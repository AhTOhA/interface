--[[ $Id: rogue-subtlety.lua 5 2010-11-06 00:21:14Z decipherable $ ]]--

-- Our base array
Subtlety = {}

-- Subtlety variables NOT SAVED
Subtlety.currentTarget = ""
Subtlety.lastTarget = ""

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

local language = GetLocale();

if language == "esMX" then
	Subtlety.L = {
		["Garrote"]             = "Garrote",
		["Backstab"]            = "Puñalada",
		["Slice and Dice"]      = "Hacer picadillo",	
		["Eviscerate"]          = "Eviscerar",
		["Rupture"]             = "Ruptura",
		["Recuperate"]          = "Reponerse",
		["Tricks of the Trade"] = "Secretos del oficio",
		["Shadowstep"]          = "Paso de las Sombras",
		["Hemorrhage"]          = "Hemorragia",
		["Ambush"]       		= "Emboscada",
		["Vanish"]       		= "Esfumarse",
		["Shadow Dance"]        = "Danza de las Sombras",	
		["Premeditation"]       = "Premeditación",
		["Redirect"]       		= "Redirigir",
		["Master of Subtlety"]	= "Maestro de la sutileza",
		["Stealth"]       		= "Sigilo",		
		["Generator"]       	= "Generator"					
	}
elseif language == "frFR" then
	Subtlety.L = {
		["Garrote"]             = "Garrot",
		["Backstab"]            = "Attaque sournoise",
		["Slice and Dice"]      = "Débiter",	
		["Eviscerate"]          = "Eviscération",
		["Rupture"]             = "Rupture",
		["Recuperate"]          = "Conversion",
		["Tricks of the Trade"] = "Ficelles du métier",
		["Shadowstep"]          = "Pas de l'ombre",
		["Hemorrhage"]          = "Hémorragie",
		["Ambush"]       		= "Embuscade",
		["Vanish"]       		= "Disparition",
		["Shadow Dance"]        = "Danse de l'ombre",	
		["Premeditation"]       = "Préméditation",
		["Redirect"]       		= "Rediriger",
		["Master of Subtlety"]	= "Maître de la discrétion",
		["Stealth"]       		= "Camouflage",		
		["Generator"]       	= "Generator"					
	}
elseif language == "deDE" then
	Subtlety.L = {
		["Garrote"]             = "Erdrosseln",
		["Backstab"]            = "Meucheln",
		["Slice and Dice"]      = "Zerhäckseln",	
		["Eviscerate"]          = "Ausweiden",
		["Rupture"]             = "Blutung",
		["Recuperate"]          = "Gesundung",
		["Tricks of the Trade"] = "Schurkenhandel",
		["Shadowstep"]          = "Schattenschritt",
		["Hemorrhage"]          = "Blutsturz",
		["Ambush"]       		= "Hinterhalt",
		["Vanish"]       		= "Verschwinden",
		["Shadow Dance"]        = "Schattentanz",	
		["Premeditation"]       = "Konzentration",
		["Redirect"]       		= "Umlenken",
		["Master of Subtlety"]	= "Meister des hinterhältigen Angriffs",
		["Stealth"]       		= "Verstohlenheit",		
		["Generator"]       	= "Generator"					
	} 
elseif language == "ruRU" then
	Subtlety.L = {
		["Garrote"]             = "Гаррота",
		["Backstab"]            = "Удар в спину",
		["Slice and Dice"]      = "Мясорубка",	
		["Eviscerate"]          = "Потрошение",
		["Rupture"]             = "Рваная рана",
		["Recuperate"]          = "Заживление ран",
		["Tricks of the Trade"] = "Маленькие хитрости",
		["Shadowstep"]          = "Шаг сквозь тень",
		["Hemorrhage"]          = "Кровоизлияние",
		["Ambush"]       		= "Внезапный удар",
		["Vanish"]       		= "Исчезновение",
		["Shadow Dance"]        = "Танец теней",	
		["Premeditation"]       = "Умысел",
		["Redirect"]       		= "Смена приоритетов",
		["Master of Subtlety"]	= "Мастер скрытности",
		["Stealth"]       		= "Незаметность",		
		["Generator"]       	= "Generator"					
	}
else
	Subtlety.L = {
		["Garrote"]             = "Garrote",
		["Backstab"]            = "Backstab",
		["Slice and Dice"]      = "Slice and Dice",	
		["Eviscerate"]          = "Eviscerate",
		["Rupture"]             = "Rupture",
		["Recuperate"]          = "Recuperate",
		["Tricks of the Trade"] = "Tricks of the Trade",
		["Shadowstep"]          = "Shadowstep",
		["Hemorrhage"]          = "Hemorrhage",
		["Ambush"]       		= "Ambush",
		["Vanish"]       		= "Vanish",
		["Shadow Dance"]        = "Shadow Dance",	
		["Premeditation"]       = "Premeditation",
		["Redirect"]       		= "Redirect",
		["Master of Subtlety"]	= "Master of Subtlety",
		["Stealth"]       		= "Stealth",		
		["Generator"]       	= "Generator"					
	}
end	

Subtlety.L["Garrote"]             = GetSpellInfo(703)
Subtlety.L["Slice and Dice"]      = GetSpellInfo(5171)
Subtlety.L["Backstab"]            = GetSpellInfo(53)
Subtlety.L["Hemorrhage"]          = GetSpellInfo(16511)
Subtlety.L["Eviscerate"]          = GetSpellInfo(2098)
Subtlety.L["Rupture"]             = GetSpellInfo(1943)
Subtlety.L["Recuperate"]          = GetSpellInfo(73651)
Subtlety.L["Tricks of the Trade"] = GetSpellInfo(57934)
Subtlety.L["Shadowstep"]          = GetSpellInfo(36554)
Subtlety.L["Shadow Dance"]        = GetSpellInfo(51713)
Subtlety.L["Ambush"]     	      = GetSpellInfo(8676)
Subtlety.L["Premeditation"]		  = GetSpellInfo(14183)
Subtlety.L["Vanish"]              = GetSpellInfo(1856)
Subtlety.L["Redirect"]            = GetSpellInfo(73981)

