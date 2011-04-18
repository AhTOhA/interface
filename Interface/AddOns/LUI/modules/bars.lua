--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: bars.lua
	Description: Bars Module
	Version....: 1.0
	Rev Date...: 12/10/2010
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local LSM = LibStub("LibSharedMedia-3.0")
local widgetLists = AceGUIWidgetLSMlists
local LUIHook = LUI:GetModule("LUIHook")
local Panels = LUI:GetModule("Panels")
local module = LUI:NewModule("Bars", "AceHook-3.0")

local db
local barAnchors = {
	'BT4Bar1', 
	'BT4Bar2', 
	'BT4Bar3', 
	'BT4Bar4', 
	'BT4Bar5', 
	'BT4Bar6', 
	'BT4Bar7', 
	'BT4Bar8', 
	'BT4Bar9', 
	'BT4Bar10', 
	'Dominos Bar1', 
	'Dominos Bar2', 
	'Dominos Bar3',
	'Dominos Bar4',
	'Dominos Bar5',
	'Dominos Bar6',
	'Dominos Bar7',
	'Dominos Bar8',
	'Dominos Bar9',
	'Dominos Bar10',
}
local isLocked = false

local function TopBarTextureSetPoint()
	BarsBackground:ClearAllPoints()
	BarsBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", tonumber(db.Bars.TopTexture.X), tonumber(db.Bars.TopTexture.Y))
end

local function TopBarTextureSetAlpha()
	BarsBackground:SetAlpha(db.Bars.TopTexture.Alpha)
end

local function ShowTopBarTexture()
	if db.Bars.TopTexture.Enable == true then
		BarsBackground:Show()
	else
		BarsBackground:Hide()
	end
end

local function BottomBarTextureSetPoint()
	BarsBackground2:ClearAllPoints()
	BarsBackground2:SetPoint("BOTTOM", UIParent, "BOTTOM", tonumber(db.Bars.BottomTexture.X), tonumber(db.Bars.BottomTexture.Y))
end

local function BottomBarTextureSetAlpha()
	BarsBackground2:SetAlpha(db.Bars.BottomTexture.Alpha)
end

local function ShowBottomBarTexture()
	if db.Bars.BottomTexture.Enable == true then
		BarsBackground2:Show()
	else
		BarsBackground2:Hide()
	end
end

local function GetAnchorStatus(anchor)
	if strmatch(anchor, "Dominos") then
		if IsAddOnLoaded("Dominos") then
			anchor = Dominos.ActionBar:Get(string.match(anchor, "%d+"))
			return anchor:IsShown()
		end
	else
		if _G[anchor] then 
			local getAnchorStatus = loadstring("return "..anchor..":IsShown()")
			return getAnchorStatus()
		end
	end
end

local function SidebarSetAlpha(anchor,alpha)
	if strmatch(anchor, "Dominos") then
		if IsAddOnLoaded("Dominos") then
			anchor = Dominos.ActionBar:Get(string.match(anchor, "%d+"))
			anchor:SetAlpha(alpha)
		end
	else
		local alphafunc = loadstring(anchor..":SetAlpha("..alpha..")")
	
		if GetAnchorStatus(anchor) then
			alphafunc()
		end
	end
end

local function SetLeftSidebarAnchor()
	if db.Bars.SidebarLeft.AutoPosEnable ~= true then return end
	
	local anchor = db.Bars.SidebarLeft.Anchor
	local xOffset = db.Bars.SidebarLeft.X
	local yOffset = db.Bars.SidebarLeft.Y
	local sbOffset = db.Bars.SidebarLeft.Offset
	
	if GetAnchorStatus(anchor) then
		if strmatch(anchor, "Dominos") then
			if IsAddOnLoaded("Dominos") then
				anchor = Dominos.ActionBar:Get(string.match(anchor, "%d+"))
				local scale = anchor:GetEffectiveScale()
				local scaleUI = UIParent:GetEffectiveScale()

				local x = tonumber(xOffset) + ( scaleUI * math.floor( 20 / scale ) )
				local y = tonumber(yOffset) + ( scaleUI * math.floor( 157 + tonumber(sbOffset) / scale ) )
				
				anchor:SetFrameStrata("BACKGROUND")
				anchor:SetFrameLevel(2)
				anchor:ClearAllPoints()
				anchor:SetPoint("LEFT",UIParent,"LEFT",x,y)
			end
		else
			local getScale = loadstring("return "..anchor..":GetEffectiveScale()")
			local scale = getScale()
			local scaleUI = UIParent:GetEffectiveScale()

			local x = tonumber(xOffset) + ( scaleUI * math.floor( 20 / scale ) )
			local y = tonumber(yOffset) + ( scaleUI * math.floor( 157 + tonumber(sbOffset) / scale ) )
			
			local sb_SetFrameStrata = loadstring(anchor..":SetFrameStrata(\"BACKGROUND\")")
			local sb_SetFrameLevel = loadstring(anchor..":SetFrameLevel(2)")
			local sb_ClearAllPoints = loadstring(anchor..":ClearAllPoints()")
			local sb_SetPoint = loadstring(anchor..":SetPoint(\"LEFT\",UIParent,\"LEFT\","..x..","..y..")")
			
			sb_SetFrameStrata()
			sb_SetFrameLevel()
			sb_ClearAllPoints()
			sb_SetPoint()
		end
	end
end

local function SetRightSidebarAnchor()
	if db.Bars.SidebarRight.AutoPosEnable ~= true then return end

	local anchor = db.Bars.SidebarRight.Anchor
	local xOffset = db.Bars.SidebarRight.X
	local yOffset = db.Bars.SidebarRight.Y
	local sbOffset = db.Bars.SidebarRight.Offset

	if GetAnchorStatus(anchor) then
		if strmatch(anchor, "Dominos") then
			if IsAddOnLoaded("Dominos") then
				anchor = Dominos.ActionBar:Get(string.match(anchor, "%d+"))
				local scale = anchor:GetEffectiveScale()
				local scaleUI = UIParent:GetEffectiveScale()

				local x = tonumber(xOffset) + ( scaleUI * math.floor( -90 / scale ) )
				local y = tonumber(yOffset) + ( scaleUI * math.floor( 157 + tonumber(sbOffset) / scale ) )
				
				anchor:SetFrameStrata("BACKGROUND")
				anchor:SetFrameLevel(2)
				anchor:ClearAllPoints()
				anchor:SetPoint("RIGHT",UIParent,"RIGHT",x,y)
			end
		else
			local getScale = loadstring("return "..anchor..":GetEffectiveScale()")
			local scale = getScale()
			local scaleUI = UIParent:GetEffectiveScale()

			local x = tonumber(xOffset) + ( scaleUI * math.floor( -90 / scale ) )
			local y = tonumber(yOffset) + ( scaleUI * math.floor( 157 + tonumber(sbOffset) / scale ) )
			
			local sb_SetFrameStrata = loadstring(anchor..":SetFrameStrata(\"BACKGROUND\")")
			local sb_SetFrameLevel = loadstring(anchor..":SetFrameLevel(2)")
			local sb_ClearAllPoints = loadstring(anchor..":ClearAllPoints()")
			local sb_SetPoint = loadstring(anchor..":SetPoint(\"RIGHT\",UIParent,\"RIGHT\","..x..","..y..")")
			
			sb_SetFrameStrata()
			sb_SetFrameLevel()
			sb_ClearAllPoints()
			sb_SetPoint()
		end
	end
end

