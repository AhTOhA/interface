local LSM = LibStub("LibSharedMedia-3.0")
local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local db = LUI.db.profile

if db == nil then return end
if db.oUF.Settings.Enable ~= true then return end

local highlight = true

------------------------------------------------------------------------
--	Textures and Medias
------------------------------------------------------------------------

local mediaPath = [=[Interface\Addons\oUF_LUI\media\]=]

local floor = math.floor
local format = string.format

local normTex = mediaPath..[=[textures\normTex]=]
local glowTex = mediaPath..[=[textures\glowTex]=]
local bubbleTex = mediaPath..[=[textures\bubbleTex]=]
local buttonTex = mediaPath..[=[textures\buttonTex]=]
local highlightTex = mediaPath..[=[textures\highlightTex]=]
local borderTex = mediaPath..[=[textures\border]=]
local blankTex = mediaPath..[=[textures\blank]=]

local backdrop = {
	bgFile = blankTex,
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local backdrop2 = {
	bgFile = blankTex,
	edgeFile = blankTex, 
	tile = false, tileSize = 0, edgeSize = 1, 
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local font = [=[Interface\Addons\LUI\media\fonts\vibrocen.ttf]=]
local fontn = mediaPath..[=[fonts\KhmerUI.ttf]=]
local font2 = [=[Fonts\ARIALN.ttf]=]
local font3 = [=[Interface\Addons\LUI\media\fonts\Prototype.ttf]=]
local _, class = UnitClass("player")

------------------------------------------------------------------------
--	Colors
------------------------------------------------------------------------

local colors = oUF_LUI.colors

------------------------------------------------------------------------
--	Don't edit this if you don't know what you are doing!
------------------------------------------------------------------------

local menu = function(self)
	local unit = self.unit:gsub("(.)", string.upper, 1) 
	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif (self.unit:match("party")) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end

local SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

local ShortValue = function(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local UnitFrame_OnEnter = function(self)
	UnitFrame_OnEnter(self)
	if highlight then
		self.Highlight:Show()	
	end
end

local UnitFrame_OnLeave = function(self)
	UnitFrame_OnLeave(self)
	if highlight then
		self.Highlight:Hide()	
	end
end

local PostUpdateHealth = function(health, unit, min, max)
	local pClass, pToken = UnitClass(unit)
	local color = colors.class[pToken]
	local r, g, b
	
	r, g, b = oUF.ColorGradient(min/max, unpack(oUF.colors.smooth))
	
	if health.colorClass == true then
		if color then
			health:SetStatusBarColor(color[1], color[2], color[3])
			local mu = health.bg.multiplier or 1
			health.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu)
		else
			health:SetStatusBarColor(0.5, 0.5, 0.5)
			local mu = health.bg.multiplier or 1
			health.bg:SetVertexColor(0.5*mu, 0.5*mu, 0.5*mu)
		end
	elseif health.colorIndividual.Enable == true then
		health:SetStatusBarColor(health.colorIndividual.r, health.colorIndividual.g, health.colorIndividual.b)
		local mu = health.bg.multiplier or 1
		health.bg:SetVertexColor(health.colorIndividual.r*mu, health.colorIndividual.g*mu, health.colorIndividual.b*mu)
	elseif health.colorSmooth == true then
		health:SetStatusBarColor(r,g,b)
		local mu = health.bg.multiplier or 1
		health.bg:SetVertexColor(r*mu, g*mu, b*mu)
	end

	if not UnitIsConnected(unit) then
		health:SetValue(0)
		health.valueMissing:SetText()
		
		if health.value.ShowDead == true then
			health.value:SetText("|cffD7BEA5Offline|r")
		else
			health.value:SetText()
		end
		
		if health.valuePercent.ShowDead == true then
			health.valuePercent:SetText("|cffD7BEA5Offline|r")
		else
			health.valuePercent:SetText()
		end
	elseif UnitIsDead(unit) then
		health:SetValue(0)
		health.valueMissing:SetText()
		
		if health.value.ShowDead == true then
			health.value:SetText("|cffD7BEA5Dead|r")
		else
			health.value:SetText()
		end
		
		if health.valuePercent.ShowDead == true then
			health.valuePercent:SetText("|cffD7BEA5Dead|r")
		else
			health.valuePercent:SetText()
		end
	elseif UnitIsGhost(unit) then
		health:SetValue(0)
		health.valueMissing:SetText()
		
		if health.value.ShowDead == true then
			health.value:SetText("|cffD7BEA5Ghost|r")
		else
			health.value:SetText()
		end
		
		if health.valuePercent.ShowDead == true then
			health.valuePercent:SetText("|cffD7BEA5Ghost|r")
		else
			health.valuePercent:SetText()
		end
	else
		local healthPercent = 100 * min / max
		healthPercent = string.format("%.1f", healthPercent)
		healthPercent = healthPercent.."%"
		
		if health.value.Enable == true then
			if min >= 1 then
				if health.value.Format == "Absolut" then
					health.value:SetFormattedText("%s/%s",min,max)
				elseif health.value.Format == "Absolut & Percent" then
					health.value:SetFormattedText("%s/%s | %s",min,max,healthPercent)
				elseif health.value.Format == "Absolut Short" then
					health.value:SetFormattedText("%s/%s",ShortValue(min),ShortValue(max))
				elseif health.value.Format == "Absolut Short & Percent" then
					health.value:SetFormattedText("%s/%s | %s",ShortValue(min),ShortValue(max),healthPercent)
				elseif health.value.Format == "Standard" then
					health.value:SetText(min)
				elseif health.value.Format == "Standard Short" then
					health.value:SetText(ShortValue(min))
				else
					health.value:SetText(min)
				end
				
				if health.value.colorClass == true then
					if color then
						health.value:SetTextColor(color[1], color[2], color[3])
					else
						health.value:SetTextColor(0, 0, 0)
					end
				elseif health.value.colorGradient == true then
					health.value:SetTextColor(r, g, b)
				elseif health.value.colorIndividual.Enable == true then
					health.value:SetTextColor(health.value.colorIndividual.r, health.value.colorIndividual.g, health.value.colorIndividual.b)
				end
			else
				health.value:SetText()
			end
		else
			health.value:SetText()
		end
		
		if health.valuePercent.Enable == true then
			if min ~= max or health.valuePercent.ShowAlways == true then
				health.valuePercent:SetText(healthPercent)
			else
				health.valuePercent:SetText()
			end
			
			if health.valuePercent.colorClass == true then
				if color then
					health.valuePercent:SetTextColor(color[1], color[2], color[3])
				else
					health.valuePercent:SetTextColor(0, 0, 0)
				end
			elseif health.valuePercent.colorGradient == true then
				health.valuePercent:SetTextColor(r, g, b)
			elseif health.valuePercent.colorIndividual.Enable == true then
				health.valuePercent:SetTextColor(health.valuePercent.colorIndividual.r, health.valuePercent.colorIndividual.g, health.valuePercent.colorIndividual.b)
			end
		else
			health.valuePercent:SetText()
		end
		
		if health.valueMissing.Enable == true then
			local healthMissing = max-min
			
			if healthMissing > 0 or health.valueMissing.ShowAlways == true then
				if health.valueMissing.ShortValue == true then
					health.valueMissing:SetText("-"..ShortValue(healthMissing))
				else
					health.valueMissing:SetText("-"..healthMissing)
				end
			else
				health.valueMissing:SetText()
			end
			
			if health.valueMissing.colorClass == true then
				if color then
					health.valueMissing:SetTextColor(color[1], color[2], color[3])
				else
					health.valueMissing:SetTextColor(0, 0, 0)
				end
			elseif health.valueMissing.colorGradient == true then
				health.valueMissing:SetTextColor(r, g, b)
			elseif health.valueMissing.colorIndividual.Enable == true then
				health.valueMissing:SetTextColor(health.valueMissing.colorIndividual.r, health.valueMissing.colorIndividual.g, health.valueMissing.colorIndividual.b)
			end
		else
			health.valueMissing:SetText()
		end
	end
end

local PostUpdatePower = function(power, unit, min, max)
	local _, pType = UnitPowerType(unit)
	local pClass, pToken = UnitClass(unit)
	local color = colors.class[pToken]
	local color2 = colors.power[pType]
	if power.colorClass == true then
		if color then
			power:SetStatusBarColor(color[1], color[2], color[3])
			local mu = power.bg.multiplier or 1
			power.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu)
		else
			if color2 then
				power:SetStatusBarColor(color2[1], color2[2], color2[3])
				local mu = power.bg.multiplier or 1
				power.bg:SetVertexColor(color2[1]*mu, color2[2]*mu, color2[3]*mu)
				else
				power:SetStatusBarColor(0.5, 0.5, 0.5)
				local mu = power.bg.multiplier or 1
				power.bg:SetVertexColor(0.5*mu, 0.5*mu, 0.5*mu)
			end
		end
	elseif power.colorIndividual.Enable == true then
		power:SetStatusBarColor(power.colorIndividual.r, power.colorIndividual.g, power.colorIndividual.b)
		local mu = power.bg.multiplier or 1
		power.bg:SetVertexColor(power.colorIndividual.r*mu, power.colorIndividual.g*mu, power.colorIndividual.b*mu)
	elseif power.colorType == true then
		if color2 then
			power:SetStatusBarColor(color2[1], color2[2], color2[3])
			local mu = power.bg.multiplier or 1
			power.bg:SetVertexColor(color2[1]*mu, color2[2]*mu, color2[3]*mu)
		else
			if color then
				power:SetStatusBarColor(color[1], color[2], color[3])
				local mu = power.bg.multiplier or 1
				power.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu)
			else
				power:SetStatusBarColor(0.5, 0.5, 0.5)
				local mu = power.bg.multiplier or 1
				power.bg:SetVertexColor(0.5*mu, 0.5*mu, 0.5*mu)
			end
		end
	end

	if not UnitIsConnected(unit) then
		power:SetValue(0)
		power.valueMissing:SetText()
		power.valuePercent:SetText()
		power.value:SetText()
	elseif UnitIsDead(unit) then
		power:SetValue(0)
		power.valueMissing:SetText()
		power.valuePercent:SetText()
		power.value:SetText()
	elseif UnitIsGhost(unit) then
		power:SetValue(0)
		power.valueMissing:SetText()
		power.valuePercent:SetText()
		power.value:SetText()
	else
		local powerPercent = 100 * min / max
		powerPercent = string.format("%.1f", powerPercent)
		powerPercent = powerPercent.."%"
	
		if power.value.Enable == true then
			if min >= 1 then
				if power.value.Format == "Absolut" then
					power.value:SetFormattedText("%s/%s",min,max)
				elseif power.value.Format == "Absolut & Percent" then
					power.value:SetFormattedText("%s/%s | %s",min,max,powerPercent)
				elseif power.value.Format == "Absolut Short" then
					power.value:SetFormattedText("%s/%s",ShortValue(min),ShortValue(max))
				elseif power.value.Format == "Absolut Short & Percent" then
					power.value:SetFormattedText("%s/%s | %s",ShortValue(min),ShortValue(max),powerPercent)
				elseif power.value.Format == "Standard" then
					power.value:SetText(min)
				elseif power.value.Format == "Standard Short" then
					power.value:SetText(ShortValue(min))
				else
					power.value:SetText(min)
				end
				
				if power.value.colorClass == true then
					if color then
						power.value:SetTextColor(color[1],color[2],color[3])
					else
						if color2 then
							power.value:SetTextColor(color2[1],color2[2],color2[3])
						else
							power.value:SetTextColor(0, 0, 0)
						end
					end
				elseif power.value.colorType == true then
					if color2 then
						power.value:SetTextColor(color2[1],color2[2],color2[3])
					else
						if color then
							power.value:SetTextColor(color[1],color[2],color[3])
						else
							power.value:SetTextColor(0, 0, 0)
						end
					end
				elseif power.value.colorIndividual.Enable == true then
					power.value:SetTextColor(power.value.colorIndividual.r, power.value.colorIndividual.g, power.value.colorIndividual.b)
				end
			else
				power.value:SetText()
			end
		else
			power.value:SetText()
		end
		
		if power.valuePercent.Enable == true then
			if min ~=max or power.valuePercent.howAlways == true then
				power.valuePercent:SetText(powerPercent)
			else
				power.valuePercent:SetText()
			end
			
			if power.valuePercent.colorClass == true then
				if color then
					power.valuePercent:SetTextColor(color[1],color[2],color[3])
				else
					if color2 then
						power.valuePercent:SetTextColor(color2[1],color2[2],color2[3])
					else
						power.valuePercent:SetTextColor(0, 0, 0)
					end
				end
			elseif power.valuePercent.colorType == true then
				if color2 then
					power.valuePercent:SetTextColor(color2[1],color2[2],color2[3])
				else
					if color then
						power.valuePercent:SetTextColor(color[1],color[2],color[3])
					else
						power.valuePercent:SetTextColor(0, 0, 0)
					end
				end
			elseif power.valuePercent.colorIndividual.Enable == true then
				power.valuePercent:SetTextColor(power.valuePercent.colorIndividual.r, power.valuePercent.colorIndividual.g, power.valuePercent.colorIndividual.b)
			end
		else
			power.valuePercent:SetText()
		end
		
		if power.valueMissing.Enable == true then
			local powerMissing = max-min
			
			if powerMissing > 0 or power.valueMissing.ShowAlways == true then
				if power.valueMissing.ShortValue == true then
					power.valueMissing:SetText("-"..ShortValue(powerMissing))
				else
					power.valueMissing:SetText("-"..powerMissing)
				end
			else
				power.valueMissing:SetText()
			end
			
			if power.valueMissing.colorClass == true then
				if color then
					power.valueMissing:SetTextColor(color[1],color[2],color[3])
				else
					if color2 then
						power.valueMissing:SetTextColor(color2[1],color2[2],color2[3])
					else
						power.valueMissing:SetTextColor(0, 0, 0)
					end
				end
			elseif power.valueMissing.colorType == true then
				if color2 then
					power.valueMissing:SetTextColor(color2[1],color2[2],color2[3])
				else
					if color then
						power.valueMissing:SetTextColor(color[1],color[2],color[3])
					else
						power.valueMissing:SetTextColor(0, 0, 0)
					end
				end
			elseif power.valueMissing.colorIndividual.Enable == true then
				power.valueMissing:SetTextColor(power.valueMissing.colorIndividual.r, power.valueMissing.colorIndividual.g, power.valueMissing.colorIndividual.b)
			end
		else
			power.valueMissing:SetText()
		end
	end
