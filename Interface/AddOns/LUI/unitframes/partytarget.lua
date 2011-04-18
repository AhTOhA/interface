--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: partytarget.lua
	Description: oUF Party Target Module
	Version....: 1.0
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local module = LUI:NewModule("oUF_PartyTarget")
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
	PartyTarget = {
		Enable = true,
		Height = "24",
		Width = "130",
		X = "8",
		Y = "-8",
		Point = "TOPLEFT",
		RelativePoint = "BOTTOMRIGHT",
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
			buffs_auratimer = false,
			buffs_enable = false,
			buffsX = "0",
			buffsY = "-25",
			buffs_initialAnchor = "BOTTOMLEFT",
			buffs_growthY = "DOWN",
			buffs_growthX = "RIGHT",
			buffs_size = "18",
			buffs_spacing = "2",
			buffs_num = "8",
			debuffs_colorbytype = false,
			debuffs_auratimer = false,
			debuffs_enable = false,
			debuffs_playeronly = false,
			debuffsX = "5",
			debuffsY = "-5",
			debuffs_initialAnchor = "RIGHT",
			debuffs_growthY = "DOWN",
			debuffs_growthX = "RIGHT",
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
			Lootmaster = {
				Enable = false,
				Size = 15,
				X = "16",
				Y = "10",
				Point = "TOPLEFT",
			},
			Leader = {
				Enable = false,
				Size = 17,
				X = "0",
				Y = "10",
				Point = "TOPLEFT",
			},
			Role = {
				Enable = false,
				Size = 22,
				X = "15",
				Y = "10",
				Point = "TOPRIGHT",
			},
			Raid = {
				Enable = true,
				Size = 55,
				X = "0",
				Y = "0",
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
		PartyTarget = {
			name = "Party Target",
			type = "group",
			disabled = function() return not db.oUF.Settings.Enable end,
			order = 30,
			childGroups = "tab",
			args = {
				header1 = {
					name = "Party Target",
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
									desc = "Wether you want to use a Party Target Frame or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyTarget.Enable end,
									set = function(self,Enable)
												db.oUF.PartyTarget.Enable = not db.oUF.PartyTarget.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
							},
						},
						Positioning = {
							name = "Positioning",
							type = "group",
							disabled = function() return not db.oUF.PartyTarget.Enable end,
							order = 1,
							args = {
								header1 = {
									name = "Frame Position",
									type = "header",
									order = 1,
								},
								PartyTargetX = {
									name = "X Value",
									desc = "X Value for your Party Target Frame.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.X,
									type = "input",
									get = function() return db.oUF.PartyTarget.X end,
									set = function(self,PartyTargetX)
												if PartyTargetX == nil or PartyTargetX == "" then
													PartyTargetX = "0"
												end
												db.oUF.PartyTarget.X = PartyTargetX
												oUF_LUI_partyUnitButton1target:ClearAllPoints()
												oUF_LUI_partyUnitButton1target:SetPoint(db.oUF.PartyTarget.Point, oUF_LUI_partyUnitButton1, db.oUF.PartyTarget.RelativePoint, tonumber(PartyTargetX), tonumber(db.oUF.PartyTarget.Y))
											end,
									order = 2,
								},
								PartyTargetY = {
									name = "Y Value",
									desc = "Y Value for your Party Target Frame.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Y,
									type = "input",
									get = function() return db.oUF.PartyTarget.Y end,
									set = function(self,PartyTargetY)
												if PartyTargetY == nil or PartyTargetY == "" then
													PartyTargetY = "0"
												end
												db.oUF.PartyTarget.Y = PartyTargetY
												oUF_LUI_partyUnitButton1target:ClearAllPoints()
												oUF_LUI_partyUnitButton1target:SetPoint(db.oUF.PartyTarget.Point, oUF_LUI_partyUnitButton1, db.oUF.PartyTarget.RelativePoint, tonumber(db.oUF.PartyTarget.X), tonumber(PartyTargetY))
											end,
									order = 3,
								},
								PartyTargetPoint = {
									name = "Point",
									desc = "Choose the Point for your Party Target Frame.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Point,
									type = "select",
											values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.Point == v then
													return k
												end
											end
										end,
									set = function(self, PartyTargetPoint)
											db.oUF.PartyTarget.Point = positions[PartyTargetPoint]
											oUF_LUI_partyUnitButton1target:ClearAllPoints()
											oUF_LUI_partyUnitButton1target:SetPoint(PartyTargetPoint, oUF_LUI_partyUnitButton1, db.oUF.PartyTarget.RelativePoint, tonumber(db.oUF.PartyTarget.X), tonumber(db.oUF.PartyTarget.Y))
										end,
									order = 4,
								},
								PartyTargetRelativePoint = {
									name = "RelativePoint",
									desc = "Choose the RelativePoint for your Party Target Frame.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.RelativePoint,
									type = "select",
											values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.RelativePoint == v then
													return k
												end
											end
										end,
									set = function(self, PartyTargetRelativePoint)
											db.oUF.PartyTarget.RelativePoint = positions[PartyTargetRelativePoint]
											oUF_LUI_partyUnitButton1target:ClearAllPoints()
											oUF_LUI_partyUnitButton1target:SetPoint(db.oUF.PartyTarget.Point, oUF_LUI_partyUnitButton1, PartyTargetRelativePoint, tonumber(db.oUF.PartyTarget.X), tonumber(db.oUF.PartyTarget.Y))
										end,
									order = 5,
								},
							},
						},
						Size = {
							name = "Size",
							type = "group",
							disabled = function() return not db.oUF.PartyTarget.Enable end,
							order = 2,
							args = {
								header1 = {
									name = "Frame Height/Width",
									type = "header",
									order = 1,
								},
								PartyTargetHeight = {
									name = "Height",
									desc = "Decide the Height of your Party Target Frame.\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Height,
									type = "input",
									get = function() return db.oUF.PartyTarget.Height end,
									set = function(self,PartyTargetHeight)
												if PartyTargetHeight == nil or PartyTargetHeight == "" then
													PartyTargetHeight = "0"
												end
												db.oUF.PartyTarget.Height = PartyTargetHeight
												oUF_LUI_partyUnitButton1target:SetHeight(tonumber(PartyTargetHeight))
											end,
									order = 2,
								},
								PartyTargetWidth = {
									name = "Width",
									desc = "Decide the Width of your Party Target Frame.\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Width,
									type = "input",
									get = function() return db.oUF.PartyTarget.Width end,
									set = function(self,PartyTargetWidth)
												if PartyTargetWidth == nil or PartyTargetWidth == "" then
													PartyTargetWidth = "0"
												end
												db.oUF.PartyTarget.Width = PartyTargetWidth
												oUF_LUI_partyUnitButton1target:SetWidth(tonumber(PartyTargetWidth))
												
												if db.oUF.PartyTarget.Aura.buffs_enable == true then
													oUF_LUI_partyUnitButton1target.Buffs:SetWidth(tonumber(PartyTargetWidth))
												end
												
												if db.oUF.PartyTarget.Aura.debuffs_enable == true then
													oUF_LUI_partyUnitButton1target.Debuffs:SetWidth(tonumber(PartyTargetWidth))
												end
											end,
									order = 3,
								},
							},
						},
						Appearance = {
							name = "Appearance",
							type = "group",
							disabled = function() return not db.oUF.PartyTarget.Enable end,
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
									get = function() return db.oUF.PartyTarget.Backdrop.Color.r, db.oUF.PartyTarget.Backdrop.Color.g, db.oUF.PartyTarget.Backdrop.Color.b, db.oUF.PartyTarget.Backdrop.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.PartyTarget.Backdrop.Color.r = r
											db.oUF.PartyTarget.Backdrop.Color.g = g
											db.oUF.PartyTarget.Backdrop.Color.b = b
											db.oUF.PartyTarget.Backdrop.Color.a = a

											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropColor(r,g,b,a)
										end,
									order = 2,
								},
								BackdropBorderColor = {
									name = "Border Color",
									desc = "Choose a Backdrop Border Color.",
									type = "color",
									width = "full",
									hasAlpha = true,
									get = function() return db.oUF.PartyTarget.Border.Color.r, db.oUF.PartyTarget.Border.Color.g, db.oUF.PartyTarget.Border.Color.b, db.oUF.PartyTarget.Border.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.PartyTarget.Border.Color.r = r
											db.oUF.PartyTarget.Border.Color.g = g
											db.oUF.PartyTarget.Border.Color.b = b
											db.oUF.PartyTarget.Border.Color.a = a
											
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyTarget.Border.Insets.Left), right = tonumber(db.oUF.PartyTarget.Border.Insets.Right), top = tonumber(db.oUF.PartyTarget.Border.Insets.Top), bottom = tonumber(db.oUF.PartyTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyTarget.Backdrop.Color.r), tonumber(db.oUF.PartyTarget.Backdrop.Color.g), tonumber(db.oUF.PartyTarget.Backdrop.Color.b), tonumber(db.oUF.PartyTarget.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyTarget.Border.Color.r), tonumber(db.oUF.PartyTarget.Border.Color.g), tonumber(db.oUF.PartyTarget.Border.Color.b), tonumber(db.oUF.PartyTarget.Border.Color.a))
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
									desc = "Choose your Backdrop Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Backdrop.Texture,
									type = "select",
									dialogControl = "LSM30_Background",
									values = widgetLists.background,
									get = function() return db.oUF.PartyTarget.Backdrop.Texture end,
									set = function(self, BackdropTexture)
											db.oUF.PartyTarget.Backdrop.Texture = BackdropTexture
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyTarget.Border.Insets.Left), right = tonumber(db.oUF.PartyTarget.Border.Insets.Right), top = tonumber(db.oUF.PartyTarget.Border.Insets.Top), bottom = tonumber(db.oUF.PartyTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyTarget.Backdrop.Color.r), tonumber(db.oUF.PartyTarget.Backdrop.Color.g), tonumber(db.oUF.PartyTarget.Backdrop.Color.b), tonumber(db.oUF.PartyTarget.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyTarget.Border.Color.r), tonumber(db.oUF.PartyTarget.Border.Color.g), tonumber(db.oUF.PartyTarget.Border.Color.b), tonumber(db.oUF.PartyTarget.Border.Color.a))
										end,
									order = 5,
								},
								BorderTexture = {
									name = "Border Texture",
									desc = "Choose your Border Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Border.EdgeFile,
									type = "select",
									dialogControl = "LSM30_Border",
									values = widgetLists.border,
									get = function() return db.oUF.PartyTarget.Border.EdgeFile end,
									set = function(self, BorderTexture)
											db.oUF.PartyTarget.Border.EdgeFile = BorderTexture
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyTarget.Border.Insets.Left), right = tonumber(db.oUF.PartyTarget.Border.Insets.Right), top = tonumber(db.oUF.PartyTarget.Border.Insets.Top), bottom = tonumber(db.oUF.PartyTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyTarget.Backdrop.Color.r), tonumber(db.oUF.PartyTarget.Backdrop.Color.g), tonumber(db.oUF.PartyTarget.Backdrop.Color.b), tonumber(db.oUF.PartyTarget.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyTarget.Border.Color.r), tonumber(db.oUF.PartyTarget.Border.Color.g), tonumber(db.oUF.PartyTarget.Border.Color.b), tonumber(db.oUF.PartyTarget.Border.Color.a))
										end,
									order = 6,
								},
								BorderSize = {
									name = "Edge Size",
									desc = "Choose the Edge Size for your Frame Border.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Border.EdgeSize,
									type = "range",
									min = 1,
									max = 50,
									step = 1,
									get = function() return db.oUF.PartyTarget.Border.EdgeSize end,
									set = function(_, BorderSize) 
											db.oUF.PartyTarget.Border.EdgeSize = BorderSize
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyTarget.Border.Insets.Left), right = tonumber(db.oUF.PartyTarget.Border.Insets.Right), top = tonumber(db.oUF.PartyTarget.Border.Insets.Top), bottom = tonumber(db.oUF.PartyTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyTarget.Backdrop.Color.r), tonumber(db.oUF.PartyTarget.Backdrop.Color.g), tonumber(db.oUF.PartyTarget.Backdrop.Color.b), tonumber(db.oUF.PartyTarget.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyTarget.Border.Color.r), tonumber(db.oUF.PartyTarget.Border.Color.g), tonumber(db.oUF.PartyTarget.Border.Color.b), tonumber(db.oUF.PartyTarget.Border.Color.a))
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
									desc = "Value for the Left Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Backdrop.Padding.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyTarget.Backdrop.Padding.Left end,
									set = function(self,PaddingLeft)
										if PaddingLeft == nil or PaddingLeft == "" then
											PaddingLeft = "0"
										end
										db.oUF.PartyTarget.Backdrop.Padding.Left = PaddingLeft
										oUF_LUI_partyUnitButton1target.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1target, "TOPLEFT", tonumber(db.oUF.PartyTarget.Backdrop.Padding.Left), tonumber(db.oUF.PartyTarget.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1target, "BOTTOMRIGHT", tonumber(db.oUF.PartyTarget.Backdrop.Padding.Right), tonumber(db.oUF.PartyTarget.Backdrop.Padding.Bottom))
									end,
									order = 9,
								},
								PaddingRight = {
									name = "Right",
									desc = "Value for the Right Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Backdrop.Padding.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyTarget.Backdrop.Padding.Right end,
									set = function(self,PaddingRight)
										if PaddingRight == nil or PaddingRight == "" then
											PaddingRight = "0"
										end
										db.oUF.PartyTarget.Backdrop.Padding.Right = PaddingRight
										oUF_LUI_partyUnitButton1target.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1target, "TOPLEFT", tonumber(db.oUF.PartyTarget.Backdrop.Padding.Left), tonumber(db.oUF.PartyTarget.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1target, "BOTTOMRIGHT", tonumber(db.oUF.PartyTarget.Backdrop.Padding.Right), tonumber(db.oUF.PartyTarget.Backdrop.Padding.Bottom))
									end,
									order = 10,
								},
								PaddingTop = {
									name = "Top",
									desc = "Value for the Top Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Backdrop.Padding.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyTarget.Backdrop.Padding.Top end,
									set = function(self,PaddingTop)
										if PaddingTop == nil or PaddingTop == "" then
											PaddingTop = "0"
										end
										db.oUF.PartyTarget.Backdrop.Padding.Top = PaddingTop
										oUF_LUI_partyUnitButton1target.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1target, "TOPLEFT", tonumber(db.oUF.PartyTarget.Backdrop.Padding.Left), tonumber(db.oUF.PartyTarget.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1target, "BOTTOMRIGHT", tonumber(db.oUF.PartyTarget.Backdrop.Padding.Right), tonumber(db.oUF.PartyTarget.Backdrop.Padding.Bottom))
									end,
									order = 11,
								},
								PaddingBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Backdrop.Padding.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyTarget.Backdrop.Padding.Bottom end,
									set = function(self,PaddingBottom)
										if PaddingBottom == nil or PaddingBottom == "" then
											PaddingBottom = "0"
										end
										db.oUF.PartyTarget.Backdrop.Padding.Bottom = PaddingBottom
										oUF_LUI_partyUnitButton1target.FrameBackdrop:ClearAllPoints()
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1target, "TOPLEFT", tonumber(db.oUF.PartyTarget.Backdrop.Padding.Left), tonumber(db.oUF.PartyTarget.Backdrop.Padding.Top))
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_partyUnitButton1target, "BOTTOMRIGHT", tonumber(db.oUF.PartyTarget.Backdrop.Padding.Right), tonumber(db.oUF.PartyTarget.Backdrop.Padding.Bottom))
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
									desc = "Value for the Left Border Inset\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Border.Insets.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyTarget.Border.Insets.Left end,
									set = function(self,InsetLeft)
										if InsetLeft == nil or InsetLeft == "" then
											InsetLeft = "0"
										end
										db.oUF.PartyTarget.Border.Insets.Left = InsetLeft
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyTarget.Border.Insets.Left), right = tonumber(db.oUF.PartyTarget.Border.Insets.Right), top = tonumber(db.oUF.PartyTarget.Border.Insets.Top), bottom = tonumber(db.oUF.PartyTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyTarget.Backdrop.Color.r), tonumber(db.oUF.PartyTarget.Backdrop.Color.g), tonumber(db.oUF.PartyTarget.Backdrop.Color.b), tonumber(db.oUF.PartyTarget.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyTarget.Border.Color.r), tonumber(db.oUF.PartyTarget.Border.Color.g), tonumber(db.oUF.PartyTarget.Border.Color.b), tonumber(db.oUF.PartyTarget.Border.Color.a))
											end,
									order = 14,
								},
								InsetRight = {
									name = "Right",
									desc = "Value for the Right Border Inset\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Border.Insets.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyTarget.Border.Insets.Right end,
									set = function(self,InsetRight)
										if InsetRight == nil or InsetRight == "" then
											InsetRight = "0"
										end
										db.oUF.PartyTarget.Border.Insets.Right = InsetRight
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyTarget.Border.Insets.Left), right = tonumber(db.oUF.PartyTarget.Border.Insets.Right), top = tonumber(db.oUF.PartyTarget.Border.Insets.Top), bottom = tonumber(db.oUF.PartyTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyTarget.Backdrop.Color.r), tonumber(db.oUF.PartyTarget.Backdrop.Color.g), tonumber(db.oUF.PartyTarget.Backdrop.Color.b), tonumber(db.oUF.PartyTarget.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyTarget.Border.Color.r), tonumber(db.oUF.PartyTarget.Border.Color.g), tonumber(db.oUF.PartyTarget.Border.Color.b), tonumber(db.oUF.PartyTarget.Border.Color.a))
											end,
									order = 15,
								},
								InsetTop = {
									name = "Top",
									desc = "Value for the Top Border Inset\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Border.Insets.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyTarget.Border.Insets.Top end,
									set = function(self,InsetTop)
										if InsetTop == nil or InsetTop == "" then
											InsetTop = "0"
										end
										db.oUF.PartyTarget.Border.Insets.Top = InsetTop
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyTarget.Border.Insets.Left), right = tonumber(db.oUF.PartyTarget.Border.Insets.Right), top = tonumber(db.oUF.PartyTarget.Border.Insets.Top), bottom = tonumber(db.oUF.PartyTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyTarget.Backdrop.Color.r), tonumber(db.oUF.PartyTarget.Backdrop.Color.g), tonumber(db.oUF.PartyTarget.Backdrop.Color.b), tonumber(db.oUF.PartyTarget.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyTarget.Border.Color.r), tonumber(db.oUF.PartyTarget.Border.Color.g), tonumber(db.oUF.PartyTarget.Border.Color.b), tonumber(db.oUF.PartyTarget.Border.Color.a))
											end,
									order = 16,
								},
								InsetBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Border Inset\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Border.Insets.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.PartyTarget.Border.Insets.Bottom end,
									set = function(self,InsetBottom)
										if InsetBottom == nil or InsetBottom == "" then
											InsetBottom = "0"
										end
										db.oUF.PartyTarget.Border.Insets.Bottom = InsetBottom
										oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.PartyTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.PartyTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.PartyTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.PartyTarget.Border.Insets.Left), right = tonumber(db.oUF.PartyTarget.Border.Insets.Right), top = tonumber(db.oUF.PartyTarget.Border.Insets.Top), bottom = tonumber(db.oUF.PartyTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.PartyTarget.Backdrop.Color.r), tonumber(db.oUF.PartyTarget.Backdrop.Color.g), tonumber(db.oUF.PartyTarget.Backdrop.Color.b), tonumber(db.oUF.PartyTarget.Backdrop.Color.a))
											oUF_LUI_partyUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.PartyTarget.Border.Color.r), tonumber(db.oUF.PartyTarget.Border.Color.g), tonumber(db.oUF.PartyTarget.Border.Color.b), tonumber(db.oUF.PartyTarget.Border.Color.a))
											end,
									order = 17,
								},
							},
						},
						AlphaFader = {
							name = "Fader",
							type = "group",
							disabled = function() return not db.oUF.PartyTarget.Enable end,
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
					disabled = function() return not db.oUF.PartyTarget.Enable end,
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
											desc = "Decide the Height of your Party Target Health.\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Health.Height,
											type = "input",
											get = function() return db.oUF.PartyTarget.Health.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.PartyTarget.Health.Height = Height
														oUF_LUI_partyUnitButton1target.Health:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Health.Padding,
											type = "input",
											get = function() return db.oUF.PartyTarget.Health.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.PartyTarget.Health.Padding = Padding
														oUF_LUI_partyUnitButton1target.Health:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Health:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1target, "TOPLEFT", 0, tonumber(Padding))
														oUF_LUI_partyUnitButton1target.Health:SetPoint("TOPRIGHT", oUF_LUI_partyUnitButton1target, "TOPRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.PartyTarget.Health.Smooth end,
											set = function(self,Smooth)
														db.oUF.PartyTarget.Health.Smooth = not db.oUF.PartyTarget.Health.Smooth
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
											get = function() return db.oUF.PartyTarget.Health.ColorClass end,
											set = function(self,HealthClassColor)
														db.oUF.PartyTarget.Health.ColorClass = true
														db.oUF.PartyTarget.Health.ColorGradient = false
														db.oUF.PartyTarget.Health.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Health.colorClass = true
														oUF_LUI_partyUnitButton1target.Health.colorGradient = false
														oUF_LUI_partyUnitButton1target.Health.colorIndividual.Enable = false
															
														print("Party Target Healthbar Color will change once you gain/lose HP")
													end,
											order = 1,
										},
										HealthGradientColor = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthBars or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Health.ColorGradient end,
											set = function(self,HealthGradientColor)
														db.oUF.PartyTarget.Health.ColorGradient = true
														db.oUF.PartyTarget.Health.ColorClass = false
														db.oUF.PartyTarget.Health.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Health.colorGradient = true
														oUF_LUI_partyUnitButton1target.Health.colorClass = false
														oUF_LUI_partyUnitButton1target.Health.colorIndividual.Enable = false
															
														print("Party Target Healthbar Color will change once you gain/lose HP")
													end,
											order = 2,
										},
										IndividualHealthColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual HealthBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Health.IndividualColor.Enable end,
											set = function(self,IndividualHealthColor)
														db.oUF.PartyTarget.Health.IndividualColor.Enable = true
														db.oUF.PartyTarget.Health.ColorClass = false
														db.oUF.PartyTarget.Health.ColorGradient = false
															
														oUF_LUI_partyUnitButton1target.Health.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1target.Health.colorClass = false
														oUF_LUI_partyUnitButton1target.Health.colorGradient = false
															
														oUF_LUI_partyUnitButton1target.Health:SetStatusBarColor(db.oUF.PartyTarget.Health.IndividualColor.r, db.oUF.PartyTarget.Health.IndividualColor.g, db.oUF.PartyTarget.Health.IndividualColor.b)
														oUF_LUI_partyUnitButton1target.Health.bg:SetVertexColor(db.oUF.PartyTarget.Health.IndividualColor.r*tonumber(db.oUF.PartyTarget.Health.BGMultiplier), db.oUF.PartyTarget.Health.IndividualColor.g*tonumber(db.oUF.PartyTarget.Health.BGMultiplier), db.oUF.PartyTarget.Health.IndividualColor.b*tonumber(db.oUF.PartyTarget.Health.BGMultiplier))
													end,
											order = 3,
										},
										HealthColor = {
											name = "Individual Color",
											desc = "Choose an individual Healthbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyTarget.Health.IndividualColor.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyTarget.Health.IndividualColor.r, db.oUF.PartyTarget.Health.IndividualColor.g, db.oUF.PartyTarget.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyTarget.Health.IndividualColor.r = r
													db.oUF.PartyTarget.Health.IndividualColor.g = g
													db.oUF.PartyTarget.Health.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1target.Health.colorIndividual.r = r
													oUF_LUI_partyUnitButton1target.Health.colorIndividual.g = g
													oUF_LUI_partyUnitButton1target.Health.colorIndividual.b = b
														
													oUF_LUI_partyUnitButton1target.Health:SetStatusBarColor(r, g, b)
													oUF_LUI_partyUnitButton1target.Health.bg:SetVertexColor(r*tonumber(db.oUF.PartyTarget.Health.BGMultiplier), g*tonumber(db.oUF.PartyTarget.Health.BGMultiplier), b*tonumber(db.oUF.PartyTarget.Health.BGMultiplier))
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
											desc = "Choose your Health Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Health.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.PartyTarget.Health.Texture
												end,
											set = function(self, HealthTex)
													db.oUF.PartyTarget.Health.Texture = HealthTex
													oUF_LUI_partyUnitButton1target.Health:SetStatusBarTexture(LSM:Fetch("statusbar", HealthTex))
												end,
											order = 1,
										},
										HealthTexBG = {
											name = "Background Texture",
											desc = "Choose your Health Background Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Health.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.PartyTarget.Health.TextureBG
												end,
											set = function(self, HealthTexBG)
													db.oUF.PartyTarget.Health.TextureBG = HealthTexBG
													oUF_LUI_partyUnitButton1target.Health.bg:SetTexture(LSM:Fetch("statusbar", HealthTexBG))
												end,
											order = 2,
										},
										HealthTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Health Background.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Health.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.PartyTarget.Health.BGAlpha end,
											set = function(_, HealthTexBGAlpha) 
													db.oUF.PartyTarget.Health.BGAlpha  = HealthTexBGAlpha
													oUF_LUI_partyUnitButton1target.Health.bg:SetAlpha(tonumber(HealthTexBGAlpha))
												end,
											order = 3,
										},
										HealthTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Health.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.PartyTarget.Health.BGMultiplier end,
											set = function(_, HealthTexBGMultiplier) 
													db.oUF.PartyTarget.Health.BGMultiplier  = HealthTexBGMultiplier
													oUF_LUI_partyUnitButton1target.Health.bg.multiplier = tonumber(HealthTexBGMultiplier)
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
									get = function() return db.oUF.PartyTarget.Power.Enable end,
									set = function(self,EnablePower)
												db.oUF.PartyTarget.Power.Enable = not db.oUF.PartyTarget.Power.Enable
												if EnablePower == true then
													oUF_LUI_partyUnitButton1target.Power:Show()
												else
													oUF_LUI_partyUnitButton1target.Power:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "General Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Power.Enable end,
									guiInline = true,

									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your PartyTarget Power.\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Power.Height,
											type = "input",
											get = function() return db.oUF.PartyTarget.Power.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.PartyTarget.Power.Height = Height
														oUF_LUI_partyUnitButton1target.Power:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Power.Padding,
											type = "input",
											get = function() return db.oUF.PartyTarget.Power.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.PartyTarget.Power.Padding = Padding
														oUF_LUI_partyUnitButton1target.Power:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Power:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1target.Health, "BOTTOMLEFT", 0, tonumber(Padding))
														oUF_LUI_partyUnitButton1target.Power:SetPoint("TOPRIGHT", oUF_LUI_partyUnitButton1target.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.PartyTarget.Power.Smooth end,
											set = function(self,Smooth)
														db.oUF.PartyTarget.Power.Smooth = not db.oUF.PartyTarget.Power.Smooth
														StaticPopup_Show("RELOAD_UI")
													end,
											order = 3,
										},
									}
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Power.Enable end,
									guiInline = true,
									order = 3,
									args = {
										PowerClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Power.ColorClass end,
											set = function(self,PowerClassColor)
														db.oUF.PartyTarget.Power.ColorClass = true
														db.oUF.PartyTarget.Power.ColorType = false
														db.oUF.PartyTarget.Power.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Power.colorClass = true
														oUF_LUI_partyUnitButton1target.Power.colorType = false
														oUF_LUI_partyUnitButton1target.Power.colorIndividual.Enable = false
														
														print("PartyTarget Powerbar Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										PowerColorByType = {
											name = "Color by Type",
											desc = "Wether you want to use Power Type colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Power.ColorType end,
											set = function(self,PowerColorByType)
														db.oUF.PartyTarget.Power.ColorType = true
														db.oUF.PartyTarget.Power.ColorClass = false
														db.oUF.PartyTarget.Power.IndividualColor.Enable = false
																
														oUF_LUI_partyUnitButton1target.Power.colorType = true
														oUF_LUI_partyUnitButton1target.Power.colorClass = false
														oUF_LUI_partyUnitButton1target.Power.colorIndividual.Enable = false
															
														print("PartyTarget Powerbar Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualPowerColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PowerBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Power.IndividualColor.Enable end,
											set = function(self,IndividualPowerColor)
														db.oUF.PartyTarget.Power.IndividualColor.Enable = true
														db.oUF.PartyTarget.Power.ColorType = false
														db.oUF.PartyTarget.Power.ColorClass = false
																
														oUF_LUI_partyUnitButton1target.Power.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1target.Power.colorClass = false
														oUF_LUI_partyUnitButton1target.Power.colorType = false
															
														oUF_LUI_partyUnitButton1target.Power:SetStatusBarColor(db.oUF.PartyTarget.Power.IndividualColor.r, db.oUF.PartyTarget.Power.IndividualColor.g, db.oUF.PartyTarget.Power.IndividualColor.b)
														oUF_LUI_partyUnitButton1target.Power.bg:SetVertexColor(db.oUF.PartyTarget.Power.IndividualColor.r*tonumber(db.oUF.PartyTarget.Power.BGMultiplier), db.oUF.PartyTarget.Power.IndividualColor.g*tonumber(db.oUF.PartyTarget.Power.BGMultiplier), db.oUF.PartyTarget.Power.IndividualColor.b*tonumber(db.oUF.PartyTarget.Power.BGMultiplier))
													end,
											order = 3,
										},
										PowerColor = {
											name = "Individual Color",
											desc = "Choose an individual Powerbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyTarget.Power.IndividualColor.Enable or not db.oUF.PartyTarget.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyTarget.Power.IndividualColor.r, db.oUF.PartyTarget.Power.IndividualColor.g, db.oUF.PartyTarget.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyTarget.Power.IndividualColor.r = r
													db.oUF.PartyTarget.Power.IndividualColor.g = g
													db.oUF.PartyTarget.Power.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1target.Power.colorIndividual.r = r
													oUF_LUI_partyUnitButton1target.Power.colorIndividual.g = g
													oUF_LUI_partyUnitButton1target.Power.colorIndividual.b = b
														
													oUF_LUI_partyUnitButton1target.Power:SetStatusBarColor(r, g, b)
													oUF_LUI_partyUnitButton1target.Power.bg:SetVertexColor(r*tonumber(db.oUF.PartyTarget.Power.BGMultiplier), g*tonumber(db.oUF.PartyTarget.Power.BGMultiplier), b*tonumber(db.oUF.PartyTarget.Power.BGMultiplier))
												end,
											order = 4,
										},
									},
								},
								Textures = {
									name = "Texture Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Power.Enable end,
									guiInline = true,
									order = 4,
									args = {
										PowerTex = {
											name = "Texture",
											desc = "Choose your Power Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Power.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.PartyTarget.Power.Texture
												end,
											set = function(self, PowerTex)
													db.oUF.PartyTarget.Power.Texture = PowerTex
													oUF_LUI_partyUnitButton1target.Power:SetStatusBarTexture(LSM:Fetch("statusbar", PowerTex))
												end,
											order = 1,
										},
										PowerTexBG = {
											name = "Background Texture",
											desc = "Choose your Power Background Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Power.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.PartyTarget.Power.TextureBG
												end,

											set = function(self, PowerTexBG)
													db.oUF.PartyTarget.Power.TextureBG = PowerTexBG
													oUF_LUI_partyUnitButton1target.Power.bg:SetTexture(LSM:Fetch("statusbar", PowerTexBG))
												end,
											order = 2,
										},
										PowerTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Power Background.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Power.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.PartyTarget.Power.BGAlpha end,
											set = function(_, PowerTexBGAlpha) 
													db.oUF.PartyTarget.Power.BGAlpha  = PowerTexBGAlpha
													oUF_LUI_partyUnitButton1target.Power.bg:SetAlpha(tonumber(PowerTexBGAlpha))
												end,
											order = 3,
										},
										PowerTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Power.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.PartyTarget.Power.BGMultiplier end,
											set = function(_, PowerTexBGMultiplier) 
													db.oUF.PartyTarget.Power.BGMultiplier  = PowerTexBGMultiplier
													oUF_LUI_partyUnitButton1target.Power.bg.multiplier = tonumber(PowerTexBGMultiplier)
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
									get = function() return db.oUF.PartyTarget.Full.Enable end,
									set = function(self,EnableFullbar)
												db.oUF.PartyTarget.Full.Enable = not db.oUF.PartyTarget.Full.Enable
												if EnableFullbar == true then
													oUF_LUI_partyUnitButton1target_Full:Show()
												else
													oUF_LUI_partyUnitButton1target_Full:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Full.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your Fullbar.\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Full.Height,
											type = "input",
											get = function() return db.oUF.PartyTarget.Full.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.PartyTarget.Full.Height = Height
														oUF_LUI_partyUnitButton1target_Full:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Fullbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Full.Padding,
											type = "input",
											get = function() return db.oUF.PartyTarget.Full.Padding end,
											set = function(self,Padding)
													if Padding == nil or Padding == "" then
														Padding = "0"
													end
													db.oUF.PartyTarget.Full.Padding = Padding
													oUF_LUI_partyUnitButton1target_Full:ClearAllPoints()
													oUF_LUI_partyUnitButton1target_Full:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1target.Health, "BOTTOMLEFT", 0, tonumber(Padding))
													oUF_LUI_partyUnitButton1target_Full:SetPoint("TOPRIGHT", oUF_LUI_partyUnitButton1target.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
												end,
											order = 2,
										},
										FullTex = {
											name = "Texture",
											desc = "Choose your Fullbar Texture!\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Full.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.PartyTarget.Full.Texture
												end,
											set = function(self, FullTex)
													db.oUF.PartyTarget.Full.Texture = FullTex
													oUF_LUI_partyUnitButton1target_Full:SetStatusBarTexture(LSM:Fetch("statusbar", FullTex))
												end,
											order = 3,
										},
										FullAlpha = {
											name = "Alpha",
											desc = "Choose the Alpha Value for your Fullbar!\n Default: "..LUI.defaults.profile.oUF.PartyTarget.Full.Alpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.PartyTarget.Full.Alpha end,
											set = function(_, FullAlpha)
													db.oUF.PartyTarget.Full.Alpha = FullAlpha
													oUF_LUI_partyUnitButton1target_Full:SetAlpha(FullAlpha)
												end,
											order = 4,
										},
										Color = {
											name = "Color",
											desc = "Choose your Fullbar Color.",
											type = "color",
											hasAlpha = true,
											get = function() return db.oUF.PartyTarget.Full.Color.r, db.oUF.PartyTarget.Full.Color.g, db.oUF.PartyTarget.Full.Color.b, db.oUF.PartyTarget.Full.Color.a end,
											set = function(_,r,g,b,a)
													db.oUF.PartyTarget.Full.Color.r = r
													db.oUF.PartyTarget.Full.Color.g = g
													db.oUF.PartyTarget.Full.Color.b = b
													db.oUF.PartyTarget.Full.Color.a = a
													
													oUF_LUI_partyUnitButton1target_Full:SetStatusBarColor(r, g, b, a)
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
					disabled = function() return not db.oUF.PartyTarget.Enable end,
					order = 6,
					args = {
						Name = {
							name = "Name",
							type = "group",
							order = 1,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the PartyTarget Name or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyTarget.Texts.Name.Enable end,
									set = function(self,Enable)
												db.oUF.PartyTarget.Texts.Name.Enable = not db.oUF.PartyTarget.Texts.Name.Enable
												if Enable == true then
													oUF_LUI_partyUnitButton1target.Info:Show()
												else
													oUF_LUI_partyUnitButton1target.Info:Hide()
												end
											end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyTarget Name Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Name.Size,
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyTarget.Texts.Name.Size end,
											set = function(_, FontSize)
													db.oUF.PartyTarget.Texts.Name.Size = FontSize
													oUF_LUI_partyUnitButton1target.Info:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.Name.Font),db.oUF.PartyTarget.Texts.Name.Size,db.oUF.PartyTarget.Texts.Name.Outline)
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
											desc = "Choose your Font for PartyTarget Name!\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Name.Font,
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyTarget.Texts.Name.Font end,
											set = function(self, Font)
													db.oUF.PartyTarget.Texts.Name.Font = Font
													oUF_LUI_partyUnitButton1target.Info:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.Name.Font),db.oUF.PartyTarget.Texts.Name.Size,db.oUF.PartyTarget.Texts.Name.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyTarget Name.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Name.Outline,
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyTarget.Texts.Name.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyTarget.Texts.Name.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1target.Info:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.Name.Font),db.oUF.PartyTarget.Texts.Name.Size,db.oUF.PartyTarget.Texts.Name.Outline)
												end,
											order = 4,
										},
										NameX = {
											name = "X Value",
											desc = "X Value for your PartyTarget Name.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Name.X,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Name.X end,
											set = function(self,NameX)
														if NameX == nil or NameX == "" then
															NameX = "0"
														end
														db.oUF.PartyTarget.Texts.Name.X = NameX
														oUF_LUI_partyUnitButton1target.Info:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Info:SetPoint(db.oUF.PartyTarget.Texts.Name.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Name.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Name.X), tonumber(db.oUF.PartyTarget.Texts.Name.Y))
													end,
											order = 5,
										},
										NameY = {
											name = "Y Value",
											desc = "Y Value for your PartyTarget Name.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Name.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Name.Y end,
											set = function(self,NameY)
														if NameY == nil or NameY == "" then
															NameY = "0"
														end
														db.oUF.PartyTarget.Texts.Name.Y = NameY
														oUF_LUI_partyUnitButton1target.Info:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Info:SetPoint(db.oUF.PartyTarget.Texts.Name.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Name.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Name.X), tonumber(db.oUF.PartyTarget.Texts.Name.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyTarget Name.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Name.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.Name.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyTarget.Texts.Name.Point = positions[Point]
													oUF_LUI_partyUnitButton1target.Info:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Info:SetPoint(db.oUF.PartyTarget.Texts.Name.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Name.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Name.X), tonumber(db.oUF.PartyTarget.Texts.Name.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyTarget Name.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Name.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.Name.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyTarget.Texts.Name.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1target.Info:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Info:SetPoint(db.oUF.PartyTarget.Texts.Name.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Name.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Name.X), tonumber(db.oUF.PartyTarget.Texts.Name.Y))
												end,
											order = 8,
										},
									},
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Format = {
											name = "Format",
											desc = "Choose the Format for your PartyTarget Name.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Name.Format,
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											type = "select",
											width = "full",
											values = nameFormat,

											get = function()
													for k, v in pairs(nameFormat) do
														if db.oUF.PartyTarget.Texts.Name.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.PartyTarget.Texts.Name.Format = nameFormat[Format]
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 1,
										},
										Length = {
											name = "Length",
											desc = "Choose the Length of your PartyTarget Name.\n\nShort = 6 Letters\nMedium = 18 Letters\nLong = 36 Letters\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Name.Length,
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											type = "select",
											values = nameLenghts,
											get = function()
													for k, v in pairs(nameLenghts) do
														if db.oUF.PartyTarget.Texts.Name.Length == v then
															return k
														end
													end
												end,
											set = function(self, Length)
													db.oUF.PartyTarget.Texts.Name.Length = nameLenghts[Length]
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
											desc = "Wether you want to color the PartyTarget Name by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Name.ColorNameByClass end,
											set = function(self,ColorNameByClass)
													db.oUF.PartyTarget.Texts.Name.ColorNameByClass = not db.oUF.PartyTarget.Texts.Name.ColorNameByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 4,
										},
										ColorClassByClass = {
											name = "Color Class by Class",
											desc = "Wether you want to color the PartyTarget Class by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Name.ColorClassByClass end,
											set = function(self,ColorClassByClass)
													db.oUF.PartyTarget.Texts.Name.ColorClassByClass = not db.oUF.PartyTarget.Texts.Name.ColorClassByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 5,
										},
										ColorLevelByDifficulty = {
											name = "Color Level by Difficulty",
											desc = "Wether you want to color the Level by Difficulty or not.",
											type = "toggle",
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Name.ColorLevelByDifficulty end,
											set = function(self,ColorLevelByDifficulty)
													db.oUF.PartyTarget.Texts.Name.ColorLevelByDifficulty = not db.oUF.PartyTarget.Texts.Name.ColorLevelByDifficulty
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 6,
										},
										ShowClassification = {
											name = "Show Classification",
											desc = "Wether you want to show Classifications like Elite, Boss, Rar or not.",
											type = "toggle",
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Name.ShowClassification end,
											set = function(self,ShowClassification)
													db.oUF.PartyTarget.Texts.Name.ShowClassification = not db.oUF.PartyTarget.Texts.Name.ShowClassification
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 7,
										},
										ShortClassification = {
											name = "Enable Short Classification",
											desc = "Wether you want to show short Classifications or not.",
											type = "toggle",
											width = "full",
											disabled = function() return not db.oUF.PartyTarget.Texts.Name.ShowClassification or not db.oUF.PartyTarget.Texts.Name.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Name.ShortClassification end,
											set = function(self,ShortClassification)
													db.oUF.PartyTarget.Texts.Name.ShortClassification = not db.oUF.PartyTarget.Texts.Name.ShortClassification
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
									desc = "Wether you want to show the PartyTarget Health or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyTarget.Texts.Health.Enable end,
									set = function(self,Enable)
											db.oUF.PartyTarget.Texts.Health.Enable = not db.oUF.PartyTarget.Texts.Health.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1target.Health.value:Show()
											else
												oUF_LUI_partyUnitButton1target.Health.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.Health.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyTarget Health Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Health.Size,
											disabled = function() return not db.oUF.PartyTarget.Texts.Health.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyTarget.Texts.Health.Size end,
											set = function(_, FontSize)
													db.oUF.PartyTarget.Texts.Health.Size = FontSize
													oUF_LUI_partyUnitButton1target.Health.value:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.Health.Font),db.oUF.PartyTarget.Texts.Health.Size,db.oUF.PartyTarget.Texts.Health.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your PartyTarget Health.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Health.Format,
											disabled = function() return not db.oUF.PartyTarget.Texts.Health.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.PartyTarget.Texts.Health.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.PartyTarget.Texts.Health.Format = valueFormat[Format]
													oUF_LUI_partyUnitButton1target.Health.value.Format = valueFormat[Format]
													print("PartyTarget Health Value Format will change once you gain/lose Health")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyTarget Health!\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Health.Font,
											disabled = function() return not db.oUF.PartyTarget.Texts.Health.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyTarget.Texts.Health.Font end,
											set = function(self, Font)
													db.oUF.PartyTarget.Texts.Health.Font = Font
													oUF_LUI_partyUnitButton1target.Health.value:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.Health.Font),db.oUF.PartyTarget.Texts.Health.Size,db.oUF.PartyTarget.Texts.Health.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyTarget Health.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Health.Outline,
											disabled = function() return not db.oUF.PartyTarget.Texts.Health.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyTarget.Texts.Health.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyTarget.Texts.Health.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1target.Health.value:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.Health.Font),db.oUF.PartyTarget.Texts.Health.Size,db.oUF.PartyTarget.Texts.Health.Outline)
												end,
											order = 4,
										},
										HealthX = {
											name = "X Value",
											desc = "X Value for your PartyTarget Health.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Health.X,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.Health.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Health.X end,
											set = function(self,HealthX)
														if HealthX == nil or HealthX == "" then
															HealthX = "0"
														end
														db.oUF.PartyTarget.Texts.Health.X = HealthX
														oUF_LUI_partyUnitButton1target.Health.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Health.value:SetPoint(db.oUF.PartyTarget.Texts.Health.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Health.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Health.X), tonumber(db.oUF.PartyTarget.Texts.Health.Y))
													end,
											order = 5,
										},
										HealthY = {
											name = "Y Value",
											desc = "Y Value for your PartyTarget Health.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Health.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.Health.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Health.Y end,
											set = function(self,HealthY)
														if HealthY == nil or HealthY == "" then
															HealthY = "0"
														end
														db.oUF.PartyTarget.Texts.Health.Y = HealthY
														oUF_LUI_partyUnitButton1target.Health.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Health.value:SetPoint(db.oUF.PartyTarget.Texts.Health.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Health.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Health.X), tonumber(db.oUF.PartyTarget.Texts.Health.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyTarget Health.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Health.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.Health.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyTarget.Texts.Health.Point = positions[Point]
													oUF_LUI_partyUnitButton1target.Health.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Health.value:SetPoint(db.oUF.PartyTarget.Texts.Health.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Health.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Health.X), tonumber(db.oUF.PartyTarget.Texts.Health.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyTarget Health.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Health.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.Health.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyTarget.Texts.Health.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1target.Health.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Health.value:SetPoint(db.oUF.PartyTarget.Texts.Health.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Health.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Health.X), tonumber(db.oUF.PartyTarget.Texts.Health.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.Health.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.Health.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyTarget.Texts.Health.ColorClass = true
														db.oUF.PartyTarget.Texts.Health.ColorGradient = false
														db.oUF.PartyTarget.Texts.Health.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Health.value.colorClass = true
														oUF_LUI_partyUnitButton1target.Health.value.colorGradient = false
														oUF_LUI_partyUnitButton1target.Health.value.colorIndividual.Enable = false
														
														print("PartyTarget Health Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.Health.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.PartyTarget.Texts.Health.ColorGradient = true
														db.oUF.PartyTarget.Texts.Health.ColorClass = false
														db.oUF.PartyTarget.Texts.Health.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Health.value.colorGradient = true
														oUF_LUI_partyUnitButton1target.Health.value.colorClass = false
														oUF_LUI_partyUnitButton1target.Health.value.colorIndividual.Enable = false
															
														print("PartyTarget Health Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyTarget Health Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.Health.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyTarget.Texts.Health.IndividualColor.Enable = true
														db.oUF.PartyTarget.Texts.Health.ColorClass = false
														db.oUF.PartyTarget.Texts.Health.ColorGradient = false
															
														oUF_LUI_partyUnitButton1target.Health.value.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1target.Health.value.colorClass = false
														oUF_LUI_partyUnitButton1target.Health.value.colorGradient = false
														
														oUF_LUI_partyUnitButton1target.Health.value:SetTextColor(tonumber(db.oUF.PartyTarget.Texts.Health.IndividualColor.r),tonumber(db.oUF.PartyTarget.Texts.Health.IndividualColor.g),tonumber(db.oUF.PartyTarget.Texts.Health.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyTarget Health Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyTarget.Texts.Health.IndividualColor.Enable or not db.oUF.PartyTarget.Texts.Health.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyTarget.Texts.Health.IndividualColor.r, db.oUF.PartyTarget.Texts.Health.IndividualColor.g, db.oUF.PartyTarget.Texts.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyTarget.Texts.Health.IndividualColor.r = r
													db.oUF.PartyTarget.Texts.Health.IndividualColor.g = g
													db.oUF.PartyTarget.Texts.Health.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1target.Health.value.colorIndividual.r = r
													oUF_LUI_partyUnitButton1target.Health.value.colorIndividual.g = g
													oUF_LUI_partyUnitButton1target.Health.value.colorIndividual.b = b
													
													oUF_LUI_partyUnitButton1target.Health.value:SetTextColor(r,g,b)
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
											get = function() return db.oUF.PartyTarget.Texts.Health.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.PartyTarget.Texts.Health.ShowDead = not db.oUF.PartyTarget.Texts.Health.ShowDead
														oUF_LUI_partyUnitButton1target.Health.value.ShowDead = db.oUF.PartyTarget.Texts.Health.ShowDead
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
									desc = "Wether you want to show the PartyTarget Power or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyTarget.Texts.Power.Enable end,
									set = function(self,Enable)
											db.oUF.PartyTarget.Texts.Power.Enable = not db.oUF.PartyTarget.Texts.Power.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1target.Power.value:Show()
											else
												oUF_LUI_partyUnitButton1target.Power.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.Power.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyTarget Power Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Power.Size,
											disabled = function() return not db.oUF.PartyTarget.Texts.Power.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyTarget.Texts.Power.Size end,
											set = function(_, FontSize)
													db.oUF.PartyTarget.Texts.Power.Size = FontSize
													oUF_LUI_partyUnitButton1target.Power.value:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.Power.Font),db.oUF.PartyTarget.Texts.Power.Size,db.oUF.PartyTarget.Texts.Power.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your PartyTarget Power.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Power.Format,
											disabled = function() return not db.oUF.PartyTarget.Texts.Power.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.PartyTarget.Texts.Power.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.PartyTarget.Texts.Power.Format = valueFormat[Format]
													oUF_LUI_partyUnitButton1target.Power.value.Format = valueFormat[Format]
													print("PartyTarget Power Value Format will change once you gain/lose Power")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyTarget Power!\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Power.Font,
											disabled = function() return not db.oUF.PartyTarget.Texts.Power.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyTarget.Texts.Power.Font end,
											set = function(self, Font)
													db.oUF.PartyTarget.Texts.Power.Font = Font
													oUF_LUI_partyUnitButton1target.Power.value:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.Power.Font),db.oUF.PartyTarget.Texts.Power.Size,db.oUF.PartyTarget.Texts.Power.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyTarget Power.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Power.Outline,
											disabled = function() return not db.oUF.PartyTarget.Texts.Power.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyTarget.Texts.Power.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyTarget.Texts.Power.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1target.Power.value:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.Power.Font),db.oUF.PartyTarget.Texts.Power.Size,db.oUF.PartyTarget.Texts.Power.Outline)
												end,
											order = 4,
										},
										PowerX = {
											name = "X Value",
											desc = "X Value for your PartyTarget Power.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Power.X,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.Power.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Power.X end,
											set = function(self,PowerX)
														if PowerX == nil or PowerX == "" then
															PowerX = "0"
														end
														db.oUF.PartyTarget.Texts.Power.X = PowerX
														oUF_LUI_partyUnitButton1target.Power.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Power.value:SetPoint(db.oUF.PartyTarget.Texts.Power.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Power.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Power.X), tonumber(db.oUF.PartyTarget.Texts.Power.Y))
													end,
											order = 5,
										},
										PowerY = {
											name = "Y Value",
											desc = "Y Value for your PartyTarget Power.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Power.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.Power.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.Power.Y end,
											set = function(self,PowerY)
														if PowerY == nil or PowerY == "" then
															PowerY = "0"
														end
														db.oUF.PartyTarget.Texts.Power.Y = PowerY
														oUF_LUI_partyUnitButton1target.Power.value:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Power.value:SetPoint(db.oUF.PartyTarget.Texts.Power.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Power.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Power.X), tonumber(db.oUF.PartyTarget.Texts.Power.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyTarget Power.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Power.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.Power.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyTarget.Texts.Power.Point = positions[Point]
													oUF_LUI_partyUnitButton1target.Power.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Power.value:SetPoint(db.oUF.PartyTarget.Texts.Power.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Power.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Power.X), tonumber(db.oUF.PartyTarget.Texts.Power.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyTarget Power.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.Power.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.Power.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyTarget.Texts.Power.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1target.Power.value:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Power.value:SetPoint(db.oUF.PartyTarget.Texts.Power.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.Power.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.Power.X), tonumber(db.oUF.PartyTarget.Texts.Power.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.Power.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.Power.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyTarget.Texts.Power.ColorClass = true
														db.oUF.PartyTarget.Texts.Power.ColorType = false
														db.oUF.PartyTarget.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Power.value.colorClass = true
														oUF_LUI_partyUnitButton1target.Power.value.colorType = false
														oUF_LUI_partyUnitButton1target.Power.value.colorIndividual.Enable = false
			
														print("PartyTarget Power Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Powertype colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.Power.ColorType end,
											set = function(self,ColorType)
														db.oUF.PartyTarget.Texts.Power.ColorType = true
														db.oUF.PartyTarget.Texts.Power.ColorClass = false
														db.oUF.PartyTarget.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Power.value.colorType = true
														oUF_LUI_partyUnitButton1target.Power.value.colorClass = false
														oUF_LUI_partyUnitButton1target.Power.value.colorIndividual.Enable = false
		
														print("PartyTarget Power Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyTarget Power Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.Power.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyTarget.Texts.Power.IndividualColor.Enable = true
														db.oUF.PartyTarget.Texts.Power.ColorClass = false
														db.oUF.PartyTarget.Texts.Power.ColorType = false
														
														oUF_LUI_partyUnitButton1target.Power.value.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1target.Power.value.colorClass = false
														oUF_LUI_partyUnitButton1target.Power.value.colorType = false
			
														oUF_LUI_partyUnitButton1target.Power.value:SetTextColor(tonumber(db.oUF.PartyTarget.Texts.Power.IndividualColor.r),tonumber(db.oUF.PartyTarget.Texts.Power.IndividualColor.g),tonumber(db.oUF.PartyTarget.Texts.Power.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyTarget Power Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyTarget.Texts.Power.IndividualColor.Enable or not db.oUF.PartyTarget.Texts.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyTarget.Texts.Power.IndividualColor.r, db.oUF.PartyTarget.Texts.Power.IndividualColor.g, db.oUF.PartyTarget.Texts.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyTarget.Texts.Power.IndividualColor.r = r
													db.oUF.PartyTarget.Texts.Power.IndividualColor.g = g
													db.oUF.PartyTarget.Texts.Power.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1target.Power.value.colorIndividual.r = r
													oUF_LUI_partyUnitButton1target.Power.value.colorIndividual.g = g
													oUF_LUI_partyUnitButton1target.Power.value.colorIndividual.b = b

													oUF_LUI_partyUnitButton1target.Power.value:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the PartyTarget HealthPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
									set = function(self,Enable)
											db.oUF.PartyTarget.Texts.HealthPercent.Enable = not db.oUF.PartyTarget.Texts.HealthPercent.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1target.Health.valuePercent:Show()
											else
												oUF_LUI_partyUnitButton1target.Health.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyTarget HealthPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthPercent.Size,
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyTarget.Texts.HealthPercent.Size end,
											set = function(_, FontSize)
													db.oUF.PartyTarget.Texts.HealthPercent.Size = FontSize
													oUF_LUI_partyUnitButton1target.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.HealthPercent.Font),db.oUF.PartyTarget.Texts.HealthPercent.Size,db.oUF.PartyTarget.Texts.HealthPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show PartyTarget HealthPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.HealthPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.PartyTarget.Texts.HealthPercent.ShowAlways = not db.oUF.PartyTarget.Texts.HealthPercent.ShowAlways
													oUF_LUI_partyUnitButton1target.health.valuePercent = db.oUF.PartyTarget.Texts.HealthPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyTarget HealthPercent!\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthPercent.Font,
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyTarget.Texts.HealthPercent.Font end,
											set = function(self, Font)
													db.oUF.PartyTarget.Texts.HealthPercent.Font = Font
													oUF_LUI_partyUnitButton1target.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.HealthPercent.Font),db.oUF.PartyTarget.Texts.HealthPercent.Size,db.oUF.PartyTarget.Texts.HealthPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyTarget HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthPercent.Outline,
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyTarget.Texts.HealthPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyTarget.Texts.HealthPercent.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1target.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.HealthPercent.Font),db.oUF.PartyTarget.Texts.HealthPercent.Size,db.oUF.PartyTarget.Texts.HealthPercent.Outline)
												end,
											order = 4,
										},
										HealthPercentX = {
											name = "X Value",
											desc = "X Value for your PartyTarget HealthPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthPercent.X,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.HealthPercent.X end,
											set = function(self,HealthPercentX)
														if HealthPercentX == nil or HealthPercentX == "" then
															HealthPercentX = "0"
														end
														db.oUF.PartyTarget.Texts.HealthPercent.X = HealthPercentX
														oUF_LUI_partyUnitButton1target.Health.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Health.valuePercent:SetPoint(db.oUF.PartyTarget.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.HealthPercent.X), tonumber(db.oUF.PartyTarget.Texts.HealthPercent.Y))
													end,
											order = 5,
										},
										HealthPercentY = {
											name = "Y Value",
											desc = "Y Value for your PartyTarget HealthPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.HealthPercent.Y end,
											set = function(self,HealthPercentY)
														if HealthPercentY == nil or HealthPercentY == "" then
															HealthPercentY = "0"
														end
														db.oUF.PartyTarget.Texts.HealthPercent.Y = HealthPercentY
														oUF_LUI_partyUnitButton1target.Health.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Health.valuePercent:SetPoint(db.oUF.PartyTarget.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.HealthPercent.X), tonumber(db.oUF.PartyTarget.Texts.HealthPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyTarget HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.HealthPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyTarget.Texts.HealthPercent.Point = positions[Point]
													oUF_LUI_partyUnitButton1target.Health.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Health.valuePercent:SetPoint(db.oUF.PartyTarget.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.HealthPercent.X), tonumber(db.oUF.PartyTarget.Texts.HealthPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyTarget HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.HealthPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyTarget.Texts.HealthPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1target.Health.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Health.valuePercent:SetPoint(db.oUF.PartyTarget.Texts.HealthPercent.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.HealthPercent.X), tonumber(db.oUF.PartyTarget.Texts.HealthPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.HealthPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyTarget.Texts.HealthPercent.ColorClass = true
														db.oUF.PartyTarget.Texts.HealthPercent.ColorGradient = false
														db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Health.valuePercent.colorClass = true
														oUF_LUI_partyUnitButton1target.Health.valuePercent.colorGradient = false
														oUF_LUI_partyUnitButton1target.Health.valuePercent.colorIndividual.Enable = false
					
														print("PartyTarget HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.HealthPercent.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.PartyTarget.Texts.HealthPercent.ColorGradient = true
														db.oUF.PartyTarget.Texts.HealthPercent.ColorClass = false
														db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Health.valuePercent.colorGradient = true
														oUF_LUI_partyUnitButton1target.Health.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1target.Health.valuePercent.colorIndividual.Enable = false
				
														print("PartyTarget HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyTarget HealthPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.Enable = true
														db.oUF.PartyTarget.Texts.HealthPercent.ColorClass = false
														db.oUF.PartyTarget.Texts.HealthPercent.ColorGradient = false
															
														oUF_LUI_partyUnitButton1target.Health.valuePercent.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1target.Health.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1target.Health.valuePercent.colorGradient = false
							
														oUF_LUI_partyUnitButton1target.Health.valuePercent:SetTextColor(tonumber(db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.r),tonumber(db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.g),tonumber(db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyTarget HealthPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.Enable or not db.oUF.PartyTarget.Texts.HealthPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.r, db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.g, db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.r = r
													db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.g = g
													db.oUF.PartyTarget.Texts.HealthPercent.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1target.Health.valuePercent.colorIndividual.r = r
													oUF_LUI_partyUnitButton1target.Health.valuePercent.colorIndividual.g = g
													oUF_LUI_partyUnitButton1target.Health.valuePercent.colorIndividual.b = b
			
													oUF_LUI_partyUnitButton1target.Health.valuePercent:SetTextColor(r,g,b)
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
											get = function() return db.oUF.PartyTarget.Texts.HealthPercent.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.PartyTarget.Texts.HealthPercent.ShowDead = not db.oUF.PartyTarget.Texts.HealthPercent.ShowDead
														oUF_LUI_partyUnitButton1target.Health.valuePercent.ShowDead = db.oUF.PartyTarget.Texts.HealthPercent.ShowDead
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
									desc = "Wether you want to show the PartyTarget PowerPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
									set = function(self,Enable)
											db.oUF.PartyTarget.Texts.PowerPercent.Enable = not db.oUF.PartyTarget.Texts.PowerPercent.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1target.Power.valuePercent:Show()
											else
												oUF_LUI_partyUnitButton1target.Power.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyTarget PowerPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerPercent.Size,
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyTarget.Texts.PowerPercent.Size end,
											set = function(_, FontSize)
													db.oUF.PartyTarget.Texts.PowerPercent.Size = FontSize
													oUF_LUI_partyUnitButton1target.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.PowerPercent.Font),db.oUF.PartyTarget.Texts.PowerPercent.Size,db.oUF.PartyTarget.Texts.PowerPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show PartyTarget PowerPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.PowerPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.PartyTarget.Texts.PowerPercent.ShowAlways = not db.oUF.PartyTarget.Texts.PowerPercent.ShowAlways
													oUF_LUI_partyUnitButton1target.Power.valuePercent.ShowAlways = db.oUF.PartyTarget.Texts.PowerPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyTarget PowerPercent!\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerPercent.Font,
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyTarget.Texts.PowerPercent.Font end,
											set = function(self, Font)
													db.oUF.PartyTarget.Texts.PowerPercent.Font = Font
													oUF_LUI_partyUnitButton1target.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.PowerPercent.Font),db.oUF.PartyTarget.Texts.PowerPercent.Size,db.oUF.PartyTarget.Texts.PowerPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyTarget PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerPercent.Outline,
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyTarget.Texts.PowerPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyTarget.Texts.PowerPercent.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1target.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.PowerPercent.Font),db.oUF.PartyTarget.Texts.PowerPercent.Size,db.oUF.PartyTarget.Texts.PowerPercent.Outline)
												end,
											order = 4,
										},
										PowerPercentX = {
											name = "X Value",
											desc = "X Value for your PartyTarget PowerPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerPercent.X,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.PowerPercent.X end,
											set = function(self,PowerPercentX)
														if PowerPercentX == nil or PowerPercentX == "" then
															PowerPercentX = "0"
														end
														db.oUF.PartyTarget.Texts.PowerPercent.X = PowerPercentX
														oUF_LUI_partyUnitButton1target.Power.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Power.valuePercent:SetPoint(db.oUF.PartyTarget.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.PowerPercent.X), tonumber(db.oUF.PartyTarget.Texts.PowerPercent.Y))
													end,
											order = 5,

										},
										PowerPercentY = {
											name = "Y Value",
											desc = "Y Value for your PartyTarget PowerPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.PowerPercent.Y end,
											set = function(self,PowerPercentY)
														if PowerPercentY == nil or PowerPercentY == "" then
															PowerPercentY = "0"
														end
														db.oUF.PartyTarget.Texts.PowerPercent.Y = PowerPercentY
														oUF_LUI_partyUnitButton1target.Power.valuePercent:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Power.valuePercent:SetPoint(db.oUF.PartyTarget.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.PowerPercent.X), tonumber(db.oUF.PartyTarget.Texts.PowerPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyTarget PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.PowerPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyTarget.Texts.PowerPercent.Point = positions[Point]
													oUF_LUI_partyUnitButton1target.Power.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Power.valuePercent:SetPoint(db.oUF.PartyTarget.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.PowerPercent.X), tonumber(db.oUF.PartyTarget.Texts.PowerPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyTarget PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.PowerPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyTarget.Texts.PowerPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1target.Power.valuePercent:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Power.valuePercent:SetPoint(db.oUF.PartyTarget.Texts.PowerPercent.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.PowerPercent.X), tonumber(db.oUF.PartyTarget.Texts.PowerPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.PowerPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyTarget.Texts.PowerPercent.ColorClass = true
														db.oUF.PartyTarget.Texts.PowerPercent.ColorType = false
														db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.Enable = false
														
														oUF_LUI_partyUnitButton1target.Power.valuePercent.colorClass = true
														oUF_LUI_partyUnitButton1target.Power.valuePercent.colorType = false
														oUF_LUI_partyUnitButton1target.Power.valuePercent.individualColor.Enable = false
	
														print("PartyTarget PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.PowerPercent.ColorType end,
											set = function(self,ColorType)
														db.oUF.PartyTarget.Texts.PowerPercent.ColorType = true
														db.oUF.PartyTarget.Texts.PowerPercent.ColorClass = false
														db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Power.valuePercent.colorType = true
														oUF_LUI_partyUnitButton1target.Power.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1target.Power.valuePercent.individualColor.Enable = false
		
														print("PartyTarget PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyTarget PowerPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.Enable = true
														db.oUF.PartyTarget.Texts.PowerPercent.ColorClass = false
														db.oUF.PartyTarget.Texts.PowerPercent.ColorType = false
															
														oUF_LUI_partyUnitButton1target.Power.valuePercent.individualColor.Enable = true
														oUF_LUI_partyUnitButton1target.Power.valuePercent.colorClass = false
														oUF_LUI_partyUnitButton1target.Power.valuePercent.colorType = false

														oUF_LUI_partyUnitButton1target.Power.valuePercent:SetTextColor(tonumber(db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.r),tonumber(db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.g),tonumber(db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyTarget PowerPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.Enable or not db.oUF.PartyTarget.Texts.PowerPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.r, db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.g, db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.r = r
													db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.g = g
													db.oUF.PartyTarget.Texts.PowerPercent.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1target.Power.valuePercent.individualColor.r = r
													oUF_LUI_partyUnitButton1target.Power.valuePercent.individualColor.g = g
													oUF_LUI_partyUnitButton1target.Power.valuePercent.individualColor.b = b

													oUF_LUI_partyUnitButton1target.Power.valuePercent:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the PartyTarget HealthMissing or not.",
									type = "toggle",

									width = "full",
									get = function() return db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
									set = function(self,Enable)
											db.oUF.PartyTarget.Texts.HealthMissing.Enable = not db.oUF.PartyTarget.Texts.HealthMissing.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1target.Health.valueMissing:Show()
											else
												oUF_LUI_partyUnitButton1target.Health.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyTarget HealthMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthMissing.Size,
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyTarget.Texts.HealthMissing.Size end,
											set = function(_, FontSize)
													db.oUF.PartyTarget.Texts.HealthMissing.Size = FontSize
													oUF_LUI_partyUnitButton1target.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.HealthMissing.Font),db.oUF.PartyTarget.Texts.HealthMissing.Size,db.oUF.PartyTarget.Texts.HealthMissing.Outline)
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
											desc = "Always show PartyTarget HealthMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.HealthMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.PartyTarget.Texts.HealthMissing.ShowAlways = not db.oUF.PartyTarget.Texts.HealthMissing.ShowAlways
													oUF_LUI_partyUnitButton1target.Health.valueMissing.ShowAlways = db.oUF.PartyTarget.Texts.HealthMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.HealthMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.PartyTarget.Texts.HealthMissing.ShortValue = not db.oUF.PartyTarget.Texts.HealthMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyTarget HealthMissing!\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthMissing.Font,
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyTarget.Texts.HealthMissing.Font end,
											set = function(self, Font)
													db.oUF.PartyTarget.Texts.HealthMissing.Font = Font
													oUF_LUI_partyUnitButton1target.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.HealthMissing.Font),db.oUF.PartyTarget.Texts.HealthMissing.Size,db.oUF.PartyTarget.Texts.HealthMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyTarget HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthMissing.Outline,
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyTarget.Texts.HealthMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyTarget.Texts.HealthMissing.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1target.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.HealthMissing.Font),db.oUF.PartyTarget.Texts.HealthMissing.Size,db.oUF.PartyTarget.Texts.HealthMissing.Outline)
												end,
											order = 6,
										},
										HealthMissingX = {
											name = "X Value",
											desc = "X Value for your PartyTarget HealthMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthMissing.X,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.HealthMissing.X end,
											set = function(self,HealthMissingX)
														if HealthMissingX == nil or HealthMissingX == "" then
															HealthMissingX = "0"
														end
														db.oUF.PartyTarget.Texts.HealthMissing.X = HealthMissingX
														oUF_LUI_partyUnitButton1target.Health.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Health.valueMissing:SetPoint(db.oUF.PartyTarget.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.HealthMissing.X), tonumber(db.oUF.PartyTarget.Texts.HealthMissing.Y))
													end,
											order = 7,
										},
										HealthMissingY = {
											name = "Y Value",
											desc = "Y Value for your PartyTarget HealthMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.HealthMissing.Y end,
											set = function(self,HealthMissingY)
														if HealthMissingY == nil or HealthMissingY == "" then
															HealthMissingY = "0"
														end
														db.oUF.PartyTarget.Texts.HealthMissing.Y = HealthMissingY
														oUF_LUI_partyUnitButton1target.Health.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Health.valueMissing:SetPoint(db.oUF.PartyTarget.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.HealthMissing.X), tonumber(db.oUF.PartyTarget.Texts.HealthMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyTarget HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.HealthMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyTarget.Texts.HealthMissing.Point = positions[Point]
													oUF_LUI_partyUnitButton1target.Health.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Health.valueMissing:SetPoint(db.oUF.PartyTarget.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.HealthMissing.X), tonumber(db.oUF.PartyTarget.Texts.HealthMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyTarget HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.HealthMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.HealthMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyTarget.Texts.HealthMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1target.Health.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Health.valueMissing:SetPoint(db.oUF.PartyTarget.Texts.HealthMissing.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.HealthMissing.X), tonumber(db.oUF.PartyTarget.Texts.HealthMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.HealthMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyTarget.Texts.HealthMissing.ColorClass = true
														db.oUF.PartyTarget.Texts.HealthMissing.ColorGradient = false
														db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.Enable = false
														
														oUF_LUI_partyUnitButton1target.Health.valueMissing.colorClass = true
														oUF_LUI_partyUnitButton1target.Health.valueMissing.colorGradient = false
														oUF_LUI_partyUnitButton1target.Health.valueMissing.colorIndividual.Enable = false
	
														print("PartyTarget HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.HealthMissing.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.PartyTarget.Texts.HealthMissing.ColorGradient = true
														db.oUF.PartyTarget.Texts.HealthMissing.ColorClass = false
														db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Health.valueMissing.colorGradient = true
														oUF_LUI_partyUnitButton1target.Health.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1target.Health.valueMissing.colorIndividual.Enable = false

														print("PartyTarget HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyTarget HealthMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.Enable = true
														db.oUF.PartyTarget.Texts.HealthMissing.ColorClass = false
														db.oUF.PartyTarget.Texts.HealthMissing.ColorGradient = false
															
														oUF_LUI_partyUnitButton1target.Health.valueMissing.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1target.Health.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1target.Health.valueMissing.colorGradient = false

														oUF_LUI_partyUnitButton1target.Health.valueMissing:SetTextColor(tonumber(db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.r),tonumber(db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.g),tonumber(db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyTarget HealthMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.Enable or not db.oUF.PartyTarget.Texts.HealthMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.r, db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.g, db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.r = r
													db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.g = g
													db.oUF.PartyTarget.Texts.HealthMissing.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1target.Health.valueMissing.colorIndividual.r = r
													oUF_LUI_partyUnitButton1target.Health.valueMissing.colorIndividual.g = g
													oUF_LUI_partyUnitButton1target.Health.valueMissing.colorIndividual.b = b
													
													oUF_LUI_partyUnitButton1target.Health.valueMissing:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the PartyTarget PowerMissing or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
									set = function(self,Enable)
											db.oUF.PartyTarget.Texts.PowerMissing.Enable = not db.oUF.PartyTarget.Texts.PowerMissing.Enable
											if Enable == true then
												oUF_LUI_partyUnitButton1target.Power.valueMissing:Show()
											else
												oUF_LUI_partyUnitButton1target.Power.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your PartyTarget PowerMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerMissing.Size,
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.PartyTarget.Texts.PowerMissing.Size end,
											set = function(_, FontSize)
													db.oUF.PartyTarget.Texts.PowerMissing.Size = FontSize
													oUF_LUI_partyUnitButton1target.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.PowerMissing.Font),db.oUF.PartyTarget.Texts.PowerMissing.Size,db.oUF.PartyTarget.Texts.PowerMissing.Outline)
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
											desc = "Always show PartyTarget PowerMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.PowerMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.PartyTarget.Texts.PowerMissing.ShowAlways = not db.oUF.PartyTarget.Texts.PowerMissing.ShowAlways
													oUF_LUI_partyUnitButton1target.Power.valueMissing.ShowAlways = db.oUF.PartyTarget.Texts.PowerMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.PowerMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.PartyTarget.Texts.PowerMissing.ShortValue = not db.oUF.PartyTarget.Texts.PowerMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for PartyTarget PowerMissing!\n\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerMissing.Font,
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.PartyTarget.Texts.PowerMissing.Font end,
											set = function(self, Font)
													db.oUF.PartyTarget.Texts.PowerMissing.Font = Font
													oUF_LUI_partyUnitButton1target.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.PowerMissing.Font),db.oUF.PartyTarget.Texts.PowerMissing.Size,db.oUF.PartyTarget.Texts.PowerMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your PartyTarget PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerMissing.Outline,
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.PartyTarget.Texts.PowerMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.PartyTarget.Texts.PowerMissing.Outline = fontflags[FontFlag]
													oUF_LUI_partyUnitButton1target.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.PartyTarget.Texts.PowerMissing.Font),db.oUF.PartyTarget.Texts.PowerMissing.Size,db.oUF.PartyTarget.Texts.PowerMissing.Outline)
												end,
											order = 6,
										},
										PowerMissingX = {
											name = "X Value",
											desc = "X Value for your PartyTarget PowerMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerMissing.X,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.PowerMissing.X end,
											set = function(self,PowerMissingX)
														if PowerMissingX == nil or PowerMissingX == "" then
															PowerMissingX = "0"
														end
														db.oUF.PartyTarget.Texts.PowerMissing.X = PowerMissingX
														oUF_LUI_partyUnitButton1target.Power.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Power.valueMissing:SetPoint(db.oUF.PartyTarget.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.PowerMissing.X), tonumber(db.oUF.PartyTarget.Texts.PowerMissing.Y))
													end,
											order = 7,
										},
										PowerMissingY = {
											name = "Y Value",
											desc = "Y Value for your PartyTarget PowerMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.PartyTarget.Texts.PowerMissing.Y end,
											set = function(self,PowerMissingY)
														if PowerMissingY == nil or PowerMissingY == "" then
															PowerMissingY = "0"
														end
														db.oUF.PartyTarget.Texts.PowerMissing.Y = PowerMissingY
														oUF_LUI_partyUnitButton1target.Power.valueMissing:ClearAllPoints()
														oUF_LUI_partyUnitButton1target.Power.valueMissing:SetPoint(db.oUF.PartyTarget.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.PowerMissing.X), tonumber(db.oUF.PartyTarget.Texts.PowerMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your PartyTarget PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.PowerMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.PartyTarget.Texts.PowerMissing.Point = positions[Point]
													oUF_LUI_partyUnitButton1target.Power.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Power.valueMissing:SetPoint(db.oUF.PartyTarget.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.PowerMissing.X), tonumber(db.oUF.PartyTarget.Texts.PowerMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your PartyTarget PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Texts.PowerMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.PartyTarget.Texts.PowerMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.PartyTarget.Texts.PowerMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_partyUnitButton1target.Power.valueMissing:ClearAllPoints()
													oUF_LUI_partyUnitButton1target.Power.valueMissing:SetPoint(db.oUF.PartyTarget.Texts.PowerMissing.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.PartyTarget.Texts.PowerMissing.X), tonumber(db.oUF.PartyTarget.Texts.PowerMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.PowerMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.PartyTarget.Texts.PowerMissing.ColorClass = true
														db.oUF.PartyTarget.Texts.PowerMissing.ColorType = false
														db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Power.valueMissing.colorClass = true
														oUF_LUI_partyUnitButton1target.Power.valueMissing.colorType = false
														oUF_LUI_partyUnitButton1target.Power.valueMissing.colorIndividual.Enable = false

														print("PartyTarget PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.PowerMissing.ColorType end,
											set = function(self,ColorType)
														db.oUF.PartyTarget.Texts.PowerMissing.ColorType = true
														db.oUF.PartyTarget.Texts.PowerMissing.ColorClass = false
														db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_partyUnitButton1target.Power.valueMissing.colorType = true
														oUF_LUI_partyUnitButton1target.Power.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1target.Power.valueMissing.colorIndividual.Enable = false
		
														print("PartyTarget PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PartyTarget PowerMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.Enable = true
														db.oUF.PartyTarget.Texts.PowerMissing.ColorClass = false
														db.oUF.PartyTarget.Texts.PowerMissing.ColorType = false
															
														oUF_LUI_partyUnitButton1target.Power.valueMissing.colorIndividual.Enable = true
														oUF_LUI_partyUnitButton1target.Power.valueMissing.colorClass = false
														oUF_LUI_partyUnitButton1target.Power.valueMissing.colorType = false
		
														oUF_LUI_partyUnitButton1target.Power.valueMissing:SetTextColor(tonumber(db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.r),tonumber(db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.g),tonumber(db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual PartyTarget PowerMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.Enable or not db.oUF.PartyTarget.Texts.PowerMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.r, db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.g, db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.r = r
													db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.g = g
													db.oUF.PartyTarget.Texts.PowerMissing.IndividualColor.b = b
													
													oUF_LUI_partyUnitButton1target.Power.valueMissing.colorIndividual.r = r
													oUF_LUI_partyUnitButton1target.Power.valueMissing.colorIndividual.g = g
													oUF_LUI_partyUnitButton1target.Power.valueMissing.colorIndividual.b = b
													
													oUF_LUI_partyUnitButton1target.Power.valueMissing:SetTextColor(r,g,b)
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
					disabled = function() return not db.oUF.PartyTarget.Enable end,
					args = {
						header1 = {
							name = "PartyTarget Auras",
							type = "header",
							order = 1,
						},
						PartyTargetBuffs = {
							name = "Buffs",
							type = "group",
							order = 2,
							args = {
								PartyTargetBuffsEnable = {
									name = "Enable PartyTarget Buffs",
									desc = "Wether you want to show PartyTarget Buffs or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyTarget.Aura.buffs_enable end,
									set = function(self,PartyTargetBuffsEnable)
												db.oUF.PartyTarget.Aura.buffs_enable = not db.oUF.PartyTarget.Aura.buffs_enable 
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 0,
								},
								PartyTargetBuffsAuratimer = {
									name = "Enable Auratimer",
									desc = "Wether you want to show Auratimers or not.",
									type = "toggle",
									disabled = function() return not db.oUF.PartyTarget.Aura.buffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.buffs_auratimer end,
									set = function(self,PartyTargetBuffsAuratimer)
												db.oUF.PartyTarget.Aura.buffs_auratimer = not db.oUF.PartyTarget.Aura.buffs_auratimer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								PartyTargetBuffsNum = {
									name = "Amount",
									desc = "Amount of your PartyTarget Buffs.\nDefault: 8",
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Aura.buffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.buffs_num end,
									set = function(self,PartyTargetBuffsNum)
												if PartyTargetBuffsNum == nil or PartyTargetBuffsNum == "" then
													PartyTargetBuffsNum = "0"
												end
												db.oUF.PartyTarget.Aura.buffs_num = PartyTargetBuffsNum
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								PartyTargetBuffsSize = {
									name = "Size",
									desc = "Size for your PartyTarget Buffs.\nDefault: 18",
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Aura.buffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.buffs_size end,
									set = function(self,PartyTargetBuffsSize)
												if PartyTargetBuffsSize == nil or PartyTargetBuffsSize == "" then
													PartyTargetBuffsSize = "0"
												end
												db.oUF.PartyTarget.Aura.buffs_size = PartyTargetBuffsSize
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
								PartyTargetBuffsSpacing = {
									name = "Spacing",
									desc = "Spacing between your PartyTarget Buffs.\nDefault: 2",
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Aura.buffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.buffs_spacing end,
									set = function(self,PartyTargetBuffsSpacing)
												if PartyTargetBuffsSpacing == nil or PartyTargetBuffsSpacing == "" then
													PartyTargetBuffsSpacing = "0"
												end
												db.oUF.PartyTarget.Aura.buffs_spacing = PartyTargetBuffsSpacing
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 5,
								},
								PartyTargetBuffsX = {
									name = "X Value",
									desc = "X Value for your PartyTarget Buffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: 0",
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Aura.buffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.buffsX end,
									set = function(self,PartyTargetBuffsX)
												if PartyTargetBuffsX == nil or PartyTargetBuffsX == "" then
													PartyTargetBuffsX = "0"
												end
												db.oUF.PartyTarget.Aura.buffsX = PartyTargetBuffsX
												oUF_LUI_partyUnitButton1target_buffs:SetPoint(db.oUF.PartyTarget.Aura.buffs_initialAnchor, oUF_LUI_partyUnitButton1target.Health, db.oUF.PartyTarget.Aura.buffs_initialAnchor, PartyTargetBuffsX, db.oUF.PartyTarget.Aura.buffsY)
											end,
									order = 6,
								},
								PartyTargetBuffsY = {
									name = "Y Value",
									desc = "Y Value for your PartyTarget Buffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: -25",
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Aura.buffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.buffsY end,
									set = function(self,PartyTargetBuffsY)
												if PartyTargetBuffsY == nil or PartyTargetBuffsY == "" then
													PartyTargetBuffsY = "0"
												end
												db.oUF.PartyTarget.Aura.buffsY = PartyTargetBuffsY
												oUF_LUI_partyUnitButton1target_buffs:SetPoint(db.oUF.PartyTarget.Aura.buffs_initialAnchor, oUF_LUI_partyUnitButton1target.Health, db.oUF.PartyTarget.Aura.buffs_initialAnchor, db.oUF.PartyTarget.Aura.buffsX, PartyTargetBuffsY)
											end,
									order = 7,
								},
								PartyTargetBuffsGrowthY = {
									name = "Growth Y",
									desc = "Choose the growth Y direction for your PartyTarget Buffs.\nDefault: DOWN",
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Aura.buffs_enable end,
									values = growthY,
									get = function()
											for k, v in pairs(growthY) do
												if db.oUF.PartyTarget.Aura.buffs_growthY == v then
													return k
												end
											end
										end,
									set = function(self, PartyTargetBuffsGrowthY)
											db.oUF.PartyTarget.Aura.buffs_growthY = growthY[PartyTargetBuffsGrowthY]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 8,
								},
								PartyTargetBuffsGrowthX = {
									name = "Growth X",
									desc = "Choose the growth X direction for your PartyTarget Buffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Aura.buffs_enable end,
									values = growthX,
									get = function()
											for k, v in pairs(growthX) do
												if db.oUF.PartyTarget.Aura.buffs_growthX == v then
													return k
												end
											end
										end,
									set = function(self, PartyTargetBuffsGrowthX)
											db.oUF.PartyTarget.Aura.buffs_growthX = growthX[PartyTargetBuffsGrowthX]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 9,
								},
								PartyTargetBuffsAnchor = {
									name = "Initial Anchor",
									desc = "Choose the initinal Anchor for your PartyTarget Buffs.\nDefault: BOTTOMLEFT",
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Aura.buffs_enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.Aura.buffs_initialAnchor == v then
													return k
												end
											end
										end,
									set = function(self, PartyTargetBuffsAnchor)
											db.oUF.PartyTarget.Aura.buffs_initialAnchor = positions[PartyTargetBuffsAnchor]
											oUF_LUI_partyUnitButton1target_buffs:SetPoint(positions[PartyTargetBuffsAnchor], oUF_LUI_partyUnitButton1target.Health, positions[PartyTargetBuffsAnchor], db.oUF.PartyTarget.Aura.buffsX, db.oUF.PartyTarget.Aura.buffsY)
										end,
									order = 10,
								},
							},
						},
						PartyTargetDebuffs = {
							name = "Debuffs",
							type = "group",
							order = 3,
							args = {
								PartyTargetDebuffsEnable = {
									name = "Enable PartyTarget Debuffs",
									desc = "Wether you want to show PartyTarget Debuffs or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.PartyTarget.Aura.debuffs_enable end,
									set = function(self,PartyTargetDebuffsEnable)
												db.oUF.PartyTarget.Aura.debuffs_enable = not db.oUF.PartyTarget.Aura.debuffs_enable 
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 0,
								},
								PartyTargetDebuffsAuratimer = {
									name = "Enable Auratimer",
									desc = "Wether you want to show Auratimers or not.\nDefault: Off",
									type = "toggle",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.debuffs_auratimer end,
									set = function(self,PartyTargetDebuffsAuratimer)
												db.oUF.PartyTarget.Aura.debuffs_auratimer = not db.oUF.PartyTarget.Aura.debuffs_auratimer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								PartyTargetDebuffsPlayerBuffsOnly = {
									name = "Player Debuffs Only",
									desc = "Wether you want to show only your Debuffs on PartyTargetmembers or not.",
									type = "toggle",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.debuffs_playeronly end,
									set = function(self,PartyTargetBuffsPlayerBuffsOnly)
												db.oUF.PartyTarget.Aura.debuffs_playeronly = not db.oUF.PartyTarget.Aura.debuffs_playeronly
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 2,
								},
								PartyTargetDebuffsColorByType = {
									name = "Color by Type",
									desc = "Wether you want to color PartyTarget Debuffs by Type or not.",
									type = "toggle",
									width = "full",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.debuffs_colorbytype end,
									set = function(self,PartyTargetDebuffsColorByType)
												db.oUF.PartyTarget.Aura.debuffs_colorbytype = not db.oUF.PartyTarget.Aura.debuffs_colorbytype
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								PartyTargetDebuffsNum = {
									name = "Amount",
									desc = "Amount of your PartyTarget Debuffs.\nDefault: 8",
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.debuffs_num end,
									set = function(self,PartyTargetDebuffsNum)
												if PartyTargetDebuffsNum == nil or PartyTargetDebuffsNum == "" then
													PartyTargetDebuffsNum = "0"
												end
												db.oUF.PartyTarget.Aura.debuffs_num = PartyTargetDebuffsNum
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
								PartyTargetDebuffsSize = {
									name = "Size",
									desc = "Size for your PartyTarget Debuffs.\nDefault: 18",
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.debuffs_size end,
									set = function(self,PartyTargetDebuffsSize)
												if PartyTargetDebuffsSize == nil or PartyTargetDebuffsSize == "" then
													PartyTargetDebuffsSize = "0"
												end
												db.oUF.PartyTarget.Aura.debuffs_size = PartyTargetDebuffsSize
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 5,
								},
								PartyTargetDebuffsSpacing = {
									name = "Spacing",
									desc = "Spacing between your PartyTarget Debuffs.\nDefault: 2",
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.debuffs_spacing end,
									set = function(self,PartyTargetDebuffsSpacing)
												if PartyTargetDebuffsSpacing == nil or PartyTargetDebuffsSpacing == "" then
													PartyTargetDebuffsSpacing = "0"
												end
												db.oUF.PartyTarget.Aura.debuffs_spacing = PartyTargetDebuffsSpacing
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 6,
								},
								PartyTargetDebuffsX = {
									name = "X Value",
									desc = "X Value for your PartyTarget Debuffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: 5",
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.debuffsX end,
									set = function(self,PartyTargetDebuffsX)
												if PartyTargetDebuffsX == nil or PartyTargetDebuffsX == "" then
													PartyTargetDebuffsX = "0"
												end
												db.oUF.PartyTarget.Aura.debuffsX = PartyTargetDebuffsX
												oUF_LUI_partyUnitButton1target_debuffs:SetPoint(db.oUF.PartyTarget.Aura.debuffs_initialAnchor, oUF_LUI_partyUnitButton1target.Health, db.oUF.PartyTarget.Aura.debuffs_initialAnchor, PartyTargetDebuffsX, db.oUF.PartyTarget.Aura.debuffsY)
											end,
									order = 7,
								},
								PartyTargetDebuffsY = {
									name = "Y Value",
									desc = "Y Value for your PartyTarget Debuffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: -5",
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.PartyTarget.Aura.debuffsY end,
									set = function(self,PartyTargetDebuffsY)
												if PartyTargetDebuffsY == nil or PartyTargetDebuffsY == "" then
													PartyTargetDebuffsY = "0"
												end
												db.oUF.PartyTarget.Aura.debuffsY = PartyTargetDebuffsY
												oUF_LUI_partyUnitButton1target_debuffs:SetPoint(db.oUF.PartyTarget.Aura.debuffs_initialAnchor, oUF_LUI_partyUnitButton1target.Health, db.oUF.PartyTarget.Aura.debuffs_initialAnchor, db.oUF.PartyTarget.Aura.debuffsX, PartyTargetDebuffsY)
											end,
									order = 8,
								},
								PartyTargetDebuffsGrowthY = {
									name = "Growth Y",
									desc = "Choose the growth Y direction for your PartyTarget Debuffs.\nDefault: DOWN",
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									values = growthY,
									get = function()
											for k, v in pairs(growthY) do
												if db.oUF.PartyTarget.Aura.debuffs_growthY == v then
													return k
												end
											end
										end,
									set = function(self, PartyTargetDebuffsGrowthY)
											db.oUF.PartyTarget.Aura.debuffs_growthY = growthY[PartyTargetDebuffsGrowthY]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 9,
								},
								PartyTargetDebuffsGrowthX = {
									name = "Growth X",
									desc = "Choose the growth X direction for your PartyTarget Debuffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									values = growthX,
									get = function()
											for k, v in pairs(growthX) do
												if db.oUF.PartyTarget.Aura.debuffs_growthX == v then
													return k
												end
											end
										end,
									set = function(self, PartyTargetDebuffsGrowthX)
											db.oUF.PartyTarget.Aura.debuffs_growthX = growthX[PartyTargetDebuffsGrowthX]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 10,
								},
								PartyTargetDebuffsAnchor = {
									name = "Initial Anchor",
									desc = "Choose the initinal Anchor for your PartyTarget Debuffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Aura.debuffs_enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.Aura.debuffs_initialAnchor == v then
													return k
												end
											end
										end,
									set = function(self, PartyTargetDebuffsAnchor)
											db.oUF.PartyTarget.Aura.debuffs_initialAnchor = positions[PartyTargetDebuffsAnchor]
											oUF_LUI_partyUnitButton1target_debuffs:SetPoint(positions[PartyTargetDebuffsAnchor], oUF_LUI_partyUnitButton1target.Health, positions[PartyTargetDebuffsAnchor], db.oUF.PartyTarget.Aura.debuffsX, db.oUF.PartyTarget.Aura.debuffsY)
										end,
									order = 11,
								},
							},
						},
					},
				},
				Portrait = {
					name = "Portrait",
					disabled = function() return not db.oUF.PartyTarget.Enable end,
					type = "group",
					order = 8,
					args = {
						EnablePortrait = {
							name = "Enable",
							desc = "Wether you want to show the Portrait or not.",
							type = "toggle",
							width = "full",
							get = function() return db.oUF.PartyTarget.Portrait.Enable end,
							set = function(self,EnablePortrait)
										db.oUF.PartyTarget.Portrait.Enable = not db.oUF.PartyTarget.Portrait.Enable
										StaticPopup_Show("RELOAD_UI")
									end,
							order = 1,
						},
						PortraitWidth = {
							name = "Width",
							desc = "Choose the Width for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.PartyTarget.Portrait.Enable end,
							get = function() return db.oUF.PartyTarget.Portrait.Width end,
							set = function(self,PortraitWidth)
										if PortraitWidth == nil or PortraitWidth == "" then
											PortraitWidth = "0"
										end
										db.oUF.PartyTarget.Portrait.Width = PortraitWidth
										oUF_LUI_partyUnitButton1target.Portrait:SetWidth(tonumber(PortraitWidth))
									end,
							order = 2,
						},
						PortraitHeight = {
							name = "Height",
							desc = "Choose the Height for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.PartyTarget.Portrait.Enable end,
							get = function() return db.oUF.PartyTarget.Portrait.Height end,
							set = function(self,PortraitHeight)
										if PortraitHeight == nil or PortraitHeight == "" then
											PortraitHeight = "0"
										end
										db.oUF.PartyTarget.Portrait.Height = PortraitHeight
										oUF_LUI_partyUnitButton1target.Portrait:SetHeight(tonumber(PortraitHeight))
									end,
							order = 3,
						},
						PortraitX = {
							name = "X Value",
							desc = "X Value for your Portrait.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Portrait.X,
							type = "input",
							disabled = function() return not db.oUF.PartyTarget.Portrait.Enable end,
							get = function() return db.oUF.PartyTarget.Portrait.X end,
							set = function(self,PortraitX)
										if PortraitX == nil or PortraitX == "" then
											PortraitX = "0"
										end
										db.oUF.PartyTarget.Portrait.X = PortraitX
										oUF_LUI_partyUnitButton1target.Portrait:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1target.Health, "TOPLEFT", PortraitX, db.oUF.PartyTarget.Portrait.Y)
									end,
							order = 4,
						},
						PortraitY = {
							name = "Y Value",
							desc = "Y Value for your Portrait.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Portrait.Y,
							type = "input",
							disabled = function() return not db.oUF.PartyTarget.Portrait.Enable end,
							get = function() return db.oUF.PartyTarget.Portrait.Y end,
							set = function(self,PortraitY)
										if PortraitY == nil or PortraitY == "" then
											PortraitY = "0"
										end
										db.oUF.PartyTarget.Portrait.Y = PortraitY
										oUF_LUI_partyUnitButton1target.Portrait:SetPoint("TOPLEFT", oUF_LUI_partyUnitButton1target.Health, "TOPLEFT", db.oUF.PartyTarget.Portrait.X, PortraitY)
									end,
							order = 5,
						},
					},
				},
				Icons = {
					name = "Icons",
					type = "group",
					disabled = function() return not db.oUF.PartyTarget.Enable end,
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
									get = function() return db.oUF.PartyTarget.Icons.Lootmaster.Enable end,
									set = function(self,LootMasterEnable)
												db.oUF.PartyTarget.Icons.Lootmaster.Enable = not db.oUF.PartyTarget.Icons.Lootmaster.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								LootMasterX = {
									name = "X Value",
									desc = "X Value for your LootMaster Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Lootmaster.X,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Lootmaster.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Lootmaster.X end,
									set = function(self,LootMasterX)
												if LootMasterX == nil or LootMasterX == "" then
													LootMasterX = "0"
												end
												db.oUF.PartyTarget.Icons.Lootmaster.X = LootMasterX
												oUF_LUI_partyUnitButton1target.MasterLooter:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.MasterLooter:SetPoint(db.oUF.PartyTarget.Icons.Lootmaster.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Lootmaster.Point, tonumber(LootMasterX), tonumber(db.oUF.PartyTarget.Icons.Lootmaster.Y))
											end,
									order = 2,
								},
								LootMasterY = {
									name = "Y Value",
									desc = "Y Value for your LootMaster Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Lootmaster.Y,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Lootmaster.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Lootmaster.Y end,
									set = function(self,LootMasterY)
												if LootMasterY == nil or LootMasterY == "" then
													LootMasterY = "0"
												end
												db.oUF.PartyTarget.Icons.Lootmaster.Y = LootMasterY
												oUF_LUI_partyUnitButton1target.MasterLooter:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.MasterLooter:SetPoint(db.oUF.PartyTarget.Icons.Lootmaster.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Lootmaster.Point, tonumber(db.oUF.PartyTarget.Icons.Lootmaster.X), tonumber(LootMasterY))
											end,
									order = 3,
								},
								LootMasterPoint = {
									name = "Position",
									desc = "Choose the Position for your LootMaster Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Lootmaster.Point,
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Icons.Lootmaster.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.Icons.Lootmaster.Point == v then
													return k
												end
											end
										end,
									set = function(self, LootMasterPoint)
											db.oUF.PartyTarget.Icons.Lootmaster.Point = positions[LootMasterPoint]
											oUF_LUI_partyUnitButton1target.MasterLooter:ClearAllPoints()
											oUF_LUI_partyUnitButton1target.MasterLooter:SetPoint(db.oUF.PartyTarget.Icons.Lootmaster.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Lootmaster.Point, tonumber(db.oUF.PartyTarget.Icons.Lootmaster.X), tonumber(db.oUF.PartyTarget.Icons.Lootmaster.Y))
										end,
									order = 4,
								},
								LootMasterSize = {
									name = "Size",
									desc = "Choose a size for your LootMaster Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Lootmaster.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.PartyTarget.Icons.Lootmaster.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Lootmaster.Size end,
									set = function(_, LootMasterSize) 
											db.oUF.PartyTarget.Icons.Lootmaster.Size = LootMasterSize
											oUF_LUI_partyUnitButton1target.MasterLooter:SetHeight(LootMasterSize)
											oUF_LUI_partyUnitButton1target.MasterLooter:SetWidth(LootMasterSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.PartyTarget.Icons.Lootmaster.Enable end,
									desc = "Toggles the LootMaster Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1target.MasterLooter:IsShown() then oUF_LUI_partyUnitButton1target.MasterLooter:Hide() else oUF_LUI_partyUnitButton1target.MasterLooter:Show() end end
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
									get = function() return db.oUF.PartyTarget.Icons.Leader.Enable end,
									set = function(self,LeaderEnable)
												db.oUF.PartyTarget.Icons.Leader.Enable = not db.oUF.PartyTarget.Icons.Leader.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								LeaderX = {
									name = "X Value",
									desc = "X Value for your Leader Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Leader.X,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Leader.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Leader.X end,
									set = function(self,LeaderX)
												if LeaderX == nil or LeaderX == "" then
													LeaderX = "0"
												end
												db.oUF.PartyTarget.Icons.Leader.X = LeaderX
												oUF_LUI_partyUnitButton1target.Leader:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.Leader:SetPoint(db.oUF.PartyTarget.Icons.Leader.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Leader.Point, tonumber(LeaderX), tonumber(db.oUF.PartyTarget.Icons.Leader.Y))
											end,
									order = 2,
								},
								LeaderY = {
									name = "Y Value",
									desc = "Y Value for your Leader Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Leader.Y,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Leader.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Leader.Y end,
									set = function(self,LeaderY)
												if LeaderY == nil or LeaderY == "" then
													LeaderY = "0"
												end
												db.oUF.PartyTarget.Icons.Leader.Y = LeaderY
												oUF_LUI_partyUnitButton1target.Leader:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.Leader:SetPoint(db.oUF.PartyTarget.Icons.Leader.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Leader.Point, tonumber(db.oUF.PartyTarget.Icons.Leader.X), tonumber(LeaderY))
											end,
									order = 3,
								},
								LeaderPoint = {
									name = "Position",
									desc = "Choose the Position for your Leader Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Leader.Point,
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Icons.Leader.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.Icons.Leader.Point == v then
													return k
												end
											end
										end,
									set = function(self, LeaderPoint)
											db.oUF.PartyTarget.Icons.Leader.Point = positions[LeaderPoint]
											oUF_LUI_partyUnitButton1target.Leader:ClearAllPoints()
											oUF_LUI_partyUnitButton1target.Leader:SetPoint(db.oUF.PartyTarget.Icons.Leader.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Leader.Point, tonumber(db.oUF.PartyTarget.Icons.Leader.X), tonumber(db.oUF.PartyTarget.Icons.Leader.Y))
										end,
									order = 4,
								},
								LeaderSize = {
									name = "Size",
									desc = "Choose your Size for your Leader Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Leader.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.PartyTarget.Icons.Leader.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Leader.Size end,
									set = function(_, LeaderSize) 
											db.oUF.PartyTarget.Icons.Leader.Size = LeaderSize
											oUF_LUI_partyUnitButton1target.Leader:SetHeight(LeaderSize)
											oUF_LUI_partyUnitButton1target.Leader:SetWidth(LeaderSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.PartyTarget.Icons.Leader.Enable end,
									desc = "Toggles the Leader Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1target.Leader:IsShown() then oUF_LUI_partyUnitButton1target.Leader:Hide() else oUF_LUI_partyUnitButton1target.Leader:Show() end end
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
									get = function() return db.oUF.PartyTarget.Icons.Role.Enable end,
									set = function(self,RoleEnable)
												db.oUF.PartyTarget.Icons.Role.Enable = not db.oUF.PartyTarget.Icons.Role.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								RoleX = {
									name = "X Value",
									desc = "X Value for your Group Role Icon Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Role.X,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Role.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Role.X end,
									set = function(self,RoleX)
												if RoleX == nil or RoleX == "" then
													RoleX = "0"
												end
												db.oUF.PartyTarget.Icons.Role.X = RoleX
												oUF_LUI_partyUnitButton1target.LFDRole:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.LFDRole:SetPoint(db.oUF.PartyTarget.Icons.Role.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Role.Point, tonumber(RoleX), tonumber(db.oUF.PartyTarget.Icons.Role.Y))
											end,
									order = 2,
								},
								RoleY = {
									name = "Y Value",
									desc = "Y Value for your Role Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Role.Y,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Role.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Role.Y end,
									set = function(self,RoleY)
												if RoleY == nil or RoleY == "" then
													RoleY = "0"
												end
												db.oUF.PartyTarget.Icons.Role.Y = RoleY
												oUF_LUI_partyUnitButton1target.LFDRole:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.LFDRole:SetPoint(db.oUF.PartyTarget.Icons.Role.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Role.Point, tonumber(db.oUF.PartyTarget.Icons.Role.X), tonumber(RoleY))
											end,
									order = 3,
								},
								RolePoint = {
									name = "Position",
									desc = "Choose the Position for your Role Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Role.Point,
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Icons.Role.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.Icons.Role.Point == v then
													return k
												end
											end
										end,
									set = function(self, RolePoint)
											db.oUF.PartyTarget.Icons.Role.Point = positions[RolePoint]
											oUF_LUI_partyUnitButton1target.LFDRole:ClearAllPoints()
											oUF_LUI_partyUnitButton1target.LFDRole:SetPoint(db.oUF.PartyTarget.Icons.Role.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Role.Point, tonumber(db.oUF.PartyTarget.Icons.Role.X), tonumber(db.oUF.PartyTarget.Icons.Role.Y))
										end,
									order = 4,
								},
								RoleSize = {
									name = "Size",
									desc = "Choose a Size for your Group Role Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Role.Size,
									type = "range",
									min = 5,
									max = 100,
									step = 1,
									disabled = function() return not db.oUF.PartyTarget.Icons.Role.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Role.Size end,
									set = function(_, RoleSize) 
											db.oUF.PartyTarget.Icons.Role.Size = RoleSize
											oUF_LUI_partyUnitButton1target.LFDRole:SetHeight(RoleSize)
											oUF_LUI_partyUnitButton1target.LFDRole:SetWidth(RoleSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.PartyTarget.Icons.Role.Enable end,
									desc = "Toggles the LFDRole Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1target.LFDRole:IsShown() then oUF_LUI_partyUnitButton1target.LFDRole:Hide() else oUF_LUI_partyUnitButton1target.LFDRole:Show() end end
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
									get = function() return db.oUF.PartyTarget.Icons.Raid.Enable end,
									set = function(self,RaidEnable)
												db.oUF.PartyTarget.Icons.Raid.Enable = not db.oUF.PartyTarget.Icons.Raid.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								RaidX = {
									name = "X Value",
									desc = "X Value for your Raid Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Raid.X,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Raid.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Raid.X end,
									set = function(self,RaidX)
												if RaidX == nil or RaidX == "" then
													RaidX = "0"
												end

												db.oUF.PartyTarget.Icons.Raid.X = RaidX
												oUF_LUI_partyUnitButton1target.RaidIcon:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.RaidIcon:SetPoint(db.oUF.PartyTarget.Icons.Raid.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Raid.Point, tonumber(RaidX), tonumber(db.oUF.PartyTarget.Icons.Raid.Y))
											end,
									order = 2,
								},
								RaidY = {
									name = "Y Value",
									desc = "Y Value for your Raid Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Raid.Y,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Raid.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Raid.Y end,
									set = function(self,RaidY)
												if RaidY == nil or RaidY == "" then
													RaidY = "0"
												end
												db.oUF.PartyTarget.Icons.Raid.Y = RaidY
												oUF_LUI_partyUnitButton1target.RaidIcon:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.RaidIcon:SetPoint(db.oUF.PartyTarget.Icons.Raid.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Raid.Point, tonumber(db.oUF.PartyTarget.Icons.Raid.X), tonumber(RaidY))
											end,
									order = 3,
								},
								RaidPoint = {
									name = "Position",
									desc = "Choose the Position for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Raid.Point,
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Icons.Raid.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.Icons.Raid.Point == v then
													return k
												end
											end
										end,
									set = function(self, RaidPoint)
											db.oUF.PartyTarget.Icons.Raid.Point = positions[RaidPoint]
											oUF_LUI_partyUnitButton1target.RaidIcon:ClearAllPoints()
											oUF_LUI_partyUnitButton1target.RaidIcon:SetPoint(db.oUF.PartyTarget.Icons.Raid.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Raid.Point, tonumber(db.oUF.PartyTarget.Icons.Raid.X), tonumber(db.oUF.PartyTarget.Icons.Raid.Y))
										end,
									order = 4,
								},
								RaidSize = {
									name = "Size",
									desc = "Choose a Size for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Raid.Size,
									type = "range",
									min = 5,
									max = 200,
									step = 5,
									disabled = function() return not db.oUF.PartyTarget.Icons.Raid.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Raid.Size end,
									set = function(_, RaidSize) 
											db.oUF.PartyTarget.Icons.Raid.Size = RaidSize
											oUF_LUI_partyUnitButton1target.RaidIcon:SetHeight(RaidSize)
											oUF_LUI_partyUnitButton1target.RaidIcon:SetWidth(RaidSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.PartyTarget.Icons.Raid.Enable end,
									desc = "Toggles the RaidIcon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1target.RaidIcon:IsShown() then oUF_LUI_partyUnitButton1target.RaidIcon:Hide() else oUF_LUI_partyUnitButton1target.RaidIcon:Show() end end
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
									get = function() return db.oUF.PartyTarget.Icons.Resting.Enable end,
									set = function(self,RestingEnable)
												db.oUF.PartyTarget.Icons.Resting.Enable = not db.oUF.PartyTarget.Icons.Resting.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								RestingX = {
									name = "X Value",
									desc = "X Value for your Resting Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Resting.X,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Resting.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Resting.X end,
									set = function(self,RestingX)
												if RestingX == nil or RestingX == "" then
													RestingX = "0"
												end
												db.oUF.PartyTarget.Icons.Resting.X = RestingX
												oUF_LUI_partyUnitButton1target.Resting:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.Resting:SetPoint(db.oUF.PartyTarget.Icons.Resting.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Resting.Point, tonumber(RestingX), tonumber(db.oUF.PartyTarget.Icons.Resting.Y))
											end,
									order = 2,
								},
								RestingY = {
									name = "Y Value",
									desc = "Y Value for your Resting Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Resting.Y,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Resting.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Resting.Y end,
									set = function(self,RestingY)
												if RestingY == nil or RestingY == "" then
													RestingY = "0"
												end
												db.oUF.PartyTarget.Icons.Resting.Y = RestingY
												oUF_LUI_partyUnitButton1target.Resting:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.Resting:SetPoint(db.oUF.PartyTarget.Icons.Resting.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Resting.Point, tonumber(db.oUF.PartyTarget.Icons.Resting.X), tonumber(RestingY))
											end,
									order = 3,
								},
								RestingPoint = {
									name = "Position",
									desc = "Choose the Position for your Resting Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Resting.Point,
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Icons.Resting.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.Icons.Resting.Point == v then
													return k
												end
											end
										end,
									set = function(self, RestingPoint)
											db.oUF.PartyTarget.Icons.Resting.Point = positions[RestingPoint]
											oUF_LUI_partyUnitButton1target.Resting:ClearAllPoints()
											oUF_LUI_partyUnitButton1target.Resting:SetPoint(db.oUF.PartyTarget.Icons.Resting.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Resting.Point, tonumber(db.oUF.PartyTarget.Icons.Resting.X), tonumber(db.oUF.PartyTarget.Icons.Resting.Y))
										end,
									order = 4,
								},
								RestingSize = {
									name = "Size",
									desc = "Choose a Size for your Resting Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Resting.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.PartyTarget.Icons.Resting.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Resting.Size end,
									set = function(_, RestingSize) 
											db.oUF.PartyTarget.Icons.Resting.Size = RestingSize
											oUF_LUI_partyUnitButton1target.Resting:SetHeight(RestingSize)
											oUF_LUI_partyUnitButton1target.Resting:SetWidth(RestingSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.PartyTarget.Icons.Resting.Enable end,
									desc = "Toggles the Resting Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1target.Resting:IsShown() then oUF_LUI_partyUnitButton1target.Resting:Hide() else oUF_LUI_partyUnitButton1target.Resting:Show() end end
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
									get = function() return db.oUF.PartyTarget.Icons.Combat.Enable end,
									set = function(self,CombatEnable)
												db.oUF.PartyTarget.Icons.Combat.Enable = not db.oUF.PartyTarget.Icons.Combat.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								CombatX = {
									name = "X Value",
									desc = "X Value for your Combat Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Combat.X,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Combat.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Combat.X end,
									set = function(self,CombatX)
												if CombatX == nil or CombatX == "" then
													CombatX = "0"
												end
												db.oUF.PartyTarget.Icons.Combat.X = CombatX
												oUF_LUI_partyUnitButton1target.Combat:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.Combat:SetPoint(db.oUF.PartyTarget.Icons.Combat.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Combat.Point, tonumber(CombatX), tonumber(db.oUF.PartyTarget.Icons.Combat.Y))
											end,
									order = 2,
								},
								CombatY = {
									name = "Y Value",
									desc = "Y Value for your Combat Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Combat.Y,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.Combat.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Combat.Y end,
									set = function(self,CombatY)
												if CombatY == nil or CombatY == "" then
													CombatY = "0"
												end
												db.oUF.PartyTarget.Icons.Combat.Y = CombatY
												oUF_LUI_partyUnitButton1target.Combat:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.Combat:SetPoint(db.oUF.PartyTarget.Icons.Combat.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Combat.Point, tonumber(db.oUF.PartyTarget.Icons.Combat.X), tonumber(CombatY))
											end,
									order = 3,
								},
								CombatPoint = {
									name = "Position",
									desc = "Choose the Position for your Combat Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Combat.Point,
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Icons.Combat.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.Icons.Combat.Point == v then
													return k
												end
											end
										end,
									set = function(self, CombatPoint)

											db.oUF.PartyTarget.Icons.Combat.Point = positions[CombatPoint]
											oUF_LUI_partyUnitButton1target.Combat:ClearAllPoints()
											oUF_LUI_partyUnitButton1target.Combat:SetPoint(db.oUF.PartyTarget.Icons.Combat.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.Combat.Point, tonumber(db.oUF.PartyTarget.Icons.Combat.X), tonumber(db.oUF.PartyTarget.Icons.Combat.Y))
										end,
									order = 4,
								},
								CombatSize = {
									name = "Size",
									desc = "Choose a Size for your Combat Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.Combat.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.PartyTarget.Icons.Combat.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.Combat.Size end,
									set = function(_, CombatSize) 
											db.oUF.PartyTarget.Icons.Combat.Size = CombatSize
											oUF_LUI_partyUnitButton1target.Combat:SetHeight(CombatSize)
											oUF_LUI_partyUnitButton1target.Combat:SetWidth(CombatSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									disabled = function() return not db.oUF.PartyTarget.Icons.Combat.Enable end,
									name = "Show/Hide",
									desc = "Toggles the Combat Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1target.Combat:IsShown() then oUF_LUI_partyUnitButton1target.Combat:Hide() else oUF_LUI_partyUnitButton1target.Combat:Show() end end
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
									get = function() return db.oUF.PartyTarget.Icons.PvP.Enable end,
									set = function(self,PvPEnable)
												db.oUF.PartyTarget.Icons.PvP.Enable = not db.oUF.PartyTarget.Icons.PvP.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								PvPX = {
									name = "X Value",
									desc = "X Value for your PvP Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.PvP.X,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.PvP.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.PvP.X end,
									set = function(self,PvPX)
												if PvPX == nil or PvPX == "" then
													PvPX = "0"
												end
												db.oUF.PartyTarget.Icons.PvP.X = PvPX
												oUF_LUI_partyUnitButton1target.PvP:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.PvP:SetPoint(db.oUF.PartyTarget.Icons.PvP.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.PvP.Point, tonumber(PvPX), tonumber(db.oUF.PartyTarget.Icons.PvP.Y))
											end,
									order = 2,
								},
								PvPY = {
									name = "Y Value",
									desc = "Y Value for your PvP Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.PvP.Y,
									type = "input",
									disabled = function() return not db.oUF.PartyTarget.Icons.PvP.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.PvP.Y end,
									set = function(self,PvPY)
												if PvPY == nil or PvPY == "" then
													PvPY = "0"
												end
												db.oUF.PartyTarget.Icons.PvP.Y = PvPY
												oUF_LUI_partyUnitButton1target.PvP:ClearAllPoints()
												oUF_LUI_partyUnitButton1target.PvP:SetPoint(db.oUF.PartyTarget.Icons.PvP.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.PvP.Point, tonumber(db.oUF.PartyTarget.Icons.PvP.X), tonumber(PvPY))
											end,
									order = 3,
								},
								PvPPoint = {
									name = "Position",
									desc = "Choose the Position for your PvP Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.PvP.Point,
									type = "select",
									disabled = function() return not db.oUF.PartyTarget.Icons.PvP.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.PartyTarget.Icons.PvP.Point == v then
													return k
												end
											end
										end,
									set = function(self, PvPPoint)
											db.oUF.PartyTarget.Icons.PvP.Point = positions[PvPPoint]
											oUF_LUI_partyUnitButton1target.PvP:ClearAllPoints()
											oUF_LUI_partyUnitButton1target.PvP:SetPoint(db.oUF.PartyTarget.Icons.PvP.Point, oUF_LUI_partyUnitButton1target, db.oUF.PartyTarget.Icons.PvP.Point, tonumber(db.oUF.PartyTarget.Icons.PvP.X), tonumber(db.oUF.PartyTarget.Icons.PvP.Y))
										end,
									order = 4,
								},
								PvPSize = {
									name = "Size",
									desc = "Choose a Size for your PvP Icon.\nDefault: "..LUI.defaults.profile.oUF.PartyTarget.Icons.PvP.Size,
									type = "range",
									min = 5,
									max = 40,
									step = 1,
									disabled = function() return not db.oUF.PartyTarget.Icons.PvP.Enable end,
									get = function() return db.oUF.PartyTarget.Icons.PvP.Size end,
									set = function(_, PvPSize) 
											db.oUF.PartyTarget.Icons.PvP.Size = PvPSize
											oUF_LUI_partyUnitButton1target.PvP:SetHeight(PvPSize)
											oUF_LUI_partyUnitButton1target.PvP:SetWidth(PvPSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.PartyTarget.Icons.PvP.Enable end,
									desc = "Toggles the PvP Icon",
									type = 'execute',
									func = function() if oUF_LUI_partyUnitButton1target.PvP:IsShown() then oUF_LUI_partyUnitButton1target.PvP:Hide() else oUF_LUI_partyUnitButton1target.PvP:Show() end end
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