function module:CreateCooldowntimerAnimation()
	if IsAddOnLoaded("Forte_Core") and IsAddOnLoaded("Forte_Cooldown") then
		if FC_Saved.Profiles[FC_Saved.PROFILE]["Cooldown"]["Enable"] ~= nil then
			if FC_Saved.Profiles[FC_Saved.PROFILE]["Cooldown"]["Enable"] == true then
				LUI.isForteCooldownLoaded = true
			end
		end
	end

	if not LUI.isForteCooldownLoaded == true then return end
	
	local bb_timerout,bb_timerin = 0,0
	local bb_animation_time = 0.5
	local bb_at_out = 0.25
		
	local bb_SlideIn = CreateFrame("Frame", "bb_SlideIn", UIParent)
	bb_SlideIn:Hide()
		
	bb_SlideIn:SetScript("OnUpdate", function(self,elapsed)
		bb_timerin = bb_timerin + elapsed
		local bb_x = tonumber(db.Bars.TopTexture.X)
		local bb_y = tonumber(db.Bars.TopTexture.Y)
		local bb_pixelpersecond = tonumber(db.Bars.TopTexture.AnimationHeight) * 2
		if bb_timerin < bb_animation_time then
			local y2 = bb_y - bb_timerin * bb_pixelpersecond + bb_pixelpersecond * bb_animation_time
			BarsBackground:ClearAllPoints()
			BarsBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", bb_x, y2)
		else
			BarsBackground:ClearAllPoints()
			BarsBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", bb_x, bb_y)
			bb_timerin = 0
			self:Hide()
		end
	end)

	local bb_SlideOut = CreateFrame("Frame", "bb_SlideOut", UIParent)
	bb_SlideOut:Hide()
	
	bb_SlideOut:SetScript("OnUpdate", function(self,elapsed)
		bb_timerout = bb_timerout + elapsed
		local bb_x = tonumber(db.Bars.TopTexture.X)
		local bb_y = tonumber(db.Bars.TopTexture.Y)
		local bb_ppx_out = tonumber(db.Bars.TopTexture.AnimationHeight) * 3
		local bb_yout = tonumber(db.Bars.TopTexture.Y) + tonumber(db.Bars.TopTexture.AnimationHeight)
		if bb_timerout < bb_at_out then
			local y2 = bb_y + bb_timerout * bb_ppx_out
			BarsBackground:ClearAllPoints()
			BarsBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", bb_x, y2)
		else
			BarsBackground:ClearAllPoints()
			BarsBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", bb_x, bb_yout)
			bb_timerout = 0
			self:Hide()
		end
	end)
	
	if LUICONFIG.IsConfigured then
		if IsAddOnLoaded("Forte_Core") and IsAddOnLoaded("Forte_Cooldown") and LUICONFIG.IsForteInstalled == true then
			bb_Forte = CreateFrame("Frame", "bb_Forte", UIParent)
			bb_Forte:Show()
			
			local isOut = false
			
			bb_Forte:SetScript("OnUpdate", function(self)
				if db.Forte.CDLock ~= false then
					if FX_Cooldown:IsShown() and isOut == false then
						if db.Bars.TopTexture.Animation == true then
							bb_SlideOut:Show()
							isOut = true
						end
					elseif not FX_Cooldown:IsShown() and isOut == true then
						if db.Bars.TopTexture.Animation == true then
							bb_SlideIn:Show()
							isOut = false
						end
					end
				end
			end)
		end
	end
end

function module:SetBarColors()
	BarsBackground:SetBackdropColor(unpack(db.Colors.bar))
	BarsBackground2:SetBackdropColor(unpack(db.Colors.bar2))
end

function module:CreateBarBackground()
	-- SET BARS TOP TEXTURE
	local BarsBackground = LUI:CreateMeAFrame("FRAME","BarsBackground",UIParent,1024,1024,1,"BACKGROUND",2,"BOTTOM",UIParent,"BOTTOM",200,-70,1)
	BarsBackground:SetBackdrop({
		bgFile=fdir.."bars_top",
		edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
		tile=false, edgeSize=1, 
		insets={left=0, right=0, top=0, bottom=0}
	})
	BarsBackground:SetBackdropColor(unpack(db.Colors.bar))
	BarsBackground:SetBackdropBorderColor(0,0,0,0)
	BarsBackground:ClearAllPoints()
	TopBarTextureSetPoint()
	TopBarTextureSetAlpha()
	ShowTopBarTexture()
	
	-- SET BARS BOTTOM TEXTURE
	local BarsBackground2 = LUI:CreateMeAFrame("FRAME","BarsBackground2",BT4Bar1,1024,1024,1,"BACKGROUND",0,"BOTTOM",BT4Bar1,"BOTTOM",210,-145,1)
	BarsBackground2:SetBackdrop({
		bgFile=fdir.."bars_bottom", 
		edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", 
		tile=false, edgeSize=1,
		insets={left=0, right=0, top=0, bottom=0}
	})
	BarsBackground2:SetBackdropColor(unpack(db.Colors.bar2))
	BarsBackground2:SetBackdropBorderColor(0,0,0,0)		
	BottomBarTextureSetPoint()
	BottomBarTextureSetAlpha()
	ShowBottomBarTexture()
end

function module:SetSidebarColors()
	local sidebar_r, sidebar_g, sidebar_b, sidebar_a = unpack(db.Colors.sidebar)
	
	fsidebar_back:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,sidebar_a)
	fsidebar_back2:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,sidebar_a)
	fsidebar_bt_back:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
	fsidebar_button:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
	fsidebar_button_hover:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
	
	fsidebar2_back:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,sidebar_a)
	fsidebar2_back2:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,sidebar_a)
	fsidebar2_bt_back:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
	fsidebar2_button:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
	fsidebar2_button_hover:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
end