end

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 1)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 1)), s % hour
	elseif s >= minute then
		if s <= minute * 1 then
			return format('%d:%02d', floor(s/60), s % minute), s - floor(s)
		end
		return format("%dm", floor(s/minute + 1)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 1), s - floor(s)
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end

local CreateAuraTimer = function(self,elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)

				self.remaining:SetTextColor(1, 1, 1)
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

local CancelAura = function(self, button)
	if button == "RightButton" and not self.debuff then
		--CancelUnitBuff("player", self:GetID())
	end
end

local PostCreateAura = function(element, button)
	button.backdrop = CreateFrame("Frame", nil, button)
	button.backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3.5, 3)
	button.backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -3.5)
	button.backdrop:SetFrameStrata("BACKGROUND")
	button.backdrop:SetBackdrop {
		edgeFile = glowTex, edgeSize = 5,
		insets = {left = 3, right = 3, top = 3, bottom = 3}
	}
	button.backdrop:SetBackdropColor(0, 0, 0, 0)
	button.backdrop:SetBackdropBorderColor(0, 0, 0)

	button.count:SetPoint("BOTTOMRIGHT", -1, 2)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(font3, 16, "OUTLINE")
	button.count:SetTextColor(0.84, 0.75, 0.65)
	
	button.remaining = SetFontString(button, LSM:Fetch("font", db.oUF.Settings.Auras.auratimer_font), db.oUF.Settings.Auras.auratimer_size, db.oUF.Settings.Auras.auratimer_flag)
	button.remaining:SetPoint("TOPLEFT", 1, -1)
	
	button.cd.noOCC = true
	button.cd.noCooldownCount = true

	button.overlay:SetTexture(buttonTex)
	button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
	button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
	button.overlay:SetTexCoord(0, 1, 0.02, 1)
	button.overlay.Hide = function(self) end
