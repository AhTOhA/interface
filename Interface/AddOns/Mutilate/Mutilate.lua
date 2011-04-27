--
-- Mutilate --
-- 

-- Our base array
Mutilate = {}

-- Mutilate variables NOT SAVED
Mutilate.versionNumber = 1.11
Mutilate.currentTarget = ""
Mutilate.lastTarget = ""


-- Define list of terms that need translation.
function FM_GetSpellNameById(spellId)
	if (spellId == nil) then
		return nil
	end
		local spellName, rank, _, _, _, _, _, _, _ = GetSpellInfo(spellId)
	if rank==nil then
	return spellName
	elseif string.len(rank)>1 then
		return spellName.."("..rank..")"
	end
	return spellName
end

function FM_GetSpellEnergyById(spellId)
	if (spellId == nil) then
		return nil
	end
		local spellName, _, _, cost, _, _, _, _, _ = GetSpellInfo(spellId)
					
	return cost
end


Mutilate.L = {
    ["Vendetta"]            = "Vendetta",
	["Garrote"]             = "Garrote",
	["Slice and Dice"]      = "Slice and Dice",
	["Mutilate"]            = "Mutilate",
	["Envenom"]             = "Envenom",
	["Rupture"]             = "Rupture",
	["Cold Blood"]          = "Cold Blood",
	["Tricks of the Trade"] = "Tricks of the Trade",
	["Vanish"]              = "Vanish",
	["Backstab"]            = "Backstab",
	["Overkill"]			= "Overkill"
}

Mutilate.E = {
    ["Vendetta"]            = 0,
	["Garrote"]             = 0,
	["Slice and Dice"]      = 0,
	["Mutilate"]            = 0,
	["Envenom"]             = 0,
	["Rupture"]             = 0,
	["Cold Blood"]          = 0,
	["Tricks of the Trade"] = 0,
	["Vanish"]              = 0,
	["Backstab"]            = 0,
	["Overkill"]			= 0
}

Mutilate.textureList = {
  ["last"] = nil,
  ["current"] = nil,
  ["next"] = nil,
  ["misc"] = nil,
  ["int"] = nil,
  ["vendetta"] = nil,
}


	
local language = GetLocale();

Mutilate.L["Vendetta"]            = FM_GetSpellNameById(79140)
Mutilate.L["Garrote"]             = FM_GetSpellNameById(703)
Mutilate.L["Slice and Dice"]      = FM_GetSpellNameById(5171)
Mutilate.L["Mutilate"]            = FM_GetSpellNameById(1329)
Mutilate.L["Envenom"]             = FM_GetSpellNameById(32645)
Mutilate.L["Rupture"]             = FM_GetSpellNameById(1943)
Mutilate.L["Cold Blood"]          = FM_GetSpellNameById(14177)
Mutilate.L["Tricks of the Trade"] = FM_GetSpellNameById(57934)
Mutilate.L["Vanish"]              = FM_GetSpellNameById(1856)
Mutilate.L["Backstab"]            = FM_GetSpellNameById(53)
Mutilate.E["Overkill"]            = FM_GetSpellNameById(58426)


Mutilate.timeSinceLastUpdate = 0
Mutilate.playerName = UnitName("player")
Mutilate.spellHaste = GetCombatRatingBonus(20)


-- Our sneaky frame to watch for events ... checks Mutilate.events[] for the function.  Passes all args.
Mutilate.eventFrame = CreateFrame("Frame")
Mutilate.eventFrame:SetScript("OnEvent", function(this, event, ...)
  Mutilate.events[event](...)
end)

Mutilate.eventFrame:RegisterEvent("ADDON_LOADED")
Mutilate.eventFrame:RegisterEvent("PLAYER_LOGIN")
Mutilate.eventFrame:RegisterEvent("PLAYER_ALIVE")
Mutilate.eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
Mutilate.eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
Mutilate.eventFrame:RegisterEvent("SPELLS_CHANGED")


-- Define our Event Handlers here
Mutilate.events = {}

function Mutilate.events.SPELLS_CHANGED()

	Mutilate.E["Vendetta"]            = FM_GetSpellEnergyById(79140)
	Mutilate.E["Garrote"]             = FM_GetSpellEnergyById(703)
	Mutilate.E["Slice and Dice"]      = FM_GetSpellEnergyById(5171)
	Mutilate.E["Mutilate"]            = FM_GetSpellEnergyById(1329)
	Mutilate.E["Envenom"]             = FM_GetSpellEnergyById(32645)
	Mutilate.E["Rupture"]             = FM_GetSpellEnergyById(1943)
	Mutilate.E["Cold Blood"]          = FM_GetSpellEnergyById(14177)
	Mutilate.E["Tricks of the Trade"] = FM_GetSpellEnergyById(57934)
	Mutilate.E["Vanish"]              = FM_GetSpellEnergyById(1856)
	Mutilate.E["Backstab"]            = FM_GetSpellEnergyById(53)
	Mutilate.E["Overkill"]            = FM_GetSpellEnergyById(58426)
	
	--DEFAULT_CHAT_FRAME:AddMessage("SPELLS_CHANGED ---")
	--DEFAULT_CHAT_FRAME:AddMessage(FM_GetSpellEnergyById(1329))
	
end

function Mutilate.events.PLAYER_TALENT_UPDATE()
	-- check talents 
	-- Vendetta for Mut 
	local _, _, _, _, vendetta_rank = GetTalentInfo(1, 19) 

	if vendetta_rank == 1 then 
		Mutilate.displayFrame:Show() 
	else 
		Mutilate.displayFrame:Hide() 
	end 
	
end

function Mutilate.events.PLAYER_ALIVE()

	Mutilate.eventFrame:UnregisterEvent("PLAYER_ALIVE")
end

function Mutilate.events.PLAYER_LOGIN()

	Mutilate.playerName = UnitName("player");

end

