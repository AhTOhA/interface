-------------------------------
-- Vendetta | Created by Hep --
-------------------------------

Vendetta = LibStub("AceAddon-3.0"):NewAddon("Vendetta", "AceConsole-3.0", "AceEvent-3.0")

local options = {
    name = "Vendetta Options",
    handler = Vendetta,
    type = "group",
    args = {
	
			rotationFrame = { 
			type = "group",
			inline = true,
			name = "Rotation",
			desc = "",
			order = 1,
			args = { -- rotationFrame Args Start
			
					backstabFrame = { 
					type = "group",
					inline = true,
					name = "Backstab",
					desc = "",
					order = 1,
					args = {
					
							SuggestBackstab = {
								type = "toggle",
								name = "Suggest Backstab",
								order = 0,
								desc = "Suggest backstab instead of Mutilate if target is bellow 35% health.",
								width = "full",
								get = "GetSuggestBackstab",
								set = "ToggleSuggestBackstab",
							},
						
						},
					},
					
					vanishFrame = { 
					type = "group",
					inline = true,
					name = "Vanish",
					desc = "",
					order = 2,
					args = {
					
							SuggestVanish = {
								type = "toggle",
								name = "Suggest Vanish",
								order = 1,
								desc = "Suggest vanish for overkill buff.",
								width = "full",
								get = "GetSuggestVanish",
								set = "ToggleSuggestVanish",
							},
						
						},
					},
			
					ruptureFrame = { 
					type = "group",
					inline = true,
					name = "Rupture",
					desc = "",
					order = 3,
					args = {
					
							RuptureTimer = {
								type = "range",
								name = "Suggestion Debuff Timer",
								desc = "Suggest Rupture when the targets Rupture debuff time is bellow or the same as the set amount of seconds.",
								order = 2,
								min = 1,
								max = 6,
								step = 1,
								bigStep = 1,
								get = "GetRuptureTimer",
								set = "ToggleRuptureTimer",
							},
						
						},
					},
					
					roationOptionsFrame = { 
					type = "group",
					inline = true,
					name = "Options",
					desc = "",
					order = 4,
					args = {
					
							EnergyOffset = {
								type = "range",
								name = "Energy Offset",
								desc = "Increase to allow time between rotation suggestion and player input.",
								order = 1,
								min = 0,
								max = 10,
								step = 1,
								bigStep = 1,
								get = "GetEnergyOffset",
								set = "ToggleEnergyOffset",
							},
						
						},
					},

				} -- rotationFrame Args Finish
			},
			
			
			cooldownTrackingFrame = { 
			type = "group",
			inline = true,
			name = "Cooldown Tracking",
			desc = "",
			order = 2,
			args = {
			
					TrackToTT = {
						type = "toggle",
						name = "Tricks of the Trade",
						order = 1,
						desc = "Track Tricks of the Trade at the top left corner of Venetta's UI.",
						get = "GetTrackToTT",
						set = "ToggleTrackToTT",
					},
					
					TrackVendetta = {
						type = "toggle",
						name = "Vendetta",
						order = 2,
						desc = "Track Vendetta to the left of Venetta's UI.",
						get = "GetTrackVendetta",
						set = "ToggleTrackVendetta",
					},
					
					TrackColdblood = {
						type = "toggle",
						name = "Coldblood",
						order = 3,
						desc = "Track Coldblood at the bottom left corner of Venetta's UI.",
						get = "GetTrackColdblood",
						set = "ToggleTrackColdblood",
					},
					
					TrackVanish = {
						type = "toggle",
						name = "Vanish",
						order = 4,
						desc = "Track Vanish at the top right corner of Venetta's UI. Vanish will only show when you have no Overkill buff active.",
						get = "GetTrackVanish",
						set = "ToggleTrackVanish",
					},
					
					TrackRacial = {
						type = "toggle",
						name = "Racial",
						order = 5,
						desc = "Track either Blood Elf, Troll or Orc Racial at the bottom right corner of Venetta's UI.",
						get = "GetTrackRacial",
						set = "ToggleTrackRacial",
					},
			
				},
			},
			
			uiFrame = { 
			type = "group",
			inline = true,
			name = "User Interface",
			desc = "",
			order = 3,
			args = {
					
					UILocked = {
						type = "toggle",
						name = "Lock",
						order = 0,
						desc = "Lock Vendetta's UI. This will also cause Vendetta's UI to become transparent.",
						width = "full",
						get = "GetUILocked",
						set = "ToggleUILocked",
					},
				
					UIScale = {
						type = "range",
						name = "UI Scale",
						desc = "Toggle to increase/decrease the scale of Vendetta's UI.",
						order = 1,
						min = 0.5,
						max = 1.5,
						step = 0.1,
						bigStep = 0.1,
						get = "GetUIScale",
						set = "ToggleUIScale",
					},
					
				},
			},
	}
}

