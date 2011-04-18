--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: RaidMenu.lua
	Description: Replaces PallyPower button with a Raid Flare menu
	Version....: 2.3
	Rev Date...: 11/21/2010 [mm/dd/yyyy]
	Author.....: Zista [Thrall] <NightShift>
	
	Notes:
		Replaces PallyPower button with a Raid Menu.  Paladins will be able to show/hide PallyPower by right clicking the button.
]]

-- Local includes/definitions
local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local LSM = LibStub("LibSharedMedia-3.0")
local module = LUI:NewModule("RaidMenu", "AceHook-3.0")
local Themes = LUI:GetModule("Themes")
local db
local version = "2.3"
local author = "Zista <NightShift> of Thrall"

local Y_normal, Y_compact = 107, 101
local OverlapPreventionMethods = {"Auto-Hide", "Offset"}

-- Create function to refresh Colors and hook it to the Themes:Refresh_Micromenu function
function module:Refresh_RaidMenu()
	RaidMenu_Parent:SetBackdropColor(unpack(db.Colors.micromenu_bg2))
	RaidMenu:SetBackdropColor(unpack(db.Colors.micromenu_bg))
	local micro_r, micro_g, micro_b = unpack(db.Colors.micromenu)
	RaidMenu_Border:SetBackdropColor(micro_r, micro_g, micro_b, 1)
	RaidMenu_Header:SetFont(LSM:Fetch("font", db.Info.Clock.Font), LUI:Scale(20), "THICKOUTLINE")
	RaidMenu_Header:SetTextColor(db.Info.Clock.Color.r, db.Info.Clock.Color.g, db.Info.Clock.Color.b, db.Info.Clock.Color.a)
end

function Themes:Refresh_Micromenu()
	if LUI:GetModule("Micromenu", true) then
		local Micromenu = LUI:GetModule("Micromenu")
		Micromenu:SetColors()
	end
	module:Refresh_RaidMenu()
end

-- Place Raid Target Icon on target
local MarkTarget = function(iconId)
	if db.RaidMenu.ToggleRaidIcon then
		SetRaidTargetIcon("target", iconId)
	elseif (GetRaidTargetIndex("target") ~= iconId) then
		SetRaidTarget("target", iconId)
	end
end

-- Create function for adjusting frame posisition
local OverlapPrevention = function(frame,action)
	
	local Y_Position = Y_normal
	if db.RaidMenu.Compact then
		Y_Position = Y_compact+(db.RaidMenu.Spacing/2)
	end
	
	local offset = 0
	if db.RaidMenu.OverlapPrevention == "Offset" and db.Frames.IsMicroMenuShown then
		offset = db.RaidMenu.Offset
	end
	
	if frame == "RM" then
		if action == "toggle" then
			if RaidMenu_Parent:IsShown() then
				RMAlphaOut:Show()
			else
				if db.RaidMenu.OverlapPrevention == "Auto-Hide" and db.Frames.IsMicroMenuShown then
					MicroMenu_Clicker:Click()
				end
				RaidMenu_Parent:SetPoint("TOPRIGHT",MicroMenu_ButtonLeft,"BOTTOMRIGHT",0,(((Y_Position+offset)/db.RaidMenu.Scale)+17))
				RMAlphaIn:Show()
			end
		elseif action == "slide" then
			if db.Frames.IsMicroMenuShown then
				RMSlideUp:Show()
			else
				RMSlideDown:Show()
			end
		elseif action == "position" then
			RaidMenu_Parent:Show()
			RaidMenu_Parent:SetAlpha(db.RaidMenu.Opacity/100)
			if db.Frames.IsMicroMenuShown then
				if db.RaidMenu.OverlapPrevention == "Auto-Hide" then
					MMAlphaOut:Show()
					db.Frames.IsMicroMenuShown = false
					MicroMenuAnchor:SetBackdrop({bgFile = fdir.."micro_anchor",
						  edgeFile='Interface\\Tooltips\\UI-Tooltip-Border',
						  tile=false, tileSize = 0, edgeSize = 1,
						  insets = { left = 0, right = 0, top = 0, bottom = 0}});
					MicroMenuAnchor:SetBackdropColor(unpack(db.Colors.micromenu_btn_hover))
					MicroMenuAnchor:SetBackdropBorderColor(0,0,0,0)	
				end
			else
				if db.RaidMenu.OverlapPrevention == "Offset" then
					MMAlphaIn:Show()
					db.Frames.IsMicroMenuShown = true
					MicroMenuAnchor:SetBackdrop({bgFile = fdir.."micro_anchor3",
						  edgeFile='Interface\\Tooltips\\UI-Tooltip-Border',
						  tile=false, tileSize = 0, edgeSize = 1,
						  insets = { left = 0, right = 0, top = 0, bottom = 0}});
					MicroMenuAnchor:SetBackdropColor(unpack(db.Colors.micromenu_btn_hover))
					MicroMenuAnchor:SetBackdropBorderColor(0,0,0,0)
					offset = db.RaidMenu.Offset
				end
			end
			RaidMenu_Parent:SetPoint("TOPRIGHT",MicroMenu_ButtonLeft,"BOTTOMRIGHT",0,(((Y_Position+offset)/db.RaidMenu.Scale)+17))
		end
	elseif frame == "MM" then
		if db.Frames.IsMicroMenuShown then
			if db.RaidMenu.OverlapPrevention == "Offset" then
				RMSlideUp:Show()
			end
			MMAlphaOut:Show()
			db.Frames.IsMicroMenuShown = false
			MicroMenuAnchor:SetBackdrop({bgFile = fdir.."micro_anchor",
				  edgeFile='Interface\\Tooltips\\UI-Tooltip-Border',
				  tile=false, tileSize = 0, edgeSize = 1,
				  insets = { left = 0, right = 0, top = 0, bottom = 0}});
			MicroMenuAnchor:SetBackdropColor(unpack(db.Colors.micromenu_btn_hover))
			MicroMenuAnchor:SetBackdropBorderColor(0,0,0,0)	
		else
			if db.RaidMenu.OverlapPrevention == "Auto-Hide" then
				if RaidMenu_Parent:IsShown() then
					MicroMenu_ButtonLeft_Clicker:Click()
				end
			else
				RMSlideDown:Show()
			end
			MMAlphaIn:Show()
			db.Frames.IsMicroMenuShown = true
			MicroMenuAnchor:SetBackdrop({bgFile = fdir.."micro_anchor3",
				  edgeFile='Interface\\Tooltips\\UI-Tooltip-Border',
				  tile=false, tileSize = 0, edgeSize = 1,
				  insets = { left = 0, right = 0, top = 0, bottom = 0}});
			MicroMenuAnchor:SetBackdropColor(unpack(db.Colors.micromenu_btn_hover))
			MicroMenuAnchor:SetBackdropBorderColor(0,0,0,0)
		end
	end
