--[[
					Market Watcher
				written by Torrid of Black Dragonflight

To Do:

query/filter sets
more accurate graph methods
detailed view, list view
view hidden, filtered
clear filters button
disable have materials

]]

MarketWatcher = {};
local MarketWatcher = MarketWatcher;

local tempItemTable = {};

--MarketWatcher.debug = true;

MarketWatcher.AUCTION_TIMELEFT = {
	[0] = 0,
	[1] = 1800,
	[2] = 7200,
	[3] = 43200,
	[4] = 172800,
};
local AUCTION_TIMELEFT = MarketWatcher.AUCTION_TIMELEFT;
local maxAuctionTime = AUCTION_TIMELEFT[#AUCTION_TIMELEFT];

MarketWatcher.AUCTION_DURATIONS = {
	[1] = 720,
	[2] = 1440,
	[3] = 2880,
};

-- how many auctions in each subclass before we scan the entire subclass rather than individual items
local SUBCLASS_THRESHOLD = {
	[MARKETWATCHER_GLYPH] = {
		["all"] = 6,
	},
	[MARKETWATCHER_GEM] = {
		["all"] = 4,
	},
};

MarketWatcher.CLASSES = { GetAuctionItemClasses() };
local CLASSES = MarketWatcher.CLASSES;

MarketWatcher.SUBCLASSES = { };
local SUBCLASSES = MarketWatcher.SUBCLASSES;

for i = 1, #CLASSES do
	SUBCLASSES[i] = { GetAuctionItemSubClasses(i) };
end

MarketWatcher.INVTYPES = {
	INVTYPE_HEAD,
	INVTYPE_NECK,
	INVTYPE_SHOULDER,
	INVTYPE_BODY,
	INVTYPE_CHEST,
	INVTYPE_WAIST,
	INVTYPE_LEGS,
	INVTYPE_FEET,
	INVTYPE_WRIST,
	INVTYPE_HAND,
	INVTYPE_FINGER,
	INVTYPE_TRINKET,
	INVTYPE_WEAPON,
	INVTYPE_SHIELD,
	INVTYPE_RANGEDRIGHT,
	INVTYPE_CLOAK,
	INVTYPE_2HWEAPON,
	INVTYPE_BAG,
	INVTYPE_TABARD,
	INVTYPE_ROBE,
	INVTYPE_WEAPONMAINHAND,
	INVTYPE_WEAPONOFFHAND,
	INVTYPE_HOLDABLE,
	INVTYPE_AMMO,
	INVTYPE_THROWN,
	INVTYPE_RANGED,
};

MarketWatcherHistory = {};
--[[
{
	[server] = {
		[faction] = {
			[itemId] = {
				[scanIndex] = {
					[timestamp]
					[auctionIndex] = {
						[1] = itemMods,
						[2] = uId,
						[3] = count,
						[4] = seller,
						[5] = buyoutPrice,
						[6] = minBid,
						[7] = bidAmount,
						[8] = timeleft,
						[9] = instances,
					},
					[auctionIndex] = {
						[1] = dupeScanIndex,
						[2] = dupeAuctionIndex,
						[3] = bidAmount,
						[4] = timeleft,
						[5] = instances,
					},
				},
			},
		},
	},
}
]]

MarketWatcherWatched = {};
MarketWatcherTempItemInfo = {};

MarketWatcherConfig = {};

local configDefaults = {
	["queryDelay"] = .5,
	["defaultUndercut"] = 0,
	["bidPriceMarkdown"] = 0,
	["ignoreSensitivity"] = 3,
	["saveOnBrowse"] = false,
	["reapplyFilters"] = false,
	["allowTSOpen"] = false,
	["ignoreOutliers"] = false,
}

local itemHistory, itemInfo, config, unregisteredTSWindow;

---------------------------------------------------------------------------------
--	Main Frame
---------------------------------------------------------------------------------

MarketWatcher.frame = CreateFrame("Frame");
local frame = MarketWatcher.frame;

frame:RegisterEvent("AUCTION_HOUSE_SHOW");
frame:RegisterEvent("AUCTION_HOUSE_CLOSED");
frame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE");
frame:RegisterEvent("VARIABLES_LOADED");

function frame.OnEvent(self, event)
	if ( event == "AUCTION_ITEM_LIST_UPDATE" ) then
		if ( MarketWatcher.listFunction ) then
			MarketWatcher.listFunction();
		end

	elseif ( event == "AUCTION_HOUSE_SHOW" ) then
		MarketWatcher.Setup();

	elseif ( event == "AUCTION_HOUSE_CLOSED" ) then
		MarketWatcher.Close();
	end
end

frame:SetScript("OnEvent", frame.OnEvent);


---------------------------------------------------------------------------------
--	Timer
---------------------------------------------------------------------------------

MarketWatcher.timer = CreateFrame("Frame", "MarketWatcherTimer", frame);
local timer = MarketWatcher.timer;
timer:Hide();

function timer:OnUpdate(elapsed)
	if ( self.endTime < GetTime() ) then
		--print("timer expired");
		self.endTime = GetTime() + 999999999;		-- just in case
		self:Hide();
		timer.func();
	end

end

timer:SetScript("OnUpdate", timer.OnUpdate);

function timer.StartTimer(time, func)
	timer.func = func;
	MarketWatcherTimer.endTime = GetTime() + time;
	MarketWatcherTimer:Show();
end

function timer.StopTimer()
	MarketWatcherTimer.endTime = 0;
	MarketWatcherTimer:Hide();
end


---------------------------------------------------------------------------------
--	Setup Functions
---------------------------------------------------------------------------------

function MarketWatcher.GetServerFaction()
	MarketWatcher.server = GetRealmName();
	_, MarketWatcher.faction = UnitFactionGroup("player");

	SetMapToCurrentZone();
	local map = GetMapInfo();
	if ( (map == "Tanaris") or (map == "Stranglethorn") or (map == "Winterspring") ) then
		MarketWatcher.faction = "Neutral";
	end

	return MarketWatcher.server, MarketWatcher.faction;
end

function MarketWatcher.Setup()
	local server, faction = MarketWatcher.GetServerFaction();

	if ( not server or not faction ) then
		return;
	end

	if ( not MarketWatcherConfig[server] ) then
		MarketWatcherConfig[server] = {};
	end
	if ( not MarketWatcherConfig[server][faction] ) then
		MarketWatcherConfig[server][faction] = {};
	end
	for k, v in pairs(configDefaults) do
		if ( type(MarketWatcherConfig[server][faction][k]) == "nil" ) then
			MarketWatcherConfig[server][faction][k] = v;
		end
	end

	if ( not MarketWatcherHistory[server] ) then
		MarketWatcherHistory[server] = {};
	end
	if ( not MarketWatcherHistory[server][faction] ) then
		MarketWatcherHistory[server][faction] = {};
	end

	if ( not MarketWatcherWatched[server] ) then
		MarketWatcherWatched[server] = {};
	end
	if ( not MarketWatcherWatched[server][faction] ) then
		MarketWatcherWatched[server][faction] = {};
	end

	config = MarketWatcherConfig[server][faction];
	itemHistory = MarketWatcherHistory[server][faction];
	itemInfo = MarketWatcherWatched[server][faction];

	if ( not MarketWatcher.GetConfig().allowTSOpen ) then
		UIParent:UnregisterEvent("TRADE_SKILL_SHOW");
		unregisteredTSWindow = true;
	end

	MarketWatcher.CreateTradeskillSelectorFrame();
end

function MarketWatcher.Close()
	MarketWatcher.timer.StopTimer();
	if ( unregisteredTSWindow ) then
		UIParent:RegisterEvent("TRADE_SKILL_SHOW");
		unregisteredTSWindow = false;
	end
end

function MarketWatcher.GetConfig()
	return config;
end


---------------------------------------------------------------------------------
--	Scan Functions
---------------------------------------------------------------------------------

function MarketWatcher.GetNumScans(itemId)
	if ( not itemHistory[itemId] ) then
		return 0;
	else
		return #itemHistory[itemId];
	end
end

function MarketWatcher.GetScanTimestamp(itemId, scanIndex)
	if ( scanIndex == 0 ) then
		return tempItemTable[itemId][1];
	else
		return itemHistory[itemId][scanIndex][1];
	end
end

function MarketWatcher.DeleteScanEntry(itemId, scan)
	if ( not itemId or not scan ) then
		return
	end

	local totalScans = MarketWatcher.GetNumScans(itemId, scan);

	if ( totalScans == scan ) then
		table.remove(itemHistory[itemId], scan);
		return
	end

	local pScan, pAuc, p, count, seller, buyoutPrice, timeleft, instances, minBid, bidAmount, itemMods, uId;

	-- iterate all scans after scan to be deleted
	for nextScanIndex = scan + 1, totalScans do

		-- iterate auctions in scan
		for auctionIndex = 1, MarketWatcher.GetNumAuctions(itemId, nextScanIndex) do

			-- find pointers
			p, pScan, pAuc = MarketWatcher.IsAPointer(itemId, nextScanIndex, auctionIndex);
			if ( p ) then
				
				-- is this auction pointing to an auction in the scan to be deleted?
				if ( pScan == scan ) then

					count, seller, buyoutPrice, _, _, _, _, minBid, bidAmount, itemMods, uId = MarketWatcher.GetAuction(itemId, pScan, pAuc);
					_, _, _, _, _, timeleft, instances, _, bidAmount = MarketWatcher.GetAuction(itemId, nextScanIndex, auctionIndex);

					MarketWatcher.EditAuction(itemId, nextScanIndex, auctionIndex, itemMods, uId, count, seller, buyoutPrice, minBid, bidAmount, timeleft, instances);

					p, pScan, pAuc = MarketWatcher.IsAPointer(itemId, pScan, pAuc);
					if ( p ) then
						MarketWatcher.ConvertAuctionToPointer(itemId, nextScanIndex, auctionIndex, pScan, pAuc);
					end

				-- is this auction pointing to an auction in a scan after the scan to be deleted?
				elseif ( pScan > scan ) then

					-- decrement pointer's scan number because we are deleting one
					itemHistory[itemId][nextScanIndex][auctionIndex + 1][1] = itemHistory[itemId][nextScanIndex][auctionIndex + 1][1] - 1;
				end

			end

		end
	end

	table.remove(itemHistory[itemId], scan);
end

function MarketWatcher.PruneHistory(itemId)
	local itemInfo = MarketWatcher.GetItemInfoTable(itemId);
	local scan, scanTime, age;
	
	if ( MarketWatcher.GetNumScans(itemId) > 0 and itemInfo.maxAge and itemInfo.maxAge > 0 ) then
		
		age = time() - itemInfo.maxAge * 86400;

		scanTime = MarketWatcher.GetScanTimestamp(itemId, 1);

		while ( scanTime < age ) do

			if ( MarketWatcher.debug ) then
				print("deleting old scan for item "..itemInfo.name);
			end

			MarketWatcher.DeleteScanEntry(itemId, 1);

			if ( MarketWatcher.GetNumScans(itemId) == 0 ) then
				break;
			end
			scanTime = MarketWatcher.GetScanTimestamp(itemId, 1);
		end
	end

	if ( MarketWatcher.GetNumScans(itemId) > 0 and itemInfo.maxEntries and itemInfo.maxEntries > 0 ) then

		while ( MarketWatcher.GetNumScans(itemId) > itemInfo.maxEntries ) do

			if ( MarketWatcher.debug ) then
				print("deleting excess scan for item "..itemInfo.name);
			end

			MarketWatcher.DeleteScanEntry(itemId, 1);
		end

	end
end

function MarketWatcher.ScanAnalysis(itemId, scanIndex, ignoreMinLow, ignoreMaxLow, ignoreMinAvg, ignoreMaxAvg, ignoreMinHigh, ignoreMaxHigh)
	local scanTime = MarketWatcher.GetScanTimestamp(itemId, scanIndex);
	local count, buyout, buyoutPerUnit, instances, minBid, bidAmount, bid, avg;
	local highestBuyoutPerUnit, lowestBuyoutPerUnit, averageBuyoutPerUnit, lowestBid, lowestBuyout, highestBid, highestBuyout;
	local auctions, unitsForSale, buyoutUnits = 0, 0, 0;

	for auctionIndex = 1, MarketWatcher.GetNumAuctions(itemId, scanIndex) do

		count, _, buyout, buyoutPerUnit, bid, _, instances = MarketWatcher.GetAuction(itemId, scanIndex, auctionIndex);

		if ( not lowestBid or lowestBid > bid ) then
			lowestBid = bid;
		end

		if ( not highestBid or highestBid < bid ) then
			highestBid = bid;
		end

		if ( not lowestBuyout or lowestBuyout > buyout ) then
			lowestBuyout = buyout;
		end

		if ( not highestBuyout or highestBuyout < buyout ) then
			highestBuyout = buyout;
		end

		if ( buyout > 0 ) then

			if ( not highestBuyoutPerUnit or highestBuyoutPerUnit < buyoutPerUnit ) then

				if ( not ignoreMaxHigh or (buyoutPerUnit > ignoreMinHigh and buyoutPerUnit < ignoreMaxHigh) ) then
					highestBuyoutPerUnit = buyoutPerUnit;
				end
			end

			if ( not lowestBuyoutPerUnit or lowestBuyoutPerUnit > buyoutPerUnit ) then

				if ( not ignoreMinLow or (buyoutPerUnit > ignoreMinLow and buyoutPerUnit < ignoreMaxLow) ) then
					lowestBuyoutPerUnit = buyoutPerUnit;
				end
			end

			avg = buyoutPerUnit * count * instances;
			if ( not ignoreMinAvg or ((avg / (count * instances)) > ignoreMinAvg and (avg / (count * instances)) < ignoreMaxAvg) ) then

				if ( not averageBuyoutPerUnit ) then
					averageBuyoutPerUnit = avg;
				else
					averageBuyoutPerUnit = averageBuyoutPerUnit + avg;
				end
				buyoutUnits = buyoutUnits + count * instances;
			end
		end
		unitsForSale = unitsForSale + count * instances;
		auctions = auctions + instances;
	end

	if ( averageBuyoutPerUnit ) then
		averageBuyoutPerUnit = averageBuyoutPerUnit / buyoutUnits;
	end

	return lowestBuyoutPerUnit, highestBuyoutPerUnit, averageBuyoutPerUnit, lowestBid, highestBid, lowestBuyout, highestBuyout, auctions, unitsForSale, scanTime;
end

function MarketWatcher.HistoricalComparison(itemId, pricePerUnit)

	local numScans = MarketWatcher.GetNumScans(itemId);
	if ( numScans < 2 or not pricePerUnit ) then
		return
	end

	local timestamp, buyout, count, instances, units, timeStamp;
	local high, low, weeklyAverage, weeklyHighestLow, weeklyLowestLow, monthlyAverage, monthlyHighestLow, monthlyLowestLow;
	local monthlyAverageLow, weeklyAverageLow, weeklyScans, monthlyScans = 0, 0, 0, 0;
	local weekAgo = time() - 604800;
	local monthAgo = time() - 2419200;

	for scanIndex = numScans, 1, -1 do
		timestamp = MarketWatcher.GetScanTimestamp(itemId, scanIndex);
		units = 0;
		average = 0;
		low = 0;
		high = 0;

		low, high, average, _, _, _, _, _, units, timeStamp = MarketWatcher.ScanAnalysis(itemId, scanIndex);

		if ( low ) then
			if ( timeStamp < monthAgo ) then
				break;
			end

			if ( timeStamp > weekAgo ) then
				if ( not weeklyHighestLow or weeklyHighestLow < low ) then
					weeklyHighestLow = low;
				end
				if ( not weeklyLowestLow or weeklyLowestLow > low ) then
					weeklyLowestLow = low;
				end
				weeklyAverageLow = weeklyAverageLow + low;
				weeklyScans = weeklyScans + 1;
			end

			if ( not monthlyHighestLow or monthlyHighestLow < low ) then
				monthlyHighestLow = low;
			end
			if ( not monthlyLowestLow or monthlyLowestLow > low ) then
				monthlyLowestLow = low;
			end

			monthlyAverageLow = monthlyAverageLow + low;
			monthlyScans = monthlyScans + 1;
		end
	end

	weeklyAverageLow = weeklyAverageLow / weeklyScans;
	monthlyAverageLow = monthlyAverageLow / monthlyScans;

	local weekly, monthly;

	if ( weeklyScans > 0 ) then
		low = pricePerUnit - weeklyAverageLow;
		weekly = math.floor(100 / weeklyAverageLow * low);
	end
	if ( monthlyScans > 0 and monthlyScans > weeklyScans ) then
		low = pricePerUnit - monthlyAverageLow;
		monthly = math.floor(100 / monthlyAverageLow * low);
	end

	return weekly, monthly;
end


---------------------------------------------------------------------------------
--	Temp Data Functions
---------------------------------------------------------------------------------

function MarketWatcher.NewTempTable()
	tempItemTable = {};
end

function MarketWatcher.AddTempItem(itemId, timestamp)

	if ( not tempItemTable[itemId] ) then
		tempItemTable[itemId] = {};
		MarketWatcher.SetTempTimestamp(itemId, timestamp);
	end
end

function MarketWatcher.SetTempTimestamp(itemId, timestamp)
	if ( tempItemTable[itemId] ) then
		tempItemTable[itemId][1] = timestamp or time(date("*t"));
	end
end

function MarketWatcher.AddTempAuction(itemId, itemMods, uId, count, seller, buyoutPrice, minBid, bidAmount, timeleft, instances)

	if ( not tempItemTable[itemId] ) then
		MarketWatcher.AddTempItem(itemId);
	end

	tinsert(tempItemTable[itemId], {
		itemMods,
		uId,
		count,
		seller,
		buyoutPrice,
		minBid,
		bidAmount,
		timeleft,
		instances,
	});
end


function MarketWatcher.TempItemIterator()
	return pairs(tempItemTable);
end

function MarketWatcher.IsItemInTable(itemId)
	if ( tempItemTable[itemId] ) then
		return true;
	end
end

function MarketWatcher.DeleteTempItem(itemId)
	tempItemTable[itemId] = nil;
end

function MarketWatcher.DeleteTempAuction(itemId, auctionIndex)
	table.remove(tempItemTable[itemId], auctionIndex + 1);
end

-- sortIndex and secondaryIndex inputs: 1 = sort by count; 2 seller name; 3 buyoutPrice (default); 4 currentBid (secondary default); 5 timeleft; 6 instances
function MarketWatcher.SortTempAuctions(itemId, sortIndex, secondaryIndex)

	if ( not sortIndex ) then
		sortIndex = 3;
	end
	if ( not secondaryIndex ) then
		secondaryIndex = 4;
	end

	local a1 = {};
	local a2 = {};
	local tmp;

	table.sort(tempItemTable[itemId], function(a, b)
		if ( type(a) ~= "table" ) then
			return true;
		end
		if ( type(b) ~= "table" ) then
			return false;
		end

		tmp, a1[4], a1[5], a1[6] = MarketWatcher.DereferenceAuction(a, itemId);
		if ( a1[4] == 0 ) then
			a1[4] = tmp[6];
		end
		a1[1] = tmp[3];
		a1[2] = tmp[4];
		a1[3] = tmp[5];

		tmp, a2[4], a2[5], a2[6] = MarketWatcher.DereferenceAuction(b, itemId);
		if ( a2[4] == 0 ) then
			a2[4] = tmp[6];
		end
		a2[1] = tmp[3];
		a2[2] = tmp[4];
		a2[3] = tmp[5];

		if ( a1[sortIndex] == a2[sortIndex] ) then
			return a1[secondaryIndex] < a2[secondaryIndex];
		else
			return a1[sortIndex] < a2[sortIndex];
		end
	end);
end

function MarketWatcher.SaveTempItemData(itemId)
	local scanTime, lastScanTime, numScans, entries, record, found, count;
	local itemInfo = MarketWatcher.GetItemInfoTable(itemId);

	if ( not itemHistory[itemId] ) then
		itemHistory[itemId] = {};
	end

	numScans = MarketWatcher.GetNumScans(itemId);

	if ( numScans > 0 ) then
		lastScanTime = MarketWatcher.GetScanTimestamp(itemId, numScans);
	end
	entries = MarketWatcher.GetNumAuctions(itemId, 0);
	scanTime = MarketWatcher.GetScanTimestamp(itemId, 0);


	-- Make pointers

	-- if this is not the first scan and the last scan was within the last 48 hours
	if ( numScans > 0 and lastScanTime > (scanTime - AUCTION_TIMELEFT[#AUCTION_TIMELEFT]) ) then

		-- iterate auctions in temp data
		for scanAuctionIndex = 1, MarketWatcher.GetNumAuctions(itemId, 0) do

			-- compare with every history entry in last scan for matches
			for historicalAuctionIndex = 1, MarketWatcher.GetNumAuctions(itemId, numScans) do

				if ( MarketWatcher.IsAuctionEqual(itemId, numScans, historicalAuctionIndex, 0, scanAuctionIndex) ) then

					-- convert to pointer
					MarketWatcher.ConvertAuctionToPointer(itemId, 0, scanAuctionIndex, numScans, historicalAuctionIndex);

					break;
				end

			end
		end
	end

	-- create duplicate of table and copy that table to history
	local t = {};
	tinsert(t, tempItemTable[itemId][1]);

	for scanAuctionIndex = 1, MarketWatcher.GetNumAuctions(itemId, 0) do

		if ( not itemInfo.stackOnly or MarketWatcher.GetAuction(itemId, 0, scanAuctionIndex) == itemInfo.stackCount ) then
			tinsert(t, tempItemTable[itemId][scanAuctionIndex + 1]);
		end
	end

	tinsert(itemHistory[itemId], t);

	if ( MarketWatcher.debug ) then
		print("scan entry recorded for item "..itemInfo.name);
	end
end


---------------------------------------------------------------------------------
--	Watched Items Functions
---------------------------------------------------------------------------------

function MarketWatcher.WatchedItemsIterator()
	return pairs(itemInfo);
end

function MarketWatcher.GetItemInfoTable(itemId)
	if ( itemInfo[itemId] ) then
		return itemInfo[itemId];
	elseif ( MarketWatcherTempItemInfo[itemId] ) then
		return MarketWatcherTempItemInfo[itemId], true;
	end
end

function MarketWatcher.SetWatchedItemInfo(itemId)

	local item = MarketWatcher.GetItemInfoTable(itemId);

	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
	itemEquipLoc, itemTexture = GetItemInfo(itemId);

	if ( not itemName ) then
		return
	end

	item.name	= itemName;
	item.quality	= itemRarity;
	item.iLevel	= itemLevel;
	item.minLevel	= itemMinLevel;
	item.type	= itemType;
	item.subType	= itemSubType;
	item.stackCount = itemStackCount;
	item.equipLoc	= itemEquipLoc;
	item.texture	= itemTexture;
end

function MarketWatcher.AddWatchedItem(itemId, bidThreshold, buyoutThreshold, stackOnly, recordHistory, maxEntries, maxAge, summaryConditional, summaryStackOnly, noneOnSale)

	local itemName = GetItemInfo(itemId);
	local itemTable, isTemp = MarketWatcher.GetItemInfoTable(itemId);

	if ( itemName and (not itemTable or isTemp) ) then
		itemInfo[itemId] = {};
		MarketWatcherTempItemInfo[itemId] = nil;	-- remove from temp items if needed
		MarketWatcher.EditWatchedItem(itemId, bidThreshold or 0, buyoutThreshold or 0, stackOnly or false, recordHistory or false, maxEntries or 100, maxAge or 30, summaryConditional or "no", summaryStackOnly or false, noneOnSale or "true");
		MarketWatcher.SetWatchedItemInfo(itemId);
	end
end

function MarketWatcher.AddTempItemInfo(itemId)

	MarketWatcherTempItemInfo[itemId] = {};
	local item = MarketWatcherTempItemInfo[itemId];

	MarketWatcher.SetWatchedItemInfo(itemId);

	item.bidThreshold	= 0;
	item.buyoutThreshold	= 0;
	item.stackOnly		= false;
	item.recordHistory	= false;
	item.maxEntries		= 0;
	item.maxAge		= 0;
	item.summaryConditional = "no";
	item.summaryStackOnly	= false;
	item.noneOnSale		= true;
end

function MarketWatcher.EditWatchedItem(itemId, bidThreshold, buyoutThreshold, stackOnly, recordHistory, maxEntries, maxAge, summaryConditional, summaryStackOnly, noneOnSale)

	local item = MarketWatcher.GetItemInfoTable(itemId);

	item.bidThreshold	= bidThreshold;
	item.buyoutThreshold	= buyoutThreshold;
	item.stackOnly		= stackOnly;
	item.recordHistory	= recordHistory;
	item.maxEntries		= maxEntries;
	item.maxAge		= maxAge;
	item.summaryConditional = summaryConditional;
	item.summaryStackOnly	= summaryStackOnly;
	item.noneOnSale		= noneOnSale;
end

function MarketWatcher.RemoveWatchedItem(itemId)
	itemInfo[itemId] = nil;
	itemHistory[itemId] = nil;
end


---------------------------------------------------------------------------------
--	Auction Data Functions
---------------------------------------------------------------------------------

function MarketWatcher.GetNumAuctions(itemId, scanIndex)
	local scanTable;

	if ( scanIndex == 0 ) then
		scanTable = tempItemTable[itemId];
	else
		if ( not itemHistory[itemId] ) then
			return 0;
		end
		scanTable = itemHistory[itemId][scanIndex];
	end

	if ( scanTable ) then
		return #scanTable - 1;
	else
		return 0;
	end
end

function MarketWatcher.AuctionsIterator(itemId, scanIndex)

	local i = 0;
	local n;
	
	if ( scanIndex == 0 ) then
		n = #tempItemTable[itemId];
	else
		n = #itemHistory[itemId][scanIndex];
	end

	return function ()
		i = i + 1;
		if ( i < n ) then
			return MarketWatcher.GetAuction(itemId, scanIndex, i);
		end
	end
end

function MarketWatcher.IsAPointer(itemId, scanIndex, auctionIndex)

	local auction;

	if ( type(itemId) == "table" ) then
		auction = itemId;
	else
		if ( scanIndex == 0 ) then
			auction = tempItemTable[itemId][auctionIndex + 1];
		else
			auction = itemHistory[itemId][scanIndex][auctionIndex + 1];
		end
	end

	if ( type(auction[1]) == "number" ) then
		return true, auction[1], auction[2] - 1;
	end
end

-- targetScanIndex cannot be zero (temp data)
function MarketWatcher.ConvertAuctionToPointer(itemId, convertScanIndex, convertAuctionIndex, targetScanIndex, targetAuctionIndex)
	local convert, target;

	if ( convertScanIndex == 0 ) then
		convert = tempItemTable[itemId][convertAuctionIndex + 1];
	else
		convert = itemHistory[itemId][convertScanIndex][convertAuctionIndex + 1];
	end

	target = itemHistory[itemId][targetScanIndex][targetAuctionIndex + 1];

	convert[5] = convert[9];
	convert[4] = convert[8];
	convert[3] = convert[7];
	convert[1] = targetScanIndex;
	convert[2] = targetAuctionIndex + 1;
end

function MarketWatcher.DereferenceAuction(auction, itemId)

	local bid, timeleft, instances = auction[3], auction[4], auction[5];

	-- if auction is not a pointer, return input
	if ( not MarketWatcher.IsAPointer(auction) ) then
		return auction, auction[7], auction[8], auction[9];
	end

	local i = 0;
	while ( MarketWatcher.IsAPointer(auction) and i < 1000 ) do
		if (	
			not itemId or
			not itemHistory[itemId][ auction[1] ] or
			not itemHistory[itemId][ auction[1] ][ auction[2] ]
		) then
			return
		end

		auction = itemHistory[itemId][ auction[1] ][ auction[2] ];
		i = i + 1;
	end

	if ( MarketWatcher.debug and i == 1000 ) then
		print("Error: Infinite dereference loop; itemId: "..itemId.."; scan: "..auction[1].."; auction: "..auction[2]);
	end
	return auction, bid, timeleft, instances;
end

-- Get auction data from the history or temp table; a scanIndex of 0 == get from temp table
-- returns: count, seller, buyoutPrice, buyoutPricePerUnit, currentBid, timeleft, instances, minBid, bidAmount, itemMods, uId
function MarketWatcher.GetAuction(itemId, scanIndex, auctionIndex)

	local auction, currentBid;

	if ( scanIndex == 0 ) then
		auction = tempItemTable[itemId][auctionIndex + 1];	-- first entry is scan timestamp

	else
		auction = itemHistory[itemId][scanIndex][auctionIndex + 1];	-- first entry is scan timestamp
	end

	local bid, timeleft, instances;

	auction, bid, timeleft, instances = MarketWatcher.DereferenceAuction(auction, itemId);

	if ( not auction ) then
		return
	end

	if ( bid == 0 ) then
		currentBid = auction[6];
	else
		currentBid = bid;
	end

	return auction[3], auction[4], auction[5], auction[5] / auction[3], currentBid, timeleft, instances or 1, auction[6], bid, auction[1], auction[2];
end

-- do not use this on pointer auctions
function MarketWatcher.EditAuction(itemId, scanIndex, auctionIndex, itemMods, uId, count, seller, buyoutPrice, minBid, bidAmount, timeleft, instances)

	local auction;

	if ( scanIndex == 0 ) then
		auction = tempItemTable[itemId][auctionIndex + 1];
	else
		auction = itemHistory[itemId][scanIndex][auctionIndex + 1];
	end

	auction[1] = itemMods or auction[1];
	auction[2] = uId or auction[2];
	auction[3] = count or auction[3];
	auction[4] = seller or auction[4];
	auction[5] = buyoutPrice or auction[5];
	auction[6] = minBid or auction[6];
	auction[7] = bidAmount or auction[7];
	auction[8] = timeleft or auction[8];
	auction[9] = instances or auction[9];
end

function MarketWatcher.IsAuctionEqual(itemId, scanIndex1, auctionIndex1, scanIndex2, auctionIndex2)

	local count1, seller1, buyoutPrice1, _, _, timeleft1, _, minBid1, bidAmount1, itemMods1, uId1 = MarketWatcher.GetAuction(itemId, scanIndex1, auctionIndex1);
	local timeStamp1 = MarketWatcher.GetScanTimestamp(itemId, scanIndex1);

	local count2, seller2, buyoutPrice2, _, _, timeleft2, _, minBid2, bidAmount2, itemMods2, uId2 = MarketWatcher.GetAuction(itemId, scanIndex2, auctionIndex2);
	local timeStamp2 = MarketWatcher.GetScanTimestamp(itemId, scanIndex2);

	if ( scanIndex1 == scanIndex2 and auctionIndex1 == auctionIndex2 ) then
		return true;
	end

	if (
		uId1 == uId2 and
		count1 == count2 and
		seller1 == seller2 and
		minBid1 == minBid2 and
		itemMods1 == itemMods2 and
		buyoutPrice1 == buyoutPrice2
	) then

		-- make sure the first auction is the earlier one
		if ( timeStamp2 < timeStamp1 ) then
			local temp = timeleft1;
			timeleft1 = timeleft2;
			timeleft2 = temp;

			temp = bidAmount1;
			bidAmount1 = bidAmount2;
			bidAmount2 = temp;

			temp = timeStamp1;
			timeStamp1 = timeStamp2;
			timeStamp2 = temp;
		end

		-- check bids
		if ( bidAmount1 > bidAmount2 ) then
			return false;
		end

		-- check auction time lefts

		-- if auctions were scanned at the same time
		if ( timeStamp1 == timeStamp2 ) then
			if ( timeleft1 == timeleft2 ) then
				return true;
			else
				return false;
			end
		end

		-- if scans were more than 48 hours apart
		if ( (timeStamp2 - timeStamp1) > maxAuctionTime ) then
			return false;
		end

		-- check if auction 1's maximum possible time left > the minimum time left of auction 2
		if ( (timeStamp1 + AUCTION_TIMELEFT[timeleft1]) > (timeStamp2 + AUCTION_TIMELEFT[timeleft2 - 1]) ) then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function MarketWatcher.ItemBoughtOut(itemId, scan, n)
	local numScans = MarketWatcher.GetNumScans(itemId);

	if ( scan == numScans ) then
		return false;
	end

	local scanTime = MarketWatcher.GetScanTimestamp(itemId, scan);
	local nextScanTime, found, timeleft;

	for nextScan = scan + 1, numScans do
		nextScanTime = MarketWatcher.GetScanTimestamp(itemId, nextScan);
		_, _, _, _, _, timeleft = MarketWatcher.GetAuction(itemId, scan, n);

		-- if next scan was taken longer than minimum possible time remaining
		if ( (nextScanTime - scanTime) > AUCTION_TIMELEFT[timeleft - 1] ) then
			-- break, because auction may have expired
			break;
		else
			-- this scan is within the time remaining

			found = false;
			for i = 1, MarketWatcher.GetNumAuctions(itemId, nextScan) do

				if ( MarketWatcher.IsAuctionEqual(itemId, scan, n, nextScan, i) ) then
					found = true;
				end
			end

			if ( not found ) then
				return true;
			end
		end

	end

	return false;
end


---------------------------------------------------------------------------------
--	Query Functions
---------------------------------------------------------------------------------

function MarketWatcher.QueryServer(name, minLevel, maxLevel, invTypeIndex, classIndex, subclassIndex, page, isUsable, qualityIndex, getAll)
	if ( AucAdvanced ) then
		AucAdvanced.Scan.Private.Hook.QueryAuctionItems(name or "", minLevel, maxLevel, invTypeIndex or 0, classIndex or 0, subclassIndex or 0, page or 0, isUsable or 0, qualityIndex or 0, getAll);
	else
		QueryAuctionItems(name or "", minLevel, maxLevel, invTypeIndex or 0, classIndex or 0, subclassIndex or 0, page or 0, isUsable or 0, qualityIndex or 0, getAll);
	end
end

function MarketWatcher.QueryItem(itemId, page)

	if ( not CanSendAuctionQuery() ) then
		return false;
	end

	local itemInfo;
	local invTypeIndex, classIndex, subclassIndex;

	itemInfo = MarketWatcher.GetItemInfoTable(itemId);

	classIndex, subclassIndex = MarketWatcher.GetItemAuctionClasses(itemInfo.type, itemInfo.subType);
	invTypeIndex = MarketWatcher.GetItemInvType(itemInfo.equipLoc, classIndex, subclassIndex);

	if ( MarketWatcher.debug ) then
		print("Querying "..itemInfo.name, invTypeIndex, classIndex, subclassIndex, page or 0, 0, itemInfo.quality);
	end
	MarketWatcher.QueryServer(itemInfo.name, nil, nil, invTypeIndex, classIndex, subclassIndex, page or 0, 0, itemInfo.quality, false);

	return true;
end

function MarketWatcher.GetItemAuctionClasses(type, subType)
	local subclassIndex;

	for i, class in ipairs(CLASSES) do
		if ( class == type ) then

			for j, subClass in ipairs(SUBCLASSES[i]) do
				if ( subClass == subType ) then
					subclassIndex = j;
					break;
				end
			end

			return i, subclassIndex;
		end
	end
end

function MarketWatcher.GetItemInvType(equipLoc, classIndex, subclassIndex)
	if ( equipLoc and equipLoc ~= "" ) then
		
		local invTypes = { GetAuctionInvTypes(classIndex, subclassIndex) };
		
		for i, type in pairs(invTypes) do

			if ( type == equipLoc and invTypes[i+1] ) then
				return (i + 1) / 2;
			end
		end

		return 0;
	else
		return 0;
	end
end

function MarketWatcher.GenerateQueryList()
	local subclassed = {};
	local subTallies = {};
	local item, classIndex, subclassIndex;

	local function GetWords(s)
		local t = {};

		for word in string.gmatch(s, "(%S+)") do
			if ( #word > 3 ) then
				tinsert(t, word);
			end
		end

		-- put longest words first
		table.sort(t, function (a, b)
			return #a > #b;
		end);

		return t;
	end

	local function MatchWords(t, s)
		local removed;

		while ( true ) do
			for i, word in ipairs(t) do

				if ( not string.find(s, word) ) then
					tremove(t, i);
					removed = true;
					break;
				end

			end

			if ( not removed ) then
				break;
			end
			removed = false;
		end
	end

	-- count up the number of items, determine the lowest quality, and find any words common to all in each subclass
	for itemId in MarketWatcher.WatchedItemsIterator() do

		item = MarketWatcher.GetItemInfoTable(itemId);
		if ( item.name ) then

			classIndex, subclassIndex = MarketWatcher.GetItemAuctionClasses(item.type, item.subType);

			if ( SUBCLASSES[classIndex] and SUBCLASSES[classIndex][subclassIndex] ) then
				if ( not subTallies[classIndex] ) then
					subTallies[classIndex] = {};
				end
				if ( not subTallies[classIndex][subclassIndex] ) then
					subTallies[classIndex][subclassIndex] = {};
					subTallies[classIndex][subclassIndex]["count"] = 1;
					subTallies[classIndex][subclassIndex]["quality"] = item.quality;
					subTallies[classIndex][subclassIndex]["words"] = GetWords(item.name);	-- create a table containing the words of the first item in this subclass
				else
					subTallies[classIndex][subclassIndex]["count"] = subTallies[classIndex][subclassIndex]["count"] + 1;

					if ( subTallies[classIndex][subclassIndex]["quality"] > item.quality ) then
						subTallies[classIndex][subclassIndex]["quality"] = item.quality;
					end

					-- remove words not common to previous items in this subclass
					if ( subTallies[classIndex][subclassIndex]["words"] ) then
						MatchWords(subTallies[classIndex][subclassIndex]["words"], item.name);
						if ( #subTallies[classIndex][subclassIndex]["words"] == 0 ) then
							subTallies[classIndex][subclassIndex]["words"] = nil;
						end
					end
				end

			end
		end
	end

	local queries = {};
	local threshold, invTypeIndex, count, commonWord;

	-- figure out which subclasses have more items than the threshold needed before we scan the entire subclass rather than individual items
	for tallyClassIndex, tallyClassTable in pairs(subTallies) do
		for tallySubclassIndex, subclassInfo in pairs(tallyClassTable) do

			count = subclassInfo["count"];
			if ( subclassInfo["words"] ) then
				commonWord = subclassInfo["words"][1];
			else
				commonWord = "";
			end

			threshold = SUBCLASS_THRESHOLD[ CLASSES[tallyClassIndex] ];
			if ( threshold ) then
				threshold = SUBCLASS_THRESHOLD[ CLASSES[tallyClassIndex] ][ SUBCLASSES[tallySubclassIndex] ]
					    or SUBCLASS_THRESHOLD[ CLASSES[tallyClassIndex] ]["all"];
			end

			if ( threshold and subclassInfo["count"] >= threshold ) then

				table.insert(queries, {
					["name"] = commonWord,
				--	["minLevel"] = nil,
				--	["maxLevel"] = nil,
					["invTypeIndex"] = 0,
					["classIndex"] = tallyClassIndex,
					["subclassIndex"] = tallySubclassIndex,
					["qualityIndex"] = subclassInfo["quality"],
				});
			end
		end
	end

	-- add individual items to scan
	for itemId in MarketWatcher.WatchedItemsIterator() do
		if ( not subclassed[itemId] ) then
	
			item = MarketWatcher.GetItemInfoTable(itemId);
			if ( item.name ) then
				classIndex, subclassIndex = MarketWatcher.GetItemAuctionClasses(item.type, item.subType);

				threshold = SUBCLASS_THRESHOLD[ CLASSES[classIndex] ];
				if ( threshold ) then
					threshold = SUBCLASS_THRESHOLD[ CLASSES[classIndex] ][ SUBCLASSES[subclassIndex] ]
						    or SUBCLASS_THRESHOLD[ CLASSES[classIndex] ]["all"];
				end

				if ( not threshold or not subTallies[classIndex] or subTallies[classIndex][subclassIndex]["count"] < threshold ) then

					if ( item.equipLoc and item.equipLoc ~= "" ) then
						invTypeIndex = _G[item.equipLoc];
					else
						invTypeIndex = 0;
					end

					table.insert(queries, {
						["name"] = item.name,
					--	["minLevel"] = nil,
					--	["maxLevel"] = nil,
						["invTypeIndex"] = invTypeIndex,
						["classIndex"] = classIndex,
						["subclassIndex"] = subclassIndex,
						["qualityIndex"] = item.quality,
					});
				end
			end
		end
	end

	return queries;
end

function MarketWatcher.IsItemInQuery(query, itemId)
	
	local itemInfo = MarketWatcher.GetItemInfoTable(itemId);
	if ( not itemInfo ) then
		if ( GetItemInfo(itemId) ) then
			MarketWatcher.AddTempItemInfo(itemId);
			itemInfo = MarketWatcher.GetItemInfoTable(itemId);
			if ( not itemInfo ) then
				return
			end
		else
			return
		end
	end

	local classIndex, subclassIndex = MarketWatcher.GetItemAuctionClasses(itemInfo.type, itemInfo.subType)
	local invType = MarketWatcher.GetItemInvType(itemInfo.equipLoc, classIndex, subclassIndex);

	if (	(not query.classIndex or query.classIndex == classIndex)
		and (not query.subclassIndex or (query.subclassIndex == subclassIndex))
		and (not query.name or (strfind(itemInfo.name:lower(), query.name:lower(), 1, true)))
		and (not query.invTypeIndex or (invType == query.invTypeIndex))
		and (not query.qualityIndex or (itemInfo.quality >= query.qualityIndex))
--		and (not query.minLevel or (itemInfo >= query.minUseLevel))
--		and (not query.maxLevel or (itemInfo <= query.maxUseLevel))
--		and (not query.isUsable or ())
	) then
		return true;
	end

	return false;
end


---------------------------------------------------------------------------------
--	Container Functions
---------------------------------------------------------------------------------

function MarketWatcher.FindItemInBags(itemId, qty)
	local bagName, slot, link, itemCount, locked;
	local tmpBag, tmpSlot, tmpItemCount;
	local sumItems = 0;

	for bag = 0, 4 do
		bagName = GetBagName(bag);
		if ( bagName ) then

			for slot = 1, GetContainerNumSlots(bag) do
				link = GetContainerItemLink(bag, slot);
				if ( link ) then

					_, itemCount, locked = GetContainerItemInfo(bag, slot);

					if ( itemId == MarketWatcher.DecodeItemLink(link) and not locked ) then

						sumItems = sumItems + itemCount;

						if (	not qty
							or not tmpBag
							or (tmpItemCount ~= qty and itemCount >= qty)
						) then
							tmpBag, tmpSlot, tmpItemCount = bag, slot, itemCount;
						end
					end
				end
			end
		end
	end

	return tmpBag, tmpSlot, tmpItemCount, sumItems;
end

function MarketWatcher.SplitStack(splitBag, splitSlot, splitCount)

	local numberOfFreeSlots, bag, bagType;

	for bag = 0, 4 do
		numberOfFreeSlots, bagType = GetContainerNumFreeSlots(bag);

		if ( numberOfFreeSlots > 0 and bagType == 0 ) then

			for slot = 1, GetContainerNumSlots(bag) do

				if ( not GetContainerItemInfo(bag, slot) ) then
			
					SplitContainerItem(splitBag, splitSlot, splitCount);
					PickupContainerItem(bag, slot);

					return bag, slot, splitCount;
				end
			end
		end
	end
end


---------------------------------------------------------------------------------
--	Misc Functions
---------------------------------------------------------------------------------

function MarketWatcher.MoneyText(money)
	-- tostring()ing and tonumber()ing to stip off .0s
	if ( money < COPPER_PER_SILVER ) then
		return "|cFFC8A080"..tonumber(format("%.1f", tostring(money))).."|r|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:0:-1|t";

	elseif ( money < COPPER_PER_GOLD ) then
		return "|cFFC8C8C8"..tonumber(format("%.1f", tostring(money / COPPER_PER_SILVER))).."|r|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:0:-1|t";

	elseif ( money > (COPPER_PER_GOLD * 1000) ) then
		return "|cFFD8CC60"..format("%i", (money / COPPER_PER_GOLD)).."|r|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:0:-1|t";
	else
		return "|cFFD8CC60"..tonumber(format("%.1f", tostring(money / COPPER_PER_GOLD))).."|r|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:0:-1|t";
	end
end

function MarketWatcher.DecodeItemLink(link)
	local _, _, itemStr = strsplit("|", link);
	local _, id, enchant, gem1, gem2, gem3, gemBonus, suffix, uId, _, reforge = strsplit(":", itemStr);
	id = tonumber(id) or 0;
	uId = tonumber(uId) or 0;
	local modifiers;
	if ( not enchant or not gem1 ) then
		return
	end
	local modifiers = enchant..":"..gem1..":"..gem2..":"..gem3..":"..gemBonus..":"..suffix..":"..reforge;
	return id, modifiers, uId;
end

function MarketWatcher.CanCreate(itemId)
	local craftedItemId, link, skillName, skillType, numAvail;

	for i = GetFirstTradeSkill(), GetNumTradeSkills() do

		skillName, skillType, numAvail = GetTradeSkillInfo(i);

		if ( skillName and skillType ~= "header" ) then
			link = GetTradeSkillItemLink(i);
			if ( link ) then
				craftedItemId = MarketWatcher.DecodeItemLink(link);
				if ( itemId == craftedItemId ) then
					return i, numAvail;
				end
			end
		end
	end
end

function MarketWatcher.CreateTradeskillSelectorFrame()
	if ( MarketWatcherTradeskillSelectorFrame ) then
		return
	end

	local frame = CreateFrame("Frame", "MarketWatcherTradeskillSelectorFrame", AuctionFrame);

	frame:SetHeight(51);
	frame:SetWidth(95);
	frame:SetPoint("BOTTOMLEFT", AuctionFrame, "BOTTOMRIGHT", 5, 8);
	frame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
			    edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
			    tile = true, tileSize = 16, edgeSize = 16,
			    insets = { left = 4, right = 4, top = 4, bottom = 4 }
	});
	frame:SetBackdropColor(0, 0, 0, 1);

	local prof1, prof2, icon1, icon2, id;

	prof1, prof2 = GetProfessions();
	if ( prof1 ) then
		prof1, icon1 = GetProfessionInfo(prof1);
	end
	if ( prof2 ) then
		prof2, icon2 = GetProfessionInfo(prof2);
	end

	if ( MARKETWATCHER_TRADESKILL_EXCLUDE[prof1] ) then
		prof1 = nil;
	end
	if ( MARKETWATCHER_TRADESKILL_EXCLUDE[prof2] ) then
		prof2 = nil;
	end

	if ( not prof1 and not prof2 ) then
		frame:Hide();
		return
	elseif ( not prof1 or not prof2 ) then
		frame:SetWidth(51);
	end

	if ( prof1 ) then

		if ( icon1 ) then
			button1 = CreateFrame("CheckButton", "MarketWatcherTradeskillSelect1", MarketWatcherTradeskillSelectorFrame, "ActionButtonTemplate, SecureActionButtonTemplate");
			button1:SetHeight(36);
			button1:SetWidth(36);
			button1:SetPoint("TOPLEFT", MarketWatcherTradeskillSelectorFrame, "TOPLEFT", 8, -7);
			button1:SetAttribute("type*", "spell");
			button1:SetAttribute("spell1", prof1);

			_G[button1:GetName().."Icon"]:SetTexture(icon1);
			button1:SetScript("OnEnter", function(self) 
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:AddLine(prof1, 1, 1, 1);
				GameTooltip:AddLine(MARKETWATCHER_TOOLTIP17, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
				GameTooltip:Show();
			end);
			button1:SetScript("OnLeave", function(self) GameTooltip:Hide(); end);
			button1.trade = prof1;
		end
	end
	
	if ( prof2 ) then

		if ( icon2 ) then
			button2 = CreateFrame("CheckButton", "MarketWatcherTradeskillSelect2", MarketWatcherTradeskillSelectorFrame, "ActionButtonTemplate, SecureActionButtonTemplate");
			button2:SetHeight(36);
			button2:SetWidth(36);
			button2:SetPoint("TOPRIGHT", MarketWatcherTradeskillSelectorFrame, "TOPRIGHT", -7, -7);
			button2:SetAttribute("type*", "spell");
			button2:SetAttribute("spell1", prof2);

			_G[button2:GetName().."Icon"]:SetTexture(icon2);
			button2:SetScript("OnEnter", function(self) 
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:AddLine(prof2, 1, 1, 1);
				GameTooltip:AddLine(MARKETWATCHER_TOOLTIP17, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
				GameTooltip:Show();
			end);
			button2:SetScript("OnLeave", function(self) GameTooltip:Hide(); end);
			button2.trade = prof2;
		end
	end
end