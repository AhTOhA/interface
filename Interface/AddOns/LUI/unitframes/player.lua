--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: player.lua
	Description: oUF Player Module
	Version....: 1.0
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local module = LUI:NewModule("oUF_Player")
local Forte
local LSM = LibStub("LibSharedMedia-3.0")
local widgetLists = AceGUIWidgetLSMlists

local db

local positions = {"TOP", "TOPRIGHT", "TOPLEFT","BOTTOM", "BOTTOMRIGHT", "BOTTOMLEFT","RIGHT", "LEFT", "CENTER"}
local fontflags = {'OUTLINE', 'THICKOUTLINE', 'MONOCHROME', 'NONE'}
local justifications = {'LEFT', 'CENTER', 'RIGHT'}
local valueFormat = {'Absolut', 'Absolut & Percent', 'Absolut Short', 'Absolut Short & Percent', 'Standard', 'Standard Short'}
local _, class = UnitClass("player")

local defaults = {
	XP_Rep = {
		Font = "vibrocen",
		FontSize = 14,
		FontFlag = "NONE",
		FontJustify = "CENTER",
		FontColor = {
			r = 0,
			g = 1,
			b = 1,
			a = 1,
		},
		Experience = {
			Enable = true,
			ShowValue = true,
			AlwaysShow = false,
			Alpha = 1,
			BGColor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.7,
			},
			FillColor = {
				r = 0.33,
				g = 0.33,
				b = 0.33,
				a = 1,
			},
			RestedColor = {
				r = 0,
				g = 0.39,
				b = 0.88,
				a = 0.5,
			},
		},
		Reputation = {
			Enable = true,
			ShowValue = true,
			AlwaysShow = false,
			Alpha = 1,
			BGColor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.7,
			},
			FillColor = {
				r = 0.33,
				g = 0.33,
				b = 0.33,
				a = 1,
			},
		},
	},
	Player = {
		Height = "43",
		Width = "250",
		X = "-200",
		Y = "-200",
		Border = {
			Aggro = true,
			EdgeFile = "glow",
			EdgeSize = 5,
			Insets = {
				Left = "3",
				Right = "3",
				Top = "3",
				Bottom = "3",
			},
			Color = {
				r = 0,
				g = 0,
				b = 0,
				a = 1,
			},
		},
		Backdrop = {
			Texture = "Blizzard Tooltip",
			Padding = {
				Left = "-4",
				Right = "4",
				Top = "4",
				Bottom = "-4",
			},
			Color = {
				r = 0,
				g = 0,
				b = 0,
				a = 1,
			},
		},
		Health = {
			Height = "30",
			Padding = "0",
			ColorClass = false,
			ColorGradient = false,
			Texture = "LUI_Gradient",
			TextureBG = "LUI_Gradient",
			BGAlpha = 1,
			BGMultiplier = 0.4,
			Smooth = true,
			IndividualColor = {
				Enable = true,
				r = 0.2509803921568627,
				g = 0.2509803921568627,
				b = 0.2509803921568627,
			},
		},
		Power = {
			Enable = true,
			Height = "10",
			Padding = "-2",
			ColorClass = true,
			ColorType = false,
			Texture = "LUI_Minimalist",
			TextureBG = "LUI_Minimalist",
			BGAlpha = 1,
			BGMultiplier = 0.4,
			Smooth = true,
			IndividualColor = {
				Enable = false,
				r = 0.8,
				g = 0.8,
				b = 0.8,
			},
		},
		Full = {
			Enable = false,
			Height = "17",
			Texture = "LUI_Minimalist",
			Padding = "-12",
			Alpha = 1,
			Color = {
				r = 0.11,
				g = 0.11,
				b = 0.11,
				a = 1,
			},
		},
		DruidMana = {
			Enable = true,
			OverPower = true,
			Height = "10",
			Padding = "-2",
			ColorClass = false,
			ColorType = true,
			ColorGradient = false,
			Texture = "LUI_Minimalist",
			TextureBG = "LUI_Minimalist",
			BGAlpha = 1,
			BGMultiplier = 0.4,
			Smooth = true,
		},
		Totems = {
			Enable = true,
			X = "0",
			Y = "0.5",
			Height = "8",
			Width = "250",
			Texture = "LUI_Minimalist",
			Padding = 1,
			Multiplier = 0.5,
			Lock = true,
		},
		Runes = {
			Enable = true,
			X = "0",
			Y = "0.5",
			Height = "8",
			Width = "250",
			Texture = "LUI_Minimalist",
			Padding = 1,
			Lock = true,
		},
		HolyPower = {
			Enable = true,
			X = "0",
			Y = "0.5",
			Height = "8",
			Width = "250",
			Texture = "LUI_Minimalist",
			Padding = 1,
			Lock = true,
		},
		SoulShards = {
			Enable = true,
			X = "0",
			Y = "0.5",
			Height = "8",
			Width = "250",
			Texture = "LUI_Minimalist",
			Padding = 2,
			Lock = true,
		},
		Eclipse = {
			Enable = true,
			X = "0",
			Y = "0.5",
			Height = "8",
			Width = "250",
			Texture = "LUI_Minimalist",
			Lock = true,
			Text = {
				Enable = true,
				Font = "neuropol",
				Size = 12,
				Outline = "NONE",
				X = "0",
				Y = "0",
			},
		},
		Swing = {
			Enable = true,
			Width = "384",
			Height = "4",
			X = "0",
			Y = "86.5",
			Texture = "LUI_Gradient",
			ColorClass = true,
			IndividualColor = {
				Enable = false,
				r = 1,
				g = 1,
				b = 1,
			},
			BGTexture = "LUI_Minimalist",
			BGMultiplier = 0.4,
		},
		Vengeance = {
			Enable = true,
			Width = "384",
			Height = "4",
			X = "0",
			Y = "12",
			Texture = "LUI_Gradient",
			ColorClass = true,
			IndividualColor = {
				Enable = false,
				r = 1,
				g = 1,
				b = 1,
			},
			BGTexture = "LUI_Minimalist",
			BGMultiplier = 0.4,
		},
		Aura = {
			buffs_colorbytype = false, ---------------
			buffs_playeronly = false,
			buffs_enable = false,
			buffs_auratimer = false,
			buffs_disableCooldown = false, ---------------
			buffs_cooldownReverse = true, ---------------
			buffsX = "-0.5",
			buffsY = "-30",
			buffs_initialAnchor = "BOTTOMRIGHT",
			buffs_growthY = "DOWN",
			buffs_growthX = "LEFT",
			buffs_size = "26",
			buffs_spacing = "2",
			buffs_num = "8",
			debuffs_colorbytype = false,
			debuffs_playeronly = false,
			debuffs_enable = false,
			debuffs_auratimer = false,
			debuffs_disableCooldown = false, ---------------
			debuffs_cooldownReverse = true, ---------------
			debuffsX = "-0.5",
			debuffsY = "-60",
			debuffs_initialAnchor = "BOTTOMLEFT",
			debuffs_growthY = "DOWN",
			debuffs_growthX = "RIGHT",
			debuffs_size = "26",
			debuffs_spacing = "2",
			debuffs_num = "36",
		},
		Castbar = {
			Enable = true,
			Height = "33",
			Width = "360",
			X = "13",
			Y = "155",
			Texture = "LUI_Gradient",
			TextureBG = "LUI_Minimalist",
			IndividualColor = false,
			Latency = true,
			Icon = true,
			Text = {
				Name = {
					Enable = true,
					Font = "neuropol",
					Size = 15,
					OffsetX = "5",
					OffsetY = "1",
				},
				Time = {
					Enable = true,
					ShowMax = true,
					Font = "neuropol",
					Size = 13,
					OffsetX = "-5",
					OffsetY = "1",
				},
			},
			Border = {
				Texture = "glow",
				Thickness = "4",
				Inset = {
					left = "3",
					right = "3",
					top = "3",
					bottom = "3",
				},
			},
			Colors = {
				Bar = {
					r = 0.13,
					g = 0.59,
					b = 1,
					a = 0.68,
				},
				Background = {
					r = 0.15,
					g = 0.15,
					b = 0.15,
					a = 0.67,
				},
				Latency = {
					r = 0.11,
					g = 0.11,
					b = 0.11,
					a = 0.74,
				},
				Border = {
					r = 0,
					g = 0,
					b = 0,
					a = 0.7,
				},
				Name = {
					r = 0.9,
					g = 0.9,
					b = 0.9,
				},
				Time = {
					r = 0.9,
					g = 0.9,
					b = 0.9,
				},
			},
		},
		Portrait = {
			Enable = false,
			Height = "43",
			Width = "110",
			X = "0",
			Y = "0",
		},
		Icons = {
			Lootmaster = {
				Enable = true,
				Size = 15,
				X = "16",
				Y = "10",
				Point = "TOPLEFT",
			},
			Leader = {
				Enable = true,
				Size = 17,
				X = "0",
				Y = "10",
				Point = "TOPLEFT",
			},
			Role = {
				Enable = true,
				Size = 22,
				X = "15",
				Y = "10",
				Point = "TOPRIGHT",
			},
			Raid = {
				Enable = true,
				Size = 55,
				X = "0",
				Y = "10",
				Point = "CENTER",
			},
			Resting = {
				Enable = false,
				Size = 27,
				X = "-12",
				Y = "13",
				Point = "TOPLEFT",
			},
			Combat = {
				Enable = false,
				Size = 27,
				X = "-15",
				Y = "-30",
				Point = "BOTTOMLEFT",
			},
			PvP = {
				Enable = false,
				Size = 35,
				X = "-12",
				Y = "10",
				Point = "TOPLEFT",
			},
		},
		Texts = {
			Name = {
				Enable = false,
				Font = "Prototype",
				Size = 24,
				X = "0",
				Y = "0",
				IndividualColor = {
					Enable = true,
					r = 0,
					g = 0,
					b = 0,
				},
				Outline = "NONE",
				Point = "BOTTOMLEFT",
				RelativePoint = "BOTTOMRIGHT",
				Format = "Level + Name",
				Length = "Medium",
				ColorNameByClass = true,
				ColorClassByClass = true,
				ColorLevelByDifficulty = true,
				ShowClassification = true,
				ShortClassification = false,
			},
			Health = {
				Enable = true,
				Font = "Prototype",
				Size = 28,
				X = "0",
				Y = "-31",
				ShowAlways = true,
				ColorClass = false,
				ColorGradient = false,
				IndividualColor = {
					Enable = true,
					r = 1,
					g = 1,
					b = 1,
				},
				Outline = "NONE",
				Point = "BOTTOMRIGHT",
				RelativePoint = "BOTTOMRIGHT",
				Format = "Standard",
				ShowDead = false,
			},
			Power = {
				Enable = true,
				Font = "Prototype",
				Size = 21,
				X = "0",
				Y = "-52",
				ShowAlways = true,
				ColorClass = true,
				ColorType = false,
				IndividualColor = {
					Enable = false,
					r = 1,
					g = 1,
					b = 1,
				},
				Outline = "NONE",
				Point = "BOTTOMRIGHT",
				RelativePoint = "BOTTOMRIGHT",
				Format = "Standard",
			},
			HealthPercent = {
				Enable = true,
				Font = "Prototype",
				Size = 16,
				X = "0",
				Y = "6",
				ShowAlways = false,
				ColorClass = false,
				ColorGradient = false,
				IndividualColor = {
					Enable = true,
					r = 1,
					g = 1,
					b = 1,
				},
				Outline = "NONE",
				Point = "CENTER",
				RelativePoint = "CENTER",
				ShowDead = true,
			},
			PowerPercent = {
				Enable = false,
				Font = "Prototype",
				Size = 14,
				X = "0",
				Y = "-15",
				ShowAlways = false,
				ColorClass = false,
				ColorType = false,
				IndividualColor = {
					Enable = true,
					r = 1,
					g = 1,
					b = 1,
				},
				Outline = "NONE",
				Point = "CENTER",
				RelativePoint = "CENTER",
			},
			HealthMissing = {
				Enable = false,
				Font = "Prototype",
				Size = 15,
				X = "-3",
				Y = "0",
				ShortValue = true,
				ShowAlways = false,
				ColorClass = false,
				ColorGradient = false,
				IndividualColor = {
					Enable = true,
					r = 1,
					g = 1,
					b = 1,
				},
				Outline = "NONE",
				Point = "BOTTOMRIGHT",
				RelativePoint = "BOTTOMRIGHT",
			},
			PowerMissing = {
				Enable = false,
				Font = "Prototype",
				Size = 13,
				X = "-3",
				Y = "-15",
				ShortValue = true,
				ShowAlways = false,
				ColorClass = false,
				ColorType = false,
				IndividualColor = {
					Enable = true,
					r = 1,
					g = 1,
					b = 1,
				},
				Outline = "NONE",
				Point = "RIGHT",
				RelativePoint = "RIGHT",
			},
			DruidMana = {
				Enable = true,
				Font = "Prototype",
				Outline = "NONE",
				Size = 14,
				X = "0",
				Y = "0",
				Point = "BOTTOM",
				RelativePoint = "BOTTOM",
				Format = "Standard",
				HideIfFullMana = true,
				ColorClass = false,
				ColorType = false,
				IndividualColor = {
					Enable = true,
					r = 1,
					g = 1,
					b = 1,
				},
			},
			Combat = {
				Enable = false,
				Font = "vibrocen",
				Outline = "OUTLINE",
				Size = 20,
				Point = "CENTER", ----- here down
				RelativePoint = "BOTTOM",
				X = "0",
				Y = "0",
				ShowDamage = true,
				ShowHeal = true,
				ShowImmune = true,
				ShowEnergize = true,
				ShowOther = true,
				MaxAlpha = 0.6, ----- to here
			},
			PvP = {
				Enable = true,
				Font = "vibroceb",
				Outline = "NONE",
				Size = 12,
				X = "20",
				Y = "5",
				Color = {
					r = 1.0,
					g = 0.1,
					b = 0.1,
				},
			},
		},
	},
}

