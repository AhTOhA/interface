--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: target.lua
	Description: oUF Target Module
	Version....: 1.0
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local module = LUI:NewModule("oUF_Target")
local LSM = LibStub("LibSharedMedia-3.0")
local widgetLists = AceGUIWidgetLSMlists

local defaults = {
	Target = {
		Height = "43",
		Width = "250",
		X = "200",
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
				r = "0",
				g = "0",
				b = "0",
				a = "1",
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
			Tapping = false,
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
				r = "0.11",
				g = "0.11",
				b = "0.11",
				a = "1",
			},
		},
		ComboPoints = {
			Enable = true,
			ShowAlways = false,
			X = "0",
			Y = "0.5",
			Height = "5",
			Width = "249",
			Texture = "LUI_Ruben",
			Padding = 1,
			Multiplier = 0.4,
			BackgroundColor = {
				Enable = true,
				r = 0.23,
				g = 0.23,
				b = 0.23,
			},
		},
		Aura = {
			buffs_colorbytype = false,
			buffs_playeronly = false,
			buffs_enable = true,
			buffs_auratimer = false,
			buffs_disableCooldown = false,
			buffs_cooldownReverse = true,
			buffsX = "-0.5",
			buffsY = "30",
			buffs_initialAnchor = "TOPLEFT",
			buffs_growthY = "UP",
			buffs_growthX = "RIGHT",
			buffs_size = "26",
			buffs_spacing = "2",
			buffs_num = "36",
			debuffs_colorbytype = false,
			debuffs_playeronly = false,
			debuffs_enable = true,
			debuffs_auratimer = false,
			debuffs_disableCooldown = false,
			debuffs_cooldownReverse = true,
			debuffsX = "-0.5",
			debuffsY = "60",
			debuffs_initialAnchor = "TOPRIGHT",
			debuffs_growthY = "UP",
			debuffs_growthX = "LEFT",
			debuffs_size = "26",
			debuffs_spacing = "2",
			debuffs_num = "36",
		},
		Castbar = {
			Enable = true,
			Height = "33",
			Width = "360",
			X = "13",
			Y = "205",
			Texture = "LUI_Gradient",
			TextureBG = "LUI_Minimalist",
			IndividualColor = false,
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
			Width = "90",
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
				Enable = true,
				Font = "Prototype",
				Size = 25,
				X = "5",
				Y = "0",
				IndividualColor = {
					Enable = true,
					r = "0",
					g = "0",
					b = "0",
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
					r = "1",
					g = "1",
					b = "1",
				},
				Outline = "NONE",
				Point = "BOTTOMLEFT",
				RelativePoint = "BOTTOMLEFT",
				Format = "Standard",
				ShowDead = false,
			},
			Power = {
				Enable = true,
				Font = "Prototype",
				Size = 21,
				X = "0",
				Y = "-51",
				ShowAlways = true,
				ColorClass = true,
				ColorType = false,
				IndividualColor = {
					Enable = false,
					r = "0",
					g = "0",
					b = "0",
				},
				Outline = "NONE",
				Point = "BOTTOMLEFT",
				RelativePoint = "BOTTOMLEFT",
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
					r = "1",
					g = "1",
					b = "1",
				},
				Outline = "NONE",
				Point = "CENTER",
				RelativePoint = "CENTER",
				ShowDead = true,
			},
			PowerPercent = {
				Enable = false,
				Font = "Prototype",
				Size = 24,
				X = "0",
				Y = "0",
				ShowAlways = false,
				ColorClass = false,
				ColorType = false,
				IndividualColor = {
					Enable = true,
					r = "0",
					g = "0",
					b = "0",
				},
				Outline = "NONE",
				Point = "CENTER",
				RelativePoint = "CENTER",
			},
			HealthMissing = {
				Enable = false,
				Font = "Prototype",
				Size = 24,
				X = "0",
				Y = "0",
				ShortValue = true,
				ShowAlways = false,
				ColorClass = false,
				ColorGradient = false,
				IndividualColor = {
					Enable = true,
					r = "0",
					g = "0",
					b = "0",
				},
				Outline = "NONE",
				Point = "RIGHT",
				RelativePoint = "RIGHT",
			},
			PowerMissing = {
				Enable = false,
				Font = "Prototype",
				Size = 24,
				X = "0",
				Y = "0",
				ShortValue = true,
				ShowAlways = false,
				ColorClass = false,
				ColorType = false,
				IndividualColor = {
					Enable = true,
					r = "0",
					g = "0",
					b = "0",
				},
				Outline = "NONE",
				Point = "RIGHT",
				RelativePoint = "RIGHT",
			},
			Combat = {
				Enable = false,
				Font = "vibrocen",
				Outline = "OUTLINE",
				Size = 20,
				Point = "CENTER",
				RelativePoint = "BOTTOM",
				X = "0",
				Y = "0",
				ShowDamage = true,
				ShowHeal = true,
				ShowImmune = true,
				ShowEnergize = true,
				ShowOther = true,
				MaxAlpha = 0.6,
			},
		},
	},
}

