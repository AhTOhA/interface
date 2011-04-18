-- This addon makes standard UI frames movable

local hints = { };
local specialFrames = { };
local profile = { };

-- We will NOT touch these frames.
-- Important note: special frames CANNOT be excluded!
local excludedFrames = {
	["ItemRefTooltip"] = true,
	["WorldMapFrame"] = true
};

-- Logging function
local function info(msg)
	--DEFAULT_CHAT_FRAME:AddMessage("[|cFFFF00D0VMF|r] " .. (msg or "?"), 1, 1, 1);
end

-- Add size and location data for title bar adjustments
local function hint(name, dx, dy, dw, dh)
	hints[name] = {
		["dx"] = dx,
		["dy"] = dy,
		["dw"] = dw,
		["dh"] = dh
	};
end

-- Create (or return, if it already exists) a basic drag handle frame
local function createHandle(parentName)
	local name = parentName .. "DragHandle";
	local existing = _G[name];
	if(existing ~= nil) then
		info("createHandle(" .. existing:GetName() .. "): " 
			.. (existing:GetLeft() and format("%4.2f", existing:GetLeft()) or "?") 
			.. "," 
			.. (existing:GetTop() and format("%4.2f", existing:GetTop()) or "?"));
		return existing;
	end
	
	info("Creating a drag handle for '" .. parentName .. "'");
	local handle = CreateFrame("Frame", name);		-- We'll set its parent later
	handle:EnableMouse(true);
	handle:SetMovable(true);
	handle:SetUserPlaced(true);
	
	local tex = handle:CreateTexture(handle:GetName() .. "Texture", "ARTWORK");
	tex:SetAllPoints();
	tex:SetTexture(1, 1, 1, 0.35);
	tex:Hide();

	info("createHandle(" .. handle:GetName() .. "): " .. (handle:GetLeft() or "?") .. "," .. (handle:GetTop() or "?"));
	return handle;
end

-- Set the size of the frame's handle
local function setHandleSize(handle, w0, h0)
	local f = handle:GetParent();

	local hint = hints[f:GetName()];
	local dx, dy, dw, dh = 0, 0, 0, 0;
	if(hint ~= nil) then
		dx, dy, dw, dh = hint.dx, hint.dy, hint.dw, hint.dh;
	end
	
	-- If we have the new size specified, use that. If not, use the frame size.
	local w, h = w0, h0;
	if(w == nil) or (h == nil) then
		w, h = f:GetWidth(), f:GetHeight();
	end	
	
	local closeButton = _G[f:GetName() .. "CloseButton"];
	if(closeButton == nil) then
		handle:SetWidth(w + dw);
	else
		handle:SetWidth(w + dw - closeButton:GetWidth());
	end
	
	handle:SetHeight(24+dh);

	info("setHandleSize(): frame=" .. w .. "x" .. h .. "; handle=" .. handle:GetWidth() .. "x" .. handle:GetHeight()
		.. "; closeButton=" .. (closeButton and closeButton:GetWidth() or "n/a"));

	--f:ClearAllPoints();
	info("Setting " .. f:GetName() .. " handle size to (" .. format("%4.2f", handle:GetWidth()) .. "," .. format("%4.2f", handle:GetHeight()) .. ")");
	
	return -dx, -dy;
end

-- Save the position of the handle
local function savePosition(handle, x, y)
	-- If 'x' and 'y' are not specified, use the frame's current coordinates
	if(x == nil) and (y == nil) then
		x = handle:GetLeft();
		y = handle:GetTop();
	end
	
	local n = handle:GetParent():GetName();
	local pos = profile.frames[n];
	if(pos == null) then
		pos = { };
		profile.frames[n] = pos;
	end
	
	pos.x = x;
	pos.y = y;
end

