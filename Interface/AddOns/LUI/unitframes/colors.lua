--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: colors.lua
	Description: oUF Colors Module
	Version....: 1.0
	Rev Date...: 10/10/2010
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local module = LUI:NewModule("oUF_Colors")

local db

local _, class = UnitClass("player")

local defaults = {
	Colors = {
		Class = {
			WARRIOR = {1, 0.78, 0.55},
			PRIEST = {0.9, 0.9, 0.9},
			DRUID = {1, 0.44, 0.15},
			HUNTER = {0.22, 0.91, 0.18},
			MAGE = {0.12, 0.58, 0.89},
			PALADIN = {0.96, 0.21, 0.73},
			SHAMAN = {0.04, 0.39, 0.98},
			WARLOCK = {0.57, 0.22, 1},
			ROGUE = {0.95, 0.86, 0.16},
			DEATHKNIGHT = {0.8, 0.1, 0.1},
		},
		Power = {
			MANA = {0.31, 0.45, 0.63},
			RAGE = {0.69, 0.31, 0.31},
			FOCUS = {0.71, 0.43, 0.27},
			ENERGY = {0.65, 0.63, 0.35},
			RUNES = {0.55, 0.57, 0.61},
			RUNIC_POWER = {0, 0.82, 1},
			AMMOSLOT = {0.8, 0.6, 0},
			FUEL = {0, 0.55, 0.5},
		},
		HolyPowerBar = {
			[1] = {0.90, 0.88, 0.06},
			[2] = {0.90, 0.88, 0.06},
			[3] = {0.90, 0.88, 0.06},
		},
		SoulShardBar = {
			[1] = {0.93, 0.93, 0.93},
			[2] = {0.93, 0.93, 0.93},
			[3] = {0.93, 0.93, 0.93},
		},
		EclipseBar = {
			Lunar = {0.3, 0.52, 0.9},
			Solar = {0.8, 0.82, 0.6},
			LunarBG = {0.15, 0.26, 0.45},
			SolarBG = {0.36, 0.36, 0.27},
		},
		Runes = {
			[1] = {0.69, 0.31, 0.31}, -- Blood Rune
			[2] = {0.33, 0.59, 0.33}, -- Unholy Rune
			[3] = {0.31, 0.45, 0.63}, -- Frost Rune
			[4] = {0.84, 0.75, 0.65}, -- Death Rune
		},
		Happiness = {
			[1] = {0.8, 0.05, 0.05}, -- Unhappy
			[2] = {0.85, 0.80, 0.30}, -- Normal
			[3] = {0.05, 0.95, 0.05}, -- Happy
		},
		Tapped = {0.55, 0.57, 0.61},
		Smooth = {
			0.69, 0.31, 0.31, -- Low Health
			0.69, 0.69, 0.31, -- Mid Health
			0.31, 0.69, 0.31, -- High Health
		},
		ComboPoints = {
			[1] = {0.95, 0.86, 0.16},
			[2] = {0.95, 0.86, 0.16},
			[3] = {0.95, 0.86, 0.16},
			[4] = {0.95, 0.86, 0.16},
			[5] = {0.95, 0.86, 0.16},
		},
		LevelDiff = {
			[1] = {0.69, 0.31, 0.31}, -- Target Level >= 5
			[2] = {0.71, 0.43, 0.27}, -- Target Level >= 3
			[3] = {0.84, 0.75, 0.65}, -- Target Level <> 2
			[4] = {0.33, 0.59, 0.33}, -- Target Level GreenQuestRange
			[5] = {0.55, 0.57, 0.61}, -- Low Level Target
		},
		TotemBar = {
			[1] = {0.752, 0.172, 0.02}, -- Fire
			[2] = {0.741, 0.580, 0.04}, -- Earth
			[3] = {0, 0.443, 0.631}, -- Water
			[4] = {0.6, 1.0, 0.945}, -- Air
		},
		CombatText = {
			DAMAGE = {0.69, 0.31, 0.31},
			CRUSHING = {0.69, 0.31, 0.31},
			CRITICAL = {0.69, 0.31, 0.31},
			GLANCING = {0.69, 0.31, 0.31},
			STANDARD = {0.84, 0.75, 0.65},
			IMMUNE = {0.84, 0.75, 0.65},
			ABSORB = {0.84, 0.75, 0.65},
			BLOCK = {0.84, 0.75, 0.65},
			RESIST = {0.84, 0.75, 0.65},
			MISS = {0.84, 0.75, 0.65},
			HEAL = {0.33, 0.59, 0.33},
			CRITHEAL = {0.33, 0.59, 0.33},
			ENERGIZE = {0.31, 0.45, 0.63},
			CRITENERGIZE = {0.31, 0.45, 0.63},
		},
	},
}