end

local PostUpdateAura = function(icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
	if unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle" then
		if icon.debuff then
			if icons.colorByType == false then
				icon.overlay:SetVertexColor(0.69, 0.31, 0.31)
			end
		else
			icon.overlay:SetVertexColor(1, 1, 1)
		end
	else
		if UnitIsEnemy("player", unit) then
			if icon.debuff then
				icon.icon:SetDesaturated(true)
			end
		else
			if icon.debuff then
				if icons.colorByType == false then
					icon.overlay:SetVertexColor(0.69, 0.31, 0.31)
				end
			else
				icon.overlay:SetVertexColor(1, 1, 1)
			end
		end
		--icon.overlay:SetVertexColor(1, 1, 1)
	end

	if duration and duration > 0 then
		if icons.showAuratimer then
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end	else
		icon.remaining:Hide()
	end
	
	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	--icon:SetScript("OnUpdate", CreateAuraTimer)
	icons.disableCooldown = true
	icon.remaining:Hide()
	icon.timeLeft = false
	icon.duration = false
end

local ThreatOverride = function(self, event, unit)
	if(unit ~= self.unit) then return end

	unit = unit or self.unit
	local status = UnitThreatSituation(unit)

	if(status and status > 0) and self.Threat.Enable == true then
		local r, g, b = GetThreatStatusColor(status)
		--self.Threat:SetBackdropColor(r, g, b)
		self.Threat:SetBackdropBorderColor(r, g, b)
		self.Threat:Show()
	else
		self.Threat:Hide()
	end
end

------------------------------------------------------------------------
--	Layout Style
------------------------------------------------------------------------

local function SetStyle(self, unit)
	local oufdb
	
	if unit == "raid" then
		oufdb = db.oUF.Maintank
	elseif unit == "raidtarget" then
		oufdb = db.oUF.MaintankTarget
	elseif unit == "raidtargettarget" then
		oufdb = db.oUF.MaintankToT
	end
	
	self.menu = menu
	self.colors = colors
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.MoveableFrames = true
	
	self:SetAttribute('*type2', 'menu')

	self.Health = CreateFrame("StatusBar", self:GetName().."_Health", self)
	self.Power = CreateFrame("StatusBar", self:GetName().."_Power", self)
	self.Full = CreateFrame("StatusBar", self:GetName().."_Full", self)
	
	if unit then
		self.Health:SetFrameLevel(2)
	elseif self:GetAttribute("unitsuffix") then
		self.Health:SetFrameLevel(2)
	elseif not unit then
		self.Health:SetFrameLevel(2)
	end
	
	------------------------------------------------------------------------
	--	Width/Height
	------------------------------------------------------------------------
	
	--self:SetHeight(tonumber(oufdb.Height))
	--self:SetWidth(tonumber(oufdb.Width))
	
	self.Health:SetHeight(tonumber(oufdb.Health.Height))
	self.Power:SetHeight(tonumber(oufdb.Power.Height))
	self.Full:SetHeight(tonumber(oufdb.Full.Height))
	
	if oufdb.Power.Enable == false then
		self.Power:Hide()
	end
	
	if oufdb.Full.Enable == false then
		self.Full:Hide()
	end
	
	------------------------------------------------------------------------
	--	Position
	------------------------------------------------------------------------
	
	if unit == "raidtarget" or unit == "raidtargettarget" then
		self:SetPoint(oufdb.Point, self:GetParent(), oufdb.RelativePoint, tonumber(oufdb.X), tonumber(oufdb.Y))
	end
	
	self.Health:SetPoint("TOPLEFT", 0, tonumber(oufdb.Health.Padding))
	self.Health:SetPoint("TOPRIGHT", 0, tonumber(oufdb.Health.Padding))
	
	self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, tonumber(oufdb.Power.Padding))
	self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, tonumber(oufdb.Power.Padding))
	
	self.Full:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, tonumber(oufdb.Full.Padding))
	self.Full:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, tonumber(oufdb.Full.Padding))

	------------------------------------------------------------------------
	--	Textures
	------------------------------------------------------------------------
	
	self.Health:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.Health.Texture))
	self.Power:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.Power.Texture))
	
	self.Full:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.Full.Texture))
	self.Full:SetStatusBarColor(tonumber(oufdb.Full.Color.r), tonumber(oufdb.Full.Color.g), tonumber(oufdb.Full.Color.b), tonumber(oufdb.Full.Color.a))
	self.Full:SetValue(100)
	self.Full:SetAlpha(oufdb.Full.Alpha)
	
	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture(LSM:Fetch("statusbar", oufdb.Health.TextureBG))
	self.Health.bg:SetAlpha(tonumber(oufdb.Health.BGAlpha))
	self.Health.bg.multiplier = tonumber(oufdb.Health.BGMultiplier)
	
	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.bg:SetTexture(LSM:Fetch("statusbar", oufdb.Power.TextureBG))
	self.Power.bg:SetAlpha(tonumber(oufdb.Power.BGAlpha))
	self.Power.bg.multiplier = tonumber(oufdb.Power.BGMultiplier)
		
	------------------------------------------------------------------------
	--	Texts
	------------------------------------------------------------------------
	
	self.Info = SetFontString(self.Health, LSM:Fetch("font", oufdb.Texts.Name.Font), tonumber(oufdb.Texts.Name.Size), oufdb.Texts.Name.Outline)
	self.Info:SetPoint(oufdb.Texts.Name.Point, self, oufdb.Texts.Name.RelativePoint, tonumber(oufdb.Texts.Name.X), tonumber(oufdb.Texts.Name.Y))
	for k, v in pairs(oufdb.Texts.Name) do
		self.Info[k] = v
	end
	self:FormatName()
	
	if oufdb.Texts.Name.Enable == false then
		self.Info:Hide()
	end
	
	self.Health.value = SetFontString(self.Health, LSM:Fetch("font", oufdb.Texts.Health.Font), tonumber(oufdb.Texts.Health.Size), oufdb.Texts.Health.Outline)
	self.Health.value:SetPoint(oufdb.Texts.Health.Point, self, oufdb.Texts.Health.RelativePoint, tonumber(oufdb.Texts.Health.X), tonumber(oufdb.Texts.Health.Y))
	
	if oufdb.Texts.Health.Enable == false then
		self.Health.value:Hide()
	end
	
	self.Health.valuePercent = SetFontString(self.Health, LSM:Fetch("font", oufdb.Texts.HealthPercent.Font), tonumber(oufdb.Texts.HealthPercent.Size), oufdb.Texts.HealthPercent.Outline)
	self.Health.valuePercent:SetPoint(oufdb.Texts.HealthPercent.Point, self, oufdb.Texts.HealthPercent.RelativePoint, tonumber(oufdb.Texts.HealthPercent.X), tonumber(oufdb.Texts.HealthPercent.Y))
	
	if oufdb.Texts.HealthPercent.Enable == false then
		self.Health.valuePercent:Hide()
	end
	
	self.Health.valueMissing = SetFontString(self.Health, LSM:Fetch("font", oufdb.Texts.HealthMissing.Font), tonumber(oufdb.Texts.HealthMissing.Size), oufdb.Texts.HealthMissing.Outline)
	self.Health.valueMissing:SetPoint(oufdb.Texts.HealthMissing.Point, self, oufdb.Texts.HealthMissing.RelativePoint, tonumber(oufdb.Texts.HealthMissing.X), tonumber(oufdb.Texts.HealthMissing.Y))
	
	if oufdb.Texts.HealthMissing.Enable == false then
		self.Health.valueMissing:Hide()
	end
	
	self.Power.value = SetFontString(self.Power, LSM:Fetch("font", oufdb.Texts.Power.Font), tonumber(oufdb.Texts.Power.Size), oufdb.Texts.Power.Outline)
	self.Power.value:SetPoint(oufdb.Texts.Power.Point, self, oufdb.Texts.Power.RelativePoint, tonumber(oufdb.Texts.Power.X), tonumber(oufdb.Texts.Power.Y))
	
	if oufdb.Texts.Power.Enable == false then
		self.Power.value:Hide()
	end
	
	self.Power.valuePercent = SetFontString(self.Power, LSM:Fetch("font", oufdb.Texts.PowerPercent.Font), tonumber(oufdb.Texts.PowerPercent.Size), oufdb.Texts.PowerPercent.Outline)
	self.Power.valuePercent:SetPoint(oufdb.Texts.PowerPercent.Point, self, oufdb.Texts.PowerPercent.RelativePoint, tonumber(oufdb.Texts.PowerPercent.X), tonumber(oufdb.Texts.PowerPercent.Y))
	
	if oufdb.Texts.PowerPercent.Enable == false then
		self.Power.valuePercent:Hide()
	end
	
	self.Power.valueMissing = SetFontString(self.Power, LSM:Fetch("font", oufdb.Texts.PowerMissing.Font), tonumber(oufdb.Texts.PowerMissing.Size), oufdb.Texts.PowerMissing.Outline)
	self.Power.valueMissing:SetPoint(oufdb.Texts.PowerMissing.Point, self, oufdb.Texts.PowerMissing.RelativePoint, tonumber(oufdb.Texts.PowerMissing.X), tonumber(oufdb.Texts.PowerMissing.Y))
	
	if oufdb.Texts.PowerMissing.Enable == false then
		self.Power.valueMissing:Hide()
	end
		
	------------------------------------------------------------------------
	--	Icons
	------------------------------------------------------------------------
	
	if oufdb.Icons.Raid.Enable == true then
		self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetHeight(oufdb.Icons.Raid.Size)
		self.RaidIcon:SetWidth(oufdb.Icons.Raid.Size)
		self.RaidIcon:SetPoint(oufdb.Icons.Raid.Point, self, oufdb.Icons.Raid.Point, oufdb.Icons.Raid.X, oufdb.Icons.Raid.Y)
	end
	
	if unit == "raid" then
		if oufdb.Icons.Leader.Enable == true then
			self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
			self.Leader:SetHeight(tonumber(oufdb.Icons.Leader.Size))
			self.Leader:SetWidth(tonumber(oufdb.Icons.Leader.Size))
			self.Leader:SetPoint(oufdb.Icons.Leader.Point, self, oufdb.Icons.Leader.Point, oufdb.Icons.Leader.X, oufdb.Icons.Leader.Y)
			
			self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
			self.Assistant:SetHeight(oufdb.Icons.Leader.Size)
			self.Assistant:SetWidth(oufdb.Icons.Leader.Size)
			self.Assistant:SetPoint(oufdb.Icons.Leader.Point, self, oufdb.Icons.Leader.Point, tonumber(oufdb.Icons.Leader.X), tonumber(oufdb.Icons.Leader.Y))
		end
		
		if oufdb.Icons.Lootmaster.Enable == true then
			self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
			self.MasterLooter:SetHeight(oufdb.Icons.Lootmaster.Size)
			self.MasterLooter:SetWidth(oufdb.Icons.Lootmaster.Size)
			self.MasterLooter:SetPoint(oufdb.Icons.Lootmaster.Point, self, oufdb.Icons.Lootmaster.Point, oufdb.Icons.Lootmaster.X, oufdb.Icons.Lootmaster.Y)
		end
		
		if oufdb.Icons.Role.Enable == true then
			self.LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
			self.LFDRole:SetHeight(oufdb.Icons.Role.Size)
			self.LFDRole:SetWidth(oufdb.Icons.Role.Size)
			self.LFDRole:SetPoint(oufdb.Icons.Role.Point, self, oufdb.Icons.Role.Point, oufdb.Icons.Role.X, oufdb.Icons.Role.Y)
		end
		
		if oufdb.Icons.Resting.Enable == true then
			self.Resting = self.Health:CreateTexture(nil, "OVERLAY")
			self.Resting:SetHeight(oufdb.Icons.Resting.Size)
			self.Resting:SetWidth(oufdb.Icons.Resting.Size)
			self.Resting:SetPoint(oufdb.Icons.Resting.Point, self, oufdb.Icons.Resting.Point, oufdb.Icons.Resting.X, oufdb.Icons.Resting.Y)
		end
		
		if oufdb.Icons.Combat.Enable == true then
			self.Combat = self.Health:CreateTexture(nil, "OVERLAY")
			self.Combat:SetHeight(oufdb.Icons.Combat.Size)
			self.Combat:SetWidth(oufdb.Icons.Combat.Size)
			self.Combat:SetPoint(oufdb.Icons.Combat.Point, self, oufdb.Icons.Combat.Point, oufdb.Icons.Combat.X, oufdb.Icons.Combat.Y)
		end
		
		if oufdb.Icons.PvP.Enable == true then
			self.PvP = self.Health:CreateTexture(nil, "OVERLAY")
			self.PvP:SetHeight(oufdb.Icons.PvP.Size)
			self.PvP:SetWidth(oufdb.Icons.PvP.Size)
			self.PvP:SetPoint(oufdb.Icons.PvP.Point, self, oufdb.Icons.PvP.Point, oufdb.Icons.PvP.X, oufdb.Icons.PvP.Y)
		end
	end
	
	------------------------------------------------------------------------
	--	Portrait
	------------------------------------------------------------------------
	
	if oufdb.Portrait.Enable == true then
		self.Portrait = CreateFrame("PlayerModel", nil, self)
		self.Portrait:SetFrameLevel(8)
		self.Portrait:SetHeight(tonumber(oufdb.Portrait.Height))
		self.Portrait:SetWidth(tonumber(oufdb.Portrait.Width))
		self.Portrait:SetAlpha(1)
		self.Portrait:SetPoint("TOPLEFT", self.Health, "TOPLEFT", tonumber(oufdb.Portrait.X), tonumber(oufdb.Portrait.Y))
	end
	
	------------------------------------------------------------------------
	--	Auras
	------------------------------------------------------------------------

	if oufdb.Aura.buffs_enable then
		self.Buffs = CreateFrame("Frame", nil, self)
		self.Buffs:SetHeight(tonumber(oufdb.Aura.buffs_size))
		self.Buffs:SetWidth(tonumber(oufdb.Width))
		self.Buffs.size = tonumber(oufdb.Aura.buffs_size)
		self.Buffs.spacing = tonumber(oufdb.Aura.buffs_spacing)
		self.Buffs.num = tonumber(oufdb.Aura.buffs_num)
		self.Buffs.numDebuffs = tonumber(oufdb.Aura.buffs_num)
		self.Buffs.onlyShowPlayer = oufdb.Aura.buffs_playeronly
		
		self.Buffs:SetPoint(oufdb.Aura.buffs_initialAnchor, self.Health, oufdb.Aura.buffs_initialAnchor, tonumber(oufdb.Aura.buffsX), tonumber(oufdb.Aura.buffsY))
		self.Buffs.initialAnchor = oufdb.Aura.buffs_initialAnchor
		self.Buffs["growth-y"] = oufdb.Aura.buffs_growthY
		self.Buffs["growth-x"] = oufdb.Aura.buffs_growthX
		self.Buffs.showAuratimer = oufdb.Aura.buffs_auratimer
		
		self.Buffs.PostCreateIcon = PostCreateAura
		self.Buffs.PostUpdateIcon = PostUpdateAura
	end
	
	if oufdb.Aura.debuffs_enable then
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs:SetHeight(tonumber(oufdb.Aura.debuffs_size))
		self.Debuffs:SetWidth(tonumber(oufdb.Width))
		self.Debuffs.size = tonumber(oufdb.Aura.debuffs_size)
		self.Debuffs.spacing = tonumber(oufdb.Aura.debuffs_spacing)
		self.Debuffs.num = tonumber(oufdb.Aura.debuffs_num)
		self.Debuffs.numDebuffs = tonumber(oufdb.Aura.debuffs_num)
		
		self.Debuffs:SetPoint(oufdb.Aura.debuffs_initialAnchor, self.Health, oufdb.Aura.debuffs_initialAnchor, tonumber(oufdb.Aura.debuffsX), tonumber(oufdb.Aura.debuffsY))
		self.Debuffs.initialAnchor = oufdb.Aura.debuffs_initialAnchor
		self.Debuffs["growth-y"] = oufdb.Aura.debuffs_growthY
		self.Debuffs["growth-x"] = oufdb.Aura.debuffs_growthX
		self.Debuffs.colorByType = oufdb.Aura.debuffs_colorbytype
		self.Debuffs.showAuratimer = oufdb.Aura.debuffs_auratimer
		
		self.Debuffs.PostCreateIcon = PostCreateAura
		self.Debuffs.PostUpdateIcon = PostUpdateAura
	end
	
	------------------------------------------------------------------------
	--	Aggro Glow
	------------------------------------------------------------------------
	if unit == "raid" then
		self.Threat = CreateFrame("Frame", nil, self)
		self.Threat:SetPoint("TOPLEFT", self, "TOPLEFT", tonumber(oufdb.Backdrop.Padding.Left), tonumber(oufdb.Backdrop.Padding.Top))
		self.Threat:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", tonumber(oufdb.Backdrop.Padding.Right), tonumber(oufdb.Backdrop.Padding.Bottom))
		self.Threat:SetFrameLevel(self.Health:GetFrameLevel() + 1)
		self.Threat:SetBackdrop({
				edgeFile = LSM:Fetch("border", oufdb.Border.EdgeFile),
				edgeSize = tonumber(oufdb.Border.EdgeSize),
				insets = {
					left = tonumber(oufdb.Border.Insets.Left),
					right = tonumber(oufdb.Border.Insets.Right),
					top = tonumber(oufdb.Border.Insets.Top),
					bottom = tonumber(oufdb.Border.Insets.Bottom)
				}
		})
		self.Threat:SetBackdropColor(0, 0, 0, 0)
		self.Threat:SetBackdropBorderColor(0, 0, 0)
		
		self.Threat.Enable = oufdb.Border.Enable
		self.Threat.Override = ThreatOverride
	end
	
	------------------------------------------------------------------------
	--	Colors / Settings
	------------------------------------------------------------------------
	
	self.Health.colorClass = oufdb.Health.ColorClass
	self.Health.colorTapping = false
	self.Health.colorDisconnected = false
	self.Health.colorSmooth = oufdb.Health.ColorGradient
	self.Health.colorHappy = false
	self.Health.colorIndividual = oufdb.Health.IndividualColor
	self.Health.Smooth = oufdb.Health.Smooth
	self.Health.colorReaction = false
	self.Health.frequentUpdates = false
		
	self.Health.value.Enable = oufdb.Texts.Health.Enable
	self.Health.value.ShowDead = oufdb.Texts.Health.ShowDead
	self.Health.value.Format = oufdb.Texts.Health.Format
	self.Health.value.colorClass = oufdb.Texts.Health.ColorClass
	self.Health.value.colorGradient = oufdb.Texts.Health.ColorGradient
	self.Health.value.colorIndividual = oufdb.Texts.Health.IndividualColor
	
	self.Health.valuePercent.Enable = oufdb.Texts.HealthPercent.Enable
	self.Health.valuePercent.ShowAlways = oufdb.Texts.HealthPercent.ShowAlways
	self.Health.valuePercent.ShowDead = oufdb.Texts.HealthPercent.ShowDead
	self.Health.valuePercent.colorClass = oufdb.Texts.HealthPercent.ColorClass
	self.Health.valuePercent.colorGradient = oufdb.Texts.HealthPercent.ColorGradient
	self.Health.valuePercent.colorIndividual = oufdb.Texts.HealthPercent.IndividualColor
	
	self.Health.valueMissing.Enable = oufdb.Texts.HealthMissing.Enable
	self.Health.valueMissing.ShowAlways = oufdb.Texts.HealthMissing.ShowAlways
	self.Health.valueMissing.ShortValue = oufdb.Texts.HealthMissing.ShortValue
	self.Health.valueMissing.colorClass = oufdb.Texts.HealthMissing.ColorClass
	self.Health.valueMissing.colorGradient = oufdb.Texts.HealthMissing.ColorGradient
	self.Health.valueMissing.colorIndividual = oufdb.Texts.HealthMissing.IndividualColor
	
	self.Power.colorClass = oufdb.Power.ColorClass
	self.Power.colorTapping = false
	self.Power.colorDisconnected = false
	self.Power.colorSmooth = false
	self.Power.colorType = oufdb.Power.ColorType
	self.Power.colorIndividual = oufdb.Power.IndividualColor
	self.Power.Smooth = oufdb.Power.Smooth
	self.Power.colorReaction = false
	self.Power.frequentUpdates = true
	
	self.Power.value.Enable = oufdb.Texts.Power.Enable
	self.Power.value.Format = oufdb.Texts.Power.Format
	self.Power.value.colorClass = oufdb.Texts.Power.ColorClass
	self.Power.value.colorType = oufdb.Texts.Power.ColorType
	self.Power.value.colorIndividual = oufdb.Texts.Power.IndividualColor
	
	self.Power.valuePercent.Enable = oufdb.Texts.PowerPercent.Enable
	self.Power.valuePercent.ShowAlways = oufdb.Texts.PowerPercent.ShowAlways
	self.Power.valuePercent.colorClass = oufdb.Texts.PowerPercent.ColorClass
	self.Power.valuePercent.colorType = oufdb.Texts.PowerPercent.ColorType
	self.Power.valuePercent.colorIndividual = oufdb.Texts.PowerPercent.IndividualColor
	
	self.Power.valueMissing.Enable = oufdb.Texts.PowerMissing.Enable
	self.Power.valueMissing.ShowAlways = oufdb.Texts.PowerMissing.ShowAlways
	self.Power.valueMissing.ShortValue = oufdb.Texts.PowerMissing.ShortValue
	self.Power.valueMissing.colorClass = oufdb.Texts.PowerMissing.ColorClass
	self.Power.valueMissing.colorType = oufdb.Texts.PowerMissing.ColorType
	self.Power.valueMissing.colorIndividual = oufdb.Texts.PowerMissing.IndividualColor
	
	------------------------------------------------------------------------
	--	Background texture and textures border
	------------------------------------------------------------------------

	self.FrameBackdrop = CreateFrame("Frame", nil, self)
	self.FrameBackdrop:SetPoint("TOPLEFT", self, "TOPLEFT", tonumber(oufdb.Backdrop.Padding.Left), tonumber(oufdb.Backdrop.Padding.Top))
	self.FrameBackdrop:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", tonumber(oufdb.Backdrop.Padding.Right), tonumber(oufdb.Backdrop.Padding.Bottom))
	self.FrameBackdrop:SetFrameStrata("BACKGROUND")
	self.FrameBackdrop:SetBackdrop({
		bgFile = LSM:Fetch("background", oufdb.Backdrop.Texture),
		edgeFile = LSM:Fetch("border", oufdb.Border.EdgeFile),
		edgeSize = tonumber(oufdb.Border.EdgeSize),
		insets = {
			left = tonumber(oufdb.Border.Insets.Left),
			right = tonumber(oufdb.Border.Insets.Right),
			top = tonumber(oufdb.Border.Insets.Top),
			bottom = tonumber(oufdb.Border.Insets.Bottom)
		}
	})
	self.FrameBackdrop:SetBackdropColor(tonumber(oufdb.Backdrop.Color.r),tonumber(oufdb.Backdrop.Color.g),tonumber(oufdb.Backdrop.Color.b),tonumber(oufdb.Backdrop.Color.a))
	self.FrameBackdrop:SetBackdropBorderColor(tonumber(oufdb.Border.Color.r), tonumber(oufdb.Border.Color.g), tonumber(oufdb.Border.Color.b), tonumber(oufdb.Border.Color.a))
	
	--  highlight 
	if highlight then
		self.Highlight = self.Health:CreateTexture(nil, "OVERLAY")
		self.Highlight:SetAllPoints(self)
		self.Highlight:SetTexture(highlightTex)
		self.Highlight:SetVertexColor(1,1,1,.1)
		self.Highlight:SetBlendMode("ADD")
		self.Highlight:Hide()
	end

	self.SpellRange = true
	self.BarFade = false
	
	self.Health.PostUpdate = PostUpdateHealth
	self.Power.PostUpdate = PostUpdatePower
	
	return self