function Mutilate.events.ADDON_LOADED(addon)

	if addon ~= "Mutilate" then 
		return 
	end
	
	local _,playerClass = UnitClass("player")
	if playerClass ~= "ROGUE" then
		Mutilate.eventFrame:UnregisterEvent("PLAYER_ALIVE")
		Mutilate.eventFrame:UnregisterEvent("ADDON_LOADED")
		Mutilate.eventFrame:UnregisterEvent("PLAYER_LOGIN")
		Mutilate.eventFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
		Mutilate.eventFrame:UnregisterEvent("PLAYER_TALENT_UPDATE")
		return 
	end
	
	-- Default saved variables
	if not Mutilatedb then
		Mutilatedb = {} -- fresh start
	end
	if not Mutilatedb.scale then Mutilatedb.scale = 1 end
	if Mutilatedb.locked == nil then Mutilatedb.locked = false end
	if not Mutilatedb.x then Mutilatedb.x = 100 end
	if not Mutilatedb.y then Mutilatedb.y = 100 end
	if not Mutilatedb.SuggestVanish then Mutilatedb.SuggestVanish = false end
	if not Mutilatedb.SuggestVendetta then Mutilatedb.SuggestVendetta = false end
	if not Mutilatedb.SuggestColdBlood then Mutilatedb.SuggestColdBlood = false end
	if not Mutilatedb.SliceAndDiceTimer then Mutilatedb.SliceAndDiceTimer = 1.0 end
	if not Mutilatedb.RuptureTimer then Mutilatedb.RuptureTimer = 2.0 end
	if not Mutilatedb.RuptureClipTimer then Mutilatedb.RuptureClipTimer = 0.0 end
	if not Mutilatedb.PoolEnergyThreshold then Mutilatedb.PoolEnergyThreshold = 90 end
	if not Mutilatedb.RuptureCp then Mutilatedb.RuptureCp = 1 end
	if not Mutilatedb.EnvenomCp then Mutilatedb.EnvenomCp = 4 end
	if not Mutilatedb.TargetHealthThreshold then Mutilatedb.TargetHealthThreshold = 35 end
	if not Mutilatedb.EnvenomTimer then Mutilatedb.EnvenomTimer = 0 end
	if not Mutilatedb.ColdBloodEnergyCap then Mutilatedb.ColdBloodEnergyCap = 90 end
	if not Mutilatedb.BackstabEnvenomCp then Mutilatedb.BackstabEnvenomCp = 5 end
	
	-- Create GUI
	Mutilate:CreateGUI()
	Mutilate.displayFrame:SetScale(Mutilatedb.scale)


	-- Create Options Frame
	Mutilate:CreateOptionFrame()
	if Mutilatedb.locked then
		Mutilate.displayFrame:SetScript("OnMouseDown", nil)
		Mutilate.displayFrame:SetScript("OnMouseUp", nil)
		Mutilate.displayFrame:SetScript("OnDragStop", nil)
		Mutilate.displayFrame:SetBackdropColor(0, 0, 0, 0)
		Mutilate.displayFrame:EnableMouse(false)
	else
		Mutilate.displayFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		Mutilate.displayFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
		Mutilate.displayFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		Mutilate.displayFrame:SetBackdropColor(0, 0, 0, .4)
		Mutilate.displayFrame:EnableMouse(true)
	end

	-- Register for Slash Commands
	SlashCmdList["Mutilate"] = Mutilate.Options
	SLASH_Mutilate1 = "/Mutilate"
	SLASH_Mutilate2 = "/mut"

	-- Register for Function Events
	Mutilate.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Mutilate.eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

	
	-- check talents 
	-- Vendetta for Mut 
	local _, _, _, _, vendetta_rank = GetTalentInfo(1, 19) 

	if vendetta_rank == 1 then 
		Mutilate.displayFrame:Show() 
	else 
		Mutilate.displayFrame:Hide() 
	end 
	
	Mutilate.E["Vendetta"]            = FM_GetSpellEnergyById(79140)
	Mutilate.E["Garrote"]             = FM_GetSpellEnergyById(703)
	Mutilate.E["Slice and Dice"]      = FM_GetSpellEnergyById(5171)
	Mutilate.E["Mutilate"]            = FM_GetSpellEnergyById(1329)
	Mutilate.E["Envenom"]             = FM_GetSpellEnergyById(32645)
	Mutilate.E["Rupture"]             = FM_GetSpellEnergyById(1943)
	Mutilate.E["Cold Blood"]          = FM_GetSpellEnergyById(14177)
	Mutilate.E["Tricks of the Trade"] = FM_GetSpellEnergyById(57934)
	Mutilate.E["Vanish"]              = FM_GetSpellEnergyById(1856)
	Mutilate.E["Backstab"]            = FM_GetSpellEnergyById(53)
	Mutilate.E["Overkill"]            = FM_GetSpellEnergyById(58426)
	
end

function Mutilate.events.COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	
	if UnitName("target") == nil or UnitIsFriend("player","target") ~= nil or UnitHealth("target") == 0 then
		Mutilate.displayFrame_last:Hide()
		Mutilate.displayFrame_current:Hide()
		Mutilate.displayFrame_next:Hide()
		Mutilate.displayFrame_misc:Hide()
		Mutilate.displayFrame_int:Hide()
		Mutilate.displayFrame_vendetta:Hide()
	else
		Mutilate.displayFrame_last:Show()
		Mutilate.displayFrame_current:Show()
		Mutilate.displayFrame_next:Show()
		Mutilate.displayFrame_misc:Show()
		Mutilate.displayFrame_int:Show()
		Mutilate.displayFrame_vendetta:Show()
		Mutilate:DecideSpells()
	end

	
end

function Mutilate.events.COMBAT_RATING_UPDATE(unit)
	
end