local defaults = {
    profile = {
        EnergyOffset = 0,
		RuptureTimer = 2,
        SuggestBackstab = true,
		SuggestVanish = false,
		TrackToTT = true,
		TrackVendetta = true,
		TrackColdblood = true,
		TrackVanish = true,
		TrackRacial = true,
		UILocked = false,
		UIScale = 1,
		x = 0,
		y = 0,
		point = "CENTER",
    },
}



function Vendetta:OnEnable()	
	local _, playerClass = UnitClass("player")
	if playerClass == "ROGUE" then
		self.db = LibStub("AceDB-3.0"):New("VendettaDB", defaults, "Default")

		LibStub("AceConfig-3.0"):RegisterOptionsTable("Vendetta", options)
		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Vendetta", "Vendetta")
		self:RegisterChatCommand("ven", "ChatCommand")
		self:RegisterChatCommand("vendetta", "ChatCommand")
	
		-- Create UI
		self:CreateUI()
		
		-- Load UI Settings
		self.displayFrame:SetScale(self.db.profile.UIScale)
		
		if self.db.profile.UILock then
			self.displayFrame:SetScript("OnMouseDown", nil)
			self.displayFrame:SetScript("OnMouseUp", nil)
			self.displayFrame:SetScript("OnDragStop", nil)
			self.displayFrame:SetBackdropColor(0, 0, 0, 0)
			self.displayFrame:EnableMouse(false)
		else
			self.displayFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
			self.displayFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
			self.displayFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
			self.displayFrame:SetBackdropColor(0, 0, 0, .4)
			self.displayFrame:EnableMouse(true)
		end
		
		self.displayFrame:SetScript("OnUpdate", function(this, elapsed) self:OnUpdate(elapsed) end)
		
		-- Register Events
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
		
	end
end

function Vendetta:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	elseif not input or input:trim() == "help" then
		print("Vendetta Help\nshow - Shows UI\nhide - Hides UI\nlock - Locks UI\nunlock - Unlocks UI")
	elseif not input or input:trim() == "show" then
		self.displayFrame:Show() 
	elseif not input or input:trim() == "hide" then
		self.displayFrame:Hide() 
	elseif not input or input:trim() == "lock" then
		self:ToggleUILocked(nil, true)
	elseif not input or input:trim() == "unlock" then
		self:ToggleUILocked(nil, false)
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(WelcomeHome, "ven", "Vendetta", input)
    end
end

-- Variable Delegates

function Vendetta:GetSuggestBackstab(info)
    return self.db.profile.SuggestBackstab
end

function Vendetta:ToggleSuggestBackstab(info, value)
    self.db.profile.SuggestBackstab = value
end

function Vendetta:GetSuggestVanish(info)
    return self.db.profile.SuggestVanish
end

function Vendetta:ToggleSuggestVanish(info, value)
    self.db.profile.SuggestVanish = value
end

function Vendetta:GetEnergyOffset()
    return self.db.profile.EnergyOffset
end

function Vendetta:ToggleEnergyOffset(info, value)
    self.db.profile.EnergyOffset = value
end

function Vendetta:GetRuptureTimer()
    return self.db.profile.RuptureTimer
end

function Vendetta:ToggleRuptureTimer(info, value)
    self.db.profile.RuptureTimer = value
end

function Vendetta:GetTrackToTT()
    return self.db.profile.TrackToTT
end

function Vendetta:ToggleTrackToTT(info, value)
    self.db.profile.TrackToTT = value
end

function Vendetta:GetTrackVendetta()
    return self.db.profile.TrackVendetta
