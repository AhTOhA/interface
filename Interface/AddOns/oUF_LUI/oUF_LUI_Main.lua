------------------------------------------------------------------------
--	oUF LUI Layout
--	Version 3.0
-- 	Date: 01/12/2010
--	DO NOT USE THIS LAYOUT WITHOUT LUI
------------------------------------------------------------------------

local LSM = LibStub("LibSharedMedia-3.0")
local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local db = LUI.db.profile

if db == nil then return end
if db.oUF.Settings.Enable ~= true then return end

local highlight = true
local entering

local switch = function(n, ...)
	for k,v in pairs({...}) do
		if v[1] == n or v[1] == nil then
			return (type(v[2]) == "function") and v[2]() or v[2]
		end
	end
end

local case = function(n,f)
	return {n,f}
end

local default = function(f)
	return {nil,f}
end

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
local font2 = mediaPath..[=[Fonts\ARIALN.ttf]=]
local font3 = [=[Interface\Addons\LUI\media\fonts\Prototype.ttf]=]

local _, class = UnitClass("player")
local standings = {'Hated', 'Hostile', 'Unfriendly', 'Neutral', 'Friendly', 'Honored', 'Revered', 'Exalted'}

local vengeance = {
	["WARRIOR"] = true,
	["DRUID"] = true,
	["DEATHKNIGHT"] = true,
	["DEATH KNIGHT"] = true,
	["PALADIN"] = true,
}

------------------------------------------------------------------------
--	Colors
------------------------------------------------------------------------

local colors = oUF_LUI.colors

------------------------------------------------------------------------
--	Don't edit this if you don't know what you are doing!
------------------------------------------------------------------------

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

local EnterVehicle = function(self, event)
	if event == "enter" then
	
	end
end

local ExitVehicle = function(self, event)
	if event == "exit" then
		
	end
end

local PostUpdateHealth = function(health, unit, min, max)
	local pClass, pToken = UnitClass(unit)
	local color = colors.class[pToken]
	
	local r, g, b = oUF.ColorGradient(min/max, unpack(colors.smooth))
	
	if unit == "player" and entering == true then
		if db.oUF.Player.Health.ColorClass == true then
			if color then
				health:SetStatusBarColor(color[1], color[2], color[3])
				local mu = health.bg.multiplier or 1
				health.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu)
			else
				health:SetStatusBarColor(0.5, 0.5, 0.5)
				local mu = health.bg.multiplier or 1
				health.bg:SetVertexColor(0.5*mu, 0.5*mu, 0.5*mu)
			end
		elseif db.oUF.Player.Health.IndividualColor.Enable == true then
			health:SetStatusBarColor(db.oUF.Player.Health.IndividualColor.r, db.oUF.Player.Health.IndividualColor.g, db.oUF.Player.Health.IndividualColor.b)
			local mu = health.bg.multiplier or 1
			health.bg:SetVertexColor(db.oUF.Player.Health.IndividualColor.r*mu, db.oUF.Player.Health.IndividualColor.g*mu, db.oUF.Player.Health.IndividualColor.b*mu)
		elseif db.oUF.Player.Health.ColorGradient == true then
			health:SetStatusBarColor(r,g,b)
			local mu = health.bg.multiplier or 1
			health.bg:SetVertexColor(r*mu, g*mu, b*mu)
		end
	else
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
		if pToken == "HUNTER" and unit == "pet" then
			if health.colorHappy == true then
				local pHappy = GetPetHappiness()
				
				if pHappy then
					local color3 = colors.happiness[pHappy]
					if color3 then
						health:SetStatusBarColor(color3[1], color3[2], color3[3])
						local mu = health.bg.multiplier or 1
						health.bg:SetVertexColor(color3[1]*mu, color3[2]*mu, color3[3]*mu)
					else
						health:SetStatusBarColor(0.5, 0.5, 0.5)
						local mu = health.bg.multiplier or 1
						health.bg:SetVertexColor(0.5*mu, 0.5*mu, 0.5*mu)
					end
				end
			end
		end
	end
		
	if health.colorTapping and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
		local tr,tg,tb = unpack(colors.tapped)
		health:SetStatusBarColor(tr,tg,tb)
		local mu = health.bg.multiplier or 1
		health.bg:SetVertexColor(tr*mu, tg*mu, tb*mu)
	end

	if not UnitIsConnected(unit) then
		health:SetValue(0)
		health.valueMissing:SetText()
		
		if health.value.ShowDead == true then
			health.value:SetText("|cffD7BEA5<Offline>|r")
		else
			health.value:SetText()
		end
		
		if health.valuePercent.ShowDead == true then
			health.valuePercent:SetText("|cffD7BEA5<Offline>|r")
		else
			health.valuePercent:SetText()
		end
	elseif UnitIsGhost(unit) then
		health:SetValue(0)
		health.valueMissing:SetText()
		
		if health.value.ShowDead == true then
			health.value:SetText("|cffD7BEA5<Ghost>|r")
		else
			health.value:SetText()
		end
		
		if health.valuePercent.ShowDead == true then
			health.valuePercent:SetText("|cffD7BEA5<Ghost>|r")
		else
			health.valuePercent:SetText()
		end
	elseif UnitIsDead(unit) then
		health:SetValue(0)
		health.valueMissing:SetText()
		
		if health.value.ShowDead == true then
			health.value:SetText("|cffD7BEA5<Dead>|r")
		else
			health.value:SetText()
		end
		
		if health.valuePercent.ShowDead == true then
			health.valuePercent:SetText("|cffD7BEA5<Dead>|r")
		else
			health.valuePercent:SetText()
		end
	else
		local healthPercent = 100 * min / max
		healthPercent = string.format("%.1f", healthPercent)
		healthPercent = healthPercent.."%"
		
		if health.value.Enable == true then
			if min >= 1 then
				if health.value.ShowAlways == false and min == max then
					health.value:SetText()
				else
               health.value:SetFormattedText(unpack(
                  switch(health.value.Format,
                     case("Absolut", {"%s/%s",min,max}),
                     case("Absolut & Percent", {"%s/%s | %s",min,max,healthPercent}),
                     case("Absolut Short", {"%s/%s",ShortValue(min),ShortValue(max)}),
                     case("Absolut Short & Percent", {"%s/%s | %s",ShortValue(min),ShortValue(max),healthPercent}),
                     case("Standard", {"%s",min}),
                     case("Standard Short", {"%s",ShortValue(min)}),
                     default({"%s",min})
                  )
               ))			
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
	
	if UnitIsAFK(unit) then
		if health.value.ShowDead == true then
			if health.value:GetText() then
				if not strfind(health.value:GetText(), "AFK") then
					health.value:SetText("|cffffffff<AFK>|r "..health.value:GetText())
				end
			else
				health.value:SetText("|cffffffff<AFK>|r")
			end
		end
		
		if health.valuePercent.ShowDead == true then
			if health.valuePercent:GetText() then
				if not strfind(health.valuePercent:GetText(), "AFK") then
					health.valuePercent:SetText("|cffffffff<AFK>|r "..health.valuePercent:GetText())
				end
			else
				health.valuePercent:SetText("|cffffffff<AFK>|r")
			end
		end
	end
end

local PostUpdatePower = function(power, unit, min, max)
	local _, pType = UnitPowerType(unit)
	local pClass, pToken = UnitClass(unit)
	local color = colors.class[pToken]
	local color2 = colors.power[pType]
	
	if unit == "player" and entering == true then
		if db.oUF.Player.Power.ColorClass == true then
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
		elseif db.oUF.Player.Power.IndividualColor.Enable == true then
			power:SetStatusBarColor(db.oUF.Player.Power.IndividualColor.r, db.oUF.Player.Power.IndividualColor.g, db.oUF.Player.Power.IndividualColor.b)
			local mu = power.bg.multiplier or 1
			power.bg:SetVertexColor(db.oUF.Player.Power.IndividualColor.r*mu, db.oUF.Player.Power.IndividualColor.g*mu, db.oUF.Player.Power.IndividualColor.b*mu)
		elseif db.oUF.Player.Power.ColorType == true then
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
	else
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
		if class == "HUNTER" and unit == "pet" then
			if power.colorHappy == true then
				local pHappy = GetPetHappiness()
					
				if pHappy then
					local color3 = colors.happiness[pHappy]
					if color3 then
						power:SetStatusBarColor(color3[1], color3[2], color3[3])
						local mu = power.bg.multiplier or 1
						power.bg:SetVertexColor(color3[1]*mu, color3[2]*mu, color3[3]*mu)
					else
						power:SetStatusBarColor(0.5, 0.5, 0.5)
						local mu = power.bg.multiplier or 1
						power.bg:SetVertexColor(0.5*mu, 0.5*mu, 0.5*mu)
					end
				end
			end
		end
	end
	
	if not UnitIsConnected(unit) then
		power:SetValue(0)
		power.valueMissing:SetText()
		power.valuePercent:SetText()
		power.value:SetText()
	elseif UnitIsGhost(unit) then
		power:SetValue(0)
		power.valueMissing:SetText()
		power.valuePercent:SetText()
		power.value:SetText()
	elseif UnitIsDead(unit) then
		power:SetValue(0)
		power.valueMissing:SetText()
		power.valuePercent:SetText()
		power.value:SetText()
	else
		local powerPercent = 100 * min / max
		powerPercent = string.format("%.1f", powerPercent)
		powerPercent = powerPercent.."%"
		local maxPower = not (select(2, UnitPowerType(unit)) == "RAGE" or select(2, UnitPowerType(unit)) == "RUNIC_POWER")
		
		if power.value.Enable == true then
			if power.value.ShowAlways == false and ((maxPower == true and min == max) or (maxPower == false and min == 0)) then
				power.value:SetText()
			else
            power.value:SetFormattedText(unpack(
               switch(power.value.Format,
                  case("Absolut", {"%s/%s",min,max}),
                  case("Absolut & Percent", {"%s/%s | %s",min,max,powerPercent}),
                  case("Absolut Short", {"%s/%s",ShortValue(min),ShortValue(max)}),
                  case("Absolut Short & Percent", {"%s/%s | %s",ShortValue(min),ShortValue(max),powerPercent}),
                  case("Standard", {"%s",min}),
                  case("Standard Short", {"%s",ShortValue(min)}),
                  default({"%s",min})
               )
            ))
			end
			
			if power.value.colorClass == true then
				if color then
					power.value:SetTextColor(color[1],color[2],color[3])
				elseif color2 then
					power.value:SetTextColor(color2[1],color2[2],color2[3])
				else
					power.value:SetTextColor(0, 0, 0)
				end
			elseif power.value.colorType == true then
				if color2 then
					power.value:SetTextColor(color2[1],color2[2],color2[3])
				elseif color then
					power.value:SetTextColor(color[1],color[2],color[3])
				else
					power.value:SetTextColor(0, 0, 0)
				end
			elseif power.value.colorIndividual.Enable == true then
				power.value:SetTextColor(power.value.colorIndividual.r, power.value.colorIndividual.g, power.value.colorIndividual.b)
			end
		else
			power.value:SetText()
		end
		
		if power.valuePercent.Enable == true then
			if power.valuePercent.ShowAlways == false and ((maxPower == true and min == max) or (maxPower == false and min == 0)) then
				power.valuePercent:SetText()
			else
				power.valuePercent:SetText(powerPercent)
			end
			
			if power.valuePercent.colorClass == true then
				if color then
					power.valuePercent:SetTextColor(color[1],color[2],color[3])
				elseif color2 then
					power.valuePercent:SetTextColor(color2[1],color2[2],color2[3])
				else
					power.valuePercent:SetTextColor(0, 0, 0)
				end
			elseif power.valuePercent.colorType == true then
				if color2 then
					power.valuePercent:SetTextColor(color2[1],color2[2],color2[3])
				elseif color then
					power.valuePercent:SetTextColor(color[1],color[2],color[3])
				else
					power.valuePercent:SetTextColor(0, 0, 0)
				end
			elseif power.valuePercent.colorIndividual.Enable == true then
				power.valuePercent:SetTextColor(power.valuePercent.colorIndividual.r, power.valuePercent.colorIndividual.g, power.valuePercent.colorIndividual.b)
			end
		else
			power.valuePercent:SetText()
		end
		
		if power.valueMissing.Enable == true then
			local powerMissing = max-min
			
			if power.valueMissing.ShowAlways == false and ((maxPower == true and min == max) or (maxPower == false and min == 0)) then
				power.valueMissing:SetText()
			elseif power.valueMissing.ShortValue == true then
				power.valueMissing:SetText("-"..ShortValue(powerMissing))
			else
				power.valueMissing:SetText("-"..powerMissing)
			end
			
			if power.valueMissing.colorClass == true then
				if color then
					power.valueMissing:SetTextColor(color[1],color[2],color[3])
				elseif color2 then
					power.valueMissing:SetTextColor(color2[1],color2[2],color2[3])
				else
					power.valueMissing:SetTextColor(0, 0, 0)
				end
			elseif power.valueMissing.colorType == true then
				if color2 then
					power.valueMissing:SetTextColor(color2[1],color2[2],color2[3])
				elseif color then
					power.valueMissing:SetTextColor(color[1],color[2],color[3])
				else
					power.valueMissing:SetTextColor(0, 0, 0)
				end
			elseif power.valueMissing.colorIndividual.Enable == true then
				power.valueMissing:SetTextColor(power.valueMissing.colorIndividual.r, power.valueMissing.colorIndividual.g, power.valueMissing.colorIndividual.b)
			end
		else
			power.valueMissing:SetText()
		end
	end