-- The user started dragging the frame
local function VeryMobileFrames_OnMouseDown(f, arg1, arg2)
	--info("OnMouseDown(" .. f:GetName() .. ", " .. (arg1 or "?") .. "): locked=" .. (f.isLocked or "no"));
	if (((not f.isLocked) or (f.isLocked == 0)) and (arg1 == "LeftButton")) then
		f:SetUserPlaced(true);
		f:StartMoving();
		f.isMoving = true;
		f.isReset = false;
		savePosition(f);
	end
end

-- The user stopped dragging the frame: stop moving, remember its position for later
local function VeryMobileFrames_OnMouseUp(f, arg1)
	--info("OnMouseUp(" .. f:GetName() .. ", " .. (arg1 or "?") .. ")");
	if(f.isMoving) then
		f:StopMovingOrSizing();
		f.isMoving = false;
		savePosition(f);
	end
end

-- The frame is being hidden: stop moving, remember its position for later
local function VeryMobileFrames_OnHide(f)
	--info("OnHide(" .. f:GetName() .. ", " .. (arg1 or "?") .. ")");
	if(f.isMoving) then
		f:StopMovingOrSizing();
		f.isMoving = false;
		savePosition(f);
	end
end

-- Replace SetPoint with our own functionality
function VeryMobileFrames_Frame_SetPoint(f, point, relativeTo, relativePoint, xOffset, yOffset)
	if(not f["_vmf_resetPosition"]) then
		return
	end

	local n;
	if(relativeTo == nil) then
		n = "?";
	elseif(type(relativeTo) == "table") then
		n = "{" .. relativeTo:GetName() .. "}";
	else
		n = relativeTo;
	end
	
	info((f:GetName() or "?") .. ":|cFFFF0000SetPoint|r(" 
		.. (point or "?") .. ", " 
		.. n .. ", "
		.. (relativePoint or "?") .. ", "
		.. (xOffset or "?") .. ", "
		.. (yOffset or "?") .. ")");

	-- Make sure we don't get a stack overflow here
	f["_vmf_resetPosition"] = false;		
	f:ClearAllPoints();
	
	-- Reattach the frame to its handle
	local hint = hints[f:GetName()];
	local dx, dy = 0, 0;
	if(hint ~= nil) then
		dx, dy = hint.dx, hint.dy;
	end
	f:SetPoint("TOPLEFT", f["_vmf_handle"], "TOPLEFT", -dx, -dy);
	
	-- We want to do the same on subsequent calls to SetPoint()
	f["_vmf_resetPosition"] = true;
end

-- Print the frame parent-child hierarchy starting from the mouse focus
function VeryMobileFrames_PrintHierarchy(msg)
	local list = "";
	local f = GetMouseFocus();
	
	while((f ~= nil) and (f:GetName() ~= "UIParent")) do
		list = list .. " " .. (f:GetName() or "?");
		f = f:GetParent();
	end
	
	info(list);	
end

-- Update the size of the handle if the size of its parent changes
function VeryMobileFrames_Frame_OnSizeChanged(f, width, height)
	info("OnSizeChanged: |cFFFF0000" .. f:GetName() .. "|r: " .. width .. "," .. height);
	setHandleSize(f["_vmf_handle"], width, height);
end