end

-- Create function for formating buttons
local FormatMarker = function(frame,x,y,r,g,b,id,t1,t2,t3,t4)
	if frame == nil then return end
	local width, height
	if db.RaidMenu.Compact then
		width, height = 24, 24
	else
		width, height = 32, 32
	end
	frame:SetWidth(width)
	frame:SetHeight(height)
	frame:SetScale(1)
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(4)
	frame:SetPoint("TOPLEFT",RaidMenu_Parent,"TOPLEFT",x,y)
	frame:SetAlpha(0.6)
	frame:RegisterForClicks("AnyUp")
	
	if string.find(frame:GetName(), "WorldMarker") ~= nil then
		frame:SetAttribute("type", "macro")
		frame:SetAttribute("macrotext", [[/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
/click DropDownList1Button]]..tostring(id)..[[

/run if LUI.db.profile.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end]])
		
		local texture = _G[frame:GetName().."MarkerTex"]
		if texture == nil then
			texture = frame:CreateTexture(frame:GetName().."MarkerTex")
		end
		texture:SetPoint("TOPLEFT", frame,"TOPLEFT",0,0)
		texture:SetWidth(width)
		texture:SetHeight(height)
		texture:SetTexture("Interface\\Buttons\\UI-Quickslot")
		texture:SetTexCoord(0.15,0.85,0.15,0.85)
		if (frame:GetName() == "ClearWorldMarkers") then
			texture:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
			texture:SetTexCoord(0,1,0,1)
		else			
			local textureColor = _G[frame:GetName().."TextureColor"]
			if textureColor == nil then
				textureColor = frame:CreateTexture(frame:GetName().."TextureColor")
			end
			textureColor:SetPoint("TOPLEFT", frame,"TOPLEFT", 4, -4)
			textureColor:SetPoint("BOTTOMRIGHT", frame,"BOTTOMRIGHT", -4, 4)
			textureColor:SetTexture(r,g,b)
		end
		
	elseif string.find(frame:GetName(), "RaidIcon") ~= nil then
		frame:SetID(id)
		frame:SetScript("OnClick", function(self)
			if db.RaidMenu.AutoHide then
				MicroMenu_ButtonLeft_Clicker:Click()
			end
			MarkTarget(frame:GetID());
		end)
		
		local texture = _G[frame:GetName().."MarkerTex"]
		if texture == nil then
			texture = frame:CreateTexture(frame:GetName().."MarkerTex")
		end
		texture:SetPoint("TOPLEFT", frame,"TOPLEFT",2,-2)
		texture:SetWidth(width-4)
		texture:SetHeight(height-4)
		if (frame:GetName() == "ClearRaidIcon") then
			texture:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
		else
			texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
		end
		texture:SetTexCoord(t1,t2,t3,t4)
		
	else
		if db.RaidMenu.Compact then
			width = 100+(db.RaidMenu.Spacing*3)
		else
			width = 120, 20
		end
		frame:SetWidth(width)
		frame:SetHeight(LUI:Scale(20))
		frame:SetAlpha(1)
	end
end

