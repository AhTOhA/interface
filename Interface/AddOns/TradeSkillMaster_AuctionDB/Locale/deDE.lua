-- TradeSkillMaster_AuctionDB Locale - deDE
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_AuctionDB/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "deDE")
if not L then return end

L["%s has a market value of %s and was seen %s times last scan and %s times total. The stdDev is %s."] = "%s hat einen Marktwert von %s. Es wurde im letzten Scan %s mal und insgesamt %s mal gesehen. Die Standardabweichung beträgt %s." -- Needs review
L["Alchemy"] = "Alchemie" -- Needs review
L["Auction house must be open in order to scan."] = "Das Auktionshaus muss geöffnet sein um scannen zu können." -- Needs review
L["AuctionDB"] = "AuctionDB" -- Needs review
L["AuctionDB - Auction House Scanning"] = "AuctionDB - Auction House Scanning" -- Needs review
L["AuctionDB - Run Scan"] = "AuctionDB - Scan durchführen" -- Needs review
L["AuctionDB - Scanning"] = "AuctionDB - Scannen" -- Needs review
L["AuctionDB Market Value:"] = "AuctionDB Markwert:" -- Needs review
L["AuctionDB Min Buyout:"] = "AuctionDB Min. Sofortkauf" -- Needs review
L["AuctionDB Seen Count:"] = "AuctionDB gesehen:" -- Needs review
L["Blacksmithing"] = "Schmiedekunst" -- Needs review
L["Complete AH Scan"] = "Kompletter AH Scan" -- Needs review
L["Cooking"] = "Kochen" -- Needs review
L["Enable display of AuctionDB data in tooltip."] = "Aktiviere die Anzeige der AuctionDB-Daten im Tooltip." -- Needs review
L["Enchanting"] = "Verzauberkunst" -- Needs review
L["Engineering"] = "Ingenieurskunst" -- Needs review
L["Error: AuctionHouse window busy."] = "Fehler: Auktionshaus-Fenster ist beschäftigt." -- Needs review
L["GetAll Scan:"] = "Komplettscan" -- Needs review
L[ [=[If checked, a GetAll scan will be used whenever possible.

WARNING: With any GetAll scan there is a risk you may get disconnected from the game.]=] ] = [=[Wenn aktiviert, wird immer ein Komplettscan durchgeführt, wenn dies möglich ist.

WARNUNG: bei einem Komplettscan könntest du vom Spiel disconnected werden.]=] -- Needs review
L["If checked, a regular scan will scan for this profession."] = "Wenn aktiviert, wird ein regulärer Scan für diesen Beruf durchgeführt." -- Needs review
L["Inscription"] = "Inschriftenkunde" -- Needs review
L["Item Lookup:"] = "Itemsuche:" -- Needs review
L["Jewelcrafting"] = "Juwelenschleifen" -- Needs review
L["Leatherworking"] = "Lederkunst" -- Needs review
L["No data for that item"] = "Keine Daten für dieses Item" -- Needs review
L["Not Ready"] = "Nicht bereit" -- Needs review
L["Nothing to scan."] = "Nichts zum scannen vorhanden." -- Needs review
L["Professions to scan for:"] = "Beruf zum scannen:" -- Needs review
L["Ready"] = "Bereit" -- Needs review
L["Ready in %s min and %s sec"] = "Bereit in %s Minuten und %s Sekunden" -- Needs review
L["Run GetAll Scan"] = "Starte Komplettscan" -- Needs review
L["Run GetAll Scan if Possible"] = "Starte Komplettscan wenn möglich" -- Needs review
L["Run Regular Scan"] = "Starte normalen Scan" -- Needs review
L["Run Scan"] = "Starte scan" -- Needs review
L["Scan complete!"] = "Scan komplett!" -- Needs review
L["Scan interupted due to auction house being closed."] = "Scan wurde abgebrochen da das Auktionshaus geschlossen wurde." -- Needs review
L[ [=[Starts scanning the auction house based on the below settings.

If you are running a GetAll scan, your game client may temporarily lock up.]=] ] = "Starte den Scan mit der unteren Konfiguration." -- Needs review
L["Tailoring"] = "Schneider" -- Needs review
L["resets the data"] = "Resettet die Daten" -- Needs review
L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."] = "|cffff0000WARNUNG:|r Seit 4.0.1 existiert ein Bug mit Komplettscans, da nur maximal 42554 Auktionen eingelesen werden können. Da das Auktionshaus momentan mehr Auktionen hat, könnten dadurch tausende Items übersehen werden. Bitte nutze normale Scans bis Blizzard diesen Bug fixed." -- Needs review
 