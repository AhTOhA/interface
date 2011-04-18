local TSMAuc = select(2, ...)
TSMAuc = LibStub("AceAddon-3.0"):NewAddon(TSMAuc, "TradeSkillMaster_Auctioning", "AceEvent-3.0", "AceConsole-3.0")
TSMAuc.status = {}
TSMAuc.version = GetAddOnMetadata("TradeSkillMaster_Auctioning","X-Curse-Packaged-Version") or GetAddOnMetadata("TradeSkillMaster_Auctioning", "Version") -- current version of the addon
local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Auctioning") -- loads the localization table
TSMAuc.itemReverseLookup = {}
TSMAuc.groupReverseLookup = {}
local status = TSMAuc.status
local statusLog, logIDs, lastSeenLogID = {}, {}

-- versionKey is used to ensure inter-module compatibility when new features are added
local versionKey = 2


function TSMAuc:CopySettings(otherDB)
	local profileSettings = {
		noCancel = {default = false},
		undercut = {default = 1},
		postTime = {default = 12},
		bidPercent = {default = 1.0},
		fallback = {default = 50000},
		fallbackCap = {default = 5},
		threshold = {default = 10000},
		postCap = {default = 4},
		perAuction = {default = 1},
		perAuctionIsCap = {default = false},
		priceThreshold = {default = 10},
	}
	local globalSettings = {
		showStatus = false,
		smartCancel = true,
		cancelWithBid = false,
		hideHelp = false,
		hideGray = false,
		blockAuc = true,
	}
	local factionrealmSettings = {
		player = {},
		whitelist = {},
	}
	
	for i in pairs(profileSettings) do
		for group, value in pairs(otherDB.profile[i]) do
			TSMAuc.db.profile[i][strlower(group)] = value
		end
	end
	TSMAuc.db.profile.ignoreStacksOver = CopyTable(otherDB.profile.ignoreStacks)
	
	for i in pairs(globalSettings) do
		TSMAuc.db.global[i] = otherDB.global[i]
	end
	
	for i in pairs(factionrealmSettings) do
		TSMAuc.db.factionrealm[i] = CopyTable(otherDB.factionrealm[i])
	end
	
	for name, data in pairs(otherDB.global.groups) do
		TSMAuc.db.profile.groups[strlower(name)] = CopyTable(data)
	end
	for _, group in pairs(TSMAuc.db.profile.groups) do
		local temp = CopyTable(group)
		for oldID, value in pairs(temp) do
			if type(oldID) ~= "number" then
				local newID = gsub(oldID, "item:", "")
				newID = tonumber(newID)
				if newID then
					group[newID] = value
					group[oldID] = nil
				end
			end
		end
	end
end

