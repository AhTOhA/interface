local MapData = nil
local Config = nil

ARH_GREEN = 1
ARH_YELLOW = 2
ARH_RED = 3

CONYARDS = {[ARH_GREEN] = 40, [ARH_YELLOW] = 80, [ARH_RED] = 640}

local minimap_size = {
	indoor = {
		[0] = 300, -- scale
		[1] = 240, -- 1.25
		[2] = 180, -- 5/3
		[3] = 120, -- 2.5
		[4] = 80,  -- 3.75
		[5] = 50,  -- 6
	},
	outdoor = {
		[0] = 466 + 2/3, -- scale
		[1] = 400,       -- 7/6
		[2] = 333 + 1/3, -- 1.4
		[3] = 266 + 2/6, -- 1.75
		[4] = 200,       -- 7/3
		[5] = 133 + 1/3, -- 3.5
	},
}
local minimap_scale = {
	indoor = {
		[0] = 1,
		[1] = 1.25,
		[2] = 5/3,
		[3] = 2.5,
		[4] = 3.75,
		[5] = 6,
	},
	outdoor = {
		[0] = 1,
		[1] = 7/6,
		[2] = 1.4,
		[3] = 1.75,
		[4] = 7/3,
		[5] = 3.5,
	},
}

local function CopyByValue(t)
	if type(t) ~= "table" then return t end
	local t2 = {}
	for k,v in pairs(t) do
		t2[CopyByValue(k)] = CopyByValue(v)
	end
	return t2
end

local function SetVisible(self, visible)
	if visible then
		self:Show()
	else
		self:Hide()
	end
end

local function cs(str)
	return "|cffffff78"..str.."|r"
end

Arh_DefaultConfig =
{
	MainFrame =
	{
		Visible = true,
		Locked = false,
		Scale = 1,
		Alpha = 1,
		ShowTooltips = true,
	},
	HUD =
	{
		UseGatherMate2 = true,
		Scale = 1,
		Alpha = 1,
		ShowArrow = true,
		ArrowScale = 1,
		ArrowAlpha = 1,
		ShowSuccessCircle = true,
		SuccessCircleColor = {r=1, g=0, b=0, a=1},
		ShowCompass = true,
		CompassRadius = 120,
		CompassColor = {r=0, g=1, b=0, a=0.5},
		CompassTextColor = {r=0, g=1, b=0, a=0.5},
		RedSectAlpha = 0.1,
		RedLineAlpha = 0.05,
		YellowSectAlpha = 0.1,
		YellowLineAlpha = 0.2,
		GreenSectAlpha = 0.1,
		GreenLineAlpha = 0.2,
	},
	DigSites =
	{
		ShowOnMinimap = false,
		ShowOnBattlefieldMinimap = true,
	},
}
local cfg = nil

BINDING_HEADER_ARH = "Archaeology Helper"
BINDING_NAME_ARH_ADDRED = "Add red area to the HUD"
BINDING_NAME_ARH_ADDYELLOW = "Add yellow area to the HUD"
BINDING_NAME_ARH_ADDGREEN = "Add green area to the HUD"
BINDING_NAME_ARH_TOGGLEHUD = "Show/Hide the HUD"
BINDING_NAME_ARH_TOGGLERED = "Show/Hide all red areas"
BINDING_NAME_ARH_TOGGLEYELLOW = "Show/Hide all yellow areas"
BINDING_NAME_ARH_TOGGLEGREEN = "Show/Hide all green areas"
BINDING_NAME_ARH_BACK = "Remove one previously added area"

local function Arh_UpdateSettings()
	local c

-- MainFrame
	Arh_MainFrame:ClearAllPoints()
	Arh_MainFrame:SetPoint("CENTER")
	SetVisible(Arh_MainFrame, cfg.MainFrame.Visible)
    Arh_MainFrame:SetScale(cfg.MainFrame.Scale)
	Arh_MainFrame:SetAlpha(cfg.MainFrame.Alpha)

-- HUD
	-- Frame
	Arh_SetUseGatherMate2(cfg.HUD.UseGatherMate2)
    Arh_HudFrame:SetScale(cfg.HUD.Scale)
	Arh_HudFrame:SetAlpha(cfg.HUD.Alpha)
    -- Arrow
	SetVisible(Arh_HudFrame_ArrowFrame, cfg.HUD.ShowArrow)
	Arh_HudFrame_ArrowFrame:SetScale(cfg.HUD.ArrowScale)
	Arh_HudFrame_ArrowFrame:SetAlpha(cfg.HUD.ArrowAlpha)
	-- SuccessCircle
    SetVisible(Arh_HudFrame.SuccessCircle, cfg.HUD.ShowSuccessCircle)
	c = cfg.HUD.SuccessCircleColor
	Arh_HudFrame.SuccessCircle:SetVertexColor(c.r, c.g, c.b, c.a)
	-- Compass
	SetVisible(Arh_HudFrame.CompassCircle, cfg.HUD.ShowCompass)
	c = cfg.HUD.CompassColor
	Arh_HudFrame.CompassCircle:SetVertexColor(c.r, c.g, c.b, c.a)
	c = cfg.HUD.CompassTextColor
    for k, v in ipairs(Arh_HudFrame.CompasDirections) do
		SetVisible(v, cfg.HUD.ShowCompass)
		v:SetTextColor(c.r, c.g, c.b, c.a)
    end
	Arh_UpdateHudFrameSizes(true)
	-- Annulus Sectors
	Arh_UpdateAlphaEverything(ARH_RED, false)
    Arh_UpdateAlphaEverything(ARH_YELLOW, false)
	Arh_UpdateAlphaEverything(ARH_GREEN, false)
	Arh_UpdateAlphaEverything(ARH_RED, true)
	Arh_UpdateAlphaEverything(ARH_YELLOW, true)
	Arh_UpdateAlphaEverything(ARH_GREEN, true)

-- Dig Sites
	SetVisible(Arh_ArchaeologyDigSites_BattlefieldMinimap, cfg.DigSites.ShowOnBattlefieldMinimap)
	SetVisible(Arh_ArchaeologyDigSites_Minimap, cfg.DigSites.ShowOnMinimap)
end