Subtlety.timeSinceLastUpdate = 0
Subtlety.playerName = UnitName("player")

Subtlety.textureList = {
  ["last"] = nil,
  ["redirect"] = nil,
  ["current"] = nil,
  ["next"] = nil,
  ["misc"] = nil,
  ["int"] = nil,
  ["premeditation"] = nil,
  }


-- Our sneaky frame to watch for events ... checks Subtlety.events[] for the function.  Passes all args.
Subtlety.eventFrame = CreateFrame("Frame")
Subtlety.eventFrame:SetScript("OnEvent", function(this, event, ...)
  Subtlety.events[event](...)
end)

Subtlety.eventFrame:RegisterEvent("ADDON_LOADED")
Subtlety.eventFrame:RegisterEvent("PLAYER_LOGIN")
Subtlety.eventFrame:RegisterEvent("PLAYER_ALIVE")
Subtlety.eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
Subtlety.eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")


-- Define our Event Handlers here
Subtlety.events = {}

function Subtlety.events.PLAYER_TALENT_UPDATE()
	-- check talents for Shadow Dance
 
	local _, _, _, _, sd_rank = GetTalentInfo(3, 19) 

	if sd_rank == 1 then 
		Subtlety.displayFrame:Show() 
	else 
		Subtlety.displayFrame:Hide() 
	end 
end

function Subtlety.events.PLAYER_ALIVE()
	--SendChatMessage("Subtlety.events.PLAYER_ALIVE()",  "SAY", GetDefaultLanguage("player"));
	Subtlety.eventFrame:UnregisterEvent("PLAYER_ALIVE")
end

function Subtlety.events.PLAYER_LOGIN()
	--SendChatMessage("Subtlety.events.PLAYER_LOGIN()",  "SAY", GetDefaultLanguage("player"));
	Subtlety.playerName = UnitName("player");
end

function Subtlety.events.ADDON_LOADED(addon)

	if addon ~= "rogue-subtlety" then 
		return 
	end
	
	local _,playerClass = UnitClass("player")
	if playerClass ~= "ROGUE" then
		Subtlety.eventFrame:UnregisterEvent("PLAYER_ALIVE")
		Subtlety.eventFrame:UnregisterEvent("ADDON_LOADED")
		Subtlety.eventFrame:UnregisterEvent("PLAYER_LOGIN")
		Subtlety.eventFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
		Subtlety.eventFrame:UnregisterEvent("PLAYER_TALENT_UPDATE")
		return 
	end
	
	-- Default saved variables
	if not Subtletydb then
		Subtletydb = {} -- fresh start
	end
	
	if not Subtletydb.scale then Subtletydb.scale = 1 end
	
	if not Subtletydb.RecuperatePoints then Subtletydb.RecuperatePoints = 3 end
	if not Subtletydb.RecuperatePriority then Subtletydb.RecuperatePriority = 1 end

	if not Subtletydb.RupturePoints then Subtletydb.RupturePoints = 5 end
	if not Subtletydb.RupturePriority then Subtletydb.RupturePriority = 2 end

	if not Subtletydb.SliceAndDicePoints then Subtletydb.SliceAndDicePoints = 3 end
	if not Subtletydb.SliceAndDicePriority then Subtletydb.SliceAndDicePriority = 3 end
	
	if Subtletydb.locked == nil then Subtletydb.locked = false end
	if not Subtletydb.x then Subtletydb.x = 100 end
	if not Subtletydb.y then Subtletydb.y = 100 end
	if not Subtletydb.SuggestVanish then Subtletydb.SuggestVanish = false end	
	if not Subtletydb.SuggestBackstab then Subtletydb.SuggestBackstab = false end
	if not Subtletydb.SuggestShadowDance then Subtletydb.SuggestShadowDance = false end	
	if not Subtletydb.SuggestTotT then Subtletydb.SuggestTotT = false end		
	if Subtletydb.range == nil then Subtletydb.range = true end
	
	if (Subtletydb.SuggestBackstab == true) then
		Subtlety.L["Generator"] = Subtlety.L["Hemorrhage"]
	else
		Subtlety.L["Generator"] = Subtlety.L["Backstab"]
	end	
	
	-- Create GUI
	Subtlety:CreateGUI()
	Subtlety.displayFrame:SetScale(Subtletydb.scale)


	-- Create Options Frame
	Subtlety:CreateOptionFrame()
	if Subtletydb.locked then
		Subtlety.displayFrame:SetScript("OnMouseDown", nil)
		Subtlety.displayFrame:SetScript("OnMouseUp", nil)
		Subtlety.displayFrame:SetScript("OnDragStop", nil)
		Subtlety.displayFrame:SetBackdropColor(0, 0, 0, 0)
		Subtlety.displayFrame:EnableMouse(false)
	else
		Subtlety.displayFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		Subtlety.displayFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
		Subtlety.displayFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		Subtlety.displayFrame:SetBackdropColor(0, 0, 0, .4)
		Subtlety.displayFrame:EnableMouse(true)
	end

	-- Register for Slash Commands
	SlashCmdList["Subtlety"] = Subtlety.Options
	SLASH_Subtlety1 = "/subtlety"
	SLASH_Subtlety2 = "/sub"

	-- Register for Function Events
	Subtlety.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Subtlety.eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

	
	-- check talents for Shadow Dance
 
	local _, _, _, _, sd_rank = GetTalentInfo(3,19) 

	if sd_rank == 1 then 
		Subtlety.displayFrame:Show() 
	else 
		Subtlety.displayFrame:Hide() 
	end 
	
	--SendChatMessage("Subtlety.events.ADDON_LOADED(addon)",  "SAY", GetDefaultLanguage("player"));

end

