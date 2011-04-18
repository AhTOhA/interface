--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: general.lua
	Description: oUF General Module
	Version....: 1.0
	Notes......: This module contains all of the defaults and options that are contained within all of the UnitFrames.
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local module = LUI:NewModule("oUF_General")
local Forte
local LSM = LibStub("LibSharedMedia-3.0")
local widgetLists = AceGUIWidgetLSMlists

local db

local units = {"Player", "Target", "ToT", "ToToT", "Focus", "FocusTarget", "Pet", "PetTarget"}

local ufNames = {
	Player = "oUF_LUI_player",
	Target = "oUF_LUI_target",
	ToT = "oUF_LUI_targettarget",
	ToToT = "oUF_LUI_targettargettarget",
	Focus = "oUF_LUI_focus",
	FocusTarget = "oUF_LUI_focustarget",
	Pet = "oUF_LUI_pet",
	PetTarget = "oUF_LUI_pettarget",
}

local ufUnits = {
	Player = "player",
	Target = "target",
	ToT = "targettarget",
	ToToT = "targettargettarget",
	Focus = "focus",
	FocusTarget = "focustarget",
	Pet = "pet",
	PetTarget = "pettarget",
}

local positions = {"TOP", "TOPRIGHT", "TOPLEFT","BOTTOM", "BOTTOMRIGHT", "BOTTOMLEFT","RIGHT", "LEFT", "CENTER"}
local fontflags = {'OUTLINE', 'THICKOUTLINE', 'MONOCHROME', 'NONE'}
local justifications = {'LEFT', 'CENTER', 'RIGHT'}
local valueFormat = {'Absolut', 'Absolut & Percent', 'Absolut Short', 'Absolut Short & Percent', 'Standard', 'Standard Short'}
local nameFormat = {'Name', 'Name + Level', 'Name + Level + Class', 'Name + Level + Race + Class', 'Level + Name', 'Level + Name + Class', 'Level + Class + Name', 'Level + Name + Race + Class', 'Level + Race + Class + Name'}
local nameLenghts = {'Short', 'Medium', 'Long'}
local growthY = {"UP", "DOWN"}
local growthX = {"LEFT", "RIGHT"}
local _, class = UnitClass("player")