local OptionsTable =
{
	type = "group",
	args =
		{
			ResetToDefaults =
			{
				order = 1,
				name = "Reset All Settings",
				desc = "Resets all settings to defaults",
				type = "execute",
				confirm = true,
				confirmText = "This will overwrite current settings!",
				func =
						function()
							Arh_Config = CopyByValue(Arh_DefaultConfig)
							cfg = Arh_Config
							Arh_UpdateSettings()
						end,
			},
			MainFrame =
			{
				order = 2,
				name = "Main Window",
				desc = "Main window settings",
				type = "group",
				args =
				{
					VisualOptions =
					{
						order = 1,
						type = "group",
						name = "Visual Settings",
						inline = true,
						args = 
						{
							reset =
							{
								order = 1,
								name = "Reset Position",
								desc = "Resets window position to the center of the screen",
								type = "execute",
								width = "full",
								confirm = true,
								confirmText = "This will reset Main Window position",
								func =
										function()
											Arh_MainFrame:ClearAllPoints()
											Arh_MainFrame:SetPoint("CENTER")
										end,
							},
							visible =
							{
								order = 2,
								name = "Visible",
								desc = "Whether window is visible",
								type = "toggle",
								get = function(info) return cfg.MainFrame.Visible end,
								set =
									function(info,val)
										cfg.MainFrame.Visible = val
										SetVisible(Arh_MainFrame, val)
									end,
							},
							locked =
							{
								order = 3,
								name = "Locked",
								desc = "Locks window to prevent accidental repositioning",
								type = "toggle",
								get = function(info) return cfg.MainFrame.Locked end,
								set =
									function(info,val)
										cfg.MainFrame.Locked = val
									end,
							},
							scale =
							{
								order = 4,
								name = "Scaling",
								desc = "Size of the main window",
								type = "range",
								min = 0.1,
								max = 100,
								softMin = 0.5,
								softMax = 5,
								step = 0.1,
								get = function(info) return cfg.MainFrame.Scale end,
								set =
									function(info,val)
										cfg.MainFrame.Scale = val
										Arh_MainFrame:SetScale(val)
									end,
							},
							alpha =
							{
								order = 5,
								name = "Alpha",
								desc = "How transparent is window",
								type = "range",
								min = 0,
								max = 1,
								step = 0.01,
								isPercent = true,
								get = function(info) return cfg.MainFrame.Alpha end,
								set =
									function(info,val)
										cfg.MainFrame.Alpha = val
										Arh_MainFrame:SetAlpha(val)
									end,
							},
							ShowTooltips =
							{
								order = 6,
								name = "Show Tooltips",
								desc = "Show Tooltips in the main window",
								type = "toggle",
								get = function(info) return cfg.MainFrame.ShowTooltips end,
								set = function(info,val) cfg.MainFrame.ShowTooltips = val end,
							},
						},
					},
					KeyBindings =
					{
						order = 2,
						type = "group",
						name = "Key Bindings Settings",
						inline = true,
						args = 
						{
							DigButtonKeyBinding =
							{
								order = 1,
								width = "full",
								type = "keybinding",
								name = BINDING_NAME_ARH_TOGGLEHUD,
								desc = "You can also use |cff69ccf0/arh h|r command for this action",
								get =
										function()
											return GetBindingKey("ARH_TOGGLEHUD")
										end,
								set =
										function(info, v)
											SetBinding(v, "ARH_TOGGLEHUD")
											SaveBindings(GetCurrentBindingSet())
										end
							},
							RedButtonKeyBinding =
							{
								order = 2,
								width = "full",
								type = "keybinding",
								name = BINDING_NAME_ARH_ADDRED,
								desc = "You can also use |cff69ccf0/arh ar|r command for this action",
								get =
										function()
											return GetBindingKey("ARH_ADDRED")
										end,
								set =
										function(info, v)
											SetBinding(v, "ARH_ADDRED")
											SaveBindings(GetCurrentBindingSet())
										end
							},
							YellowButtonKeyBinding =
							{
								order = 3,
								width = "full",
								type = "keybinding",
								name = BINDING_NAME_ARH_ADDYELLOW,
								desc = "You can also use |cff69ccf0/arh ay|r command for this action",
								get =
										function()
											return GetBindingKey("ARH_ADDYELLOW")
										end,
								set =
										function(info, v)
											SetBinding(v, "ARH_ADDYELLOW")
											SaveBindings(GetCurrentBindingSet())
										end
							},
							GreenButtonKeyBinding =
							{
								order = 4,
								width = "full",
								type = "keybinding",
								name = BINDING_NAME_ARH_ADDGREEN,
								desc = "You can also use |cff69ccf0/arh ag|r command for this action",
								get =
										function()
											return GetBindingKey("ARH_ADDGREEN")
										end,
								set =
										function(info, v)
											SetBinding(v, "ARH_ADDGREEN")
											SaveBindings(GetCurrentBindingSet())
										end
							},
							ToggleRedButtonKeyBinding =
							{
								order = 5,
								width = "full",
								type = "keybinding",
								name = BINDING_NAME_ARH_TOGGLERED,
								desc = "Show/Hide all red areas",
								get =
										function()
											return GetBindingKey("ARH_TOGGLERED")
										end,
								set =
										function(info, v)
											SetBinding(v, "ARH_TOGGLERED")
											SaveBindings(GetCurrentBindingSet())
										end
							},
							ToggleYellowButtonKeyBinding =
							{
								order = 6,
								width = "full",
								type = "keybinding",
								name = BINDING_NAME_ARH_TOGGLEYELLOW,
								desc = "Show/Hide all yellow areas",
								get =
										function()
											return GetBindingKey("ARH_TOGGLEYELLOW")
										end,
								set =
										function(info, v)
											SetBinding(v, "ARH_TOGGLEYELLOW")
											SaveBindings(GetCurrentBindingSet())
										end
							},
							ToggleGreenButtonKeyBinding =
							{
								order = 7,
								width = "full",
								type = "keybinding",
								name = BINDING_NAME_ARH_TOGGLEGREEN,
								desc = "Show/Hide all green areas",
								get =
										function()
											return GetBindingKey("ARH_TOGGLEGREEN")
										end,
								set =
										function(info, v)
											SetBinding(v, "ARH_TOGGLEGREEN")
											SaveBindings(GetCurrentBindingSet())
										end
							},
							BackButtonKeyBinding =
							{
								order = 8,
								width = "full",
								type = "keybinding",
								name = BINDING_NAME_ARH_BACK,
								desc = "Remove one previously added area",
								get =
										function()
											return GetBindingKey("ARH_BACK")
										end,
								set =
										function(info, v)
											SetBinding(v, "ARH_BACK")
											SaveBindings(GetCurrentBindingSet())
										end
							},
						},
					},

				},
			},
			HUD =
			{
				order = 3,
				name = "HUD",
				desc = "HUD settings",
				type = "group",
				args =
				{
					General =
					{
						order = 1,
						type = "group",
						name = "General HUD Settings",
						inline = true,
						args = 
						{
							ShowGatherMate2 =
							{
								order = 1,
								name = "Show GatherMate2 pins on the HUD (recomended)",
								desc = "Redirect GatherMate2 output to the HUD when visible",
								type = "toggle",
								width = "full",
								disabled = function(info) return not GatherMate2 end,
								get = function(info) return cfg.HUD.UseGatherMate2 end,
								set = function(info,val) Arh_SetUseGatherMate2(val) end,
							},
							scale =
							{
								order = 2,
								name = "HUD Scaling",
								desc = "Size of the HUD\nIf you need ZOOM - use Minimap ZOOM instead",
								type = "range",        
								min = 0.1,
								max = 100,
								softMin = 0.1,
								softMax = 3,
								step = 0.1,
								get = function(info) return cfg.HUD.Scale end,
								set =
									function(info,val)
										cfg.HUD.Scale = val
										Arh_HudFrame:SetScale(val)
									end,
							},
							alpha =
							{
								order = 3,
								name = "HUD Alpha",
								desc = "How transparent is HUD",
								type = "range",        
								min = 0,
								max = 1,
								step = 0.01,
								isPercent = true,
								get = function(info) return cfg.HUD.Alpha end,
								set =
									function(info,val)
										cfg.HUD.Alpha = val
										Arh_HudFrame:SetAlpha(val)
									end,
							},
							ShowArrow =
							{
								order = 4,
								name = "Show Palyer Arrow",
								desc = "Draw arrow in the center of the HUD",
								type = "toggle",
								width = "full",
								get = function(info) return cfg.HUD.ShowArrow end,
								set =
									function(info,val)
										cfg.HUD.ShowArrow = val
										SetVisible(Arh_HudFrame_ArrowFrame, val)
									end,
							},
							ArrowScale =
							{
								order = 5,
								name = "Arrow Scaling",
								desc = "Size of the Player Arrow",
								type = "range",
								disabled = function(info) return not cfg.HUD.ShowArrow end,
								min = 0.1,
								max = 100,
								softMin = 0.1,
								softMax = 10,
								step = 0.1,
								get = function(info) return cfg.HUD.ArrowScale end,
								set =
									function(info,val)
										cfg.HUD.ArrowScale = val
										Arh_HudFrame_ArrowFrame:SetScale(val)
									end,
							},
							ArrowAlpha =
							{
								order = 6,
								name = "Arrow Alpha",
								desc = "How transparent is Player Arrow",
								type = "range",
								disabled = function(info) return not cfg.HUD.ShowArrow end,
								min = 0,
								max = 1,
								step = 0.01,
								isPercent = true,
								get = function(info) return cfg.HUD.ArrowAlpha end,
								set =
									function(info,val)
										cfg.HUD.ArrowAlpha = val
										Arh_HudFrame_ArrowFrame:SetAlpha(val)
									end,
							},
							ShowSuccessCircle =
							{
								order = 7,
								name = "Show Success Circle",
								desc = "Survae will success if fragment lay within this circle",
								type = "toggle",
								get = function(info) return cfg.HUD.ShowSuccessCircle end,
								set =
									function(info,val)
										cfg.HUD.ShowSuccessCircle = val
										SetVisible(Arh_HudFrame.SuccessCircle, val)
									end,
							},
							SuccessCircleColor =
							{
								order = 8,
								name = "Success Circle Color",
								desc = "Color of the Success Circle (you can also set alpha here)",
								type = "color",
								hasAlpha  = true,
								disabled = function(info) return not cfg.HUD.ShowSuccessCircle end,
								get =
										function(info)
											local c = cfg.HUD.SuccessCircleColor
											return c.r, c.g, c.b, c.a
										end,
								set =
										function(info, r, g, b, a)
											local c = cfg.HUD.SuccessCircleColor
											c.r, c.g, c.b, c.a = r, g, b, a
											Arh_HudFrame.SuccessCircle:SetVertexColor(c.r, c.g, c.b, c.a)
										end,
							},

						},
					},
					Compass =
					{
						order = 2,
						type = "group",
						name = "Compass Settings",
						inline = true,
						args = 
						{
							ShowCompass =
							{
								order = 1,
								name = "Show compass",
								desc = "Draw compass-like  circle on the HUD",
								type = "toggle",
								get = function(info) return cfg.HUD.ShowCompass end,
								set =
									function(info,val)
										cfg.HUD.ShowCompass = val
										SetVisible(Arh_HudFrame.CompassCircle, val)
										for k, v in ipairs(Arh_HudFrame.CompasDirections) do
											SetVisible(v, val)
										end
									end,
							},
							CompassRadius =
							{
								order = 2,
								name = "Radius (yards)",
								desc = "Radius of the compass circle",
								type = "range",
								disabled = function(info) return not cfg.HUD.ShowCompass end,
								min = 1,
								max = 1000,
								softMin = 10,
								softMax = 300,
								step = 1,
								get = function(info) return cfg.HUD.CompassRadius end,
								set =
									function(info,val)
										cfg.HUD.CompassRadius = val
										Arh_UpdateHudFrameSizes(true)
									end,
							},
							CompassColor =
							{
								order = 3,
								name = "Compass Circle Color",
								desc = "Color of the Compass Circle (you can also set alpha here)",
								type = "color",
								hasAlpha  = true,
								disabled = function(info) return not cfg.HUD.ShowCompass end,
								get =
										function(info)
											local c = cfg.HUD.CompassColor
											return c.r, c.g, c.b, c.a
										end,
								set =
										function(info, r, g, b, a)
											local c = cfg.HUD.CompassColor
											c.r, c.g, c.b, c.a = r, g, b, a
											Arh_HudFrame.CompassCircle:SetVertexColor(c.r, c.g, c.b, c.a)
										end,
							},
							CompassTextColor =
							{
								order = 4,
								name = "Direction Marks Color",
								desc = "Color of Compass Direction Marks (you can also set alpha here)",
								type = "color",
								hasAlpha  = true,
								disabled = function(info) return not cfg.HUD.ShowCompass end,
								get =
										function(info)
											local c = cfg.HUD.CompassTextColor
											return c.r, c.g, c.b, c.a
										end,
								set =
										function(info, r, g, b, a)
											local c = cfg.HUD.CompassTextColor
											c.r, c.g, c.b, c.a = r, g, b, a
											for k, v in ipairs(Arh_HudFrame.CompasDirections) do
												v:SetTextColor(c.r, c.g, c.b, c.a)
											end
										end,
							},

						},
					},
					AnnulusSectors =
					{
						order = 3,
						type = "group",
						name = "Annulus Sectors Settings",
						inline = true,
						args = 
						{
							RedSectAlpha =
							{
								order = 1,
								name = "Red Sector Alpha",
								desc = "How transparent is Red Annulus Sector",
								type = "range",
								min = 0,
								max = 1,
								step = 0.01,
								isPercent = true,
								get = function(info) return cfg.HUD.RedSectAlpha end,
								set =
									function(info,val)
										cfg.HUD.RedSectAlpha = val
										Arh_UpdateAlphaEverything(ARH_RED, false)
									end,
							},
							RedLineAlpha =
							{
								order = 2,
								name = "Red Line Alpha",
								desc = "How transparent is Red Direction Line",
								type = "range",
								min = 0,
								max = 1,
								step = 0.01,
								isPercent = true,
								get = function(info) return cfg.HUD.RedLineAlpha end,
								set =
									function(info,val)
										cfg.HUD.RedLineAlpha = val
										Arh_UpdateAlphaEverything(ARH_RED, true)
									end,
							},
							YellowSectAlpha =
							{
								order = 3,
								name = "Yellow Sector Alpha",
								desc = "How transparent is Yellow Annulus Sector",
								type = "range",
								min = 0,
								max = 1,
								step = 0.01,
								isPercent = true,
								get = function(info) return cfg.HUD.YellowSectAlpha end,
								set =
									function(info,val)
										cfg.HUD.YellowSectAlpha = val
										Arh_UpdateAlphaEverything(ARH_YELLOW, false)
									end,
							},
							YellowLineAlpha =
							{
								order = 4,
								name = "Yellow Line Alpha",
								desc = "How transparent is Yellow Direction Line",
								type = "range",
								min = 0,
								max = 1,
								step = 0.01,
								isPercent = true,
								get = function(info) return cfg.HUD.YellowLineAlpha end,
								set =
									function(info,val)
										cfg.HUD.YellowLineAlpha = val
										Arh_UpdateAlphaEverything(ARH_YELLOW, true)
									end,
							},
							GreenSectAlpha =
							{
								order = 5,
								name = "Green Sector Alpha",
								desc = "How transparent is Green Annulus Sector",
								type = "range",
								min = 0,
								max = 1,
								step = 0.01,
								isPercent = true,
								get = function(info) return cfg.HUD.GreenSectAlpha end,
								set =
									function(info,val)
										cfg.HUD.GreenSectAlpha = val
										Arh_UpdateAlphaEverything(ARH_GREEN, false)
									end,
							},
							GreenLineAlpha =
							{
								order = 6,
								name = "Green Line Alpha",
								desc = "How transparent is Green Direction Line",
								type = "range",
								min = 0,
								max = 1,
								step = 0.01,
								isPercent = true,
								get = function(info) return cfg.HUD.GreenLineAlpha end,
								set =
									function(info,val)
										cfg.HUD.GreenLineAlpha = val
										Arh_UpdateAlphaEverything(ARH_GREEN, true)
									end,
							},
						},
					},
				},
			},
			DigSites =
			{
				order = 4,
				name = "Dig Sites",
				desc = "Dig Sites settings",
				type = "group",
				args =
				{
					ShowOnBattlefieldMinimap =
					{
						order = 1,
						name = "Show digsites on the Battlefield Minimap",
						desc = "Use |cff69ccf0Shift-M|r to open or hide Battlefield Minimap",
						type = "toggle",
						width = "full",
						get = function(info) return cfg.DigSites.ShowOnBattlefieldMinimap end,
						set =
							function(info,val)
								cfg.DigSites.ShowOnBattlefieldMinimap = val
								SetVisible(Arh_ArchaeologyDigSites_BattlefieldMinimap, val)
							end,
					},
					ShowOnMinimap =
					{
						order = 2,
						name = "Show digsites on the Minimap",
						desc = "Digsites will be drawn outsite Minimap sometimes\nYou can also use |cff69ccf0/arh mm|r command to toggle this option",
						type = "toggle",
						width = "full",
						confirm = function(info) return not cfg.DigSites.ShowOnMinimap end,
						confirmText = "It will be buggy!",
						disabled = function(info) return GetCVar("rotateMinimap") == "1" end,
						get = function(info) return cfg.DigSites.ShowOnMinimap end,
						set =
							function(info,val)
								cfg.DigSites.ShowOnMinimap = val
								SetVisible(Arh_ArchaeologyDigSites_Minimap, val)
							end,
					},
					ShowOnMinimapNote =
					{
						order = 3,
						name = "NOTE: The way blizzard currently implement Digsites Frame does not allow to draw it correctly on the Minimap. Digsites sometimes will exceed Minimap area. Additionally Digsites can't be shown on rotating Minimap. This note does not apply to Battlefield Minimap.",
						type = "description",
					},
				},
			},

		}
}

