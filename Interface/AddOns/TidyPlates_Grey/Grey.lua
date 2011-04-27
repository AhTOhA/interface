-----------------------------------------------------
-- Tidy Plates Grey
-----------------------------------------------------
local Theme = {}
local CopyTable = TidyPlatesUtility.copyTable

local defaultArtPath = "Interface\\Addons\\TidyPlates_Grey\\Media"
local font =					defaultArtPath.."\\LiberationSans-Regular.ttf"
local blizzfont =				NAMEPLATE_FONT
--local blizzfont =					"FONTS\\ARIALN.TTF"
local nameplate_verticalOffset = -5
local castBar_verticalOffset = -6 -- Adjust Cast Bar distance

local StyleDefault = {}

StyleDefault.hitbox = { width = 140, height = 35, }

StyleDefault.highlight = {
	texture =					defaultArtPath.."\\Highlight",
}

StyleDefault.healthborder = {
	texture		 =				defaultArtPath.."\\RegularBorder",
	glowtexture =					defaultArtPath.."\\Highlight",
	--texture =					defaultArtPath.."\\EliteBorder",
	width = 128,
	height = 64,
	x = 0,
	y = nameplate_verticalOffset,
	anchor = "CENTER",
}

StyleDefault.eliteicon = {
	texture = defaultArtPath.."\\EliteIcon",
	width = 14,
	height = 14,
	x = -51,
	y = 17,
	anchor = "CENTER",
	show = true,
}

StyleDefault.target = {
	texture = defaultArtPath.."\\TargetBox",
	width = 128,
	height = 64,
	x = 0,
	y = nameplate_verticalOffset,
	anchor = "CENTER",
	show = true,
}

StyleDefault.threatborder = {
	texture =			defaultArtPath.."\\RegularThreat",
	elitetexture =			defaultArtPath.."\\EliteThreat",
	width = 128,
	height = 64,
	x = 0,
	y = nameplate_verticalOffset,
	anchor = "CENTER",
}

StyleDefault.castborder = {
	texture =					defaultArtPath.."\\CastStoppable",
	width = 128,
	height = 64,
	x = 0,
	y = 0 +castBar_verticalOffset+nameplate_verticalOffset,
	anchor = "CENTER",
}

StyleDefault.castnostop = {
	texture = 				defaultArtPath.."\\CastNotStoppable",
	width = 128,
	height = 64,
	x = 0,
	y = 0+castBar_verticalOffset+nameplate_verticalOffset,
	anchor = "CENTER",
}

StyleDefault.name = {
	typeface =					font,
	size = 9,
	width = 100,
	height = 10,
	x = 0,
	y = 6+nameplate_verticalOffset,
	align = "LEFT",
	anchor = "LEFT",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
}

StyleDefault.level = {
	typeface =					font,
	size = 9,
	width = 25,
	height = 10,
	x = 36,
	y = 6+nameplate_verticalOffset,
	align = "RIGHT",
	anchor = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
}

StyleDefault.healthbar = {
	texture =					 defaultArtPath.."\\Statusbar",
	backdrop = 				defaultArtPath.."\\Empty",
	--backdrop = 				defaultArtPath.."\\Statusbar",
	height = 12,
	width = 101,
	x = 0,
	y = 15+nameplate_verticalOffset,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
}

StyleDefault.castbar = {
	texture =					defaultArtPath.."\\Statusbar",
	backdrop = 				defaultArtPath.."\\Empty",
	--backdrop = 				defaultArtPath.."\\Statusbar",
	height = 12,
	width = 99,
	x = 0,
	y = -8+castBar_verticalOffset+nameplate_verticalOffset,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
}

StyleDefault.customtext = {
	typeface =					font,
	size = 9,
	width = 93,
	height = 10,
	x = 0,
	y = 16+nameplate_verticalOffset,
	align = "RIGHT",
	anchor = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = true,
}

StyleDefault.spelltext = {
	typeface =					font,
	size = 8,
	width = 100,
	height = 10,
	x = 1,
	y = castBar_verticalOffset-8+nameplate_verticalOffset,
	align = "LEFT",
	anchor = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = true,
}

StyleDefault.spellicon = {
	width = 18,
	height = 18,
	x = 62,
	y = -8+castBar_verticalOffset+nameplate_verticalOffset,
	anchor = "CENTER",
}

StyleDefault.raidicon = {
	width = 20,
	height = 20,
	x = -35,
	y = 12+nameplate_verticalOffset,
	anchor = "TOP",
}

StyleDefault.dangerskull = {
	width = 14,
	height = 14,
	x = 44,
	y = 8+nameplate_verticalOffset,
	anchor = "CENTER",
}

StyleDefault.frame = {
	width = 101,
	height = 45,
	x = 0,
	y = 0+nameplate_verticalOffset,
	anchor = "CENTER",
}