end

local FormatCastbarTime = function(self, duration)
	if self.channeling then
		if self.Time.ShowMax == true then
			self.Time:SetFormattedText("%.1f / %.1f", duration, self.max)
		else
			self.Time:SetFormattedText("%.1f", duration)
		end
	elseif self.casting then
		if self.Time.ShowMax == true then
			self.Time:SetFormattedText("%.1f / %.1f", self.max - duration, self.max)
		else
			self.Time:SetFormattedText("%.1f ", self.max - duration)
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

	button.overlay:Hide()

	button.auratype = button:CreateTexture(nil, "OVERLAY")
	button.auratype:SetTexture(buttonTex)
	button.auratype:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
	button.auratype:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
	button.auratype:SetTexCoord(0, 1, 0.02, 1)
end

local PostUpdateAura = function(icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
	if not(unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") then
		if icon.debuff then
			icon.icon:SetDesaturated(true)
		end
	end
	
	if icons.showAuraType and dtype then
		local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
		icon.auratype:SetVertexColor(color.r, color.g, color.b)
	else
		if icon.debuff then
			icon.auratype:SetVertexColor(0.69, 0.31, 0.31)
		else
			icon.auratype:SetVertexColor(1, 1, 1)
		end
	end
	
	if icons.disableCooldown then
		icon.cd:Hide()
	else
		icon.cd:Show()
	end
	icon.cd:SetReverse(icons.cooldownReverse)

	if duration and duration > 0 then
		if icons.showAuratimer then
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
	else
		icon.remaining:Hide()
	end
	
	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	icon:SetScript("OnUpdate", CreateAuraTimer)
end

local ThreatOverride = function(self, event, unit)
	if(unit ~= self.unit) then return end
	if unit == "vehicle" then unit = "player" end

	unit = unit or self.unit
	local status = UnitThreatSituation(unit)

	if(status and status > 0) then
		local r, g, b = GetThreatStatusColor(status)
		--self.Threat:SetBackdropColor(r, g, b)
		self.Threat:SetBackdropBorderColor(r, g, b)
		self.Threat:Show()
	else
		self.Threat:Hide()
	end
end

local UpdateCPoints = function(self, event, unit)
	if(unit == 'pet') then return end

	local cp
	if(UnitExists'vehicle') then
		cp = GetComboPoints('vehicle', 'target')
	else
		cp = GetComboPoints('player', 'target')
	end
	
	local cpoints = self.CPoints
	if cp == 0 and not cpoints.showAlways then
		return cpoints:Hide()
	elseif not cpoints:IsShown() then
		cpoints:Show()
	end

	for i=1, MAX_COMBO_POINTS do
		if(i <= cp) then
			cpoints[i]:SetValue(1)
		else
			cpoints[i]:SetValue(0)
		end
	end
end

local UpdateShards = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end
	
	local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
	for i = 1, SHARD_BAR_NUM_SHARDS do
		if(i <= num) then
			self.SoulShards[i]:SetAlpha(1)
		else
			self.SoulShards[i]:SetAlpha(.4)
		end
	end
end

local UpdateHoly = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end
	
	local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
	for i = 1, MAX_HOLY_POWER do
		if(i <= num) then
			self.HolyPower[i]:SetAlpha(1)
		else
			self.HolyPower[i]:SetAlpha(.4)
		end
	end
end

local PostEclipseUpdate = function(self, unit)
	if self.ShowText then
		if ( GetEclipseDirection() == "sun" ) then
			self.LunarText:SetText(50+math.floor((UnitPower('player', SPELL_POWER_ECLIPSE)+1)/2))
			self.LunarText:SetTextColor(unpack(colors.eclipsebar["lunarbg"]))
			self.SolarText:SetText("Starfire!")
			self.SolarText:SetTextColor(unpack(colors.eclipsebar["lunarbg"]))
		elseif ( GetEclipseDirection() == "moon" ) then
			self.LunarText:SetText("Wrath!")
			self.LunarText:SetTextColor(unpack(colors.eclipsebar["solarbg"]))
			self.SolarText:SetText(50-math.floor((UnitPower('player', SPELL_POWER_ECLIPSE)+1)/2))
			self.SolarText:SetTextColor(unpack(colors.eclipsebar["solarbg"]))
		elseif self:IsShown() then
			self.LunarText:SetText(50+math.floor((UnitPower('player', SPELL_POWER_ECLIPSE)+1)/2))
			self.LunarText:SetTextColor(unpack(colors.eclipsebar["solarbg"]))
			self.SolarText:SetText(50-math.floor((UnitPower('player', SPELL_POWER_ECLIPSE)+1)/2))
			self.SolarText:SetTextColor(unpack(colors.eclipsebar["lunarbg"]))
		end
	end
end

local eclipseBarBuff = function(self, unit)
	if ( GetEclipseDirection() == "sun" ) then
		self.LunarBar:SetAlpha(1)
		self.SolarBar:SetAlpha(0.7)
		self.LunarBar:SetStatusBarColor(unpack(colors.eclipsebar["lunar"]))
		self.SolarBar:SetStatusBarColor(unpack(colors.eclipsebar["solarbg"]))
	elseif ( GetEclipseDirection() == "moon" ) then
		self.SolarBar:SetAlpha(1)
		self.LunarBar:SetAlpha(0.7)
		self.LunarBar:SetStatusBarColor(unpack(colors.eclipsebar["lunarbg"]))
		self.SolarBar:SetStatusBarColor(unpack(colors.eclipsebar["solar"]))
	elseif self:IsShown() then
		self.LunarBar:SetAlpha(1)
		self.SolarBar:SetAlpha(1)
		self.LunarBar:SetStatusBarColor(unpack(colors.eclipsebar["lunarbg"]))
		self.SolarBar:SetStatusBarColor(unpack(colors.eclipsebar["solarbg"]))
	end
end

do
	local f = CreateFrame("Frame")

	f:RegisterEvent("UNIT_ENTERED_VEHICLE")
	f:RegisterEvent("UNIT_EXITED_VEHICLE")
	
	local delay = 0.5
	local OnUpdate = function(self, elapsed)
		self.elapsed = (self.elapsed or delay) - elapsed
		if self.elapsed <= 0 then
			local petframe = oUF_LUI_pet
			petframe:PLAYER_ENTERING_WORLD()
			self:SetScript("OnUpdate", nil)
			if entering and petframe.PostEnterVehicle then
				petframe:PostEnterVehicle("enter")
			elseif not entering and petframe.PostExitVehicle then
				petframe:PostExitVehicle("exit")
			end
		end
	end

	f:SetScript("OnEvent", function(self, event, unit)
		if unit == "player" then
			if event == "UNIT_ENTERED_VEHICLE" then
				entering = true
			else
				entering = false
			end
			f.elapsed = delay
			f:SetScript("OnUpdate", OnUpdate)
		end
	end)
end

------------------------------------------------------------------------
--	Layout Style
------------------------------------------------------------------------

local SetStyle = function(self, unit, isSingle)
	local oufdb, ouf_xp_rep
	
	if unit == "player" or unit == "vehicle" then
		oufdb = db.oUF.Player
		ouf_xp_rep = db.oUF.XP_Rep
	elseif unit == "targettarget" then
		oufdb = db.oUF.ToT
	elseif unit == "targettargettarget" then
		oufdb = db.oUF.ToToT
	elseif unit == "target" then
		oufdb = db.oUF.Target
	elseif unit == "focustarget" then
		oufdb = db.oUF.FocusTarget
	elseif unit == "focus" then
		oufdb = db.oUF.Focus
	elseif unit == "pettarget" then
		oufdb = db.oUF.PetTarget
	elseif unit == "pet" then
		oufdb = db.oUF.Pet
	end
	
	self.menu = menu
	self.colors = colors
	self:RegisterForClicks("AnyUp")
	self:SetAttribute("type2", "menu")

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	
	self.MoveableFrames = true
	
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
	
	self:SetHeight(tonumber(oufdb.Height))
	self:SetWidth(tonumber(oufdb.Width))
	
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
	self.Health.bg:SetAlpha(oufdb.Health.BGAlpha)
	self.Health.bg.multiplier = oufdb.Health.BGMultiplier
	
	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.bg:SetTexture(LSM:Fetch("statusbar", oufdb.Power.TextureBG))
	self.Power.bg:SetAlpha(oufdb.Power.BGAlpha)
	self.Power.bg.multiplier = oufdb.Power.BGMultiplier
		
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
	
	self.CreateLeader = function()
		self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
		self.Leader:SetHeight(oufdb.Icons.Leader.Size)
		self.Leader:SetWidth(oufdb.Icons.Leader.Size)
		self.Leader:SetPoint(oufdb.Icons.Leader.Point, self, oufdb.Icons.Leader.Point, tonumber(oufdb.Icons.Leader.X), tonumber(oufdb.Icons.Leader.Y))
		
		self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
		self.Assistant:SetHeight(oufdb.Icons.Leader.Size)
		self.Assistant:SetWidth(oufdb.Icons.Leader.Size)
		self.Assistant:SetPoint(oufdb.Icons.Leader.Point, self, oufdb.Icons.Leader.Point, tonumber(oufdb.Icons.Leader.X), tonumber(oufdb.Icons.Leader.Y))
	end
	if oufdb.Icons.Leader and oufdb.Icons.Leader.Enable then self.CreateLeader() end
	
	self.CreateMasterLooter = function()
		self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
		self.MasterLooter:SetHeight(oufdb.Icons.Lootmaster.Size)
		self.MasterLooter:SetWidth(oufdb.Icons.Lootmaster.Size)
		self.MasterLooter:SetPoint(oufdb.Icons.Lootmaster.Point, self, oufdb.Icons.Lootmaster.Point, tonumber(oufdb.Icons.Lootmaster.X), tonumber(oufdb.Icons.Lootmaster.Y))
	end
	if oufdb.Icons.Lootmaster and oufdb.Icons.Lootmaster.Enable then self.CreateMasterLooter() end
	
	self.CreateRaidIcon = function()
		self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetHeight(oufdb.Icons.Raid.Size)
		self.RaidIcon:SetWidth(oufdb.Icons.Raid.Size)
		self.RaidIcon:SetPoint(oufdb.Icons.Raid.Point, self, oufdb.Icons.Raid.Point, tonumber(oufdb.Icons.Raid.X), tonumber(oufdb.Icons.Raid.Y))
	end
	if oufdb.Icons.Raid and oufdb.Icons.Raid.Enable then self.CreateRaidIcon() end
	
	self.CreateLFDRole = function()
		self.LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
		self.LFDRole:SetHeight(oufdb.Icons.Role.Size)
		self.LFDRole:SetWidth(oufdb.Icons.Role.Size)
		self.LFDRole:SetPoint(oufdb.Icons.Role.Point, self, oufdb.Icons.Role.Point, tonumber(oufdb.Icons.Role.X), tonumber(oufdb.Icons.Role.Y))
	end
	if oufdb.Icons.Role and oufdb.Icons.Role.Enable then self.CreateLFDRole() end
		
	self.CreatePvP = function()
		self.PvP = self.Health:CreateTexture(nil, "OVERLAY")
		self.PvP:SetHeight(oufdb.Icons.PvP.Size)
		self.PvP:SetWidth(oufdb.Icons.PvP.Size)
		self.PvP:SetPoint(oufdb.Icons.PvP.Point, self, oufdb.Icons.PvP.Point, tonumber(oufdb.Icons.PvP.X), tonumber(oufdb.Icons.PvP.Y))
		
		if unit == "player" then
			self.PvP.Timer = SetFontString(self.Health, LSM:Fetch("font", oufdb.Texts.PvP.Font), oufdb.Texts.PvP.Size, oufdb.Texts.PvP.Outline)
			self.PvP.Timer:SetPoint("CENTER", self.PvP, "CENTER", tonumber(oufdb.Texts.PvP.X), tonumber(oufdb.Texts.PvP.Y))
			self.PvP.Timer:SetTextColor(oufdb.Texts.PvP.Color.r, oufdb.Texts.PvP.Color.g, oufdb.Texts.PvP.Color.b)
			
			self.Health:HookScript("OnUpdate", function(_, elapsed)
				if UnitIsPVP(unit) and oufdb.Icons.PvP.Enable and oufdb.Texts.PvP.Enable then
					if (GetPVPTimer() == 301000 or GetPVPTimer() == -1) then
						if self.PvP.Timer:IsShown() then
							self.PvP.Timer:Hide()
						end
					else
						self.PvP.Timer:Show()
						local min = math.floor(GetPVPTimer()/1000/60)
						local sec = (math.floor(GetPVPTimer()/1000))-(min*60)
						if sec < 10 then sec = "0"..sec end
						self.PvP.Timer:SetText(min..":"..sec)
					end
				elseif self.PvP.Timer:IsShown() then
					self.PvP.Timer:Hide()
				end
			end)
		end
	end
	if oufdb.Icons.PvP and oufdb.Icons.PvP.Enable then self.CreatePvP() end
	
	if unit == "player" then
		self.CreateResting = function()
			self.Resting = self.Health:CreateTexture(nil, "OVERLAY")
			self.Resting:SetHeight(oufdb.Icons.Resting.Size)
			self.Resting:SetWidth(oufdb.Icons.Resting.Size)
			self.Resting:SetPoint(oufdb.Icons.Resting.Point, self, oufdb.Icons.Resting.Point, tonumber(oufdb.Icons.Resting.X), tonumber(oufdb.Icons.Resting.Y))
		end
		if oufdb.Icons.Resting and oufdb.Icons.Resting.Enable then self.CreateResting() end
		
		self.CreateCombat = function()
			self.Combat = self.Health:CreateTexture(nil, "OVERLAY")
			self.Combat:SetHeight(oufdb.Icons.Combat.Size)
			self.Combat:SetWidth(oufdb.Icons.Combat.Size)
			self.Combat:SetPoint(oufdb.Icons.Combat.Point, self, oufdb.Icons.Combat.Point, tonumber(oufdb.Icons.Combat.X), tonumber(oufdb.Icons.Combat.Y))
		end
		if oufdb.Icons.Combat and oufdb.Icons.Combat.Enable then self.CreateCombat() end
	end
	
	------------------------------------------------------------------------
	--	Portrait
	------------------------------------------------------------------------
	
	self.CreatePortrait = function()
		self.Portrait = CreateFrame("PlayerModel", nil, self)
		self.Portrait:SetFrameLevel(8)
		self.Portrait:SetHeight(tonumber(oufdb.Portrait.Height))
		self.Portrait:SetWidth(tonumber(oufdb.Portrait.Width))
		self.Portrait:SetAlpha(1)
		self.Portrait:SetPoint("TOPLEFT", self.Health, "TOPLEFT", tonumber(oufdb.Portrait.X), tonumber(oufdb.Portrait.Y))
	end
	if oufdb.Portrait.Enable == true then self.CreatePortrait() end
	
	------------------------------------------------------------------------
	--	Player Specific Items
	------------------------------------------------------------------------
	
	if unit == "player" then
	
		------------------------------------------------------------------------
		--	Experience
		------------------------------------------------------------------------	
		
		self.CreateExperience = function()
			self.XP = CreateFrame("Frame", self:GetName().."_XP", self)
			self.XP:SetFrameLevel(self:GetFrameLevel() + 2)
			self.XP:SetHeight(17)
			self.XP:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 2, -3)
			self.XP:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", -2, -3)
						
			self.Experience = CreateFrame("StatusBar",  nil, self.XP)
			self.Experience:SetStatusBarTexture(normTex)
			self.Experience:SetStatusBarColor(ouf_xp_rep.Experience.FillColor.r, ouf_xp_rep.Experience.FillColor.g, ouf_xp_rep.Experience.FillColor.b, ouf_xp_rep.Experience.FillColor.a)
			self.Experience:SetAllPoints(self.XP)
			
			self.Experience.Value = SetFontString(self.Experience, LSM:Fetch("font", ouf_xp_rep.Font), tonumber(ouf_xp_rep.FontSize), ouf_xp_rep.FontFlag)
			self.Experience.Value:SetAllPoints(self.XP)
			self.Experience.Value:SetFontObject(GameFontHighlight)
			self.Experience.Value:SetJustifyH(ouf_xp_rep.FontJustify)
			self.Experience.Value:SetTextColor(ouf_xp_rep.FontColor.r, ouf_xp_rep.FontColor.g, ouf_xp_rep.FontColor.b, ouf_xp_rep.FontColor.a)
			
			self.Experience.Rested = CreateFrame("StatusBar", nil, self.Experience)
			self.Experience.Rested:SetAllPoints(self.XP)
			self.Experience.Rested:SetStatusBarTexture(normTex)
			self.Experience.Rested:SetStatusBarColor(ouf_xp_rep.Experience.RestedColor.r, ouf_xp_rep.Experience.RestedColor.g, ouf_xp_rep.Experience.RestedColor.b, ouf_xp_rep.Experience.RestedColor.a)
			
			self.Experience.bg = self.XP:CreateTexture(nil, 'BACKGROUND')
			self.Experience.bg:SetAllPoints(self.XP)
			self.Experience.bg:SetTexture(normTex)
			self.Experience.bg:SetVertexColor(ouf_xp_rep.Experience.BGColor.r, ouf_xp_rep.Experience.BGColor.g, ouf_xp_rep.Experience.BGColor.b, ouf_xp_rep.Experience.BGColor.a)
			
			self.Experience.Override = function(self, event, unit)
				if(self.unit ~= unit) then return end
				if unit == "vehicle" then unit = "player" end
				
				if UnitLevel(unit) == MAX_PLAYER_LEVEL then
					return self.Experience:Hide()
				else
					self.Experience:Show()
				end
				
				local min, max = UnitXP(unit), UnitXPMax(unit)

				self.Experience:SetMinMaxValues(0, max)
				self.Experience:SetValue(min)

				if self.Experience.Rested then
					local exhaustion = unit == 'player' and GetXPExhaustion() or 0
					self.Experience.Rested:SetMinMaxValues(0, max)
					self.Experience.Rested:SetValue(math.min(min + exhaustion, max))
				end
			end
			
			local events = {'PLAYER_XP_UPDATE', 'PLAYER_LEVEL_UP', 'UPDATE_EXHAUSTION', 'PLAYER_ENTERING_WORLD'}
			for i=1, #events do self.XP:RegisterEvent(events[i]) end
			self.XP:SetScript("OnEvent", function(_, event)
				local value, max = UnitXP("player"), UnitXPMax("player")
				self.Experience.Value:SetText(value.." / "..max.."  ("..math.floor(value / max * 100 + 0.5).."%)")
				if event == 'PLAYER_ENTERING_WORLD' then self.XP:UnregisterEvent('PLAYER_ENTERING_WORLD') end
			end)
			
			self.XP:SetScript("OnEnter", function()
				self.XP:SetAlpha(ouf_xp_rep.Experience.Alpha)
				local level, value, max, rested = UnitLevel("player"), UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
				GameTooltip:SetOwner(self.XP, "ANCHOR_LEFT")
				GameTooltip:ClearLines()
				GameTooltip:AddLine("Level "..level)
				if (rested and rested > 0) then
					GameTooltip:AddLine("Rested: "..rested)
				end
				GameTooltip:AddLine("Remaining: "..max - value)
				GameTooltip:Show()
			end)
			
			self.XP:SetScript("OnLeave", function()
				if not ouf_xp_rep.Experience.AlwaysShow then
					self.XP:SetAlpha(0)
				end
				GameTooltip:Hide()
			end)
			
			if ouf_xp_rep.Experience.AlwaysShow then
				self.XP:SetAlpha(ouf_xp_rep.Experience.Alpha)
			else
				self.XP:SetAlpha(0)
			end
			
			if ouf_xp_rep.Experience.ShowValue then
				self.Experience.Value:Show()
			else
				self.Experience.Value:Hide()
			end
		end
		if ouf_xp_rep.Experience.Enable == true then self.CreateExperience() end
		
		------------------------------------------------------------------------
		--	Reputation
		------------------------------------------------------------------------
		
		self.CreateReputation = function()
			self.Rep = CreateFrame("Frame", self:GetName().."_Rep", self)
			self.Rep:SetFrameLevel(self:GetFrameLevel() + 2)
			self.Rep:SetHeight(17)
			self.Rep:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 2, -3)
			self.Rep:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", -2, -3)
			
			self.Reputation = CreateFrame("StatusBar", nil, self.Rep)
			self.Reputation:SetStatusBarTexture(normTex)
			self.Reputation:SetStatusBarColor(ouf_xp_rep.Reputation.FillColor.r, ouf_xp_rep.Reputation.FillColor.g, ouf_xp_rep.Reputation.FillColor.b, ouf_xp_rep.Reputation.FillColor.a)
			self.Reputation:SetAllPoints(self.Rep)
			
			self.Reputation.Value = SetFontString(self.Reputation, LSM:Fetch("font", ouf_xp_rep.Font), tonumber(ouf_xp_rep.FontSize), ouf_xp_rep.FontFlag)
			self.Reputation.Value:SetAllPoints(self.Rep)
			self.Reputation.Value:SetFontObject(GameFontHighlight)
			self.Reputation.Value:SetJustifyH(ouf_xp_rep.FontJustify)
			self.Reputation.Value:SetTextColor(ouf_xp_rep.FontColor.r, ouf_xp_rep.FontColor.g, ouf_xp_rep.FontColor.b, ouf_xp_rep.FontColor.a)
			
			self.Reputation.bg = self.Reputation:CreateTexture(nil, 'BACKGROUND')
			self.Reputation.bg:SetAllPoints(self.Rep)
			self.Reputation.bg:SetTexture(normTex)
			self.Reputation.bg:SetVertexColor(ouf_xp_rep.Reputation.BGColor.r, ouf_xp_rep.Reputation.BGColor.g, ouf_xp_rep.Reputation.BGColor.b, ouf_xp_rep.Reputation.BGColor.a)
			
			local events = {'UPDATE_FACTION', 'PLAYER_ENTERING_WORLD'}
			for i=1, #events do self.Rep:RegisterEvent(events[i]) end
			self.Rep:SetScript("OnEvent", function(_, event)
				if GetWatchedFactionInfo() then
					local _, _, min, max, value = GetWatchedFactionInfo()
					self.Reputation.Value:SetText(value - min.." / "..max - min.."  ("..math.floor(((value - min) / (max - min)) * 100 + 0.5).."%)")
				else
					self.Reputation.Value:SetText("")
				end
				if event == 'PLAYER_ENTERING_WORLD' then self.Rep:UnregisterEvent('PLAYER_ENTERING_WORLD') end
			end)
			
			self.Rep:SetScript("OnEnter", function()
				self.Rep:SetAlpha(ouf_xp_rep.Reputation.Alpha)
				GameTooltip:SetOwner(self.Rep, "ANCHOR_LEFT")
				GameTooltip:ClearLines()
				if GetWatchedFactionInfo() then
					local name, standing, min, max, value = GetWatchedFactionInfo()
					GameTooltip:AddLine(name..": "..standings[standing])
					GameTooltip:AddLine("Remaining: "..max - value)
				else
					GameTooltip:AddLine("You are not tracking any factions")
				end
				GameTooltip:Show()
			end)
			
			self.Rep:SetScript("OnLeave", function()
				if ouf_xp_rep.Reputation.AlwaysShow ~= true then
					self.Rep:SetAlpha(0)
				end
				GameTooltip:Hide()
			end)
			
			if ouf_xp_rep.Reputation.AlwaysShow == true then
				self.Rep:SetAlpha(ouf_xp_rep.Reputation.Alpha)
			else
				self.Rep:SetAlpha(0)
			end
			
			if ouf_xp_rep.Reputation.ShowValue == true then
				self.Reputation.Value:Show()
			else
				self.Reputation.Value:Hide()
			end
		end
		if ouf_xp_rep.Reputation.Enable == true then self.CreateReputation() end
		
		------------------------------------------------------------------------
		--  XP / Rep    Toggle and Messages
		------------------------------------------------------------------------
		
		if UnitLevel("player") == MAX_PLAYER_LEVEL then
			if self.XP then
				self.XP:Hide()
			end
			if self.Rep then
				self.Rep:SetScript("OnMouseUp", function(_, button)
					if button == "LeftButton" and GetWatchedFactionInfo() then
						local msgSent = false
						local name, standing, min, max, value = GetWatchedFactionInfo()
						for i=1, NUM_CHAT_WINDOWS do
							if _G["ChatFrame"..i.."EditBox"] then
								if _G["ChatFrame"..i.."EditBox"]:IsShown() then
									_G["ChatFrame"..i.."EditBox"]:Insert("Reputation with "..name..": "..value - min.." / "..max - min.." "..standings[standing].." ("..max - value.." remaining)")
									msgSent = true
									break
								end
							end
						end
						if msgSent == false then
							print("Reputation with "..name..": "..value - min.." / "..max - min.." "..standings[standing].." ("..max - value.." remaining)")
						end
					end
				end)
			end
		else
			if self.XP and self.Rep then
				self.Rep:Hide()
			end
			if self.XP then			
				self.XP:SetScript("OnMouseUp", function(_, button)
					if button == "LeftButton" then
						local msgSent = false
						local level, value, max, rested = UnitLevel("player"), UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
						for i=1, NUM_CHAT_WINDOWS do
							if _G["ChatFrame"..i.."EditBox"] then
								if _G["ChatFrame"..i.."EditBox"]:IsShown() then
									if (rested and rested > 0) then
										_G["ChatFrame"..i.."EditBox"]:Insert("Experience into Level "..level..": "..value.." / "..max.." ("..max - value.." remaining), "..rested.." rested XP")
									else
										_G["ChatFrame"..i.."EditBox"]:Insert("Experience into Level "..level..": "..value.." / "..max.." ("..max - value.." remaining)")
									end
									msgSent = true
									break
								end
							end
						end
						if msgSent == false then
							if (rested and rested > 0) then
								print("Experience into Level "..level..": "..value.." / "..max.." ("..max - value.." remaining), "..rested.." rested XP")
							else
								print("Experience into Level "..level..": "..value.." / "..max.." ("..max - value.." remaining)")
							end
						end
					elseif button == "RightButton" and self.Rep then
						self.XP:Hide()
						self.Rep:Show()
					end
				end)
			end
			if self.Rep then
				self.Rep:SetScript("OnMouseUp", function(_, button)
					if button == "LeftButton" and GetWatchedFactionInfo() then
						local msgSent = false
						local name, standing, min, max, value = GetWatchedFactionInfo()
						for i=1, NUM_CHAT_WINDOWS do
							if _G["ChatFrame"..i.."EditBox"] then
								if _G["ChatFrame"..i.."EditBox"]:IsShown() then
									_G["ChatFrame"..i.."EditBox"]:Insert("Reputation with "..name..": "..value - min.." / "..max - min.." "..standings[standing].." ("..max - value.." remaining)")
									msgSent = true
									break
								end
							end
						end
						if msgSent == false then
							print("Reputation with "..name..": "..value - min.." / "..max - min.." "..standings[standing].." ("..max - value.." remaining)")
						end
					elseif button == "RightButton" and self.XP and UnitLevel("player") ~= MAX_PLAYER_LEVEL then
						self.Rep:Hide()
						self.XP:Show()
					end
				end)
			end
		end
		
		------------------------------------------------------------------------
		--   Swingtimer
		------------------------------------------------------------------------
		
		self.CreateSwing = function()
			self.Swing = CreateFrame("Frame", nil, self)
			self.Swing:SetWidth(tonumber(oufdb.Swing.Width))
			self.Swing:SetHeight(tonumber(oufdb.Swing.Height))
			self.Swing:SetPoint("BOTTOM", UIParent, "BOTTOM", tonumber(oufdb.Swing.X), tonumber(oufdb.Swing.Y))
			
			self.Swing.texture = LSM:Fetch("statusbar", oufdb.Swing.Texture)
			self.Swing.textureBG = LSM:Fetch("statusbar", oufdb.Swing.TextureBG)
			
			local mu = oufdb.Swing.BGMultiplier
			
			if oufdb.Swing.ColorClass == true then
				local color = colors.class[class]
				self.Swing.color = {color[1], color[2], color[3], 0.8}
				self.Swing.colorBG = {color[1]*mu, color[2]*mu, color[3]*mu, 1}
			else
				self.Swing.color = {oufdb.Swing.IndividualColor.r, oufdb.Swing.IndividualColor.g, oufdb.Swing.IndividualColor.b, 0.8}
				self.Swing.colorBG = {oufdb.Swing.IndividualColor.r*mu, oufdb.Swing.IndividualColor.g*mu, oufdb.Swing.IndividualColor.b*mu, 0.8}
			end
			
			self.Swing.Mainhand = CreateFrame("StatusBar", nil, self.Swing)
			self.Swing.Mainhand:SetPoint("TOPLEFT")
			self.Swing.Mainhand:SetPoint("BOTTOMRIGHT", self.Swing, "RIGHT")
			self.Swing.Mainhand:SetStatusBarTexture(self.Swing.texture)
			self.Swing.Mainhand:SetStatusBarColor(unpack(self.Swing.color))
			self.Swing.Mainhand:SetFrameLevel(20)
			self.Swing.Mainhand:Hide()
			
			self.Swing.Mainhand.bg = self.Swing.Mainhand:CreateTexture(nil, "BACKGROUND")
			self.Swing.Mainhand.bg:SetAllPoints(self.Swing.Mainhand)
			self.Swing.Mainhand.bg:SetTexture(self.Swing.textureBG)
			self.Swing.Mainhand.bg:SetVertexColor(unpack(self.Swing.colorBG))
			
			self.Swing.Offhand = CreateFrame("StatusBar", nil, self.Swing)
			self.Swing.Offhand:SetPoint("TOPLEFT", self.Swing, "LEFT")
			self.Swing.Offhand:SetPoint("BOTTOMRIGHT")
			self.Swing.Offhand:SetStatusBarTexture(self.Swing.texture)
			self.Swing.Offhand:SetStatusBarColor(unpack(self.Swing.color))
			self.Swing.Offhand:SetFrameLevel(20)
			self.Swing.Offhand:Hide()
			
			self.Swing.Offhand.bg = self.Swing.Offhand:CreateTexture(nil, "BACKGROUND")
			self.Swing.Offhand.bg:SetAllPoints(self.Swing.Offhand)
			self.Swing.Offhand.bg:SetTexture(self.Swing.textureBG)
			self.Swing.Offhand.bg:SetVertexColor(unpack(self.Swing.colorBG))
		end
		if oufdb.Swing.Enable == true then self.CreateSwing() end
		
		------------------------------------------------------------------------
		--   Vengeance Bar
		------------------------------------------------------------------------
		
		if class == "WARRIOR" or class == "DEATHKNIGHT" or class == "DEATH KNIGHT" or class == "DRUID" or class == "PALADIN" then
			self.CreateVengeance = function()
				self.Vengeance = CreateFrame("StatusBar", nil, self)
				self.Vengeance:SetWidth(tonumber(oufdb.Vengeance.Width))
				self.Vengeance:SetHeight(tonumber(oufdb.Vengeance.Height))
				self.Vengeance:SetPoint("BOTTOM", UIParent, "BOTTOM", tonumber(oufdb.Vengeance.X), tonumber(oufdb.Vengeance.Y))
				self.Vengeance:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.Vengeance.Texture))
				
				self.Vengeance.bg = self.Vengeance:CreateTexture(nil, "BORDER")
				self.Vengeance.bg:SetAllPoints(self.Vengeance)
				self.Vengeance.bg:SetTexture(LSM:Fetch("statusbar", oufdb.Vengeance.TextureBG))
				
				local mu = oufdb.Vengeance.BGMultiplier
				
				if oufdb.Vengeance.ColorClass == true then
					local color = colors.class[class]
					self.Vengeance:SetStatusBarColor(color[1], color[2], color[3], 0.8)
					self.Vengeance.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu, 1)
				else
					self.Vengeance:SetStatusBarColor(oufdb.Vengeance.IndividualColor.r, oufdb.Vengeance.IndividualColor.g, oufdb.Vengeance.IndividualColor.b, 0.8)
					self.Vengeance.bg:SetVertexColor(oufdb.Vengeance.IndividualColor.r*mu, oufdb.Vengeance.IndividualColor.g*mu, oufdb.Vengeance.IndividualColor.b*mu, 1)
				end
			end
			if oufdb.Vengeance.Enable == true then self.CreateVengeance() end
		end
		
		------------------------------------------------------------------------
		--   Totems
		------------------------------------------------------------------------   
	
		if class == "SHAMAN" then
			self.CreateTotemBar = function()
				local x = oufdb.Totems.Lock and 0 or oufdb.Totems.X
				local y = oufdb.Totems.Lock and 0.5 or oufdb.Totems.Y
				
				self.TotemBar = CreateFrame('Frame', nil, self)
				self.TotemBar:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', x, y)
				self.TotemBar:SetHeight(oufdb.Totems.Height)
				self.TotemBar:SetWidth(oufdb.Totems.Width)
				self.TotemBar.colors = colors.totembar
				self.TotemBar.Destroy = true
				
				for i = 1, 4 do
					self.TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self.TotemBar)
					self.TotemBar[i]:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.Totems.Texture))
					self.TotemBar[i]:SetHeight(oufdb.Totems.Height)
					self.TotemBar[i]:SetWidth((tonumber(oufdb.Totems.Width) -3*oufdb.Totems.Padding) / 4)
					self.TotemBar[i]:SetBackdrop(backdrop)
					self.TotemBar[i]:SetBackdropColor(0, 0, 0)
					self.TotemBar[i]:SetMinMaxValues(0, 1)
					
					if (i == 1) then
						self.TotemBar[i]:SetPoint("LEFT", self.TotemBar, "LEFT", 0, 0)
					else
						self.TotemBar[i]:SetPoint("LEFT", self.TotemBar[i-1], "RIGHT", oufdb.Totems.Padding, 0)
					end

					self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
					self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
					self.TotemBar[i].bg:SetTexture(normTex)
					self.TotemBar[i].bg.multiplier = tonumber(oufdb.Totems.Multiplier)
				end
				
				self.TotemBar.FrameBackdrop = CreateFrame("Frame", nil, self.TotemBar)
				self.TotemBar.FrameBackdrop:SetPoint("TOPLEFT", self.TotemBar, "TOPLEFT", -3.5, 3)
				self.TotemBar.FrameBackdrop:SetPoint("BOTTOMRIGHT", self.TotemBar, "BOTTOMRIGHT", 3.5, -3)
				self.TotemBar.FrameBackdrop:SetFrameStrata("BACKGROUND")
				self.TotemBar.FrameBackdrop:SetBackdrop {
					edgeFile = glowTex, edgeSize = 5,
					insets = {left = 3, right = 3, top = 3, bottom = 3}
				}
				self.TotemBar.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
				self.TotemBar.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
			end
			if oufdb.Totems.Enable == true then self.CreateTotemBar() end
		end

		------------------------------------------------------------------------
		--	Runes 
		------------------------------------------------------------------------	
	
		if class == "DEATHKNIGHT" then
			self.CreateRunes = function()
				local x = oufdb.Runes.Lock and 0 or oufdb.Runes.X
				local y = oufdb.Runes.Lock and 0.5 or oufdb.Runes.Y
				
				self.Runes = CreateFrame('Frame', nil, self)
				self.Runes:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', x, y)
				self.Runes:SetHeight(oufdb.Runes.Height)
				self.Runes:SetWidth(oufdb.Runes.Width)

				for i = 1, 6 do
					self.Runes[i] = CreateFrame('StatusBar', nil, self.Runes)
					self.Runes[i]:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.Runes.Texture))
					self.Runes[i]:SetStatusBarColor(unpack(colors.runes[math.floor((i+1)/2)]))
					self.Runes[i]:SetSize(((oufdb.Runes.Width - 5*oufdb.Runes.Padding) / 6), oufdb.Runes.Height)
					self.Runes[i]:SetBackdrop(backdrop)
					self.Runes[i]:SetBackdropColor(0.08, 0.08, 0.08)
					
					if i == 1 then
						self.Runes[i]:SetPoint("LEFT", self.Runes, "LEFT", 0, 0)
					else
						self.Runes[i]:SetPoint("LEFT", self.Runes[i-1], "RIGHT", oufdb.Runes.Padding, 0)
					end
				end
				
				self.Runes[5]:SetPoint("LEFT", self.Runes[2], "RIGHT", oufdb.Runes.Padding, 0)
				self.Runes[3]:SetPoint("LEFT", self.Runes[6], "RIGHT", oufdb.Runes.Padding, 0)
	
				self.Runes.FrameBackdrop = CreateFrame("Frame", nil, self.Runes)
				self.Runes.FrameBackdrop:SetPoint("TOPLEFT", self.Runes, "TOPLEFT", -3.5, 3)
				self.Runes.FrameBackdrop:SetPoint("BOTTOMRIGHT", self.Runes, "BOTTOMRIGHT", 3.5, -3)
				self.Runes.FrameBackdrop:SetFrameStrata("BACKGROUND")
				self.Runes.FrameBackdrop:SetBackdrop {
					edgeFile = glowTex, edgeSize = 5,
					insets = {left = 3, right = 3, top = 3, bottom = 3}
				}
				self.Runes.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
				self.Runes.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
			end
			if oufdb.Runes.Enable == true then self.CreateRunes() else RuneFrame:Hide() end
		end
		
		------------------------------------------------------------------------
		--	Holy Power 
		------------------------------------------------------------------------	
		
		if class == "PALADIN" then
			self.CreateHolyPower = function()
				local x = oufdb.HolyPower.Lock and 0 or oufdb.HolyPower.X
				local y = oufdb.HolyPower.Lock and 0.5 or oufdb.HolyPower.Y
				
				self.HolyPower = CreateFrame('Frame', nil, self)
				self.HolyPower:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', x, y)
				self.HolyPower:SetHeight(oufdb.HolyPower.Height)
				self.HolyPower:SetWidth(oufdb.HolyPower.Width)
				
				for i = 1, 3 do
					self.HolyPower[i] = CreateFrame('StatusBar', nil, self.HolyPower)
					self.HolyPower[i]:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.HolyPower.Texture))
					self.HolyPower[i]:SetStatusBarColor(unpack(colors.holypowerbar[i]))
					self.HolyPower[i]:SetSize(((oufdb.HolyPower.Width - 2*oufdb.HolyPower.Padding) / 3), oufdb.HolyPower.Height)
					self.HolyPower[i]:SetBackdrop(backdrop)
					self.HolyPower[i]:SetBackdropColor(0.08, 0.08, 0.08)
					
					if i == 1 then
						self.HolyPower[i]:SetPoint("LEFT", self.HolyPower, "LEFT", 0, 0)
					else
						self.HolyPower[i]:SetPoint("LEFT", self.HolyPower[i-1], "RIGHT", oufdb.HolyPower.Padding, 0)
					end
					
					self.HolyPower[i]:SetAlpha(.4)
				end
				
				self.HolyPower.FrameBackdrop = CreateFrame("Frame", nil, self.HolyPower)
				self.HolyPower.FrameBackdrop:SetPoint("TOPLEFT", self.HolyPower, "TOPLEFT", -3.5, 3)
				self.HolyPower.FrameBackdrop:SetPoint("BOTTOMRIGHT", self.HolyPower, "BOTTOMRIGHT", 3.5, -3)
				self.HolyPower.FrameBackdrop:SetFrameStrata("BACKGROUND")
				self.HolyPower.FrameBackdrop:SetBackdrop {
					edgeFile = glowTex, edgeSize = 5,
					insets = {left = 3, right = 3, top = 3, bottom = 3}
				}
				self.HolyPower.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
				self.HolyPower.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
				
				self.HolyPower.Override = UpdateHoly
			end
			if oufdb.HolyPower.Enable == true then self.CreateHolyPower() end
		end
		
		------------------------------------------------------------------------
		--	Soul Shards
		------------------------------------------------------------------------	
	
		if class == "WARLOCK" then
			self.CreateSoulShards = function()
				local x = oufdb.SoulShards.Lock and 0 or oufdb.SoulShards.X
				local y = oufdb.SoulShards.Lock and 0.5 or oufdb.SoulShards.Y
				
				self.SoulShards = CreateFrame('Frame', nil, self)
				self.SoulShards:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', x, y)
				self.SoulShards:SetHeight(oufdb.SoulShards.Height)
				self.SoulShards:SetWidth(oufdb.SoulShards.Width)
				
				for i = 1, 3 do
					self.SoulShards[i] = CreateFrame('StatusBar', nil, self.SoulShards)
					self.SoulShards[i]:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.SoulShards.Texture))
					self.SoulShards[i]:SetStatusBarColor(unpack(colors.soulshardbar[i]))
					self.SoulShards[i]:SetSize(((oufdb.SoulShards.Width - 2*oufdb.SoulShards.Padding) / 3), oufdb.SoulShards.Height)
					self.SoulShards[i]:SetBackdrop(backdrop)
					self.SoulShards[i]:SetBackdropColor(0.08, 0.08, 0.08)
					
					if i == 1 then
						self.SoulShards[i]:SetPoint("LEFT", self.SoulShards, "LEFT", 0, 0)
					else
						self.SoulShards[i]:SetPoint("LEFT", self.SoulShards[i-1], "RIGHT", oufdb.SoulShards.Padding, 0)
					end
					
					self.SoulShards[i]:SetAlpha(.4)
				end
				
				self.SoulShards.FrameBackdrop = CreateFrame("Frame", nil, self.SoulShards)
				self.SoulShards.FrameBackdrop:SetPoint("TOPLEFT", self.SoulShards, "TOPLEFT", -3.5, 3)
				self.SoulShards.FrameBackdrop:SetPoint("BOTTOMRIGHT", self.SoulShards, "BOTTOMRIGHT", 3.5, -3)
				self.SoulShards.FrameBackdrop:SetFrameStrata("BACKGROUND")
				self.SoulShards.FrameBackdrop:SetBackdrop {
					edgeFile = glowTex, edgeSize = 5,
					insets = {left = 3, right = 3, top = 3, bottom = 3}
				}
				self.SoulShards.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
				self.SoulShards.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
				
				self.SoulShards.Override = UpdateShards
			end
			if oufdb.SoulShards.Enable == true then self.CreateSoulShards() end
		end
		
		------------------------------------------------------------------------
		--	Druid Eclipse
		------------------------------------------------------------------------	
	
		if class == "DRUID" then
			self.CreateEclipseBar = function()
				local x = oufdb.Eclipse.Lock and 0 or oufdb.Eclipse.X
				local y = oufdb.Eclipse.Lock and 0.5 or oufdb.Eclipse.Y
				
				self.EclipseBar = CreateFrame('Frame', nil, self)
				self.EclipseBar:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', x, y)
				self.EclipseBar:SetHeight(oufdb.Eclipse.Height)
				self.EclipseBar:SetWidth(oufdb.Eclipse.Width)
				self.EclipseBar.ShowText = oufdb.Eclipse.Text.Enable
				self.EclipseBar.PostUnitAura = eclipseBarBuff
				self.EclipseBar.PostUpdatePower = PostEclipseUpdate
				self.EclipseBar.PostUpdateVisibility = function()
					LUI:GetModule("Forte"):SetPosForte()
				end
				
				self.EclipseBar.LunarBar = CreateFrame('StatusBar', nil, self.EclipseBar)
				self.EclipseBar.LunarBar:SetAllPoints(self.EclipseBar)
				self.EclipseBar.LunarBar:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.Eclipse.Texture))
				self.EclipseBar.LunarBar:SetStatusBarColor(unpack(colors.eclipsebar["lunar"]))
				
				self.EclipseBar.SolarBar = CreateFrame('StatusBar', nil, self.EclipseBar)
				self.EclipseBar.SolarBar:SetPoint('TOPLEFT', self.EclipseBar.LunarBar:GetStatusBarTexture(), 'TOPRIGHT')
				self.EclipseBar.SolarBar:SetPoint('BOTTOMLEFT', self.EclipseBar.LunarBar:GetStatusBarTexture(), 'BOTTOMRIGHT')
				self.EclipseBar.SolarBar:SetWidth(oufdb.Eclipse.Width)
				self.EclipseBar.SolarBar:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.Eclipse.Texture))
				self.EclipseBar.SolarBar:SetStatusBarColor(unpack(colors.eclipsebar["solar"]))
				
				self.EclipseBar.spark = self.EclipseBar:CreateTexture(nil, "OVERLAY")
				self.EclipseBar.spark:SetPoint("TOP", self.EclipseBar, "TOP")
				self.EclipseBar.spark:SetPoint("BOTTOM", self.EclipseBar, "BOTTOM")
				self.EclipseBar.spark:SetWidth(2)
				self.EclipseBar.spark:SetTexture(1,1,1,1)
					
				self.EclipseBar.FrameBackdrop = CreateFrame("Frame", nil, self.EclipseBar)
				self.EclipseBar.FrameBackdrop:SetPoint("TOPLEFT", self.EclipseBar, "TOPLEFT", -3.5, 3)
				self.EclipseBar.FrameBackdrop:SetPoint("BOTTOMRIGHT", self.EclipseBar, "BOTTOMRIGHT", 3.5, -3)
				self.EclipseBar.FrameBackdrop:SetFrameStrata("BACKGROUND")
				self.EclipseBar.FrameBackdrop:SetBackdrop({
					edgeFile = glowTex, edgeSize = 5,
					insets = {left = 3, right = 3, top = 3, bottom = 3}
				})
				self.EclipseBar.FrameBackdrop:SetBackdropColor(0, 0, 0, 1)
				self.EclipseBar.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
				
				self.EclipseBar.LunarText = SetFontString(self.EclipseBar.LunarBar, LSM:Fetch("font", oufdb.Eclipse.Text.Font), tonumber(oufdb.Eclipse.Text.Size), oufdb.Eclipse.Text.Outline)
				self.EclipseBar.LunarText:SetPoint("LEFT", self.EclipseBar, "LEFT", tonumber(oufdb.Eclipse.Text.X), tonumber(oufdb.Eclipse.Text.Y))
				
				self.EclipseBar.SolarText = SetFontString(self.EclipseBar.SolarBar, LSM:Fetch("font", oufdb.Eclipse.Text.Font), tonumber(oufdb.Eclipse.Text.Size), oufdb.Eclipse.Text.Outline)
				self.EclipseBar.SolarText:SetPoint("RIGHT", self.EclipseBar, "RIGHT", -tonumber(oufdb.Eclipse.Text.X), tonumber(oufdb.Eclipse.Text.Y))
				if oufdb.Eclipse.Text.Enable == false then
					self.EclipseBar.LunarText:Hide()
					self.EclipseBar.SolarText:Hide()
				end
			end
			if oufdb.Eclipse.Enable == true then self.CreateEclipseBar() end
		end
		
		------------------------------------------------------------------------
		--	Druid Mana (in cat and bear form)
		------------------------------------------------------------------------

		if class == "DRUID" then
			self.CreateDruidMana = function()
				self.DruidMana = CreateFrame("Frame", self:GetName().."_DruidMana", self)
				self.DruidMana:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, oufdb.DruidMana.Padding)
				self.DruidMana:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, oufdb.DruidMana.Padding)
				self.DruidMana:SetFrameLevel(self.Power:GetFrameLevel()-1)
				self.DruidMana:Hide()
				
				self.DruidMana.ManaBar = CreateFrame("StatusBar", nil, self.DruidMana)
				self.DruidMana.ManaBar:SetAllPoints(self.DruidMana)
				self.DruidMana.ManaBar:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.DruidMana.Texture))
				
				self.DruidMana.bg = self.DruidMana:CreateTexture(nil, 'BORDER')
				self.DruidMana.bg:SetAllPoints(self.DruidMana)
				self.DruidMana.bg:SetTexture(LSM:Fetch("statusbar", oufdb.DruidMana.TextureBG))
				self.DruidMana.bg:SetAlpha(oufdb.DruidMana.BGAlpha)
				self.DruidMana.bg.multiplier = oufdb.DruidMana.BGMultiplier
				
				self.DruidMana.Smooth = oufdb.DruidMana.Smooth
				
				self.DruidMana.value = SetFontString(self.DruidMana.ManaBar, LSM:Fetch("font", oufdb.Texts.DruidMana.Font), oufdb.Texts.DruidMana.Size, oufdb.Texts.DruidMana.Outline)
				self.DruidMana.value:SetPoint('CENTER', self.DruidMana.ManaBar, 'CENTER')
				self:Tag(self.DruidMana.value, "[druidmana2]")
				
				self.DruidMana.SetPosition = function()
					if (not oufdb.DruidMana.Enable) or (oufdb.DruidMana.OverPower and not self.DruidMana:IsShown()) then
						self.XP:ClearAllPoints()
						self.XP:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 2, -3)
						self.XP:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", -2, -3)
						self.Rep:ClearAllPoints()
						self.Rep:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 2, -3)
						self.Rep:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", -2, -3)
						
						self.Power:SetHeight(oufdb.Power.Height)
						self.DruidMana:SetHeight(0)
					else
						self.XP:ClearAllPoints()
						self.XP:SetPoint("TOPLEFT", self.DruidMana, "BOTTOMLEFT", 2, -3)
						self.XP:SetPoint("TOPRIGHT", self.DruidMana, "BOTTOMRIGHT", -2, -3)
						self.Rep:ClearAllPoints()
						self.Rep:SetPoint("TOPLEFT", self.DruidMana, "BOTTOMLEFT", 2, -3)
						self.Rep:SetPoint("TOPRIGHT", self.DruidMana, "BOTTOMRIGHT", -2, -3)
						
						if oufdb.DruidMana.OverPower then
							self.Power:SetHeight((oufdb.Power.Height+tonumber(oufdb.DruidMana.Padding))/2)
							self.DruidMana:SetHeight((oufdb.Power.Height+tonumber(oufdb.DruidMana.Padding))/2)
						else
							self.Power:SetHeight(oufdb.Power.Height)
							self.DruidMana:SetHeight(oufdb.DruidMana.Height)
						end
					end
				end
				
				self.DruidMana:SetScript("OnShow", self.DruidMana.SetPosition)
				self.DruidMana:SetScript("OnHide", self.DruidMana.SetPosition)
				
				if GetShapeshiftFormID() == CAT_FORM or GetShapeshiftFormID() == BEAR_FORM then
					self.DruidMana.SetPosition()
				end
			end
			if oufdb.DruidMana.Enable == true then self.CreateDruidMana() end
		end
	
	end
	
	------------------------------------------------------------------------
	--	Target Specific Items
	------------------------------------------------------------------------
	
	if unit == "target" then
	
		------------------------------------------------------------------------
		--	Combo Points
		------------------------------------------------------------------------	
	
		self.CreateCPoints = function()
			self.CPoints = CreateFrame('Frame', nil, self)
			self.CPoints:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', oufdb.ComboPoints.X, oufdb.ComboPoints.Y)
			self.CPoints:SetHeight(oufdb.ComboPoints.Height)
			self.CPoints:SetWidth(oufdb.ComboPoints.Width)
			self.CPoints.showAlways = oufdb.ComboPoints.ShowAlways
		
			for i = 1, 5 do
				self.CPoints[i] = CreateFrame("StatusBar", nil, self.CPoints)
				if (i == 1) then
					self.CPoints[i]:SetPoint("LEFT", self.CPoints, "LEFT", 0, 0)
				else
					self.CPoints[i]:SetPoint("LEFT", self.CPoints[i-1], "RIGHT", 1, 0)
				end
				self.CPoints[i]:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.ComboPoints.Texture))
				self.CPoints[i]:SetStatusBarColor(unpack(colors.combopoints[i]))	
				self.CPoints[i]:SetHeight(oufdb.ComboPoints.Height)
				self.CPoints[i]:SetWidth((tonumber(oufdb.ComboPoints.Width) -4*oufdb.ComboPoints.Padding) / 5)
				self.CPoints[i]:SetBackdrop(backdrop)
				self.CPoints[i]:SetBackdropColor(0, 0, 0)
				self.CPoints[i]:SetMinMaxValues(0, 1)
	
				self.CPoints[i].bg = self.CPoints[i]:CreateTexture(nil, "BORDER")
				self.CPoints[i].bg:SetAllPoints(self.CPoints[i])
				self.CPoints[i].bg:SetTexture(LSM:Fetch("statusbar", oufdb.ComboPoints.Texture))
				self.CPoints[i].bg.multiplier = tonumber(oufdb.ComboPoints.Multiplier)
				
				if oufdb.ComboPoints.BackgroundColor.Enable == true then
					r = oufdb.ComboPoints.BackgroundColor.r
					g = oufdb.ComboPoints.BackgroundColor.g
					b = oufdb.ComboPoints.BackgroundColor.b
						
					self.CPoints[i].bg:SetVertexColor(r, g, b) 
				else
					local mu = tonumber(oufdb.ComboPoints.Multiplier)
					local r, g, b = self.CPoints[i]:GetStatusBarColor()
					r, g, b = r*mu, g*mu, b*mu
					self.CPoints[i].bg:SetVertexColor(r, g, b) 
				end
			end
			
			self.CPoints.FrameBackdrop = CreateFrame("Frame", nil, self.CPoints)
			self.CPoints.FrameBackdrop:SetPoint("TOPLEFT", self.CPoints, "TOPLEFT", -3, 3)
			self.CPoints.FrameBackdrop:SetPoint("BOTTOMRIGHT", self.CPoints, "BOTTOMRIGHT", 3, -3)
			self.CPoints.FrameBackdrop:SetFrameStrata("BACKGROUND")
			self.CPoints.FrameBackdrop:SetBackdrop {
				edgeFile = glowTex, edgeSize = 4,
				insets = {left = 3, right = 3, top = 3, bottom = 3}
			}
			self.CPoints.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
			self.CPoints.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
			
			self.CPoints.Override = UpdateCPoints
		end
		if oufdb.ComboPoints.Enable == true then self.CreateCPoints() end
	
	end

	------------------------------------------------------------------------
	--	Vehicule Swap
	------------------------------------------------------------------------

	if unit == "pet" then
		self.PostEnterVehicle = EnterVehicle
		self.PostExitVehicle = ExitVehicle
	end

	------------------------------------------------------------------------
	--	Auras
	------------------------------------------------------------------------	

	if unit == "player" or unit == "target" or unit == "focus" or unit == "pet" or unit == "targettarget" then
		self.CreateBuffs = function()
			self.Buffs = CreateFrame("Frame", nil, self)
			self.Buffs:SetHeight(tonumber(oufdb.Aura.buffs_size))
			self.Buffs:SetWidth(tonumber(oufdb.Width))
			self.Buffs.size = tonumber(oufdb.Aura.buffs_size)
			self.Buffs.spacing = tonumber(oufdb.Aura.buffs_spacing)
			self.Buffs.num = tonumber(oufdb.Aura.buffs_num)
				
			self.Buffs:SetPoint(oufdb.Aura.buffs_initialAnchor, self, oufdb.Aura.buffs_initialAnchor, tonumber(oufdb.Aura.buffsX), tonumber(oufdb.Aura.buffsY))
			self.Buffs.initialAnchor = oufdb.Aura.buffs_initialAnchor
			self.Buffs["growth-y"] = oufdb.Aura.buffs_growthY
			self.Buffs["growth-x"] = oufdb.Aura.buffs_growthX
			self.Buffs.onlyShowPlayer = oufdb.Aura.buffs_playeronly
			self.Buffs.showStealableBuffs = class == "MAGE" or class == "SHAMAN"
			self.Buffs.showAuraType = oufdb.Aura.buffs_colorbytype
			self.Buffs.showAuratimer = oufdb.Aura.buffs_auratimer
			self.Buffs.disableCooldown = oufdb.Aura.buffs_disableCooldown
			self.Buffs.cooldownReverse = oufdb.Aura.buffs_cooldownReverse
			
			self.Buffs.PostCreateIcon = PostCreateAura
			self.Buffs.PostUpdateIcon = PostUpdateAura
		end
		if oufdb.Aura.buffs_enable then self.CreateBuffs() end
		
		self.CreateDebuffs = function()
			self.Debuffs = CreateFrame("Frame", nil, self)
			self.Debuffs:SetHeight(tonumber(oufdb.Aura.debuffs_size))
			self.Debuffs:SetWidth(tonumber(oufdb.Width))
			self.Debuffs.size = tonumber(oufdb.Aura.debuffs_size)
			self.Debuffs.spacing = tonumber(oufdb.Aura.debuffs_spacing)
			self.Debuffs.num = tonumber(oufdb.Aura.debuffs_num)
				
			self.Debuffs:SetPoint(oufdb.Aura.debuffs_initialAnchor, self, oufdb.Aura.debuffs_initialAnchor, tonumber(oufdb.Aura.debuffsX), tonumber(oufdb.Aura.debuffsY))
			self.Debuffs.initialAnchor = oufdb.Aura.debuffs_initialAnchor
			self.Debuffs["growth-y"] = oufdb.Aura.debuffs_growthY
			self.Debuffs["growth-x"] = oufdb.Aura.debuffs_growthX
			self.Debuffs.onlyShowPlayer = oufdb.Aura.debuffs_playeronly
			self.Debuffs.showAuraType = oufdb.Aura.debuffs_colorbytype
			self.Debuffs.showAuratimer = oufdb.Aura.debuffs_auratimer
			self.Debuffs.disableCooldown = oufdb.Aura.debuffs_disableCooldown
			self.Debuffs.cooldownReverse = oufdb.Aura.debuffs_cooldownReverse
			
			self.Debuffs.PostCreateIcon = PostCreateAura
			self.Debuffs.PostUpdateIcon = PostUpdateAura
		end
		if oufdb.Aura.debuffs_enable then self.CreateDebuffs() end
	end
		
	------------------------------------------------------------------------
	--	Combat text
	------------------------------------------------------------------------	
	
	if unit == "player" or unit == "target" or unit == "focus" or unit == "pet" or unit == "targettarget" then
		self.CreateCombatFeedbackText = function()
			self.CombatFeedbackText = SetFontString(self.Health, LSM:Fetch("font", oufdb.Texts.Combat.Font), tonumber(oufdb.Texts.Combat.Size), oufdb.Texts.Combat.Outline)
			self.CombatFeedbackText:SetPoint(oufdb.Texts.Combat.Point, self, oufdb.Texts.Combat.RelativePoint, tonumber(oufdb.Texts.Combat.X), tonumber(oufdb.Texts.Combat.Y))
			self.CombatFeedbackText.ignoreImmune = not oufdb.Texts.Combat.ShowImmune
			self.CombatFeedbackText.ignoreDamage = not oufdb.Texts.Combat.ShowDamage
			self.CombatFeedbackText.ignoreHeal = not oufdb.Texts.Combat.ShowHeal
			self.CombatFeedbackText.ignoreEnergize = not oufdb.Texts.Combat.ShowEnergize
			self.CombatFeedbackText.ignoreOther = not oufdb.Texts.Combat.ShowOther
			self.CombatFeedbackText.colors = colors.combattext
		end
		self.CreateCombatFeedbackText()
		if oufdb.Texts.Combat.Enable == false then
			self.CombatFeedbackText.ignoreImmune = true
			self.CombatFeedbackText.ignoreDamage = true
			self.CombatFeedbackText.ignoreHeal = true
			self.CombatFeedbackText.ignoreEnergize = true
			self.CombatFeedbackText.ignoreOther = true
			self.CombatFeedbackText:Hide()
		end
	end
	
	------------------------------------------------------------------------
	--	Castbar
	------------------------------------------------------------------------

	if unit == "player" or unit == "target" or unit == "focus" or unit == "pet" then
		self.CreateCastbar = function()
			local pClass, pToken = UnitClass("player")
			local color = colors.class[pToken]
			
			self.Castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			self.Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", oufdb.Castbar.Texture))
			self.Castbar:SetFrameLevel(6)
			self.Castbar:SetHeight(tonumber(oufdb.Castbar.Height))
			self.Castbar:SetWidth(tonumber(oufdb.Castbar.Width))
			if unit == "player" or unit == "target" then
				self.Castbar:SetPoint("BOTTOM", UIParent, "BOTTOM", tonumber(oufdb.Castbar.X), tonumber(oufdb.Castbar.Y))
			else
				self.Castbar:SetPoint("TOP", self, "BOTTOM", tonumber(oufdb.Castbar.X), tonumber(oufdb.Castbar.Y))
			end
			
			self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
			self.Castbar.bg:SetAllPoints(self.Castbar)
			self.Castbar.bg:SetTexture(LSM:Fetch("statusbar", oufdb.Castbar.TextureBG ))
				
			self.CastbarBackdrop = CreateFrame("Frame", nil, self)
			self.CastbarBackdrop:SetPoint("TOPLEFT", self.Castbar, "TOPLEFT", -4, 3)
			self.CastbarBackdrop:SetPoint("BOTTOMRIGHT", self.Castbar, "BOTTOMRIGHT", 3, -3.5)
			self.CastbarBackdrop:SetParent(self.Castbar)
			
			if oufdb.Castbar.IndividualColor == true then
				self.Castbar:SetStatusBarColor(oufdb.Castbar.Colors.Bar.r,oufdb.Castbar.Colors.Bar.g,oufdb.Castbar.Colors.Bar.b,oufdb.Castbar.Colors.Bar.a)
				self.Castbar.bg:SetVertexColor(oufdb.Castbar.Colors.Background.r,oufdb.Castbar.Colors.Background.g,oufdb.Castbar.Colors.Background.b,oufdb.Castbar.Colors.Background.a)
					
				self.CastbarBackdrop:SetBackdrop({
				edgeFile = LSM:Fetch("border", oufdb.Castbar.Border.Texture), edgeSize = oufdb.Castbar.Border.Thickness,
					insets = {left = oufdb.Castbar.Border.Inset.left, right = oufdb.Castbar.Border.Inset.right, top = oufdb.Castbar.Border.Inset.top, bottom = oufdb.Castbar.Border.Inset.bottom}
				})
				self.CastbarBackdrop:SetBackdropColor(0, 0, 0, 0)
				self.CastbarBackdrop:SetBackdropBorderColor(oufdb.Castbar.Colors.Border.r,oufdb.Castbar.Colors.Border.g,oufdb.Castbar.Colors.Border.b,oufdb.Castbar.Colors.Border.a)
			else
				self.Castbar.bg:SetVertexColor(0.15, 0.15, 0.15, 0.75)
				self.Castbar:SetStatusBarColor(color[1],color[2],color[3],0.68)
				
				self.CastbarBackdrop:SetBackdrop({
				edgeFile = LSM:Fetch("border", oufdb.Castbar.Border.Texture), edgeSize = oufdb.Castbar.Border.Thickness,
					insets = {left = oufdb.Castbar.Border.Inset.left, right = oufdb.Castbar.Border.Inset.right, top = oufdb.Castbar.Border.Inset.top, bottom = oufdb.Castbar.Border.Inset.bottom}
				})
				self.CastbarBackdrop:SetBackdropColor(0, 0, 0, 0)
				self.CastbarBackdrop:SetBackdropBorderColor(0, 0, 0, 0.7)
			end
					
			self.Castbar.Time = SetFontString(self.Castbar, LSM:Fetch("font", oufdb.Castbar.Text.Time.Font), oufdb.Castbar.Text.Time.Size)
			self.Castbar.Time:SetPoint("RIGHT", self.Castbar, "RIGHT", oufdb.Castbar.Text.Time.OffsetX, oufdb.Castbar.Text.Time.OffsetY)
			self.Castbar.Time:SetTextColor(oufdb.Castbar.Colors.Time.r, oufdb.Castbar.Colors.Time.g, oufdb.Castbar.Colors.Time.b)
			self.Castbar.Time:SetJustifyH("RIGHT")
			self.Castbar.Time.ShowMax = oufdb.Castbar.Text.Time.ShowMax
			self.Castbar.CustomTimeText = FormatCastbarTime
			
			if oufdb.Castbar.Text.Time.Enable == false then
				self.Castbar.Time:Hide()
			end
				
			self.Castbar.Text = SetFontString(self.Castbar, LSM:Fetch("font", oufdb.Castbar.Text.Name.Font), oufdb.Castbar.Text.Name.Size)
			self.Castbar.Text:SetPoint("LEFT", self.Castbar, "LEFT", oufdb.Castbar.Text.Name.OffsetX, oufdb.Castbar.Text.Name.OffsetY)
			self.Castbar.Text:SetTextColor(oufdb.Castbar.Colors.Name.r, oufdb.Castbar.Colors.Name.r, oufdb.Castbar.Colors.Name.r)
				
			if oufdb.Castbar.Text.Name.Enable == false then
				self.Castbar.Text:Hide()
			end
				
			self.Castbar.CreateIcon = function()
				self.Castbar.Icon = self.Castbar:CreateTexture(nil, "ARTWORK")
				self.Castbar.Icon:SetHeight(28.5)
				self.Castbar.Icon:SetWidth(28.5)
				self.Castbar.Icon:SetTexCoord(0, 1, 0, 1)
				self.Castbar.Icon:SetPoint("LEFT", -41.5, 0)
	
				self.Castbar.IconOverlay = self.Castbar:CreateTexture(nil, "OVERLAY")
				self.Castbar.IconOverlay:SetPoint("TOPLEFT", self.Castbar.Icon, "TOPLEFT", -1.5, 1)
				self.Castbar.IconOverlay:SetPoint("BOTTOMRIGHT", self.Castbar.Icon, "BOTTOMRIGHT", 1, -1)
				self.Castbar.IconOverlay:SetTexture(buttonTex)
				self.Castbar.IconOverlay:SetVertexColor(1, 1, 1)
	
				self.Castbar.IconBackdrop = CreateFrame("Frame", nil, self.Castbar)
				self.Castbar.IconBackdrop:SetPoint("TOPLEFT", self.Castbar.Icon, "TOPLEFT", -4, 3)
				self.Castbar.IconBackdrop:SetPoint("BOTTOMRIGHT", self.Castbar.Icon, "BOTTOMRIGHT", 3, -3.5)
				self.Castbar.IconBackdrop:SetBackdrop({
					edgeFile = glowTex, edgeSize = 4,
					insets = {left = 3, right = 3, top = 3, bottom = 3}
				})
				self.Castbar.IconBackdrop:SetBackdropColor(0, 0, 0, 0)
				self.Castbar.IconBackdrop:SetBackdropBorderColor(0, 0, 0, 0.7)
			end
			if oufdb.Castbar.Icon == true then self.Castbar.CreateIcon() end
				
			if oufdb.Castbar.Latency == true then
				self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "ARTWORK")
				self.Castbar.SafeZone:SetTexture(normTex)
					
				if oufdb.Castbar.IndividualColor == true then
					self.Castbar.SafeZone:SetVertexColor(oufdb.Castbar.Colors.Latency.r,oufdb.Castbar.Colors.Latency.g,oufdb.Castbar.Colors.Latency.b,oufdb.Castbar.Colors.Latency.a)
				else
					self.Castbar.SafeZone:SetVertexColor(0.11,0.11,0.11,0.6)
				end
			end
		end
		if db.oUF.Settings.Castbars == true and oufdb.Castbar.Enable == true then self.CreateCastbar() end
	end
	
	------------------------------------------------------------------------
	--	Aggro Glow
	------------------------------------------------------------------------
	
	if unit == "player" or unit == "target" or unit == "focus" or unit == "pet" or unit == "vehicle" then
		self.CreateThreat = function()
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
			
			self.Threat.Override = ThreatOverride
		end
		if oufdb.Border.Aggro == true then self.CreateThreat() end
	end
	
	------------------------------------------------------------------------
	--	Colors / Settings
	------------------------------------------------------------------------
	
	self.Health.colorClass = oufdb.Health.ColorClass
	self.Health.colorTapping = (unit == "target") and oufdb.Health.Tapping or false
	self.Health.colorDisconnected = false
	self.Health.colorSmooth = oufdb.Health.ColorGradient
	self.Health.colorHappy = (unit == "pet") and oufdb.Health.ColorHappy or false
	self.Health.colorIndividual = oufdb.Health.IndividualColor
	self.Health.Smooth = oufdb.Health.Smooth
	self.Health.colorReaction = false
	self.Health.frequentUpdates = false
	
	self.Health.value.Enable = oufdb.Texts.Health.Enable
	self.Health.value.ShowAlways = oufdb.Texts.Health.ShowAlways
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
	self.Power.value.ShowAlways = oufdb.Texts.Power.ShowAlways
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
		
	------------------------------------------------------------------------
	--	V2 Textures
	------------------------------------------------------------------------

	if unit == "targettarget" then
		self.CreateV2Textures = function()
			local Panel2 = CreateFrame("Frame", nil, self)
			Panel2:SetFrameLevel(20)
			Panel2:SetFrameStrata("BACKGROUND")
			Panel2:SetHeight(2)
			Panel2:SetWidth(60)
			Panel2:SetPoint("LEFT", self.Health, "LEFT", -50, -1)
			Panel2:SetScale(1)
			Panel2:SetBackdrop(backdrop2)
			Panel2:SetBackdropColor(0,0,0,1)
			Panel2:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel2:Show()
			
			local Panel3 = CreateFrame("Frame", nil, Panel2)
			Panel3:SetFrameLevel(20)
			Panel3:SetFrameStrata("BACKGROUND")
			Panel3:SetHeight(50)
			Panel3:SetWidth(2)
			Panel3:SetPoint("LEFT", self.Health, "LEFT", -50, 23)
			Panel3:SetScale(1)
			Panel3:SetBackdrop(backdrop2)
			Panel3:SetBackdropColor(0,0,0,1)
			Panel3:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel3:Show()
			
			local Panel4 = CreateFrame("Frame", nil, Panel2)
			Panel4:SetFrameLevel(20)
			Panel4:SetFrameStrata("BACKGROUND")
			Panel4:SetHeight(2)
			Panel4:SetWidth(60)
			Panel4:SetPoint("RIGHT", self.Health, "RIGHT", 50, -1)
			Panel4:SetScale(1)
			Panel4:SetBackdrop(backdrop2)
			Panel4:SetBackdropColor(0,0,0,1)
			Panel4:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel4:Show()
			
			local Panel5 = CreateFrame("Frame", nil, Panel2)
			Panel5:SetFrameLevel(20)
			Panel5:SetFrameStrata("BACKGROUND")
			Panel5:SetHeight(6)
			Panel5:SetWidth(6)
			Panel5:SetPoint("RIGHT", self.Health, "RIGHT", 52, -1)
			Panel5:SetScale(1)
			Panel5:SetBackdrop(backdrop2)
			Panel5:SetBackdropColor(0,0,0,1)
			Panel5:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel5:Show()
			
			self.V2Tex = Panel2
		end
	elseif unit == "targettargettarget" then
		self.CreateV2Textures = function()
			local Panel2 = CreateFrame("Frame", nil, self)
			Panel2:SetFrameLevel(20)
			Panel2:SetFrameStrata("BACKGROUND")
			Panel2:SetHeight(2)
			Panel2:SetWidth(60)
			Panel2:SetPoint("LEFT", self.Health, "LEFT", -50, -1)
			Panel2:SetScale(1)
			Panel2:SetBackdrop(backdrop2)
			Panel2:SetBackdropColor(0,0,0,1)
			Panel2:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel2:Show()
			
			local Panel3 = CreateFrame("Frame", nil, Panel2)
			Panel3:SetFrameLevel(20)
			Panel3:SetFrameStrata("BACKGROUND")
			Panel3:SetHeight(35)
			Panel3:SetWidth(2)
			Panel3:SetPoint("LEFT", self.Health, "LEFT", -50, 16)
			Panel3:SetScale(1)
			Panel3:SetBackdrop(backdrop2)
			Panel3:SetBackdropColor(0,0,0,1)
			Panel3:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel3:Show()
			
			local Panel4 = CreateFrame("Frame", nil, Panel2)
			Panel4:SetFrameLevel(20)
			Panel4:SetFrameStrata("BACKGROUND")
			Panel4:SetHeight(2)
			Panel4:SetWidth(60)
			Panel4:SetPoint("RIGHT", self.Health, "RIGHT", 50, -1)
			Panel4:SetScale(1)
			Panel4:SetBackdrop(backdrop2)
			Panel4:SetBackdropColor(0,0,0,1)
			Panel4:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel4:Show()
			
			local Panel5 = CreateFrame("Frame", nil, Panel2)
			Panel5:SetFrameLevel(20)
			Panel5:SetFrameStrata("BACKGROUND")
			Panel5:SetHeight(6)
			Panel5:SetWidth(6)
			Panel5:SetPoint("RIGHT", self.Health, "RIGHT", 52, -1)
			Panel5:SetScale(1)
			Panel5:SetBackdrop(backdrop2)
			Panel5:SetBackdropColor(0,0,0,1)
			Panel5:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel5:Show()
			
			local Panel6 = CreateFrame("Frame", nil, Panel2)
			Panel6:SetFrameLevel(20)
			Panel6:SetFrameStrata("BACKGROUND")
			Panel6:SetHeight(6)
			Panel6:SetWidth(6)
			Panel6:SetPoint("LEFT", self.Health, "LEFT", -52, 34)
			Panel6:SetScale(1)
			Panel6:SetBackdrop(backdrop2)
			Panel6:SetBackdropColor(0,0,0,1)
			Panel6:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel6:Show()
			
			self.V2Tex = Panel2
		end
	elseif unit == "focustarget" then
		self.CreateV2Textures = function()
			local Panel2 = CreateFrame("Frame", nil, self)
			Panel2:SetFrameLevel(20)
			Panel2:SetFrameStrata("BACKGROUND")
			Panel2:SetHeight(2)
			Panel2:SetWidth(60)
			Panel2:SetPoint("LEFT", self.Health, "LEFT", -50, -1)
			Panel2:SetScale(1)
			Panel2:SetBackdrop(backdrop2)
			Panel2:SetBackdropColor(0,0,0,1)
			Panel2:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel2:Show()
			
			local Panel3 = CreateFrame("Frame", nil, Panel2)
			Panel3:SetFrameLevel(20)
			Panel3:SetFrameStrata("BACKGROUND")
			Panel3:SetHeight(35)
			Panel3:SetWidth(2)
			Panel3:SetPoint("RIGHT", self.Health, "RIGHT", 50, 16)
			Panel3:SetScale(1)
			Panel3:SetBackdrop(backdrop2)
			Panel3:SetBackdropColor(0,0,0,1)
			Panel3:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel3:Show()
			
			local Panel4 = CreateFrame("Frame", nil, Panel2)
			Panel4:SetFrameLevel(20)
			Panel4:SetFrameStrata("BACKGROUND")
			Panel4:SetHeight(2)
			Panel4:SetWidth(60)
			Panel4:SetPoint("RIGHT", self.Health, "RIGHT", 50, -1)
			Panel4:SetScale(1)
			Panel4:SetBackdrop(backdrop2)
			Panel4:SetBackdropColor(0,0,0,1)
			Panel4:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel4:Show()
			
			local Panel5 = CreateFrame("Frame", nil, Panel2)
			Panel5:SetFrameLevel(20)
			Panel5:SetFrameStrata("BACKGROUND")
			Panel5:SetHeight(6)
			Panel5:SetWidth(6)
			Panel5:SetPoint("LEFT", self.Health, "LEFT", -52, -1)
			Panel5:SetScale(1)
			Panel5:SetBackdrop(backdrop2)
			Panel5:SetBackdropColor(0,0,0,1)
			Panel5:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel5:Show()
			
			local Panel6 = CreateFrame("Frame", nil, Panel2)
			Panel6:SetFrameLevel(20)
			Panel6:SetFrameStrata("BACKGROUND")
			Panel6:SetHeight(6)
			Panel6:SetWidth(6)
			Panel6:SetPoint("RIGHT", self.Health, "RIGHT", 52, 34)
			Panel6:SetScale(1)
			Panel6:SetBackdrop(backdrop2)
			Panel6:SetBackdropColor(0,0,0,1)
			Panel6:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel6:Show()
			
			self.V2Tex = Panel2
		end
	elseif unit == "focus" then
		self.CreateV2Textures = function()
			local Panel2 = CreateFrame("Frame", nil, self)
			Panel2:SetFrameLevel(20)
			Panel2:SetFrameStrata("BACKGROUND")
			Panel2:SetHeight(2)
			Panel2:SetWidth(60)
			Panel2:SetPoint("RIGHT", self.Health, "RIGHT", 50, -1)
			Panel2:SetScale(1)
			Panel2:SetBackdrop(backdrop2)
			Panel2:SetBackdropColor(0,0,0,1)
			Panel2:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel2:Show()
			
			local Panel3 = CreateFrame("Frame", nil, Panel2)
			Panel3:SetFrameLevel(20)
			Panel3:SetFrameStrata("BACKGROUND")
			Panel3:SetHeight(50)
			Panel3:SetWidth(2)
			Panel3:SetPoint("RIGHT", self.Health, "RIGHT", 50, 23)
			Panel3:SetScale(1)
			Panel3:SetBackdrop(backdrop2)
			Panel3:SetBackdropColor(0,0,0,1)
			Panel3:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel3:Show()
			
			local Panel4 = CreateFrame("Frame", nil, Panel2)
			Panel4:SetFrameLevel(20)
			Panel4:SetFrameStrata("BACKGROUND")
			Panel4:SetHeight(2)
			Panel4:SetWidth(50)
			Panel4:SetPoint("LEFT", self.Health, "LEFT", -50, -1)
			Panel4:SetScale(1)
			Panel4:SetBackdrop(backdrop2)
			Panel4:SetBackdropColor(0,0,0,1)
			Panel4:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel4:Show()
			
			local Panel5 = CreateFrame("Frame", nil, Panel2)
			Panel5:SetFrameLevel(20)
			Panel5:SetFrameStrata("BACKGROUND")
			Panel5:SetHeight(6)
			Panel5:SetWidth(6)
			Panel5:SetPoint("LEFT", self.Health, "LEFT", -52, -1)
			Panel5:SetScale(1)
			Panel5:SetBackdrop(backdrop2)
			Panel5:SetBackdropColor(0,0,0,1)
			Panel5:SetBackdropBorderColor(0.1,0.1,0.1,1)
			Panel5:Show()
			
			self.V2Tex = Panel2
		end
	end
	if db.oUF.Settings.show_v2_textures == true and self.CreateV2Textures then self.CreateV2Textures() end
	
	--  highlight 
	self.CreateHighlight = function()
		self.Highlight = self.Health:CreateTexture(nil, "OVERLAY")
		self.Highlight:SetAllPoints(self)
		self.Highlight:SetTexture(highlightTex)
		self.Highlight:SetVertexColor(1,1,1,.1)
		self.Highlight:SetBlendMode("ADD")
		self.Highlight:Hide()
	end
	if highlight then self.CreateHighlight() end

	self.SpellRange = true
	self.BarFade = false

	self.Health.PostUpdate = PostUpdateHealth
	self.Power.PostUpdate = PostUpdatePower
	
	self:RegisterEvent("PLAYER_FLAGS_CHANGED", function(self) self.Health:ForceUpdate() end)
	
	return self