function module:LoadOptions()
	local options = {
		XP_Rep = {
			name = "XP / Rep",
			type = "group",
			order = 5,
			disabled = function() return not db.oUF.Settings.Enable end,
			childGroups = "tab",
			args = {
				header = {
					name = "XP / Rep",
					type = "header",
					order = 1,
				},
				Info = {
					name = "Info",
					type = "group",
					order = 2,
					args = {
						About = {
							name = "About",
							type = "group",
							order = 1,
							guiInline = true,
							args = {
								desc = {
									name = "The XP and Rep bars are located below the Player UnitFrame and will show on mouseover.\nThe Experience Bar will only be shown if you are not yet Level "..MAX_PLAYER_LEVEL..".\n\nIf you are not yet Level "..MAX_PLAYER_LEVEL.." you can right click on either bar to switch to the other.\nWhen you left click on one of the bars, information about that bar will be paste into your Chat EditBox if it is open and added to the Chat Window if not.\n\n\n",
									type = "description",
									order = 1,
								},
							},
						},
						Reset = {
							name = "Reset",
							type = "execute",
							order = 5,
							func = function(self, reset)
									db.oUF.XP_Rep = defaults.XP_Rep 
									StaticPopup_Show("RELOAD_UI")
								end,
						},
					},
				},
				Experience = {
					name = "XPbar",
					type = "group",
					order = 3,
					args = {
						XPEnable = {
							name = "Enable",
							desc = "Weather you want to show the Experience bar or not.\n",
							type = "toggle",
							width = "full",
							get = function() return db.oUF.XP_Rep.Experience.Enable end,
							set = function()
									db.oUF.XP_Rep.Experience.Enable = not db.oUF.XP_Rep.Experience.Enable
									if db.oUF.XP_Rep.Experience.Enable == true then
										oUF_LUI_player_XP:Show()
										if oUF_LUI_player_Rep ~= nil then
											oUF_LUI_player_Rep:Hide()
										end
									else
										oUF_LUI_player_XP:Hide()
										if db.oUF.XP_Rep.Reputation.Enable == true and oUF_LUI_player_Rep ~= nil then
											oUF_LUI_player_Rep:Show()
										end
									end
								end,
							order = 1,
						},
						Settings = {
							name = "Settings",
							type = "group",
							disabled = function() return not db.oUF.XP_Rep.Experience.Enable end,
							guiInline = true,
							order = 2,
							args = {
								ShowValue = {
									name = "Show Value",
									desc = "Weather you want to show how much XP you have in the XP bar or not.\n",
									type = "toggle",
									order = 1,
									get = function() return db.oUF.XP_Rep.Experience.ShowValue end,
									set = function()
											db.oUF.XP_Rep.Experience.ShowValue = not db.oUF.XP_Rep.Experience.ShowValue
											if db.oUF.XP_Rep.Experience.ShowValue == true then
												oUF_LUI_player.Experience.Value:Show()
											else
												oUF_LUI_player.Experience.Value:Hide()
											end
										end,
								},
								AlwaysShow = {
									name = "Always Show",
									desc = "Weather you want the XP bar to always show or not.\n",
									type = "toggle",
									order = 2,
									get = function() return db.oUF.XP_Rep.Experience.AlwaysShow end,
									set = function()
											db.oUF.XP_Rep.Experience.AlwaysShow = not db.oUF.XP_Rep.Experience.AlwaysShow
											if db.oUF.XP_Rep.Experience.AlwaysShow == true then
												oUF_LUI_player_XP:SetAlpha(db.oUF.XP_Rep.Experience.Alpha)
											else
												oUF_LUI_player_XP:SetAlpha(0)
											end
										end,
								},
								BGColor = {
									name = "Background Color",
									desc = "Select the background color for your XP bar.\n",
									type = "color",
									hasAlpha = true,
									order = 3,
									get = function() return db.oUF.XP_Rep.Experience.BGColor.r, db.oUF.XP_Rep.Experience.BGColor.g, db.oUF.XP_Rep.Experience.BGColor.b, db.oUF.XP_Rep.Experience.BGColor.a end,
									set = function(_, r, g, b, a)
											db.oUF.XP_Rep.Experience.BGColor.r = r
											db.oUF.XP_Rep.Experience.BGColor.g = g
											db.oUF.XP_Rep.Experience.BGColor.b = b
											db.oUF.XP_Rep.Experience.BGColor.a = a
											oUF_LUI_player.Experience.bg:SetVertexColor(db.oUF.XP_Rep.Experience.BGColor.r, db.oUF.XP_Rep.Experience.BGColor.g, db.oUF.XP_Rep.Experience.BGColor.b, db.oUF.XP_Rep.Experience.BGColor.a)
										end,
								},
								FillColor = {
									name = "Fill Color",
									desc = "Select the fill color for your XP bar.\n",
									type = "color",
									hasAlpha = true,
									order = 4,
									get = function() return db.oUF.XP_Rep.Experience.FillColor.r, db.oUF.XP_Rep.Experience.FillColor.g, db.oUF.XP_Rep.Experience.FillColor.b, db.oUF.XP_Rep.Experience.FillColor.a end,
									set = function(_, r, g, b, a)
											db.oUF.XP_Rep.Experience.FillColor.r = r
											db.oUF.XP_Rep.Experience.FillColor.g = g
											db.oUF.XP_Rep.Experience.FillColor.b = b
											db.oUF.XP_Rep.Experience.FillColor.a = a
											oUF_LUI_player.Experience:SetStatusBarColor(db.oUF.XP_Rep.Experience.FillColor.r, db.oUF.XP_Rep.Experience.FillColor.g, db.oUF.XP_Rep.Experience.FillColor.b, db.oUF.XP_Rep.Experience.FillColor.a)
										end,
								},
								RestedColor = {
									name = "Rested Color",
									desc = "Select the rested xp color for your XP bar.\n",
									type = "color",
									hasAlpha = true,
									order = 4,
									get = function() return db.oUF.XP_Rep.Experience.RestedColor.r, db.oUF.XP_Rep.Experience.RestedColor.g, db.oUF.XP_Rep.Experience.RestedColor.b, db.oUF.XP_Rep.Experience.RestedColor.a end,
									set = function(_, r, g, b, a)
											db.oUF.XP_Rep.Experience.RestedColor.r = r
											db.oUF.XP_Rep.Experience.RestedColor.g = g
											db.oUF.XP_Rep.Experience.RestedColor.b = b
											db.oUF.XP_Rep.Experience.RestedColor.a = a
											oUF_LUI_player.Experience.Rested:SetStatusBarColor(db.oUF.XP_Rep.Experience.RestedColor.r, db.oUF.XP_Rep.Experience.RestedColor.g, db.oUF.XP_Rep.Experience.RestedColor.b, db.oUF.XP_Rep.Experience.RestedColor.a)
										end,
								},
								Alpha = {
									name = "Alpha",
									desc = "Select the alpha of the XP bar when shown.\n",
									type = "range",
									order = 5,
									min = 0,
									max = 1,
									step = 0.1,
									get = function() return db.oUF.XP_Rep.Experience.Alpha end,
									set = function(self, alpha)
											db.oUF.XP_Rep.Experience.Alpha = alpha
											if db.oUF.XP_Rep.Experience.AlwaysShow == true then
												oUF_LUI_player_XP:SetAlpha(db.oUF.XP_Rep.Experience.Alpha)
											end
										end,
								},
							},
						},
					},
				},
				Reputation = {
					name = "Repbar",
					type = "group",
					order = 4,
					args = {
						RepEnable = {
							name = "Enable",
							desc = "Weather you want to show the Reputation bar or not.\n",
							type = "toggle",
							width = "full",
							get = function() return db.oUF.XP_Rep.Reputation.Enable end,
							set = function()
									db.oUF.XP_Rep.Reputation.Enable = not db.oUF.XP_Rep.Reputation.Enable
									if db.oUF.XP_Rep.Reputation.Enable == true then
										oUF_LUI_player_Rep:Show()
										if oUF_LUI_player_XP ~= nil then
											oUF_LUI_player_XP:Hide()
										end
									else
										oUF_LUI_player_Rep:Hide()
										if db.oUF.XP_Rep.Experience.Enable == true and oUF_LUI_player_XP ~= nil and UnitLevel("player") ~= MAX_PLAYER_LEVEL then
											oUF_LUI_player_XP:Show()
										end
									end
								end,
							order = 1,
						},
						Settings = {
							name = "Settings",
							type = "group",
							disabled = function() return not db.oUF.XP_Rep.Reputation.Enable end,
							guiInline = true,
							order = 2,
							args = {
								ShowValue = {
									name = "Show Value",
									desc = "Weather you want to show how much Rep you have in the Rep bar or not.\n",
									type = "toggle",
									order = 1,
									get = function() return db.oUF.XP_Rep.Reputation.ShowValue end,
									set = function()
											db.oUF.XP_Rep.Reputation.ShowValue = not db.oUF.XP_Rep.Reputation.ShowValue
											if db.oUF.XP_Rep.Reputation.ShowValue == true then
												oUF_LUI_player.Reputation.Value:Show()
											else
												oUF_LUI_player.Reputation.Value:Hide()
											end
										end,
								},
								AlwaysShow = {
									name = "Always Show",
									desc = "Weather you want the Rep bar to always show or not.\n",
									type = "toggle",
									order = 2,
									get = function() return db.oUF.XP_Rep.Reputation.AlwaysShow end,
									set = function()
											db.oUF.XP_Rep.Reputation.AlwaysShow = not db.oUF.XP_Rep.Reputation.AlwaysShow
											if db.oUF.XP_Rep.Reputation.AlwaysShow == true then
												oUF_LUI_player_Rep:SetAlpha(db.oUF.XP_Rep.Reputation.Alpha)
											else
												oUF_LUI_player_Rep:SetAlpha(0)
											end
										end,
								},
								BGColor = {
									name = "Background Color",
									desc = "Select the background color for your Rep bar.\n",
									type = "color",
									hasAlpha = true,
									order = 3,
									get = function() return db.oUF.XP_Rep.Reputation.BGColor.r, db.oUF.XP_Rep.Reputation.BGColor.g, db.oUF.XP_Rep.Reputation.BGColor.b, db.oUF.XP_Rep.Reputation.BGColor.a end,
									set = function(_, r, g, b, a)
											db.oUF.XP_Rep.Reputation.BGColor.r = r
											db.oUF.XP_Rep.Reputation.BGColor.g = g
											db.oUF.XP_Rep.Reputation.BGColor.b = b
											db.oUF.XP_Rep.Reputation.BGColor.a = a
											oUF_LUI_player.Reputation.bg:SetVertexColor(db.oUF.XP_Rep.Reputation.BGColor.r, db.oUF.XP_Rep.Reputation.BGColor.g, db.oUF.XP_Rep.Reputation.BGColor.b, db.oUF.XP_Rep.Reputation.BGColor.a)
										end,
								},
								FillColor = {
									name = "Fill Color",
									desc = "Select the fill color for your Rep bar.\n",
									type = "color",
									hasAlpha = true,
									order = 4,
									get = function() return db.oUF.XP_Rep.Reputation.FillColor.r, db.oUF.XP_Rep.Reputation.FillColor.g, db.oUF.XP_Rep.Reputation.FillColor.b, db.oUF.XP_Rep.Reputation.FillColor.a end,
									set = function(_, r, g, b, a)
											db.oUF.XP_Rep.Reputation.FillColor.r = r
											db.oUF.XP_Rep.Reputation.FillColor.g = g
											db.oUF.XP_Rep.Reputation.FillColor.b = b
											db.oUF.XP_Rep.Reputation.FillColor.a = a
											oUF_LUI_player.Reputation:SetStatusBarColor(db.oUF.XP_Rep.Reputation.FillColor.r, db.oUF.XP_Rep.Reputation.FillColor.g, db.oUF.XP_Rep.Reputation.FillColor.b, db.oUF.XP_Rep.Reputation.FillColor.a)
										end,
								},
								Alpha = {
									name = "Alpha",
									desc = "Select the alpha of the Rep bar when shown.\n",
									type = "range",
									order = 5,
									min = 0,
									max = 1,
									step = 0.1,
									get = function() return db.oUF.XP_Rep.Reputation.Alpha end,
									set = function(self, alpha)
											db.oUF.XP_Rep.Reputation.Alpha = alpha
											if db.oUF.XP_Rep.Reputation.AlwaysShow == true then
												oUF_LUI_player_Rep:SetAlpha(db.oUF.XP_Rep.Reputation.Alpha)
											end
										end,
								},
							},
						},
					},
				},
				Font = {
					name = "Font",
					type = "group",
					order = 5,
					args = {
						Face = {
							name = "Font",
							desc = "Choose your font!\nDefault: "..LUI.defaults.profile.oUF.XP_Rep.Font,
							type = "select",
							order = 1,
							dialogControl = "LSM30_Font",
							values = widgetLists.font,
							get = function() return db.oUF.XP_Rep.Font end,
							set = function(self, font)
									db.oUF.XP_Rep.Font = font
									if oUF_LUI_player_XP ~= nil then
										oUF_LUI_player.Experience.Value:SetFont(LSM:Fetch("font", db.oUF.XP_Rep.Font), tonumber(db.oUF.XP_Rep.FontSize), db.oUF.XP_Rep.FontFlag)
									end
									if oUF_LUI_player_Rep ~= nil then
										oUF_LUI_player.Reputation.Value:SetFont(LSM:Fetch("font", db.oUF.XP_Rep.Font), tonumber(db.oUF.XP_Rep.FontSize), db.oUF.XP_Rep.FontFlag)
									end
								end,
						},
						Size = {
							name = "Font Size",
							desc = "Choose your font size!\n\nDefault: "..LUI.defaults.profile.oUF.XP_Rep.FontSize,
							type = "range",
							order = 2,
							min = 6,
							max = 20,
							step = 1,
							get = function() return db.oUF.XP_Rep.FontSize end,
							set = function(self, fontSize)
									db.oUF.XP_Rep.FontSize = fontSize
									if oUF_LUI_player_XP ~= nil then
										oUF_LUI_player.Experience.Value:SetFont(LSM:Fetch("font", db.oUF.XP_Rep.Font), tonumber(db.oUF.XP_Rep.FontSize), db.oUF.XP_Rep.FontFlag)
									end
									if oUF_LUI_player_Rep ~= nil then
										oUF_LUI_player.Reputation.Value:SetFont(LSM:Fetch("font", db.oUF.XP_Rep.Font), tonumber(db.oUF.XP_Rep.FontSize), db.oUF.XP_Rep.FontFlag)
									end
								end,
						},
						Flag = {
							name = "Font Flag",
							desc = "Choose your font flag!\n\nDefault: "..LUI.defaults.profile.oUF.XP_Rep.FontFlag,
							type = "select",
							order = 3,
							values = fontflags,
							get = function()
									for k,v in pairs(fontflags) do
										if db.oUF.XP_Rep.FontFlag == v then
											return k
										end
									end
								end,
							set = function(self, fontFlag)
									db.oUF.XP_Rep.FontFlag = fontflags[fontFlag]
									if oUF_LUI_player_XP ~= nil then
										oUF_LUI_player.Experience.Value:SetFont(LSM:Fetch("font", db.oUF.XP_Rep.Font), tonumber(db.oUF.XP_Rep.FontSize), db.oUF.XP_Rep.FontFlag)
									end
									if oUF_LUI_player_Rep ~= nil then
										oUF_LUI_player.Reputation.Value:SetFont(LSM:Fetch("font", db.oUF.XP_Rep.Font), tonumber(db.oUF.XP_Rep.FontSize), db.oUF.XP_Rep.FontFlag)
									end
								end,
						},
						Justify = {
							name = "Font Justify",
							desc = "Choose your font justification!\n\nDefault: "..LUI.defaults.profile.oUF.XP_Rep.FontJustify,
							type = "select",
							order = 4,
							values = justifications,
							get = function()
									for k, v in pairs(justifications) do
										if db.oUF.XP_Rep.FontJustify == v then
											return k
										end
									end
								end,
							set = function(self, fontJustify)
									db.oUF.XP_Rep.FontJustify = justifications[fontJustify]
									if oUF_LUI_player_XP ~= nil then
										oUF_LUI_player.Experience.Value:SetJustifyH(db.oUF.XP_Rep.FontJustify)
									end
									if oUF_LUI_player_Rep ~= nil then
										oUF_LUI_player.Reputation.Value:SetJustifyH(db.oUF.XP_Rep.FontJustify)
									end
								end,
						},
						Color = {
							name = "Font Color",
							desc = "Choose your font color!\n\nDefaults:\nr = "..LUI.defaults.profile.oUF.XP_Rep.FontColor.r.."\ng = "..LUI.defaults.profile.oUF.XP_Rep.FontColor.g.."\nb = "..LUI.defaults.profile.oUF.XP_Rep.FontColor.b.."\na = "..LUI.defaults.profile.oUF.XP_Rep.FontColor.a,
							type = "color",
							order = 5,
							hasAlpha = true,
							get = function() return db.oUF.XP_Rep.FontColor.r, db.oUF.XP_Rep.FontColor.g, db.oUF.XP_Rep.FontColor.b, db.oUF.XP_Rep.FontColor.a end,
							set = function(_, r, g, b, a)
									db.oUF.XP_Rep.FontColor.r = r
									db.oUF.XP_Rep.FontColor.g = g
									db.oUF.XP_Rep.FontColor.b = b
									db.oUF.XP_Rep.FontColor.a = a
									if oUF_LUI_player.XP ~= nil then
										oUF_LUI_player.Experience.Value:SetTextColor(db.oUF.XP_Rep.FontColor.r, db.oUF.XP_Rep.FontColor.g, db.oUF.XP_Rep.FontColor.b, db.oUF.XP_Rep.FontColor.a)
									end
									if oUF_LUI_player.Rep ~= nil then
										oUF_LUI_player.Reputation.Value:SetTextColor(db.oUF.XP_Rep.FontColor.r, db.oUF.XP_Rep.FontColor.g, db.oUF.XP_Rep.FontColor.b, db.oUF.XP_Rep.FontColor.a)
									end
								end,
						},
					},
				},
			},
		},
		Player = {
			args = {
				Bars = {
					args = {
						DruidMana = {
							name = "DruidMana",
							type = "group",
							order = 11,
							disabled = function() return not(class == "DRUID") end,
							hidden = function() return not(class == "DRUID") end,
							args = {
								DruidManaEnable = {
									name = "Enable",
									desc = "Weather you want to show the DruidMana Bar while in Cat or Bear Form or not.\n",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.DruidMana.Enable end,
									set = function(self,Enable)
										db.oUF.Player.DruidMana.Enable = Enable
										if not oUF_LUI_player.DruidMana then oUF_LUI_player.CreateDruidMana() end
										if Enable then
											oUF_LUI_player:EnableElement("DruidMana")
										else
											oUF_LUI_player:DisableElement("DruidMana")
											oUF_LUI_player.DruidMana:Hide()
										end
										oUF_LUI_player:UpdateAllElements()
									end,
									order = 1,
								},
								General = {
									name = "General Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.DruidMana.Enable end,
									guiInline = true,
									order = 2,
									args = {
										OverPower = {
											name = "Over Power Bar",
											desc = "Weather you want the DruidMana Bar to take up half the Power Bar or be a separate bar.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.DruidMana.OverPower end,
											set = function(self,OverPower)
												db.oUF.Player.DruidMana.OverPower = OverPower
												oUF_LUI_player.DruidMana.SetPosition()
											end,
											order = 1,
										},
										Height = {
											name = "Height",
											desc = "Decide the Height of your Player Power.\n\nDefault: "..LUI.defaults.profile.oUF.Player.DruidMana.Height,
											type = "input",
											disabled = function() return db.oUF.Player.DruidMana.OverPower end,
											get = function() return db.oUF.Player.DruidMana.Height end,
											set = function(self,Height)
												if Height == nil or Height == "" then Height = "0" end
												db.oUF.Player.DruidMana.Height = Height
												oUF_LUI_player.DruidMana:SetHeight(tonumber(Height))
											end,
											order = 2,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Power bar & DruidMana bar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.DruidMana.Padding,
											type = "input",
											get = function() return db.oUF.Player.DruidMana.Padding end,
											set = function(self,Padding)
												if Padding == nil or Padding == "" then Padding = "0" end
												db.oUF.Player.DruidMana.Padding = Padding
												oUF_LUI_player.DruidMana:ClearAllPoints()
												oUF_LUI_player.DruidMana:SetPoint("TOPLEFT", oUF_LUI_player.Power, "BOTTOMLEFT", 0, tonumber(Padding))
												oUF_LUI_player.DruidMana:SetPoint("TOPRIGHT", oUF_LUI_player.Power, "BOTTOMRIGHT", 0, tonumber(Padding))
												oUF_LUI_player.DruidMana.SetPosition()
											end,
											order = 3,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.DruidMana.Smooth end,
											set = function(self,Smooth)
												db.oUF.Player.DruidMana.Smooth = Smooth
												if Smooth then
													oUF_LUI_player:SmoothBar(oUF_LUI_player.DruidMana.ManaBar)
												else
													oUF_LUI_player.DruidMana.ManaBar.SetValue = oUF_LUI_player.DruidMana.ManaBar.SetValue_
												end
											end,
											order = 4,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.DruidMana.Enable end,
									guiInline = true,
									order = 3,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored DruidMana Bars or not.",
											type = "toggle",
											get = function() return db.oUF.Player.DruidMana.ColorClass end,
											set = function(self,PowerClassColor)
												db.oUF.Player.DruidMana.ColorClass = true
												db.oUF.Player.DruidMana.ColorType = false
												db.oUF.Player.DruidMana.ColorGradient = false
												
												oUF_LUI_player.DruidMana.colorClass = true
												oUF_LUI_player.DruidMana.colorSmooth = false
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 1,
										},
										ColorByType = {
											name = "Color by Type",
											desc = "Wether you want to use Mana colored DruidMana Bars or not.",
											type = "toggle",
											get = function() return db.oUF.Player.DruidMana.ColorType end,
											set = function(self,PowerColorByType)
												db.oUF.Player.DruidMana.ColorType = true
												db.oUF.Player.DruidMana.ColorClass = false
												db.oUF.Player.DruidMana.ColorGradient = false
												
												oUF_LUI_player.DruidMana.colorClass = false
												oUF_LUI_player.DruidMana.colorSmooth = false
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 2,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use the Health Gradient colors for your DruidMana Bars or not.",
											type = "toggle",
											get = function() return db.oUF.Player.DruidMana.ColorGradient end,
											set = function(self,IndividualPowerColor)
												db.oUF.Player.DruidMana.ColorGradient = true
												db.oUF.Player.DruidMana.ColorType = false
												db.oUF.Player.DruidMana.ColorClass = false
												
												oUF_LUI_player.DruidMana.colorSmooth = true
												oUF_LUI_player.DruidMana.colorClass = false
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 3,
										},
									},
								},
								Textures = {
									name = "Texture Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.DruidMana.Enable end,
									guiInline = true,
									order = 4,
									args = {
										DruidManaTex = {
											name = "Texture",
											desc = "Choose your DruidMana Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.DruidMana.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
												return db.oUF.Player.DruidMana.Texture
											end,
											set = function(self, DruidManaTex)
												db.oUF.Player.DruidMana.Texture = DruidManaTex
												oUF_LUI_player.DruidMana.ManaBar:SetStatusBarTexture(LSM:Fetch("statusbar", DruidManaTex))
												end,
											order = 1,
										},
										DruidManaTexBG = {
											name = "Background Texture",
											desc = "Choose your DruidMana Background Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.DruidMana.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
												return db.oUF.Player.DruidMana.TextureBG
											end,
											set = function(self, DruidManaTexBG)
												db.oUF.Player.DruidMana.TextureBG = DruidManaTexBG
												oUF_LUI_player.DruidMana.bg:SetTexture(LSM:Fetch("statusbar", DruidManaTexBG))
											end,
											order = 2,
										},
										DruidManaTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your DruidMana Background.\nDefault: "..LUI.defaults.profile.oUF.Player.DruidMana.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Player.DruidMana.BGAlpha end,
											set = function(_, DruidManaTexBGAlpha) 
												db.oUF.Player.DruidMana.BGAlpha = DruidManaTexBGAlpha
												oUF_LUI_player.DruidMana.bg:SetAlpha(tonumber(DruidManaTexBGAlpha))
											end,
											order = 3,
										},
										DruidManaTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.Player.DruidMana.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Player.DruidMana.BGMultiplier end,
											set = function(_, DruidManaTexBGMultiplier) 
												db.oUF.Player.DruidMana.BGMultiplier = DruidManaTexBGMultiplier
												oUF_LUI_player.DruidMana.bg.multiplier = tonumber(DruidManaTexBGMultiplier)
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 4,
										},
									},
								},
							},
						},
						TotemBar = {
							name = "TotemBar",
							type = "group",
							order = 12,
							hidden = function() return not(class == "SHAMAN") end,
							args = {
								Totems = {
									name = "Enable",
									desc = "Whether you want to show the TotemTimer Bar or not.\n",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.Totems.Enable end,
									set = function(self,Enable)
										db.oUF.Player.Totems.Enable = Enable
										if not oUF_LUI_player.TotemBar then oUF_LUI_player.CreateTotemBar() end
										if Enable then
											oUF_LUI_player.TotemBar:Show()
											oUF_LUI_player:EnableElement("TotemBar")
										else
											oUF_LUI_player:DisableElement("TotemBar")
											oUF_LUI_player.TotemBar:Hide()
										end
										Forte:SetPosForte()
										oUF_LUI_player:UpdateAllElements()
									end,
									order = 1,
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.Totems.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Lock = {
											name = "Lock",
											desc = "Whether you want to stick the TotemBar to your PlayerFrame or not.\nIf Locked, FortExorcist Spelltimer will be adjust automaticly.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.Totems.Lock end,
											set = function(self,Lock)
												db.oUF.Player.Totems.Lock = Lock
												if Lock then
													oUF_LUI_player.TotemBar:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", 0, 0.5)
												else
													oUF_LUI_player.TotemBar:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", db.oUF.Player.Totems.X, db.oUF.Player.Totems.Y)
												end
												Forte:SetPosForte()
											end,
											order = 1,
										},
										XValue = {
											name = "X Value",
											desc = "Choose the X Value for your TotemBar.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.Totems.X,
											type = "input",
											disabled = function() return db.oUF.Player.Totems.Lock end,
											get = function() return db.oUF.Player.Totems.X end,
											set = function(self,XValue)
												if XValue == nil or XValue == "" then XValue = "0" end
												db.oUF.Player.Totems.X = XValue
												oUF_LUI_player.TotemBar:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", db.oUF.Player.Totems.X, db.oUF.Player.Totems.Y)
											end,
											order = 2,
										},
										YValue = {
											name = "Y Value",
											desc = "Choose the Y Value for your TotemBar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.Totems.Y,
											type = "input",
											disabled = function() return db.oUF.Player.Totems.Lock end,
											get = function() return db.oUF.Player.Totems.Y end,
											set = function(self,YValue)
												if YValue == nil or YValue == "" then YValue = "0" end
												db.oUF.Player.Totems.Y = YValue
												oUF_LUI_player.TotemBar:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", db.oUF.Player.Totems.X, db.oUF.Player.Totems.Y)
											end,
											order = 3,
										},
										Width = {
											name = "Width",
											desc = "Choose your TotemBar Width.\n\nDefault: "..LUI.defaults.profile.oUF.Player.Totems.Width,
											type = "input",
											get = function() return db.oUF.Player.Totems.Width end,
											set = function(self,Width)
												if Width == nil or Width == "" then Width = "0" end
												db.oUF.Player.Totems.Width = Width
												oUF_LUI_player.TotemBar:SetWidth(tonumber(Width))
												for i = 1, 4 do
													oUF_LUI_player.TotemBar[i]:SetWidth((tonumber(Width) -3*db.oUF.Player.Totems.Padding) / 4)
												end
											end,
											order = 4,
										},
										Height = {
											name = "Height",
											desc = "Choose your TotemBar Height.\n\nDefault: "..LUI.defaults.profile.oUF.Player.Totems.Height,
											type = "input",
											get = function() return db.oUF.Player.Totems.Height end,
											set = function(self,Height)
												if Height == nil or Height == "" then Height = "0" end
												db.oUF.Player.Totems.Height = Height
												oUF_LUI_player.TotemBar:SetHeight(tonumber(Height))
												for i = 1, 4 do
													oUF_LUI_player.TotemBar[i]:SetHeight(tonumber(Height))
												end
												Forte:SetPosForte()
											end,
											order = 5,
										},
										Texture = {
											name = "Texture",
											desc = "Choose your TotemBar Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.Totems.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function() return db.oUF.Player.Totems.Texture end,
											set = function(self, Texture)
												db.oUF.Player.Totems.Texture = Texture
												for i = 1, 4 do
													oUF_LUI_player.TotemBar[i]:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
												end
											end,
											order = 6,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between your Totems!\n Default: "..LUI.defaults.profile.oUF.Player.Totems.Padding,
											type = "range",
											min = 1,
											max = 10,
											step = 1,
											get = function() return db.oUF.Player.Totems.Padding end,
											set = function(_,Padding)
												db.oUF.Player.Totems.Padding = Padding
												for i = 1, 4 do
													oUF_LUI_player.TotemBar[i]:SetWidth((tonumber(db.oUF.Player.Totems.Width) -3*Padding) / 4)
													if i ~= 1 then
														oUF_LUI_player.TotemBar[i]:SetPoint("LEFT", oUF_LUI_player.TotemBar[i-1], "RIGHT", Padding, 0)
													end
												end
											end,
											order = 7,
										},
										Multiplier = {
											name = "Multiplier",
											desc = "Choose your TotemBar Background Multiplier!\n Default: "..LUI.defaults.profile.oUF.Player.Totems.Multiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Player.Totems.Multiplier end,
											set = function(_, Multiplier)
												db.oUF.Player.Totems.Multiplier = Multiplier
												for i = 1, 4 do
													oUF_LUI_player.TotemBar[i].bg.multiplier = Multiplier
												end
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 8,
										},
									},
								},
							},
						},
						Runebar = {
							name = "Runebar",
							type = "group",
							order = 13,
							disabled = function() return not(class == "DEATHKNIGHT") end,
							hidden = function() return not(class == "DEATHKNIGHT") end,
							args = {
								Runes = {
									name = "Enable",
									desc = "Whether you want to show the DK Rune Bar or not.\n",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.Runes.Enable end,
									set = function(self,Enable)
										db.oUF.Player.Runes.Enable = Enable
										if not oUF_LUI_player.Runes then oUF_LUI_player.CreateRunes() end
										if Enable then
											oUF_LUI_player.Runes:Show()
											oUF_LUI_player:EnableElement("Runes")
										else
											oUF_LUI_player:DisableElement("Runes")
											oUF_LUI_player.Runes:Hide()
										end
										Forte:SetPosForte()
										oUF_LUI_player:UpdateAllElements()
									end,
									order = 1,
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.Runes.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Lock = {
											name = "Lock",
											desc = "Whether you want to stick the DK Rune Bar to your PlayerFrame or not.\nIf Locked, FortExorcist Spelltimer will be adjust automaticly.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.Runes.Lock end,
											set = function(self,Lock)
												db.oUF.Player.Runes.Lock = Lock
												if Lock then
													oUF_LUI_player.Runes:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", 0, 0.5)
												else
													oUF_LUI_player.Runes:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", db.oUF.Player.Runes.X, db.oUF.Player.Runes.Y)
												end
												Forte:SetPosForte()
											end,
											order = 1,
										},
										XValue = {
											name = "X Value",
											desc = "Choose the X Value for your RuneBar.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.Runes.X,
											type = "input",
											disabled = function() return db.oUF.Player.Runes.Lock end,
											get = function() return db.oUF.Player.Runes.X end,
											set = function(self,XValue)
												if XValue == nil or XValue == "" then XValue = "0" end
												db.oUF.Player.Runes.X = XValue
												oUF_LUI_player.Runes:SetPoint('BOTTOMLEFT', oUF_LUI_player, 'TOPLEFT', db.oUF.Player.Runes.X, db.oUF.Player.Runes.Y)
											end,
											order = 2,
										},
										YValue = {
											name = "Y Value",
											desc = "Choose the Y Value for your RuneBar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.Runes.Y,
											type = "input",
											disabled = function() return db.oUF.Player.Runes.Lock end,
											get = function() return db.oUF.Player.Runes.Y end,
											set = function(self,YValue)
												if YValue == nil or YValue == "" then YValue = "0" end
												db.oUF.Player.Runes.Y = YValue
												oUF_LUI_player.Runes:SetPoint('BOTTOMLEFT', oUF_LUI_player, 'TOPLEFT', db.oUF.Player.Runes.X, db.oUF.Player.Runes.Y)
											end,
											order = 3,
										},
										Width = {
											name = "Width",
											desc = "Choose your RuneBar Width.\n\nDefault: "..LUI.defaults.profile.oUF.Player.Runes.Width,
											type = "input",
											get = function() return db.oUF.Player.Runes.Width end,
											set = function(self,Width)
												if Width == nil or Width == "" then Width = "0" end
												db.oUF.Player.Runes.Width = Width
												oUF_LUI_player.Runes:SetWidth(tonumber(Width))
												for i = 1, 6 do
													oUF_LUI_player.Runes[i]:SetWidth((tonumber(Width) -5*db.oUF.Player.Runes.Padding) / 6)
												end
											end,
											order = 4,
										},
										Height = {
											name = "Height",
											desc = "Choose your RuneBar Height.\n\nDefault: "..LUI.defaults.profile.oUF.Player.Runes.Height,
											type = "input",
											get = function() return db.oUF.Player.Runes.Height end,
											set = function(self,Height)
												if Height == nil or Height == "" then Height = "0" end
												db.oUF.Player.Runes.Height = Height
												oUF_LUI_player.Runes:SetHeight(tonumber(Height))
												for i = 1, 6 do
													oUF_LUI_player.Runes[i]:SetHeight(tonumber(Height))
												end
												Forte:SetPosForte()
											end,
											order = 5,
										},
										Texture = {
											name = "Texture",
											desc = "Choose your RuneBar Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.Runes.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function() return db.oUF.Player.Runes.Texture end,
											set = function(self, Texture)
												db.oUF.Player.Runes.Texture = Texture
												for i = 1, 6 do
													oUF_LUI_player.Runes[i]:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
												end
											end,
											order = 6,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between your Runes!\n Default: "..LUI.defaults.profile.oUF.Player.Runes.Padding,
											type = "range",
											min = 1,
											max = 10,
											step = 1,
											get = function() return db.oUF.Player.Runes.Padding end,
											set = function(_, Padding)
												db.oUF.Player.Runes.Padding = Padding
												for i = 1, 6 do
													oUF_LUI_player.Runes[i]:SetWidth((tonumber(db.oUF.Player.Runes.Width) -5*Padding) / 6)
													if i ~= 1 then
														oUF_LUI_player.Runes[i]:SetPoint("LEFT", oUF_LUI_player.Runes[i-1], "RIGHT", Padding, 0)
													end
												end
												oUF_LUI_player.Runes[5]:SetPoint("LEFT", oUF_LUI_player.Runes[2], "RIGHT", Padding, 0)
												oUF_LUI_player.Runes[3]:SetPoint("LEFT", oUF_LUI_player.Runes[6], "RIGHT", Padding, 0)
											end,
											order = 7,
										},
									},
								},
							},
						},
						HolyPower = {
							name = "Holy Power",
							type = "group",
							order = 14,
							disabled = function() return not(class == "PALADIN") end,
							hidden = function() return not(class == "PALADIN") end,
							args = {
								HolyPowerEnable = {
									name = "Enable",
									desc = "Whether you want to show the HolyPower Bar or not.\n",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.HolyPower.Enable end,
									set = function(self,Enable)
										db.oUF.Player.HolyPower.Enable = Enable
										if not oUF_LUI_player.HolyPower then oUF_LUI_player.CreateHolyPower() end
										if Enable then
											oUF_LUI_player.HolyPower:Show()
											oUF_LUI_player:EnableElement("HolyPower")
											if not oUF_LUI_player:IsEventRegistered("UNIT_POWER") then oUF_LUI_player:RegisterEvent("UNIT_POWER") end
										else
											oUF_LUI_player:DisableElement("HolyPower")
											oUF_LUI_player.HolyPower:Hide()
										end
										Forte:SetPosForte()
										oUF_LUI_player:UpdateAllElements()
									end,
									order = 1,
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.HolyPower.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Lock = {
											name = "Lock",
											desc = "Whether you want to stick the HolyPowerBar to your PlayerFrame or not.\nIf Locked, FortExorcist Spelltimer will be adjust automaticly.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.HolyPower.Lock end,
											set = function(self,Lock)
												db.oUF.Player.HolyPower.Lock = Lock
												if Lock then
													oUF_LUI_player.HolyPower:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", 0, 0.5)
												else
													oUF_LUI_player.HolyPower:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", db.oUF.Player.HolyPower.X, db.oUF.Player.HolyPower.Y)
												end
												Forte:SetPosForte()
											end,
											order = 1,
										},
										XValue = {
											name = "X Value",
											desc = "Choose the X Value for your HolyPowerBar.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.HolyPower.X,
											type = "input",
											disabled = function() return db.oUF.Player.HolyPower.Lock end,
											get = function() return db.oUF.Player.HolyPower.X end,
											set = function(self,XValue)
												if XValue == nil or XValue == "" then XValue = "0" end
												db.oUF.Player.HolyPower.X = XValue
												oUF_LUI_player.HolyPower:SetPoint('BOTTOMLEFT', oUF_LUI_player, 'TOPLEFT', db.oUF.Player.HolyPower.X, db.oUF.Player.HolyPower.Y)
											end,
											order = 2,
										},
										YValue = {
											name = "Y Value",
											desc = "Choose the Y Value for your HolyPowerBar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.HolyPower.Y,
											type = "input",
											disabled = function() return db.oUF.Player.HolyPower.Lock end,
											get = function() return db.oUF.Player.HolyPower.Y end,
											set = function(self,YValue)
												if YValue == nil or YValue == "" then YValue = "0" end
												db.oUF.Player.HolyPower.Y = YValue
												oUF_LUI_player.HolyPower:SetPoint('BOTTOMLEFT', oUF_LUI_player, 'TOPLEFT', db.oUF.Player.HolyPower.X, db.oUF.Player.HolyPower.Y)
											end,
											order = 3,
										},
										Width = {
											name = "Width",
											desc = "Choose your HolyPowerBar Width.\n\nDefault: "..LUI.defaults.profile.oUF.Player.HolyPower.Width,
											type = "input",
											get = function() return db.oUF.Player.HolyPower.Width end,
											set = function(self,Width)
												if Width == nil or Width == "" then Width = "0" end
												db.oUF.Player.HolyPower.Width = Width
												oUF_LUI_player.HolyPower:SetWidth(tonumber(Width))
												for i = 1, 3 do
													oUF_LUI_player.HolyPower[i]:SetWidth((tonumber(Width) -2*db.oUF.Player.HolyPower.Padding) / 3)
												end
											end,
											order = 4,
										},
										Height = {
											name = "Height",
											desc = "Choose your HolyPowerBar Height.\n\nDefault: "..LUI.defaults.profile.oUF.Player.HolyPower.Height,
											type = "input",
											get = function() return db.oUF.Player.HolyPower.Height end,
											set = function(self,Height)
												if Height == nil or Height == "" then Height = "0" end
												db.oUF.Player.HolyPower.Height = Height
												oUF_LUI_player.HolyPower:SetHeight(tonumber(Height))
												for i = 1, 3 do
													oUF_LUI_player.HolyPower[i]:SetHeight(tonumber(Height))
												end
												Forte:SetPosForte()
											end,
											order = 5,
										},
										Texture = {
											name = "Texture",
											desc = "Choose your HolyPowerBar Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.HolyPower.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function() return db.oUF.Player.HolyPower.Texture end,
											set = function(self, Texture)
												db.oUF.Player.HolyPower.Texture = Texture
												for i = 1, 3 do
													oUF_LUI_player.HolyPower[i]:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
												end
											end,
											order = 6,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between your HolyPower Segments!\n Default: "..LUI.defaults.profile.oUF.Player.HolyPower.Padding,
											type = "range",
											min = 1,
											max = 10,
											step = 1,
											get = function() return db.oUF.Player.HolyPower.Padding end,
											set = function(_, Padding)
												db.oUF.Player.HolyPower.Padding = Padding
												for i = 1, 3 do
													oUF_LUI_player.HolyPower[i]:SetWidth((tonumber(db.oUF.Player.HolyPower.Width) -2*Padding) / 3)
													if i ~= 1 then
														oUF_LUI_player.HolyPower[i]:SetPoint("LEFT", oUF_LUI_player.HolyPower[i-1], "RIGHT", Padding, 0)
													end
												end
											end,
											order = 7,
										},
									},
								},
							},
						},
						SoulShards = {
							name = "Soul Shards",
							type = "group",
							order = 15,
							disabled = function() return not(class == "WARLOCK") end,
							hidden = function() return not(class == "WARLOCK") end,
							args = {
								SoulShardsEnable = {
									name = "Enable",
									desc = "Whether you want to show the SoulShards Bar or not.\n",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.SoulShards.Enable end,
									set = function(self,Enable)
										db.oUF.Player.SoulShards.Enable = Enable
										if not oUF_LUI_player.SoulShards then oUF_LUI_player.CreateSoulShards() end
										if Enable then
											oUF_LUI_player.SoulShards:Show()
											oUF_LUI_player:EnableElement("SoulShards")
											if not oUF_LUI_player:IsEventRegistered("UNIT_POWER") then oUF_LUI_player:RegisterEvent("UNIT_POWER") end
										else
											oUF_LUI_player:DisableElement("SoulShards")
											oUF_LUI_player.SoulShards:Hide()
										end
										Forte:SetPosForte()
										oUF_LUI_player:UpdateAllElements()
									end,
									order = 1,
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.SoulShards.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Lock = {
											name = "Lock",
											desc = "Whether you want to stick the SoulShardsBar to your PlayerFrame or not.\nIf Locked, FortExorcist Spelltimer will be adjust automaticly.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.SoulShards.Lock end,
											set = function(self,Lock)
												db.oUF.Player.SoulShards.Lock = Lock
												if Lock then
													oUF_LUI_player.SoulShards:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", 0, 0.5)
												else
													oUF_LUI_player.SoulShards:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", db.oUF.Player.SoulShards.X, db.oUF.Player.SoulShards.Y)
												end
												Forte:SetPosForte()
											end,
											order = 1,
										},
										XValue = {
											name = "X Value",
											desc = "Choose the X Value for your SoulShardsBar.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.SoulShards.X,
											type = "input",
											disabled = function() return db.oUF.Player.SoulShards.Lock end,
											get = function() return db.oUF.Player.SoulShards.X end,
											set = function(self,XValue)
												if XValue == nil or XValue == "" then XValue = "0" end
												db.oUF.Player.SoulShards.X = XValue
												oUF_LUI_player.SoulShards:SetPoint('BOTTOMLEFT', oUF_LUI_player, 'TOPLEFT', db.oUF.Player.SoulShards.X, db.oUF.Player.SoulShards.Y)
											end,
											order = 2,
										},
										YValue = {
											name = "Y Value",
											desc = "Choose the Y Value for your SoulShardsBar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.SoulShards.Y,
											type = "input",
											disabled = function() return db.oUF.Player.SoulShards.Lock end,
											get = function() return db.oUF.Player.SoulShards.Y end,
											set = function(self,YValue)
												if YValue == nil or YValue == "" then YValue = "0" end
												db.oUF.Player.SoulShards.Y = YValue
												oUF_LUI_player.SoulShards:SetPoint('BOTTOMLEFT', oUF_LUI_player, 'TOPLEFT', db.oUF.Player.SoulShards.X, db.oUF.Player.SoulShards.Y)
											end,
											order = 3,
										},
										Width = {
											name = "Width",
											desc = "Choose your SoulShardsBar Width.\n\nDefault: "..LUI.defaults.profile.oUF.Player.SoulShards.Width,
											type = "input",
											get = function() return db.oUF.Player.SoulShards.Width end,
											set = function(self,Width)
												if Width == nil or Width == "" then Width = "0" end
												db.oUF.Player.SoulShards.Width = Width
												oUF_LUI_player.SoulShards:SetWidth(tonumber(Width))
												for i = 1, 3 do
													oUF_LUI_player.SoulShards[i]:SetWidth((tonumber(Width) -2*db.oUF.Player.SoulShards.Padding) / 3)
												end
											end,
											order = 4,
										},
										Height = {
											name = "Height",
											desc = "Choose your SoulShardsBar Height.\n\nDefault: "..LUI.defaults.profile.oUF.Player.SoulShards.Height,
											type = "input",
											get = function() return db.oUF.Player.SoulShards.Height end,
											set = function(self,Height)
												if Height == nil or Height == "" then Height = "0" end
												db.oUF.Player.SoulShards.Height = Height
												oUF_LUI_player.SoulShards:SetHeight(tonumber(Height))
												for i = 1, 3 do
													oUF_LUI_player.SoulShards[i]:SetHeight(tonumber(Height))
												end
												Forte:SetPosForte()
											end,
											order = 5,
										},
										Texture = {
											name = "Texture",
											desc = "Choose your SoulShardsBar Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.SoulShards.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function() return db.oUF.Player.SoulShards.Texture end,
											set = function(self, Texture)
												db.oUF.Player.SoulShards.Texture = Texture
												for i = 1, 3 do
													oUF_LUI_player.SoulShards[i]:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
												end
											end,
											order = 6,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between your SoulShards Segments!\n Default: "..LUI.defaults.profile.oUF.Player.SoulShards.Padding,
											type = "range",
											min = 1,
											max = 10,
											step = 1,
											get = function() return db.oUF.Player.SoulShards.Padding end,
											set = function(_, Padding)
												db.oUF.Player.SoulShards.Padding = Padding
												for i = 1, 3 do
													oUF_LUI_player.SoulShards[i]:SetWidth((tonumber(db.oUF.Player.SoulShards.Width) -2*Padding) / 3)
													if i ~= 1 then
														oUF_LUI_player.SoulShards[i]:SetPoint("LEFT", oUF_LUI_player.SoulShards[i-1], "RIGHT", Padding, 0)
													end
												end
											end,
											order = 7,
										},
									},
								},
							},
						},
						Eclipse = {
							name = "Eclipsebar",
							type = "group",
							order = 16,
							disabled = function() return not(class == "DRUID") end,
							hidden = function() return not(class == "DRUID") end,
							args = {
								EclipseEnable = {
									name = "Enable",
									desc = "Whether you want to show the Eclipse Bar or not.\n",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.Eclipse.Enable end,
									set = function(self,Enable)
										db.oUF.Player.Eclipse.Enable = Enable
										if not oUF_LUI_player.EclipseBar then oUF_LUI_player.CreateEclipseBar() end
										if Enable then
											oUF_LUI_player.EclipseBar:Show()
											oUF_LUI_player:EnableElement("EclipseBar")
											if not oUF_LUI_player:IsEventRegistered("UNIT_POWER") then oUF_LUI_player:RegisterEvent("UNIT_POWER") end
										else
											oUF_LUI_player:DisableElement("EclipseBar")
											oUF_LUI_player.EclipseBar:Hide()
										end
										Forte:SetPosForte()
										oUF_LUI_player:UpdateAllElements()
									end,
									order = 1,
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.Eclipse.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Lock = {
											name = "Lock",
											desc = "Whether you want to stick the EclipseBar to your PlayerFrame or not.\nIf Locked, FortExorcist Spelltimer will be adjust automaticly.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.Eclipse.Lock end,
											set = function(self,Lock)
												db.oUF.Player.Eclipse.Lock = Lock
												if Lock then
													oUF_LUI_player.EclipseBar:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", 0, 0.5)
												else
													oUF_LUI_player.EclipseBar:SetPoint("BOTTOMLEFT", oUF_LUI_player, "TOPLEFT", db.oUF.Player.Eclipse.X, db.oUF.Player.Eclipse.Y)
												end
												Forte:SetPosForte()
											end,
											order = 1,
										},
										XValue = {
											name = "X Value",
											desc = "Choose the X Value for your Eclipse Bar.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.Eclipse.X,
											type = "input",
											disabled = function() return db.oUF.Player.Eclipse.Lock end,
											get = function() return db.oUF.Player.Eclipse.X end,
											set = function(self,XValue)
												if XValue == nil or XValue == "" then XValue = "0" end
												db.oUF.Player.Eclipse.X = XValue
												oUF_LUI_player.EclipseBar:SetPoint('BOTTOMLEFT', oUF_LUI_player, 'TOPLEFT', db.oUF.Player.Eclipse.X, db.oUF.Player.Eclipse.Y)
											end,
											order = 2,
										},
										YValue = {
											name = "Y Value",
											desc = "Choose the Y Value for your Eclipse Bar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.Eclipse.Y,
											type = "input",
											disabled = function() return db.oUF.Player.Eclipse.Lock end,
											get = function() return db.oUF.Player.Eclipse.Y end,
											set = function(self,YValue)
												if YValue == nil or YValue == "" then YValue = "0" end
												db.oUF.Player.Eclipse.Y = YValue
												oUF_LUI_player.EclipseBar:SetPoint('BOTTOMLEFT', oUF_LUI_player, 'TOPLEFT', db.oUF.Player.Eclipse.X, db.oUF.Player.Eclipse.Y)
											end,
											order = 3,
										},
										Width = {
											name = "Width",
											desc = "Choose your Eclipse Bar Width.\n\nDefault: "..LUI.defaults.profile.oUF.Player.Eclipse.Width,
											type = "input",
											get = function() return db.oUF.Player.Eclipse.Width end,
											set = function(self,Width)
												if Width == nil or Width == "" then Width = "0" end
												db.oUF.Player.Eclipse.Width = Width
												oUF_LUI_player.EclipseBar:SetWidth(tonumber(Width))
												oUF_LUI_player.EclipseBar.SolarBar:SetWidth(tonumber(Width))
											end,
											order = 4,
										},
										Height = {
											name = "Height",
											desc = "Choose your Eclipse Bar Height.\n\nDefault: "..LUI.defaults.profile.oUF.Player.Eclipse.Height,
											type = "input",
											get = function() return db.oUF.Player.Eclipse.Height end,
											set = function(self,Height)
												if Height == nil or Height == "" then Height = "0" end
												db.oUF.Player.Eclipse.Height = Height
												oUF_LUI_player.EclipseBar:SetHeight(tonumber(Height))
											end,
											order = 5,
										},
										Texture = {
											name = "Texture",
											desc = "Choose your Eclipse Bar Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.Eclipse.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function() return db.oUF.Player.Eclipse.Texture end,
											set = function(self, Texture)
												db.oUF.Player.Eclipse.Texture = Texture
												oUF_LUI_player.EclipseBar.LunarBar:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
												oUF_LUI_player.EclipseBar.SolarBar:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
											end,
											order = 6,
										},
									},
								},
								TextEnable = {
									name = "Enable Text",
									desc = "Wether you want to show the Eclipse Bar Text or not.",
									type = "toggle",
									width = "full",
									disabled = function() return not db.oUF.Player.Eclipse.Enable end,
									get = function() return db.oUF.Player.Eclipse.Text.Enable end,
									set = function(self,TextEnable)
										db.oUF.Player.Eclipse.Text.Enable = TextEnable
										oUF_LUI_player.EclipseBar.ShowText = TextEnable
										if TextEnable then
											oUF_LUI_player.EclipseBar.LunarText:Show()
											oUF_LUI_player.EclipseBar.SolarText:Show()
											oUF_LUI_player:UpdateAllElements()
										else
											oUF_LUI_player.EclipseBar.LunarText:Hide()
											oUF_LUI_player.EclipseBar.SolarText:Hide()
										end
									end,
									order = 3,
								},
								FontSettings = {
									name = "Text Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.Eclipse.Enable or not db.oUF.Player.Eclipse.Text.Enable end,
									guiInline = true,
									order = 4,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Eclipse Bar Text Fontsize!\n Default: "..LUI.defaults.profile.oUF.Player.Eclipse.Text.Size,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Player.Eclipse.Text.Size end,
											set = function(_, FontSize)
												db.oUF.Player.Eclipse.Text.Size = FontSize
												oUF_LUI_player.EclipseBar.LunarText:SetFont(LSM:Fetch("font", db.oUF.Player.Eclipse.Text.Font), db.oUF.Player.Eclipse.Text.Size, db.oUF.Player.Eclipse.Text.Outline)
												oUF_LUI_player.EclipseBar.SolarText:SetFont(LSM:Fetch("font", db.oUF.Player.Eclipse.Text.Font), db.oUF.Player.Eclipse.Text.Size, db.oUF.Player.Eclipse.Text.Outline)
											end,
											order = 1,
										},
										empty = {
											name = " ",
											type = "description",
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Eclipse Bar Text!\n\nDefault: "..LUI.defaults.profile.oUF.Player.Eclipse.Text.Font,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Player.Eclipse.Text.Font end,
											set = function(self, Font)
												db.oUF.Player.Eclipse.Text.Font = Font
												oUF_LUI_player.EclipseBar.LunarText:SetFont(LSM:Fetch("font", db.oUF.Player.Eclipse.Text.Font), db.oUF.Player.Eclipse.Text.Size, db.oUF.Player.Eclipse.Text.Outline)
												oUF_LUI_player.EclipseBar.SolarText:SetFont(LSM:Fetch("font", db.oUF.Player.Eclipse.Text.Font), db.oUF.Player.Eclipse.Text.Size, db.oUF.Player.Eclipse.Text.Outline)
											end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Eclipse Bar Text.\nDefault: "..LUI.defaults.profile.oUF.Player.Eclipse.Text.Outline,
											type = "select",
											values = fontflags,
											get = function()
												for k, v in pairs(fontflags) do
													if db.oUF.Player.Eclipse.Text.Outline == v then
														return k
													end
												end
											end,
											set = function(self, FontFlag)
												db.oUF.Player.Eclipse.Text.Outline = fontflags[FontFlag]
												oUF_LUI_player.EclipseBar.LunarText:SetFont(LSM:Fetch("font", db.oUF.Player.Eclipse.Text.Font), db.oUF.Player.Eclipse.Text.Size, db.oUF.Player.Eclipse.Text.Outline)
												oUF_LUI_player.EclipseBar.SolarText:SetFont(LSM:Fetch("font", db.oUF.Player.Eclipse.Text.Font), db.oUF.Player.Eclipse.Text.Size, db.oUF.Player.Eclipse.Text.Outline)
											end,
											order = 4,
										},
										XOffset = {
											name = "X Value",
											desc = "X Value for your Eclipse Bar Text.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.Eclipse.Text.X,
											type = "input",
											get = function() return db.oUF.Player.Eclipse.Text.X end,
											set = function(self,XOffset)
												if XOffset == nil or XOffset == "" then XOffset = "0" end
												oUF_LUI_player.EclipseBar.LunarText:ClearAllPoints()
												oUF_LUI_player.EclipseBar.LunarText:SetPoint("LEFT", oUF_LUI_player.EclipseBar, "LEFT", tonumber(db.oUF.Player.Eclipse.Text.X), tonumber(db.oUF.Player.Eclipse.Text.Y))
												oUF_LUI_player.EclipseBar.SolarText:ClearAllPoints()
												oUF_LUI_player.EclipseBar.SolarText:SetPoint("RIGHT", oUF_LUI_player.EclipseBar, "RIGHT", -tonumber(db.oUF.Player.Eclipse.Text.X), tonumber(db.oUF.Player.Eclipse.Text.Y))
											end,
											order = 5,
										},
										YOffset = {
											name = "Y Value",
											desc = "Y Value for your Eclipse Bar Text.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.Eclipse.Text.Y,
											type = "input",
											get = function() return db.oUF.Player.Eclipse.Text.Y end,
											set = function(self,YOffset)
												if YOffset == nil or YOffset == "" then YOffset = "0" end
												db.oUF.Player.Eclipse.Text.Y = YOffset
												oUF_LUI_player.EclipseBar.LunarText:ClearAllPoints()
												oUF_LUI_player.EclipseBar.LunarText:SetPoint("LEFT", oUF_LUI_player.EclipseBar, "LEFT", tonumber(db.oUF.Player.Eclipse.Text.X), tonumber(db.oUF.Player.Eclipse.Text.Y))
												oUF_LUI_player.EclipseBar.SolarText:ClearAllPoints()
												oUF_LUI_player.EclipseBar.SolarText:SetPoint("RIGHT", oUF_LUI_player.EclipseBar, "RIGHT", -tonumber(db.oUF.Player.Eclipse.Text.X), tonumber(db.oUF.Player.Eclipse.Text.Y))
											end,
											order = 6,
										},
									},
								},
							},
						},
						Swing = {
							name = "Swingtimer",
							type = "group",
							order = 17,
							args = {
								SwingEnable = {
									name = "Enable",
									desc = "Whether you want to show the Swingtimer or not.\n",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.Swing.Enable end,
									set = function(self,Enable)
										db.oUF.Player.Swing.Enable = Enable
										if not oUF_LUI_player.Swing then
											oUF_LUI_player.CreateSwing()
											oUF_LUI_player:EnableElement("Swing")
										end
										if Enable then
											oUF_LUI_player.Swing:Show()
										else
											oUF_LUI_player.Swing:Hide()
										end
										oUF_LUI_player:UpdateAllElements()
									end,
									order = 1,
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.Swing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										XValue = {
											name = "X Value",
											desc = "Choose the X Value for your Swingtmer.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.Swing.X,
											type = "input",
											get = function() return db.oUF.Player.Swing.X end,
											set = function(self,XValue)
												if XValue == nil or XValue == "" then XValue = "0" end
												db.oUF.Player.Swing.X = XValue
												oUF_LUI_player.Swing:SetPoint('BOTTOM', UIParent, 'BOTTOM', db.oUF.Player.Swing.X, db.oUF.Player.Swing.Y)
											end,
											order = 2,
										},
										YValue = {
											name = "Y Value",
											desc = "Choose the Y Value for your Swingtimer.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.Swing.Y,
											type = "input",
											get = function() return db.oUF.Player.Swing.Y end,
											set = function(self,YValue)
												if YValue == nil or YValue == "" then YValue = "0" end
												db.oUF.Player.Swing.Y = YValue
												oUF_LUI_player.Swing:SetPoint('BOTTOM', UIParent, 'BOTTOM', db.oUF.Player.Swing.X, db.oUF.Player.Swing.Y)
											end,
											order = 3,
										},
										Width = {
											name = "Width",
											desc = "Choose your Swingtimer Width.\n\nDefault: "..LUI.defaults.profile.oUF.Player.Swing.Width,
											type = "input",
											get = function() return db.oUF.Player.Swing.Width end,
											set = function(self,Width)
												if Width == nil or Width == "" then Width = "0" end
												db.oUF.Player.Swing.Width = Width
												oUF_LUI_player.Swing:SetWidth(tonumber(Width))
											end,
											order = 4,
										},
										Height = {
											name = "Height",
											desc = "Choose your Swingtimer Height.\n\nDefault: "..LUI.defaults.profile.oUF.Player.Swing.Height,
											type = "input",
											get = function() return db.oUF.Player.Swing.Height end,
											set = function(self,Height)
												if Height == nil or Height == "" then Height = "0" end
												db.oUF.Player.Swing.Height = Height
												oUF_LUI_player.Swing:SetHeight(tonumber(Height))
											end,
											order = 5,
										},
										Texture = {
											name = "Texture",
											desc = "Choose your Swingtimer Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.Swing.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function() return db.oUF.Player.Swing.Texture end,
											set = function(self, Texture)
												db.oUF.Player.Swing.Texture = Texture
												oUF_LUI_player.Swing.texture = Texture
												oUF_LUI_player.Swing.Twohand:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
												oUF_LUI_player.Swing.Mainhand:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
												oUF_LUI_player.Swing.Offhand:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
											end,
											order = 6,
										},
										BGTexture = {
											name = "Background Texture",
											desc = "Choose your Swingtimer Background Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.Swing.BGTexture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function() return db.oUF.Player.Swing.BGTexture end,
											set = function(self, BGTexture)
												db.oUF.Player.Swing.BGTexture = BGTexture
												oUF_LUI_player.Swing.textureBG = BGTexture	
												oUF_LUI_player.Swing.Twohand.bg:SetTexture(LSM:Fetch("statusbar", BGTexture))
												oUF_LUI_player.Swing.Mainhand.bg:SetTexture(LSM:Fetch("statusbar", BGTexture))
												oUF_LUI_player.Swing.Offhand.bg:SetTexture(LSM:Fetch("statusbar", BGTexture))
											end,
											order = 7,
										},
										ColorClass = {
											name = "Color by Class",
											desc = "Choose wether you want to use Classcolors or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.Swing.ColorClass end,
											set = function(self, ColorClass)
												db.oUF.Player.Swing.ColorClass = true
												db.oUF.Player.Swing.IndividualColor.Enable = false
												
												local color = oUF_LUI.colors.class[class]
												local mu = db.oUF.Player.Swing.BGMultiplier
												oUF_LUI_player.Swing.color = {color[1], color[2], color[3], 0.8}
												oUF_LUI_player.Swing.colorBG = {color[1]*mu, color[2]*mu, color[3]*mu, 1}
												oUF_LUI_player.Swing.Twohand:SetStatusBarColor(color[1], color[2], color[3], 0.8)
												oUF_LUI_player.Swing.Twohand.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu, 1)
												oUF_LUI_player.Swing.Mainhand:SetStatusBarColor(color[1], color[2], color[3], 0.8)
												oUF_LUI_player.Swing.Mainhand.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu, 1)
												oUF_LUI_player.Swing.Offhand:SetStatusBarColor(color[1], color[2], color[3], 0.8)
												oUF_LUI_player.Swing.Offhand.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu, 1)
											end,
											order = 8,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Choose wether you want to use Individual Color or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.Swing.IndividualColor.Enable end,
											set = function(self, IndividualColor)
												db.oUF.Player.Swing.IndividualColor.Enable = true
												db.oUF.Player.Swing.ColorClass = false
												
												local color = {db.oUF.Player.Swing.IndividualColor.r, db.oUF.Player.Swing.IndividualColor.g, db.oUF.Player.Swing.IndividualColor.b}
												local mu = db.oUF.Player.Swing.BGMultiplier
												oUF_LUI_player.Swing.color = {color[1], color[2], color[3], 0.8}
												oUF_LUI_player.Swing.colorBG = {color[1]*mu, color[2]*mu, color[3]*mu, 1}
												oUF_LUI_player.Swing.Twohand:SetStatusBarColor(color[1], color[2], color[3], 0.8)
												oUF_LUI_player.Swing.Twohand.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu, 1)
												oUF_LUI_player.Swing.Mainhand:SetStatusBarColor(color[1], color[2], color[3], 0.8)
												oUF_LUI_player.Swing.Mainhand.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu, 1)
												oUF_LUI_player.Swing.Offhand:SetStatusBarColor(color[1], color[2], color[3], 0.8)
												oUF_LUI_player.Swing.Offhand.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu, 1)
											end,
											order = 9,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose your individual Color for your Swingtimer.",
											type = "color",
											disabled = function() return not db.oUF.Player.Swing.IndividualColor.Enable end,
											get = function() return db.oUF.Player.Swing.IndividualColor.r, db.oUF.Player.Swing.IndividualColor.g, db.oUF.Player.Swing.IndividualColor.b end,
											set = function(_,r,g,b)
												db.oUF.Player.Swing.IndividualColor.r = r
												db.oUF.Player.Swing.IndividualColor.g = g
												db.oUF.Player.Swing.IndividualColor.b = b
												
												local mu = db.oUF.Player.Swing.BGMultiplier
												oUF_LUI_player.Swing.Twohand:SetStatusBarColor(r, g, b, 0.8)
												oUF_LUI_player.Swing.Twohand.bg:SetVertexColor(r*mu, g*mu, b*mu, 1)
												oUF_LUI_player.Swing.Mainhand:SetStatusBarColor(r, g, b, 0.8)
												oUF_LUI_player.Swing.Mainhand.bg:SetVertexColor(r*mu, g*mu, b*mu, 1)
												oUF_LUI_player.Swing.Offhand:SetStatusBarColor(r, g, b, 0.8)
												oUF_LUI_player.Swing.Offhand.bg:SetVertexColor(r*mu, g*mu, b*mu, 1)
											end,
											order = 10,
										},
										BGMultiplier = {
											name = "Background Multiplier",
											desc = "Choose the Multiplier which will be used to generate the Background Color.\nDefault: "..LUI.defaults.profile.oUF.Player.Swing.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Player.Swing.BGMultiplier end,
											set = function(_,BGMultiplier)
												db.oUF.Player.Swing.BGMultiplier = BGMultiplier
												
												local r, g, b = oUF_LUI_player.Swing.Twohand:GetStatusBarColor()
												oUF_LUI_player.Swing.Twohand.bg:SetVertexColor(r * BGMultiplier, g * BGMultiplier, b * BGMultiplier, 1)
												oUF_LUI_player.Swing.Mainhand.bg:SetVertexColor(r * BGMultiplier, g * BGMultiplier, b * BGMultiplier, 1)
												oUF_LUI_player.Swing.Offhand.bg:SetVertexColor(r * BGMultiplier, g * BGMultiplier, b * BGMultiplier, 1)
											end,
											order = 11,
										},
									},
								},
							},
						},						
						Vengeance = {
							name = "Vengeancebar",
							type = "group",
							order = 18,
							disabled = function() return not(class == "DRUID" or class == "WARRIOR" or class == "PALADIN" or class == "DEATHKNIGHT") end,
							hidden = function() return not(class == "DRUID" or class == "WARRIOR" or class == "PALADIN" or class == "DEATHKNIGHT") end,
							args = {
								VengeanceEnable = {
									name = "Enable",
									desc = "Whether you want to show the Vengeancebar or not.\n",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.Vengeance.Enable end,
									set = function(self,Enable)
										db.oUF.Player.Vengeance.Enable = Enable
										if not oUF_LUI_player.Vengeance then oUF_LUI_player.CreateVengeance() end
										if Enable then
											oUF_LUI_player:EnableElement("Vengeance")
										else
											oUF_LUI_player:DisableElement("Vengeance")
											oUF_LUI_player.Vengeance:Hide()
										end
										oUF_LUI_player:UpdateAllElements()
									end,
									order = 1,
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.Vengeance.Enable end,
									guiInline = true,
									order = 2,
									args = {
										XValue = {
											name = "X Value",
											desc = "Choose the X Value for your Vengeancetmer.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.Vengeance.X,
											type = "input",
											get = function() return db.oUF.Player.Vengeance.X end,
											set = function(self,XValue)
												if XValue == nil or XValue == "" then XValue = "0" end
												db.oUF.Player.Vengeance.X = XValue
												oUF_LUI_player.Vengeance:SetPoint('BOTTOM', UIParent, 'BOTTOM', db.oUF.Player.Vengeance.X, db.oUF.Player.Vengeance.Y)
											end,
											order = 2,
										},
										YValue = {
											name = "Y Value",
											desc = "Choose the Y Value for your Vengeancebar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.Vengeance.Y,
											type = "input",
											get = function() return db.oUF.Player.Vengeance.Y end,
											set = function(self,YValue)
												if YValue == nil or YValue == "" then YValue = "0" end
												db.oUF.Player.Vengeance.Y = YValue
												oUF_LUI_player.Vengeance:SetPoint('BOTTOM', UIParent, 'BOTTOM', db.oUF.Player.Vengeance.X, db.oUF.Player.Vengeance.Y)
											end,
											order = 3,
										},
										Width = {
											name = "Width",
											desc = "Choose your Vengeancebar Width.\n\nDefault: "..LUI.defaults.profile.oUF.Player.Vengeance.Width,
											type = "input",
											get = function() return db.oUF.Player.Vengeance.Width end,
											set = function(self,Width)
												if Width == nil or Width == "" then Width = "0" end
												db.oUF.Player.Vengeance.Width = Width
												oUF_LUI_player.Vengeance:SetWidth(tonumber(Width))
											end,
											order = 4,
										},
										Height = {
											name = "Height",
											desc = "Choose your Vengeancebar Height.\n\nDefault: "..LUI.defaults.profile.oUF.Player.Vengeance.Height,
											type = "input",
											get = function() return db.oUF.Player.Vengeance.Height end,
											set = function(self,Height)
												if Height == nil or Height == "" then Height = "0" end
												db.oUF.Player.Vengeance.Height = Height
												oUF_LUI_player.Vengeance:SetHeight(tonumber(Height))
											end,
											order = 5,
										},
										Texture = {
											name = "Texture",
											desc = "Choose your Vengeancebar Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.Vengeance.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function() return db.oUF.Player.Vengeance.Texture end,
											set = function(self, Texture)
												db.oUF.Player.Vengeance.Texture = Texture
												oUF_LUI_player.Vengeance:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
											end,
											order = 6,
										},
										BGTexture = {
											name = "Background Texture",
											desc = "Choose your Vengeancebar Background Texture!\nDefault: "..LUI.defaults.profile.oUF.Player.Vengeance.BGTexture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function() return db.oUF.Player.Vengeance.BGTexture end,
											set = function(self, BGTexture)
												db.oUF.Player.Vengeance.BGTexture = BGTexture
												oUF_LUI_player.Vengeance.bg:SetTexture(LSM:Fetch("statusbar", BGTexture))
											end,
											order = 7,
										},
										ColorClass = {
											name = "Color by Class",
											desc = "Choose wether you want to use Classcolors or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.Vengeance.ColorClass end,
											set = function(self, ColorClass)
												db.oUF.Player.Vengeance.ColorClass = true
												db.oUF.Player.Vengeance.IndividualColor.Enable = false
												
												local color = oUF_LUI.colors.class[class]
												local mu = db.oUF.Player.Vengeance.BGMultiplier
												oUF_LUI_player.Vengeance:SetStatusBarColor(color[1], color[2], color[3], 0.8)
												oUF_LUI_player.Vengeance.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu, 1)
											end,
											order = 8,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Choose wether you want to use Individual Color or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Player.Vengeance.IndividualColor.Enable end,
											set = function(self, IndividualColor)
												db.oUF.Player.Vengeance.IndividualColor.Enable = true
												db.oUF.Player.Vengeance.ColorClass = false
												
												local color = {db.oUF.Player.Vengeance.IndividualColor.r, db.oUF.Player.Vengeance.IndividualColor.g, db.oUF.Player.Vengeance.IndividualColor.b}
												local mu = db.oUF.Player.Vengeance.BGMultiplier
												oUF_LUI_player.Vengeance:SetStatusBarColor(color[1], color[2], color[3], 0.8)
												oUF_LUI_player.Vengeance.bg:SetVertexColor(color[1]*mu, color[2]*mu, color[3]*mu, 1)
											end,
											order = 9,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose your individual Color for your Vengeancebar.",
											type = "color",
											disabled = function() return not db.oUF.Player.Vengeance.Enable or not db.oUF.Player.Vengeance.IndividualColor.Enable end,
											get = function() return db.oUF.Player.Vengeance.IndividualColor.r, db.oUF.Player.Vengeance.IndividualColor.g, db.oUF.Player.Vengeance.IndividualColor.b end,
											set = function(_,r,g,b)
												db.oUF.Player.Vengeance.IndividualColor.r = r
												db.oUF.Player.Vengeance.IndividualColor.g = g
												db.oUF.Player.Vengeance.IndividualColor.b = b
												
												local mu = db.oUF.Player.Vengeance.BGMultiplier
												oUF_LUI_player.Vengeance:SetStatusBarColor(r, g, b, 0.8)
												oUF_LUI_player.Vengeance.bg:SetVertexColor(r*mu, g*mu, b*mu, 1)
											end,
											order = 10,
										},
										BGMultiplier = {
											name = "Background Multiplier",
											desc = "Choose the Multiplier which will be used to generate the Background Color.\nDefault: "..LUI.defaults.profile.oUF.Player.Vengeance.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Player.Vengeance.BGMultiplier end,
											set = function(_,BGMultiplier)
												db.oUF.Player.Vengeance.BGMultiplier = BGMultiplier
												
												local r, g, b = oUF_LUI_player.Vengeance:GetStatusBarColor()
												oUF_LUI_player.Vengeance.bg:SetVertexColor(r * BGMultiplier, g * BGMultiplier, b * BGMultiplier, 1)
											end,
											order = 11,
										},
									},
								},
							},
						},
					},
				},
				Texts = {
					args = {
						DruidMana = {
							name = "DruidMana",
							type = "group",
							disabled = function() return not(class == "DRUID") end,
							hidden = function() return not(class == "DRUID") end,
							order = 7.5,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the your Mana Value while in Cat/Bear or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.Texts.DruidMana.Enable end,
									set = function(self,Enable)
										db.oUF.Player.Texts.DruidMana.Enable = Enable
										if Enable then
											oUF_LUI_player.DruidMana.value:Show()
										else
											oUF_LUI_player.DruidMana.value:Hide()
										end
									end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.Texts.DruidMana.Enable end,
									guiInline = true,
									order = 2,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your DruidMana Fontsize!\n Default: "..LUI.defaults.profile.oUF.Player.Texts.DruidMana.Size,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Player.Texts.DruidMana.Size end,
											set = function(_, FontSize)
												db.oUF.Player.Texts.DruidMana.Size = FontSize
												oUF_LUI_player.DruidMana:SetFont(LSM:Fetch("font", db.oUF.Player.Texts.DruidMana.Font), db.oUF.Player.Texts.DruidMana.Size, db.oUF.Player.Texts.DruidMana.Outline)
											end,
											order = 1,
										},
										empty = {
											name = " ",
											type = "description",
											width = "full",
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your DruidMana Font!\n\nDefault: "..LUI.defaults.profile.oUF.Player.Texts.DruidMana.Font,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Player.Texts.DruidMana.Font end,
											set = function(self, Font)
												db.oUF.Player.Texts.DruidMana.Font = Font
												oUF_LUI_player.DruidMana:SetFont(LSM:Fetch("font", db.oUF.Player.Texts.DruidMana.Font), db.oUF.Player.Texts.DruidMana.Size, db.oUF.Player.Texts.DruidMana.Outline)
											end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the DruidMana Font Flag.\nDefault: "..LUI.defaults.profile.oUF.Player.Texts.DruidMana.Outline,
											type = "select",
											values = fontflags,
											get = function()
												for k, v in pairs(fontflags) do
													if db.oUF.Player.Texts.DruidMana.Outline == v then
														return k
													end
												end
											end,
											set = function(self, FontFlag)
												db.oUF.Player.Texts.DruidMana.Outline = fontflags[FontFlag]
												oUF_LUI_player.DruidMana:SetFont(LSM:Fetch("font", db.oUF.Player.Texts.DruidMana.Font), db.oUF.Player.Texts.DruidMana.Size, db.oUF.Player.Texts.DruidMana.Outline)
											end,
											order = 4,
										},
										XValue = {
											name = "X Value",
											desc = "Choose the X Value for your DruidMana.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.Texts.DruidMana.X,
											type = "input",
											get = function() return db.oUF.Player.Texts.DruidMana.X end,
											set = function(self,XValue)
												if XValue == nil or XValue == "" then XValue = "0" end
												db.oUF.Player.Texts.DruidMana.X = XValue
												oUF_LUI_player.DruidMana:ClearAllPoints()
												oUF_LUI_player.DruidMana:SetPoint(db.oUF.Player.Texts.DruidMana.Point, oUF_LUI_player, db.oUF.Player.Texts.DruidMana.RelativePoint, tonumber(XValue), tonumber(db.oUF.Player.Texts.DruidMana.Y))
											end,
											order = 5,
										},
										YValue = {
											name = "Y Value",
											desc = "Choose the Y Value for your DruidMana.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.Texts.DruidMana.Y,
											type = "input",
											get = function() return db.oUF.Player.Texts.DruidMana.Y end,
											set = function(self,YValue)
												if YValue == nil or YValue == "" then YValue = "0" end
												db.oUF.Player.Texts.DruidMana.Y = YValue
												oUF_LUI_player.DruidMana:ClearAllPoints()
												oUF_LUI_player.DruidMana:SetPoint(db.oUF.Player.Texts.DruidMana.Point, oUF_LUI_player, db.oUF.Player.Texts.DruidMana.RelativePoint, tonumber(db.oUF.Player.Texts.DruidMana.X), tonumber(YValue))
											end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your DruidMana text.\nDefault: "..LUI.defaults.profile.oUF.Player.Texts.DruidMana.Point,
											type = "select",
											values = positions,
											get = function()
												for k, v in pairs(positions) do
													if db.oUF.Player.Texts.DruidMana.Point == v then
														return k
													end
												end
											end,
											set = function(self, Point)
												db.oUF.Player.Texts.DruidMana.Point = positions[Point]
												oUF_LUI_player.Power.value:ClearAllPoints()
												oUF_LUI_player.Power.value:SetPoint(db.oUF.Player.Texts.DruidMana.Point, oUF_LUI_player, db.oUF.Player.Texts.DruidMana.RelativePoint, tonumber(db.oUF.Player.Texts.DruidMana.X), tonumber(db.oUF.Player.Texts.DruidMana.Y))
											end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your DruidMana text.\nDefault: "..LUI.defaults.profile.oUF.Player.Texts.DruidMana.RelativePoint,
											type = "select",
											values = positions,
											get = function()
												for k, v in pairs(positions) do
													if db.oUF.Player.Texts.DruidMana.RelativePoint == v then
														return k
													end
												end
											end,
											set = function(self, RelativePoint)
												db.oUF.Player.Texts.DruidMana.RelativePoint = positions[RelativePoint]
												oUF_LUI_player.Power.value:ClearAllPoints()
												oUF_LUI_player.Power.value:SetPoint(db.oUF.Player.Texts.DruidMana.Point, oUF_LUI_player, db.oUF.Player.Texts.DruidMana.RelativePoint, tonumber(db.oUF.Player.Texts.DruidMana.X), tonumber(db.oUF.Player.Texts.DruidMana.Y))
											end,
											order = 8,
										},
									},
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.Texts.DruidMana.Enable end,
									guiInline = true,
									order = 3,
									args = {
										Format = {
											name = "Format",
											desc = "Choose the format for your DruidMana text.",
											type = "select",
											values = valueFormat,
											get = function()
												for k, v in pairs(valueFormat) do
													if db.oUF.Player.Texts.DruidMana.Format == v then
														return k
													end
												end
											end,
											set = function(self, Format)
												db.oUF.Player.Texts.DruidMana.Format = valueFormat[Format]
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 1,
										},
										empty = {
											name = " ",
											type = "description",
											width = "full",
											order = 2,
										},
										HideIfFullMana = {
											name = "Hide If Full Mana",
											desc = "Wether you want to hide your DruidMana text when you have full Mana or not.",
											type = "toggle",
											get = function() return db.oUF.Player.Texts.DruidMana.HideIfFullMana end,
											set = function(self,HideIfFullMana)
												db.oUF.Player.Texts.DruidMana.HideIfFullMana = HideIfFullMana
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 3,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.Texts.DruidMana.Enable end,
									guiInline = true,
									order = 4,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored DruidMana Value or not.",
											type = "toggle",
											get = function() return db.oUF.Player.Texts.DruidMana.ColorClass end,
											set = function(self,ClassColor)
												db.oUF.Player.Texts.DruidMana.ColorClass = true
												db.oUF.Player.Texts.DruidMana.ColorType = false
												db.oUF.Player.Texts.DruidMana.IndividualColor.Enable = false
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Powertype colored DruidMana Value or not.",
											type = "toggle",
											get = function() return db.oUF.Player.Texts.DruidMana.ColorType end,
											set = function(self,ColorType)
												db.oUF.Player.Texts.DruidMana.ColorType = true
												db.oUF.Player.Texts.DruidMana.ColorClass = false
												db.oUF.Player.Texts.DruidMana.IndividualColor.Enable = false
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual DruidMana Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Player.Texts.DruidMana.IndividualColor.Enable end,
											set = function(self,IndividualColor)
												db.oUF.Player.Texts.DruidMana.IndividualColor.Enable = true
												db.oUF.Player.Texts.DruidMana.ColorClass = false
												db.oUF.Player.Texts.DruidMana.ColorType = false
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual DruidMana Value Color.",
											type = "color",
											disabled = function() return not db.oUF.Player.Texts.DruidMana.IndividualColor.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Player.Texts.DruidMana.IndividualColor.r, db.oUF.Player.Texts.DruidMana.IndividualColor.g, db.oUF.Player.Texts.DruidMana.IndividualColor.b end,
											set = function(_,r,g,b)
												db.oUF.Player.Texts.DruidMana.IndividualColor.r = r
												db.oUF.Player.Texts.DruidMana.IndividualColor.g = g
												db.oUF.Player.Texts.DruidMana.IndividualColor.b = b
												oUF_LUI_player:UpdateAllElements()
											end,
											order = 4,
										},
									},
								},
							},
						},
						PvPTimer = {
							name = "PvPTimer",
							type = "group",
							disabled = function() return not db.oUF.Player.Icons.PvP.Enable end,
							order = 10,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show a timer next to your PvP Icon when you're flaged or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.Texts.PvP.Enable end,
									set = function(self,Enable)
										db.oUF.Player.Texts.PvP.Enable = Enable
									end,
									order = 1,
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Player.Texts.PvP.Enable end,
									guiInline = true,
									order = 2,
									args = {
										XValue = {
											name = "X Value",
											desc = "Choose the X Value for your PvP Timer.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.Texts.PvP.X,
											type = "input",
											get = function() return db.oUF.Player.Texts.PvP.X end,
											set = function(self,XValue)
												if XValue == nil or XValue == "" then XValue = "0" end
												db.oUF.Player.Texts.PvP.X = XValue
												oUF_LUI_player.PvP.Timer:ClearAllPoints()
												oUF_LUI_player.PvP.Timer:SetPoint("CENTER", oUF_LUI_player.PvP, "CENTER", tonumber(XValue), tonumber(db.oUF.Player.Texts.PvP.Y))
											end,
											order = 1,
										},
										YValue = {
											name = "Y Value",
											desc = "Choose the Y Value for your PvP Timer.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.Texts.PvP.Y,
											type = "input",
											get = function() return db.oUF.Player.Texts.PvP.Y end,
											set = function(self,YValue)
												if YValue == nil or YValue == "" then YValue = "0" end
												db.oUF.Player.Texts.PvP.Y = YValue
												oUF_LUI_player.PvP.Timer:ClearAllPoints()
												oUF_LUI_player.PvP.Timer:SetPoint("CENTER", oUF_LUI_player.PvP, "CENTER", tonumber(db.oUF.Player.Texts.PvP.X), tonumber(YValue))
											end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your PvP Timer Font!\n\nDefault: "..LUI.defaults.profile.oUF.Player.Texts.PvP.Font,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Player.Texts.PvP.Font end,
											set = function(self, Font)
												db.oUF.Player.Texts.PvP.Font = Font
												oUF_LUI_player.PvP.Timer:SetFont(LSM:Fetch("font", db.oUF.Player.Texts.PvP.Font), db.oUF.Player.Texts.PvP.Size, db.oUF.Player.Texts.PvP.Outline)
											end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the PvP Timer Font Flag.\nDefault: "..LUI.defaults.profile.oUF.Player.Texts.PvP.Outline,
											type = "select",
											values = fontflags,
											get = function()
												for k, v in pairs(fontflags) do
													if db.oUF.Player.Texts.PvP.Outline == v then
														return k
													end
												end
											end,
											set = function(self, FontFlag)
												db.oUF.Player.Texts.PvP.Outline = fontflags[FontFlag]
												oUF_LUI_player.PvP.Timer:SetFont(LSM:Fetch("font", db.oUF.Player.Texts.PvP.Font), db.oUF.Player.Texts.PvP.Size, db.oUF.Player.Texts.PvP.Outline)
											end,
											order = 4,
										},
										FontSize = {
											name = "Size",
											desc = "Choose your PvP Timer Fontsize!\n Default: "..LUI.defaults.profile.oUF.Player.Texts.PvP.Size,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Player.Texts.PvP.Size end,
											set = function(_, FontSize)
												db.oUF.Player.Texts.PvP.Size = FontSize
												oUF_LUI_player.PvP.Timer:SetFont(LSM:Fetch("font", db.oUF.Player.Texts.PvP.Font), db.oUF.Player.Texts.PvP.Size, db.oUF.Player.Texts.PvP.Outline)
											end,
											order = 5,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PvP Timer Color.",
											type = "color",
											hasAlpha = false,
											get = function() return db.oUF.Player.Texts.PvP.Color.r, db.oUF.Player.Texts.PvP.Color.g, db.oUF.Player.Texts.PvP.Color.b end,
											set = function(_,r,g,b)
												db.oUF.Player.Texts.PvP.Color.r = r
												db.oUF.Player.Texts.PvP.Color.g = g
												db.oUF.Player.Texts.PvP.Color.b = b
												
												oUF_LUI_player.PvP.Timer:SetTextColor(r,g,b)
											end,
											order = 6,
										},
									},
								},
							},
						},
					},
				},
				Castbar = {
					args = {
						CastbarColors = {
							args = {
								Colors = {
									args = {
										CBLatencyColor = {
											name = "Castbar Latency Color",
											desc = "Choose an individual Castbar-Latency-Color.\n\nDefaults: "..LUI.defaults.profile.oUF.Player.Castbar.Colors.Latency.r.." / "..LUI.defaults.profile.oUF.Player.Castbar.Colors.Latency.g.." / "..LUI.defaults.profile.oUF.Player.Castbar.Colors.Latency.b.." / "..1-LUI.defaults.profile.oUF.Player.Castbar.Colors.Latency.a,
											type = "color",
											width = "full",
											disabled = function() return not db.oUF.Player.Castbar.IndividualColor end,
											hasAlpha = true,
											get = function() return db.oUF.Player.Castbar.Colors.Latency.r, db.oUF.Player.Castbar.Colors.Latency.g, db.oUF.Player.Castbar.Colors.Latency.b, db.oUF.Player.Castbar.Colors.Latency.a end,
											set = function(_,r,g,b,a)
													db.oUF.Player.Castbar.Colors.Latency.r = r
													db.oUF.Player.Castbar.Colors.Latency.g = g
													db.oUF.Player.Castbar.Colors.Latency.b = b
													db.oUF.Player.Castbar.Colors.Latency.a = a
													oUF_LUI_player.Castbar.SafeZone:SetVertexColor(r,g,b,a) 
												end,
											order = 4,
										},
									},
								},
							},
						},
					},
				},
				Icons = {
					args = {
						Resting = {
							name = "Resting",
							type = "group",
							order = 6,
							args = {
								RestingEnable = {
									name = "Enable",
									desc = "Wether you want to show the Resting Icon or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.Icons.Resting.Enable end,
									set = function(self,RestingEnable)
										db.oUF.Player.Icons.Resting.Enable = RestingEnable
										if not oUF_LUI_player.Resting then oUF_LUI_player.CreateResting() end
										if RestingEnable then
											oUF_LUI_player:EnableElement("Resting")
										else
											oUF_LUI_player:DisableElement("Resting")
											oUF_LUI_player.Resting:Hide()
										end
										oUF_LUI_player:UpdateAllElements()
									end,
									order = 1,
								},
								RestingX = {
									name = "X Value",
									desc = "X Value for your Resting Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.Icons.Resting.X,
									type = "input",
									disabled = function() return not db.oUF.Player.Icons.Resting.Enable end,
									get = function() return db.oUF.Player.Icons.Resting.X end,
									set = function(self,RestingX)
										if RestingX == nil or RestingX == "" then RestingX = "0" end
										db.oUF.Player.Icons.Resting.X = RestingX
										oUF_LUI_player.Resting:ClearAllPoints()
										oUF_LUI_player.Resting:SetPoint(db.oUF.Player.Icons.Resting.Point, oUF_LUI_player, db.oUF.Player.Icons.Resting.Point, tonumber(RestingX), tonumber(db.oUF.Player.Icons.Resting.Y))
									end,
									order = 2,
								},
								RestingY = {
									name = "Y Value",
									desc = "Y Value for your Resting Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.Icons.Resting.Y,
									type = "input",
									disabled = function() return not db.oUF.Player.Icons.Resting.Enable end,
									get = function() return db.oUF.Player.Icons.Resting.Y end,
									set = function(self,RestingY)
										if RestingY == nil or RestingY == "" then RestingY = "0" end
										db.oUF.Player.Icons.Resting.Y = RestingY
										oUF_LUI_player.Resting:ClearAllPoints()
										oUF_LUI_player.Resting:SetPoint(db.oUF.Player.Icons.Resting.Point, oUF_LUI_player, db.oUF.Player.Icons.Resting.Point, tonumber(db.oUF.Player.Icons.Resting.X), tonumber(RestingY))
									end,
									order = 3,
								},
								RestingPoint = {
									name = "Position",
									desc = "Choose the Position for your Resting Icon.\nDefault: "..LUI.defaults.profile.oUF.Player.Icons.Resting.Point,
									type = "select",
									disabled = function() return not db.oUF.Player.Icons.Resting.Enable end,
									values = positions,
									get = function()
										for k, v in pairs(positions) do
											if db.oUF.Player.Icons.Resting.Point == v then
												return k
											end
										end
									end,
									set = function(self, RestingPoint)
										db.oUF.Player.Icons.Resting.Point = positions[RestingPoint]
										oUF_LUI_player.Resting:ClearAllPoints()
										oUF_LUI_player.Resting:SetPoint(db.oUF.Player.Icons.Resting.Point, oUF_LUI_player, db.oUF.Player.Icons.Resting.Point, tonumber(db.oUF.Player.Icons.Resting.X), tonumber(db.oUF.Player.Icons.Resting.Y))
									end,
									order = 4,
								},
								RestingSize = {
									name = "Size",
									desc = "Choose a Size for your Resting Icon.\nDefault: "..LUI.defaults.profile.oUF.Player.Icons.Resting.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.Player.Icons.Resting.Enable end,
									get = function() return db.oUF.Player.Icons.Resting.Size end,
									set = function(_, RestingSize) 
										db.oUF.Player.Icons.Resting.Size = RestingSize
										oUF_LUI_player.Resting:SetHeight(RestingSize)
										oUF_LUI_player.Resting:SetWidth(RestingSize)
									end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.Player.Icons.Resting.Enable end,
									desc = "Toggles the Resting Icon",
									type = 'execute',
									func = function() if oUF_LUI_player.Resting:IsShown() then oUF_LUI_player.Resting:Hide() else oUF_LUI_player.Resting:Show() end end
								},
							},
						},
						Combat = {
							name = "Combat",
							type = "group",
							order = 7,
							args = {
								CombatEnable = {
									name = "Enable",
									desc = "Wether you want to show the Combat Icon or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Player.Icons.Combat.Enable end,
									set = function(self,CombatEnable)
										db.oUF.Player.Icons.Combat.Enable = CombatEnable
										if not oUF_LUI_player.Combat then oUF_LUI_player.CreateCombat() end
										if CombatEnable then
											oUF_LUI_player:EnableElement("Combat")
										else
											oUF_LUI_player:DisableElement("Combat")
											oUF_LUI_player.Combat:Hide()
										end
										oUF_LUI_player:UpdateAllElements()
										end,
									order = 1,
								},
								CombatX = {
									name = "X Value",
									desc = "X Value for your Combat Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Player.Icons.Combat.X,
									type = "input",
									disabled = function() return not db.oUF.Player.Icons.Combat.Enable end,
									get = function() return db.oUF.Player.Icons.Combat.X end,
									set = function(self,CombatX)
										if CombatX == nil or CombatX == "" then CombatX = "0" end
										db.oUF.Player.Icons.Combat.X = CombatX
										oUF_LUI_player.Combat:ClearAllPoints()
										oUF_LUI_player.Combat:SetPoint(db.oUF.Player.Icons.Combat.Point, oUF_LUI_player, db.oUF.Player.Icons.Combat.Point, tonumber(CombatX), tonumber(db.oUF.Player.Icons.Combat.Y))
									end,
									order = 2,
								},
								CombatY = {
									name = "Y Value",
									desc = "Y Value for your Combat Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Player.Icons.Combat.Y,
									type = "input",
									disabled = function() return not db.oUF.Player.Icons.Combat.Enable end,
									get = function() return db.oUF.Player.Icons.Combat.Y end,
									set = function(self,CombatY)
										if CombatY == nil or CombatY == "" then CombatY = "0" end
										db.oUF.Player.Icons.Combat.Y = CombatY
										oUF_LUI_player.Combat:ClearAllPoints()
										oUF_LUI_player.Combat:SetPoint(db.oUF.Player.Icons.Combat.Point, oUF_LUI_player, db.oUF.Player.Icons.Combat.Point, tonumber(db.oUF.Player.Icons.Combat.X), tonumber(CombatY))
									end,
									order = 3,
								},
								CombatPoint = {
									name = "Position",
									desc = "Choose the Position for your Combat Icon.\nDefault: "..LUI.defaults.profile.oUF.Player.Icons.Combat.Point,
									type = "select",
									disabled = function() return not db.oUF.Player.Icons.Combat.Enable end,
									values = positions,
									get = function()
										for k, v in pairs(positions) do
											if db.oUF.Player.Icons.Combat.Point == v then
												return k
											end
										end
									end,
									set = function(self, CombatPoint)
										db.oUF.Player.Icons.Combat.Point = positions[CombatPoint]
										oUF_LUI_player.Combat:ClearAllPoints()
										oUF_LUI_player.Combat:SetPoint(db.oUF.Player.Icons.Combat.Point, oUF_LUI_player, db.oUF.Player.Icons.Combat.Point, tonumber(db.oUF.Player.Icons.Combat.X), tonumber(db.oUF.Player.Icons.Combat.Y))
									end,
									order = 4,
								},
								CombatSize = {
									name = "Size",
									desc = "Choose a Size for your Combat Icon.\nDefault: "..LUI.defaults.profile.oUF.Player.Icons.Combat.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.Player.Icons.Combat.Enable end,
									get = function() return db.oUF.Player.Icons.Combat.Size end,
									set = function(_, CombatSize) 
										db.oUF.Player.Icons.Combat.Size = CombatSize
										oUF_LUI_player.Combat:SetHeight(CombatSize)
										oUF_LUI_player.Combat:SetWidth(CombatSize)
									end,
									order = 5,
								},
								toggle = {
									order = 6,
									disabled = function() return not db.oUF.Player.Icons.Combat.Enable end,
									name = "Show/Hide",
									desc = "Toggles the Combat Icon",
									type = 'execute',
									func = function() if oUF_LUI_player.Combat:IsShown() then oUF_LUI_player.Combat:Hide() else oUF_LUI_player.Combat:Show() end end
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

function module:OnInitialize()
	LUI:MergeDefaults(LUI.db.defaults.profile.oUF, defaults)
	LUI:RefreshDefaults()
	LUI:Refresh()
	
	self.db = LUI.db.profile
	db = self.db
	
	Forte = LUI:GetModule("Forte")
	
	LUI:RegisterUnitFrame(self)
end