function Subtlety.events.COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	--SendChatMessage("Subtlety.events.COMBAT_LOG_EVENT_UNFILTERED",  "SAY", GetDefaultLanguage("player"));
	
	if UnitName("target") == nil or UnitIsFriend("player","target") ~= nil or UnitHealth("target") == 0 then
		Subtlety.displayFrame_last:Hide()
		--Subtlety.displayFrame_redirect:Hide()
		Subtlety.displayFrame_current:Hide()
		Subtlety.displayFrame_next:Hide()
		Subtlety.displayFrame_misc:Hide()
		Subtlety.displayFrame_int:Hide()
		Subtlety.displayFrame_premeditation:Hide()		
	else
		Subtlety.displayFrame_last:Show()
		--Subtlety.displayFrame_redirect:Show()
		Subtlety.displayFrame_current:Show()
		Subtlety.displayFrame_next:Show()
		Subtlety.displayFrame_misc:Show()
		Subtlety.displayFrame_int:Show()
		Subtlety.displayFrame_premeditation:Show()				
		Subtlety:DecideSpells()
	end

end

function Subtlety.events.COMBAT_RATING_UPDATE(unit)
	--SendChatMessage("Subtlety.events.COMBAT_RATING_UPDATE(unit)",  "SAY", GetDefaultLanguage("player"));

end

function Subtlety.events.PLAYER_TARGET_CHANGED(...)
	--SendChatMessage("Subtlety.events.PLAYER_TARGET_CHANGED(...)",  "SAY", GetDefaultLanguage("player"));
	
	-- target changed, set last target, update current target, will be nil if no target
	Subtlety.lastTarget = Subtlety.currentTarget
	Subtlety.currentTarget = UnitGUID("target")
	
	if UnitName("target") == nil or UnitIsFriend("player","target") ~= nil or UnitHealth("target") == 0 then
		Subtlety.displayFrame_last:Hide()
		--Subtlety.displayFrame_redirect:Hide()
		Subtlety.displayFrame_current:Hide()
		Subtlety.displayFrame_next:Hide()
		Subtlety.displayFrame_misc:Hide()
		Subtlety.displayFrame_int:Hide()
		Subtlety.displayFrame_premeditation:Hide()
	else
		Subtlety.displayFrame_last:Show()
		--Subtlety.displayFrame_redirect:Show()
		Subtlety.displayFrame_current:Show()
		Subtlety.displayFrame_next:Show()
		Subtlety.displayFrame_misc:Show()
		Subtlety.displayFrame_int:Show()
		Subtlety.displayFrame_premeditation:Show()
		Subtlety:DecideSpells()
	end
end



-- End Event Handlers


function Subtlety:CreateGUI()

  local displayFrame = CreateFrame("Frame","SubtletyDisplayFrame",UIParent)
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

  local displayFrame_last = CreateFrame("Frame","$parent_last", SubtletyDisplayFrame)
  --local displayFrame_redirect = CreateFrame("Frame","$parent_redirect", SubtletyDisplayFrame)
  local displayFrame_current = CreateFrame("Frame","$parent_current", SubtletyDisplayFrame)
  local displayFrame_next = CreateFrame("Frame","$parent_next", SubtletyDisplayFrame)
  local displayFrame_misc = CreateFrame("Frame","$parent_misc", SubtletyDisplayFrame)
  local displayFrame_int = CreateFrame("Frame","$parent_int", SubtletyDisplayFrame)
  local displayFrame_premeditation = CreateFrame("Frame","$parent_premeditation", SubtletyDisplayFrame)

  displayFrame_last:SetWidth(45)
  --displayFrame_redirect:SetWidth(45)
  displayFrame_current:SetWidth(70)
  displayFrame_next:SetWidth(45)
  displayFrame_misc:SetWidth(45)
  displayFrame_int:SetWidth(45)
  displayFrame_premeditation:SetWidth(45)

  displayFrame_last:SetHeight(45)
  --displayFrame_redirect:SetHeight(45)
  displayFrame_current:SetHeight(70)
  displayFrame_next:SetHeight(45)
  displayFrame_misc:SetHeight(45)
  displayFrame_int:SetHeight(45)
  displayFrame_premeditation:SetHeight(45)

  displayFrame_current:SetPoint("TOPLEFT", 140, -10)
  displayFrame_next:SetPoint("TOPLEFT", 250, -50)
  
  displayFrame_last:SetPoint("TOPLEFT", 0, -50)
  --displayFrame_redirect:SetPoint("TOPLEFT", 250, 0)

  displayFrame_misc:SetPoint("TOPLEFT", 0, 0)
  displayFrame_int:SetPoint("TOPLEFT", 50, 0)
  displayFrame_premeditation:SetPoint("TOPLEFT", 50,-50) 


  local t = displayFrame_last:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_last)
  t:SetAlpha(.8)
  displayFrame_last.texture = t
  Subtlety.textureList["last"] = t

  --[[
  t = displayFrame_redirect:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_redirect)
  t:SetAlpha(.8)
  displayFrame_redirect.texture = t
  Subtlety.textureList["redirect"] = t  
	]]
	
  t = displayFrame_current:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:ClearAllPoints()
  t:SetAllPoints(displayFrame_current)
  displayFrame_current.texture = t
  Subtlety.textureList["current"] = t

  t = displayFrame_misc:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_misc)
  t:SetAlpha(.8)
  displayFrame_misc.texture = t
  Subtlety.textureList["misc"] = t

  t = displayFrame_int:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_int)
  t:SetAlpha(.8)
  displayFrame_int.texture = t
  Subtlety.textureList["int"] = t

  t = displayFrame_next:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_next)
  t:SetAlpha(.8)
  displayFrame_next.texture = t
  Subtlety.textureList["next"] = t

  t = displayFrame_premeditation:CreateTexture(nil,"BACKGROUND")
  t:SetTexture(nil)
  t:SetAllPoints(displayFrame_premeditation)
  t:SetAlpha(.8)
  displayFrame_premeditation.texture = t
  Subtlety.textureList["premeditation"] = t
  
  
  displayFrame:SetScript("OnUpdate", function(this, elapsed)
	Subtlety:OnUpdate(elapsed)
  end)

  local cooldownFrame = CreateFrame("Cooldown","$parent_cooldown", SubtletyDisplayFrame_current)
  cooldownFrame:SetHeight(70)
  cooldownFrame:SetWidth(70)
  cooldownFrame:ClearAllPoints()
  cooldownFrame:SetPoint("CENTER", displayFrame_current, "CENTER", 0, 0)
  
  Subtlety.displayFrame = displayFrame
  Subtlety.displayFrame_last = displayFrame_last
  Subtlety.displayFrame_current = displayFrame_current
  Subtlety.displayFrame_next = displayFrame_next
  Subtlety.displayFrame_misc =  displayFrame_misc
  Subtlety.displayFrame_int =  displayFrame_int
  Subtlety.displayFrame_premeditation = displayFrame_premeditation
  Subtlety.cooldownFrame = cooldownFrame