function module:CreateRightSidebar()
	local RightAnchor = db.Bars.SidebarRight.Anchor
	local isRightSidebarCreated = false
	local sidebar_r, sidebar_g, sidebar_b, sidebar_a = unpack(db.Colors.sidebar)
	
	if isRightSidebarCreated == false or isRightSidebarCreated == nil then
		local isRightSidebarCreated = true
		------------------------------------------------------
		-- / OPEN / CLOSE RIGHT SIDEBAR / --
		------------------------------------------------------
		local fsidebar_timerout,fsidebar_timerin = 0,0
		local fsidebar_y = 0
		local fsidebar_x = -30
		local fsidebar_xout = -118 
		local fsidebar_pixelpersecond = -176
		local fsidebar_animation_time = 0.5
		
		local fsidebar_SlideOut = CreateFrame("Frame", "fsidebar_SlideOut", UIParent)
		fsidebar_SlideOut:Hide()
		
		fsidebar_SlideOut:SetScript("OnUpdate", function(self,elapsed)
			fsidebar_timerout = fsidebar_timerout + elapsed
			if fsidebar_timerout < fsidebar_animation_time then
				local x2 = fsidebar_x + fsidebar_timerout * fsidebar_pixelpersecond
				fsidebar_button_anchor:ClearAllPoints()
				fsidebar_button_anchor:SetPoint("LEFT", fsidebar_anchor, "LEFT", x2, fsidebar_y)
			else
				fsidebar_button_anchor:ClearAllPoints()
				fsidebar_button_anchor:SetPoint("LEFT", fsidebar_anchor, "LEFT", fsidebar_xout, fsidebar_y)
				fsidebar_timerout = 0
				fsidebar_bt_AlphaIn:Show()
				self:Hide()
			end
		end)
		
		local fsidebar_SlideIn = CreateFrame("Frame", "fsidebar_SlideIn", UIParent)
		fsidebar_SlideIn:Hide()
		
		fsidebar_SlideIn:SetScript("OnUpdate", function(self,elapsed)
			fsidebar_timerin = fsidebar_timerin + elapsed
			if fsidebar_timerin < fsidebar_animation_time then
				local x2 = fsidebar_x - fsidebar_timerin * fsidebar_pixelpersecond + fsidebar_pixelpersecond * fsidebar_animation_time
				fsidebar_button_anchor:ClearAllPoints()
				fsidebar_button_anchor:SetPoint("LEFT", fsidebar_anchor, "LEFT", x2, fsidebar_y)
			else
				fsidebar_button_anchor:ClearAllPoints()
				fsidebar_button_anchor:SetPoint("LEFT", fsidebar_anchor, "LEFT", fsidebar_x, fsidebar_y)
				fsidebar_timerin = 0
				self:Hide()
			end
		end)
		
		local fsidebar_alpha_timerout, fsidebar_alpha_timerin = 0,0
		local fsidebar_speedin = 0.9
		local fsidebar_speedout = 0.3
		
		local fsidebar_AlphaIn = CreateFrame("Frame", "fsidebar_AlphaIn", UIParent)
		fsidebar_AlphaIn:Hide()
		
		fsidebar_AlphaIn:SetScript("OnUpdate", function(self,elapsed)
			fsidebar_alpha_timerin = fsidebar_alpha_timerin + elapsed
			if fsidebar_alpha_timerin < fsidebar_speedin then
				local alpha = fsidebar_alpha_timerin / fsidebar_speedin 
				fsidebar_bt_back:SetAlpha(alpha)
			else
				fsidebar_bt_back:SetAlpha(1)
				fsidebar_alpha_timerin = 0
				self:Hide()
			end
		end)
		
		local fsidebar_AlphaOut = CreateFrame("Frame", "fsidebar_AlphaOut", UIParent)
		fsidebar_AlphaOut:Hide()
		
		fsidebar_AlphaOut:SetScript("OnUpdate", function(self,elapsed)
			fsidebar_alpha_timerout = fsidebar_alpha_timerout + elapsed
			if fsidebar_alpha_timerout < fsidebar_speedout then
				local alpha = 1 - fsidebar_alpha_timerout / fsidebar_speedout
				fsidebar_bt_back:SetAlpha(alpha)
			else
				fsidebar_bt_back:SetAlpha(0)
				fsidebar_alpha_timerout = 0
				self:Hide()
			end
		end)
		
		local fsidebar_bt_timerin = 0
		local fsidebar_bt_speedin = 0.3
		
		local fsidebar_bt_AlphaIn = CreateFrame("Frame", "fsidebar_bt_AlphaIn", UIParent)
		fsidebar_bt_AlphaIn:Hide()
		
		fsidebar_bt_AlphaIn:SetScript("OnUpdate", function(self,elapsed)
			fsidebar_bt_timerin = fsidebar_bt_timerin + elapsed
			if fsidebar_bt_timerin < fsidebar_bt_speedin then
				local alpha = fsidebar_bt_timerin / fsidebar_bt_speedin
				SidebarSetAlpha(RightAnchor,alpha)
				
				for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarRight.Additional)) do
					SidebarSetAlpha(frame, alpha)
				end
			else
				SidebarSetAlpha(RightAnchor,1)
				for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarRight.Additional)) do
					SidebarSetAlpha(frame, 1)
				end
				fsidebar_bt_timerin = 0
				self:Hide()
			end
		end)
		
		------------------------------------------------------
		-- / RIGHT SIDEBAR FRAMES / --
		------------------------------------------------------
		
		fsidebar_anchor = LUI:CreateMeAFrame("FRAME","fsidebar_anchor",UIParent,25,25,1,"BACKGROUND",0,"RIGHT",UIParent,"RIGHT",11,db.Bars.SidebarRight.Offset,1)
		fsidebar_anchor:SetBackdrop({
			bgFile="Interface\\Tooltips\\UI-Tooltip-Background", 
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
			tile=false, edgeSize=1, 
			insets={left=0, right=0, top=0, bottom=0}
		})
		fsidebar_anchor:SetBackdropColor(0,0,0,0)
		fsidebar_anchor:SetBackdropBorderColor(0,0,0,0)
		fsidebar_anchor:Show() 
		
		local fsidebar = LUI:CreateMeAFrame("FRAME","fsidebar",fsidebar_anchor,512,512,1,"BACKGROUND",2,"LEFT",fsidebar_anchor,"LEFT",-17,0,1)
		fsidebar:SetBackdrop({
			bgFile=fdir.."sidebar", 
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
			tile=false, edgeSize=1, 
			insets={left=0, right=0, top=0, bottom=0}
		})
		fsidebar:SetBackdropBorderColor(0,0,0,0)
		fsidebar:Show()
		
		local fsidebar_back = LUI:CreateMeAFrame("FRAME","fsidebar_back",fsidebar_anchor,512,512,1,"BACKGROUND",1,"LEFT",fsidebar_anchor,"LEFT",-25,0,1)
		fsidebar_back:SetBackdrop({
			bgFile=fdir.."sidebar_back", 
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
			tile=false, edgeSize=1, 
			insets={left=0, right=0, top=0, bottom=0}
		})
		fsidebar_back:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,sidebar_a)
		fsidebar_back:SetBackdropBorderColor(0,0,0,0)
		fsidebar_back:Show()
		
		local fsidebar_back2 = LUI:CreateMeAFrame("FRAME","fsidebar_back2",fsidebar_anchor,512,512,1,"BACKGROUND",1,"LEFT",fsidebar_anchor,"LEFT",-25,0,1)
		fsidebar_back2:SetBackdrop({
			bgFile=fdir.."sidebar_back2", 
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", 
			tile=false, edgeSize=1,
			insets={left=0, right=0, top=0, bottom=0}
		})
		fsidebar_back2:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,sidebar_a)
		fsidebar_back2:SetBackdropBorderColor(0,0,0,0)
		fsidebar_back2:Show()
		
		local fsidebar_button_anchor=LUI:CreateMeAFrame("FRAME","fsidebar_button_anchor",fsidebar_anchor,10,10,1,"BACKGROUND",0,"LEFT",fsidebar_anchor,"LEFT",-30,0,1)
		fsidebar_button_anchor:SetBackdrop({
			bgFile="Interface\\Tooltips\\UI-Tooltip-Background", 
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", 
			tile=false, edgeSize=1, 
			insets={left=0, right=0, top=0, bottom=0}
		})
		fsidebar_button_anchor:SetBackdropColor(0,0,0,0)
		fsidebar_button_anchor:SetBackdropBorderColor(0,0,0,0)
		fsidebar_button_anchor:Show()
		
		local fsidebar_bt_back = LUI:CreateMeAFrame("FRAME","fsidebar_bt_back",fsidebar_button_anchor,273,267,1,"BACKGROUND",0,"LEFT",fsidebar_button_anchor,"LEFT",3,-2,1)
		fsidebar_bt_back:SetBackdrop({
			bgFile=fdir.."sidebar_bt_back", 
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", 
			tile=false, edgeSize=1, 
			insets={left=0, right=0, top=0, bottom=0}
		})
		fsidebar_bt_back:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
		fsidebar_bt_back:SetBackdropBorderColor(0,0,0,0)
		fsidebar_bt_back:SetAlpha(0)
		fsidebar_bt_back:Show()
		
		local fsidebar_bt_block= LUI:CreateMeAFrame("FRAME","fsidebar_bt_block",fsidebar_anchor,80,225,1,"MEDIUM",4,"LEFT",fsidebar_anchor,"LEFT",-82,-5,1)
		fsidebar_bt_block:SetBackdrop({
			bgFile="Interface\\Tooltips\\UI-Tooltip-Background", 
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
			tile=false, edgeSize=1, 
			insets={left=0, right=0, top=0, bottom=0}
		})
		fsidebar_bt_block:SetBackdropColor(0,0,0,0)
		fsidebar_bt_block:SetBackdropBorderColor(0,0,0,0)
		fsidebar_bt_block:EnableMouse(true)
		fsidebar_bt_block:Show()
		
		local fsidebar_button_clicker= LUI:CreateMeAFrame("BUTTON","fsidebar_button_clicker",fsidebar_button_anchor,30,215,1,"MEDIUM",5,"LEFT",fsidebar_button_anchor,"LEFT",6,-5,1)
		fsidebar_button_clicker:SetBackdrop({
			bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
			tile=false, edgeSize=1, 
			insets={left=0, right=0, top=0, bottom=0}
		})
		fsidebar_button_clicker:SetBackdropColor(0,0,0,0)
		fsidebar_button_clicker:SetBackdropBorderColor(0,0,0,0)
		fsidebar_button_clicker:Show()
	
		local fsidebar_button = LUI:CreateMeAFrame("FRAME","fsidebar_button",fsidebar_button_anchor,266,251,1,"BACKGROUND",0,"LEFT",fsidebar_button_anchor,"LEFT",0,-2,1)
		fsidebar_button:SetBackdrop({
			bgFile=fdir.."sidebar_button", 
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", 
			tile=false, edgeSize=1, 
			insets={left=0, right=0, top=0, bottom=0}
		})
		fsidebar_button:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
		fsidebar_button:SetBackdropBorderColor(0,0,0,0)
		fsidebar_button:Show()
		
		local fsidebar_button_hover = LUI:CreateMeAFrame("FRAME","fsidebar_button_hover",fsidebar_button_anchor,266,251,1,"BACKGROUND",0,"LEFT",fsidebar_button_anchor,"LEFT",0,-2,1)
		fsidebar_button_hover:SetBackdrop({
			bgFile=fdir.."sidebar_button_hover",
			edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", 
			tile=false, edgeSize=1,
			insets={left=0, right=0, top=0, bottom=0}
		})
		fsidebar_button_hover:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
		fsidebar_button_hover:SetBackdropBorderColor(0,0,0,0)
		fsidebar_button_hover:Hide()
		
		rightSidebarOpen = 0
		
		fsidebar_button_clicker:RegisterForClicks("AnyUp")
		fsidebar_button_clicker:SetScript("OnClick", function(self)
			if rightSidebarOpen == 0 then
				rightSidebarOpen = 1
				db.Bars.SidebarRight.IsOpen = true
				if db.Bars.SidebarRight.OpenInstant then
					fsidebar_button_anchor:ClearAllPoints()
					fsidebar_button_anchor:SetPoint("LEFT",fsidebar_anchor,"LEFT",-120,0)
					fsidebar_bt_back:SetAlpha(1)
					SidebarSetAlpha(RightAnchor,1)
					for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarRight.Additional)) do
						SidebarSetAlpha(frame, 1)
					end
					fsidebar_bt_block:Hide()
				else
					fsidebar_SlideOut:Show()
					fsidebar_AlphaIn:Show()
					fsidebar_bt_block:Hide()
				end
			else
				rightSidebarOpen = 0
				db.Bars.SidebarRight.IsOpen = false
				if db.Bars.SidebarRight.OpenInstant then
					fsidebar_button_anchor:ClearAllPoints()
					fsidebar_button_anchor:SetPoint("LEFT",fsidebar_anchor,"LEFT",-32,0)
					fsidebar_bt_back:SetAlpha(0)
					SidebarSetAlpha(RightAnchor,0)
					for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarRight.Additional)) do
						SidebarSetAlpha(frame, 0)
					end
					fsidebar_bt_block:Show()
				else
					fsidebar_SlideIn:Show()
					fsidebar_AlphaOut:Show()
					SidebarSetAlpha(RightAnchor,0)
					for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarRight.Additional)) do
						SidebarSetAlpha(frame, 0)
					end
					fsidebar_bt_block:Show()
				end
			end
		end)
	
		fsidebar_button_clicker:SetScript("OnEnter", function(self)
			fsidebar_button:Hide()
			fsidebar_button_hover:Show()
		end)
	
		fsidebar_button_clicker:SetScript("OnLeave", function(self)
			fsidebar_button:Show()
			fsidebar_button_hover:Hide()
		end)
	end
	
	if db.Bars.SidebarRight.Enable then	
		fsidebar_anchor:Show()
	else
		fsidebar_anchor:Hide()
	end
	
	SetRightSidebarAnchor()
	SidebarSetAlpha(RightAnchor,0)
	for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarRight.Additional)) do
		SidebarSetAlpha(frame, 0)
	end
	
	if db.Bars.SidebarRight.Enable == true then
		if db.Bars.SidebarRight.IsOpen == true then
			rightSidebarOpen = 1
			fsidebar_SlideOut:Show()
			fsidebar_AlphaIn:Show()
			fsidebar_bt_block:Hide()
		end
	end
