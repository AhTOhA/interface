--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: party.lua
	Description: oUF Party Module
	Version....: 1.0
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local module = LUI:NewModule("oUF_Party")
local LSM = LibStub("LibSharedMedia-3.0")
local widgetLists = AceGUIWidgetLSMlists

local db

local positions = {"TOP", "TOPRIGHT", "TOPLEFT","BOTTOM", "BOTTOMRIGHT", "BOTTOMLEFT","RIGHT", "LEFT", "CENTER"}
local fontflags = {'OUTLINE', 'THICKOUTLINE', 'MONOCHROME', 'NONE'}
local valueFormat = {'Absolut', 'Absolut & Percent', 'Absolut Short', 'Absolut Short & Percent', 'Standard', 'Standard Short'}
local nameFormat = {'Name', 'Name + Level', 'Name + Level + Class', 'Name + Level + Race + Class', 'Level + Name', 'Level + Name + Class', 'Level + Class + Name', 'Level + Name + Race + Class', 'Level + Race + Class + Name'}
local nameLenghts = {'Short', 'Medium', 'Long'}
local growthY = {"UP", "DOWN"}
local growthX = {"LEFT", "RIGHT"}

local defaults = {
	Party = {
		Enable = true,
		UseBlizzard = false,
		Height = "43",
		Width = "170",
		X = "150",
		Y = "100",
		Padding = "50",
		ShowPlayer = false,
		ShowInRaid = false,
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
			Height = "14",
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
		Aura = {
			buffs_playeronly = false,
			buffs_auratimer = false,
			buffs_enable = false,
			buffsX = "0",
			buffsY = "-42",
			buffs_initialAnchor = "BOTTOMLEFT",
			buffs_growthY = "DOWN",
			buffs_growthX = "RIGHT",
			buffs_size = "26",
			buffs_spacing = "2",
			buffs_num = "8",
			debuffs_colorbytype = true,
			debuffs_auratimer = false,
			debuffs_enable = true,
			debuffsX = "35",
			debuffsY = "-5",
			debuffs_initialAnchor = "RIGHT",
			debuffs_growthY = "DOWN",
			debuffs_growthX = "RIGHT",
			debuffs_size = "26",
			debuffs_spacing = "2",
			debuffs_num = "36",
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
				Size = 16,
				X = "17",
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
				Enable = true,
				Font = "Prototype",
				Size = 19,
				X = "0",
				Y = "-20",
				IndividualColor = {
					Enable = true,
					r = "0",
					g = "0",
					b = "0",
				},
				Outline = "OUTLINE",
				Point = "CENTER",
				RelativePoint = "CENTER",
				Format = "Name",
				Length = "Medium",
				ColorNameByClass = true,
				ColorClassByClass = false,
				ColorLevelByDifficulty = false,
				ShowClassification = false,
				ShortClassification = false,
			},
			Health = {
				Enable = false,
				Font = "Prototype",
				Size = 24,
				X = "0",
				Y = "-43",
				ColorClass = false,
				ColorGradient = false,
				IndividualColor = {
					Enable = true,
					r = "0",
					g = "0",
					b = "0",
				},
				Outline = "NONE",
				Point = "BOTTOMLEFT",
				RelativePoint = "BOTTOMRIGHT",
				Format = "Absolut Short",
				ShowDead = false,
			},
			Power = {
				Enable = false,
				Font = "Prototype",
				Size = 24,
				X = "0",
				Y = "-66",
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
				RelativePoint = "BOTTOMRIGHT",
				Format = "Absolut Short",
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
		},
	},	
}