function Mutilate.events.PLAYER_TARGET_CHANGED(...)
	
	-- target changed, set last target, update current target, will be nil if no target
	Mutilate.lastTarget = Mutilate.currentTarget
	Mutilate.currentTarget = UnitGUID("target")
	
	if UnitName("target") == nil or UnitIsFriend("player","target") ~= nil or UnitHealth("target") == 0 then
		Mutilate.displayFrame_last:Hide()
		Mutilate.displayFrame_current:Hide()
		Mutilate.displayFrame_next:Hide()
		Mutilate.displayFrame_misc:Hide()
		Mutilate.displayFrame_int:Hide()
		Mutilate.displayFrame_vendetta:Hide()
	else
		Mutilate.displayFrame_last:Show()
		Mutilate.displayFrame_current:Show()
		Mutilate.displayFrame_next:Show()
		Mutilate.displayFrame_misc:Show()
		Mutilate.displayFrame_int:Show()
		Mutilate.displayFrame_vendetta:Show()
		Mutilate:DecideSpells()
	end
end

-- End Event Handlers

function Mutilate:CreateGUI()

  local displayFrame = CreateFrame("Frame","MutilateDisplayFrame",UIParent)
  displayFrame:SetFrameStrata("BACKGROUND")
  displayFrame:SetWidth(300)
  displayFrame:SetHeight(95)
  displayFrame:SetBackdrop({
          bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 32,
  			})
  displayFrame:SetBackdropColor(0, 0, 0, .4)
  displayFrame:EnableMouse(true)
  displayFrame:SetMovable(true)
  displayFrame:SetClampedToScreen(true)
  displayFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
  displayFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
  displayFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

  displayFrame:SetPoint("CENTER",-200,-200)

  local displayFrame_last = CreateFrame("Frame","$parent_last", MutilateDisplayFrame)
  local displayFrame_current = CreateFrame("Frame","$parent_current", MutilateDisplayFrame)
  local displayFrame_next = CreateFrame("Frame","$parent_next", MutilateDisplayFrame)
  local displayFrame_misc = CreateFrame("Frame","$parent_misc", MutilateDisplayFrame)
  local displayFrame_int = CreateFrame("Frame","$parent_int", MutilateDisplayFrame)
  local displayFrame_vendetta = CreateFrame("Frame","$parent_vendetta", MutilateDisplayFrame)

  displayFrame_last:SetWidth(45)
  displayFrame_current:SetWidth(70)
  displayFrame_next:SetWidth(45)
  displayFrame_misc:SetWidth(45)
  displayFrame_int:SetWidth(45)
  displayFrame_vendetta:SetWidth(45)

  displayFrame_last:SetHeight(45)
  displayFrame_current:SetHeight(70)
  displayFrame_next:SetHeight(45)
  displayFrame_misc:SetHeight(45)
  displayFrame_int:SetHeight(45)
  displayFrame_vendetta:SetHeight(45)

  displayFrame_current:SetPoint("TOPLEFT", 140, -10)
  displayFrame_next:SetPoint("TOPLEFT", 250, -50)
  
  displayFrame_last:SetPoint("TOPLEFT", 0, -50)

  displayFrame_misc:SetPoint("TOPLEFT", 0, 0)
  displayFrame_int:SetPoint("TOPLEFT", 50, 0)
  displayFrame_vendetta:SetPoint("TOPLEFT", 50,-50) 


  local t = displayFrame_last:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_last)
  t:SetAlpha(.8)
  displayFrame_last.texture = t
  Mutilate.textureList["last"] = t

  t = displayFrame_current:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:ClearAllPoints()
  t:SetAllPoints(displayFrame_current)
  displayFrame_current.texture = t
  Mutilate.textureList["current"] = t

  t = displayFrame_misc:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_misc)
  t:SetAlpha(.8)
  displayFrame_misc.texture = t
  Mutilate.textureList["misc"] = t

  t = displayFrame_int:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_int)
  t:SetAlpha(.8)
  displayFrame_int.texture = t
  Mutilate.textureList["int"] = t

  t = displayFrame_next:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_next)
  t:SetAlpha(.8)
  displayFrame_next.texture = t
  Mutilate.textureList["next"] = t
  
  t = displayFrame_vendetta:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_vendetta)
  t:SetAlpha(.8)
  displayFrame_vendetta.texture = t
  Mutilate.textureList["vendetta"] = t


  displayFrame:SetScript("OnUpdate", function(this, elapsed)
    Mutilate:OnUpdate(elapsed)
  end)

  local cooldownFrame = CreateFrame("Cooldown","$parent_cooldown", MutilateDisplayFrame_current)
  cooldownFrame:SetHeight(70)
  cooldownFrame:SetWidth(70)
  cooldownFrame:ClearAllPoints()
  cooldownFrame:SetPoint("CENTER", displayFrame_current, "CENTER", 0, 0)
  
  Mutilate.displayFrame = displayFrame
  Mutilate.displayFrame_last = displayFrame_last
  Mutilate.displayFrame_current = displayFrame_current
  Mutilate.displayFrame_next = displayFrame_next
  Mutilate.displayFrame_misc =  displayFrame_misc
  Mutilate.displayFrame_int =  displayFrame_int
  Mutilate.displayFrame_vendetta = displayFrame_vendetta
  Mutilate.cooldownFrame = cooldownFrame

end

function Mutilate:OnUpdate(elapsed)

	Mutilate.timeSinceLastUpdate = Mutilate.timeSinceLastUpdate + elapsed;

	--if (Mutilate.timeSinceLastUpdate >= 1) then
		Mutilate:DecideSpells()
	--end

end