end

function module:CreateLeftSidebar()
	local LeftAnchor = db.Bars.SidebarLeft.Anchor
	local isLeftSidebarCreated = false
	local sidebar_r, sidebar_g, sidebar_b, sidebar_a = unpack(db.Colors.sidebar)
	
	if isLeftSidebarCreated == false or isLeftSidebarCreated == nil then
		local isLeftSidebarCreated = true
		------------------------------------------------------
		-- / SLIDE LEFT SIDEBAR / --
		------------------------------------------------------
		local fsidebar2_timerout,fsidebar2_timerin = 0,0
		local fsidebar2_y = 0
		local fsidebar2_x = 30
		local fsidebar2_xout = 118
		local fsidebar2_pixelpersecond = 176
		local fsidebar2_animation_time = 0.5
		
		local fsidebar2_SlideOut = CreateFrame("Frame", "fsidebar2_SlideOut", UIParent)
		fsidebar2_SlideOut:Hide()
		
		fsidebar2_SlideOut:SetScript("OnUpdate", function(self,elapsed)
			fsidebar2_timerout = fsidebar2_timerout + elapsed
			if fsidebar2_timerout < fsidebar2_animation_time then
				local x2 = fsidebar2_x + fsidebar2_timerout * fsidebar2_pixelpersecond
				fsidebar2_button_anchor:ClearAllPoints()
				fsidebar2_button_anchor:SetPoint("RIGHT", fsidebar2_anchor, "RIGHT", x2, fsidebar2_y)
			else
				fsidebar2_button_anchor:ClearAllPoints()
				fsidebar2_button_anchor:SetPoint("RIGHT", fsidebar2_anchor, "RIGHT", fsidebar2_xout, fsidebar2_y)
				fsidebar2_timerout = 0
				fsidebar2_bt_AlphaIn:Show()
				self:Hide()
			end
		end)
		
		local fsidebar2_SlideIn = CreateFrame("Frame", "fsidebar2_SlideIn", UIParent)
		fsidebar2_SlideIn:Hide()
		
		fsidebar2_SlideIn:SetScript("OnUpdate", function(self,elapsed)
			fsidebar2_timerin = fsidebar2_timerin + elapsed
			if fsidebar2_timerin < fsidebar2_animation_time then
				local x2 = fsidebar2_x - fsidebar2_timerin * fsidebar2_pixelpersecond + fsidebar2_pixelpersecond * fsidebar2_animation_time
				fsidebar2_button_anchor:ClearAllPoints()
				fsidebar2_button_anchor:SetPoint("RIGHT", fsidebar2_anchor, "RIGHT", x2, fsidebar2_y)
			else
				fsidebar2_button_anchor:ClearAllPoints()
				fsidebar2_button_anchor:SetPoint("RIGHT", fsidebar2_anchor, "RIGHT", fsidebar2_x, fsidebar2_y)
				fsidebar2_timerin = 0
				self:Hide()
			end
		end)
		
		local fsidebar2_alpha_timerout, fsidebar2_alpha_timerin = 0,0
		local fsidebar2_speedin = 0.9
		local fsidebar2_speedout = 0.3
		
		local fsidebar2_AlphaIn = CreateFrame("Frame", "fsidebar2_AlphaIn", UIParent)
		fsidebar2_AlphaIn:Hide()
		
		fsidebar2_AlphaIn:SetScript("OnUpdate", function(self,elapsed)
			fsidebar2_alpha_timerin = fsidebar2_alpha_timerin + elapsed
			if fsidebar2_alpha_timerin < fsidebar2_speedin then
				local alpha = fsidebar2_alpha_timerin / fsidebar2_speedin 
				fsidebar2_bt_back:SetAlpha(alpha)
			else
				fsidebar2_bt_back:SetAlpha(1)
				fsidebar2_alpha_timerin = 0
				self:Hide()
			end

		end)
		
		local fsidebar2_AlphaOut = CreateFrame("Frame", "fsidebar2_AlphaOut", UIParent)
		fsidebar2_AlphaOut:Hide()
		
		fsidebar2_AlphaOut:SetScript("OnUpdate", function(self,elapsed)
			fsidebar2_alpha_timerout = fsidebar2_alpha_timerout + elapsed
			if fsidebar2_alpha_timerout < fsidebar2_speedout then
				local alpha = 1 - fsidebar2_alpha_timerout / fsidebar2_speedout
				fsidebar2_bt_back:SetAlpha(alpha)
			else
				fsidebar2_bt_back:SetAlpha(0)
				fsidebar2_alpha_timerout = 0
				self:Hide()
			end
		end)
		
		local fsidebar2_bt_timerin = 0,0
		local fsidebar2_bt_speedin = 0.3
		
		local fsidebar2_bt_AlphaIn = CreateFrame("Frame", "fsidebar2_bt_AlphaIn", UIParent)
		fsidebar2_bt_AlphaIn:Hide()
		
		fsidebar2_bt_AlphaIn:SetScript("OnUpdate", function(self,elapsed)
			fsidebar2_bt_timerin = fsidebar2_bt_timerin + elapsed
			if fsidebar2_bt_timerin < fsidebar2_bt_speedin then
				local alpha = fsidebar2_bt_timerin / fsidebar2_bt_speedin
				SidebarSetAlpha(LeftAnchor,alpha)
				for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarLeft.Additional)) do
					SidebarSetAlpha(frame, alpha)
				end
			else
				SidebarSetAlpha(LeftAnchor,1)
				for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarLeft.Additional)) do
					SidebarSetAlpha(frame, 1)
				end
				fsidebar2_bt_timerin = 0
				self:Hide()
			end
		end)
		
		------------------------------------------------------
		-- / LEFT SIDEBAR FRAMES / --
		------------------------------------------------------
	
		fsidebar2_anchor = LUI:CreateMeAFrame("FRAME","fsidebar2_anchor",UIParent,25,25,1,"BACKGROUND",0,"LEFT",UIParent,"LEFT",-11,db.Bars.SidebarLeft.Offset,1)
		fsidebar2_anchor:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=0, tileSize=0, edgeSize=1, insets={left=0, right=0, top=0, bottom=0}})
		fsidebar2_anchor:SetBackdropColor(0,0,0,0)
		fsidebar2_anchor:SetBackdropBorderColor(0,0,0,0)
		fsidebar2_anchor:Show()
		
		local fsidebar2 = LUI:CreateMeAFrame("FRAME","fsidebar2",fsidebar2_anchor,512,512,1,"BACKGROUND",2,"RIGHT",fsidebar2_anchor,"RIGHT",17,0,1)
		fsidebar2:SetBackdrop({bgFile=fdir.."sidebar2", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=0, tileSize=0, edgeSize=1, insets={left=0, right=0, top=0, bottom=0}})
		fsidebar2:SetBackdropBorderColor(0,0,0,0)
		fsidebar2:Show()
		
		local fsidebar2_back = LUI:CreateMeAFrame("FRAME","fsidebar2_back",fsidebar2_anchor,512,512,1,"BACKGROUND",1,"RIGHT",fsidebar2_anchor,"RIGHT",25,0,1)
		fsidebar2_back:SetBackdrop({bgFile=fdir.."sidebar2_back", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=0, tileSize=0, edgeSize=1, insets={left=0, right=0, top=0, bottom=0}})
		fsidebar2_back:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,sidebar_a)
		fsidebar2_back:SetBackdropBorderColor(0,0,0,0)
		fsidebar2_back:Show()
		
		local fsidebar2_back2 = LUI:CreateMeAFrame("FRAME","fsidebar2_back2",fsidebar2_anchor,512,512,1,"BACKGROUND",3,"RIGHT",fsidebar2_anchor,"RIGHT",25,0,1)
		fsidebar2_back2:SetBackdrop({bgFile=fdir.."sidebar2_back2", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=0, tileSize=0, edgeSize=1, insets={left=0, right=0, top=0, bottom=0}})
		fsidebar2_back2:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
		fsidebar2_back2:SetBackdropBorderColor(0,0,0,0)
		fsidebar2_back2:Show()
		
		local fsidebar2_button_anchor= LUI:CreateMeAFrame("FRAME","fsidebar2_button_anchor",fsidebar2_anchor,10,10,1,"BACKGROUND",0,"RIGHT",fsidebar2_anchor,"RIGHT",30,0,1)
		fsidebar2_button_anchor:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=0, tileSize=0, edgeSize=1, insets={left=0, right=0, top=0, bottom=0}})
		fsidebar2_button_anchor:SetBackdropColor(0,0,0,0)
		fsidebar2_button_anchor:SetBackdropBorderColor(0,0,0,0)
		fsidebar2_button_anchor:Show()
		
		local fsidebar2_bt_back = LUI:CreateMeAFrame("FRAME","fsidebar2_bt_back",fsidebar2_button_anchor,273,267,1,"BACKGROUND",0,"RIGHT",fsidebar2_button_anchor,"RIGHT",-3,-2,1)
		fsidebar2_bt_back:SetBackdrop({bgFile=fdir.."sidebar2_bt_back", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=0, tileSize=0, edgeSize=1, insets={left=0, right=0, top=0, bottom=0}})
		fsidebar2_bt_back:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
		fsidebar2_bt_back:SetBackdropBorderColor(0,0,0,0)
		fsidebar2_bt_back:SetAlpha(0)
		fsidebar2_bt_back:Show()
		
		local fsidebar2_bt_block= LUI:CreateMeAFrame("FRAME","fsidebar2_bt_block",fsidebar2_anchor,80,225,1,"MEDIUM",4,"RIGHT",fsidebar2_anchor,"RIGHT",82,-5,1)
		fsidebar2_bt_block:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=0, tileSize=0, edgeSize=1, insets={left=0, right=0, top=0, bottom=0}})
		fsidebar2_bt_block:SetBackdropColor(0,0,0,0)
		fsidebar2_bt_block:SetBackdropBorderColor(0,0,0,0)
		fsidebar2_bt_block:EnableMouse(true)
		fsidebar2_bt_block:Show()
		
		local fsidebar2_button_clicker= LUI:CreateMeAFrame("BUTTON","fsidebar2_button_clicker",fsidebar2_button_anchor,30,215,1,"MEDIUM",5,"RIGHT",fsidebar2_button_anchor,"RIGHT",-6,-5,1)
		fsidebar2_button_clicker:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=0, tileSize=0, edgeSize=1, insets={left=0, right=0, top=0, bottom=0}})
		fsidebar2_button_clicker:SetBackdropColor(0,0,0,0)
		fsidebar2_button_clicker:SetBackdropBorderColor(0,0,0,0)
		fsidebar2_button_clicker:Show()

		local fsidebar2_button = LUI:CreateMeAFrame("FRAME","fsidebar2_button",fsidebar2_button_anchor,266,251,1,"BACKGROUND",0,"RIGHT",fsidebar2_button_anchor,"RIGHT",0,-2,1)
		fsidebar2_button:SetBackdrop({bgFile=fdir.."sidebar2_button", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=0, tileSize=0, edgeSize=1, insets={left=0, right=0, top=0, bottom=0}})
		fsidebar2_button:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
		fsidebar2_button:SetBackdropBorderColor(0,0,0,0)
		fsidebar2_button:Show()
		
		local fsidebar2_button_hover = LUI:CreateMeAFrame("FRAME","fsidebar2_button_hover",fsidebar2_button_anchor,266,251,1,"BACKGROUND",0,"RIGHT",fsidebar2_button_anchor,"RIGHT",0,-2,1)
		fsidebar2_button_hover:SetBackdrop({bgFile=fdir.."sidebar2_button_hover", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=0, tileSize=0, edgeSize=1, insets={left=0, right=0, top=0, bottom=0}})
		fsidebar2_button_hover:SetBackdropColor(sidebar_r,sidebar_g,sidebar_b,1)
		fsidebar2_button_hover:SetBackdropBorderColor(0,0,0,0)
		fsidebar2_button_hover:Hide()
	
		leftSidebarOpen = 0
		
		fsidebar2_button_clicker:RegisterForClicks("AnyUp")
		fsidebar2_button_clicker:SetScript("OnClick", function(self)
			if leftSidebarOpen == 0 then
				leftSidebarOpen = 1
				db.Bars.SidebarLeft.IsOpen = true
				if db.Bars.SidebarLeft.OpenInstant then
					fsidebar2_button_anchor:ClearAllPoints()
					fsidebar2_button_anchor:SetPoint("RIGHT",fsidebar2_anchor,"RIGHT",120,0)
					fsidebar2_bt_back:SetAlpha(1)
					SidebarSetAlpha(LeftAnchor,1)
					for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarLeft.Additional)) do
						SidebarSetAlpha(frame, 1)
					end
					fsidebar2_bt_block:Hide()
				else
					fsidebar2_SlideOut:Show()
					fsidebar2_AlphaIn:Show()
					fsidebar2_bt_block:Hide()
				end
			else
				leftSidebarOpen = 0
				db.Bars.SidebarLeft.IsOpen = false
				if db.Bars.SidebarLeft.OpenInstant then
					fsidebar2_button_anchor:ClearAllPoints()
					fsidebar2_button_anchor:SetPoint("RIGHT",fsidebar2_anchor,"RIGHT",32,0)
					fsidebar2_bt_back:SetAlpha(0)
					SidebarSetAlpha(LeftAnchor,0)
					for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarLeft.Additional)) do
						SidebarSetAlpha(frame, 0)
					end
					fsidebar2_bt_block:Show()
				else
					fsidebar2_SlideIn:Show()
					fsidebar2_AlphaOut:Show()
					SidebarSetAlpha(LeftAnchor,0)
					for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarLeft.Additional)) do
						SidebarSetAlpha(frame, 0)
					end
					fsidebar2_bt_block:Show()
				end
			end
		end)
	
		fsidebar2_button_clicker:SetScript("OnEnter", function(self)
			fsidebar2_button:Hide()
			fsidebar2_button_hover:Show()
		end)
	
		fsidebar2_button_clicker:SetScript("OnLeave", function(self)
			fsidebar2_button:Show()
			fsidebar2_button_hover:Hide()
		end)
	end
	
	if db.Bars.SidebarLeft.Enable then	
		fsidebar2_anchor:Show()
	else
		fsidebar2_anchor:Hide()
	end
	
	SetLeftSidebarAnchor()
	SidebarSetAlpha(LeftAnchor,0)
	for _, frame in pairs(Panels:LoadAdditional(db.Bars.SidebarLeft.Additional)) do
		SidebarSetAlpha(frame, 0)
	end
	
	if db.Bars.SidebarLeft.Enable == true then
		if db.Bars.SidebarLeft.IsOpen == true then
			leftSidebarOpen = 1
			fsidebar2_SlideOut:Show()
			fsidebar2_AlphaIn:Show()
			fsidebar2_bt_block:Hide()
		end
	end