end

function Subtlety:OnUpdate(elapsed)

	Subtlety.timeSinceLastUpdate = Subtlety.timeSinceLastUpdate + elapsed;

--	if (Subtlety.timeSinceLastUpdate >= 1) then
		Subtlety:DecideSpells()
--	end

end

function Subtlety:Find(t, v, c)
   if type(t) == "table" and v then 
      v = (c==0 or c==2) and v:lower() or v 
      for k, val in pairs(t) do 
         val = (c==0 or c==2) and val:lower() or val
         if (c==1 or c==2) and val:find(v) or v == val then 
            return k
         end 
      end 
   end 
   return nil
end

function Subtlety:DecideSpells()

	-- Database for finishers --
	Subtlety.Finisher = {
		{
			spell = "Recuperate",
			name = "recuperate",
			priority = Subtletydb.RecuperatePriority,
			points = Subtletydb.RecuperatePoints,
			energy = 30,
			expires = '0',
		},

		{
			spell = "Rupture",
			name = "rupture",
			priority = Subtletydb.RupturePriority,
			points = Subtletydb.RupturePoints,
			energy = 25,
			expires = '0',
		},

		{
			spell = "Slice and Dice",
			name = "slice_and_dice",
			priority = Subtletydb.SliceAndDicePriority,
			points = Subtletydb.SliceAndDicePoints,
			energy = 25,
			expires = '0',
		},
	}

	function sort_func(a, b)
		return a.priority < b.priority;
	end

	table.sort(Subtlety.Finisher, sort_func);
	
	Subtlety.timeSinceLastUpdate = 0;

	local guid = UnitGUID("target")
	local puid = UnitGUID("player")
	
	if  UnitName("target") == nil or UnitIsFriend("player","target") ~= nil or UnitHealth("target") == 0 then
		return -- ignore the dead and friendly
	end

	if guid == nil then
		Subtlety.textureList["last"]:SetTexture(nil)
		--Subtlety.textureList["redirect"]:SetTexture(nil)
		Subtlety.textureList["current"]:SetTexture(nil)
		Subtlety.textureList["next"]:SetTexture(nil)
		Subtlety.textureList["misc"]:SetTexture(nil)
		Subtlety.textureList["int"]:SetTexture(nil)
		Subtlety.textureList["premeditation"]:SetTexture(nil)
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
	
	local cost = 0
	local garrote = 0
	local slice_and_dice = 0
	local recuperate = 0
	local rupture = 0	
	local premeditation = 0	
	local hemorrhage = 0
	local vanish = 0	
	local tott = 0
	local shadowstep = 0
	local shadow_dance = 0
	local master_of_subtlety = 0
	local serrated_blades = 0	
	
	-- 29102010 decipherable Anticipating Cataclysm --
	local redirect = 0
	
	--[[ Recuperate, Slice and Dice, Rupture ]]--
	for i = 1, 3, 1 do

	   local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitBuff("player", Subtlety.L[Subtlety.Finisher[i].spell])
	   
	   currentTime = GetTime()
	   if name ~= nil then
		  if Subtlety.Finisher[i].name == "recuperate" then
			 Subtlety.Finisher[i]["expires"] = expirationTime - currentTime
		  elseif Subtlety.Finisher[i].name == "slice_and_dice" then
			 Subtlety.Finisher[i]["expires"] = expirationTime - currentTime
		  end
	   end
	   
	   local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", Subtlety.L[Subtlety.Finisher[i].spell])
	   
	   currentTime = GetTime()
	   if name ~= nil then
		  if Subtlety.Finisher[i].name == "rupture" then
			 Subtlety.Finisher[i]["expires"] = expirationTime - currentTime
		  end
	   end   
	   
	end	

	--[[ Generator ]]--
	local name, rank, icon, price, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(Subtlety.L["Generator"])
	
	if name ~= nil then
		cost = price
	end	

	--[[ Rupture ]]--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", Subtlety.L["Rupture"])

	currentTime = GetTime()
	if name ~= nil and isMine == "player" then
		rupture = expirationTime - currentTime
	end	

	--[[ Recuperate ]]--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitBuff("player", Subtlety.L["Recuperate"])

	currentTime = GetTime()
	if name ~= nil and isMine == "player" then
		recuperate = expirationTime - currentTime
	end		
	
	--[[ Garrote ]]--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", Subtlety.L["Garrote"])

	currentTime = GetTime()
	if name ~= nil and isMine == "player" then
		garrote = expirationTime - currentTime
	end	

	--[[ Master of Subtlety ]]--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitBuff("player", Subtlety.L["Master of Subtlety"])

	currentTime = GetTime()
	if name ~= nil then
		master_of_subtlety = expirationTime - currentTime
	end
	
	--[[ Hemorrhage ]]--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", Subtlety.L["Hemorrhage"])
	currentTime = GetTime()
	if name ~= nil and isMine == "player" then
		hemorrhage = expirationTime - currentTime
	end	
	
	--[[ Tricks of the Trade ]]--
	local start, duration, enabled = GetSpellCooldown(Subtlety.L["Tricks of the Trade"]);
	if duration ~= nil then 
		tott = duration + start - currentTime
	else
		tott = 60
	end	
	
	--[[ Shadowstep ]]--
	local start, duration, enabled = GetSpellCooldown(Subtlety.L["Shadowstep"]);
	if duration ~= nil then 
		shadowstep = duration + start - currentTime
	else
		shadowstep = 60
	end	

	--[[ Vanish ]]--
	local start, duration, enabled = GetSpellCooldown(Subtlety.L["Vanish"]);
	if duration ~= nil then
		vanish = duration + start - currentTime
	else
		vanish = 60
	end	
	
	--[[ Premeditation ]]--
	local start, duration, enabled = GetSpellCooldown(Subtlety.L["Premeditation"]);
	if duration ~= nil then 
		premeditation = duration + start - currentTime
	else
		premeditation = 60
	end	
	
	--[[ Shadow Dance ]]--
	local start, duration, enabled = GetSpellCooldown(Subtlety.L["Shadow Dance"]);
	if duration ~= nil then 
		shadow_dance = duration + start - currentTime
	else
		shadow_dance = 60
	end	
	
	--[[ Serrated Blades ]]--
	local _, _, _, _, sb_rank = GetTalentInfo(3,18);  
	
	if sb_rank ~= 0 then 
		serrated_blades = true 
	else 
		serrated_blades = false
	end

	--[[ Prioritize ]]--

	--[[ Rotation borrowed from: http://elitistjerks.com/f78/t105659-4_0_1_rogue_faq/p19/#post1781716 ]]--		
	
	if UnitAura("player", Subtlety.L["Stealth"]) ~= nil or UnitBuff("player", Subtlety.L["Shadow Dance"]) ~= nil or UnitBuff("player", Subtlety.L["Vanish"]) ~= nil then
		
		-- Evaluate Premeditation and Recuperation status
		--[[ if (recuperate == 0) then
			if premeditation < 1 then 
				spell = Subtlety.L["Premeditation"];
			else
				spell = Subtlety.L["Recuperate"];
			end			
		
		else ]]--
		
		if (tott < 1) and (Subtletydb.SuggestTotT == true) then
			spell = Subtlety.L["Tricks of the Trade"];
						
		elseif (shadowstep < 1) then
			spell = Subtlety.L["Shadowstep"];
			
		elseif (tonumber(Subtlety.Finisher[1].expires) <= 5) and (cp >= tonumber(Subtlety.Finisher[1].points)) and (tonumber(Subtlety.Finisher[1].points) ~= 0) then
			if (energy >= Subtlety.Finisher[1].energy) then
				spell = Subtlety.L[Subtlety.Finisher[1].spell];
			else
				nextspell = Subtlety.L[Subtlety.Finisher[1].spell];
			end	
		elseif (tonumber(Subtlety.Finisher[2].expires) <= 5) and (cp >= tonumber(Subtlety.Finisher[2].points)) and (tonumber(Subtlety.Finisher[2].points) ~= 0) then
			if (energy >= Subtlety.Finisher[2].energy) then
				spell = Subtlety.L[Subtlety.Finisher[2].spell];
			else
				nextspell = Subtlety.L[Subtlety.Finisher[2].spell];
			end	
		elseif (tonumber(Subtlety.Finisher[3].expires) <= 5) and (cp >= tonumber(Subtlety.Finisher[3].points)) and (tonumber(Subtlety.Finisher[3].points) ~= 0) then
			if (energy >= Subtlety.Finisher[3].energy) then
				spell = Subtlety.L[Subtlety.Finisher[3].spell];
			else
				nextspell = Subtlety.L[Subtlety.Finisher[3].spell];
			end	
			
		elseif (cp == 5) then
			--Eviscerate--
			if (energy >= 25) then
				spell = Subtlety.L["Eviscerate"];
			else
				nextspell = Subtlety.L["Eviscerate"];
			end							
			
		else
			--Generator--
			if (hemorrhage > 1) and (garrote ~= 0.0) then
				if (energy >= 50) then
					spell = Subtlety.L["Garrote"];
				else
					nextspell = Subtlety.L["Garrote"];
				end
			else				
				if (energy >= 40) then
					spell = Subtlety.L["Ambush"];
				else
					nextspell = Subtlety.L["Ambush"];
				end	
			end
		end
		
	end	
	
	
	if UnitAura("player", Subtlety.L["Stealth"]) == nil and UnitBuff("player", Subtlety.L["Shadow Dance"]) == nil and UnitBuff("player", Subtlety.L["Vanish"]) == nil then		
		
		if (serrated_blades == true) and (rupture <= 7) and (cp >= 1) and (rupture ~= 0) then
			if (energy >= 35) then
				spell = Subtlety.L["Eviscerate"];
			else
				nextspell = Subtlety.L["Eviscerate"];
			end		

		elseif (tott < 1) and (Subtletydb.SuggestTotT == true) then
			spell = Subtlety.L["Tricks of the Trade"];
			
		elseif (shadow_dance < 1) and (Subtletydb.SuggestShadowDance == true) then
			spell = Subtlety.L["Shadow Dance"];	

		elseif (vanish < 1) and (Subtletydb.SuggestVanish == true) then
			spell = Subtlety.L["Tricks of the Trade"];				
			
		elseif (tonumber(Subtlety.Finisher[1].expires) <= 5) and (cp >= tonumber(Subtlety.Finisher[1].points)) and (tonumber(Subtlety.Finisher[1].points) ~= 0) then
			if (energy >= Subtlety.Finisher[1].energy) then
				spell = Subtlety.L[Subtlety.Finisher[1].spell];
			else
				nextspell = Subtlety.L[Subtlety.Finisher[1].spell];
			end	
		elseif (tonumber(Subtlety.Finisher[2].expires) <= 5) and (cp >= tonumber(Subtlety.Finisher[2].points)) and (tonumber(Subtlety.Finisher[2].points) ~= 0) then 
			if (energy >= Subtlety.Finisher[2].energy) then
				spell = Subtlety.L[Subtlety.Finisher[2].spell];
			else
				nextspell = Subtlety.L[Subtlety.Finisher[2].spell];
			end	
		elseif (tonumber(Subtlety.Finisher[3].expires) <= 5) and (cp >= tonumber(Subtlety.Finisher[3].points)) and (tonumber(Subtlety.Finisher[3].points) ~= 0) then
			if (energy >= Subtlety.Finisher[3].energy) then
				spell = Subtlety.L[Subtlety.Finisher[3].spell];
			else
				nextspell = Subtlety.L[Subtlety.Finisher[3].spell];
			end	
			
		elseif (cp == 5) then
			--Eviscerate--
			if (energy >= 25) then
				spell = Subtlety.L["Eviscerate"];
			else
				nextspell = Subtlety.L["Eviscerate"];
			end							
		else
			--Generator--
			if (hemorrhage <= 5) then
				if (energy >= cost) then
					spell = Subtlety.L["Hemorrhage"];
				else
					nextspell = Subtlety.L["Hemorrhage"];			
				end
			else		 
				if (energy >= cost) then
					spell = Subtlety.L["Generator"];
				else
					nextspell = Subtlety.L["Generator"];
				end
			end
		end
	end
	
	Subtlety.textureList["current"]:SetTexture(GetSpellBookItemTexture(spell))
	Subtlety.textureList["next"]:SetTexture(GetSpellBookItemTexture(nextspell))

	--[[
	if redirect < 1 then
		Subtlety.textureList["redirect"]:SetTexture(GetSpellBookItemTexture(Subtlety.L["Redirect"]))
	else
		Subtlety.textureList["redirect"]:SetTexture(nil)
	end
	]]
	
	if shadow_dance < 1 then
		Subtlety.textureList["last"]:SetTexture(GetSpellBookItemTexture(Subtlety.L["Shadow Dance"]))
	else
		Subtlety.textureList["last"]:SetTexture(nil)
	end
	
	if tott < 1 then
		Subtlety.textureList["misc"]:SetTexture(GetSpellBookItemTexture(Subtlety.L["Tricks of the Trade"]))
	else
		Subtlety.textureList["misc"]:SetTexture(nil)
	end
	
	if (vanish < 1) then
		Subtlety.textureList["int"]:SetTexture(GetSpellBookItemTexture(Subtlety.L["Vanish"]))
	else
		Subtlety.textureList["int"]:SetTexture(nil)
	end
	
	if premeditation < 1 then
		Subtlety.textureList["premeditation"]:SetTexture(GetSpellBookItemTexture(Subtlety.L["Premeditation"]))
	else
		Subtlety.textureList["premeditation"]:SetTexture(nil)
	end
		
	if spell ~= "" and spell ~= nil then
		local start, dur = GetSpellCooldown(spell)
		if dur == 0 or start == nil or dur == nil then
			Subtlety.cooldownFrame:SetAlpha(0)
		else
			Subtlety.cooldownFrame:SetAlpha(1)
			Subtlety.cooldownFrame:SetCooldown(start, dur)
		end
	end
end

function Subtlety:CreateOptionFrame()
	local panel = CreateFrame("FRAME", "SubtletyOptions");
	panel.name = "Rogue: Subtlety";
	
	local fstring00 = panel:CreateFontString("SubtletyOptions_string00","OVERLAY","GameFontNormal")
	fstring00:SetText("Priority")
	fstring00:SetPoint("TOPLEFT", 175, -10)

	local fstring01 = panel:CreateFontString("SubtletyOptions_string01","OVERLAY","GameFontNormal")
	fstring01:SetText("Combo Points")
	fstring01:SetPoint("TOPLEFT", 285, -10)
	
	--[[ New line start ]]--

	local fstring1 = panel:CreateFontString("SubtletyOptions_string1","OVERLAY","GameFontNormal")
	fstring1:SetText("Recuperate")
	fstring1:SetPoint("TOPLEFT", 10, -40)

	local slider1a = CreateFrame("Slider", "$parent_s1a", panel, "OptionsSliderTemplate")
	slider1a:SetMinMaxValues(1, 3)
	slider1a:SetWidth(75)
	slider1a:SetValue(Subtlety:GetRecuperatePriority())
	slider1a:SetValueStep(1)
	slider1a:SetScript("OnValueChanged", function(self) Subtlety:SetRecuperatePriority(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider1a:GetName() .. "Low"):SetText("1")
	getglobal(slider1a:GetName() .. "High"):SetText("3")
	getglobal(slider1a:GetName() .. "Text"):SetText(Subtlety:GetRecuperatePriority())
	slider1a:SetPoint("TOPRIGHT", -175, -40)

	local slider1b = CreateFrame("Slider", "$parent_s1b", panel, "OptionsSliderTemplate")
	slider1b:SetMinMaxValues(0, 5)
	slider1b:SetWidth(150)
	slider1b:SetValue(Subtlety:GetRecuperatePoints())
	slider1b:SetValueStep(1)
	slider1b:SetScript("OnValueChanged", function(self) Subtlety:SetRecuperatePoints(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider1b:GetName() .. "Low"):SetText("None")
	getglobal(slider1b:GetName() .. "High"):SetText("5")
	getglobal(slider1b:GetName() .. "Text"):SetText(Subtlety:GetRecuperatePoints())
	slider1b:SetPoint("TOPRIGHT", -10, -40)
	
	--[[]]--
	
	local fstring2 = panel:CreateFontString("SubtletyOptions_string2","OVERLAY","GameFontNormal")
	fstring2:SetText("Rupture")
	fstring2:SetPoint("TOPLEFT", 10, -70)

	local slider2a = CreateFrame("Slider", "$parent_s2a", panel, "OptionsSliderTemplate")
	slider2a:SetMinMaxValues(1, 3)
	slider2a:SetWidth(75)
	slider2a:SetValue(Subtlety:GetRupturePriority())
	slider2a:SetValueStep(1)
	slider2a:SetScript("OnValueChanged", function(self) Subtlety:SetRupturePriority(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider2a:GetName() .. "Low"):SetText("1")
	getglobal(slider2a:GetName() .. "High"):SetText("3")
	getglobal(slider2a:GetName() .. "Text"):SetText(Subtlety:GetRupturePriority())
	slider2a:SetPoint("TOPRIGHT", -175, -70)

	local slider2b = CreateFrame("Slider", "$parent_s2b", panel, "OptionsSliderTemplate")
	slider2b:SetMinMaxValues(0, 5)
	slider2b:SetWidth(150)
	slider2b:SetValue(Subtlety:GetRupturePoints())
	slider2b:SetValueStep(1)
	slider2b:SetScript("OnValueChanged", function(self) Subtlety:SetRupturePoints(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider2b:GetName() .. "Low"):SetText("None")
	getglobal(slider2b:GetName() .. "High"):SetText("5")
	getglobal(slider2b:GetName() .. "Text"):SetText(Subtlety:GetRupturePoints())
	slider2b:SetPoint("TOPRIGHT", -10, -70)

	--[[]]--
	
	local fstring3 = panel:CreateFontString("SubtletyOptions_string3","OVERLAY","GameFontNormal")
	fstring3:SetText("Slice and Dice")
	fstring3:SetPoint("TOPLEFT", 10, -100)

	local slider3a = CreateFrame("Slider", "$parent_s3a", panel, "OptionsSliderTemplate")
	slider3a:SetMinMaxValues(1, 3)
	slider3a:SetWidth(75)
	slider3a:SetValue(Subtlety:GetSliceAndDicePriority())
	slider3a:SetValueStep(1)
	slider3a:SetScript("OnValueChanged", function(self) Subtlety:SetSliceAndDicePriority(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider3a:GetName() .. "Low"):SetText("1")
	getglobal(slider3a:GetName() .. "High"):SetText("3")
	getglobal(slider3a:GetName() .. "Text"):SetText(Subtlety:GetSliceAndDicePriority())
	slider3a:SetPoint("TOPRIGHT", -175, -100)

	local slider3b = CreateFrame("Slider", "$parent_s3b", panel, "OptionsSliderTemplate")
	slider3b:SetMinMaxValues(0, 5)
	slider3b:SetWidth(150)
	slider3b:SetValue(Subtlety:GetSliceAndDicePoints())
	slider3b:SetValueStep(1)
	slider3b:SetScript("OnValueChanged", function(self) Subtlety:SetSliceAndDicePoints(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider3b:GetName() .. "Low"):SetText("None")
	getglobal(slider3b:GetName() .. "High"):SetText("5")
	getglobal(slider3b:GetName() .. "Text"):SetText(Subtlety:GetSliceAndDicePoints())
	slider3b:SetPoint("TOPRIGHT", -10, -100)

	--[[ New line end ]]--
	
	local fstring4 = panel:CreateFontString("SubtletyOptions_string4","OVERLAY","GameFontNormal")
	fstring4:SetText("Suggest Vanish in Rotation")
	fstring4:SetPoint("TOPLEFT", 10, -150)
	
	local checkbox4 = CreateFrame("CheckButton", "$parent_cb4", panel, "OptionsCheckButtonTemplate")
	checkbox4:SetWidth(18)
	checkbox4:SetHeight(18)
	checkbox4:SetScript("OnClick", function() Subtlety:ToggleVanish() end)
	checkbox4:SetPoint("TOPRIGHT", -10, -150)
	checkbox4:SetChecked(Subtlety:GetVanish())	


	--[[ New Option: Use Hemorrhage over Backstab as Combo Points generator ]]--
	local fstring5 = panel:CreateFontString("SubtletyOptions_string4","OVERLAY","GameFontNormal")
	fstring5:SetText("Suggest Hemorrhage for Combo Points Generator")
	fstring5:SetPoint("TOPLEFT", 10, -180)
	
	local checkbox5 = CreateFrame("CheckButton", "$parent_cb5", panel, "OptionsCheckButtonTemplate")
	checkbox5:SetWidth(18)
	checkbox5:SetHeight(18)
	checkbox5:SetScript("OnClick", function() Subtlety:ToggleBackstab() end)
	checkbox5:SetPoint("TOPRIGHT", -10, -180)
	checkbox5:SetChecked(Subtlety:GetBackstab())	


	--[[ New Option: Suggest Shadow Dance ]]--
	local fstring6 = panel:CreateFontString("SubtletyOptions_string5","OVERLAY","GameFontNormal")
	fstring6:SetText("Suggest Shadow Dance")
	fstring6:SetPoint("TOPLEFT", 10, -210)
	
	local checkbox6 = CreateFrame("CheckButton", "$parent_cb6", panel, "OptionsCheckButtonTemplate")
	checkbox6:SetWidth(18)
	checkbox6:SetHeight(18)
	checkbox6:SetScript("OnClick", function() Subtlety:ToggleShadowDance() end)
	checkbox6:SetPoint("TOPRIGHT", -10, -210)
	checkbox6:SetChecked(Subtlety:GetShadowDance())
	
	--[[ New Option: Suggest Tricks of the Trade ]]--
	local fstring7 = panel:CreateFontString("SubtletyOptions_string7","OVERLAY","GameFontNormal")
	fstring7:SetText("Suggest Tricks of the Trade")
	fstring7:SetPoint("TOPLEFT", 10, -240)
	
	local checkbox7 = CreateFrame("CheckButton", "$parent_cb7", panel, "OptionsCheckButtonTemplate")
	checkbox7:SetWidth(18)
	checkbox7:SetHeight(18)
	checkbox7:SetScript("OnClick", function() Subtlety:ToggleTotT() end)
	checkbox7:SetPoint("TOPRIGHT", -10, -240)
	checkbox7:SetChecked(Subtlety:GetTotT())
		
		
	local fstring8 = panel:CreateFontString("SubtletyOptions_string8","OVERLAY","GameFontNormal")
	fstring8:SetText("GUI Scale")
	fstring8:SetPoint("TOPLEFT", 10, -280)

	local slider8 = CreateFrame("Slider", "$parent_s8", panel, "OptionsSliderTemplate")
	slider8:SetMinMaxValues(.5, 1.5)
	slider8:SetValue(Subtlety:GetScale())
	slider8:SetValueStep(.05)
	slider8:SetScript("OnValueChanged", function(self) Subtlety:SetScale(self:GetValue()); getglobal(self:GetName() .. "Text"):SetText(self:GetValue())  end)
	getglobal(slider8:GetName() .. "Low"):SetText("0.5")
	getglobal(slider8:GetName() .. "High"):SetText("1.5")
	getglobal(slider8:GetName() .. "Text"):SetText(Subtlety:GetScale())
	slider8:SetPoint("TOPRIGHT", -10, -280)

	local fstring9 = panel:CreateFontString("SubtletyOptions_string1","OVERLAY","GameFontNormal")
	fstring9:SetText("Lock")
	fstring9:SetPoint("TOPLEFT", 10, -320)

	local checkbox9 = CreateFrame("CheckButton", "$parent_cb9", panel, "OptionsCheckButtonTemplate")
	checkbox9:SetWidth(18)
	checkbox9:SetHeight(18)
	checkbox9:SetScript("OnClick", function() Subtlety:ToggleLocked() end)
	checkbox9:SetPoint("TOPRIGHT", -10, -320)
	checkbox9:SetChecked(Subtlety:GetLocked())
	
	InterfaceOptions_AddCategory(panel);
end

function Subtlety:GetLocked()
	return Subtletydb.locked
end

function Subtlety:ToggleLocked()
	if Subtletydb.locked then
		Subtletydb.locked = false
		Subtlety.displayFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		Subtlety.displayFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
		Subtlety.displayFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		Subtlety.displayFrame:SetBackdropColor(0, 0, 0, .4)
		Subtlety.displayFrame:EnableMouse(true)
	else
		Subtletydb.locked = true
		Subtlety.displayFrame:SetScript("OnMouseDown", nil)
		Subtlety.displayFrame:SetScript("OnMouseUp", nil)
		Subtlety.displayFrame:SetScript("OnDragStop", nil)
		Subtlety.displayFrame:SetBackdropColor(0, 0, 0, 0)
		Subtlety.displayFrame:EnableMouse(false)
	end
end

function Subtlety:GetScale()
	return Subtletydb.scale
end

function Subtlety:SetScale(num)
	Subtletydb.scale = num
	Subtlety.displayFrame:SetScale(Subtletydb.scale)
	Subtlety.cooldownFrame:SetScale(Subtletydb.scale)
end

function Subtlety.Options(msg, editBox)

	if(msg == 'show') then
		Subtlety.displayFrame:Show() 
	elseif(msg == 'hide') then
		Subtlety.displayFrame:Hide() 
	elseif(msg == '') then
		InterfaceOptionsFrame_OpenToCategory(getglobal("SubtletyOptions"))
	else
	end
	
end

--[[ New line ]]--

function Subtlety:GetRecuperatePoints()
	return Subtletydb.RecuperatePoints
end

function Subtlety:SetRecuperatePoints(num)
	Subtletydb.RecuperatePoints = num
end

function Subtlety:GetRecuperatePriority()
	return Subtletydb.RecuperatePriority
end

function Subtlety:SetRecuperatePriority(num)
	Subtletydb.RecuperatePriority = num
end

--[[]]--

function Subtlety:GetRupturePoints()
	return Subtletydb.RupturePoints
end

function Subtlety:SetRupturePoints(num)
	Subtletydb.RupturePoints = num	
end

function Subtlety:GetRupturePriority()
	return Subtletydb.RupturePriority
end

function Subtlety:SetRupturePriority(num)
	Subtletydb.RupturePriority = num
end

--[[]]--

function Subtlety:GetSliceAndDicePoints()
	return Subtletydb.SliceAndDicePoints
end

function Subtlety:SetSliceAndDicePoints(num)
	Subtletydb.SliceAndDicePoints = num
end

function Subtlety:GetSliceAndDicePriority()
	return Subtletydb.SliceAndDicePriority
end

function Subtlety:SetSliceAndDicePriority(num)
	Subtletydb.SliceAndDicePriority = num
end

--[[ End new line ]]--

function Subtlety:GetVanish()
	return Subtletydb.SuggestVanish
end

function Subtlety:GetShadowDance()
	return Subtletydb.SuggestShadowDance
end

function Subtlety:GetBackstab()
	return Subtletydb.SuggestBackstab
end

function Subtlety:GetTotT()
	return Subtletydb.SuggestTotT
end

function Subtlety:ToggleVanish()
	if(Subtletydb.SuggestVanish == true) then
		Subtletydb.SuggestVanish = false
	else
		Subtletydb.SuggestVanish = true
	end
end

function Subtlety:ToggleShadowDance()
	if(Subtletydb.SuggestShadowDance == true) then
		Subtletydb.SuggestShadowDance = false
	else
		Subtletydb.SuggestShadowDance = true
	end
end

function Subtlety:ToggleBackstab()
	if(Subtletydb.SuggestBackstab == true) then
		Subtletydb.SuggestBackstab = false
		Subtlety.L["Generator"] = Subtlety.L["Backstab"]
	else
		Subtletydb.SuggestBackstab = true
		Subtlety.L["Generator"] = Subtlety.L["Hemorrhage"]
	end
end

function Subtlety:ToggleTotT()
	if(Subtletydb.SuggestTotT == true) then
		Subtletydb.SuggestTotT = false
	else
		Subtletydb.SuggestTotT = true
	end
end