function Arh_ShowTooltip(self)
	if not cfg.MainFrame.ShowTooltips then return end
	if not self.TooltipText then return end

	local text
	if type(self.TooltipText)=="string" then
		text = self.TooltipText
	elseif type(self.TooltipText)=="function" then
		text = self.TooltipText(self)
		if not text then return end
	end
	Arh_Tooltip:SetOwner(self, "ANCHOR_CURSOR")
	Arh_Tooltip:AddLine(text, 1, 1, 1)
	Arh_Tooltip:Show()
end
function Arh_HideTooltip(self)
	Arh_Tooltip:Hide()
end

local function SetTooltips()
	Arh_MainFrame.TooltipText =
								function(self)
									if cfg.MainFrame.Locked then
										return cs("Right Click")..": open configuration page"
									else
										return cs("Left Click")..": move window\n"..cs("Right Click")..": open configuration page"
									end
								end
	Arh_MainFrame_ButtonRed.TooltipText = cs("Left Click")..": add new red zone to the HUD\n"..cs("Right Click")..": show/hide all red areas on the HUD"
	Arh_MainFrame_ButtonYellow.TooltipText = cs("Left Click")..": add new yellow zone to the HUD\n"..cs("Right Click")..": show/hide all yellow areas on the HUD"
	Arh_MainFrame_ButtonGreen.TooltipText = cs("Left Click")..": add new green zone to the HUD\n"..cs("Right Click")..": show/hide all green areas on the HUD"
	Arh_MainFrame_ButtonDig.TooltipText = cs("Left Click")..": cast Survey\n"..cs("Right Click")..": show/hide HUD window\n"..cs("Middle Click")..": open archaeology window"
	Arh_MainFrame_ButtonBack.TooltipText = cs("Left Click")..": remove one previously added area"