function module:CreateOptions(index, unit)
	local luidefaults = LUI.defaults.profile.oUF[unit]
	local oufdb = db.oUF[unit]
	local UF = ufNames[unit]
	local options = {
		name = unit,
		type = "group",
		order = index*2+10,
		disabled = function() return not db.oUF.Settings.Enable end,
		childGroups = "tab",
		args = {
			header = {
				name = unit,
				type = "header",
				order = 1,
			},
			General = {
				name = "General",
				type = "group",
				childGroups = "tab",
				order = 2,
				args = {
					General = (unit ~= "Player" and unit ~= "Target") and {
						name = "General",
						type = "group",
						order = 0,
						args = {
							Enable = {
								name = "Enable",
								desc = "Wether you want to use a Focus Frame or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Enable end,
								set = function(self,Enable)
									oufdb.Enable = Enable
									if Enable then
										if _G[UF] then
											_G[UF]:Enable()
										else
											oUF:SetActiveStyle("LUI")
											oUF:Spawn(ufUnits[unit], UF):SetPoint("CENTER", UIParent, "CENTER", tonumber(oufdb.X), tonumber(oufdb.Y))
										end
									else
										if _G[UF] then
											_G[UF]:Disable()
										end
									end
								end,
								order = 1,
							},
						},
					} or nil,
					Positioning = {
						name = "Positioning",
						type = "group",
						disabled = function() return (oufdb.Enable ~= nil and not oufdb.Enable or false) end,
						order = 2,
						args = {
							header = {
								name = "Frame Position",
								type = "header",
								order = 1,
							},
							XValue = {
								name = "X Value",
								desc = "X Value for your "..unit.." Frame.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.X,
								type = "input",
								get = function() return oufdb.X end,
								set = function(self,XValue)
									if XValue == nil or XValue == "" then XValue = "0" end
									oufdb.X = XValue
									_G[UF]:SetPoint("CENTER", UIParent, "CENTER", tonumber(oufdb.X), tonumber(oufdb.Y))
									if unit == "Player" then Forte:SetPosForte() end
								end,
								order = 2,
							},
							YValue = {
								name = "Y Value",
								desc = "Y Value for your "..unit.." Frame.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Y,
								type = "input",
								get = function() return oufdb.Y end,
								set = function(self,YValue)
									if YValue == nil or YValue == "" then YValue = "0" end
									oufdb.Y = YValue
									_G[UF]:SetPoint("CENTER", UIParent, "CENTER", tonumber(oufdb.X), tonumber(oufdb.Y))
									if unit == "Player" then Forte:SetPosForte() end
								end,
								order = 3,
							},
						},
					},
					Size = {
						name = "Size",
						type = "group",
						disabled = function() return (oufdb.Enable ~= nil and not oufdb.Enable or false) end,
						order = 4,
						args = {
							header = {
								name = "Frame Height/Width",
								type = "header",
								order = 1,
							},
							Height = {
								name = "Height",
								desc = "Decide the Height of your "..unit.." Frame.\n\nDefault: "..luidefaults.Height,
								type = "input",
								get = function() return oufdb.Height end,
								set = function(self,Height)
									if Height == nil or Height == "" then Height = "0" end
									oufdb.Height = Height
									_G[UF]:SetHeight(tonumber(Height))
									if unit == "Player" then Forte:SetPosForte() end
								end,
								order = 2,
							},
							Width = {
								name = "Width",
								desc = "Decide the Width of your "..unit.." Frame.\n\nDefault: "..luidefaults.Width,
								type = "input",
								get = function() return oufdb.Width end,
								set = function(self,Width)
									if Width == nil or Width == "" then Width = "0" end
									oufdb.Width = Width
									_G[UF]:SetWidth(tonumber(Width))
									if oufdb.Aura then
										if oufdb.Aura.buffs_enable == true then _G[UF].Buffs:SetWidth(tonumber(Width)) end
										if oufdb.Aura.debuffs_enable == true then _G[UF].Debuffs:SetWidth(tonumber(Width)) end
									end
									if unit == "Player" then Forte:SetPosForte() end
								end,
								order = 3,
							},
						},
					},
					Appearance = {
						name = "Appearance",
						type = "group",
						disabled = function() return (oufdb.Enable ~= nil and not oufdb.Enable or false) end,
						order = 6,
						args = {
							header = {
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
								get = function() return oufdb.Backdrop.Color.r, oufdb.Backdrop.Color.g, oufdb.Backdrop.Color.b, oufdb.Backdrop.Color.a end,
								set = function(_,r,g,b,a)
									oufdb.Backdrop.Color.r = r
									oufdb.Backdrop.Color.g = g
									oufdb.Backdrop.Color.b = b
									oufdb.Backdrop.Color.a = a
									_G[UF].FrameBackdrop:SetBackdropColor(r,g,b,a)
								end,
								order = 2,
							},
							BackdropBorderColor = {
								name = "Border Color",
								desc = "Choose a Backdrop Border Color.",
								type = "color",
								hasAlpha = true,
								get = function() return oufdb.Border.Color.r, oufdb.Border.Color.g, oufdb.Border.Color.b, oufdb.Border.Color.a end,
								set = function(_,r,g,b,a)
									oufdb.Border.Color.r = r
									oufdb.Border.Color.g = g
									oufdb.Border.Color.b = b
									oufdb.Border.Color.a = a
									_G[UF].FrameBackdrop:SetBackdropBorderColor(r,g,b,a)
								end,
								order = 3,
							},
							AggroGlow = (unit == "Player" or unit == "Target" or unit == "Focus" or unit == "Pet") and {
								name = "Aggro Glow",
								desc = "Wether you want the border color to change if you have aggro or not.",
								type = "toggle",
								get = function() return oufdb.Border.Aggro end,
								set = function(self, Enable)
									oufdb.Border.Aggro = Enable
									if not _G[UF].Threat then _G[UF].CreateThreat() end
									if Enable then
										_G[UF]:EnableElement("Threat")
									else
										_G[UF]:DisableElement("Threat")
										_G[UF].Threat:Hide()
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 4,
							} or nil,
							header2 = {
								name = "Backdrop Settings",
								type = "header",
								order = 5,
							},
							BackdropTexture = {
								name = "Backdrop Texture",
								desc = "Choose your Backdrop Texture!\nDefault: "..luidefaults.Backdrop.Texture,
								type = "select",
								dialogControl = "LSM30_Background",
								values = widgetLists.background,
								get = function() return oufdb.Backdrop.Texture end,
								set = function(self, BackdropTexture)
									oufdb.Backdrop.Texture = BackdropTexture
									_G[UF].FrameBackdrop:SetBackdrop({
											bgFile = LSM:Fetch("background", oufdb.Backdrop.Texture),
											edgeFile = LSM:Fetch("border", oufdb.Border.EdgeFile), edgeSize = tonumber(oufdb.Border.EdgeSize),
											insets = {left = tonumber(oufdb.Border.Insets.Left), right = tonumber(oufdb.Border.Insets.Right), top = tonumber(oufdb.Border.Insets.Top), bottom = tonumber(oufdb.Border.Insets.Bottom)}
										})
									_G[UF].FrameBackdrop:SetBackdropColor(oufdb.Backdrop.Color.r, oufdb.Backdrop.Color.g, oufdb.Backdrop.Color.b, oufdb.Backdrop.Color.a)
									_G[UF].FrameBackdrop:SetBackdropBorderColor(oufdb.Border.Color.r, oufdb.Border.Color.g, oufdb.Border.Color.b, oufdb.Border.Color.a)
								end,
								order = 6,
							},
							BorderTexture = {
								name = "Border Texture",
								desc = "Choose your Border Texture!\nDefault: "..luidefaults.Border.EdgeFile,
								type = "select",
								dialogControl = "LSM30_Border",
								values = widgetLists.border,
								get = function() return oufdb.Border.EdgeFile end,
								set = function(self, BorderTexture)
									oufdb.Border.EdgeFile = BorderTexture
									_G[UF].FrameBackdrop:SetBackdrop({
											bgFile = LSM:Fetch("background", oufdb.Backdrop.Texture),
											edgeFile = LSM:Fetch("border", oufdb.Border.EdgeFile), edgeSize = tonumber(oufdb.Border.EdgeSize),
											insets = {left = tonumber(oufdb.Border.Insets.Left), right = tonumber(oufdb.Border.Insets.Right), top = tonumber(oufdb.Border.Insets.Top), bottom = tonumber(oufdb.Border.Insets.Bottom)}
										})
									_G[UF].FrameBackdrop:SetBackdropColor(oufdb.Backdrop.Color.r, oufdb.Backdrop.Color.g, oufdb.Backdrop.Color.b, oufdb.Backdrop.Color.a)
									_G[UF].FrameBackdrop:SetBackdropBorderColor(oufdb.Border.Color.r, oufdb.Border.Color.g, oufdb.Border.Color.b, oufdb.Border.Color.a)
								end,
								order = 7,
							},
							BorderSize = {
								name = "Edge Size",
								desc = "Choose the Edge Size for your Frame Border.\nDefault: "..luidefaults.Border.EdgeSize,
								type = "range",
								min = 1,
								max = 50,
								step = 1,
								get = function() return oufdb.Border.EdgeSize end,
								set = function(_, BorderSize) 
									oufdb.Border.EdgeSize = BorderSize
									_G[UF].FrameBackdrop:SetBackdrop({
											bgFile = LSM:Fetch("background", oufdb.Backdrop.Texture),
											edgeFile = LSM:Fetch("border", oufdb.Border.EdgeFile), edgeSize = tonumber(oufdb.Border.EdgeSize),
											insets = {left = tonumber(oufdb.Border.Insets.Left), right = tonumber(oufdb.Border.Insets.Right), top = tonumber(oufdb.Border.Insets.Top), bottom = tonumber(oufdb.Border.Insets.Bottom)}
										})
									_G[UF].FrameBackdrop:SetBackdropColor(oufdb.Backdrop.Color.r, oufdb.Backdrop.Color.g, oufdb.Backdrop.Color.b, oufdb.Backdrop.Color.a)
									_G[UF].FrameBackdrop:SetBackdropBorderColor(oufdb.Border.Color.r, oufdb.Border.Color.g, oufdb.Border.Color.b, oufdb.Border.Color.a)
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
								desc = "Value for the Left Backdrop Padding\nDefault: "..luidefaults.Backdrop.Padding.Left,
								type = "input",
								width = "half",
								get = function() return oufdb.Backdrop.Padding.Left end,
								set = function(self,PaddingLeft)
									if PaddingLeft == nil or PaddingLeft == "" then PaddingLeft = "0" end
									oufdb.Backdrop.Padding.Left = PaddingLeft
									_G[UF].FrameBackdrop:ClearAllPoints()
									_G[UF].FrameBackdrop:SetPoint("TOPLEFT", _G[UF], "TOPLEFT", tonumber(oufdb.Backdrop.Padding.Left), tonumber(oufdb.Backdrop.Padding.Top))
									_G[UF].FrameBackdrop:SetPoint("BOTTOMRIGHT", _G[UF], "BOTTOMRIGHT", tonumber(oufdb.Backdrop.Padding.Right), tonumber(oufdb.Backdrop.Padding.Bottom))
								end,
								order = 10,
							},
							PaddingRight = {
								name = "Right",
								desc = "Value for the Right Backdrop Padding\nDefault: "..luidefaults.Backdrop.Padding.Right,
								type = "input",
								width = "half",
								get = function() return oufdb.Backdrop.Padding.Right end,
								set = function(self,PaddingRight)
									if PaddingRight == nil or PaddingRight == "" then PaddingRight = "0" end
									oufdb.Backdrop.Padding.Right = PaddingRight
									_G[UF].FrameBackdrop:ClearAllPoints()
									_G[UF].FrameBackdrop:SetPoint("TOPLEFT", _G[UF], "TOPLEFT", tonumber(oufdb.Backdrop.Padding.Left), tonumber(oufdb.Backdrop.Padding.Top))
									_G[UF].FrameBackdrop:SetPoint("BOTTOMRIGHT", _G[UF], "BOTTOMRIGHT", tonumber(oufdb.Backdrop.Padding.Right), tonumber(oufdb.Backdrop.Padding.Bottom))
								end,
								order = 11,
							},
							PaddingTop = {
								name = "Top",
								desc = "Value for the Top Backdrop Padding\nDefault: "..luidefaults.Backdrop.Padding.Top,
								type = "input",
								width = "half",
								get = function() return oufdb.Backdrop.Padding.Top end,
								set = function(self,PaddingTop)
									if PaddingTop == nil or PaddingTop == "" then PaddingTop = "0" end
									oufdb.Backdrop.Padding.Top = PaddingTop
									_G[UF].FrameBackdrop:ClearAllPoints()
									_G[UF].FrameBackdrop:SetPoint("TOPLEFT", _G[UF], "TOPLEFT", tonumber(oufdb.Backdrop.Padding.Left), tonumber(oufdb.Backdrop.Padding.Top))
									_G[UF].FrameBackdrop:SetPoint("BOTTOMRIGHT", _G[UF], "BOTTOMRIGHT", tonumber(oufdb.Backdrop.Padding.Right), tonumber(oufdb.Backdrop.Padding.Bottom))
								end,
								order = 12,
							},
							PaddingBottom = {
								name = "Bottom",
								desc = "Value for the Bottom Backdrop Padding\nDefault: "..luidefaults.Backdrop.Padding.Bottom,
								type = "input",
								width = "half",
								get = function() return oufdb.Backdrop.Padding.Bottom end,
								set = function(self,PaddingBottom)
									if PaddingBottom == nil or PaddingBottom == "" then PaddingBottom = "0" end
									oufdb.Backdrop.Padding.Bottom = PaddingBottom
									_G[UF].FrameBackdrop:ClearAllPoints()
									_G[UF].FrameBackdrop:SetPoint("TOPLEFT", _G[UF], "TOPLEFT", tonumber(oufdb.Backdrop.Padding.Left), tonumber(oufdb.Backdrop.Padding.Top))
									_G[UF].FrameBackdrop:SetPoint("BOTTOMRIGHT", _G[UF], "BOTTOMRIGHT", tonumber(oufdb.Backdrop.Padding.Right), tonumber(oufdb.Backdrop.Padding.Bottom))
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
								desc = "Value for the Left Border Inset\nDefault: "..luidefaults.Border.Insets.Left,
								type = "input",
								width = "half",
								get = function() return oufdb.Border.Insets.Left end,
								set = function(self,InsetLeft)
									if InsetLeft == nil or InsetLeft == "" then InsetLeft = "0" end
									oufdb.Border.Insets.Left = InsetLeft
									_G[UF].FrameBackdrop:SetBackdrop({
											bgFile = LSM:Fetch("background", oufdb.Backdrop.Texture),
											edgeFile = LSM:Fetch("border", oufdb.Border.EdgeFile), edgeSize = tonumber(oufdb.Border.EdgeSize),
											insets = {left = tonumber(oufdb.Border.Insets.Left), right = tonumber(oufdb.Border.Insets.Right), top = tonumber(oufdb.Border.Insets.Top), bottom = tonumber(oufdb.Border.Insets.Bottom)}
										})
									_G[UF].FrameBackdrop:SetBackdropColor(oufdb.Backdrop.Color.r, oufdb.Backdrop.Color.g, oufdb.Backdrop.Color.b, oufdb.Backdrop.Color.a)
									_G[UF].FrameBackdrop:SetBackdropBorderColor(oufdb.Border.Color.r, oufdb.Border.Color.g, oufdb.Border.Color.b, oufdb.Border.Color.a)
								end,
								order = 15,
							},
							InsetRight = {
								name = "Right",
								desc = "Value for the Right Border Inset\nDefault: "..luidefaults.Border.Insets.Right,
								type = "input",
								width = "half",
								get = function() return oufdb.Border.Insets.Right end,
								set = function(self,InsetRight)
									if InsetRight == nil or InsetRight == "" then InsetRight = "0" end
									oufdb.Border.Insets.Right = InsetRight
									_G[UF].FrameBackdrop:SetBackdrop({
											bgFile = LSM:Fetch("background", oufdb.Backdrop.Texture),
											edgeFile = LSM:Fetch("border", oufdb.Border.EdgeFile), edgeSize = tonumber(oufdb.Border.EdgeSize),
											insets = {left = tonumber(oufdb.Border.Insets.Left), right = tonumber(oufdb.Border.Insets.Right), top = tonumber(oufdb.Border.Insets.Top), bottom = tonumber(oufdb.Border.Insets.Bottom)}
										})
									_G[UF].FrameBackdrop:SetBackdropColor(oufdb.Backdrop.Color.r, oufdb.Backdrop.Color.g, oufdb.Backdrop.Color.b, oufdb.Backdrop.Color.a)
									_G[UF].FrameBackdrop:SetBackdropBorderColor(oufdb.Border.Color.r, oufdb.Border.Color.g, oufdb.Border.Color.b, oufdb.Border.Color.a)
								end,
								order = 16,
							},
							InsetTop = {
								name = "Top",
								desc = "Value for the Top Border Inset\nDefault: "..luidefaults.Border.Insets.Top,
								type = "input",
								width = "half",
								get = function() return oufdb.Border.Insets.Top end,
								set = function(self,InsetTop)
									if InsetTop == nil or InsetTop == "" then InsetTop = "0" end
									oufdb.Border.Insets.Top = InsetTop
									_G[UF].FrameBackdrop:SetBackdrop({
											bgFile = LSM:Fetch("background", oufdb.Backdrop.Texture),
											edgeFile = LSM:Fetch("border", oufdb.Border.EdgeFile), edgeSize = tonumber(oufdb.Border.EdgeSize),
											insets = {left = tonumber(oufdb.Border.Insets.Left), right = tonumber(oufdb.Border.Insets.Right), top = tonumber(oufdb.Border.Insets.Top), bottom = tonumber(oufdb.Border.Insets.Bottom)}
										})
									_G[UF].FrameBackdrop:SetBackdropColor(oufdb.Backdrop.Color.r, oufdb.Backdrop.Color.g, oufdb.Backdrop.Color.b, oufdb.Backdrop.Color.a)
									_G[UF].FrameBackdrop:SetBackdropBorderColor(oufdb.Border.Color.r, oufdb.Border.Color.g, oufdb.Border.Color.b, oufdb.Border.Color.a)
								end,
								order = 17,
							},
							InsetBottom = {
								name = "Bottom",
								desc = "Value for the Bottom Border Inset\nDefault: "..luidefaults.Border.Insets.Bottom,
								type = "input",
								width = "half",
								get = function() return oufdb.Border.Insets.Bottom end,
								set = function(self,InsetBottom)
									if InsetBottom == nil or InsetBottom == "" then InsetBottom = "0" end
									oufdb.Border.Insets.Bottom = InsetBottom
									_G[UF].FrameBackdrop:SetBackdrop({
											bgFile = LSM:Fetch("background", oufdb.Backdrop.Texture),
											edgeFile = LSM:Fetch("border", oufdb.Border.EdgeFile), edgeSize = tonumber(oufdb.Border.EdgeSize),
											insets = {left = tonumber(oufdb.Border.Insets.Left), right = tonumber(oufdb.Border.Insets.Right), top = tonumber(oufdb.Border.Insets.Top), bottom = tonumber(oufdb.Border.Insets.Bottom)}
										})
									_G[UF].FrameBackdrop:SetBackdropColor(oufdb.Backdrop.Color.r, oufdb.Backdrop.Color.g, oufdb.Backdrop.Color.b, oufdb.Backdrop.Color.a)
									_G[UF].FrameBackdrop:SetBackdropBorderColor(oufdb.Border.Color.r, oufdb.Border.Color.g, oufdb.Border.Color.b, oufdb.Border.Color.a)
								end,
								order = 18,
							},
						},
					},
					AlphaFader = {
						name = "Fader",
						type = "group",
						disabled = function() return (oufdb.Enable ~= nil and not oufdb.Enable or false) end,
						order = 8,
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
				disabled = function() return (oufdb.Enable ~= nil and not oufdb.Enable or false) end,
				childGroups = "tab",
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
										desc = "Decide the Height of your "..unit.." Health.\n\nDefault: "..luidefaults.Health.Height,
										type = "input",
										get = function() return oufdb.Health.Height end,
										set = function(self,Height)
											if Height == nil or Height == "" then Height = "0" end
											oufdb.Health.Height = Height
											_G[UF].Health:SetHeight(tonumber(Height))
										end,
										order = 1,
									},
									Padding = {
										name = "Padding",
										desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Health.Padding,
										type = "input",
										get = function() return oufdb.Health.Padding end,
										set = function(self,Padding)
											if Padding == nil or Padding == "" then Padding = "0" end
											oufdb.Health.Padding = Padding
											_G[UF].Health:ClearAllPoints()
											_G[UF].Health:SetPoint("TOPLEFT", _G[UF], "TOPLEFT", 0, tonumber(Padding))
											_G[UF].Health:SetPoint("TOPRIGHT", _G[UF], "TOPRIGHT", 0, tonumber(Padding))
										end,
										order = 2,
									},
									Smooth = {
										name = "Enable Smooth Bar Animation",
										desc = "Wether you want to use Smooth Animations or not.",
										type = "toggle",
										width = "full",
										get = function() return oufdb.Health.Smooth end,
										set = function(self,Smooth)
											oufdb.Health.Smooth = Smooth
											if Smooth then
												_G[UF]:SmoothBar(_G[UF].Health)
											else
												_G[UF].Health.SetValue = _G[UF].Health.SetValue_
											end
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
										get = function() return oufdb.Health.ColorClass end,
										set = function(self,HealthClassColor)
											oufdb.Health.ColorClass = true
											oufdb.Health.ColorGradient = false
											oufdb.Health.IndividualColor.Enable = false
											
											_G[UF].Health.colorClass = true
											_G[UF].Health.colorSmooth = false
											_G[UF].Health.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									HealthGradientColor = {
										name = "Color Gradient",
										desc = "Wether you want to use Gradient colored HealthBars or not.",
										type = "toggle",
										get = function() return oufdb.Health.ColorGradient end,
										set = function(self,HealthGradientColor)
											oufdb.Health.ColorGradient = true
											oufdb.Health.ColorClass = false
											oufdb.Health.IndividualColor.Enable = false
											
											_G[UF].Health.colorClass = false
											_G[UF].Health.colorSmooth = true
											_G[UF].Health.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
									IndividualHealthColor = {
										name = "Individual Color",
										desc = "Wether you want to use an individual HealthBar Color or not.",
										type = "toggle",
										get = function() return oufdb.Health.IndividualColor.Enable end,
										set = function(self,IndividualHealthColor)
											oufdb.Health.IndividualColor.Enable = true
											oufdb.Health.ColorClass = false
											oufdb.Health.ColorGradient = false
											
											_G[UF].Health.colorClass = false
											_G[UF].Health.colorSmooth = false
											_G[UF].Health.colorIndividual.Enable = true
											_G[UF]:UpdateAllElements()
										end,
										order = 3,
									},
									HealthColor = {
										name = "Individual Color",
										desc = "Choose an individual Healthbar Color.",
										type = "color",
										disabled = function() return not oufdb.Health.IndividualColor.Enable end,
										hasAlpha = false,
										get = function() return oufdb.Health.IndividualColor.r, oufdb.Health.IndividualColor.g, oufdb.Health.IndividualColor.b end,
										set = function(_,r,g,b)
											oufdb.Health.IndividualColor.r = r
											oufdb.Health.IndividualColor.g = g
											oufdb.Health.IndividualColor.b = b
											
											_G[UF].Health.colorIndividual = oufdb.Health.IndividualColor
											_G[UF]:UpdateAllElements()
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
										desc = "Choose your Health Texture!\nDefault: "..luidefaults.Health.Texture,
										type = "select",
										dialogControl = "LSM30_Statusbar",
										values = widgetLists.statusbar,
										get = function() return oufdb.Health.Texture end,
										set = function(self, HealthTex)
											oufdb.Health.Texture = HealthTex
											_G[UF].Health:SetStatusBarTexture(LSM:Fetch("statusbar", HealthTex))
										end,
										order = 1,
									},
									HealthTexBG = {
										name = "Background Texture",
										desc = "Choose your Health Background Texture!\nDefault: "..luidefaults.Health.TextureBG,
										type = "select",
										dialogControl = "LSM30_Statusbar",
										values = widgetLists.statusbar,
										get = function() return oufdb.Health.TextureBG end,
										set = function(self, HealthTexBG)
											oufdb.Health.TextureBG = HealthTexBG
											_G[UF].Health.bg:SetTexture(LSM:Fetch("statusbar", HealthTexBG))
										end,
										order = 2,
									},
									HealthTexBGAlpha = {
										name = "Background Alpha",
										desc = "Choose the Alpha Value for your Health Background.\nDefault: "..luidefaults.Health.BGAlpha,
										type = "range",
										min = 0,
										max = 1,
										step = 0.05,
										get = function() return oufdb.Health.BGAlpha end,
										set = function(_, HealthTexBGAlpha) 
											oufdb.Health.BGAlpha = HealthTexBGAlpha
											_G[UF].Health.bg:SetAlpha(HealthTexBGAlpha)
										end,
										order = 3,
									},
									HealthTexBGMultiplier = {
										name = "Background Muliplier",
										desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..luidefaults.Health.BGMultiplier,
										type = "range",
										min = 0,
										max = 1,
										step = 0.05,
										get = function() return oufdb.Health.BGMultiplier end,
										set = function(_, HealthTexBGMultiplier) 
											oufdb.Health.BGMultiplier = HealthTexBGMultiplier
											_G[UF].Health.bg.multiplier = HealthTexBGMultiplier
											_G[UF]:UpdateAllElements()
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
								get = function() return oufdb.Power.Enable end,
								set = function(self,EnablePower)
									oufdb.Power.Enable = EnablePower
									if EnablePower == true then
										_G[UF].Power:Show()
									else
										_G[UF].Power:Hide()
									end
								end,
								order = 1,
							},
							General = {
								name = "General Settings",
								type = "group",
								disabled = function() return not oufdb.Power.Enable end,
								guiInline = true,
								order = 2,
								args = {
									Height = {
										name = "Height",
										desc = "Decide the Height of your "..unit.." Power.\n\nDefault: "..luidefaults.Power.Height,
										type = "input",
										get = function() return oufdb.Power.Height end,
										set = function(self,Height)
											if Height == nil or Height == "" then Height = "0" end
											oufdb.Power.Height = Height
											_G[UF].Power:SetHeight(tonumber(Height))
										end,
										order = 1,
									},
									Padding = {
										name = "Padding",
										desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Power.Padding,
										type = "input",
										get = function() return oufdb.Power.Padding end,
										set = function(self,Padding)
											if Padding == nil or Padding == "" then Padding = "0" end
											oufdb.Power.Padding = Padding
											
											_G[UF].Power:ClearAllPoints()
											_G[UF].Power:SetPoint("TOPLEFT", _G[UF].Health, "BOTTOMLEFT", 0, tonumber(Padding))
											_G[UF].Power:SetPoint("TOPRIGHT", _G[UF].Health, "BOTTOMRIGHT", 0, tonumber(Padding))
										end,
										order = 2,
									},
									Smooth = {
										name = "Enable Smooth Bar Animation",
										desc = "Wether you want to use Smooth Animations or not.",
										type = "toggle",
										width = "full",
										get = function() return oufdb.Power.Smooth end,
										set = function(self,Smooth)
											oufdb.Power.Smooth = Smooth
											if Smooth then
												_G[UF]:SmoothBar(_G[UF].Power)
											else
												_G[UF].Power.SetValue = _G[UF].Power.SetValue_
											end
										end,
										order = 3,
									},
								}
							},
							Colors = {
								name = "Color Settings",
								type = "group",
								disabled = function() return not oufdb.Power.Enable end,
								guiInline = true,
								order = 3,
								args = {
									PowerClassColor = {
										name = "Color by Class",
										desc = "Wether you want to use class colored PowerBars or not.",
										type = "toggle",
										get = function() return oufdb.Power.ColorClass end,
										set = function(self,PowerClassColor)
											oufdb.Power.ColorClass = true
											oufdb.Power.ColorType = false
											oufdb.Power.IndividualColor.Enable = false
											
											_G[UF].Power.colorClass = true
											_G[UF].Power.colorType = false
											_G[UF].Power.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									PowerColorByType = {
										name = "Color by Type",
										desc = "Wether you want to use Power Type colored PowerBars or not.",
										type = "toggle",
										get = function() return oufdb.Power.ColorType end,
										set = function(self,PowerColorByType)
											oufdb.Power.ColorType = true
											oufdb.Power.ColorClass = false
											oufdb.Power.IndividualColor.Enable = false
											
											_G[UF].Power.colorType = true
											_G[UF].Power.colorClass = false
											_G[UF].Power.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
									IndividualPowerColor = {
										name = "Individual Color",
										desc = "Wether you want to use an individual PowerBar Color or not.",
										type = "toggle",
										get = function() return oufdb.Power.IndividualColor.Enable end,
										set = function(self,IndividualPowerColor)
											oufdb.Power.IndividualColor.Enable = true
											oufdb.Power.ColorType = false
											oufdb.Power.ColorClass = false
											
											_G[UF].Power.colorIndividual.Enable = true
											_G[UF].Power.colorClass = false
											_G[UF].Power.colorType = false
											_G[UF]:UpdateAllElements()
										end,
										order = 3,
									},
									PowerColor = {
										name = "Individual Color",
										desc = "Choose an individual Powerbar Color.",
										type = "color",
										disabled = function() return not oufdb.Power.IndividualColor.Enable end,
										hasAlpha = false,
										get = function() return oufdb.Power.IndividualColor.r, oufdb.Power.IndividualColor.g, oufdb.Power.IndividualColor.b end,
										set = function(_,r,g,b)
											oufdb.Power.IndividualColor.r = r
											oufdb.Power.IndividualColor.g = g
											oufdb.Power.IndividualColor.b = b
											
											_G[UF].Power.colorIndividual = oufdb.Power.IndividualColor
											_G[UF]:UpdateAllElements()
										end,
										order = 4,
									},
								},
							},
							Textures = {
								name = "Texture Settings",
								type = "group",
								disabled = function() return not oufdb.Power.Enable end,
								guiInline = true,
								order = 4,
								args = {
									PowerTex = {
										name = "Texture",
										desc = "Choose your Power Texture!\nDefault: "..luidefaults.Power.Texture,
										type = "select",
										dialogControl = "LSM30_Statusbar",
										values = widgetLists.statusbar,
										get = function() return oufdb.Power.Texture end,
										set = function(self, PowerTex)
											oufdb.Power.Texture = PowerTex
											_G[UF].Power:SetStatusBarTexture(LSM:Fetch("statusbar", PowerTex))
										end,
										order = 1,
									},
									PowerTexBG = {
										name = "Background Texture",
										desc = "Choose your Power Background Texture!\nDefault: "..luidefaults.Power.TextureBG,
										type = "select",
										dialogControl = "LSM30_Statusbar",
										values = widgetLists.statusbar,
										get = function() return oufdb.Power.TextureBG end,
										set = function(self, PowerTexBG)
											oufdb.Power.TextureBG = PowerTexBG
											_G[UF].Power.bg:SetTexture(LSM:Fetch("statusbar", PowerTexBG))
										end,
										order = 2,
									},
									PowerTexBGAlpha = {
										name = "Background Alpha",
										desc = "Choose the Alpha Value for your Power Background.\nDefault: "..luidefaults.Power.BGAlpha,
										type = "range",
										min = 0,
										max = 1,
										step = 0.05,
										get = function() return oufdb.Power.BGAlpha end,
										set = function(_, PowerTexBGAlpha) 
											oufdb.Power.BGAlpha = PowerTexBGAlpha
											_G[UF].Power.bg:SetAlpha(PowerTexBGAlpha)
										end,
										order = 3,
									},
									PowerTexBGMultiplier = {
										name = "Background Muliplier",
										desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..luidefaults.Power.BGMultiplier,
										type = "range",
										min = 0,
										max = 1,
										step = 0.05,
										get = function() return oufdb.Power.BGMultiplier end,
										set = function(_, PowerTexBGMultiplier) 
											oufdb.Power.BGMultiplier = PowerTexBGMultiplier
											_G[UF].Power.bg.multiplier = PowerTexBGMultiplier
											_G[UF]:UpdateAllElements()
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
								get = function() return oufdb.Full.Enable end,
								set = function(self,EnableFullbar)
									oufdb.Full.Enable = EnableFullbar
									if EnableFullbar then
										_G[UF].Full:Show()
									else
										_G[UF].Full:Hide()
									end
								end,
								order = 1,
							},
							General = {
								name = "Settings",
								type = "group",
								disabled = function() return not oufdb.Full.Enable end,
								guiInline = true,
								order = 2,
								args = {
									Height = {
										name = "Height",
										desc = "Decide the Height of your Fullbar.\n\nDefault: "..luidefaults.Full.Height,
										type = "input",
										get = function() return oufdb.Full.Height end,
										set = function(self,Height)
											if Height == nil or Height == "" then Height = "0" end
											oufdb.Full.Height = Height
											_G[UF].Full:SetHeight(tonumber(Height))
										end,
										order = 1,
									},
									Padding = {
										name = "Padding",
										desc = "Choose the Padding between Health & Fullbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Full.Padding,
										type = "input",
										get = function() return oufdb.Full.Padding end,
										set = function(self,Padding)
											if Padding == nil or Padding == "" then Padding = "0" end
											oufdb.Full.Padding = Padding
											_G[UF].Full:ClearAllPoints()
											_G[UF].Full:SetPoint("TOPLEFT", _G[UF].Health, "BOTTOMLEFT", 0, tonumber(Padding))
											_G[UF].Full:SetPoint("TOPRIGHT", _G[UF].Health, "BOTTOMRIGHT", 0, tonumber(Padding))
										end,
										order = 2,
									},
									FullTex = {
										name = "Texture",
										desc = "Choose your Fullbar Texture!\nDefault: "..luidefaults.Full.Texture,
										type = "select",
										dialogControl = "LSM30_Statusbar",
										values = widgetLists.statusbar,
										get = function() return oufdb.Full.Texture end,
										set = function(self, FullTex)
											oufdb.Full.Texture = FullTex
											_G[UF].Full:SetStatusBarTexture(LSM:Fetch("statusbar", FullTex))
										end,
										order = 3,
									},
									FullAlpha = {
										name = "Alpha",
										desc = "Choose the Alpha Value for your Fullbar!\n Default: "..luidefaults.Full.Alpha,
										type = "range",
										min = 0,
										max = 1,
										step = 0.05,
										get = function() return oufdb.Full.Alpha end,
										set = function(_, FullAlpha)
											oufdb.Full.Alpha = FullAlpha
											_G[UF].Full:SetAlpha(FullAlpha)
										end,
										order = 4,
									},
									Color = {
										name = "Color",
										desc = "Choose your Fullbar Color.",
										type = "color",
										hasAlpha = true,
										get = function() return oufdb.Full.Color.r, oufdb.Full.Color.g, oufdb.Full.Color.b, oufdb.Full.Color.a end,
										set = function(_,r,g,b,a)
											oufdb.Full.Color.r = r
											oufdb.Full.Color.g = g
											oufdb.Full.Color.b = b
											oufdb.Full.Color.a = a
											_G[UF].Full:SetStatusBarColor(r,g,b,a)
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
				disabled = function() return (oufdb.Enable ~= nil and not oufdb.Enable or false) end,
				childGroups = "tab",
				order = 6,
				args = {
					Name = {
						name = "Name",
						type = "group",
						order = 1,
						args = {
							Enable = {
								name = "Enable",
								desc = "Wether you want to show the "..unit.." Name or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Texts.Name.Enable end,
								set = function(self,Enable)
									oufdb.Texts.Name.Enable = Enable
									_G[UF].Info.Enable = Enable
									if Enable == true then
										_G[UF].Info:Show()
									else
										_G[UF].Info:Hide()
									end
								end,
								order = 1,
							},
							FontSettings = {
								name = "Font Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.Name.Enable end,
								guiInline = true,
								order = 1,
								args = {
									FontSize = {
										name = "Size",
										desc = "Choose your "..unit.." Name Fontsize!\n Default: "..luidefaults.Texts.Name.Size,
										type = "range",
										min = 1,
										max = 40,
										step = 1,
										get = function() return oufdb.Texts.Name.Size end,
										set = function(_, FontSize)
											oufdb.Texts.Name.Size = FontSize
											_G[UF].Info:SetFont(LSM:Fetch("font", oufdb.Texts.Name.Font),FontSize,oufdb.Texts.Name.Outline)
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
										desc = "Choose your Font for "..unit.." Name!\n\nDefault: "..luidefaults.Texts.Name.Font,
										type = "select",
										dialogControl = "LSM30_Font",
										values = widgetLists.font,
										get = function() return oufdb.Texts.Name.Font end,
										set = function(self, Font)
											oufdb.Texts.Name.Font = Font
											_G[UF].Info:SetFont(LSM:Fetch("font", Font),oufdb.Texts.Name.Size,oufdb.Texts.Name.Outline)
										end,
										order = 3,
									},
									FontFlag = {
										name = "Font Flag",
										desc = "Choose the Font Flag for your "..unit.." Name.\nDefault: "..luidefaults.Texts.Name.Outline,
										type = "select",
										values = fontflags,
										get = function()
											for k, v in pairs(fontflags) do
												if oufdb.Texts.Name.Outline == v then
													return k
												end
											end
										end,
										set = function(self, FontFlag)
											oufdb.Texts.Name.Outline = fontflags[FontFlag]
											_G[UF].Info:SetFont(LSM:Fetch("font", oufdb.Texts.Name.Font),oufdb.Texts.Name.Size,fontflags[FontFlag])
										end,
										order = 4,
									},
									NameX = {
										name = "X Value",
										desc = "X Value for your "..unit.." Name.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Texts.Name.X,
										type = "input",
										get = function() return oufdb.Texts.Name.X end,
										set = function(self,NameX)
											if NameX == nil or NameX == "" then NameX = "0" end
											oufdb.Texts.Name.X = NameX
											_G[UF].Info:ClearAllPoints()
											_G[UF].Info:SetPoint(oufdb.Texts.Name.Point, _G[UF], oufdb.Texts.Name.RelativePoint, tonumber(NameX), tonumber(oufdb.Texts.Name.Y))
										end,
										order = 5,
									},
									NameY = {
										name = "Y Value",
										desc = "Y Value for your "..unit.." Name.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Texts.Name.Y,
										type = "input",
										get = function() return oufdb.Texts.Name.Y end,
										set = function(self,NameY)
											if NameY == nil or NameY == "" then NameY = "0" end
											oufdb.Texts.Name.Y = NameY
											_G[UF].Info:ClearAllPoints()
											_G[UF].Info:SetPoint(oufdb.Texts.Name.Point, _G[UF], oufdb.Texts.Name.RelativePoint, tonumber(oufdb.Texts.Name.X), tonumber(NameY))
										end,
										order = 6,
									},
									Point = {
										name = "Point",
										desc = "Choose the Position for your "..unit.." Name.\nDefault: "..luidefaults.Texts.Name.Point,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.Name.Point == v then
													return k
												end
											end
										end,
										set = function(self, Point)
											oufdb.Texts.Name.Point = positions[Point]
											_G[UF].Info:ClearAllPoints()
											_G[UF].Info:SetPoint(positions[Point], _G[UF], oufdb.Texts.Name.RelativePoint, tonumber(oufdb.Texts.Name.X), tonumber(oufdb.Texts.Name.Y))
										end,
										order = 7,
									},
									RelativePoint = {
										name = "RelativePoint",
										desc = "Choose the RelativePoint for your "..unit.." Name.\nDefault: "..luidefaults.Texts.Name.RelativePoint,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.Name.RelativePoint == v then
													return k
												end
											end
										end,
										set = function(self, RelativePoint)
											oufdb.Texts.Name.RelativePoint = positions[RelativePoint]
											_G[UF].Info:ClearAllPoints()
											_G[UF].Info:SetPoint(oufdb.Texts.Name.Point, _G[UF], positions[RelativePoint], tonumber(oufdb.Texts.Name.X), tonumber(oufdb.Texts.Name.Y))
										end,
										order = 8,
									},
								},
							},
							Settings = {
								name = "Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.Name.Enable end,
								guiInline = true,
								order = 2,
								args = {
									Format = {
										name = "Format",
										desc = "Choose the Format for your "..unit.." Name.\nDefault: "..luidefaults.Texts.Name.Format,
										type = "select",
										width = "full",
										values = nameFormat,
										get = function()
											for k, v in pairs(nameFormat) do
												if oufdb.Texts.Name.Format == v then
													return k
												end
											end
										end,
										set = function(self, Format)
											oufdb.Texts.Name.Format = nameFormat[Format]
											_G[UF].Info.Format = nameFormat[Format]
											_G[UF]:FormatName()
										end,
										order = 1,
									},
									Length = {
										name = "Length",
										desc = "Choose the Length of your "..unit.." Name.\n\nShort = 6 Letters\nMedium = 18 Letters\nLong = 36 Letters\n\nDefault: "..luidefaults.Texts.Name.Length,
										type = "select",
										values = nameLenghts,
										get = function()
											for k, v in pairs(nameLenghts) do
												if oufdb.Texts.Name.Length == v then
													return k
												end
											end
										end,
										set = function(self, Length)
											oufdb.Texts.Name.Length = nameLenghts[Length]
											_G[UF].Info.Length = nameLengths[Length]
											_G[UF]:FormatName()
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
										desc = "Wether you want to color the "..unit.." Name by Class or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Name.ColorNameByClass end,
										set = function(self,ColorNameByClass)
											oufdb.Texts.Name.ColorNameByClass = ColorNameByClass
											_G[UF].Info.ColorNameByClass = ColorNameByClass
											_G[UF]:FormatName()
										end,
										order = 4,
									},
									ColorClassByClass = {
										name = "Color Class by Class",
										desc = "Wether you want to color the "..unit.." Class by Class or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Name.ColorClassByClass end,
										set = function(self,ColorClassByClass)
											oufdb.Texts.Name.ColorClassByClass = ColorClassByClass
											_G[UF].Info.ColorClassByClass = ColorClassByClass
											_G[UF]:FormatName()
										end,
										order = 5,
									},
									ColorLevelByDifficulty = {
										name = "Color Level by Difficulty",
										desc = "Wether you want to color the Level by Difficulty or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Name.ColorLevelByDifficulty end,
										set = function(self,ColorLevelByDifficulty)
											oufdb.Texts.Name.ColorLevelByDifficulty = ColorLevelByDifficulty
											_G[UF].Info.ColorLevelByDifficulty = ColorLevelByDifficulty
											_G[UF]:FormatName()
										end,
										order = 6,
									},
									ShowClassification = {
										name = "Show Classification",
										desc = "Wether you want to show Classifications like Elite, Boss, Rar or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Name.ShowClassification end,
										set = function(self,ShowClassification)
											oufdb.Texts.Name.ShowClassification = ShowClassification
											_G[UF].Info.ShowClassification = ShowClassification
											_G[UF]:FormatName()
										end,
										order = 7,
									},
									ShortClassification = {
										name = "Enable Short Classification",
										desc = "Wether you want to show short Classifications or not.",
										type = "toggle",
										width = "full",
										disabled = function() return not oufdb.Texts.Name.ShowClassification end,
										get = function() return oufdb.Texts.Name.ShortClassification end,
										set = function(self,ShortClassification)
											oufdb.Texts.Name.ShortClassification = ShortClassification
											_G[UF].Info.ShortClassification = ShortClassification
											_G[UF]:FormatName()
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
								desc = "Wether you want to show the "..unit.." Health or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Texts.Health.Enable end,
								set = function(self,Enable)
									oufdb.Texts.Health.Enable = Enable
									_G[UF].Health.value.Enable = Enable
									if Enable == true then
										_G[UF].Health.value:Show()
									else
										_G[UF].Health.value:Hide()
									end
								end,
								order = 1,
							},
							FontSettings = {
								name = "Font Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.Health.Enable end,
								guiInline = true,
								order = 2,
								args = {
									FontSize = {
										name = "Size",
										desc = "Choose your "..unit.." Health Fontsize!\n Default: "..luidefaults.Texts.Health.Size,
										type = "range",
										min = 1,
										max = 40,
										step = 1,
										get = function() return oufdb.Texts.Health.Size end,
										set = function(_, FontSize)
											oufdb.Texts.Health.Size = FontSize
											_G[UF].Health.value:SetFont(LSM:Fetch("font", oufdb.Texts.Health.Font),oufdb.Texts.Health.Size,oufdb.Texts.Health.Outline)
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
										desc = "Choose your Font for "..unit.." Health!\n\nDefault: "..luidefaults.Texts.Health.Font,
										type = "select",
										dialogControl = "LSM30_Font",
										values = widgetLists.font,
										get = function() return oufdb.Texts.Health.Font end,
										set = function(self, Font)
											oufdb.Texts.Health.Font = Font
											_G[UF].Health.value:SetFont(LSM:Fetch("font", oufdb.Texts.Health.Font),oufdb.Texts.Health.Size,oufdb.Texts.Health.Outline)
										end,
										order = 3,
									},
									FontFlag = {
										name = "Font Flag",
										desc = "Choose the Font Flag for your "..unit.." Health.\nDefault: "..luidefaults.Texts.Health.Outline,
										type = "select",
										values = fontflags,
										get = function()
											for k, v in pairs(fontflags) do
												if oufdb.Texts.Health.Outline == v then
													return k
												end
											end
										end,
										set = function(self, FontFlag)
											oufdb.Texts.Health.Outline = fontflags[FontFlag]
											_G[UF].Health.value:SetFont(LSM:Fetch("font", oufdb.Texts.Health.Font),oufdb.Texts.Health.Size,oufdb.Texts.Health.Outline)
										end,
										order = 4,
									},
									HealthX = {
										name = "X Value",
										desc = "X Value for your "..unit.." Health.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Texts.Health.X,
										type = "input",
										get = function() return oufdb.Texts.Health.X end,
										set = function(self,HealthX)
											if HealthX == nil or HealthX == "" then HealthX = "0" end
											oufdb.Texts.Health.X = HealthX
											_G[UF].Health.value:ClearAllPoints()
											_G[UF].Health.value:SetPoint(oufdb.Texts.Health.Point, _G[UF], oufdb.Texts.Health.RelativePoint, tonumber(oufdb.Texts.Health.X), tonumber(oufdb.Texts.Health.Y))
										end,
										order = 5,
									},
									HealthY = {
										name = "Y Value",
										desc = "Y Value for your "..unit.." Health.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Texts.Health.Y,
										type = "input",
										get = function() return oufdb.Texts.Health.Y end,
										set = function(self,HealthY)
											if HealthY == nil or HealthY == "" then HealthY = "0" end
											oufdb.Texts.Health.Y = HealthY
											_G[UF].Health.value:ClearAllPoints()
											_G[UF].Health.value:SetPoint(oufdb.Texts.Health.Point, _G[UF], oufdb.Texts.Health.RelativePoint, tonumber(oufdb.Texts.Health.X), tonumber(oufdb.Texts.Health.Y))
										end,
										order = 6,
									},
									Point = {
										name = "Point",
										desc = "Choose the Position for your "..unit.." Health.\nDefault: "..luidefaults.Texts.Health.Point,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.Health.Point == v then
													return k
												end
											end
										end,
										set = function(self, Point)
											oufdb.Texts.Health.Point = positions[Point]
											_G[UF].Health.value:ClearAllPoints()
											_G[UF].Health.value:SetPoint(oufdb.Texts.Health.Point, _G[UF], oufdb.Texts.Health.RelativePoint, tonumber(oufdb.Texts.Health.X), tonumber(oufdb.Texts.Health.Y))
										end,
										order = 7,
									},
									RelativePoint = {
										name = "RelativePoint",
										desc = "Choose the RelativePoint for your "..unit.." Health.\nDefault: "..luidefaults.Texts.Health.RelativePoint,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.Health.RelativePoint == v then
													return k
												end
											end
										end,
										set = function(self, RelativePoint)
											oufdb.Texts.Health.RelativePoint = positions[RelativePoint]
											_G[UF].Health.value:ClearAllPoints()
											_G[UF].Health.value:SetPoint(oufdb.Texts.Health.Point, _G[UF], oufdb.Texts.Health.RelativePoint, tonumber(oufdb.Texts.Health.X), tonumber(oufdb.Texts.Health.Y))
										end,
										order = 8,
									},
								},
							},
							Settings = {
								name = "Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.Health.Enable end,
								guiInline = true,
								order = 3,
								args = {
									Format = {
										name = "Format",
										desc = "Choose the Format for your "..unit.." Health.\nDefault: "..luidefaults.Texts.Health.Format,
										type = "select",
										values = valueFormat,
										get = function()
											for k, v in pairs(valueFormat) do
												if oufdb.Texts.Health.Format == v then
													return k
												end
											end
										end,
										set = function(self, Format)
											oufdb.Texts.Health.Format = valueFormat[Format]
											_G[UF].Health.value.Format = valueFormat[Format]
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									empty = {
										name = " ",
										type = "description",
										width = "full",
										order = 2,
									},
									ShowAlways = {
										name = "Show Always",
										desc = "Always show "..unit.." Health or just if the Unit is not at Max HP.",
										type = "toggle",
										get = function() return oufdb.Texts.Health.ShowAlways end,
										set = function(self,ShowAlways)
											oufdb.Texts.Health.ShowAlways = ShowAlways
											_G[UF].Health.value.ShowAlways = ShowAlways
											_G[UF]:UpdateAllElements()
										end,
										order = 3,
									},
									ShowDead = {
										name = "Show Dead/AFK/Disconnected Information",
										desc = "Wether you want to switch the Health Value to Dead/AFK/Disconnected or not.",
										type = "toggle",
										width = "full",
										get = function() return oufdb.Texts.Health.ShowDead end,
										set = function(self,ShowDead)
											oufdb.Texts.Health.ShowDead = ShowDead
											_G[UF].Health.value.ShowDead = ShowDead
											_G[UF]:UpdateAllElements()
										end,
										order = 4,
									},
								},
							},
							Colors = {
								name = "Color Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.Health.Enable end,
								guiInline = true,
								order = 4,
								args = {
									ClassColor = {
										name = "Color by Class",
										desc = "Wether you want to use class colored Health Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Health.ColorClass end,
										set = function(self,ClassColor)
											oufdb.Texts.Health.ColorClass = true
											oufdb.Texts.Health.ColorGradient = false
											oufdb.Texts.Health.IndividualColor.Enable = false
												
											_G[UF].Health.value.colorClass = true
											_G[UF].Health.value.colorGradient = false
											_G[UF].Health.value.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									ColorGradient = {
										name = "Color Gradient",
										desc = "Wether you want to use Gradient colored Health Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Health.ColorGradient end,
										set = function(self,ColorGradient)
											oufdb.Texts.Health.ColorGradient = true
											oufdb.Texts.Health.ColorClass = false
											oufdb.Texts.Health.IndividualColor.Enable = false
											
											_G[UF].Health.value.colorGradient = true
											_G[UF].Health.value.colorClass = false
											_G[UF].Health.value.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
									IndividualColor = {
										name = "Individual Color",
										desc = "Wether you want to use an individual "..unit.." Health Value Color or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Health.IndividualColor.Enable end,
										set = function(self,IndividualColor)
											oufdb.Texts.Health.IndividualColor.Enable = true
											oufdb.Texts.Health.ColorClass = false
											oufdb.Texts.Health.ColorGradient = false
											
											_G[UF].Health.value.colorIndividual.Enable = true
											_G[UF].Health.value.colorClass = false
											_G[UF].Health.value.colorGradient = false
											_G[UF]:UpdateAllElements()
										end,
										order = 3,
									},
									Color = {
										name = "Individual Color",
										desc = "Choose an individual "..unit.." Health Value Color.",
										type = "color",
										disabled = function() return not oufdb.Texts.Health.IndividualColor.Enable end,
										hasAlpha = false,
										get = function() return oufdb.Texts.Health.IndividualColor.r, oufdb.Texts.Health.IndividualColor.g, oufdb.Texts.Health.IndividualColor.b end,
										set = function(_,r,g,b)
											oufdb.Texts.Health.IndividualColor.r = r
											oufdb.Texts.Health.IndividualColor.g = g
											oufdb.Texts.Health.IndividualColor.b = b
											
											_G[UF].Health.value.colorIndividual = oufdb.Texts.Health.IndividualColor
											_G[UF]:UpdateAllElements()
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
						disabled = function() return not oufdb.Power.Enable end,
						order = 3,
						args = {
							Enable = {
								name = "Enable",
								desc = "Wether you want to show the "..unit.." Power or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Texts.Power.Enable end,
								set = function(self,Enable)
									oufdb.Texts.Power.Enable = Enable
									if Enable == true then
										_G[UF].Power.value:Show()
									else
										_G[UF].Power.value:Hide()
									end
								end,
								order = 1,
							},
							FontSettings = {
								name = "Font Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.Power.Enable end,
								guiInline = true,
								order = 2,
								args = {
									FontSize = {
										name = "Size",
										desc = "Choose your "..unit.." Power Fontsize!\n Default: "..luidefaults.Texts.Power.Size,
										type = "range",
										min = 1,
										max = 40,
										step = 1,
										get = function() return oufdb.Texts.Power.Size end,
										set = function(_, FontSize)
											oufdb.Texts.Power.Size = FontSize
											_G[UF].Power.value:SetFont(LSM:Fetch("font", oufdb.Texts.Power.Font),oufdb.Texts.Power.Size,oufdb.Texts.Power.Outline)
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
										desc = "Choose your Font for "..unit.." Power!\n\nDefault: "..luidefaults.Texts.Power.Font,
										type = "select",
										dialogControl = "LSM30_Font",
										values = widgetLists.font,
										get = function() return oufdb.Texts.Power.Font end,
										set = function(self, Font)
											oufdb.Texts.Power.Font = Font
											_G[UF].Power.value:SetFont(LSM:Fetch("font", oufdb.Texts.Power.Font),oufdb.Texts.Power.Size,oufdb.Texts.Power.Outline)
										end,
										order = 3,
									},
									FontFlag = {
										name = "Font Flag",
										desc = "Choose the Font Flag for your "..unit.." Power.\nDefault: "..luidefaults.Texts.Power.Outline,
										type = "select",
										values = fontflags,
										get = function()
											for k, v in pairs(fontflags) do
												if oufdb.Texts.Power.Outline == v then
													return k
												end
											end
										end,
										set = function(self, FontFlag)
											oufdb.Texts.Power.Outline = fontflags[FontFlag]
											_G[UF].Power.value:SetFont(LSM:Fetch("font", oufdb.Texts.Power.Font),oufdb.Texts.Power.Size,oufdb.Texts.Power.Outline)
										end,
										order = 4,
									},
									PowerX = {
										name = "X Value",
										desc = "X Value for your "..unit.." Power.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Texts.Power.X,
										type = "input",
										get = function() return oufdb.Texts.Power.X end,
										set = function(self,PowerX)
											if PowerX == nil or PowerX == "" then PowerX = "0" end
											oufdb.Texts.Power.X = PowerX
											_G[UF].Power.value:ClearAllPoints()
											_G[UF].Power.value:SetPoint(oufdb.Texts.Power.Point, _G[UF], oufdb.Texts.Power.RelativePoint, tonumber(oufdb.Texts.Power.X), tonumber(oufdb.Texts.Power.Y))
										end,
										order = 5,
									},
									PowerY = {
										name = "Y Value",
										desc = "Y Value for your "..unit.." Power.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Texts.Power.Y,
										type = "input",
										get = function() return oufdb.Texts.Power.Y end,
										set = function(self,PowerY)
											if PowerY == nil or PowerY == "" then PowerY = "0" end
											oufdb.Texts.Power.Y = PowerY
											_G[UF].Power.value:ClearAllPoints()
											_G[UF].Power.value:SetPoint(oufdb.Texts.Power.Point, _G[UF], oufdb.Texts.Power.RelativePoint, tonumber(oufdb.Texts.Power.X), tonumber(oufdb.Texts.Power.Y))
										end,
										order = 6,
									},
									Point = {
										name = "Point",
										desc = "Choose the Position for your "..unit.." Power.\nDefault: "..luidefaults.Texts.Power.Point,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.Power.Point == v then
													return k
												end
											end
										end,
										set = function(self, Point)
											oufdb.Texts.Power.Point = positions[Point]
											_G[UF].Power.value:ClearAllPoints()
											_G[UF].Power.value:SetPoint(oufdb.Texts.Power.Point, _G[UF], oufdb.Texts.Power.RelativePoint, tonumber(oufdb.Texts.Power.X), tonumber(oufdb.Texts.Power.Y))
										end,
										order = 7,
									},
									RelativePoint = {
										name = "RelativePoint",
										desc = "Choose the RelativePoint for your "..unit.." Power.\nDefault: "..luidefaults.Texts.Power.RelativePoint,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.Power.RelativePoint == v then
													return k
												end
											end
										end,
										set = function(self, RelativePoint)
											oufdb.Texts.Power.RelativePoint = positions[RelativePoint]
											_G[UF].Power.value:ClearAllPoints()
											_G[UF].Power.value:SetPoint(oufdb.Texts.Power.Point, _G[UF], oufdb.Texts.Power.RelativePoint, tonumber(oufdb.Texts.Power.X), tonumber(oufdb.Texts.Power.Y))
										end,
										order = 8,
									},
								},
							},
							Settings = {
								name = "Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.Power.Enable end,
								guiInline = true,
								order = 3,
								args = {
									Format = {
										name = "Format",
										desc = "Choose the Format for your "..unit.." Power.\nDefault: "..luidefaults.Texts.Power.Format,
										type = "select",
										values = valueFormat,
										get = function()
											for k, v in pairs(valueFormat) do
												if oufdb.Texts.Power.Format == v then
													return k
												end
											end
										end,
										set = function(self, Format)
											oufdb.Texts.Power.Format = valueFormat[Format]
											_G[UF].Power.value.Format = valueFormat[Format]
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									empty = {
										name = " ",
										type = "description",
										width = "full",
										order = 2,
									},
									ShowAlways = {
										name = "Show Always",
										desc = "Always show "..unit.." Power or just if the Unit is not at Max Power.",
										type = "toggle",
										get = function() return oufdb.Texts.Power.ShowAlways end,
										set = function(self,ShowAlways)
											oufdb.Texts.Power.ShowAlways = ShowAlways
											_G[UF].Power.value.ShowAlways = ShowAlways
											_G[UF]:UpdateAllElements()
										end,
										order = 3,
									},
								},
							},
							Colors = {
								name = "Color Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.Power.Enable end,
								guiInline = true,
								order = 4,
								args = {
									ClassColor = {
										name = "Color by Class",
										desc = "Wether you want to use class colored Power Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Power.ColorClass end,
										set = function(self,ClassColor)
											oufdb.Texts.Power.ColorClass = true
											oufdb.Texts.Power.ColorType = false
											oufdb.Texts.Power.IndividualColor.Enable = false
											
											_G[UF].Power.value.colorClass = true
											_G[UF].Power.value.colorType = false
											_G[UF].Power.value.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									ColorType = {
										name = "Color by Type",
										desc = "Wether you want to use Powertype colored Power Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Power.ColorType end,
										set = function(self,ColorType)
											oufdb.Texts.Power.ColorType = true
											oufdb.Texts.Power.ColorClass = false
											oufdb.Texts.Power.IndividualColor.Enable = false
											
											_G[UF].Power.value.colorClass = false
											_G[UF].Power.value.colorType = true
											_G[UF].Power.value.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
									IndividualColor = {
										name = "Individual Color",
										desc = "Wether you want to use an individual "..unit.." Power Value Color or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Power.IndividualColor.Enable end,
										set = function(self,IndividualColor)
											oufdb.Texts.Power.IndividualColor.Enable = true
											oufdb.Texts.Power.ColorClass = false
											oufdb.Texts.Power.ColorType = false
											
											_G[UF].Power.value.colorClass = false
											_G[UF].Power.value.colorType = false
											_G[UF].Power.value.colorIndividual.Enable = true
											_G[UF]:UpdateAllElements()
										end,
										order = 3,
									},
									Color = {
										name = "Individual Color",
										desc = "Choose an individual "..unit.." Power Value Color.",
										type = "color",
										disabled = function() return not oufdb.Texts.Power.IndividualColor.Enable end,
										hasAlpha = false,
										get = function() return oufdb.Texts.Power.IndividualColor.r, oufdb.Texts.Power.IndividualColor.g, oufdb.Texts.Power.IndividualColor.b end,
										set = function(_,r,g,b)
											oufdb.Texts.Power.IndividualColor.r = r
											oufdb.Texts.Power.IndividualColor.g = g
											oufdb.Texts.Power.IndividualColor.b = b
											
											_G[UF].Power.value.colorIndividual = oufdb.Texts.Power.IndividualColor
											_G[UF]:UpdateAllElements()
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
								desc = "Wether you want to show the "..unit.." HealthPercent or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Texts.HealthPercent.Enable end,
								set = function(self,Enable)
									oufdb.Texts.HealthPercent.Enable = Enable
									_G[UF].Health.valuePercent.Enable = Enable
									if Enable == true then
										_G[UF].Health.valuePercent:Show()
									else
										_G[UF].Health.valuePercent:Hide()
									end
								end,
								order = 1,
							},
							FontSettings = {
								name = "Font Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.HealthPercent.Enable end,
								guiInline = true,
								order = 2,
								args = {
									FontSize = {
										name = "Size",
										desc = "Choose your "..unit.." HealthPercent Fontsize!\n Default: "..luidefaults.Texts.HealthPercent.Size,
										type = "range",
										min = 1,
										max = 40,
										step = 1,
										get = function() return oufdb.Texts.HealthPercent.Size end,
										set = function(_, FontSize)
											oufdb.Texts.HealthPercent.Size = FontSize
											_G[UF].Health.valuePercent:SetFont(LSM:Fetch("font", oufdb.Texts.HealthPercent.Font),oufdb.Texts.HealthPercent.Size,oufdb.Texts.HealthPercent.Outline)
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
										desc = "Choose your Font for "..unit.." HealthPercent!\n\nDefault: "..luidefaults.Texts.HealthPercent.Font,
										type = "select",
										dialogControl = "LSM30_Font",
										values = widgetLists.font,
										get = function() return oufdb.Texts.HealthPercent.Font end,
										set = function(self, Font)
											oufdb.Texts.HealthPercent.Font = Font
											_G[UF].Health.valuePercent:SetFont(LSM:Fetch("font", oufdb.Texts.HealthPercent.Font),oufdb.Texts.HealthPercent.Size,oufdb.Texts.HealthPercent.Outline)
										end,
										order = 3,
									},
									FontFlag = {
										name = "Font Flag",
										desc = "Choose the Font Flag for your "..unit.." HealthPercent.\nDefault: "..luidefaults.Texts.HealthPercent.Outline,
										type = "select",
										values = fontflags,
										get = function()
											for k, v in pairs(fontflags) do
												if oufdb.Texts.HealthPercent.Outline == v then
													return k
												end
											end
										end,
										set = function(self, FontFlag)
											oufdb.Texts.HealthPercent.Outline = fontflags[FontFlag]
											_G[UF].Health.valuePercent:SetFont(LSM:Fetch("font", oufdb.Texts.HealthPercent.Font),oufdb.Texts.HealthPercent.Size,oufdb.Texts.HealthPercent.Outline)
										end,
										order = 4,
									},
									HealthPercentX = {
										name = "X Value",
										desc = "X Value for your "..unit.." HealthPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Texts.HealthPercent.X,
										type = "input",
										get = function() return oufdb.Texts.HealthPercent.X end,
										set = function(self,HealthPercentX)
											if HealthPercentX == nil or HealthPercentX == "" then HealthPercentX = "0" end
											oufdb.Texts.HealthPercent.X = HealthPercentX
											_G[UF].Health.valuePercent:ClearAllPoints()
											_G[UF].Health.valuePercent:SetPoint(oufdb.Texts.HealthPercent.Point, _G[UF], oufdb.Texts.HealthPercent.RelativePoint, tonumber(oufdb.Texts.HealthPercent.X), tonumber(oufdb.Texts.HealthPercent.Y))
										end,
										order = 5,
									},
									HealthPercentY = {
										name = "Y Value",
										desc = "Y Value for your "..unit.." HealthPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Texts.HealthPercent.Y,
										type = "input",
										get = function() return oufdb.Texts.HealthPercent.Y end,
										set = function(self,HealthPercentY)
											if HealthPercentY == nil or HealthPercentY == "" then HealthPercentY = "0" end
											oufdb.Texts.HealthPercent.Y = HealthPercentY
											_G[UF].Health.valuePercent:ClearAllPoints()
											_G[UF].Health.valuePercent:SetPoint(oufdb.Texts.HealthPercent.Point, _G[UF], oufdb.Texts.HealthPercent.RelativePoint, tonumber(oufdb.Texts.HealthPercent.X), tonumber(oufdb.Texts.HealthPercent.Y))
										end,
										order = 6,
									},
									Point = {
										name = "Point",
										desc = "Choose the Position for your "..unit.." HealthPercent.\nDefault: "..luidefaults.Texts.HealthPercent.Point,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.HealthPercent.Point == v then
													return k
												end
											end
										end,
										set = function(self, Point)
											oufdb.Texts.HealthPercent.Point = positions[Point]
											_G[UF].Health.valuePercent:ClearAllPoints()
											_G[UF].Health.valuePercent:SetPoint(oufdb.Texts.HealthPercent.Point, _G[UF], oufdb.Texts.HealthPercent.RelativePoint, tonumber(oufdb.Texts.HealthPercent.X), tonumber(oufdb.Texts.HealthPercent.Y))
										end,
										order = 7,
									},
									RelativePoint = {
										name = "RelativePoint",
										desc = "Choose the RelativePoint for your "..unit.." HealthPercent.\nDefault: "..luidefaults.Texts.HealthPercent.RelativePoint,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.HealthPercent.RelativePoint == v then
													return k
												end
											end
										end,
										set = function(self, RelativePoint)
											oufdb.Texts.HealthPercent.RelativePoint = positions[RelativePoint]
											_G[UF].Health.valuePercent:ClearAllPoints()
											_G[UF].Health.valuePercent:SetPoint(oufdb.Texts.HealthPercent.Point, _G[UF], oufdb.Texts.HealthPercent.RelativePoint, tonumber(oufdb.Texts.HealthPercent.X), tonumber(oufdb.Texts.HealthPercent.Y))
										end,
										order = 8,
									},
								},
							},
							Settings = {
								name = "Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.HealthPercent.Enable end,
								guiInline = true,
								order = 3,
								args = {
									ShowAlways = {
										name = "Show Always",
										desc = "Always show "..unit.." HealthPercent or just if the Unit has no MaxHP.",
										type = "toggle",
										get = function() return oufdb.Texts.HealthPercent.ShowAlways end,
										set = function(self,ShowAlways)
											oufdb.Texts.HealthPercent.ShowAlways = ShowAlways
											_G[UF].Health.valuePercent.ShowAlways = ShowAlways
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									ShowDead = {
										name = "Show Dead/AFK/Disconnected Information",
										desc = "Wether you want to switch the HealthPercent Value to Dead/AFK/Disconnected or not.",
										type = "toggle",
										width = "full",
										get = function() return oufdb.Texts.HealthPercent.ShowDead end,
										set = function(self,ShowDead)
											oufdb.Texts.HealthPercent.ShowDead = ShowDead
											_G[UF].Health.valuePercent.ShowDead = ShowDead
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
								},
							},
							Colors = {
								name = "Color Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.HealthPercent.Enable end,
								guiInline = true,
								order = 4,
								args = {
									ClassColor = {
										name = "Color by Class",
										desc = "Wether you want to use class colored HealthPercent Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.HealthPercent.ColorClass end,
										set = function(self,ClassColor)
											oufdb.Texts.HealthPercent.ColorClass = true
											oufdb.Texts.HealthPercent.ColorGradient = false
											oufdb.Texts.HealthPercent.IndividualColor.Enable = false
											
											_G[UF].Health.valuePercent.colorClass = true
											_G[UF].Health.valuePercent.colorGradient = false
											_G[UF].Health.valuePercent.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									ColorGradient = {
										name = "Color Gradient",
										desc = "Wether you want to use Gradient colored HealthPercent Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.HealthPercent.ColorGradient end,
										set = function(self,ColorGradient)
											oufdb.Texts.HealthPercent.ColorGradient = true
											oufdb.Texts.HealthPercent.ColorClass = false
											oufdb.Texts.HealthPercent.IndividualColor.Enable = false
											
											_G[UF].Health.valuePercent.colorGradient = true
											_G[UF].Health.valuePercent.colorClass = false
											_G[UF].Health.valuePercent.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
									IndividualColor = {
										name = "Individual Color",
										desc = "Wether you want to use an individual "..unit.." HealthPercent Value Color or not.",
										type = "toggle",
										get = function() return oufdb.Texts.HealthPercent.IndividualColor.Enable end,
										set = function(self,IndividualColor)
											oufdb.Texts.HealthPercent.IndividualColor.Enable = true
											oufdb.Texts.HealthPercent.ColorClass = false
											oufdb.Texts.HealthPercent.ColorGradient = false
											
											_G[UF].Health.valuePercent.colorIndividual.Enable = true
											_G[UF].Health.valuePercent.colorClass = false
											_G[UF].Health.valuePercent.colorGradient = false
											_G[UF]:UpdateAllElements()
										end,
										order = 3,
									},
									Color = {
										name = "Individual Color",
										desc = "Choose an individual "..unit.." HealthPercent Value Color.",
										type = "color",
										disabled = function() return not oufdb.Texts.HealthPercent.IndividualColor.Enable end,
										hasAlpha = false,
										get = function() return oufdb.Texts.HealthPercent.IndividualColor.r, oufdb.Texts.HealthPercent.IndividualColor.g, oufdb.Texts.HealthPercent.IndividualColor.b end,
										set = function(_,r,g,b)
											oufdb.Texts.HealthPercent.IndividualColor.r = r
											oufdb.Texts.HealthPercent.IndividualColor.g = g
											oufdb.Texts.HealthPercent.IndividualColor.b = b
											
											_G[UF].Health.valuePercent.colorIndividual = oufdb.Texts.HealthPercent.IndividualColor
											_G[UF]:UpdateAllElements()
										end,
										order = 4,
									},
								},
							},
						},
					},
					PowerPercent = {
						name = "PowerPercent",
						type = "group",
						disabled = function() return not oufdb.Power.Enable end,
						order = 5,
						args = {
							Enable = {
								name = "Enable",
								desc = "Wether you want to show the "..unit.." PowerPercent or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Texts.PowerPercent.Enable end,
								set = function(self,Enable)
									oufdb.Texts.PowerPercent.Enable = Enable
									_G[UF].Power.valuePercent.Enable = Enable
									if Enable == true then
										_G[UF].Power.valuePercent:Show()
									else
										_G[UF].Power.valuePercent:Hide()
									end
								end,
								order = 1,
							},
							FontSettings = {
								name = "Font Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.PowerPercent.Enable end,
								guiInline = true,
								order = 2,
								args = {
									FontSize = {
										name = "Size",
										desc = "Choose your "..unit.." PowerPercent Fontsize!\n Default: "..luidefaults.Texts.PowerPercent.Size,
										type = "range",
										min = 1,
										max = 40,
										step = 1,
										get = function() return oufdb.Texts.PowerPercent.Size end,
										set = function(_, FontSize)
											oufdb.Texts.PowerPercent.Size = FontSize
											_G[UF].Power.valuePercent:SetFont(LSM:Fetch("font", oufdb.Texts.PowerPercent.Font),oufdb.Texts.PowerPercent.Size,oufdb.Texts.PowerPercent.Outline)
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
										desc = "Choose your Font for "..unit.." PowerPercent!\n\nDefault: "..luidefaults.Texts.PowerPercent.Font,
										type = "select",
										dialogControl = "LSM30_Font",
										values = widgetLists.font,
										get = function() return oufdb.Texts.PowerPercent.Font end,
										set = function(self, Font)
											oufdb.Texts.PowerPercent.Font = Font
											_G[UF].Power.valuePercent:SetFont(LSM:Fetch("font", oufdb.Texts.PowerPercent.Font),oufdb.Texts.PowerPercent.Size,oufdb.Texts.PowerPercent.Outline)
										end,
										order = 3,
									},
									FontFlag = {
										name = "Font Flag",
										desc = "Choose the Font Flag for your "..unit.." PowerPercent.\nDefault: "..luidefaults.Texts.PowerPercent.Outline,
										type = "select",
										values = fontflags,
										get = function()
											for k, v in pairs(fontflags) do
												if oufdb.Texts.PowerPercent.Outline == v then
													return k
												end
											end
										end,
										set = function(self, FontFlag)
											oufdb.Texts.PowerPercent.Outline = fontflags[FontFlag]
											_G[UF].Power.valuePercent:SetFont(LSM:Fetch("font", oufdb.Texts.PowerPercent.Font),oufdb.Texts.PowerPercent.Size,oufdb.Texts.PowerPercent.Outline)
										end,
										order = 4,
									},
									PowerPercentX = {
										name = "X Value",
										desc = "X Value for your "..unit.." PowerPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Texts.PowerPercent.X,
										type = "input",
										get = function() return oufdb.Texts.PowerPercent.X end,
										set = function(self,PowerPercentX)
											if PowerPercentX == nil or PowerPercentX == "" then PowerPercentX = "0" end
											oufdb.Texts.PowerPercent.X = PowerPercentX
											_G[UF].Power.valuePercent:ClearAllPoints()
											_G[UF].Power.valuePercent:SetPoint(oufdb.Texts.PowerPercent.Point, _G[UF], oufdb.Texts.PowerPercent.RelativePoint, tonumber(oufdb.Texts.PowerPercent.X), tonumber(oufdb.Texts.PowerPercent.Y))
										end,
										order = 5,
									},
									PowerPercentY = {
										name = "Y Value",
										desc = "Y Value for your "..unit.." PowerPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Texts.PowerPercent.Y,
										type = "input",
										get = function() return oufdb.Texts.PowerPercent.Y end,
										set = function(self,PowerPercentY)
											if PowerPercentY == nil or PowerPercentY == "" then PowerPercentY = "0" end
											oufdb.Texts.PowerPercent.Y = PowerPercentY
											_G[UF].Power.valuePercent:ClearAllPoints()
											_G[UF].Power.valuePercent:SetPoint(oufdb.Texts.PowerPercent.Point, _G[UF], oufdb.Texts.PowerPercent.RelativePoint, tonumber(oufdb.Texts.PowerPercent.X), tonumber(oufdb.Texts.PowerPercent.Y))
										end,
										order = 6,
									},
									Point = {
										name = "Point",
										desc = "Choose the Position for your "..unit.." PowerPercent.\nDefault: "..luidefaults.Texts.PowerPercent.Point,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.PowerPercent.Point == v then
													return k
												end
											end
										end,
										set = function(self, Point)
											oufdb.Texts.PowerPercent.Point = positions[Point]
											_G[UF].Power.valuePercent:ClearAllPoints()
											_G[UF].Power.valuePercent:SetPoint(oufdb.Texts.PowerPercent.Point, _G[UF], oufdb.Texts.PowerPercent.RelativePoint, tonumber(oufdb.Texts.PowerPercent.X), tonumber(oufdb.Texts.PowerPercent.Y))
										end,
										order = 7,
									},
									RelativePoint = {
										name = "RelativePoint",
										desc = "Choose the RelativePoint for your "..unit.." PowerPercent.\nDefault: "..luidefaults.Texts.PowerPercent.RelativePoint,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.PowerPercent.RelativePoint == v then
													return k
												end
											end
										end,
										set = function(self, RelativePoint)
											oufdb.Texts.PowerPercent.RelativePoint = positions[RelativePoint]
											_G[UF].Power.valuePercent:ClearAllPoints()
											_G[UF].Power.valuePercent:SetPoint(oufdb.Texts.PowerPercent.Point, _G[UF], oufdb.Texts.PowerPercent.RelativePoint, tonumber(oufdb.Texts.PowerPercent.X), tonumber(oufdb.Texts.PowerPercent.Y))
										end,
										order = 8,
									},
								},
							},
							Settings = {
								name = "Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.PowerPercent.Enable end,
								guiInline = true,
								order = 3,
								args = {
									ShowAlways = {
										name = "Show Always",
										desc = "Always show "..unit.." PowerPercent or just if the Unit has no MaxHP.",
										type = "toggle",
										get = function() return oufdb.Texts.PowerPercent.ShowAlways end,
										set = function(self,ShowAlways)
											oufdb.Texts.PowerPercent.ShowAlways = ShowAlways
											_G[UF].Power.valuePercent.ShowAlways = oufdb.Texts.PowerPercent.ShowAlways
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
								},
							},
							Colors = {
								name = "Color Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.PowerPercent.Enable end,
								guiInline = true,
								order = 4,
								args = {
									ClassColor = {
										name = "Color by Class",
										desc = "Wether you want to use class colored PowerPercent Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.PowerPercent.ColorClass end,
										set = function(self,ClassColor)
											oufdb.Texts.PowerPercent.ColorClass = true
											oufdb.Texts.PowerPercent.ColorType = false
											oufdb.Texts.PowerPercent.IndividualColor.Enable = false
											
											_G[UF].Power.valuePercent.colorClass = true
											_G[UF].Power.valuePercent.colorType = false
											_G[UF].Power.valuePercent.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									ColorType = {
										name = "Color by Type",
										desc = "Wether you want to use Type colored PowerPercent Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.PowerPercent.ColorType end,
										set = function(self,ColorType)
											oufdb.Texts.PowerPercent.ColorType = true
											oufdb.Texts.PowerPercent.ColorClass = false
											oufdb.Texts.PowerPercent.IndividualColor.Enable = false
											
											_G[UF].Power.valuePercent.colorType = true
											_G[UF].Power.valuePercent.colorClass = false
											_G[UF].Power.valuePercent.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
									IndividualColor = {
										name = "Individual Color",
										desc = "Wether you want to use an individual "..unit.." PowerPercent Value Color or not.",
										type = "toggle",
										get = function() return oufdb.Texts.PowerPercent.IndividualColor.Enable end,
										set = function(self,IndividualColor)
											oufdb.Texts.PowerPercent.IndividualColor.Enable = true
											oufdb.Texts.PowerPercent.ColorClass = false
											oufdb.Texts.PowerPercent.ColorType = false
											
											_G[UF].Power.valuePercent.colorIndividual.Enable = true
											_G[UF].Power.valuePercent.colorClass = false
											_G[UF].Power.valuePercent.colorType = false
											_G[UF]:UpdateAllElements()
										end,
										order = 3,
									},
									Color = {
										name = "Individual Color",
										desc = "Choose an individual "..unit.." PowerPercent Value Color.",
										type = "color",
										disabled = function() return not oufdb.Texts.PowerPercent.IndividualColor.Enable end,
										hasAlpha = false,
										get = function() return oufdb.Texts.PowerPercent.IndividualColor.r, oufdb.Texts.PowerPercent.IndividualColor.g, oufdb.Texts.PowerPercent.IndividualColor.b end,
										set = function(_,r,g,b)
											oufdb.Texts.PowerPercent.IndividualColor.r = r
											oufdb.Texts.PowerPercent.IndividualColor.g = g
											oufdb.Texts.PowerPercent.IndividualColor.b = b
											
											_G[UF].Power.valuePercent.colorIndividual = oufdb.Texts.PowerPercent.IndividualColor
											_G[UF]:UpdateAllElements()
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
								desc = "Wether you want to show the "..unit.." HealthMissing or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Texts.HealthMissing.Enable end,
								set = function(self,Enable)
									oufdb.Texts.HealthMissing.Enable = Enable
									_G[UF].Health.valueMissing.Enable = Enable
									if Enable == true then
										_G[UF].Health.valueMissing:Show()
									else
										_G[UF].Health.valueMissing:Hide()
									end
								end,
								order = 1,
							},
							FontSettings = {
								name = "Font Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.HealthMissing.Enable end,
								guiInline = true,
								order = 2,
								args = {
									FontSize = {
										name = "Size",
										desc = "Choose your "..unit.." HealthMissing Fontsize!\n Default: "..luidefaults.Texts.HealthMissing.Size,
										type = "range",
										min = 1,
										max = 40,
										step = 1,
										get = function() return oufdb.Texts.HealthMissing.Size end,
										set = function(_, FontSize)
											oufdb.Texts.HealthMissing.Size = FontSize
											_G[UF].Health.valueMissing:SetFont(LSM:Fetch("font", oufdb.Texts.HealthMissing.Font),oufdb.Texts.HealthMissing.Size,oufdb.Texts.HealthMissing.Outline)
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
										desc = "Choose your Font for "..unit.." HealthMissing!\n\nDefault: "..luidefaults.Texts.HealthMissing.Font,
										type = "select",
										dialogControl = "LSM30_Font",
										values = widgetLists.font,
										get = function() return oufdb.Texts.HealthMissing.Font end,
										set = function(self, Font)
											oufdb.Texts.HealthMissing.Font = Font
											_G[UF].Health.valueMissing:SetFont(LSM:Fetch("font", oufdb.Texts.HealthMissing.Font),oufdb.Texts.HealthMissing.Size,oufdb.Texts.HealthMissing.Outline)
										end,
										order = 3,
									},
									FontFlag = {
										name = "Font Flag",
										desc = "Choose the Font Flag for your "..unit.." HealthMissing.\nDefault: "..luidefaults.Texts.HealthMissing.Outline,
										type = "select",
										values = fontflags,
										get = function()
											for k, v in pairs(fontflags) do
												if oufdb.Texts.HealthMissing.Outline == v then
													return k
												end
											end
										end,
										set = function(self, FontFlag)
											oufdb.Texts.HealthMissing.Outline = fontflags[FontFlag]
											_G[UF].Health.valueMissing:SetFont(LSM:Fetch("font", oufdb.Texts.HealthMissing.Font),oufdb.Texts.HealthMissing.Size,oufdb.Texts.HealthMissing.Outline)
										end,
										order = 4,
									},
									HealthMissingX = {
										name = "X Value",
										desc = "X Value for your "..unit.." HealthMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Texts.HealthMissing.X,
										type = "input",
										get = function() return oufdb.Texts.HealthMissing.X end,
										set = function(self,HealthMissingX)
											if HealthMissingX == nil or HealthMissingX == "" then HealthMissingX = "0" end
											oufdb.Texts.HealthMissing.X = HealthMissingX
											_G[UF].Health.valueMissing:ClearAllPoints()
											_G[UF].Health.valueMissing:SetPoint(oufdb.Texts.HealthMissing.Point, _G[UF], oufdb.Texts.HealthMissing.RelativePoint, tonumber(oufdb.Texts.HealthMissing.X), tonumber(oufdb.Texts.HealthMissing.Y))
										end,
										order = 5,
									},
									HealthMissingY = {
										name = "Y Value",
										desc = "Y Value for your "..unit.." HealthMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Texts.HealthMissing.Y,
										type = "input",
										get = function() return oufdb.Texts.HealthMissing.Y end,
										set = function(self,HealthMissingY)
											if HealthMissingY == nil or HealthMissingY == "" then HealthMissingY = "0" end
											oufdb.Texts.HealthMissing.Y = HealthMissingY
											_G[UF].Health.valueMissing:ClearAllPoints()
											_G[UF].Health.valueMissing:SetPoint(oufdb.Texts.HealthMissing.Point, _G[UF], oufdb.Texts.HealthMissing.RelativePoint, tonumber(oufdb.Texts.HealthMissing.X), tonumber(oufdb.Texts.HealthMissing.Y))
										end,
										order = 6,
									},
									Point = {
										name = "Point",
										desc = "Choose the Position for your "..unit.." HealthMissing.\nDefault: "..luidefaults.Texts.HealthMissing.Point,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.HealthMissing.Point == v then
													return k
												end
											end
										end,
										set = function(self, Point)
											oufdb.Texts.HealthMissing.Point = positions[Point]
											_G[UF].Health.valueMissing:ClearAllPoints()
											_G[UF].Health.valueMissing:SetPoint(oufdb.Texts.HealthMissing.Point, _G[UF], oufdb.Texts.HealthMissing.RelativePoint, tonumber(oufdb.Texts.HealthMissing.X), tonumber(oufdb.Texts.HealthMissing.Y))
										end,
										order = 7,
									},
									RelativePoint = {
										name = "RelativePoint",
										desc = "Choose the RelativePoint for your "..unit.." HealthMissing.\nDefault: "..luidefaults.Texts.HealthMissing.RelativePoint,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.HealthMissing.RelativePoint == v then
													return k
												end
											end
										end,
										set = function(self, RelativePoint)
											oufdb.Texts.HealthMissing.RelativePoint = positions[RelativePoint]
											_G[UF].Health.valueMissing:ClearAllPoints()
											_G[UF].Health.valueMissing:SetPoint(oufdb.Texts.HealthMissing.Point, _G[UF], oufdb.Texts.HealthMissing.RelativePoint, tonumber(oufdb.Texts.HealthMissing.X), tonumber(oufdb.Texts.HealthMissing.Y))
										end,
										order = 8,
									},
								},
							},
							Settings = {
								name = "Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.HealthMissing.Enable end,
								guiInline = true,
								order = 3,
								args = {
									ShortValue = {
										name = "Short Value",
										desc = "Show a Short or the Normal Value of the Missing HP",
										type = "toggle",
										get = function() return oufdb.Texts.HealthMissing.ShortValue end,
										set = function(self,ShortValue)
											oufdb.Texts.HealthMissing.ShortValue = ShortValue
											_G[UF].Health.valueMissing.ShortValue = ShortValue
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									ShowAlways = {
										name = "Show Always",
										desc = "Always show "..unit.." HealthMissing or just if the Unit has no MaxHP.",
										type = "toggle",
										get = function() return oufdb.Texts.HealthMissing.ShowAlways end,
										set = function(self,ShowAlways)
											oufdb.Texts.HealthMissing.ShowAlways = ShowAlways
											_G[UF].Health.valueMissing.ShowAlways = ShowAlways
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
								},
							},
							Colors = {
								name = "Color Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.HealthMissing.Enable end,
								guiInline = true,
								order = 4,
								args = {
									ClassColor = {
										name = "Color by Class",
										desc = "Wether you want to use class colored HealthMissing Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.HealthMissing.ColorClass end,
										set = function(self,ClassColor)
											oufdb.Texts.HealthMissing.ColorClass = true
											oufdb.Texts.HealthMissing.ColorGradient = false
											oufdb.Texts.HealthMissing.IndividualColor.Enable = false
													
											_G[UF].Health.valueMissing.colorClass = true
											_G[UF].Health.valueMissing.colorGradient = false
											_G[UF].Health.valueMissing.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									ColorGradient = {
										name = "Color Gradient",
										desc = "Wether you want to use Gradient colored HealthMissing Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.HealthMissing.ColorGradient end,
										set = function(self,ColorGradient)
											oufdb.Texts.HealthMissing.ColorGradient = true
											oufdb.Texts.HealthMissing.ColorClass = false
											oufdb.Texts.HealthMissing.IndividualColor.Enable = false
												
											_G[UF].Health.valueMissing.colorGradient = true
											_G[UF].Health.valueMissing.colorClass = false
											_G[UF].Health.valueMissing.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
									IndividualColor = {
										name = "Individual Color",
										desc = "Wether you want to use an individual "..unit.." HealthMissing Value Color or not.",
										type = "toggle",
										get = function() return oufdb.Texts.HealthMissing.IndividualColor.Enable end,
										set = function(self,IndividualColor)
											oufdb.Texts.HealthMissing.IndividualColor.Enable = true
											oufdb.Texts.HealthMissing.ColorClass = false
											oufdb.Texts.HealthMissing.ColorGradient = false
											
											_G[UF].Health.valueMissing.colorIndividual.Enable = true
											_G[UF].Health.valueMissing.colorClass = false
											_G[UF].Health.valueMissing.colorGradient = false
											_G[UF]:UpdateAllElements()
										end,
										order = 3,
									},
									Color = {
										name = "Individual Color",
										desc = "Choose an individual "..unit.." HealthMissing Value Color.",
										type = "color",
										disabled = function() return not oufdb.Texts.HealthMissing.IndividualColor.Enable end,
										hasAlpha = false,
										get = function() return oufdb.Texts.HealthMissing.IndividualColor.r, oufdb.Texts.HealthMissing.IndividualColor.g, oufdb.Texts.HealthMissing.IndividualColor.b end,
										set = function(_,r,g,b)
											oufdb.Texts.HealthMissing.IndividualColor.r = r
											oufdb.Texts.HealthMissing.IndividualColor.g = g
											oufdb.Texts.HealthMissing.IndividualColor.b = b
											
											_G[UF].Health.valueMissing.colorIndividual = oufdb.Texts.HealthMissing.IndividualColor
											_G[UF]:UpdateAllElements()
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
						disabled = function() return not oufdb.Power.Enable end,
						order = 7,
						args = {
							Enable = {
								name = "Enable",
								desc = "Wether you want to show the "..unit.." PowerMissing or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Texts.PowerMissing.Enable end,
								set = function(self,Enable)
									oufdb.Texts.PowerMissing.Enable = Enable
									_G[UF].Power.valueMissing.Enable = Enable
									if Enable == true then
										_G[UF].Power.valueMissing:Show()
									else
										_G[UF].Power.valueMissing:Hide()
									end
								end,
								order = 1,
							},
							FontSettings = {
								name = "Font Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.PowerMissing.Enable end,
								guiInline = true,
								order = 2,
								args = {
									FontSize = {
										name = "Size",
										desc = "Choose your "..unit.." PowerMissing Fontsize!\n Default: "..luidefaults.Texts.PowerMissing.Size,
										type = "range",
										min = 1,
										max = 40,
										step = 1,
										get = function() return oufdb.Texts.PowerMissing.Size end,
										set = function(_, FontSize)
											oufdb.Texts.PowerMissing.Size = FontSize
											_G[UF].Power.valueMissing:SetFont(LSM:Fetch("font", oufdb.Texts.PowerMissing.Font),oufdb.Texts.PowerMissing.Size,oufdb.Texts.PowerMissing.Outline)
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
										desc = "Choose your Font for "..unit.." PowerMissing!\n\nDefault: "..luidefaults.Texts.PowerMissing.Font,
										type = "select",
										dialogControl = "LSM30_Font",
										values = widgetLists.font,
										get = function() return oufdb.Texts.PowerMissing.Font end,
										set = function(self, Font)
											oufdb.Texts.PowerMissing.Font = Font
											_G[UF].Power.valueMissing:SetFont(LSM:Fetch("font", oufdb.Texts.PowerMissing.Font),oufdb.Texts.PowerMissing.Size,oufdb.Texts.PowerMissing.Outline)
										end,
										order = 3,
									},
									FontFlag = {
										name = "Font Flag",
										desc = "Choose the Font Flag for your "..unit.." PowerMissing.\nDefault: "..luidefaults.Texts.PowerMissing.Outline,
										type = "select",
										values = fontflags,
										get = function()
											for k, v in pairs(fontflags) do
												if oufdb.Texts.PowerMissing.Outline == v then
													return k
												end
											end
										end,
										set = function(self, FontFlag)
											oufdb.Texts.PowerMissing.Outline = fontflags[FontFlag]
											_G[UF].Power.valueMissing:SetFont(LSM:Fetch("font", oufdb.Texts.PowerMissing.Font),oufdb.Texts.PowerMissing.Size,oufdb.Texts.PowerMissing.Outline)
										end,
										order = 4,
									},
									PowerMissingX = {
										name = "X Value",
										desc = "X Value for your "..unit.." PowerMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Texts.PowerMissing.X,
										type = "input",
										get = function() return oufdb.Texts.PowerMissing.X end,
										set = function(self,PowerMissingX)
											if PowerMissingX == nil or PowerMissingX == "" then PowerMissingX = "0" end
											oufdb.Texts.PowerMissing.X = PowerMissingX
											_G[UF].Power.valueMissing:ClearAllPoints()
											_G[UF].Power.valueMissing:SetPoint(oufdb.Texts.PowerMissing.Point, _G[UF], oufdb.Texts.PowerMissing.RelativePoint, tonumber(oufdb.Texts.PowerMissing.X), tonumber(oufdb.Texts.PowerMissing.Y))
										end,
										order = 5,
									},
									PowerMissingY = {
										name = "Y Value",
										desc = "Y Value for your "..unit.." PowerMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Texts.PowerMissing.Y,
										type = "input",
										get = function() return oufdb.Texts.PowerMissing.Y end,
										set = function(self,PowerMissingY)
											if PowerMissingY == nil or PowerMissingY == "" then PowerMissingY = "0" end
											oufdb.Texts.PowerMissing.Y = PowerMissingY
											_G[UF].Power.valueMissing:ClearAllPoints()
											_G[UF].Power.valueMissing:SetPoint(oufdb.Texts.PowerMissing.Point, _G[UF], oufdb.Texts.PowerMissing.RelativePoint, tonumber(oufdb.Texts.PowerMissing.X), tonumber(oufdb.Texts.PowerMissing.Y))
										end,
										order = 6,
									},
									Point = {
										name = "Point",
										desc = "Choose the Position for your "..unit.." PowerMissing.\nDefault: "..luidefaults.Texts.PowerMissing.Point,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.PowerMissing.Point == v then
													return k
												end
											end
										end,
										set = function(self, Point)
											oufdb.Texts.PowerMissing.Point = positions[Point]
											_G[UF].Power.valueMissing:ClearAllPoints()
											_G[UF].Power.valueMissing:SetPoint(oufdb.Texts.PowerMissing.Point, _G[UF], oufdb.Texts.PowerMissing.RelativePoint, tonumber(oufdb.Texts.PowerMissing.X), tonumber(oufdb.Texts.PowerMissing.Y))
										end,
										order = 7,
									},
									RelativePoint = {
										name = "RelativePoint",
										desc = "Choose the RelativePoint for your "..unit.." PowerMissing.\nDefault: "..luidefaults.Texts.PowerMissing.RelativePoint,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.PowerMissing.RelativePoint == v then
													return k
												end
											end
										end,
										set = function(self, RelativePoint)
											oufdb.Texts.PowerMissing.RelativePoint = positions[RelativePoint]
											_G[UF].Power.valueMissing:ClearAllPoints()
											_G[UF].Power.valueMissing:SetPoint(oufdb.Texts.PowerMissing.Point, _G[UF], oufdb.Texts.PowerMissing.RelativePoint, tonumber(oufdb.Texts.PowerMissing.X), tonumber(oufdb.Texts.PowerMissing.Y))
										end,
										order = 8,
									},
								},
							},
							Settings = {
								name = "Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.PowerMissing.Enable end,
								guiInline = true,
								order = 3,
								args = {
									ShortValue = {
										name = "Short Value",
										desc = "Show a Short or the Normal Value of the Missing Power",
										type = "toggle",
										get = function() return oufdb.Texts.PowerMissing.ShortValue end,
										set = function(self,ShortValue)
											oufdb.Texts.PowerMissing.ShortValue = ShortValue
											_G[UF].Power.valueMissing.ShortValue = ShortValue
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									ShowAlways = {
										name = "Show Always",
										desc = "Always show "..unit.." PowerMissing or just if the Unit has no MaxPower.",
										type = "toggle",
										get = function() return oufdb.Texts.PowerMissing.ShowAlways end,
										set = function(self,ShowAlways)
											oufdb.Texts.PowerMissing.ShowAlways = ShowAlways
											_G[UF].Power.valueMissing.ShowAlways = ShowAlways
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
									
								},
							},
							Colors = {
								name = "Color Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.PowerMissing.Enable end,
								guiInline = true,
								order = 4,
								args = {
									ClassColor = {
										name = "Color by Class",
										desc = "Wether you want to use class colored PowerMissing Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.PowerMissing.ColorClass end,
										set = function(self,ClassColor)
											oufdb.Texts.PowerMissing.ColorClass = true
											oufdb.Texts.PowerMissing.ColorType = false
											oufdb.Texts.PowerMissing.IndividualColor.Enable = false
											
											_G[UF].Power.valueMissing.colorClass = true
											_G[UF].Power.valueMissing.colorType = false
											_G[UF].Power.valueMissing.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 1,
									},
									ColorType = {
										name = "Color by Type",
										desc = "Wether you want to use Type colored PowerMissing Value or not.",
										type = "toggle",
										get = function() return oufdb.Texts.PowerMissing.ColorType end,
										set = function(self,ColorType)
											oufdb.Texts.PowerMissing.ColorType = true
											oufdb.Texts.PowerMissing.ColorClass = false
											oufdb.Texts.PowerMissing.IndividualColor.Enable = false
											
											_G[UF].Power.valueMissing.colorType = true
											_G[UF].Power.valueMissing.colorClass = false
											_G[UF].Power.valueMissing.colorIndividual.Enable = false
											_G[UF]:UpdateAllElements()
										end,
										order = 2,
									},
									IndividualColor = {
										name = "Individual Color",
										desc = "Wether you want to use an individual "..unit.." PowerMissing Value Color or not.",
										type = "toggle",
										get = function() return oufdb.Texts.PowerMissing.IndividualColor.Enable end,
										set = function(self,IndividualColor)
											oufdb.Texts.PowerMissing.IndividualColor.Enable = true
											oufdb.Texts.PowerMissing.ColorClass = false
											oufdb.Texts.PowerMissing.ColorType = false
											
											_G[UF].Power.valueMissing.colorIndividual.Enable = true
											_G[UF].Power.valueMissing.colorClass = false
											_G[UF].Power.valueMissing.colorType = false
											_G[UF]:UpdateAllElements()
										end,
										order = 3,
									},
									Color = {
										name = "Individual Color",
										desc = "Choose an individual "..unit.." PowerMissing Value Color.",
										type = "color",
										disabled = function() return not oufdb.Texts.PowerMissing.IndividualColor.Enable end,
										hasAlpha = false,
										get = function() return oufdb.Texts.PowerMissing.IndividualColor.r, oufdb.Texts.PowerMissing.IndividualColor.g, oufdb.Texts.PowerMissing.IndividualColor.b end,
										set = function(_,r,g,b)
											oufdb.Texts.PowerMissing.IndividualColor.r = r
											oufdb.Texts.PowerMissing.IndividualColor.g = g
											oufdb.Texts.PowerMissing.IndividualColor.b = b
											
											_G[UF].Power.valueMissing.colorIndividual = oufdb.Texts.PowerMissing.IndividualColor
											_G[UF]:UpdateAllElements()
										end,
										order = 4,
									},
								},
							},
						},
					},
					CombatText = (unit == "Player" or unit == "Target" or unit == "Focus" or unit == "Pet" or unit == "ToT") and {
						name = "Combat",
						type = "group",
						order = 8,
						args = {
							Enable = {
								name = "Enable",
								desc = "Wether you want to show combat text on your unitframe or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Texts.Combat.Enable end,
								set = function(self,Enable)
									oufdb.Texts.Combat.Enable = Enable
									if _G[UF].CombatFeedbackText.InitEnabled == false then _G[UF].CreateCombatFeedbackText() end
									if Enable == true then
										_G[UF].CombatFeedbackText.ignoreImmune = not oufdb.Texts.Combat.ShowImmune
										_G[UF].CombatFeedbackText.ignoreDamage = not oufdb.Texts.Combat.ShowDamage
										_G[UF].CombatFeedbackText.ignoreHeal = not oufdb.Texts.Combat.ShowHeal
										_G[UF].CombatFeedbackText.ignoreEnergize = not oufdb.Texts.Combat.ShowEnergize
										_G[UF].CombatFeedbackText.ignoreOther = not oufdb.Texts.Combat.ShowOther
									else
										_G[UF].CombatFeedbackText.ignoreImmune = true
										_G[UF].CombatFeedbackText.ignoreDamage = true
										_G[UF].CombatFeedbackText.ignoreHeal = true
										_G[UF].CombatFeedbackText.ignoreEnergize = true
										_G[UF].CombatFeedbackText.ignoreOther = true
										_G[UF].CombatFeedbackText:Hide()
									end
								end,
								order = 1,
							},
							FontSettings = {
								name = "Font Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.Combat.Enable end,
								guiInline = true,
								order = 2,
								args = {
									FontSize = {
										name = "Size",
										desc = "Choose your Combat Text Fontsize!\n Default: "..luidefaults.Texts.Combat.Size,
										type = "range",
										min = 1,
										max = 40,
										step = 1,
										get = function() return oufdb.Texts.Combat.Size end,
										set = function(_, FontSize)
											oufdb.Texts.Combat.Size = FontSize
											_G[UF].CombatFeedbackText:SetFont(LSM:Fetch("font", oufdb.Texts.Combat.Font), oufdb.Texts.Combat.Size, oufdb.Texts.Combat.Outline)
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
										desc = "Choose your Combat Text Font!\n\nDefault: "..luidefaults.Texts.Combat.Font,
										type = "select",
										dialogControl = "LSM30_Font",
										values = widgetLists.font,
										get = function() return oufdb.Texts.Combat.Font end,
										set = function(self, Font)
											oufdb.Texts.Combat.Font = Font
											_G[UF].CombatFeedbackText:SetFont(LSM:Fetch("font", oufdb.Texts.Combat.Font), oufdb.Texts.Combat.Size, oufdb.Texts.Combat.Outline)
										end,
										order = 3,
									},
									FontFlag = {
										name = "Font Flag",
										desc = "Choose the Combat Text Font Flag.\nDefault: "..luidefaults.Texts.Combat.Outline,
										type = "select",
										values = fontflags,
										get = function()
											for k, v in pairs(fontflags) do
												if oufdb.Texts.Combat.Outline == v then
													return k
												end
											end
										end,
										set = function(self, FontFlag)
											oufdb.Texts.Combat.Outline = fontflags[FontFlag]
											_G[UF].CombatFeedbackText:SetFont(LSM:Fetch("font", oufdb.Texts.Combat.Font), oufdb.Texts.Combat.Size, oufdb.Texts.Combat.Outline)
										end,
										order = 4,
									},
									XValue = {
										name = "X Value",
										desc = "Choose the X Value for your Combat Text.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Texts.Combat.X,
										type = "input",
										get = function() return oufdb.Texts.Combat.X end,
										set = function(self,XValue)
											if XValue == nil or XValue == "" then XValue = "0" end
											oufdb.Texts.Combat.X = XValue
											_G[UF].CombatFeedbackText:ClearAllPoints()
											_G[UF].CombatFeedbackText:SetPoint(oufdb.Texts.Combat.Point, _G[UF], oufdb.Texts.Combat.RelativePoint, tonumber(XValue), tonumber(oufdb.Texts.Combat.Y))
										end,
										order = 5,
									},
									YValue = {
										name = "Y Value",
										desc = "Choose the Y Value for your Combat Text.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Texts.Combat.Y,
										type = "input",
										get = function() return oufdb.Texts.Combat.Y end,
										set = function(self,YValue)
											if YValue == nil or YValue == "" then YValue = "0" end
											oufdb.Texts.Combat.Y = YValue
											_G[UF].CombatFeedbackText:ClearAllPoints()
											_G[UF].CombatFeedbackText:SetPoint(oufdb.Texts.Combat.Point, _G[UF], oufdb.Texts.Combat.RelativePoint, tonumber(oufdb.Texts.Combat.X), tonumber(YValue))
										end,
										order = 6,
									},
									Point = {
										name = "Point",
										desc = "Choose the Position for your "..unit.." CombatText.\nDefault: "..luidefaults.Texts.Combat.Point,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.Combat.Point == v then
													return k
												end
											end
										end,
										set = function(self, Point)
											oufdb.Texts.Combat.Point = positions[Point]
											_G[UF].CombatFeedbackText:SetPoint(positions[Point], _G[UF], oufdb.Texts.Combat.RelativePoint, tonumber(oufdb.Texts.Combat.X), tonumber(oufdb.Texts.Combat.Y))
										end,
										order = 7,
									},
									RelativePoint = {
										name = "RelativePoint",
										desc = "Choose the RelativePoint for your "..unit.." CombatText.\nDefault: "..luidefaults.Texts.Combat.RelativePoint,
										type = "select",
										values = positions,
										get = function()
											for k, v in pairs(positions) do
												if oufdb.Texts.Combat.RelativePoint == v then
													return k
												end
											end
										end,
										set = function(self, RelativePoint)
											oufdb.Texts.Combat.RelativePoint = positions[RelativePoint]
											_G[UF].CombatFeedbackText:SetPoint(oufdb.Texts.Combat.Point, _G[UF], positions[RelativePoint], tonumber(oufdb.Texts.Combat.X), tonumber(oufdb.Texts.Combat.Y))
										end,
										order = 8,
									},
								},
							},
							Settings = {
								name = "Settings",
								type = "group",
								disabled = function() return not oufdb.Texts.Combat.Enable end,
								guiInline = true,
								order = 3,
								args = {
									ShowDamage = {
										name = "Show Damage",
										desc = "Wether you want to show damage done to your"..unit.." or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Combat.ShowDamage end,
										set = function(self, ShowDamage)
											oufdb.Texts.Combat.ShowDamage = ShowDamage
											_G[UF].CombatFeedbackText.ignoreDamage = not ShowDamage
										end,
										order = 1,
									},
									ShowHeals = {
										name = "Show Heals",
										desc = "Wether you want to show heals done to your"..unit.." or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Combat.ShowHeal end,
										set = function(self, ShowHeal)
											oufdb.Texts.Combat.ShowHeal = ShowHeal
											_G[UF].CombatFeedbackText.ignoreHeal = not ShowHeal
										end,
										order = 2,
									},
									ShowImmune = {
										name = "Show Immune",
										desc = "Wether you want to show immune reports on your"..unit.." or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Combat.ShowImmune end,
										set = function(self, ShowImmune)
											oufdb.Texts.Combat.ShowImmune = ShowImmune
											_G[UF].CombatFeedbackText.ignoreImmune = not ShowImmune
										end,
										order = 3,
									},
									ShowEnergize = {
										name = "Show Energize",
										desc = "Wether you want to show energize events on your"..unit.." or not.\n\nAny effect that restores energy/mana",
										type = "toggle",
										get = function() return oufdb.Texts.Combat.ShowEnergize end,
										set = function(self, ShowEnergize)
											oufdb.Texts.Combat.ShowEnergize = ShowEnergize
											_G[UF].CombatFeedbackText.ignoreEnergize = not ShowEnergize
										end,
										order = 4,
									},
									ShowOther = {
										name = "Show Other",
										desc = "Wether you want to show other events on your"..unit.." or not.",
										type = "toggle",
										get = function() return oufdb.Texts.Combat.ShowOther end,
										set = function(self, ShowOther)
											oufdb.Texts.Combat.ShowOther = ShowOther
											_G[UF].CombatFeedbackText.ignoreOther = not ShowOther
										end,
										order = 5,
									},
									MaxAlpha = {
										name = "Max Alpha",
										desc = "Choose the max alpha for your "..unit.." CombatText.\nDefault: "..luidefaults.Texts.Combat.MaxAlpha,
										type = "range",
										min = 0,
										max = 1,
										step = 0.05,
										get = function() return oufdb.Texts.Combat.MaxAlpha end,
										set = function(_, MaxAlpha)
											oufdb.Texts.Combat.MaxAlpha = MaxAlpha
											_G[UF].CombatFeedbackText.MaxAlpha = MaxAlpha
										end,
										order = 6,
									},
								},
							},
						},
					} or nil,
				},
			},
			Castbar = (unit == "Player" or unit == "Target" or unit == "Focus" or unit == "Pet") and {
				name = "Castbar",
				type = "group",
				disabled = function() return (oufdb.Enable ~= nil and not (oufdb.Enable and db.oUF.Settings.Castbars) or not db.oUF.Settings.Castbars) end,
				order = 7,
				childGroups = "tab",
				args = {
					header = {
						name = unit.." Castbar",
						type = "header",
						order = 1,
					},
					General = {
						name = "General",
						type = "group",
						order = 2,
						args = {
							CastbarEnable = {
								name = "Enable",
								desc = "Wether you want to show your "..unit.." Castbar or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Castbar.Enable end,
								set = function(self,CastbarEnable)
									oufdb.Castbar.Enable = CastbarEnable
									if not _G[UF].Castbar then _G[UF].CreateCastbar() end
									if CastbarEnable == true then
										_G[UF]:EnableElement("Castbar")
									else
										_G[UF].Castbar:Hide()
										_G[UF]:DisableElement("Castbar")
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 1,
							},
							CastbarSize = {
								name = "Size/Position",
								type = "group",
								guiInline = true,
								disabled = function() return not oufdb.Castbar.Enable end,
								order = 2,
								args = {
									CastbarHeight = {
										name = "Height",
										desc = "Castbar Height.\n\nDefault: "..luidefaults.Castbar.Height,
										type = "input",
										get = function() return oufdb.Castbar.Height end,
										set = function(self,CastbarHeight)
											if CastbarHeight == nil or CastbarHeight == "" then CastbarHeight = "0" end
											oufdb.Castbar.Height = CastbarHeight
											_G[UF].Castbar:SetHeight(CastbarHeight)
										end,
										order = 1,
									},
									CastbarWidth = {
										name = "Width",
										desc = "Castbar Width.\n\nDefault: "..luidefaults.Castbar.Width,
										type = "input",
										get = function() return oufdb.Castbar.Width end,
										set = function(self,CastbarWidth)
											if CastbarWidth == nil or CastbarWidth == "" then CastbarWidth = "0" end
											oufdb.Castbar.Width = CastbarWidth
											_G[UF].Castbar:SetWidth(CastbarWidth)
										end,
										order = 2,
									},
									CastbarX = {
										name = "X Value",
										desc = "X Value for your Castbar.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Castbar.X,
										type = "input",
										get = function() return oufdb.Castbar.X end,
										set = function(self,CastbarX)
											if CastbarX == nil or CastbarX == "" then CastbarX = "0" end
											oufdb.Castbar.X = CastbarX
											_G[UF].Castbar:ClearAllPoints()
											if unit == "Player" or unit == "Target" then
												_G[UF].Castbar:SetPoint("BOTTOM", UIParent, "BOTTOM", CastbarX, oufdb.Castbar.Y)
											else
												_G[UF].Castbar:SetPoint("TOP", _G[UF], "BOTTOM", CastbarX, oufdb.Castbar.Y)
											end
										end,
										order = 3,
									},
									CastbarY = {
										name = "Y Value",
										desc = "Y Value for your Castbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Castbar.Y,
										type = "input",
										get = function() return oufdb.Castbar.Y end,
										set = function(self,CastbarY)
											if CastbarY == nil or CastbarY == "" then CastbarY = "0" end
											oufdb.Castbar.Y = CastbarY
											_G[UF].Castbar:ClearAllPoints()
											if unit == "Player" or unit == "Target" then
												_G[UF].Castbar:SetPoint("BOTTOM", UIParent, "BOTTOM", oufdb.Castbar.X, CastbarY)
											else
												_G[UF].Castbar:SetPoint("TOP", _G[UF], "BOTTOM", oufdb.Castbar.X, CastbarY)
											end
										end,
										order = 4,
									},
								},
							},
							CastbarToggle = {
								name = "Show Dummy Castbar",
								desc = "Show a dummy castbar for testing and positioning",
								type = "execute",
								disabled = function() return not oufdb.Castbar.Enable end,
								func = function()
									if UnitExists(unit) then
										_G[UF].Castbar.casting = true
										_G[UF].Castbar.max = 60
										_G[UF].Castbar.duration = 0
										_G[UF].Castbar.delay = 0
										_G[UF].Castbar:SetMinMaxValues(0, 60)
										_G[UF].Castbar.Text:SetText("Dummy Castbar")
										_G[UF].Castbar:Show()
									else
										LUI:Print("The "..unit.." UnitFrame must be showing for the dummy castbar to work")
									end
								end,
								order = 3,
							},
						},
					},
					CastbarColors = {
						name = "Colors",
						type = "group",
						disabled = function() return not oufdb.Castbar.Enable end,
						order = 3,
						args = {
							Colors = {
								name = "Castbar Colors",
								type = "group",
								guiInline = true,
								order = 1,
								args = {
									CBColorEnable = {
										name = "Individual Castbar Color",
										desc = "Wether you want an individual Castbar Color or not.",
										type = "toggle",
										width = "full",
										get = function() return oufdb.Castbar.IndividualColor end,
										set = function(self,CBColorEnable)
											oufdb.Castbar.IndividualColor = CBColorEnable
											if CBColorEnable then
												_G[UF].Castbar:SetStatusBarColor(oufdb.Castbar.Colors.Bar.r,oufdb.Castbar.Colors.Bar.g,oufdb.Castbar.Colors.Bar.b,oufdb.Castbar.Colors.Bar.a)
												_G[UF].Castbar.bg:SetVertexColor(oufdb.Castbar.Colors.Background.r,oufdb.Castbar.Colors.Background.g,oufdb.Castbar.Colors.Background.b,oufdb.Castbar.Colors.Background.a)
												_G[UF].CastbarBackdrop:SetBackdropBorderColor(oufdb.Castbar.Colors.Border.r,oufdb.Castbar.Colors.Border.g,oufdb.Castbar.Colors.Border.b,oufdb.Castbar.Colors.Border.a)
												if unit == "player" then
													_G[UF].Castbar.SafeZone:SetVertexColor(oufdb.Castbar.Colors.Latency.r,oufdb.Castbar.Colors.Latency.g,oufdb.Castbar.Colors.Latency.b,oufdb.Castbar.Colors.Latency.a)
												end
											else
												local r,g,b = unpack(oUF_LUI.colors.class[class])
												_G[UF].Castbar:SetStatusBarColor(r,g,b,0.68)
												_G[UF].Castbar.bg:SetVertexColor(0.15,0.15,0.15,0.75)
												_G[UF].CastbarBackdrop:SetBackdropBorderColor(0,0,0,0.7)
												if unit == "player" then
													_G[UF].Castbar.SafeZone:SetVertexColor(0.11,0.11,0.11,0.6)
												end
											end
										end,
										order = 1,
									},
									CBColor = {
										name = "Castbar Color",
										desc = "Choose an individual Castbar-Color.\n\nDefault: "..luidefaults.Castbar.Colors.Bar.r.." / "..luidefaults.Castbar.Colors.Bar.g.." / "..luidefaults.Castbar.Colors.Bar.b.." / "..luidefaults.Castbar.Colors.Bar.a,
										type = "color",
										width = "full",
										disabled = function() return not oufdb.Castbar.IndividualColor end,
										hasAlpha = true,
										get = function() return oufdb.Castbar.Colors.Bar.r, oufdb.Castbar.Colors.Bar.g, oufdb.Castbar.Colors.Bar.b, oufdb.Castbar.Colors.Bar.a end,
										set = function(_,r,g,b,a)
											oufdb.Castbar.Colors.Bar.r = r
											oufdb.Castbar.Colors.Bar.g = g
											oufdb.Castbar.Colors.Bar.b = b
											oufdb.Castbar.Colors.Bar.a = a
											_G[UF].Castbar:SetStatusBarColor(r,g,b,a)
										end,
										order = 2,
									},
									CBBGColor = {
										name = "Castbar BG Color",
										desc = "Choose an individual Castbar-Background-Color.\n\nDefault: "..luidefaults.Castbar.Colors.Background.r.." / "..luidefaults.Castbar.Colors.Background.g.." / "..luidefaults.Castbar.Colors.Background.b.." / "..1-luidefaults.Castbar.Colors.Background.a,
										type = "color",
										width = "full",
										disabled = function() return not oufdb.Castbar.IndividualColor end,
										hasAlpha = true,
										get = function() return oufdb.Castbar.Colors.Background.r, oufdb.Castbar.Colors.Background.g, oufdb.Castbar.Colors.Background.b, oufdb.Castbar.Colors.Background.a end,
										set = function(_,r,g,b,a)
											oufdb.Castbar.Colors.Background.r = r
											oufdb.Castbar.Colors.Background.g = g
											oufdb.Castbar.Colors.Background.b = b
											oufdb.Castbar.Colors.Background.a = a
											_G[UF].Castbar.bg:SetVertexColor(r,g,b,a)
										end,
										order = 3,
									},
									--[[CBLatencyColor = {
										name = "Castbar Latency Color",
										desc = "Choose an individual Castbar-Latency-Color.\n\nDefaults: "..luidefaults.Castbar.Colors.Latency.r.." / "..luidefaults.Castbar.Colors.Latency.g.." / "..luidefaults.Castbar.Colors.Latency.b.." / "..1-luidefaults.Castbar.Colors.Latency.a,
										type = "color",
										width = "full",
										disabled = function() return not oufdb.Castbar.IndividualColor end,
										hasAlpha = true,
										get = function() return oufdb.Castbar.Colors.Latency.r, oufdb.Castbar.Colors.Latency.g, oufdb.Castbar.Colors.Latency.b, oufdb.Castbar.Colors.Latency.a end,
										set = function(_,r,g,b,a)
											oufdb.Castbar.Colors.Latency.r = r
											oufdb.Castbar.Colors.Latency.g = g
											oufdb.Castbar.Colors.Latency.b = b
											oufdb.Castbar.Colors.Latency.a = a
											_G[UF].Castbar.SafeZone:SetVertexColor(r,g,b,a)
										end,
										order = 4,
									},]]
									CBBorderColor = {
										name = "Castbar Border Color",
										desc = "Choose an individual Castbar-Border-Color.\n\nDefaults: "..luidefaults.Castbar.Colors.Border.r.." / "..luidefaults.Castbar.Colors.Border.g.." / "..luidefaults.Castbar.Colors.Border.b.." / "..1-luidefaults.Castbar.Colors.Border.a,
										type = "color",
										width = "full",
										disabled = function() return not oufdb.Castbar.IndividualColor end,
										hasAlpha = true,
										get = function() return oufdb.Castbar.Colors.Border.r, oufdb.Castbar.Colors.Border.g, oufdb.Castbar.Colors.Border.b, oufdb.Castbar.Colors.Border.a end,
										set = function(_,r,g,b,a)
											oufdb.Castbar.Colors.Border.r = r
											oufdb.Castbar.Colors.Border.g = g
											oufdb.Castbar.Colors.Border.b = b
											oufdb.Castbar.Colors.Border.a = a
											_G[UF].CastbarBackdrop:SetBackdropBorderColor(r,g,b,a)
										end,
										order = 5, 
									},
									empty = {
										name = " ",
										type = "description",
										width = "full",
										order = 6,
									},
									CBNameColor = {
										name = "Castbar Name Text Color",
										desc = "Choose an individual Castbar Name Text Color.\n\nDefaults: "..luidefaults.Castbar.Colors.Name.r.." / "..luidefaults.Castbar.Colors.Name.g.." / "..luidefaults.Castbar.Colors.Name.b,
										type = "color",
										width = "full",
										hasAlpha = false,
										get = function() return oufdb.Castbar.Colors.Name.r, oufdb.Castbar.Colors.Name.g, oufdb.Castbar.Colors.Name.b end,
										set = function(_,r,g,b)
											oufdb.Castbar.Colors.Name.r = r
											oufdb.Castbar.Colors.Name.g = g
											oufdb.Castbar.Colors.Name.b = b
											_G[UF].Castbar.Text:SetTextColor(r, g, b)
										end,
										order = 7, 
									},
									CBTimeColor = {
										name = "Castbar Time Text Color",
										desc = "Choose an individual Castbar Time Text Color.\n\nDefaults: "..luidefaults.Castbar.Colors.Time.r.." / "..luidefaults.Castbar.Colors.Time.g.." / "..luidefaults.Castbar.Colors.Time.b,
										type = "color",
										width = "full",
										hasAlpha = false,
										get = function() return oufdb.Castbar.Colors.Time.r, oufdb.Castbar.Colors.Time.g, oufdb.Castbar.Colors.Time.b end,
										set = function(_,r,g,b)
											oufdb.Castbar.Colors.Time.r = r
											oufdb.Castbar.Colors.Time.g = g
											oufdb.Castbar.Colors.Time.b = b
											_G[UF].Castbar.Time:SetTextColor(r, g, b)
										end,
										order = 8, 
									},
								},
							},
							CastbarTexture = {
								name = "Castbar Textures",
								type = "group",
								guiInline = true,
								order = 2,
								args = {
									CBTexture = {
										name = "Bar Texture",
										desc = "Choose your Castbar Texture!\nDefault: LUI_Gradient",
										type = "select",
										dialogControl = "LSM30_Statusbar",
										values = widgetLists.statusbar,
										get = function() return oufdb.Castbar.Texture end,
										set = function(self, CBTexture)
											oufdb.Castbar.Texture = CBTexture
											_G[UF].Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", CBTexture))
										end,
										order = 1,
									},
									CBTextureBG = {
										name = "Background Texture",
										desc = "Choose your Castbar Background Texture!\nDefault: LUI_Minimalist",
										type = "select",
										dialogControl = "LSM30_Statusbar",
										values = widgetLists.statusbar,
										get = function() return oufdb.Castbar.TextureBG end,
										set = function(self, CBTextureBG)
											oufdb.Castbar.TextureBG = CBTextureBG
											_G[UF].Castbar.bg:SetTexture(LSM:Fetch("statusbar", CBTextureBG))
										end,
										order = 2,
									},
								},
							},
						},
					},
					Texts = {
						name = "Texts",
						type = "group",
						disabled = function() return not oufdb.Castbar.Enable end,
						order = 4,
						args = {
							CastbarText = {
								name = "Castbar Text",
								type = "group",
								guiInline = true,
								order = 7,
								args = {
									CastbarNameFont = {
										name = "Name Font",
										desc = "Choose your Font for your Castbar Name Text!\n\nDefault: "..luidefaults.Castbar.Text.Name.Font,
										type = "select",
										dialogControl = "LSM30_Font",
										values = widgetLists.font,
										get = function() return oufdb.Castbar.Text.Name.Font end,
										set = function(self, CastbarNameFont)
											oufdb.Castbar.Text.Name.Font = CastbarNameFont
											_G[UF].Castbar.Text:SetFont(LSM:Fetch("font", CastbarNameFont),oufdb.Castbar.Text.Name.Size)
										end,
										order = 1,
									},
									CastbarNameFontsize = {
										name = "Size",
										desc = "Choose your Castbar Name Text Fontsize!\n Default: "..luidefaults.Castbar.Text.Name.Size,
										type = "range",
										min = 10,
										max = 40,
										step = 1,
										get = function() return oufdb.Castbar.Text.Name.Size end,
										set = function(_, CastbarNameFontsize) 
											oufdb.Castbar.Text.Name.Size = CastbarNameFontsize
											_G[UF].Castbar.Text:SetFont(LSM:Fetch("font", oufdb.Castbar.Text.Name.Font),CastbarNameFontsize)
										end,
										order = 2,
									},
									CastbarTimeFont = {
										name = "Time Font",
										desc = "Choose your Font for your Castbar Time Text!\n\nDefault: "..luidefaults.Castbar.Text.Name.Font,
										type = "select",
										dialogControl = "LSM30_Font",
										values = widgetLists.font,
										get = function() return oufdb.Castbar.Text.Time.Font end,
										set = function(self, CastbarTimeFont)
											oufdb.Castbar.Text.Time.Font = CastbarTimeFont
											_G[UF].Castbar.Time:SetFont(LSM:Fetch("font", CastbarTimeFont),oufdb.Castbar.Text.Time.Size)
										end,
										order = 3,
									},
									CastbarTimeFontsize = {
										name = "Size",
										desc = "Choose your Castbar Time Text Fontsize!\n Default: "..luidefaults.Castbar.Text.Name.Size,
										type = "range",
										min = 10,
										max = 40,
										step = 1,
										get = function() return oufdb.Castbar.Text.Time.Size end,
										set = function(_, CastbarTimeFontsize) 
											oufdb.Castbar.Text.Time.Size = CastbarTimeFontsize
											_G[UF].Castbar.Time:SetFont(LSM:Fetch("font", oufdb.Castbar.Text.Time.Font),CastbarTimeFontsize)
										end,
										order = 4,
									},
									CastbarName = {
										name = "Show Name Text",
										desc = "Wether you want to show your Castbar Name Text or not.",
										type = "toggle",
										width = "full",
										get = function() return oufdb.Castbar.Text.Name.Enable end,
										set = function(self,CastbarName)
											oufdb.Castbar.Text.Name.Enable = CastbarName
											if CastbarName == true then
												_G[UF].Castbar.Text:Show()
											else
												_G[UF].Castbar.Text:Hide()
											end
										end,
										order = 5,
									},
									CastbarTime = {
										name = "Show Time Text",
										desc = "Wether you want to show your Castbar Time Text or not.",
										type = "toggle",
										width = "full",
										get = function() return oufdb.Castbar.Text.Time.Enable end,
										set = function(self,CastbarTime)
											oufdb.Castbar.Text.Time.Enable = CastbarTime
											if CastbarTime == true then
												_G[UF].Castbar.Time:Show()
											else
												_G[UF].Castbar.Time:Hide()
											end
										end,
										order = 6,
									},
									CastbarTimeMax = {
										name = "Show Cast Time",
										desc = "Wether you want to show your Castbar Cast Time or not.",
										type = "toggle",
										width = "full",
										disabled = function() return not oufdb.Castbar.Text.Time.Enable end,
										get = function() return oufdb.Castbar.Text.Time.ShowMax end,
										set = function(self,CastbarTimeMax)
											oufdb.Castbar.Text.Time.ShowMax = CastbarTimeMax
											_G[UF].Castbar.Time.ShowMax = CastbarTimeMax
											end,
										order = 7,
									},
									CastbarNameOffsetX = {
										name = "Name Text X Offset",
										desc = "Castbar Name Text X Offset.\nDefault: "..luidefaults.Castbar.Text.Name.OffsetX,
										type = "input",
										disabled = function() return oufdb.Castbar.Text.Name.Enable end,
										get = function() return oufdb.Castbar.Text.Name.OffsetX end,
										set = function(self,CastbarNameOffsetX)
											if CastbarNameOffsetX == nil or CastbarNameOffsetX == "" then CastbarNameOffsetX = "0" end
											oufdb.Castbar.Text.Name.OffsetX = CastbarNameOffsetX
											_G[UF].Castbar.Text:SetPoint("LEFT", tonumber(CastbarNameOffsetX), tonumber(oufdb.Castbar.Text.Name.OffsetY))
										end,  
										order = 8,
									},
									CastbarNameOffsetY = {
										name = "Name Text Y Offset",
										desc = "Castbar Name Text Y Offset.\nDefault: "..luidefaults.Castbar.Text.Name.OffsetY,
										type = "input",
										disabled = function() return not oufdb.Castbar.Text.Name.Enable end,
										get = function() return oufdb.Castbar.Text.Name.OffsetY end,
										set = function(self,CastbarNameOffsetY)
											if CastbarNameOffsetY == nil or CastbarNameOffsetY == "" then CastbarNameOffsetY = "0" end
											oufdb.Castbar.Text.Name.OffsetY = CastbarNameOffsetY
											_G[UF].Castbar.Text:SetPoint("LEFT", tonumber(oufdb.Castbar.Text.Name.OffsetX), tonumber(CastbarNameOffsetY))
										end,
										order = 9,
									},
									CastbarTimeOffsetX = {
										name = "Time Text X Offset",
										desc = "Castbar Time Text X Offset.\nDefault: "..luidefaults.Castbar.Text.Time.OffsetX,
										type = "input",
										disabled = function() return not oufdb.Castbar.Text.Time.Enable end,
										get = function() return oufdb.Castbar.Text.Time.OffsetX end,
										set = function(self,CastbarTimeOffsetX)
											if CastbarTimeOffsetX == nil or CastbarTimeOffsetX == "" then CastbarTimeOffsetX = "0" end
											oufdb.Castbar.Text.Time.OffsetX = CastbarTimeOffsetX
											_G[UF].Castbar.Time:SetPoint("RIGHT", tonumber(CastbarTimeOffsetX), tonumber(oufdb.Castbar.Text.Time.OffsetY))
										end,
										order = 10,
									},
									CastbarTimeOffsetY = {
										name = "Time Text Y Offset",
										desc = "Castbar Time Text Y Offset.\nDefault: "..luidefaults.Castbar.Text.Time.OffsetY,
										type = "input",
										disabled = function() return not oufdb.Castbar.Text.Time.Enable end,
										get = function() return oufdb.Castbar.Text.Time.OffsetY end,
										set = function(self,CastbarTimeOffsetY)
											if CastbarTimeOffsetY == nil or CastbarTimeOffsetY == "" then CastbarTimeOffsetY = "0" end
											oufdb.Castbar.Text.Time.OffsetY = CastbarTimeOffsetY
											_G[UF].Castbar.Time:SetPoint("RIGHT", tonumber(oufdb.Castbar.Text.Time.OffsetX), tonumber(CastbarTimeOffsetY))
										end,
										order = 11,
									},
								},
							},
						},
					},
					Border = {
						name = "Border",
						type = "group",
						disabled = function() return not oufdb.Castbar.Enable end,
						order = 5,
						args = {
							CastbarBorder = {
								name = "Castbar Border",
								type = "group",
								guiInline = true,
								order = 6,
								args = {
									CBBorder = {
										name = "Border Texture",
										desc = "Choose your Border Texture!\nDefault: "..luidefaults.Castbar.Border.Texture,
										type = "select",
										dialogControl = "LSM30_Border",
										values = widgetLists.border,
										get = function() return oufdb.Castbar.Border.Texture end,
										set = function(self, CBBorder)
											oufdb.Castbar.Border.Texture = CBBorder
											
											_G[UF].CastbarBackdrop:SetBackdrop({
													edgeFile = LSM:Fetch("border", CBBorder), edgeSize = oufdb.Castbar.Border.Thickness,
													insets = {left = oufdb.Castbar.Border.Inset.left, right = oufdb.Castbar.Border.Inset.right, top = oufdb.Castbar.Border.Inset.top, bottom = oufdb.Castbar.Border.Inset.bottom}
												})
											_G[UF].CastbarBackdrop:SetBackdropColor(0, 0, 0, 0)
											_G[UF].CastbarBackdrop:SetBackdropBorderColor(oufdb.Castbar.Colors.Border.r,oufdb.Castbar.Colors.Border.g,oufdb.Castbar.Colors.Border.b,oufdb.Castbar.Colors.Border.a)
										end,
										order = 1,
									},
									CBBorderThickness = {
										name = "Edge Size",
										desc = "Value for your Castbar Border Edge Size\nDefault: "..luidefaults.Castbar.Border.Thickness,
										type = "input",
										width = "half",
										get = function() return oufdb.Castbar.Border.Thickness end,
										set = function(self,CBBorderThickness)
											if CBBorderThickness == nil or CBBorderThickness == "" then CBBorderThickness = "0" end
											oufdb.Castbar.Border.Thickness = CBBorderThickness
											
											_G[UF].CastbarBackdrop:SetBackdrop({
													edgeFile = LSM:Fetch("border", oufdb.Castbar.Border.Texture), edgeSize = CBBorderThickness,
													insets = {left = oufdb.Castbar.Border.Inset.left, right = oufdb.Castbar.Border.Inset.right, top = oufdb.Castbar.Border.Inset.top, bottom = oufdb.Castbar.Border.Inset.bottom}
												})
											_G[UF].CastbarBackdrop:SetBackdropColor(0, 0, 0, 0)
											_G[UF].CastbarBackdrop:SetBackdropBorderColor(oufdb.Castbar.Colors.Border.r,oufdb.Castbar.Colors.Border.g,oufdb.Castbar.Colors.Border.b,oufdb.Castbar.Colors.Border.a)
										end,
										order = 2,
									},
									empty235 = {
										name = "   ",
										type = "description",
										order = 3,
									},
									CBBorderInsetLeft = {
										name = "Left",
										desc = "Value for the Left Border Inset\nDefault: "..luidefaults.Castbar.Border.Inset.left,
										type = "input",
										width = "half",
										get = function() return oufdb.Castbar.Border.Inset.left end,
										set = function(self,CBBorderInsetLeft)
											if CBBorderInsetLeft == nil or CBBorderInsetLeft == "" then CBBorderInsetLeft = "0" end
											oufdb.Castbar.Border.Inset.left = CBBorderInsetLeft
											
											_G[UF].CastbarBackdrop:SetBackdrop({
													edgeFile = LSM:Fetch("border", oufdb.Castbar.Border.Texture), edgeSize = oufdb.Castbar.Border.Thickness,
													insets = {left = CBBorderInsetLeft, right = oufdb.Castbar.Border.Inset.right, top = oufdb.Castbar.Border.Inset.top, bottom = oufdb.Castbar.Border.Inset.bottom}
												})
											_G[UF].CastbarBackdrop:SetBackdropColor(0, 0, 0, 0)
											_G[UF].CastbarBackdrop:SetBackdropBorderColor(oufdb.Castbar.Colors.Border.r,oufdb.Castbar.Colors.Border.g,oufdb.Castbar.Colors.Border.b,oufdb.Castbar.Colors.Border.a)
										end,
										order = 4,
									},
									CBBorderInsetRight = {
										name = "Right",
										desc = "Value for the Right Border Inset\nDefault: "..luidefaults.Castbar.Border.Inset.right,
										type = "input",
										width = "half",
										get = function() return oufdb.Castbar.Border.Inset.right end,
										set = function(self,CBBorderInsetRight)
											if CBBorderInsetRight == nil or CBBorderInsetRight == "" then CBBorderInsetRight = "0" end
											oufdb.Castbar.Border.Inset.right = CBBorderInsetRight
											
											_G[UF].CastbarBackdrop:SetBackdrop({
													edgeFile = LSM:Fetch("border", oufdb.Castbar.Border.Texture), edgeSize = oufdb.Castbar.Border.Thickness,
													insets = {left = oufdb.Castbar.Border.Inset.left, right = CBBorderInsetRight, top = oufdb.Castbar.Border.Inset.top, bottom = oufdb.Castbar.Border.Inset.bottom}
												})
											_G[UF].CastbarBackdrop:SetBackdropColor(0, 0, 0, 0)
											_G[UF].CastbarBackdrop:SetBackdropBorderColor(oufdb.Castbar.Colors.Border.r,oufdb.Castbar.Colors.Border.g,oufdb.Castbar.Colors.Border.b,oufdb.Castbar.Colors.Border.a)
										end,
										order = 5,
									},
									CBBorderInsetTop = {
										name = "Top",
										desc = "Value for the Top Border Inset\nDefault: "..luidefaults.Castbar.Border.Inset.top,
										type = "input",
										width = "half",
										get = function() return oufdb.Castbar.Border.Inset.top end,
										set = function(self,CBBorderInsetTop)
											if CBBorderInsetTop == nil or CBBorderInsetTop == "" then CBBorderInsetTop = "0" end
											oufdb.Castbar.Border.Inset.top = CBBorderInsetTop
											
											_G[UF].CastbarBackdrop:SetBackdrop({
													edgeFile = LSM:Fetch("border", oufdb.Castbar.Border.Texture), edgeSize = oufdb.Castbar.Border.Thickness,
													insets = {left = oufdb.Castbar.Border.Inset.left, right = oufdb.Castbar.Border.Inset.right, top = CBBorderInsetTop, bottom = oufdb.Castbar.Border.Inset.bottom}
												})
											_G[UF].CastbarBackdrop:SetBackdropColor(0, 0, 0, 0)
											_G[UF].CastbarBackdrop:SetBackdropBorderColor(oufdb.Castbar.Colors.Border.r,oufdb.Castbar.Colors.Border.g,oufdb.Castbar.Colors.Border.b,oufdb.Castbar.Colors.Border.a)
										end,
										order = 6,
									},
									CBBorderInsetBottom = {
										name = "Bottom",
										desc = "Value for the Bottom Border Inset\nDefault: "..luidefaults.Castbar.Border.Inset.bottom,
										type = "input",
										width = "half",
										get = function() return oufdb.Castbar.Border.Inset.bottom end,
										set = function(self,CBBorderInsetBottom)
											if CBBorderInsetBottom == nil or CBBorderInsetBottom == "" then CBBorderInsetBottom = "0" end
											oufdb.Castbar.Border.Inset.bottom = CBBorderInsetBottom
											
											_G[UF].CastbarBackdrop:SetBackdrop({
													edgeFile = LSM:Fetch("border", oufdb.Castbar.Border.Texture), edgeSize = oufdb.Castbar.Border.Thickness,
													insets = {left = oufdb.Castbar.Border.Inset.left, right = oufdb.Castbar.Border.Inset.right, top = oufdb.Castbar.Border.Inset.top, bottom = CBBorderInsetBottom}
												})
											_G[UF].CastbarBackdrop:SetBackdropColor(0, 0, 0, 0)
											_G[UF].CastbarBackdrop:SetBackdropBorderColor(oufdb.Castbar.Colors.Border.r,oufdb.Castbar.Colors.Border.g,oufdb.Castbar.Colors.Border.b,oufdb.Castbar.Colors.Border.a)
										end,
										order = 7,
									},
								},
							},
						},
					},
				},
			} or nil,
			Aura = (unit == "Player" or unit == "Target" or unit == "Focus" or unit == "Pet" or unit == "ToT") and {
				name = "Aura",
				type = "group",
				disabled = function() return (oufdb.Enable ~= nil and not oufdb.Enable or false) end,
				childGroups = "tab",
				order = 8,
				args = {
					header = {
						name = unit.." Auras",
						type = "header",
						order = 1,
					},
					Buffs = {
						name = "Buffs",
						type = "group",
						order = 2,
						args = {
							BuffsEnable = {
								name = "Enable "..unit.." Buffs",
								desc = "Wether you want to show "..unit.." Buffs or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Aura.buffs_enable end,
								set = function(self,BuffsEnable)
									oufdb.Aura.buffs_enable = BuffsEnable
									if not _G[UF].Buffs then _G[UF].CreateBuffs() end
									if BuffsEnable == true then
										_G[UF]:EnableElement("Aura")
										_G[UF].Buffs:Show()
									else
										if oufdb.Aura.debuffs_enable == false then
											_G[UF]:DisableElement("Aura")
										end
										_G[UF].Buffs:Hide()
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 1,
							},
							BuffsAuratimer = {
								name = "Enable Auratimer",
								desc = "Wether you want to show Auratimers or not.",
								type = "toggle",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								get = function() return oufdb.Aura.buffs_auratimer end,
								set = function(self,BuffsAuratimer)
									oufdb.Aura.buffs_auratimer = BuffsAuratimer
									_G[UF].Buffs.showAuratimer = BuffsAuratimer
									_G[UF]:UpdateAllElements()
								end,
								order = 2,
							},
							PlayerBuffsOnly = {
								name = "Player Buffs Only",
								desc = "Wether you want to show only your Buffs on "..unit.." or not.",
								type = "toggle",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								get = function() return oufdb.Aura.buffs_playeronly end,
								set = function(self,PlayerBuffsOnly)
									oufdb.Aura.buffs_playeronly = PlayerBuffsOnly
									_G[UF].Buffs.onlyShowPlayer = PlayerBuffsOnly
									_G[UF]:UpdateAllElements()
								end,
								order = 3,
							},
							BuffsColorByType = {
								name = "Color by Type",
								desc = "Wether you want to color "..unit.." Buffs by Type or not.",
								type = "toggle",
								width = "full",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								get = function() return oufdb.Aura.buffs_colorbytype end,
								set = function(self,BuffsColorByType)
									oufdb.Aura.buffs_colorbytype = BuffsColorByType
									_G[UF].Buffs.showAuraType = BuffsColorByType
									_G[UF]:UpdateAllElements()
								end,
								order = 4,
							},
							BuffsCooldown = {
								name = "Hide Cooldown Spiral",
								desc = "Wether you want to disable the cooldown spiral effect on your Buffs or not.",
								type = "toggle",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								get = function() return oufdb.Aura.buffs_disableCooldown end,
								set = function(self,DisableCooldown)
									oufdb.Aura.buffs_disableCooldown = DisableCooldown
									_G[UF].Buffs.disableCooldown = DisableCooldown
									_G[UF]:UpdateAllElements()
								end,
								order = 5,
							},
							BuffsCooldownReverse = {
								name = "Reverse Cooldown Effect",
								desc = "Wether you want to reverse the cooldown spiral effect on your Buffs or not.",
								type = "toggle",
								disabled = function() return not oufdb.Aura.buffs_enable or oufdb.Aura.buffs_disableCooldown end,
								get = function() return oufdb.Aura.buffs_cooldownReverse end,
								set = function(self,CooldownReverse)
									oufdb.Aura.buffs_cooldownReverse = CooldownReverse
									_G[UF].Buffs.cooldownReverse = CooldownReverse
									_G[UF]:UpdateAllElements()
								end,
								order = 6,
							},
							BuffsNum = {
								name = "Amount",
								desc = "Amount of your "..unit.." Buffs.\nDefault: "..luidefaults.Aura.buffs_num,
								type = "input",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								get = function() return oufdb.Aura.buffs_num end,
								set = function(self,BuffsNum)
									if BuffsNum == nil or BuffsNum == "" then BuffsNum = "0" end
									oufdb.Aura.buffs_num = BuffsNum
									_G[UF].Buffs.num = tonumber(BuffsNum)
									_G[UF]:UpdateAllElements()
								end,
								order = 7,
							},
							empty = {
								name = "   ",
								width = "full",
								type = "description",
								order = 8,
							},
							BuffsSize = {
								name = "Size",
								desc = "Size for your "..unit.." Buffs.\nDefault: "..luidefaults.Aura.buffs_size,
								type = "input",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								get = function() return oufdb.Aura.buffs_size end,
								set = function(self,BuffsSize)
									if BuffsSize == nil or BuffsSize == "" then BuffsSize = "0" end
									oufdb.Aura.buffs_size = BuffsSize
									_G[UF].Buffs:SetHeight(tonumber(BuffsSize))
									_G[UF].Buffs.size = tonumber(BuffsSize)
									for i = 1, #_G[UF].Buffs do
										local button = _G[UF].Buffs[i]
										if(button and button:IsShown()) then
											button:SetWidth(tonumber(BuffsSize))
											button:SetHeight(tonumber(BuffsSize))
										elseif(not button) then
											break
										end
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 9,
							},
							BuffsSpacing = {
								name = "Spacing",
								desc = "Spacing between your "..unit.." Buffs.\nDefault: "..luidefaults.Aura.buffs_spacing,
								type = "input",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								get = function() return oufdb.Aura.buffs_spacing end,
								set = function(self,BuffsSpacing)
									if BuffsSpacing == nil or BuffsSpacing == "" then BuffsSpacing = "0" end
									oufdb.Aura.buffs_spacing = BuffsSpacing
									_G[UF].Buffs.spacing = tonumber(BuffsSpacing)
									_G[UF]:UpdateAllElements()
								end,
								order = 10,
							},
							BuffsX = {
								name = "X Value",
								desc = "X Value for your "..unit.." Buffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Aura.buffsX,
								type = "input",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								get = function() return oufdb.Aura.buffsX end,
								set = function(self,BuffsX)
									if BuffsX == nil or BuffsX == "" then BuffsX = "0" end
									oufdb.Aura.buffsX = BuffsX
									_G[UF].Buffs:ClearAllPoints()
									_G[UF].Buffs:SetPoint(oufdb.Aura.buffs_initialAnchor, _G[UF], oufdb.Aura.buffs_initialAnchor, tonumber(BuffsX), tonumber(oufdb.Aura.buffsY))
								end,
								order = 11,
							},
							BuffsY = {
								name = "Y Value",
								desc = "Y Value for your "..unit.." Buffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Aura.buffsY,
								type = "input",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								get = function() return oufdb.Aura.buffsY end,
								set = function(self,BuffsY)
									if BuffsY == nil or BuffsY == "" then BuffsY = "0" end
									oufdb.Aura.buffsY = BuffsY
									_G[UF].Buffs:ClearAllPoints()
									_G[UF].Buffs:SetPoint(oufdb.Aura.buffs_initialAnchor, _G[UF], oufdb.Aura.buffs_initialAnchor, tonumber(oufdb.Aura.buffsX), tonumber(BuffsY))
								end,
								order = 12,
							},
							BuffsGrowthY = {
								name = "Growth Y",
								desc = "Choose the growth Y direction for your "..unit.." Buffs.\nDefault: "..luidefaults.Aura.buffs_growthY,
								type = "select",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								values = growthY,
								get = function()
									for k, v in pairs(growthY) do
										if oufdb.Aura.buffs_growthY == v then
											return k
										end
									end
								end,
								set = function(self, BuffsGrowthY)
									oufdb.Aura.buffs_growthY = growthY[BuffsGrowthY]
									_G[UF].Buffs["growth-y"] = growthY[BuffsGrowthY]
									_G[UF]:UpdateAllElements()
								end,
								order = 13,
							},
							BuffsGrowthX = {
								name = "Growth X",
								desc = "Choose the growth X direction for your "..unit.." Buffs.\nDefault: "..luidefaults.Aura.buffs_growthX,
								type = "select",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								values = growthX,
								get = function()
									for k, v in pairs(growthX) do
										if oufdb.Aura.buffs_growthX == v then
											return k
										end
									end
								end,
								set = function(self, BuffsGrowthX)
									oufdb.Aura.buffs_growthX = growthX[BuffsGrowthX]
									_G[UF].Buffs["growth-x"] = growthX[BuffsGrowthX]
									_G[UF]:UpdateAllElements()
								end,
								order = 14,
							},
							BuffsAnchor = {
								name = "Initial Anchor",
								desc = "Choose the initinal Anchor for your "..unit.." Buffs.\nDefault: "..luidefaults.Aura.buffs_initialAnchor,
								type = "select",
								disabled = function() return not oufdb.Aura.buffs_enable end,
								values = positions,
								get = function()
									for k, v in pairs(positions) do
										if oufdb.Aura.buffs_initialAnchor == v then
											return k
										end
									end
								end,
								set = function(self, BuffsAnchor)
									oufdb.Aura.buffs_initialAnchor = positions[BuffsAnchor]
									_G[UF].Buffs:ClearAllPoints()
									_G[UF].Buffs:SetPoint(positions[BuffsAnchor], _G[UF], positions[BuffsAnchor], tonumber(oufdb.Aura.buffsX), tonumber(oufdb.Aura.buffsY))
									_G[UF].Buffs.initialAnchor = positions[BuffsAnchor]
									_G[UF]:UpdateAllElements()
								end,
								order = 15,
							},
						},
					},
					Debuffs = {
						name = "Debuffs",
						type = "group",
						order = 3,
						args = {
							DebuffsEnable = {
								name = "Enable "..unit.." Debuffs",
								desc = "Wether you want to show "..unit.." Debuffs or not.",
								type = "toggle",
								width = "full",
								get = function() return oufdb.Aura.debuffs_enable end,
								set = function(self,DebuffsEnable)
									oufdb.Aura.debuffs_enable = DebuffsEnable
									if not _G[UF].Debuffs then _G[UF].CreateDebuffs() end
									if DebuffsEnable == true then
										_G[UF]:EnableElement("Aura")
										_G[UF].Debuffs:Show()
									else
										if oufdb.Aura.buffs_enable == false then
											_G[UF]:DisableElement("Aura")
										end
										_G[UF].Debuffs:Hide()
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 1,
							},
							DebuffsAuratimer = {
								name = "Enable Auratimer",
								desc = "Wether you want to show Auratimers or not.",
								type = "toggle",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								get = function() return oufdb.Aura.debuffs_auratimer end,
								set = function(self,DebuffsAuratimer)
									oufdb.Aura.debuffs_auratimer = DebuffsAuratimer
									_G[UF].Debuffs.showAuratimer = DebuffsAuratimer
									_G[UF]:UpdateAllElements()
								end,
								order = 2,
							},
							PlayerDebuffsOnly = {
								name = "Player Debuffs Only",
								desc = "Wether you want to show only your Debuffs on "..unit.." or not.",
								type = "toggle",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								get = function() return oufdb.Aura.debuffs_playeronly end,
								set = function(self,PlayerDebuffsOnly)
									oufdb.Aura.debuffs_playeronly = PlayerDebuffsOnly
									_G[UF].Debuffs.onlyShowPlayer = PlayerDebuffsOnly
									_G[UF]:UpdateAllElements()
								end,
								order = 3,
							},
							DebuffsColorByType = {
								name = "Color by Type",
								desc = "Wether you want to color "..unit.." Debuffs by Type or not.",
								type = "toggle",
								width = "full",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								get = function() return oufdb.Aura.debuffs_colorbytype end,
								set = function(self,DebuffsColorByType)
									oufdb.Aura.debuffs_colorbytype = DebuffsColorByType
									_G[UF].Debuffs.showAuraType = DebuffsColorByType
									_G[UF]:UpdateAllElements()
								end,
								order = 4,
							},
							DebuffsCooldown = {
								name = "Hide Cooldown Spiral",
								desc = "Wether you want to disable the cooldown spiral effect on your Debuffs or not.",
								type = "toggle",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								get = function() return oufdb.Aura.debuffs_disableCooldown end,
								set = function(self,DisableCooldown)
									oufdb.Aura.debuffs_disableCooldown = DisableCooldown
									_G[UF].Debuffs.disableCooldown = DisableCooldown
									_G[UF]:UpdateAllElements()
								end,
								order = 5,
							},
							DebuffsCooldownReverse = {
								name = "Reverse Cooldown Effect",
								desc = "Wether you want to reverse the cooldown spiral effect on your Debuffs or not.",
								type = "toggle",
								disabled = function() return not oufdb.Aura.debuffs_enable or oufdb.Aura.debuffs_disableCooldown end,
								get = function() return oufdb.Aura.debuffs_cooldownReverse end,
								set = function(self,CooldownReverse)
									oufdb.Aura.debuffs_cooldownReverse = CooldownReverse
									_G[UF].Debuffs.cooldownReverse = CooldownReverse
									_G[UF]:UpdateAllElements()
								end,
								order = 6,
							},
							DebuffsNum = {
								name = "Amount",
								desc = "Amount of your "..unit.." Debuffs.\nDefault: "..luidefaults.Aura.debuffs_num,
								type = "input",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								get = function() return oufdb.Aura.debuffs_num end,
								set = function(self,DebuffsNum)
									if DebuffsNum == nil or DebuffsNum == "" then DebuffsNum = "0" end
									oufdb.Aura.debuffs_num = DebuffsNum
									_G[UF].Debuffs.num = tonumber(DebuffsNum)
									_G[UF]:UpdateAllElements()
								end,
								order = 7,
							},
							empty = {
								name = "   ",
								width = "full",
								type = "description",
								order = 8,
							},
							DebuffsSize = {
								name = "Size",
								desc = "Size for your "..unit.." Debuffs.\nDefault: "..luidefaults.Aura.debuffs_size,
								type = "input",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								get = function() return oufdb.Aura.debuffs_size end,
								set = function(self,DebuffsSize)
									if DebuffsSize == nil or DebuffsSize == "" then DebuffsSize = "0" end
									oufdb.Aura.debuffs_size = DebuffsSize
									_G[UF].Debuffs:SetHeight(tonumber(DebuffsSize))
									_G[UF].Debuffs.size = tonumber(DebuffsSize)
									for i = 1, #_G[UF].Debuffs do
										local button = _G[UF].Debuffs[i]
										if(button and button:IsShown()) then
											button:SetWidth(tonumber(DebuffsSize))
											button:SetHeight(tonumber(DebuffsSize))
										elseif(not button) then
											break
										end
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 9,
							},
							DebuffsSpacing = {
								name = "Spacing",
								desc = "Spacing between your "..unit.." Debuffs.\nDefault: "..luidefaults.Aura.debuffs_spacing,
								type = "input",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								get = function() return oufdb.Aura.debuffs_spacing end,
								set = function(self,DebuffsSpacing)
									if DebuffsSpacing == nil or DebuffsSpacing == "" then DebuffsSpacing = "0" end
									oufdb.Aura.debuffs_spacing = DebuffsSpacing
									_G[UF].Debuffs.spacing = tonumber(DebuffsSpacing)
									_G[UF]:UpdateAllElements()
								end,
								order = 10,
							},
							DebuffsX = {
								name = "X Value",
								desc = "X Value for your "..unit.." Debuffs.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Aura.debuffsX,
								type = "input",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								get = function() return oufdb.Aura.debuffsX end,
								set = function(self,DebuffsX)
									if DebuffsX == nil or DebuffsX == "" then DebuffsX = "0" end
									oufdb.Aura.debuffsX = DebuffsX
									_G[UF].Debuffs:ClearAllPoints()
									_G[UF].Debuffs:SetPoint(oufdb.Aura.debuffs_initialAnchor, _G[UF], oufdb.Aura.debuffs_initialAnchor, tonumber(DebuffsX), tonumber(oufdb.Aura.debuffsY))
								end,
								order = 11,
							},
							DebuffsY = {
								name = "Y Value",
								desc = "Y Value for your "..unit.." Debuffs.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Aura.debuffsY,
								type = "input",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								get = function() return oufdb.Aura.debuffsY end,
								set = function(self,DebuffsY)
									if DebuffsY == nil or DebuffsY == "" then DebuffsY = "0" end
									oufdb.Aura.debuffsY = DebuffsY
									_G[UF].Debuffs:ClearAllPoints()
									_G[UF].Debuffs:SetPoint(oufdb.Aura.debuffs_initialAnchor, _G[UF], oufdb.Aura.debuffs_initialAnchor, tonumber(oufdb.Aura.debuffsX), tonumber(DebuffsY))
								end,
								order = 12,
							},
							DebuffsGrowthY = {
								name = "Growth Y",
								desc = "Choose the growth Y direction for your "..unit.." Debuffs.\nDefault: "..luidefaults.Aura.debuffs_growthY,
								type = "select",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								values = growthY,
								get = function()
									for k, v in pairs(growthY) do
										if oufdb.Aura.debuffs_growthY == v then
											return k
										end
									end
								end,
								set = function(self, DebuffsGrowthY)
									oufdb.Aura.debuffs_growthY = growthY[DebuffsGrowthY]
									_G[UF].Debuffs["growth-y"] = growthY[DebuffsGrowthY]
									_G[UF]:UpdateAllElements()
								end,
								order = 13,
							},
							DebuffsGrowthX = {
								name = "Growth X",
								desc = "Choose the growth X direction for your "..unit.." Debuffs.\nDefault: "..luidefaults.Aura.debuffs_growthX,
								type = "select",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								values = growthX,
								get = function()
									for k, v in pairs(growthX) do
										if oufdb.Aura.debuffs_growthX == v then
											return k
										end
									end
								end,
								set = function(self, DebuffsGrowthX)
									oufdb.Aura.debuffs_growthX = growthX[DebuffsGrowthX]
									_G[UF].Debuffs["growth-x"] = growthX[DebuffsGrowthX]
									_G[UF]:UpdateAllElements()
								end,
								order = 14,
							},
							DebuffsAnchor = {
								name = "Initial Anchor",
								desc = "Choose the initinal Anchor for your "..unit.." Debuffs.\nDefault: "..luidefaults.Aura.debuffs_initialAnchor,
								type = "select",
								disabled = function() return not oufdb.Aura.debuffs_enable end,
								values = positions,
								get = function()
									for k, v in pairs(positions) do
										if oufdb.Aura.debuffs_initialAnchor == v then
											return k
										end
									end
								end,
								set = function(self, DebuffsAnchor)
									oufdb.Aura.debuffs_initialAnchor = positions[DebuffsAnchor]
									_G[UF].Debuffs:ClearAllPoints()
									_G[UF].Debuffs:SetPoint(positions[DebuffsAnchor], _G[UF], positions[DebuffsAnchor], tonumber(oufdb.Aura.debuffsX), tonumber(oufdb.Aura.debuffsY))
									_G[UF].Debuffs.initialAnchor = positions[DebuffsAnchor]
									_G[UF]:UpdateAllElements()
								end,
								order = 15,
							},
						},
					},
				},
			} or nil,
			Portrait = {
				name = "Portrait",
				type = "group",
				disabled = function() return (oufdb.Enable ~= nil and not oufdb.Enable or false) end,
				order = 9,
				args = {
					EnablePortrait = {
						name = "Enable",
						desc = "Wether you want to show the Portrait or not.",
						type = "toggle",
						width = "full",
						get = function() return oufdb.Portrait.Enable end,
						set = function(self,EnablePortrait)
							oufdb.Portrait.Enable = EnablePortrait
							if not _G[UF].Portrait then _G[UF].CreatePortrait() end
							if EnablePortrait == true then
								_G[UF]:EnableElement("Portrait")
								_G[UF].Portrait:Show()
							else
								_G[UF].Portrait:Hide()
								_G[UF]:DisableElement("Portrait")
							end
							_G[UF]:UpdateAllElements()
						end,
						order = 1,
					},
					PortraitWidth = {
						name = "Width",
						desc = "Choose the Width for your Portrait.\nDefault: "..luidefaults.Portrait.Width,
						type = "input",
						disabled = function() return not oufdb.Portrait.Enable end,
						get = function() return oufdb.Portrait.Width end,
						set = function(self,PortraitWidth)
							if PortraitWidth == nil or PortraitWidth == "" then PortraitWidth = "0" end
							oufdb.Portrait.Width = PortraitWidth
							_G[UF].Portrait:SetWidth(tonumber(PortraitWidth))
						end,
						order = 2,
					},
					PortraitHeight = {
						name = "Height",
						desc = "Choose the Height for your Portrait.\nDefault: "..luidefaults.Portrait.Height,
						type = "input",
						disabled = function() return not oufdb.Portrait.Enable end,
						get = function() return oufdb.Portrait.Height end,
						set = function(self,PortraitHeight)
							if PortraitHeight == nil or PortraitHeight == "" then PortraitHeight = "0" end
							oufdb.Portrait.Height = PortraitHeight
							_G[UF].Portrait:SetHeight(tonumber(PortraitHeight))
						end,
						order = 3,
					},
					PortraitX = {
						name = "X Value",
						desc = "X Value for your Portrait.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Portrait.X,
						type = "input",
						disabled = function() return not oufdb.Portrait.Enable end,
						get = function() return oufdb.Portrait.X end,
						set = function(self,PortraitX)
							if PortraitX == nil or PortraitX == "" then PortraitX = "0" end
							oufdb.Portrait.X = PortraitX
							_G[UF].Portrait:SetPoint("TOPLEFT", _G[UF].Health, "TOPLEFT", PortraitX, oufdb.Portrait.Y)
						end,
						order = 4,
					},
					PortraitY = {
						name = "Y Value",
						desc = "Y Value for your Portrait.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Portrait.Y,
						type = "input",
						disabled = function() return not oufdb.Portrait.Enable end,
						get = function() return oufdb.Portrait.Y end,
						set = function(self,PortraitY)
							if PortraitY == nil or PortraitY == "" then PortraitY = "0" end
							oufdb.Portrait.Y = PortraitY
							_G[UF].Portrait:SetPoint("TOPLEFT", _G[UF].Health, "TOPLEFT", oufdb.Portrait.X, PortraitY)
						end,
						order = 5,
					},
				},
			},
			Icons = {
				name = "Icons",
				type = "group",
				disabled = function() return (oufdb.Enable ~= nil and not oufdb.Enable or false) end,
				order = 10,
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
								get = function() return oufdb.Icons.Lootmaster.Enable end,
								set = function(self,LootMasterEnable)
									oufdb.Icons.Lootmaster.Enable = LootMasterEnable
									if not _G[UF].MasterLooter then _G[UF].CreateMasterLooter() end
									if LootMasterEnable then
										_G[UF]:EnableElement("MasterLooter")
									else
										_G[UF]:DisableElement("MasterLooter")
										_G[UF].MasterLooter:Hide()
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 1,
							},
							LootMasterX = {
								name = "X Value",
								desc = "X Value for your LootMaster Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Icons.Lootmaster.X,
								type = "input",
								disabled = function() return not oufdb.Icons.Lootmaster.Enable end,
								get = function() return oufdb.Icons.Lootmaster.X end,
								set = function(self,LootMasterX)
									if LootMasterX == nil or LootMasterX == "" then LootMasterX = "0" end
									oufdb.Icons.Lootmaster.X = LootMasterX
									_G[UF].MasterLooter:ClearAllPoints()
									_G[UF].MasterLooter:SetPoint(oufdb.Icons.Lootmaster.Point, _G[UF], oufdb.Icons.Lootmaster.Point, tonumber(LootMasterX), tonumber(oufdb.Icons.Lootmaster.Y))
								end,
								order = 2,
							},
							LootMasterY = {
								name = "Y Value",
								desc = "Y Value for your LootMaster Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Icons.Lootmaster.Y,
								type = "input",
								disabled = function() return not oufdb.Icons.Lootmaster.Enable end,
								get = function() return oufdb.Icons.Lootmaster.Y end,
								set = function(self,LootMasterY)
									if LootMasterY == nil or LootMasterY == "" then LootMasterY = "0" end
									oufdb.Icons.Lootmaster.Y = LootMasterY
									_G[UF].MasterLooter:ClearAllPoints()
									_G[UF].MasterLooter:SetPoint(oufdb.Icons.Lootmaster.Point, _G[UF], oufdb.Icons.Lootmaster.Point, tonumber(oufdb.Icons.Lootmaster.X), tonumber(LootMasterY))
								end,
								order = 3,
							},
							LootMasterPoint = {
								name = "Position",
								desc = "Choose the Position for your LootMaster Icon.\nDefault: "..luidefaults.Icons.Lootmaster.Point,
								type = "select",
								disabled = function() return not oufdb.Icons.Lootmaster.Enable end,
								values = positions,
								get = function()
									for k, v in pairs(positions) do
										if oufdb.Icons.Lootmaster.Point == v then
											return k
										end
									end
								end,
								set = function(self, LootMasterPoint)
									oufdb.Icons.Lootmaster.Point = positions[LootMasterPoint]
									_G[UF].MasterLooter:ClearAllPoints()
									_G[UF].MasterLooter:SetPoint(oufdb.Icons.Lootmaster.Point, _G[UF], oufdb.Icons.Lootmaster.Point, tonumber(oufdb.Icons.Lootmaster.X), tonumber(oufdb.Icons.Lootmaster.Y))
								end,
								order = 4,
							},
							LootMasterSize = {
								name = "Size",
								desc = "Choose a size for your LootMaster Icon.\nDefault: "..luidefaults.Icons.Lootmaster.Size,
								type = "range",
								min = 5,
								max = 40,
								step = 1,
								disabled = function() return not oufdb.Icons.Lootmaster.Enable end,
								get = function() return oufdb.Icons.Lootmaster.Size end,
								set = function(_, LootMasterSize) 
									oufdb.Icons.Lootmaster.Size = LootMasterSize
									_G[UF].MasterLooter:SetHeight(LootMasterSize)
									_G[UF].MasterLooter:SetWidth(LootMasterSize)
								end,
								order = 5,
							},
							toggle = {
								order = 6,
								name = "Show/Hide",
								disabled = function() return not oufdb.Icons.Lootmaster.Enable end,
								desc = "Toggles the LootMaster Icon",
								type = 'execute',
								func = function() if _G[UF].MasterLooter:IsShown() then _G[UF].MasterLooter:Hide() else _G[UF].MasterLooter:Show() end end
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
								get = function() return oufdb.Icons.Leader.Enable end,
								set = function(self,LeaderEnable)
									oufdb.Icons.Leader.Enable = LeaderEnable
									if not _G[UF].Leader then _G[UF].CreateLeader() end
									if LeaderEnable then
										_G[UF]:EnableElement("Leader")
									else
										_G[UF]:DisableElement("Leader")
										_G[UF].Leader:Hide()
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 1,
							},
							LeaderX = {
								name = "X Value",
								desc = "X Value for your Leader Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Icons.Leader.X,
								type = "input",
								disabled = function() return not oufdb.Icons.Leader.Enable end,
								get = function() return oufdb.Icons.Leader.X end,
								set = function(self,LeaderX)
									if LeaderX == nil or LeaderX == "" then LeaderX = "0" end
									oufdb.Icons.Leader.X = LeaderX
									_G[UF].Leader:ClearAllPoints()
									_G[UF].Leader:SetPoint(oufdb.Icons.Leader.Point, _G[UF], oufdb.Icons.Leader.Point, tonumber(LeaderX), tonumber(oufdb.Icons.Leader.Y))
								end,
								order = 2,
							},
							LeaderY = {
								name = "Y Value",
								desc = "Y Value for your Leader Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Icons.Leader.Y,
								type = "input",
								disabled = function() return not oufdb.Icons.Leader.Enable end,
								get = function() return oufdb.Icons.Leader.Y end,
								set = function(self,LeaderY)
									if LeaderY == nil or LeaderY == "" then LeaderY = "0" end
									oufdb.Icons.Leader.Y = LeaderY
									_G[UF].Leader:ClearAllPoints()
									_G[UF].Leader:SetPoint(oufdb.Icons.Leader.Point, _G[UF], oufdb.Icons.Leader.Point, tonumber(oufdb.Icons.Leader.X), tonumber(LeaderY))
								end,
								order = 3,
							},
							LeaderPoint = {
								name = "Position",
								desc = "Choose the Position for your Leader Icon.\nDefault: "..luidefaults.Icons.Leader.Point,
								type = "select",
								disabled = function() return not oufdb.Icons.Leader.Enable end,
								values = positions,
								get = function()
									for k, v in pairs(positions) do
										if oufdb.Icons.Leader.Point == v then
											return k
										end
									end
								end,
								set = function(self, LeaderPoint)
									oufdb.Icons.Leader.Point = positions[LeaderPoint]
									_G[UF].Leader:ClearAllPoints()
									_G[UF].Leader:SetPoint(oufdb.Icons.Leader.Point, _G[UF], oufdb.Icons.Leader.Point, tonumber(oufdb.Icons.Leader.X), tonumber(oufdb.Icons.Leader.Y))
								end,
								order = 4,
							},
							LeaderSize = {
								name = "Size",
								desc = "Choose your Size for your Leader Icon.\nDefault: "..luidefaults.Icons.Leader.Size,
								type = "range",
								min = 5,
								max = 40,
								step = 1,
								disabled = function() return not oufdb.Icons.Leader.Enable end,
								get = function() return oufdb.Icons.Leader.Size end,
								set = function(_, LeaderSize) 
									oufdb.Icons.Leader.Size = LeaderSize
									_G[UF].Leader:SetHeight(LeaderSize)
									_G[UF].Leader:SetWidth(LeaderSize)
								end,
								order = 5,
							},
							toggle = {
								order = 6,
								name = "Show/Hide",
								disabled = function() return not oufdb.Icons.Leader.Enable end,
								desc = "Toggles the Leader Icon",
								type = 'execute',
								func = function() if _G[UF].Leader:IsShown() then _G[UF].Leader:Hide() else _G[UF].Leader:Show() end end
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
								get = function() return oufdb.Icons.Role.Enable end,
								set = function(self,RoleEnable)
									oufdb.Icons.Role.Enable = RoleEnable
									if not _G[UF].LFDRole then _G[UF].CreateLFDRole() end
									if RoleEnable then
										_G[UF]:EnableElement("LFDRole")
									else
										_G[UF]:DisableElement("LFDRole")
										_G[UF].LFDRole:Hide()
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 1,
							},
							RoleX = {
								name = "X Value",
								desc = "X Value for your Group Role Icon Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Icons.Role.X,
								type = "input",
								disabled = function() return not oufdb.Icons.Role.Enable end,
								get = function() return oufdb.Icons.Role.X end,
								set = function(self,RoleX)
									if RoleX == nil or RoleX == "" then RoleX = "0" end
									oufdb.Icons.Role.X = RoleX
									_G[UF].LFDRole:ClearAllPoints()
									_G[UF].LFDRole:SetPoint(oufdb.Icons.Role.Point, _G[UF], oufdb.Icons.Role.Point, tonumber(RoleX), tonumber(oufdb.Icons.Role.Y))
								end,
								order = 2,
							},
							RoleY = {
								name = "Y Value",
								desc = "Y Value for your Role Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Icons.Role.Y,
								type = "input",
								disabled = function() return not oufdb.Icons.Role.Enable end,
								get = function() return oufdb.Icons.Role.Y end,
								set = function(self,RoleY)
									if RoleY == nil or RoleY == "" then RoleY = "0" end
									oufdb.Icons.Role.Y = RoleY
									_G[UF].LFDRole:ClearAllPoints()
									_G[UF].LFDRole:SetPoint(oufdb.Icons.Role.Point, _G[UF], oufdb.Icons.Role.Point, tonumber(oufdb.Icons.Role.X), tonumber(RoleY))
								end,
								order = 3,
							},
							RolePoint = {
								name = "Position",
								desc = "Choose the Position for your Role Icon.\nDefault: "..luidefaults.Icons.Role.Point,
								type = "select",
								disabled = function() return not oufdb.Icons.Role.Enable end,
								values = positions,
								get = function()
									for k, v in pairs(positions) do
										if oufdb.Icons.Role.Point == v then
											return k
										end
									end
								end,
								set = function(self, RolePoint)
									oufdb.Icons.Role.Point = positions[RolePoint]
									_G[UF].LFDRole:ClearAllPoints()
									_G[UF].LFDRole:SetPoint(oufdb.Icons.Role.Point, _G[UF], oufdb.Icons.Role.Point, tonumber(oufdb.Icons.Role.X), tonumber(oufdb.Icons.Role.Y))
								end,
								order = 4,
							},
							RoleSize = {
								name = "Size",
								desc = "Choose a Size for your Group Role Icon.\nDefault: "..luidefaults.Icons.Role.Size,
								type = "range",
								min = 5,
								max = 100,
								step = 1,
								disabled = function() return not oufdb.Icons.Role.Enable end,
								get = function() return oufdb.Icons.Role.Size end,
								set = function(_, RoleSize) 
									oufdb.Icons.Role.Size = RoleSize
									_G[UF].LFDRole:SetHeight(RoleSize)
									_G[UF].LFDRole:SetWidth(RoleSize)
								end,
								order = 5,
							},
							toggle = {
								order = 6,
								name = "Show/Hide",
								disabled = function() return not oufdb.Icons.Role.Enable end,
								desc = "Toggles the LFDRole Icon",
								type = 'execute',
								func = function() if _G[UF].LFDRole:IsShown() then _G[UF].LFDRole:Hide() else _G[UF].LFDRole:Show() end end
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
								get = function() return oufdb.Icons.Raid.Enable end,
								set = function(self,RaidEnable)
									oufdb.Icons.Raid.Enable = RaidEnable
									if not _G[UF].RaidIcon then _G[UF].CreateRaidIcon() end
									if RaidEnable then
										_G[UF]:EnableElement("RaidIcon")
									else
										_G[UF]:DisableElement("RaidIcon")
										_G[UF].RaidIcon:Hide()
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 1,
							},
							RaidX = {
								name = "X Value",
								desc = "X Value for your Raid Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Icons.Raid.X,
								type = "input",
								disabled = function() return not oufdb.Icons.Raid.Enable end,
								get = function() return oufdb.Icons.Raid.X end,
								set = function(self,RaidX)
									if RaidX == nil or RaidX == "" then RaidX = "0" end
									oufdb.Icons.Raid.X = RaidX
									_G[UF].RaidIcon:ClearAllPoints()
									_G[UF].RaidIcon:SetPoint(oufdb.Icons.Raid.Point, _G[UF], oufdb.Icons.Raid.Point, tonumber(RaidX), tonumber(oufdb.Icons.Raid.Y))
								end,
								order = 2,
							},
							RaidY = {
								name = "Y Value",
								desc = "Y Value for your Raid Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Icons.Raid.Y,
								type = "input",
								disabled = function() return not oufdb.Icons.Raid.Enable end,
								get = function() return oufdb.Icons.Raid.Y end,
								set = function(self,RaidY)
									if RaidY == nil or RaidY == "" then RaidY = "0" end
									oufdb.Icons.Raid.Y = RaidY
									_G[UF].RaidIcon:ClearAllPoints()
									_G[UF].RaidIcon:SetPoint(oufdb.Icons.Raid.Point, _G[UF], oufdb.Icons.Raid.Point, tonumber(oufdb.Icons.Raid.X), tonumber(RaidY))
								end,
								order = 3,
							},
							RaidPoint = {
								name = "Position",
								desc = "Choose the Position for your Raid Icon.\nDefault: "..luidefaults.Icons.Raid.Point,
								type = "select",
								disabled = function() return not oufdb.Icons.Raid.Enable end,
								values = positions,
								get = function()
									for k, v in pairs(positions) do
										if oufdb.Icons.Raid.Point == v then
											return k
										end
									end
								end,
								set = function(self, RaidPoint)
									oufdb.Icons.Raid.Point = positions[RaidPoint]
									_G[UF].RaidIcon:ClearAllPoints()
									_G[UF].RaidIcon:SetPoint(oufdb.Icons.Raid.Point, _G[UF], oufdb.Icons.Raid.Point, tonumber(oufdb.Icons.Raid.X), tonumber(oufdb.Icons.Raid.Y))
								end,
								order = 4,
							},
							RaidSize = {
								name = "Size",
								desc = "Choose a Size for your Raid Icon.\nDefault: "..luidefaults.Icons.Raid.Size,
								type = "range",
								min = 5,
								max = 200,
								step = 5,
								disabled = function() return not oufdb.Icons.Raid.Enable end,
								get = function() return oufdb.Icons.Raid.Size end,
								set = function(_, RaidSize) 
									oufdb.Icons.Raid.Size = RaidSize
									_G[UF].RaidIcon:SetHeight(RaidSize)
									_G[UF].RaidIcon:SetWidth(RaidSize)
								end,
								order = 5,
							},
							toggle = {
								order = 6,
								name = "Show/Hide",
								disabled = function() return not oufdb.Icons.Raid.Enable end,
								desc = "Toggles the RaidIcon",
								type = 'execute',
								func = function() if _G[UF].RaidIcon:IsShown() then _G[UF].RaidIcon:Hide() else _G[UF].RaidIcon:Show() end end
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
								get = function() return oufdb.Icons.PvP.Enable end,
								set = function(self,PvPEnable)
									oufdb.Icons.PvP.Enable = PvPEnable
									if not _G[UF].PvP then _G[UF].CreatePvP() end
									if PvPEnable then
										_G[UF]:EnableElement("PvP")
									else
										_G[UF]:DisableElement("PvP")
										_G[UF].PvP:Hide()
									end
									_G[UF]:UpdateAllElements()
								end,
								order = 1,
							},
							PvPX = {
								name = "X Value",
								desc = "X Value for your PvP Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..luidefaults.Icons.PvP.X,
								type = "input",
								disabled = function() return not oufdb.Icons.PvP.Enable end,
								get = function() return oufdb.Icons.PvP.X end,
								set = function(self,PvPX)
									if PvPX == nil or PvPX == "" then PvPX = "0" end
									oufdb.Icons.PvP.X = PvPX
									_G[UF].PvP:ClearAllPoints()
									_G[UF].PvP:SetPoint(oufdb.Icons.PvP.Point, _G[UF], oufdb.Icons.PvP.Point, tonumber(PvPX), tonumber(oufdb.Icons.PvP.Y))
								end,
								order = 2,
							},
							PvPY = {
								name = "Y Value",
								desc = "Y Value for your PvP Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..luidefaults.Icons.PvP.Y,
								type = "input",
								disabled = function() return not oufdb.Icons.PvP.Enable end,
								get = function() return oufdb.Icons.PvP.Y end,
								set = function(self,PvPY)
									if PvPY == nil or PvPY == "" then PvPY = "0" end
									oufdb.Icons.PvP.Y = PvPY
									_G[UF].PvP:ClearAllPoints()
									_G[UF].PvP:SetPoint(oufdb.Icons.PvP.Point, _G[UF], oufdb.Icons.PvP.Point, tonumber(oufdb.Icons.PvP.X), tonumber(PvPY))
								end,
								order = 3,
							},
							PvPPoint = {
								name = "Position",
								desc = "Choose the Position for your PvP Icon.\nDefault: "..luidefaults.Icons.PvP.Point,
								type = "select",
								disabled = function() return not oufdb.Icons.PvP.Enable end,
								values = positions,
								get = function()
									for k, v in pairs(positions) do
										if oufdb.Icons.PvP.Point == v then
											return k
										end
									end
								end,
								set = function(self, PvPPoint)
									oufdb.Icons.PvP.Point = positions[PvPPoint]
									_G[UF].PvP:ClearAllPoints()
									_G[UF].PvP:SetPoint(db.oUF[unit].Icons.PvP.Point, _G[UF], db.oUF[unit].Icons.PvP.Point, tonumber(db.oUF[unit].Icons.PvP.X), tonumber(db.oUF[unit].Icons.PvP.Y))
								end,
								order = 4,
							},
							PvPSize = {
								name = "Size",
								desc = "Choose a Size for your PvP Icon.\nDefault: "..luidefaults.Icons.PvP.Size,
								type = "range",
								min = 5,
								max = 40,
								step = 1,
								disabled = function() return not db.oUF[unit].Icons.PvP.Enable end,
								get = function() return db.oUF[unit].Icons.PvP.Size end,
								set = function(_, PvPSize) 
									db.oUF[unit].Icons.PvP.Size = PvPSize
									_G[UF].PvP:SetHeight(PvPSize)
									_G[UF].PvP:SetWidth(PvPSize)
								end,
								order = 5,
							},
							toggle = {
								order = 6,
								name = "Show/Hide",
								disabled = function() return not db.oUF[unit].Icons.PvP.Enable end,
								desc = "Toggles the PvP Icon",
								type = 'execute',
								func = function() if _G[UF].PvP:IsShown() then _G[UF].PvP:Hide() else _G[UF].PvP:Show() end end
							},
						},
					},
				},
			},
		},
	}
	
	return options
end

function module:LoadOptions()
	local options = {}
	
	for index, unit in pairs(units) do
		options[unit] = module:CreateOptions(index, unit)
	end
	
	return options
end

function module:OnInitialize()	
	self.db = LUI.db.profile
	db = self.db
	
	Forte = LUI:GetModule("Forte")
	
	LUI:RegisterUnitFrame(self)
end

function module:OnEnable()
end