end

function Vendetta:ToggleTrackVendetta(info, value)
    self.db.profile.TrackVendetta = value
end

function Vendetta:GetTrackColdblood()
    return self.db.profile.TrackColdblood
end

function Vendetta:ToggleTrackColdblood(info, value)
    self.db.profile.TrackColdblood = value
end

function Vendetta:GetTrackVanish()
    return self.db.profile.TrackVanish
end

function Vendetta:ToggleTrackVanish(info, value)
    self.db.profile.TrackVanish = value
end

function Vendetta:GetTrackRacial()
    return self.db.profile.TrackRacial
end

function Vendetta:ToggleTrackRacial(info, value)
    self.db.profile.TrackRacial = value
end

function Vendetta:GetUILocked()
    return self.db.profile.UILock
end

function Vendetta:ToggleUILocked()
    return self.db.profile.UILock
end

function Vendetta:ToggleUILocked(info, value)
    self.db.profile.UILock = value
	if value then
		self.displayFrame:SetScript("OnMouseDown", nil)
		self.displayFrame:SetScript("OnMouseUp", nil)
		self.displayFrame:SetScript("OnDragStop", nil)
		self.displayFrame:SetBackdropColor(0, 0, 0, 0)
		self.displayFrame:EnableMouse(false)
	else
		self.displayFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		self.displayFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
		self.displayFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		self.displayFrame:SetBackdropColor(0, 0, 0, .4)
		self.displayFrame:EnableMouse(true)
	end
end

function Vendetta:GetUIScale()
    return self.db.profile.UIScale
end

function Vendetta:ToggleUIScale(info, value)
    self.db.profile.UIScale = value
	self.displayFrame:SetScale(self.db.profile.UIScale)
end

-- Returns the spell ID from spell name
function Vendetta:GetSpellNameById(spellId)

	if (spellId == nil) then
		return nil
	end
	
	local spellName, rank, _, _, _, _, _, _, _ = GetSpellInfo(spellId)
	return spellName
	
end

-- Create an Array of spells used within Vendetta's rotation algorithm.
Vendetta.Spells = {
	["Garrote"]             = Vendetta:GetSpellNameById(703),
	["Slice and Dice"]      = Vendetta:GetSpellNameById(5171),
	["Vendetta"]   		    = Vendetta:GetSpellNameById(79140),
	["Mutilate"]            = Vendetta:GetSpellNameById(1329),
	["Backstab"]            = Vendetta:GetSpellNameById(53),
	["Envenom"]             = Vendetta:GetSpellNameById(32645),
	["Rupture"]             = Vendetta:GetSpellNameById(1943),
	["Cold Blood"]          = Vendetta:GetSpellNameById(14177),
	["Berserking"] 			= Vendetta:GetSpellNameById(26297),
	["Blood Fury"] 			= Vendetta:GetSpellNameById(33697),
	["Arcane Torrent"] 		= Vendetta:GetSpellNameById(25046),
	["Racial"] 				= Vendetta:GetSpellNameById(nil),
	["Tricks of the Trade"] = Vendetta:GetSpellNameById(57934),
	["Vanish"]              = Vendetta:GetSpellNameById(1856),
	["Overkill"]            = Vendetta:GetSpellNameById(58426),
	["Deadly Poison"]       = Vendetta:GetSpellNameById(43581),
}

function Vendetta:PLAYER_TALENT_UPDATE()

	-- Check Vendetta is a useable spell
	local _, _, _, _, rank = GetTalentInfo(1, 19) 
	if rank == 1 then
		self.displayFrame:Show() 
	else
		self.displayFrame:Hide() 
	end

end


