-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Crafting - AddOn by Sapu94							 		  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_crafting.aspx    --
-- ------------------------------------------------------------------------------------- --


-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TradeSkillMaster_Crafting", "AceEvent-3.0", "AceConsole-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Crafting") -- loads the localization table
TSM.version = GetAddOnMetadata("TradeSkillMaster_Crafting","X-Curse-Packaged-Version") or GetAddOnMetadata("TradeSkillMaster_Crafting", "Version") -- current version of the addon

local GOLD_TEXT = "|cffffd700g|r"
local SILVER_TEXT = "|cffc7c7cfs|r"
local COPPER_TEXT = "|cffeda55fc|r"

-- stuff for debugging TSM
function TSM:Debug(...)
	if TSMCRAFTINGDEBUG then
		print(...)
	end
end
local debug = function(...) TSM:Debug(...) end

-- default values for the savedDB
local savedDBDefaults = {
	global = {
		treeStatus = {[2] = true, [5] = true},
		queueSort = "profit",
		queueSortDescending = true,
	},
	-- data that is stored per user profile
	profile = {
		matLock = {}, -- table of which material costs are locked ('lock mat costs' tab)
		profitPercent = 0, -- percentage to subtract from buyout when calculating profit (5% = AH cut)
		matCostSource = "DBMarket", -- how to calculate the cost of materials
		craftCostSource = "DBMarket",
		craftHistory = {}, -- stores a history of what crafts were crafted
		queueMinProfitGold = {default = 50},
		queueMinProfitPercent = {default = 0.5},
		restockAH = true,
		altAddon = "Gathering",
		altGuilds = {},
		altCharacters = {},
		queueProfitMethod = {default = "gold"},
		doubleClick = 2,
		maxRestockQuantity = {default = 3},
		seenCountFilterSource = "",
		seenCountFilter = 0,
		ignoreSeenCountFilter = {},
		minRestockQuantity = {default = 1},
		dontQueue = {},
		craftManagementWindowScale = 1,
		inscriptionGrouping = 2,
		closeTSMWindow = true,
		lastScan = {},
		alwaysQueue = {},
		craftSortMethod = {default = "name"},
		craftSortOrder = {default = "ascending"},
		unknownProfitMethod = {default = "unknown"},
		enableNewTradeskills = false,
		showPercentProfit = true,
		tooltip = true,
	},
}

-- Called once the player has loaded WOW.
function TSM:OnEnable()
	TSM.tradeSkills = {{name="Enchanting", spellID=7411}, {name="Inscription", spellID=45357},
		{name="Jewelcrafting", spellID=25229}, {name="Alchemy", spellID=2259},
		{name="Blacksmithing", spellID=2018}, {name="Leatherworking", spellID=2108},
		{name="Tailoring", spellID=3908}, {name="Engineering", spellID=4036},
		{name="Cooking", spellID=2550}}--, {name="Smelting", spellID=2656}}
	
	-- load TradeSkillMaster_Crafting's modules
	TSM.Data = TSM.modules.Data
	TSM.Scan = TSM.modules.Scan
	TSM.GUI = TSM.modules.GUI
	TSM.Crafting = TSM.modules.Crafting
	
	-- load all the profession modules
	for _, data in ipairs(TSM.tradeSkills) do
		TSM[data.name] = TSM.modules[data.name]
	end
	
	-- load the savedDB into TSM.db
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_CraftingDB", savedDBDefaults, true)
	TSM.Data:Initialize() -- setup TradeSkillMaster_Crafting's internal data table using some savedDB data
	
	TSMAPI:RegisterModule("TradeSkillMaster_Crafting", TSM.version, GetAddOnMetadata("TradeSkillMaster_Crafting", "Author"),
		GetAddOnMetadata("TradeSkillMaster_Crafting", "Notes"))
	TSMAPI:RegisterData("shopping", function(_, mode) return TSM.Data:GetShoppingData(mode or "shopping") end)
	TSMAPI:RegisterData("craftingcost", function(_, itemID) return TSM.Data:GetCraftingCost(itemID) end)
	
	if TSM.db.profile.tooltip then
		TSMAPI:RegisterTooltip("TradeSkillMaster_Crafting", function(...) return TSM:LoadTooltip(...) end)
	end
end