end

oUF:RegisterStyle("Maintank", SetStyle)
oUF:SetActiveStyle("Maintank")

if not db.oUF.Maintank.Enable == true then return end

local temp
local tank

local initialconfigfunc = [[
	local unit = ...
	if unit == "raid" then
		self:SetHeight(]]..tonumber(db.oUF.Maintank.Height)..[[)
		self:SetWidth(]]..tonumber(db.oUF.Maintank.Width)..[[)
	elseif unit == "raidtarget" then
		self:SetHeight(]]..tonumber(db.oUF.MaintankTarget.Height)..[[)
		self:SetWidth(]]..tonumber(db.oUF.MaintankTarget.Width)..[[)
	elseif unit == "raidtargettarget" then
		self:SetHeight(]]..tonumber(db.oUF.MaintankToT.Height)..[[)
		self:SetWidth(]]..tonumber(db.oUF.MaintankToT.Width)..[[)
	end
]]

if db.oUF.MaintankTarget.Enable == true then
	if db.oUF.MaintankToT.Enable == true then
		temp = "oUF_LUI_maintanktargettarget"
	else
		temp = "oUF_LUI_maintanktarget"
	end
else
	temp = nil
end

if temp ~= nil then
	tank = oUF:SpawnHeader("oUF_LUI_maintank", nil, nil,
		"showRaid", true,
		"groupFilter", "MAINTANK",
		"template", temp,
		"yOffset", -tonumber(db.oUF.Maintank.Padding),
		"oUF-initialConfigFunction", initialconfigfunc,
		-- needed for testmode
		"showSolo", true,
		"showPlayer", true
	)
else
	tank = oUF:SpawnHeader("oUF_LUI_maintank", nil, nil,
		"showRaid", true,
		"groupFilter", "MAINTANK",
		"yOffset", -tonumber(db.oUF.Maintank.Padding),
		"oUF-initialConfigFunction", initialconfigfunc,
		-- needed for testmode
		"showSolo", true,
		"showPlayer", true
	)
end

tank:SetPoint("TOPRIGHT", UIParent, "RIGHT", tonumber(db.oUF.Maintank.X), tonumber(db.oUF.Maintank.Y))
tank:Show()