function Vendetta:CreateUI()

	-- Get useable racial
	local usable, nomana = IsUsableSpell("Arcane Torrent");
	if (usable) then
		self.Spells["Racial"] = self.Spells["Arcane Torrent"]
	local usable, nomana = IsUsableSpell("Blood Fury");
	elseif (usable) then
		self.Spells["Racial"] = self.Spells["Blood Fury"]
	local usable, nomana = IsUsableSpell("Berserking");
	elseif (usable) then
		self.Spells["Racial"] = self.Spells["Berserking"]
	end


	local displayFrame = CreateFrame("Frame","VendettaDisplayFrame",UIParent)
	displayFrame:SetFrameStrata("BACKGROUND")
	displayFrame:SetWidth(215)
	displayFrame:SetHeight(105)
	displayFrame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 32,})
	displayFrame:SetBackdropColor(0, 0, 0, .4)
	displayFrame:SetFrameStrata("HIGH")
	displayFrame:SetClampedToScreen(true)
    displayFrame:SetMovable(true)
	displayFrame:ClearAllPoints()
	displayFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	displayFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	displayFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)	
	displayFrame:SetPoint(Vendetta.db.profile.point,Vendetta.db.profile.x,Vendetta.db.profile.y)	
	
	--
	-- Current Spell Frame
	------------
	local displayFrame_current = CreateFrame("Frame", nil, displayFrame) 
	displayFrame_current:SetWidth(65)
	displayFrame_current:SetHeight(65)
	displayFrame_current:SetPoint("CENTER", 0, 0)
	
	-- Create Cooldown Frame
	displayFrame_current.Frame = CreateFrame("Cooldown","$parent_tott_cd", displayFrame_current)
	displayFrame_current.Frame:SetWidth(65)
	displayFrame_current.Frame:SetHeight(65)
	displayFrame_current.Frame:SetPoint("CENTER", 0, 0)

	-- Set Texture
	displayFrame_current.Texture = displayFrame_current:CreateTexture()	
	displayFrame_current.Texture:SetTexture(nil)
	displayFrame_current.Texture:SetAllPoints(displayFrame_current)
	displayFrame_current.Texture:SetAlpha(1)
	------------
	-- End Current Spell Frame
	--
	
	
	
	--
	-- Next Spell Frame
	------------
	local displayFrame_next = CreateFrame("Frame", nil, displayFrame) 
	displayFrame_next:SetWidth(35)
	displayFrame_next:SetHeight(35)
	displayFrame_next:SetPoint("RIGHT", 0, 0)
	
	-- Create Cooldown Frame
	displayFrame_next.Frame = CreateFrame("Cooldown","$parent_tott_cd", displayFrame_next)
	displayFrame_next.Frame:SetWidth(35)
	displayFrame_next.Frame:SetHeight(35)
	displayFrame_next.Frame:SetPoint("CENTER", 0, 0)

	-- Set Texture
	displayFrame_next.Texture = displayFrame_next:CreateTexture()	
	displayFrame_next.Texture:SetTexture(nil)
	displayFrame_next.Texture:SetAllPoints(displayFrame_next)
	displayFrame_next.Texture:SetAlpha(1)
	------------
	-- End Next Spell Frame
	--
	

	
	--
	-- TotT Frame
	------------
	local displayFrame_tott = CreateFrame("Frame", nil, displayFrame) 
	displayFrame_tott:SetWidth(35)
	displayFrame_tott:SetHeight(35)
	displayFrame_tott:SetPoint("TOPLEFT", 0, 0)
	
	-- Create Cooldown Frame
	displayFrame_tott.Frame = CreateFrame("Cooldown","$parent_tott_cd", displayFrame_tott)
	displayFrame_tott.Frame:SetWidth(35)
	displayFrame_tott.Frame:SetHeight(35)
	displayFrame_tott.Frame:SetPoint("CENTER", 0, 0)

	-- Set Texture
	displayFrame_tott.Texture = displayFrame_tott:CreateTexture()	
	displayFrame_tott.Texture:SetTexture(GetSpellTexture(self.Spells["Tricks of the Trade"]))
	displayFrame_tott.Texture:SetAllPoints(displayFrame_tott)
	displayFrame_tott.Texture:SetAlpha(1)
	
	-- Set FontString
	displayFrame_tott.FontString = displayFrame_tott:CreateFontString("cooldown_string", "OVERLAY", "GameFontWhite")
	displayFrame_tott.FontString:SetPoint("CENTER", 0, 0)
	------------
	-- End TotT Frame
	--
	
	
	
	--
	-- Vendetta Frame
	------------
	local displayFrame_vendetta = CreateFrame("Frame", nil, displayFrame) 
	displayFrame_vendetta:SetWidth(35)
	displayFrame_vendetta:SetHeight(35)
	displayFrame_vendetta:SetPoint("LEFT", 0, 0)
	
	-- Create Cooldown Frame
	displayFrame_vendetta.Frame = CreateFrame("Cooldown","$parent_tott_cd", displayFrame_vendetta)
	displayFrame_vendetta.Frame:SetWidth(35)
	displayFrame_vendetta.Frame:SetHeight(35)
	displayFrame_vendetta.Frame:SetPoint("CENTER", 0, 0)

	-- Set Texture
	displayFrame_vendetta.Texture = displayFrame_vendetta:CreateTexture()	
	displayFrame_vendetta.Texture:SetTexture(GetSpellTexture(self.Spells["Vendetta"]))
	displayFrame_vendetta.Texture:SetAllPoints(displayFrame_vendetta)
	displayFrame_vendetta.Texture:SetAlpha(1)
	
	-- Set FontString
	displayFrame_vendetta.FontString = displayFrame_vendetta:CreateFontString("cooldown_string", "OVERLAY", "GameFontWhite")
	displayFrame_vendetta.FontString:SetPoint("CENTER", 0, 0)
	------------
	-- End Vendetta Frame
	--
	
	
	
	--
	-- Cold Blood Frame
	------------
	local displayFrame_cb = CreateFrame("Frame", nil, displayFrame) 
	displayFrame_cb:SetWidth(35)
	displayFrame_cb:SetHeight(35)
	displayFrame_cb:SetPoint("BOTTOMLEFT", 0, 0)
	
	-- Create Cooldown Frame
	displayFrame_cb.Frame = CreateFrame("Cooldown","$parent_tott_cd", displayFrame_cb)
	displayFrame_cb.Frame:SetWidth(35)
	displayFrame_cb.Frame:SetHeight(35)
	displayFrame_cb.Frame:SetPoint("CENTER", 0, 0)

	-- Set Texture
	displayFrame_cb.Texture = displayFrame_cb:CreateTexture()	
	displayFrame_cb.Texture:SetTexture(GetSpellTexture(self.Spells["Cold Blood"]))
	displayFrame_cb.Texture:SetAllPoints(displayFrame_cb)
	displayFrame_cb.Texture:SetAlpha(1)
	
	-- Set FontString
	displayFrame_cb.FontString = displayFrame_cb:CreateFontString("cooldown_string", "OVERLAY", "GameFontWhite")
	displayFrame_cb.FontString:SetPoint("CENTER", 0, 0)
	------------
	-- End Cold Blood Frame
	--

	

	--
	-- Vanish Frame
	------------
	local displayFrame_vanish = CreateFrame("Frame", nil, displayFrame) 
	displayFrame_vanish:SetWidth(35)
	displayFrame_vanish:SetHeight(35)
	displayFrame_vanish:SetPoint("TOPRIGHT", 0, 0)
	
	-- Create Cooldown Frame
	displayFrame_vanish.Frame = CreateFrame("Cooldown","$parent_tott_cd", displayFrame_vanish)
	displayFrame_vanish.Frame:SetWidth(35)
	displayFrame_vanish.Frame:SetHeight(35)
	displayFrame_vanish.Frame:SetPoint("CENTER", 0, 0)

	-- Set Texture
	displayFrame_vanish.Texture = displayFrame_vanish:CreateTexture()	
	displayFrame_vanish.Texture:SetTexture(GetSpellTexture(self.Spells["Vanish"]))
	displayFrame_vanish.Texture:SetAllPoints(displayFrame_vanish)
	displayFrame_vanish.Texture:SetAlpha(1)
	
	-- Set FontString
	displayFrame_vanish.FontString = displayFrame_vanish:CreateFontString("cooldown_string", "OVERLAY", "GameFontWhite")
	displayFrame_vanish.FontString:SetPoint("CENTER", 0, 0)
	------------
	-- End Vanish Frame
	--
	
	
	
	--
	-- Racial Frame
	------------
	local displayFrame_racial = CreateFrame("Frame", nil, displayFrame) 
	displayFrame_racial:SetWidth(35)
	displayFrame_racial:SetHeight(35)
	displayFrame_racial:SetPoint("BOTTOMRIGHT", 0, 0)
	
	-- Create Cooldown Frame
	displayFrame_racial.Frame = CreateFrame("Cooldown","$parent_tott_cd", displayFrame_racial)
	displayFrame_racial.Frame:SetWidth(35)
	displayFrame_racial.Frame:SetHeight(35)
	displayFrame_racial.Frame:SetPoint("CENTER", 0, 0)

	-- Set Texture
	displayFrame_racial.Texture = displayFrame_racial:CreateTexture()	
	if(self.Spells["Racial"] ~= nil) then
		displayFrame_racial.Texture:SetTexture(GetSpellTexture(self.Spells["Racial"]))
	else
		displayFrame_racial.Texture:SetTexture(nil)
	end
	displayFrame_racial.Texture:SetAllPoints(displayFrame_racial)
	displayFrame_racial.Texture:SetAlpha(1)
	
	-- Set FontString
	displayFrame_racial.FontString = displayFrame_racial:CreateFontString("cooldown_string", "OVERLAY", "GameFontWhite")
	displayFrame_racial.FontString:SetPoint("CENTER", 0, 0)
	------------
	-- End Racial Frame
	--
	
	
	self.displayFrame = displayFrame
	self.displayFrame_cb = displayFrame_cb
	self.displayFrame_current = displayFrame_current
	self.displayFrame_next = displayFrame_next
	self.displayFrame_tott =  displayFrame_tott
	self.displayFrame_vendetta =  displayFrame_vendetta
	self.displayFrame_vanish =  displayFrame_vanish
	self.displayFrame_racial =  displayFrame_racial
		