end

local function RotateTexture(texture, angle)
	local cos, sin = math.cos(angle), math.sin(angle)
	local p, m = (sin+cos)/2, (sin-cos)/2
	local pp, pm, mp, mm = 0.5+p, 0.5+m, 0.5-p, 0.5-m
	texture:SetTexCoord(pm, mp, mp, mm, pp, pm, mm, pp)
end

local function CreateConTexture(parent, color)
	local t = parent:CreateTexture()
	t:SetBlendMode("ADD")
	t:SetPoint("CENTER", parent, "CENTER", 0, 0)
	t:SetTexture("Interface\\AddOns\\Arh\\img\\con1024_"..color)
	t:Show()

	return t
end

local function CreateLineTexture(parent, contexture, color)
	local t = parent:CreateTexture()
	t:SetBlendMode("ADD")
	t:SetPoint("CENTER", contexture, "CENTER", 0, 0)
	t:SetTexture("Interface\\AddOns\\Arh\\img\\line1024_"..color)
	t:Show()

	return t
end

local function SetTextureColor(texture, color, isline)
	local r,g,b,a
	if isline then
		if color == ARH_RED then
			r,g,b,a = 1,0,0,cfg.HUD.RedLineAlpha
		elseif color == ARH_YELLOW then
			r,g,b,a = 0.5,0.5,0,cfg.HUD.YellowLineAlpha
		elseif color == ARH_GREEN then
			r,g,b,a = 0,1,0,cfg.HUD.GreenLineAlpha
		end
	else
		if color == ARH_RED then
			r,g,b,a = 1,0,0,cfg.HUD.RedSectAlpha
		elseif color == ARH_YELLOW then
			r,g,b,a = 0.5,0.5,0,cfg.HUD.YellowSectAlpha
		elseif color == ARH_GREEN then
			r,g,b,a = 0,1,0,cfg.HUD.GreenSectAlpha
		end
	end
		
	texture:SetVertexColor(r,g,b,a)
end

local function PixelsInYardOnHud_Calc()
	local mapSizePix = Arh_HudFrame:GetHeight()

	local zoom = Minimap:GetZoom()
	local indoors = GetCVar("minimapZoom")+0 == Minimap:GetZoom() and "outdoor" or "indoor"
	local mapSizeYards = minimap_size[indoors][zoom]

	return mapSizePix/mapSizeYards
end
local PixelsInYardOnHud = -1


local function UpdateTextureSize(texture, color)
	texture:SetSize(PixelsInYardOnHud * CONYARDS[color]*2, PixelsInYardOnHud * CONYARDS[color]*2)