function module:UpdateColors()
	oUF.colors.smooth = oUF_LUI.colors.smooth or oUF.colors.smooth
	if oUF_LUI_target.CPoints then
		for i=1, 5 do
			oUF_LUI_target.CPoints[i]:SetStatusBarColor(unpack(oUF_LUI.colors.combopoints[i]))
			if db.oUF.Target.ComboPoints.BackgroundColor.Enable == false then
				local mu = db.oUF.Target.ComboPoints.Multiplier
				local r, g, b = unpack(oUF_LUI.colors.combopoints[i])
				oUF_LUI_target.CPoints[i].bg:SetVertexColor(r*mu, g*mu, b*mu)
			end
		end
	end
	if oUF_LUI_player.HolyPower then
		for i=1, 3 do
			oUF_LUI_player.HolyPower[i]:SetStatusBarColor(unpack(oUF_LUI.colors.holypowerbar[i]))
		end
	end
	if oUF_LUI_player.SoulShards then
		for i=1, 3 do
			oUF_LUI_player.SoulShards[i]:SetStatusBarColor(unpack(oUF_LUI.colors.soulshardbar[i]))
		end
	end
	for k, obj in pairs(oUF.objects) do
		obj:UpdateAllElements()
	end
end

function module:LoadOptions()
	local options = {
		Colors = {
			name = "Colors",
			type = "group",
			childGroups = "tab",
			disabled = function() return not db.oUF.Settings.Enable end,
			order = 2,
			args = {
				ClassColors = {
					name = "Class",
					type = "group",
					order = 1,
					args = {
						header1 = {
							name = "Class Colors",
							type = "header",
							order = 1,
						},
						Warrior = {
							name = "Warrior",
							desc = "Choose an individual Color for Warriors.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Class.WARRIOR) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Class.WARRIOR = {r,g,b}
								module:UpdateColors()
							end,
							order = 2,
						},
						Priest = {
							name = "Priest",
							desc = "Choose an individual Color for Priests.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Class.PRIEST) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Class.PRIEST = {r,g,b}
								module:UpdateColors()
							end,
							order = 3,
						},
						Druid = {
							name = "Druid",
							desc = "Choose an individual Color for Druids.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Class.DRUID) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Class.DRUID = {r,g,b}
								module:UpdateColors()
							end,
							order = 4,
						},
						Hunter = {
							name = "Hunter",
							desc = "Choose an individual Color for Hunters.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Class.HUNTER) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Class.HUNTER = {r,g,b}
								module:UpdateColors()
							end,
							order = 5,
						},
						Mage = {
							name = "Mage",
							desc = "Choose an individual Color for Mages.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Class.MAGE) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Class.MAGE = {r,g,b}
								module:UpdateColors()
							end,
							order = 6,
						},
						Paladin = {
							name = "Paladin",
							desc = "Choose an individual Color for Paladins.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Class.PALADIN) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Class.PALADIN = {r,g,b}
								module:UpdateColors()
							end,
							order = 7,
						},
						Shaman = {
							name = "Shaman",
							desc = "Choose an individual Color for Shamans.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Class.SHAMAN) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Class.SHAMAN = {r,g,b}
								module:UpdateColors()
							end,
							order = 8,
						},
						Warlock = {
							name = "Warlock",
							desc = "Choose an individual Color for Warlocks.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Class.WARLOCK) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Class.WARLOCK = {r,g,b}
								module:UpdateColors()
							end,
							order = 9,
						},
						Rogue = {
							name = "Rogue",
							desc = "Choose an individual Color for Rogues.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Class.ROGUE) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Class.ROGUE = {r,g,b}
								module:UpdateColors()
							end,
							order = 10,
						},
						DeathKnight = {
							name = "Death Knight",
							desc = "Choose an individual Color for Death Knights.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Class.DEATHKNIGHT) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Class.DEATHKNIGHT = {r,g,b}
								module:UpdateColors()
							end,
							order = 11,
						},
						empty = {
							name = "   ",
							type = "description",
							order = 12,
							width = "full",
						},
						Reset = {
							order = 13,
							type = "execute",
							name = "Restore Defaults",
							func = function()
								db.oUF.Colors.Class = LUI.defaults.profile.oUF.Colors.Class
								module:UpdateColors()
							end,
						},
					},
				},
				PowerType = {
					name = "Power",
					type = "group",
					order = 2,
					args = {
						header1 = {
							name = "Power Colors",
							type = "header",
							order = 1,
						},
						Mana = {
							name = "Mana",
							desc = "Choose an individual Color for Mana.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Power.MANA) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Power.MANA = {r,g,b}
								module:UpdateColors()
							end,
							order = 2,
						},
						Rage = {
							name = "Rage",
							desc = "Choose an individual Color for Rage.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Power.RAGE) end,
							set = function(_,r,g,b) 
								db.oUF.Colors.Power.RAGE = {r,g,b}
								module:UpdateColors()
							end,
							order = 3,
						},
						Focus = {
							name = "Focus",
							desc = "Choose an individual Color for Focus.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Power.FOCUS) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Power.FOCUS = {r,g,b}
								module:UpdateColors()
							end,
							order = 4,
						},
						Energy = {
							name = "Energy",
							desc = "Choose an individual Color for Energy.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Power.ENERGY) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Power.ENERGY = {r,g,b}
								module:UpdateColors()
							end,
							order = 5,
						},
						Runes = {
							name = "Runes",
							desc = "Choose an individual Color for Runes.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Power.RUNES) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Power.RUNES = {r,g,b}
								module:UpdateColors()
							end,
							order = 6,
						},
						RunicPower = {
							name = "Runic Power",
							desc = "Choose an individual Color for Runic Power.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Power.RUNIC_POWER) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Power.RUNIC_POWER = {r,g,b}
								module:UpdateColors()
							end,
							order = 7,
						},
						AmmoSlot = {
							name = "Ammo Slot",
							desc = "Choose an individual Color for Ammo Slot.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Power.AMMOSLOT) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Power.AMMOSLOT = {r,g,b}
								module:UpdateColors()
							end,
							order = 8,
						},
						Fuel = {
							name = "Fuel",
							desc = "Choose an individual Color for Fuel.",
							type = "color",
							hasAlpha = false,
							get = function() return unpack(db.oUF.Colors.Power.FUEL) end,
							set = function(_,r,g,b)
								db.oUF.Colors.Power.FUEL = {r,g,b}
								module:UpdateColors()
							end,
							order = 9,
						},
						empty = {
							name = "   ",
							type = "description",
							order = 10,
							width = "full",
						},
						Reset = {
							order = 11,
							type = "execute",
							name = "Restore Defaults",
							func = function()
								db.oUF.Colors.Power = LUI.defaults.profile.oUF.Colors.Power
								module:UpdateColors()
							end,
						},
					},
				},
				HealthGradient = {
					name = "Health Gradient",
					type = "group",
					order = 3,
					args = {
						header1 = {
							name = "Health Gradient Colors",
							type = "header",
							order = 1,
						},
						EmptyHP = {
							name = "Empty (Bad!)",
							desc = "Choose an individual Color for Empty HP.",
							type = "color",
							width = "full",
							hasAlpha = false,
							get = function()
								local r,g,b = select(1, unpack(db.oUF.Colors.Smooth))
								return r,g,b
							end,
							set = function(_,r,g,b)
								local r1,g1,b1,r2,g2,b2,r3,g3,b3 = unpack(db.oUF.Colors.Smooth)
								db.oUF.Colors.Smooth = {r,g,b,r2,g2,b2,r3,g3,b3}
								module:UpdateColors()
							end,
							order = 2,
						},
						OKHP = {
							name = "Half (OK!)",
							desc = "Choose an individual Color for Half HP.",
							type = "color",
							width = "full",
							hasAlpha = false,
							get = function()
								local r,g,b = select(4, unpack(db.oUF.Colors.Smooth))
								return r,g,b
							end,
							set = function(_,r,g,b)
								local r1,g1,b1,r2,g2,b2,r3,g3,b3 = unpack(db.oUF.Colors.Smooth)
								db.oUF.Colors.Smooth = {r1,g1,b1,r,g,b,r3,g3,b3}
								module:UpdateColors()
							end,
							order = 3,
						},
						FullHP = {
							name = "Full (Good!)",
							desc = "Choose an individual Color for Full HP.",
							type = "color",
							width = "full",
							hasAlpha = false,
							get = function()
								local r,g,b = select(7, unpack(db.oUF.Colors.Smooth))
								return r,g,b
							end,
							set = function(_,r,g,b)
								local r1,g1,b1,r2,g2,b2,r3,g3,b3 = unpack(db.oUF.Colors.Smooth)
								db.oUF.Colors.Smooth = {r1,g1,b1,r2,g2,b2,r,g,b}
								module:UpdateColors()
							end,
							order = 4,
						},
						empty = {
							name = "   ",
							type = "description",
							order = 5,
							width = "full",
						},
						Reset = {
							order = 6,
							type = "execute",
							name = "Restore Defaults",
							func = function()
								db.oUF.Colors.Smooth = LUI.defaults.profile.oUF.Colors.Smooth
								module:UpdateColors()
							end,
						},
					},
				},
				CombatText = {
					name = "CombatText",
					type = "group",
					order = 4,
					args = {
						Damage = {
							name = "Damage",
							type = "group",
							inline = true,
							order = 1,
							args = {
								Damage = {
									name = "Normal",
									desc = "Choose a color for normal damage events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.DAMAGE) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.DAMAGE = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								Crit = {
									name = "Crit",
									desc = "Choose a color for critical damage events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.CRITICAL) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.CRITICAL = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
								Crushing = {
									name = "Crushing",
									desc = "Choose a color for crushing damage events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.CRUSHING) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.CRUSHING = {r,g,b}
										module:UpdateColors()
									end,
									order = 3,
								},
								Glancing = {
									name = "Glancing",
									desc = "Choose a color for glancing damage events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.GLANCING) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.GLANCING = {r,g,b}
										module:UpdateColors()
									end,
									order = 4,
								},
								Absorb = {
									name = "Absorb",
									desc = "Choose a color for absorb events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.ABSORB) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.ABSORB = {r,g,b}
										module:UpdateColors()
									end,
									order = 5,
								},
								Block = {
									name = "Block",
									desc = "Choose a color for block events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.BLOCK) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.BLOCK = {r,g,b}
										module:UpdateColors()
									end,
									order = 6,
								},
								Resist = {
									name = "Resist",
									desc = "Choose a color for resist events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.RESIST) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.RESIST = {r,g,b}
										module:UpdateColors()
									end,
									order = 7,
								},
								Miss = {
									name = "Miss",
									desc = "Choose a color for miss events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.MISS) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.MISS = {r,g,b}
										module:UpdateColors()
									end,
									order = 8,
								},
							},
						},
						Heal = {
							name = "Heal",
							type = "group",
							inline = true,
							order = 2,
							args = {
								Heal = {
									name = "Normal",
									desc = "Choose a color for normal heal events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.HEAL) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.HEAL = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								Crit = {
									name = "Crit",
									desc = "Choose a color for crittical heal events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.CRITHEAL) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.CRITHEAL = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
							},
						},
						Other = {
							name = "Other",
							type = "group",
							inline = true,
							order = 3,
							args = {
								Immune = {
									name = "Immune",
									desc = "Choose a color for immune events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.IMMUNE) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.IMMUNE = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								Energize = {
									name = "Other",
									desc = "Choose a color for normal energize events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.ENERGIZE) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.ENERGIZE = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
								CritEnergize = {
									name = "Crit Energize",
									desc = "Choose a color for critical energize events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.CRITENERGIZE) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.CRITENERGIZE = {r,g,b}
										module:UpdateColors()
									end,
									order = 3,
								},
								Other = {
									name = "Other",
									desc = "Choose a color for other events.",
									type = "color",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.CombatText.STANDARD) end,
									set = function(_,r,g,b)
										db.oUF.Colors.CombatText.STANDARD = {r,g,b}
										module:UpdateColors()
									end,
									order = 4,
								},
							},
						},
						empty = {
							name = "   ",
							type = "description",
							width = "full",
							order = 4,
						},
						Reset = {
							name = "Restore Defaults",
							type = "execute",
							order = 5,
							func = function()
								db.oUF.Colors.CombatText = LUI.defaults.profile.oUF.Colors.CombatText
								module:UpdateColors()
							end,
						},
					},
				},
				Other = {
					name = "Other",
					type = "group",
					order = 5,
					args = {
						Happiness = {
							name = "Happiness Colors",
							type = "group",
							inline = true,
							hidden = class ~= "HUNTER",
							order = 1,
							args = {
								Happy = {
									name = "Happy",
									desc = "Choose an individual Color for Happy.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.Happiness[3]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.Happiness[3] = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								Normal = {
									name = "Normal",
									desc = "Choose an individual Color for Normal.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.Happiness[2]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.Happiness[2] = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
								Unhappy = {
									name = "Unhappy",
									desc = "Choose an individual Color for Unhappy.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.Happiness[1]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.Happiness[1] = {r,g,b}
										module:UpdateColors()
									end,
									order = 3,
								},
							},
						},
						Runes = {
							name = "Rune Colors",
							type = "group",
							inline = true,
							hidden = class ~= "DEATHKNIGHT",
							order = 2,
							args = {
								Blood = {
									name = "Blood",
									desc = "Choose an individual Color for Blood.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.Runes[1]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.Runes[1] = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								Frost = {
									name = "Frost",
									desc = "Choose an individual Color for Frost.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.Runes[3]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.Runes[3] = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
								Unholy = {
									name = "Unholy",
									desc = "Choose an individual Color for Unholy.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.Runes[2]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.Runes[2] = {r,g,b}
										module:UpdateColors()
									end,
									order = 3,
								},
								Death = {
									name = "Death",
									desc = "Choose an individual Color for Death.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.Runes[4]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.Runes[4] = {r,g,b}
										module:UpdateColors()
									end,
									order = 4,
								},
							},
						},
						ComboPoints = {
							name = "ComboPoint Colors",
							type = "group",
							inline = true,
							order = 3,
							args = {
								Combo1 = {
									name = "CP 1",
									desc = "Choose an individual Color for your 1st ComboPoint.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.ComboPoints[1]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.ComboPoints[1] = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								Combo2 = {
									name = "CP 2",
									desc = "Choose an individual Color for your 2nd ComboPoint.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.ComboPoints[2]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.ComboPoints[2] = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
								Combo3 = {
									name = "CP 3",
									desc = "Choose an individual Color for your 3rd ComboPoint.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.ComboPoints[3]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.ComboPoints[3] = {r,g,b}
										module:UpdateColors()
									end,
									order = 3,
								},
								Combo4 = {
									name = "CP 4",
									desc = "Choose an individual Color for your 4rd ComboPoint.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.ComboPoints[4]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.ComboPoints[4] = {r,g,b}
										module:UpdateColors()
									end,
									order = 4,
								},
								Combo5 = {
									name = "CP 5",
									desc = "Choose an individual Color for your 5th ComboPoint.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.ComboPoints[5]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.ComboPoints[5] = {r,g,b}
										module:UpdateColors()
									end,
									order = 5,
								},
							},
						},
						Totems = {
							name = "TotemBar Colors",
							type = "group",
							inline = true,
							hidden = class ~= "SHAMAN",
							order = 4,
							args = {
								TotemFire = {
									name = "Fire",
									desc = "Choose an individual Color for your Fire Totems.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.TotemBar[1]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.TotemBar[1] = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								TotemEarth = {
									name = "Earth",
									desc = "Choose an individual Color for your Earth Totems.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.TotemBar[2]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.TotemBar[2] = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
								TotemWater = {
									name = "Water",
									desc = "Choose an individual Color for your Water Totems.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.TotemBar[3]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.TotemBar[3] = {r,g,b}
										module:UpdateColors()
									end,
									order = 3,
								},
								TotemAir = {
									name = "Air",
									desc = "Choose an individual Color for your Air Totems.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.TotemBar[4]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.TotemBar[4] = {r,g,b}
										module:UpdateColors()
									end,
									order = 4,
								},
							},
						},
						LevelDiff = {
							name = "Level Difficulty Colors",
							type = "group",
							inline = true,
							order = 5,
							args = {
								LevelDiff1 = {
									name = "Target Level >= 5",
									desc = "Color for when your Target's Level is 5 or more Levels higher than yours.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.LevelDiff[1]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.LevelDiff[1] = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								LevelDiff2 = {
									name = "Target Level >= 3",
									desc = "Color for when your Target's Level is 3 - 4 Levels higher than yours.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.LevelDiff[2]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.LevelDiff[2] = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
								LevelDiff3 = {
									name = "Target Level <> 2",
									desc = "Color for when your Target's Level is within 2 Levels of yours.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.LevelDiff[3]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.LevelDiff[3] = {r,g,b}
										module:UpdateColors()
									end,
									order = 3,
								},
								LevelDiff4 = {
									name = "Target Level is in Green QuestRange",
									desc = "Color for when your Target's Level is in Green QuestRange.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.LevelDiff[4]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.LevelDiff[4] = {r,g,b}
										module:UpdateColors()
									end,
									order = 4,
								},
								LevelDiff5 = {
									name = "Low Level Target",
									desc = "Color for when your Target's Level is well below yours.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.LevelDiff[5]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.LevelDiff[5] = {r,g,b}
										module:UpdateColors()
									end,
									order = 5,
								},
							},
						},
						Tapped = {
							name = "Tapped Target Colors",
							type = "group",
							inline = true,
							order = 6,
							args = {
								Tapped = {
									name = "Tapped",
									desc = "Choose an individual Color for Tapped Mobs.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.Tapped) end,
									set = function(_,r,g,b)
										db.oUF.Colors.Tapped = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
							},
						},
						HolyPower = {
							name = "Holy Power Colors",
							type = "group",
							inline = true,
							hidden = class ~= "PALADIN",
							order = 7,
							args = {
								HolyPower1 = {
									name = "Part 1",
									desc = "Choose any color for the first part of your Holy Power Bar.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.HolyPowerBar[1]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.HolyPowerBar[1] = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								HolyPower2 = {
									name = "Part 2",
									desc = "Choose any color for the second part of your Holy Power Bar.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.HolyPowerBar[2]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.HolyPowerBar[2] = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
								HolyPower3 = {
									name = "Part 3",
									desc = "Choose any color for the third part of your Holy Power Bar.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.HolyPowerBar[3]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.HolyPowerBar[3] = {r,g,b}
										module:UpdateColors()
									end,
									order = 3,
								},
							},
						},
						SoulShards = {
							name = "Soul Shards",
							type = "group",
							inline = true,
							hidden = class ~= "WARLOCK",
							order = 8,
							args = {
								SoulShard1 = {
									name = "Shard 1",
									desc = "Choose any color for the first Part of your Sould Shard Bar.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.SoulShardBar[1]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.SoulShardBar[1] = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								SoulShard2 = {
									name = "Shard 2",
									desc = "Choose any color for the second Part of your Sould Shard Bar.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.SoulShardBar[2]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.SoulShardBar[2] = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
								SoulShard3 = {
									name = "Shard 3",
									desc = "Choose any color for the third Part of your Sould Shard Bar.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.SoulShardBar[3]) end,
									set = function(_,r,g,b)
										db.oUF.Colors.SoulShardBar[3] = {r,g,b}
										module:UpdateColors()
									end,
									order = 3,
								},
							},
						},
						Eclipse = {
							name = "Eclipse",
							type = "group",
							inline = true,
							hidden = class ~= "DRUID",
							order = 9,
							args = {
								EclipseLunar = {
									name = "Lunar",
									desc = "Choose any color for the Lunar Part of your Eclipse Bar.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.EclipseBar.Lunar) end,
									set = function(_,r,g,b)
										db.oUF.Colors.EclipseBar.Lunar = {r,g,b}
										module:UpdateColors()
									end,
									order = 1,
								},
								EclipseLunarBG = {
									name = "Lunar BG",
									desc = "Choose any background color for the Lunar Part of your Eclipse Bar.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.EclipseBar.LunarBG) end,
									set = function(_,r,g,b)
										db.oUF.Colors.EclipseBar.LunarBG = {r,g,b}
										module:UpdateColors()
									end,
									order = 2,
								},
								EclipseSolar = {
									name = "Solar",
									desc = "Choose any color for the Solar Part of your Eclipse Bar.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.EclipseBar.Solar) end,
									set = function(_,r,g,b)
										db.oUF.Colors.EclipseBar.Solar = {r,g,b}
										module:UpdateColors()
									end,
									order = 3,
								},
								EclipseSolarBG = {
									name = "Solar BG",
									desc = "Choose any background color for the Solar Part of your Eclipse Bar.",
									type = "color",
									width = "full",
									hasAlpha = false,
									get = function() return unpack(db.oUF.Colors.EclipseBar.SolarBG) end,
									set = function(_,r,g,b)
										db.oUF.Colors.EclipseBar.SolarBG = {r,g,b}
										module:UpdateColors()
									end,
									order = 4,
								},
							},
						},
						empty = {
							name = "   ",
							type = "description",
							width = "full",
							order = 10,
						},
						Reset = {
							name = "Restore Defaults",
							type = "execute",
							order = 11,
							func = function()
								db.oUF.Colors.Happiness = LUI.defaults.profile.oUF.Colors.Happiness
								db.oUF.Colors.Runes = LUI.defaults.profile.oUF.Colors.Runes
								db.oUF.Colors.ComboPoints = LUI.defaults.profile.oUF.Colors.ComboPoints
								db.oUF.Colors.TotemBar = LUI.defaults.profile.oUF.Colors.TotemBar
								db.oUF.Colors.LevelDiff = LUI.defaults.profile.oUF.Colors.LevelDiff
								db.oUF.Colors.Tapped = LUI.defaults.profile.oUF.Colors.Tapped
								db.oUF.Colors.HolyPowerBar = LUI.defaults.profile.oUF.Colors.HolyPowerBar
								db.oUF.Colors.SoulShardBar = LUI.defaults.profile.oUF.Colors.SoulShardBar
								db.oUF.Colors.EclipseBar = LUI.defaults.profile.oUF.Colors.EclipseBar
								module:UpdateColors()
							end,
						},
					},
				},
			},
		},
	}
	
	return options
end

function module:OnInitialize()
	LUI:MergeDefaults(LUI.db.defaults.profile.oUF, defaults)
	LUI:RefreshDefaults()
	LUI:Refresh()
	
	self.db = LUI.db.profile
	db = self.db
	
	LUI:RegisterUnitFrame(self)
end