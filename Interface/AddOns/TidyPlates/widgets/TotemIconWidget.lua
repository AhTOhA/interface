--------------------
-- Totem Icon Widget
--------------------

local function TotemName(SpellID)
	local name = (select(1,GetSpellInfo(SpellID)))
	return name
end

local function TotemIcon(SpellID)
	local icon = (select(3,GetSpellInfo(SpellID)))
	return icon
end

local Totem_InfoTable = {
	-- Air Totems
	[TotemName(8177)] = TotemIcon(8177), -- Grounding Totem
	[TotemName(8512)] = TotemIcon(8512), -- Windfury Totem
	[TotemName(3738)] = TotemIcon(3738), -- Wrath of Air Totem
	-- Earth Totems
	[TotemName(2062)] = TotemIcon(2062), -- Earth Elemental Totem
	[TotemName(2484)] = TotemIcon(2484), -- Earthbind Totem
	[TotemName(5730)] = TotemIcon(5730), -- Stoneclaw Totem
	[TotemName(8071)] = TotemIcon(8071), -- Stoneskin Totem
	[TotemName(8075)] = TotemIcon(8075), -- Strength of Earth Totem
	[TotemName(8143)] = TotemIcon(8143), -- Tremor Totem
	-- Fire Totems
	[TotemName(2894)] = TotemIcon(2894), -- Fire Elemental Totem
	[TotemName(8227)] = TotemIcon(8227), -- Flametongue Totem
	[TotemName(8190)] = TotemIcon(8190), -- Magma Totem
	[TotemName(3599)] = TotemIcon(3599), -- Searing Totem
	-- Water Totems
	[TotemName(8184)] = TotemIcon(8184), -- Elemental Resistance Totem
	[TotemName(5394)] = TotemIcon(5394), -- Healing Stream Totem
	[TotemName(5675)] = TotemIcon(5675), -- Mana Spring Totem
	[TotemName(16190)] = TotemIcon(16190), -- Mana Tide Totem
	[TotemName(87718)] = TotemIcon(87718) -- Totem of Tranquil Mind
}

local function IsTotem(name) if name then return (Totem_InfoTable[name] ~= nil) end end

local function UpdateTotemIconWidget(self, unit)
	local icon = Totem_InfoTable[unit.name]
	if icon then
		self.Icon:SetTexture(icon)
		self:Show()
	else 
		self:Hide() 
	end
end

local function CreateTotemIconWidget(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetWidth(16); frame:SetHeight(16)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetPoint("CENTER",frame)
	frame.Icon:SetAllPoints(frame)
	frame:Hide()
	frame.Update = UpdateTotemIconWidget
	return frame
end

TidyPlatesWidgets.CreateTotemIconWidget = CreateTotemIconWidget
TidyPlatesUtility.IsTotem = IsTotem