-- Create function for frame sizing
local SizeRaidMenu = function(compact)
	if compact == nil then compact = db.RaidMenu.Compact end
	if compact then
		local x_spacing = db.RaidMenu.Spacing
		local y_spacing = -1*(db.RaidMenu.Spacing)
		RaidMenu_Parent:SetWidth(190+db.RaidMenu.Spacing*6)
		RaidMenu_Parent:SetHeight(185+db.RaidMenu.Spacing*6)
		RaidMenu_BG:SetWidth(190+db.RaidMenu.Spacing*6)
		RaidMenu_BG:SetHeight(185+db.RaidMenu.Spacing*6)
		RaidMenu:SetWidth(190+db.RaidMenu.Spacing*6)
		RaidMenu:SetHeight(185+db.RaidMenu.Spacing*6)
		RaidMenu_Border:SetWidth(190+db.RaidMenu.Spacing*6)
		RaidMenu_Border:SetHeight(185+db.RaidMenu.Spacing*6)
		RaidMenu_Header:Hide()
		FormatMarker(SkullRaidIcon, 15, -50+y_spacing, 0, 0, 0, 8, 0.75,1,0.25,0.5)
		FormatMarker(CrossRaidIcon, 15, -75+y_spacing*2, 0, 0, 0, 7, 0.5,0.75,0.25,0.5)
		FormatMarker(SquareRaidIcon, 15, -100+y_spacing*3, 0, 0, 0, 6, 0.25,0.5,0.25,0.5)
		FormatMarker(MoonRaidIcon, 15, -125+y_spacing*4, 0, 0, 0, 5, 0,0.25,0.25,0.5)
		FormatMarker(TriangleRaidIcon, 40+x_spacing, -50+y_spacing, 0, 0, 0, 4, 0.75,1,0,0.25)
		FormatMarker(DiamondRaidIcon, 40+x_spacing, -75+y_spacing*2, 0, 0, 0, 3, 0.5,0.75,0,0.25)
		FormatMarker(CircleRaidIcon, 40+x_spacing, -100+y_spacing*3, 0, 0, 0, 2, 0.25,0.5,0,0.25)
		FormatMarker(StarRaidIcon, 40+x_spacing, -125+y_spacing*4, 0, 0, 0, 1, 0,0.25,0,0.25)
		FormatMarker(ClearRaidIcon, 32.5+x_spacing*0.5, -150+y_spacing*5, 0, 0, 0, 0, 0, 1, 0, 1)
		FormatMarker(BlueWorldMarker, 15, -25, 0, 0.5, 1, 1)
		FormatMarker(GreenWorldMarker, 40+x_spacing, -25, 0, 1, 0.2, 2)
		FormatMarker(PurpleWorldMarker, 65+x_spacing*2, -25, 0.5, 0, 1, 3)
		FormatMarker(RedWorldMarker, 90+x_spacing*3, -25, 1, 0, 0, 4)
		FormatMarker(YellowWorldMarker, 115+x_spacing*4, -25, 1, 1, 0, 5)
		FormatMarker(ClearWorldMarkers, 140+x_spacing*5, -25, 0, 0, 0, 6)
		FormatMarker(ConvertRaid, 65+x_spacing*2, -50+y_spacing)
		FormatMarker(LootMethod, 65+x_spacing*2, -75+y_spacing*2)
		FormatMarker(LootThreshold, 65+x_spacing*2, -100+y_spacing*3)
		FormatMarker(RoleChecker, 65+x_spacing*2, -125+y_spacing*4)
		FormatMarker(RoleCheckerButton, 65+x_spacing*2, -125+y_spacing*4)
		FormatMarker(ReadyChecker, 65+x_spacing*2, -150+y_spacing*5)
	else
		RaidMenu_Parent:SetWidth(256)
		RaidMenu_Parent:SetHeight(256)
		RaidMenu_BG:SetWidth(256)
		RaidMenu_BG:SetHeight(256)
		RaidMenu:SetWidth(256)
		RaidMenu:SetHeight(256)
		RaidMenu_Border:SetWidth(256)
		RaidMenu_Border:SetHeight(256)
		RaidMenu_Header:Show()
		FormatMarker(SkullRaidIcon, 20, -50, 0, 0, 0, 8, 0.75,1,0.25,0.5)
		FormatMarker(CrossRaidIcon, 20, -90, 0, 0, 0, 7, 0.5,0.75,0.25,0.5)
		FormatMarker(SquareRaidIcon, 20, -130, 0, 0, 0, 6, 0.25,0.5,0.25,0.5)
		FormatMarker(MoonRaidIcon, 20, -170, 0, 0, 0, 5, 0,0.25,0.25,0.5)
		FormatMarker(TriangleRaidIcon, 60, -50, 0, 0, 0, 4, 0.75,1,0,0.25)
		FormatMarker(DiamondRaidIcon, 60, -90, 0, 0, 0, 3, 0.5,0.75,0,0.25)
		FormatMarker(CircleRaidIcon, 60, -130, 0, 0, 0, 2, 0.25,0.5,0,0.25)
		FormatMarker(StarRaidIcon, 60, -170, 0, 0, 0, 1, 0,0.25,0,0.25)
		FormatMarker(ClearRaidIcon, 40, -210, 0, 0, 0, 0, 0, 1, 0, 1)
		FormatMarker(BlueWorldMarker, 110, -175, 0, 0.5, 1, 1)
		FormatMarker(GreenWorldMarker, 145, -175, 0, 1, 0.2, 2)
		FormatMarker(PurpleWorldMarker, 180, -175, 0.5, 0, 1, 3)
		FormatMarker(RedWorldMarker, 110, -210, 1, 0, 0, 4)
		FormatMarker(YellowWorldMarker, 145, -210, 1, 1, 0, 5)
		FormatMarker(ClearWorldMarkers, 180, -210, 0, 0, 0, 6)
		FormatMarker(ConvertRaid, 105, -50)
		FormatMarker(LootMethod, 105, -75)
		FormatMarker(LootThreshold, 105, -100)
		FormatMarker(RoleChecker, 105, -125)
		FormatMarker(RoleCheckerButton, 105, -125)
		FormatMarker(ReadyChecker, 105, -150)
	end
end