function module:LoadOptions()
	local options = {
		Party = {
			name = "Party",
			type = "group",
			disabled = function() return not db.oUF.Settings.Enable end,
			order = 28,
			childGroups = "tab",
			args = {
				header1 = {
					name = "Party",
					type = "header",
					order = 1,
				},
				General = {
					name = "General",
					type = "group",
					childGroups = "tab",
					order = 2,
					args = {
						General = {
							name = "General",
							type = "group",
							order = 0,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to use a Party Frame or not.",
									type = "toggle",
									get = function() return db.oUF.Party.Enable end,
									set = function(self,Enable)
												db.oUF.Party.Enable = not db.oUF.Party.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								UseBlizzard = {
									name = "Use Blizzard Party Frames",
									desc = "Wether you want to use the Blizzard Party Frames or no Party Frames.",
									type = "toggle",
									disabled = function() return db.oUF.Party.Enable end,
									get = function() return db.oUF.Party.UseBlizzard end,
									set = function(self,UseBlizzard)
										db.oUF.Party.UseBlizzard = UseBlizzard
										if UseBlizzard == true then
											LUI:GetModule("oUF"):EnableBlizzard("party")
										else
											oUF:DisableBlizzard("party")
										end
									end,
									order = 1.5,
								},
								ShowPlayer = {
									name = "Show Player",
									disabled = function() return not db.oUF.Party.Enable end,
									desc = "Wether you want to show your Player within the Party Frame or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.ShowPlayer end,
									set = function(self,ShowPlayer)
												db.oUF.Party.ShowPlayer = not db.oUF.Party.ShowPlayer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 2,
								},
								ShowInRaid = {
									name = "Show in Raid",
									disabled = function() return not db.oUF.Party.Enable end,
									desc = "Wether you want to show your Party Frame while in Raids with more than 5 Players or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.ShowInRaid end,
									set = function(self,ShowInRaid)
												db.oUF.Party.ShowInRaid = not db.oUF.Party.ShowInRaid
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								Padding = {
									name = "Padding",
									disabled = function() return not db.oUF.Party.Enable end,
									desc = "Choose the Padding between your Partymembers.\nDefault: "..LUI.defaults.profile.oUF.Party.Padding,
									type = "input",
									get = function() return db.oUF.Party.Padding end,
									set = function(self,Padding)
												if Padding == nil or Padding == "" then
													Padding = "0"
												end
												db.oUF.Party.Padding = Padding
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
							},
						},
						Positioning = {
							name = "Positioning",
							type = "group",
							disabled = function() return not db.oUF.Party.Enable end,
							order = 1,
							args = {
								header1 = {
									name = "Frame Position",
									type = "header",
									order = 1,
								},
								PartyX = {
									name = "X Value",
									desc = "X Value for your Party Frame.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.X,
									type = "input",
									get = function() return db.oUF.Party.X end,
									set = function(self,PartyX)
												if PartyX == nil or PartyX == "" then
													PartyX = "0"
												end
												db.oUF.Party.X = PartyX
												oUF_LUI_party:ClearAllPoints()
												oUF_LUI_party:SetPoint("LEFT", UIParent, "LEFT", tonumber(PartyX), tonumber(db.oUF.Party.Y))
											end,
									order = 2,
								},
								PartyY = {
									name = "Y Value",
									desc = "Y Value for your Party Frame.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Y,
									type = "input",
									get = function() return db.oUF.Party.Y end,
									set = function(self,PartyY)
												if PartyY == nil or PartyY == "" then
													PartyY = "0"
												end
												db.oUF.Party.Y = PartyY
												oUF_LUI_party:ClearAllPoints()
												oUF_LUI_party:SetPoint("LEFT", UIParent, "LEFT", tonumber(db.oUF.Party.X), tonumber(PartyY))
											end,
									order = 3,
								},
							},
						},
						Size = {
							name = "Size",
							type = "group",
							disabled = function() return not db.oUF.Party.Enable end,
							order = 2,
							args = {
								header1 = {
									name = "Frame Height/Width",
									type = "header",
									order = 1,
								},
								PartyHeight = {
									name = "Height",
									desc = "Decide the Height of your Party Frame.\n\nDefault: "..LUI.defaults.profile.oUF.Party.Height,
									type = "input",
									get = function() return db.oUF.Party.Height end,
									set = function(self,PartyHeight)
												if PartyHeight == nil or PartyHeight == "" then
													PartyHeight = "0"
												end
												db.oUF.Party.Height = PartyHeight
												oUF_LUI_partyUnitButton1:SetHeight(tonumber(PartyHeight))
											end,
									order = 2,
								},
								PartyWidth = {
									name = "Width",
									desc = "Decide the Width of your Party Frame.\n\nDefault: "..LUI.defaults.profile.oUF.Party.Width,
									type = "input",
									get = function() return db.oUF.Party.Width end,
									set = function(self,PartyWidth)
												if PartyWidth == nil or PartyWidth == "" then
													PartyWidth = "0"
												end
												db.oUF.Party.Width = PartyWidth
												oUF_LUI_partyUnitButton1:SetWidth(tonumber(PartyWidth))
												
												if db.oUF.Party.Aura.buffs_enable == true then
													oUF_LUI_partyUnitButton1.Buffs:SetWidth(tonumber(PartyWidth))
												end
												
												if db.oUF.Party.Aura.debuffs_enable == true then
													oUF_LUI_partyUnitButton1.Debuffs:SetWidth(tonumber(PartyWidth))
												end
											end,
									order = 3,
								},
							},
						},
						Appearance = {
							name = "Appearance",
							type = "group",
							disabled = function() return not db.oUF.Party.Enable end,
							order = 3,
							args = {
								header1 = {
									name = "Backdrop Colors",
									type = "header",
									order = 1,
								},
								BackdropColor = {
									name = "Color",
									desc = "Choose a Backdrop Color.",
									type = "color",
									width = "full",
									hasAlpha = true,
									get = function() return db.oUF.Party.Backdrop.Color.r, db.oUF.Party.Backdrop.Color.g, db.oUF.Party.Backdrop.Color.b, db.oUF.Party.Backdrop.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.Party.Backdrop.Color.r = r
											db.oUF.Party.Backdrop.Color.g = g
											db.oUF.Party.Backdrop.Color.b = b
											db.oUF.Party.Backdrop.Color.a = a

											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropColor(r,g,b,a)
										end,
									order = 2,
								},
								BackdropBorderColor = {
									name = "Border Color",
									desc = "Choose a Backdrop Border Color.",
									type = "color",
									hasAlpha = true,
									get = function() return db.oUF.Party.Border.Color.r, db.oUF.Party.Border.Color.g, db.oUF.Party.Border.Color.b, db.oUF.Party.Border.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.Party.Border.Color.r = r
											db.oUF.Party.Border.Color.g = g
											db.oUF.Party.Border.Color.b = b
											db.oUF.Party.Border.Color.a = a
											
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Party.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Party.Border.EdgeFile), edgeSize = tonumber(db.oUF.Party.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Party.Border.Insets.Left), right = tonumber(db.oUF.Party.Border.Insets.Right), top = tonumber(db.oUF.Party.Border.Insets.Top), bottom = tonumber(db.oUF.Party.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Party.Backdrop.Color.r), tonumber(db.oUF.Party.Backdrop.Color.g), tonumber(db.oUF.Party.Backdrop.Color.b), tonumber(db.oUF.Party.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Party.Border.Color.r), tonumber(db.oUF.Party.Border.Color.g), tonumber(db.oUF.Party.Border.Color.b), tonumber(db.oUF.Party.Border.Color.a))
										end,
									order = 3,
								},
								AggroGlow = {
									name = "Aggro Glow",
									desc = "Wether you want the border color to change if you get aggro or not.",
									type = "toggle",
									get = function() return db.oUF.Party.Border.Aggro end,
									set = function(self, aggro)
											db.oUF.Party.Border.Aggro = not db.oUF.Party.Border.Aggro
										end,
									order = 4,
								},
								header2 = {
									name = "Backdrop Settings",
									type = "header",
									order = 5,
								},
								BackdropTexture = {
									name = "Backdrop Texture",
									desc = "Choose your Backdrop Texture!\nDefault: "..LUI.defaults.profile.oUF.Party.Backdrop.Texture,
									type = "select",
									dialogControl = "LSM30_Background",
									values = widgetLists.background,
									get = function() return db.oUF.Party.Backdrop.Texture end,
									set = function(self, BackdropTexture)
											db.oUF.Party.Backdrop.Texture = BackdropTexture
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Party.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Party.Border.EdgeFile), edgeSize = tonumber(db.oUF.Party.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Party.Border.Insets.Left), right = tonumber(db.oUF.Party.Border.Insets.Right), top = tonumber(db.oUF.Party.Border.Insets.Top), bottom = tonumber(db.oUF.Party.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Party.Backdrop.Color.r), tonumber(db.oUF.Party.Backdrop.Color.g), tonumber(db.oUF.Party.Backdrop.Color.b), tonumber(db.oUF.Party.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Party.Border.Color.r), tonumber(db.oUF.Party.Border.Color.g), tonumber(db.oUF.Party.Border.Color.b), tonumber(db.oUF.Party.Border.Color.a))
										end,
									order = 6,
								},
								BorderTexture = {
									name = "Border Texture",
									desc = "Choose your Border Texture!\nDefault: "..LUI.defaults.profile.oUF.Party.Border.EdgeFile,
									type = "select",
									dialogControl = "LSM30_Border",
									values = widgetLists.border,
									get = function() return db.oUF.Party.Border.EdgeFile end,
									set = function(self, BorderTexture)
											db.oUF.Party.Border.EdgeFile = BorderTexture
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Party.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Party.Border.EdgeFile), edgeSize = tonumber(db.oUF.Party.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Party.Border.Insets.Left), right = tonumber(db.oUF.Party.Border.Insets.Right), top = tonumber(db.oUF.Party.Border.Insets.Top), bottom = tonumber(db.oUF.Party.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Party.Backdrop.Color.r), tonumber(db.oUF.Party.Backdrop.Color.g), tonumber(db.oUF.Party.Backdrop.Color.b), tonumber(db.oUF.Party.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Party.Border.Color.r), tonumber(db.oUF.Party.Border.Color.g), tonumber(db.oUF.Party.Border.Color.b), tonumber(db.oUF.Party.Border.Color.a))
										end,
									order = 7,
								},
								BorderSize = {
									name = "Edge Size",
									desc = "Choose the Edge Size for your Frame Border.\nDefault: "..LUI.defaults.profile.oUF.Party.Border.EdgeSize,
									type = "range",
									min = 1,
									max = 50,
									step = 1,
									get = function() return db.oUF.Party.Border.EdgeSize end,
									set = function(_, BorderSize) 
											db.oUF.Party.Border.EdgeSize = BorderSize
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Party.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Party.Border.EdgeFile), edgeSize = tonumber(db.oUF.Party.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Party.Border.Insets.Left), right = tonumber(db.oUF.Party.Border.Insets.Right), top = tonumber(db.oUF.Party.Border.Insets.Top), bottom = tonumber(db.oUF.Party.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Party.Backdrop.Color.r), tonumber(db.oUF.Party.Backdrop.Color.g), tonumber(db.oUF.Party.Backdrop.Color.b), tonumber(db.oUF.Party.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Party.Border.Color.r), tonumber(db.oUF.Party.Border.Color.g), tonumber(db.oUF.Party.Border.Color.b), tonumber(db.oUF.Party.Border.Color.a))
										end,
									order = 8,
								},
								header3 = {
									name = "Backdrop Padding",
									type = "header",
									order = 9,
								},
								PaddingLeft = {
									name = "Left",
									desc = "Value for the Left Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.Party.Backdrop.Padding.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.Party.Backdrop.Padding.Left end,
									set = function(self,PaddingLeft)
										if PaddingLeft == nil or PaddingLeft == "" then
											PaddingLeft = "0"
										end
										db.oUF.Party.Backdrop.Padding.Left = PaddingLeft
										oUF_LUI_partyUnitButton1.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1, "TOPLEFT", tonumber(db.oUF.Party.Backdrop.Padding.Left), tonumber(db.oUF.Party.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1, "BOTTOMRIGHT", tonumber(db.oUF.Party.Backdrop.Padding.Right), tonumber(db.oUF.Party.Backdrop.Padding.Bottom))
									end,
									order = 10,
								},
								PaddingRight = {
									name = "Right",
									desc = "Value for the Right Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.Party.Backdrop.Padding.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.Party.Backdrop.Padding.Right end,
									set = function(self,PaddingRight)
										if PaddingRight == nil or PaddingRight == "" then
											PaddingRight = "0"
										end
										db.oUF.Party.Backdrop.Padding.Right = PaddingRight
										oUF_LUI_partyUnitButton1.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1, "TOPLEFT", tonumber(db.oUF.Party.Backdrop.Padding.Left), tonumber(db.oUF.Party.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1, "BOTTOMRIGHT", tonumber(db.oUF.Party.Backdrop.Padding.Right), tonumber(db.oUF.Party.Backdrop.Padding.Bottom))
									end,
									order = 11,
								},
								PaddingTop = {
									name = "Top",
									desc = "Value for the Top Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.Party.Backdrop.Padding.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.Party.Backdrop.Padding.Top end,
									set = function(self,PaddingTop)
										if PaddingTop == nil or PaddingTop == "" then
											PaddingTop = "0"
										end
										db.oUF.Party.Backdrop.Padding.Top = PaddingTop
										oUF_LUI_partyUnitButton1.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1, "TOPLEFT", tonumber(db.oUF.Party.Backdrop.Padding.Left), tonumber(db.oUF.Party.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1, "BOTTOMRIGHT", tonumber(db.oUF.Party.Backdrop.Padding.Right), tonumber(db.oUF.Party.Backdrop.Padding.Bottom))
									end,
									order = 12,
								},
								PaddingBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.Party.Backdrop.Padding.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.Party.Backdrop.Padding.Bottom end,
									set = function(self,PaddingBottom)
										if PaddingBottom == nil or PaddingBottom == "" then
											PaddingBottom = "0"
										end
										db.oUF.Party.Backdrop.Padding.Bottom = PaddingBottom
										oUF_LUI_partyUnitButton1.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1, "TOPLEFT", tonumber(db.oUF.Party.Backdrop.Padding.Left), tonumber(db.oUF.Party.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1, "BOTTOMRIGHT", tonumber(db.oUF.Party.Backdrop.Padding.Right), tonumber(db.oUF.Party.Backdrop.Padding.Bottom))
									end,
									order = 13,
								},
								header4 = {
									name = "Boder Insets",
									type = "header",
									order = 14,
								},
								InsetLeft = {
									name = "Left",
									desc = "Value for the Left Border Inset\nDefault: "..LUI.defaults.profile.oUF.Party.Border.Insets.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.Party.Border.Insets.Left end,
									set = function(self,InsetLeft)
										if InsetLeft == nil or InsetLeft == "" then
											InsetLeft = "0"
										end
										db.oUF.Party.Border.Insets.Left = InsetLeft
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Party.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Party.Border.EdgeFile), edgeSize = tonumber(db.oUF.Party.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Party.Border.Insets.Left), right = tonumber(db.oUF.Party.Border.Insets.Right), top = tonumber(db.oUF.Party.Border.Insets.Top), bottom = tonumber(db.oUF.Party.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Party.Backdrop.Color.r), tonumber(db.oUF.Party.Backdrop.Color.g), tonumber(db.oUF.Party.Backdrop.Color.b), tonumber(db.oUF.Party.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Party.Border.Color.r), tonumber(db.oUF.Party.Border.Color.g), tonumber(db.oUF.Party.Border.Color.b), tonumber(db.oUF.Party.Border.Color.a))
											end,
									order = 15,
								},
								InsetRight = {
									name = "Right",
									desc = "Value for the Right Border Inset\nDefault: "..LUI.defaults.profile.oUF.Party.Border.Insets.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.Party.Border.Insets.Right end,
									set = function(self,InsetRight)
										if InsetRight == nil or InsetRight == "" then
											InsetRight = "0"
										end
										db.oUF.Party.Border.Insets.Right = InsetRight
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Party.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Party.Border.EdgeFile), edgeSize = tonumber(db.oUF.Party.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Party.Border.Insets.Left), right = tonumber(db.oUF.Party.Border.Insets.Right), top = tonumber(db.oUF.Party.Border.Insets.Top), bottom = tonumber(db.oUF.Party.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Party.Backdrop.Color.r), tonumber(db.oUF.Party.Backdrop.Color.g), tonumber(db.oUF.Party.Backdrop.Color.b), tonumber(db.oUF.Party.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Party.Border.Color.r), tonumber(db.oUF.Party.Border.Color.g), tonumber(db.oUF.Party.Border.Color.b), tonumber(db.oUF.Party.Border.Color.a))
											end,
									order = 16,
								},
								InsetTop = {
									name = "Top",
									desc = "Value for the Top Border Inset\nDefault: "..LUI.defaults.profile.oUF.Party.Border.Insets.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.Party.Border.Insets.Top end,
									set = function(self,InsetTop)
										if InsetTop == nil or InsetTop == "" then
											InsetTop = "0"
										end
										db.oUF.Party.Border.Insets.Top = InsetTop
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Party.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Party.Border.EdgeFile), edgeSize = tonumber(db.oUF.Party.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Party.Border.Insets.Left), right = tonumber(db.oUF.Party.Border.Insets.Right), top = tonumber(db.oUF.Party.Border.Insets.Top), bottom = tonumber(db.oUF.Party.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Party.Backdrop.Color.r), tonumber(db.oUF.Party.Backdrop.Color.g), tonumber(db.oUF.Party.Backdrop.Color.b), tonumber(db.oUF.Party.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Party.Border.Color.r), tonumber(db.oUF.Party.Border.Color.g), tonumber(db.oUF.Party.Border.Color.b), tonumber(db.oUF.Party.Border.Color.a))
											end,
									order = 17,
								},
								InsetBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Border Inset\nDefault: "..LUI.defaults.profile.oUF.Party.Border.Insets.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.Party.Border.Insets.Bottom end,
									set = function(self,InsetBottom)
										if InsetBottom == nil or InsetBottom == "" then
											InsetBottom = "0"
										end
										db.oUF.Party.Border.Insets.Bottom = InsetBottom
										oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Party.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Party.Border.EdgeFile), edgeSize = tonumber(db.oUF.Party.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Party.Border.Insets.Left), right = tonumber(db.oUF.Party.Border.Insets.Right), top = tonumber(db.oUF.Party.Border.Insets.Top), bottom = tonumber(db.oUF.Party.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Party.Backdrop.Color.r), tonumber(db.oUF.Party.Backdrop.Color.g), tonumber(db.oUF.Party.Backdrop.Color.b), tonumber(db.oUF.Party.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Party.Border.Color.r), tonumber(db.oUF.Party.Border.Color.g), tonumber(db.oUF.Party.Border.Color.b), tonumber(db.oUF.Party.Border.Color.a))
											end,
									order = 18,
								},
							},
						},
						AlphaFader = {
							name = "Fader",
							type = "group",
							disabled = function() return not db.oUF.Party.Enable end,
							order = 4,
							args = {
								empty = {
									order = 1,
									width = "full",
									type = "description",
									name = "\n\n    coming soon...",
								},
							},
						},
					},
				},
				Bars = {
					name = "Bars",
					type = "group",
					childGroups = "tab",
					disabled = function() return not db.oUF.Party.Enable end,
					order = 3,
					args = {
						Health = {
							name = "Health",
							type = "group",
							order = 1,
							args = {
								General = {
									name = "General Settings",
									type = "group",
									guiInline = true,
									order = 1,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your Party Health.\n\nDefault: "..LUI.defaults.profile.oUF.Party.Health.Height,
											type = "input",
											get = function() return db.oUF.Party.Health.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.Party.Health.Height = Height
														oUF_LUI_partyUnitButton1.Health:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Health.Padding,
											type = "input",
											get = function() return db.oUF.Party.Health.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.Party.Health.Padding = Padding
														oUF_LUI_partyUnitButton1.Health:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Health:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1, "TOPLEFT", 0, tonumber(Padding))
														oUF_LUI_partyUnitButton1.Health:SetPoint("TOPRIGHT", oUF_LUI_partyUnitButton1, "TOPRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Party.Health.Smooth end,
											set = function(self,Smooth)
														db.oUF.Party.Health.Smooth = not db.oUF.Party.Health.Smooth
														StaticPopup_Show("RELOAD_UI")
													end,
											order = 3,
										},
									}
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									guiInline = true,
									order = 2,
									args = {
										HealthClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthBars or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Health.ColorClass end,
											set = function(self,HealthClassColor)
														db.oUF.Party.Health.ColorClass = true
														db.oUF.Party.Health.ColorGradient = false
														db.oUF.Party.Health.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Health.colorClass = true
														oUF_LUI_partyUnitButton1.Health.colorGradient = false
														oUF_LUI_partyUnitButton1.Health.colorIndividual.Enable = false
															
														print("Party Healthbar Color will change once you gain/lose HP")
													end,
											order = 1,
										},
										HealthGradientColor = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthBars or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Health.ColorGradient end,
											set = function(self,HealthGradientColor)
														db.oUF.Party.Health.ColorGradient = true
														db.oUF.Party.Health.ColorClass = false
														db.oUF.Party.Health.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Health.colorGradient = true
														oUF_LUI_partyUnitButton1.Health.colorClass = false
														oUF_LUI_partyUnitButton1.Health.colorIndividual.Enable = false
															
														print("Party Healthbar Color will change once you gain/lose HP")
													end,
											order = 2,
										},
										IndividualHealthColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual HealthBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Health.IndividualColor.Enable end,
											set = function(self,IndividualHealthColor)
														db.oUF.Party.Health.IndividualColor.Enable = true
														db.oUF.Party.Health.ColorClass = false
														db.oUF.Party.Health.ColorGradient = false
															
														oUF_LUI_partyUnitButton1.Health.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1.Health.colorClass = false
														oUF_LUI_partyUnitButton1.Health.colorGradient = false
															
														oUF_LUI_partyUnitButton1.Health:SetStatusBarColor(db.oUF.Party.Health.IndividualColor.r, db.oUF.Party.Health.IndividualColor.g, db.oUF.Party.Health.IndividualColor.b)
														oUF_LUI_partyUnitButton1.Health.bg:SetVertexColor(db.oUF.Party.Health.IndividualColor.r*tonumber(db.oUF.Party.Health.BGMultiplier), db.oUF.Party.Health.IndividualColor.g*tonumber(db.oUF.Party.Health.BGMultiplier), db.oUF.Party.Health.IndividualColor.b*tonumber(db.oUF.Party.Health.BGMultiplier))
													end,
											order = 3,
										},
										HealthColor = {
											name = "Individual Color",
											desc = "Choose an individual Healthbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Party.Health.IndividualColor.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Party.Health.IndividualColor.r, db.oUF.Party.Health.IndividualColor.g, db.oUF.Party.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Party.Health.IndividualColor.r = r
													db.oUF.Party.Health.IndividualColor.g = g
													db.oUF.Party.Health.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1.Health.colorIndividual.r = r
													oUF_LUI_partyUnitButton1.Health.colorIndividual.g = g
													oUF_LUI_partyUnitButton1.Health.colorIndividual.b = b
														
													oUF_LUI_partyUnitButton1.Health:SetStatusBarColor(r, g, b)
													oUF_LUI_partyUnitButton1.Health.bg:SetVertexColor(r*tonumber(db.oUF.Party.Health.BGMultiplier), g*tonumber(db.oUF.Party.Health.BGMultiplier), b*tonumber(db.oUF.Party.Health.BGMultiplier))
												end,
											order = 4,
										},
									},
								},
								Textures = {
									name = "Texture Settings",
									type = "group",
									guiInline = true,
									order = 3,
									args = {
										HealthTex = {
											name = "Texture",
											desc = "Choose your Health Texture!\nDefault: "..LUI.defaults.profile.oUF.Party.Health.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.Party.Health.Texture
												end,
											set = function(self, HealthTex)
													db.oUF.Party.Health.Texture = HealthTex
													oUF_LUI_partyUnitButton1.Health:SetStatusBarTexture(LSM:Fetch("statusbar", HealthTex))
												end,
											order = 1,
										},
										HealthTexBG = {
											name = "Background Texture",
											desc = "Choose your Health Background Texture!\nDefault: "..LUI.defaults.profile.oUF.Party.Health.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.Party.Health.TextureBG
												end,
											set = function(self, HealthTexBG)
													db.oUF.Party.Health.TextureBG = HealthTexBG
													oUF_LUI_partyUnitButton1.Health.bg:SetTexture(LSM:Fetch("statusbar", HealthTexBG))
												end,
											order = 2,
										},
										HealthTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Health Background.\nDefault: "..LUI.defaults.profile.oUF.Party.Health.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Party.Health.BGAlpha end,
											set = function(_, HealthTexBGAlpha) 
													db.oUF.Party.Health.BGAlpha  = HealthTexBGAlpha
													oUF_LUI_partyUnitButton1.Health.bg:SetAlpha(tonumber(HealthTexBGAlpha))
												end,
											order = 3,
										},
										HealthTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.Party.Health.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Party.Health.BGMultiplier end,
											set = function(_, HealthTexBGMultiplier) 
													db.oUF.Party.Health.BGMultiplier  = HealthTexBGMultiplier
													oUF_LUI_partyUnitButton1.Health.bg.multiplier = tonumber(HealthTexBGMultiplier)
												end,
											order = 4,
										},
									},
								},
							},
						},
						Power = {
							name = "Power",
							type = "group",
							order = 2,
							args = {
								EnablePower = {
									name = "Enable",
									desc = "Wether you want to use a Powerbar or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Power.Enable end,
									set = function(self,EnablePower)
												db.oUF.Party.Power.Enable = not db.oUF.Party.Power.Enable
												if EnablePower == true then
													oUF_LUI_partyUnitButton1.Power:Show()
												else
													oUF_LUI_partyUnitButton1.Power:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "General Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Power.Enable end,
									guiInline = true,

									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your Party Power.\n\nDefault: "..LUI.defaults.profile.oUF.Party.Power.Height,
											type = "input",
											get = function() return db.oUF.Party.Power.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.Party.Power.Height = Height
														oUF_LUI_partyUnitButton1.Power:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Power.Padding,
											type = "input",
											get = function() return db.oUF.Party.Power.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.Party.Power.Padding = Padding
														oUF_LUI_partyUnitButton1.Power:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Power:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1.Health, "BOTTOMLEFT", 0, tonumber(Padding))
														oUF_LUI_partyUnitButton1.Power:SetPoint("TOPRIGHT", oUF_LUI_partyUnitButton1.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Party.Power.Smooth end,
											set = function(self,Smooth)
														db.oUF.Party.Power.Smooth = not db.oUF.Party.Power.Smooth
														StaticPopup_Show("RELOAD_UI")
													end,
											order = 3,
										},
									}
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Power.Enable end,
									guiInline = true,
									order = 3,
									args = {
										PowerClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Power.ColorClass end,
											set = function(self,PowerClassColor)
														db.oUF.Party.Power.ColorClass = true
														db.oUF.Party.Power.ColorType = false
														db.oUF.Party.Power.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Power.colorClass = true
														oUF_LUI_partyUnitButton1.Power.colorType = false
														oUF_LUI_partyUnitButton1.Power.colorIndividual.Enable = false
														
														print("Party Powerbar Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										PowerColorByType = {
											name = "Color by Type",
											desc = "Wether you want to use Power Type colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Power.ColorType end,
											set = function(self,PowerColorByType)
														db.oUF.Party.Power.ColorType = true
														db.oUF.Party.Power.ColorClass = false
														db.oUF.Party.Power.IndividualColor.Enable = false
																
														oUF_LUI_partyUnitButton1.Power.colorType = true
														oUF_LUI_partyUnitButton1.Power.colorClass = false
														oUF_LUI_partyUnitButton1.Power.colorIndividual.Enable = false
															
														print("Party Powerbar Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualPowerColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PowerBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Power.IndividualColor.Enable end,
											set = function(self,IndividualPowerColor)
														db.oUF.Party.Power.IndividualColor.Enable = true
														db.oUF.Party.Power.ColorType = false
														db.oUF.Party.Power.ColorClass = false
																
														oUF_LUI_partyUnitButton1.Power.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1.Power.colorClass = false
														oUF_LUI_partyUnitButton1.Power.colorType = false
															
														oUF_LUI_partyUnitButton1.Power:SetStatusBarColor(db.oUF.Party.Power.IndividualColor.r, db.oUF.Party.Power.IndividualColor.g, db.oUF.Party.Power.IndividualColor.b)
														oUF_LUI_partyUnitButton1.Power.bg:SetVertexColor(db.oUF.Party.Power.IndividualColor.r*tonumber(db.oUF.Party.Power.BGMultiplier), db.oUF.Party.Power.IndividualColor.g*tonumber(db.oUF.Party.Power.BGMultiplier), db.oUF.Party.Power.IndividualColor.b*tonumber(db.oUF.Party.Power.BGMultiplier))
													end,
											order = 3,
										},
										PowerColor = {
											name = "Individual Color",
											desc = "Choose an individual Powerbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Party.Power.IndividualColor.Enable or not db.oUF.Party.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Party.Power.IndividualColor.r, db.oUF.Party.Power.IndividualColor.g, db.oUF.Party.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Party.Power.IndividualColor.r = r
													db.oUF.Party.Power.IndividualColor.g = g
													db.oUF.Party.Power.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1.Power.colorIndividual.r = r
													oUF_LUI_partyUnitButton1.Power.colorIndividual.g = g
													oUF_LUI_partyUnitButton1.Power.colorIndividual.b = b
														
													oUF_LUI_partyUnitButton1.Power:SetStatusBarColor(r, g, b)
													oUF_LUI_partyUnitButton1.Power.bg:SetVertexColor(r*tonumber(db.oUF.Party.Power.BGMultiplier), g*tonumber(db.oUF.Party.Power.BGMultiplier), b*tonumber(db.oUF.Party.Power.BGMultiplier))
												end,
											order = 4,
										},
									},
								},
								Textures = {
									name = "Texture Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Power.Enable end,
									guiInline = true,
									order = 4,
									args = {
										PowerTex = {
											name = "Texture",
											desc = "Choose your Power Texture!\nDefault: "..LUI.defaults.profile.oUF.Party.Power.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.Party.Power.Texture
												end,
											set = function(self, PowerTex)
													db.oUF.Party.Power.Texture = PowerTex
													oUF_LUI_partyUnitButton1.Power:SetStatusBarTexture(LSM:Fetch("statusbar", PowerTex))
												end,
											order = 1,
										},
										PowerTexBG = {
											name = "Background Texture",
											desc = "Choose your Power Background Texture!\nDefault: "..LUI.defaults.profile.oUF.Party.Power.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.Party.Power.TextureBG
												end,

											set = function(self, PowerTexBG)
													db.oUF.Party.Power.TextureBG = PowerTexBG
													oUF_LUI_partyUnitButton1.Power.bg:SetTexture(LSM:Fetch("statusbar", PowerTexBG))
												end,
											order = 2,
										},
										PowerTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Power Background.\nDefault: "..LUI.defaults.profile.oUF.Party.Power.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Party.Power.BGAlpha end,
											set = function(_, PowerTexBGAlpha) 
													db.oUF.Party.Power.BGAlpha  = PowerTexBGAlpha
													oUF_LUI_partyUnitButton1.Power.bg:SetAlpha(tonumber(PowerTexBGAlpha))
												end,
											order = 3,
										},
										PowerTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.Party.Power.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Party.Power.BGMultiplier end,
											set = function(_, PowerTexBGMultiplier) 
													db.oUF.Party.Power.BGMultiplier  = PowerTexBGMultiplier
													oUF_LUI_partyUnitButton1.Power.bg.multiplier = tonumber(PowerTexBGMultiplier)
												end,
											order = 4,
										},
									},
								},
							},
						},
						Full = {
							name = "Fullbar",
							type = "group",
							order = 3,
							args = {
								EnableFullbar = {
									name = "Enable",
									desc = "Wether you want to use a Fullbar or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Full.Enable end,
									set = function(self,EnableFullbar)
												db.oUF.Party.Full.Enable = not db.oUF.Party.Full.Enable
												if EnableFullbar == true then
													oUF_LUI_partyUnitButton1_Full:Show()
												else
													oUF_LUI_partyUnitButton1_Full:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Full.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your Fullbar.\n\nDefault: "..LUI.defaults.profile.oUF.Party.Full.Height,
											type = "input",
											get = function() return db.oUF.Party.Full.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.Party.Full.Height = Height
														oUF_LUI_partyUnitButton1_Full:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Fullbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Full.Padding,
											type = "input",
											get = function() return db.oUF.Party.Full.Padding end,
											set = function(self,Padding)
													if Padding == nil or Padding == "" then
														Padding = "0"
													end
													db.oUF.Party.Full.Padding = Padding
													oUF_LUI_partyUnitButton1_Full:ClearAllPoints()
													oUF_LUI_partyUnitButton1_Full:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1.Health, "BOTTOMLEFT", 0, tonumber(Padding))
													oUF_LUI_partyUnitButton1_Full:SetPoint("TOPRIGHT", oUF_LUI_partyUnitButton1.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
												end,
											order = 2,
										},
										FullTex = {
											name = "Texture",
											desc = "Choose your Fullbar Texture!\nDefault: "..LUI.defaults.profile.oUF.Party.Full.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.Party.Full.Texture
												end,
											set = function(self, FullTex)
													db.oUF.Party.Full.Texture = FullTex
													oUF_LUI_partyUnitButton1_Full:SetStatusBarTexture(LSM:Fetch("statusbar", FullTex))
												end,
											order = 3,
										},
										FullAlpha = {
											name = "Alpha",
											desc = "Choose the Alpha Value for your Fullbar!\n Default: "..LUI.defaults.profile.oUF.Party.Full.Alpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Party.Full.Alpha end,
											set = function(_, FullAlpha)
													db.oUF.Party.Full.Alpha = FullAlpha
													oUF_LUI_partyUnitButton1_Full:SetAlpha(FullAlpha)
												end,
											order = 4,
										},
										Color = {
											name = "Color",
											desc = "Choose your Fullbar Color.",
											type = "color",
											hasAlpha = true,
											get = function() return db.oUF.Party.Full.Color.r, db.oUF.Party.Full.Color.g, db.oUF.Party.Full.Color.b, db.oUF.Party.Full.Color.a end,
											set = function(_,r,g,b,a)
													db.oUF.Party.Full.Color.r = r
													db.oUF.Party.Full.Color.g = g
													db.oUF.Party.Full.Color.b = b
													db.oUF.Party.Full.Color.a = a
													
													oUF_LUI_partyUnitButton1_Full:SetStatusBarColor(r, g, b, a)
												end,
											order = 5,
										},
									},
								},
							},
						},
					},
				},
				Texts = {
					name = "Texts",
					type = "group",
					childGroups = "tab",
					disabled = function() return not db.oUF.Party.Enable end,
					order = 6,
					args = {
						Name = {
							name = "Name",
							type = "group",
							order = 1,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the Party Name or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Texts.Name.Enable end,
									set = function(self,Enable)
												db.oUF.Party.Texts.Name.Enable = not db.oUF.Party.Texts.Name.Enable
												if Enable == true then
													oUF_LUI_partyUnitButton1.Info:Show()
												else
													oUF_LUI_partyUnitButton1.Info:Hide()
												end
											end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Party Name Fontsize!\n Default: "..LUI.defaults.profile.oUF.Party.Texts.Name.Size,
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Party.Texts.Name.Size end,
											set = function(_, FontSize)
													db.oUF.Party.Texts.Name.Size = FontSize
													oUF_LUI_partyUnitButton1.Info:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.Name.Font),db.oUF.Party.Texts.Name.Size,db.oUF.Party.Texts.Name.Outline)
												end,
											order = 1,
										},
										empty = {
											order = 2,
											width = "full",
											type = "description",
											name = " ",
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Party Name!\n\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Name.Font,
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Party.Texts.Name.Font end,
											set = function(self, Font)
													db.oUF.Party.Texts.Name.Font = Font
													oUF_LUI_partyUnitButton1.Info:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.Name.Font),db.oUF.Party.Texts.Name.Size,db.oUF.Party.Texts.Name.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Party Name.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Name.Outline,
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Party.Texts.Name.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Party.Texts.Name.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1.Info:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.Name.Font),db.oUF.Party.Texts.Name.Size,db.oUF.Party.Texts.Name.Outline)
												end,
											order = 4,
										},
										NameX = {
											name = "X Value",
											desc = "X Value for your Party Name.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Name.X,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											get = function() return db.oUF.Party.Texts.Name.X end,
											set = function(self,NameX)
														if NameX == nil or NameX == "" then
															NameX = "0"
														end
														db.oUF.Party.Texts.Name.X = NameX
														oUF_LUI_partyUnitButton1.Info:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Info:SetPoint(db.oUF.Party.Texts.Name.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Name.RelativePoint, tonumber(db.oUF.Party.Texts.Name.X), tonumber(db.oUF.Party.Texts.Name.Y))
													end,
											order = 5,
										},
										NameY = {
											name = "Y Value",
											desc = "Y Value for your Party Name.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Name.Y,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											get = function() return db.oUF.Party.Texts.Name.Y end,
											set = function(self,NameY)
														if NameY == nil or NameY == "" then
															NameY = "0"
														end
														db.oUF.Party.Texts.Name.Y = NameY
														oUF_LUI_partyUnitButton1.Info:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Info:SetPoint(db.oUF.Party.Texts.Name.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Name.RelativePoint, tonumber(db.oUF.Party.Texts.Name.X), tonumber(db.oUF.Party.Texts.Name.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Party Name.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Name.Point,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.Name.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Party.Texts.Name.Point = positions[Point]
													oUF_LUI_partyUnitButton1.Info:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Info:SetPoint(db.oUF.Party.Texts.Name.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Name.RelativePoint, tonumber(db.oUF.Party.Texts.Name.X), tonumber(db.oUF.Party.Texts.Name.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Party Name.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Name.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.Name.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Party.Texts.Name.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1.Info:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Info:SetPoint(db.oUF.Party.Texts.Name.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Name.RelativePoint, tonumber(db.oUF.Party.Texts.Name.X), tonumber(db.oUF.Party.Texts.Name.Y))
												end,
											order = 8,
										},
									},
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Format = {
											name = "Format",
											desc = "Choose the Format for your Party Name.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Name.Format,
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											type = "select",
											width = "full",
											values = nameFormat,

											get = function()
													for k, v in pairs(nameFormat) do
														if db.oUF.Party.Texts.Name.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.Party.Texts.Name.Format = nameFormat[Format]
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 1,
										},
										Length = {
											name = "Length",
											desc = "Choose the Length of your Party Name.\n\nShort = 6 Letters\nMedium = 18 Letters\nLong = 36 Letters\n\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Name.Length,
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											type = "select",
											values = nameLenghts,
											get = function()
													for k, v in pairs(nameLenghts) do
														if db.oUF.Party.Texts.Name.Length == v then
															return k
														end
													end
												end,
											set = function(self, Length)
													db.oUF.Party.Texts.Name.Length = nameLenghts[Length]
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 2,
										},
										empty = {
											order = 3,
											width = "full",
											type = "description",
											name = " ",
										},
										ColorNameByClass = {
											name = "Color Name by Class",
											desc = "Wether you want to color the Party Name by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											get = function() return db.oUF.Party.Texts.Name.ColorNameByClass end,
											set = function(self,ColorNameByClass)
													db.oUF.Party.Texts.Name.ColorNameByClass = not db.oUF.Party.Texts.Name.ColorNameByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 4,
										},
										ColorClassByClass = {
											name = "Color Class by Class",
											desc = "Wether you want to color the Party Class by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											get = function() return db.oUF.Party.Texts.Name.ColorClassByClass end,
											set = function(self,ColorClassByClass)
													db.oUF.Party.Texts.Name.ColorClassByClass = not db.oUF.Party.Texts.Name.ColorClassByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 5,
										},
										ColorLevelByDifficulty = {
											name = "Color Level by Difficulty",
											desc = "Wether you want to color the Level by Difficulty or not.",
											type = "toggle",
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											get = function() return db.oUF.Party.Texts.Name.ColorLevelByDifficulty end,
											set = function(self,ColorLevelByDifficulty)
													db.oUF.Party.Texts.Name.ColorLevelByDifficulty = not db.oUF.Party.Texts.Name.ColorLevelByDifficulty
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 6,
										},
										ShowClassification = {
											name = "Show Classification",
											desc = "Wether you want to show Classifications like Elite, Boss, Rar or not.",
											type = "toggle",
											disabled = function() return not db.oUF.Party.Texts.Name.Enable end,
											get = function() return db.oUF.Party.Texts.Name.ShowClassification end,
											set = function(self,ShowClassification)
													db.oUF.Party.Texts.Name.ShowClassification = not db.oUF.Party.Texts.Name.ShowClassification
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 7,
										},
										ShortClassification = {
											name = "Enable Short Classification",
											desc = "Wether you want to show short Classifications or not.",
											type = "toggle",
											width = "full",
											disabled = function() return not db.oUF.Party.Texts.Name.ShowClassification or not db.oUF.Party.Texts.Name.Enable end,
											get = function() return db.oUF.Party.Texts.Name.ShortClassification end,
											set = function(self,ShortClassification)
													db.oUF.Party.Texts.Name.ShortClassification = not db.oUF.Party.Texts.Name.ShortClassification
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 8,
										},
									},
								},
							},
						},
						Health = {
							name = "Health",
							type = "group",
							order = 2,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the Party Health or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Texts.Health.Enable end,
									set = function(self,Enable)
											db.oUF.Party.Texts.Health.Enable = not db.oUF.Party.Texts.Health.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1.Health.value:Show()
											else
												oUF_LUI_partyUnitButton1.Health.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.Health.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Party Health Fontsize!\n Default: "..LUI.defaults.profile.oUF.Party.Texts.Health.Size,
											disabled = function() return not db.oUF.Party.Texts.Health.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Party.Texts.Health.Size end,
											set = function(_, FontSize)
													db.oUF.Party.Texts.Health.Size = FontSize
													oUF_LUI_partyUnitButton1.Health.value:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.Health.Font),db.oUF.Party.Texts.Health.Size,db.oUF.Party.Texts.Health.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your Party Health.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Health.Format,
											disabled = function() return not db.oUF.Party.Texts.Health.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.Party.Texts.Health.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.Party.Texts.Health.Format = valueFormat[Format]
													oUF_LUI_partyUnitButton1.Health.value.Format = valueFormat[Format]
													print("Party Health Value Format will change once you gain/lose Health")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Party Health!\n\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Health.Font,
											disabled = function() return not db.oUF.Party.Texts.Health.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Party.Texts.Health.Font end,
											set = function(self, Font)
													db.oUF.Party.Texts.Health.Font = Font
													oUF_LUI_partyUnitButton1.Health.value:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.Health.Font),db.oUF.Party.Texts.Health.Size,db.oUF.Party.Texts.Health.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Party Health.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Health.Outline,
											disabled = function() return not db.oUF.Party.Texts.Health.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Party.Texts.Health.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Party.Texts.Health.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1.Health.value:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.Health.Font),db.oUF.Party.Texts.Health.Size,db.oUF.Party.Texts.Health.Outline)
												end,
											order = 4,
										},
										HealthX = {
											name = "X Value",
											desc = "X Value for your Party Health.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Health.X,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.Health.Enable end,
											get = function() return db.oUF.Party.Texts.Health.X end,
											set = function(self,HealthX)
														if HealthX == nil or HealthX == "" then
															HealthX = "0"
														end
														db.oUF.Party.Texts.Health.X = HealthX
														oUF_LUI_partyUnitButton1.Health.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Health.value:SetPoint(db.oUF.Party.Texts.Health.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Health.RelativePoint, tonumber(db.oUF.Party.Texts.Health.X), tonumber(db.oUF.Party.Texts.Health.Y))
													end,
											order = 5,
										},
										HealthY = {
											name = "Y Value",
											desc = "Y Value for your Party Health.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Health.Y,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.Health.Enable end,
											get = function() return db.oUF.Party.Texts.Health.Y end,
											set = function(self,HealthY)
														if HealthY == nil or HealthY == "" then
															HealthY = "0"
														end
														db.oUF.Party.Texts.Health.Y = HealthY
														oUF_LUI_partyUnitButton1.Health.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Health.value:SetPoint(db.oUF.Party.Texts.Health.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Health.RelativePoint, tonumber(db.oUF.Party.Texts.Health.X), tonumber(db.oUF.Party.Texts.Health.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Party Health.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Health.Point,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.Health.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Party.Texts.Health.Point = positions[Point]
													oUF_LUI_partyUnitButton1.Health.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Health.value:SetPoint(db.oUF.Party.Texts.Health.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Health.RelativePoint, tonumber(db.oUF.Party.Texts.Health.X), tonumber(db.oUF.Party.Texts.Health.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Party Health.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Health.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.Health.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Party.Texts.Health.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1.Health.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Health.value:SetPoint(db.oUF.Party.Texts.Health.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Health.RelativePoint, tonumber(db.oUF.Party.Texts.Health.X), tonumber(db.oUF.Party.Texts.Health.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.Health.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.Health.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Party.Texts.Health.ColorClass = true
														db.oUF.Party.Texts.Health.ColorGradient = false
														db.oUF.Party.Texts.Health.IndividualColor.Enable = false
														
														oUF_LUI_partyUnitButton1.Health.value.colorClass = true
														oUF_LUI_partyUnitButton1.Health.value.colorGradient = false
														oUF_LUI_partyUnitButton1.Health.value.colorIndividual.Enable = false
															
														print("Party Health Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.Health.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.Party.Texts.Health.ColorGradient = true
														db.oUF.Party.Texts.Health.ColorClass = false
														db.oUF.Party.Texts.Health.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Health.value.colorGradient = true
														oUF_LUI_partyUnitButton1.Health.value.colorClass = false
														oUF_LUI_partyUnitButton1.Health.value.colorIndividual.Enable = false
															
														print("Party Health Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Party Health Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.Health.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Party.Texts.Health.IndividualColor.Enable = true
														db.oUF.Party.Texts.Health.ColorClass = false
														db.oUF.Party.Texts.Health.ColorGradient = false
															
														oUF_LUI_partyUnitButton1.Health.value.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1.Health.value.colorClass = false
														oUF_LUI_partyUnitButton1.Health.value.colorGradient = false
														
														oUF_LUI_partyUnitButton1.Health.value:SetTextColor(tonumber(db.oUF.Party.Texts.Health.IndividualColor.r),tonumber(db.oUF.Party.Texts.Health.IndividualColor.g),tonumber(db.oUF.Party.Texts.Health.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Party Health Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Party.Texts.Health.IndividualColor.Enable or not db.oUF.Party.Texts.Health.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Party.Texts.Health.IndividualColor.r, db.oUF.Party.Texts.Health.IndividualColor.g, db.oUF.Party.Texts.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Party.Texts.Health.IndividualColor.r = r
													db.oUF.Party.Texts.Health.IndividualColor.g = g
													db.oUF.Party.Texts.Health.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1.Health.value.colorIndividual.r = r
													oUF_LUI_partyUnitButton1.Health.value.colorIndividual.g = g
													oUF_LUI_partyUnitButton1.Health.value.colorIndividual.b = b
													
													oUF_LUI_partyUnitButton1.Health.value:SetTextColor(r,g,b)
												end,
											order = 4,
										},
									},
								},
								Settings = {
									name = "Settings",
									type = "group",
									guiInline = true,
									order = 3,
									args = {
										ShowDead = {
											name = "Show Dead/AFK/Disconnected Information",
											desc = "Wether you want to switch the Health Value to Dead/AFK/Disconnected or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Party.Texts.Health.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.Party.Texts.Health.ShowDead = not db.oUF.Party.Texts.Health.ShowDead
														oUF_LUI_partyUnitButton1.Health.value.ShowDead = db.oUF.Party.Texts.Health.ShowDead
													end,
											order = 1,
										},
									},
								},
							},
						},
						Power = {
							name = "Power",
							type = "group",
							order = 3,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the Party Power or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Texts.Power.Enable end,
									set = function(self,Enable)
											db.oUF.Party.Texts.Power.Enable = not db.oUF.Party.Texts.Power.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1.Power.value:Show()
											else
												oUF_LUI_partyUnitButton1.Power.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.Power.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Party Power Fontsize!\n Default: "..LUI.defaults.profile.oUF.Party.Texts.Power.Size,
											disabled = function() return not db.oUF.Party.Texts.Power.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Party.Texts.Power.Size end,
											set = function(_, FontSize)
													db.oUF.Party.Texts.Power.Size = FontSize
													oUF_LUI_partyUnitButton1.Power.value:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.Power.Font),db.oUF.Party.Texts.Power.Size,db.oUF.Party.Texts.Power.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your Party Power.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Power.Format,
											disabled = function() return not db.oUF.Party.Texts.Power.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.Party.Texts.Power.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.Party.Texts.Power.Format = valueFormat[Format]
													oUF_LUI_partyUnitButton1.Power.value.Format = valueFormat[Format]
													print("Party Power Value Format will change once you gain/lose Power")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Party Power!\n\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Power.Font,
											disabled = function() return not db.oUF.Party.Texts.Power.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Party.Texts.Power.Font end,
											set = function(self, Font)
													db.oUF.Party.Texts.Power.Font = Font
													oUF_LUI_partyUnitButton1.Power.value:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.Power.Font),db.oUF.Party.Texts.Power.Size,db.oUF.Party.Texts.Power.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Party Power.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Power.Outline,
											disabled = function() return not db.oUF.Party.Texts.Power.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Party.Texts.Power.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Party.Texts.Power.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1.Power.value:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.Power.Font),db.oUF.Party.Texts.Power.Size,db.oUF.Party.Texts.Power.Outline)
												end,
											order = 4,
										},
										PowerX = {
											name = "X Value",
											desc = "X Value for your Party Power.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Power.X,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.Power.Enable end,
											get = function() return db.oUF.Party.Texts.Power.X end,
											set = function(self,PowerX)
														if PowerX == nil or PowerX == "" then
															PowerX = "0"
														end
														db.oUF.Party.Texts.Power.X = PowerX
														oUF_LUI_partyUnitButton1.Power.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Power.value:SetPoint(db.oUF.Party.Texts.Power.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Power.RelativePoint, tonumber(db.oUF.Party.Texts.Power.X), tonumber(db.oUF.Party.Texts.Power.Y))
													end,
											order = 5,
										},
										PowerY = {
											name = "Y Value",
											desc = "Y Value for your Party Power.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Power.Y,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.Power.Enable end,
											get = function() return db.oUF.Party.Texts.Power.Y end,
											set = function(self,PowerY)
														if PowerY == nil or PowerY == "" then
															PowerY = "0"
														end
														db.oUF.Party.Texts.Power.Y = PowerY
														oUF_LUI_partyUnitButton1.Power.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Power.value:SetPoint(db.oUF.Party.Texts.Power.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Power.RelativePoint, tonumber(db.oUF.Party.Texts.Power.X), tonumber(db.oUF.Party.Texts.Power.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Party Power.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Power.Point,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.Power.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Party.Texts.Power.Point = positions[Point]
													oUF_LUI_partyUnitButton1.Power.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Power.value:SetPoint(db.oUF.Party.Texts.Power.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Power.RelativePoint, tonumber(db.oUF.Party.Texts.Power.X), tonumber(db.oUF.Party.Texts.Power.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Party Power.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.Power.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.Power.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Party.Texts.Power.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1.Power.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Power.value:SetPoint(db.oUF.Party.Texts.Power.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.Power.RelativePoint, tonumber(db.oUF.Party.Texts.Power.X), tonumber(db.oUF.Party.Texts.Power.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.Power.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.Power.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Party.Texts.Power.ColorClass = true
														db.oUF.Party.Texts.Power.ColorType = false
														db.oUF.Party.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Power.value.colorClass = true
														oUF_LUI_partyUnitButton1.Power.value.colorType = false
														oUF_LUI_partyUnitButton1.Power.value.colorIndividual.Enable = false
			
														print("Party Power Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Powertype colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.Power.ColorType end,
											set = function(self,ColorType)
														db.oUF.Party.Texts.Power.ColorType = true
														db.oUF.Party.Texts.Power.ColorClass = false
														db.oUF.Party.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Power.value.colorType = true
														oUF_LUI_partyUnitButton1.Power.value.colorClass = false
														oUF_LUI_partyUnitButton1.Power.value.colorIndividual.Enable = false
		
														print("Party Power Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Party Power Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.Power.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Party.Texts.Power.IndividualColor.Enable = true
														db.oUF.Party.Texts.Power.ColorClass = false
														db.oUF.Party.Texts.Power.ColorType = false
															
														oUF_LUI_partyUnitButton1.Power.value.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1.Power.value.colorClass = false
														oUF_LUI_partyUnitButton1.Power.value.colorType = false
		
														oUF_LUI_partyUnitButton1.Power.value:SetTextColor(tonumber(db.oUF.Party.Texts.Power.IndividualColor.r),tonumber(db.oUF.Party.Texts.Power.IndividualColor.g),tonumber(db.oUF.Party.Texts.Power.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Party Power Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Party.Texts.Power.IndividualColor.Enable or not db.oUF.Party.Texts.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Party.Texts.Power.IndividualColor.r, db.oUF.Party.Texts.Power.IndividualColor.g, db.oUF.Party.Texts.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Party.Texts.Power.IndividualColor.r = r
													db.oUF.Party.Texts.Power.IndividualColor.g = g
													db.oUF.Party.Texts.Power.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1.Power.value.colorIndividual.r = r
													oUF_LUI_partyUnitButton1.Power.value.colorIndividual.g = g
													oUF_LUI_partyUnitButton1.Power.value.colorIndividual.b = b

													oUF_LUI_partyUnitButton1.Power.value:SetTextColor(r,g,b)
												end,
											order = 4,
										},
									},
								},
							},
						},
						HealthPercent = {
							name = "HealthPercent",
							type = "group",
							order = 4,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the Party HealthPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Texts.HealthPercent.Enable end,
									set = function(self,Enable)
											db.oUF.Party.Texts.HealthPercent.Enable = not db.oUF.Party.Texts.HealthPercent.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1.Health.valuePercent:Show()
											else
												oUF_LUI_partyUnitButton1.Health.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Party HealthPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.Party.Texts.HealthPercent.Size,
											disabled = function() return not db.oUF.Party.Texts.HealthPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Party.Texts.HealthPercent.Size end,
											set = function(_, FontSize)
													db.oUF.Party.Texts.HealthPercent.Size = FontSize
													oUF_LUI_partyUnitButton1.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.HealthPercent.Font),db.oUF.Party.Texts.HealthPercent.Size,db.oUF.Party.Texts.HealthPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show Party HealthPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.Party.Texts.HealthPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.Party.Texts.HealthPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.Party.Texts.HealthPercent.ShowAlways = not db.oUF.Party.Texts.HealthPercent.ShowAlways
													oUF_LUI_partyUnitButton1.Health.valuePercent = db.oUF.Party.Texts.HealthPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Party HealthPercent!\n\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthPercent.Font,
											disabled = function() return not db.oUF.Party.Texts.HealthPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Party.Texts.HealthPercent.Font end,
											set = function(self, Font)
													db.oUF.Party.Texts.HealthPercent.Font = Font
													oUF_LUI_partyUnitButton1.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.HealthPercent.Font),db.oUF.Party.Texts.HealthPercent.Size,db.oUF.Party.Texts.HealthPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Party HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthPercent.Outline,
											disabled = function() return not db.oUF.Party.Texts.HealthPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Party.Texts.HealthPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Party.Texts.HealthPercent.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.HealthPercent.Font),db.oUF.Party.Texts.HealthPercent.Size,db.oUF.Party.Texts.HealthPercent.Outline)
												end,
											order = 4,
										},
										HealthPercentX = {
											name = "X Value",
											desc = "X Value for your Party HealthPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthPercent.X,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.Party.Texts.HealthPercent.X end,
											set = function(self,HealthPercentX)
														if HealthPercentX == nil or HealthPercentX == "" then
															HealthPercentX = "0"
														end
														db.oUF.Party.Texts.HealthPercent.X = HealthPercentX
														oUF_LUI_partyUnitButton1.Health.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Health.valuePercent:SetPoint(db.oUF.Party.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.Party.Texts.HealthPercent.X), tonumber(db.oUF.Party.Texts.HealthPercent.Y))
													end,
											order = 5,
										},
										HealthPercentY = {
											name = "Y Value",
											desc = "Y Value for your Party HealthPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.Party.Texts.HealthPercent.Y end,
											set = function(self,HealthPercentY)
														if HealthPercentY == nil or HealthPercentY == "" then
															HealthPercentY = "0"
														end
														db.oUF.Party.Texts.HealthPercent.Y = HealthPercentY
														oUF_LUI_partyUnitButton1.Health.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Health.valuePercent:SetPoint(db.oUF.Party.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.Party.Texts.HealthPercent.X), tonumber(db.oUF.Party.Texts.HealthPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Party HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.HealthPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Party.Texts.HealthPercent.Point = positions[Point]
													oUF_LUI_partyUnitButton1.Health.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Health.valuePercent:SetPoint(db.oUF.Party.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.Party.Texts.HealthPercent.X), tonumber(db.oUF.Party.Texts.HealthPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Party HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.HealthPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Party.Texts.HealthPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1.Health.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Health.valuePercent:SetPoint(db.oUF.Party.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.Party.Texts.HealthPercent.X), tonumber(db.oUF.Party.Texts.HealthPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.HealthPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Party.Texts.HealthPercent.ColorClass = true
														db.oUF.Party.Texts.HealthPercent.ColorGradient = false
														db.oUF.Party.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Health.valuePercent.colorClass = true
														oUF_LUI_partyUnitButton1.Health.valuePercent.colorGradient = false
														oUF_LUI_partyUnitButton1.Health.valuePercent.colorIndividual.Enable = false
					
														print("Party HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.HealthPercent.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.Party.Texts.HealthPercent.ColorGradient = true
														db.oUF.Party.Texts.HealthPercent.ColorClass = false
														db.oUF.Party.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Health.valuePercent.colorGradient = true
														oUF_LUI_partyUnitButton1.Health.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1.Health.valuePercent.colorIndividual.Enable = false
				
														print("Party HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Party HealthPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.HealthPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Party.Texts.HealthPercent.IndividualColor.Enable = true
														db.oUF.Party.Texts.HealthPercent.ColorClass = false
														db.oUF.Party.Texts.HealthPercent.ColorGradient = false
															
														oUF_LUI_partyUnitButton1.Health.valuePercent.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1.Health.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1.Health.valuePercent.colorGradient = false
							
														oUF_LUI_partyUnitButton1.Health.valuePercent:SetTextColor(tonumber(db.oUF.Party.Texts.HealthPercent.IndividualColor.r),tonumber(db.oUF.Party.Texts.HealthPercent.IndividualColor.g),tonumber(db.oUF.Party.Texts.HealthPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Party HealthPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Party.Texts.HealthPercent.IndividualColor.Enable or not db.oUF.Party.Texts.HealthPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Party.Texts.HealthPercent.IndividualColor.r, db.oUF.Party.Texts.HealthPercent.IndividualColor.g, db.oUF.Party.Texts.HealthPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Party.Texts.HealthPercent.IndividualColor.r = r
													db.oUF.Party.Texts.HealthPercent.IndividualColor.g = g
													db.oUF.Party.Texts.HealthPercent.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1.Health.valuePercent.colorIndividual.r = r
													oUF_LUI_partyUnitButton1.Health.valuePercent.colorIndividual.g = g
													oUF_LUI_partyUnitButton1.Health.valuePercent.colorIndividual.b = b
			
													oUF_LUI_partyUnitButton1.Health.valuePercent:SetTextColor(r,g,b)
												end,
											order = 4,
										},
									},
								},
								Settings = {
									name = "Settings",
									type = "group",
									guiInline = true,
									order = 3,
									args = {
										ShowDead = {
											name = "Show Dead/AFK/Disconnected Information",
											desc = "Wether you want to switch the HealthPercent Value to Dead/AFK/Disconnected or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Party.Texts.HealthPercent.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.Party.Texts.HealthPercent.ShowDead = not db.oUF.Party.Texts.HealthPercent.ShowDead
														oUF_LUI_partyUnitButton1.Health.valuePercent.ShowDead = db.oUF.Party.Texts.HealthPercent.ShowDead
													end,
											order = 1,
										},
									},
								},
							},
						},
						PowerPercent = {
							name = "PowerPercent",
							type = "group",
							order = 5,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the Party PowerPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Texts.PowerPercent.Enable end,
									set = function(self,Enable)
											db.oUF.Party.Texts.PowerPercent.Enable = not db.oUF.Party.Texts.PowerPercent.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1.Power.valuePercent:Show()
											else
												oUF_LUI_partyUnitButton1.Power.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Party PowerPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.Party.Texts.PowerPercent.Size,
											disabled = function() return not db.oUF.Party.Texts.PowerPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Party.Texts.PowerPercent.Size end,
											set = function(_, FontSize)
													db.oUF.Party.Texts.PowerPercent.Size = FontSize
													oUF_LUI_partyUnitButton1.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.PowerPercent.Font),db.oUF.Party.Texts.PowerPercent.Size,db.oUF.Party.Texts.PowerPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show Party PowerPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.Party.Texts.PowerPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.Party.Texts.PowerPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.Party.Texts.PowerPercent.ShowAlways = not db.oUF.Party.Texts.PowerPercent.ShowAlways
													oUF_LUI_partyUnitButton1.Power.valuePercent.ShowAlways = db.oUF.Party.Texts.PowerPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Party PowerPercent!\n\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerPercent.Font,
											disabled = function() return not db.oUF.Party.Texts.PowerPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Party.Texts.PowerPercent.Font end,
											set = function(self, Font)
													db.oUF.Party.Texts.PowerPercent.Font = Font
													oUF_LUI_partyUnitButton1.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.PowerPercent.Font),db.oUF.Party.Texts.PowerPercent.Size,db.oUF.Party.Texts.PowerPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Party PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerPercent.Outline,
											disabled = function() return not db.oUF.Party.Texts.PowerPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Party.Texts.PowerPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Party.Texts.PowerPercent.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.PowerPercent.Font),db.oUF.Party.Texts.PowerPercent.Size,db.oUF.Party.Texts.PowerPercent.Outline)
												end,
											order = 4,
										},
										PowerPercentX = {
											name = "X Value",
											desc = "X Value for your Party PowerPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerPercent.X,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.Party.Texts.PowerPercent.X end,
											set = function(self,PowerPercentX)
														if PowerPercentX == nil or PowerPercentX == "" then
															PowerPercentX = "0"
														end
														db.oUF.Party.Texts.PowerPercent.X = PowerPercentX
														oUF_LUI_partyUnitButton1.Power.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Power.valuePercent:SetPoint(db.oUF.Party.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.Party.Texts.PowerPercent.X), tonumber(db.oUF.Party.Texts.PowerPercent.Y))
													end,
											order = 5,

										},
										PowerPercentY = {
											name = "Y Value",
											desc = "Y Value for your Party PowerPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.Party.Texts.PowerPercent.Y end,
											set = function(self,PowerPercentY)
														if PowerPercentY == nil or PowerPercentY == "" then
															PowerPercentY = "0"
														end
														db.oUF.Party.Texts.PowerPercent.Y = PowerPercentY
														oUF_LUI_partyUnitButton1.Power.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Power.valuePercent:SetPoint(db.oUF.Party.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.Party.Texts.PowerPercent.X), tonumber(db.oUF.Party.Texts.PowerPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Party PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.PowerPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Party.Texts.PowerPercent.Point = positions[Point]
													oUF_LUI_partyUnitButton1.Power.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Power.valuePercent:SetPoint(db.oUF.Party.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.Party.Texts.PowerPercent.X), tonumber(db.oUF.Party.Texts.PowerPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Party PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.PowerPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Party.Texts.PowerPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1.Power.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Power.valuePercent:SetPoint(db.oUF.Party.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.Party.Texts.PowerPercent.X), tonumber(db.oUF.Party.Texts.PowerPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.PowerPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Party.Texts.PowerPercent.ColorClass = true
														db.oUF.Party.Texts.PowerPercent.ColorType = false
														db.oUF.Party.Texts.PowerPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Power.valuePercent.colorClass = true
														oUF_LUI_partyUnitButton1.Power.valuePercent.colorType = false
														oUF_LUI_partyUnitButton1.Power.valuePercent.individualColor.Enable = false
		
														print("Party PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.PowerPercent.ColorType end,
											set = function(self,ColorType)
														db.oUF.Party.Texts.PowerPercent.ColorType = true
														db.oUF.Party.Texts.PowerPercent.ColorClass = false
														db.oUF.Party.Texts.PowerPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Power.valuePercent.colorType = true
														oUF_LUI_partyUnitButton1.Power.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1.Power.valuePercent.individualColor.Enable = false
		
														print("Party PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Party PowerPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.PowerPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Party.Texts.PowerPercent.IndividualColor.Enable = true
														db.oUF.Party.Texts.PowerPercent.ColorClass = false
														db.oUF.Party.Texts.PowerPercent.ColorType = false
															
														oUF_LUI_partyUnitButton1.Power.valuePercent.individualColor.Enable = true
														oUF_LUI_partyUnitButton1.Power.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1.Power.valuePercent.colorType = false

														oUF_LUI_partyUnitButton1.Power.valuePercent:SetTextColor(tonumber(db.oUF.Party.Texts.PowerPercent.IndividualColor.r),tonumber(db.oUF.Party.Texts.PowerPercent.IndividualColor.g),tonumber(db.oUF.Party.Texts.PowerPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Party PowerPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Party.Texts.PowerPercent.IndividualColor.Enable or not db.oUF.Party.Texts.PowerPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Party.Texts.PowerPercent.IndividualColor.r, db.oUF.Party.Texts.PowerPercent.IndividualColor.g, db.oUF.Party.Texts.PowerPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Party.Texts.PowerPercent.IndividualColor.r = r
													db.oUF.Party.Texts.PowerPercent.IndividualColor.g = g
													db.oUF.Party.Texts.PowerPercent.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1.Power.valuePercent.individualColor.r = r
													oUF_LUI_partyUnitButton1.Power.valuePercent.individualColor.g = g
													oUF_LUI_partyUnitButton1.Power.valuePercent.individualColor.b = b

													oUF_LUI_partyUnitButton1.Power.valuePercent:SetTextColor(r,g,b)
												end,
											order = 4,
										},
									},
								},
							},
						},
						HealthMissing = {
							name = "HealthMissing",
							type = "group",
							order = 6,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the Party HealthMissing or not.",
									type = "toggle",

									width = "full",
									get = function() return db.oUF.Party.Texts.HealthMissing.Enable end,
									set = function(self,Enable)
											db.oUF.Party.Texts.HealthMissing.Enable = not db.oUF.Party.Texts.HealthMissing.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1.Health.valueMissing:Show()
											else
												oUF_LUI_partyUnitButton1.Health.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Party HealthMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.Party.Texts.HealthMissing.Size,
											disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Party.Texts.HealthMissing.Size end,
											set = function(_, FontSize)
													db.oUF.Party.Texts.HealthMissing.Size = FontSize
													oUF_LUI_partyUnitButton1.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.HealthMissing.Font),db.oUF.Party.Texts.HealthMissing.Size,db.oUF.Party.Texts.HealthMissing.Outline)
												end,
											order = 1,
										},
										empty = {
											order = 2,
											width = "full",
											type = "description",
											name = " ",
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show Party HealthMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.Party.Texts.HealthMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.Party.Texts.HealthMissing.ShowAlways = not db.oUF.Party.Texts.HealthMissing.ShowAlways
													oUF_LUI_partyUnitButton1.Health.valueMissing.ShowAlways = db.oUF.Party.Texts.HealthMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.Party.Texts.HealthMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.Party.Texts.HealthMissing.ShortValue = not db.oUF.Party.Texts.HealthMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Party HealthMissing!\n\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthMissing.Font,
											disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Party.Texts.HealthMissing.Font end,
											set = function(self, Font)
													db.oUF.Party.Texts.HealthMissing.Font = Font
													oUF_LUI_partyUnitButton1.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.HealthMissing.Font),db.oUF.Party.Texts.HealthMissing.Size,db.oUF.Party.Texts.HealthMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Party HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthMissing.Outline,
											disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Party.Texts.HealthMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Party.Texts.HealthMissing.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.HealthMissing.Font),db.oUF.Party.Texts.HealthMissing.Size,db.oUF.Party.Texts.HealthMissing.Outline)
												end,
											order = 6,
										},
										HealthMissingX = {
											name = "X Value",
											desc = "X Value for your Party HealthMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthMissing.X,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.Party.Texts.HealthMissing.X end,
											set = function(self,HealthMissingX)
														if HealthMissingX == nil or HealthMissingX == "" then
															HealthMissingX = "0"
														end
														db.oUF.Party.Texts.HealthMissing.X = HealthMissingX
														oUF_LUI_partyUnitButton1.Health.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Health.valueMissing:SetPoint(db.oUF.Party.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.Party.Texts.HealthMissing.X), tonumber(db.oUF.Party.Texts.HealthMissing.Y))
													end,
											order = 7,
										},
										HealthMissingY = {
											name = "Y Value",
											desc = "Y Value for your Party HealthMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.Party.Texts.HealthMissing.Y end,
											set = function(self,HealthMissingY)
														if HealthMissingY == nil or HealthMissingY == "" then
															HealthMissingY = "0"
														end
														db.oUF.Party.Texts.HealthMissing.Y = HealthMissingY
														oUF_LUI_partyUnitButton1.Health.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Health.valueMissing:SetPoint(db.oUF.Party.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.Party.Texts.HealthMissing.X), tonumber(db.oUF.Party.Texts.HealthMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Party HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.HealthMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Party.Texts.HealthMissing.Point = positions[Point]
													oUF_LUI_partyUnitButton1.Health.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Health.valueMissing:SetPoint(db.oUF.Party.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.Party.Texts.HealthMissing.X), tonumber(db.oUF.Party.Texts.HealthMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Party HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.HealthMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.HealthMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Party.Texts.HealthMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1.Health.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Health.valueMissing:SetPoint(db.oUF.Party.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.Party.Texts.HealthMissing.X), tonumber(db.oUF.Party.Texts.HealthMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.HealthMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Party.Texts.HealthMissing.ColorClass = true
														db.oUF.Party.Texts.HealthMissing.ColorGradient = false
														db.oUF.Party.Texts.HealthMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Health.valueMissing.colorClass = true
														oUF_LUI_partyUnitButton1.Health.valueMissing.colorGradient = false
														oUF_LUI_partyUnitButton1.Health.valueMissing.colorIndividual.Enable = false

														print("Party HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.HealthMissing.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.Party.Texts.HealthMissing.ColorGradient = true
														db.oUF.Party.Texts.HealthMissing.ColorClass = false
														db.oUF.Party.Texts.HealthMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Health.valueMissing.colorGradient = true
														oUF_LUI_partyUnitButton1.Health.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1.Health.valueMissing.colorIndividual.Enable = false

														print("Party HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Party HealthMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.HealthMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Party.Texts.HealthMissing.IndividualColor.Enable = true
														db.oUF.Party.Texts.HealthMissing.ColorClass = false
														db.oUF.Party.Texts.HealthMissing.ColorGradient = false
															
														oUF_LUI_partyUnitButton1.Health.valueMissing.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1.Health.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1.Health.valueMissing.colorGradient = false
														
														oUF_LUI_partyUnitButton1.Health.valueMissing:SetTextColor(tonumber(db.oUF.Party.Texts.HealthMissing.IndividualColor.r),tonumber(db.oUF.Party.Texts.HealthMissing.IndividualColor.g),tonumber(db.oUF.Party.Texts.HealthMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Party HealthMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Party.Texts.HealthMissing.IndividualColor.Enable or not db.oUF.Party.Texts.HealthMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Party.Texts.HealthMissing.IndividualColor.r, db.oUF.Party.Texts.HealthMissing.IndividualColor.g, db.oUF.Party.Texts.HealthMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Party.Texts.HealthMissing.IndividualColor.r = r
													db.oUF.Party.Texts.HealthMissing.IndividualColor.g = g
													db.oUF.Party.Texts.HealthMissing.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1.Health.valueMissing.colorIndividual.r = r
													oUF_LUI_partyUnitButton1.Health.valueMissing.colorIndividual.g = g
													oUF_LUI_partyUnitButton1.Health.valueMissing.colorIndividual.b = b
													
													oUF_LUI_partyUnitButton1.Health.valueMissing:SetTextColor(r,g,b)
												end,
											order = 4,
										},
									},
								},
							},
						},
						PowerMissing = {
							name = "PowerMissing",
							type = "group",
							order = 7,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the Party PowerMissing or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Texts.PowerMissing.Enable end,
									set = function(self,Enable)
											db.oUF.Party.Texts.PowerMissing.Enable = not db.oUF.Party.Texts.PowerMissing.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1.Power.valueMissing:Show()
											else
												oUF_LUI_partyUnitButton1.Power.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Party PowerMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.Party.Texts.PowerMissing.Size,
											disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Party.Texts.PowerMissing.Size end,
											set = function(_, FontSize)
													db.oUF.Party.Texts.PowerMissing.Size = FontSize
													oUF_LUI_partyUnitButton1.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.PowerMissing.Font),db.oUF.Party.Texts.PowerMissing.Size,db.oUF.Party.Texts.PowerMissing.Outline)
												end,
											order = 1,
										},
										empty = {
											order = 2,
											width = "full",

											type = "description",
											name = " ",
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show Party PowerMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.Party.Texts.PowerMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.Party.Texts.PowerMissing.ShowAlways = not db.oUF.Party.Texts.PowerMissing.ShowAlways
													oUF_LUI_partyUnitButton1.Power.valueMissing.ShowAlways = db.oUF.Party.Texts.PowerMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.Party.Texts.PowerMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.Party.Texts.PowerMissing.ShortValue = not db.oUF.Party.Texts.PowerMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Party PowerMissing!\n\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerMissing.Font,
											disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Party.Texts.PowerMissing.Font end,
											set = function(self, Font)
													db.oUF.Party.Texts.PowerMissing.Font = Font
													oUF_LUI_partyUnitButton1.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.PowerMissing.Font),db.oUF.Party.Texts.PowerMissing.Size,db.oUF.Party.Texts.PowerMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Party PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerMissing.Outline,
											disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Party.Texts.PowerMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Party.Texts.PowerMissing.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Party.Texts.PowerMissing.Font),db.oUF.Party.Texts.PowerMissing.Size,db.oUF.Party.Texts.PowerMissing.Outline)
												end,
											order = 6,
										},
										PowerMissingX = {
											name = "X Value",
											desc = "X Value for your Party PowerMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerMissing.X,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.Party.Texts.PowerMissing.X end,
											set = function(self,PowerMissingX)
														if PowerMissingX == nil or PowerMissingX == "" then
															PowerMissingX = "0"
														end
														db.oUF.Party.Texts.PowerMissing.X = PowerMissingX
														oUF_LUI_partyUnitButton1.Power.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Power.valueMissing:SetPoint(db.oUF.Party.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.Party.Texts.PowerMissing.X), tonumber(db.oUF.Party.Texts.PowerMissing.Y))
													end,
											order = 7,
										},
										PowerMissingY = {
											name = "Y Value",
											desc = "Y Value for your Party PowerMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.Party.Texts.PowerMissing.Y end,
											set = function(self,PowerMissingY)
														if PowerMissingY == nil or PowerMissingY == "" then
															PowerMissingY = "0"
														end
														db.oUF.Party.Texts.PowerMissing.Y = PowerMissingY
														oUF_LUI_partyUnitButton1.Power.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1.Power.valueMissing:SetPoint(db.oUF.Party.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.Party.Texts.PowerMissing.X), tonumber(db.oUF.Party.Texts.PowerMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Party PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.PowerMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Party.Texts.PowerMissing.Point = positions[Point]
													oUF_LUI_partyUnitButton1.Power.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Power.valueMissing:SetPoint(db.oUF.Party.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.Party.Texts.PowerMissing.X), tonumber(db.oUF.Party.Texts.PowerMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Party PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.Party.Texts.PowerMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Party.Texts.PowerMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Party.Texts.PowerMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1.Power.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1.Power.valueMissing:SetPoint(db.oUF.Party.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.Party.Texts.PowerMissing.X), tonumber(db.oUF.Party.Texts.PowerMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Party.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.PowerMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Party.Texts.PowerMissing.ColorClass = true
														db.oUF.Party.Texts.PowerMissing.ColorType = false
														db.oUF.Party.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Power.valueMissing.colorClass = true
														oUF_LUI_partyUnitButton1.Power.valueMissing.colorType = false
														oUF_LUI_partyUnitButton1.Power.valueMissing.colorIndividual.Enable = false

														print("Party PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.PowerMissing.ColorType end,
											set = function(self,ColorType)
														db.oUF.Party.Texts.PowerMissing.ColorType = true
														db.oUF.Party.Texts.PowerMissing.ColorClass = false
														db.oUF.Party.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1.Power.valueMissing.colorType = true
														oUF_LUI_partyUnitButton1.Power.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1.Power.valueMissing.colorIndividual.Enable = false
		
														print("Party PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Party PowerMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Party.Texts.PowerMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Party.Texts.PowerMissing.IndividualColor.Enable = true
														db.oUF.Party.Texts.PowerMissing.ColorClass = false
														db.oUF.Party.Texts.PowerMissing.ColorType = false
															
														oUF_LUI_partyUnitButton1.Power.valueMissing.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1.Power.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1.Power.valueMissing.colorType = false
		
														oUF_LUI_partyUnitButton1.Power.valueMissing:SetTextColor(tonumber(db.oUF.Party.Texts.PowerMissing.IndividualColor.r),tonumber(db.oUF.Party.Texts.PowerMissing.IndividualColor.g),tonumber(db.oUF.Party.Texts.PowerMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Party PowerMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Party.Texts.PowerMissing.IndividualColor.Enable or not db.oUF.Party.Texts.PowerMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Party.Texts.PowerMissing.IndividualColor.r, db.oUF.Party.Texts.PowerMissing.IndividualColor.g, db.oUF.Party.Texts.PowerMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Party.Texts.PowerMissing.IndividualColor.r = r
													db.oUF.Party.Texts.PowerMissing.IndividualColor.g = g
													db.oUF.Party.Texts.PowerMissing.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1.Power.valueMissing.colorIndividual.r = r
													oUF_LUI_partyUnitButton1.Power.valueMissing.colorIndividual.g = g
													oUF_LUI_partyUnitButton1.Power.valueMissing.colorIndividual.b = b
													
													oUF_LUI_partyUnitButton1.Power.valueMissing:SetTextColor(r,g,b)
												end,
											order = 4,
										},
									},
								},
							},
						},
					},
				},
				Aura = {
					name = "Aura",
					type = "group",
					order = 7,
					childGroups = "tab",
					disabled = function() return not db.oUF.Party.Enable end,
					args = {
						header1 = {
							name = "Party Auras",
							type = "header",
							order = 1,
						},
						PartyBuffs = {
							name = "Buffs",
							type = "group",
							order = 2,
							args = {
								PartyBuffsEnable = {
									name = "Enable Party Buffs",
									desc = "Wether you want to show Party Buffs or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Aura.buffs_enable end,
									set = function(self,PartyBuffsEnable)
												db.oUF.Party.Aura.buffs_enable = not db.oUF.Party.Aura.buffs_enable 
											end,
									order = 0,
								},
								PartyBuffsAuratimer = {
									name = "Enable Auratimer",
									desc = "Wether you want to show Auratimers or not.",
									type = "toggle",
									disabled = function() return not db.oUF.Party.Aura.buffs_enable end,
									get = function() return db.oUF.Party.Aura.buffs_auratimer end,
									set = function(self,PartyBuffsAuratimer)
												db.oUF.Party.Aura.buffs_auratimer = not db.oUF.Party.Aura.buffs_auratimer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								PartyBuffsPlayerBuffsOnly = {
									name = "Player Buffs Only",
									desc = "Wether you want to show only your Buffs on Partymembers or not.",
									type = "toggle",
									disabled = function() return not db.oUF.Party.Aura.buffs_enable end,
									get = function() return db.oUF.Party.Aura.buffs_playeronly end,
									set = function(self,PartyBuffsPlayerBuffsOnly)
												db.oUF.Party.Aura.buffs_playeronly = not db.oUF.Party.Aura.buffs_playeronly
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 2,
								},
								PartyBuffsNum = {
									name = "Amount",
									desc = "Amount of your Party Buffs.\nDefault: 36",
									type = "input",
									disabled = function() return not db.oUF.Party.Aura.buffs_enable end,
									get = function() return db.oUF.Party.Aura.buffs_num end,
									set = function(self,PartyBuffsNum)
												if PartyBuffsNum == nil or PartyBuffsNum == "" then
													PartyBuffsNum = "0"
												end
												db.oUF.Party.Aura.buffs_num = PartyBuffsNum
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								PartyBuffsSize = {
									name = "Size",
									desc = "Size for your Party Buffs.\nDefault: 26",
									type = "input",
									disabled = function() return not db.oUF.Party.Aura.buffs_enable end,
									get = function() return db.oUF.Party.Aura.buffs_size end,
									set = function(self,PartyBuffsSize)
												if PartyBuffsSize == nil or PartyBuffsSize == "" then
													PartyBuffsSize = "0"
												end
												db.oUF.Party.Aura.buffs_size = PartyBuffsSize
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
								PartyBuffsSpacing = {
									name = "Spacing",
									desc = "Spacing between your Party Buffs.\nDefault: 2",
									type = "input",
									disabled = function() return not db.oUF.Party.Aura.buffs_enable end,
									get = function() return db.oUF.Party.Aura.buffs_spacing end,
									set = function(self,PartyBuffsSpacing)
												if PartyBuffsSpacing == nil or PartyBuffsSpacing == "" then
													PartyBuffsSpacing = "0"
												end
												db.oUF.Party.Aura.buffs_spacing = PartyBuffsSpacing
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 5,
								},
								PartyBuffsX = {
									name = "X Value",
									desc = "X Value for your Party Buffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.Party.Aura.buffs_enable end,
									get = function() return db.oUF.Party.Aura.buffsX end,
									set = function(self,PartyBuffsX)
												if PartyBuffsX == nil or PartyBuffsX == "" then
													PartyBuffsX = "0"
												end
												db.oUF.Party.Aura.buffsX = PartyBuffsX
												oUF_LUI_partyUnitButton1_buffs:SetPoint(db.oUF.Party.Aura.buffs_initialAnchor, oUF_LUI_partyUnitButton1.Health, db.oUF.Party.Aura.buffs_initialAnchor, PartyBuffsX, db.oUF.Party.Aura.buffsY)
											end,
									order = 6,
								},
								PartyBuffsY = {
									name = "Y Value",
									desc = "Y Value for your Party Buffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.Party.Aura.buffs_enable end,
									get = function() return db.oUF.Party.Aura.buffsY end,
									set = function(self,PartyBuffsY)
												if PartyBuffsY == nil or PartyBuffsY == "" then
													PartyBuffsY = "0"
												end
												db.oUF.Party.Aura.buffsY = PartyBuffsY
												oUF_LUI_partyUnitButton1_buffs:SetPoint(db.oUF.Party.Aura.buffs_initialAnchor, oUF_LUI_partyUnitButton1.Health, db.oUF.Party.Aura.buffs_initialAnchor, db.oUF.Party.Aura.buffsX, PartyBuffsY)
											end,
									order = 7,
								},
								PartyBuffsGrowthY = {
									name = "Growth Y",
									desc = "Choose the growth Y direction for your Party Buffs.\nDefault: UP",
									type = "select",
									disabled = function() return not db.oUF.Party.Aura.buffs_enable end,
									values = growthY,
									get = function()
											for k, v in pairs(growthY) do
												if db.oUF.Party.Aura.buffs_growthY == v then
													return k
												end
											end
										end,
									set = function(self, PartyBuffsGrowthY)
											db.oUF.Party.Aura.buffs_growthY = growthY[PartyBuffsGrowthY]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 8,
								},
								PartyBuffsGrowthX = {
									name = "Growth X",
									desc = "Choose the growth X direction for your Party Buffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.Party.Aura.buffs_enable end,
									values = growthX,
									get = function()
											for k, v in pairs(growthX) do
												if db.oUF.Party.Aura.buffs_growthX == v then
													return k
												end
											end
										end,
									set = function(self, PartyBuffsGrowthX)
											db.oUF.Party.Aura.buffs_growthX = growthX[PartyBuffsGrowthX]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 9,
								},
								PartyBuffsAnchor = {
									name = "Initial Anchor",
									desc = "Choose the initinal Anchor for your Party Buffs.\nDefault: LEFT",
									type = "select",
									disabled = function() return not db.oUF.Party.Aura.buffs_enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.Party.Aura.buffs_initialAnchor == v then
													return k
												end
											end
										end,
									set = function(self, PartyBuffsAnchor)
											db.oUF.Party.Aura.buffs_initialAnchor = positions[PartyBuffsAnchor]
											oUF_LUI_partyUnitButton1_buffs:SetPoint(positions[PartyBuffsAnchor], oUF_LUI_partyUnitButton1.Health, positions[PartyBuffsAnchor], db.oUF.Party.Aura.buffsX, db.oUF.Party.Aura.buffsY)
										end,
									order = 10,
								},
							},
						},
						PartyDebuffs = {
							name = "Debuffs",
							type = "group",
							order = 3,
							args = {
								PartyDebuffsEnable = {
									name = "Enable Party Debuffs",
									desc = "Wether you want to show Party Debuffs or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Aura.debuffs_enable end,
									set = function(self,PartyDebuffsEnable)
												db.oUF.Party.Aura.debuffs_enable = not db.oUF.Party.Aura.debuffs_enable 
											end,
									order = 0,
								},
								PartyDebuffsAuratimer = {
									name = "Enable Auratimer",
									desc = "Wether you want to show Auratimers or not.\nDefault: Off",
									type = "toggle",
									disabled = function() return not db.oUF.Party.Aura.debuffs_enable end,
									get = function() return db.oUF.Party.Aura.debuffs_auratimer end,
									set = function(self,PartyDebuffsAuratimer)
												db.oUF.Party.Aura.debuffs_auratimer = not db.oUF.Party.Aura.debuffs_auratimer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								PartyDebuffsColorByType = {
									name = "Color by Type",
									desc = "Wether you want to color Party Debuffs by Type or not.",
									type = "toggle",
									disabled = function() return not db.oUF.Party.Aura.debuffs_enable end,
									get = function() return db.oUF.Party.Aura.debuffs_colorbytype end,
									set = function(self,PartyDebuffsColorByType)
												db.oUF.Party.Aura.debuffs_colorbytype = not db.oUF.Party.Aura.debuffs_colorbytype
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 2,
								},
								PartyDebuffsNum = {
									name = "Amount",
									desc = "Amount of your Party Debuffs.\nDefault: 36",
									type = "input",
									disabled = function() return not db.oUF.Party.Aura.debuffs_enable end,
									get = function() return db.oUF.Party.Aura.debuffs_num end,
									set = function(self,PartyDebuffsNum)
												if PartyDebuffsNum == nil or PartyDebuffsNum == "" then
													PartyDebuffsNum = "0"
												end
												db.oUF.Party.Aura.debuffs_num = PartyDebuffsNum
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								PartyDebuffsSize = {
									name = "Size",
									desc = "Size for your Party Debuffs.\nDefault: 26",
									type = "input",
									disabled = function() return not db.oUF.Party.Aura.debuffs_enable end,
									get = function() return db.oUF.Party.Aura.debuffs_size end,
									set = function(self,PartyDebuffsSize)
												if PartyDebuffsSize == nil or PartyDebuffsSize == "" then
													PartyDebuffsSize = "0"
												end
												db.oUF.Party.Aura.debuffs_size = PartyDebuffsSize
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
								PartyDebuffsSpacing = {
									name = "Spacing",
									desc = "Spacing between your Party Debuffs.\nDefault: 2",
									type = "input",
									disabled = function() return not db.oUF.Party.Aura.debuffs_enable end,
									get = function() return db.oUF.Party.Aura.debuffs_spacing end,
									set = function(self,PartyDebuffsSpacing)
												if PartyDebuffsSpacing == nil or PartyDebuffsSpacing == "" then
													PartyDebuffsSpacing = "0"
												end
												db.oUF.Party.Aura.debuffs_spacing = PartyDebuffsSpacing
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 5,
								},
								PartyDebuffsX = {
									name = "X Value",
									desc = "X Value for your Party Debuffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.Party.Aura.debuffs_enable end,
									get = function() return db.oUF.Party.Aura.debuffsX end,
									set = function(self,PartyDebuffsX)
												if PartyDebuffsX == nil or PartyDebuffsX == "" then
													PartyDebuffsX = "0"
												end
												db.oUF.Party.Aura.debuffsX = PartyDebuffsX
												oUF_LUI_partyUnitButton1_debuffs:SetPoint(db.oUF.Party.Aura.debuffs_initialAnchor, oUF_LUI_partyUnitButton1.Health, db.oUF.Party.Aura.debuffs_initialAnchor, PartyDebuffsX, db.oUF.Party.Aura.debuffsY)
											end,
									order = 6,
								},
								PartyDebuffsY = {
									name = "Y Value",
									desc = "Y Value for your Party Debuffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.Party.Aura.debuffs_enable end,
									get = function() return db.oUF.Party.Aura.debuffsY end,
									set = function(self,PartyDebuffsY)
												if PartyDebuffsY == nil or PartyDebuffsY == "" then
													PartyDebuffsY = "0"
												end
												db.oUF.Party.Aura.debuffsY = PartyDebuffsY
												oUF_LUI_partyUnitButton1_debuffs:SetPoint(db.oUF.Party.Aura.debuffs_initialAnchor, oUF_LUI_partyUnitButton1.Health, db.oUF.Party.Aura.debuffs_initialAnchor, db.oUF.Party.Aura.debuffsX, PartyDebuffsY)
											end,
									order = 7,
								},
								PartyDebuffsGrowthY = {
									name = "Growth Y",
									desc = "Choose the growth Y direction for your Party Debuffs.\nDefault: UP",
									type = "select",
									disabled = function() return not db.oUF.Party.Aura.debuffs_enable end,
									values = growthY,
									get = function()
											for k, v in pairs(growthY) do
												if db.oUF.Party.Aura.debuffs_growthY == v then
													return k
												end
											end
										end,
									set = function(self, PartyDebuffsGrowthY)
											db.oUF.Party.Aura.debuffs_growthY = growthY[PartyDebuffsGrowthY]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 8,
								},
								PartyDebuffsGrowthX = {
									name = "Growth X",
									desc = "Choose the growth X direction for your Party Debuffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.Party.Aura.debuffs_enable end,
									values = growthX,
									get = function()
											for k, v in pairs(growthX) do
												if db.oUF.Party.Aura.debuffs_growthX == v then
													return k
												end
											end
										end,
									set = function(self, PartyDebuffsGrowthX)
											db.oUF.Party.Aura.debuffs_growthX = growthX[PartyDebuffsGrowthX]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 9,
								},
								PartyDebuffsAnchor = {
									name = "Initial Anchor",
									desc = "Choose the initinal Anchor for your Party Debuffs.\nDefault: LEFT",
									type = "select",
									disabled = function() return not db.oUF.Party.Aura.debuffs_enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.Party.Aura.debuffs_initialAnchor == v then
													return k
												end
											end
										end,
									set = function(self, PartyDebuffsAnchor)
											db.oUF.Party.Aura.debuffs_initialAnchor = positions[PartyDebuffsAnchor]
											oUF_LUI_partyUnitButton1_debuffs:SetPoint(positions[PartyDebuffsAnchor], oUF_LUI_partyUnitButton1.Health, positions[PartyDebuffsAnchor], db.oUF.Party.Aura.debuffsX, db.oUF.Party.Aura.debuffsY)
										end,
									order = 10,
								},
							},
						},
					},
				},
				Portrait = {
					name = "Portrait",
					disabled = function() return not db.oUF.Party.Enable end,
					type = "group",
					order = 8,
					args = {
						EnablePortrait = {
							name = "Enable",
							desc = "Wether you want to show the Portrait or not.",
							type = "toggle",
							width = "full",
							get = function() return db.oUF.Party.Portrait.Enable end,
							set = function(self,EnablePortrait)
										db.oUF.Party.Portrait.Enable = not db.oUF.Party.Portrait.Enable
										StaticPopup_Show("RELOAD_UI")
									end,
							order = 1,
						},
						PortraitWidth = {
							name = "Width",
							desc = "Choose the Width for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.Party.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.Party.Portrait.Enable end,
							get = function() return db.oUF.Party.Portrait.Width end,
							set = function(self,PortraitWidth)
										if PortraitWidth == nil or PortraitWidth == "" then
											PortraitWidth = "0"
										end
										db.oUF.Party.Portrait.Width = PortraitWidth
										oUF_LUI_partyUnitButton1.Portrait:SetWidth(tonumber(PortraitWidth))
									end,
							order = 2,
						},
						PortraitHeight = {
							name = "Height",
							desc = "Choose the Height for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.Party.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.Party.Portrait.Enable end,
							get = function() return db.oUF.Party.Portrait.Height end,
							set = function(self,PortraitHeight)
										if PortraitHeight == nil or PortraitHeight == "" then
											PortraitHeight = "0"
										end
										db.oUF.Party.Portrait.Height = PortraitHeight
										oUF_LUI_partyUnitButton1.Portrait:SetHeight(tonumber(PortraitHeight))
									end,
							order = 3,
						},
						PortraitX = {
							name = "X Value",
							desc = "X Value for your Portrait.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Portrait.X,
							type = "input",
							disabled = function() return not db.oUF.Party.Portrait.Enable end,
							get = function() return db.oUF.Party.Portrait.X end,
							set = function(self,PortraitX)
										if PortraitX == nil or PortraitX == "" then
											PortraitX = "0"
										end
										db.oUF.Party.Portrait.X = PortraitX
										oUF_LUI_partyUnitButton1.Portrait:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1.Health, "TOPLEFT", PortraitX, db.oUF.Party.Portrait.Y)
									end,
							order = 4,
						},
						PortraitY = {
							name = "Y Value",
							desc = "Y Value for your Portrait.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Portrait.Y,
							type = "input",
							disabled = function() return not db.oUF.Party.Portrait.Enable end,
							get = function() return db.oUF.Party.Portrait.Y end,
							set = function(self,PortraitY)
										if PortraitY == nil or PortraitY == "" then
											PortraitY = "0"
										end
										db.oUF.Party.Portrait.Y = PortraitY
										oUF_LUI_partyUnitButton1.Portrait:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1.Health, "TOPLEFT", db.oUF.Party.Portrait.X, PortraitY)
									end,
							order = 5,
						},
					},
				},
				Icons = {
					name = "Icons",
					type = "group",
					disabled = function() return not db.oUF.Party.Enable end,
					order = 9,
					childGroups = "tab",
					args = {
						Lootmaster = {
							name = "Lootmaster",
							type = "group",
							order = 1,
							args = {
								LootMasterEnable = {
									name = "Enable",
									desc = "Wether you want to show the LootMaster Icon or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Icons.Lootmaster.Enable end,
									set = function(self,LootMasterEnable)
												db.oUF.Party.Icons.Lootmaster.Enable = not db.oUF.Party.Icons.Lootmaster.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								LootMasterX = {
									name = "X Value",
									desc = "X Value for your LootMaster Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Lootmaster.X,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Lootmaster.Enable end,
									get = function() return db.oUF.Party.Icons.Lootmaster.X end,
									set = function(self,LootMasterX)
												if LootMasterX == nil or LootMasterX == "" then
													LootMasterX = "0"
												end
												db.oUF.Party.Icons.Lootmaster.X = LootMasterX
												oUF_LUI_partyUnitButton1.MasterLooter:ClearAllPoints()
												oUF_LUI_partyUnitButton1.MasterLooter:SetPoint(db.oUF.Party.Icons.Lootmaster.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Lootmaster.Point, tonumber(LootMasterX), tonumber(db.oUF.Party.Icons.Lootmaster.Y))
											end,
									order = 2,
								},
								LootMasterY = {
									name = "Y Value",
									desc = "Y Value for your LootMaster Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Lootmaster.Y,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Lootmaster.Enable end,
									get = function() return db.oUF.Party.Icons.Lootmaster.Y end,
									set = function(self,LootMasterY)
												if LootMasterY == nil or LootMasterY == "" then
													LootMasterY = "0"
												end
												db.oUF.Party.Icons.Lootmaster.Y = LootMasterY
												oUF_LUI_partyUnitButton1.MasterLooter:ClearAllPoints()
												oUF_LUI_partyUnitButton1.MasterLooter:SetPoint(db.oUF.Party.Icons.Lootmaster.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Lootmaster.Point, tonumber(db.oUF.Party.Icons.Lootmaster.X), tonumber(LootMasterY))
											end,
									order = 3,
								},
								LootMasterPoint = {
									name = "Position",
									desc = "Choose the Position for your LootMaster Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Lootmaster.Point,
									type = "select",
									disabled = function() return not db.oUF.Party.Icons.Lootmaster.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.Party.Icons.Lootmaster.Point == v then
													return k
												end
											end
										end,
									set = function(self, LootMasterPoint)
											db.oUF.Party.Icons.Lootmaster.Point = positions[LootMasterPoint]
											oUF_LUI_partyUnitButton1.MasterLooter:ClearAllPoints()
											oUF_LUI_partyUnitButton1.MasterLooter:SetPoint(db.oUF.Party.Icons.Lootmaster.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Lootmaster.Point, tonumber(db.oUF.Party.Icons.Lootmaster.X), tonumber(db.oUF.Party.Icons.Lootmaster.Y))
										end,
									order = 4,
								},
								LootMasterSize = {
									name = "Size",
									desc = "Choose a size for your LootMaster Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Lootmaster.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.Party.Icons.Lootmaster.Enable end,
									get = function() return db.oUF.Party.Icons.Lootmaster.Size end,
									set = function(_, LootMasterSize) 
											db.oUF.Party.Icons.Lootmaster.Size = LootMasterSize
											oUF_LUI_partyUnitButton1.MasterLooter:SetHeight(LootMasterSize)
											oUF_LUI_partyUnitButton1.MasterLooter:SetWidth(LootMasterSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.Party.Icons.Lootmaster.Enable end,
									desc = "Toggles the LootMaster Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1.MasterLooter:IsShown() then oUF_LUI_partyUnitButton1.MasterLooter:Hide() else oUF_LUI_partyUnitButton1.MasterLooter:Show() end end
								},
							},
						},
						Leader = {
							name = "Leader",
							type = "group",
							order = 2,
							args = {
								LeaderEnable = {
									name = "Enable",
									desc = "Wether you want to show the Leader Icon or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Icons.Leader.Enable end,
									set = function(self,LeaderEnable)
												db.oUF.Party.Icons.Leader.Enable = not db.oUF.Party.Icons.Leader.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								LeaderX = {
									name = "X Value",
									desc = "X Value for your Leader Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Leader.X,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Leader.Enable end,
									get = function() return db.oUF.Party.Icons.Leader.X end,
									set = function(self,LeaderX)
												if LeaderX == nil or LeaderX == "" then
													LeaderX = "0"
												end
												db.oUF.Party.Icons.Leader.X = LeaderX
												oUF_LUI_partyUnitButton1.Leader:ClearAllPoints()
												oUF_LUI_partyUnitButton1.Leader:SetPoint(db.oUF.Party.Icons.Leader.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Leader.Point, tonumber(LeaderX), tonumber(db.oUF.Party.Icons.Leader.Y))
											end,
									order = 2,
								},
								LeaderY = {
									name = "Y Value",
									desc = "Y Value for your Leader Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Leader.Y,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Leader.Enable end,
									get = function() return db.oUF.Party.Icons.Leader.Y end,
									set = function(self,LeaderY)
												if LeaderY == nil or LeaderY == "" then
													LeaderY = "0"
												end
												db.oUF.Party.Icons.Leader.Y = LeaderY
												oUF_LUI_partyUnitButton1.Leader:ClearAllPoints()
												oUF_LUI_partyUnitButton1.Leader:SetPoint(db.oUF.Party.Icons.Leader.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Leader.Point, tonumber(db.oUF.Party.Icons.Leader.X), tonumber(LeaderY))
											end,
									order = 3,
								},
								LeaderPoint = {
									name = "Position",
									desc = "Choose the Position for your Leader Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Leader.Point,
									type = "select",
									disabled = function() return not db.oUF.Party.Icons.Leader.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.Party.Icons.Leader.Point == v then
													return k
												end
											end
										end,
									set = function(self, LeaderPoint)
											db.oUF.Party.Icons.Leader.Point = positions[LeaderPoint]
											oUF_LUI_partyUnitButton1.Leader:ClearAllPoints()
											oUF_LUI_partyUnitButton1.Leader:SetPoint(db.oUF.Party.Icons.Leader.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Leader.Point, tonumber(db.oUF.Party.Icons.Leader.X), tonumber(db.oUF.Party.Icons.Leader.Y))
										end,
									order = 4,
								},
								LeaderSize = {
									name = "Size",
									desc = "Choose your Size for your Leader Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Leader.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.Party.Icons.Leader.Enable end,
									get = function() return db.oUF.Party.Icons.Leader.Size end,
									set = function(_, LeaderSize) 
											db.oUF.Party.Icons.Leader.Size = LeaderSize
											oUF_LUI_partyUnitButton1.Leader:SetHeight(LeaderSize)
											oUF_LUI_partyUnitButton1.Leader:SetWidth(LeaderSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.Party.Icons.Leader.Enable end,
									desc = "Toggles the Leader Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1.Leader:IsShown() then oUF_LUI_partyUnitButton1.Leader:Hide() else oUF_LUI_partyUnitButton1.Leader:Show() end end
								},
							},
						},
						LFDRole = {
							name = "LFDRole",
							type = "group",
							order = 3,
							args = {
								RoleEnable = {
									name = "Enable",
									desc = "Wether you want to show the Group Role Icon or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Icons.Role.Enable end,
									set = function(self,RoleEnable)
												db.oUF.Party.Icons.Role.Enable = not db.oUF.Party.Icons.Role.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								RoleX = {
									name = "X Value",
									desc = "X Value for your Group Role Icon Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Role.X,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Role.Enable end,
									get = function() return db.oUF.Party.Icons.Role.X end,
									set = function(self,RoleX)
												if RoleX == nil or RoleX == "" then
													RoleX = "0"
												end
												db.oUF.Party.Icons.Role.X = RoleX
												oUF_LUI_partyUnitButton1.LFDRole:ClearAllPoints()
												oUF_LUI_partyUnitButton1.LFDRole:SetPoint(db.oUF.Party.Icons.Role.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Role.Point, tonumber(RoleX), tonumber(db.oUF.Party.Icons.Role.Y))
											end,
									order = 2,
								},
								RoleY = {
									name = "Y Value",
									desc = "Y Value for your Role Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Role.Y,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Role.Enable end,
									get = function() return db.oUF.Party.Icons.Role.Y end,
									set = function(self,RoleY)
												if RoleY == nil or RoleY == "" then
													RoleY = "0"
												end
												db.oUF.Party.Icons.Role.Y = RoleY
												oUF_LUI_partyUnitButton1.LFDRole:ClearAllPoints()
												oUF_LUI_partyUnitButton1.LFDRole:SetPoint(db.oUF.Party.Icons.Role.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Role.Point, tonumber(db.oUF.Party.Icons.Role.X), tonumber(RoleY))
											end,
									order = 3,
								},
								RolePoint = {
									name = "Position",
									desc = "Choose the Position for your Role Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Role.Point,
									type = "select",
									disabled = function() return not db.oUF.Party.Icons.Role.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.Party.Icons.Role.Point == v then
													return k
												end
											end
										end,
									set = function(self, RolePoint)
											db.oUF.Party.Icons.Role.Point = positions[RolePoint]
											oUF_LUI_partyUnitButton1.LFDRole:ClearAllPoints()
											oUF_LUI_partyUnitButton1.LFDRole:SetPoint(db.oUF.Party.Icons.Role.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Role.Point, tonumber(db.oUF.Party.Icons.Role.X), tonumber(db.oUF.Party.Icons.Role.Y))
										end,
									order = 4,
								},
								RoleSize = {
									name = "Size",
									desc = "Choose a Size for your Group Role Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Role.Size,
									type = "range",
									min = 5,
									max = 100,
									step = 1,
									disabled = function() return not db.oUF.Party.Icons.Role.Enable end,
									get = function() return db.oUF.Party.Icons.Role.Size end,
									set = function(_, RoleSize) 
											db.oUF.Party.Icons.Role.Size = RoleSize
											oUF_LUI_partyUnitButton1.LFDRole:SetHeight(RoleSize)
											oUF_LUI_partyUnitButton1.LFDRole:SetWidth(RoleSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.Party.Icons.Role.Enable end,
									desc = "Toggles the LFDRole Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1.LFDRole:IsShown() then oUF_LUI_partyUnitButton1.LFDRole:Hide() else oUF_LUI_partyUnitButton1.LFDRole:Show() end end
								},
							},
						},
						Raid = {
							name = "RaidIcon",
							type = "group",
							order = 4,
							args = {
								RaidEnable = {
									name = "Enable",
									desc = "Wether you want to show the Raid Icon or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Icons.Raid.Enable end,
									set = function(self,RaidEnable)
												db.oUF.Party.Icons.Raid.Enable = not db.oUF.Party.Icons.Raid.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								RaidX = {
									name = "X Value",
									desc = "X Value for your Raid Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Raid.X,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Raid.Enable end,
									get = function() return db.oUF.Party.Icons.Raid.X end,
									set = function(self,RaidX)
												if RaidX == nil or RaidX == "" then
													RaidX = "0"
												end

												db.oUF.Party.Icons.Raid.X = RaidX
												oUF_LUI_partyUnitButton1.RaidIcon:ClearAllPoints()
												oUF_LUI_partyUnitButton1.RaidIcon:SetPoint(db.oUF.Party.Icons.Raid.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Raid.Point, tonumber(RaidX), tonumber(db.oUF.Party.Icons.Raid.Y))
											end,
									order = 2,
								},
								RaidY = {
									name = "Y Value",
									desc = "Y Value for your Raid Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Raid.Y,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Raid.Enable end,
									get = function() return db.oUF.Party.Icons.Raid.Y end,
									set = function(self,RaidY)
												if RaidY == nil or RaidY == "" then
													RaidY = "0"
												end
												db.oUF.Party.Icons.Raid.Y = RaidY
												oUF_LUI_partyUnitButton1.RaidIcon:ClearAllPoints()
												oUF_LUI_partyUnitButton1.RaidIcon:SetPoint(db.oUF.Party.Icons.Raid.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Raid.Point, tonumber(db.oUF.Party.Icons.Raid.X), tonumber(RaidY))
											end,
									order = 3,
								},
								RaidPoint = {
									name = "Position",
									desc = "Choose the Position for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Raid.Point,
									type = "select",
									disabled = function() return not db.oUF.Party.Icons.Raid.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.Party.Icons.Raid.Point == v then
													return k
												end
											end
										end,
									set = function(self, RaidPoint)
											db.oUF.Party.Icons.Raid.Point = positions[RaidPoint]
											oUF_LUI_partyUnitButton1.RaidIcon:ClearAllPoints()
											oUF_LUI_partyUnitButton1.RaidIcon:SetPoint(db.oUF.Party.Icons.Raid.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Raid.Point, tonumber(db.oUF.Party.Icons.Raid.X), tonumber(db.oUF.Party.Icons.Raid.Y))
										end,
									order = 4,
								},
								RaidSize = {
									name = "Size",
									desc = "Choose a Size for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Raid.Size,
									type = "range",
									min = 5,
									max = 200,
									step = 5,
									disabled = function() return not db.oUF.Party.Icons.Raid.Enable end,
									get = function() return db.oUF.Party.Icons.Raid.Size end,
									set = function(_, RaidSize) 
											db.oUF.Party.Icons.Raid.Size = RaidSize
											oUF_LUI_partyUnitButton1.RaidIcon:SetHeight(RaidSize)
											oUF_LUI_partyUnitButton1.RaidIcon:SetWidth(RaidSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.Party.Icons.Raid.Enable end,
									desc = "Toggles the RaidIcon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1.RaidIcon:IsShown() then oUF_LUI_partyUnitButton1.RaidIcon:Hide() else oUF_LUI_partyUnitButton1.RaidIcon:Show() end end
								},
							},
						},
						Resting = {
							name = "Resting",
							type = "group",
							order = 5,
							args = {
								RestingEnable = {
									name = "Enable",
									desc = "Wether you want to show the Resting Icon or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Icons.Resting.Enable end,
									set = function(self,RestingEnable)
												db.oUF.Party.Icons.Resting.Enable = not db.oUF.Party.Icons.Resting.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								RestingX = {
									name = "X Value",
									desc = "X Value for your Resting Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Resting.X,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Resting.Enable end,
									get = function() return db.oUF.Party.Icons.Resting.X end,
									set = function(self,RestingX)
												if RestingX == nil or RestingX == "" then
													RestingX = "0"
												end
												db.oUF.Party.Icons.Resting.X = RestingX
												oUF_LUI_partyUnitButton1.Resting:ClearAllPoints()
												oUF_LUI_partyUnitButton1.Resting:SetPoint(db.oUF.Party.Icons.Resting.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Resting.Point, tonumber(RestingX), tonumber(db.oUF.Party.Icons.Resting.Y))
											end,
									order = 2,
								},
								RestingY = {
									name = "Y Value",
									desc = "Y Value for your Resting Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Resting.Y,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Resting.Enable end,
									get = function() return db.oUF.Party.Icons.Resting.Y end,
									set = function(self,RestingY)
												if RestingY == nil or RestingY == "" then
													RestingY = "0"
												end
												db.oUF.Party.Icons.Resting.Y = RestingY
												oUF_LUI_partyUnitButton1.Resting:ClearAllPoints()
												oUF_LUI_partyUnitButton1.Resting:SetPoint(db.oUF.Party.Icons.Resting.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Resting.Point, tonumber(db.oUF.Party.Icons.Resting.X), tonumber(RestingY))
											end,
									order = 3,
								},
								RestingPoint = {
									name = "Position",
									desc = "Choose the Position for your Resting Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Resting.Point,
									type = "select",
									disabled = function() return not db.oUF.Party.Icons.Resting.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.Party.Icons.Resting.Point == v then
													return k
												end
											end
										end,
									set = function(self, RestingPoint)
											db.oUF.Party.Icons.Resting.Point = positions[RestingPoint]
											oUF_LUI_partyUnitButton1.Resting:ClearAllPoints()
											oUF_LUI_partyUnitButton1.Resting:SetPoint(db.oUF.Party.Icons.Resting.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Resting.Point, tonumber(db.oUF.Party.Icons.Resting.X), tonumber(db.oUF.Party.Icons.Resting.Y))
										end,
									order = 4,
								},
								RestingSize = {
									name = "Size",
									desc = "Choose a Size for your Resting Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Resting.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.Party.Icons.Resting.Enable end,
									get = function() return db.oUF.Party.Icons.Resting.Size end,
									set = function(_, RestingSize) 
											db.oUF.Party.Icons.Resting.Size = RestingSize
											oUF_LUI_partyUnitButton1.Resting:SetHeight(RestingSize)
											oUF_LUI_partyUnitButton1.Resting:SetWidth(RestingSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.Party.Icons.Resting.Enable end,
									desc = "Toggles the Resting Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1.Resting:IsShown() then oUF_LUI_partyUnitButton1.Resting:Hide() else oUF_LUI_partyUnitButton1.Resting:Show() end end
								},
							},
						},
						Combat = {
							name = "Combat",
							type = "group",
							order = 5,
							args = {
								CombatEnable = {
									name = "Enable",
									desc = "Wether you want to show the Combat Icon or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Icons.Combat.Enable end,
									set = function(self,CombatEnable)
												db.oUF.Party.Icons.Combat.Enable = not db.oUF.Party.Icons.Combat.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								CombatX = {
									name = "X Value",
									desc = "X Value for your Combat Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Combat.X,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Combat.Enable end,
									get = function() return db.oUF.Party.Icons.Combat.X end,
									set = function(self,CombatX)
												if CombatX == nil or CombatX == "" then
													CombatX = "0"
												end
												db.oUF.Party.Icons.Combat.X = CombatX
												oUF_LUI_partyUnitButton1.Combat:ClearAllPoints()
												oUF_LUI_partyUnitButton1.Combat:SetPoint(db.oUF.Party.Icons.Combat.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Combat.Point, tonumber(CombatX), tonumber(db.oUF.Party.Icons.Combat.Y))
											end,
									order = 2,
								},
								CombatY = {
									name = "Y Value",
									desc = "Y Value for your Combat Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Combat.Y,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.Combat.Enable end,
									get = function() return db.oUF.Party.Icons.Combat.Y end,
									set = function(self,CombatY)
												if CombatY == nil or CombatY == "" then
													CombatY = "0"
												end
												db.oUF.Party.Icons.Combat.Y = CombatY
												oUF_LUI_partyUnitButton1.Combat:ClearAllPoints()
												oUF_LUI_partyUnitButton1.Combat:SetPoint(db.oUF.Party.Icons.Combat.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Combat.Point, tonumber(db.oUF.Party.Icons.Combat.X), tonumber(CombatY))
											end,
									order = 3,
								},
								CombatPoint = {
									name = "Position",
									desc = "Choose the Position for your Combat Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Combat.Point,
									type = "select",
									disabled = function() return not db.oUF.Party.Icons.Combat.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.Party.Icons.Combat.Point == v then
													return k
												end
											end
										end,
									set = function(self, CombatPoint)

											db.oUF.Party.Icons.Combat.Point = positions[CombatPoint]
											oUF_LUI_partyUnitButton1.Combat:ClearAllPoints()
											oUF_LUI_partyUnitButton1.Combat:SetPoint(db.oUF.Party.Icons.Combat.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.Combat.Point, tonumber(db.oUF.Party.Icons.Combat.X), tonumber(db.oUF.Party.Icons.Combat.Y))
										end,
									order = 4,
								},
								CombatSize = {
									name = "Size",
									desc = "Choose a Size for your Combat Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.Combat.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.Party.Icons.Combat.Enable end,
									get = function() return db.oUF.Party.Icons.Combat.Size end,
									set = function(_, CombatSize) 
											db.oUF.Party.Icons.Combat.Size = CombatSize
											oUF_LUI_partyUnitButton1.Combat:SetHeight(CombatSize)
											oUF_LUI_partyUnitButton1.Combat:SetWidth(CombatSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									disabled = function() return not db.oUF.Party.Icons.Combat.Enable end,
									name = "Show/Hide",
									desc = "Toggles the Combat Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1.Combat:IsShown() then oUF_LUI_partyUnitButton1.Combat:Hide() else oUF_LUI_partyUnitButton1.Combat:Show() end end
								},
							},
						},
						PvP = {
							name = "PvP",
							type = "group",
							order = 5,
							args = {
								PvPEnable = {
									name = "Enable",
									desc = "Wether you want to show the PvP Icon or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Party.Icons.PvP.Enable end,
									set = function(self,PvPEnable)
												db.oUF.Party.Icons.PvP.Enable = not db.oUF.Party.Icons.PvP.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								PvPX = {
									name = "X Value",
									desc = "X Value for your PvP Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.PvP.X,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.PvP.Enable end,
									get = function() return db.oUF.Party.Icons.PvP.X end,
									set = function(self,PvPX)
												if PvPX == nil or PvPX == "" then
													PvPX = "0"
												end
												db.oUF.Party.Icons.PvP.X = PvPX
												oUF_LUI_partyUnitButton1.PvP:ClearAllPoints()
												oUF_LUI_partyUnitButton1.PvP:SetPoint(db.oUF.Party.Icons.PvP.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.PvP.Point, tonumber(PvPX), tonumber(db.oUF.Party.Icons.PvP.Y))
											end,
									order = 2,
								},
								PvPY = {
									name = "Y Value",
									desc = "Y Value for your PvP Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.PvP.Y,
									type = "input",
									disabled = function() return not db.oUF.Party.Icons.PvP.Enable end,
									get = function() return db.oUF.Party.Icons.PvP.Y end,
									set = function(self,PvPY)
												if PvPY == nil or PvPY == "" then
													PvPY = "0"
												end
												db.oUF.Party.Icons.PvP.Y = PvPY
												oUF_LUI_partyUnitButton1.PvP:ClearAllPoints()
												oUF_LUI_partyUnitButton1.PvP:SetPoint(db.oUF.Party.Icons.PvP.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.PvP.Point, tonumber(db.oUF.Party.Icons.PvP.X), tonumber(PvPY))
											end,
									order = 3,
								},
								PvPPoint = {
									name = "Position",
									desc = "Choose the Position for your PvP Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.PvP.Point,
									type = "select",
									disabled = function() return not db.oUF.Party.Icons.PvP.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.Party.Icons.PvP.Point == v then
													return k
												end
											end
										end,
									set = function(self, PvPPoint)
											db.oUF.Party.Icons.PvP.Point = positions[PvPPoint]
											oUF_LUI_partyUnitButton1.PvP:ClearAllPoints()
											oUF_LUI_partyUnitButton1.PvP:SetPoint(db.oUF.Party.Icons.PvP.Point, oUF_LUI_partyUnitButton1, db.oUF.Party.Icons.PvP.Point, tonumber(db.oUF.Party.Icons.PvP.X), tonumber(db.oUF.Party.Icons.PvP.Y))
										end,
									order = 4,
								},
								PvPSize = {
									name = "Size",
									desc = "Choose a Size for your PvP Icon.\nDefault: "..LUI.defaults.profile.oUF.Party.Icons.PvP.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.Party.Icons.PvP.Enable end,
									get = function() return db.oUF.Party.Icons.PvP.Size end,
									set = function(_, PvPSize) 
											db.oUF.Party.Icons.PvP.Size = PvPSize
											oUF_LUI_partyUnitButton1.PvP:SetHeight(PvPSize)
											oUF_LUI_partyUnitButton1.PvP:SetWidth(PvPSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.Party.Icons.PvP.Enable end,
									desc = "Toggles the PvP Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1.PvP:IsShown() then oUF_LUI_partyUnitButton1.PvP:Hide() else oUF_LUI_partyUnitButton1.PvP:Show() end end
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

function module:OnEnable()
end