end

local function CreateCon(parent, color)
	local t = CreateConTexture(parent, color)
	SetTextureColor(t, color, false)
	UpdateTextureSize(t, color)

	return t
end
local function CreateLine(parent, color, contexture)
	local t = CreateLineTexture(parent, contexture, color)
	SetTextureColor(t, color, true)
	UpdateTextureSize(t, color)

	return t
end


local function UpdateConAndLine(texture_con, texture_line, color)
	UpdateTextureSize(texture_con, color)
	texture_con:Show()

	UpdateTextureSize(texture_line, color)
	texture_line:Show()
end

ConsCache = {[ARH_GREEN] = {["items"]={}, ["size"]=0}, [ARH_YELLOW] = {["items"]={}, ["size"]=0}, [ARH_RED] = {["items"]={}, ["size"]=0} }
ConsArray = {}
local ConsArraySize = 0
local function GetCached(color)
	if ConsCache[color].size > 0 then
		ConsCache[color].size = ConsCache[color].size - 1
		return ConsCache[color].items[ConsCache[color].size]
	else
		return nil
	end
end
function Arh_ReturnAllToCache()
	for i=0,ConsArraySize-1 do
		ConsArray[i].texture:Hide()
		ConsArray[i].texture_line:Hide()
		local c = ConsArray[i].color
		local cs = ConsCache[c].size
		ConsCache[c].items[cs] = {["texture"]=ConsArray[i].texture, ["texture_line"]=ConsArray[i].texture_line}
		ConsCache[c].size = cs+1
	end
	ConsArraySize = 0
end
function Arh_returnLastToCache()
	if ConsArraySize==0 then return end

	ConsArraySize = ConsArraySize-1
	local i = ConsArraySize

	ConsArray[i].texture:Hide()
	ConsArray[i].texture_line:Hide()
	local c = ConsArray[i].color
	local cs = ConsCache[c].size
	ConsCache[c].items[cs] = {["texture"]=ConsArray[i].texture, ["texture_line"]=ConsArray[i].texture_line}
	ConsCache[c].size = cs+1
end


local function AddCon(color, x, y, a)
	local item = GetCached(color)
	if item then
		ConsArray[ConsArraySize] = {["color"]=color, ["texture"]=item.texture, ["texture_line"]=item.texture_line, ["x"]=x, ["y"]=y, ["a"]=a}
		UpdateConAndLine(ConsArray[ConsArraySize].texture, ConsArray[ConsArraySize].texture_line, color)
		
	else
		ConsArray[ConsArraySize] = {["color"]=color, ["texture"]=CreateCon(Arh_HudFrame, color), ["texture_line"]=nil, ["x"]=x, ["y"]=y, ["a"]=a}
		ConsArray[ConsArraySize].texture_line = CreateLine(Arh_HudFrame, color, ConsArray[ConsArraySize].texture)
	end

	local visible
	if color==ARH_RED then
		visible = not Arh_MainFrame_ButtonRed.Canceled
	elseif color==ARH_YELLOW then
		visible = not Arh_MainFrame_ButtonYellow.Canceled
	elseif color==ARH_GREEN then
		visible = not Arh_MainFrame_ButtonGreen.Canceled
	end
	SetVisible(ConsArray[ConsArraySize].texture, visible)
	SetVisible(ConsArray[ConsArraySize].texture_line, visible)

	ConsArraySize = ConsArraySize+1
end

local function UpdateConsSizes()
	local piy = PixelsInYardOnHud_Calc()
	if piy == PixelsInYardOnHud then return end
	PixelsInYardOnHud = piy
	for i=0,ConsArraySize-1 do
		UpdateTextureSize(ConsArray[i].texture, ConsArray[i].color)
		UpdateTextureSize(ConsArray[i].texture_line, ConsArray[i].color)
	end
end

local function PlaceCon(id, player_x, player_y, player_a)
	local dx, dy = ConsArray[id].x-player_x, ConsArray[id].y-player_y
	local cos, sin = math.cos(player_a), math.sin(player_a)
	local x = dx*cos - dy*sin
	local y = dx*sin + dy*cos

	ConsArray[id].texture:ClearAllPoints()
	ConsArray[id].texture:SetPoint("CENTER", Arh_HudFrame, "CENTER", x*PixelsInYardOnHud, -y*PixelsInYardOnHud)
	RotateTexture(ConsArray[id].texture, ConsArray[id].a-player_a)

	RotateTexture(ConsArray[id].texture_line, ConsArray[id].a-player_a)
end

local function UpdateConsPositions(player_x, player_y, player_a)
	for i=0,ConsArraySize-1 do
		PlaceCon(i, player_x, player_y, player_a)
	end
end

function UpdateAlpha(texture, color, isline)
	local a
	if isline then
		if color == ARH_RED then
			a = cfg.HUD.RedLineAlpha
		elseif color == ARH_YELLOW then
			a = cfg.HUD.YellowLineAlpha
		elseif color == ARH_GREEN then
			a = cfg.HUD.GreenLineAlpha
		end
	else
		if color == ARH_RED then
			a = cfg.HUD.RedSectAlpha
		elseif color == ARH_YELLOW then
			a = cfg.HUD.YellowSectAlpha
		elseif color == ARH_GREEN then
			a = cfg.HUD.GreenSectAlpha
		end
	end

	texture:SetAlpha(a)
end

function Arh_UpdateAlphaEverything(color, isline)
	for i=0,ConsArraySize-1 do
		if color == ConsArray[i].color then
			if isline then
				UpdateAlpha(ConsArray[i].texture_line, color, true)
			else
				UpdateAlpha(ConsArray[i].texture, color, false)
			end
		end
	end
	for i=0,ConsCache[color].size-1 do
		if isline then
			UpdateAlpha(ConsCache[color].items[i].texture_line, color, true)
		else
			UpdateAlpha(ConsCache[color].items[i].texture, color, false)
		end
	end
end

local function UpdateCons(player_x, player_y, player_a)
	UpdateConsSizes() -- if minimap zoomed
	UpdateConsPositions(player_x, player_y, player_a)
end

function Arh_ToYards(x, y)
	local level = GetCurrentMapDungeonLevel();
	local map = GetCurrentMapAreaID();
	return MapData:PointToYards(map, level, x, y);	
end

local function Distance(xa, ya, xb, yb)
	return math.sqrt(math.pow(xa-xb,2)+math.pow(ya-yb,2))
end

local function CalcAngle(xa, ya, xb, yb)
	if ya == yb then
		if xa == xb then
			return 0;
		elseif xa > xb then
			return math.pi/2;
		else
			return 3*math.pi/2;
		end
	end
	local t = (xb-xa)/(yb-ya);
	local a = math.atan(t);
	if ya > yb then
		if xa == xb then
			return 0;
		elseif xa > xb then
			return a;
		else
			return a+2*math.pi;
		end
	else
		if xa == xb then
			return math.pi;
		elseif xa > xb then
			return a+math.pi;
		else
			return a+math.pi;
		end
	end
end

local function AddPoint(color)
	SetMapToCurrentZone();
	local x, y = GetPlayerMapPosition("player")
        local jax, jay = Arh_ToYards(x, y)
	a = GetPlayerFacing()

	AddCon(color, jax, jay, a)