end

oUF:RegisterStyle("LUI", SetStyle)
oUF:SetActiveStyle("LUI")

oUF:Spawn("player", "oUF_LUI_player"):SetPoint("CENTER", UIParent, "CENTER", tonumber(db.oUF.Player.X), tonumber(db.oUF.Player.Y))
oUF:Spawn("target", "oUF_LUI_target"):SetPoint("CENTER", UIParent, "CENTER", tonumber(db.oUF.Target.X), tonumber(db.oUF.Target.Y))

if db.oUF.Focus.Enable == true then oUF:Spawn("focus", "oUF_LUI_focus"):SetPoint("CENTER", UIParent, "CENTER", tonumber(db.oUF.Focus.X), tonumber(db.oUF.Focus.Y)) end
if db.oUF.FocusTarget.Enable == true then oUF:Spawn("focustarget", "oUF_LUI_focustarget"):SetPoint("CENTER", UIParent, "CENTER", tonumber(db.oUF.FocusTarget.X), tonumber(db.oUF.FocusTarget.Y)) end

if db.oUF.ToT.Enable == true then oUF:Spawn("targettarget", "oUF_LUI_targettarget"):SetPoint("CENTER", UIParent, "CENTER", tonumber(db.oUF.ToT.X), tonumber(db.oUF.ToT.Y)) end
if db.oUF.ToToT.Enable == true then oUF:Spawn("targettargettarget", "oUF_LUI_targettargettarget"):SetPoint("CENTER", UIParent, "CENTER", tonumber(db.oUF.ToToT.X), tonumber(db.oUF.ToToT.Y)) end

if db.oUF.Pet.Enable == true then oUF:Spawn("pet", "oUF_LUI_pet"):SetPoint("CENTER", UIParent, "CENTER", tonumber(db.oUF.Pet.X), tonumber(db.oUF.Pet.Y)) end
if db.oUF.PetTarget.Enable == true then oUF:Spawn("pettarget", "oUF_LUI_pettarget"):SetPoint("CENTER", UIParent, "CENTER", tonumber(db.oUF.PetTarget.X), tonumber(db.oUF.PetTarget.Y)) end