StyleDefault.threatcolor = {
	LOW = {r = .6, g = 1, b = 0, a = 1,},
	MEDIUM = {r = .6, g = 1, b = 0, a = 1,},
	HIGH = {r = 1, g = 0, b = 0, a= 1,},  }

local WidgetConfig = {}
WidgetConfig.ClassIcon = { anchor = "TOP" , x = -32 ,y = 7 }
--WidgetConfig.TotemIcon = { anchor = "TOP" , x = -28 ,y = 12 }
WidgetConfig.TotemIcon = { anchor = "TOP" , x = 0 ,y = 10 }
WidgetConfig.ThreatLineWidget = { anchor =  "CENTER", x = 0 ,y = 18 }
WidgetConfig.ThreatWheelWidget = { anchor =  "CENTER", x = 31 ,y = 23 } -- "CENTER", plate, 30, 18
WidgetConfig.ComboWidget = { anchor = "CENTER" , x = 0 ,y = 24 }
WidgetConfig.RangeWidget = { anchor = "CENTER" , x = 0 ,y = 12 }
WidgetConfig.DebuffWidget = { anchor = "CENTER" , x = 15 ,y = 35 }

local DamageThemeName = "Grey/|cFFFF4400Damage"
local TankThemeName = "Grey/|cFF3782D1Tank"
-- local DamageThemeStyle


SLASH_GREYTANK1 = '/greytank'
SlashCmdList['GREYTANK'] = ShowTidyPlatesHubTankPanel

SLASH_GREYDPS1 = '/greydps'
SlashCmdList['GREYDPS'] = ShowTidyPlatesHubDamagePanel

---------------------------------------------
-- Tidy Plates Hub Integration
---------------------------------------------
Theme["Default"] = StyleDefault
local function StyleDelegate(unit)
	return "Default"
end
Theme.SetStyle = StyleDelegate

TidyPlatesThemeList[DamageThemeName] = Theme
local LocalVars = TidyPlatesHubDamageVariables

local function OnApplyThemeCustomization(theme)
	local style = theme["Default"]
	style.level.show = (LocalVars.TextShowLevel == true)
	style.target.show = (LocalVars.WidgetTargetHighlight == true)
	style.eliteicon.show = (LocalVars.WidgetEliteIndicator == true)
	style.frame.y = ((LocalVars.FrameVerticalPosition-.5)*50)-5

	-- [[ Font
	local currentFont = font
	if LocalVars.TextUseBlizzardFont then
		currentFont = blizzfont
	end
	style.name.typeface = currentFont
	style.level.typeface = currentFont
	style.customtext.typeface = currentFont
	style.spelltext.typeface = currentFont
	--]]
	
	TidyPlates:ForceUpdate()
end

local function OnApplyDamageCustomization()
	OnApplyThemeCustomization(Theme)
end

local function OnInitialize(plate)
	TidyPlatesHubFunctions.OnInitializeWidgets(plate, WidgetConfig)
end

local function OnActivateTheme(themeTable)
		if Theme == themeTable then
			LocalVars = TidyPlatesHubFunctions:UseDamageVariables()
			OnApplyDamageCustomization()
		end
end

Theme.SetNameColor = TidyPlatesHubFunctions.SetNameColor
Theme.SetScale = TidyPlatesHubFunctions.SetScale
Theme.SetAlpha = TidyPlatesHubFunctions.SetAlpha
Theme.SetHealthbarColor = TidyPlatesHubFunctions.SetHealthbarColor
Theme.SetThreatColor = TidyPlatesHubFunctions.SetThreatColor
Theme.SetCastbarColor = TidyPlatesHubFunctions.SetCastbarColor
Theme.SetCustomText = TidyPlatesHubFunctions.SetCustomText
Theme.OnUpdate = TidyPlatesHubFunctions.OnUpdate
Theme.OnContextUpdate = TidyPlatesHubFunctions.OnContextUpdate
Theme.ShowConfigPanel = ShowTidyPlatesHubDamagePanel

Theme.OnInitialize = OnInitialize		-- Need to provide widget positions
Theme.OnActivateTheme = OnActivateTheme -- called by Tidy Plates Core, Theme Loader
Theme.OnApplyThemeCustomization = OnApplyDamageCustomization -- Called By Hub Panel

do
	local TankTheme = CopyTable(Theme)
	TidyPlatesThemeList[TankThemeName] = TankTheme
	
	local function OnApplyTankCustomization()
		OnApplyThemeCustomization(TankTheme)  -- OnApplyTankCustomization
	end

	local function OnActivateTheme(themeTable)
		if TankTheme == themeTable then
			LocalVars = TidyPlatesHubFunctions:UseTankVariables()
			OnApplyTankCustomization()
		end
	end
	
	TankTheme.OnActivateTheme = OnActivateTheme -- called by Tidy Plates Core, Theme Loader
	TankTheme.OnApplyThemeCustomization = OnApplyTankCustomization -- Called By Hub Panel
	TankTheme.ShowConfigPanel = ShowTidyPlatesHubTankPanel
end