-- Addon loaded
function TSMAuc:OnInitialize()
	local defaults = {
		profile = {
			noCancel = {default = false},
			undercut = {default = 1},
			postTime = {default = 12},
			bidPercent = {default = 1.0},
			fallback = {default = 50000},
			fallbackPercent = {},
			fallbackPriceMethod = {default = "gold"},
			fallbackCap = {default = 5},
			threshold = {default = 10000},
			thresholdPercent = {},
			thresholdPriceMethod = {default = "gold"},
			postCap = {default = 4},
			perAuction = {default = 1},
			perAuctionIsCap = {default = false},
			priceThreshold = {default = 10},
			ignoreStacksOver = {default = 1000},
			ignoreStacksUnder = {default = 1},
			reset = {default = "none"},
			resetPrice = {default = 30000},
			disabled = {default = false},
			minDuration = {default = 0},
			groups = {},
			categories = {},
		},
		global = {
			infoID = -1,
			showStatus = false,
			smartCancel = true,
			cancelWithBid = false,
			hideHelp = false,
			hideGray = false,
			blockAuc = true,
			smartScanning = true,
			hideAdvanced = nil,
			enableSounds = false,
			tabOrder = 1,
			treeGroupStatus = {treewidth = 200, groups={[2]=true}},
			showTooltip = true,
		},
		factionrealm = {
			player = {},
			whitelist = {},
			blacklist = {},
		},
	}
	
	TSMAuc.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_AuctioningDB", defaults, true)
	TSMAuc.Cancel = TSMAuc.modules.Cancel
	TSMAuc.Config = TSMAuc.modules.Config
	TSMAuc.Log = TSMAuc.modules.Log
	TSMAuc.Post = TSMAuc.modules.Post
	TSMAuc.Scan = TSMAuc.modules.Scan
	TSMAuc.Manage = TSMAuc.modules.Manage
	TSMAuc.Status = TSMAuc.modules.Status
	
	-- Add this character to the alt list so it's not undercut by the player
	TSMAuc.db.factionrealm.player[UnitName("player")] = true
	
	if TSMAuc.db.profile.ignoreStacks then
		TSMAuc.db.profile.ignoreStacksOver = CopyTable(TSMAuc.db.profile.ignoreStacks)
		TSMAuc.db.profile.ignoreStacks = nil
	end
	
	-- converts itemIDs to itemStrings in the savedDB
	-- this shouldn't be deleted for a long time...
	local temp = {}
	for name, items in pairs(TSMAuc.db.profile.groups) do
		for itemID, value in pairs(items) do
			if type(itemID) == "number" then
				local itemString = TSMAuc:GetItemString(itemID)
				tinsert(temp, {name, itemID, itemString, value})
			end
		end
	end
	for _, data in ipairs(temp) do
		TSMAuc.db.profile.groups[data[1]][data[2]] = nil
		TSMAuc.db.profile.groups[data[1]][data[3]] = data[4]
	end
	
	if TSMAuc.db.profile.autoFallback then
		for group, value in pairs(TSMAuc.db.profile.autoFallback) do
			if value then
				TSMAuc.db.profile.reset[group] = "fallback"
			end
		end
		TSMAuc.db.profile.autoFallback = nil
	end
	
	for _, items in pairs(TSMAuc.db.profile.groups) do
		local fix = {}
		for itemString in pairs(items) do
			if #{(":"):split(itemString)} > 8 then
				tinsert(fix, itemString)
			end
		end
		for _, itemString in ipairs(fix) do
			items[itemString] = nil
			local newItemString = TSMAuc:GetItemString(itemString)
			if newItemString then
				items[newItemString] = true
			end
		end
	end
	
	-- Wait for auction house to be loaded
	TSMAuc:RegisterEvent("ADDON_LOADED", function(event, addon)
		if addon == "Blizzard_AuctionUI" then
			TSMAuc:UnregisterEvent("ADDON_LOADED")
			AuctionsTitle:Hide()
		end
	end)
	
	if IsAddOnLoaded("Blizzard_AuctionUI") then
		TSMAuc:UnregisterEvent("ADDON_LOADED")
		AuctionsTitle:Hide()
	end
	
	TSMAuc:ShowInfoPanel()
	TSMAPI:RegisterModule("TradeSkillMaster_Auctioning", TSMAuc.version, GetAddOnMetadata("TradeSkillMaster_Auctioning", "Author"),
		GetAddOnMetadata("TradeSkillMaster_Auctioning", "Notes"), versionKey)
	TSMAPI:RegisterIcon(L["Auctioning Groups/Options"], "Interface\\Icons\\Racial_Dwarf_FindTreasure", function(...) TSMAuc.Config:LoadOptions(...) end, "TradeSkillMaster_Auctioning", "options")
	TSMAuc:RegisterMessage("TSMAUC_NEW_GROUP_ITEM")
	TSMAPI:RegisterData("auctioningGroups", TSMAuc.GetGroups)
	TSMAPI:RegisterData("auctioningCategories", TSMAuc.GetCategories)
	TSMAPI:RegisterData("auctioningGroupItems", TSMAuc.GetGroupItems)
	TSMAPI:RegisterData("auctioningThreshold", TSMAuc.GetThresholdPrice)
	TSMAPI:RegisterData("auctioningFallback", TSMAuc.GetFallbackPrice)
	
	if TSMAuc.db.global.showTooltip then
		TSMAPI:RegisterTooltip("TradeSkillMaster_Auctioning", function(...) return TSMAuc:LoadTooltip(...) end)
	end
end

function TSMAuc:OnDisable()
	TSMAuc.db.global.treeGroupStatus = TSM.Config.treeGroup.frame.obj.status.groups
end

