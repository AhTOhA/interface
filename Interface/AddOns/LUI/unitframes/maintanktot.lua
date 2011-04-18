--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: maintanktot.lua
	Description: oUF Maintank ToT Module
	Version....: 1.0
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local module = LUI:NewModule("oUF_MaintankToT")
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
	MaintankToT = {
		Enable = true,
		Height = "24",
		Width = "130",
		X = "-146",
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
		MaintankToT = {
			name = "Maintank ToT",
			type = "group",
			disabled = function() return not db.oUF.Settings.Enable or not db.oUF.Maintank.Enable end,
			order = 40,
			childGroups = "tab",
			args = {
				header1 = {
					name = "Maintank ToT",
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
									desc = "Wether you want to use a Maintank ToT Frame or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankToT.Enable end,
									set = function(self,Enable)
												db.oUF.MaintankToT.Enable = not db.oUF.MaintankToT.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
							},
						},
						Positioning = {
							name = "Positioning",
							type = "group",
							disabled = function() return not db.oUF.MaintankToT.Enable end,
							order = 1,
							args = {
								header1 = {
									name = "Frame Position",
									type = "header",
									order = 1,
								},
								MaintankToTX = {
									name = "X Value",
									desc = "X Value for your Maintank ToT Frame.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.X,
									type = "input",
									get = function() return db.oUF.MaintankToT.X end,
									set = function(self,MaintankToTX)
												if MaintankToTX == nil or MaintankToTX == "" then
													MaintankToTX = "0"
												end
												db.oUF.MaintankToT.X = MaintankToTX
												oUF_LUI_maintankUnitButton1targettarget:ClearAllPoints()
												oUF_LUI_maintankUnitButton1targettarget:SetPoint(db.oUF.MaintankToT.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankToT.RelativePoint, tonumber(MaintankToTX), tonumber(db.oUF.MaintankToT.Y))
											end,
									order = 2,
								},
								MaintankToTY = {
									name = "Y Value",
									desc = "Y Value for your Maintank ToT Frame.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Y,
									type = "input",
									get = function() return db.oUF.MaintankToT.Y end,
									set = function(self,MaintankToTY)
												if MaintankToTY == nil or MaintankToTY == "" then
													MaintankToTY = "0"
												end
												db.oUF.MaintankToT.Y = MaintankToTY
												oUF_LUI_maintankUnitButton1targettarget:ClearAllPoints()
												oUF_LUI_maintankUnitButton1targettarget:SetPoint(db.oUF.MaintankToT.Point, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankToT.RelativePoint, tonumber(db.oUF.MaintankToT.X), tonumber(MaintankToTY))
											end,
									order = 3,
								},
								MaintankToTPoint = {
									name = "Point",
									desc = "Choose the Point for your Maintank ToT Frame.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Point,
									type = "select",
											values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.MaintankToT.Point == v then
													return k
												end
											end
										end,
									set = function(self, MaintankToTPoint)
											db.oUF.MaintankToT.Point = positions[MaintankToTPoint]
											oUF_LUI_maintankUnitButton1targettarget:ClearAllPoints()
											oUF_LUI_maintankUnitButton1targettarget:SetPoint(MaintankToTPoint, oUF_LUI_maintankUnitButton1target, db.oUF.MaintankToT.RelativePoint, tonumber(db.oUF.MaintankToT.X), tonumber(db.oUF.MaintankToT.Y))
										end,
									order = 4,
								},
								MaintankToTRelativePoint = {
									name = "RelativePoint",
									desc = "Choose the RelativePoint for your Maintank ToT Frame.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.RelativePoint,
									type = "select",
											values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.MaintankToT.RelativePoint == v then
													return k
												end
											end
										end,
									set = function(self, MaintankToTRelativePoint)
											db.oUF.MaintankToT.RelativePoint = positions[MaintankToTRelativePoint]
											oUF_LUI_maintankUnitButton1targettarget:ClearAllPoints()
											oUF_LUI_maintankUnitButton1targettarget:SetPoint(db.oUF.MaintankToT.Point, oUF_LUI_maintankUnitButton1target, MaintankToTRelativePoint, tonumber(db.oUF.MaintankToT.X), tonumber(db.oUF.MaintankToT.Y))
										end,
									order = 5,
								},
							},
						},
						Size = {
							name = "Size",
							type = "group",
							disabled = function() return not db.oUF.MaintankToT.Enable end,
							order = 2,
							args = {
								header1 = {
									name = "Frame Height/Width",
									type = "header",
									order = 1,
								},
								MaintankToTHeight = {
									name = "Height",
									desc = "Decide the Height of your Maintank ToT Frame.\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Height,
									type = "input",
									get = function() return db.oUF.MaintankToT.Height end,
									set = function(self,MaintankToTHeight)
												if MaintankToTHeight == nil or MaintankToTHeight == "" then
													MaintankToTHeight = "0"
												end
												db.oUF.MaintankToT.Height = MaintankToTHeight
												oUF_LUI_maintankUnitButton1targettarget:SetHeight(tonumber(MaintankToTHeight))
											end,
									order = 2,
								},
								MaintankToTWidth = {
									name = "Width",
									desc = "Decide the Width of your Maintank ToT Frame.\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Width,
									type = "input",
									get = function() return db.oUF.MaintankToT.Width end,
									set = function(self,MaintankToTWidth)
												if MaintankToTWidth == nil or MaintankToTWidth == "" then
													MaintankToTWidth = "0"
												end
												db.oUF.MaintankToT.Width = MaintankToTWidth
												oUF_LUI_maintankUnitButton1targettarget:SetWidth(tonumber(MaintankToTWidth))
												
												if db.oUF.MaintankToT.Aura.buffs_enable == true then
													oUF_LUI_maintankUnitButton1targettarget.Buffs:SetWidth(tonumber(MaintankToTWidth))
												end
												
												if db.oUF.MaintankToT.Aura.debuffs_enable == true then
													oUF_LUI_maintankUnitButton1targettarget.Debuffs:SetWidth(tonumber(MaintankToTWidth))
												end
											end,
									order = 3,
								},
							},
						},
						Appearance = {
							name = "Appearance",
							type = "group",
							disabled = function() return not db.oUF.MaintankToT.Enable end,
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
									get = function() return db.oUF.MaintankToT.Backdrop.Color.r, db.oUF.MaintankToT.Backdrop.Color.g, db.oUF.MaintankToT.Backdrop.Color.b, db.oUF.MaintankToT.Backdrop.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.MaintankToT.Backdrop.Color.r = r
											db.oUF.MaintankToT.Backdrop.Color.g = g
											db.oUF.MaintankToT.Backdrop.Color.b = b
											db.oUF.MaintankToT.Backdrop.Color.a = a

											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropColor(r,g,b,a)
										end,
									order = 2,
								},
								BackdropBorderColor = {
									name = "Border Color",
									desc = "Choose a Backdrop Border Color.",
									type = "color",
									width = "full",
									hasAlpha = true,
									get = function() return db.oUF.MaintankToT.Border.Color.r, db.oUF.MaintankToT.Border.Color.g, db.oUF.MaintankToT.Border.Color.b, db.oUF.MaintankToT.Border.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.MaintankToT.Border.Color.r = r
											db.oUF.MaintankToT.Border.Color.g = g
											db.oUF.MaintankToT.Border.Color.b = b
											db.oUF.MaintankToT.Border.Color.a = a
											
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankToT.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankToT.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankToT.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankToT.Border.Insets.Left), right = tonumber(db.oUF.MaintankToT.Border.Insets.Right), top = tonumber(db.oUF.MaintankToT.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankToT.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankToT.Backdrop.Color.r), tonumber(db.oUF.MaintankToT.Backdrop.Color.g), tonumber(db.oUF.MaintankToT.Backdrop.Color.b), tonumber(db.oUF.MaintankToT.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankToT.Border.Color.r), tonumber(db.oUF.MaintankToT.Border.Color.g), tonumber(db.oUF.MaintankToT.Border.Color.b), tonumber(db.oUF.MaintankToT.Border.Color.a))
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
									desc = "Choose your Backdrop Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Backdrop.Texture,
									type = "select",
									dialogControl = "LSM30_Background",
									values = widgetLists.background,
									get = function() return db.oUF.MaintankToT.Backdrop.Texture end,
									set = function(self, BackdropTexture)
											db.oUF.MaintankToT.Backdrop.Texture = BackdropTexture
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankToT.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankToT.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankToT.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankToT.Border.Insets.Left), right = tonumber(db.oUF.MaintankToT.Border.Insets.Right), top = tonumber(db.oUF.MaintankToT.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankToT.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankToT.Backdrop.Color.r), tonumber(db.oUF.MaintankToT.Backdrop.Color.g), tonumber(db.oUF.MaintankToT.Backdrop.Color.b), tonumber(db.oUF.MaintankToT.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankToT.Border.Color.r), tonumber(db.oUF.MaintankToT.Border.Color.g), tonumber(db.oUF.MaintankToT.Border.Color.b), tonumber(db.oUF.MaintankToT.Border.Color.a))
										end,
									order = 5,
								},
								BorderTexture = {
									name = "Border Texture",
									desc = "Choose your Border Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Border.EdgeFile,
									type = "select",
									dialogControl = "LSM30_Border",
									values = widgetLists.border,
									get = function() return db.oUF.MaintankToT.Border.EdgeFile end,
									set = function(self, BorderTexture)
											db.oUF.MaintankToT.Border.EdgeFile = BorderTexture
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankToT.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankToT.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankToT.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankToT.Border.Insets.Left), right = tonumber(db.oUF.MaintankToT.Border.Insets.Right), top = tonumber(db.oUF.MaintankToT.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankToT.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankToT.Backdrop.Color.r), tonumber(db.oUF.MaintankToT.Backdrop.Color.g), tonumber(db.oUF.MaintankToT.Backdrop.Color.b), tonumber(db.oUF.MaintankToT.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankToT.Border.Color.r), tonumber(db.oUF.MaintankToT.Border.Color.g), tonumber(db.oUF.MaintankToT.Border.Color.b), tonumber(db.oUF.MaintankToT.Border.Color.a))
										end,
									order = 6,
								},
								BorderSize = {
									name = "Edge Size",
									desc = "Choose the Edge Size for your Frame Border.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Border.EdgeSize,
									type = "range",
									min = 1,
									max = 50,
									step = 1,
									get = function() return db.oUF.MaintankToT.Border.EdgeSize end,
									set = function(_, BorderSize) 
											db.oUF.MaintankToT.Border.EdgeSize = BorderSize
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankToT.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankToT.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankToT.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankToT.Border.Insets.Left), right = tonumber(db.oUF.MaintankToT.Border.Insets.Right), top = tonumber(db.oUF.MaintankToT.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankToT.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankToT.Backdrop.Color.r), tonumber(db.oUF.MaintankToT.Backdrop.Color.g), tonumber(db.oUF.MaintankToT.Backdrop.Color.b), tonumber(db.oUF.MaintankToT.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankToT.Border.Color.r), tonumber(db.oUF.MaintankToT.Border.Color.g), tonumber(db.oUF.MaintankToT.Border.Color.b), tonumber(db.oUF.MaintankToT.Border.Color.a))
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
									desc = "Value for the Left Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Backdrop.Padding.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankToT.Backdrop.Padding.Left end,
									set = function(self,PaddingLeft)
										if PaddingLeft == nil or PaddingLeft == "" then
											PaddingLeft = "0"
										end
										db.oUF.MaintankToT.Backdrop.Padding.Left = PaddingLeft
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:ClearAllPoints()
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1targettarget, "TOPLEFT", tonumber(db.oUF.MaintankToT.Backdrop.Padding.Left), tonumber(db.oUF.MaintankToT.Backdrop.Padding.Top))
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_maintankUnitButton1targettarget, "BOTTOMRIGHT", tonumber(db.oUF.MaintankToT.Backdrop.Padding.Right), tonumber(db.oUF.MaintankToT.Backdrop.Padding.Bottom))
									end,
									order = 9,
								},
								PaddingRight = {
									name = "Right",
									desc = "Value for the Right Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Backdrop.Padding.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankToT.Backdrop.Padding.Right end,
									set = function(self,PaddingRight)
										if PaddingRight == nil or PaddingRight == "" then
											PaddingRight = "0"
										end
										db.oUF.MaintankToT.Backdrop.Padding.Right = PaddingRight
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:ClearAllPoints()
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1targettarget, "TOPLEFT", tonumber(db.oUF.MaintankToT.Backdrop.Padding.Left), tonumber(db.oUF.MaintankToT.Backdrop.Padding.Top))
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_maintankUnitButton1targettarget, "BOTTOMRIGHT", tonumber(db.oUF.MaintankToT.Backdrop.Padding.Right), tonumber(db.oUF.MaintankToT.Backdrop.Padding.Bottom))
									end,
									order = 10,
								},
								PaddingTop = {
									name = "Top",
									desc = "Value for the Top Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Backdrop.Padding.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankToT.Backdrop.Padding.Top end,
									set = function(self,PaddingTop)
										if PaddingTop == nil or PaddingTop == "" then
											PaddingTop = "0"
										end
										db.oUF.MaintankToT.Backdrop.Padding.Top = PaddingTop
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:ClearAllPoints()
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1targettarget, "TOPLEFT", tonumber(db.oUF.MaintankToT.Backdrop.Padding.Left), tonumber(db.oUF.MaintankToT.Backdrop.Padding.Top))
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_maintankUnitButton1targettarget, "BOTTOMRIGHT", tonumber(db.oUF.MaintankToT.Backdrop.Padding.Right), tonumber(db.oUF.MaintankToT.Backdrop.Padding.Bottom))
									end,
									order = 11,
								},
								PaddingBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Backdrop.Padding.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankToT.Backdrop.Padding.Bottom end,
									set = function(self,PaddingBottom)
										if PaddingBottom == nil or PaddingBottom == "" then
											PaddingBottom = "0"
										end
										db.oUF.MaintankToT.Backdrop.Padding.Bottom = PaddingBottom
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:ClearAllPoints()
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1targettarget, "TOPLEFT", tonumber(db.oUF.MaintankToT.Backdrop.Padding.Left), tonumber(db.oUF.MaintankToT.Backdrop.Padding.Top))
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_maintankUnitButton1targettarget, "BOTTOMRIGHT", tonumber(db.oUF.MaintankToT.Backdrop.Padding.Right), tonumber(db.oUF.MaintankToT.Backdrop.Padding.Bottom))
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
									desc = "Value for the Left Border Inset\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Border.Insets.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankToT.Border.Insets.Left end,
									set = function(self,InsetLeft)
										if InsetLeft == nil or InsetLeft == "" then
											InsetLeft = "0"
										end
										db.oUF.MaintankToT.Border.Insets.Left = InsetLeft
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankToT.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankToT.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankToT.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankToT.Border.Insets.Left), right = tonumber(db.oUF.MaintankToT.Border.Insets.Right), top = tonumber(db.oUF.MaintankToT.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankToT.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankToT.Backdrop.Color.r), tonumber(db.oUF.MaintankToT.Backdrop.Color.g), tonumber(db.oUF.MaintankToT.Backdrop.Color.b), tonumber(db.oUF.MaintankToT.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankToT.Border.Color.r), tonumber(db.oUF.MaintankToT.Border.Color.g), tonumber(db.oUF.MaintankToT.Border.Color.b), tonumber(db.oUF.MaintankToT.Border.Color.a))
											end,
									order = 14,
								},
								InsetRight = {
									name = "Right",
									desc = "Value for the Right Border Inset\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Border.Insets.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankToT.Border.Insets.Right end,
									set = function(self,InsetRight)
										if InsetRight == nil or InsetRight == "" then
											InsetRight = "0"
										end
										db.oUF.MaintankToT.Border.Insets.Right = InsetRight
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankToT.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankToT.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankToT.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankToT.Border.Insets.Left), right = tonumber(db.oUF.MaintankToT.Border.Insets.Right), top = tonumber(db.oUF.MaintankToT.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankToT.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankToT.Backdrop.Color.r), tonumber(db.oUF.MaintankToT.Backdrop.Color.g), tonumber(db.oUF.MaintankToT.Backdrop.Color.b), tonumber(db.oUF.MaintankToT.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankToT.Border.Color.r), tonumber(db.oUF.MaintankToT.Border.Color.g), tonumber(db.oUF.MaintankToT.Border.Color.b), tonumber(db.oUF.MaintankToT.Border.Color.a))
											end,
									order = 15,
								},
								InsetTop = {
									name = "Top",
									desc = "Value for the Top Border Inset\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Border.Insets.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankToT.Border.Insets.Top end,
									set = function(self,InsetTop)
										if InsetTop == nil or InsetTop == "" then
											InsetTop = "0"
										end
										db.oUF.MaintankToT.Border.Insets.Top = InsetTop
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankToT.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankToT.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankToT.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankToT.Border.Insets.Left), right = tonumber(db.oUF.MaintankToT.Border.Insets.Right), top = tonumber(db.oUF.MaintankToT.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankToT.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankToT.Backdrop.Color.r), tonumber(db.oUF.MaintankToT.Backdrop.Color.g), tonumber(db.oUF.MaintankToT.Backdrop.Color.b), tonumber(db.oUF.MaintankToT.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankToT.Border.Color.r), tonumber(db.oUF.MaintankToT.Border.Color.g), tonumber(db.oUF.MaintankToT.Border.Color.b), tonumber(db.oUF.MaintankToT.Border.Color.a))
											end,
									order = 16,
								},
								InsetBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Border Inset\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Border.Insets.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.MaintankToT.Border.Insets.Bottom end,
									set = function(self,InsetBottom)
										if InsetBottom == nil or InsetBottom == "" then
											InsetBottom = "0"
										end
										db.oUF.MaintankToT.Border.Insets.Bottom = InsetBottom
										oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.MaintankToT.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.MaintankToT.Border.EdgeFile), edgeSize = tonumber(db.oUF.MaintankToT.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.MaintankToT.Border.Insets.Left), right = tonumber(db.oUF.MaintankToT.Border.Insets.Right), top = tonumber(db.oUF.MaintankToT.Border.Insets.Top), bottom = tonumber(db.oUF.MaintankToT.Border.Insets.Bottom)}
											})
											
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.MaintankToT.Backdrop.Color.r), tonumber(db.oUF.MaintankToT.Backdrop.Color.g), tonumber(db.oUF.MaintankToT.Backdrop.Color.b), tonumber(db.oUF.MaintankToT.Backdrop.Color.a))
											oUF_LUI_maintankUnitButton1targettarget.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.MaintankToT.Border.Color.r), tonumber(db.oUF.MaintankToT.Border.Color.g), tonumber(db.oUF.MaintankToT.Border.Color.b), tonumber(db.oUF.MaintankToT.Border.Color.a))
											end,
									order = 17,
								},
							},
						},
						AlphaFader = {
							name = "Fader",
							type = "group",
							disabled = function() return not db.oUF.MaintankToT.Enable end,
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
					disabled = function() return not db.oUF.MaintankToT.Enable end,
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
											desc = "Decide the Height of your Maintank ToT Health.\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Health.Height,
											type = "input",
											get = function() return db.oUF.MaintankToT.Health.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.MaintankToT.Health.Height = Height
														oUF_LUI_maintankUnitButton1targettarget.Health:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Health.Padding,
											type = "input",
											get = function() return db.oUF.MaintankToT.Health.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.MaintankToT.Health.Padding = Padding
														oUF_LUI_maintankUnitButton1targettarget.Health:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Health:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1targettarget, "TOPLEFT", 0, tonumber(Padding))
														oUF_LUI_maintankUnitButton1targettarget.Health:SetPoint("TOPRIGHT", oUF_LUI_maintankUnitButton1targettarget, "TOPRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.MaintankToT.Health.Smooth end,
											set = function(self,Smooth)
														db.oUF.MaintankToT.Health.Smooth = not db.oUF.MaintankToT.Health.Smooth
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
											get = function() return db.oUF.MaintankToT.Health.ColorClass end,
											set = function(self,HealthClassColor)
														db.oUF.MaintankToT.Health.ColorClass = true
														db.oUF.MaintankToT.Health.ColorGradient = false
														db.oUF.MaintankToT.Health.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.colorClass = true
														oUF_LUI_maintankUnitButton1targettarget.Health.colorGradient = false
														oUF_LUI_maintankUnitButton1targettarget.Health.colorIndividual.Enable = false
															
														print("Maintank ToT Healthbar Color will change once you gain/lose HP")
													end,
											order = 1,
										},
										HealthGradientColor = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthBars or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Health.ColorGradient end,
											set = function(self,HealthGradientColor)
														db.oUF.MaintankToT.Health.ColorGradient = true
														db.oUF.MaintankToT.Health.ColorClass = false
														db.oUF.MaintankToT.Health.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.colorGradient = true
														oUF_LUI_maintankUnitButton1targettarget.Health.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Health.colorIndividual.Enable = false
															
														print("Maintank ToT Healthbar Color will change once you gain/lose HP")
													end,
											order = 2,
										},
										IndividualHealthColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual HealthBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Health.IndividualColor.Enable end,
											set = function(self,IndividualHealthColor)
														db.oUF.MaintankToT.Health.IndividualColor.Enable = true
														db.oUF.MaintankToT.Health.ColorClass = false
														db.oUF.MaintankToT.Health.ColorGradient = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1targettarget.Health.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Health.colorGradient = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health:SetStatusBarColor(db.oUF.MaintankToT.Health.IndividualColor.r, db.oUF.MaintankToT.Health.IndividualColor.g, db.oUF.MaintankToT.Health.IndividualColor.b)
														oUF_LUI_maintankUnitButton1targettarget.Health.bg:SetVertexColor(db.oUF.MaintankToT.Health.IndividualColor.r*tonumber(db.oUF.MaintankToT.Health.BGMultiplier), db.oUF.MaintankToT.Health.IndividualColor.g*tonumber(db.oUF.MaintankToT.Health.BGMultiplier), db.oUF.MaintankToT.Health.IndividualColor.b*tonumber(db.oUF.MaintankToT.Health.BGMultiplier))
													end,
											order = 3,
										},
										HealthColor = {
											name = "Individual Color",
											desc = "Choose an individual Healthbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankToT.Health.IndividualColor.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankToT.Health.IndividualColor.r, db.oUF.MaintankToT.Health.IndividualColor.g, db.oUF.MaintankToT.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankToT.Health.IndividualColor.r = r
													db.oUF.MaintankToT.Health.IndividualColor.g = g
													db.oUF.MaintankToT.Health.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Health.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1targettarget.Health.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1targettarget.Health.colorIndividual.b = b
														
													oUF_LUI_maintankUnitButton1targettarget.Health:SetStatusBarColor(r, g, b)
													oUF_LUI_maintankUnitButton1targettarget.Health.bg:SetVertexColor(r*tonumber(db.oUF.MaintankToT.Health.BGMultiplier), g*tonumber(db.oUF.MaintankToT.Health.BGMultiplier), b*tonumber(db.oUF.MaintankToT.Health.BGMultiplier))
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
											desc = "Choose your Health Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Health.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.MaintankToT.Health.Texture
												end,
											set = function(self, HealthTex)
													db.oUF.MaintankToT.Health.Texture = HealthTex
													oUF_LUI_maintankUnitButton1targettarget.Health:SetStatusBarTexture(LSM:Fetch("statusbar", HealthTex))
												end,
											order = 1,
										},
										HealthTexBG = {
											name = "Background Texture",
											desc = "Choose your Health Background Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Health.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.MaintankToT.Health.TextureBG
												end,
											set = function(self, HealthTexBG)
													db.oUF.MaintankToT.Health.TextureBG = HealthTexBG
													oUF_LUI_maintankUnitButton1targettarget.Health.bg:SetTexture(LSM:Fetch("statusbar", HealthTexBG))
												end,
											order = 2,
										},
										HealthTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Health Background.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Health.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.MaintankToT.Health.BGAlpha end,
											set = function(_, HealthTexBGAlpha) 
													db.oUF.MaintankToT.Health.BGAlpha  = HealthTexBGAlpha
													oUF_LUI_maintankUnitButton1targettarget.Health.bg:SetAlpha(tonumber(HealthTexBGAlpha))
												end,
											order = 3,
										},
										HealthTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Health.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.MaintankToT.Health.BGMultiplier end,
											set = function(_, HealthTexBGMultiplier) 
													db.oUF.MaintankToT.Health.BGMultiplier  = HealthTexBGMultiplier
													oUF_LUI_maintankUnitButton1targettarget.Health.bg.multiplier = tonumber(HealthTexBGMultiplier)
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
									get = function() return db.oUF.MaintankToT.Power.Enable end,
									set = function(self,EnablePower)
												db.oUF.MaintankToT.Power.Enable = not db.oUF.MaintankToT.Power.Enable
												if EnablePower == true then
													oUF_LUI_maintankUnitButton1targettarget.Power:Show()
												else
													oUF_LUI_maintankUnitButton1targettarget.Power:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "General Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Power.Enable end,
									guiInline = true,

									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your MaintankToT Power.\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Power.Height,
											type = "input",
											get = function() return db.oUF.MaintankToT.Power.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.MaintankToT.Power.Height = Height
														oUF_LUI_maintankUnitButton1targettarget.Power:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Power.Padding,
											type = "input",
											get = function() return db.oUF.MaintankToT.Power.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.MaintankToT.Power.Padding = Padding
														oUF_LUI_maintankUnitButton1targettarget.Power:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Power:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1targettarget.Health, "BOTTOMLEFT", 0, tonumber(Padding))
														oUF_LUI_maintankUnitButton1targettarget.Power:SetPoint("TOPRIGHT", oUF_LUI_maintankUnitButton1targettarget.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.MaintankToT.Power.Smooth end,
											set = function(self,Smooth)
														db.oUF.MaintankToT.Power.Smooth = not db.oUF.MaintankToT.Power.Smooth
														StaticPopup_Show("RELOAD_UI")
													end,
											order = 3,
										},
									}
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Power.Enable end,
									guiInline = true,
									order = 3,
									args = {
										PowerClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Power.ColorClass end,
											set = function(self,PowerClassColor)
														db.oUF.MaintankToT.Power.ColorClass = true
														db.oUF.MaintankToT.Power.ColorType = false
														db.oUF.MaintankToT.Power.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Power.colorClass = true
														oUF_LUI_maintankUnitButton1targettarget.Power.colorType = false
														oUF_LUI_maintankUnitButton1targettarget.Power.colorIndividual.Enable = false
														
														print("MaintankToT Powerbar Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										PowerColorByType = {
											name = "Color by Type",
											desc = "Wether you want to use Power Type colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Power.ColorType end,
											set = function(self,PowerColorByType)
														db.oUF.MaintankToT.Power.ColorType = true
														db.oUF.MaintankToT.Power.ColorClass = false
														db.oUF.MaintankToT.Power.IndividualColor.Enable = false
																
														oUF_LUI_maintankUnitButton1targettarget.Power.colorType = true
														oUF_LUI_maintankUnitButton1targettarget.Power.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Power.colorIndividual.Enable = false
															
														print("MaintankToT Powerbar Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualPowerColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PowerBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Power.IndividualColor.Enable end,
											set = function(self,IndividualPowerColor)
														db.oUF.MaintankToT.Power.IndividualColor.Enable = true
														db.oUF.MaintankToT.Power.ColorType = false
														db.oUF.MaintankToT.Power.ColorClass = false
																
														oUF_LUI_maintankUnitButton1targettarget.Power.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1targettarget.Power.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Power.colorType = false
															
														oUF_LUI_maintankUnitButton1targettarget.Power:SetStatusBarColor(db.oUF.MaintankToT.Power.IndividualColor.r, db.oUF.MaintankToT.Power.IndividualColor.g, db.oUF.MaintankToT.Power.IndividualColor.b)
														oUF_LUI_maintankUnitButton1targettarget.Power.bg:SetVertexColor(db.oUF.MaintankToT.Power.IndividualColor.r*tonumber(db.oUF.MaintankToT.Power.BGMultiplier), db.oUF.MaintankToT.Power.IndividualColor.g*tonumber(db.oUF.MaintankToT.Power.BGMultiplier), db.oUF.MaintankToT.Power.IndividualColor.b*tonumber(db.oUF.MaintankToT.Power.BGMultiplier))
													end,
											order = 3,
										},
										PowerColor = {
											name = "Individual Color",
											desc = "Choose an individual Powerbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankToT.Power.IndividualColor.Enable or not db.oUF.MaintankToT.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankToT.Power.IndividualColor.r, db.oUF.MaintankToT.Power.IndividualColor.g, db.oUF.MaintankToT.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankToT.Power.IndividualColor.r = r
													db.oUF.MaintankToT.Power.IndividualColor.g = g
													db.oUF.MaintankToT.Power.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Power.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1targettarget.Power.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1targettarget.Power.colorIndividual.b = b
														
													oUF_LUI_maintankUnitButton1targettarget.Power:SetStatusBarColor(r, g, b)
													oUF_LUI_maintankUnitButton1targettarget.Power.bg:SetVertexColor(r*tonumber(db.oUF.MaintankToT.Power.BGMultiplier), g*tonumber(db.oUF.MaintankToT.Power.BGMultiplier), b*tonumber(db.oUF.MaintankToT.Power.BGMultiplier))
												end,
											order = 4,
										},
									},
								},
								Textures = {
									name = "Texture Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Power.Enable end,
									guiInline = true,
									order = 4,
									args = {
										PowerTex = {
											name = "Texture",
											desc = "Choose your Power Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Power.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.MaintankToT.Power.Texture
												end,
											set = function(self, PowerTex)
													db.oUF.MaintankToT.Power.Texture = PowerTex
													oUF_LUI_maintankUnitButton1targettarget.Power:SetStatusBarTexture(LSM:Fetch("statusbar", PowerTex))
												end,
											order = 1,
										},
										PowerTexBG = {
											name = "Background Texture",
											desc = "Choose your Power Background Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Power.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.MaintankToT.Power.TextureBG
												end,

											set = function(self, PowerTexBG)
													db.oUF.MaintankToT.Power.TextureBG = PowerTexBG
													oUF_LUI_maintankUnitButton1targettarget.Power.bg:SetTexture(LSM:Fetch("statusbar", PowerTexBG))
												end,
											order = 2,
										},
										PowerTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Power Background.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Power.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.MaintankToT.Power.BGAlpha end,
											set = function(_, PowerTexBGAlpha) 
													db.oUF.MaintankToT.Power.BGAlpha  = PowerTexBGAlpha
													oUF_LUI_maintankUnitButton1targettarget.Power.bg:SetAlpha(tonumber(PowerTexBGAlpha))
												end,
											order = 3,
										},
										PowerTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Power.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.MaintankToT.Power.BGMultiplier end,
											set = function(_, PowerTexBGMultiplier) 
													db.oUF.MaintankToT.Power.BGMultiplier  = PowerTexBGMultiplier
													oUF_LUI_maintankUnitButton1targettarget.Power.bg.multiplier = tonumber(PowerTexBGMultiplier)
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
									get = function() return db.oUF.MaintankToT.Full.Enable end,
									set = function(self,EnableFullbar)
												db.oUF.MaintankToT.Full.Enable = not db.oUF.MaintankToT.Full.Enable
												if EnableFullbar == true then
													oUF_LUI_maintankUnitButton1targettarget_Full:Show()
												else
													oUF_LUI_maintankUnitButton1targettarget_Full:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Full.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your Fullbar.\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Full.Height,
											type = "input",
											get = function() return db.oUF.MaintankToT.Full.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.MaintankToT.Full.Height = Height
														oUF_LUI_maintankUnitButton1targettarget_Full:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Fullbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Full.Padding,
											type = "input",
											get = function() return db.oUF.MaintankToT.Full.Padding end,
											set = function(self,Padding)
													if Padding == nil or Padding == "" then
														Padding = "0"
													end
													db.oUF.MaintankToT.Full.Padding = Padding
													oUF_LUI_maintankUnitButton1targettarget_Full:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget_Full:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1targettarget.Health, "BOTTOMLEFT", 0, tonumber(Padding))
													oUF_LUI_maintankUnitButton1targettarget_Full:SetPoint("TOPRIGHT", oUF_LUI_maintankUnitButton1targettarget.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
												end,
											order = 2,
										},
										FullTex = {
											name = "Texture",
											desc = "Choose your Fullbar Texture!\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Full.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.MaintankToT.Full.Texture
												end,
											set = function(self, FullTex)
													db.oUF.MaintankToT.Full.Texture = FullTex
													oUF_LUI_maintankUnitButton1targettarget_Full:SetStatusBarTexture(LSM:Fetch("statusbar", FullTex))
												end,
											order = 3,
										},
										FullAlpha = {
											name = "Alpha",
											desc = "Choose the Alpha Value for your Fullbar!\n Default: "..LUI.defaults.profile.oUF.MaintankToT.Full.Alpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.MaintankToT.Full.Alpha end,
											set = function(_, FullAlpha)
													db.oUF.MaintankToT.Full.Alpha = FullAlpha
													oUF_LUI_maintankUnitButton1targettarget_Full:SetAlpha(FullAlpha)
												end,
											order = 4,
										},
										Color = {
											name = "Color",
											desc = "Choose your Fullbar Color.",
											type = "color",
											hasAlpha = true,
											get = function() return db.oUF.MaintankToT.Full.Color.r, db.oUF.MaintankToT.Full.Color.g, db.oUF.MaintankToT.Full.Color.b, db.oUF.MaintankToT.Full.Color.a end,
											set = function(_,r,g,b,a)
													db.oUF.MaintankToT.Full.Color.r = r
													db.oUF.MaintankToT.Full.Color.g = g
													db.oUF.MaintankToT.Full.Color.b = b
													db.oUF.MaintankToT.Full.Color.a = a
													
													oUF_LUI_maintankUnitButton1targettarget_Full:SetStatusBarColor(r, g, b, a)
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
					disabled = function() return not db.oUF.MaintankToT.Enable end,
					order = 6,
					args = {
						Name = {
							name = "Name",
							type = "group",
							order = 1,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the MaintankToT Name or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankToT.Texts.Name.Enable end,
									set = function(self,Enable)
												db.oUF.MaintankToT.Texts.Name.Enable = not db.oUF.MaintankToT.Texts.Name.Enable
												if Enable == true then
													oUF_LUI_maintankUnitButton1targettarget.Info:Show()
												else
													oUF_LUI_maintankUnitButton1targettarget.Info:Hide()
												end
											end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankToT Name Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Name.Size,
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankToT.Texts.Name.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankToT.Texts.Name.Size = FontSize
													oUF_LUI_maintankUnitButton1targettarget.Info:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.Name.Font),db.oUF.MaintankToT.Texts.Name.Size,db.oUF.MaintankToT.Texts.Name.Outline)
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
											desc = "Choose your Font for MaintankToT Name!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Name.Font,
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankToT.Texts.Name.Font end,
											set = function(self, Font)
													db.oUF.MaintankToT.Texts.Name.Font = Font
													oUF_LUI_maintankUnitButton1targettarget.Info:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.Name.Font),db.oUF.MaintankToT.Texts.Name.Size,db.oUF.MaintankToT.Texts.Name.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankToT Name.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Name.Outline,
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankToT.Texts.Name.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankToT.Texts.Name.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1targettarget.Info:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.Name.Font),db.oUF.MaintankToT.Texts.Name.Size,db.oUF.MaintankToT.Texts.Name.Outline)
												end,
											order = 4,
										},
										NameX = {
											name = "X Value",
											desc = "X Value for your MaintankToT Name.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Name.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Name.X end,
											set = function(self,NameX)
														if NameX == nil or NameX == "" then
															NameX = "0"
														end
														db.oUF.MaintankToT.Texts.Name.X = NameX
														oUF_LUI_maintankUnitButton1targettarget.Info:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Info:SetPoint(db.oUF.MaintankToT.Texts.Name.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Name.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Name.X), tonumber(db.oUF.MaintankToT.Texts.Name.Y))
													end,
											order = 5,
										},
										NameY = {
											name = "Y Value",
											desc = "Y Value for your MaintankToT Name.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Name.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Name.Y end,
											set = function(self,NameY)
														if NameY == nil or NameY == "" then
															NameY = "0"
														end
														db.oUF.MaintankToT.Texts.Name.Y = NameY
														oUF_LUI_maintankUnitButton1targettarget.Info:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Info:SetPoint(db.oUF.MaintankToT.Texts.Name.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Name.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Name.X), tonumber(db.oUF.MaintankToT.Texts.Name.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankToT Name.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Name.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.Name.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankToT.Texts.Name.Point = positions[Point]
													oUF_LUI_maintankUnitButton1targettarget.Info:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Info:SetPoint(db.oUF.MaintankToT.Texts.Name.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Name.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Name.X), tonumber(db.oUF.MaintankToT.Texts.Name.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankToT Name.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Name.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.Name.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankToT.Texts.Name.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1targettarget.Info:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Info:SetPoint(db.oUF.MaintankToT.Texts.Name.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Name.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Name.X), tonumber(db.oUF.MaintankToT.Texts.Name.Y))
												end,
											order = 8,
										},
									},
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Format = {
											name = "Format",
											desc = "Choose the Format for your MaintankToT Name.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Name.Format,
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											type = "select",
											width = "full",
											values = nameFormat,

											get = function()
													for k, v in pairs(nameFormat) do
														if db.oUF.MaintankToT.Texts.Name.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.MaintankToT.Texts.Name.Format = nameFormat[Format]
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 1,
										},
										Length = {
											name = "Length",
											desc = "Choose the Length of your MaintankToT Name.\n\nShort = 6 Letters\nMedium = 18 Letters\nLong = 36 Letters\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Name.Length,
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											type = "select",
											values = nameLenghts,
											get = function()
													for k, v in pairs(nameLenghts) do
														if db.oUF.MaintankToT.Texts.Name.Length == v then
															return k
														end
													end
												end,
											set = function(self, Length)
													db.oUF.MaintankToT.Texts.Name.Length = nameLenghts[Length]
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
											desc = "Wether you want to color the MaintankToT Name by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Name.ColorNameByClass end,
											set = function(self,ColorNameByClass)
													db.oUF.MaintankToT.Texts.Name.ColorNameByClass = not db.oUF.MaintankToT.Texts.Name.ColorNameByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 4,
										},
										ColorClassByClass = {
											name = "Color Class by Class",
											desc = "Wether you want to color the MaintankToT Class by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Name.ColorClassByClass end,
											set = function(self,ColorClassByClass)
													db.oUF.MaintankToT.Texts.Name.ColorClassByClass = not db.oUF.MaintankToT.Texts.Name.ColorClassByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 5,
										},
										ColorLevelByDifficulty = {
											name = "Color Level by Difficulty",
											desc = "Wether you want to color the Level by Difficulty or not.",
											type = "toggle",
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Name.ColorLevelByDifficulty end,
											set = function(self,ColorLevelByDifficulty)
													db.oUF.MaintankToT.Texts.Name.ColorLevelByDifficulty = not db.oUF.MaintankToT.Texts.Name.ColorLevelByDifficulty
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 6,
										},
										ShowClassification = {
											name = "Show Classification",
											desc = "Wether you want to show Classifications like Elite, Boss, Rar or not.",
											type = "toggle",
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Name.ShowClassification end,
											set = function(self,ShowClassification)
													db.oUF.MaintankToT.Texts.Name.ShowClassification = not db.oUF.MaintankToT.Texts.Name.ShowClassification
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 7,
										},
										ShortClassification = {
											name = "Enable Short Classification",
											desc = "Wether you want to show short Classifications or not.",
											type = "toggle",
											width = "full",
											disabled = function() return not db.oUF.MaintankToT.Texts.Name.ShowClassification or not db.oUF.MaintankToT.Texts.Name.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Name.ShortClassification end,
											set = function(self,ShortClassification)
													db.oUF.MaintankToT.Texts.Name.ShortClassification = not db.oUF.MaintankToT.Texts.Name.ShortClassification
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
									desc = "Wether you want to show the MaintankToT Health or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankToT.Texts.Health.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankToT.Texts.Health.Enable = not db.oUF.MaintankToT.Texts.Health.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1targettarget.Health.value:Show()
											else
												oUF_LUI_maintankUnitButton1targettarget.Health.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.Health.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankToT Health Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Health.Size,
											disabled = function() return not db.oUF.MaintankToT.Texts.Health.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankToT.Texts.Health.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankToT.Texts.Health.Size = FontSize
													oUF_LUI_maintankUnitButton1targettarget.Health.value:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.Health.Font),db.oUF.MaintankToT.Texts.Health.Size,db.oUF.MaintankToT.Texts.Health.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your MaintankToT Health.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Health.Format,
											disabled = function() return not db.oUF.MaintankToT.Texts.Health.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.MaintankToT.Texts.Health.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.MaintankToT.Texts.Health.Format = valueFormat[Format]
													oUF_LUI_maintankUnitButton1targettarget.Health.value.Format = valueFormat[Format]
													print("MaintankToT Health Value Format will change once you gain/lose Health")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankToT Health!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Health.Font,
											disabled = function() return not db.oUF.MaintankToT.Texts.Health.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankToT.Texts.Health.Font end,
											set = function(self, Font)
													db.oUF.MaintankToT.Texts.Health.Font = Font
													oUF_LUI_maintankUnitButton1targettarget.Health.value:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.Health.Font),db.oUF.MaintankToT.Texts.Health.Size,db.oUF.MaintankToT.Texts.Health.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankToT Health.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Health.Outline,
											disabled = function() return not db.oUF.MaintankToT.Texts.Health.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankToT.Texts.Health.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankToT.Texts.Health.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1targettarget.Health.value:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.Health.Font),db.oUF.MaintankToT.Texts.Health.Size,db.oUF.MaintankToT.Texts.Health.Outline)
												end,
											order = 4,
										},
										HealthX = {
											name = "X Value",
											desc = "X Value for your MaintankToT Health.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Health.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.Health.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Health.X end,
											set = function(self,HealthX)
														if HealthX == nil or HealthX == "" then
															HealthX = "0"
														end
														db.oUF.MaintankToT.Texts.Health.X = HealthX
														oUF_LUI_maintankUnitButton1targettarget.Health.value:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Health.value:SetPoint(db.oUF.MaintankToT.Texts.Health.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Health.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Health.X), tonumber(db.oUF.MaintankToT.Texts.Health.Y))
													end,
											order = 5,
										},
										HealthY = {
											name = "Y Value",
											desc = "Y Value for your MaintankToT Health.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Health.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.Health.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Health.Y end,
											set = function(self,HealthY)
														if HealthY == nil or HealthY == "" then
															HealthY = "0"
														end
														db.oUF.MaintankToT.Texts.Health.Y = HealthY
														oUF_LUI_maintankUnitButton1targettarget.Health.value:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Health.value:SetPoint(db.oUF.MaintankToT.Texts.Health.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Health.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Health.X), tonumber(db.oUF.MaintankToT.Texts.Health.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankToT Health.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Health.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.Health.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankToT.Texts.Health.Point = positions[Point]
													oUF_LUI_maintankUnitButton1targettarget.Health.value:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Health.value:SetPoint(db.oUF.MaintankToT.Texts.Health.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Health.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Health.X), tonumber(db.oUF.MaintankToT.Texts.Health.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankToT Health.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Health.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.Health.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankToT.Texts.Health.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1targettarget.Health.value:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Health.value:SetPoint(db.oUF.MaintankToT.Texts.Health.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Health.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Health.X), tonumber(db.oUF.MaintankToT.Texts.Health.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.Health.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.Health.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankToT.Texts.Health.ColorClass = true
														db.oUF.MaintankToT.Texts.Health.ColorGradient = false
														db.oUF.MaintankToT.Texts.Health.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.value.colorClass = true
														oUF_LUI_maintankUnitButton1targettarget.Health.value.colorGradient = false
														oUF_LUI_maintankUnitButton1targettarget.Health.value.colorIndividual.Enable = false
														
														print("MaintankToT Health Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.Health.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.MaintankToT.Texts.Health.ColorGradient = true
														db.oUF.MaintankToT.Texts.Health.ColorClass = false
														db.oUF.MaintankToT.Texts.Health.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.value.colorGradient = true
														oUF_LUI_maintankUnitButton1targettarget.Health.value.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Health.value.colorIndividual.Enable = false
															
														print("MaintankToT Health Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankToT Health Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.Health.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankToT.Texts.Health.IndividualColor.Enable = true
														db.oUF.MaintankToT.Texts.Health.ColorClass = false
														db.oUF.MaintankToT.Texts.Health.ColorGradient = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.value.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1targettarget.Health.value.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Health.value.colorGradient = false
														
														oUF_LUI_maintankUnitButton1targettarget.Health.value:SetTextColor(tonumber(db.oUF.MaintankToT.Texts.Health.IndividualColor.r),tonumber(db.oUF.MaintankToT.Texts.Health.IndividualColor.g),tonumber(db.oUF.MaintankToT.Texts.Health.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankToT Health Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankToT.Texts.Health.IndividualColor.Enable or not db.oUF.MaintankToT.Texts.Health.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankToT.Texts.Health.IndividualColor.r, db.oUF.MaintankToT.Texts.Health.IndividualColor.g, db.oUF.MaintankToT.Texts.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankToT.Texts.Health.IndividualColor.r = r
													db.oUF.MaintankToT.Texts.Health.IndividualColor.g = g
													db.oUF.MaintankToT.Texts.Health.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Health.value.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1targettarget.Health.value.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1targettarget.Health.value.colorIndividual.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Health.value:SetTextColor(r,g,b)
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
											get = function() return db.oUF.MaintankToT.Texts.Health.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.MaintankToT.Texts.Health.ShowDead = not db.oUF.MaintankToT.Texts.Health.ShowDead
														oUF_LUI_maintankUnitButton1targettarget.Health.value.ShowDead = db.oUF.MaintankToT.Texts.Health.ShowDead
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
									desc = "Wether you want to show the MaintankToT Power or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankToT.Texts.Power.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankToT.Texts.Power.Enable = not db.oUF.MaintankToT.Texts.Power.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1targettarget.Power.value:Show()
											else
												oUF_LUI_maintankUnitButton1targettarget.Power.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.Power.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankToT Power Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Power.Size,
											disabled = function() return not db.oUF.MaintankToT.Texts.Power.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankToT.Texts.Power.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankToT.Texts.Power.Size = FontSize
													oUF_LUI_maintankUnitButton1targettarget.Power.value:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.Power.Font),db.oUF.MaintankToT.Texts.Power.Size,db.oUF.MaintankToT.Texts.Power.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your MaintankToT Power.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Power.Format,
											disabled = function() return not db.oUF.MaintankToT.Texts.Power.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.MaintankToT.Texts.Power.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.MaintankToT.Texts.Power.Format = valueFormat[Format]
													oUF_LUI_maintankUnitButton1targettarget.Power.value.Format = valueFormat[Format]
													print("MaintankToT Power Value Format will change once you gain/lose Power")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankToT Power!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Power.Font,
											disabled = function() return not db.oUF.MaintankToT.Texts.Power.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankToT.Texts.Power.Font end,
											set = function(self, Font)
													db.oUF.MaintankToT.Texts.Power.Font = Font
													oUF_LUI_maintankUnitButton1targettarget.Power.value:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.Power.Font),db.oUF.MaintankToT.Texts.Power.Size,db.oUF.MaintankToT.Texts.Power.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankToT Power.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Power.Outline,
											disabled = function() return not db.oUF.MaintankToT.Texts.Power.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankToT.Texts.Power.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankToT.Texts.Power.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1targettarget.Power.value:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.Power.Font),db.oUF.MaintankToT.Texts.Power.Size,db.oUF.MaintankToT.Texts.Power.Outline)
												end,
											order = 4,
										},
										PowerX = {
											name = "X Value",
											desc = "X Value for your MaintankToT Power.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Power.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.Power.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Power.X end,
											set = function(self,PowerX)
														if PowerX == nil or PowerX == "" then
															PowerX = "0"
														end
														db.oUF.MaintankToT.Texts.Power.X = PowerX
														oUF_LUI_maintankUnitButton1targettarget.Power.value:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Power.value:SetPoint(db.oUF.MaintankToT.Texts.Power.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Power.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Power.X), tonumber(db.oUF.MaintankToT.Texts.Power.Y))
													end,
											order = 5,
										},
										PowerY = {
											name = "Y Value",
											desc = "Y Value for your MaintankToT Power.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Power.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.Power.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.Power.Y end,
											set = function(self,PowerY)
														if PowerY == nil or PowerY == "" then
															PowerY = "0"
														end
														db.oUF.MaintankToT.Texts.Power.Y = PowerY
														oUF_LUI_maintankUnitButton1targettarget.Power.value:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Power.value:SetPoint(db.oUF.MaintankToT.Texts.Power.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Power.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Power.X), tonumber(db.oUF.MaintankToT.Texts.Power.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankToT Power.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Power.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.Power.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankToT.Texts.Power.Point = positions[Point]
													oUF_LUI_maintankUnitButton1targettarget.Power.value:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Power.value:SetPoint(db.oUF.MaintankToT.Texts.Power.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Power.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Power.X), tonumber(db.oUF.MaintankToT.Texts.Power.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankToT Power.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.Power.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.Power.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankToT.Texts.Power.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1targettarget.Power.value:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Power.value:SetPoint(db.oUF.MaintankToT.Texts.Power.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.Power.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.Power.X), tonumber(db.oUF.MaintankToT.Texts.Power.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.Power.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.Power.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankToT.Texts.Power.ColorClass = true
														db.oUF.MaintankToT.Texts.Power.ColorType = false
														db.oUF.MaintankToT.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Power.value.colorClass = true
														oUF_LUI_maintankUnitButton1targettarget.Power.value.colorType = false
														oUF_LUI_maintankUnitButton1targettarget.Power.value.colorIndividual.Enable = false
			
														print("MaintankToT Power Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Powertype colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.Power.ColorType end,
											set = function(self,ColorType)
														db.oUF.MaintankToT.Texts.Power.ColorType = true
														db.oUF.MaintankToT.Texts.Power.ColorClass = false
														db.oUF.MaintankToT.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Power.value.colorType = true
														oUF_LUI_maintankUnitButton1targettarget.Power.value.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Power.value.colorIndividual.Enable = false
		
														print("MaintankToT Power Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankToT Power Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.Power.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankToT.Texts.Power.IndividualColor.Enable = true
														db.oUF.MaintankToT.Texts.Power.ColorClass = false
														db.oUF.MaintankToT.Texts.Power.ColorType = false
														
														oUF_LUI_maintankUnitButton1targettarget.Power.value.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1targettarget.Power.value.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Power.value.colorType = false
			
														oUF_LUI_maintankUnitButton1targettarget.Power.value:SetTextColor(tonumber(db.oUF.MaintankToT.Texts.Power.IndividualColor.r),tonumber(db.oUF.MaintankToT.Texts.Power.IndividualColor.g),tonumber(db.oUF.MaintankToT.Texts.Power.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankToT Power Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankToT.Texts.Power.IndividualColor.Enable or not db.oUF.MaintankToT.Texts.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankToT.Texts.Power.IndividualColor.r, db.oUF.MaintankToT.Texts.Power.IndividualColor.g, db.oUF.MaintankToT.Texts.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankToT.Texts.Power.IndividualColor.r = r
													db.oUF.MaintankToT.Texts.Power.IndividualColor.g = g
													db.oUF.MaintankToT.Texts.Power.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Power.value.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1targettarget.Power.value.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1targettarget.Power.value.colorIndividual.b = b

													oUF_LUI_maintankUnitButton1targettarget.Power.value:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the MaintankToT HealthPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankToT.Texts.HealthPercent.Enable = not db.oUF.MaintankToT.Texts.HealthPercent.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:Show()
											else
												oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankToT HealthPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthPercent.Size,
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankToT.Texts.HealthPercent.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankToT.Texts.HealthPercent.Size = FontSize
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.HealthPercent.Font),db.oUF.MaintankToT.Texts.HealthPercent.Size,db.oUF.MaintankToT.Texts.HealthPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show MaintankToT HealthPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.HealthPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.MaintankToT.Texts.HealthPercent.ShowAlways = not db.oUF.MaintankToT.Texts.HealthPercent.ShowAlways
													oUF_LUI_maintankUnitButton1targettarget.health.valuePercent = db.oUF.MaintankToT.Texts.HealthPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankToT HealthPercent!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthPercent.Font,
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankToT.Texts.HealthPercent.Font end,
											set = function(self, Font)
													db.oUF.MaintankToT.Texts.HealthPercent.Font = Font
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.HealthPercent.Font),db.oUF.MaintankToT.Texts.HealthPercent.Size,db.oUF.MaintankToT.Texts.HealthPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankToT HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthPercent.Outline,
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankToT.Texts.HealthPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankToT.Texts.HealthPercent.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.HealthPercent.Font),db.oUF.MaintankToT.Texts.HealthPercent.Size,db.oUF.MaintankToT.Texts.HealthPercent.Outline)
												end,
											order = 4,
										},
										HealthPercentX = {
											name = "X Value",
											desc = "X Value for your MaintankToT HealthPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthPercent.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.HealthPercent.X end,
											set = function(self,HealthPercentX)
														if HealthPercentX == nil or HealthPercentX == "" then
															HealthPercentX = "0"
														end
														db.oUF.MaintankToT.Texts.HealthPercent.X = HealthPercentX
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:SetPoint(db.oUF.MaintankToT.Texts.HealthPercent.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.HealthPercent.X), tonumber(db.oUF.MaintankToT.Texts.HealthPercent.Y))
													end,
											order = 5,
										},
										HealthPercentY = {
											name = "Y Value",
											desc = "Y Value for your MaintankToT HealthPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.HealthPercent.Y end,
											set = function(self,HealthPercentY)
														if HealthPercentY == nil or HealthPercentY == "" then
															HealthPercentY = "0"
														end
														db.oUF.MaintankToT.Texts.HealthPercent.Y = HealthPercentY
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:SetPoint(db.oUF.MaintankToT.Texts.HealthPercent.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.HealthPercent.X), tonumber(db.oUF.MaintankToT.Texts.HealthPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankToT HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.HealthPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankToT.Texts.HealthPercent.Point = positions[Point]
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:SetPoint(db.oUF.MaintankToT.Texts.HealthPercent.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.HealthPercent.X), tonumber(db.oUF.MaintankToT.Texts.HealthPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankToT HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.HealthPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankToT.Texts.HealthPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:SetPoint(db.oUF.MaintankToT.Texts.HealthPercent.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.HealthPercent.X), tonumber(db.oUF.MaintankToT.Texts.HealthPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.HealthPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankToT.Texts.HealthPercent.ColorClass = true
														db.oUF.MaintankToT.Texts.HealthPercent.ColorGradient = false
														db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorClass = true
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorGradient = false
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorIndividual.Enable = false
					
														print("MaintankToT HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.HealthPercent.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.MaintankToT.Texts.HealthPercent.ColorGradient = true
														db.oUF.MaintankToT.Texts.HealthPercent.ColorClass = false
														db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorGradient = true
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorIndividual.Enable = false
				
														print("MaintankToT HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankToT HealthPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.Enable = true
														db.oUF.MaintankToT.Texts.HealthPercent.ColorClass = false
														db.oUF.MaintankToT.Texts.HealthPercent.ColorGradient = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorGradient = false
							
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:SetTextColor(tonumber(db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.r),tonumber(db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.g),tonumber(db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankToT HealthPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.Enable or not db.oUF.MaintankToT.Texts.HealthPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.r, db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.g, db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.r = r
													db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.g = g
													db.oUF.MaintankToT.Texts.HealthPercent.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.colorIndividual.b = b
			
													oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent:SetTextColor(r,g,b)
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
											get = function() return db.oUF.MaintankToT.Texts.HealthPercent.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.MaintankToT.Texts.HealthPercent.ShowDead = not db.oUF.MaintankToT.Texts.HealthPercent.ShowDead
														oUF_LUI_maintankUnitButton1targettarget.Health.valuePercent.ShowDead = db.oUF.MaintankToT.Texts.HealthPercent.ShowDead
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
									desc = "Wether you want to show the MaintankToT PowerPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankToT.Texts.PowerPercent.Enable = not db.oUF.MaintankToT.Texts.PowerPercent.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:Show()
											else
												oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankToT PowerPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerPercent.Size,
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankToT.Texts.PowerPercent.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankToT.Texts.PowerPercent.Size = FontSize
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.PowerPercent.Font),db.oUF.MaintankToT.Texts.PowerPercent.Size,db.oUF.MaintankToT.Texts.PowerPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show MaintankToT PowerPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.PowerPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.MaintankToT.Texts.PowerPercent.ShowAlways = not db.oUF.MaintankToT.Texts.PowerPercent.ShowAlways
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.ShowAlways = db.oUF.MaintankToT.Texts.PowerPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankToT PowerPercent!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerPercent.Font,
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankToT.Texts.PowerPercent.Font end,
											set = function(self, Font)
													db.oUF.MaintankToT.Texts.PowerPercent.Font = Font
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.PowerPercent.Font),db.oUF.MaintankToT.Texts.PowerPercent.Size,db.oUF.MaintankToT.Texts.PowerPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankToT PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerPercent.Outline,
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankToT.Texts.PowerPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankToT.Texts.PowerPercent.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.PowerPercent.Font),db.oUF.MaintankToT.Texts.PowerPercent.Size,db.oUF.MaintankToT.Texts.PowerPercent.Outline)
												end,
											order = 4,
										},
										PowerPercentX = {
											name = "X Value",
											desc = "X Value for your MaintankToT PowerPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerPercent.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.PowerPercent.X end,
											set = function(self,PowerPercentX)
														if PowerPercentX == nil or PowerPercentX == "" then
															PowerPercentX = "0"
														end
														db.oUF.MaintankToT.Texts.PowerPercent.X = PowerPercentX
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:SetPoint(db.oUF.MaintankToT.Texts.PowerPercent.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.PowerPercent.X), tonumber(db.oUF.MaintankToT.Texts.PowerPercent.Y))
													end,
											order = 5,

										},
										PowerPercentY = {
											name = "Y Value",
											desc = "Y Value for your MaintankToT PowerPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.PowerPercent.Y end,
											set = function(self,PowerPercentY)
														if PowerPercentY == nil or PowerPercentY == "" then
															PowerPercentY = "0"
														end
														db.oUF.MaintankToT.Texts.PowerPercent.Y = PowerPercentY
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:SetPoint(db.oUF.MaintankToT.Texts.PowerPercent.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.PowerPercent.X), tonumber(db.oUF.MaintankToT.Texts.PowerPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankToT PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.PowerPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankToT.Texts.PowerPercent.Point = positions[Point]
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:SetPoint(db.oUF.MaintankToT.Texts.PowerPercent.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.PowerPercent.X), tonumber(db.oUF.MaintankToT.Texts.PowerPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankToT PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.PowerPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankToT.Texts.PowerPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:SetPoint(db.oUF.MaintankToT.Texts.PowerPercent.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.PowerPercent.X), tonumber(db.oUF.MaintankToT.Texts.PowerPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.PowerPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankToT.Texts.PowerPercent.ColorClass = true
														db.oUF.MaintankToT.Texts.PowerPercent.ColorType = false
														db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.Enable = false
														
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.colorClass = true
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.colorType = false
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.individualColor.Enable = false
	
														print("MaintankToT PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.PowerPercent.ColorType end,
											set = function(self,ColorType)
														db.oUF.MaintankToT.Texts.PowerPercent.ColorType = true
														db.oUF.MaintankToT.Texts.PowerPercent.ColorClass = false
														db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.colorType = true
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.individualColor.Enable = false
		
														print("MaintankToT PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankToT PowerPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.Enable = true
														db.oUF.MaintankToT.Texts.PowerPercent.ColorClass = false
														db.oUF.MaintankToT.Texts.PowerPercent.ColorType = false
															
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.individualColor.Enable = true
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.colorType = false

														oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:SetTextColor(tonumber(db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.r),tonumber(db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.g),tonumber(db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankToT PowerPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.Enable or not db.oUF.MaintankToT.Texts.PowerPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.r, db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.g, db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.r = r
													db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.g = g
													db.oUF.MaintankToT.Texts.PowerPercent.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.individualColor.r = r
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.individualColor.g = g
													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent.individualColor.b = b

													oUF_LUI_maintankUnitButton1targettarget.Power.valuePercent:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the MaintankToT HealthMissing or not.",
									type = "toggle",

									width = "full",
									get = function() return db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankToT.Texts.HealthMissing.Enable = not db.oUF.MaintankToT.Texts.HealthMissing.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:Show()
											else
												oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankToT HealthMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthMissing.Size,
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankToT.Texts.HealthMissing.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankToT.Texts.HealthMissing.Size = FontSize
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.HealthMissing.Font),db.oUF.MaintankToT.Texts.HealthMissing.Size,db.oUF.MaintankToT.Texts.HealthMissing.Outline)
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
											desc = "Always show MaintankToT HealthMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.HealthMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.MaintankToT.Texts.HealthMissing.ShowAlways = not db.oUF.MaintankToT.Texts.HealthMissing.ShowAlways
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.ShowAlways = db.oUF.MaintankToT.Texts.HealthMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.HealthMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.MaintankToT.Texts.HealthMissing.ShortValue = not db.oUF.MaintankToT.Texts.HealthMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankToT HealthMissing!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthMissing.Font,
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankToT.Texts.HealthMissing.Font end,
											set = function(self, Font)
													db.oUF.MaintankToT.Texts.HealthMissing.Font = Font
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.HealthMissing.Font),db.oUF.MaintankToT.Texts.HealthMissing.Size,db.oUF.MaintankToT.Texts.HealthMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankToT HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthMissing.Outline,
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankToT.Texts.HealthMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankToT.Texts.HealthMissing.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.HealthMissing.Font),db.oUF.MaintankToT.Texts.HealthMissing.Size,db.oUF.MaintankToT.Texts.HealthMissing.Outline)
												end,
											order = 6,
										},
										HealthMissingX = {
											name = "X Value",
											desc = "X Value for your MaintankToT HealthMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthMissing.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.HealthMissing.X end,
											set = function(self,HealthMissingX)
														if HealthMissingX == nil or HealthMissingX == "" then
															HealthMissingX = "0"
														end
														db.oUF.MaintankToT.Texts.HealthMissing.X = HealthMissingX
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:SetPoint(db.oUF.MaintankToT.Texts.HealthMissing.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.HealthMissing.X), tonumber(db.oUF.MaintankToT.Texts.HealthMissing.Y))
													end,
											order = 7,
										},
										HealthMissingY = {
											name = "Y Value",
											desc = "Y Value for your MaintankToT HealthMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.HealthMissing.Y end,
											set = function(self,HealthMissingY)
														if HealthMissingY == nil or HealthMissingY == "" then
															HealthMissingY = "0"
														end
														db.oUF.MaintankToT.Texts.HealthMissing.Y = HealthMissingY
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:SetPoint(db.oUF.MaintankToT.Texts.HealthMissing.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.HealthMissing.X), tonumber(db.oUF.MaintankToT.Texts.HealthMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankToT HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.HealthMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankToT.Texts.HealthMissing.Point = positions[Point]
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:SetPoint(db.oUF.MaintankToT.Texts.HealthMissing.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.HealthMissing.X), tonumber(db.oUF.MaintankToT.Texts.HealthMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankToT HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.HealthMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.HealthMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankToT.Texts.HealthMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:SetPoint(db.oUF.MaintankToT.Texts.HealthMissing.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.HealthMissing.X), tonumber(db.oUF.MaintankToT.Texts.HealthMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.HealthMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankToT.Texts.HealthMissing.ColorClass = true
														db.oUF.MaintankToT.Texts.HealthMissing.ColorGradient = false
														db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.Enable = false
														
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorClass = true
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorGradient = false
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorIndividual.Enable = false
	
														print("MaintankToT HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.HealthMissing.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.MaintankToT.Texts.HealthMissing.ColorGradient = true
														db.oUF.MaintankToT.Texts.HealthMissing.ColorClass = false
														db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorGradient = true
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorIndividual.Enable = false

														print("MaintankToT HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankToT HealthMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.Enable = true
														db.oUF.MaintankToT.Texts.HealthMissing.ColorClass = false
														db.oUF.MaintankToT.Texts.HealthMissing.ColorGradient = false
															
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorGradient = false

														oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:SetTextColor(tonumber(db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.r),tonumber(db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.g),tonumber(db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankToT HealthMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.Enable or not db.oUF.MaintankToT.Texts.HealthMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.r, db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.g, db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.r = r
													db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.g = g
													db.oUF.MaintankToT.Texts.HealthMissing.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing.colorIndividual.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Health.valueMissing:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the MaintankToT PowerMissing or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
									set = function(self,Enable)
											db.oUF.MaintankToT.Texts.PowerMissing.Enable = not db.oUF.MaintankToT.Texts.PowerMissing.Enable
											if Enable == true then
												oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:Show()
											else
												oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your MaintankToT PowerMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerMissing.Size,
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.MaintankToT.Texts.PowerMissing.Size end,
											set = function(_, FontSize)
													db.oUF.MaintankToT.Texts.PowerMissing.Size = FontSize
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.PowerMissing.Font),db.oUF.MaintankToT.Texts.PowerMissing.Size,db.oUF.MaintankToT.Texts.PowerMissing.Outline)
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
											desc = "Always show MaintankToT PowerMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.PowerMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.MaintankToT.Texts.PowerMissing.ShowAlways = not db.oUF.MaintankToT.Texts.PowerMissing.ShowAlways
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.ShowAlways = db.oUF.MaintankToT.Texts.PowerMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.PowerMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.MaintankToT.Texts.PowerMissing.ShortValue = not db.oUF.MaintankToT.Texts.PowerMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for MaintankToT PowerMissing!\n\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerMissing.Font,
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.MaintankToT.Texts.PowerMissing.Font end,
											set = function(self, Font)
													db.oUF.MaintankToT.Texts.PowerMissing.Font = Font
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.PowerMissing.Font),db.oUF.MaintankToT.Texts.PowerMissing.Size,db.oUF.MaintankToT.Texts.PowerMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your MaintankToT PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerMissing.Outline,
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.MaintankToT.Texts.PowerMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.MaintankToT.Texts.PowerMissing.Outline = fontflags[FontFlag]
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.MaintankToT.Texts.PowerMissing.Font),db.oUF.MaintankToT.Texts.PowerMissing.Size,db.oUF.MaintankToT.Texts.PowerMissing.Outline)
												end,
											order = 6,
										},
										PowerMissingX = {
											name = "X Value",
											desc = "X Value for your MaintankToT PowerMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerMissing.X,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.PowerMissing.X end,
											set = function(self,PowerMissingX)
														if PowerMissingX == nil or PowerMissingX == "" then
															PowerMissingX = "0"
														end
														db.oUF.MaintankToT.Texts.PowerMissing.X = PowerMissingX
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:SetPoint(db.oUF.MaintankToT.Texts.PowerMissing.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.PowerMissing.X), tonumber(db.oUF.MaintankToT.Texts.PowerMissing.Y))
													end,
											order = 7,
										},
										PowerMissingY = {
											name = "Y Value",
											desc = "Y Value for your MaintankToT PowerMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.MaintankToT.Texts.PowerMissing.Y end,
											set = function(self,PowerMissingY)
														if PowerMissingY == nil or PowerMissingY == "" then
															PowerMissingY = "0"
														end
														db.oUF.MaintankToT.Texts.PowerMissing.Y = PowerMissingY
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:ClearAllPoints()
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:SetPoint(db.oUF.MaintankToT.Texts.PowerMissing.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.PowerMissing.X), tonumber(db.oUF.MaintankToT.Texts.PowerMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your MaintankToT PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.PowerMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.MaintankToT.Texts.PowerMissing.Point = positions[Point]
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:SetPoint(db.oUF.MaintankToT.Texts.PowerMissing.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.PowerMissing.X), tonumber(db.oUF.MaintankToT.Texts.PowerMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your MaintankToT PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Texts.PowerMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.MaintankToT.Texts.PowerMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.MaintankToT.Texts.PowerMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:ClearAllPoints()
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:SetPoint(db.oUF.MaintankToT.Texts.PowerMissing.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.MaintankToT.Texts.PowerMissing.X), tonumber(db.oUF.MaintankToT.Texts.PowerMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.PowerMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.MaintankToT.Texts.PowerMissing.ColorClass = true
														db.oUF.MaintankToT.Texts.PowerMissing.ColorType = false
														db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorClass = true
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorType = false
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorIndividual.Enable = false

														print("MaintankToT PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.PowerMissing.ColorType end,
											set = function(self,ColorType)
														db.oUF.MaintankToT.Texts.PowerMissing.ColorType = true
														db.oUF.MaintankToT.Texts.PowerMissing.ColorClass = false
														db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorType = true
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorIndividual.Enable = false
		
														print("MaintankToT PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual MaintankToT PowerMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.Enable = true
														db.oUF.MaintankToT.Texts.PowerMissing.ColorClass = false
														db.oUF.MaintankToT.Texts.PowerMissing.ColorType = false
															
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorIndividual.Enable = true
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorClass = false
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorType = false
		
														oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:SetTextColor(tonumber(db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.r),tonumber(db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.g),tonumber(db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual MaintankToT PowerMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.Enable or not db.oUF.MaintankToT.Texts.PowerMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.r, db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.g, db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.r = r
													db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.g = g
													db.oUF.MaintankToT.Texts.PowerMissing.IndividualColor.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorIndividual.r = r
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorIndividual.g = g
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing.colorIndividual.b = b
													
													oUF_LUI_maintankUnitButton1targettarget.Power.valueMissing:SetTextColor(r,g,b)
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
					disabled = function() return not db.oUF.MaintankToT.Enable end,
					args = {
						header1 = {
							name = "MaintankToT Auras",
							type = "header",
							order = 1,
						},
						MaintankToTBuffs = {
							name = "Buffs",
							type = "group",
							order = 2,
							args = {
								MaintankToTBuffsEnable = {
									name = "Enable MaintankToT Buffs",
									desc = "Wether you want to show MaintankToT Buffs or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankToT.Aura.buffs_enable end,
									set = function(self,MaintankToTBuffsEnable)
												db.oUF.MaintankToT.Aura.buffs_enable = not db.oUF.MaintankToT.Aura.buffs_enable 
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 0,
								},
								MaintankToTBuffsAuratimer = {
									name = "Enable Auratimer",
									desc = "Wether you want to show Auratimers or not.",
									type = "toggle",
									disabled = function() return not db.oUF.MaintankToT.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.buffs_auratimer end,
									set = function(self,MaintankToTBuffsAuratimer)
												db.oUF.MaintankToT.Aura.buffs_auratimer = not db.oUF.MaintankToT.Aura.buffs_auratimer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								MaintankToTBuffsNum = {
									name = "Amount",
									desc = "Amount of your MaintankToT Buffs.\nDefault: 8",
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.buffs_num end,
									set = function(self,MaintankToTBuffsNum)
												if MaintankToTBuffsNum == nil or MaintankToTBuffsNum == "" then
													MaintankToTBuffsNum = "0"
												end
												db.oUF.MaintankToT.Aura.buffs_num = MaintankToTBuffsNum
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								MaintankToTBuffsSize = {
									name = "Size",
									desc = "Size for your MaintankToT Buffs.\nDefault: 18",
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.buffs_size end,
									set = function(self,MaintankToTBuffsSize)
												if MaintankToTBuffsSize == nil or MaintankToTBuffsSize == "" then
													MaintankToTBuffsSize = "0"
												end
												db.oUF.MaintankToT.Aura.buffs_size = MaintankToTBuffsSize
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
								MaintankToTBuffsSpacing = {
									name = "Spacing",
									desc = "Spacing between your MaintankToT Buffs.\nDefault: 2",
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.buffs_spacing end,
									set = function(self,MaintankToTBuffsSpacing)
												if MaintankToTBuffsSpacing == nil or MaintankToTBuffsSpacing == "" then
													MaintankToTBuffsSpacing = "0"
												end
												db.oUF.MaintankToT.Aura.buffs_spacing = MaintankToTBuffsSpacing
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 5,
								},
								MaintankToTBuffsX = {
									name = "X Value",
									desc = "X Value for your MaintankToT Buffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: ",
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.buffsX end,
									set = function(self,MaintankToTBuffsX)
												if MaintankToTBuffsX == nil or MaintankToTBuffsX == "" then
													MaintankToTBuffsX = "0"
												end
												db.oUF.MaintankToT.Aura.buffsX = MaintankToTBuffsX
												oUF_LUI_maintankUnitButton1targettarget.buffs:SetPoint(db.oUF.MaintankToT.Aura.buffs_initialAnchor, oUF_LUI_maintankUnitButton1targettarget.Health, db.oUF.MaintankToT.Aura.buffs_initialAnchor, MaintankToTBuffsX, db.oUF.MaintankToT.Aura.buffsY)
											end,
									order = 6,
								},
								MaintankToTBuffsY = {
									name = "Y Value",
									desc = "Y Value for your MaintankToT Buffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Aura.buffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.buffsY end,
									set = function(self,MaintankToTBuffsY)
												if MaintankToTBuffsY == nil or MaintankToTBuffsY == "" then
													MaintankToTBuffsY = "0"
												end
												db.oUF.MaintankToT.Aura.buffsY = MaintankToTBuffsY
												oUF_LUI_maintankUnitButton1targettarget.buffs:SetPoint(db.oUF.MaintankToT.Aura.buffs_initialAnchor, oUF_LUI_maintankUnitButton1targettarget.Health, db.oUF.MaintankToT.Aura.buffs_initialAnchor, db.oUF.MaintankToT.Aura.buffsX, MaintankToTBuffsY)
											end,
									order = 7,
								},
								MaintankToTBuffsGrowthY = {
									name = "Growth Y",
									desc = "Choose the growth Y direction for your MaintankToT Buffs.\nDefault: UP",
									type = "select",
									disabled = function() return not db.oUF.MaintankToT.Aura.buffs_enable end,
									values = growthY,
									get = function()
											for k, v in pairs(growthY) do
												if db.oUF.MaintankToT.Aura.buffs_growthY == v then
													return k
												end
											end
										end,
									set = function(self, MaintankToTBuffsGrowthY)
											db.oUF.MaintankToT.Aura.buffs_growthY = growthY[MaintankToTBuffsGrowthY]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 8,
								},
								MaintankToTBuffsGrowthX = {
									name = "Growth X",
									desc = "Choose the growth X direction for your MaintankToT Buffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.MaintankToT.Aura.buffs_enable end,
									values = growthX,
									get = function()
											for k, v in pairs(growthX) do
												if db.oUF.MaintankToT.Aura.buffs_growthX == v then
													return k
												end
											end
										end,
									set = function(self, MaintankToTBuffsGrowthX)
											db.oUF.MaintankToT.Aura.buffs_growthX = growthX[MaintankToTBuffsGrowthX]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 9,
								},
								MaintankToTBuffsAnchor = {
									name = "Initial Anchor",
									desc = "Choose the initinal Anchor for your MaintankToT Buffs.\nDefault: LEFT",
									type = "select",
									disabled = function() return not db.oUF.MaintankToT.Aura.buffs_enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.MaintankToT.Aura.buffs_initialAnchor == v then
													return k
												end
											end
										end,
									set = function(self, MaintankToTBuffsAnchor)
											db.oUF.MaintankToT.Aura.buffs_initialAnchor = positions[MaintankToTBuffsAnchor]
											oUF_LUI_maintankUnitButton1targettarget.buffs:SetPoint(positions[MaintankToTBuffsAnchor], oUF_LUI_maintankUnitButton1targettarget.Health, positions[MaintankToTBuffsAnchor], db.oUF.MaintankToT.Aura.buffsX, db.oUF.MaintankToT.Aura.buffsY)
										end,
									order = 10,
								},
							},
						},
						MaintankToTDebuffs = {
							name = "Debuffs",
							type = "group",
							order = 3,
							args = {
								MaintankToTDebuffsEnable = {
									name = "Enable MaintankToT Debuffs",
									desc = "Wether you want to show MaintankToT Debuffs or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.MaintankToT.Aura.debuffs_enable end,
									set = function(self,MaintankToTDebuffsEnable)
												db.oUF.MaintankToT.Aura.debuffs_enable = not db.oUF.MaintankToT.Aura.debuffs_enable 
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 0,
								},
								MaintankToTDebuffsAuratimer = {
									name = "Enable Auratimer",
									desc = "Wether you want to show Auratimers or not.\nDefault: Off",
									type = "toggle",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.debuffs_auratimer end,
									set = function(self,MaintankToTDebuffsAuratimer)
												db.oUF.MaintankToT.Aura.debuffs_auratimer = not db.oUF.MaintankToT.Aura.debuffs_auratimer
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								MaintankToTDebuffsPlayerBuffsOnly = {
									name = "Player Debuffs Only",
									desc = "Wether you want to show only your Debuffs on MaintankToTmembers or not.",
									type = "toggle",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.debuffs_playeronly end,
									set = function(self,MaintankToTBuffsPlayerBuffsOnly)
												db.oUF.MaintankToT.Aura.debuffs_playeronly = not db.oUF.MaintankToT.Aura.debuffs_playeronly
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 2,
								},
								MaintankToTDebuffsColorByType = {
									name = "Color by Type",
									desc = "Wether you want to color MaintankToT Debuffs by Type or not.",
									type = "toggle",
									width = "full",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.debuffs_colorbytype end,
									set = function(self,MaintankToTDebuffsColorByType)
												db.oUF.MaintankToT.Aura.debuffs_colorbytype = not db.oUF.MaintankToT.Aura.debuffs_colorbytype
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 3,
								},
								MaintankToTDebuffsNum = {
									name = "Amount",
									desc = "Amount of your MaintankToT Debuffs.\nDefault: 8",
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.debuffs_num end,
									set = function(self,MaintankToTDebuffsNum)
												if MaintankToTDebuffsNum == nil or MaintankToTDebuffsNum == "" then
													MaintankToTDebuffsNum = "0"
												end
												db.oUF.MaintankToT.Aura.debuffs_num = MaintankToTDebuffsNum
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 4,
								},
								MaintankToTDebuffsSize = {
									name = "Size",
									desc = "Size for your MaintankToT Debuffs.\nDefault: 18",
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.debuffs_size end,
									set = function(self,MaintankToTDebuffsSize)
												if MaintankToTDebuffsSize == nil or MaintankToTDebuffsSize == "" then
													MaintankToTDebuffsSize = "0"
												end
												db.oUF.MaintankToT.Aura.debuffs_size = MaintankToTDebuffsSize
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 5,
								},
								MaintankToTDebuffsSpacing = {
									name = "Spacing",
									desc = "Spacing between your MaintankToT Debuffs.\nDefault: 2",
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.debuffs_spacing end,
									set = function(self,MaintankToTDebuffsSpacing)
												if MaintankToTDebuffsSpacing == nil or MaintankToTDebuffsSpacing == "" then
													MaintankToTDebuffsSpacing = "0"
												end
												db.oUF.MaintankToT.Aura.debuffs_spacing = MaintankToTDebuffsSpacing
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 6,
								},
								MaintankToTDebuffsX = {
									name = "X Value",
									desc = "X Value for your MaintankToT Debuffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.debuffsX end,
									set = function(self,MaintankToTDebuffsX)
												if MaintankToTDebuffsX == nil or MaintankToTDebuffsX == "" then
													MaintankToTDebuffsX = "0"
												end
												db.oUF.MaintankToT.Aura.debuffsX = MaintankToTDebuffsX
												oUF_LUI_maintankUnitButton1targettarget.debuffs:SetPoint(db.oUF.MaintankToT.Aura.debuffs_initialAnchor, oUF_LUI_maintankUnitButton1targettarget.Health, db.oUF.MaintankToT.Aura.debuffs_initialAnchor, MaintankToTDebuffsX, db.oUF.MaintankToT.Aura.debuffsY)
											end,
									order = 7,
								},
								MaintankToTDebuffsY = {
									name = "Y Value",
									desc = "Y Value for your MaintankToT Debuffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: 30",
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									get = function() return db.oUF.MaintankToT.Aura.debuffsY end,
									set = function(self,MaintankToTDebuffsY)
												if MaintankToTDebuffsY == nil or MaintankToTDebuffsY == "" then
													MaintankToTDebuffsY = "0"
												end
												db.oUF.MaintankToT.Aura.debuffsY = MaintankToTDebuffsY
												oUF_LUI_maintankUnitButton1targettarget.debuffs:SetPoint(db.oUF.MaintankToT.Aura.debuffs_initialAnchor, oUF_LUI_maintankUnitButton1targettarget.Health, db.oUF.MaintankToT.Aura.debuffs_initialAnchor, db.oUF.MaintankToT.Aura.debuffsX, MaintankToTDebuffsY)
											end,
									order = 8,
								},
								MaintankToTDebuffsGrowthY = {
									name = "Growth Y",
									desc = "Choose the growth Y direction for your MaintankToT Debuffs.\nDefault: UP",
									type = "select",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									values = growthY,
									get = function()
											for k, v in pairs(growthY) do
												if db.oUF.MaintankToT.Aura.debuffs_growthY == v then
													return k
												end
											end
										end,
									set = function(self, MaintankToTDebuffsGrowthY)
											db.oUF.MaintankToT.Aura.debuffs_growthY = growthY[MaintankToTDebuffsGrowthY]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 9,
								},
								MaintankToTDebuffsGrowthX = {
									name = "Growth X",
									desc = "Choose the growth X direction for your MaintankToT Debuffs.\nDefault: RIGHT",
									type = "select",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									values = growthX,
									get = function()
											for k, v in pairs(growthX) do
												if db.oUF.MaintankToT.Aura.debuffs_growthX == v then
													return k
												end
											end
										end,
									set = function(self, MaintankToTDebuffsGrowthX)
											db.oUF.MaintankToT.Aura.debuffs_growthX = growthX[MaintankToTDebuffsGrowthX]
											StaticPopup_Show("RELOAD_UI")
										end,
									order = 10,
								},
								MaintankToTDebuffsAnchor = {
									name = "Initial Anchor",
									desc = "Choose the initinal Anchor for your MaintankToT Debuffs.\nDefault: LEFT",
									type = "select",
									disabled = function() return not db.oUF.MaintankToT.Aura.debuffs_enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.MaintankToT.Aura.debuffs_initialAnchor == v then
													return k
												end
											end
										end,
									set = function(self, MaintankToTDebuffsAnchor)
											db.oUF.MaintankToT.Aura.debuffs_initialAnchor = positions[MaintankToTDebuffsAnchor]
											oUF_LUI_maintankUnitButton1targettarget.debuffs:SetPoint(positions[MaintankToTDebuffsAnchor], oUF_LUI_maintankUnitButton1targettarget.Health, positions[MaintankToTDebuffsAnchor], db.oUF.MaintankToT.Aura.debuffsX, db.oUF.MaintankToT.Aura.debuffsY)
										end,
									order = 11,
								},
							},
						},
					},
				},
				Portrait = {
					name = "Portrait",
					disabled = function() return not db.oUF.MaintankToT.Enable end,
					type = "group",
					order = 8,
					args = {
						EnablePortrait = {
							name = "Enable",
							desc = "Wether you want to show the Portrait or not.",
							type = "toggle",
							width = "full",
							get = function() return db.oUF.MaintankToT.Portrait.Enable end,
							set = function(self,EnablePortrait)
										db.oUF.MaintankToT.Portrait.Enable = not db.oUF.MaintankToT.Portrait.Enable
										StaticPopup_Show("RELOAD_UI")
									end,
							order = 1,
						},
						PortraitWidth = {
							name = "Width",
							desc = "Choose the Width for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.MaintankToT.Portrait.Enable end,
							get = function() return db.oUF.MaintankToT.Portrait.Width end,
							set = function(self,PortraitWidth)
										if PortraitWidth == nil or PortraitWidth == "" then
											PortraitWidth = "0"
										end
										db.oUF.MaintankToT.Portrait.Width = PortraitWidth
										oUF_LUI_maintankUnitButton1targettarget.Portrait:SetWidth(tonumber(PortraitWidth))
									end,
							order = 2,
						},
						PortraitHeight = {
							name = "Height",
							desc = "Choose the Height for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.MaintankToT.Portrait.Enable end,
							get = function() return db.oUF.MaintankToT.Portrait.Height end,
							set = function(self,PortraitHeight)
										if PortraitHeight == nil or PortraitHeight == "" then
											PortraitHeight = "0"
										end
										db.oUF.MaintankToT.Portrait.Height = PortraitHeight
										oUF_LUI_maintankUnitButton1targettarget.Portrait:SetHeight(tonumber(PortraitHeight))
									end,
							order = 3,
						},
						PortraitX = {
							name = "X Value",
							desc = "X Value for your Portrait.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Portrait.X,
							type = "input",
							disabled = function() return not db.oUF.MaintankToT.Portrait.Enable end,
							get = function() return db.oUF.MaintankToT.Portrait.X end,
							set = function(self,PortraitX)
										if PortraitX == nil or PortraitX == "" then
											PortraitX = "0"
										end
										db.oUF.MaintankToT.Portrait.X = PortraitX
										oUF_LUI_maintankUnitButton1targettarget.Portrait:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1targettarget.Health, "TOPLEFT", PortraitX, db.oUF.MaintankToT.Portrait.Y)
									end,
							order = 4,
						},
						PortraitY = {
							name = "Y Value",
							desc = "Y Value for your Portrait.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Portrait.Y,
							type = "input",
							disabled = function() return not db.oUF.MaintankToT.Portrait.Enable end,
							get = function() return db.oUF.MaintankToT.Portrait.Y end,
							set = function(self,PortraitY)
										if PortraitY == nil or PortraitY == "" then
											PortraitY = "0"
										end
										db.oUF.MaintankToT.Portrait.Y = PortraitY
										oUF_LUI_maintankUnitButton1targettarget.Portrait:SetPoint("TOPLEFT", oUF_LUI_maintankUnitButton1targettarget.Health, "TOPLEFT", db.oUF.MaintankToT.Portrait.X, PortraitY)
									end,
							order = 5,
						},
					},
				},
				Icons = {
					name = "Icons",
					type = "group",
					disabled = function() return not db.oUF.MaintankToT.Enable end,
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
									get = function() return db.oUF.MaintankToT.Icons.Raid.Enable end,
									set = function(self,RaidEnable)
												db.oUF.MaintankToT.Icons.Raid.Enable = not db.oUF.MaintankToT.Icons.Raid.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								RaidX = {
									name = "X Value",
									desc = "X Value for your Raid Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Icons.Raid.X,
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Icons.Raid.Enable end,
									get = function() return db.oUF.MaintankToT.Icons.Raid.X end,
									set = function(self,RaidX)
												if RaidX == nil or RaidX == "" then
													RaidX = "0"
												end

												db.oUF.MaintankToT.Icons.Raid.X = RaidX
												oUF_LUI_maintankUnitButton1targettarget.RaidIcon:ClearAllPoints()
												oUF_LUI_maintankUnitButton1targettarget.RaidIcon:SetPoint(db.oUF.MaintankToT.Icons.Raid.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Icons.Raid.Point, tonumber(RaidX), tonumber(db.oUF.MaintankToT.Icons.Raid.Y))
											end,
									order = 2,
								},
								RaidY = {
									name = "Y Value",
									desc = "Y Value for your Raid Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Icons.Raid.Y,
									type = "input",
									disabled = function() return not db.oUF.MaintankToT.Icons.Raid.Enable end,
									get = function() return db.oUF.MaintankToT.Icons.Raid.Y end,
									set = function(self,RaidY)
												if RaidY == nil or RaidY == "" then
													RaidY = "0"
												end
												db.oUF.MaintankToT.Icons.Raid.Y = RaidY
												oUF_LUI_maintankUnitButton1targettarget.RaidIcon:ClearAllPoints()
												oUF_LUI_maintankUnitButton1targettarget.RaidIcon:SetPoint(db.oUF.MaintankToT.Icons.Raid.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Icons.Raid.Point, tonumber(db.oUF.MaintankToT.Icons.Raid.X), tonumber(RaidY))
											end,
									order = 3,
								},
								RaidPoint = {
									name = "Position",
									desc = "Choose the Position for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Icons.Raid.Point,
									type = "select",
									disabled = function() return not db.oUF.MaintankToT.Icons.Raid.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.MaintankToT.Icons.Raid.Point == v then
													return k
												end
											end
										end,
									set = function(self, RaidPoint)
											db.oUF.MaintankToT.Icons.Raid.Point = positions[RaidPoint]
											oUF_LUI_maintankUnitButton1targettarget.RaidIcon:ClearAllPoints()
											oUF_LUI_maintankUnitButton1targettarget.RaidIcon:SetPoint(db.oUF.MaintankToT.Icons.Raid.Point, oUF_LUI_maintankUnitButton1targettarget, db.oUF.MaintankToT.Icons.Raid.Point, tonumber(db.oUF.MaintankToT.Icons.Raid.X), tonumber(db.oUF.MaintankToT.Icons.Raid.Y))
										end,
									order = 4,
								},
								RaidSize = {
									name = "Size",
									desc = "Choose a Size for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.MaintankToT.Icons.Raid.Size,
									type = "range",
									min = 5,
									max = 200,
									step = 5,
									disabled = function() return not db.oUF.MaintankToT.Icons.Raid.Enable end,
									get = function() return db.oUF.MaintankToT.Icons.Raid.Size end,
									set = function(_, RaidSize) 
											db.oUF.MaintankToT.Icons.Raid.Size = RaidSize
											oUF_LUI_maintankUnitButton1targettarget.RaidIcon:SetHeight(RaidSize)
											oUF_LUI_maintankUnitButton1targettarget.RaidIcon:SetWidth(RaidSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.MaintankToT.Icons.Raid.Enable end,
									desc = "Toggles the RaidIcon",
									type = 'execute',
									func = function() if oUF_LUI_maintankUnitButton1targettarget.RaidIcon:IsShown() then oUF_LUI_maintankUnitButton1targettarget.RaidIcon:Hide() else oUF_LUI_maintankUnitButton1targettarget.RaidIcon:Show() end end
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
