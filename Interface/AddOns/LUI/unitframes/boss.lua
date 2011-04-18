--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: boss.lua
	Description: oUF Boss Module
	Version....: 1.0
]] 

local LUI = LibStub("AceAddon-3.0"):GetAddon("LUI")
local module = LUI:NewModule("oUF_Boss", "AceHook-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local widgetLists = AceGUIWidgetLSMlists

local db

local positions = {"TOP", "TOPRIGHT", "TOPLEFT","BOTTOM", "BOTTOMRIGHT", "BOTTOMLEFT","RIGHT", "LEFT", "CENTER"}
local fontflags = {'OUTLINE', 'THICKOUTLINE', 'MONOCHROME', 'NONE'}
local valueFormat = {'Absolut', 'Absolut & Percent', 'Absolut Short', 'Absolut Short & Percent', 'Standard', 'Standard Short'}
local nameFormat = {'Name', 'Name + Level', 'Name + Level + Class', 'Name + Level + Race + Class', 'Level + Name', 'Level + Name + Class', 'Level + Class + Name', 'Level + Name + Race + Class', 'Level + Race + Class + Name'}
local nameLenghts = {'Short', 'Medium', 'Long'}

local eventWatch = CreateFrame("Frame")
eventWatch:RegisterEvent("PLAYER_REGEN_DISABLED")

function module:ShowBossFrames()
	for k, v in next, oUF.objects do
		if v.unit and v.unit:match'(boss)%d?$' == 'boss' then
			v.unit_ = v.unit
			v:SetAttribute("unit", "player")
		end
	end
	if not module:IsHooked(eventWatch, "OnEvent") then
		module:HookScript(eventWatch, "OnEvent", "HideBossFrames")
	end
end

function module:HideBossFrames(self, event)
	if event and event ~= "PLAYER_REGEN_DISABLED" then return end
	for k, v in next, oUF.objects do
		if v.unit_ and v.unit_:match'(boss)%d?$' == 'boss' then
			v:SetAttribute("unit", v.unit_)
		end
	end
	module:Unhook(eventWatch, "OnEvent")
	if event then LUI:Print("Boss Frames hidden due to combat") end
end

local defaults = {
	Boss = {
		Enable = true,
		UseBlizzard = false,
		Padding = "6",
		Height = "24",
		Width = "130",
		X = "-25",
		Y = "300",
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
		Boss = {
			name = "Boss",
			type = "group",
			disabled = function() return not db.oUF.Settings.Enable end,
			order = 34,
			childGroups = "tab",
			args = {
				header1 = {
					name = "Boss",
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
									desc = "Wether you want to use a Boss Frame or not.",
									type = "toggle",
									get = function() return db.oUF.Boss.Enable end,
									set = function(self,Enable)
												db.oUF.Boss.Enable = not db.oUF.Boss.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								UseBlizzard = {
									name = "Use Blizzard Boss Frames",
									desc = "Wether you want to use the Blizzard Boss Frames or no Boss Frames.",
									type = "toggle",
									disabled = function() return db.oUF.Boss.Enable end,
									get = function() return db.oUF.Boss.UseBlizzard end,
									set = function(self,UseBlizzard)
										db.oUF.Boss.UseBlizzard = UseBlizzard
										if UseBlizzard == true then
											LUI:GetModule("oUF"):EnableBlizzard("boss")
										else
											for i = 1, MAX_BOSS_FRAMES do
												local boss = _G["Boss"..i.."TargetFrame"]
												boss.Show = function() end
												boss:Hide()
												boss:UnregisterAllEvents()
											end
										end
									end,
									order = 1.5,
								},
								Padding = {
									name = "Padding",
									disabled = function() return not db.oUF.Boss.Enable end,
									desc = "Choose the Padding between your Bosses.\nDefault: "..LUI.defaults.profile.oUF.Boss.Padding,
									type = "input",
									get = function() return db.oUF.Boss.Padding end,
									set = function(self,Padding)
												if Padding == nil or Padding == "" then
													Padding = "0"
												end
												db.oUF.Boss.Padding = Padding
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 2,
								},
								empty = {
									order = 3,
									width = "full",
									type = "description",
									name = "   ",
								},
								toggle = {
									order = 4,
									name = "Show/Hide",
									disabled = function() return not db.oUF.Boss.Enable end,
									desc = "Toggles the Boss Frame",
									type = 'execute',
									func = function() 
											if oUF_LUI_boss1 and oUF_LUI_boss1:IsShown() then
												module:HideBossFrames()
											else
												module:ShowBossFrames()
											end
										end,
								},
							},
						},
						Positioning = {
							name = "Positioning",
							type = "group",
							disabled = function() return not db.oUF.Boss.Enable end,
							order = 1,
							args = {
								header1 = {
									name = "Frame Position",
									type = "header",
									order = 1,
								},
								BossX = {
									name = "X Value",
									desc = "X Value for your Boss Frame.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Boss.X,
									type = "input",
									get = function() return db.oUF.Boss.X end,
									set = function(self,BossX)
												if BossX == nil or BossX == "" then
													BossX = "0"
												end
												db.oUF.Boss.X = BossX
												
												oUF_LUI_boss1:ClearAllPoints()
												oUF_LUI_boss1:SetPoint("TOPRIGHT", UIParent, "RIGHT", tonumber(BossX), tonumber(db.oUF.Boss.Y))
											end,
									order = 2,
								},
								BossY = {
									name = "Y Value",
									desc = "Y Value for your Boss Frame.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Y,
									type = "input",
									get = function() return db.oUF.Boss.Y end,
									set = function(self,BossY)
												if BossY == nil or BossY == "" then
													BossY = "0"
												end
												db.oUF.Boss.Y = BossY
												
												oUF_LUI_boss1:ClearAllPoints()
												oUF_LUI_boss1:SetPoint("TOPRIGHT", UIParent, "RIGHT", tonumber(db.oUF.Boss.X), tonumber(BossY))
											end,
									order = 3,
								},
							},
						},
						Size = {
							name = "Size",
							type = "group",
							order = 2,
							disabled = function() return not db.oUF.Boss.Enable end,
							args = {
								header1 = {
									name = "Frame Height/Width",
									type = "header",
									order = 1,
								},
								BossHeight = {
									name = "Height",
									desc = "Decide the Height of your Boss Frame.\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Height,
									type = "input",
									get = function() return db.oUF.Boss.Height end,
									set = function(self,BossHeight)
												if BossHeight == nil or BossHeight == "" then
													BossHeight = "0"
												end
												db.oUF.Boss.Height = BossHeight

												for i = 1,MAX_BOSS_FRAMES do
													local bossfunc = loadstring("oUF_LUI_boss"..i..":SetHeight(tonumber("..BossHeight.."))")
													bossfunc()
												end
											end,
									order = 2,
								},
								BossWidth = {
									name = "Width",
									desc = "Decide the Width of your Boss Frame.\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Width,
									type = "input",
									get = function() return db.oUF.Boss.Width end,
									set = function(self,BossWidth)
												if BossWidth == nil or BossWidth == "" then
													BossWidth = "0"
												end
												db.oUF.Boss.Width = BossWidth
												
												for i = 1,MAX_BOSS_FRAMES do
													local bossfunc = loadstring("oUF_LUI_boss"..i..":SetWidth(tonumber("..BossWidth.."))")
													bossfunc()
												end
											end,
									order = 3,
								},
							},
						},
						Appearance = {
							name = "Appearance",
							type = "group",
							disabled = function() return not db.oUF.Boss.Enable end,
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
									get = function() return db.oUF.Boss.Backdrop.Color.r, db.oUF.Boss.Backdrop.Color.g, db.oUF.Boss.Backdrop.Color.b, db.oUF.Boss.Backdrop.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.Boss.Backdrop.Color.r = r
											db.oUF.Boss.Backdrop.Color.g = g
											db.oUF.Boss.Backdrop.Color.b = b
											db.oUF.Boss.Backdrop.Color.a = a
											
											for i = 1,MAX_BOSS_FRAMES do
												local bossfunc = loadstring("oUF_LUI_boss"..i..".FrameBackdrop:SetBackdropColor("..r..","..g..","..b..","..a..")")
												bossfunc()
											end
										end,
									order = 2,
								},
								BackdropBorderColor = {
									name = "Border Color",
									desc = "Choose a Backdrop Border Color.",
									type = "color",
									width = "full",
									hasAlpha = true,
									get = function() return db.oUF.Boss.Border.Color.r, db.oUF.Boss.Border.Color.g, db.oUF.Boss.Border.Color.b, db.oUF.Boss.Border.Color.a end,
									set = function(_,r,g,b,a)
											db.oUF.Boss.Border.Color.r = r
											db.oUF.Boss.Border.Color.g = g
											db.oUF.Boss.Border.Color.b = b
											db.oUF.Boss.Border.Color.a = a
											
											for i = 1,MAX_BOSS_FRAMES do
												local bossfunc = loadstring("oUF_LUI_boss"..i..".FrameBackdrop:SetBackdropBorderColor(tonumber("..db.oUF.Boss.Border.Color.r.."), tonumber("..db.oUF.Boss.Border.Color.g.."), tonumber("..db.oUF.Boss.Border.Color.b.."), tonumber("..db.oUF.Boss.Border.Color.a.."))")
												bossfunc()
											end
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
									desc = "Choose your Backdrop Texture!\nDefault: "..LUI.defaults.profile.oUF.Boss.Backdrop.Texture,
									type = "select",
									dialogControl = "LSM30_Background",
									values = widgetLists.background,
									get = function() return db.oUF.Boss.Backdrop.Texture end,
									set = function(self, BackdropTexture)
											db.oUF.Boss.Backdrop.Texture = BackdropTexture
											oUF_LUI_boss1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Boss.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Boss.Border.EdgeFile), edgeSize = tonumber(db.oUF.Boss.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Boss.Border.Insets.Left), right = tonumber(db.oUF.Boss.Border.Insets.Right), top = tonumber(db.oUF.Boss.Border.Insets.Top), bottom = tonumber(db.oUF.Boss.Border.Insets.Bottom)}
											})
											
											oUF_LUI_boss1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Boss.Backdrop.Color.r), tonumber(db.oUF.Boss.Backdrop.Color.g), tonumber(db.oUF.Boss.Backdrop.Color.b), tonumber(db.oUF.Boss.Backdrop.Color.a))
											oUF_LUI_boss1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Boss.Border.Color.r), tonumber(db.oUF.Boss.Border.Color.g), tonumber(db.oUF.Boss.Border.Color.b), tonumber(db.oUF.Boss.Border.Color.a))
										end,
									order = 5,
								},
								BorderTexture = {
									name = "Border Texture",
									desc = "Choose your Border Texture!\nDefault: "..LUI.defaults.profile.oUF.Boss.Border.EdgeFile,
									type = "select",
									dialogControl = "LSM30_Border",
									values = widgetLists.border,
									get = function() return db.oUF.Boss.Border.EdgeFile end,
									set = function(self, BorderTexture)
											db.oUF.Boss.Border.EdgeFile = BorderTexture
											oUF_LUI_boss1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Boss.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Boss.Border.EdgeFile), edgeSize = tonumber(db.oUF.Boss.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Boss.Border.Insets.Left), right = tonumber(db.oUF.Boss.Border.Insets.Right), top = tonumber(db.oUF.Boss.Border.Insets.Top), bottom = tonumber(db.oUF.Boss.Border.Insets.Bottom)}
											})
											
											oUF_LUI_boss1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Boss.Backdrop.Color.r), tonumber(db.oUF.Boss.Backdrop.Color.g), tonumber(db.oUF.Boss.Backdrop.Color.b), tonumber(db.oUF.Boss.Backdrop.Color.a))
											oUF_LUI_boss1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Boss.Border.Color.r), tonumber(db.oUF.Boss.Border.Color.g), tonumber(db.oUF.Boss.Border.Color.b), tonumber(db.oUF.Boss.Border.Color.a))
										end,
									order = 6,
								},
								BorderSize = {
									name = "Edge Size",
									desc = "Choose the Edge Size for your Frame Border.\nDefault: "..LUI.defaults.profile.oUF.Boss.Border.EdgeSize,
									type = "range",
									min = 1,
									max = 50,
									step = 1,
									get = function() return db.oUF.Boss.Border.EdgeSize end,
									set = function(_, BorderSize) 
											db.oUF.Boss.Border.EdgeSize = BorderSize
											oUF_LUI_boss1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Boss.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Boss.Border.EdgeFile), edgeSize = tonumber(db.oUF.Boss.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Boss.Border.Insets.Left), right = tonumber(db.oUF.Boss.Border.Insets.Right), top = tonumber(db.oUF.Boss.Border.Insets.Top), bottom = tonumber(db.oUF.Boss.Border.Insets.Bottom)}
											})
											
											oUF_LUI_boss1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Boss.Backdrop.Color.r), tonumber(db.oUF.Boss.Backdrop.Color.g), tonumber(db.oUF.Boss.Backdrop.Color.b), tonumber(db.oUF.Boss.Backdrop.Color.a))
											oUF_LUI_boss1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Boss.Border.Color.r), tonumber(db.oUF.Boss.Border.Color.g), tonumber(db.oUF.Boss.Border.Color.b), tonumber(db.oUF.Boss.Border.Color.a))
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
									desc = "Value for the Left Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.Boss.Backdrop.Padding.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.Boss.Backdrop.Padding.Left end,
									set = function(self,PaddingLeft)
										if PaddingLeft == nil or PaddingLeft == "" then
											PaddingLeft = "0"
										end
										db.oUF.Boss.Backdrop.Padding.Left = PaddingLeft
										oUF_LUI_boss1.FrameBackdrop:ClearAllPoints()
										oUF_LUI_boss1.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_boss1, "TOPLEFT", tonumber(db.oUF.Boss.Backdrop.Padding.Left), tonumber(db.oUF.Boss.Backdrop.Padding.Top))
										oUF_LUI_boss1.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_boss1, "BOTTOMRIGHT", tonumber(db.oUF.Boss.Backdrop.Padding.Right), tonumber(db.oUF.Boss.Backdrop.Padding.Bottom))
									end,
									order = 9,
								},
								PaddingRight = {
									name = "Right",
									desc = "Value for the Right Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.Boss.Backdrop.Padding.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.Boss.Backdrop.Padding.Right end,
									set = function(self,PaddingRight)
										if PaddingRight == nil or PaddingRight == "" then
											PaddingRight = "0"
										end
										db.oUF.Boss.Backdrop.Padding.Right = PaddingRight
										oUF_LUI_boss1.FrameBackdrop:ClearAllPoints()
										oUF_LUI_boss1.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_boss1, "TOPLEFT", tonumber(db.oUF.Boss.Backdrop.Padding.Left), tonumber(db.oUF.Boss.Backdrop.Padding.Top))
										oUF_LUI_boss1.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_boss1, "BOTTOMRIGHT", tonumber(db.oUF.Boss.Backdrop.Padding.Right), tonumber(db.oUF.Boss.Backdrop.Padding.Bottom))
									end,
									order = 10,
								},
								PaddingTop = {
									name = "Top",
									desc = "Value for the Top Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.Boss.Backdrop.Padding.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.Boss.Backdrop.Padding.Top end,
									set = function(self,PaddingTop)
										if PaddingTop == nil or PaddingTop == "" then
											PaddingTop = "0"
										end
										db.oUF.Boss.Backdrop.Padding.Top = PaddingTop
										oUF_LUI_boss1.FrameBackdrop:ClearAllPoints()
										oUF_LUI_boss1.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_boss1, "TOPLEFT", tonumber(db.oUF.Boss.Backdrop.Padding.Left), tonumber(db.oUF.Boss.Backdrop.Padding.Top))
										oUF_LUI_boss1.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_boss1, "BOTTOMRIGHT", tonumber(db.oUF.Boss.Backdrop.Padding.Right), tonumber(db.oUF.Boss.Backdrop.Padding.Bottom))
									end,
									order = 11,
								},
								PaddingBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Backdrop Padding\nDefault: "..LUI.defaults.profile.oUF.Boss.Backdrop.Padding.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.Boss.Backdrop.Padding.Bottom end,
									set = function(self,PaddingBottom)
										if PaddingBottom == nil or PaddingBottom == "" then
											PaddingBottom = "0"
										end
										db.oUF.Boss.Backdrop.Padding.Bottom = PaddingBottom
										oUF_LUI_boss1.FrameBackdrop:ClearAllPoints()
										oUF_LUI_boss1.FrameBackdrop:SetPoint("TOPLEFT", oUF_LUI_boss1, "TOPLEFT", tonumber(db.oUF.Boss.Backdrop.Padding.Left), tonumber(db.oUF.Boss.Backdrop.Padding.Top))
										oUF_LUI_boss1.FrameBackdrop:SetPoint("BOTTOMRIGHT", oUF_LUI_boss1, "BOTTOMRIGHT", tonumber(db.oUF.Boss.Backdrop.Padding.Right), tonumber(db.oUF.Boss.Backdrop.Padding.Bottom))
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
									desc = "Value for the Left Border Inset\nDefault: "..LUI.defaults.profile.oUF.Boss.Border.Insets.Left,
									type = "input",
									width = "half",
									get = function() return db.oUF.Boss.Border.Insets.Left end,
									set = function(self,InsetLeft)
											if InsetLeft == nil or InsetLeft == "" then
												InsetLeft = "0"
											end
											db.oUF.Boss.Border.Insets.Left = InsetLeft
											oUF_LUI_boss1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Boss.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Boss.Border.EdgeFile), edgeSize = tonumber(db.oUF.Boss.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Boss.Border.Insets.Left), right = tonumber(db.oUF.Boss.Border.Insets.Right), top = tonumber(db.oUF.Boss.Border.Insets.Top), bottom = tonumber(db.oUF.Boss.Border.Insets.Bottom)}
											})
											
											oUF_LUI_boss1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Boss.Backdrop.Color.r), tonumber(db.oUF.Boss.Backdrop.Color.g), tonumber(db.oUF.Boss.Backdrop.Color.b), tonumber(db.oUF.Boss.Backdrop.Color.a))
											oUF_LUI_boss1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Boss.Border.Color.r), tonumber(db.oUF.Boss.Border.Color.g), tonumber(db.oUF.Boss.Border.Color.b), tonumber(db.oUF.Boss.Border.Color.a))
										end,
									order = 14,
								},
								InsetRight = {
									name = "Right",
									desc = "Value for the Right Border Inset\nDefault: "..LUI.defaults.profile.oUF.Boss.Border.Insets.Right,
									type = "input",
									width = "half",
									get = function() return db.oUF.Boss.Border.Insets.Right end,
									set = function(self,InsetRight)
										if InsetRight == nil or InsetRight == "" then
											InsetRight = "0"
										end
										db.oUF.Boss.Border.Insets.Right = InsetRight
										oUF_LUI_boss1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Boss.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Boss.Border.EdgeFile), edgeSize = tonumber(db.oUF.Boss.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Boss.Border.Insets.Left), right = tonumber(db.oUF.Boss.Border.Insets.Right), top = tonumber(db.oUF.Boss.Border.Insets.Top), bottom = tonumber(db.oUF.Boss.Border.Insets.Bottom)}
											})
											
											oUF_LUI_boss1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Boss.Backdrop.Color.r), tonumber(db.oUF.Boss.Backdrop.Color.g), tonumber(db.oUF.Boss.Backdrop.Color.b), tonumber(db.oUF.Boss.Backdrop.Color.a))
											oUF_LUI_boss1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Boss.Border.Color.r), tonumber(db.oUF.Boss.Border.Color.g), tonumber(db.oUF.Boss.Border.Color.b), tonumber(db.oUF.Boss.Border.Color.a))
											end,
									order = 15,
								},
								InsetTop = {
									name = "Top",
									desc = "Value for the Top Border Inset\nDefault: "..LUI.defaults.profile.oUF.Boss.Border.Insets.Top,
									type = "input",
									width = "half",
									get = function() return db.oUF.Boss.Border.Insets.Top end,
									set = function(self,InsetTop)
										if InsetTop == nil or InsetTop == "" then
											InsetTop = "0"
										end
										db.oUF.Boss.Border.Insets.Top = InsetTop
										oUF_LUI_boss1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Boss.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Boss.Border.EdgeFile), edgeSize = tonumber(db.oUF.Boss.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Boss.Border.Insets.Left), right = tonumber(db.oUF.Boss.Border.Insets.Right), top = tonumber(db.oUF.Boss.Border.Insets.Top), bottom = tonumber(db.oUF.Boss.Border.Insets.Bottom)}
											})
											
											oUF_LUI_boss1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Boss.Backdrop.Color.r), tonumber(db.oUF.Boss.Backdrop.Color.g), tonumber(db.oUF.Boss.Backdrop.Color.b), tonumber(db.oUF.Boss.Backdrop.Color.a))
											oUF_LUI_boss1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Boss.Border.Color.r), tonumber(db.oUF.Boss.Border.Color.g), tonumber(db.oUF.Boss.Border.Color.b), tonumber(db.oUF.Boss.Border.Color.a))
											end,
									order = 16,
								},
								InsetBottom = {
									name = "Bottom",
									desc = "Value for the Bottom Border Inset\nDefault: "..LUI.defaults.profile.oUF.Boss.Border.Insets.Bottom,
									type = "input",
									width = "half",
									get = function() return db.oUF.Boss.Border.Insets.Bottom end,
									set = function(self,InsetBottom)
										if InsetBottom == nil or InsetBottom == "" then
											InsetBottom = "0"
										end
										db.oUF.Boss.Border.Insets.Bottom = InsetBottom
										oUF_LUI_boss1.FrameBackdrop:SetBackdrop({
												bgFile = LSM:Fetch("background", db.oUF.Boss.Backdrop.Texture),
												edgeFile = LSM:Fetch("border", db.oUF.Boss.Border.EdgeFile), edgeSize = tonumber(db.oUF.Boss.Border.EdgeSize),
												insets = {left = tonumber(db.oUF.Boss.Border.Insets.Left), right = tonumber(db.oUF.Boss.Border.Insets.Right), top = tonumber(db.oUF.Boss.Border.Insets.Top), bottom = tonumber(db.oUF.Boss.Border.Insets.Bottom)}
											})
											
											oUF_LUI_boss1.FrameBackdrop:SetBackdropColor(tonumber(db.oUF.Boss.Backdrop.Color.r), tonumber(db.oUF.Boss.Backdrop.Color.g), tonumber(db.oUF.Boss.Backdrop.Color.b), tonumber(db.oUF.Boss.Backdrop.Color.a))
											oUF_LUI_boss1.FrameBackdrop:SetBackdropBorderColor(tonumber(db.oUF.Boss.Border.Color.r), tonumber(db.oUF.Boss.Border.Color.g), tonumber(db.oUF.Boss.Border.Color.b), tonumber(db.oUF.Boss.Border.Color.a))
											end,
									order = 17,
								},
							},
						},
						AlphaFader = {
							name = "Fader",
							type = "group",
							disabled = function() return not db.oUF.Boss.Enable end,
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
					disabled = function() return not db.oUF.Boss.Enable end,
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
											desc = "Decide the Height of your Boss Health.\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Health.Height,
											type = "input",
											get = function() return db.oUF.Boss.Health.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.Boss.Health.Height = Height
														oUF_LUI_boss1.Health:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Health.Padding,
											type = "input",
											get = function() return db.oUF.Boss.Health.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.Boss.Health.Padding = Padding
														oUF_LUI_boss1.Health:ClearAllPoints()
														oUF_LUI_boss1.Health:SetPoint("TOPLEFT", oUF_LUI_boss1, "TOPLEFT", 0, tonumber(Padding))
														oUF_LUI_boss1.Health:SetPoint("TOPRIGHT", oUF_LUI_boss1, "TOPRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Boss.Health.Smooth end,
											set = function(self,Smooth)
														db.oUF.Boss.Health.Smooth = not db.oUF.Boss.Health.Smooth
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
											get = function() return db.oUF.Boss.Health.ColorClass end,
											set = function(self,HealthClassColor)
														db.oUF.Boss.Health.ColorClass = true
														db.oUF.Boss.Health.ColorGradient = false
														db.oUF.Boss.Health.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Health.colorClass = true
														oUF_LUI_boss1.Health.colorGradient = false
														oUF_LUI_boss1.Health.colorIndividual.Enable = false
															
														print("Boss Healthbar Color will change once you gain/lose HP")
													end,
											order = 1,
										},
										HealthGradientColor = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthBars or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Health.ColorGradient end,
											set = function(self,HealthGradientColor)
														db.oUF.Boss.Health.ColorGradient = true
														db.oUF.Boss.Health.ColorClass = false
														db.oUF.Boss.Health.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Health.colorGradient = true
														oUF_LUI_boss1.Health.colorClass = false
														oUF_LUI_boss1.Health.colorIndividual.Enable = false
															
														print("Boss Healthbar Color will change once you gain/lose HP")
													end,
											order = 2,
										},
										IndividualHealthColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual HealthBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Health.IndividualColor.Enable end,
											set = function(self,IndividualHealthColor)
														db.oUF.Boss.Health.IndividualColor.Enable = true
														db.oUF.Boss.Health.ColorClass = false
														db.oUF.Boss.Health.ColorGradient = false
															
														oUF_LUI_boss1.Health.colorIndividual.Enable = true
														oUF_LUI_boss1.Health.colorClass = false
														oUF_LUI_boss1.Health.colorGradient = false
															
														oUF_LUI_boss1.Health:SetStatusBarColor(db.oUF.Boss.Health.IndividualColor.r, db.oUF.Boss.Health.IndividualColor.g, db.oUF.Boss.Health.IndividualColor.b)
														oUF_LUI_boss1.Health.bg:SetVertexColor(db.oUF.Boss.Health.IndividualColor.r*tonumber(db.oUF.Boss.Health.BGMultiplier), db.oUF.Boss.Health.IndividualColor.g*tonumber(db.oUF.Boss.Health.BGMultiplier), db.oUF.Boss.Health.IndividualColor.b*tonumber(db.oUF.Boss.Health.BGMultiplier))
													end,
											order = 3,
										},
										HealthColor = {
											name = "Individual Color",
											desc = "Choose an individual Healthbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Boss.Health.IndividualColor.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Boss.Health.IndividualColor.r, db.oUF.Boss.Health.IndividualColor.g, db.oUF.Boss.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Boss.Health.IndividualColor.r = r
													db.oUF.Boss.Health.IndividualColor.g = g
													db.oUF.Boss.Health.IndividualColor.b = b
													
													oUF_LUI_boss1.Health.colorIndividual.r = r
													oUF_LUI_boss1.Health.colorIndividual.g = g
													oUF_LUI_boss1.Health.colorIndividual.b = b
															
													oUF_LUI_boss1.Health:SetStatusBarColor(r, g, b)
													oUF_LUI_boss1.Health.bg:SetVertexColor(r*tonumber(db.oUF.Boss.Health.BGMultiplier), g*tonumber(db.oUF.Boss.Health.BGMultiplier), b*tonumber(db.oUF.Boss.Health.BGMultiplier))
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
											desc = "Choose your Health Texture!\nDefault: "..LUI.defaults.profile.oUF.Boss.Health.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.Boss.Health.Texture
												end,
											set = function(self, HealthTex)
													db.oUF.Boss.Health.Texture = HealthTex
													oUF_LUI_boss1.Health:SetStatusBarTexture(LSM:Fetch("statusbar", HealthTex))
												end,
											order = 1,
										},
										HealthTexBG = {
											name = "Background Texture",
											desc = "Choose your Health Background Texture!\nDefault: "..LUI.defaults.profile.oUF.Boss.Health.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.Boss.Health.TextureBG
												end,
											set = function(self, HealthTexBG)
													db.oUF.Boss.Health.TextureBG = HealthTexBG
													oUF_LUI_boss1.Health.bg:SetTexture(LSM:Fetch("statusbar", HealthTexBG))
												end,
											order = 2,
										},
										HealthTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Health Background.\nDefault: "..LUI.defaults.profile.oUF.Boss.Health.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Boss.Health.BGAlpha end,
											set = function(_, HealthTexBGAlpha) 
													db.oUF.Boss.Health.BGAlpha  = HealthTexBGAlpha
													oUF_LUI_boss1.Health.bg:SetAlpha(tonumber(HealthTexBGAlpha))
												end,
											order = 3,
										},
										HealthTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.Boss.Health.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Boss.Health.BGMultiplier end,
											set = function(_, HealthTexBGMultiplier) 
													db.oUF.Boss.Health.BGMultiplier  = HealthTexBGMultiplier
													oUF_LUI_boss1.Health.bg.multiplier = tonumber(HealthTexBGMultiplier)
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
									get = function() return db.oUF.Boss.Power.Enable end,
									set = function(self,EnablePower)
												db.oUF.Boss.Power.Enable = not db.oUF.Boss.Power.Enable
												if EnablePower == true then
													oUF_LUI_boss1.Power:Show()
												else
													oUF_LUI_boss1.Power:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "General Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Power.Enable end,
									guiInline = true,

									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your Boss Power.\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Power.Height,
											type = "input",
											get = function() return db.oUF.Boss.Power.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.Boss.Power.Height = Height
														oUF_LUI_boss1.Power:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Powerbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Power.Padding,
											type = "input",
											get = function() return db.oUF.Boss.Power.Padding end,
											set = function(self,Padding)
														if Padding == nil or Padding == "" then
															Padding = "0"
														end
														db.oUF.Boss.Power.Padding = Padding
														oUF_LUI_boss1.Power:ClearAllPoints()
														oUF_LUI_boss1.Power:SetPoint("TOPLEFT", oUF_LUI_boss1.Health, "BOTTOMLEFT", 0, tonumber(Padding))
														oUF_LUI_boss1.Power:SetPoint("TOPRIGHT", oUF_LUI_boss1.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
													end,
											order = 2,
										},
										Smooth = {
											name = "Enable Smooth Bar Animation",
											desc = "Wether you want to use Smooth Animations or not.",
											type = "toggle",
											width = "full",
											get = function() return db.oUF.Boss.Power.Smooth end,
											set = function(self,Smooth)
														db.oUF.Boss.Power.Smooth = not db.oUF.Boss.Power.Smooth
														StaticPopup_Show("RELOAD_UI")
													end,
											order = 3,
										},
									}
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Power.Enable end,
									guiInline = true,
									order = 3,
									args = {
										PowerClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Power.ColorClass end,
											set = function(self,PowerClassColor)
														db.oUF.Boss.Power.ColorClass = true
														db.oUF.Boss.Power.ColorType = false
														db.oUF.Boss.Power.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Power.colorClass = true
														oUF_LUI_boss1.Power.colorType = false
														oUF_LUI_boss1.Power.colorIndividual.Enable = false
														
														print("Boss Powerbar Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										PowerColorByType = {
											name = "Color by Type",
											desc = "Wether you want to use Power Type colored PowerBars or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Power.ColorType end,
											set = function(self,PowerColorByType)
														db.oUF.Boss.Power.ColorType = true
														db.oUF.Boss.Power.ColorClass = false
														db.oUF.Boss.Power.IndividualColor.Enable = false
																
														oUF_LUI_boss1.Power.colorType = true
														oUF_LUI_boss1.Power.colorClass = false
														oUF_LUI_boss1.Power.colorIndividual.Enable = false
															
														print("Boss Powerbar Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualPowerColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual PowerBar Color or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Power.IndividualColor.Enable end,
											set = function(self,IndividualPowerColor)
														db.oUF.Boss.Power.IndividualColor.Enable = true
														db.oUF.Boss.Power.ColorType = false
														db.oUF.Boss.Power.ColorClass = false
																
														oUF_LUI_boss1.Power.colorIndividual.Enable = true
														oUF_LUI_boss1.Power.colorClass = false
														oUF_LUI_boss1.Power.colorType = false
															
														oUF_LUI_boss1.Power:SetStatusBarColor(db.oUF.Boss.Power.IndividualColor.r, db.oUF.Boss.Power.IndividualColor.g, db.oUF.Boss.Power.IndividualColor.b)
														oUF_LUI_boss1.Power.bg:SetVertexColor(db.oUF.Boss.Power.IndividualColor.r*tonumber(db.oUF.Boss.Power.BGMultiplier), db.oUF.Boss.Power.IndividualColor.g*tonumber(db.oUF.Boss.Power.BGMultiplier), db.oUF.Boss.Power.IndividualColor.b*tonumber(db.oUF.Boss.Power.BGMultiplier))
													end,
											order = 3,
										},
										PowerColor = {
											name = "Individual Color",
											desc = "Choose an individual Powerbar Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Boss.Power.IndividualColor.Enable or not db.oUF.Boss.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Boss.Power.IndividualColor.r, db.oUF.Boss.Power.IndividualColor.g, db.oUF.Boss.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Boss.Power.IndividualColor.r = r
													db.oUF.Boss.Power.IndividualColor.g = g
													db.oUF.Boss.Power.IndividualColor.b = b
													
													oUF_LUI_boss1.Power.colorIndividual.r = r
													oUF_LUI_boss1.Power.colorIndividual.g = g
													oUF_LUI_boss1.Power.colorIndividual.b = b
														
													oUF_LUI_boss1.Power:SetStatusBarColor(r, g, b)
													oUF_LUI_boss1.Power.bg:SetVertexColor(r*tonumber(db.oUF.Boss.Power.BGMultiplier), g*tonumber(db.oUF.Boss.Power.BGMultiplier), b*tonumber(db.oUF.Boss.Power.BGMultiplier))
												end,
											order = 4,
										},
									},
								},
								Textures = {
									name = "Texture Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Power.Enable end,
									guiInline = true,
									order = 4,
									args = {
										PowerTex = {
											name = "Texture",
											desc = "Choose your Power Texture!\nDefault: "..LUI.defaults.profile.oUF.Boss.Power.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.Boss.Power.Texture
												end,
											set = function(self, PowerTex)
													db.oUF.Boss.Power.Texture = PowerTex
													oUF_LUI_boss1.Power:SetStatusBarTexture(LSM:Fetch("statusbar", PowerTex))
												end,
											order = 1,
										},
										PowerTexBG = {
											name = "Background Texture",
											desc = "Choose your Power Background Texture!\nDefault: "..LUI.defaults.profile.oUF.Boss.Power.TextureBG,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.Boss.Power.TextureBG
												end,
											set = function(self, PowerTexBG)
													db.oUF.Boss.Power.TextureBG = PowerTexBG
													oUF_LUI_boss1.Power.bg:SetTexture(LSM:Fetch("statusbar", PowerTexBG))
												end,
											order = 2,
										},
										PowerTexBGAlpha = {
											name = "Background Alpha",
											desc = "Choose the Alpha Value for your Power Background.\nDefault: "..LUI.defaults.profile.oUF.Boss.Power.BGAlpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Boss.Power.BGAlpha end,
											set = function(_, PowerTexBGAlpha) 
													db.oUF.Boss.Power.BGAlpha  = PowerTexBGAlpha
													oUF_LUI_boss1.Power.bg:SetAlpha(tonumber(PowerTexBGAlpha))
												end,
											order = 3,
										},
										PowerTexBGMultiplier = {
											name = "Background Muliplier",
											desc = "Choose the Multiplier which will be used to generate the BackgroundColor.\nDefault: "..LUI.defaults.profile.oUF.Boss.Power.BGMultiplier,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Boss.Power.BGMultiplier end,
											set = function(_, PowerTexBGMultiplier) 
													db.oUF.Boss.Power.BGMultiplier  = PowerTexBGMultiplier
													oUF_LUI_boss1.Power.bg.multiplier = tonumber(PowerTexBGMultiplier)
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
									get = function() return db.oUF.Boss.Full.Enable end,
									set = function(self,EnableFullbar)
												db.oUF.Boss.Full.Enable = not db.oUF.Boss.Full.Enable
												if EnableFullbar == true then
													oUF_LUI_boss1.Full:Show()
												else
													oUF_LUI_boss1.Full:Hide()
												end
											end,
									order = 1,
								},
								General = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Full.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Height = {
											name = "Height",
											desc = "Decide the Height of your Fullbar.\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Full.Height,
											type = "input",
											get = function() return db.oUF.Boss.Full.Height end,
											set = function(self,Height)
														if Height == nil or Height == "" then
															Height = "0"
														end
														db.oUF.Boss.Full.Height = Height
														oUF_LUI_boss1.Full:SetHeight(tonumber(Height))
													end,
											order = 1,
										},
										Padding = {
											name = "Padding",
											desc = "Choose the Padding between Health & Fullbar.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Full.Padding,
											type = "input",
											get = function() return db.oUF.Boss.Full.Padding end,
											set = function(self,Padding)
													if Padding == nil or Padding == "" then
														Padding = "0"
													end
													db.oUF.Boss.Full.Padding = Padding
													oUF_LUI_boss1.Full:ClearAllPoints()
													oUF_LUI_boss1.Full:SetPoint("TOPLEFT", oUF_LUI_boss1.Health, "BOTTOMLEFT", 0, tonumber(Padding))
													oUF_LUI_boss1.Full:SetPoint("TOPRIGHT", oUF_LUI_boss1.Health, "BOTTOMRIGHT", 0, tonumber(Padding))
												end,
											order = 2,
										},
										FullTex = {
											name = "Texture",
											desc = "Choose your Fullbar Texture!\nDefault: "..LUI.defaults.profile.oUF.Boss.Full.Texture,
											type = "select",
											dialogControl = "LSM30_Statusbar",
											values = widgetLists.statusbar,
											get = function()
													return db.oUF.Boss.Full.Texture
												end,
											set = function(self, FullTex)
													db.oUF.Boss.Full.Texture = FullTex
													oUF_LUI_boss1.Full:SetStatusBarTexture(LSM:Fetch("statusbar", FullTex))
												end,
											order = 3,
										},
										FullAlpha = {
											name = "Alpha",
											desc = "Choose the Alpha Value for your Fullbar!\n Default: "..LUI.defaults.profile.oUF.Boss.Full.Alpha,
											type = "range",
											min = 0,
											max = 1,
											step = 0.05,
											get = function() return db.oUF.Boss.Full.Alpha end,
											set = function(_, FullAlpha)
													db.oUF.Boss.Full.Alpha = FullAlpha
													oUF_LUI_boss1.Full:SetAlpha(FullAlpha)
												end,
											order = 4,
										},
										Color = {
											name = "Color",
											desc = "Choose your Fullbar Color.",
											type = "color",
											hasAlpha = true,
											get = function() return db.oUF.Boss.Full.Color.r, db.oUF.Boss.Full.Color.g, db.oUF.Boss.Full.Color.b, db.oUF.Boss.Full.Color.a end,
											set = function(_,r,g,b,a)
													db.oUF.Boss.Full.Color.r = r
													db.oUF.Boss.Full.Color.g = g
													db.oUF.Boss.Full.Color.b = b
													db.oUF.Boss.Full.Color.a = a
													
													oUF_LUI_boss1.Full:SetStatusBarColor(r, g, b, a)
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
					order = 6,
					disabled = function() return not db.oUF.Boss.Enable end,
					args = {
						Name = {
							name = "Name",
							type = "group",
							order = 1,
							args = {
								Enable = {
									name = "Enable",
									desc = "Wether you want to show the Boss Name or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Boss.Texts.Name.Enable end,
									set = function(self,Enable)
												db.oUF.Boss.Texts.Name.Enable = not db.oUF.Boss.Texts.Name.Enable
												if Enable == true then
													oUF_LUI_boss1.Info:Show()
												else
													oUF_LUI_boss1.Info:Hide()
												end
											end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Boss Name Fontsize!\n Default: "..LUI.defaults.profile.oUF.Boss.Texts.Name.Size,
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Boss.Texts.Name.Size end,
											set = function(_, FontSize)
													db.oUF.Boss.Texts.Name.Size = FontSize
													oUF_LUI_boss1.Info:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.Name.Font),db.oUF.Boss.Texts.Name.Size,db.oUF.Boss.Texts.Name.Outline)
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
											desc = "Choose your Font for Boss Name!\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Name.Font,
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Boss.Texts.Name.Font end,
											set = function(self, Font)
													db.oUF.Boss.Texts.Name.Font = Font
													oUF_LUI_boss1.Info:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.Name.Font),db.oUF.Boss.Texts.Name.Size,db.oUF.Boss.Texts.Name.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Boss Name.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Name.Outline,
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Boss.Texts.Name.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Boss.Texts.Name.Outline = fontflags[FontFlag]
													oUF_LUI_boss1.Info:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.Name.Font),db.oUF.Boss.Texts.Name.Size,db.oUF.Boss.Texts.Name.Outline)
												end,
											order = 4,
										},
										NameX = {
											name = "X Value",
											desc = "X Value for your Boss Name.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Name.X,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											get = function() return db.oUF.Boss.Texts.Name.X end,
											set = function(self,NameX)
														if NameX == nil or NameX == "" then
															NameX = "0"
														end
														db.oUF.Boss.Texts.Name.X = NameX
														oUF_LUI_boss1.Info:ClearAllPoints()
														oUF_LUI_boss1.Info:SetPoint(db.oUF.Boss.Texts.Name.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Name.RelativePoint, tonumber(db.oUF.Boss.Texts.Name.X), tonumber(db.oUF.Boss.Texts.Name.Y))
													end,
											order = 5,
										},
										NameY = {
											name = "Y Value",
											desc = "Y Value for your Boss Name.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Name.Y,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											get = function() return db.oUF.Boss.Texts.Name.Y end,
											set = function(self,NameY)
														if NameY == nil or NameY == "" then
															NameY = "0"
														end
														db.oUF.Boss.Texts.Name.Y = NameY
														oUF_LUI_boss1.Info:ClearAllPoints()
														oUF_LUI_boss1.Info:SetPoint(db.oUF.Boss.Texts.Name.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Name.RelativePoint, tonumber(db.oUF.Boss.Texts.Name.X), tonumber(db.oUF.Boss.Texts.Name.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Boss Name.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Name.Point,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.Name.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Boss.Texts.Name.Point = positions[Point]
													oUF_LUI_boss1.Info:ClearAllPoints()
													oUF_LUI_boss1.Info:SetPoint(db.oUF.Boss.Texts.Name.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Name.RelativePoint, tonumber(db.oUF.Boss.Texts.Name.X), tonumber(db.oUF.Boss.Texts.Name.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Boss Name.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Name.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.Name.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Boss.Texts.Name.RelativePoint = positions[RelativePoint]
													oUF_LUI_boss1.Info:ClearAllPoints()
													oUF_LUI_boss1.Info:SetPoint(db.oUF.Boss.Texts.Name.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Name.RelativePoint, tonumber(db.oUF.Boss.Texts.Name.X), tonumber(db.oUF.Boss.Texts.Name.Y))
												end,
											order = 8,
										},
									},
								},
								Settings = {
									name = "Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
									guiInline = true,
									order = 2,
									args = {
										Format = {
											name = "Format",
											desc = "Choose the Format for your Boss Name.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Name.Format,
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											type = "select",
											width = "full",
											values = nameFormat,
											get = function()
													for k, v in pairs(nameFormat) do
														if db.oUF.Boss.Texts.Name.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.Boss.Texts.Name.Format = nameFormat[Format]
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 1,
										},
										Length = {
											name = "Length",
											desc = "Choose the Length of your Boss Name.\n\nShort = 6 Letters\nMedium = 18 Letters\nLong = 36 Letters\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Name.Length,
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											type = "select",
											values = nameLenghts,
											get = function()
													for k, v in pairs(nameLenghts) do
														if db.oUF.Boss.Texts.Name.Length == v then
															return k
														end
													end
												end,
											set = function(self, Length)
													db.oUF.Boss.Texts.Name.Length = nameLenghts[Length]
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
											desc = "Wether you want to color the Boss Name by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											get = function() return db.oUF.Boss.Texts.Name.ColorNameByClass end,
											set = function(self,ColorNameByClass)
													db.oUF.Boss.Texts.Name.ColorNameByClass = not db.oUF.Boss.Texts.Name.ColorNameByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 4,
										},
										ColorClassByClass = {
											name = "Color Class by Class",
											desc = "Wether you want to color the Boss Class by Class or not.",
											type = "toggle",
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											get = function() return db.oUF.Boss.Texts.Name.ColorClassByClass end,
											set = function(self,ColorClassByClass)
													db.oUF.Boss.Texts.Name.ColorClassByClass = not db.oUF.Boss.Texts.Name.ColorClassByClass
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 5,
										},
										ColorLevelByDifficulty = {
											name = "Color Level by Difficulty",
											desc = "Wether you want to color the Level by Difficulty or not.",
											type = "toggle",
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											get = function() return db.oUF.Boss.Texts.Name.ColorLevelByDifficulty end,
											set = function(self,ColorLevelByDifficulty)
													db.oUF.Boss.Texts.Name.ColorLevelByDifficulty = not db.oUF.Boss.Texts.Name.ColorLevelByDifficulty
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 6,
										},
										ShowClassification = {
											name = "Show Classification",
											desc = "Wether you want to show Classifications like Elite, Boss, Rar or not.",
											type = "toggle",
											disabled = function() return not db.oUF.Boss.Texts.Name.Enable end,
											get = function() return db.oUF.Boss.Texts.Name.ShowClassification end,
											set = function(self,ShowClassification)
													db.oUF.Boss.Texts.Name.ShowClassification = not db.oUF.Boss.Texts.Name.ShowClassification
													StaticPopup_Show("RELOAD_UI")
												end,
											order = 7,
										},
										ShortClassification = {
											name = "Enable Short Classification",
											desc = "Wether you want to show short Classifications or not.",
											type = "toggle",
											width = "full",
											disabled = function() return not db.oUF.Boss.Texts.Name.ShowClassification or not db.oUF.Boss.Texts.Name.Enable end,
											get = function() return db.oUF.Boss.Texts.Name.ShortClassification end,
											set = function(self,ShortClassification)
													db.oUF.Boss.Texts.Name.ShortClassification = not db.oUF.Boss.Texts.Name.ShortClassification
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
									desc = "Wether you want to show the Boss Health or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Boss.Texts.Health.Enable end,
									set = function(self,Enable)
											db.oUF.Boss.Texts.Health.Enable = not db.oUF.Boss.Texts.Health.Enable
											if Enable == true then
												oUF_LUI_boss1.Health.value:Show()
											else
												oUF_LUI_boss1.Health.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.Health.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Boss Health Fontsize!\n Default: "..LUI.defaults.profile.oUF.Boss.Texts.Health.Size,
											disabled = function() return not db.oUF.Boss.Texts.Health.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Boss.Texts.Health.Size end,
											set = function(_, FontSize)
													db.oUF.Boss.Texts.Health.Size = FontSize
													oUF_LUI_boss1.Health.value:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.Health.Font),db.oUF.Boss.Texts.Health.Size,db.oUF.Boss.Texts.Health.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your Boss Health.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Health.Format,
											disabled = function() return not db.oUF.Boss.Texts.Health.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.Boss.Texts.Health.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.Boss.Texts.Health.Format = valueFormat[Format]
													oUF_LUI_boss1.Health.value.Format = valueFormat[Format]
													print("Boss Health Value Format will change once you gain/lose Health")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Boss Health!\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Health.Font,
											disabled = function() return not db.oUF.Boss.Texts.Health.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Boss.Texts.Health.Font end,
											set = function(self, Font)
													db.oUF.Boss.Texts.Health.Font = Font
													oUF_LUI_boss1.Health.value:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.Health.Font),db.oUF.Boss.Texts.Health.Size,db.oUF.Boss.Texts.Health.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Boss Health.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Health.Outline,
											disabled = function() return not db.oUF.Boss.Texts.Health.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Boss.Texts.Health.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Boss.Texts.Health.Outline = fontflags[FontFlag]
													oUF_LUI_boss1.Health.value:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.Health.Font),db.oUF.Boss.Texts.Health.Size,db.oUF.Boss.Texts.Health.Outline)
												end,
											order = 4,
										},
										HealthX = {
											name = "X Value",
											desc = "X Value for your Boss Health.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Health.X,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.Health.Enable end,
											get = function() return db.oUF.Boss.Texts.Health.X end,
											set = function(self,HealthX)
														if HealthX == nil or HealthX == "" then
															HealthX = "0"
														end
														db.oUF.Boss.Texts.Health.X = HealthX
														oUF_LUI_boss1.Health.value:ClearAllPoints()
														oUF_LUI_boss1.Health.value:SetPoint(db.oUF.Boss.Texts.Health.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Health.RelativePoint, tonumber(db.oUF.Boss.Texts.Health.X), tonumber(db.oUF.Boss.Texts.Health.Y))
													end,
											order = 5,
										},
										HealthY = {
											name = "Y Value",
											desc = "Y Value for your Boss Health.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Health.Y,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.Health.Enable end,
											get = function() return db.oUF.Boss.Texts.Health.Y end,
											set = function(self,HealthY)
														if HealthY == nil or HealthY == "" then
															HealthY = "0"
														end
														db.oUF.Boss.Texts.Health.Y = HealthY
														oUF_LUI_boss1.Health.value:ClearAllPoints()
														oUF_LUI_boss1.Health.value:SetPoint(db.oUF.Boss.Texts.Health.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Health.RelativePoint, tonumber(db.oUF.Boss.Texts.Health.X), tonumber(db.oUF.Boss.Texts.Health.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Boss Health.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Health.Point,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.Health.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Boss.Texts.Health.Point = positions[Point]
													oUF_LUI_boss1.Health.value:ClearAllPoints()
													oUF_LUI_boss1.Health.value:SetPoint(db.oUF.Boss.Texts.Health.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Health.RelativePoint, tonumber(db.oUF.Boss.Texts.Health.X), tonumber(db.oUF.Boss.Texts.Health.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Boss Health.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Health.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.Health.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.Health.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Boss.Texts.Health.RelativePoint = positions[RelativePoint]
													oUF_LUI_boss1.Health.value:ClearAllPoints()
													oUF_LUI_boss1.Health.value:SetPoint(db.oUF.Boss.Texts.Health.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Health.RelativePoint, tonumber(db.oUF.Boss.Texts.Health.X), tonumber(db.oUF.Boss.Texts.Health.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.Health.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.Health.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Boss.Texts.Health.ColorClass = true
														db.oUF.Boss.Texts.Health.ColorGradient = false
														db.oUF.Boss.Texts.Health.IndividualColor.Enable = false
														
														oUF_LUI_boss1.Health.value.colorClass = true
														oUF_LUI_boss1.Health.value.colorGradient = false
														oUF_LUI_boss1.Health.value.colorIndividual.Enable = false
														
														print("Boss Health Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored Health Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.Health.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.Boss.Texts.Health.ColorGradient = true
														db.oUF.Boss.Texts.Health.ColorClass = false
														db.oUF.Boss.Texts.Health.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Health.value.colorGradient = true
														oUF_LUI_boss1.Health.value.colorClass = false
														oUF_LUI_boss1.Health.value.colorIndividual.Enable = false
															
														print("Boss Health Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Boss Health Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.Health.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Boss.Texts.Health.IndividualColor.Enable = true
														db.oUF.Boss.Texts.Health.ColorClass = false
														db.oUF.Boss.Texts.Health.ColorGradient = false
															
														oUF_LUI_boss1.Health.value.colorIndividual.Enable = true
														oUF_LUI_boss1.Health.value.colorClass = false
														oUF_LUI_boss1.Health.value.colorGradient = false
														
														oUF_LUI_boss1.Health.value:SetTextColor(tonumber(db.oUF.Boss.Texts.Health.IndividualColor.r),tonumber(db.oUF.Boss.Texts.Health.IndividualColor.g),tonumber(db.oUF.Boss.Texts.Health.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Boss Health Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Boss.Texts.Health.IndividualColor.Enable or not db.oUF.Boss.Texts.Health.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Boss.Texts.Health.IndividualColor.r, db.oUF.Boss.Texts.Health.IndividualColor.g, db.oUF.Boss.Texts.Health.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Boss.Texts.Health.IndividualColor.r = r
													db.oUF.Boss.Texts.Health.IndividualColor.g = g
													db.oUF.Boss.Texts.Health.IndividualColor.b = b
													
													oUF_LUI_boss1.Health.value.colorIndividual.r = r
													oUF_LUI_boss1.Health.value.colorIndividual.g = g
													oUF_LUI_boss1.Health.value.colorIndividual.b = b
													
													oUF_LUI_boss1.Health.value:SetTextColor(r,g,b)
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
											get = function() return db.oUF.Boss.Texts.Health.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.Boss.Texts.Health.ShowDead = not db.oUF.Boss.Texts.Health.ShowDead
														oUF_LUI_boss1.Health.value.ShowDead = db.oUF.Boss.Texts.Health.ShowDead
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
									desc = "Wether you want to show the Boss Power or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Boss.Texts.Power.Enable end,
									set = function(self,Enable)
											db.oUF.Boss.Texts.Power.Enable = not db.oUF.Boss.Texts.Power.Enable
											if Enable == true then
												oUF_LUI_boss1.Power.value:Show()
											else
												oUF_LUI_boss1.Power.value:Hide()
											end
										end,
									order = 0,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.Power.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Boss Power Fontsize!\n Default: "..LUI.defaults.profile.oUF.Boss.Texts.Power.Size,
											disabled = function() return not db.oUF.Boss.Texts.Power.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Boss.Texts.Power.Size end,
											set = function(_, FontSize)
													db.oUF.Boss.Texts.Power.Size = FontSize
													oUF_LUI_boss1.Power.value:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.Power.Font),db.oUF.Boss.Texts.Power.Size,db.oUF.Boss.Texts.Power.Outline)
												end,
											order = 1,
										},
										Format = {
											name = "Format",
											desc = "Choose the Format for your Boss Power.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Power.Format,
											disabled = function() return not db.oUF.Boss.Texts.Power.Enable end,
											type = "select",
											values = valueFormat,
											get = function()
													for k, v in pairs(valueFormat) do
														if db.oUF.Boss.Texts.Power.Format == v then
															return k
														end
													end
												end,
											set = function(self, Format)
													db.oUF.Boss.Texts.Power.Format = valueFormat[Format]
													oUF_LUI_boss1.Power.value.Format = valueFormat[Format]
													print("Boss Power Value Format will change once you gain/lose Power")
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Boss Power!\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Power.Font,
											disabled = function() return not db.oUF.Boss.Texts.Power.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Boss.Texts.Power.Font end,
											set = function(self, Font)
													db.oUF.Boss.Texts.Power.Font = Font
													oUF_LUI_boss1.Power.value:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.Power.Font),db.oUF.Boss.Texts.Power.Size,db.oUF.Boss.Texts.Power.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Boss Power.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Power.Outline,
											disabled = function() return not db.oUF.Boss.Texts.Power.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Boss.Texts.Power.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Boss.Texts.Power.Outline = fontflags[FontFlag]
													oUF_LUI_boss1.Power.value:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.Power.Font),db.oUF.Boss.Texts.Power.Size,db.oUF.Boss.Texts.Power.Outline)
												end,
											order = 4,
										},
										PowerX = {
											name = "X Value",
											desc = "X Value for your Boss Power.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Power.X,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.Power.Enable end,
											get = function() return db.oUF.Boss.Texts.Power.X end,
											set = function(self,PowerX)
														if PowerX == nil or PowerX == "" then
															PowerX = "0"
														end
														db.oUF.Boss.Texts.Power.X = PowerX
														oUF_LUI_boss1.Power.value:ClearAllPoints()
														oUF_LUI_boss1.Power.value:SetPoint(db.oUF.Boss.Texts.Power.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Power.RelativePoint, tonumber(db.oUF.Boss.Texts.Power.X), tonumber(db.oUF.Boss.Texts.Power.Y))
													end,
											order = 5,
										},
										PowerY = {
											name = "Y Value",
											desc = "Y Value for your Boss Power.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Power.Y,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.Power.Enable end,
											get = function() return db.oUF.Boss.Texts.Power.Y end,
											set = function(self,PowerY)
														if PowerY == nil or PowerY == "" then
															PowerY = "0"
														end
														db.oUF.Boss.Texts.Power.Y = PowerY
														oUF_LUI_boss1.Power.value:ClearAllPoints()
														oUF_LUI_boss1.Power.value:SetPoint(db.oUF.Boss.Texts.Power.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Power.RelativePoint, tonumber(db.oUF.Boss.Texts.Power.X), tonumber(db.oUF.Boss.Texts.Power.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Boss Power.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Power.Point,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.Power.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Boss.Texts.Power.Point = positions[Point]
													oUF_LUI_boss1.Power.value:ClearAllPoints()
													oUF_LUI_boss1.Power.value:SetPoint(db.oUF.Boss.Texts.Power.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Power.RelativePoint, tonumber(db.oUF.Boss.Texts.Power.X), tonumber(db.oUF.Boss.Texts.Power.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Boss Power.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.Power.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.Power.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.Power.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Boss.Texts.Power.RelativePoint = positions[RelativePoint]
													oUF_LUI_boss1.Power.value:ClearAllPoints()
													oUF_LUI_boss1.Power.value:SetPoint(db.oUF.Boss.Texts.Power.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.Power.RelativePoint, tonumber(db.oUF.Boss.Texts.Power.X), tonumber(db.oUF.Boss.Texts.Power.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.Power.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.Power.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Boss.Texts.Power.ColorClass = true
														db.oUF.Boss.Texts.Power.ColorType = false
														db.oUF.Boss.Texts.Power.IndividualColor.Enable = false
														
														oUF_LUI_boss1.Power.value.colorClass = true
														oUF_LUI_boss1.Power.value.colorType = false
														oUF_LUI_boss1.Power.value.colorIndividual.Enable = false
			
														print("Boss Power Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Powertype colored Power Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.Power.ColorType end,
											set = function(self,ColorType)
														db.oUF.Boss.Texts.Power.ColorType = true
														db.oUF.Boss.Texts.Power.ColorClass = false
														db.oUF.Boss.Texts.Power.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Power.value.colorType = true
														oUF_LUI_boss1.Power.value.colorClass = false
														oUF_LUI_boss1.Power.value.colorIndividual.Enable = false
		
														print("Boss Power Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Boss Power Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.Power.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Boss.Texts.Power.IndividualColor.Enable = true
														db.oUF.Boss.Texts.Power.ColorClass = false
														db.oUF.Boss.Texts.Power.ColorType = false
															
														oUF_LUI_boss1.Power.value.colorIndividual.Enable = true
														oUF_LUI_boss1.Power.value.colorClass = false
														oUF_LUI_boss1.Power.value.colorType = false
		
														oUF_LUI_boss1.Power.value:SetTextColor(tonumber(db.oUF.Boss.Texts.Power.IndividualColor.r),tonumber(db.oUF.Boss.Texts.Power.IndividualColor.g),tonumber(db.oUF.Boss.Texts.Power.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Boss Power Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Boss.Texts.Power.IndividualColor.Enable or not db.oUF.Boss.Texts.Power.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Boss.Texts.Power.IndividualColor.r, db.oUF.Boss.Texts.Power.IndividualColor.g, db.oUF.Boss.Texts.Power.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Boss.Texts.Power.IndividualColor.r = r
													db.oUF.Boss.Texts.Power.IndividualColor.g = g
													db.oUF.Boss.Texts.Power.IndividualColor.b = b
													
													oUF_LUI_boss1.Power.value.colorIndividual.r = r
													oUF_LUI_boss1.Power.value.colorIndividual.g = g
													oUF_LUI_boss1.Power.value.colorIndividual.b = b
	
													oUF_LUI_boss1.Power.value:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the Boss HealthPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Boss.Texts.HealthPercent.Enable end,
									set = function(self,Enable)
											db.oUF.Boss.Texts.HealthPercent.Enable = not db.oUF.Boss.Texts.HealthPercent.Enable
											if Enable == true then
												oUF_LUI_boss1.Health.valuePercent:Show()
											else
												oUF_LUI_boss1.Health.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Boss HealthPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.Boss.Texts.HealthPercent.Size,
											disabled = function() return not db.oUF.Boss.Texts.HealthPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Boss.Texts.HealthPercent.Size end,
											set = function(_, FontSize)
													db.oUF.Boss.Texts.HealthPercent.Size = FontSize
													oUF_LUI_boss1.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.HealthPercent.Font),db.oUF.Boss.Texts.HealthPercent.Size,db.oUF.Boss.Texts.HealthPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show Boss HealthPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.Boss.Texts.HealthPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.HealthPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.Boss.Texts.HealthPercent.ShowAlways = not db.oUF.Boss.Texts.HealthPercent.ShowAlways
													oUF_LUI_boss1.Health.valuePercent.ShowAlways = db.oUF.Boss.Texts.HealthPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Boss HealthPercent!\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthPercent.Font,
											disabled = function() return not db.oUF.Boss.Texts.HealthPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Boss.Texts.HealthPercent.Font end,
											set = function(self, Font)
													db.oUF.Boss.Texts.HealthPercent.Font = Font
													oUF_LUI_boss1.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.HealthPercent.Font),db.oUF.Boss.Texts.HealthPercent.Size,db.oUF.Boss.Texts.HealthPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Boss HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthPercent.Outline,
											disabled = function() return not db.oUF.Boss.Texts.HealthPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Boss.Texts.HealthPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Boss.Texts.HealthPercent.Outline = fontflags[FontFlag]
													oUF_LUI_boss1.Health.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.HealthPercent.Font),db.oUF.Boss.Texts.HealthPercent.Size,db.oUF.Boss.Texts.HealthPercent.Outline)
												end,
											order = 4,
										},
										HealthPercentX = {
											name = "X Value",
											desc = "X Value for your Boss HealthPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthPercent.X,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.Boss.Texts.HealthPercent.X end,
											set = function(self,HealthPercentX)
														if HealthPercentX == nil or HealthPercentX == "" then
															HealthPercentX = "0"
														end
														db.oUF.Boss.Texts.HealthPercent.X = HealthPercentX
														oUF_LUI_boss1.Health.valuePercent:ClearAllPoints()
														oUF_LUI_boss1.Health.valuePercent:SetPoint(db.oUF.Boss.Texts.HealthPercent.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.Boss.Texts.HealthPercent.X), tonumber(db.oUF.Boss.Texts.HealthPercent.Y))
													end,
											order = 5,
										},
										HealthPercentY = {
											name = "Y Value",
											desc = "Y Value for your Boss HealthPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.HealthPercent.Enable end,
											get = function() return db.oUF.Boss.Texts.HealthPercent.Y end,
											set = function(self,HealthPercentY)
														if HealthPercentY == nil or HealthPercentY == "" then
															HealthPercentY = "0"
														end
														db.oUF.Boss.Texts.HealthPercent.Y = HealthPercentY
														oUF_LUI_boss1.Health.valuePercent:ClearAllPoints()
														oUF_LUI_boss1.Health.valuePercent:SetPoint(db.oUF.Boss.Texts.HealthPercent.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.Boss.Texts.HealthPercent.X), tonumber(db.oUF.Boss.Texts.HealthPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Boss HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.HealthPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Boss.Texts.HealthPercent.Point = positions[Point]
													oUF_LUI_boss1.Health.valuePercent:ClearAllPoints()
													oUF_LUI_boss1.Health.valuePercent:SetPoint(db.oUF.Boss.Texts.HealthPercent.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.Boss.Texts.HealthPercent.X), tonumber(db.oUF.Boss.Texts.HealthPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Boss HealthPercent.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.HealthPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.HealthPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Boss.Texts.HealthPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_boss1.Health.valuePercent:ClearAllPoints()
													oUF_LUI_boss1.Health.valuePercent:SetPoint(db.oUF.Boss.Texts.HealthPercent.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.HealthPercent.RelativePoint, tonumber(db.oUF.Boss.Texts.HealthPercent.X), tonumber(db.oUF.Boss.Texts.HealthPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.HealthPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.HealthPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Boss.Texts.HealthPercent.ColorClass = true
														db.oUF.Boss.Texts.HealthPercent.ColorGradient = false
														db.oUF.Boss.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Health.valuePercent.colorClass = true
														oUF_LUI_boss1.Health.valuePercent.colorGradient = false
														oUF_LUI_boss1.Health.valuePercent.colorIndividual.Enable = false
					
														print("Boss HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.HealthPercent.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.Boss.Texts.HealthPercent.ColorGradient = true
														db.oUF.Boss.Texts.HealthPercent.ColorClass = false
														db.oUF.Boss.Texts.HealthPercent.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Health.valuePercent.colorGradient = true
														oUF_LUI_boss1.Health.valuePercent.colorClass = false
														oUF_LUI_boss1.Health.valuePercent.colorIndividual.Enable = false
				
														print("Boss HealthPercent Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Boss HealthPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.HealthPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Boss.Texts.HealthPercent.IndividualColor.Enable = true
														db.oUF.Boss.Texts.HealthPercent.ColorClass = false
														db.oUF.Boss.Texts.HealthPercent.ColorGradient = false
															
														oUF_LUI_boss1.Health.valuePercent.colorIndividual.Enable = true
														oUF_LUI_boss1.Health.valuePercent.colorClass = false
														oUF_LUI_boss1.Health.valuePercent.colorGradient = false
							
														oUF_LUI_boss1.Health.valuePercent:SetTextColor(tonumber(db.oUF.Boss.Texts.HealthPercent.IndividualColor.r),tonumber(db.oUF.Boss.Texts.HealthPercent.IndividualColor.g),tonumber(db.oUF.Boss.Texts.HealthPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Boss HealthPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Boss.Texts.HealthPercent.IndividualColor.Enable or not db.oUF.Boss.Texts.HealthPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Boss.Texts.HealthPercent.IndividualColor.r, db.oUF.Boss.Texts.HealthPercent.IndividualColor.g, db.oUF.Boss.Texts.HealthPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Boss.Texts.HealthPercent.IndividualColor.r = r
													db.oUF.Boss.Texts.HealthPercent.IndividualColor.g = g
													db.oUF.Boss.Texts.HealthPercent.IndividualColor.b = b
													
													oUF_LUI_boss1.Health.valuePercent.colorIndividual.r = r
													oUF_LUI_boss1.Health.valuePercent.colorIndividual.g = g
													oUF_LUI_boss1.Health.valuePercent.colorIndividual.b = b
			
													oUF_LUI_boss1.Health.valuePercent:SetTextColor(r,g,b)
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
											get = function() return db.oUF.Boss.Texts.HealthPercent.ShowDead end,
											set = function(self,ShowDead)
														db.oUF.Boss.Texts.HealthPercent.ShowDead = not db.oUF.Boss.Texts.HealthPercent.ShowDead
														oUF_LUI_boss1.Health.valuePercent.ShowDead = db.oUF.Boss.Texts.HealthPercent.ShowDead
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
									desc = "Wether you want to show the Boss PowerPercent or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Boss.Texts.PowerPercent.Enable end,
									set = function(self,Enable)
											db.oUF.Boss.Texts.PowerPercent.Enable = not db.oUF.Boss.Texts.PowerPercent.Enable
											if Enable == true then
												oUF_LUI_boss1.Power.valuePercent:Show()
											else
												oUF_LUI_boss1.Power.valuePercent:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Boss PowerPercent Fontsize!\n Default: "..LUI.defaults.profile.oUF.Boss.Texts.PowerPercent.Size,
											disabled = function() return not db.oUF.Boss.Texts.PowerPercent.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Boss.Texts.PowerPercent.Size end,
											set = function(_, FontSize)
													db.oUF.Boss.Texts.PowerPercent.Size = FontSize
													oUF_LUI_boss1.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.PowerPercent.Font),db.oUF.Boss.Texts.PowerPercent.Size,db.oUF.Boss.Texts.PowerPercent.Outline)
												end,
											order = 1,
										},
										ShowAlways = {
											name = "Show Always",
											desc = "Always show Boss PowerPercent or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.Boss.Texts.PowerPercent.Enable end,
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.PowerPercent.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.Boss.Texts.PowerPercent.ShowAlways = not db.oUF.Boss.Texts.PowerPercent.ShowAlways
													oUF_LUI_boss1.Power.valuePercent.ShowAlways = db.oUF.Boss.Texts.PowerPercent.ShowAlways
												end,
											order = 2,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Boss PowerPercent!\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerPercent.Font,
											disabled = function() return not db.oUF.Boss.Texts.PowerPercent.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Boss.Texts.PowerPercent.Font end,
											set = function(self, Font)
													db.oUF.Boss.Texts.PowerPercent.Font = Font
													oUF_LUI_boss1.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.PowerPercent.Font),db.oUF.Boss.Texts.PowerPercent.Size,db.oUF.Boss.Texts.PowerPercent.Outline)
												end,
											order = 3,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Boss PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerPercent.Outline,
											disabled = function() return not db.oUF.Boss.Texts.PowerPercent.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Boss.Texts.PowerPercent.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Boss.Texts.PowerPercent.Outline = fontflags[FontFlag]
													oUF_LUI_boss1.Power.valuePercent:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.PowerPercent.Font),db.oUF.Boss.Texts.PowerPercent.Size,db.oUF.Boss.Texts.PowerPercent.Outline)
												end,
											order = 4,
										},
										PowerPercentX = {
											name = "X Value",
											desc = "X Value for your Boss PowerPercent.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerPercent.X,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.Boss.Texts.PowerPercent.X end,
											set = function(self,PowerPercentX)
														if PowerPercentX == nil or PowerPercentX == "" then
															PowerPercentX = "0"
														end
														db.oUF.Boss.Texts.PowerPercent.X = PowerPercentX
														oUF_LUI_boss1.Power.valuePercent:ClearAllPoints()
														oUF_LUI_boss1.Power.valuePercent:SetPoint(db.oUF.Boss.Texts.PowerPercent.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.Boss.Texts.PowerPercent.X), tonumber(db.oUF.Boss.Texts.PowerPercent.Y))
													end,
											order = 5,

										},
										PowerPercentY = {
											name = "Y Value",
											desc = "Y Value for your Boss PowerPercent.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerPercent.Y,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.PowerPercent.Enable end,
											get = function() return db.oUF.Boss.Texts.PowerPercent.Y end,
											set = function(self,PowerPercentY)
														if PowerPercentY == nil or PowerPercentY == "" then
															PowerPercentY = "0"
														end
														db.oUF.Boss.Texts.PowerPercent.Y = PowerPercentY
														oUF_LUI_boss1.Power.valuePercent:ClearAllPoints()
														oUF_LUI_boss1.Power.valuePercent:SetPoint(db.oUF.Boss.Texts.PowerPercent.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.Boss.Texts.PowerPercent.X), tonumber(db.oUF.Boss.Texts.PowerPercent.Y))
													end,
											order = 6,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Boss PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerPercent.Point,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.PowerPercent.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Boss.Texts.PowerPercent.Point = positions[Point]
													oUF_LUI_boss1.Power.valuePercent:ClearAllPoints()
													oUF_LUI_boss1.Power.valuePercent:SetPoint(db.oUF.Boss.Texts.PowerPercent.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.Boss.Texts.PowerPercent.X), tonumber(db.oUF.Boss.Texts.PowerPercent.Y))
												end,
											order = 7,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Boss PowerPercent.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerPercent.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.PowerPercent.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.PowerPercent.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Boss.Texts.PowerPercent.RelativePoint = positions[RelativePoint]
													oUF_LUI_boss1.Power.valuePercent:ClearAllPoints()
													oUF_LUI_boss1.Power.valuePercent:SetPoint(db.oUF.Boss.Texts.PowerPercent.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.PowerPercent.RelativePoint, tonumber(db.oUF.Boss.Texts.PowerPercent.X), tonumber(db.oUF.Boss.Texts.PowerPercent.Y))
												end,
											order = 8,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.PowerPercent.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.PowerPercent.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Boss.Texts.PowerPercent.ColorClass = true
														db.oUF.Boss.Texts.PowerPercent.ColorType = false
														db.oUF.Boss.Texts.PowerPercent.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Power.valuePercent.colorClass = true
														oUF_LUI_boss1.Power.valuePercent.colorType = false
														oUF_LUI_boss1.Power.valuePercent.individualColor.Enable = false

														print("Boss PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerPercent Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.PowerPercent.ColorType end,
											set = function(self,ColorType)
														db.oUF.Boss.Texts.PowerPercent.ColorType = true
														db.oUF.Boss.Texts.PowerPercent.ColorClass = false
														db.oUF.Boss.Texts.PowerPercent.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Power.valuePercent.colorType = true
														oUF_LUI_boss1.Power.valuePercent.colorClass = false
														oUF_LUI_boss1.Power.valuePercent.individualColor.Enable = false
		
														print("Boss PowerPercent Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Boss PowerPercent Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.PowerPercent.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Boss.Texts.PowerPercent.IndividualColor.Enable = true
														db.oUF.Boss.Texts.PowerPercent.ColorClass = false
														db.oUF.Boss.Texts.PowerPercent.ColorType = false
															
														oUF_LUI_boss1.Power.valuePercent.individualColor.Enable = true
														oUF_LUI_boss1.Power.valuePercent.colorClass = false
														oUF_LUI_boss1.Power.valuePercent.colorType = false

														oUF_LUI_boss1.Power.valuePercent:SetTextColor(tonumber(db.oUF.Boss.Texts.PowerPercent.IndividualColor.r),tonumber(db.oUF.Boss.Texts.PowerPercent.IndividualColor.g),tonumber(db.oUF.Boss.Texts.PowerPercent.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Boss PowerPercent Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Boss.Texts.PowerPercent.IndividualColor.Enable or not db.oUF.Boss.Texts.PowerPercent.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Boss.Texts.PowerPercent.IndividualColor.r, db.oUF.Boss.Texts.PowerPercent.IndividualColor.g, db.oUF.Boss.Texts.PowerPercent.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Boss.Texts.PowerPercent.IndividualColor.r = r
													db.oUF.Boss.Texts.PowerPercent.IndividualColor.g = g
													db.oUF.Boss.Texts.PowerPercent.IndividualColor.b = b
													
													oUF_LUI_boss1.Power.valuePercent.individualColor.r = r
													oUF_LUI_boss1.Power.valuePercent.individualColor.g = g
													oUF_LUI_boss1.Power.valuePercent.individualColor.b = b

													oUF_LUI_boss1.Power.valuePercent:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the Boss HealthMissing or not.",
									type = "toggle",

									width = "full",
									get = function() return db.oUF.Boss.Texts.HealthMissing.Enable end,
									set = function(self,Enable)
											db.oUF.Boss.Texts.HealthMissing.Enable = not db.oUF.Boss.Texts.HealthMissing.Enable
											if Enable == true then
												oUF_LUI_boss1.Health.valueMissing:Show()
											else
												oUF_LUI_boss1.Health.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Boss HealthMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.Boss.Texts.HealthMissing.Size,
											disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Boss.Texts.HealthMissing.Size end,
											set = function(_, FontSize)
													db.oUF.Boss.Texts.HealthMissing.Size = FontSize
													oUF_LUI_boss1.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.HealthMissing.Font),db.oUF.Boss.Texts.HealthMissing.Size,db.oUF.Boss.Texts.HealthMissing.Outline)
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
											desc = "Always show Boss HealthMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.HealthMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.Boss.Texts.HealthMissing.ShowAlways = not db.oUF.Boss.Texts.HealthMissing.ShowAlways
													oUF_LUI_boss1.Health.valueMissing.ShowAlways = db.oUF.Boss.Texts.HealthMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.HealthMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.Boss.Texts.HealthMissing.ShortValue = not db.oUF.Boss.Texts.HealthMissing.ShortValue
													oUF_LUI_boss1.Health.valueMissing.ShortValue = db.oUF.Boss.Texts.HealthMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Boss HealthMissing!\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthMissing.Font,
											disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Boss.Texts.HealthMissing.Font end,
											set = function(self, Font)
													db.oUF.Boss.Texts.HealthMissing.Font = Font
													oUF_LUI_boss1.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.HealthMissing.Font),db.oUF.Boss.Texts.HealthMissing.Size,db.oUF.Boss.Texts.HealthMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Boss HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthMissing.Outline,
											disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Boss.Texts.HealthMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Boss.Texts.HealthMissing.Outline = fontflags[FontFlag]
													oUF_LUI_boss1.Health.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.HealthMissing.Font),db.oUF.Boss.Texts.HealthMissing.Size,db.oUF.Boss.Texts.HealthMissing.Outline)
												end,
											order = 6,
										},
										HealthMissingX = {
											name = "X Value",
											desc = "X Value for your Boss HealthMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthMissing.X,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.Boss.Texts.HealthMissing.X end,
											set = function(self,HealthMissingX)
														if HealthMissingX == nil or HealthMissingX == "" then
															HealthMissingX = "0"
														end
														db.oUF.Boss.Texts.HealthMissing.X = HealthMissingX
														oUF_LUI_boss1.Health.valueMissing:ClearAllPoints()
														oUF_LUI_boss1.Health.valueMissing:SetPoint(db.oUF.Boss.Texts.HealthMissing.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.Boss.Texts.HealthMissing.X), tonumber(db.oUF.Boss.Texts.HealthMissing.Y))
													end,
											order = 7,
										},
										HealthMissingY = {
											name = "Y Value",
											desc = "Y Value for your Boss HealthMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
											get = function() return db.oUF.Boss.Texts.HealthMissing.Y end,
											set = function(self,HealthMissingY)
														if HealthMissingY == nil or HealthMissingY == "" then
															HealthMissingY = "0"
														end
														db.oUF.Boss.Texts.HealthMissing.Y = HealthMissingY
														oUF_LUI_boss1.Health.valueMissing:ClearAllPoints()
														oUF_LUI_boss1.Health.valueMissing:SetPoint(db.oUF.Boss.Texts.HealthMissing.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.Boss.Texts.HealthMissing.X), tonumber(db.oUF.Boss.Texts.HealthMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Boss HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.HealthMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Boss.Texts.HealthMissing.Point = positions[Point]
													oUF_LUI_boss1.Health.valueMissing:ClearAllPoints()
													oUF_LUI_boss1.Health.valueMissing:SetPoint(db.oUF.Boss.Texts.HealthMissing.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.Boss.Texts.HealthMissing.X), tonumber(db.oUF.Boss.Texts.HealthMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Boss HealthMissing.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.HealthMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.HealthMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Boss.Texts.HealthMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_boss1.Health.valueMissing:ClearAllPoints()
													oUF_LUI_boss1.Health.valueMissing:SetPoint(db.oUF.Boss.Texts.HealthMissing.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.HealthMissing.RelativePoint, tonumber(db.oUF.Boss.Texts.HealthMissing.X), tonumber(db.oUF.Boss.Texts.HealthMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.HealthMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.HealthMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Boss.Texts.HealthMissing.ColorClass = true
														db.oUF.Boss.Texts.HealthMissing.ColorGradient = false
														db.oUF.Boss.Texts.HealthMissing.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Health.valueMissing.colorClass = true
														oUF_LUI_boss1.Health.valueMissing.colorGradient = false
														oUF_LUI_boss1.Health.valueMissing.colorIndividual.Enable = false

														print("Boss HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 1,
										},
										ColorGradient = {
											name = "Color Gradient",
											desc = "Wether you want to use Gradient colored HealthMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.HealthMissing.ColorGradient end,
											set = function(self,ColorGradient)
														db.oUF.Boss.Texts.HealthMissing.ColorGradient = true
														db.oUF.Boss.Texts.HealthMissing.ColorClass = false
														db.oUF.Boss.Texts.HealthMissing.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Health.valueMissing.colorGradient = true
														oUF_LUI_boss1.Health.valueMissing.colorClass = false
														oUF_LUI_boss1.Health.valueMissing.colorIndividual.Enable = false

														print("Boss HealthMissing Value Color will change once you gain/lose Health")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Boss HealthMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.HealthMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Boss.Texts.HealthMissing.IndividualColor.Enable = true
														db.oUF.Boss.Texts.HealthMissing.ColorClass = false
														db.oUF.Boss.Texts.HealthMissing.ColorGradient = false
															
														oUF_LUI_boss1.Health.valueMissing.colorIndividual.Enable = true
														oUF_LUI_boss1.Health.valueMissing.colorClass = false
														oUF_LUI_boss1.Health.valueMissing.colorGradient = false

														oUF_LUI_boss1.Health.valueMissing:SetTextColor(tonumber(db.oUF.Boss.Texts.HealthMissing.IndividualColor.r),tonumber(db.oUF.Boss.Texts.HealthMissing.IndividualColor.g),tonumber(db.oUF.Boss.Texts.HealthMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Boss HealthMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Boss.Texts.HealthMissing.IndividualColor.Enable or not db.oUF.Boss.Texts.HealthMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Boss.Texts.HealthMissing.IndividualColor.r, db.oUF.Boss.Texts.HealthMissing.IndividualColor.g, db.oUF.Boss.Texts.HealthMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Boss.Texts.HealthMissing.IndividualColor.r = r
													db.oUF.Boss.Texts.HealthMissing.IndividualColor.g = g
													db.oUF.Boss.Texts.HealthMissing.IndividualColor.b = b
													
													oUF_LUI_boss1.Health.valueMissing.colorIndividual.r = r
													oUF_LUI_boss1.Health.valueMissing.colorIndividual.g = g
													oUF_LUI_boss1.Health.valueMissing.colorIndividual.b = b
													
													oUF_LUI_boss1.Health.valueMissing:SetTextColor(r,g,b)
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
									desc = "Wether you want to show the Boss PowerMissing or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Boss.Texts.PowerMissing.Enable end,
									set = function(self,Enable)
											db.oUF.Boss.Texts.PowerMissing.Enable = not db.oUF.Boss.Texts.PowerMissing.Enable
											if Enable == true then
												oUF_LUI_boss1.Power.valueMissing:Show()
											else
												oUF_LUI_boss1.Power.valueMissing:Hide()
											end
										end,
									order = 1,
								},
								FontSettings = {
									name = "Font Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 1,
									args = {
										FontSize = {
											name = "Size",
											desc = "Choose your Boss PowerMissing Fontsize!\n Default: "..LUI.defaults.profile.oUF.Boss.Texts.PowerMissing.Size,
											disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
											type = "range",
											min = 1,
											max = 40,
											step = 1,
											get = function() return db.oUF.Boss.Texts.PowerMissing.Size end,
											set = function(_, FontSize)
													db.oUF.Boss.Texts.PowerMissing.Size = FontSize
													oUF_LUI_boss1.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.PowerMissing.Font),db.oUF.Boss.Texts.PowerMissing.Size,db.oUF.Boss.Texts.PowerMissing.Outline)
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
											desc = "Always show Boss PowerMissing or just if the Unit has no MaxHP.",
											disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.PowerMissing.ShowAlways end,
											set = function(self,ShowAlways)
													db.oUF.Boss.Texts.PowerMissing.ShowAlways = not db.oUF.Boss.Texts.PowerMissing.ShowAlways
													oUF_LUI_boss1.Power.valueMissing.ShowAlways = db.oUF.Boss.Texts.PowerMissing.ShowAlways
												end,
											order = 3,
										},
										ShortValue = {
											name = "Short Value",
											desc = "Show a Short or the Normal Value of the Missing HP",
											disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.PowerMissing.ShortValue end,
											set = function(self,ShortValue)
													db.oUF.Boss.Texts.PowerMissing.ShortValue = not db.oUF.Boss.Texts.PowerMissing.ShortValue
													oUF_LUI_boss1.Power.valueMissing.ShortValue = db.oUF.Boss.Texts.PowerMissing.ShortValue
												end,
											order = 4,
										},
										Font = {
											name = "Font",
											desc = "Choose your Font for Boss PowerMissing!\n\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerMissing.Font,
											disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
											type = "select",
											dialogControl = "LSM30_Font",
											values = widgetLists.font,
											get = function() return db.oUF.Boss.Texts.PowerMissing.Font end,
											set = function(self, Font)
													db.oUF.Boss.Texts.PowerMissing.Font = Font
													oUF_LUI_boss1.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.PowerMissing.Font),db.oUF.Boss.Texts.PowerMissing.Size,db.oUF.Boss.Texts.PowerMissing.Outline)
												end,
											order = 5,
										},
										FontFlag = {
											name = "Font Flag",
											desc = "Choose the Font Flag for your Boss PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerMissing.Outline,
											disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
											type = "select",
											values = fontflags,
											get = function()
													for k, v in pairs(fontflags) do
														if db.oUF.Boss.Texts.PowerMissing.Outline == v then
															return k
														end
													end
												end,
											set = function(self, FontFlag)
													db.oUF.Boss.Texts.PowerMissing.Outline = fontflags[FontFlag]
													oUF_LUI_boss1.Power.valueMissing:SetFont(LSM:Fetch("font", db.oUF.Boss.Texts.PowerMissing.Font),db.oUF.Boss.Texts.PowerMissing.Size,db.oUF.Boss.Texts.PowerMissing.Outline)
												end,
											order = 6,
										},
										PowerMissingX = {
											name = "X Value",
											desc = "X Value for your Boss PowerMissing.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerMissing.X,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.Boss.Texts.PowerMissing.X end,
											set = function(self,PowerMissingX)
														if PowerMissingX == nil or PowerMissingX == "" then
															PowerMissingX = "0"
														end
														db.oUF.Boss.Texts.PowerMissing.X = PowerMissingX
														oUF_LUI_boss1.Power.valueMissing:ClearAllPoints()
														oUF_LUI_boss1.Power.valueMissing:SetPoint(db.oUF.Boss.Texts.PowerMissing.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.Boss.Texts.PowerMissing.X), tonumber(db.oUF.Boss.Texts.PowerMissing.Y))
													end,
											order = 7,
										},
										PowerMissingY = {
											name = "Y Value",
											desc = "Y Value for your Boss PowerMissing.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerMissing.Y,
											type = "input",
											disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
											get = function() return db.oUF.Boss.Texts.PowerMissing.Y end,
											set = function(self,PowerMissingY)
														if PowerMissingY == nil or PowerMissingY == "" then
															PowerMissingY = "0"
														end
														db.oUF.Boss.Texts.PowerMissing.Y = PowerMissingY
														oUF_LUI_boss1.Power.valueMissing:ClearAllPoints()
														oUF_LUI_boss1.Power.valueMissing:SetPoint(db.oUF.Boss.Texts.PowerMissing.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.Boss.Texts.PowerMissing.X), tonumber(db.oUF.Boss.Texts.PowerMissing.Y))
													end,
											order = 8,
										},
										Point = {
											name = "Point",
											desc = "Choose the Position for your Boss PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerMissing.Point,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.PowerMissing.Point == v then
															return k
														end
													end
												end,
											set = function(self, Point)
													db.oUF.Boss.Texts.PowerMissing.Point = positions[Point]
													oUF_LUI_boss1.Power.valueMissing:ClearAllPoints()
													oUF_LUI_boss1.Power.valueMissing:SetPoint(db.oUF.Boss.Texts.PowerMissing.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.Boss.Texts.PowerMissing.X), tonumber(db.oUF.Boss.Texts.PowerMissing.Y))
												end,
											order = 9,
										},
										RelativePoint = {
											name = "RelativePoint",
											desc = "Choose the RelativePoint for your Boss PowerMissing.\nDefault: "..LUI.defaults.profile.oUF.Boss.Texts.PowerMissing.RelativePoint,
											type = "select",
											disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
											values = positions,
											get = function()
													for k, v in pairs(positions) do
														if db.oUF.Boss.Texts.PowerMissing.RelativePoint == v then
															return k
														end
													end
												end,
											set = function(self, RelativePoint)
													db.oUF.Boss.Texts.PowerMissing.RelativePoint = positions[RelativePoint]
													oUF_LUI_boss1.Power.valueMissing:ClearAllPoints()
													oUF_LUI_boss1.Power.valueMissing:SetPoint(db.oUF.Boss.Texts.PowerMissing.Point, oUF_LUI_boss1, db.oUF.Boss.Texts.PowerMissing.RelativePoint, tonumber(db.oUF.Boss.Texts.PowerMissing.X), tonumber(db.oUF.Boss.Texts.PowerMissing.Y))
												end,
											order = 10,
										},
									},
								},
								Colors = {
									name = "Color Settings",
									type = "group",
									disabled = function() return not db.oUF.Boss.Texts.PowerMissing.Enable end,
									guiInline = true,
									order = 2,
									args = {
										ClassColor = {
											name = "Color by Class",
											desc = "Wether you want to use class colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.PowerMissing.ColorClass end,
											set = function(self,ClassColor)
														db.oUF.Boss.Texts.PowerMissing.ColorClass = true
														db.oUF.Boss.Texts.PowerMissing.ColorType = false
														db.oUF.Boss.Texts.PowerMissing.IndividualColor.Enable = false
														
														oUF_LUI_boss1.Power.valueMissing.colorClass = true
														oUF_LUI_boss1.Power.valueMissing.colorType = false
														oUF_LUI_boss1.Power.valueMissing.colorIndividual.Enable = false

														print("Boss PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 1,
										},
										ColorType = {
											name = "Color by Type",
											desc = "Wether you want to use Type colored PowerMissing Value or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.PowerMissing.ColorType end,
											set = function(self,ColorType)
														db.oUF.Boss.Texts.PowerMissing.ColorType = true
														db.oUF.Boss.Texts.PowerMissing.ColorClass = false
														db.oUF.Boss.Texts.PowerMissing.IndividualColor.Enable = false
															
														oUF_LUI_boss1.Power.valueMissing.colorType = true
														oUF_LUI_boss1.Power.valueMissing.colorClass = false
														oUF_LUI_boss1.Power.valueMissing.colorIndividual.Enable = false
		
														print("Boss PowerMissing Value Color will change once you gain/lose Power")
													end,
											order = 2,
										},
										IndividualColor = {
											name = "Individual Color",
											desc = "Wether you want to use an individual Boss PowerMissing Value Color or not.",
											type = "toggle",
											get = function() return db.oUF.Boss.Texts.PowerMissing.IndividualColor.Enable end,
											set = function(self,IndividualColor)
														db.oUF.Boss.Texts.PowerMissing.IndividualColor.Enable = true
														db.oUF.Boss.Texts.PowerMissing.ColorClass = false
														db.oUF.Boss.Texts.PowerMissing.ColorType = false
															
														oUF_LUI_boss1.Power.valueMissing.colorIndividual.Enable = true
														oUF_LUI_boss1.Power.valueMissing.colorClass = false
														oUF_LUI_boss1.Power.valueMissing.colorType = false
		
														oUF_LUI_boss1.Power.valueMissing:SetTextColor(tonumber(db.oUF.Boss.Texts.PowerMissing.IndividualColor.r),tonumber(db.oUF.Boss.Texts.PowerMissing.IndividualColor.g),tonumber(db.oUF.Boss.Texts.PowerMissing.IndividualColor.b))
													end,
											order = 3,
										},
										Color = {
											name = "Individual Color",
											desc = "Choose an individual Boss PowerMissing Value Color.\n\nNote:\nYou have to reload the UI.\nType /rl",
											type = "color",
											disabled = function() return not db.oUF.Boss.Texts.PowerMissing.IndividualColor.Enable or not db.oUF.Boss.Texts.PowerMissing.Enable end,
											hasAlpha = false,
											get = function() return db.oUF.Boss.Texts.PowerMissing.IndividualColor.r, db.oUF.Boss.Texts.PowerMissing.IndividualColor.g, db.oUF.Boss.Texts.PowerMissing.IndividualColor.b end,
											set = function(_,r,g,b)
													db.oUF.Boss.Texts.PowerMissing.IndividualColor.r = r
													db.oUF.Boss.Texts.PowerMissing.IndividualColor.g = g
													db.oUF.Boss.Texts.PowerMissing.IndividualColor.b = b
													
													oUF_LUI_boss1.Power.valueMissing.colorIndividual.r = r
													oUF_LUI_boss1.Power.valueMissing.colorIndividual.g = g
													oUF_LUI_boss1.Power.valueMissing.colorIndividual.b = b
														
													oUF_LUI_boss1.Power.valueMissing:SetTextColor(r,g,b)
												end,
											order = 4,
										},
									},
								},
							},
						},
					},
				},
				Portrait = {
					name = "Portrait",
					disabled = function() return not db.oUF.Boss.Enable end,
					type = "group",
					order = 7,
					args = {
						EnablePortrait = {
							name = "Enable",
							desc = "Wether you want to show the Portrait or not.",
							type = "toggle",
							width = "full",
							get = function() return db.oUF.Boss.Portrait.Enable end,
							set = function(self,EnablePortrait)
										db.oUF.Boss.Portrait.Enable = not db.oUF.Boss.Portrait.Enable
										StaticPopup_Show("RELOAD_UI")
									end,
							order = 1,
						},
						PortraitWidth = {
							name = "Width",
							desc = "Choose the Width for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.Boss.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.Boss.Portrait.Enable end,
							get = function() return db.oUF.Boss.Portrait.Width end,
							set = function(self,PortraitWidth)
										if PortraitWidth == nil or PortraitWidth == "" then
											PortraitWidth = "0"
										end
										db.oUF.Boss.Portrait.Width = PortraitWidth
										oUF_LUI_boss1.Portrait:SetWidth(tonumber(PortraitWidth))
									end,
							order = 2,
						},
						PortraitHeight = {
							name = "Height",
							desc = "Choose the Height for your Portrait.\nDefault: "..LUI.defaults.profile.oUF.Boss.Portrait.Width,
							type = "input",
							disabled = function() return not db.oUF.Boss.Portrait.Enable end,
							get = function() return db.oUF.Boss.Portrait.Height end,
							set = function(self,PortraitHeight)
										if PortraitHeight == nil or PortraitHeight == "" then
											PortraitHeight = "0"
										end
										db.oUF.Boss.Portrait.Height = PortraitHeight
										oUF_LUI_boss1.Portrait:SetHeight(tonumber(PortraitHeight))
									end,
							order = 3,
						},
						PortraitX = {
							name = "X Value",
							desc = "X Value for your Portrait.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Boss.Portrait.X,
							type = "input",
							disabled = function() return not db.oUF.Boss.Portrait.Enable end,
							get = function() return db.oUF.Boss.Portrait.X end,
							set = function(self,PortraitX)
										if PortraitX == nil or PortraitX == "" then
											PortraitX = "0"
										end
										db.oUF.Boss.Portrait.X = PortraitX
										oUF_LUI_boss1.Portrait:SetPoint("TOPLEFT", oUF_LUI_boss1.Health, "TOPLEFT", PortraitX, db.oUF.Boss.Portrait.Y)
									end,
							order = 4,
						},
						PortraitY = {
							name = "Y Value",
							desc = "Y Value for your Portrait.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Portrait.Y,
							type = "input",
							disabled = function() return not db.oUF.Boss.Portrait.Enable end,
							get = function() return db.oUF.Boss.Portrait.Y end,
							set = function(self,PortraitY)
										if PortraitY == nil or PortraitY == "" then
											PortraitY = "0"
										end
										db.oUF.Boss.Portrait.Y = PortraitY
										oUF_LUI_boss1.Portrait:SetPoint("TOPLEFT", oUF_LUI_boss1.Health, "TOPLEFT", db.oUF.Boss.Portrait.X, PortraitY)
									end,
							order = 5,
						},
					},
				},
				Icons = {
					name = "Icons",
					type = "group",
					disabled = function() return not db.oUF.Boss.Enable end,
					order = 8,
					childGroups = "tab",
					args = {
						Raid = {
							name = "RaidIcon",
							type = "group",
							order = 1,
							args = {
								RaidEnable = {
									name = "Enable",
									desc = "Wether you want to show the Raid Icon or not.",
									type = "toggle",
									width = "full",
									get = function() return db.oUF.Boss.Icons.Raid.Enable end,
									set = function(self,RaidEnable)
												db.oUF.Boss.Icons.Raid.Enable = not db.oUF.Boss.Icons.Raid.Enable
												StaticPopup_Show("RELOAD_UI")
											end,
									order = 1,
								},
								RaidX = {
									name = "X Value",
									desc = "X Value for your Raid Icon.\n\nNote:\nPositive values = right\nNegativ values = left\nDefault: "..LUI.defaults.profile.oUF.Boss.Icons.Raid.X,
									type = "input",
									disabled = function() return not db.oUF.Boss.Icons.Raid.Enable end,
									get = function() return db.oUF.Boss.Icons.Raid.X end,
									set = function(self,RaidX)
												if RaidX == nil or RaidX == "" then
													RaidX = "0"
												end

												db.oUF.Boss.Icons.Raid.X = RaidX
												oUF_LUI_boss1.RaidIcon:ClearAllPoints()
												oUF_LUI_boss1.RaidIcon:SetPoint(db.oUF.Boss.Icons.Raid.Point, oUF_LUI_boss1, db.oUF.Boss.Icons.Raid.Point, tonumber(RaidX), tonumber(db.oUF.Boss.Icons.Raid.Y))
											end,
									order = 2,
								},
								RaidY = {
									name = "Y Value",
									desc = "Y Value for your Raid Icon.\n\nNote:\nPositive values = up\nNegativ values = down\nDefault: "..LUI.defaults.profile.oUF.Boss.Icons.Raid.Y,
									type = "input",
									disabled = function() return not db.oUF.Boss.Icons.Raid.Enable end,
									get = function() return db.oUF.Boss.Icons.Raid.Y end,
									set = function(self,RaidY)
												if RaidY == nil or RaidY == "" then
													RaidY = "0"
												end
												db.oUF.Boss.Icons.Raid.Y = RaidY
												oUF_LUI_boss1.RaidIcon:ClearAllPoints()
												oUF_LUI_boss1.RaidIcon:SetPoint(db.oUF.Boss.Icons.Raid.Point, oUF_LUI_boss1, db.oUF.Boss.Icons.Raid.Point, tonumber(db.oUF.Boss.Icons.Raid.X), tonumber(RaidY))
											end,
									order = 3,
								},
								RaidPoint = {
									name = "Position",
									desc = "Choose the Position for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.Boss.Icons.Raid.Point,
									type = "select",
									disabled = function() return not db.oUF.Boss.Icons.Raid.Enable end,
									values = positions,
									get = function()
											for k, v in pairs(positions) do
												if db.oUF.Boss.Icons.Raid.Point == v then
													return k
												end
											end
										end,
									set = function(self, RaidPoint)
											db.oUF.Boss.Icons.Raid.Point = positions[RaidPoint]
											oUF_LUI_boss1.RaidIcon:ClearAllPoints()
											oUF_LUI_boss1.RaidIcon:SetPoint(db.oUF.Boss.Icons.Raid.Point, oUF_LUI_boss1, db.oUF.Boss.Icons.Raid.Point, tonumber(db.oUF.Boss.Icons.Raid.X), tonumber(db.oUF.Boss.Icons.Raid.Y))
										end,
									order = 4,
								},
								RaidSize = {
									name = "Size",
									desc = "Choose a Size for your Raid Icon.\nDefault: "..LUI.defaults.profile.oUF.Boss.Icons.Raid.Size,
									type = "range",
									min = 5,
									max = 200,
									step = 5,
									disabled = function() return not db.oUF.Boss.Icons.Raid.Enable end,
									get = function() return db.oUF.Boss.Icons.Raid.Size end,
									set = function(_, RaidSize) 
											db.oUF.Boss.Icons.Raid.Size = RaidSize
											oUF_LUI_boss1.RaidIcon:SetHeight(RaidSize)
											oUF_LUI_boss1.RaidIcon:SetWidth(RaidSize)
										end,
									order = 5,
								},
								toggle = {
									order = 6,
									name = "Show/Hide",
									disabled = function() return not db.oUF.Boss.Icons.Raid.Enable end,
									desc = "Toggles the RaidIcon",
									type = 'execute',
									func = function() if oUF_LUI_boss1.RaidIcon:IsShown() then oUF_LUI_boss1.RaidIcon:Hide() else oUF_LUI_boss1.RaidIcon:Show() end end
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