function TSMAuc:ShowInfoPanel()
	local messages = {
		L["Welcome to TradeSkillMaster_Auctioning!\n\nPlease click on the OK button below to enable APM and then reload your UI so your settings can be transferred!"],
		L["Welcome to TradeSkillMaster_Auctioning!\n\nPlease click on the OK button below to transfer your settings, disable APM, and reload your UI!"],
		L["TradeSkillMaster_Auctioning has detected that you have APM/ZA/QA3 running.\n\nPlease disable APM/ZA/QA3 by clicking on the OK button below."]
	}
	
	if not select(2, GetAddOnInfo("AuctionProfitMaster")) or TSMAuc.db.global.infoID == 1 and not select(4, GetAddOnInfo("AuctionProfitMaster")) or TSMAuc.db.global.infoID == 2 then
		return
	end
	
	local needToDisable
	if TSMAuc.db.global.infoID == 1 and (select(4, GetAddOnInfo("AuctionProfitMaster")) or select(4, GetAddOnInfo("ZeroAuctions")) or select(4, GetAddOnInfo("QuickAuctions"))) then
		needToDisable = true
	elseif select(4, GetAddOnInfo("AuctionProfitMaster")) then
		TSMAuc.db.global.infoID = 0
	end
	
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("HIGH")
	frame:SetToplevel(true)
	frame:SetWidth(400)
	frame:SetHeight(285)
	frame:SetBackdrop({
		  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		  edgeSize = 26,
		  insets = {left = 9, right = 9, top = 9, bottom = 9},
	})
	frame:SetBackdropColor(0, 0, 0, 0.85)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)

	frame.titleBar = frame:CreateTexture(nil, "ARTWORK")
	frame.titleBar:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
	frame.titleBar:SetPoint("TOP", 0, 8)
	frame.titleBar:SetWidth(405)
	frame.titleBar:SetHeight(45)

	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frame.title:SetPoint("TOP", 0, 0)
	frame.title:SetText("TradeSkillMaster_Auctioning")
	
	local text = L["Important! Please read!"].."\n\n"
	if TSMAuc.db.global.infoID == -1 then
		text = text .. messages[1]
	elseif TSMAuc.db.global.infoID == 0 then
		text = text .. messages[2]
	elseif needToDisable then
		text = text .. messages[3]
	end

	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	frame.text:SetText(text)
	frame.text:SetPoint("TOPLEFT", 12, -22)
	frame.text:SetWidth(frame:GetWidth() - 20)
	frame.text:SetJustifyH("LEFT")
	frame:SetHeight(frame.text:GetHeight() + 70)

	frame.transfer = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.transfer:SetText("OK")
	frame.transfer:SetHeight(20)
	frame.transfer:SetWidth(100)
	frame.transfer:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 8)
	frame.transfer:SetScript("OnClick", function(self)
		if TSMAuc.db.global.infoID == -1 then
			TSMAuc.db.global.infoID = 0
			EnableAddOn("AuctionProfitMaster")
			ReloadUI()
		elseif TSMAuc.db.global.infoID == 0 then
			if not select(4, GetAddOnInfo("AuctionProfitMaster")) then
				TSMAuc.db.global.infoID = -1
			else
				local APMDB = LibStub("AceAddon-3.0"):GetAddon("AuctionProfitMaster").db
				TSMAuc:CopySettings(APMDB)
				TSMAuc.db.global.infoID = 1
				DisableAddOn("AuctionProfitMaster")
				ReloadUI()
			end
		elseif needToDisable then
			DisableAddOn("AuctionProfitMaster")
			ReloadUI()
		else
			TSMAuc.db.global.infoID = 1
		end
		self:GetParent():Hide()
	end)
	
	frame.hide = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.hide:SetText("Cancel")
	if needToDisable then frame.hide:SetText("Hide Forever") end
	frame.hide:SetHeight(20)
	frame.hide:SetWidth(100)
	frame.hide:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 156, 8)
	frame.hide:SetScript("OnClick", function(self)
		self:GetParent():Hide()
		if needToDisable then
			TSMAuc.db.global.infoID = 2
		end
	end)
	
	TSMAuc.InfoFrame = frame
end

local GOLD_TEXT = "|cffffd700g|r"
local SILVER_TEXT = "|cffc7c7cfs|r"
local COPPER_TEXT = "|cffeda55fc|r"

