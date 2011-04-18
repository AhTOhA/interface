-- TradeSkillMaster_AuctionDB Locale - zhTW
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_AuctionDB/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "zhTW")
if not L then return end

-- L["%s has a market value of %s and was seen %s times last scan and %s times total. The stdDev is %s."] = ""
L["Alchemy"] = "煉金"
L["Auction house must be open in order to scan."] = "必須打開拍賣行才能掃描"
L["AuctionDB"] = "拍賣行數據庫"
L["AuctionDB - Auction House Scanning"] = "拍賣行數據庫-拍賣行掃描"
L["AuctionDB - Run Scan"] = "拍賣行數據庫 - 開始掃描"
L["AuctionDB - Scanning"] = "拍賣行數據庫 - 掃描中"
L["AuctionDB Market Value:"] = "拍賣行數據庫 市場價"
L["AuctionDB Min Buyout:"] = "拍賣行數據庫 最低一口價"
-- L["AuctionDB Seen Count:"] = ""
L["Blacksmithing"] = "鍛造"
L["Complete AH Scan"] = "完全掃描拍賣行"
L["Cooking"] = "烹飪"
L["Enable display of AuctionDB data in tooltip."] = "在鼠標提示中顯示拍賣行數據庫數據"
L["Enchanting"] = "附魔"
L["Engineering"] = "工程"
L["Error: AuctionHouse window busy."] = "錯誤：拍賣行窗口繁忙"
L["GetAll Scan:"] = "全部掃描"
L[ [=[If checked, a GetAll scan will be used whenever possible.

WARNING: With any GetAll scan there is a risk you may get disconnected from the game.]=] ] = "如果選擇了，每次可能時都進行全拍賣行掃描"
L["If checked, a regular scan will scan for this profession."] = "如果選擇了，將進行當前專業的常規掃描"
L["Inscription"] = "銘文"
L["Item Lookup:"] = "查找物品"
L["Jewelcrafting"] = "珠寶"
L["Leatherworking"] = "制皮"
L["No data for that item"] = "沒有當前物品數據"
L["Not Ready"] = "沒准備好"
L["Nothing to scan."] = "沒找到任何物品"
L["Professions to scan for:"] = "掃描的專業"
L["Ready"] = "準備好了"
L["Ready in %s min and %s sec"] = "在%s分鐘%s秒內完成"
L["Run GetAll Scan"] = "進行全拍賣行掃描"
L["Run GetAll Scan if Possible"] = "可能情況下掃描整個拍賣行"
L["Run Regular Scan"] = "進行常規掃描"
L["Run Scan"] = "掃描"
L["Scan complete!"] = "掃描完成"
L["Scan interupted due to auction house being closed."] = "因為拍賣行被關閉掃描中斷"
L[ [=[Starts scanning the auction house based on the below settings.

If you are running a GetAll scan, your game client may temporarily lock up.]=] ] = [=[根據下列設定開始拍賣行掃描.

如果你掃描整個拍賣行，你可能會斷線]=]
L["Tailoring"] = "裁縫"
L["resets the data"] = "重置資料"
-- L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."] = ""
 