function TSM:LoadTooltip(itemID)
	for _, profession in pairs(TSM.tradeSkills) do
		if TSM.Data[profession.name].crafts[itemID] then
			local cost,_,profit = TSM.Data:CalcPrices(TSM.Data[profession.name].crafts[itemID], profession.name)
			local restockWouldQueue
			
			local profitText = profit and "|cffffffff"..floor(profit+0.5)..GOLD_TEXT.."|r" or "|cffffffff---|r"
			local text1 = format(L["Crafting Cost: %s (%s profit)"], "|cffffffff"..cost..GOLD_TEXT.."|r", profitText)
			
			return {text1}
		end
	end
end

function TSM:OnDisable()
	TSM.db.global.treeStatus = TSM.GUI.TreeGroup.frame.obj.status.groups
end

-- converts an itemID into the name of the item.
function TSM:GetName(sID)
	if not sID then return end
	
	if not tonumber(sID) then return sID end
	
	local cachedName = TSM:GetNameFromGlobalNameCache(sID)
	if cachedName then return cachedName end

	local queriedName = GetItemInfo(sID)
	
	if not queriedName then
		queriedName = TSM:GetNameFromMatsForCurrentMode(sID)
		queriedName = TSM:GetNameFromCraftsForCurrentMode(sID)
		if not queriedName and sID == 38682 and GetLocale() == "enUS" then
			queriedName = "Enchanting Vellum"
		end
	end
	
	if queriedName then
		TSM:StoreNameInGlobalNameCache(sID, queriedName)
		
		if TSM:GetMatForCurrentMode(sID) and not TSM:GetMatForCurrentMode(sID).name then
			TSM:GetMatForCurrentMode(sID).name = queriedName
		end
		return queriedName
	else
		-- sad face :(
		TSM:Print(format("TradeSkillMaster imploded on itemID %s. This means you have not seen this " ..
			"item since the last patch and TradeSkillMaster_Crafting doesn't have a record of it. Try to find this " ..
			"item in game and then TradeSkillMaster_Crafting again. If you continue to get this error message please " ..
			"report this to the author (include the itemID in your message).", sID))
	end
end

function TSM:IsEnchant(link)
	if not link then return end
	return strfind(link, "enchant:") and true
end

function TSM:GetMode()
	local mode
	if TSM.Crafting.frame and TSM.Crafting.frame:IsVisible() then
		mode = TSM.Crafting.mode or TSM.mode
	else
		mode = TSM.mode
	end
	
	return mode
end

function TSM:GetNameFromGlobalNameCache(sID)
	if TSM.db.global[sID] then -- check to see if we have the name stored already in the saved DB
		if TSM.db.global[sID] == "Armor Vellum" then
			TSM.db.global[sID] = "Enchanting Vellum"
		end
		return TSM.db.global[sID]
	end
end
   
function TSM:StoreNameInGlobalNameCache(itemID, queriedName)
	TSM.db.global[itemID] = queriedName
end

function TSM:GetNameFromMatsForCurrentMode(itemID)
	local mode = TSM:GetMode()
	if TSM.Data[mode].mats[itemID] then
		return TSM.Data[mode].mats[itemID].name
	end
end

function TSM:GetNameFromCraftsForCurrentMode(itemID)
	local mode = TSM:GetMode()
	if TSM.Data[mode].crafts[itemID] then
		return TSM.Data[mode].crafts[itemID].name
	end
end

function TSM:GetMatForCurrentMode(itemID)
	local mode = TSM:GetMode()
	return TSM.Data[mode].mats[itemID]
end

local vendorMats = {[2324]=0.0025, [2325]=0.1, [6260]=0.005, [2320]=0.001, [38426]=3, [2321]=0.001, [4340]=0.035, [2605]=0.001,
		[8343]=0.2, [6261]=0.01, [10290]=0.25, [4342]=0.25, [2604]=0.005, [14341]=0.5, [4291]=0.05, [4341]=0.05, [38682] = 0.1,
		[39354]=0, [10648]=0.01, [39501]=0.12, [39502]=0.5, [3371]=0.01, [3466]=0.2, [2880]=0.01, [44835]=0.001, [62786]=0.1,
		[62788]=0.1, [58274]=1.1, [17194]=0.001, [17196]=0.005, [44853]=0.0025, [2678]=0.001, [62787]=0.1, [30817]=0.0025,
		[34412]=0.1, [58278]=1.6, [35949]=0.85, [17020]=0.1, [10647]=0.2, [39684]=0.9, [4400]=0.2, [4470]=0.0038, [11291]=0.45,
		[40533]=5, [4399]=0.02, [52188]=1.5, [4289]=0.005}

function TSM:GetVendorPrice(itemID)
	return vendorMats[itemID]
end

function TSM:GetDBValue(key, profession, itemID)
	return (itemID and TSM.db.profile[key][itemID]) or (profession and TSM.db.profile[key][profession]) or TSM.db.profile[key].default
end

function TSM:GoldToGoldSilverCopper(oGold, noCopper)
	if not oGold then return end
	local gold = floor(oGold)
	local silver, copper
	
	if noCopper then
		silver = floor(oGold*SILVER_PER_GOLD+0.5)%SILVER_PER_GOLD
	else
		silver = floor(oGold*SILVER_PER_GOLD)%SILVER_PER_GOLD
		copper = floor(oGold*COPPER_PER_GOLD)%COPPER_PER_SILVER
	end
	
	return gold, silver, copper
end



-- CRAFTING SPECIFIC API FUNCTIONS --

-- Clears the queue for the passed tradeskill (not case sensitive)
-- Will refresh the craft management window if it's open
-- Returns true if successful
-- Returns nil followed by an error message if not successful (two return values)
function TSMAPI:ClearQueue(tradeskill)
	if type(tradeskill) ~= "string" then
		return nil, "Invalid Tradeskill Type"
	end
	
	local valid = false
	
	for _, skill in ipairs(TSM.tradeSkills) do
		if strlower(skill.name) == strlower(tradeskill) or strlower(tradeskill) == "all" then
			for _, data in pairs(TSM.Data[skill.name].crafts) do
				data.queued = 0
				data.intermediateQueued = nil
			end
			valid = true
		end
	end
	
	if not valid then return nil, "Invalid Tradeskill: "..tradeskill end
	
	if TSM.Crafting.frame:IsVisible() then
		TSM.Crafting:UpdateAllScrollFrames()
	end
	
	return true
end

-- Sets the queued quantity of the specified item to the specified quantity
-- Will refresh the craft management window if it's open unless noUpdate is true - if you are going to call this multiple times in succession, set noUpdate on all but the last call to avoid lagging the user.
-- Accepts either itemIDs or itemLinks
-- Returns true if successful
function TSMAPI:AddItemToQueue(itemID, quantity, noUpdate)
	itemID = TSMAPI:GetItemID(itemID) or itemID
	if type(itemID) ~= "number" then return nil, "invalid itemID/itemLink" end
	if type(quantity) ~= "number" then return nil, "invalid quantity" end
	
	for _, skill in ipairs(TSM.tradeSkills) do
		if TSM.Data[skill.name].crafts[itemID] then
			TSM.Data[skill.name].crafts[itemID].queued = quantity
			break
		end
	end
	
	if TSM.Crafting.frame:IsVisible() and not noUpdate then
		TSM.Crafting:UpdateAllScrollFrames()
	end
	
	return true
end

-- Gets data for the specified tradeskill
-- Returns nil if not successful followed by an error message (two return values)
-- Returns a list of all crafts added to Crafting for the tradeskill. Each craft is a list with the following properties:

--[[
{
	itemID=#####, --itemID of Crafted Item
	spellID=#####, --spellID of spell to craft this item
	mats={matItemID1=matQuantity1, matItemID2=matQuantity2, ...}, -- mats for this craft
	queued=#, -- how many are queued
	enabled=true/false, -- if it is enabled (will show up in the craft management window)
	intermediateQueued=#, -- how many are queued as an intermediate craft
	group=#, -- number of the group this item is in
	name="name" -- name of the crafted item
}
--]]
function TSMAPI:GetTradeSkillData(tradeskill)
	if not tradeskill then return end
	
	if not TSM.data[tradeskill] then
		for _, skill in ipairs(TSM.tradeSkills) do
			if strlower(skill.name) == strlower(tradeskill) then
				tradeskill = skill.name
				break
			end
		end
	end
	
	if not (TSM.data[tradeskill] and TSM.data[tradeskill].crafts) then return end
	
	local results = {}
	for itemID, data in pairs(TSM.Data[tradeskill].crafts) do
		local temp = CopyTable(data)
		temp.itemID = itemID
		tinsert(results, temp)
	end
	
	return results
end