-- Make the parent frame of the given handle movable
local function makeMovable(handle)
	local f = handle:GetParent();

	if(f["_vmf_processed"] ~= nil) then
		return;
	end
	
	info("|cFF0080FFmakeMovable|r(" .. handle:GetName() .. ")");
	local dx, dy = setHandleSize(handle);
	local x, y;

	local name = f:GetName();
	local pos = profile.frames[name];
	--if(handle:GetLeft() == nil) or (handle:GetTop() == nil) then		
	if(pos == nil) then
		x = f:GetLeft();
		y = f:GetTop();
		info("  * Borrowing frame coordinates: " .. (x or "?") .. "," .. (y or "?"));
	else
		x = pos.x;
		y = pos.y;
		info("  * Restoring frame coordinates: " .. (x or "?") .. "," .. (y or "?"));
	end
	
	-- Do not let this frame get clipped by the screen
	local left = x + dx;
	local top = y + dy;
	local right = left + f:GetWidth();
	local bottom = top - f:GetHeight();
	local centerX = (left + right) / 2;
	local centerY = (top + bottom) / 2;
	
	-- right > left
	if(centerX > UIParent:GetRight()) then
		left = UIParent:GetRight() - f:GetWidth();
	elseif(centerX < UIParent:GetLeft()) then
		left = UIParent:GetLeft();
	end
	
	-- top > bottom
	if(top > UIParent:GetTop()) then
		top = UIParent:GetTop();
	elseif(centerY < UIParent:GetBottom()) then
		top = UIParent:GetBottom() + f:GetHeight();
	end
	
	x = left - dx;
	y = top - dy;

	savePosition(handle, x, y);
	handle:ClearAllPoints();
	handle:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y);
	
	info("  * Attaching " .. f:GetName() .. " to " .. handle:GetName() .. " at " .. dx .. "," .. dy);
	f:ClearAllPoints();
	f:SetPoint("TOPLEFT", handle, "TOPLEFT", dx, dy);
	handle:SetScript("OnMouseUp", VeryMobileFrames_OnMouseUp);
	handle:SetScript("OnMouseDown", VeryMobileFrames_OnMouseDown);
	handle:SetScript("OnHide", VeryMobileFrames_OnHide);
	
	f["_vmf_resetPosition"] = true;
	hooksecurefunc(f, "SetPoint", VeryMobileFrames_Frame_SetPoint);
	f:HookScript("OnSizeChanged", VeryMobileFrames_Frame_OnSizeChanged);
	
	handle:Show();
	
	f["_vmf_processed"] = true;
end

-- Set the parent of the handle
local function setParent(handle, f)
	handle:SetParent(f);
	f["_vmf_handle"] = handle;
	handle:SetFrameStrata(f:GetFrameStrata());
	handle:SetFrameLevel(f:GetFrameLevel()+5);
end

-- Schedule a delayed instrumentation of this frame
function onShowUIPanel(f)
	local name = f:GetName();

	-- If this frame has been excluded, don't make any changes to them!
	if(excludedFrames[name]) and (not specialFrames[name]) then
		return;
	end
	
	if(f["_vmf_processed"] ~= nil) then
		return;
	end
	
	local handle = createHandle(name);
	setParent(handle, f);

	info("ShowUIPanel(): " 
		.. (f:GetLeft() and format("%4.2f", f:GetLeft()) or "?") 
		.. "," 
		.. (f:GetTop() and format("%4.2f", f:GetTop()) or "?"));
	makeMovable(handle);		
end

-- Since ShowUIPanel() is not called for a number of special frames (bags, quest watch),
-- we'll hook Show() instead
function VeryMobileFrames_Frame_Show(f)
	if(f["_vmf_showDisabled"]) then
		return;
	end
	
	info(f:GetName() .. ":Show()");
	ShowUIPanel(f);

	f["_vmf_showDisabled"] = true;
end

