--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: partypet.lua
	Description: oUF Party Pet Module
	Version....: 1.0
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local module = LUI:NewModule("oUF_PartyPet")
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
	PartyPet = {
		Enable = true,
		Height = "24",
		Width = "130",
		X = "-15",
		Y = "-10",
		Point = "TOPLEFT",
		RelativePoint = "BOTTOMLEFT",
		Border = {
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
			Height = "24",
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
			Enable = false,
			Height = "5",
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
			buffs_enable = false,
			buffs_auratimer = false,
			buffsX = "-0.5",
			buffsY = "30",
			buffs_initialAnchor = "TOPLEFT",
			buffs_growthY = "UP",
			buffs_growthX = "RIGHT",
			buffs_size = "18",
			buffs_spacing = "2",
			buffs_num = "8",
			debuffs_colorbytype = false,
			debuffs_enable = false,
			debuffs_auratimer = false,
			debuffsX = "-0.5",
			debuffsY = "-30",
			debuffs_initialAnchor = "RIGHT",
			debuffs_growthY = "UP",
			debuffs_growthX = "LEFT",
			debuffs_size = "18",
			debuffs_spacing = "2",
			debuffs_num = "8",
		},
		Portrait = {
			Enable = false,
			Height = "43",
			Width = "90",
			X = "0",
			Y = "0",
		},
		Icons = {
			Raid = {
				Enable = true,
				Size = 55,
				X = "0",
				Y = "0",
				Point = "CENTER",
			},
		},
		Texts = {
			Name = {
				Enable = true,
				Font = "Prototype",
				Size = 15,
				X = "0",
				Y = "0",
				IndividualColor = {
					Enable = true,
					r = "0",
					g = "0",
					b = "0",
				},
				Outline = "NONE",
				Point = "CENTER",
				RelativePoint = "CENTER",
				Format = "Name",
				Length = "Short",
				ColorNameByClass = false,
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
				Enable = false,
				Font = "Prototype",
				Size = 14,
				X = "-5",
				Y = "0",
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
				Point = "RIGHT",
				RelativePoint = "RIGHT",
				ShowDead = false,
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
		PartyPet = {
			name = "Party Pet",
			type = "group",
			disabled = function() return not db.oUF.Settings.Enable end,
			order = 32,
			childGroups = "tab",
			args = {
				header1 = {
					name = "Party Pet",
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
									desc = "Wether you want to use a Party Pet Frame or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyPet.Enable end,
									set = function(self,Enable)
												db.oUF.PartyPet.Enable = not db.oUF.PartyPet.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
							},
						},
						Positioning = {
							name = "Positioning",
							type = "group",
							disabled = function() return not db.oUF.PartyPet.Enable end,
							order = 1,
							args = {
								header1 = {
									name = "Frame Position",
									type = "header",
									order = 1,
								},
								PartyPetX = {
									name = "X Value",
									desc = "X Value for your Party Pet Frame.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyPet.X,
									type = "input",
									get = function() return db.oUF.PartyPet.X end,
									set = function(self,PartyPetX)
												if PartyPetX == nil or PartyPetX == "" then
													PartyPetX = "0"
												end
												db.oUF.PartyPet.X = PartyPetX
												oUF_LUI_partyUnitButton1pet:ClearAllPoints()
												oUF_LUI_partyUnitButton1pet:SetPoint(db.oUF.PartyPet.Point, oUF_LUI_partyUnitButton1, db.oUF.PartyPet.RelativePoint, tonumber(PartyPetX), tonumber(db.oUF.PartyPet.Y))
											end,
									order = 2,
								},
								PartyPetY = {
									name = "Y Value",
									desc = "Y Value for your Party Pet Frame.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Y,
									type = "input",
									get = function() return db.oUF.PartyPet.Y end,
									set = function(self,PartyPetY)
												if PartyPetY == nil or PartyPetY == "" then
													PartyPetY = "0"
												end
												db.oUF.PartyPet.Y = PartyPetY
												oUF_LUI_partyUnitButton1pet:ClearAllPoints()
												oUF_LUI_partyUnitButton1pet:SetPoint(db.oUF.PartyPet.Point, oUF_LUI_partyUnitButton1, db.oUF.PartyPet.RelativePoint, tonumber(db.oUF.PartyPet.X), tonumber(PartyPetY))
											end,
									order = 3,
								},
								PartyPetPoint = {
									name = "Point",
									desc = "Choose the Point for your Party Pet Frame.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Point,
									type = "select",
											values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyPet.Point == v then
													return k
												end
											end
										end,
									set = function(self, PartyPetPoint)
											db.oUF.PartyPet.Point = positions[PartyPetPoint]
											oUF_LUI_partyUnitButton1pet:ClearAllPoints()
											oUF_LUI_partyUnitButton1pet:SetPoint(PartyPetPoint, oUF_LUI_partyUnitButton1, db.oUF.PartyPet.RelativePoint, tonumber(db.oUF.PartyPet.X), tonumber(db.oUF.PartyPet.Y))
										end,
									order = 4,
								},
								PartyPetRelativePoint = {
									name = "RelativePoint",
									desc = "Choose the RelativePoint for your Party Pet Frame.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.RelativePoint,
									type = "select",
											values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyPet.RelativePoint == v then
													return k
												end
											end
										end,
									set = function(self, PartyPetRelativePoint)
											db.oUF.PartyPet.RelativePoint = positions[PartyPetRelativePoint]
											oUF_LUI_partyUnitButton1pet:ClearAllPoints()
											oUF_LUI_partyUnitButton1pet:SetPoint(db.oUF.PartyPet.Point, oUF_LUI_partyUnitButton1, PartyPetRelativePoint, tonumber(db.oUF.PartyPet.X), tonumber(db.oUF.PartyPet.Y))
										end,
									order = 5,
								},
							},
						},
						Size = {
							name = "Size",
							type = "group",
							disabled = function() return not db.oUF.PartyPet.Enable end,
							order = 2,
							args = {
								header1 = {
									name = "Frame Height/Width",
									type = "header",
									order = 1,
								},
								PartyPetHeight = {
									name = "Height",
									desc = "Decide the Height of your Party Pet Frame.\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Height,
									type = "input",
									get = function() return db.oUF.PartyPet.Height end,
									set = function(self,PartyPetHeight)
												if PartyPetHeight == nil or PartyPetHeight == "" then
													PartyPetHeight = "0"
												end
												db.oUF.PartyPet.Height = PartyPetHeight
												oUF_LUI_partyUnitButton1pet:SetHeight(tonumber(PartyPetHeight))
											end,
									order = 2,
								},
								PartyPetWidth = {
									name = "Width",
									desc = "Decide the Width of your Party Pet Frame.\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Width,
									type = "input",
									get = function() return db.oUF.PartyPet.Width end,
									set = function(self,PartyPetWidth)
												if PartyPetWidth == nil or PartyPetWidth == "" then
													PartyPetWidth = "0"
												end
												db.oUF.PartyPet.Width = PartyPetWidth
												oUF_LUI_partyUnitButton1pet:SetWidth(tonumber(PartyPetWidth))
												
												if db.oUF.PartyPet.Aura.buffs_enable == true then
													oUF_LUI_partyUnitButton1pet.Buffs:SetWidth(tonumber(PartyPetWidth))
												end
												
												if db.oUF.PartyPet.Aura.debuffs_enable == true then
													oUF_LUI_partyUnitButton1pet.Debuffs:SetWidth(tonumber(PartyPetWidth))
												end
											end,
									order = 3,
								},
							},
						},
						Appearance = {
							name = "Appearance",
							type = "group",
							disabled = function() return not db.oUF.PartyPet.Enable end,
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
									get = function() return db.oUF.PartyPet.Backdrop.Color.r, db.oUF.PartyPet.Backdrop.Color.g, db.oUF.PartyPet.Backdrop.Color.b, db.oUF.PartyPet.Backdrop.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.PartyPet.Backdrop.Color.r = r
											db.oUF.PartyPet.Backdrop.Color.g = g
											db.oUF.PartyPet.Backdrop.Color.b = b
											db.oUF.PartyPet.Backdrop.Color.a = a

											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropColor(r,g,b,a)
										end,
									order = 2,
								},
								BackdropBorderColor = {
									name = "Border Color",
									desc = "Choose a Backdrop Border Color.",
									type = "color",
									width = "full",
									hasAlpha = true,
									get = function() return db.oUF.PartyPet.Border.Color.r, db.oUF.PartyPet.Border.Color.g, db.oUF.PartyPet.Border.Color.b, db.oUF.PartyPet.Border.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.PartyPet.Border.Color.r = r
											db.oUF.PartyPet.Border.Color.g = g
											db.oUF.PartyPet.Border.Color.b = b
											db.oUF.PartyPet.Border.Color.a = a
											
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyPet.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyPet.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyPet.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyPet.Border.Insets.Left), right = tonumber(db.oUF.PartyPet.Border.Insets.Right), top = tonumber(db.oUF.PartyPet.Border.Insets.Top), bottom = tonumber(db.oUF.PartyPet.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyPet.Backdrop.Color.r), tonumber(db.oUF.PartyPet.Backdrop.Color.g), tonumber(db.oUF.PartyPet.Backdrop.Color.b), tonumber(db.oUF.PartyPet.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyPet.Border.Color.r), tonumber(db.oUF.PartyPet.Border.Color.g), tonumber(db.oUF.PartyPet.Border.Color.b), tonumber(db.oUF.PartyPet.Border.Color.a))
										end,
									order = 3,
								},
								header2 = {
									name = "Backdrop Settings",
									type = "header",
									order = 4,
								},
								BackdropTexture = {
									name = "Backdrop Texture",
									desc = "Choose your Backdrop Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Backdrop.Texture,
									type = "select",
									dialogControl = "LSM30_Background",
									values = widgetLists.background,
									get = function() return db.oUF.PartyPet.Backdrop.Texture end,
									set = function(self, BackdropTexture)
											db.oUF.PartyPet.Backdrop.Texture = BackdropTexture
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyPet.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyPet.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyPet.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyPet.Border.Insets.Left), right = tonumber(db.oUF.PartyPet.Border.Insets.Right), top = tonumber(db.oUF.PartyPet.Border.Insets.Top), bottom = tonumber(db.oUF.PartyPet.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyPet.Backdrop.Color.r), tonumber(db.oUF.PartyPet.Backdrop.Color.g), tonumber(db.oUF.PartyPet.Backdrop.Color.b), tonumber(db.oUF.PartyPet.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyPet.Border.Color.r), tonumber(db.oUF.PartyPet.Border.Color.g), tonumber(db.oUF.PartyPet.Border.Color.b), tonumber(db.oUF.PartyPet.Border.Color.a))
										end,
									order = 5,
								},
								BorderTexture = {
									name = "Border Texture",
									desc = "Choose your Border Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Border.EdgeFile,
									type = "select",
									dialogControl = "LSM30_Border",
									values = widgetLists.border,
									get = function() return db.oUF.PartyPet.Border.EdgeFile end,
									set = function(self, BorderTexture)
											db.oUF.PartyPet.Border.EdgeFile = BorderTexture
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyPet.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyPet.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyPet.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyPet.Border.Insets.Left), right = tonumber(db.oUF.PartyPet.Border.Insets.Right), top = tonumber(db.oUF.PartyPet.Border.Insets.Top), bottom = tonumber(db.oUF.PartyPet.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyPet.Backdrop.Color.r), tonumber(db.oUF.PartyPet.Backdrop.Color.g), tonumber(db.oUF.PartyPet.Backdrop.Color.b), tonumber(db.oUF.PartyPet.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyPet.Border.Color.r), tonumber(db.oUF.PartyPet.Border.Color.g), tonumber(db.oUF.PartyPet.Border.Color.b), tonumber(db.oUF.PartyPet.Border.Color.a))
										end,
									order = 6,
								},
								BorderSize = {
									name = "Edge Size",
									desc = "Choose the Edge Size for your Frame Border.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Border.EdgeSize,
									type = "range",
									min = 1,
									max = 50,
									step = 1,
									get = function() return db.oUF.PartyPet.Border.EdgeSize end,
									set = function(_, BorderSize) 
											db.oUF.PartyPet.Border.EdgeSize = BorderSize
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyPet.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyPet.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyPet.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyPet.Border.Insets.Left), right = tonumber(db.oUF.PartyPet.Border.Insets.Right), top = tonumber(db.oUF.PartyPet.Border.Insets.Top), bottom = tonumber(db.oUF.PartyPet.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyPet.Backdrop.Color.r), tonumber(db.oUF.PartyPet.Backdrop.Color.g), tonumber(db.oUF.PartyPet.Backdrop.Color.b), tonumber(db.oUF.PartyPet.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyPet.Border.Color.r), tonumber(db.oUF.PartyPet.Border.Color.g), tonumber(db.oUF.PartyPet.Border.Color.b), tonumber(db.oUF.PartyPet.Border.Color.a))
										end,
									order = 7,
								},
								header3 = {
									name = "Backdrop Padding",
									type = "header",
									order = 8,
								},
								PaddingLeft = {
									name = "Left",
									desc = "Value for the Left Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Backdrop.Padding.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyPet.Backdrop.Padding.Left end,
									set = function(self,PaddingLeft)
										if PaddingLeft == nil or PaddingLeft == "" then
											PaddingLeft = "0"
										end
										db.oUF.PartyPet.Backdrop.Padding.Left = PaddingLeft
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1pet, "TOPLEFT", tonumber(db.oUF.PartyPet.Backdrop.Padding.Left), tonumber(db.oUF.PartyPet.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1pet, "BOTTOMRIGHT", tonumber(db.oUF.PartyPet.Backdrop.Padding.Right), tonumber(db.oUF.PartyPet.Backdrop.Padding.Bottom))
									end,
									order = 9,
								},
								PaddingRight = {
									name = "Right",
									desc = "Value for the Right Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Backdrop.Padding.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyPet.Backdrop.Padding.Right end,
									set = function(self,PaddingRight)
										if PaddingRight == nil or PaddingRight == "" then
											PaddingRight = "0"
										end
										db.oUF.PartyPet.Backdrop.Padding.Right = PaddingRight
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1pet, "TOPLEFT", tonumber(db.oUF.PartyPet.Backdrop.Padding.Left), tonumber(db.oUF.PartyPet.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1pet, "BOTTOMRIGHT", tonumber(db.oUF.PartyPet.Backdrop.Padding.Right), tonumber(db.oUF.PartyPet.Backdrop.Padding.Bottom))
									end,
									order = 10,
								},
								PaddingTop = {
									name = "Top",
									desc = "Value for the Top Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Backdrop.Padding.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyPet.Backdrop.Padding.Top end,
									set = function(self,PaddingTop)
										if PaddingTop == nil or PaddingTop == "" then
											PaddingTop = "0"
										end
										db.oUF.PartyPet.Backdrop.Padding.Top = PaddingTop
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1pet, "TOPLEFT", tonumber(db.oUF.PartyPet.Backdrop.Padding.Left), tonumber(db.oUF.PartyPet.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1pet, "BOTTOMRIGHT", tonumber(db.oUF.PartyPet.Backdrop.Padding.Right), tonumber(db.oUF.PartyPet.Backdrop.Padding.Bottom))
									end,
									order = 11,
								},
								PaddingBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Backdrop.Padding.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyPet.Backdrop.Padding.Bottom end,
									set = function(self,PaddingBottom)
										if PaddingBottom == nil or PaddingBottom == "" then
											PaddingBottom = "0"
										end
										db.oUF.PartyPet.Backdrop.Padding.Bottom = PaddingBottom
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1pet, "TOPLEFT", tonumber(db.oUF.PartyPet.Backdrop.Padding.Left), tonumber(db.oUF.PartyPet.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1pet, "BOTTOMRIGHT", tonumber(db.oUF.PartyPet.Backdrop.Padding.Right), tonumber(db.oUF.PartyPet.Backdrop.Padding.Bottom))
									end,
									order = 12,
								},
								header4 = {
									name = "Boder Insets",
									type = "header",
									order = 13,
								},
								InsetLeft = {
									name = "Left",
									desc = "Value for the Left Border Inset\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Border.Insets.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyPet.Border.Insets.Left end,
									set = function(self,InsetLeft)
										if InsetLeft == nil or InsetLeft == "" then
											InsetLeft = "0"
										end
										db.oUF.PartyPet.Border.Insets.Left = InsetLeft
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyPet.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyPet.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyPet.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyPet.Border.Insets.Left), right = tonumber(db.oUF.PartyPet.Border.Insets.Right), top = tonumber(db.oUF.PartyPet.Border.Insets.Top), bottom = tonumber(db.oUF.PartyPet.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyPet.Backdrop.Color.r), tonumber(db.oUF.PartyPet.Backdrop.Color.g), tonumber(db.oUF.PartyPet.Backdrop.Color.b), tonumber(db.oUF.PartyPet.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyPet.Border.Color.r), tonumber(db.oUF.PartyPet.Border.Color.g), tonumber(db.oUF.PartyPet.Border.Color.b), tonumber(db.oUF.PartyPet.Border.Color.a))
											end,
									order = 14,
								},
								InsetRight = {
									name = "Right",
									desc = "Value for the Right Border Inset\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Border.Insets.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyPet.Border.Insets.Right end,
									set = function(self,InsetRight)
										if InsetRight == nil or InsetRight == "" then
											InsetRight = "0"
										end
										db.oUF.PartyPet.Border.Insets.Right = InsetRight
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyPet.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyPet.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyPet.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyPet.Border.Insets.Left), right = tonumber(db.oUF.PartyPet.Border.Insets.Right), top = tonumber(db.oUF.PartyPet.Border.Insets.Top), bottom = tonumber(db.oUF.PartyPet.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyPet.Backdrop.Color.r), tonumber(db.oUF.PartyPet.Backdrop.Color.g), tonumber(db.oUF.PartyPet.Backdrop.Color.b), tonumber(db.oUF.PartyPet.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyPet.Border.Color.r), tonumber(db.oUF.PartyPet.Border.Color.g), tonumber(db.oUF.PartyPet.Border.Color.b), tonumber(db.oUF.PartyPet.Border.Color.a))
											end,
									order = 15,
								},
								InsetTop = {
									name = "Top",
									desc = "Value for the Top Border Inset\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Border.Insets.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyPet.Border.Insets.Top end,
									set = function(self,InsetTop)
										if InsetTop == nil or InsetTop == "" then
											InsetTop = "0"
										end
										db.oUF.PartyPet.Border.Insets.Top = InsetTop
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyPet.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyPet.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyPet.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyPet.Border.Insets.Left), right = tonumber(db.oUF.PartyPet.Border.Insets.Right), top = tonumber(db.oUF.PartyPet.Border.Insets.Top), bottom = tonumber(db.oUF.PartyPet.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyPet.Backdrop.Color.r), tonumber(db.oUF.PartyPet.Backdrop.Color.g), tonumber(db.oUF.PartyPet.Backdrop.Color.b), tonumber(db.oUF.PartyPet.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyPet.Border.Color.r), tonumber(db.oUF.PartyPet.Border.Color.g), tonumber(db.oUF.PartyPet.Border.Color.b), tonumber(db.oUF.PartyPet.Border.Color.a))
											end,
									order = 16,
								},
								InsetBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Border Inset\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Border.Insets.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyPet.Border.Insets.Bottom end,
									set = function(self,InsetBottom)
										if InsetBottom == nil or InsetBottom == "" then
											InsetBottom = "0"
										end
										db.oUF.PartyPet.Border.Insets.Bottom = InsetBottom
										oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyPet.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyPet.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyPet.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyPet.Border.Insets.Left), right = tonumber(db.oUF.PartyPet.Border.Insets.Right), top = tonumber(db.oUF.PartyPet.Border.Insets.Top), bottom = tonumber(db.oUF.PartyPet.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyPet.Backdrop.Color.r), tonumber(db.oUF.PartyPet.Backdrop.Color.g), tonumber(db.oUF.PartyPet.Backdrop.Color.b), tonumber(db.oUF.PartyPet.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1pet.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyPet.Border.Color.r), tonumber(db.oUF.PartyPet.Border.Color.g), tonumber(db.oUF.PartyPet.Border.Color.b), tonumber(db.oUF.PartyPet.Border.Color.a))
											end,
									order = 17,
								},
							},
						},
						AlphaFader = {
							name = "Fader",
							type = "group",
							disabled = function() return not db.oUF.PartyPet.Enable end,
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
					disabled = function() return not db.oUF.PartyPet.Enable end,
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
											desc = "Decide the Height of your Party Pet Health.\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Health.Height,
											type = "input",
											get = function() return db.oUF.PartyPet.Health.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.PartyPet.Health.Height = Height
														oUF_LUI_partyUnitButton1pet.Health:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Health.Padding,
											type = "input",
											get = function() return db.oUF.PartyPet.Health.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.PartyPet.Health.Padding = Padding
														oUF_LUI_partyUnitButton1pet.Health:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Health:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1pet, "TOPLEFT", 0, tonumber(Padding))
														oUF_LUI_partyUnitButton1pet.Health:SetPoint("TOPRIGHT", oUF_LUI_partyUnitButton1pet, "TOPRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.PartyPet.Health.Smooth end,
											set = function(self,Smooth)
														db.oUF.PartyPet.Health.Smooth = not db.oUF.PartyPet.Health.Smooth
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
											get = function() return db.oUF.PartyPet.Health.ColorClass end,
											set = function(self,HealthClassColor)
														db.oUF.PartyPet.Health.ColorClass = true
														db.oUF.PartyPet.Health.ColorGradient = false
														db.oUF.PartyPet.Health.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Health.colorClass = true
														oUF_LUI_partyUnitButton1pet.Health.colorGradient = false
														oUF_LUI_partyUnitButton1pet.Health.colorIndividual.Enable = false
															
														print("Party Pet Healthbar Color will change once you gain/lose HP")
													end,
											order = 1,
										},
										HealthGradientColor = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthBars or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Health.ColorGradient end,
											set = function(self,HealthGradientColor)
														db.oUF.PartyPet.Health.ColorGradient = true
														db.oUF.PartyPet.Health.ColorClass = false
														db.oUF.PartyPet.Health.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Health.colorGradient = true
														oUF_LUI_partyUnitButton1pet.Health.colorClass = false
														oUF_LUI_partyUnitButton1pet.Health.colorIndividual.Enable = false
															
														print("Party Pet Healthbar Color will change once you gain/lose HP")
													end,
											order = 2,
										},
										IndividualHealthColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual HealthBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Health.IndividualColor.Enable end,
											set = function(self,IndividualHealthColor)
														db.oUF.PartyPet.Health.IndividualColor.Enable = true
														db.oUF.PartyPet.Health.ColorClass = false
														db.oUF.PartyPet.Health.ColorGradient = false
															
														oUF_LUI_partyUnitButton1pet.Health.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1pet.Health.colorClass = false
														oUF_LUI_partyUnitButton1pet.Health.colorGradient = false
															
														oUF_LUI_partyUnitButton1pet.Health:SetStatusBarColor(db.oUF.PartyPet.Health.IndividualColor.r, db.oUF.PartyPet.Health.IndividualColor.g, db.oUF.PartyPet.Health.IndividualColor.b)
														oUF_LUI_partyUnitButton1pet.Health.bg:SetVertexColor(db.oUF.PartyPet.Health.IndividualColor.r*tonumber(db.oUF.PartyPet.Health.BGMultiplier), db.oUF.PartyPet.Health.IndividualColor.g*tonumber(db.oUF.PartyPet.Health.BGMultiplier), db.oUF.PartyPet.Health.IndividualColor.b*tonumber(db.oUF.PartyPet.Health.BGMultiplier))
													end,
											order = 3,
										},
										HealthColor = {
											name = "Individual Color",
											desc = "Choose an individual Healthbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyPet.Health.IndividualColor.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyPet.Health.IndividualColor.r, db.oUF.PartyPet.Health.IndividualColor.g, db.oUF.PartyPet.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyPet.Health.IndividualColor.r = r
													db.oUF.PartyPet.Health.IndividualColor.g = g
													db.oUF.PartyPet.Health.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1pet.Health.colorIndividual.r = r
													oUF_LUI_partyUnitButton1pet.Health.colorIndividual.g = g
													oUF_LUI_partyUnitButton1pet.Health.colorIndividual.b = b
														
													oUF_LUI_partyUnitButton1pet.Health:SetStatusBarColor(r, g, b)
													oUF_LUI_partyUnitButton1pet.Health.bg:SetVertexColor(r*tonumber(db.oUF.PartyPet.Health.BGMultiplier), g*tonumber(db.oUF.PartyPet.Health.BGMultiplier), b*tonumber(db.oUF.PartyPet.Health.BGMultiplier))
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
											desc = "Choose your Health Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Health.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.PartyPet.Health.Texture
												end,
											set = function(self, HealthTex)
													db.oUF.PartyPet.Health.Texture = HealthTex
													oUF_LUI_partyUnitButton1pet.Health:SetStatusBarTexture(LSM:Fetch("statusbar", HealthTex))
												end,
											order = 1,
										},
										HealthTexBG = {
											name = "Background Texture",
											desc = "Choose your Health Background Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Health.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.PartyPet.Health.TextureBG
												end,
											set = function(self, HealthTexBG)
													db.oUF.PartyPet.Health.TextureBG = HealthTexBG
													oUF_LUI_partyUnitButton1pet.Health.bg:SetTexture(LSM:Fetch("statusbar", HealthTexBG))
												end,
											order = 2,
										},
										HealthTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Health Background.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Health.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.PartyPet.Health.BGAlpha end,
											set = function(_, HealthTexBGAlpha) 
													db.oUF.PartyPet.Health.BGAlpha  = HealthTexBGAlpha
													oUF_LUI_partyUnitButton1pet.Health.bg:SetAlpha(tonumber(HealthTexBGAlpha))
												end,
											order = 3,
										},
										HealthTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Health.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.PartyPet.Health.BGMultiplier end,
											set = function(_, HealthTexBGMultiplier) 
													db.oUF.PartyPet.Health.BGMultiplier  = HealthTexBGMultiplier
													oUF_LUI_partyUnitButton1pet.Health.bg.multiplier = tonumber(HealthTexBGMultiplier)
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
									get = function() return db.oUF.PartyPet.Power.Enable end,
									set = function(self,EnablePower)
												db.oUF.PartyPet.Power.Enable = not db.oUF.PartyPet.Power.Enable
												if EnablePower == true then
													oUF_LUI_partyUnitButton1pet.Power:Show()
												else
													oUF_LUI_partyUnitButton1pet.Power:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "General Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Power.Enable end,
									guiInline = true,

									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your PartyPet Power.\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Power.Height,
											type = "input",
											get = function() return db.oUF.PartyPet.Power.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.PartyPet.Power.Height = Height
														oUF_LUI_partyUnitButton1pet.Power:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Power.Padding,
											type = "input",
											get = function() return db.oUF.PartyPet.Power.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.PartyPet.Power.Padding = Padding
														oUF_LUI_partyUnitButton1pet.Power:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Power:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1pet.Health, "BOTTOMLEFT", 0, tonumber(Padding))
														oUF_LUI_partyUnitButton1pet.Power:SetPoint("TOPRIGHT", oUF_LUI_partyUnitButton1pet.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.PartyPet.Power.Smooth end,
											set = function(self,Smooth)
														db.oUF.PartyPet.Power.Smooth = not db.oUF.PartyPet.Power.Smooth
														StaticPopup_Show("RELOAD_UI")
													end,
											order = 3,
										},
									}
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Power.Enable end,
									guiInline = true,
									order = 3,
									args = {
										PowerClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Power.ColorClass end,
											set = function(self,PowerClassColor)
														db.oUF.PartyPet.Power.ColorClass = true
														db.oUF.PartyPet.Power.ColorType = false
														db.oUF.PartyPet.Power.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Power.colorClass = true
														oUF_LUI_partyUnitButton1pet.Power.colorType = false
														oUF_LUI_partyUnitButton1pet.Power.colorIndividual.Enable = false
														
														print("PartyPet Powerbar Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										PowerColorByType = {
											name = "Color by Type",
											desc = "Wether you want to use Power Type colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Power.ColorType end,
											set = function(self,PowerColorByType)
														db.oUF.PartyPet.Power.ColorType = true
														db.oUF.PartyPet.Power.ColorClass = false
														db.oUF.PartyPet.Power.IndividualColor.Enable = false
																
														oUF_LUI_partyUnitButton1pet.Power.colorType = true
														oUF_LUI_partyUnitButton1pet.Power.colorClass = false
														oUF_LUI_partyUnitButton1pet.Power.colorIndividual.Enable = false
															
														print("PartyPet Powerbar Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualPowerColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PowerBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Power.IndividualColor.Enable end,
											set = function(self,IndividualPowerColor)
														db.oUF.PartyPet.Power.IndividualColor.Enable = true
														db.oUF.PartyPet.Power.ColorType = false
														db.oUF.PartyPet.Power.ColorClass = false
																
														oUF_LUI_partyUnitButton1pet.Power.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1pet.Power.colorClass = false
														oUF_LUI_partyUnitButton1pet.Power.colorType = false
															
														oUF_LUI_partyUnitButton1pet.Power:SetStatusBarColor(db.oUF.PartyPet.Power.IndividualColor.r, db.oUF.PartyPet.Power.IndividualColor.g, db.oUF.PartyPet.Power.IndividualColor.b)
														oUF_LUI_partyUnitButton1pet.Power.bg:SetVertexColor(db.oUF.PartyPet.Power.IndividualColor.r*tonumber(db.oUF.PartyPet.Power.BGMultiplier), db.oUF.PartyPet.Power.IndividualColor.g*tonumber(db.oUF.PartyPet.Power.BGMultiplier), db.oUF.PartyPet.Power.IndividualColor.b*tonumber(db.oUF.PartyPet.Power.BGMultiplier))
													end,
											order = 3,
										},
										PowerColor = {
											name = "Individual Color",
											desc = "Choose an individual Powerbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyPet.Power.IndividualColor.Enable or not db.oUF.PartyPet.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyPet.Power.IndividualColor.r, db.oUF.PartyPet.Power.IndividualColor.g, db.oUF.PartyPet.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyPet.Power.IndividualColor.r = r
													db.oUF.PartyPet.Power.IndividualColor.g = g
													db.oUF.PartyPet.Power.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1pet.Power.colorIndividual.r = r
													oUF_LUI_partyUnitButton1pet.Power.colorIndividual.g = g
													oUF_LUI_partyUnitButton1pet.Power.colorIndividual.b = b
														
													oUF_LUI_partyUnitButton1pet.Power:SetStatusBarColor(r, g, b)
													oUF_LUI_partyUnitButton1pet.Power.bg:SetVertexColor(r*tonumber(db.oUF.PartyPet.Power.BGMultiplier), g*tonumber(db.oUF.PartyPet.Power.BGMultiplier), b*tonumber(db.oUF.PartyPet.Power.BGMultiplier))
												end,
											order = 4,
										},
									},
								},
								Textures = {
									name = "Texture Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Power.Enable end,
									guiInline = true,
									order = 4,
									args = {
										PowerTex = {
											name = "Texture",
											desc = "Choose your Power Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Power.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.PartyPet.Power.Texture
												end,
											set = function(self, PowerTex)
													db.oUF.PartyPet.Power.Texture = PowerTex
													oUF_LUI_partyUnitButton1pet.Power:SetStatusBarTexture(LSM:Fetch("statusbar", PowerTex))
												end,
											order = 1,
										},
										PowerTexBG = {
											name = "Background Texture",
											desc = "Choose your Power Background Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Power.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.PartyPet.Power.TextureBG
												end,

											set = function(self, PowerTexBG)
													db.oUF.PartyPet.Power.TextureBG = PowerTexBG
													oUF_LUI_partyUnitButton1pet.Power.bg:SetTexture(LSM:Fetch("statusbar", PowerTexBG))
												end,
											order = 2,
										},
										PowerTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Power Background.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Power.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.PartyPet.Power.BGAlpha end,
											set = function(_, PowerTexBGAlpha) 
													db.oUF.PartyPet.Power.BGAlpha  = PowerTexBGAlpha
													oUF_LUI_partyUnitButton1pet.Power.bg:SetAlpha(tonumber(PowerTexBGAlpha))
												end,
											order = 3,
										},
										PowerTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Power.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.PartyPet.Power.BGMultiplier end,
											set = function(_, PowerTexBGMultiplier) 
													db.oUF.PartyPet.Power.BGMultiplier  = PowerTexBGMultiplier
													oUF_LUI_partyUnitButton1pet.Power.bg.multiplier = tonumber(PowerTexBGMultiplier)
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
									get = function() return db.oUF.PartyPet.Full.Enable end,
									set = function(self,EnableFullbar)
												db.oUF.PartyPet.Full.Enable = not db.oUF.PartyPet.Full.Enable
												if EnableFullbar == true then
													oUF_LUI_partyUnitButton1pet_Full:Show()
												else
													oUF_LUI_partyUnitButton1pet_Full:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Full.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your Fullbar.\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Full.Height,
											type = "input",
											get = function() return db.oUF.PartyPet.Full.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.PartyPet.Full.Height = Height
														oUF_LUI_partyUnitButton1pet_Full:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Fullbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Full.Padding,
											type = "input",
											get = function() return db.oUF.PartyPet.Full.Padding end,
											set = function(self,Padding)
													if Padding == nil or Padding == "" then
														Padding = "0"
													end
													db.oUF.PartyPet.Full.Padding = Padding
													oUF_LUI_partyUnitButton1pet_Full:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet_Full:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1pet.Health, "BOTTOMLEFT", 0, tonumber(Padding))
													oUF_LUI_partyUnitButton1pet_Full:SetPoint("TOPRIGHT", oUF_LUI_partyUnitButton1pet.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
												end,
											order = 2,
										},
										FullTex = {
											name = "Texture",
											desc = "Choose your Fullbar Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Full.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.PartyPet.Full.Texture
												end,
											set = function(self, FullTex)
													db.oUF.PartyPet.Full.Texture = FullTex
													oUF_LUI_partyUnitButton1pet_Full:SetStatusBarTexture(LSM:Fetch("statusbar", FullTex))
												end,
											order = 3,
										},
										FullAlpha = {
											name = "Alpha",
											desc = "Choose the Alpha Value for your Fullbar!\n Default: "..LUI.defaults.profile.oUF.PartyPet.Full.Alpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.PartyPet.Full.Alpha end,
											set = function(_, FullAlpha)
													db.oUF.PartyPet.Full.Alpha = FullAlpha
													oUF_LUI_partyUnitButton1pet_Full:SetAlpha(FullAlpha)
												end,
											order = 4,
										},
										Color = {
											name = "Color",
											desc = "Choose your Fullbar Color.",
											type = "color",
											hasAlpha = true,
											get = function() return db.oUF.PartyPet.Full.Color.r, db.oUF.PartyPet.Full.Color.g, db.oUF.PartyPet.Full.Color.b, db.oUF.PartyPet.Full.Color.a end,
											set = function(_,r,g,b,a)
													db.oUF.PartyPet.Full.Color.r = r
													db.oUF.PartyPet.Full.Color.g = g
													db.oUF.PartyPet.Full.Color.b = b
													db.oUF.PartyPet.Full.Color.a = a
													
													oUF_LUI_partyUnitButton1pet_Full:SetStatusBarColor(r, g, b, a)
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
					disabled = function() return not db.oUF.PartyPet.Enable end,
					order = 6,
					args = {
						Name = {
							name = "Name",
							type = "group",
							order = 1,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the PartyPet Name or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyPet.Texts.Name.Enable end,
									set = function(self,Enable)
												db.oUF.PartyPet.Texts.Name.Enable = not db.oUF.PartyPet.Texts.Name.Enable
												if Enable == true then
													oUF_LUI_partyUnitButton1pet.Info:Show()
												else
													oUF_LUI_partyUnitButton1pet.Info:Hide()
												end
											end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyPet Name Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyPet.Texts.Name.Size,
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyPet.Texts.Name.Size end,
											set = function(_, FontSize)
													db.oUF.PartyPet.Texts.Name.Size = FontSize
													oUF_LUI_partyUnitButton1pet.Info:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.Name.Font),db.oUF.PartyPet.Texts.Name.Size,db.oUF.PartyPet.Texts.Name.Outline)
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
											desc = "Choose your Font for PartyPet Name!\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Name.Font,
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyPet.Texts.Name.Font end,
											set = function(self, Font)
													db.oUF.PartyPet.Texts.Name.Font = Font
													oUF_LUI_partyUnitButton1pet.Info:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.Name.Font),db.oUF.PartyPet.Texts.Name.Size,db.oUF.PartyPet.Texts.Name.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyPet Name.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Name.Outline,
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyPet.Texts.Name.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyPet.Texts.Name.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1pet.Info:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.Name.Font),db.oUF.PartyPet.Texts.Name.Size,db.oUF.PartyPet.Texts.Name.Outline)
												end,
											order = 4,
										},
										NameX = {
											name = "X Value",
											desc = "X Value for your PartyPet Name.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Name.X,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Name.X end,
											set = function(self,NameX)
														if NameX == nil or NameX == "" then
															NameX = "0"
														end
														db.oUF.PartyPet.Texts.Name.X = NameX
														oUF_LUI_partyUnitButton1pet.Info:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Info:SetPoint(db.oUF.PartyPet.Texts.Name.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Name.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Name.X), tonumber(db.oUF.PartyPet.Texts.Name.Y))
													end,
											order = 5,
										},
										NameY = {
											name = "Y Value",
											desc = "Y Value for your PartyPet Name.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Name.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Name.Y end,
											set = function(self,NameY)
														if NameY == nil or NameY == "" then
															NameY = "0"
														end
														db.oUF.PartyPet.Texts.Name.Y = NameY
														oUF_LUI_partyUnitButton1pet.Info:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Info:SetPoint(db.oUF.PartyPet.Texts.Name.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Name.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Name.X), tonumber(db.oUF.PartyPet.Texts.Name.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyPet Name.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Name.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.Name.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyPet.Texts.Name.Point = positions[Point]
													oUF_LUI_partyUnitButton1pet.Info:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Info:SetPoint(db.oUF.PartyPet.Texts.Name.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Name.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Name.X), tonumber(db.oUF.PartyPet.Texts.Name.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyPet Name.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Name.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.Name.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyPet.Texts.Name.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1pet.Info:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Info:SetPoint(db.oUF.PartyPet.Texts.Name.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Name.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Name.X), tonumber(db.oUF.PartyPet.Texts.Name.Y))
												end,
											order = 8,
										},
									},
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Format = {
											name = "Format",
											desc = "Choose the Format for your PartyPet Name.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Name.Format,
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											type = "select",
											width = "full",
											values = nameFormat,

											get = function()
													for k, v in pairs(nameFormat) do
														if db.oUF.PartyPet.Texts.Name.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.PartyPet.Texts.Name.Format = nameFormat[Format]
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 1,
										},
										Length = {
											name = "Length",
											desc = "Choose the Length of your PartyPet Name.\n\nShort = 6 Letters\nMedium = 18 Letters\nLong = 36 Letters\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Name.Length,
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											type = "select",
											values = nameLenghts,
											get = function()
													for k, v in pairs(nameLenghts) do
														if db.oUF.PartyPet.Texts.Name.Length == v then
															return k
														end
													end
												end,
											set = function(self, Length)
													db.oUF.PartyPet.Texts.Name.Length = nameLenghts[Length]
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
											desc = "Wether you want to color the PartyPet Name by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Name.ColorNameByClass end,
											set = function(self,ColorNameByClass)
													db.oUF.PartyPet.Texts.Name.ColorNameByClass = not db.oUF.PartyPet.Texts.Name.ColorNameByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 4,
										},
										ColorClassByClass = {
											name = "Color Class by Class",
											desc = "Wether you want to color the PartyPet Class by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Name.ColorClassByClass end,
											set = function(self,ColorClassByClass)
													db.oUF.PartyPet.Texts.Name.ColorClassByClass = not db.oUF.PartyPet.Texts.Name.ColorClassByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 5,
										},
										ColorLevelByDifficulty = {
											name = "Color Level by Difficulty",
											desc = "Wether you want to color the Level by Difficulty or not.",
											type = "toggle",
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Name.ColorLevelByDifficulty end,
											set = function(self,ColorLevelByDifficulty)
													db.oUF.PartyPet.Texts.Name.ColorLevelByDifficulty = not db.oUF.PartyPet.Texts.Name.ColorLevelByDifficulty
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 6,
										},
										ShowClassification = {
											name = "Show Classification",
											desc = "Wether you want to show Classifications like Elite, Boss, Rar or not.",
											type = "toggle",
											disabled = function() return not db.oUF.PartyPet.Texts.Name.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Name.ShowClassification end,
											set = function(self,ShowClassification)
													db.oUF.PartyPet.Texts.Name.ShowClassification = not db.oUF.PartyPet.Texts.Name.ShowClassification
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 7,
										},
										ShortClassification = {
											name = "Enable Short Classification",
											desc = "Wether you want to show short Classifications or not.",
											type = "toggle",
											width = "full",
											disabled = function() return not db.oUF.PartyPet.Texts.Name.ShowClassification or not db.oUF.PartyPet.Texts.Name.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Name.ShortClassification end,
											set = function(self,ShortClassification)
													db.oUF.PartyPet.Texts.Name.ShortClassification = not db.oUF.PartyPet.Texts.Name.ShortClassification
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
									desc = "Wether you want to show the PartyPet Health or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyPet.Texts.Health.Enable end,
									set = function(self,Enable)
											db.oUF.PartyPet.Texts.Health.Enable = not db.oUF.PartyPet.Texts.Health.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1pet.Health.value:Show()
											else
												oUF_LUI_partyUnitButton1pet.Health.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.Health.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyPet Health Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyPet.Texts.Health.Size,
											disabled = function() return not db.oUF.PartyPet.Texts.Health.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyPet.Texts.Health.Size end,
											set = function(_, FontSize)
													db.oUF.PartyPet.Texts.Health.Size = FontSize
													oUF_LUI_partyUnitButton1pet.Health.value:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.Health.Font),db.oUF.PartyPet.Texts.Health.Size,db.oUF.PartyPet.Texts.Health.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your PartyPet Health.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Health.Format,
											disabled = function() return not db.oUF.PartyPet.Texts.Health.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.PartyPet.Texts.Health.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.PartyPet.Texts.Health.Format = valueFormat[Format]
													oUF_LUI_partyUnitButton1pet.Health.value.Format = valueFormat[Format]
													print("PartyPet Health Value Format will change once you gain/lose Health")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyPet Health!\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Health.Font,
											disabled = function() return not db.oUF.PartyPet.Texts.Health.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyPet.Texts.Health.Font end,
											set = function(self, Font)
													db.oUF.PartyPet.Texts.Health.Font = Font
													oUF_LUI_partyUnitButton1pet.Health.value:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.Health.Font),db.oUF.PartyPet.Texts.Health.Size,db.oUF.PartyPet.Texts.Health.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyPet Health.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Health.Outline,
											disabled = function() return not db.oUF.PartyPet.Texts.Health.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyPet.Texts.Health.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyPet.Texts.Health.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1pet.Health.value:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.Health.Font),db.oUF.PartyPet.Texts.Health.Size,db.oUF.PartyPet.Texts.Health.Outline)
												end,
											order = 4,
										},
										HealthX = {
											name = "X Value",
											desc = "X Value for your PartyPet Health.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Health.X,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.Health.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Health.X end,
											set = function(self,HealthX)
														if HealthX == nil or HealthX == "" then
															HealthX = "0"
														end
														db.oUF.PartyPet.Texts.Health.X = HealthX
														oUF_LUI_partyUnitButton1pet.Health.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Health.value:SetPoint(db.oUF.PartyPet.Texts.Health.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Health.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Health.X), tonumber(db.oUF.PartyPet.Texts.Health.Y))
													end,
											order = 5,
										},
										HealthY = {
											name = "Y Value",
											desc = "Y Value for your PartyPet Health.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Health.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.Health.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Health.Y end,
											set = function(self,HealthY)
														if HealthY == nil or HealthY == "" then
															HealthY = "0"
														end
														db.oUF.PartyPet.Texts.Health.Y = HealthY
														oUF_LUI_partyUnitButton1pet.Health.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Health.value:SetPoint(db.oUF.PartyPet.Texts.Health.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Health.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Health.X), tonumber(db.oUF.PartyPet.Texts.Health.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyPet Health.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Health.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.Health.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyPet.Texts.Health.Point = positions[Point]
													oUF_LUI_partyUnitButton1pet.Health.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Health.value:SetPoint(db.oUF.PartyPet.Texts.Health.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Health.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Health.X), tonumber(db.oUF.PartyPet.Texts.Health.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyPet Health.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Health.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.Health.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyPet.Texts.Health.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1pet.Health.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Health.value:SetPoint(db.oUF.PartyPet.Texts.Health.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Health.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Health.X), tonumber(db.oUF.PartyPet.Texts.Health.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.Health.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.Health.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyPet.Texts.Health.ColorClass = true
														db.oUF.PartyPet.Texts.Health.ColorGradient = false
														db.oUF.PartyPet.Texts.Health.IndividualColor.Enable = false
														
														oUF_LUI_partyUnitButton1pet.Health.value.colorClass = true
														oUF_LUI_partyUnitButton1pet.Health.value.colorGradient = false
														oUF_LUI_partyUnitButton1pet.Health.value.colorIndividual.Enable = false
															
														print("PartyPet Health Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.Health.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.PartyPet.Texts.Health.ColorGradient = true
														db.oUF.PartyPet.Texts.Health.ColorClass = false
														db.oUF.PartyPet.Texts.Health.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Health.value.colorGradient = true
														oUF_LUI_partyUnitButton1pet.Health.value.colorClass = false
														oUF_LUI_partyUnitButton1pet.Health.value.colorIndividual.Enable = false
															
														print("PartyPet Health Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyPet Health Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.Health.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyPet.Texts.Health.IndividualColor.Enable = true
														db.oUF.PartyPet.Texts.Health.ColorClass = false
														db.oUF.PartyPet.Texts.Health.ColorGradient = false
															
														oUF_LUI_partyUnitButton1pet.Health.value.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1pet.Health.value.colorClass = false
														oUF_LUI_partyUnitButton1pet.Health.value.colorGradient = false
														
														oUF_LUI_partyUnitButton1pet.Health.value:SetTextColor(tonumber(db.oUF.PartyPet.Texts.Health.IndividualColor.r),tonumber(db.oUF.PartyPet.Texts.Health.IndividualColor.g),tonumber(db.oUF.PartyPet.Texts.Health.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyPet Health Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyPet.Texts.Health.IndividualColor.Enable or not db.oUF.PartyPet.Texts.Health.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyPet.Texts.Health.IndividualColor.r, db.oUF.PartyPet.Texts.Health.IndividualColor.g, db.oUF.PartyPet.Texts.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyPet.Texts.Health.IndividualColor.r = r
													db.oUF.PartyPet.Texts.Health.IndividualColor.g = g
													db.oUF.PartyPet.Texts.Health.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1pet.Health.value.colorIndividual.r = r
													oUF_LUI_partyUnitButton1pet.Health.value.colorIndividual.g = g
													oUF_LUI_partyUnitButton1pet.Health.value.colorIndividual.b = b
													
													oUF_LUI_partyUnitButton1pet.Health.value:SetTextColor(r,g,b)
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
											get = function() return db.oUF.PartyPet.Texts.Health.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.PartyPet.Texts.Health.ShowDead = not db.oUF.PartyPet.Texts.Health.ShowDead
														oUF_LUI_partyUnitButton1pet.Health.value.ShowDead = db.oUF.PartyPet.Texts.Health.ShowDead
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
									desc = "Wether you want to show the PartyPet Power or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyPet.Texts.Power.Enable end,
									set = function(self,Enable)
											db.oUF.PartyPet.Texts.Power.Enable = not db.oUF.PartyPet.Texts.Power.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1pet.Power.value:Show()
											else
												oUF_LUI_partyUnitButton1pet.Power.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.Power.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyPet Power Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyPet.Texts.Power.Size,
											disabled = function() return not db.oUF.PartyPet.Texts.Power.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyPet.Texts.Power.Size end,
											set = function(_, FontSize)
													db.oUF.PartyPet.Texts.Power.Size = FontSize
													oUF_LUI_partyUnitButton1pet.Power.value:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.Power.Font),db.oUF.PartyPet.Texts.Power.Size,db.oUF.PartyPet.Texts.Power.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your PartyPet Power.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Power.Format,
											disabled = function() return not db.oUF.PartyPet.Texts.Power.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.PartyPet.Texts.Power.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.PartyPet.Texts.Power.Format = valueFormat[Format]
													oUF_LUI_partyUnitButton1pet.Power.value.Format = valueFormat[Format]
													print("PartyPet Power Value Format will change once you gain/lose Power")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyPet Power!\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Power.Font,
											disabled = function() return not db.oUF.PartyPet.Texts.Power.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyPet.Texts.Power.Font end,
											set = function(self, Font)
													db.oUF.PartyPet.Texts.Power.Font = Font
													oUF_LUI_partyUnitButton1pet.Power.value:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.Power.Font),db.oUF.PartyPet.Texts.Power.Size,db.oUF.PartyPet.Texts.Power.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyPet Power.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Power.Outline,
											disabled = function() return not db.oUF.PartyPet.Texts.Power.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyPet.Texts.Power.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyPet.Texts.Power.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1pet.Power.value:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.Power.Font),db.oUF.PartyPet.Texts.Power.Size,db.oUF.PartyPet.Texts.Power.Outline)
												end,
											order = 4,
										},
										PowerX = {
											name = "X Value",
											desc = "X Value for your PartyPet Power.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Power.X,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.Power.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Power.X end,
											set = function(self,PowerX)
														if PowerX == nil or PowerX == "" then
															PowerX = "0"
														end
														db.oUF.PartyPet.Texts.Power.X = PowerX
														oUF_LUI_partyUnitButton1pet.Power.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Power.value:SetPoint(db.oUF.PartyPet.Texts.Power.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Power.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Power.X), tonumber(db.oUF.PartyPet.Texts.Power.Y))
													end,
											order = 5,
										},
										PowerY = {
											name = "Y Value",
											desc = "Y Value for your PartyPet Power.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Power.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.Power.Enable end,
											get = function() return db.oUF.PartyPet.Texts.Power.Y end,
											set = function(self,PowerY)
														if PowerY == nil or PowerY == "" then
															PowerY = "0"
														end
														db.oUF.PartyPet.Texts.Power.Y = PowerY
														oUF_LUI_partyUnitButton1pet.Power.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Power.value:SetPoint(db.oUF.PartyPet.Texts.Power.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Power.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Power.X), tonumber(db.oUF.PartyPet.Texts.Power.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyPet Power.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Power.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.Power.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyPet.Texts.Power.Point = positions[Point]
													oUF_LUI_partyUnitButton1pet.Power.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Power.value:SetPoint(db.oUF.PartyPet.Texts.Power.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Power.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Power.X), tonumber(db.oUF.PartyPet.Texts.Power.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyPet Power.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.Power.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.Power.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyPet.Texts.Power.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1pet.Power.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Power.value:SetPoint(db.oUF.PartyPet.Texts.Power.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.Power.RelativePoint, tonumber(db.oUF.PartyPet.Texts.Power.X), tonumber(db.oUF.PartyPet.Texts.Power.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.Power.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.Power.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyPet.Texts.Power.ColorClass = true
														db.oUF.PartyPet.Texts.Power.ColorType = false
														db.oUF.PartyPet.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Power.value.colorClass = true
														oUF_LUI_partyUnitButton1pet.Power.value.colorType = false
														oUF_LUI_partyUnitButton1pet.Power.value.colorIndividual.Enable = false
			
														print("PartyPet Power Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Powertype colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.Power.ColorType end,
											set = function(self,ColorType)
														db.oUF.PartyPet.Texts.Power.ColorType = true
														db.oUF.PartyPet.Texts.Power.ColorClass = false
														db.oUF.PartyPet.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Power.value.colorType = true
														oUF_LUI_partyUnitButton1pet.Power.value.colorClass = false
														oUF_LUI_partyUnitButton1pet.Power.value.colorIndividual.Enable = false
		
														print("PartyPet Power Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyPet Power Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.Power.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyPet.Texts.Power.IndividualColor.Enable = true
														db.oUF.PartyPet.Texts.Power.ColorClass = false
														db.oUF.PartyPet.Texts.Power.ColorType = false
															
														oUF_LUI_partyUnitButton1pet.Power.value.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1pet.Power.value.colorClass = false
														oUF_LUI_partyUnitButton1pet.Power.value.colorType = false
		
														oUF_LUI_partyUnitButton1pet.Power.value:SetTextColor(tonumber(db.oUF.PartyPet.Texts.Power.IndividualColor.r),tonumber(db.oUF.PartyPet.Texts.Power.IndividualColor.g),tonumber(db.oUF.PartyPet.Texts.Power.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyPet Power Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyPet.Texts.Power.IndividualColor.Enable or not db.oUF.PartyPet.Texts.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyPet.Texts.Power.IndividualColor.r, db.oUF.PartyPet.Texts.Power.IndividualColor.g, db.oUF.PartyPet.Texts.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyPet.Texts.Power.IndividualColor.r = r
													db.oUF.PartyPet.Texts.Power.IndividualColor.g = g
													db.oUF.PartyPet.Texts.Power.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1pet.Power.value.colorIndividual.r = r
													oUF_LUI_partyUnitButton1pet.Power.value.colorIndividual.g = g
													oUF_LUI_partyUnitButton1pet.Power.value.colorIndividual.b = b

													oUF_LUI_partyUnitButton1pet.Power.value:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the PartyPet HealthPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyPet.Texts.HealthPercent.Enable end,
									set = function(self,Enable)
											db.oUF.PartyPet.Texts.HealthPercent.Enable = not db.oUF.PartyPet.Texts.HealthPercent.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1pet.Health.valuePercent:Show()
											else
												oUF_LUI_partyUnitButton1pet.Health.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyPet HealthPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthPercent.Size,
											disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyPet.Texts.HealthPercent.Size end,
											set = function(_, FontSize)
													db.oUF.PartyPet.Texts.HealthPercent.Size = FontSize
													oUF_LUI_partyUnitButton1pet.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.HealthPercent.Font),db.oUF.PartyPet.Texts.HealthPercent.Size,db.oUF.PartyPet.Texts.HealthPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show PartyPet HealthPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.HealthPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.PartyPet.Texts.HealthPercent.ShowAlways = not db.oUF.PartyPet.Texts.HealthPercent.ShowAlways
													oUF_LUI_partyUnitButton1pet.Health.valuePercent.ShowAlways = db.oUF.PartyPet.Texts.HealthPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyPet HealthPercent!\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthPercent.Font,
											disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyPet.Texts.HealthPercent.Font end,
											set = function(self, Font)
													db.oUF.PartyPet.Texts.HealthPercent.Font = Font
													oUF_LUI_partyUnitButton1pet.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.HealthPercent.Font),db.oUF.PartyPet.Texts.HealthPercent.Size,db.oUF.PartyPet.Texts.HealthPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyPet HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthPercent.Outline,
											disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyPet.Texts.HealthPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyPet.Texts.HealthPercent.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1pet.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.HealthPercent.Font),db.oUF.PartyPet.Texts.HealthPercent.Size,db.oUF.PartyPet.Texts.HealthPercent.Outline)
												end,
											order = 4,
										},
										HealthPercentX = {
											name = "X Value",
											desc = "X Value for your PartyPet HealthPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthPercent.X,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.PartyPet.Texts.HealthPercent.X end,
											set = function(self,HealthPercentX)
														if HealthPercentX == nil or HealthPercentX == "" then
															HealthPercentX = "0"
														end
														db.oUF.PartyPet.Texts.HealthPercent.X = HealthPercentX
														oUF_LUI_partyUnitButton1pet.Health.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Health.valuePercent:SetPoint(db.oUF.PartyPet.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.PartyPet.Texts.HealthPercent.X), tonumber(db.oUF.PartyPet.Texts.HealthPercent.Y))
													end,
											order = 5,
										},
										HealthPercentY = {
											name = "Y Value",
											desc = "Y Value for your PartyPet HealthPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.PartyPet.Texts.HealthPercent.Y end,
											set = function(self,HealthPercentY)
														if HealthPercentY == nil or HealthPercentY == "" then
															HealthPercentY = "0"
														end
														db.oUF.PartyPet.Texts.HealthPercent.Y = HealthPercentY
														oUF_LUI_partyUnitButton1pet.Health.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Health.valuePercent:SetPoint(db.oUF.PartyPet.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.PartyPet.Texts.HealthPercent.X), tonumber(db.oUF.PartyPet.Texts.HealthPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyPet HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.HealthPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyPet.Texts.HealthPercent.Point = positions[Point]
													oUF_LUI_partyUnitButton1pet.Health.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Health.valuePercent:SetPoint(db.oUF.PartyPet.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.PartyPet.Texts.HealthPercent.X), tonumber(db.oUF.PartyPet.Texts.HealthPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyPet HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.HealthPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyPet.Texts.HealthPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1pet.Health.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Health.valuePercent:SetPoint(db.oUF.PartyPet.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.PartyPet.Texts.HealthPercent.X), tonumber(db.oUF.PartyPet.Texts.HealthPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.HealthPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyPet.Texts.HealthPercent.ColorClass = true
														db.oUF.PartyPet.Texts.HealthPercent.ColorGradient = false
														db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorClass = true
														oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorGradient = false
														oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorIndividual.Enable = false
					
														print("PartyPet HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.HealthPercent.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.PartyPet.Texts.HealthPercent.ColorGradient = true
														db.oUF.PartyPet.Texts.HealthPercent.ColorClass = false
														db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorGradient = true
														oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorIndividual.Enable = false
				
														print("PartyPet HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyPet HealthPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.Enable = true
														db.oUF.PartyPet.Texts.HealthPercent.ColorClass = false
														db.oUF.PartyPet.Texts.HealthPercent.ColorGradient = false
															
														oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorGradient = false
							
														oUF_LUI_partyUnitButton1pet.Health.valuePercent:SetTextColor(tonumber(db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.r),tonumber(db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.g),tonumber(db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyPet HealthPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.Enable or not db.oUF.PartyPet.Texts.HealthPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.r, db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.g, db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.r = r
													db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.g = g
													db.oUF.PartyPet.Texts.HealthPercent.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorIndividual.r = r
													oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorIndividual.g = g
													oUF_LUI_partyUnitButton1pet.Health.valuePercent.colorIndividual.b = b
			
													oUF_LUI_partyUnitButton1pet.Health.valuePercent:SetTextColor(r,g,b)
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
											get = function() return db.oUF.PartyPet.Texts.HealthPercent.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.PartyPet.Texts.HealthPercent.ShowDead = not db.oUF.PartyPet.Texts.HealthPercent.ShowDead
														oUF_LUI_partyUnitButton1pet.Health.valuePercent.ShowDead = db.oUF.PartyPet.Texts.HealthPercent.ShowDead
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
									desc = "Wether you want to show the PartyPet PowerPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyPet.Texts.PowerPercent.Enable end,
									set = function(self,Enable)
											db.oUF.PartyPet.Texts.PowerPercent.Enable = not db.oUF.PartyPet.Texts.PowerPercent.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1pet.Power.valuePercent:Show()
											else
												oUF_LUI_partyUnitButton1pet.Power.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyPet PowerPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerPercent.Size,
											disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyPet.Texts.PowerPercent.Size end,
											set = function(_, FontSize)
													db.oUF.PartyPet.Texts.PowerPercent.Size = FontSize
													oUF_LUI_partyUnitButton1pet.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.PowerPercent.Font),db.oUF.PartyPet.Texts.PowerPercent.Size,db.oUF.PartyPet.Texts.PowerPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show PartyPet PowerPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.PowerPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.PartyPet.Texts.PowerPercent.ShowAlways = not db.oUF.PartyPet.Texts.PowerPercent.ShowAlways
													oUF_LUI_partyUnitButton1pet.Power.valuePercent.ShowAlways = db.oUF.PartyPet.Texts.PowerPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyPet PowerPercent!\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerPercent.Font,
											disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyPet.Texts.PowerPercent.Font end,
											set = function(self, Font)
													db.oUF.PartyPet.Texts.PowerPercent.Font = Font
													oUF_LUI_partyUnitButton1pet.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.PowerPercent.Font),db.oUF.PartyPet.Texts.PowerPercent.Size,db.oUF.PartyPet.Texts.PowerPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyPet PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerPercent.Outline,
											disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyPet.Texts.PowerPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyPet.Texts.PowerPercent.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1pet.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.PowerPercent.Font),db.oUF.PartyPet.Texts.PowerPercent.Size,db.oUF.PartyPet.Texts.PowerPercent.Outline)
												end,
											order = 4,
										},
										PowerPercentX = {
											name = "X Value",
											desc = "X Value for your PartyPet PowerPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerPercent.X,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.PartyPet.Texts.PowerPercent.X end,
											set = function(self,PowerPercentX)
														if PowerPercentX == nil or PowerPercentX == "" then
															PowerPercentX = "0"
														end
														db.oUF.PartyPet.Texts.PowerPercent.X = PowerPercentX
														oUF_LUI_partyUnitButton1pet.Power.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Power.valuePercent:SetPoint(db.oUF.PartyPet.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.PartyPet.Texts.PowerPercent.X), tonumber(db.oUF.PartyPet.Texts.PowerPercent.Y))
													end,
											order = 5,

										},
										PowerPercentY = {
											name = "Y Value",
											desc = "Y Value for your PartyPet PowerPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.PartyPet.Texts.PowerPercent.Y end,
											set = function(self,PowerPercentY)
														if PowerPercentY == nil or PowerPercentY == "" then
															PowerPercentY = "0"
														end
														db.oUF.PartyPet.Texts.PowerPercent.Y = PowerPercentY
														oUF_LUI_partyUnitButton1pet.Power.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Power.valuePercent:SetPoint(db.oUF.PartyPet.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.PartyPet.Texts.PowerPercent.X), tonumber(db.oUF.PartyPet.Texts.PowerPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyPet PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.PowerPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyPet.Texts.PowerPercent.Point = positions[Point]
													oUF_LUI_partyUnitButton1pet.Power.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Power.valuePercent:SetPoint(db.oUF.PartyPet.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.PartyPet.Texts.PowerPercent.X), tonumber(db.oUF.PartyPet.Texts.PowerPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyPet PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.PowerPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyPet.Texts.PowerPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1pet.Power.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Power.valuePercent:SetPoint(db.oUF.PartyPet.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.PartyPet.Texts.PowerPercent.X), tonumber(db.oUF.PartyPet.Texts.PowerPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.PowerPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyPet.Texts.PowerPercent.ColorClass = true
														db.oUF.PartyPet.Texts.PowerPercent.ColorType = false
														db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Power.valuePercent.colorClass = true
														oUF_LUI_partyUnitButton1pet.Power.valuePercent.colorType = false
														oUF_LUI_partyUnitButton1pet.Power.valuePercent.individualColor.Enable = false

														print("PartyPet PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.PowerPercent.ColorType end,
											set = function(self,ColorType)
														db.oUF.PartyPet.Texts.PowerPercent.ColorType = true
														db.oUF.PartyPet.Texts.PowerPercent.ColorClass = false
														db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Power.valuePercent.colorType = true
														oUF_LUI_partyUnitButton1pet.Power.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1pet.Power.valuePercent.individualColor.Enable = false
		
														print("PartyPet PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyPet PowerPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.Enable = true
														db.oUF.PartyPet.Texts.PowerPercent.ColorClass = false
														db.oUF.PartyPet.Texts.PowerPercent.ColorType = false
															
														oUF_LUI_partyUnitButton1pet.Power.valuePercent.individualColor.Enable = true
														oUF_LUI_partyUnitButton1pet.Power.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1pet.Power.valuePercent.colorType = false

														oUF_LUI_partyUnitButton1pet.Power.valuePercent:SetTextColor(tonumber(db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.r),tonumber(db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.g),tonumber(db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyPet PowerPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.Enable or not db.oUF.PartyPet.Texts.PowerPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.r, db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.g, db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.r = r
													db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.g = g
													db.oUF.PartyPet.Texts.PowerPercent.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1pet.Power.valuePercent.individualColor.r = r
													oUF_LUI_partyUnitButton1pet.Power.valuePercent.individualColor.g = g
													oUF_LUI_partyUnitButton1pet.Power.valuePercent.individualColor.b = b

													oUF_LUI_partyUnitButton1pet.Power.valuePercent:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the PartyPet HealthMissing or not.",
									type = "toggle",

									width = "full",
									get = function() return db.oUF.PartyPet.Texts.HealthMissing.Enable end,
									set = function(self,Enable)
											db.oUF.PartyPet.Texts.HealthMissing.Enable = not db.oUF.PartyPet.Texts.HealthMissing.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1pet.Health.valueMissing:Show()
											else
												oUF_LUI_partyUnitButton1pet.Health.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyPet HealthMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthMissing.Size,
											disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyPet.Texts.HealthMissing.Size end,
											set = function(_, FontSize)
													db.oUF.PartyPet.Texts.HealthMissing.Size = FontSize
													oUF_LUI_partyUnitButton1pet.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.HealthMissing.Font),db.oUF.PartyPet.Texts.HealthMissing.Size,db.oUF.PartyPet.Texts.HealthMissing.Outline)
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
											desc = "Always show PartyPet HealthMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.HealthMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.PartyPet.Texts.HealthMissing.ShowAlways = not db.oUF.PartyPet.Texts.HealthMissing.ShowAlways
													oUF_LUI_partyUnitButton1pet.Health.valueMissing.ShowAlways = db.oUF.PartyPet.Texts.HealthMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.HealthMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.PartyPet.Texts.HealthMissing.ShortValue = not db.oUF.PartyPet.Texts.HealthMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyPet HealthMissing!\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthMissing.Font,
											disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyPet.Texts.HealthMissing.Font end,
											set = function(self, Font)
													db.oUF.PartyPet.Texts.HealthMissing.Font = Font
													oUF_LUI_partyUnitButton1pet.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.HealthMissing.Font),db.oUF.PartyPet.Texts.HealthMissing.Size,db.oUF.PartyPet.Texts.HealthMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyPet HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthMissing.Outline,
											disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyPet.Texts.HealthMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyPet.Texts.HealthMissing.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1pet.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.HealthMissing.Font),db.oUF.PartyPet.Texts.HealthMissing.Size,db.oUF.PartyPet.Texts.HealthMissing.Outline)
												end,
											order = 6,
										},
										HealthMissingX = {
											name = "X Value",
											desc = "X Value for your PartyPet HealthMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthMissing.X,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.PartyPet.Texts.HealthMissing.X end,
											set = function(self,HealthMissingX)
														if HealthMissingX == nil or HealthMissingX == "" then
															HealthMissingX = "0"
														end
														db.oUF.PartyPet.Texts.HealthMissing.X = HealthMissingX
														oUF_LUI_partyUnitButton1pet.Health.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Health.valueMissing:SetPoint(db.oUF.PartyPet.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.PartyPet.Texts.HealthMissing.X), tonumber(db.oUF.PartyPet.Texts.HealthMissing.Y))
													end,
											order = 7,
										},
										HealthMissingY = {
											name = "Y Value",
											desc = "Y Value for your PartyPet HealthMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.PartyPet.Texts.HealthMissing.Y end,
											set = function(self,HealthMissingY)
														if HealthMissingY == nil or HealthMissingY == "" then
															HealthMissingY = "0"
														end
														db.oUF.PartyPet.Texts.HealthMissing.Y = HealthMissingY
														oUF_LUI_partyUnitButton1pet.Health.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Health.valueMissing:SetPoint(db.oUF.PartyPet.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.PartyPet.Texts.HealthMissing.X), tonumber(db.oUF.PartyPet.Texts.HealthMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyPet HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.HealthMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyPet.Texts.HealthMissing.Point = positions[Point]
													oUF_LUI_partyUnitButton1pet.Health.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Health.valueMissing:SetPoint(db.oUF.PartyPet.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.PartyPet.Texts.HealthMissing.X), tonumber(db.oUF.PartyPet.Texts.HealthMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyPet HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.HealthMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.HealthMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyPet.Texts.HealthMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1pet.Health.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Health.valueMissing:SetPoint(db.oUF.PartyPet.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.PartyPet.Texts.HealthMissing.X), tonumber(db.oUF.PartyPet.Texts.HealthMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.HealthMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyPet.Texts.HealthMissing.ColorClass = true
														db.oUF.PartyPet.Texts.HealthMissing.ColorGradient = false
														db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorClass = true
														oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorGradient = false
														oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorIndividual.Enable = false

														print("PartyPet HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.HealthMissing.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.PartyPet.Texts.HealthMissing.ColorGradient = true
														db.oUF.PartyPet.Texts.HealthMissing.ColorClass = false
														db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorGradient = true
														oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorIndividual.Enable = false

														print("PartyPet HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyPet HealthMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.Enable = true
														db.oUF.PartyPet.Texts.HealthMissing.ColorClass = false
														db.oUF.PartyPet.Texts.HealthMissing.ColorGradient = false
															
														oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorGradient = false

														oUF_LUI_partyUnitButton1pet.Health.valueMissing:SetTextColor(tonumber(db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.r),tonumber(db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.g),tonumber(db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyPet HealthMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.Enable or not db.oUF.PartyPet.Texts.HealthMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.r, db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.g, db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.r = r
													db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.g = g
													db.oUF.PartyPet.Texts.HealthMissing.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorIndividual.r = r
													oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorIndividual.g = g
													oUF_LUI_partyUnitButton1pet.Health.valueMissing.colorIndividual.b = b
													
													oUF_LUI_partyUnitButton1pet.Health.valueMissing:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the PartyPet PowerMissing or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyPet.Texts.PowerMissing.Enable end,
									set = function(self,Enable)
											db.oUF.PartyPet.Texts.PowerMissing.Enable = not db.oUF.PartyPet.Texts.PowerMissing.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1pet.Power.valueMissing:Show()
											else
												oUF_LUI_partyUnitButton1pet.Power.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyPet PowerMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerMissing.Size,
											disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyPet.Texts.PowerMissing.Size end,
											set = function(_, FontSize)
													db.oUF.PartyPet.Texts.PowerMissing.Size = FontSize
													oUF_LUI_partyUnitButton1pet.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.PowerMissing.Font),db.oUF.PartyPet.Texts.PowerMissing.Size,db.oUF.PartyPet.Texts.PowerMissing.Outline)
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
											desc = "Always show PartyPet PowerMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.PowerMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.PartyPet.Texts.PowerMissing.ShowAlways = not db.oUF.PartyPet.Texts.PowerMissing.ShowAlways
													oUF_LUI_partyUnitButton1pet.Health.valueMissing.ShowAlways = db.oUF.PartyPet.Texts.PowerMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.PowerMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.PartyPet.Texts.PowerMissing.ShortValue = not db.oUF.PartyPet.Texts.PowerMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyPet PowerMissing!\n\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerMissing.Font,
											disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyPet.Texts.PowerMissing.Font end,
											set = function(self, Font)
													db.oUF.PartyPet.Texts.PowerMissing.Font = Font
													oUF_LUI_partyUnitButton1pet.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.PowerMissing.Font),db.oUF.PartyPet.Texts.PowerMissing.Size,db.oUF.PartyPet.Texts.PowerMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyPet PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerMissing.Outline,
											disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyPet.Texts.PowerMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyPet.Texts.PowerMissing.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1pet.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyPet.Texts.PowerMissing.Font),db.oUF.PartyPet.Texts.PowerMissing.Size,db.oUF.PartyPet.Texts.PowerMissing.Outline)
												end,
											order = 6,
										},
										PowerMissingX = {
											name = "X Value",
											desc = "X Value for your PartyPet PowerMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerMissing.X,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.PartyPet.Texts.PowerMissing.X end,
											set = function(self,PowerMissingX)
														if PowerMissingX == nil or PowerMissingX == "" then
															PowerMissingX = "0"
														end
														db.oUF.PartyPet.Texts.PowerMissing.X = PowerMissingX
														oUF_LUI_partyUnitButton1pet.Power.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Power.valueMissing:SetPoint(db.oUF.PartyPet.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.PartyPet.Texts.PowerMissing.X), tonumber(db.oUF.PartyPet.Texts.PowerMissing.Y))
													end,
											order = 7,
										},
										PowerMissingY = {
											name = "Y Value",
											desc = "Y Value for your PartyPet PowerMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.PartyPet.Texts.PowerMissing.Y end,
											set = function(self,PowerMissingY)
														if PowerMissingY == nil or PowerMissingY == "" then
															PowerMissingY = "0"
														end
														db.oUF.PartyPet.Texts.PowerMissing.Y = PowerMissingY
														oUF_LUI_partyUnitButton1pet.Power.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1pet.Power.valueMissing:SetPoint(db.oUF.PartyPet.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.PartyPet.Texts.PowerMissing.X), tonumber(db.oUF.PartyPet.Texts.PowerMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyPet PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.PowerMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyPet.Texts.PowerMissing.Point = positions[Point]
													oUF_LUI_partyUnitButton1pet.Power.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Power.valueMissing:SetPoint(db.oUF.PartyPet.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.PartyPet.Texts.PowerMissing.X), tonumber(db.oUF.PartyPet.Texts.PowerMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyPet PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Texts.PowerMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyPet.Texts.PowerMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyPet.Texts.PowerMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1pet.Power.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1pet.Power.valueMissing:SetPoint(db.oUF.PartyPet.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.PartyPet.Texts.PowerMissing.X), tonumber(db.oUF.PartyPet.Texts.PowerMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.PowerMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyPet.Texts.PowerMissing.ColorClass = true
														db.oUF.PartyPet.Texts.PowerMissing.ColorType = false
														db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorClass = true
														oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorType = false
														oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorIndividual.Enable = false

														print("PartyPet PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.PowerMissing.ColorType end,
											set = function(self,ColorType)
														db.oUF.PartyPet.Texts.PowerMissing.ColorType = true
														db.oUF.PartyPet.Texts.PowerMissing.ColorClass = false
														db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorType = true
														oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorIndividual.Enable = false
		
														print("PartyPet PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyPet PowerMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.Enable = true
														db.oUF.PartyPet.Texts.PowerMissing.ColorClass = false
														db.oUF.PartyPet.Texts.PowerMissing.ColorType = false
															
														oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorType = false
		
														oUF_LUI_partyUnitButton1pet.Power.valueMissing:SetTextColor(tonumber(db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.r),tonumber(db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.g),tonumber(db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyPet PowerMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.Enable or not db.oUF.PartyPet.Texts.PowerMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.r, db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.g, db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.r = r
													db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.g = g
													db.oUF.PartyPet.Texts.PowerMissing.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorIndividual.r = r
													oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorIndividual.g = g
													oUF_LUI_partyUnitButton1pet.Power.valueMissing.colorIndividual.b = b
													
													oUF_LUI_partyUnitButton1pet.Power.valueMissing:SetTextColor(r,g,b)
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
					disabled = function() return not db.oUF.PartyPet.Enable end,
					args = {
						header1 = {
							name = "PartyPet Auras",
							type = "header",
							order = 1,
						},
						PartyPetBuffs = {
							name = "Buffs",
							type = "group",
							order = 2,
							args = {
								PartyPetBuffsEnable = {
									name = "Enable PartyPet Buffs",
									desc = "Wether you want to show PartyPet Buffs or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyPet.Aura.buffs_enable end,
									set = function(self,PartyPetBuffsEnable)
												db.oUF.PartyPet.Aura.buffs_enable = not db.oUF.PartyPet.Aura.buffs_enable 
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 0,
								},
								PartyPetBuffsAuratimer = {
									name = "Enable Auratimer",
									desc = "Wether you want to show Auratimers or not.",
									type = "toggle",
									disabled = function() return not db.oUF.PartyPet.Aura.buffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.buffs_auratimer end,
									set = function(self,PartyPetBuffsAuratimer)
												db.oUF.PartyPet.Aura.buffs_auratimer = not db.oUF.PartyPet.Aura.buffs_auratimer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								PartyPetBuffsPlayerBuffsOnly = {
									name = "Player Buffs Only",
									desc = "Wether you want to show only your Buffs on PartyPetmembers or not.",
									type = "toggle",
									disabled = function() return not db.oUF.PartyPet.Aura.buffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.buffs_playeronly end,
									set = function(self,PartyPetBuffsPlayerBuffsOnly)
												db.oUF.PartyPet.Aura.buffs_playeronly = not db.oUF.PartyPet.Aura.buffs_playeronly
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 2,
								},
								PartyPetBuffsNum = {
									name = "Amount",
									desc = "Amount of your PartyPet Buffs.\nDefault: 8",
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Aura.buffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.buffs_num end,
									set = function(self,PartyPetBuffsNum)
												if PartyPetBuffsNum == nil or PartyPetBuffsNum == "" then
													PartyPetBuffsNum = "0"
												end
												db.oUF.PartyPet.Aura.buffs_num = PartyPetBuffsNum
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								PartyPetBuffsSize = {
									name = "Size",
									desc = "Size for your PartyPet Buffs.\nDefault: 18",
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Aura.buffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.buffs_size end,
									set = function(self,PartyPetBuffsSize)
												if PartyPetBuffsSize == nil or PartyPetBuffsSize == "" then
													PartyPetBuffsSize = "0"
												end
												db.oUF.PartyPet.Aura.buffs_size = PartyPetBuffsSize
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
								PartyPetBuffsSpacing = {
									name = "Spacing",
									desc = "Spacing between your PartyPet Buffs.\nDefault: 2",
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Aura.buffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.buffs_spacing end,
									set = function(self,PartyPetBuffsSpacing)
												if PartyPetBuffsSpacing == nil or PartyPetBuffsSpacing == "" then
													PartyPetBuffsSpacing = "0"
												end
												db.oUF.PartyPet.Aura.buffs_spacing = PartyPetBuffsSpacing
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 5,
								},
								PartyPetBuffsX = {
									name = "X Value",
									desc = "X Value for your PartyPet Buffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: -0.5",
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Aura.buffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.buffsX end,
									set = function(self,PartyPetBuffsX)
												if PartyPetBuffsX == nil or PartyPetBuffsX == "" then
													PartyPetBuffsX = "0"
												end
												db.oUF.PartyPet.Aura.buffsX = PartyPetBuffsX
												oUF_LUI_partyUnitButton1pet_buffs:SetPoint(db.oUF.PartyPet.Aura.buffs_initialAnchor, oUF_LUI_partyUnitButton1pet.Health, db.oUF.PartyPet.Aura.buffs_initialAnchor, PartyPetBuffsX, db.oUF.PartyPet.Aura.buffsY)
											end,
									order = 6,
								},
								PartyPetBuffsY = {
									name = "Y Value",
									desc = "Y Value for your PartyPet Buffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Aura.buffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.buffsY end,
									set = function(self,PartyPetBuffsY)
												if PartyPetBuffsY == nil or PartyPetBuffsY == "" then
													PartyPetBuffsY = "0"
												end
												db.oUF.PartyPet.Aura.buffsY = PartyPetBuffsY
												oUF_LUI_partyUnitButton1pet_buffs:SetPoint(db.oUF.PartyPet.Aura.buffs_initialAnchor, oUF_LUI_partyUnitButton1pet.Health, db.oUF.PartyPet.Aura.buffs_initialAnchor, db.oUF.PartyPet.Aura.buffsX, PartyPetBuffsY)
											end,
									order = 7,
								},
								PartyPetBuffsGrowthY = {
									name = "Growth Y",
									desc = "Choose the growth Y direction for your PartyPet Buffs.\nDefault: UP",
									type = "select",
									disabled = function() return not db.oUF.PartyPet.Aura.buffs_enable end,
									values = growthY,
									get = function()
											for k, v in pairs(growthY) do
												if db.oUF.PartyPet.Aura.buffs_growthY == v then
													return k
												end
											end
										end,
									set = function(self, PartyPetBuffsGrowthY)
											db.oUF.PartyPet.Aura.buffs_growthY = growthY[PartyPetBuffsGrowthY]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 8,
								},
								PartyPetBuffsGrowthX = {
									name = "Growth X",
									desc = "Choose the growth X direction for your PartyPet Buffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.PartyPet.Aura.buffs_enable end,
									values = growthX,
									get = function()
											for k, v in pairs(growthX) do
												if db.oUF.PartyPet.Aura.buffs_growthX == v then
													return k
												end
											end
										end,
									set = function(self, PartyPetBuffsGrowthX)
											db.oUF.PartyPet.Aura.buffs_growthX = growthX[PartyPetBuffsGrowthX]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 9,
								},
								PartyPetBuffsAnchor = {
									name = "Initial Anchor",
									desc = "Choose the initinal Anchor for your PartyPet Buffs.\nDefault: TOPLEFT",
									type = "select",
									disabled = function() return not db.oUF.PartyPet.Aura.buffs_enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyPet.Aura.buffs_initialAnchor == v then
													return k
												end
											end
										end,
									set = function(self, PartyPetBuffsAnchor)
											db.oUF.PartyPet.Aura.buffs_initialAnchor = positions[PartyPetBuffsAnchor]
											oUF_LUI_partyUnitButton1pet_buffs:SetPoint(positions[PartyPetBuffsAnchor], oUF_LUI_partyUnitButton1pet.Health, positions[PartyPetBuffsAnchor], db.oUF.PartyPet.Aura.buffsX, db.oUF.PartyPet.Aura.buffsY)
										end,
									order = 10,
								},
							},
						},
						PartyPetDebuffs = {
							name = "Debuffs",
							type = "group",
							order = 3,
							args = {
								PartyPetDebuffsEnable = {
									name = "Enable PartyPet Debuffs",
									desc = "Wether you want to show PartyPet Debuffs or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyPet.Aura.debuffs_enable end,
									set = function(self,PartyPetDebuffsEnable)
												db.oUF.PartyPet.Aura.debuffs_enable = not db.oUF.PartyPet.Aura.debuffs_enable 
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 0,
								},
								PartyPetDebuffsAuratimer = {
									name = "Enable Auratimer",
									desc = "Wether you want to show Auratimers or not.\nDefault: Off",
									type = "toggle",
									disabled = function() return not db.oUF.PartyPet.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.debuffs_auratimer end,
									set = function(self,PartyPetDebuffsAuratimer)
												db.oUF.PartyPet.Aura.debuffs_auratimer = not db.oUF.PartyPet.Aura.debuffs_auratimer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								PartyPetDebuffsColorByType = {
									name = "Color by Type",
									desc = "Wether you want to color PartyPet Debuffs by Type or not.",
									type = "toggle",
									disabled = function() return not db.oUF.PartyPet.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.debuffs_colorbytype end,
									set = function(self,PartyPetDebuffsColorByType)
												db.oUF.PartyPet.Aura.debuffs_colorbytype = not db.oUF.PartyPet.Aura.debuffs_colorbytype
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 2,
								},
								PartyPetDebuffsNum = {
									name = "Amount",
									desc = "Amount of your PartyPet Debuffs.\nDefault: 8",
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.debuffs_num end,
									set = function(self,PartyPetDebuffsNum)
												if PartyPetDebuffsNum == nil or PartyPetDebuffsNum == "" then
													PartyPetDebuffsNum = "0"
												end
												db.oUF.PartyPet.Aura.debuffs_num = PartyPetDebuffsNum
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								PartyPetDebuffsSize = {
									name = "Size",
									desc = "Size for your PartyPet Debuffs.\nDefault: 18",
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.debuffs_size end,
									set = function(self,PartyPetDebuffsSize)
												if PartyPetDebuffsSize == nil or PartyPetDebuffsSize == "" then
													PartyPetDebuffsSize = "0"
												end
												db.oUF.PartyPet.Aura.debuffs_size = PartyPetDebuffsSize
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
								PartyPetDebuffsSpacing = {
									name = "Spacing",
									desc = "Spacing between your PartyPet Debuffs.\nDefault: 2",
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.debuffs_spacing end,
									set = function(self,PartyPetDebuffsSpacing)
												if PartyPetDebuffsSpacing == nil or PartyPetDebuffsSpacing == "" then
													PartyPetDebuffsSpacing = "0"
												end
												db.oUF.PartyPet.Aura.debuffs_spacing = PartyPetDebuffsSpacing
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 5,
								},
								PartyPetDebuffsX = {
									name = "X Value",
									desc = "X Value for your PartyPet Debuffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: -0.5",
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.debuffsX end,
									set = function(self,PartyPetDebuffsX)
												if PartyPetDebuffsX == nil or PartyPetDebuffsX == "" then
													PartyPetDebuffsX = "0"
												end
												db.oUF.PartyPet.Aura.debuffsX = PartyPetDebuffsX
												oUF_LUI_partyUnitButton1pet_debuffs:SetPoint(db.oUF.PartyPet.Aura.debuffs_initialAnchor, oUF_LUI_partyUnitButton1pet.Health, db.oUF.PartyPet.Aura.debuffs_initialAnchor, PartyPetDebuffsX, db.oUF.PartyPet.Aura.debuffsY)
											end,
									order = 6,
								},
								PartyPetDebuffsY = {
									name = "Y Value",
									desc = "Y Value for your PartyPet Debuffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: -30",
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyPet.Aura.debuffsY end,
									set = function(self,PartyPetDebuffsY)
												if PartyPetDebuffsY == nil or PartyPetDebuffsY == "" then
													PartyPetDebuffsY = "0"
												end
												db.oUF.PartyPet.Aura.debuffsY = PartyPetDebuffsY
												oUF_LUI_partyUnitButton1pet_debuffs:SetPoint(db.oUF.PartyPet.Aura.debuffs_initialAnchor, oUF_LUI_partyUnitButton1pet.Health, db.oUF.PartyPet.Aura.debuffs_initialAnchor, db.oUF.PartyPet.Aura.debuffsX, PartyPetDebuffsY)
											end,
									order = 7,
								},
								PartyPetDebuffsGrowthY = {
									name = "Growth Y",
									desc = "Choose the growth Y direction for your PartyPet Debuffs.\nDefault: UP",
									type = "select",
									disabled = function() return not db.oUF.PartyPet.Aura.debuffs_enable end,
									values = growthY,
									get = function()
											for k, v in pairs(growthY) do
												if db.oUF.PartyPet.Aura.debuffs_growthY == v then
													return k
												end
											end
										end,
									set = function(self, PartyPetDebuffsGrowthY)
											db.oUF.PartyPet.Aura.debuffs_growthY = growthY[PartyPetDebuffsGrowthY]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 8,
								},
								PartyPetDebuffsGrowthX = {
									name = "Growth X",
									desc = "Choose the growth X direction for your PartyPet Debuffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.PartyPet.Aura.debuffs_enable end,
									values = growthX,
									get = function()
											for k, v in pairs(growthX) do
												if db.oUF.PartyPet.Aura.debuffs_growthX == v then
													return k
												end
											end
										end,
									set = function(self, PartyPetDebuffsGrowthX)
											db.oUF.PartyPet.Aura.debuffs_growthX = growthX[PartyPetDebuffsGrowthX]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 9,
								},
								PartyPetDebuffsAnchor = {
									name = "Initial Anchor",
									desc = "Choose the initinal Anchor for your PartyPet Debuffs.\nDefault: LEFT",
									type = "select",
									disabled = function() return not db.oUF.PartyPet.Aura.debuffs_enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyPet.Aura.debuffs_initialAnchor == v then
													return k
												end
											end
										end,
									set = function(self, PartyPetDebuffsAnchor)
											db.oUF.PartyPet.Aura.debuffs_initialAnchor = positions[PartyPetDebuffsAnchor]
											oUF_LUI_partyUnitButton1pet_debuffs:SetPoint(positions[PartyPetDebuffsAnchor], oUF_LUI_partyUnitButton1pet.Health, positions[PartyPetDebuffsAnchor], db.oUF.PartyPet.Aura.debuffsX, db.oUF.PartyPet.Aura.debuffsY)
										end,
									order = 10,
								},
							},
						},
					},
				},
				Portrait = {
					name = "Portrait",
					disabled = function() return not db.oUF.PartyPet.Enable end,
					type = "group",
					order = 8,
					args = {
						EnablePortrait = {
							name = "Enable",
							desc = "Wether you want to show the Portrait or not.",
							type = "toggle",
							width = "full",
							get = function() return db.oUF.PartyPet.Portrait.Enable end,
							set = function(self,EnablePortrait)
										db.oUF.PartyPet.Portrait.Enable = not db.oUF.PartyPet.Portrait.Enable
										StaticPopup_Show("RELOAD_UI")
									end,
							order = 1,
						},
						PortraitWidth = {
							name = "Width",
							desc = "Choose the Width for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.PartyPet.Portrait.Enable end,
							get = function() return db.oUF.PartyPet.Portrait.Width end,
							set = function(self,PortraitWidth)
										if PortraitWidth == nil or PortraitWidth == "" then
											PortraitWidth = "0"
										end
										db.oUF.PartyPet.Portrait.Width = PortraitWidth
										oUF_LUI_partyUnitButton1pet.Portrait:SetWidth(tonumber(PortraitWidth))
									end,
							order = 2,
						},
						PortraitHeight = {
							name = "Height",
							desc = "Choose the Height for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.PartyPet.Portrait.Enable end,
							get = function() return db.oUF.PartyPet.Portrait.Height end,
							set = function(self,PortraitHeight)
										if PortraitHeight == nil or PortraitHeight == "" then
											PortraitHeight = "0"
										end
										db.oUF.PartyPet.Portrait.Height = PortraitHeight
										oUF_LUI_partyUnitButton1pet.Portrait:SetHeight(tonumber(PortraitHeight))
									end,
							order = 3,
						},
						PortraitX = {
							name = "X Value",
							desc = "X Value for your Portrait.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Portrait.X,
							type = "input",
							disabled = function() return not db.oUF.PartyPet.Portrait.Enable end,
							get = function() return db.oUF.PartyPet.Portrait.X end,
							set = function(self,PortraitX)
										if PortraitX == nil or PortraitX == "" then
											PortraitX = "0"
										end
										db.oUF.PartyPet.Portrait.X = PortraitX
										oUF_LUI_partyUnitButton1pet.Portrait:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1pet.Health, "TOPLEFT", PortraitX, db.oUF.PartyPet.Portrait.Y)
									end,
							order = 4,
						},
						PortraitY = {
							name = "Y Value",
							desc = "Y Value for your Portrait.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Portrait.Y,
							type = "input",
							disabled = function() return not db.oUF.PartyPet.Portrait.Enable end,
							get = function() return db.oUF.PartyPet.Portrait.Y end,
							set = function(self,PortraitY)
										if PortraitY == nil or PortraitY == "" then
											PortraitY = "0"
										end
										db.oUF.PartyPet.Portrait.Y = PortraitY
										oUF_LUI_partyUnitButton1pet.Portrait:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1pet.Health, "TOPLEFT", db.oUF.PartyPet.Portrait.X, PortraitY)
									end,
							order = 5,
						},
					},
				},
				Icons = {
					name = "Icons",
					type = "group",
					disabled = function() return not db.oUF.PartyPet.Enable end,
					order = 9,
					childGroups = "tab",
					args = {
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
									get = function() return db.oUF.PartyPet.Icons.Raid.Enable end,
									set = function(self,RaidEnable)
												db.oUF.PartyPet.Icons.Raid.Enable = not db.oUF.PartyPet.Icons.Raid.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								RaidX = {
									name = "X Value",
									desc = "X Value for your Raid Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Icons.Raid.X,
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Icons.Raid.Enable end,
									get = function() return db.oUF.PartyPet.Icons.Raid.X end,
									set = function(self,RaidX)
												if RaidX == nil or RaidX == "" then
													RaidX = "0"
												end

												db.oUF.PartyPet.Icons.Raid.X = RaidX
												oUF_LUI_partyUnitButton1pet.RaidIcon:ClearAllPoints()
												oUF_LUI_partyUnitButton1pet.RaidIcon:SetPoint(db.oUF.PartyPet.Icons.Raid.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Icons.Raid.Point, tonumber(RaidX), tonumber(db.oUF.PartyPet.Icons.Raid.Y))
											end,
									order = 2,
								},
								RaidY = {
									name = "Y Value",
									desc = "Y Value for your Raid Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Icons.Raid.Y,
									type = "input",
									disabled = function() return not db.oUF.PartyPet.Icons.Raid.Enable end,
									get = function() return db.oUF.PartyPet.Icons.Raid.Y end,
									set = function(self,RaidY)
												if RaidY == nil or RaidY == "" then
													RaidY = "0"
												end
												db.oUF.PartyPet.Icons.Raid.Y = RaidY
												oUF_LUI_partyUnitButton1pet.RaidIcon:ClearAllPoints()
												oUF_LUI_partyUnitButton1pet.RaidIcon:SetPoint(db.oUF.PartyPet.Icons.Raid.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Icons.Raid.Point, tonumber(db.oUF.PartyPet.Icons.Raid.X), tonumber(RaidY))
											end,
									order = 3,
								},
								RaidPoint = {
									name = "Position",
									desc = "Choose the Position for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Icons.Raid.Point,
									type = "select",
									disabled = function() return not db.oUF.PartyPet.Icons.Raid.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyPet.Icons.Raid.Point == v then
													return k
												end
											end
										end,
									set = function(self, RaidPoint)
											db.oUF.PartyPet.Icons.Raid.Point = positions[RaidPoint]
											oUF_LUI_partyUnitButton1pet.RaidIcon:ClearAllPoints()
											oUF_LUI_partyUnitButton1pet.RaidIcon:SetPoint(db.oUF.PartyPet.Icons.Raid.Point, oUF_LUI_partyUnitButton1pet, db.oUF.PartyPet.Icons.Raid.Point, tonumber(db.oUF.PartyPet.Icons.Raid.X), tonumber(db.oUF.PartyPet.Icons.Raid.Y))
										end,
									order = 4,
								},
								RaidSize = {
									name = "Size",
									desc = "Choose a Size for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyPet.Icons.Raid.Size,
									type = "range",
									min = 5,
									max = 200,
									step = 5,
									disabled = function() return not db.oUF.PartyPet.Icons.Raid.Enable end,
									get = function() return db.oUF.PartyPet.Icons.Raid.Size end,
									set = function(_, RaidSize) 
											db.oUF.PartyPet.Icons.Raid.Size = RaidSize
											oUF_LUI_partyUnitButton1pet.RaidIcon:SetHeight(RaidSize)
											oUF_LUI_partyUnitButton1pet.RaidIcon:SetWidth(RaidSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.PartyPet.Icons.Raid.Enable end,
									desc = "Toggles the RaidIcon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1pet.RaidIcon:IsShown() then oUF_LUI_partyUnitButton1pet.RaidIcon:Hide() else oUF_LUI_partyUnitButton1pet.RaidIcon:Show() end end
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