end

function Arh_MainFrame_ButtonRed_OnLClick()
	AddPoint(ARH_RED)
end

function Arh_MainFrame_ButtonYellow_OnLClick()
	AddPoint(ARH_YELLOW)
end

function Arh_MainFrame_ButtonGreen_OnLClick()
	AddPoint(ARH_GREEN)
end

local function ToggleColor(color, visible)
	for i=0,ConsArraySize-1 do
		if ConsArray[i].color == color then
			SetVisible(ConsArray[i].texture, visible)
			SetVisible(ConsArray[i].texture_line, visible)
		end
	end
end

local function ToggleColorButton(self, color, enable)
	if enable~=nil then
		self.Canceled = not enable
	else
		self.Canceled = not self.Canceled
	end
	ToggleColor(color, not self.Canceled)
	SetVisible(self.CanceledTexture, self.Canceled)
end

function Arh_MainFrame_ButtonRed_OnRClick()
	ToggleColorButton(Arh_MainFrame_ButtonRed, ARH_RED)
end

function Arh_MainFrame_ButtonYellow_OnRClick()
	ToggleColorButton(Arh_MainFrame_ButtonYellow, ARH_YELLOW)
end

function Arh_MainFrame_ButtonGreen_OnRClick()
	ToggleColorButton(Arh_MainFrame_ButtonGreen, ARH_GREEN)
end

function Arh_MainFrame_ButtonRed_OnMouseDown(self, button)
	if button == "LeftButton" then
		Arh_MainFrame_ButtonRed_OnLClick()
	elseif button == "RightButton" then
		Arh_MainFrame_ButtonRed_OnRClick()
	end
end

function Arh_MainFrame_ButtonYellow_OnMouseDown(self, button)
	if button == "LeftButton" then
		Arh_MainFrame_ButtonYellow_OnLClick()
	elseif button == "RightButton" then
		Arh_MainFrame_ButtonYellow_OnRClick()
	end
end

function Arh_MainFrame_ButtonGreen_OnMouseDown(self, button)
	if button == "LeftButton" then
		Arh_MainFrame_ButtonGreen_OnLClick()
	elseif button == "RightButton" then
		Arh_MainFrame_ButtonGreen_OnRClick()
	end
end

function Arh_MainFrame_ButtonBack_OnLClick()
	Arh_returnLastToCache()
end

function Arh_MainFrame_ButtonBack_OnMouseDown(self, button)
	if button == "LeftButton" then
		Arh_MainFrame_ButtonBack_OnLClick()
	elseif button == "RightButton" then
	end
end

function SaveDifs()
	SetMapToCurrentZone()
	local px, py = GetPlayerMapPosition("player")
	local japx, japy = Arh_ToYards(px, py)

	for i=0,ConsArraySize-1 do
		local jad = Distance(ConsArray[i].x, ConsArray[i].y, japx, japy)

		local ra = CalcAngle(ConsArray[i].x, ConsArray[i].y, japx, japy)
		local ad = ra-a
		while ad > 2*math.pi do ad = ad - 2*math.pi end
		while ad < 0 do ad = ad + 2*math.pi end
		if ad > math.pi then ad = ad - 2*math.pi end

		if Arh_Data == nil then
			Arh_Data = {["next"]=1, ["items"]={}}
		end
		Arh_Data.items[Arh_Data.next] = {[1]=ConsArray[i].color, [2]=jad, [3]=ad}
		Arh_Data.next = Arh_Data.next + 1
	end
end

function OnGathering()
--	SaveDifs()
	Arh_ReturnAllToCache()
	ToggleColorButton(Arh_MainFrame_ButtonRed, ARH_RED, true)
	ToggleColorButton(Arh_MainFrame_ButtonYellow, ARH_YELLOW, true)
	ToggleColorButton(Arh_MainFrame_ButtonGreen, ARH_GREEN, true)
end

function Arh_MainFrame_ButtonDig_OnRClick()
	Arh_MainFrame_ButtonDig.Canceled = not Arh_MainFrame_ButtonDig.Canceled
	SetVisible(Arh_MainFrame_ButtonDig.CanceledTexture, Arh_MainFrame_ButtonDig.Canceled)
	SetVisible(Arh_HudFrame, not Arh_MainFrame_ButtonDig.Canceled)
end

local function ShowArchaeologyFrame()
	if IsAddOnLoaded("Blizzard_ArchaeologyUI") then
		ShowUIPanel(ArchaeologyFrame)
		return true
	else
		local loaded, reason = LoadAddOn("Blizzard_ArchaeologyUI")
		if loaded then
			ShowUIPanel(ArchaeologyFrame)
			return true
		else
			return false
		end
	end
end

function Arh_MainFrame_ButtonDig_OnMouseDown(self, button)
	if button == "LeftButton" then
	elseif button == "RightButton" then
		Arh_MainFrame_ButtonDig_OnRClick()
	elseif button == "MiddleButton" then
		ShowArchaeologyFrame()
	end
end

local function ToggleMainFrame()
	cfg.MainFrame.Visible = not Arh_MainFrame:IsVisible()
	SetVisible(Arh_MainFrame, cfg.MainFrame.Visible)
end

local function OnHelp()
	local function os(str1, str2)
		return cs(str1)..", "..cs(str2)
	end
	print("Arguments to "..cs("/arh")..":")
	print("  "..os("toggle","t").." - hide/show main window")
	print("  "..os("hud","h").." - hide/show HUD window")
	print("  "..os("addred","ar").." - add new red zone to the HUD")
	print("  "..os("addyellow","ay").." - add new yellow zone to the HUD")
	print("  "..os("addgreen","ag").." - add new green zone to the HUD")
	print("  "..os("togglered","tr").." - show/hide all red areas on the HUD")
	print("  "..os("toggleyellow","ty").." - show/hide all yellow areas on the HUD")
	print("  "..os("togglegreen","tg").." - show/hide all green areas on the HUD")
	print("  "..os("back","b").." - remove one previously added area")
	print("  "..os("clear","c").." - clear HUD")
	print("  "..os("minimap","mm").." - hide/show buggy digsites on minimap")
end

local function handler(msg, editbox)
	if msg=='' then
		OnHelp()
	elseif msg=='toggle' or msg=='t' then
		ToggleMainFrame()
	elseif msg=='hud' or msg=='h' then
		Arh_MainFrame_ButtonDig_OnRClick()

	elseif msg=='addred' or msg=='ar' then
		Arh_MainFrame_ButtonRed_OnLClick()
	elseif msg=='addyellow' or msg=='ay' then
		Arh_MainFrame_ButtonYellow_OnLClick()
	elseif msg=='addgreen' or msg=='ag' then
		Arh_MainFrame_ButtonGreen_OnLClick()


	elseif msg=='togglered' or msg=='tr' then
		Arh_MainFrame_ButtonRed_OnRClick()
	elseif msg=='toggleyellow' or msg=='ty' then
		Arh_MainFrame_ButtonYellow_OnRClick()
	elseif msg=='togglegreen' or msg=='tg' then
		Arh_MainFrame_ButtonGreen_OnRClick()

	elseif msg=='back' or msg=='b' then
		Arh_MainFrame_ButtonBack_OnLClick()
	elseif msg=='clear' or msg=='c' then
		Arh_ReturnAllToCache()


	elseif msg=='minimap' or msg=='mm' then
		if Arh_ArchaeologyDigSites_Minimap:IsVisible() then
			cfg.DigSites.ShowOnMinimap = false
			Arh_ArchaeologyDigSites_Minimap:Hide()
		else
			cfg.DigSites.ShowOnMinimap = true
			Arh_ArchaeologyDigSites_Minimap:Show()
		end
	else
		print("unknown command: "..msg)
		print("use |cffffff78/arh|r for help on commands")
	end