function module:LoadOptions()
	local options = {
		Target = {
			args = {
				Bars = {
					args = {
						Health = {
							args = {
								Colors = {
									args = {
										Tapping = {
											name = "Enable Tapping",
											desc = "Wether you want to show Tapped Healthbars or not.",
											type = "toggle",
											get = function() return db.oUF.Target.Health.Tapping end,
											set = function(self,Tapping)
												db.oUF.Target.Health.Tapping = Tapping
												oUF_LUI_target.Health.colorTapping = Tapping
												oUF_LUI_target:UpdateAllElements()
											end,
											order = 5,
										},
									},
								},
							},
						},
						ComboPoints = {
							name = "Combo Points",
							type = "group",
							order = 11,
							args = {
								ComboPoints = {
									name = "Enable",
									desc = "Whether you want to show your ComboPoint Bar or not.\n",
									type = "toggle",
									get = function() return db.oUF.Target.ComboPoints.Enable end,
									set = function(self,Enable)
										db.oUF.Target.ComboPoints.Enable = Enable
										if not oUF_LUI_target.CPoints then oUF_LUI_target.CreateCPoints() end
										if Enable then
											oUF_LUI_target:EnableElement("CPoints")
										else
											oUF_LUI_target:DisableElement("CPoints")
											oUF_LUI_target.CPoints:Hide()
										end
										oUF_LUI_target:UpdateAllElements()
									end,
									order = 1,
								},
								ShowAlways = {
									name = "Show Always",
									desc = "Whether you want to always show your ComboPoint Bar or not.\n",
									type = "toggle",
									disabled = function() return not db.oUF.Target.ComboPoints.Enable end,
									get = function() return db.oUF.Target.ComboPoints.ShowAlways end,
									set = function(self,ShowAlways)
										db.oUF.Target.ComboPoints.ShowAlways = ShowAlways
										oUF_LUI_target.CPoints.showAlways = ShowAlways
										oUF_LUI_target:UpdateAllElements()
									end,
									order = 2,
								},
								empty = {
									name = " ",
									width = "full",
									type = "description",
									order = 3,
								},
								desc = {
									name = "|cff3399ffImportant:|r\nTo Change the Color for each ComboPoint\nplease go to UnitFrames->Colors->Other",
									width = "full",
									type = "description",
									order = 4,
								},
								empty2 = {
									name = " ",
									width = "full",
									type = "description",
									order = 5,
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Target.ComboPoints.Enable end,
									guiInline = true,
									order = 6,
									args = {
										XValue = {
											name = "X Value",
											desc = "Choose the X Value for your ComboPoints.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Target.ComboPoints.X,
											type = "input",
											get = function() return db.oUF.Target.ComboPoints.X end,
											set = function(self,XValue)
												if XValue == nil or XValue == "" then XValue = "0" end
												db.oUF.Target.ComboPoints.X = XValue
												oUF_LUI_target.CPoints:SetPoint("BOTTOMLEFT", oUF_LUI_target, "TOPLEFT", db.oUF.Target.ComboPoints.X, db.oUF.Target.ComboPoints.Y)
											end,
											order = 2,
										},
										YValue = {
											name = "Y Value",
											desc = "Choose the Y Value for your ComboPoints.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Target.ComboPoints.Y,
											type = "input",
											get = function() return db.oUF.Target.ComboPoints.Y end,
											set = function(self,YValue)
												if YValue == nil or YValue == "" then YValue = "0" end
												db.oUF.Target.ComboPoints.Y = YValue
												oUF_LUI_target.CPoints:SetPoint("BOTTOMLEFT", oUF_LUI_target, "TOPLEFT", db.oUF.Target.ComboPoints.X, db.oUF.Target.ComboPoints.Y)
											end,
											order = 3,
										},
										Width = {
											name = "Width",
											desc = "Choose your ComboPoints Width.\n\nDefault: "..LUI.defaults.profile.oUF.Target.ComboPoints.Width,
											type = "input",
											get = function() return db.oUF.Target.ComboPoints.Width end,
											set = function(self,Width)
												if Width == nil or Width == "" then Width = "0" end
												db.oUF.Target.ComboPoints.Width = Width
												oUF_LUI_target.CPoints:SetWidth(tonumber(Width))
												for i = 1, 5 do
													oUF_LUI_target.CPoints[i]:SetWidth((tonumber(Width) -4*db.oUF.Target.ComboPoints.Padding) / 5)
												end
											end,
											order = 4,
										},
										Height = {
											name = "Height",
											desc = "Choose your ComboPoints Height.\n\nDefault: "..LUI.defaults.profile.oUF.Target.ComboPoints.Height,
											type = "input",
											get = function() return db.oUF.Target.ComboPoints.Height end,
											set = function(self,Height)
												if Height == nil or Height == "" then Height = "0" end
												db.oUF.Target.ComboPoints.Height = Height
												oUF_LUI_target.CPoints:SetHeight(Height)
												for i = 1, 5 do	
													oUF_LUI_target.CPoints[i]:SetHeight(Height)
												end
											end,
											order = 5,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between your ComboPoints Segments!\n Default: "..LUI.defaults.profile.oUF.Target.ComboPoints.Padding,
											type = "range",
											min = 1,
											max = 10,
											step = 1,
											get = function() return db.oUF.Target.ComboPoints.Padding end,
											set = function(_, Padding)
												db.oUF.Target.ComboPoints.Padding = Padding
												for i = 1, 5 do
													oUF_LUI_target.CPoints[i]:SetWidth((tonumber(db.oUF.Target.ComboPoints.Width) -4*Padding) / 5)
													if i ~= 1 then
														oUF_LUI_target.CPoints[i]:SetPoint("LEFT", oUF_LUI_target.CPoints[i-1], "RIGHT", Padding, 0)
													end
												end
											end,
											order = 6,
										},
										empty = {
											name = " ",
											type = "description",
											order = 7,
										},
										Texture = {
											name = "Texture",
											desc = "Choose your ComboPoints Texture!\nDefault: "..LUI.defaults.profile.oUF.Target.ComboPoints.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function() return db.oUF.Target.ComboPoints.Texture end,
											set = function(self, Texture)
												db.oUF.Target.ComboPoints.Texture = Texture
												for i = 1, 5 do
													oUF_LUI_target.CPoints[i]:SetStatusBarTexture(LSM:Fetch("statusbar", Texture))
													oUF_LUI_target.CPoints[i].bg:SetTexture(LSM:Fetch("statusbar", Texture))
												end
											end,
											order = 8,
										},
										Multiplier = {
											name = "Multiplier",
											desc = "Choose your ComboPoints Background Multiplier!\n Default: "..LUI.defaults.profile.oUF.Target.ComboPoints.Multiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											disabled = function() return db.oUF.Target.ComboPoints.BackgroundColor.Enable end,
											get = function() return db.oUF.Target.ComboPoints.Multiplier end,
											set = function(_, Multiplier)
												db.oUF.Target.ComboPoints.Multiplier = Multiplier
												for i = 1, 5 do
													local r, g, b = unpack(db.oUF.Colors.ComboPoints[i])
													oUF_LUI_target.CPoints[i].bg:SetVertexColor(r*Multiplier, g*Multiplier, b*Multiplier)
												end
											end,
											order = 9,
										},
										IndividualBackgroundColor = {
											name = "Individual Background Color",
											desc = "Wether you want to use an individual Background Color or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Target.ComboPoints.BackgroundColor.Enable end,
											set = function(self,IndividualBackgroundColor)
												db.oUF.Target.ComboPoints.BackgroundColor.Enable = IndividualBackgroundColor
												if IndividualBackgroundColor then
													local r = db.oUF.Target.ComboPoints.BackgroundColor.r
													local g = db.oUF.Target.ComboPoints.BackgroundColor.g
													local b = db.oUF.Target.ComboPoints.BackgroundColor.b
													
													for i = 1, 5 do
														oUF_LUI_target.CPoints[i].bg:SetVertexColor(r, g, b)
													end
												else
													for i = 1, 5 do
														local r, g, b = unpack(db.oUF.Colors.ComboPoints[i])
														local mu = db.oUF.Target.ComboPoints.Multiplier
														oUF_LUI_target.CPoints[i].bg:SetVertexColor(r*mu, g*mu, b*mu)
													end
												end
											end,
											order = 10,
										},
										BackgroundColor = {
											name = "Individual Color",
											desc = "Choose an individual Background Color Value Color.",
											type = "color",
											disabled = function() return not db.oUF.Target.ComboPoints.BackgroundColor.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Target.ComboPoints.BackgroundColor.r, db.oUF.Target.ComboPoints.BackgroundColor.g, db.oUF.Target.ComboPoints.BackgroundColor.b end,
											set = function(_,r,g,b)
												db.oUF.Target.ComboPoints.BackgroundColor.r = r
												db.oUF.Target.ComboPoints.BackgroundColor.g = g
												db.oUF.Target.ComboPoints.BackgroundColor.b = b
												
												for i = 1, 5 do
													oUF_LUI_target.CPoints[i].bg:SetVertexColor(r, g, b)
												end
											end,
											order = 11,
										},
									},
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
	
	LUI:RegisterUnitFrame(self)
end