function Mutilate:DecideSpells()

	Mutilate.timeSinceLastUpdate = 0;
	
	local guid = UnitGUID("target")
	local puid = UnitGUID("player")
	
	if  UnitName("target") == nil or UnitIsFriend("player","target") ~= nil or UnitHealth("target") == 0 then
		return -- ignore the dead and friendly
	end

	if guid == nil then
		Mutilate.textureList["last"]:SetTexture(nil)
		Mutilate.textureList["current"]:SetTexture(nil)
		Mutilate.textureList["next"]:SetTexture(nil)
		Mutilate.textureList["misc"]:SetTexture(nil)
		Mutilate.textureList["int"]:SetTexture(nil)
		Mutilate.textureList["vendetta"]:SetTexture(nil)
		return
	end
	
	local energy = UnitPower("player")
	local cp = GetComboPoints("player")
	local currentTime = GetTime()

	local spell = ""
	local nextspell = ""
	local aoespell = ""
	local miscspell = ""
	local intspell = ""
	
	local garrote = 0
	local slice_and_dice = 0
	local overkill = 0
	local rupture = 0
	local vendetta = 0
	local cold_blood = 0
	local tott = 0
	local vanish = 0
	local envenom = 0
	local envenom_buff = 0
	local overkill_duration = -1
	
	--
	-- Rotation borrowed from :
	-- http://elitistjerks.com/f78/t110134-assassination_guide_cata/
	--
	
	--
	-- Garrote
	--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", Mutilate.L["Garrote"])

	currentTime = GetTime()
	if name ~= nil and isMine == "player" then
		garrote = expirationTime - currentTime
	end	
	
	--
	-- Slice and Dice
	--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitBuff("player", Mutilate.L["Slice and Dice"])

	currentTime = GetTime()
	if name ~= nil then
		slice_and_dice = expirationTime - currentTime
	end
	
	--
	-- Overkill
	--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitBuff("player", Mutilate.L["Overkill"])

	currentTime = GetTime()
	if name ~= nil then
		overkill_duration = duration
		overkill = expirationTime - currentTime
	end
	
	--
	-- Ruture
	--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", Mutilate.L["Rupture"])
	currentTime = GetTime()
	if name ~= nil and isMine == "player" then
		rupture = expirationTime - currentTime
	end	

	--
	-- Vendetta
	--
	local start, duration, enabled = GetSpellCooldown(Mutilate.L["Vendetta"]);
	if duration ~= nil then 
		vendetta = duration + start - currentTime
	else
		vendetta = 60
	end
	
	--
	-- Cold Blood
	--
	local start, duration, enabled = GetSpellCooldown(Mutilate.L["Cold Blood"]);
	if duration ~= nil then 
		cold_blood = duration + start - currentTime
	else
		cold_blood = 60
	end	
	
	--
	-- Tricks of the Trade
	--
	local start, duration, enabled = GetSpellCooldown(Mutilate.L["Tricks of the Trade"]);
	if duration ~= nil then 
		tott = duration + start - currentTime
	else
		tott = 60
	end	
	
	--
	-- Vanish
	--
	local start, duration, enabled = GetSpellCooldown(Mutilate.L["Vanish"]);
	if duration ~= nil then
		vanish_timer = currentTime - start
		vanish = duration + start - currentTime
	else
		vanish = 60
	end	
	
	--
	-- Envenom Buff
	--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitBuff("player", Mutilate.L["Envenom"])
	if duration ~= nil then
		envenom_buff = duration + start - currentTime
	end

	--
	-- Envenom
	--
	local start, duration, enabled = GetSpellCooldown(Mutilate.L["Envenom"]);
	if duration ~= nil then
		envenom = duration + start - currentTime
	else
		envenom = 60
	end	
	
	
	-- Get the target's health percentage for Backstab
	local  TargetsPercentOfHealth = ( UnitHealth("target") / UnitHealthMax("target") * 100);
	
	-- Determine which ability should be used to generate Combo Points
	local CpMechanic = "Mutilate";
	local EnvenomCp = Mutilatedb.EnvenomCp
	if(TargetsPercentOfHealth < Mutilatedb.TargetHealthThreshold) then
		CpMechanic = "Backstab"
		EnvenomCp = Mutilatedb.BackstabEnvenomCp
	end	
		
	-- You will always want to open from stealth such that you use as much of your 20 seconds of Overkill as possible.
	if ((UnitAura("player", "Stealth") ~= nil) or
        (overkill_duration == 0)) then
	
		-- It is better to open a fight with Garrote rather than Mutilate if you can do so without delaying the start of your 
		-- attacks by more than a second or two. 
		if (energy >= Mutilate.E["Garrote"]) then
		
			spell = Mutilate.L["Garrote"];
			nextspell = Mutilate.L[CpMechanic];
			
		else
		
			nextspell = Mutilate.L["Garrote"];
			
		end
	
	-- Once in combat, there are various sequences of abilities that work but ultimately you will want to get Rupture and SnD both up as 		
	-- quickly as possible, neither has to be a lot of combo points at the start.
	elseif ((cp >= 1) and 
	        (slice_and_dice <= Mutilatedb.SliceAndDiceTimer)) then
			
		if(slice_and_dice == 0) then
		
			if (energy >= Mutilate.E["Slice and Dice"]) then
            
				spell = Mutilate.L["Slice and Dice"];
				nextspell = Mutilate.L[CpMechanic];
			
			else
		
				nextspell = Mutilate.L["Slice and Dice"];
			
			end

		else
		
			-- if slice and dice is already applied, then use envenom to refresh duration.
			-- the occurance of executing this branch of logic should be very rare.
			if (energy >= Mutilate.E["Envenom"]) then

				spell = Mutilate.L["Envenom"];
				nextspell = Mutilate.L[CpMechanic];
				
			else
			
				nextspell = Mutilate.L["Envenom"];
				
			end	

		end				
	-- Once in combat, there are various sequences of abilities that work but ultimately you will want to get Rupture and SnD both up as 		
	-- quickly as possible, neither has to be a lot of combo points at the start.
	elseif ((cp >= Mutilatedb.RuptureCp) and
	        (rupture <= Mutilatedb.RuptureTimer)) then
				
		if ((energy >= Mutilate.E["Rupture"]) and
			(rupture <= Mutilatedb.RuptureClipTimer)) then
			
			spell = Mutilate.L["Rupture"];
			nextspell = Mutilate.L[CpMechanic];
			
		else
		
			nextspell = Mutilate.L["Rupture"];
			
		end	
	-- Cold Blood is also something you want use as soon as you can match it up with your hardest hitting ability, Envenom. 
	-- If you use it on Envenom, use it for a 5 combo point one and keep in mind that it generates 25 energy when used so if 
	-- you are pooling before using Envenom, pool less energy so you do not cap out. Coldblood can also be used with Mutilate 
	-- or Backstab to generate a guaranteed extra combo point (via Seal Fate). Coldblood is generally not worth using to increase 
	-- FoK damage since the direct FoK damage is quite insignificant as mentioned earlier.
	elseif ((Mutilatedb.SuggestColdBlood == true) and
		    (cold_blood <= 0) and
            (cp == 5) and
            (energy <= Mutilatedb.ColdBloodEnergyCap)) then

		spell = Mutilate.L["Cold Blood"]; 
		nextspell = Mutilate.L["Envenom"];
		
	elseif (cp >= Mutilatedb.EnvenomCp) then

        -----------------------------------------------------------------------------------------------------------------------------------

        local inactive_regen_per_sec, active_regen_per_sec = GetPowerRegen()
		local rupture_minus_lock = rupture - Mutilatedb.RuptureTimer
		
        -- maximum amount of energy to be regenerated until rupture expires
		--DEFAULT_CHAT_FRAME:AddMessage("--- rupture : " .. rupture .. " ---")
        local max_energy_until_rupture = energy + (rupture_minus_lock * active_regen_per_sec)
              
        -- max energy required to apply rupture
        local max_energy_for_rupture = Mutilate.E[CpMechanic] + Mutilate.E["Rupture"];
       
        -- pool energy if enough will be present to generate 1cp and apply rupture
        local continue_to_pool = max_energy_until_rupture - Mutilate.E["Envenom"] - max_energy_for_rupture
       
        local pool = false
        if((continue_to_pool > 0) and
           (energy < Mutilatedb.PoolEnergyThreshold)) then
          
            pool = true
       
        end
		
		if(continue_to_pool > 0) then
		
		else
			-- just for debug
			--DEFAULT_CHAT_FRAME:AddMessage("--- Pooling bailout ---")
		end
       
        -----------------------------------------------------------------------------------------------------------------------------------
   
        if ((energy >= Mutilate.E["Envenom"]) and
            (pool == false)) then

            spell = Mutilate.L["Envenom"];
            nextspell = Mutilate.L[CpMechanic];
           
        else
       
            nextspell = Mutilate.L["Envenom"];
           
        end    
	
	-- Vanish is a DPS cooldown because it allows you to gain Overkill again during an encounter. Similar to Vendetta, 
	-- you will want to use Vanish in combination (just before if possible) with other DPS enhancements. You will want to 
	-- avoid using Vanish while you have an Envenom buff and reopen with Garrote in less then 4 to 5 seconds.
	elseif ((Mutilatedb.SuggestVanish == true) and
			(vanish < 1) and 
	        (overkill == 0) and
			(envenom_buff == 0)) then
			
		spell = Mutilate.L["Vanish"];
		nextspell = Mutilate.L["Garrote"];
		
	-- You will want to use Vendetta when it is available and when you have a 30 second window (36 seconds glyphed) 
	-- to deal uninterrupted damage and if possible when trinket and weapons procs, bloodlust, a potion, and/or Overkill 
	-- are up. Keep in mind that Vendetta is a debuff that is placed on your target so if used in an AoE situation, you are 
	-- really only increased your AoE damage on one target.
	elseif ((Mutilatedb.SuggestVendetta == true) and
			(vendetta < 1) and 
	        (rupture > Mutilatedb.RuptureTimer)) then
	
		spell = Mutilate.L["Vendetta"];
		nextspell = Mutilate.L[CpMechanic];	
		
	else

		--DEFAULT_CHAT_FRAME:AddMessage("---")
		--DEFAULT_CHAT_FRAME:AddMessage(Mutilate.E[CpMechanic])
		--DEFAULT_CHAT_FRAME:AddMessage(FM_GetSpellEnergyById(1329))
	
		if (energy >= Mutilate.E[CpMechanic]) then
		
			spell = Mutilate.L[CpMechanic];
			nextspell = Mutilate.L[CpMechanic];	
			
		else
		
			nextspell = Mutilate.L[CpMechanic];
			
		end
		
	end
	
	Mutilate.textureList["current"]:SetTexture(GetSpellBookItemTexture(spell))
	Mutilate.textureList["next"]:SetTexture(GetSpellBookItemTexture(nextspell))

	if cold_blood < 1 then
		Mutilate.textureList["last"]:SetTexture(GetSpellBookItemTexture(Mutilate.L["Cold Blood"]))
	else
		Mutilate.textureList["last"]:SetTexture(nil)
	end
	
	if tott < 1 then
		Mutilate.textureList["misc"]:SetTexture(GetSpellBookItemTexture(Mutilate.L["Tricks of the Trade"]))
	else
		Mutilate.textureList["misc"]:SetTexture(nil)
	end
	
	if (vanish < 1) and (overkill == 0) then
		Mutilate.textureList["int"]:SetTexture(GetSpellBookItemTexture(Mutilate.L["Vanish"]))
	else
		Mutilate.textureList["int"]:SetTexture(nil)
	end
	
	if vendetta < 1 then
		Mutilate.textureList["vendetta"]:SetTexture(GetSpellBookItemTexture(Mutilate.L["Vendetta"]))
	else
		Mutilate.textureList["vendetta"]:SetTexture(nil)
	end
		
	if spell ~= "" and spell ~= nil then
		local start, dur = GetSpellCooldown(spell)
		if dur == 0 or start == nil or dur == nil then
			Mutilate.cooldownFrame:SetAlpha(0)
		else
			Mutilate.cooldownFrame:SetAlpha(1)
			Mutilate.cooldownFrame:SetCooldown(start, dur)
		end
	end