end
SlashCmdList["ARH"] = handler;
SLASH_ARH1 = "/arh"

local function OnSpellSent(unit,spellcast,rank,target)
	if unit ~= "player" then return end
	if spellcast==GetSpellInfo(73979) then -- "Searching for Artifacts"
		OnGathering()
	end
end

local function OnAddonLoaded(name)
	if name=="Arh" then
		if not Arh_Config then Arh_Config = CopyByValue(Arh_DefaultConfig) end
		cfg = Arh_Config
		Arh_MainFrame_Init()
		Arh_HudFrame_Init()
	end
end

function Arh_MainFrame_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		OnAddonLoaded(...)
	elseif event == "UNIT_SPELLCAST_SENT" then
		OnSpellSent(...)
	end
end

function Arh_MainFrame_OnLoad()
	Arh_MainFrame:RegisterEvent("ADDON_LOADED")
end

local function InitCancelableButton(self)
	local t = self:CreateTexture()
	t:SetPoint("CENTER", self, "CENTER", 0, 0)
	t:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
	t:SetSize(20, 20)
	t:SetDrawLayer("ARTWORK", 1)
	t:Hide()
	self.CanceledTexture = t
	self.Canceled = false
end

function Arh_MainFrame_Init()
	MapData = LibStub("LibMapData-1.0")

	Config = LibStub("AceConfig-3.0")
	ConfigDialog = LibStub("AceConfigDialog-3.0")
	Config:RegisterOptionsTable("Archaeology Helper Options", OptionsTable, "arhcfg")
	ConfigDialog:AddToBlizOptions("Archaeology Helper Options", "Arh")

	SetVisible(Arh_MainFrame, cfg.MainFrame.Visible)
	Arh_MainFrame:SetScale(cfg.MainFrame.Scale)
	Arh_MainFrame:SetAlpha(cfg.MainFrame.Alpha)

	Arh_MainFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
	SetTooltips()

	if BattlefieldMinimap then
		Arh_ArchaeologyDigSites_BattlefieldMinimap:SetParent(BattlefieldMinimap)
		Arh_ArchaeologyDigSites_BattlefieldMinimap:ClearAllPoints()
		Arh_ArchaeologyDigSites_BattlefieldMinimap:SetPoint("TOPLEFT", BattlefieldMinimap)
		Arh_ArchaeologyDigSites_BattlefieldMinimap:SetPoint("BOTTOMRIGHT", BattlefieldMinimap)
		SetVisible(Arh_ArchaeologyDigSites_BattlefieldMinimap, cfg.DigSites.ShowOnBattlefieldMinimap)
	end

	Arh_ArchaeologyDigSites_Minimap:ClearAllPoints()
	Arh_ArchaeologyDigSites_Minimap:SetParent(Minimap)
	Arh_ArchaeologyDigSites_Minimap:EnableMouse(false)
	Arh_ArchaeologyDigSites_Minimap:SetFrameStrata("BACKGROUND")
	if GetCVar("rotateMinimap") == "0" then
		SetVisible(Arh_ArchaeologyDigSites_Minimap, cfg.DigSites.ShowOnMinimap)
	end

	InitCancelableButton(Arh_MainFrame_ButtonRed)
	InitCancelableButton(Arh_MainFrame_ButtonYellow)
	InitCancelableButton(Arh_MainFrame_ButtonGreen)
	InitCancelableButton(Arh_MainFrame_ButtonDig)

	Arh_MainFrame_ButtonDig.CanceledTexture:SetSize(30, 30)
	Arh_MainFrame_ButtonDig.CanceledTexture:Show()
	Arh_MainFrame_ButtonDig.Canceled = true
	Arh_MainFrame_ButtonDig:SetAttribute("spell", GetSpellInfo(80451))

	Arh_MainFrame_ButtonRed:SetHitRectInsets(6,6,6,6)
	Arh_MainFrame_ButtonYellow:SetHitRectInsets(6,6,6,6)
	Arh_MainFrame_ButtonGreen:SetHitRectInsets(6,6,6,6)

	Arh_MainFrame_ButtonBack:SetHitRectInsets(0,0,6,6)
end

local MainFrameIsMoving = false
function Arh_MainFrame_OnMouseDown(self, button)
	if button == "LeftButton" then
		if Arh_MainFrame:IsMovable() and not cfg.MainFrame.Locked then
			Arh_MainFrame:StartMoving()
			MainFrameIsMoving = true
		end
	elseif button == "RightButton" then
		InterfaceOptionsFrame_OpenToCategory("Arh")
	end
end

function Arh_MainFrame_OnMouseUp(self, button)
	if button == "LeftButton" then
		if Arh_MainFrame:IsMovable() and not cfg.MainFrame.Locked then
			MainFrameIsMoving = false
			Arh_MainFrame:StopMovingOrSizing()
		end
	elseif button == "RightButton" then
	end
end

function Arh_MainFrame_OnHide()
	if MainFrameIsMoving then
		MainFrameIsMoving = false
		Arh_MainFrame:StopMovingOrSizing()
	end
end

local function RePositionDigSites_Minimap(self)
	local x, y = GetPlayerMapPosition("player");
	local dx=(x-0.5)*self:GetWidth();
	local dy=(y-0.5)*self:GetHeight();
	self:ClearAllPoints();
	self:SetPoint("CENTER", Minimap, "CENTER", -dx, dy);
end
local old_pw, old_ph = -1, -1
local function UpdateDigSitesSize_Minimap(self)
	local mapWidth = self:GetParent():GetWidth()
	local mapHeight = self:GetParent():GetHeight()
	local mapSizePix = math.min(mapWidth, mapHeight);

	local indoors = GetCVar("minimapZoom")+0 == Minimap:GetZoom() and "outdoor" or "indoor"
	local zoom = Minimap:GetZoom()
	local mapSizeYards = minimap_size[indoors][zoom]

	local yw, yh = MapData:MapArea(GetCurrentMapAreaID(), GetCurrentMapDungeonLevel())
	local pw = yw*mapSizePix/mapSizeYards
	local ph = yh*mapSizePix/mapSizeYards

	if pw==old_pw and ph==oldph then return end
	old_pw, old_ph = pw, ph

	self:SetSize(pw, ph);
end

function Arh_ArchaeologyDigSites_OnLoad(self)
	self:SetFillAlpha(128);
	self:SetFillTexture("Interface\\WorldMap\\UI-ArchaeologyBlob-Inside");
	self:SetBorderTexture("Interface\\WorldMap\\UI-ArchaeologyBlob-Outside");
	self:EnableSmoothing(true);
	--self:SetNumSplinePoints(30);
	self:SetBorderScalar(0.1);