-- Create module function
function module:SetRaidMenu()
	if (db.RaidMenu.Enable ~= true) or not(LUI:GetModule("Micromenu", true)) then return end
	
	local playerClass, englishClass = UnitClass("player")
	
	-- Create frames for Raid Menu
	local RaidMenu_Parent = LUI:CreateMeAFrame("FRAME","RaidMenu_Parent",MicroMenu_ButtonLeft,256,256,1,"HIGH",0,"TOPRIGHT",MicroMenu_ButtonLeft,"BOTTOMRIGHT",0,((107/db.RaidMenu.Scale)+17),1)
	RaidMenu_Parent:SetFrameStrata("HIGH")
	if db.Frames.IsMicroMenuShown and (db.RaidMenu.OverlapPrevention == "Offset") then
		RaidMenu_Parent:SetPoint("TOPRIGHT",MicroMenu_ButtonLeft,"BOTTOMRIGHT",0,(((107+db.RaidMenu.Offset)/db.RaidMenu.Scale)+17))
	else
		RaidMenu_Parent:SetPoint("TOPRIGHT",MicroMenu_ButtonLeft,"BOTTOMRIGHT",0,((107/db.RaidMenu.Scale)+17))
	end
	RaidMenu_Parent:SetScale(db.RaidMenu.Scale)
	RaidMenu_Parent:Hide()
	
	local RaidMenu_BG = LUI:CreateMeAFrame("FRAME","RaidMenu_BG",RaidMenu_Parent,256,256,1,"HIGH",1,"TOPRIGHT",RaidMenu_Parent,"TOPRIGHT",0,0,1)
	RaidMenu_BG:SetBackdrop({bgFile = 'Interface\\AddOns\\LUI\\modules\\RaidMenu\\RaidMenu_BG',
				  edgeFile='Interface\\Tooltips\\UI-Tooltip-Border',
				  tile=false, tileSize = 0, edgeSize = 1,
				  insets = { left = 0, right = 0, top = 0, bottom = 0}})
	RaidMenu_BG:SetBackdropColor(unpack(db.Colors.micromenu_bg2))
	RaidMenu_BG:SetBackdropBorderColor(0,0,0,0)
	RaidMenu_BG:SetAlpha(1)
	RaidMenu_BG:Show()
	
	local RaidMenu = LUI:CreateMeAFrame("FRAME","RaidMenu",RaidMenu_Parent,256,256,1,"HIGH",2,"TOPRIGHT",RaidMenu_Parent,"TOPRIGHT",0,0,1)
	RaidMenu:SetBackdrop({bgFile = 'Interface\\AddOns\\LUI\\modules\\RaidMenu\\RaidMenu',
				  edgeFile='Interface\\Tooltips\\UI-Tooltip-Border',
				  tile=false, tileSize = 0, edgeSize = 1,
				  insets = { left = 0, right = 0, top = 0, bottom = 0}})
	RaidMenu:SetBackdropColor(unpack(db.Colors.micromenu_bg))
	RaidMenu:SetBackdropBorderColor(0,0,0,0)
	RaidMenu:SetAlpha(1)
	RaidMenu:Show()
	
	local RaidMenu_Border = LUI:CreateMeAFrame("FRAME","RaidMenu_Border",RaidMenu_Parent,256,256,1,"HIGH",3,"TOPRIGHT",RaidMenu_Parent,"TOPRIGHT",2,1,1)
	RaidMenu_Border:SetBackdrop({bgFile = "Interface\\AddOns\\LUI\\modules\\RaidMenu\\RaidMenu_Border",
				  edgeFile='Interface\\Tooltips\\UI-Tooltip-Border',
				  tile=false, tileSize = 0, edgeSize = 1,
				  insets = { left = 0, right = 0, top = 0, bottom = 0}})
	RaidMenu_Border:SetBackdropColor(db.Colors.micromenu[1], db.Colors.micromenu[2], db.Colors.micromenu[3], 1)
	RaidMenu_Border:SetBackdropBorderColor(0,0,0,0)
	RaidMenu_Border:SetAlpha(1)
	RaidMenu_Border:Show()
	
	local RaidMenu_Header = RaidMenu:CreateFontString("RaidMenu_Header", "OVERLAY")
	RaidMenu_Header:SetFont(LSM:Fetch("font", db.Info.Clock.Font), LUI:Scale(20), "THICKOUTLINE")
	RaidMenu_Header:SetPoint("TOP", RaidMenu, "TOP", -5, -25)
	RaidMenu_Header:SetTextColor(db.Info.Clock.Color.r, db.Info.Clock.Color.g, db.Info.Clock.Color.b, db.Info.Clock.Color.a)
	RaidMenu_Header:SetText("LUI Raid Menu")
	
	-- Create frame for dropdown lists to access
	local LootMenuFrame = CreateFrame("Frame", "LootDropDownMenu", RaidMenu_Parent, "UIDropDownMenuTemplate")
	
	-- Create buttons for Raid Menu	
	local SkullRaidIcon = CreateFrame("BUTTON","SkullRaidIcon",RaidMenu,"MarkerTemplate")
	local CrossRaidIcon = CreateFrame("BUTTON","CrossRaidIcon",RaidMenu,"MarkerTemplate")
	local SquareRaidIcon = CreateFrame("BUTTON","SquareRaidIcon",RaidMenu,"MarkerTemplate")
	local MoonRaidIcon = CreateFrame("BUTTON","MoonRaidIcon",RaidMenu,"MarkerTemplate")
	local TriangleRaidIcon = CreateFrame("BUTTON","TriangleRaidIcon",RaidMenu,"MarkerTemplate")
	local DiamondRaidIcon = CreateFrame("BUTTON","DiamondRaidIcon",RaidMenu,"MarkerTemplate")
	local CircleRaidIcon = CreateFrame("BUTTON","CircleRaidIcon",RaidMenu,"MarkerTemplate")
	local StarRaidIcon = CreateFrame("BUTTON","StarRaidIcon",RaidMenu,"MarkerTemplate")
	local ClearRaidIcon = CreateFrame("BUTTON","ClearRaidIcon",RaidMenu,"MarkerTemplate")

	local BlueWorldMarker = CreateFrame("BUTTON","BlueWorldMarker",RaidMenu,"SecureMarkerTemplate")	
	local GreenWorldMarker = CreateFrame("BUTTON","GreenWorldMarker",RaidMenu,"SecureMarkerTemplate")
	local PurpleWorldMarker = CreateFrame("BUTTON","PurpleWorldMarker",RaidMenu,"SecureMarkerTemplate")
	local RedWorldMarker = CreateFrame("BUTTON","RedWorldMarker",RaidMenu,"SecureMarkerTemplate")
	local YelloWorldMarker = CreateFrame("BUTTON","YellowWorldMarker",RaidMenu,"SecureMarkerTemplate")
	local ClearWorldMarkers = CreateFrame("BUTTON","ClearWorldMarkers",RaidMenu,"SecureMarkerTemplate")
	
	local ConvertRaid = CreateFrame("BUTTON","ConvertRaid",RaidMenu,"OptionsButtonTemplate")
	if GetNumRaidMembers() > 0 then
		ConvertRaid:SetText("Convert to Party")
	else
		ConvertRaid:SetText("Convert to Raid")
	end
	local monitoredEvents = {"PARTY_CONVERTED_TO_RAID", "RAID_ROSTER_UPDATE", "PARTY_LEADER_CHANGED", "PARTY_MEMBERS_CHANGED"}
	for i = 1, #monitoredEvents do
		ConvertRaid:RegisterEvent(monitoredEvents[i])
	end
	ConvertRaid:SetScript("OnEvent", function(self, event)
		for i = 1, #monitoredEvents do
			if event == monitoredEvents[i] then
				if GetNumRaidMembers() > 0 then
					ConvertRaid:SetText("Convert to Party")
				else
					ConvertRaid:SetText("Convert to Raid")
				end
			end
		end
	end)
	ConvertRaid:SetScript("OnEnter", function(self)
		if db.RaidMenu.ShowToolTips then
			GameTooltip:SetOwner(ConvertRaid,"ANCHOR_BOTTOMLEFT")
			GameTooltip:SetClampedToScreen(true)
			GameTooltip:ClearLines()
			if GetNumRaidMembers() > 0 then
				GameTooltip:SetText("Convert to Party")
				GameTooltip:AddLine("Convert your Raid Group into a 5 man party",204/255,204/255,204/255,1)
				GameTooltip:AddLine("Only works with raid groups of 5 or less members!",204/255,204/255,204/255,1)
			else
				GameTooltip:SetText("Convert to Raid")
				GameTooltip:AddLine("Convert your party into a Raid Group",204/255,204/255,204/255,1)
			end
			GameTooltip:Show()
		end
	end)
	ConvertRaid:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	ConvertRaid:SetScript("OnClick", function(self)
		if GetNumRaidMembers() > 0 then
			ConvertToParty()
		else
			ConvertToRaid()
		end
		if db.RaidMenu.AutoHide then
			MicroMenu_ButtonLeft_Clicker:Click()
		end
	end)
		
	local LootMethod = CreateFrame("BUTTON","LootMethod",RaidMenu,"OptionsButtonTemplate")
	LootMethod:SetText("Loot Method")
	LootMethod:SetScript("OnEnter", function(self)
		if db.RaidMenu.ShowToolTips then
			GameTooltip:SetOwner(LootMethod,"ANCHOR_BOTTOMLEFT")
			GameTooltip:SetClampedToScreen(true)
			GameTooltip:ClearLines()
			GameTooltip:SetText("Loot Method")
			GameTooltip:AddLine("Change the Loot Method for your group",204/255,204/255,204/255,1)
			GameTooltip:Show()
		end
	end)
	LootMethod:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	LootMethod:SetScript("OnClick", function(self)
		local LootMethodList = {
			{text = "Group Loot",
			checked = (GetLootMethod() == "group"),
			func = function() SetLootMethod("group") if db.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end end},
			{text = "Free-For-All",
			checked = (GetLootMethod() == "freeforall"),
			func = function() SetLootMethod("freeforall") if db.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end end},
			{text = "Master Looter",
			checked = (GetLootMethod() == "master"),
			func = function() SetLootMethod("master", "player") if db.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end end},
			{text = "Need Before Greed",
			checked = (GetLootMethod() == "needbeforegreed"),
			func = function() SetLootMethod("needbeforegreed") if db.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end end},
			{text = "Round Robin",
			checked = (GetLootMethod() == "roundrobin"),
			func = function() SetLootMethod("roundrobin") if db.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end end}
		}
		EasyMenu(LootMethodList, LootMenuFrame, "cursor", 0, 0, "MENU", 1)
	end)
	
	local LootThreshold = CreateFrame("BUTTON","LootThreshold",RaidMenu,"OptionsButtonTemplate")
	LootThreshold:SetText("Loot Threshold")
	LootThreshold:SetScript("OnEnter", function(self)
		if db.RaidMenu.ShowToolTips then
			GameTooltip:SetOwner(LootThreshold,"ANCHOR_BOTTOMLEFT")
			GameTooltip:SetClampedToScreen(true)
			GameTooltip:ClearLines()
			GameTooltip:SetText("Loot Threshold")
			GameTooltip:AddLine("Change the Loot Threshold for your group",204/255,204/255,204/255,1)
			GameTooltip:Show()
		end
	end)
	LootThreshold:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	LootThreshold:SetScript("OnClick", function(self)
		local LootThresholdList = {
			{text = "|cff1EFF00Uncommon|r",
			checked = (GetLootThreshold() == 2),
			func = function() SetLootThreshold("2") if db.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end end},
			{text = "|cff0070FFRare|r",
			checked = (GetLootThreshold() == 3),
			func = function() SetLootThreshold("3") if db.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end end},
			{text = "|cffA335EEEpic|r",
			checked = (GetLootThreshold() == 4),
			func = function() SetLootThreshold("4") if db.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end end},
			{text = "|cffFF8000Legendary|r",
			checked = (GetLootThreshold() == 5),
			func = function() SetLootThreshold("5") if db.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end end}
		}
		EasyMenu(LootThresholdList, LootMenuFrame, "cursor", 0, 0, "MENU", 1)
	end)
		
	local RoleChecker = CreateFrame("BUTTON","RoleChecker",RaidMenu,"OptionsButtonTemplate")
	RoleChecker:Hide()
		
	local RoleCheckerButton = CreateFrame("BUTTON","RoleCheckerButton",RaidMenu,"SecureMarkerTemplate")
	RoleCheckerButton:SetHighlightTexture(RoleChecker:GetHighlightTexture())
	RoleCheckerButton:SetPushedTexture(RoleChecker:GetPushedTexture())
	RoleCheckerButton:SetNormalTexture(RoleChecker:GetNormalTexture())
	RoleCheckerButton:SetFontString(RoleChecker:GetFontString())
	RoleCheckerButton:SetText("Role Check")
	RoleCheckerButton:SetAttribute("type", "macro")
	RoleCheckerButton:SetAttribute("macrotext", [[/click CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll
/run if LUI.db.profile.RaidMenu.AutoHide then MicroMenu_ButtonLeft_Clicker:Click() end]])
	RoleCheckerButton:SetScript("OnEnter", function(self)
		if db.RaidMenu.ShowToolTips then
			GameTooltip:SetOwner(RoleChecker,"ANCHOR_BOTTOMLEFT")
			GameTooltip:SetClampedToScreen(true)
			GameTooltip:ClearLines()
			GameTooltip:SetText("Role Check")
			GameTooltip:AddLine("Perform a Role Check",204/255,204/255,204/255,1)
			GameTooltip:Show()
		end
	end)
	RoleCheckerButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	local ReadyChecker = CreateFrame("BUTTON","ReadyChecker",RaidMenu,"OptionsButtonTemplate")
	ReadyChecker:SetText("Ready Check")
	ReadyChecker:SetScript("OnEnter", function(self)
		if db.RaidMenu.ShowToolTips then
			GameTooltip:SetOwner(ReadyChecker,"ANCHOR_BOTTOMLEFT")
			GameTooltip:SetClampedToScreen(true)
			GameTooltip:ClearLines()
			GameTooltip:SetText("Ready Check")
			GameTooltip:AddLine("Perform a Ready Check",204/255,204/255,204/255,1)
			GameTooltip:Show()
		end
	end)
	ReadyChecker:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	ReadyChecker:SetScript("OnClick", function(self)
		DoReadyCheck()
		if db.RaidMenu.AutoHide then
			MicroMenu_ButtonLeft_Clicker:Click()
		end
	end)
	
	-- Create fader frames
	local rm_timerout, rm_timerin, rm_timerup, rm_timerdown = 0,0,0,0
	local rm_alpha_timer, rm_slide_timer = 0.5,0.5
	
	local RMAlphaOut = CreateFrame("Frame", "RMAlphaOut", UIParent)
	RMAlphaOut:Hide()
	
	RMAlphaOut:SetScript("OnUpdate", function(self,elapsed)
		rm_timerout = rm_timerout + elapsed
		if rm_timerout < rm_alpha_timer then
			local alpha = (1 - rm_timerout / rm_alpha_timer)*(db.RaidMenu.Opacity/100)
			RaidMenu_Parent:SetAlpha(alpha)
		else
			RaidMenu_Parent:SetAlpha(0)
			RaidMenu_Parent:Hide()
			rm_timerout = 0
			self:Hide()
		end
	end)
	
	local RMAlphaIn = CreateFrame("Frame", "RMAlphaIn", UIParent)
	RMAlphaIn:Hide()
	
	RMAlphaIn:SetScript("OnUpdate", function(self,elapsed)
		RaidMenu_Parent:Show()
		rm_timerin = rm_timerin + elapsed
		if rm_timerin < rm_alpha_timer then
			local alpha = (rm_timerin / rm_alpha_timer)*(db.RaidMenu.Opacity/100)
			RaidMenu_Parent:SetAlpha(alpha)
		else
			RaidMenu_Parent:SetAlpha(db.RaidMenu.Opacity/100)
			rm_timerin = 0
			self:Hide()
		end
	end)
	
	local RMSlideUp = CreateFrame("Frame", "RMSlideUp", UIParent)
	RMSlideUp:Hide()
	
	RMSlideUp:SetScript("OnUpdate", function(self,elapsed)
		local Y_Position
		if db.RaidMenu.Compact then
			Y_Position = Y_compact+(db.RaidMenu.Spacing/2)
		else
			Y_Position = Y_normal
		end
		rm_timerup = rm_timerup + elapsed
		if rm_timerup < rm_slide_timer then
			local offset = (1 - rm_timerup / rm_slide_timer)*(db.RaidMenu.Offset)
			RaidMenu_Parent:SetPoint("TOPRIGHT",MicroMenu_ButtonLeft,"BOTTOMRIGHT",0,(((Y_Position+offset)/db.RaidMenu.Scale)+17))
		else
			RaidMenu_Parent:SetPoint("TOPRIGHT",MicroMenu_ButtonLeft,"BOTTOMRIGHT",0,((Y_Position/db.RaidMenu.Scale)+17))
			rm_timerup = 0
			self:Hide()
		end
	end)
		
	local RMSlideDown = CreateFrame("Frame", "RMSlideDown", UIParent)
	RMSlideDown:Hide()
	
	RMSlideDown:SetScript("OnUpdate", function(self,elapsed)
		local Y_Position
		if db.RaidMenu.Compact then
			Y_Position = Y_compact+(db.RaidMenu.Spacing/2)
		else
			Y_Position = Y_normal
		end
		rm_timerdown = rm_timerdown + elapsed
		if rm_timerdown < rm_slide_timer then
			local offset = (rm_timerdown / rm_slide_timer)*(db.RaidMenu.Offset)
			RaidMenu_Parent:SetPoint("TOPRIGHT",MicroMenu_ButtonLeft,"BOTTOMRIGHT",0,(((Y_Position+offset)/db.RaidMenu.Scale)+17))
		else
			RaidMenu_Parent:SetPoint("TOPRIGHT",MicroMenu_ButtonLeft,"BOTTOMRIGHT",0,(((Y_Position+db.RaidMenu.Offset)/db.RaidMenu.Scale)+17))
			rm_timerdown = 0
			self:Hide()
		end
	end)
	
	-- Set Raid Menu script for MicroMenu button
	MicroMenu_Clicker:SetScript("OnClick", function(self)
		OverlapPrevention("MM")
	end)
	
	-- Set scripts for Left Button
	MicroMenu_ButtonLeft_Clicker:Show()
	MicroMenu_ButtonLeft_Clicker:RegisterForClicks("AnyUp")
	
	MicroMenu_ButtonLeft_Clicker:SetScript("OnEnter", function(self)
		MicroMenu_ButtonLeft:SetBackdrop({bgFile = fdir.."mm_button_left_hover",
					  edgeFile='Interface\\Tooltips\\UI-Tooltip-Border',
					  tile=false, tileSize = 0, edgeSize = 1,
					  insets = { left = 0, right = 0, top = 0, bottom = 0}});
		MicroMenu_ButtonLeft:SetBackdropColor(unpack(db.Colors.micromenu_btn_hover))
		MicroMenu_ButtonLeft:SetBackdropBorderColor(0,0,0,0)
	end)
	
	MicroMenu_ButtonLeft_Clicker:SetScript("OnLeave", function(self)
		MicroMenu_ButtonLeft:SetBackdrop({bgFile = fdir.."mm_button_left",
					  edgeFile='Interface\\Tooltips\\UI-Tooltip-Border',
					  tile=false, tileSize = 0, edgeSize = 1,
					  insets = { left = 0, right = 0, top = 0, bottom = 0}});
		MicroMenu_ButtonLeft:SetBackdropColor(unpack(db.Colors.micromenu_btn))
		MicroMenu_ButtonLeft:SetBackdropBorderColor(0,0,0,0)
	end)
	
	MicroMenu_ButtonLeft_Clicker:SetScript("OnClick", function(self, button)
		if (englishClass == "PALADIN") and (IsAddOnLoaded("PallyPower")) and (button == "RightButton") then
			if PallyPowerFrame:IsShown() then
				PallyPowerFrame:Hide()
				PallyPowerFrame:SetAlpha(0)
			else
				PallyPowerFrame:Show()
				PallyPowerFrame:SetAlpha(1)
			end
		else
			OverlapPrevention("RM", "toggle")
		end
	end)
	
	SizeRaidMenu()
