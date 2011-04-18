--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: maintanktarget.lua
	Description: oUF Maintank Target Module
	Version....: 1.0
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local module = LUI:NewModule("oUF_MaintankTarget")
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
	MaintankTarget = {
		Enable = true,
		Height = "24",
		Width = "130",
		X = "-8",
		Y = "0",
		Point = "TOPRIGHT",
		RelativePoint = "TOPLEFT",
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
			buffs_playeronly = false,
			buffs_auratimer = false,
			buffs_enable = false,
			buffsX = "0",
			buffsY = "30",
			buffs_initialAnchor = "BOTTOMLEFT",
			buffs_growthY = "UP",
			buffs_growthX = "RIGHT",
			buffs_size = "18",
			buffs_spacing = "2",
			buffs_num = "8",
			debuffs_colorbytype = false,
			debuffs_auratimer = false,
			debuffs_enable = false,
			debuffsX = "35",
			debuffsY = "-5",
			debuffs_initialAnchor = "LEFT",
			debuffs_growthY = "UP",
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
				Size = 24,
				X = "0",
				Y = "0",
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
		MaintankTarget = {
			name = "Maintank Target",
			type = "group",
			disabled = function() return not db.oUF.Settings.Enable or not db.oUF.Maintank.Enable end,
			order = 38,
			childGroups = "tab",
			args = {
				header1 = {
					name = "Maintank Target",
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
									desc = "Wether you want to use a Maintank Target Frame or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankTarget.Enable end,
									set = function(self,Enable)
												db.oUF.MaintankTarget.Enable = not db.oUF.MaintankTarget.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
							},
						},
						Positioning = {
							name = "Positioning",
							type = "group",
							disabled = function() return not db.oUF.MaintankTarget.Enable end,
							order = 1,
							args = {
								header1 = {
									name = "Frame Position",
									type = "header",
									order = 1,
								},
								MaintankTargetX = {
									name = "X Value",
									desc = "X Value for your Maintank Target Frame.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.X,
									type = "input",
									get = function() return db.oUF.MaintankTarget.X end,
									set = function(self,MaintankTargetX)
												if MaintankTargetX == nil or MaintankTargetX == "" then
													MaintankTargetX = "0"
												end
												db.oUF.MaintankTarget.X = MaintankTargetX
												oUF_LUI_maintankUnitButton1target:ClearAllPoints()
												oUF_LUI_maintankUnitButton1target:SetPoint(db.oUF.MaintankTarget.Point, oUF_LUI_maintankUnitButton1, db.oUF.MaintankTarget.RelativePoint, tonumber(MaintankTargetX), tonumber(db.oUF.MaintankTarget.Y))
											end,
									order = 2,
								},
								MaintankTargetY = {
									name = "Y Value",
									desc = "Y Value for your Maintank Target Frame.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Y,
									type = "input",
									get = function() return db.oUF.MaintankTarget.Y end,
									set = function(self,MaintankTargetY)
												if MaintankTargetY == nil or MaintankTargetY == "" then
													MaintankTargetY = "0"
												end
												db.oUF.MaintankTarget.Y = MaintankTargetY
												oUF_LUI_maintankUnitButton1target:ClearAllPoints()
												oUF_LUI_maintankUnitButton1target:SetPoint(db.oUF.MaintankTarget.Point, oUF_LUI_maintankUnitButton1, db.oUF.MaintankTarget.RelativePoint, tonumber(db.oUF.MaintankTarget.X), tonumber(MaintankTargetY))
											end,
									order = 3,
								},
								MaintankTargetPoint = {
									name = "Point",
									desc = "Choose the Point for your Maintank Target Frame.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Point,
									type = "select",
											values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.MaintankTarget.Point == v then
													return k
												end
											end
										end,
									set = function(self, MaintankTargetPoint)
											db.oUF.MaintankTarget.Point = positions[MaintankTargetPoint]
											oUF_LUI_maintankUnitButton1target:ClearAllPoints()
											oUF_LUI_maintankUnitButton1target:SetPoint(MaintankTargetPoint, oUF_LUI_maintankUnitButton1, db.oUF.MaintankTarget.RelativePoint, tonumber(db.oUF.MaintankTarget.X), tonumber(db.oUF.MaintankTarget.Y))
										end,
									order = 4,
								},
								MaintankTargetRelativePoint = {
									name = "RelativePoint",
									desc = "Choose the RelativePoint for your Maintank Target Frame.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.RelativePoint,
									type = "select",
											values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.MaintankTarget.RelativePoint == v then
													return k
												end
											end
										end,
									set = function(self, MaintankTargetRelativePoint)
											db.oUF.MaintankTarget.RelativePoint = positions[MaintankTargetRelativePoint]
											oUF_LUI_maintankUnitButton1target:ClearAllPoints()
											oUF_LUI_maintankUnitButton1target:SetPoint(db.oUF.MaintankTarget.Point, oUF_LUI_maintankUnitButton1, MaintankTargetRelativePoint, tonumber(db.oUF.MaintankTarget.X), tonumber(db.oUF.MaintankTarget.Y))
										end,
									order = 5,
								},
							},
						},
						Size = {
							name = "Size",
							type = "group",
							disabled = function() return not db.oUF.MaintankTarget.Enable end,
							order = 2,
							args = {
								header1 = {
									name = "Frame Height/Width",
									type = "header",
									order = 1,
								},
								MaintankTargetHeight = {
									name = "Height",
									desc = "Decide the Height of your Maintank Target Frame.\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Height,
									type = "input",
									get = function() return db.oUF.MaintankTarget.Height end,
									set = function(self,MaintankTargetHeight)
												if MaintankTargetHeight == nil or MaintankTargetHeight == "" then
													MaintankTargetHeight = "0"
												end
												db.oUF.MaintankTarget.Height = MaintankTargetHeight
												oUF_LUI_maintankUnitButton1target:SetHeight(tonumber(MaintankTargetHeight))
											end,
									order = 2,
								},
								MaintankTargetWidth = {
									name = "Width",
									desc = "Decide the Width of your Maintank Target Frame.\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Width,
									type = "input",
									get = function() return db.oUF.MaintankTarget.Width end,
									set = function(self,MaintankTargetWidth)
												if MaintankTargetWidth == nil or MaintankTargetWidth == "" then
													MaintankTargetWidth = "0"
												end
												db.oUF.MaintankTarget.Width = MaintankTargetWidth
												oUF_LUI_maintankUnitButton1target:SetWidth(tonumber(MaintankTargetWidth))
												
												if db.oUF.MaintankTarget.Aura.buffs_enable == true then
													oUF_LUI_maintankUnitButton1target.Buffs:SetWidth(tonumber(MaintankTargetWidth))
												end
												
												if db.oUF.MaintankTarget.Aura.debuffs_enable == true then
													oUF_LUI_maintankUnitButton1target.Debuffs:SetWidth(tonumber(MaintankTargetWidth))
												end
											end,
									order = 3,
								},
							},
						},
						Appearance = {
							name = "Appearance",
							type = "group",
							disabled = function() return not db.oUF.MaintankTarget.Enable end,
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
									get = function() return db.oUF.MaintankTarget.Backdrop.Color.r, db.oUF.MaintankTarget.Backdrop.Color.g, db.oUF.MaintankTarget.Backdrop.Color.b, db.oUF.MaintankTarget.Backdrop.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.MaintankTarget.Backdrop.Color.r = r
											db.oUF.MaintankTarget.Backdrop.Color.g = g
											db.oUF.MaintankTarget.Backdrop.Color.b = b
											db.oUF.MaintankTarget.Backdrop.Color.a = a

											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropColor(r,g,b,a)
										end,
									order = 2,
								},
								BackdropBorderColor = {
									name = "Border Color",
									desc = "Choose a Backdrop Border Color.",
									type = "color",
									width = "full",
									hasAlpha = true,
									get = function() return db.oUF.MaintankTarget.Border.Color.r, db.oUF.MaintankTarget.Border.Color.g, db.oUF.MaintankTarget.Border.Color.b, db.oUF.MaintankTarget.Border.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.MaintankTarget.Border.Color.r = r
											db.oUF.MaintankTarget.Border.Color.g = g
											db.oUF.MaintankTarget.Border.Color.b = b
											db.oUF.MaintankTarget.Border.Color.a = a
											
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankTarget.Border.Insets.Left), right = tonumber(db.oUF.MaintankTarget.Border.Insets.Right), top = tonumber(db.oUF.MaintankTarget.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankTarget.Backdrop.Color.r), tonumber(db.oUF.MaintankTarget.Backdrop.Color.g), tonumber(db.oUF.MaintankTarget.Backdrop.Color.b), tonumber(db.oUF.MaintankTarget.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankTarget.Border.Color.r), tonumber(db.oUF.MaintankTarget.Border.Color.g), tonumber(db.oUF.MaintankTarget.Border.Color.b), tonumber(db.oUF.MaintankTarget.Border.Color.a))
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
									desc = "Choose your Backdrop Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Backdrop.Texture,
									type = "select",
									dialogControl = "LSM30_Background",
									values = widgetLists.background,
									get = function() return db.oUF.MaintankTarget.Backdrop.Texture end,
									set = function(self, BackdropTexture)
											db.oUF.MaintankTarget.Backdrop.Texture = BackdropTexture
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankTarget.Border.Insets.Left), right = tonumber(db.oUF.MaintankTarget.Border.Insets.Right), top = tonumber(db.oUF.MaintankTarget.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankTarget.Backdrop.Color.r), tonumber(db.oUF.MaintankTarget.Backdrop.Color.g), tonumber(db.oUF.MaintankTarget.Backdrop.Color.b), tonumber(db.oUF.MaintankTarget.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankTarget.Border.Color.r), tonumber(db.oUF.MaintankTarget.Border.Color.g), tonumber(db.oUF.MaintankTarget.Border.Color.b), tonumber(db.oUF.MaintankTarget.Border.Color.a))
										end,
									order = 5,
								},
								BorderTexture = {
									name = "Border Texture",
									desc = "Choose your Border Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Border.EdgeFile,
									type = "select",
									dialogControl = "LSM30_Border",
									values = widgetLists.border,
									get = function() return db.oUF.MaintankTarget.Border.EdgeFile end,
									set = function(self, BorderTexture)
											db.oUF.MaintankTarget.Border.EdgeFile = BorderTexture
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankTarget.Border.Insets.Left), right = tonumber(db.oUF.MaintankTarget.Border.Insets.Right), top = tonumber(db.oUF.MaintankTarget.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankTarget.Backdrop.Color.r), tonumber(db.oUF.MaintankTarget.Backdrop.Color.g), tonumber(db.oUF.MaintankTarget.Backdrop.Color.b), tonumber(db.oUF.MaintankTarget.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankTarget.Border.Color.r), tonumber(db.oUF.MaintankTarget.Border.Color.g), tonumber(db.oUF.MaintankTarget.Border.Color.b), tonumber(db.oUF.MaintankTarget.Border.Color.a))
										end,
									order = 6,
								},
								BorderSize = {
									name = "Edge Size",
									desc = "Choose the Edge Size for your Frame Border.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Border.EdgeSize,
									type = "range",
									min = 1,
									max = 50,
									step = 1,
									get = function() return db.oUF.MaintankTarget.Border.EdgeSize end,
									set = function(_, BorderSize) 
											db.oUF.MaintankTarget.Border.EdgeSize = BorderSize
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankTarget.Border.Insets.Left), right = tonumber(db.oUF.MaintankTarget.Border.Insets.Right), top = tonumber(db.oUF.MaintankTarget.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankTarget.Backdrop.Color.r), tonumber(db.oUF.MaintankTarget.Backdrop.Color.g), tonumber(db.oUF.MaintankTarget.Backdrop.Color.b), tonumber(db.oUF.MaintankTarget.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankTarget.Border.Color.r), tonumber(db.oUF.MaintankTarget.Border.Color.g), tonumber(db.oUF.MaintankTarget.Border.Color.b), tonumber(db.oUF.MaintankTarget.Border.Color.a))
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
									desc = "Value for the Left Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Backdrop.Padding.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankTarget.Backdrop.Padding.Left end,
									set = function(self,PaddingLeft)
										if PaddingLeft == nil or PaddingLeft == "" then
											PaddingLeft = "0"
										end
										db.oUF.MaintankTarget.Backdrop.Padding.Left = PaddingLeft
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:ClearAllPoints()
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1target, "TOPLEFT", tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Left), tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Top))
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_maintankUnitButton1target, "BOTTOMRIGHT", tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Right), tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Bottom))
									end,
									order = 9,
								},
								PaddingRight = {
									name = "Right",
									desc = "Value for the Right Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Backdrop.Padding.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankTarget.Backdrop.Padding.Right end,
									set = function(self,PaddingRight)
										if PaddingRight == nil or PaddingRight == "" then
											PaddingRight = "0"
										end
										db.oUF.MaintankTarget.Backdrop.Padding.Right = PaddingRight
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:ClearAllPoints()
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1target, "TOPLEFT", tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Left), tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Top))
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_maintankUnitButton1target, "BOTTOMRIGHT", tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Right), tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Bottom))
									end,
									order = 10,
								},
								PaddingTop = {
									name = "Top",
									desc = "Value for the Top Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Backdrop.Padding.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankTarget.Backdrop.Padding.Top end,
									set = function(self,PaddingTop)
										if PaddingTop == nil or PaddingTop == "" then
											PaddingTop = "0"
										end
										db.oUF.MaintankTarget.Backdrop.Padding.Top = PaddingTop
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:ClearAllPoints()
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1target, "TOPLEFT", tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Left), tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Top))
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_maintankUnitButton1target, "BOTTOMRIGHT", tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Right), tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Bottom))
									end,
									order = 11,
								},
								PaddingBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Backdrop.Padding.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankTarget.Backdrop.Padding.Bottom end,
									set = function(self,PaddingBottom)
										if PaddingBottom == nil or PaddingBottom == "" then
											PaddingBottom = "0"
										end
										db.oUF.MaintankTarget.Backdrop.Padding.Bottom = PaddingBottom
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:ClearAllPoints()
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1target, "TOPLEFT", tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Left), tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Top))
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_maintankUnitButton1target, "BOTTOMRIGHT", tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Right), tonumber(db.oUF.MaintankTarget.Backdrop.Padding.Bottom))
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
									desc = "Value for the Left Border Inset\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Border.Insets.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankTarget.Border.Insets.Left end,
									set = function(self,InsetLeft)
										if InsetLeft == nil or InsetLeft == "" then
											InsetLeft = "0"
										end
										db.oUF.MaintankTarget.Border.Insets.Left = InsetLeft
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankTarget.Border.Insets.Left), right = tonumber(db.oUF.MaintankTarget.Border.Insets.Right), top = tonumber(db.oUF.MaintankTarget.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankTarget.Backdrop.Color.r), tonumber(db.oUF.MaintankTarget.Backdrop.Color.g), tonumber(db.oUF.MaintankTarget.Backdrop.Color.b), tonumber(db.oUF.MaintankTarget.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankTarget.Border.Color.r), tonumber(db.oUF.MaintankTarget.Border.Color.g), tonumber(db.oUF.MaintankTarget.Border.Color.b), tonumber(db.oUF.MaintankTarget.Border.Color.a))
											end,
									order = 14,
								},
								InsetRight = {
									name = "Right",
									desc = "Value for the Right Border Inset\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Border.Insets.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankTarget.Border.Insets.Right end,
									set = function(self,InsetRight)
										if InsetRight == nil or InsetRight == "" then
											InsetRight = "0"
										end
										db.oUF.MaintankTarget.Border.Insets.Right = InsetRight
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankTarget.Border.Insets.Left), right = tonumber(db.oUF.MaintankTarget.Border.Insets.Right), top = tonumber(db.oUF.MaintankTarget.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankTarget.Backdrop.Color.r), tonumber(db.oUF.MaintankTarget.Backdrop.Color.g), tonumber(db.oUF.MaintankTarget.Backdrop.Color.b), tonumber(db.oUF.MaintankTarget.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankTarget.Border.Color.r), tonumber(db.oUF.MaintankTarget.Border.Color.g), tonumber(db.oUF.MaintankTarget.Border.Color.b), tonumber(db.oUF.MaintankTarget.Border.Color.a))
											end,
									order = 15,
								},
								InsetTop = {
									name = "Top",
									desc = "Value for the Top Border Inset\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Border.Insets.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankTarget.Border.Insets.Top end,
									set = function(self,InsetTop)
										if InsetTop == nil or InsetTop == "" then
											InsetTop = "0"
										end
										db.oUF.MaintankTarget.Border.Insets.Top = InsetTop
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankTarget.Border.Insets.Left), right = tonumber(db.oUF.MaintankTarget.Border.Insets.Right), top = tonumber(db.oUF.MaintankTarget.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankTarget.Backdrop.Color.r), tonumber(db.oUF.MaintankTarget.Backdrop.Color.g), tonumber(db.oUF.MaintankTarget.Backdrop.Color.b), tonumber(db.oUF.MaintankTarget.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankTarget.Border.Color.r), tonumber(db.oUF.MaintankTarget.Border.Color.g), tonumber(db.oUF.MaintankTarget.Border.Color.b), tonumber(db.oUF.MaintankTarget.Border.Color.a))
											end,
									order = 16,
								},
								InsetBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Border Inset\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Border.Insets.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankTarget.Border.Insets.Bottom end,
									set = function(self,InsetBottom)
										if InsetBottom == nil or InsetBottom == "" then
											InsetBottom = "0"
										end
										db.oUF.MaintankTarget.Border.Insets.Bottom = InsetBottom
										oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankTarget.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankTarget.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankTarget.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankTarget.Border.Insets.Left), right = tonumber(db.oUF.MaintankTarget.Border.Insets.Right), top = tonumber(db.oUF.MaintankTarget.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankTarget.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankTarget.Backdrop.Color.r), tonumber(db.oUF.MaintankTarget.Backdrop.Color.g), tonumber(db.oUF.MaintankTarget.Backdrop.Color.b), tonumber(db.oUF.MaintankTarget.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1target.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankTarget.Border.Color.r), tonumber(db.oUF.MaintankTarget.Border.Color.g), tonumber(db.oUF.MaintankTarget.Border.Color.b), tonumber(db.oUF.MaintankTarget.Border.Color.a))
											end,
									order = 17,
								},
							},
						},
						AlphaFader = {
							name = "Fader",
							type = "group",
							disabled = function() return not db.oUF.MaintankTarget.Enable end,
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
					disabled = function() return not db.oUF.MaintankTarget.Enable end,
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
											desc = "Decide the Height of your Maintank Target Health.\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Health.Height,
											type = "input",
											get = function() return db.oUF.MaintankTarget.Health.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.MaintankTarget.Health.Height = Height
														oUF_LUI_maintankUnitButton1target.Health:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Health.Padding,
											type = "input",
											get = function() return db.oUF.MaintankTarget.Health.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.MaintankTarget.Health.Padding = Padding
														oUF_LUI_maintankUnitButton1target.Health:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Health:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1target, "TOPLEFT", 0, tonumber(Padding))
														oUF_LUI_maintankUnitButton1target.Health:SetPoint("TOPRIGHT", oUF_LUI_maintankUnitButton1target, "TOPRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.MaintankTarget.Health.Smooth end,
											set = function(self,Smooth)
														db.oUF.MaintankTarget.Health.Smooth = not db.oUF.MaintankTarget.Health.Smooth
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
											get = function() return db.oUF.MaintankTarget.Health.ColorClass end,
											set = function(self,HealthClassColor)
														db.oUF.MaintankTarget.Health.ColorClass = true
														db.oUF.MaintankTarget.Health.ColorGradient = false
														db.oUF.MaintankTarget.Health.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Health.colorClass = true
														oUF_LUI_maintankUnitButton1target.Health.colorGradient = false
														oUF_LUI_maintankUnitButton1target.Health.colorIndividual.Enable = false
															
														print("Maintank Target Healthbar Color will change once you gain/lose HP")
													end,
											order = 1,
										},
										HealthGradientColor = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthBars or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Health.ColorGradient end,
											set = function(self,HealthGradientColor)
														db.oUF.MaintankTarget.Health.ColorGradient = true
														db.oUF.MaintankTarget.Health.ColorClass = false
														db.oUF.MaintankTarget.Health.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Health.colorGradient = true
														oUF_LUI_maintankUnitButton1target.Health.colorClass = false
														oUF_LUI_maintankUnitButton1target.Health.colorIndividual.Enable = false
															
														print("Maintank Target Healthbar Color will change once you gain/lose HP")
													end,
											order = 2,
										},
										IndividualHealthColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual HealthBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Health.IndividualColor.Enable end,
											set = function(self,IndividualHealthColor)
														db.oUF.MaintankTarget.Health.IndividualColor.Enable = true
														db.oUF.MaintankTarget.Health.ColorClass = false
														db.oUF.MaintankTarget.Health.ColorGradient = false
															
														oUF_LUI_maintankUnitButton1target.Health.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1target.Health.colorClass = false
														oUF_LUI_maintankUnitButton1target.Health.colorGradient = false
															
														oUF_LUI_maintankUnitButton1target.Health:SetStatusBarColor(db.oUF.MaintankTarget.Health.IndividualColor.r, db.oUF.MaintankTarget.Health.IndividualColor.g, db.oUF.MaintankTarget.Health.IndividualColor.b)
														oUF_LUI_maintankUnitButton1target.Health.bg:SetVertexColor(db.oUF.MaintankTarget.Health.IndividualColor.r*tonumber(db.oUF.MaintankTarget.Health.BGMultiplier), db.oUF.MaintankTarget.Health.IndividualColor.g*tonumber(db.oUF.MaintankTarget.Health.BGMultiplier), db.oUF.MaintankTarget.Health.IndividualColor.b*tonumber(db.oUF.MaintankTarget.Health.BGMultiplier))
													end,
											order = 3,
										},
										HealthColor = {
											name = "Individual Color",
											desc = "Choose an individual Healthbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankTarget.Health.IndividualColor.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankTarget.Health.IndividualColor.r, db.oUF.MaintankTarget.Health.IndividualColor.g, db.oUF.MaintankTarget.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankTarget.Health.IndividualColor.r = r
													db.oUF.MaintankTarget.Health.IndividualColor.g = g
													db.oUF.MaintankTarget.Health.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1target.Health.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1target.Health.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1target.Health.colorIndividual.b = b
														
													oUF_LUI_maintankUnitButton1target.Health:SetStatusBarColor(r, g, b)
													oUF_LUI_maintankUnitButton1target.Health.bg:SetVertexColor(r*tonumber(db.oUF.MaintankTarget.Health.BGMultiplier), g*tonumber(db.oUF.MaintankTarget.Health.BGMultiplier), b*tonumber(db.oUF.MaintankTarget.Health.BGMultiplier))
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
											desc = "Choose your Health Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Health.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.MaintankTarget.Health.Texture
												end,
											set = function(self, HealthTex)
													db.oUF.MaintankTarget.Health.Texture = HealthTex
													oUF_LUI_maintankUnitButton1target.Health:SetStatusBarTexture(LSM:Fetch("statusbar", HealthTex))
												end,
											order = 1,
										},
										HealthTexBG = {
											name = "Background Texture",
											desc = "Choose your Health Background Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Health.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.MaintankTarget.Health.TextureBG
												end,
											set = function(self, HealthTexBG)
													db.oUF.MaintankTarget.Health.TextureBG = HealthTexBG
													oUF_LUI_maintankUnitButton1target.Health.bg:SetTexture(LSM:Fetch("statusbar", HealthTexBG))
												end,
											order = 2,
										},
										HealthTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Health Background.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Health.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.MaintankTarget.Health.BGAlpha end,
											set = function(_, HealthTexBGAlpha) 
													db.oUF.MaintankTarget.Health.BGAlpha  = HealthTexBGAlpha
													oUF_LUI_maintankUnitButton1target.Health.bg:SetAlpha(tonumber(HealthTexBGAlpha))
												end,
											order = 3,
										},
										HealthTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Health.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.MaintankTarget.Health.BGMultiplier end,
											set = function(_, HealthTexBGMultiplier) 
													db.oUF.MaintankTarget.Health.BGMultiplier  = HealthTexBGMultiplier
													oUF_LUI_maintankUnitButton1target.Health.bg.multiplier = tonumber(HealthTexBGMultiplier)
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
									get = function() return db.oUF.MaintankTarget.Power.Enable end,
									set = function(self,EnablePower)
												db.oUF.MaintankTarget.Power.Enable = not db.oUF.MaintankTarget.Power.Enable
												if EnablePower == true then
													oUF_LUI_maintankUnitButton1target.Power:Show()
												else
													oUF_LUI_maintankUnitButton1target.Power:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "General Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Power.Enable end,
									guiInline = true,

									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your MaintankTarget Power.\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Power.Height,
											type = "input",
											get = function() return db.oUF.MaintankTarget.Power.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.MaintankTarget.Power.Height = Height
														oUF_LUI_maintankUnitButton1target.Power:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Power.Padding,
											type = "input",
											get = function() return db.oUF.MaintankTarget.Power.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.MaintankTarget.Power.Padding = Padding
														oUF_LUI_maintankUnitButton1target.Power:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Power:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1target.Health, "BOTTOMLEFT", 0, tonumber(Padding))
														oUF_LUI_maintankUnitButton1target.Power:SetPoint("TOPRIGHT", oUF_LUI_maintankUnitButton1target.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.MaintankTarget.Power.Smooth end,
											set = function(self,Smooth)
														db.oUF.MaintankTarget.Power.Smooth = not db.oUF.MaintankTarget.Power.Smooth
														StaticPopup_Show("RELOAD_UI")
													end,
											order = 3,
										},
									}
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Power.Enable end,
									guiInline = true,
									order = 3,
									args = {
										PowerClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Power.ColorClass end,
											set = function(self,PowerClassColor)
														db.oUF.MaintankTarget.Power.ColorClass = true
														db.oUF.MaintankTarget.Power.ColorType = false
														db.oUF.MaintankTarget.Power.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Power.colorClass = true
														oUF_LUI_maintankUnitButton1target.Power.colorType = false
														oUF_LUI_maintankUnitButton1target.Power.colorIndividual.Enable = false
														
														print("MaintankTarget Powerbar Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										PowerColorByType = {
											name = "Color by Type",
											desc = "Wether you want to use Power Type colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Power.ColorType end,
											set = function(self,PowerColorByType)
														db.oUF.MaintankTarget.Power.ColorType = true
														db.oUF.MaintankTarget.Power.ColorClass = false
														db.oUF.MaintankTarget.Power.IndividualColor.Enable = false
																
														oUF_LUI_maintankUnitButton1target.Power.colorType = true
														oUF_LUI_maintankUnitButton1target.Power.colorClass = false
														oUF_LUI_maintankUnitButton1target.Power.colorIndividual.Enable = false
															
														print("MaintankTarget Powerbar Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualPowerColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PowerBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Power.IndividualColor.Enable end,
											set = function(self,IndividualPowerColor)
														db.oUF.MaintankTarget.Power.IndividualColor.Enable = true
														db.oUF.MaintankTarget.Power.ColorType = false
														db.oUF.MaintankTarget.Power.ColorClass = false
																
														oUF_LUI_maintankUnitButton1target.Power.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1target.Power.colorClass = false
														oUF_LUI_maintankUnitButton1target.Power.colorType = false
															
														oUF_LUI_maintankUnitButton1target.Power:SetStatusBarColor(db.oUF.MaintankTarget.Power.IndividualColor.r, db.oUF.MaintankTarget.Power.IndividualColor.g, db.oUF.MaintankTarget.Power.IndividualColor.b)
														oUF_LUI_maintankUnitButton1target.Power.bg:SetVertexColor(db.oUF.MaintankTarget.Power.IndividualColor.r*tonumber(db.oUF.MaintankTarget.Power.BGMultiplier), db.oUF.MaintankTarget.Power.IndividualColor.g*tonumber(db.oUF.MaintankTarget.Power.BGMultiplier), db.oUF.MaintankTarget.Power.IndividualColor.b*tonumber(db.oUF.MaintankTarget.Power.BGMultiplier))
													end,
											order = 3,
										},
										PowerColor = {
											name = "Individual Color",
											desc = "Choose an individual Powerbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankTarget.Power.IndividualColor.Enable or not db.oUF.MaintankTarget.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankTarget.Power.IndividualColor.r, db.oUF.MaintankTarget.Power.IndividualColor.g, db.oUF.MaintankTarget.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankTarget.Power.IndividualColor.r = r
													db.oUF.MaintankTarget.Power.IndividualColor.g = g
													db.oUF.MaintankTarget.Power.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1target.Power.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1target.Power.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1target.Power.colorIndividual.b = b
														
													oUF_LUI_maintankUnitButton1target.Power:SetStatusBarColor(r, g, b)
													oUF_LUI_maintankUnitButton1target.Power.bg:SetVertexColor(r*tonumber(db.oUF.MaintankTarget.Power.BGMultiplier), g*tonumber(db.oUF.MaintankTarget.Power.BGMultiplier), b*tonumber(db.oUF.MaintankTarget.Power.BGMultiplier))
												end,
											order = 4,
										},
									},
								},
								Textures = {
									name = "Texture Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Power.Enable end,
									guiInline = true,
									order = 4,
									args = {
										PowerTex = {
											name = "Texture",
											desc = "Choose your Power Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Power.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.MaintankTarget.Power.Texture
												end,
											set = function(self, PowerTex)
													db.oUF.MaintankTarget.Power.Texture = PowerTex
													oUF_LUI_maintankUnitButton1target.Power:SetStatusBarTexture(LSM:Fetch("statusbar", PowerTex))
												end,
											order = 1,
										},
										PowerTexBG = {
											name = "Background Texture",
											desc = "Choose your Power Background Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Power.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.MaintankTarget.Power.TextureBG
												end,

											set = function(self, PowerTexBG)
													db.oUF.MaintankTarget.Power.TextureBG = PowerTexBG
													oUF_LUI_maintankUnitButton1target.Power.bg:SetTexture(LSM:Fetch("statusbar", PowerTexBG))
												end,
											order = 2,
										},
										PowerTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Power Background.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Power.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.MaintankTarget.Power.BGAlpha end,
											set = function(_, PowerTexBGAlpha) 
													db.oUF.MaintankTarget.Power.BGAlpha  = PowerTexBGAlpha
													oUF_LUI_maintankUnitButton1target.Power.bg:SetAlpha(tonumber(PowerTexBGAlpha))
												end,
											order = 3,
										},
										PowerTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Power.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.MaintankTarget.Power.BGMultiplier end,
											set = function(_, PowerTexBGMultiplier) 
													db.oUF.MaintankTarget.Power.BGMultiplier  = PowerTexBGMultiplier
													oUF_LUI_maintankUnitButton1target.Power.bg.multiplier = tonumber(PowerTexBGMultiplier)
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
									get = function() return db.oUF.MaintankTarget.Full.Enable end,
									set = function(self,EnableFullbar)
												db.oUF.MaintankTarget.Full.Enable = not db.oUF.MaintankTarget.Full.Enable
												if EnableFullbar == true then
													oUF_LUI_maintankUnitButton1target_Full:Show()
												else
													oUF_LUI_maintankUnitButton1target_Full:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Full.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your Fullbar.\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Full.Height,
											type = "input",
											get = function() return db.oUF.MaintankTarget.Full.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.MaintankTarget.Full.Height = Height
														oUF_LUI_maintankUnitButton1target_Full:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Fullbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Full.Padding,
											type = "input",
											get = function() return db.oUF.MaintankTarget.Full.Padding end,
											set = function(self,Padding)
													if Padding == nil or Padding == "" then
														Padding = "0"
													end
													db.oUF.MaintankTarget.Full.Padding = Padding
													oUF_LUI_maintankUnitButton1target_Full:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target_Full:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1target.Health, "BOTTOMLEFT", 0, tonumber(Padding))
													oUF_LUI_maintankUnitButton1target_Full:SetPoint("TOPRIGHT", oUF_LUI_maintankUnitButton1target.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
												end,
											order = 2,
										},
										FullTex = {
											name = "Texture",
											desc = "Choose your Fullbar Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Full.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.MaintankTarget.Full.Texture
												end,
											set = function(self, FullTex)
													db.oUF.MaintankTarget.Full.Texture = FullTex
													oUF_LUI_maintankUnitButton1target_Full:SetStatusBarTexture(LSM:Fetch("statusbar", FullTex))
												end,
											order = 3,
										},
										FullAlpha = {
											name = "Alpha",
											desc = "Choose the Alpha Value for your Fullbar!\n Default: "..LUI.defaults.profile.oUF.MaintankTarget.Full.Alpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.MaintankTarget.Full.Alpha end,
											set = function(_, FullAlpha)
													db.oUF.MaintankTarget.Full.Alpha = FullAlpha
													oUF_LUI_maintankUnitButton1target_Full:SetAlpha(FullAlpha)
												end,
											order = 4,
										},
										Color = {
											name = "Color",
											desc = "Choose your Fullbar Color.",
											type = "color",
											hasAlpha = true,
											get = function() return db.oUF.MaintankTarget.Full.Color.r, db.oUF.MaintankTarget.Full.Color.g, db.oUF.MaintankTarget.Full.Color.b, db.oUF.MaintankTarget.Full.Color.a end,
											set = function(_,r,g,b,a)
													db.oUF.MaintankTarget.Full.Color.r = r
													db.oUF.MaintankTarget.Full.Color.g = g
													db.oUF.MaintankTarget.Full.Color.b = b
													db.oUF.MaintankTarget.Full.Color.a = a
													
													oUF_LUI_maintankUnitButton1target_Full:SetStatusBarColor(r, g, b, a)
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
					disabled = function() return not db.oUF.MaintankTarget.Enable end,
					order = 6,
					args = {
						Name = {
							name = "Name",
							type = "group",
							order = 1,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the MaintankTarget Name or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankTarget.Texts.Name.Enable end,
									set = function(self,Enable)
												db.oUF.MaintankTarget.Texts.Name.Enable = not db.oUF.MaintankTarget.Texts.Name.Enable
												if Enable == true then
													oUF_LUI_maintankUnitButton1target.Info:Show()
												else
													oUF_LUI_maintankUnitButton1target.Info:Hide()
												end
											end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankTarget Name Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Name.Size,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankTarget.Texts.Name.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankTarget.Texts.Name.Size = FontSize
													oUF_LUI_maintankUnitButton1target.Info:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.Name.Font),db.oUF.MaintankTarget.Texts.Name.Size,db.oUF.MaintankTarget.Texts.Name.Outline)
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
											desc = "Choose your Font for MaintankTarget Name!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Name.Font,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankTarget.Texts.Name.Font end,
											set = function(self, Font)
													db.oUF.MaintankTarget.Texts.Name.Font = Font
													oUF_LUI_maintankUnitButton1target.Info:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.Name.Font),db.oUF.MaintankTarget.Texts.Name.Size,db.oUF.MaintankTarget.Texts.Name.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankTarget Name.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Name.Outline,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankTarget.Texts.Name.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankTarget.Texts.Name.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1target.Info:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.Name.Font),db.oUF.MaintankTarget.Texts.Name.Size,db.oUF.MaintankTarget.Texts.Name.Outline)
												end,
											order = 4,
										},
										NameX = {
											name = "X Value",
											desc = "X Value for your MaintankTarget Name.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Name.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Name.X end,
											set = function(self,NameX)
														if NameX == nil or NameX == "" then
															NameX = "0"
														end
														db.oUF.MaintankTarget.Texts.Name.X = NameX
														oUF_LUI_maintankUnitButton1target.Info:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Info:SetPoint(db.oUF.MaintankTarget.Texts.Name.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Name.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Name.X), tonumber(db.oUF.MaintankTarget.Texts.Name.Y))
													end,
											order = 5,
										},
										NameY = {
											name = "Y Value",
											desc = "Y Value for your MaintankTarget Name.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Name.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Name.Y end,
											set = function(self,NameY)
														if NameY == nil or NameY == "" then
															NameY = "0"
														end
														db.oUF.MaintankTarget.Texts.Name.Y = NameY
														oUF_LUI_maintankUnitButton1target.Info:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Info:SetPoint(db.oUF.MaintankTarget.Texts.Name.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Name.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Name.X), tonumber(db.oUF.MaintankTarget.Texts.Name.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankTarget Name.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Name.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.Name.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankTarget.Texts.Name.Point = positions[Point]
													oUF_LUI_maintankUnitButton1target.Info:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Info:SetPoint(db.oUF.MaintankTarget.Texts.Name.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Name.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Name.X), tonumber(db.oUF.MaintankTarget.Texts.Name.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankTarget Name.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Name.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.Name.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankTarget.Texts.Name.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1target.Info:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Info:SetPoint(db.oUF.MaintankTarget.Texts.Name.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Name.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Name.X), tonumber(db.oUF.MaintankTarget.Texts.Name.Y))
												end,
											order = 8,
										},
									},
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Format = {
											name = "Format",
											desc = "Choose the Format for your MaintankTarget Name.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Name.Format,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											type = "select",
											width = "full",
											values = nameFormat,

											get = function()
													for k, v in pairs(nameFormat) do
														if db.oUF.MaintankTarget.Texts.Name.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.MaintankTarget.Texts.Name.Format = nameFormat[Format]
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 1,
										},
										Length = {
											name = "Length",
											desc = "Choose the Length of your MaintankTarget Name.\n\nShort = 6 Letters\nMedium = 18 Letters\nLong = 36 Letters\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Name.Length,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											type = "select",
											values = nameLenghts,
											get = function()
													for k, v in pairs(nameLenghts) do
														if db.oUF.MaintankTarget.Texts.Name.Length == v then
															return k
														end
													end
												end,
											set = function(self, Length)
													db.oUF.MaintankTarget.Texts.Name.Length = nameLenghts[Length]
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
											desc = "Wether you want to color the MaintankTarget Name by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Name.ColorNameByClass end,
											set = function(self,ColorNameByClass)
													db.oUF.MaintankTarget.Texts.Name.ColorNameByClass = not db.oUF.MaintankTarget.Texts.Name.ColorNameByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 4,
										},
										ColorClassByClass = {
											name = "Color Class by Class",
											desc = "Wether you want to color the MaintankTarget Class by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Name.ColorClassByClass end,
											set = function(self,ColorClassByClass)
													db.oUF.MaintankTarget.Texts.Name.ColorClassByClass = not db.oUF.MaintankTarget.Texts.Name.ColorClassByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 5,
										},
										ColorLevelByDifficulty = {
											name = "Color Level by Difficulty",
											desc = "Wether you want to color the Level by Difficulty or not.",
											type = "toggle",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Name.ColorLevelByDifficulty end,
											set = function(self,ColorLevelByDifficulty)
													db.oUF.MaintankTarget.Texts.Name.ColorLevelByDifficulty = not db.oUF.MaintankTarget.Texts.Name.ColorLevelByDifficulty
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 6,
										},
										ShowClassification = {
											name = "Show Classification",
											desc = "Wether you want to show Classifications like Elite, Boss, Rar or not.",
											type = "toggle",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Name.ShowClassification end,
											set = function(self,ShowClassification)
													db.oUF.MaintankTarget.Texts.Name.ShowClassification = not db.oUF.MaintankTarget.Texts.Name.ShowClassification
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 7,
										},
										ShortClassification = {
											name = "Enable Short Classification",
											desc = "Wether you want to show short Classifications or not.",
											type = "toggle",
											width = "full",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Name.ShowClassification or not db.oUF.MaintankTarget.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Name.ShortClassification end,
											set = function(self,ShortClassification)
													db.oUF.MaintankTarget.Texts.Name.ShortClassification = not db.oUF.MaintankTarget.Texts.Name.ShortClassification
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
									desc = "Wether you want to show the MaintankTarget Health or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankTarget.Texts.Health.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankTarget.Texts.Health.Enable = not db.oUF.MaintankTarget.Texts.Health.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1target.Health.value:Show()
											else
												oUF_LUI_maintankUnitButton1target.Health.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.Health.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankTarget Health Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Health.Size,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Health.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankTarget.Texts.Health.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankTarget.Texts.Health.Size = FontSize
													oUF_LUI_maintankUnitButton1target.Health.value:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.Health.Font),db.oUF.MaintankTarget.Texts.Health.Size,db.oUF.MaintankTarget.Texts.Health.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your MaintankTarget Health.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Health.Format,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Health.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.MaintankTarget.Texts.Health.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.MaintankTarget.Texts.Health.Format = valueFormat[Format]
													oUF_LUI_maintankUnitButton1target.Health.value.Format = valueFormat[Format]
													print("MaintankTarget Health Value Format will change once you gain/lose Health")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankTarget Health!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Health.Font,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Health.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankTarget.Texts.Health.Font end,
											set = function(self, Font)
													db.oUF.MaintankTarget.Texts.Health.Font = Font
													oUF_LUI_maintankUnitButton1target.Health.value:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.Health.Font),db.oUF.MaintankTarget.Texts.Health.Size,db.oUF.MaintankTarget.Texts.Health.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankTarget Health.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Health.Outline,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Health.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankTarget.Texts.Health.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankTarget.Texts.Health.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1target.Health.value:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.Health.Font),db.oUF.MaintankTarget.Texts.Health.Size,db.oUF.MaintankTarget.Texts.Health.Outline)
												end,
											order = 4,
										},
										HealthX = {
											name = "X Value",
											desc = "X Value for your MaintankTarget Health.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Health.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Health.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Health.X end,
											set = function(self,HealthX)
														if HealthX == nil or HealthX == "" then
															HealthX = "0"
														end
														db.oUF.MaintankTarget.Texts.Health.X = HealthX
														oUF_LUI_maintankUnitButton1target.Health.value:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Health.value:SetPoint(db.oUF.MaintankTarget.Texts.Health.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Health.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Health.X), tonumber(db.oUF.MaintankTarget.Texts.Health.Y))
													end,
											order = 5,
										},
										HealthY = {
											name = "Y Value",
											desc = "Y Value for your MaintankTarget Health.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Health.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Health.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Health.Y end,
											set = function(self,HealthY)
														if HealthY == nil or HealthY == "" then
															HealthY = "0"
														end
														db.oUF.MaintankTarget.Texts.Health.Y = HealthY
														oUF_LUI_maintankUnitButton1target.Health.value:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Health.value:SetPoint(db.oUF.MaintankTarget.Texts.Health.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Health.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Health.X), tonumber(db.oUF.MaintankTarget.Texts.Health.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankTarget Health.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Health.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.Health.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankTarget.Texts.Health.Point = positions[Point]
													oUF_LUI_maintankUnitButton1target.Health.value:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Health.value:SetPoint(db.oUF.MaintankTarget.Texts.Health.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Health.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Health.X), tonumber(db.oUF.MaintankTarget.Texts.Health.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankTarget Health.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Health.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.Health.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankTarget.Texts.Health.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1target.Health.value:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Health.value:SetPoint(db.oUF.MaintankTarget.Texts.Health.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Health.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Health.X), tonumber(db.oUF.MaintankTarget.Texts.Health.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.Health.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.Health.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankTarget.Texts.Health.ColorClass = true
														db.oUF.MaintankTarget.Texts.Health.ColorGradient = false
														db.oUF.MaintankTarget.Texts.Health.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Health.value.colorClass = true
														oUF_LUI_maintankUnitButton1target.Health.value.colorGradient = false
														oUF_LUI_maintankUnitButton1target.Health.value.colorIndividual.Enable = false
														
														print("MaintankTarget Health Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.Health.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.MaintankTarget.Texts.Health.ColorGradient = true
														db.oUF.MaintankTarget.Texts.Health.ColorClass = false
														db.oUF.MaintankTarget.Texts.Health.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Health.value.colorGradient = true
														oUF_LUI_maintankUnitButton1target.Health.value.colorClass = false
														oUF_LUI_maintankUnitButton1target.Health.value.colorIndividual.Enable = false
															
														print("MaintankTarget Health Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankTarget Health Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.Health.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankTarget.Texts.Health.IndividualColor.Enable = true
														db.oUF.MaintankTarget.Texts.Health.ColorClass = false
														db.oUF.MaintankTarget.Texts.Health.ColorGradient = false
															
														oUF_LUI_maintankUnitButton1target.Health.value.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1target.Health.value.colorClass = false
														oUF_LUI_maintankUnitButton1target.Health.value.colorGradient = false
														
														oUF_LUI_maintankUnitButton1target.Health.value:SetTextColor(tonumber(db.oUF.MaintankTarget.Texts.Health.IndividualColor.r),tonumber(db.oUF.MaintankTarget.Texts.Health.IndividualColor.g),tonumber(db.oUF.MaintankTarget.Texts.Health.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankTarget Health Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Health.IndividualColor.Enable or not db.oUF.MaintankTarget.Texts.Health.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankTarget.Texts.Health.IndividualColor.r, db.oUF.MaintankTarget.Texts.Health.IndividualColor.g, db.oUF.MaintankTarget.Texts.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankTarget.Texts.Health.IndividualColor.r = r
													db.oUF.MaintankTarget.Texts.Health.IndividualColor.g = g
													db.oUF.MaintankTarget.Texts.Health.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1target.Health.value.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1target.Health.value.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1target.Health.value.colorIndividual.b = b
													
													oUF_LUI_maintankUnitButton1target.Health.value:SetTextColor(r,g,b)
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
											get = function() return db.oUF.MaintankTarget.Texts.Health.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.MaintankTarget.Texts.Health.ShowDead = not db.oUF.MaintankTarget.Texts.Health.ShowDead
														oUF_LUI_maintankUnitButton1target.Health.value.ShowDead = db.oUF.MaintankTarget.Texts.Health.ShowDead
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
									desc = "Wether you want to show the MaintankTarget Power or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankTarget.Texts.Power.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankTarget.Texts.Power.Enable = not db.oUF.MaintankTarget.Texts.Power.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1target.Power.value:Show()
											else
												oUF_LUI_maintankUnitButton1target.Power.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.Power.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankTarget Power Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Power.Size,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Power.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankTarget.Texts.Power.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankTarget.Texts.Power.Size = FontSize
													oUF_LUI_maintankUnitButton1target.Power.value:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.Power.Font),db.oUF.MaintankTarget.Texts.Power.Size,db.oUF.MaintankTarget.Texts.Power.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your MaintankTarget Power.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Power.Format,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Power.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.MaintankTarget.Texts.Power.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.MaintankTarget.Texts.Power.Format = valueFormat[Format]
													oUF_LUI_maintankUnitButton1target.Power.value.Format = valueFormat[Format]
													print("MaintankTarget Power Value Format will change once you gain/lose Power")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankTarget Power!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Power.Font,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Power.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankTarget.Texts.Power.Font end,
											set = function(self, Font)
													db.oUF.MaintankTarget.Texts.Power.Font = Font
													oUF_LUI_maintankUnitButton1target.Power.value:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.Power.Font),db.oUF.MaintankTarget.Texts.Power.Size,db.oUF.MaintankTarget.Texts.Power.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankTarget Power.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Power.Outline,
											disabled = function() return not db.oUF.MaintankTarget.Texts.Power.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankTarget.Texts.Power.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankTarget.Texts.Power.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1target.Power.value:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.Power.Font),db.oUF.MaintankTarget.Texts.Power.Size,db.oUF.MaintankTarget.Texts.Power.Outline)
												end,
											order = 4,
										},
										PowerX = {
											name = "X Value",
											desc = "X Value for your MaintankTarget Power.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Power.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Power.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Power.X end,
											set = function(self,PowerX)
														if PowerX == nil or PowerX == "" then
															PowerX = "0"
														end
														db.oUF.MaintankTarget.Texts.Power.X = PowerX
														oUF_LUI_maintankUnitButton1target.Power.value:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Power.value:SetPoint(db.oUF.MaintankTarget.Texts.Power.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Power.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Power.X), tonumber(db.oUF.MaintankTarget.Texts.Power.Y))
													end,
											order = 5,
										},
										PowerY = {
											name = "Y Value",
											desc = "Y Value for your MaintankTarget Power.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Power.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Power.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.Power.Y end,
											set = function(self,PowerY)
														if PowerY == nil or PowerY == "" then
															PowerY = "0"
														end
														db.oUF.MaintankTarget.Texts.Power.Y = PowerY
														oUF_LUI_maintankUnitButton1target.Power.value:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Power.value:SetPoint(db.oUF.MaintankTarget.Texts.Power.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Power.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Power.X), tonumber(db.oUF.MaintankTarget.Texts.Power.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankTarget Power.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Power.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.Power.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankTarget.Texts.Power.Point = positions[Point]
													oUF_LUI_maintankUnitButton1target.Power.value:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Power.value:SetPoint(db.oUF.MaintankTarget.Texts.Power.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Power.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Power.X), tonumber(db.oUF.MaintankTarget.Texts.Power.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankTarget Power.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.Power.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.Power.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankTarget.Texts.Power.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1target.Power.value:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Power.value:SetPoint(db.oUF.MaintankTarget.Texts.Power.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.Power.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.Power.X), tonumber(db.oUF.MaintankTarget.Texts.Power.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.Power.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.Power.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankTarget.Texts.Power.ColorClass = true
														db.oUF.MaintankTarget.Texts.Power.ColorType = false
														db.oUF.MaintankTarget.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Power.value.colorClass = true
														oUF_LUI_maintankUnitButton1target.Power.value.colorType = false
														oUF_LUI_maintankUnitButton1target.Power.value.colorIndividual.Enable = false
			
														print("MaintankTarget Power Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Powertype colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.Power.ColorType end,
											set = function(self,ColorType)
														db.oUF.MaintankTarget.Texts.Power.ColorType = true
														db.oUF.MaintankTarget.Texts.Power.ColorClass = false
														db.oUF.MaintankTarget.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Power.value.colorType = true
														oUF_LUI_maintankUnitButton1target.Power.value.colorClass = false
														oUF_LUI_maintankUnitButton1target.Power.value.colorIndividual.Enable = false
		
														print("MaintankTarget Power Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankTarget Power Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.Power.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankTarget.Texts.Power.IndividualColor.Enable = true
														db.oUF.MaintankTarget.Texts.Power.ColorClass = false
														db.oUF.MaintankTarget.Texts.Power.ColorType = false
														
														oUF_LUI_maintankUnitButton1target.Power.value.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1target.Power.value.colorClass = false
														oUF_LUI_maintankUnitButton1target.Power.value.colorType = false
			
														oUF_LUI_maintankUnitButton1target.Power.value:SetTextColor(tonumber(db.oUF.MaintankTarget.Texts.Power.IndividualColor.r),tonumber(db.oUF.MaintankTarget.Texts.Power.IndividualColor.g),tonumber(db.oUF.MaintankTarget.Texts.Power.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankTarget Power Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankTarget.Texts.Power.IndividualColor.Enable or not db.oUF.MaintankTarget.Texts.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankTarget.Texts.Power.IndividualColor.r, db.oUF.MaintankTarget.Texts.Power.IndividualColor.g, db.oUF.MaintankTarget.Texts.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankTarget.Texts.Power.IndividualColor.r = r
													db.oUF.MaintankTarget.Texts.Power.IndividualColor.g = g
													db.oUF.MaintankTarget.Texts.Power.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1target.Power.value.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1target.Power.value.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1target.Power.value.colorIndividual.b = b

													oUF_LUI_maintankUnitButton1target.Power.value:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the MaintankTarget HealthPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankTarget.Texts.HealthPercent.Enable = not db.oUF.MaintankTarget.Texts.HealthPercent.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1target.Health.valuePercent:Show()
											else
												oUF_LUI_maintankUnitButton1target.Health.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankTarget HealthPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthPercent.Size,
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankTarget.Texts.HealthPercent.Size = FontSize
													oUF_LUI_maintankUnitButton1target.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.HealthPercent.Font),db.oUF.MaintankTarget.Texts.HealthPercent.Size,db.oUF.MaintankTarget.Texts.HealthPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show MaintankTarget HealthPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.MaintankTarget.Texts.HealthPercent.ShowAlways = not db.oUF.MaintankTarget.Texts.HealthPercent.ShowAlways
													oUF_LUI_maintankUnitButton1target.health.valuePercent = db.oUF.MaintankTarget.Texts.HealthPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankTarget HealthPercent!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthPercent.Font,
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.Font end,
											set = function(self, Font)
													db.oUF.MaintankTarget.Texts.HealthPercent.Font = Font
													oUF_LUI_maintankUnitButton1target.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.HealthPercent.Font),db.oUF.MaintankTarget.Texts.HealthPercent.Size,db.oUF.MaintankTarget.Texts.HealthPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankTarget HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthPercent.Outline,
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankTarget.Texts.HealthPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankTarget.Texts.HealthPercent.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1target.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.HealthPercent.Font),db.oUF.MaintankTarget.Texts.HealthPercent.Size,db.oUF.MaintankTarget.Texts.HealthPercent.Outline)
												end,
											order = 4,
										},
										HealthPercentX = {
											name = "X Value",
											desc = "X Value for your MaintankTarget HealthPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthPercent.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.X end,
											set = function(self,HealthPercentX)
														if HealthPercentX == nil or HealthPercentX == "" then
															HealthPercentX = "0"
														end
														db.oUF.MaintankTarget.Texts.HealthPercent.X = HealthPercentX
														oUF_LUI_maintankUnitButton1target.Health.valuePercent:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Health.valuePercent:SetPoint(db.oUF.MaintankTarget.Texts.HealthPercent.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.X), tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.Y))
													end,
											order = 5,
										},
										HealthPercentY = {
											name = "Y Value",
											desc = "Y Value for your MaintankTarget HealthPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.Y end,
											set = function(self,HealthPercentY)
														if HealthPercentY == nil or HealthPercentY == "" then
															HealthPercentY = "0"
														end
														db.oUF.MaintankTarget.Texts.HealthPercent.Y = HealthPercentY
														oUF_LUI_maintankUnitButton1target.Health.valuePercent:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Health.valuePercent:SetPoint(db.oUF.MaintankTarget.Texts.HealthPercent.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.X), tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankTarget HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.HealthPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankTarget.Texts.HealthPercent.Point = positions[Point]
													oUF_LUI_maintankUnitButton1target.Health.valuePercent:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Health.valuePercent:SetPoint(db.oUF.MaintankTarget.Texts.HealthPercent.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.X), tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankTarget HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.HealthPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankTarget.Texts.HealthPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1target.Health.valuePercent:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Health.valuePercent:SetPoint(db.oUF.MaintankTarget.Texts.HealthPercent.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.X), tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankTarget.Texts.HealthPercent.ColorClass = true
														db.oUF.MaintankTarget.Texts.HealthPercent.ColorGradient = false
														db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorClass = true
														oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorGradient = false
														oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorIndividual.Enable = false
					
														print("MaintankTarget HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.MaintankTarget.Texts.HealthPercent.ColorGradient = true
														db.oUF.MaintankTarget.Texts.HealthPercent.ColorClass = false
														db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorGradient = true
														oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorClass = false
														oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorIndividual.Enable = false
				
														print("MaintankTarget HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankTarget HealthPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.Enable = true
														db.oUF.MaintankTarget.Texts.HealthPercent.ColorClass = false
														db.oUF.MaintankTarget.Texts.HealthPercent.ColorGradient = false
															
														oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorClass = false
														oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorGradient = false
							
														oUF_LUI_maintankUnitButton1target.Health.valuePercent:SetTextColor(tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.r),tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.g),tonumber(db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankTarget HealthPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.Enable or not db.oUF.MaintankTarget.Texts.HealthPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.r, db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.g, db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.r = r
													db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.g = g
													db.oUF.MaintankTarget.Texts.HealthPercent.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1target.Health.valuePercent.colorIndividual.b = b
			
													oUF_LUI_maintankUnitButton1target.Health.valuePercent:SetTextColor(r,g,b)
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
											get = function() return db.oUF.MaintankTarget.Texts.HealthPercent.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.MaintankTarget.Texts.HealthPercent.ShowDead = not db.oUF.MaintankTarget.Texts.HealthPercent.ShowDead
														oUF_LUI_maintankUnitButton1target.Health.valuePercent.ShowDead = db.oUF.MaintankTarget.Texts.HealthPercent.ShowDead
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
									desc = "Wether you want to show the MaintankTarget PowerPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankTarget.Texts.PowerPercent.Enable = not db.oUF.MaintankTarget.Texts.PowerPercent.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1target.Power.valuePercent:Show()
											else
												oUF_LUI_maintankUnitButton1target.Power.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankTarget PowerPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerPercent.Size,
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankTarget.Texts.PowerPercent.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankTarget.Texts.PowerPercent.Size = FontSize
													oUF_LUI_maintankUnitButton1target.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.PowerPercent.Font),db.oUF.MaintankTarget.Texts.PowerPercent.Size,db.oUF.MaintankTarget.Texts.PowerPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show MaintankTarget PowerPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.PowerPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.MaintankTarget.Texts.PowerPercent.ShowAlways = not db.oUF.MaintankTarget.Texts.PowerPercent.ShowAlways
													oUF_LUI_maintankUnitButton1target.Power.valuePercent.ShowAlways = db.oUF.MaintankTarget.Texts.PowerPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankTarget PowerPercent!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerPercent.Font,
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankTarget.Texts.PowerPercent.Font end,
											set = function(self, Font)
													db.oUF.MaintankTarget.Texts.PowerPercent.Font = Font
													oUF_LUI_maintankUnitButton1target.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.PowerPercent.Font),db.oUF.MaintankTarget.Texts.PowerPercent.Size,db.oUF.MaintankTarget.Texts.PowerPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankTarget PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerPercent.Outline,
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankTarget.Texts.PowerPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankTarget.Texts.PowerPercent.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1target.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.PowerPercent.Font),db.oUF.MaintankTarget.Texts.PowerPercent.Size,db.oUF.MaintankTarget.Texts.PowerPercent.Outline)
												end,
											order = 4,
										},
										PowerPercentX = {
											name = "X Value",
											desc = "X Value for your MaintankTarget PowerPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerPercent.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.PowerPercent.X end,
											set = function(self,PowerPercentX)
														if PowerPercentX == nil or PowerPercentX == "" then
															PowerPercentX = "0"
														end
														db.oUF.MaintankTarget.Texts.PowerPercent.X = PowerPercentX
														oUF_LUI_maintankUnitButton1target.Power.valuePercent:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Power.valuePercent:SetPoint(db.oUF.MaintankTarget.Texts.PowerPercent.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.X), tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.Y))
													end,
											order = 5,

										},
										PowerPercentY = {
											name = "Y Value",
											desc = "Y Value for your MaintankTarget PowerPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.PowerPercent.Y end,
											set = function(self,PowerPercentY)
														if PowerPercentY == nil or PowerPercentY == "" then
															PowerPercentY = "0"
														end
														db.oUF.MaintankTarget.Texts.PowerPercent.Y = PowerPercentY
														oUF_LUI_maintankUnitButton1target.Power.valuePercent:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Power.valuePercent:SetPoint(db.oUF.MaintankTarget.Texts.PowerPercent.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.X), tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankTarget PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.PowerPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankTarget.Texts.PowerPercent.Point = positions[Point]
													oUF_LUI_maintankUnitButton1target.Power.valuePercent:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Power.valuePercent:SetPoint(db.oUF.MaintankTarget.Texts.PowerPercent.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.X), tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankTarget PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.PowerPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankTarget.Texts.PowerPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1target.Power.valuePercent:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Power.valuePercent:SetPoint(db.oUF.MaintankTarget.Texts.PowerPercent.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.X), tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.PowerPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankTarget.Texts.PowerPercent.ColorClass = true
														db.oUF.MaintankTarget.Texts.PowerPercent.ColorType = false
														db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.Enable = false
														
														oUF_LUI_maintankUnitButton1target.Power.valuePercent.colorClass = true
														oUF_LUI_maintankUnitButton1target.Power.valuePercent.colorType = false
														oUF_LUI_maintankUnitButton1target.Power.valuePercent.individualColor.Enable = false
	
														print("MaintankTarget PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.PowerPercent.ColorType end,
											set = function(self,ColorType)
														db.oUF.MaintankTarget.Texts.PowerPercent.ColorType = true
														db.oUF.MaintankTarget.Texts.PowerPercent.ColorClass = false
														db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Power.valuePercent.colorType = true
														oUF_LUI_maintankUnitButton1target.Power.valuePercent.colorClass = false
														oUF_LUI_maintankUnitButton1target.Power.valuePercent.individualColor.Enable = false
		
														print("MaintankTarget PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankTarget PowerPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.Enable = true
														db.oUF.MaintankTarget.Texts.PowerPercent.ColorClass = false
														db.oUF.MaintankTarget.Texts.PowerPercent.ColorType = false
															
														oUF_LUI_maintankUnitButton1target.Power.valuePercent.individualColor.Enable = true
														oUF_LUI_maintankUnitButton1target.Power.valuePercent.colorClass = false
														oUF_LUI_maintankUnitButton1target.Power.valuePercent.colorType = false

														oUF_LUI_maintankUnitButton1target.Power.valuePercent:SetTextColor(tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.r),tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.g),tonumber(db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankTarget PowerPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.Enable or not db.oUF.MaintankTarget.Texts.PowerPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.r, db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.g, db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.r = r
													db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.g = g
													db.oUF.MaintankTarget.Texts.PowerPercent.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1target.Power.valuePercent.individualColor.r = r
													oUF_LUI_maintankUnitButton1target.Power.valuePercent.individualColor.g = g
													oUF_LUI_maintankUnitButton1target.Power.valuePercent.individualColor.b = b

													oUF_LUI_maintankUnitButton1target.Power.valuePercent:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the MaintankTarget HealthMissing or not.",
									type = "toggle",

									width = "full",
									get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankTarget.Texts.HealthMissing.Enable = not db.oUF.MaintankTarget.Texts.HealthMissing.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1target.Health.valueMissing:Show()
											else
												oUF_LUI_maintankUnitButton1target.Health.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankTarget HealthMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthMissing.Size,
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankTarget.Texts.HealthMissing.Size = FontSize
													oUF_LUI_maintankUnitButton1target.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.HealthMissing.Font),db.oUF.MaintankTarget.Texts.HealthMissing.Size,db.oUF.MaintankTarget.Texts.HealthMissing.Outline)
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
											desc = "Always show MaintankTarget HealthMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.MaintankTarget.Texts.HealthMissing.ShowAlways = not db.oUF.MaintankTarget.Texts.HealthMissing.ShowAlways
													oUF_LUI_maintankUnitButton1target.Health.valueMissing.ShowAlways = db.oUF.MaintankTarget.Texts.HealthMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.MaintankTarget.Texts.HealthMissing.ShortValue = not db.oUF.MaintankTarget.Texts.HealthMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankTarget HealthMissing!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthMissing.Font,
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.Font end,
											set = function(self, Font)
													db.oUF.MaintankTarget.Texts.HealthMissing.Font = Font
													oUF_LUI_maintankUnitButton1target.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.HealthMissing.Font),db.oUF.MaintankTarget.Texts.HealthMissing.Size,db.oUF.MaintankTarget.Texts.HealthMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankTarget HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthMissing.Outline,
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankTarget.Texts.HealthMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankTarget.Texts.HealthMissing.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1target.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.HealthMissing.Font),db.oUF.MaintankTarget.Texts.HealthMissing.Size,db.oUF.MaintankTarget.Texts.HealthMissing.Outline)
												end,
											order = 6,
										},
										HealthMissingX = {
											name = "X Value",
											desc = "X Value for your MaintankTarget HealthMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthMissing.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.X end,
											set = function(self,HealthMissingX)
														if HealthMissingX == nil or HealthMissingX == "" then
															HealthMissingX = "0"
														end
														db.oUF.MaintankTarget.Texts.HealthMissing.X = HealthMissingX
														oUF_LUI_maintankUnitButton1target.Health.valueMissing:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Health.valueMissing:SetPoint(db.oUF.MaintankTarget.Texts.HealthMissing.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.X), tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.Y))
													end,
											order = 7,
										},
										HealthMissingY = {
											name = "Y Value",
											desc = "Y Value for your MaintankTarget HealthMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.Y end,
											set = function(self,HealthMissingY)
														if HealthMissingY == nil or HealthMissingY == "" then
															HealthMissingY = "0"
														end
														db.oUF.MaintankTarget.Texts.HealthMissing.Y = HealthMissingY
														oUF_LUI_maintankUnitButton1target.Health.valueMissing:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Health.valueMissing:SetPoint(db.oUF.MaintankTarget.Texts.HealthMissing.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.X), tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankTarget HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.HealthMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankTarget.Texts.HealthMissing.Point = positions[Point]
													oUF_LUI_maintankUnitButton1target.Health.valueMissing:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Health.valueMissing:SetPoint(db.oUF.MaintankTarget.Texts.HealthMissing.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.X), tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankTarget HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.HealthMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.HealthMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankTarget.Texts.HealthMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1target.Health.valueMissing:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Health.valueMissing:SetPoint(db.oUF.MaintankTarget.Texts.HealthMissing.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.X), tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankTarget.Texts.HealthMissing.ColorClass = true
														db.oUF.MaintankTarget.Texts.HealthMissing.ColorGradient = false
														db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.Enable = false
														
														oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorClass = true
														oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorGradient = false
														oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorIndividual.Enable = false
	
														print("MaintankTarget HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.MaintankTarget.Texts.HealthMissing.ColorGradient = true
														db.oUF.MaintankTarget.Texts.HealthMissing.ColorClass = false
														db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorGradient = true
														oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorClass = false
														oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorIndividual.Enable = false

														print("MaintankTarget HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankTarget HealthMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.Enable = true
														db.oUF.MaintankTarget.Texts.HealthMissing.ColorClass = false
														db.oUF.MaintankTarget.Texts.HealthMissing.ColorGradient = false
															
														oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorClass = false
														oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorGradient = false

														oUF_LUI_maintankUnitButton1target.Health.valueMissing:SetTextColor(tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.r),tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.g),tonumber(db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankTarget HealthMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.Enable or not db.oUF.MaintankTarget.Texts.HealthMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.r, db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.g, db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.r = r
													db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.g = g
													db.oUF.MaintankTarget.Texts.HealthMissing.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1target.Health.valueMissing.colorIndividual.b = b
													
													oUF_LUI_maintankUnitButton1target.Health.valueMissing:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the MaintankTarget PowerMissing or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankTarget.Texts.PowerMissing.Enable = not db.oUF.MaintankTarget.Texts.PowerMissing.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1target.Power.valueMissing:Show()
											else
												oUF_LUI_maintankUnitButton1target.Power.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankTarget PowerMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerMissing.Size,
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankTarget.Texts.PowerMissing.Size = FontSize
													oUF_LUI_maintankUnitButton1target.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.PowerMissing.Font),db.oUF.MaintankTarget.Texts.PowerMissing.Size,db.oUF.MaintankTarget.Texts.PowerMissing.Outline)
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
											desc = "Always show MaintankTarget PowerMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.MaintankTarget.Texts.PowerMissing.ShowAlways = not db.oUF.MaintankTarget.Texts.PowerMissing.ShowAlways
													oUF_LUI_maintankUnitButton1target.Power.valueMissing.ShowAlways = db.oUF.MaintankTarget.Texts.PowerMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.MaintankTarget.Texts.PowerMissing.ShortValue = not db.oUF.MaintankTarget.Texts.PowerMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankTarget PowerMissing!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerMissing.Font,
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.Font end,
											set = function(self, Font)
													db.oUF.MaintankTarget.Texts.PowerMissing.Font = Font
													oUF_LUI_maintankUnitButton1target.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.PowerMissing.Font),db.oUF.MaintankTarget.Texts.PowerMissing.Size,db.oUF.MaintankTarget.Texts.PowerMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankTarget PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerMissing.Outline,
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankTarget.Texts.PowerMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankTarget.Texts.PowerMissing.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1target.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankTarget.Texts.PowerMissing.Font),db.oUF.MaintankTarget.Texts.PowerMissing.Size,db.oUF.MaintankTarget.Texts.PowerMissing.Outline)
												end,
											order = 6,
										},
										PowerMissingX = {
											name = "X Value",
											desc = "X Value for your MaintankTarget PowerMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerMissing.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.X end,
											set = function(self,PowerMissingX)
														if PowerMissingX == nil or PowerMissingX == "" then
															PowerMissingX = "0"
														end
														db.oUF.MaintankTarget.Texts.PowerMissing.X = PowerMissingX
														oUF_LUI_maintankUnitButton1target.Power.valueMissing:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Power.valueMissing:SetPoint(db.oUF.MaintankTarget.Texts.PowerMissing.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.X), tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.Y))
													end,
											order = 7,
										},
										PowerMissingY = {
											name = "Y Value",
											desc = "Y Value for your MaintankTarget PowerMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.Y end,
											set = function(self,PowerMissingY)
														if PowerMissingY == nil or PowerMissingY == "" then
															PowerMissingY = "0"
														end
														db.oUF.MaintankTarget.Texts.PowerMissing.Y = PowerMissingY
														oUF_LUI_maintankUnitButton1target.Power.valueMissing:ClearAllPoints()
														oUF_LUI_maintankUnitButton1target.Power.valueMissing:SetPoint(db.oUF.MaintankTarget.Texts.PowerMissing.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.X), tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankTarget PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.PowerMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankTarget.Texts.PowerMissing.Point = positions[Point]
													oUF_LUI_maintankUnitButton1target.Power.valueMissing:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Power.valueMissing:SetPoint(db.oUF.MaintankTarget.Texts.PowerMissing.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.X), tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankTarget PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Texts.PowerMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankTarget.Texts.PowerMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankTarget.Texts.PowerMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1target.Power.valueMissing:ClearAllPoints()
													oUF_LUI_maintankUnitButton1target.Power.valueMissing:SetPoint(db.oUF.MaintankTarget.Texts.PowerMissing.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.X), tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankTarget.Texts.PowerMissing.ColorClass = true
														db.oUF.MaintankTarget.Texts.PowerMissing.ColorType = false
														db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorClass = true
														oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorType = false
														oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorIndividual.Enable = false

														print("MaintankTarget PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.ColorType end,
											set = function(self,ColorType)
														db.oUF.MaintankTarget.Texts.PowerMissing.ColorType = true
														db.oUF.MaintankTarget.Texts.PowerMissing.ColorClass = false
														db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorType = true
														oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorClass = false
														oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorIndividual.Enable = false
		
														print("MaintankTarget PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankTarget PowerMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.Enable = true
														db.oUF.MaintankTarget.Texts.PowerMissing.ColorClass = false
														db.oUF.MaintankTarget.Texts.PowerMissing.ColorType = false
															
														oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorClass = false
														oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorType = false
		
														oUF_LUI_maintankUnitButton1target.Power.valueMissing:SetTextColor(tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.r),tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.g),tonumber(db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankTarget PowerMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.Enable or not db.oUF.MaintankTarget.Texts.PowerMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.r, db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.g, db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.r = r
													db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.g = g
													db.oUF.MaintankTarget.Texts.PowerMissing.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1target.Power.valueMissing.colorIndividual.b = b
													
													oUF_LUI_maintankUnitButton1target.Power.valueMissing:SetTextColor(r,g,b)
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
					disabled = function() return not db.oUF.MaintankTarget.Enable end,
					args = {
						header1 = {
							name = "MaintankTarget Auras",
							type = "header",
							order = 1,
						},
						MaintankTargetBuffs = {
							name = "Buffs",
							type = "group",
							order = 2,
							args = {
								MaintankTargetBuffsEnable = {
									name = "Enable MaintankTarget Buffs",
									desc = "Wether you want to show MaintankTarget Buffs or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankTarget.Aura.buffs_enable end,
									set = function(self,MaintankTargetBuffsEnable)
												db.oUF.MaintankTarget.Aura.buffs_enable = not db.oUF.MaintankTarget.Aura.buffs_enable 
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 0,
								},
								MaintankTargetBuffsAuratimer = {
									name = "Enable Auratimer",
									desc = "Wether you want to show Auratimers or not.",
									type = "toggle",
									disabled = function() return not db.oUF.MaintankTarget.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.buffs_auratimer end,
									set = function(self,MaintankTargetBuffsAuratimer)
												db.oUF.MaintankTarget.Aura.buffs_auratimer = not db.oUF.MaintankTarget.Aura.buffs_auratimer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								MaintankTargetBuffsNum = {
									name = "Amount",
									desc = "Amount of your MaintankTarget Buffs.\nDefault: 8",
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.buffs_num end,
									set = function(self,MaintankTargetBuffsNum)
												if MaintankTargetBuffsNum == nil or MaintankTargetBuffsNum == "" then
													MaintankTargetBuffsNum = "0"
												end
												db.oUF.MaintankTarget.Aura.buffs_num = MaintankTargetBuffsNum
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								MaintankTargetBuffsSize = {
									name = "Size",
									desc = "Size for your MaintankTarget Buffs.\nDefault: 18",
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.buffs_size end,
									set = function(self,MaintankTargetBuffsSize)
												if MaintankTargetBuffsSize == nil or MaintankTargetBuffsSize == "" then
													MaintankTargetBuffsSize = "0"
												end
												db.oUF.MaintankTarget.Aura.buffs_size = MaintankTargetBuffsSize
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
								MaintankTargetBuffsSpacing = {
									name = "Spacing",
									desc = "Spacing between your MaintankTarget Buffs.\nDefault: 2",
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.buffs_spacing end,
									set = function(self,MaintankTargetBuffsSpacing)
												if MaintankTargetBuffsSpacing == nil or MaintankTargetBuffsSpacing == "" then
													MaintankTargetBuffsSpacing = "0"
												end
												db.oUF.MaintankTarget.Aura.buffs_spacing = MaintankTargetBuffsSpacing
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 5,
								},
								MaintankTargetBuffsX = {
									name = "X Value",
									desc = "X Value for your MaintankTarget Buffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.buffsX end,
									set = function(self,MaintankTargetBuffsX)
												if MaintankTargetBuffsX == nil or MaintankTargetBuffsX == "" then
													MaintankTargetBuffsX = "0"
												end
												db.oUF.MaintankTarget.Aura.buffsX = MaintankTargetBuffsX
												oUF_LUI_maintankUnitButton1target.buffs:SetPoint(db.oUF.MaintankTarget.Aura.buffs_initialAnchor, oUF_LUI_maintankUnitButton1target.Health, db.oUF.MaintankTarget.Aura.buffs_initialAnchor, MaintankTargetBuffsX, db.oUF.MaintankTarget.Aura.buffsY)
											end,
									order = 6,
								},
								MaintankTargetBuffsY = {
									name = "Y Value",
									desc = "Y Value for your MaintankTarget Buffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.buffsY end,
									set = function(self,MaintankTargetBuffsY)
												if MaintankTargetBuffsY == nil or MaintankTargetBuffsY == "" then
													MaintankTargetBuffsY = "0"
												end
												db.oUF.MaintankTarget.Aura.buffsY = MaintankTargetBuffsY
												oUF_LUI_maintankUnitButton1target.buffs:SetPoint(db.oUF.MaintankTarget.Aura.buffs_initialAnchor, oUF_LUI_maintankUnitButton1target.Health, db.oUF.MaintankTarget.Aura.buffs_initialAnchor, db.oUF.MaintankTarget.Aura.buffsX, MaintankTargetBuffsY)
											end,
									order = 7,
								},
								MaintankTargetBuffsGrowthY = {
									name = "Growth Y",
									desc = "Choose the growth Y direction for your MaintankTarget Buffs.\nDefault: UP",
									type = "select",
									disabled = function() return not db.oUF.MaintankTarget.Aura.buffs_enable end,
									values = growthY,
									get = function()
											for k, v in pairs(growthY) do
												if db.oUF.MaintankTarget.Aura.buffs_growthY == v then
													return k
												end
											end
										end,
									set = function(self, MaintankTargetBuffsGrowthY)
											db.oUF.MaintankTarget.Aura.buffs_growthY = growthY[MaintankTargetBuffsGrowthY]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 8,
								},
								MaintankTargetBuffsGrowthX = {
									name = "Growth X",
									desc = "Choose the growth X direction for your MaintankTarget Buffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.MaintankTarget.Aura.buffs_enable end,
									values = growthX,
									get = function()
											for k, v in pairs(growthX) do
												if db.oUF.MaintankTarget.Aura.buffs_growthX == v then
													return k
												end
											end
										end,
									set = function(self, MaintankTargetBuffsGrowthX)
											db.oUF.MaintankTarget.Aura.buffs_growthX = growthX[MaintankTargetBuffsGrowthX]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 9,
								},
								MaintankTargetBuffsAnchor = {
									name = "Initial Anchor",
									desc = "Choose the initinal Anchor for your MaintankTarget Buffs.\nDefault: LEFT",
									type = "select",
									disabled = function() return not db.oUF.MaintankTarget.Aura.buffs_enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.MaintankTarget.Aura.buffs_initialAnchor == v then
													return k
												end
											end
										end,
									set = function(self, MaintankTargetBuffsAnchor)
											db.oUF.MaintankTarget.Aura.buffs_initialAnchor = positions[MaintankTargetBuffsAnchor]
											oUF_LUI_maintankUnitButton1target.buffs:SetPoint(positions[MaintankTargetBuffsAnchor], oUF_LUI_maintankUnitButton1target.Health, positions[MaintankTargetBuffsAnchor], db.oUF.MaintankTarget.Aura.buffsX, db.oUF.MaintankTarget.Aura.buffsY)
										end,
									order = 10,
								},
							},
						},
						MaintankTargetDebuffs = {
							name = "Debuffs",
							type = "group",
							order = 3,
							args = {
								MaintankTargetDebuffsEnable = {
									name = "Enable MaintankTarget Debuffs",
									desc = "Wether you want to show MaintankTarget Debuffs or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankTarget.Aura.debuffs_enable end,
									set = function(self,MaintankTargetDebuffsEnable)
												db.oUF.MaintankTarget.Aura.debuffs_enable = not db.oUF.MaintankTarget.Aura.debuffs_enable 
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 0,
								},
								MaintankTargetDebuffsAuratimer = {
									name = "Enable Auratimer",
									desc = "Wether you want to show Auratimers or not.\nDefault: Off",
									type = "toggle",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.debuffs_auratimer end,
									set = function(self,MaintankTargetDebuffsAuratimer)
												db.oUF.MaintankTarget.Aura.debuffs_auratimer = not db.oUF.MaintankTarget.Aura.debuffs_auratimer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								MaintankTargetDebuffsPlayerBuffsOnly = {
									name = "Player Debuffs Only",
									desc = "Wether you want to show only your Debuffs on MaintankTargetmembers or not.",
									type = "toggle",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.debuffs_playeronly end,
									set = function(self,MaintankTargetBuffsPlayerBuffsOnly)
												db.oUF.MaintankTarget.Aura.debuffs_playeronly = not db.oUF.MaintankTarget.Aura.debuffs_playeronly
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 2,
								},
								MaintankTargetDebuffsColorByType = {
									name = "Color by Type",
									desc = "Wether you want to color MaintankTarget Debuffs by Type or not.",
									type = "toggle",
									width = "full",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.debuffs_colorbytype end,
									set = function(self,MaintankTargetDebuffsColorByType)
												db.oUF.MaintankTarget.Aura.debuffs_colorbytype = not db.oUF.MaintankTarget.Aura.debuffs_colorbytype
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								MaintankTargetDebuffsNum = {
									name = "Amount",
									desc = "Amount of your MaintankTarget Debuffs.\nDefault: 8",
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.debuffs_num end,
									set = function(self,MaintankTargetDebuffsNum)
												if MaintankTargetDebuffsNum == nil or MaintankTargetDebuffsNum == "" then
													MaintankTargetDebuffsNum = "0"
												end
												db.oUF.MaintankTarget.Aura.debuffs_num = MaintankTargetDebuffsNum
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
								MaintankTargetDebuffsSize = {
									name = "Size",
									desc = "Size for your MaintankTarget Debuffs.\nDefault: 18",
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.debuffs_size end,
									set = function(self,MaintankTargetDebuffsSize)
												if MaintankTargetDebuffsSize == nil or MaintankTargetDebuffsSize == "" then
													MaintankTargetDebuffsSize = "0"
												end
												db.oUF.MaintankTarget.Aura.debuffs_size = MaintankTargetDebuffsSize
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 5,
								},
								MaintankTargetDebuffsSpacing = {
									name = "Spacing",
									desc = "Spacing between your MaintankTarget Debuffs.\nDefault: 2",
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.debuffs_spacing end,
									set = function(self,MaintankTargetDebuffsSpacing)
												if MaintankTargetDebuffsSpacing == nil or MaintankTargetDebuffsSpacing == "" then
													MaintankTargetDebuffsSpacing = "0"
												end
												db.oUF.MaintankTarget.Aura.debuffs_spacing = MaintankTargetDebuffsSpacing
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 6,
								},
								MaintankTargetDebuffsX = {
									name = "X Value",
									desc = "X Value for your MaintankTarget Debuffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.debuffsX end,
									set = function(self,MaintankTargetDebuffsX)
												if MaintankTargetDebuffsX == nil or MaintankTargetDebuffsX == "" then
													MaintankTargetDebuffsX = "0"
												end
												db.oUF.MaintankTarget.Aura.debuffsX = MaintankTargetDebuffsX
												oUF_LUI_maintankUnitButton1target.debuffs:SetPoint(db.oUF.MaintankTarget.Aura.debuffs_initialAnchor, oUF_LUI_maintankUnitButton1target.Health, db.oUF.MaintankTarget.Aura.debuffs_initialAnchor, MaintankTargetDebuffsX, db.oUF.MaintankTarget.Aura.debuffsY)
											end,
									order = 7,
								},
								MaintankTargetDebuffsY = {
									name = "Y Value",
									desc = "Y Value for your MaintankTarget Debuffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankTarget.Aura.debuffsY end,
									set = function(self,MaintankTargetDebuffsY)
												if MaintankTargetDebuffsY == nil or MaintankTargetDebuffsY == "" then
													MaintankTargetDebuffsY = "0"
												end
												db.oUF.MaintankTarget.Aura.debuffsY = MaintankTargetDebuffsY
												oUF_LUI_maintankUnitButton1target.debuffs:SetPoint(db.oUF.MaintankTarget.Aura.debuffs_initialAnchor, oUF_LUI_maintankUnitButton1target.Health, db.oUF.MaintankTarget.Aura.debuffs_initialAnchor, db.oUF.MaintankTarget.Aura.debuffsX, MaintankTargetDebuffsY)
											end,
									order = 8,
								},
								MaintankTargetDebuffsGrowthY = {
									name = "Growth Y",
									desc = "Choose the growth Y direction for your MaintankTarget Debuffs.\nDefault: UP",
									type = "select",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									values = growthY,
									get = function()
											for k, v in pairs(growthY) do
												if db.oUF.MaintankTarget.Aura.debuffs_growthY == v then
													return k
												end
											end
										end,
									set = function(self, MaintankTargetDebuffsGrowthY)
											db.oUF.MaintankTarget.Aura.debuffs_growthY = growthY[MaintankTargetDebuffsGrowthY]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 9,
								},
								MaintankTargetDebuffsGrowthX = {
									name = "Growth X",
									desc = "Choose the growth X direction for your MaintankTarget Debuffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									values = growthX,
									get = function()
											for k, v in pairs(growthX) do
												if db.oUF.MaintankTarget.Aura.debuffs_growthX == v then
													return k
												end
											end
										end,
									set = function(self, MaintankTargetDebuffsGrowthX)
											db.oUF.MaintankTarget.Aura.debuffs_growthX = growthX[MaintankTargetDebuffsGrowthX]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 10,
								},
								MaintankTargetDebuffsAnchor = {
									name = "Initial Anchor",
									desc = "Choose the initinal Anchor for your MaintankTarget Debuffs.\nDefault: LEFT",
									type = "select",
									disabled = function() return not db.oUF.MaintankTarget.Aura.debuffs_enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.MaintankTarget.Aura.debuffs_initialAnchor == v then
													return k
												end
											end
										end,
									set = function(self, MaintankTargetDebuffsAnchor)
											db.oUF.MaintankTarget.Aura.debuffs_initialAnchor = positions[MaintankTargetDebuffsAnchor]
											oUF_LUI_maintankUnitButton1target.debuffs:SetPoint(positions[MaintankTargetDebuffsAnchor], oUF_LUI_maintankUnitButton1target.Health, positions[MaintankTargetDebuffsAnchor], db.oUF.MaintankTarget.Aura.debuffsX, db.oUF.MaintankTarget.Aura.debuffsY)
										end,
									order = 11,
								},
							},
						},
					},
				},
				Portrait = {
					name = "Portrait",
					disabled = function() return not db.oUF.MaintankTarget.Enable end,
					type = "group",
					order = 8,
					args = {
						EnablePortrait = {
							name = "Enable",
							desc = "Wether you want to show the Portrait or not.",
							type = "toggle",
							width = "full",
							get = function() return db.oUF.MaintankTarget.Portrait.Enable end,
							set = function(self,EnablePortrait)
										db.oUF.MaintankTarget.Portrait.Enable = not db.oUF.MaintankTarget.Portrait.Enable
										StaticPopup_Show("RELOAD_UI")
									end,
							order = 1,
						},
						PortraitWidth = {
							name = "Width",
							desc = "Choose the Width for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.MaintankTarget.Portrait.Enable end,
							get = function() return db.oUF.MaintankTarget.Portrait.Width end,
							set = function(self,PortraitWidth)
										if PortraitWidth == nil or PortraitWidth == "" then
											PortraitWidth = "0"
										end
										db.oUF.MaintankTarget.Portrait.Width = PortraitWidth
										oUF_LUI_maintankUnitButton1target.Portrait:SetWidth(tonumber(PortraitWidth))
									end,
							order = 2,
						},
						PortraitHeight = {
							name = "Height",
							desc = "Choose the Height for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.MaintankTarget.Portrait.Enable end,
							get = function() return db.oUF.MaintankTarget.Portrait.Height end,
							set = function(self,PortraitHeight)
										if PortraitHeight == nil or PortraitHeight == "" then
											PortraitHeight = "0"
										end
										db.oUF.MaintankTarget.Portrait.Height = PortraitHeight
										oUF_LUI_maintankUnitButton1target.Portrait:SetHeight(tonumber(PortraitHeight))
									end,
							order = 3,
						},
						PortraitX = {
							name = "X Value",
							desc = "X Value for your Portrait.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Portrait.X,
							type = "input",
							disabled = function() return not db.oUF.MaintankTarget.Portrait.Enable end,
							get = function() return db.oUF.MaintankTarget.Portrait.X end,
							set = function(self,PortraitX)
										if PortraitX == nil or PortraitX == "" then
											PortraitX = "0"
										end
										db.oUF.MaintankTarget.Portrait.X = PortraitX
										oUF_LUI_maintankUnitButton1target.Portrait:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1target.Health, "TOPLEFT", PortraitX, db.oUF.MaintankTarget.Portrait.Y)
									end,
							order = 4,
						},
						PortraitY = {
							name = "Y Value",
							desc = "Y Value for your Portrait.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Portrait.Y,
							type = "input",
							disabled = function() return not db.oUF.MaintankTarget.Portrait.Enable end,
							get = function() return db.oUF.MaintankTarget.Portrait.Y end,
							set = function(self,PortraitY)
										if PortraitY == nil or PortraitY == "" then
											PortraitY = "0"
										end
										db.oUF.MaintankTarget.Portrait.Y = PortraitY
										oUF_LUI_maintankUnitButton1target.Portrait:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1target.Health, "TOPLEFT", db.oUF.MaintankTarget.Portrait.X, PortraitY)
									end,
							order = 5,
						},
					},
				},
				Icons = {
					name = "Icons",
					type = "group",
					disabled = function() return not db.oUF.MaintankTarget.Enable end,
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
									get = function() return db.oUF.MaintankTarget.Icons.Raid.Enable end,
									set = function(self,RaidEnable)
												db.oUF.MaintankTarget.Icons.Raid.Enable = not db.oUF.MaintankTarget.Icons.Raid.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								RaidX = {
									name = "X Value",
									desc = "X Value for your Raid Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Icons.Raid.X,
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Icons.Raid.Enable end,
									get = function() return db.oUF.MaintankTarget.Icons.Raid.X end,
									set = function(self,RaidX)
												if RaidX == nil or RaidX == "" then
													RaidX = "0"
												end

												db.oUF.MaintankTarget.Icons.Raid.X = RaidX
												oUF_LUI_maintankUnitButton1target.RaidIcon:ClearAllPoints()
												oUF_LUI_maintankUnitButton1target.RaidIcon:SetPoint(db.oUF.MaintankTarget.Icons.Raid.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Icons.Raid.Point, tonumber(RaidX), tonumber(db.oUF.MaintankTarget.Icons.Raid.Y))
											end,
									order = 2,
								},
								RaidY = {
									name = "Y Value",
									desc = "Y Value for your Raid Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Icons.Raid.Y,
									type = "input",
									disabled = function() return not db.oUF.MaintankTarget.Icons.Raid.Enable end,
									get = function() return db.oUF.MaintankTarget.Icons.Raid.Y end,
									set = function(self,RaidY)
												if RaidY == nil or RaidY == "" then
													RaidY = "0"
												end
												db.oUF.MaintankTarget.Icons.Raid.Y = RaidY
												oUF_LUI_maintankUnitButton1target.RaidIcon:ClearAllPoints()
												oUF_LUI_maintankUnitButton1target.RaidIcon:SetPoint(db.oUF.MaintankTarget.Icons.Raid.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Icons.Raid.Point, tonumber(db.oUF.MaintankTarget.Icons.Raid.X), tonumber(RaidY))
											end,
									order = 3,
								},
								RaidPoint = {
									name = "Position",
									desc = "Choose the Position for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Icons.Raid.Point,
									type = "select",
									disabled = function() return not db.oUF.MaintankTarget.Icons.Raid.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.MaintankTarget.Icons.Raid.Point == v then
													return k
												end
											end
										end,
									set = function(self, RaidPoint)
											db.oUF.MaintankTarget.Icons.Raid.Point = positions[RaidPoint]
											oUF_LUI_maintankUnitButton1target.RaidIcon:ClearAllPoints()
											oUF_LUI_maintankUnitButton1target.RaidIcon:SetPoint(db.oUF.MaintankTarget.Icons.Raid.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankTarget.Icons.Raid.Point, tonumber(db.oUF.MaintankTarget.Icons.Raid.X), tonumber(db.oUF.MaintankTarget.Icons.Raid.Y))
										end,
									order = 4,
								},
								RaidSize = {
									name = "Size",
									desc = "Choose a Size for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.MaintankTarget.Icons.Raid.Size,
									type = "range",
									min = 5,
									max = 200,
									step = 5,
									disabled = function() return not db.oUF.MaintankTarget.Icons.Raid.Enable end,
									get = function() return db.oUF.MaintankTarget.Icons.Raid.Size end,
									set = function(_, RaidSize) 
											db.oUF.MaintankTarget.Icons.Raid.Size = RaidSize
											oUF_LUI_maintankUnitButton1target.RaidIcon:SetHeight(RaidSize)
											oUF_LUI_maintankUnitButton1target.RaidIcon:SetWidth(RaidSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.MaintankTarget.Icons.Raid.Enable end,
									desc = "Toggles the RaidIcon",
									type = 'execute',
									func = function() if oUF_LUI_maintankUnitButton1target.RaidIcon:IsShown() then oUF_LUI_maintankUnitButton1target.RaidIcon:Hide() else oUF_LUI_maintankUnitButton1target.RaidIcon:Show() end end
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