end

function Arh_ArchaeologyDigSites_BattlefieldMinimap_OnUpdate(self, elapsed)
	self:DrawNone()
	local numEntries = ArchaeologyMapUpdateAll()
	for i = 1, numEntries do
		local blobID = ArcheologyGetVisibleBlobID(i)
		self:DrawBlob(blobID, true)
	end
end

function Arh_ArchaeologyDigSites_Minimap_OnUpdate(self, elapsed)
	self:DrawNone()
	RePositionDigSites_Minimap(self)
	UpdateDigSitesSize_Minimap(self)
	local numEntries = ArchaeologyMapUpdateAll()
	for i = 1, numEntries do
		local blobID = ArcheologyGetVisibleBlobID(i)
		self:DrawBlob(blobID, true)
	end
end

local UIParent_Height_old = -1
local MinimapScale_old = -1
function Arh_UpdateHudFrameSizes(force)
	local UIParent_Height = UIParent:GetHeight()

	local zoom = Minimap:GetZoom()
	local indoors = GetCVar("minimapZoom")+0 == Minimap:GetZoom() and "outdoor" or "indoor"
	local MinimapScale = minimap_scale[indoors][zoom]

	if not force then
		if UIParent_Height==UIParent_Height_old and MinimapScale==MinimapScale_old then return end
	end
	MinimapScale_old = MinimapScale
	UIParent_Height_old = UIParent_Height

-- HUD Frame
	Arh_HudFrame:SetScale(cfg.HUD.Scale)
	local size = UIParent_Height / cfg.HUD.Scale
	Arh_HudFrame:SetSize(size, size)

	local HudPixelsInYard = size / minimap_size[indoors][zoom]

-- Success Circle
	local success_diameter = 16 * HudPixelsInYard
	Arh_HudFrame.SuccessCircle:SetSize(success_diameter, success_diameter)

-- Compass
	local compass_radius = cfg.HUD.CompassRadius * HudPixelsInYard
	local compass_diameter = 2 * compass_radius
	Arh_HudFrame.CompassCircle:SetSize(compass_diameter, compass_diameter)
	local radius = size * (0.45/2) * MinimapScale
	for k, v in ipairs(Arh_HudFrame.CompasDirections) do
		v.radius = compass_radius
	end
end

function Arh_HudFrame_OnLoad()
end

function Arh_HudFrame_Init()
	Arh_HudFrame.GetZoom = function(...) return Minimap:GetZoom(...) end
	Arh_HudFrame.SetZoom = function(...) end

-- HUD Frame
	Arh_HudFrame:SetParent("UIParent")
	Arh_HudFrame:ClearAllPoints()
	Arh_HudFrame:SetPoint("CENTER")
	Arh_HudFrame:EnableMouse(false)
	Arh_HudFrame:SetFrameStrata("BACKGROUND")

	Arh_HudFrame:SetScale(cfg.HUD.Scale)
	Arh_HudFrame:SetAlpha(cfg.HUD.Alpha)

-- Arrow
	SetVisible(Arh_HudFrame_ArrowFrame, cfg.HUD.ShowArrow)
	Arh_HudFrame_ArrowFrame:SetScale(cfg.HUD.ArrowScale)
	Arh_HudFrame_ArrowFrame:SetAlpha(cfg.HUD.ArrowAlpha)

-- Success Circle
	local circle = Arh_HudFrame:CreateTexture()
	circle:SetTexture([[SPELLS\CIRCLE.BLP]])
	circle:SetBlendMode("ADD")
	circle:SetPoint("CENTER")
	local c = cfg.HUD.SuccessCircleColor
	circle:SetVertexColor(c.r,c.g,c.b,c.a)
	SetVisible(circle, cfg.HUD.ShowSuccessCircle)
	Arh_HudFrame.SuccessCircle = circle

-- Compass Circle
	circle = Arh_HudFrame:CreateTexture()
	circle:SetTexture([[SPELLS\CIRCLE.BLP]])
	circle:SetBlendMode("ADD")
	circle:SetPoint("CENTER")
	c = cfg.HUD.CompassColor
	circle:SetVertexColor(c.r,c.g,c.b,c.a)
	SetVisible(circle, cfg.HUD.ShowCompass)
	Arh_HudFrame.CompassCircle = circle

-- Compass Text
	local directions = {}
	local indicators = {"N", "NE", "E", "SE", "S", "SW", "W", "NW"}
	for k, v in ipairs(indicators) do
		local a = ((math.pi/4) * (k-1))
		local ind = Arh_HudFrame:CreateFontString(nil, nil, "GameFontNormalSmall")
		ind:SetText(v)
		ind:SetShadowOffset(0.2,-0.2)
		ind:SetTextHeight(20)
		ind.angle = a
		c = cfg.HUD.CompassTextColor
		ind:SetTextColor(c.r,c.g,c.b,c.a)
		SetVisible(ind, cfg.HUD.ShowCompass)
		tinsert(directions, ind)
	end
	Arh_HudFrame.CompasDirections = directions
end

local last_update_hud = 0
function Arh_HudFrame_OnUpdate(frame, elapsed)
	last_update_hud = last_update_hud + elapsed
	--if last_update_hud > 0.05 then
	if last_update_hud > 0 then

		local px, py = GetPlayerMapPosition("player")
		local pa = GetPlayerFacing()
		local japx, japy = Arh_ToYards(px, py);
		UpdateCons(japx, japy, GetPlayerFacing())

		Arh_UpdateHudFrameSizes()
		
		if cfg.HUD.ShowCompass then
			for k, v in ipairs(Arh_HudFrame.CompasDirections) do
				local x, y = math.sin(v.angle + pa), math.cos(v.angle + pa)
				v:ClearAllPoints()
				v:SetPoint("CENTER", Arh_HudFrame, "CENTER", x * v.radius, y * v.radius)
			end
		end

		last_update_hud = 0
	end
end

local OriginalRotationFlag
local function UseGatherMate2(use)
	if not GatherMate2 then return end
	if use then
		OriginalRotationFlag = GetCVar("rotateMinimap")
		GatherMate2:GetModule("Display"):ReparentMinimapPins(Arh_HudFrame)
		GatherMate2:GetModule("Display"):ChangedVars(nil, "ROTATE_MINIMAP", "1")
	else
		GatherMate2:GetModule("Display"):ReparentMinimapPins(Minimap)
		GatherMate2:GetModule("Display"):ChangedVars(nil, "ROTATE_MINIMAP", OriginalRotationFlag)
	end
end

function Arh_SetUseGatherMate2(use)
	if Arh_HudFrame:IsVisible() then
		if cfg.HUD.UseGatherMate2 and not use then
			UseGatherMate2(false)
		end
		if use and not cfg.HUD.UseGatherMate2 then
			UseGatherMate2(true)
		end
	end
	cfg.HUD.UseGatherMate2 = use
end


function Arh_HudFrame_OnShow(self)
	if cfg.HUD.UseGatherMate2 then
		UseGatherMate2(true)
	end
end
function Arh_HudFrame_OnHide(self)
	if cfg.HUD.UseGatherMate2 then
		UseGatherMate2(false)
	end
end