end

function Mutilate:CreateOptionFrame()
	local panel = CreateFrame("FRAME", "MutilateOptions");
	panel.name = "Mutilate";

	local fstring1 = panel:CreateFontString("MutilateOptions_string1", "OVERLAY", "GameFontNormal")
	fstring1:SetText("Lock")
	fstring1:SetPoint("TOPLEFT", 10, -10)

	local checkbox1 = CreateFrame("CheckButton", "$parent_cb1", panel, "OptionsCheckButtonTemplate")
	checkbox1:SetWidth(18)
	checkbox1:SetHeight(18)
	checkbox1:SetScript("OnClick", function() Mutilate:ToggleLocked() end)
	checkbox1:SetPoint("TOPRIGHT", -10, -10)
	checkbox1:SetChecked(Mutilate:GetLocked())
	
	local fstring2 = panel:CreateFontString("MutilateOptions_string2", "OVERLAY", "GameFontNormal")
	fstring2:SetText("Suggest Vendetta in Rotation")
	fstring2:SetPoint("TOPLEFT", 10, -40)
	
	local checkbox2 = CreateFrame("CheckButton", "$parent_cb2", panel, "OptionsCheckButtonTemplate")
	checkbox2:SetWidth(18)
	checkbox2:SetHeight(18)
	checkbox2:SetScript("OnClick", function() Mutilate:ToggleVendetta() end)
	checkbox2:SetPoint("TOPRIGHT", -10, -40)
	checkbox2:SetChecked(Mutilate:GetVendetta())	
	
	local fstring3 = panel:CreateFontString("MutilateOptions_string3", "OVERLAY", "GameFontNormal")
	fstring3:SetText("Suggest Vanish in Rotation")
	fstring3:SetPoint("TOPLEFT", 10, -70)
	
	local checkbox3 = CreateFrame("CheckButton", "$parent_cb3", panel, "OptionsCheckButtonTemplate")
	checkbox3:SetWidth(18)
	checkbox3:SetHeight(18)
	checkbox3:SetScript("OnClick", function() Mutilate:ToggleVanish() end)
	checkbox3:SetPoint("TOPRIGHT", -10, -70)
	checkbox3:SetChecked(Mutilate:GetVanish())	

	local fstring4 = panel:CreateFontString("MutilateOptions_string4", "OVERLAY", "GameFontNormal")
	fstring4:SetText("Suggest Cold Blood in Rotation")
	fstring4:SetPoint("TOPLEFT", 10, -100)
	
	local checkbox4 = CreateFrame("CheckButton", "$parent_cb4", panel, "OptionsCheckButtonTemplate")
	checkbox4:SetWidth(18)
	checkbox4:SetHeight(18)
	checkbox4:SetScript("OnClick", function() Mutilate:ToggleColdBlood() end)
	checkbox4:SetPoint("TOPRIGHT", -10, -100)
	checkbox4:SetChecked(Mutilate:GetColdBlood())	

	--
	-- GUI Scale
	--
	local fstring5 = panel:CreateFontString("MutilateOptions_string5", "OVERLAY", "GameFontNormal")
	fstring5:SetText("GUI Scale")
	fstring5:SetPoint("TOPLEFT", 10, -130)

	local slider5 = CreateFrame("Slider", "$parent_sl", panel, "OptionsSliderTemplate")
	slider5:SetMinMaxValues(.5, 1.5)
	slider5:SetValue(Mutilate:GetScale())
	slider5:SetValueStep(.05)
	slider5:SetScript("OnValueChanged", function(self) Mutilate:SetScale(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider5:GetName() .. "Low"):SetText("0.5")
	getglobal(slider5:GetName() .. "High"):SetText("1.5")
	getglobal(slider5:GetName() .. "Text"):SetText(Mutilate:GetScale())
	slider5:SetPoint("TOPRIGHT", -10, -130)
	
	
	--
	-- Slice and Dice Timer
	--
	local fstring6 = panel:CreateFontString("MutilateOptions_string6", "OVERLAY", "GameFontNormal")
	fstring6:SetText("Lock In Slice and Dice Threshold")
	fstring6:SetPoint("TOPLEFT", 10, -160)

	local slider6 = CreateFrame("Slider", "$parent_s2", panel, "OptionsSliderTemplate")
	slider6:SetMinMaxValues(0, 10)
	slider6:SetValue(Mutilate:GetSliceAndDiceTimer())
	slider6:SetValueStep(.05)
	slider6:SetScript("OnValueChanged", function(self) Mutilate:SetSliceAndDiceTimer(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider6:GetName() .. "Low"):SetText("0")
	getglobal(slider6:GetName() .. "High"):SetText("10")
	getglobal(slider6:GetName() .. "Text"):SetText(Mutilate:GetSliceAndDiceTimer())
	slider6:SetPoint("TOPRIGHT", -10, -160)
	
	--
	-- Rupture Timer
	--
	local fstring7 = panel:CreateFontString("MutilateOptions_string7", "OVERLAY", "GameFontNormal")
	fstring7:SetText("Lock In Rupture Threshold")
	fstring7:SetPoint("TOPLEFT", 10, -190)

	local slider7 = CreateFrame("Slider", "$parent_s3", panel, "OptionsSliderTemplate")
	slider7:SetMinMaxValues(0, 5)
	slider7:SetValue(Mutilate:GetRuptureTimer())
	slider7:SetValueStep(.05)
	slider7:SetScript("OnValueChanged", function(self) Mutilate:SetRuptureTimer(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider7:GetName() .. "Low"):SetText("0")
	getglobal(slider7:GetName() .. "High"):SetText("5")
	getglobal(slider7:GetName() .. "Text"):SetText(Mutilate:GetRuptureTimer())
	slider7:SetPoint("TOPRIGHT", -10, -190)
	
	--
	-- Rupture Clip Timer
	--
	local fstring12 = panel:CreateFontString("MutilateOptions_string12", "OVERLAY", "GameFontNormal")
	fstring12:SetText("Clip Rupture Threshold")
	fstring12:SetPoint("TOPLEFT", 10, -220)

	local slider12 = CreateFrame("Slider", "$parent_s8", panel, "OptionsSliderTemplate")
	slider12:SetMinMaxValues(0, 0.5)
	slider12:SetValue(Mutilate:GetRuptureClipTimer())
	slider12:SetValueStep(.05)
	slider12:SetScript("OnValueChanged", function(self) Mutilate:SetRuptureClipTimer(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider12:GetName() .. "Low"):SetText("0")
	getglobal(slider12:GetName() .. "High"):SetText("0.5")
	getglobal(slider12:GetName() .. "Text"):SetText(Mutilate:GetRuptureClipTimer())
	slider12:SetPoint("TOPRIGHT", -10, -220)
	
	--
	-- Envenom Clip Timer
	--
	local fstring13 = panel:CreateFontString("MutilateOptions_string13", "OVERLAY", "GameFontNormal")
	fstring13:SetText("Clip Envenom Threshold")
	fstring13:SetPoint("TOPLEFT", 10, -250)

	local slider13 = CreateFrame("Slider", "$parent_s9", panel, "OptionsSliderTemplate")
	slider13:SetMinMaxValues(0, 0.5)
	slider13:SetValue(Mutilate:GetEnvenomTimer())
	slider13:SetValueStep(.05)
	slider13:SetScript("OnValueChanged", function(self) Mutilate:SetEnvenomTimer(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider13:GetName() .. "Low"):SetText("0")
	getglobal(slider13:GetName() .. "High"):SetText("0.5")
	getglobal(slider13:GetName() .. "Text"):SetText(Mutilate:GetEnvenomTimer())
	slider13:SetPoint("TOPRIGHT", -10, -250)
	
	--
	-- Pool Energy Threshold
	--
	local fstring8 = panel:CreateFontString("MutilateOptions_string8", "OVERLAY", "GameFontNormal")
	fstring8:SetText("Pool Energy Threshold")
	fstring8:SetPoint("TOPLEFT", 10, -280)

	local slider8 = CreateFrame("Slider", "$parent_s4", panel, "OptionsSliderTemplate")
	slider8:SetMinMaxValues(70, 120)
	slider8:SetValue(Mutilate:GetPoolEnergyThreshold())
	slider8:SetValueStep(1)
	slider8:SetScript("OnValueChanged", function(self) Mutilate:SetPoolEnergyThreshold(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider8:GetName() .. "Low"):SetText("70")
	getglobal(slider8:GetName() .. "High"):SetText("120")
	getglobal(slider8:GetName() .. "Text"):SetText(Mutilate:GetPoolEnergyThreshold())
	slider8:SetPoint("TOPRIGHT", -10, -280)	
	
	--
	-- RuptureCp
	--
	local fstring9 = panel:CreateFontString("MutilateOptions_string9", "OVERLAY", "GameFontNormal")
	fstring9:SetText("Rupture Cp")
	fstring9:SetPoint("TOPLEFT", 10, -310)

	local slider9 = CreateFrame("Slider", "$parent_s5", panel, "OptionsSliderTemplate")
	slider9:SetMinMaxValues(1, 5)
	slider9:SetValue(Mutilate:GetRuptureCp())
	slider9:SetValueStep(1)
	slider9:SetScript("OnValueChanged", function(self) Mutilate:SetRuptureCp(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider9:GetName() .. "Low"):SetText("1")
	getglobal(slider9:GetName() .. "High"):SetText("5")
	getglobal(slider9:GetName() .. "Text"):SetText(Mutilate:GetRuptureCp())
	slider9:SetPoint("TOPRIGHT", -10, -310)	

	--
	-- EnvenomCp
	--
	local fstring10 = panel:CreateFontString("MutilateOptions_string10", "OVERLAY", "GameFontNormal")
	fstring10:SetText("Envenom Cp")
	fstring10:SetPoint("TOPLEFT", 10, -340)

	local slider10 = CreateFrame("Slider", "$parent_s6", panel, "OptionsSliderTemplate")
	slider10:SetMinMaxValues(1, 5)
	slider10:SetValue(Mutilate:GetEnvenomCp())
	slider10:SetValueStep(1)
	slider10:SetScript("OnValueChanged", function(self) Mutilate:SetEnvenomCp(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider10:GetName() .. "Low"):SetText("1")
	getglobal(slider10:GetName() .. "High"):SetText("5")
	getglobal(slider10:GetName() .. "Text"):SetText(Mutilate:GetEnvenomCp())
	slider10:SetPoint("TOPRIGHT", -10, -340)	
	
	--
	-- TargetHealthThreshold
	--
	local fstring11 = panel:CreateFontString("MutilateOptions_string11", "OVERLAY", "GameFontNormal")
	fstring11:SetText("Backstab Threshold")
	fstring11:SetPoint("TOPLEFT", 10, -370)

	local slider11 = CreateFrame("Slider", "$parent_s7", panel, "OptionsSliderTemplate")
	slider11:SetMinMaxValues(0, 100)
	slider11:SetValue(Mutilate:GetTargetHealthThreshold())
	slider11:SetValueStep(1)
	slider11:SetScript("OnValueChanged", function(self) Mutilate:SetTargetHealthThreshold(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider11:GetName() .. "Low"):SetText("0")
	getglobal(slider11:GetName() .. "High"):SetText("100")
	getglobal(slider11:GetName() .. "Text"):SetText(Mutilate:GetTargetHealthThreshold())
	slider11:SetPoint("TOPRIGHT", -10, -370)	
	
	--
	-- TargetHealthThreshold EnvenomCp
	--
	local fstring14 = panel:CreateFontString("MutilateOptions_string14", "OVERLAY", "GameFontNormal")
	fstring14:SetText("Backstab EnvenomCp")
	fstring14:SetPoint("TOPLEFT", 10, -400)

	local slider14 = CreateFrame("Slider", "$parent_s14", panel, "OptionsSliderTemplate")
	slider14:SetMinMaxValues(1, 5)
	slider14:SetValue(Mutilate:GetBackstabEnvenomCp())
	slider14:SetValueStep(1)
	slider14:SetScript("OnValueChanged", function(self) Mutilate:SetBackstabEnvenomCp(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider14:GetName() .. "Low"):SetText("1")
	getglobal(slider14:GetName() .. "High"):SetText("5")
	getglobal(slider14:GetName() .. "Text"):SetText(Mutilate:GetBackstabEnvenomCp())
	slider14:SetPoint("TOPRIGHT", -10, -400)	
	
	InterfaceOptions_AddCategory(panel);
end

function Mutilate:GetLocked()
	return Mutilatedb.locked
end

function Mutilate:ToggleLocked()
	if Mutilatedb.locked then
		Mutilatedb.locked = false
		Mutilate.displayFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		Mutilate.displayFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
		Mutilate.displayFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		Mutilate.displayFrame:SetBackdropColor(0, 0, 0, .4)
		Mutilate.displayFrame:EnableMouse(true)
	else
		Mutilatedb.locked = true
		Mutilate.displayFrame:SetScript("OnMouseDown", nil)
		Mutilate.displayFrame:SetScript("OnMouseUp", nil)
		Mutilate.displayFrame:SetScript("OnDragStop", nil)
		Mutilate.displayFrame:SetBackdropColor(0, 0, 0, 0)
		Mutilate.displayFrame:EnableMouse(false)
	end
end


function Mutilate.Options(msg, editBox)

	if(msg == 'show') then
		Mutilate.displayFrame:Show() 
	elseif(msg == 'hide') then
		Mutilate.displayFrame:Hide() 
	elseif(msg == '') then
		InterfaceOptionsFrame_OpenToCategory(getglobal("MutilateOptions"))
	else
	end
	
end

function Mutilate:GetScale()
	return Mutilatedb.scale
end

function Mutilate:GetVanish()
	return Mutilatedb.SuggestVanish
end
	
function Mutilate:GetRupture()
	return Mutilatedb.SuggestRupture
end

function Mutilate:GetVendetta()
	return Mutilatedb.SuggestVendetta
end

function Mutilate:GetColdBlood()
	return Mutilatedb.SuggestColdBlood
end

function Mutilate:GetSliceAndDiceTimer()
	return Mutilatedb.SliceAndDiceTimer
end

function Mutilate:GetRuptureTimer()
	return Mutilatedb.RuptureTimer
end

function Mutilate:GetRuptureClipTimer()
	return Mutilatedb.RuptureClipTimer
end

function Mutilate:GetEnvenomTimer()
	return Mutilatedb.EnvenomTimer
end

function Mutilate:GetPoolEnergyThreshold()
	return Mutilatedb.PoolEnergyThreshold
end

function Mutilate:GetRuptureCp()
	return Mutilatedb.RuptureCp
end

function Mutilate:GetEnvenomCp()
	return Mutilatedb.EnvenomCp
end

function Mutilate:GetTargetHealthThreshold()
	return Mutilatedb.TargetHealthThreshold
end

function Mutilate:GetBackstabEnvenomCp()
	return Mutilatedb.BackstabEnvenomCp
end
	
function Mutilate:ToggleVanish()
	if(Mutilatedb.SuggestVanish == true) then
		Mutilatedb.SuggestVanish = false
	else
		Mutilatedb.SuggestVanish = true
	end
end

function Mutilate:ToggleRupture()
	if(Mutilatedb.SuggestRupture == true) then
		Mutilatedb.SuggestRupture = false
	else
		Mutilatedb.SuggestRupture = true
	end
end

function Mutilate:ToggleVendetta()
	if(Mutilatedb.SuggestVendetta == true) then
		Mutilatedb.SuggestVendetta = false
	else
		Mutilatedb.SuggestVendetta = true
	end
end

function Mutilate:ToggleColdBlood()
	if(Mutilatedb.SuggestColdBlood == true) then
		Mutilatedb.SuggestColdBlood = false
	else
		Mutilatedb.SuggestColdBlood = true
	end
end

function Mutilate:SetScale(num)
	Mutilatedb.scale = num
	Mutilate.displayFrame:SetScale(Mutilatedb.scale)
	Mutilate.cooldownFrame:SetScale(Mutilatedb.scale)
end

function Mutilate:SetSliceAndDiceTimer(num)
	Mutilatedb.SliceAndDiceTimer = num
end

function Mutilate:SetRuptureTimer(num)
	Mutilatedb.RuptureTimer = num
end

function Mutilate:SetRuptureClipTimer(num)
	Mutilatedb.RuptureClipTimer = num
end

function Mutilate:SetEnvenomTimer(num)
	Mutilatedb.EnvenomTimer = num
end

function Mutilate:SetPoolEnergyThreshold(num)
	Mutilatedb.PoolEnergyThreshold = num
end

function Mutilate:SetRuptureCp(num)
	Mutilatedb.RuptureCp = num
end

function Mutilate:SetEnvenomCp(num)
	Mutilatedb.EnvenomCp = num
end

function Mutilate:SetTargetHealthThreshold(num)
	Mutilatedb.TargetHealthThreshold = num
end

function Mutilate:SetBackstabEnvenomCp(num)
	Mutilatedb.BackstabEnvenomCp = num
end