-- Truncate tries to save space, after 300g stop showing copper, after 3000g stop showing silver
function TSMAuc:FormatTextMoney(money, truncate, noColor)
	if not money then return end
	local gold = floor(money / COPPER_PER_GOLD)
	local silver = floor((money - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = floor(math.fmod(money, COPPER_PER_SILVER))
	local text = ""
	
	-- Add gold
	if gold > 0 then
		text = format("%d%s ", gold, (not noColor and GOLD_TEXT or "g"))
	end
	
	-- Add silver
	if silver > 0 and (not truncate or gold < 1000) then
		text = format("%s%d%s ", text, silver, (not noColor and SILVER_TEXT or "s"))
	end
	
	-- Add copper if we have no silver/gold found, or if we actually have copper
	if text == "" or (copper > 0 and (not truncate or gold < 100)) then
		text = format("%s%d%s ", text, copper, (not noColor and COPPER_TEXT or "c"))
	end
	
	return string.trim(text)
end

-- Makes sure this bag is an actual bag and not an ammo, soul shard, etc bag
function TSMAuc:IsValidBag(bag)
	if bag == 0 or bag == -2 then return true end
	if bag == -1 then return false end
	
	-- family 0 = bag with no type, family 1/2/4 are special bags that can only hold certain types of items
	local itemFamily = GetItemFamily(GetInventoryItemLink("player", ContainerIDToInventoryID(bag)))
	return itemFamily and ( itemFamily == 0 or itemFamily > 4 )
end

function TSMAuc:UpdateItemReverseLookup()
	wipe(TSMAuc.itemReverseLookup)
	
	for group, items in pairs(TSMAuc.db.profile.groups) do
		for itemID in pairs(items) do
			TSMAuc.itemReverseLookup[itemID] = group
		end
	end
end

function TSMAuc:UpdateGroupReverseLookup()
	wipe(TSMAuc.groupReverseLookup)
	
	for category, groups in pairs(TSMAuc.db.profile.categories) do
		for groupName in pairs(groups) do
			TSMAuc.groupReverseLookup[groupName] = category
		end
	end
end

-- returns a table of all Auctioning categories
function TSMAuc:GetCategories()
	return CopyTable(TSMAuc.db.profile.categories)
end

-- returns a nicely formatted table of all Auctioning groups
function TSMAuc:GetGroups()
	local groups = CopyTable(TSMAuc.db.profile.groups)
	local temp = {}
	for groupName, items in pairs(groups) do
		for itemString, value in pairs(items) do
			local s1 = gsub(gsub(itemString, "item:", ""), "enchant:", "")
			local itemID = tonumber(strsub(s1, 1, strfind(s1, ":")-1))
			if itemID then
				tinsert(temp, {groupName, itemString, itemID, value})
			end
		end
	end
	
	for _, data in ipairs(temp) do
		groups[data[1]][data[2]] = nil
		groups[data[1]][data[3]] = data[4]
	end
	
	return groups
end

-- returns the items in the passed group
function TSMAuc:GetGroupItems(name)
	local groups = TSMAuc:GetGroups()
	if not groups[name] then return end
	local temp = {}
	for itemID in pairs(groups[name]) do
		tinsert(temp, itemID)
	end
	return temp
end

-- message handler that fires when Crafting creates a new group (or adds an item to one)
function TSMAuc:TSMAUC_NEW_GROUP_ITEM(_, groupName, itemID, isNewGroup, category)
	itemID = itemID and select(2, GetItemInfo(itemID)) or itemID
	groupName = strlower(groupName or "")
	if not groupName or groupName == "" then return end
	if isNewGroup then
		if not TSMAuc.db.profile.groups[groupName] then
			TSMAuc.db.profile.groups[groupName] = {}
			if category then
				TSMAuc.db.profile.categories[category][groupName] = true
			end
		else
			TSMAuc:Print(format(L["Group named \"%s\" already exists! Item not added."], groupName))
			return
		end
	else
		if not TSMAuc.db.profile.groups[groupName] then
			TSMAuc:Print(format(L["Group named \"%s\" does not exist! Item not added."], groupName))
			return
		end
	end
	if itemID then
		local itemString = TSMAuc:GetItemString(itemID)
		if itemString then
			TSMAuc:UpdateItemReverseLookup()
			if TSMAuc.itemReverseLookup[itemString] then
				TSMAuc.db.profile.groups[TSMAuc.itemReverseLookup[itemString]][itemString] = nil
			end
			TSMAuc.db.profile.groups[groupName][itemString] = true
		else
			TSMAuc:Print(L["Item failed to add to group."])
		end
	end
end

function TSMAuc:GetItemString(itemLink)
	if not itemLink then return end
	local link = select(2, GetItemInfo(itemLink))
	if not link then
		if tonumber(itemLink) then
			return "item:"..itemLink..":0:0:0:0:0:0"
		else
			return
		end
	end
	local _, _, _, t, itemID, id1, id2, id3, id4, id5, id6 = strfind(link, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
	return t..":"..itemID..":"..id1..":"..id2..":"..id3..":"..id4..":"..id5..":"..id6
end

function TSMAuc:ItemStringToID(itemString)
	local sNum = strfind(itemString, ":")
	local eNum = strfind(itemString, ":", sNum+1)
	return tonumber(strsub(itemString, sNum+1, eNum-1))
end

local function GetItemCost(source, itemString)
	local itemID = TSMAuc:ItemStringToID(itemString)
	local itemLink = select(2, GetItemInfo(itemID))

	if source == "dbmarket" then
		return TSMAPI:GetData("market", itemID)
	elseif source == "dbminbuyout" then
		return select(5, TSMAPI:GetData("market", itemID))
	elseif source == "crafting" then
		return TSMAPI:GetData("craftingcost", itemID)
	elseif source == "aucappraiser" and AucAdvanced then
		return AucAdvanced.Modules.Util.Appraiser.GetPrice(itemLink)
	elseif source == "aucminbuyout" and AucAdvanced then
		return select(6, AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems(itemLink))
	elseif source == "aucmarket" and AucAdvanced then
		return AucAdvanced.API.GetMarketValue(itemLink)
	elseif source == "iacost" and IAapi then
		return max(select(2, IAapi.GetItemCost(itemLink)), (select(11, GetItemInfo(itemLink)) or 0))
	end
end

function TSMAuc:GetMarketValue(group, percent, method)
	local cost = 0
	
	if TSMAuc.db.profile.groups[group] then
		for itemString in pairs(TSMAuc.db.profile.groups[group]) do
			local newCost = GetItemCost(method, itemString)
			if newCost and newCost > cost then
				cost = newCost
			end
		end
	end
	
	return cost*(percent or 1)
end

function TSMAuc:GetThresholdPrice(itemID)
	if not itemID then return end
	local itemString = TSMAuc:GetItemString(itemID)
	if not TSMAuc.itemReverseLookup[itemString] then return end
	return TSMAuc.Config:GetConfigValue(itemString, "threshold")
end

function TSMAuc:GetFallbackPrice(itemID)
	if not itemID then return end
	TSMAuc:UpdateItemReverseLookup()
	local itemString = TSMAuc:GetItemString(itemID)
	if not TSMAuc.itemReverseLookup[itemString] then return end
	return TSMAuc.Config:GetConfigValue(itemString, "fallback")
end

function TSMAuc:LoadTooltip(itemID)
	local itemString = TSMAuc:GetItemString(itemID)
	if not itemString then return end
	
	if not TSMAuc.itemReverseLookup[itemString] then
		TSMAuc:UpdateItemReverseLookup()
	end
	
	if TSMAuc.itemReverseLookup[itemString] then
		return {L["Auctioning Group:"].." |cffffffff"..TSMAuc.itemReverseLookup[itemString]}
	end
end


-- ************************************************************************** --
-- stuff for dealing with importing / exporting
-- ************************************************************************** --
local alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_="
local base = #alpha
local function decode(h)
	if strfind(h, "~") then return end
	local result = 0
	
	local i = #h - 1
	for w in string.gmatch(h, "([A-Za-z0-9_=])") do
		result = result + (strfind(alpha, w)-1)*(base^i)
		i = i - 1
	end
	
	return result
end

local function encode(d)
	local r = d % base
	local result
	if d-r == 0 then
		result = strsub(alpha, r+1, r+1)
	else 
		result = encode((d-r)/base) .. strsub(alpha, r+1, r+1)
	end
	return result
end

local function areEquiv(itemString, itemID)
	local temp = itemString
	temp = gsub(temp, itemID, "@")
	temp = gsub(temp, ":", "")
	temp = gsub(temp, "0", "")
	temp = gsub(temp, "item", "")
	temp = gsub(temp, "@", itemID)
	return tonumber(temp) == itemID
end

local eVersion = 1
local settings = {dr="postTime", fb="fallback", pa="perAuction", pc="postCap",
	pt="priceThreshold", nc="noCancel", pi="perAuctionIsCap", uc="undercut",
	so="ignoreStacksOver", su="ignoreStacksUnder", th="threshold", fc="fallbackCap",
	bp="bidPercent", md="minDuration", rt="reset", rp="resetPrice"}
local isNumber = {uc=true, dr=true, fb=true, pa=true, pc=true, pt=true, so=true, su=true,
	th=true, fc=true, bp=true, md=true, rp=true}
local isBool = {nc=true, pi=true}
local isString = {rt=true}
local encodeReset = {none="n", threshold="t", fallback="f", custom="c"}
local decodeReset = {n="none", t="threshold", f="fallback", c="custom"}
	
function TSMAuc:Encode(name)
	if not TSMAuc.db.profile.groups[name] then return "invalid name" end
	TSMAuc:UpdateItemReverseLookup()
	TSMAuc:UpdateGroupReverseLookup()
	
	local tItem
	local rope = "<vr"..encode(eVersion)..">"
	for itemString in pairs(TSMAuc.db.profile.groups[name]) do
		tItem = itemString
		local itemID = TSMAuc:ItemStringToID(itemString)
		if areEquiv(itemString, itemID) then
			rope = rope .. encode(itemID)
		else
			rope = rope .. encode(itemID)
			
			local temp = itemString
			temp = gsub(temp, "item:"..itemID..":", "")
			local nums = {(":"):split(temp)}
			for i,v in ipairs(nums) do
				if tonumber(v) < 0 then
					rope = rope .. ":!" .. encode(abs(v))
				else
					rope = rope .. ":" .. encode(v)
				end
			end
			
			rope = rope .. "|"
		end
	end
	
	for code, name in pairs(settings) do
		local settingString
		if isBool[code] then
			settingString = TSMAuc.Config:GetBoolConfigValue(tItem, name) and "1" or "0"
		elseif isString[code] then
			settingString = encodeReset[TSMAuc.Config:GetConfigValue(tItem, name)]
		elseif isNumber[code] then
			settingString = encode(tonumber(TSMAuc.Config:GetConfigValue(tItem, name)))
		else
			error("Incorrect Code: ("..code..", "..name..")")
		end
	
		rope = rope .. "<" .. code .. settingString .. ">"
	end
	
	rope = rope .. "<en>" -- end marker
	return rope
end

function TSMAuc:Decode(rope)
	local info = {items={}}
	local valid = true
	local finished = false
	
	gsub(rope, " ", "")
	
	-- special word decoding (for version / other info)
	local function specialWord(c, word)
		if not (c and word) then valid = false end
		if c == "vr" then
			info.version = tonumber(decode(word))
		elseif settings[c] then
			if isNumber[c] then
				info[settings[c]] = tonumber(decode(word))
			elseif isBool[c] then
				info[settings[c]] = word == "1" and true
			elseif isString[c] then
				info[settings[c]] = decodeReset[word]
			else
				valid = false
			end
		elseif c == "en" then
			finished = true
		else
			valid = false
		end
	end
	
	-- itemString decoding
	local function decodeItemString(word)
		local itemString = "item"
		for _, w in pairs({(":"):split(word)}) do
			if strsub(w, 1, 1) == "!" then
				itemString = itemString .. ":-" .. decode(strsub(w, 2))
			else
				itemString = itemString .. ":" .. decode(w)
			end
		end
		
		return itemString
	end

	local len = #rope
	local n = 1

	-- go through the rope and decode it!
	while(n <= len) do
		local c = strsub(rope, n, n)
		if c == "<" then -- special word start flag
			local e = strfind(rope, ">", n)
			specialWord(strsub(rope, n+1, n+2), strsub(rope, n+3, e-1))
			n = e + 1
		elseif strsub(rope, n+3, n+3) == ":" then -- itemString start flag
			local e = strfind(rope, "|", n)
			local itemString = decodeItemString(strsub(rope, n, e-1))
			if not itemString then valid = false break end
			tinsert(info.items, itemString)
			n = e + 1
		elseif strsub(rope, n, n) ~= "@" then -- read the next 3 chars as an itemID
			local itemID = tonumber(decode(strsub(rope, n, n+2)))
			if not itemID then valid = false break end
			tinsert(info.items, "item:"..itemID..":0:0:0:0:0:0")
			n = n + 3
		else -- we have read all the items and have moved onto the options
			n = n + 1
		end
	end
	
	-- make sure the data is valid before returning it
	return valid and finished and info
end

function TSMAuc:OpenImportFrame()
	local groupName, groupData
	local excludeExisting = true

	local f = AceGUI:Create("TSMWindow")
	f:SetCallback("OnClose", function(self) AceGUI:Release(self) end)
	f:SetTitle("TSM_Auctioning - "..L["Import Group Data"])
	f:SetLayout("Flow")
	f:SetHeight(200)
	f:SetHeight(300)
	
	local eb = AceGUI:Create("TSMEditBox")
	eb:SetLabel(L["Group name"])
	eb:SetRelativeWidth(0.5)
	eb:SetCallback("OnEnterPressed", function(_,_,value) groupName = strlower(value:trim()) end)
	f:AddChild(eb)
	
	local cb = AceGUI:Create("TSMCheckBox")
	cb:SetValue(excludeExisting)
	cb:SetLabel(L["Don't Import Already Grouped Items"])
	cb:SetRelativeWidth(0.5)
	cb:SetCallback("OnValueChanged", function(_,_,value) excludeExisting = value end)
	f:AddChild(cb)
	
	local spacer = AceGUI:Create("Label")
	spacer:SetFullWidth(true)
	spacer:SetText(" ")
	f:AddChild(spacer)
	
	local btn = AceGUI:Create("TSMButton")
	
	local eb = AceGUI:Create("MultiLineEditBox")
	eb:SetLabel(L["Group Data"])
	eb:SetFullWidth(true)
	eb:SetMaxLetters(0)
	eb:SetCallback("OnEnterPressed", function(_,_,data) btn:SetDisabled(false) groupData = data end)
	f:AddChild(eb)
	
	btn:SetDisabled(true)
	btn:SetText(L["Import Auctioning Group"])
	btn:SetFullWidth(true)
	btn:SetCallback("OnClick", function()
			local importData = TSMAuc:Decode(groupData)
			if not importData then
				TSMAuc:Print(L["The data you are trying to import is invalid."])
				return
			end
			
			if not groupName or TSMAuc.db.profile.groups[groupName] then
				groupName = groupName or "imported group"
				for i=1, 10000 do
					if not TSMAuc.db.profile.groups[groupName..i] then
						groupName = groupName .. i
						break
					end
				end
			end
			
			TSMAuc.db.profile.groups[groupName] = {}
			TSMAuc:UpdateItemReverseLookup()
			
			for i, v in pairs(importData) do
				if i == "items" then
					for _, itemString in pairs(v) do
						if not TSMAuc.itemReverseLookup[itemString] then
							TSMAuc.db.profile.groups[groupName][itemString] = true
						elseif excludeExisting then
							TSMAuc.db.profile.groups[TSMAuc.itemReverseLookup[itemString]][itemString] = nil
							TSMAuc.db.profile.groups[groupName][itemString] = true
						end
					end
				elseif i ~= "version" then
					TSMAuc.db.profile[i][groupName] = v
				end
			end
			
			TSMAuc.Config:UpdateTree()
			f:Hide()
			TSMAuc:Print(format(L["Data Imported to Group: %s"], groupName))
		end)
	f:AddChild(btn)
	
	f.frame:SetFrameStrata("FULLSCREEN_DIALOG")
	f.frame:SetFrameLevel(100)
end

function TSMAuc:OpenExportFrame(groupName)
	local f = AceGUI:Create("TSMWindow")
	f:SetCallback("OnClose", function(self) AceGUI:Release(self) end)
	f:SetTitle("TSM_Auctioning - "..L["Export Group Data"])
	f:SetLayout("Fill")
	f:SetHeight(200)
	f:SetHeight(300)
	
	local eb = AceGUI:Create("MultiLineEditBox")
	eb:SetLabel(L["Group Data"])
	eb:SetMaxLetters(0)
	eb:SetText(TSMAuc:Encode(groupName))
	f:AddChild(eb)
	
	f.frame:SetFrameStrata("FULLSCREEN_DIALOG")
	f.frame:SetFrameLevel(100)
end