end

-- Defaults for the module
local defaults = {
	RaidMenu = {
		Enable = true,
		Compact = false,
		Spacing = 5,
		OverlapPrevention = "Auto-Hide",
		Offset = -30,
		Opacity = 100,
		Scale = 1,
		ToggleRaidIcon = true,
		ShowToolTips = false,
		AutoHide = false,
	},
}

-- Load options: Creates an option menu for LUI
function module:LoadOptions()
	local options = {
		RaidMenu = {
			name = "Raid Menu",
			type = "group",
			order = 60,
			disabled = function() return not db.RaidMenu.Enable end,
			childGroups = "tab",
			args = {
				General = {
					name = "General",
					type = "group",
					order = 1,
					args = {
						Title = {
							type = "header",
							order = 1,
							name = "Raid Menu v" ..  version,
						},
						Info = {
							name = "Info",
							type = "group",
							order = 2,
							guiInline = true,
							args = {
								Description = {
									name = function()
										if LUI:GetModule("Micromenu", true) then
											return "Written by: "..author.."\n\nThis module will add a Raid Tools menu to the PallyPower button.\nPaladins using PallyPower can show/hide PallyPower by right clicking on the button."
										else
											return "Written by: "..author.."\n\nThis module will add a Raid Tools menu to the PallyPower button.\nPaladins using PallyPower can show/hide PallyPower by right clicking on the button.\n\nThe LUI MicroMenu must be enabled for this module to work!!!"
										end
									end,
									type = "description",
									order = 1,
								},
							},
						},
						Settings = {
							name = "Settings",
							type = "group",
							order = 3,
							disabled = function()
							end,
							guiInline = true,
							args = {
								Compact = {
									name = "Compact Raid Menu",
									desc = "Use compact version of the Raid Menu",
									disabled = function()
										if LUI:GetModule("Micromenu", true) then 
											return not db.RaidMenu.Enable
										else
											return true
										end
									end,
									type = "toggle",
									get = function() return db.RaidMenu.Compact end,
									set = function(self)
										db.RaidMenu.Compact = not db.RaidMenu.Compact
										OverlapPrevention("RM", "position")
										SizeRaidMenu()
									end,
									order = 1,
								},
								Spacing = {
									name = "Spacing",
									desc = "Spacing between buttons of Raid Menu",
									disabled = function()
										if LUI:GetModule("Micromenu", true) then
											return not db.RaidMenu.Compact
										else
											return true
										end
									end,
									type = "range",
									step = 1,
									min = 0,
									max = 10,
									get = function() return db.RaidMenu.Spacing end,
									set = function(self, value)
										db.RaidMenu.Spacing = value
										OverlapPrevention("RM", "position")
										SizeRaidMenu()
									end,
									order = 2,
								},
								OverlapPrevention = {
									name = "MicroMenu Overlap Prevention",
									desc = "\nAuto-Hide: The MicroMenu or Raid Menu should hide when the other is opened\n\nOffset: The Raid Menu should offset itself when the MicroMenu is open",
									disabled = function()
										if LUI:GetModule("Micromenu", true) then 
											return not db.RaidMenu.Enable
										else
											return true
										end
									end,
									type = "select",
									values = OverlapPreventionMethods,
									get = function()
										for k, v in pairs(OverlapPreventionMethods) do
											if db.RaidMenu.OverlapPrevention == v then
												return k
											end
										end
									end,
									set = function(self, value)
										db.RaidMenu.OverlapPrevention = OverlapPreventionMethods[value]
										OverlapPrevention("RM", "position")
									end,
									order = 3,
								},
								Offset = {
									name = "Offset",
									desc = "How far to vertically offset when the MicroMenu is open\n\nDefault: "..LUI.db.defaults.profile.RaidMenu.Offset,
									disabled = function()
										if LUI:GetModule("Micromenu", true) then
											if db.RaidMenu.OverlapPrevention == "Auto-Hide" then
												return true
											else
												return false
											end
										else
											return true
										end
									end,
									type = "range",
									step = 1,
									min = -100,
									max = 0,
									get = function() return db.RaidMenu.Offset end,
									set = function(self, value)
										db.RaidMenu.Offset = value
										OverlapPrevention("RM", "position")
									end,
									order = 4,
								},
								Scale = {
									name = "Scale",
									desc = "The Scale of the Raid Menu",
									disabled = function()
										if LUI:GetModule("Micromenu", true) then 
											return not db.RaidMenu.Enable
										else
											return true
										end
									end,
									type = "range",
									step = 0.05,
									min = 0.5,
									max = 2.0,
									get = function() return db.RaidMenu.Scale end,
									set = function(self, value)
										db.RaidMenu.Scale = value
										RaidMenu_Parent:SetScale(db.RaidMenu.Scale)
										OverlapPrevention("RM", "position")
									end,
									order = 5,
								},
								Opacity = {
									name = "Opacity",
									desc = "The Opacity of the Raid Menu\n100% is fully visable",
									disabled = function()
										if LUI:GetModule("Micromenu", true) then 
											return not db.RaidMenu.Enable
										else
											return true
										end
									end,
									type = "range",
									step = 10,
									min = 20,
									max = 100,
									get = function() return db.RaidMenu.Opacity end,
									set = function(self, value)
										db.RaidMenu.Opacity = value
										RaidMenu_Parent:SetAlpha(db.RaidMenu.Opacity/100)
									end,
									order = 6,
								},
								AutoHide = {
									name = "Auto-Hide Raid Menu",
									desc = "Weather or not the Raid Menu should hide itself after clicking on a function",
									disabled = function()
										if LUI:GetModule("Micromenu", true) then 
											return not db.RaidMenu.Enable
										else
											return true
										end
									end,
									type = "toggle",
									get = function() return db.RaidMenu.AutoHide end,
									set = function(self) db.RaidMenu.AutoHide = not db.RaidMenu.AutoHide end,
									order = 7,
								},
								ShowToolTips = {
									name = "Show Tooltips",
									desc = "Weather or not to show tooltips for the Raid Menu tools",
									disabled = function()
										if LUI:GetModule("Micromenu", true) then 
											return not db.RaidMenu.Enable
										else
											return true
										end
									end,
									type = "toggle",
									get = function() return db.RaidMenu.ShowToolTips end,
									set = function(self) db.RaidMenu.ShowToolTips = not db.RaidMenu.ShowToolTips end,
									order = 8,
								},
								ToggleRaidIcon = {
									name = "Toggle Raid Icon",
									desc = "Weather of not Raid Target Icons can be removed by applying the icon the target already has",
									disabled = function()
										if LUI:GetModule("Micromenu", true) then 
											return not db.RaidMenu.Enable
										else
											return true
										end
									end,
									type = "toggle",
									width = "full",
									get = function() return db.RaidMenu.ToggleRaidIcon end,
									set = function(self) db.RaidMenu.ToggleRaidIcon = not db.RaidMenu.ToggleRaidIcon end,
									order = 9,
								},
							},
						},
					},
				},
			},
		},
	}
	return options
end

-- Load module: Creates a module button to enable/disable through LUI options
function module:LoadModule()
	local module = {
		RaidMenu = {
			order = LUI:GetModuleCount(),
			type = "execute",
			name = function()
				if db.RaidMenu.Enable then
					return "|cff00ff00Raid Menu Enabled|r"
				else
					return "|cffFF0000Raid Menu Disabled|r"
				end
			end,
			func = function(self, RaidMenu)
				db.RaidMenu.Enable = not db.RaidMenu.Enable
				StaticPopup_Show("RELOAD_UI")
			end,
		},
	}
	
	return module
end

-- Initialize module: Called when the addon should intialize itself; this is where we load in database values
function module:OnInitialize()
	LUI:MergeDefaults(LUI.db.defaults.profile, defaults)
	LUI:RefreshDefaults()
	LUI:Refresh()
	
	self.db = LUI.db.profile
	db = self.db
end

-- Enable module: Called when addon is enabled; this is where we register module button and create the module
function module:OnEnable()
	LUI:RegisterOptions(self:LoadOptions())
	LUI:RegisterModule(self:LoadModule())
	self:SetRaidMenu()
end