end

function module:SetBars()
	self:CreateBarBackground()
	self:CreateCooldowntimerAnimation()
	self:CreateRightSidebar()
	self:CreateLeftSidebar()
end

local defaults = {
	Bars = {
		TopTexture = {
			Enable = true,
			Alpha = 0.7,
			X = "-25",
			Y = "25",
			Animation = true,
			AnimationHeight = "35",
		},
		BottomTexture = {
			Enable = true,
			Alpha = 1,
			X = "0",
			Y = "-40",
		},
		SidebarRight = { 
			Enable = true,
			OpenInstant = false,
			Offset = "0",
			IsOpen = false,
			Anchor = "BT4Bar10",
			Additional = "",
			AutoPosEnable = true,
			X = "0",
			Y = "0",
		},
		SidebarLeft = {
			Enable = false,
			OpenInstant = false,
			Offset = "0",
			IsOpen = false,
			Anchor = "BT4Bar9",
			Additional = "",
			AutoPosEnable = true,
			X = "0",
			Y = "0",
		},
	},
}

function module:LoadOptions()
	local options = {
		Bars = {
			name = "Bars",
			type = "group",
			order = 15,
			disabled = function() return isLocked end,
			childGroups = "tab",
			args = {
				BarsSettings = {
					name = "Bars",
					type = "group",
					order = 2,
					args = {
						TopTextureSettings = {
							name = "Bars Top Texture Settings",
							type = "group",
							order = 1,
							guiInline = true,
							args = {
								TopBarTextureToggle = {
									name = "Enable",
									desc = "Whether you want to show the top Bar Texture or not.",
									type = "toggle",
									get = function() return db.Bars.TopTexture.Enable end,
									set = function(self,TopBarTextureToggle)
											db.Bars.TopTexture.Enable = not db.Bars.TopTexture.Enable
											ShowTopBarTexture()
										end,
									order = 1,
								},
								TopBarTextureAlpha = {
									name = "Alpha",
									desc = "Choose your Bar Top Texture Alpha Value!\n Default: "..LUI.defaults.profile.Bars.TopTexture.Alpha,
									type = "range",
									disabled = function() return not db.Bars.TopTexture.Enable end,
									min = 0,
									max = 1,
									step = 0.1,
									get = function() return db.Bars.TopTexture.Alpha end,
									set = function(_, TopBarTextureAlpha) 
											db.Bars.TopTexture.Alpha = TopBarTextureAlpha
											TopBarTextureSetAlpha()
										end,
									order = 2,
								},
								TopBarTextureXOffset = {
									name = "X Offset",
									desc = "Choose an X Offset for your Top Bar Texture.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.Bars.TopTexture.X,
									type = "input",
									disabled = function() return not db.Bars.TopTexture.Enable end,
									get = function() return db.Bars.TopTexture.X end,
									set = function(self,TopBarTextureXOffset)
												if TopBarTextureXOffset == nil or TopBarTextureXOffset == "" then
													TopBarTextureXOffset = db.Bars.TopTexture.X
													print("Please try again...")
												end
												db.Bars.TopTexture.X = TopBarTextureXOffset
												TopBarTextureSetPoint()
											end,
									order = 3,
								},
								TopBarTextureYOffset = {
									name = "Y Offset",
									desc = "Choose an Y Offset for your Top Bar Texture.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.Bars.TopTexture.Y,
									type = "input",
									get = function() return db.Bars.TopTexture.Y end,
									disabled = function() return not db.Bars.TopTexture.Enable end,
									set = function(self,TopBarTextureYOffset)
											if TopBarTextureYOffset == nil or TopBarTextureYOffset == "" then
												TopBarTextureYOffset = db.Bars.TopTexture.Y
												print("Please try again...")
											end
											db.Bars.TopTexture.Y = TopBarTextureYOffset
											TopBarTextureSetPoint()
										end,
									order = 4,
								},
							},
						},
						empty232233411 = {
							name = "   ",
							type = "description",
							order = 2,
						},
						TopBarAnimation = {
							name = "Bar Animation",
							type = "group",
							guiInline = true,
							disabled = function() return not isForteCooldownLoaded end,
							order = 3,
							args = {
								TopBarAnimationDesc = {
									name = "This Feature will be only available if you are using FortExorcist CooldownTimer.",
									type = "description",
									order = 1,
								},
								empty23223342211 = {
									name = "   ",
									type = "description",
									order = 2,
								},
								TopBarTextureAnimation = {
									name = "Enable Bar Texture Animation",
									desc = "Whether you want to show the Bar Texture Animation or not.\n",
									type = "toggle",
									disabled = function() return not db.Bars.TopTexture.Enable end,
									width = "full",
									get = function() return db.Bars.TopTexture.Animation end,
									set = function()
											db.Bars.TopTexture.Animation = not db.Bars.TopTexture.Animation
										end,
									order = 3,
								},
								TopBarAnimationHeight = {
									name = "Bar Texture Animation Height",
									desc = "Choose the Animation Height for your Bar Texture.\nDefault: "..LUI.defaults.profile.Bars.TopTexture.AnimationHeight,
									type = "input",
									disabled = function() return not db.Bars.TopTexture.Enable end,
									get = function() return db.Bars.TopTexture.AnimationHeight end,
									set = function(self,TopBarAnimationHeight)
											if TopBarAnimationHeight == nil or TopBarAnimationHeight == "" then
												TopBarAnimationHeight = db.Bars.TopTexture.AnimationHeight
												print("Please try again...")
											end
											db.Bars.TopTexture.AnimationHeight = TopBarAnimationHeight
										end,
									order = 4,
								},
							},
						},
						empty2322334 = {
							name = "   ",
							type = "description",
							order = 4,
						},
						BottomTextureSettings = {
							name = "Bars Bottom Texture Settings",
							type = "group",
							guiInline = true,
							order = 5,
							args = {
								BottomBarTextureToggle = {
									name = "Enable",
									desc = "Whether you want to show the bottom Bar Texture or not.\n",
									type = "toggle",
									get = function() return db.Bars.BottomTexture.Enable end,
									set = function(self,BottomBarTextureToggle)
											db.Bars.BottomTexture.Enable = not db.Bars.BottomTexture.Enable
											ShowBottomBarTexture()
										end,
									order = 1,
								},
								BottomBarTextureAlpha = {
									name = "Alpha",
									desc = "Choose your Bar Top Texture Alpha Value!\n Default: "..LUI.defaults.profile.Bars.BottomTexture.Alpha,
									type = "range",
									disabled = function() return not db.Bars.BottomTexture.Enable end,
									min = 0,
									max = 1,
									step = 0.1,
									get = function() return db.Bars.BottomTexture.Alpha end,
									set = function(_, BottomBarTextureAlpha) 
											db.Bars.BottomTexture.Alpha = BottomBarTextureAlpha
											BottomBarTextureSetAlpha()
										end,
									order = 2,
								},
								BottomBarTextureXOffset = {
									name = "X Offset",
									desc = "Choose an X Offset for your Bottom Bar Texture.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.Bars.BottomTexture.X,
									type = "input",
									disabled = function() return not db.Bars.BottomTexture.Enable end,
									get = function() return db.Bars.BottomTexture.X end,
									set = function(self,BottomBarTextureXOffset)
												if BottomBarTextureXOffset == nil or BottomBarTextureXOffset == "" then
													BottomBarTextureXOffset = db.Bars.BottomTexture.X
													print("Please try again...")
												end
												db.Bars.BottomTexture.X = BottomBarTextureXOffset
												BottomBarTextureSetPoint()
											end,
									order = 3,
								},
								BottomBarTextureYOffset = {
									name = "Y Offset",
									desc = "Choose an Y Offset for your Bottom Bar Texture.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.Bars.BottomTexture.Y,
									type = "input",
									disabled = function() return not db.Bars.BottomTexture.Enable end,
									get = function() return db.Bars.BottomTexture.Y end,
									set = function(self,BottomBarTextureYOffset)
											if BottomBarTextureYOffset == nil or BottomBarTextureYOffset == "" then
												BottomBarTextureYOffset = db.Bars.BottomTexture.Y
												print("Please try again...")
											end
											db.Bars.BottomTexture.Y = BottomBarTextureYOffset
											BottomBarTextureSetPoint()
										end,
									order = 4,
								},
							},
						},
					},
				},
				SidebarRight = {
					name = "Right Sidebar",
					type = "group",
					order = 3,
					args = {
						SidebarRightEnable = {
							name = "Enabled",
							desc = "Whether you want to show the right Sidebar or not.\n",
							type = "toggle",
							get = function() return db.Bars.SidebarRight.Enable end,
							set = function(self,SidebarRightEnable)
									db.Bars.SidebarRight.Enable = SidebarRightEnable
									StaticPopup_Show("RELOAD_UI")
								end,
							order = 1,
						},
						Settings = {
							name = "Anchor",
							type = "group",
							order = 2,
							disabled = function() return not db.Bars.SidebarRight.Enable end,
							guiInline = true,
							args = {
								Intro = {
									order = 1,
									width = "full",
									type = "description",
									name = "Which Bar should be your right Sidebar?\nChoose one or type in the MainAnchor manually.\n\nMake sure your Bar is set to 6 buttons/2 columns.\nLUI will position your Bar automatically.",
								},
								spacer = {
									order = 2,
									width = "full",
									type = "description",
									name = " "
								},
								FrameModifierDesc = {
									order = 3,
									width = "full",
									type = "description",
									name = "Use the LUI Frame Identifier to search for the Parent Frame of your Bar.\n\nOr use the Blizzard Debug Tool: Type /framestack"
								},
								LUIFrameIdentifier = {
									order = 4,
									type = "execute",
									name = "LUI Frame Identifier",
									func = function()
										LUI_Frame_Identifier:Show()
									end,
								},
								spacer2 = {
									order = 5,
									width = "full",
									type = "description",
									name = ""
								},
								SidebarRightAnchorDropDown = {
									name = "Bar",
									desc = "Choose the Bar for your Right Sidebar.\nDefault: "..LUI.defaults.profile.Bars.SidebarRight.Anchor,
									type = "select",
									values = barAnchors,
									get = function()
											for k, v in pairs(barAnchors) do
												if db.Bars.SidebarRight.Anchor == v then
													return k
												end
											end
										end,
									set = function(self, SidebarRightAnchorDropDown)
											db.Bars.SidebarRight.Anchor = barAnchors[SidebarRightAnchorDropDown]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 6,
								},
								SidebarRightAnchor = {
									name = "Individual Bar",
									desc = "Choose the Bar for your Right Sidebar.\nDefault: "..LUI.defaults.profile.Bars.SidebarRight.Anchor,
									type = "input",
									get = function() return db.Bars.SidebarRight.Anchor end,
									set = function(self,SidebarRightAnchor)
											if SidebarRightAnchor == nil or SidebarRightAnchor == "" then
												SidebarRightAnchor = db.Bars.SidebarRight.Anchor
												print("Please try again...")
											end
											db.Bars.SidebarRight.Anchor = SidebarRightAnchor
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 7,
								},
								AdditionalFrames = {
									name = "Additional Frames",
									desc = "Type in any additional frame names (separated by commas)\nthat you would like to show/hide with the Right Sidebar.",
									type = "input",
									width = "double",
									get = function() return db.Bars.SidebarRight.Additional end,
									set = function(self, AdditionalFrames)
											db.Bars.SidebarRight.Additional = AdditionalFrames
											Panels:LoadAdditional(db.Bars.SidebarRight.Additional, true)
										end,
									order = 7.5,
								},
								SidebarRightXOffset = {
									name = "Bar Anchor X Offset",
									desc = "LUI will position your choosen Bar automatically but you can adjust this position here.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.Bars.SidebarRight.X,
									type = "input",
									disabled = function() return not db.Bars.SidebarRight.AutoPosEnable end,
									get = function() return db.Bars.SidebarRight.X end,
									set = function(self,SidebarRightXOffset)
											if SidebarRightXOffset == nil or SidebarRightXOffset == "" then
												SidebarRightXOffset = db.Bars.SidebarRight.X
												print("Please try again...")
											end
											db.Bars.SidebarRight.X = SidebarRightXOffset
											SetRightSidebarAnchor()
										end,
									order = 8,
								},
								SidebarRightYOffset = {
									name = "Bar Anchor Y Offset",
									desc = "LUI will position your choosen Bar automatically but you can adjust this position here.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.Bars.SidebarRight.Y,
									type = "input",
									disabled = function() return not db.Bars.SidebarRight.AutoPosEnable end,
									get = function() return db.Bars.SidebarRight.Y end,
									set = function(self,SidebarRightYOffset)
											if SidebarRightYOffset == nil or SidebarRightYOffset == "" then
												SidebarRightYOffset = db.Bars.SidebarRight.Y
												print("Please try again...")
											end
											db.Bars.SidebarRight.Y = SidebarRightYOffset
											SetRightSidebarAnchor()
										end,
									order = 9,
								},
								SidebarRightAutoPos = {
									name = "Stop touching me!",
									desc = "Whether you want that LUI handles your Bar Positioning or not.\n",
									type = "toggle",
									get = function() return not db.Bars.SidebarRight.AutoPosEnable end,
									set = function(self,SidebarRightAutoPos)
											db.Bars.SidebarRight.AutoPosEnable = not SidebarRightAutoPos
											
											if db.Bars.SidebarRight.AutoPosEnable == true then
												SetRightSidebarAnchor()
											end
										end,
									order = 10,
								},
							},
						},
						spacer = {
							order = 3,
							width = "full",
							type = "description",
							name = " "
						},
						AddOptions = {
							name = "Additional Options",
							type = "group",
							order = 4,
							disabled = function() return not db.Bars.SidebarRight.Enable end,
							guiInline = true,
							args = {
								SidebarRightOffset = {
									name = "Sidebar Y Offset",
									desc = "Y Offset from the middle-right position.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.Bars.SidebarRight.Offset,
									type = "input",
									get = function() return db.Bars.SidebarRight.Offset end,
									set = function(self,SidebarRightOffset)
											if SidebarRightOffset == nil or SidebarRightOffset == "" then
												SidebarRightOffset = db.Bars.SidebarRight.Offset
												print("Please try again...")
											end
											db.Bars.SidebarRight.Offset = SidebarRightOffset
											fsidebar_anchor:SetPoint("RIGHT", UIParent, "RIGHT", 11, SidebarRightOffset)
											SetRightSidebarAnchor()
										end,
									order = 1,
								},
								SidebarRightOpenAnimation = {
									name = "Open Instant",
									desc = "Whether you want to show an open/close animation or not.\n",
									type = "toggle",
									get = function() return db.Bars.SidebarRight.OpenInstant end,
									set = function()
												db.Bars.SidebarRight.OpenInstant = not db.Bars.SidebarRight.OpenInstant
											end,
									order = 2,
								},
							},
						},
						spacer2 = {
							order = 5,
							width = "full",
							type = "description",
							name = " "
						},
					},
				},
				SidebarLeft = {
					name = "Left Sidebar",
					type = "group",
					order = 4,
					args = {
						SidebarLeftEnable = {
							name = "Enabled",
							desc = "Whether you want to show the right Sidebar or not.\n\nOnEnable you will have to reposition your PartyFrame",
							type = "toggle",
							get = function() return db.Bars.SidebarLeft.Enable end,
							set = function(self,SidebarLeftEnable)
									db.Bars.SidebarLeft.Enable = SidebarLeftEnable
									StaticPopup_Show("RELOAD_UI")
								end,
							order = 1,
						},
						Settings = {
							name = "Settings",
							type = "group",
							order = 2,
							disabled = function() return not db.Bars.SidebarLeft.Enable end,
							guiInline = true,
							args = {
								Intro = {
									order = 1,
									width = "full",
									type = "description",
									name = "Which Bar should be your left Sidebar?\nChoose one or type in the MainAnchor manually.\n\nMake sure your Bar is set to 6 buttons/2 columns.\nLUI will position your Bar automatically.",
								},
								spacer = {
									order = 2,
									width = "full",
									type = "description",
									name = " "
								},
								FrameModifierDesc = {
									order = 3,
									width = "full",
									type = "description",
									name = "Use the LUI Frame Identifier to search for the Parent Frame of your Bar.\n\nOr use the Blizzard Debug Tool: Type /framestack"
								},
								LUIFrameIdentifier = {
									order = 4,
									type = "execute",
									name = "LUI Frame Identifier",
									func = function()
										LUI_Frame_Identifier:Show()
									end,
								},
								spacer2 = {
									order = 5,
									width = "full",
									type = "description",
									name = ""
								},
								SidebarLeftAnchorDropDown = {
									name = "Bar",
									desc = "Choose the Bar for your Left Sidebar.\nDefault: "..LUI.defaults.profile.Bars.SidebarLeft.Anchor,
									type = "select",
									values = barAnchors,
									get = function()
											for k, v in pairs(barAnchors) do
												if db.Bars.SidebarLeft.Anchor == v then
													return k
												end
											end
										end,
									set = function(self, SidebarLeftAnchorDropDown)
											db.Bars.SidebarLeft.Anchor = barAnchors[SidebarLeftAnchorDropDown]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 6,
								},
								SidebarLeftAnchor = {
									name = "Individual Bar",
									desc = "Choose the Bar for your Left Sidebar\nDefault: "..LUI.defaults.profile.Bars.SidebarLeft.Anchor,
									type = "input",
									get = function() return db.Bars.SidebarLeft.Anchor end,
									set = function(self,SidebarLeftAnchor)
											if SidebarLeftAnchor == nil or SidebarLeftAnchor == "" then
												SidebarLeftAnchor = db.Bars.SidebarLeft.Anchor
											end
											db.Bars.SidebarLeft.Anchor = SidebarLeftAnchor
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 7,
								},
								AdditionalFrames = {
									name = "Additional Frames",
									desc = "Type in any additional frame names (separated by commas)\nthat you would like to show/hide with the Right Sidebar.",
									type = "input",
									width = "double",
									get = function() return db.Bars.SidebarLeft.Additional end,
									set = function(self, AdditionalFrames)
											db.Bars.SidebarLeft.Additional = AdditionalFrames
											Panels:LoadAdditional(db.Bars.SidebarLeft.Additional, true)
										end,
									order = 7.5,
								},
								SidebarLeftXOffset = {
									name = "Bar Anchor X Offset",
									desc = "LUI will position your choosen Bar automatically but you can adjust this position here.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.Bars.SidebarLeft.X,
									type = "input",
									disabled = function() return not db.Bars.SidebarLeft.AutoPosEnable end,
									get = function() return db.Bars.SidebarLeft.X end,
									set = function(self,SidebarLeftXOffset)
											if SidebarLeftXOffset == nil or SidebarLeftXOffset == "" then
												SidebarLeftXOffset = db.Bars.SidebarLeft.X
												print("Please try again...")
											end
											db.Bars.SidebarLeft.X = SidebarLeftXOffset
											SetLeftSidebarAnchor()
										end,
									order = 8,
								},
								SidebarLeftYOffset = {
									name = "Bar Anchor Y Offset",
									desc = "LUI will position your choosen Bar automatically but you can adjust this position here.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.Bars.SidebarLeft.Y,
									type = "input",
									disabled = function() return not db.Bars.SidebarLeft.AutoPosEnable end,
									get = function() return db.Bars.SidebarLeft.Y end,
									set = function(self,SidebarLeftYOffset)
											if SidebarLeftYOffset == nil or SidebarLeftYOffset == "" then
												SidebarLeftYOffset = db.Bars.SidebarLeft.Y
												print("Please try again...")
											end
											db.Bars.SidebarLeft.Y = SidebarLeftYOffset
											SetLeftSidebarAnchor()
										end,
									order = 9,
								},
								SidebarLeftAutoPos = {
									name = "Stop touching me!",
									desc = "Whether you want that LUI handles your Bar Positioning or not.\n",
									type = "toggle",
									get = function() return not db.Bars.SidebarLeft.AutoPosEnable end,
									set = function(self,SidebarLeftAutoPos)
											db.Bars.SidebarLeft.AutoPosEnable = not SidebarLeftAutoPos
											
											if db.Bars.SidebarLeft.AutoPosEnable == true then
												SetLeftSidebarAnchor()
											end
										end,
									order = 10,
								},
							},
						},
						spacer = {
							order = 3,
							width = "full",
							type = "description",
							name = " "
						},
						AddOptions = {
							name = "Additional Options",
							type = "group",
							order = 4,
							disabled = function() return not db.Bars.SidebarLeft.Enable end,
							guiInline = true,
							args = {
								SidebarLeftOffset = {
									name = "Y Offset",
									desc = "Y Offset from the middle-left position.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.Bars.SidebarLeft.Offset,
									type = "input",
									get = function() return db.Bars.SidebarLeft.Offset end,
									set = function(self,SidebarLeftOffset)
											if SidebarLeftOffset == nil or SidebarLeftOffset == "" then
												SidebarLeftOffset = db.Bars.SidebarLeft.Offset
												print("Please try again...")
											end
											db.Bars.SidebarLeft.Offset = SidebarLeftOffset
											fsidebar2_anchor:SetPoint("LEFT", UIParent, "LEFT", -11, SidebarLeftOffset)
											SetLeftSidebarAnchor()
										end,
									order = 1,
								},
								SidebarLeftOpenAnimation = {
									name = "Open Instant",
									desc = "Whether you want to show an open/close animation or not.\n",
									type = "toggle",
									get = function() return db.Bars.SidebarLeft.OpenInstant end,
									set = function()
												db.Bars.SidebarLeft.OpenInstant = not db.Bars.SidebarLeft.OpenInstant
											end,
									order = 2,
								},
							},
						},
						spacer2 = {
							order = 5,
							width = "full",
							type = "description",
							name = " "
						},
					},
				},
			},
		},
	}

	return options
end

function module:OnInitialize()
	LUI:MergeDefaults(LUI.db.defaults.profile, defaults)
	LUI:RefreshDefaults()
	LUI:Refresh()
	
	self.db = LUI.db.profile
	db = self.db
	
	LUI:RegisterOptions(self)
end

function module:OnEnable()
	module:SetBars()
end

function module:OnDisable()
end

local CombatCheck = CreateFrame("Frame", "CombatCheck", UIParent)

CombatCheck:RegisterEvent("PLAYER_REGEN_DISABLED")
CombatCheck:RegisterEvent("PLAYER_REGEN_ENABLED")

CombatCheck:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_DISABLED" then
		isLocked = true
	elseif event == "PLAYER_REGEN_ENABLED" then
		isLocked = false
	end
end)