end

function Vendetta:OnUpdate(elapsed)

	local point,_,_,xPos,yPos = self.displayFrame:GetPoint()
	Vendetta.db.profile.x = xPos;
	Vendetta.db.profile.y = yPos;
	Vendetta.db.profile.point = point;
	
	if UnitName("target") == nil or UnitIsFriend("player","target") ~= nil or UnitHealth("target") == 0 or UnitGUID("target") == nil then
		self.displayFrame_cb:Hide()
		self.displayFrame_current:Hide()
		self.displayFrame_next:Hide()
		self.displayFrame_tott:Hide()
		self.displayFrame_vendetta:Hide()
		self.displayFrame_vanish:Hide()
		self.displayFrame_racial:Hide()
	else
		self.displayFrame_cb:Show()
		self.displayFrame_current:Show()
		self.displayFrame_next:Show()
		self.displayFrame_tott:Show()
		self.displayFrame_vendetta:Show()
		self.displayFrame_vanish:Show()
		self.displayFrame_racial:Show()
		self:CalculateRotation()
	end
end

function Vendetta:CalculateRotation()

	local energy = UnitPower("player") + self.db.profile.EnergyOffset
	local cp = GetComboPoints("player")
	
	local murderousIntent = false
	
	if(self.db.profile.SuggestBackstab == true) and (UnitHealth("target") <= UnitHealthMax("target") * 0.35) then
		murderousIntent = true
	end

	local spell = ""
	local nextspell = ""
	
	local garrote = 0
	local slice_and_dice = 0
	local vendetta = 0
	local rupture = 0
	local cold_blood = 0
	local tott = 0
	local deadly_posion_stack_count = 0
	local vanish = 0
	local overkill = 0
	local racial = 0

	--
	-- Garrote
	--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", self.Spells["Garrote"])

	if name ~= nil and isMine == "player" then
		garrote = expirationTime - GetTime()
	end	
	
	--
	-- Slice and Dice
	--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitBuff("player", self.Spells["Slice and Dice"])

	if name ~= nil then
		slice_and_dice = expirationTime - GetTime()
	end
	
	--
	-- Overkill
	--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitBuff("player", self.Spells["Overkill"])

	if name ~= nil then
		overkill = expirationTime - GetTime()
	end
		
	--
	-- Ruture
	--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", self.Spells["Rupture"])

	if name ~= nil and isMine == "player" then
		rupture = expirationTime - GetTime()
	end	

	--
	-- Deadly Poison
	--
	local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("target", self.Spells["Deadly Poison"])
	if name ~= nil and isMine == "player" then
		deadly_posion_stack_count = count
	end
	
	--
	-- Vendetta
	--
	local start, duration, enabled = GetSpellCooldown(self.Spells["Vendetta"])

	if duration ~= nil then
		vendetta = duration + start - GetTime()
	else
		vendetta = 60
	end	

	--
	-- Cold Blood
	--
	local start, duration, enabled = GetSpellCooldown(self.Spells["Cold Blood"]);
	
	if duration ~= nil then 
		cold_blood = duration + start - GetTime()
	else
		cold_blood = 60
	end	
	
	--
	-- Tricks of the Trade
	--
	local start, duration, enabled = GetSpellCooldown(self.Spells["Tricks of the Trade"]);
	
	if duration ~= nil then 
		tott = duration + start - GetTime()
	else
		tott = 60
	end	
	
	--
	-- Vanish
	--
	local start, duration, enabled = GetSpellCooldown(self.Spells["Vanish"]);
	if duration ~= nil then 
		vanish = duration + start - GetTime()
	else
		vanish = 60
	end	
			
	--
	-- Racial
	--
	
	if self.Spells["Racial"] ~= nil then
	
		local start, duration, enabled = GetSpellCooldown(self.Spells["Racial"]);
		if duration ~= nil then 
			racial = duration + start - GetTime()
		else
			racial = 60
		end	
		
	end
	
	
	
	-- Rotation suggestion algorithm...
	
	
	-- Stealth active
	if UnitAura("player", "Stealth") ~= nil then
		
		-- Open with Garrote
		if (energy >= 50) then
			spell = self.Spells["Garrote"]
		else
			nextspell = self.Spells["Garrote"];
		end
		
		
	-- Slice and Dice 
	elseif (cp >= 1) and (slice_and_dice == 0.0) then
	
		-- Check required energy
		if (energy >= 25) then
			spell = self.Spells["Slice and Dice"];
		else
			nextspell = self.Spells["Slice and Dice"];
		end
		
	
	-- Suggest Vanish in rotation if enabled
	elseif (slice_and_dice ~= 0.0)  and (vanish < 1) and (overkill == 0) and (self.db.profile.SuggestVanish) then
		
		
		spell = self.Spells["Vanish"];
		
		
	-- Finish to refresh Slice and Dice if low on timer
	elseif (cp >= 1) and (deadly_posion_stack_count >= 1) and (slice_and_dice <= 5.0) then
	
	    -- Check required energy
		if (energy >= 35) then
			spell = self.Spells["Envenom"];
		else
			nextspell = self.Spells["Envenom"];
		end
				
		
	-- Rupture if low on timer (MI)
	elseif (murderousIntent == true) and (rupture <= self.db.profile.RuptureTimer) and (cp >= 5) then 
	
	-- Queue if not quite finished, check required energy
		if (energy >= 25) then	
			spell = self.Spells["Rupture"];
		else
			nextspell = self.Spells["Rupture"];
		end
		
				
	-- Rupture if low on timer
	elseif (murderousIntent == false) and (rupture <= self.db.profile.RuptureTimer) and (cp >= 4) then 
	
		-- Queue if not quite finished, check required energy
		if (energy >= 25) then	
			spell = self.Spells["Rupture"];
		else
			nextspell = self.Spells["Rupture"];
		end
		
		
	-- Suggest Envenom (MI)
	elseif (murderousIntent == true) and (deadly_posion_stack_count == 5) and (cp >= 5) then
	
		-- Check required energy
		if (energy >= 35) then
			spell = self.Spells["Envenom"];
		else
			nextspell = self.Spells["Envenom"];
		end
		
	
	-- Suggest Envenom
	elseif (murderousIntent == false) and (deadly_posion_stack_count == 5) and (cp >= 4) then
	
		-- Check required energy
		if (energy >= 35) then
			spell = self.Spells["Envenom"];
		else
			nextspell = self.Spells["Envenom"];
		end

		
	-- Meh
	else
		if(murderousIntent) then
			
			if (energy >= 60) then
				-- Suggest Backstab
				spell = self.Spells["Backstab"];
			else
				-- Queue Backstab
				nextspell = self.Spells["Backstab"];
			end
		
		else
		
			if (energy >= 55) then
				-- Suggest Mutilate
				spell = self.Spells["Mutilate"];
			else
				-- Queue Backstab
				nextspell = self.Spells["Mutilate"];
			end	
			
		end
	end
	
	
	self.displayFrame_current.Texture:SetTexture(GetSpellTexture(spell))
	self.displayFrame_next.Texture:SetTexture(GetSpellTexture(nextspell))
	

	-- Tricks of the Trade off cooldown
	if (tott < 1) and (self.db.profile.TrackToTT) then
		self.displayFrame_tott:Show()
		self.displayFrame_tott.FontString:SetText("")
		self.displayFrame_tott.Texture:SetAlpha(1)
	elseif(self.db.profile.TrackToTT == false) then
		self.displayFrame_tott:Hide()
	else
		self.displayFrame_tott.FontString:SetText(string.format("%.0f", tott))
		self.displayFrame_tott.Texture:SetAlpha(0.3)
	end
	
	-- Vendetta off cooldown
	if (vendetta < 1) and (self.db.profile.TrackVendetta) then
		self.displayFrame_vendetta:Show()
		self.displayFrame_vendetta.FontString:SetText("")
		self.displayFrame_vendetta.Texture:SetAlpha(1)
	elseif(self.db.profile.TrackVendetta == false) then
		self.displayFrame_vendetta:Hide()
	else
		self.displayFrame_vendetta.FontString:SetText(string.format("%.0f", vendetta))
		self.displayFrame_vendetta.Texture:SetAlpha(0.3)
	end
	
	-- Coldblood off cooldown
	if (cold_blood < 1) and (self.db.profile.TrackColdblood) then
		self.displayFrame_cb:Show()
		self.displayFrame_cb.FontString:SetText("")
		self.displayFrame_cb.Texture:SetAlpha(1)
	elseif(self.db.profile.TrackColdblood == false) then
		self.displayFrame_cb:Hide()
	else
		self.displayFrame_cb.FontString:SetText(string.format("%.0f", cold_blood))
		self.displayFrame_cb.Texture:SetAlpha(0.3)
	end
		
	-- Vanish off cooldown
	if (vanish > 1) and (self.db.profile.TrackVanish) then -- Vanish on CD
		self.displayFrame_vanish.FontString:SetText(string.format("%.0f", vanish))
		self.displayFrame_vanish.Texture:SetAlpha(0.3)
	elseif(self.db.profile.TrackVanish == false) or (overkill ~= 0) then -- Not enabled, or overkill buff
		self.displayFrame_vanish:Hide()
	elseif (vanish < 1) and (overkill == 0)  and (self.db.profile.TrackVanish) then -- Vanish not on CD, no overkill buff
		self.displayFrame_vanish:Show()
		self.displayFrame_vanish.FontString:SetText("")
		self.displayFrame_vanish.Texture:SetAlpha(1)
	end
	
	-- Racial off cooldown
	if (self.Spells["Racial"] ~= nil) and (racial < 1) and (self.db.profile.TrackRacial) then
		self.displayFrame_racial:Show()
		self.displayFrame_racial.FontString:SetText("")
		self.displayFrame_racial.Texture:SetAlpha(1)
	elseif(self.db.profile.TrackRacial == false) then
		self.displayFrame_racial:Hide()
	else
		self.displayFrame_racial.FontString:SetText(string.format("%.0f", racial))
		self.displayFrame_racial.Texture:SetAlpha(0.3)
	end
		
	if (spell ~= "") and (spell ~= nil) then
		local start, dur = GetSpellCooldown(spell)
		if dur ~= 0 or start ~= nil or dur ~= nil then
		
			-- Display global cooldowns
			
			self.displayFrame_current.Frame:SetCooldown(start, dur)
			
			if(vendetta < 1) then
				self.displayFrame_vendetta.Frame:SetCooldown(start, dur)
			end
			
			if(tott < 1) then
				self.displayFrame_tott.Frame:SetCooldown(start, dur)
			end
			
			-- Doesn't display anything as of yet, may be used in future with better queueing algorithm
			if(nextspell ~= "") and (nextspell ~= nil) then
				self.displayFrame_next.Frame:SetCooldown(start, dur)
			end

		end
	end
end