-- OnLoad handler
function VeryMobileFrames_OnLoad()

	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF00D0Very Mobile Frames|r: I like to move it move it...", 1, 1, 1);

	VeryMobileFramesFrame:RegisterEvent("ADDON_LOADED");
	VeryMobileFramesFrame:RegisterEvent("PLAYER_LOGIN");

	SLASH_VMF1 = "/vmf";
	SlashCmdList["VMF"] = function(msg)
		DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000Very Mobile Frames|r: resetting frame location data");
		VeryMobileFrames = nil;
	end
	
	-- Set up drag handle position hints
	for i=1,13 do
		hint("ContainerFrame" .. i, 40, -4, -35, 0);
	end
	
	hint("CharacterFrame", 0, 0, 8, 0);
	hint("GuildFrame", 0, 0, 8, 0);
	hint("TradeSkillFrame", 0, 0, 8, 0);
	hint("FriendsFrame", 14, -14, -40, 0);
	hint("QuestLogFrame", 12, -14, -6, 0);
	hint("GameMenuFrame", 0, 8, 0, 8);
	hint("VideoOptionsFrame", 3, 6, -6, 6);
	hint("AudioOptionsFrame", 3, 6, -6, 6);
	hint("InterfaceOptionsFrame", 3, 6, -6, 6);
	hint("KeyBindingFrame", 6, 6, -50, 0);
	hint("MacroFrame", 12, -14, -38, 0);
	hint("CalendarFrame", 0, 0, -23, 20);
	hint("WatchFrame", 0, 0, -28, 0);
	hint("TradeFrame", 14, -14, -34, 0);
	hint("MerchantFrame", 14, -14, -40, 0);
	hint("AuctionFrame", 12, -12, -5, 0);
	hint("BankFrame", 12, -12, -61, 0);
	hint("ClassTrainerFrame", 0, 0, 8, 0);
	hint("GossipFrame", 14, -20, -36, 0);
	hint("QuestFrame", 14, -20, -36, 0);
	hint("TaxiFrame", 0, 0, 8, 0);
	hint("PlayerTalentFrame", 0, 0, 8, 0);
	hint("SpellBookFrame", 0, 0, 8, 0);
	hint("QuestLogDetailFrame", 14, -16, -6, 0);
	hint("ItemSocketingFrame", 14, -14, -40, 0);
	hint("MailFrame", 14, -14, -70, 0);
	hint("InspectFrame", 0, 0, 8, 0);
	hint("ReforgingFrame", 0, 0, 8, 0);
	hint("WorldMapFrame", 14, -14, -50, 0);
	hint("CastingBarFrame", -4, 8, 8, 0);
	hint("DurabilityFrame", -8, -8, 16, 57);
	
	-- Register all frames whose position will be controlled by Blizzard code
	-- (persistence only, we'll still make them movable)
	for i=1,13 do
		specialFrames["ContainerFrame" .. i] = true;
	end
	specialFrames["WatchFrame"] = true;
	specialFrames["CastingBarFrame"] = true;
	specialFrames["DurabilityFrame"] = true;
end

-- Initialize stuff when the addon is completely loaded
function VeryMobileFrames_OnEvent(event, arg)
	if(event == "ADDON_LOADED") and (arg == "VeryMobileFrames") then
		VeryMobileFramesFrame:UnregisterEvent("ADDON_LOADED");
		
		-- Initialize saved variables
		if(VMFProfile == nil) then
			VMFProfile = UnitName("player") .. " - " .. GetRealmName();
		end
		
		if(VMFSettings == nil) then
			VMFSettings = { };			
		end
		
		profile = VMFSettings[VMFProfile];
		if(profile == nil) then
			profile = { };
			VMFSettings[VMFProfile] = profile;
		end
		
		if(profile.frames == nil) then
			profile.frames = { };
		end
		
		-- This one hooks almost everything we need
		hooksecurefunc("ShowUIPanel", function(f)
			onShowUIPanel(f);
		end);
		
		-- This one hooks whatever couldn't be hooked by the call above
		for name,_ in pairs(specialFrames) do		
			hooksecurefunc(_G[name], "Show", function(f)
				VeryMobileFrames_Frame_Show(f);
			end);
		end
		
		-- All frames whose position is persisted by the Blizzard code itself
		-- are created before this point, so we can instrument them right here
		--for name, _ in pairs(blizzardControlled) do
		--	info("makeMovable(" .. name .. ") on startup");
		--	makeMovable(_G[name]);
		--end
		return;
	end
	
	if(event == "PLAYER_LOGIN") then
		VeryMobileFramesFrame:UnregisterEvent("PLAYER_LOGIN");
		info("PLAYER_LOGIN");
		
		-- Create drag handles for all frames that have been instrumented in the past
		for name,addonControlled in pairs(profile.frames) do
			createHandle(name);
		end
		
		-- The quest watch frame is special in that it gets created ahead of time
		-- and is always visible
		do
			local name = "WatchFrame";
			local handle = createHandle(name);
			setParent(handle, WatchFrame);
			makeMovable(handle);
		end
	end
end