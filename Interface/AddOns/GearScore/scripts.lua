--[[
All materials contained in this "Addon" including, but not limited to, any electronic files, code, audio, themes, or images, are the copyrighted property of Master Games International Inc.
Unauthorized usage is strictly prohibited. In addition, this addon is only authorized for distribution on "playerscore.com", "gearscoreaddon.com", "curse.com", and "wowinterface.com". 
GearScore™, PlayerScore™, and "Ten Ton Hammer™" are Trademarks of Master Games International Inc.
]]


--[[
-- Change Log --

--4.5.02--
* Cataclysm Dungeon Stats will now appear on the 

--4.5.01--
* Updated addon for Wow 4.1.00
* Fixed a bug with the new RegisterPrefix function.
* Fixed a loophole that accidently caused the quick rate mode to appear even in lite mode.

--4.5.00--
* Renamed the tabs to make some more room. (For Future Planned Releases).
* Template Engine Support added for Quick Rate Frame. (See Below)
* Fixed a bug that was causing class color information gathered from quick-scan mode to populate the group(database) tab with table values instead of hex color values.
* Fixed a bug that cuased redundent and usless database operations whenever a player entered/exited an instance of any kind. 
* Masterloot mode will no longer display players from previous instance groups.
* Character Claiming for 
* Quick Rate Mode! In previous versions of the addon, it would become difficult to rate players at the end of a dungeon because they would quickly leave the party.
	The new Quick Rate Mode attempts to remedy this by displaying a small window whenever the user exits a 5-man dungeon. There is now an option in the options menu
	that can disable this feature. You can also type "/psrate" at any time to open the window and rate party members. Due to previous limits within addon, only players
	who have been scanned by the addon at some point since the last login will appear in the quick rate frame. Finally, all players who join your party at some point 
	during the instance will be listed in the Quick Rate Frame. This means players who join and are then vote-kicked or abandon the instance will appear for you to rate.
	
	The Quick Rate Mode will display each Player's Name (Colored by Class), their GearScore, and Thumbs Up/Down for rating. In addition an Icon will be displayed for 
	viewing the negative and positive factors in a player's score.		

]]


local AceLocale = LibStub("AceLocale-3.0");
local L = AceLocale:GetLocale("GearScore4");
local f = TenTonHammer;
local gg = CreateFrame("Frame","TenTonHammer_InspectFrame",  UIParent);
gg:SetPoint("CENTER",0,0);
gg:Show();
local fName = f:GetName();
tinsert(UISpecialFrames, fName);
local OriginalInspectUnit = InspectUnit;
local MyInspectUnit = function(unit)
	f:Scan(unit);
end;
f.InspectReady = true;
f.Inspecting = false;
f.InCombat = false;
f.TTrottle = 0;
f.Callback = {};
f.Realm = GetRealmName() or "";
f.Region = string.sub(GetCVar("realmList"),1,2);
f.PartyData = {};
f.DatabaseVersion = 4111;
f.PlayerName = UnitName("player");
f.ScanQue = {};
f.AIL_Info = {};
f.data = {
	["Version"] = 40502,
	["Beta"] = false,
	["TemplateVersion"] = 100,
	["EquipmentOrder"] = {1,2,3,15,5,9,10,6,7,8,11,12,13,14,16,17,18},
	["CD"] = {
		[1] = { "PlayerScore Pro", nil },
		[2] = { "PlayerScore Elite", "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8" },
		[3] = { "PlayerScore Ultra", "Interface\\TargetingFrame\\UI-TargetingFrame-Skull" },
		[4] = { "Über Lizard Robot Alien Attack Squad", "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1" },
	},
	["Special"] = {
		["us"] = {
			["Area 52"] = {
				["Zendweller"] = { "Pocket Dictator", "And in this one, the player can't control me - 'CUZ YOU CAN'T CONTROL ME!!!'" },
			},
			["Detheroc"] = {
				["Arxkanite"] = { "Author of GearScore & PlayerScore/", "I am the programmer who created GearScore." },
				["Halcyana"] = { "Killing Machine", "I kill, you die!" },
				["Smackmonkey"] = { "Big Pimpin'", "The Original Big Pimpin', Useful for up to 34 seconds." },
				["Dairyshot"] = { "El Jefe", "The Boss" },
				["Nareli"] = { "Boned", "BONE STORM!" },
				["Snugglydeath"] = { "Pure Awesomness", "The coldest Canadian" },
			},
			["Azuremyst"] = {
				["Panserbjørne"] = { "TradeChat", "'GEARSCORE should DIE in a FIRE'", },
			},
			["Shadowmoon"] = {
				["Scyz"] = { "'Main Tank'", "I'll just ignore the people who don't get the joke!" },
				["Aramina"] = { "Scyz's Pocket Healer", "Because he is the main tank!" },
				--["Arxkanite"] = { "Author of GearScore", "I am the programmer who created GearScore." },
				["Hedravalis"] = {"I'm a goblin", "I'm real-life goblin" },
			},
			["Hyjal"] = {
				["Ralinadria"] = { "The Angry Guildmaster", "What's your GearScore?" },
			},
			["Feathermoon"] = {
				["Yournamehere"] = { "PlayerScore Pro", "PlayerScore Elite Member" },
			},
			["Sen'jin"] = {
				["Haveagoodone"] = { "PlayerScore Ultra", "PlayerScore Ultra Member" },
			},
			["Fizzcrank"] = {
				["Biggjack"] = { "PlayerScore Ultra", "PlayerScore Ultra Member" },
			},
		},
	},
	["Bosses"] = {
		[48005] = 314910;
		[51355] = 314910;
		[50369] = 314910;
		[49820] = 314910;
		[46471] = 314910;
		[44744] = 314910;
		[42307] = 314910;
		[39867] = 314910;
		[46484] = 314910;
		[46502] = 314910;
		[49533] = 314910;
		[49420] = 314910;
		[48572] = 314910;
		[46957] = 314910;
	},
	["TemplateList"] = {
	},
	["TempItemList"] = {
	},
	["DefaultSettings"] = {
			["scale"] = 5,
			["inspect"] = 1,
			["chat"] = 1,
			["database"] = 1,
			["button_hammer"] = 0,
			["collapse"] = 1,
			["usertips"] = 1,
			["itemtips"] = 1,
			["masterloot"] = 1,
			["pveOnTip"] = 0,
			["pvpOnTip"] = 0,
			["raidOnTip"] = 0,
			["gearOnTip"] = 1,
			["delay"] = 500,
			["ratingOnTip"] = 0,
			["minimap_button"] = 1,
			["panel"] = 0,
			["foobar"] = 0,
			["anchor"] = "TOPRIGHT",
			["online"] = 1,
			["update"] = 0,
			["DDL"] = 1,
			["color"] = "yellow",
			["EquipTab"] = 1,
			["TalentTab"] = 1,
			["ExperienceTab"] = 1,
			["PvPTab"] = 1,
			["NewsTab"] = 1,
			["GroupTab"] = 1,
			["Theme"] = "Neon",
			["target_inspect1"] = 1,
			["showOffSpec"] = 0,
			["ailOnTip"] = 1,
			["verbose"] = 1,
			["addonMode"] = 0,
			["quickrate"] = 1,
		};
	["DungeonList"] = {
		[L["Cataclysm"]]  = {
			[15096] = {
				[20] = "Blackwing Descent",
				[33] = "Bastion of Twilight",
				[42] = "Throne of the Four Winds",
				[19] = "Baradin Hold",
			},
		},
		[L["Wrath of the Lich King"]]  = {
			[15062] = {
				[20] = "Heroic Icecrown 25 player",
				[19] = "Icecrown 25 player",
				[18] = "Heroic Icecrown 10 player",
				[17] = "Icecrown 10 player",
				[67] = "Ruby Sanctum 10 player",
				[68] = "Heroic Ruby Sanctum 10 player",
				[69] = "Ruby Sanctum 25 player",
				[70] = "Heroic Ruby Sanctum 25 player",
			},
			[15021] = {
				[17] = "Trial of the Crusader 10 player",
				[18] = "Trial of the Grand Crusader 10 player",
				[19] = "Trial of the Crusader 25 player", 
				[20] = "Trial of the Grand Crusader 25 player",
			},
			[14963] = {
				[20] = "Ulduar 25 player",
				[1] = "Ulduar 10 player",
			},
			[14823] = {
				[30] = "Naxxramas 10 player",
				[41] = "Naxxramas 25 player",
				[60] = "Wintergrasp 10 player",
				[61] = "Wintergrasp 25 player",
			},
		},
	},
	ColorArray = {
		[0] = { .55, .55, .55  },
		[1] = { .55, .55, .55 },
		[2] = { 1, 1, 1 },
		[3] = { .12, 1, 0 },
		[4] = { 0, .5, 1 },
		[5] = { .69, .28, .97 },
		[6] = { .94, .47, 0 },
		[7] = { 1, 0, 0 },
		[8] = { 1, 0, 0 },
	},
	Color100Array = {
		[0] = { 1, 0, 0 },
		[1] = { 1, .2, 0 },
		[2] = { 1, .4, 0 },
		[3] = { 1, .6, 0 },
		[4] = { 1, .8, 0 },
		[5] = { 1, 1, 0 },
		[6] = { .8, 1, 0 },
		[7] = { .6, 1, 0 },
		[8] = { .4, 1, 0 },
		[9] = { .2, 1, 0 },
		[10] = { 0, 1, 0 },
	},
	["LiteScanData"] = {},
	["Enchantable"] = 
	{
		["INVTYPE_2HWEAPON"] = 1;
		["INVTYPE_WEAPONMAINHAND"] = 1;
		["INVTYPE_WEAPONOFFHAND"] = 1;
		["INVTYPE_RANGED"] = 1;
		["INVTYPE_SHIELD"] = 1;
		["INVTYPE_WEAPON"] = 1;
		["INVTYPE_HEAD"] = 1;
		["INVTYPE_SHOULDER"] = 1;
		["INVTYPE_CHEST"] = 1;
		["INVTYPE_ROBE"] = 1;
		["INVTYPE_LEGS"] = 1;
		["INVTYPE_FEET"] = 1;
		["INVTYPE_WRIST"] = 1;
		["INVTYPE_HAND"] = 1;
		["INVTYPE_FINGER"] = 2;
		["INVTYPE_CLOAK"] = 1;
		["INVTYPE_HOLDABLE"] = 1;
	},
	["ItemTypes"] = 
	{
		["INVTYPE_RELIC"] = { ["SlotMOD"] = .3164, ["ItemSlot"] = 18, ["Enchantable"] = 0, ["Weapon"] = 0 },
		["INVTYPE_TRINKET"] = { ["SlotMOD"] = .5625, ["ItemSlot"] = 33, ["Enchantable"] = 0, ["Weapon"] = 0  },
		["INVTYPE_2HWEAPON"] = { ["SlotMOD"] = 2, ["ItemSlot"] = 16, ["Enchantable"] = 1, ["Weapon"] = 2  },
		["INVTYPE_WEAPONMAINHAND"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 16, ["Enchantable"] = 1, ["Weapon"] = 1  },
		["INVTYPE_WEAPONOFFHAND"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 17, ["Enchantable"] = 1, ["Weapon"] = 1  },
		["INVTYPE_RANGED"] = { ["SlotMOD"] = .3164, ["ItemSlot"] = 18, ["Enchantable"] = 1, ["Weapon"] = 0  },
		["INVTYPE_THROWN"] = { ["SlotMOD"] = .3164, ["ItemSlot"] = 18, ["Enchantable"] = 0, ["Weapon"] = 0  },
		["INVTYPE_RANGEDRIGHT"] = { ["SlotMOD"] = .3164, ["ItemSlot"] = 18, ["Enchantable"] = 0, ["Weapon"] = 0  },
		["INVTYPE_SHIELD"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 17, ["Enchantable"] = 1, ["Weapon"] = 1  },
		["INVTYPE_WEAPON"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 36, ["Enchantable"] = 1, ["Weapon"] = 1  },
		["INVTYPE_HOLDABLE"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 17, ["Enchantable"] = 0, ["Weapon"] = 1  },
		["INVTYPE_HEAD"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 1, ["Enchantable"] = 1, ["Weapon"] = 0  },
		["INVTYPE_NECK"] = { ["SlotMOD"] = .5625, ["ItemSlot"] = 2, ["Enchantable"] = 0, ["Weapon"] = 0  },
		["INVTYPE_SHOULDER"] = { ["SlotMOD"] = .75, ["ItemSlot"] = 3, ["Enchantable"] = 1, ["Weapon"] = 0  },
		["INVTYPE_CHEST"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 5, ["Enchantable"] = 1, ["Weapon"] = 0  },
		["INVTYPE_ROBE"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 5, ["Enchantable"] = 1, ["Weapon"] = 0  },
		["INVTYPE_WAIST"] = { ["SlotMOD"] = .75, ["ItemSlot"] = 6, ["Enchantable"] = 0, ["Weapon"] = 0  },
		["INVTYPE_LEGS"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 7, ["Enchantable"] = 1, ["Weapon"] = 0  },
		["INVTYPE_FEET"] = { ["SlotMOD"] = .75, ["ItemSlot"] = 8, ["Enchantable"] = 1, ["Weapon"] = 0  },
		["INVTYPE_WRIST"] = { ["SlotMOD"] = .5625, ["ItemSlot"] = 9, ["Enchantable"] = 1, ["Weapon"] = 0  },
		["INVTYPE_HAND"] = { ["SlotMOD"] = .75, ["ItemSlot"] = 10, ["Enchantable"] = 1, ["Weapon"] = 0  },
		["INVTYPE_FINGER"] = { ["SlotMOD"] = .5625, ["ItemSlot"] = 31, ["Enchantable"] = 2, ["Weapon"] = 0  },
		["INVTYPE_CLOAK"] = { ["SlotMOD"] = .5625, ["ItemSlot"] = 15, ["Enchantable"] = 1, ["Weapon"] = 0  },
	},
	["Roles"] = {
		[0] = "Any",
		[1] = "Tank",
		[2] = "Physical DPS",
		[5] = "Caster DPS",
		[6] = "Caster",
		[20] = "PvP",
	},
	["RoleStats"] = { 
		[0] = {
			"STA",
			"INT",
			"SPI",
			"AGI",
			"STR",
			"MASTERY",
		},
		[1] = {
			"STA",
			"STR",
			"AGI",
			"DODGE",
			"PARRY",
			"CRIT",
			"MASTERY",
		},
		[5] = {
			"STA",
			"INT",
			"SPI",
			"HASTE",
			"CRIT",
			"TOHIT",
			"MASTERY",
		},
		[6] = {
			"STA",
			"INT",
			"SPI",
			"HASTE",
			"CRIT",
		},
		[2] = {
			"STA",
			"STR",
			"AGI",
			"CRIT",
			"EXPERTISE",
			"TOHIT",
			"MASTERY",
		},
	},
	["DayCount"] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 },
	["ClassRoles"] = {
		["SHAMAN"] = { 
			[261] = 5,
			[263] = 2,
			[262] = 6,
			[0] = 0,
		},
		["PRIEST"] = { 
			[760] = 6,
			[813] = 6,
			[795] = 5,
			[0] = 6,
		},
		["ROGUE"] = { 
			[182] = 2,
			[181] = 2,
			[183] = 2,
			[0] = 2,
		},
		["WARRIOR"] = { 
			[746] = 2,
			[815] = 2,
			[845] = 1,
			[0] = 2,
		},
		["DEATHKNIGHT"] = {
			[398] = 1,
			[399] = 2,
			[400] = 2,
			[0] = 2,
		},
		["MAGE"] = {
			[799] = 5,
			[851] = 5,
			[823] = 5,
			[0] = 5,
		},
		["WARLOCK"] = {
			[871] = 5,
			[867] = 5,
			[865] = 5,
			[0] = 5,
		},
		["HUNTER"] = {
			[811] =	2,
			[807] = 2,
			[809] = 2,
			[0] = 2,
		},
		["DRUID"] = {
			[752] = 5,
			[750] = 1,
			[748] = 6,
			[0] = 0,
		},
		["PALADIN"] = {
			[831] = 6,
			[839] = 1,
			[855] = 2,
			[0] = 0,
		},
	},
}
f.Help = {
	["Questions"] = {
		[1] = L["Introduction"],
		[2] = L["What is PlayerScore?"],
		[3] = L["What exactly is the Updater?"],
		[4] = L["How are scores calculated?"],
		[5] = L["How do I use the addon?"],
		[6] = L["Why isn't scoring instant?"],
		[7] = L["Does this addon spam?"],
		[8] = L["What happened to the database?"],
		[9] = L["How can I claim my character?"],
	},
	["Answers"] = {
		[L["Introduction"]] = L["Welcome to GearScore/PlayerScore 4.0\n\nGearScore is now PlayerScore, a collaboration between GearScore and MMORPG news and guides website, TenTonHammer.com. With a vast array of features, easy to use interface, and an integrated web component, PlayerScore is the most powerful addon experience ever created for World of Warcraft.\n\nClick a Question on the left to view more information and in-game help."],
		[L["What is PlayerScore?"]] = L["PlayerScore is a world wide player ranking and information service for World of Warcraft. PlayerScore is comprised of a Web-based component, an auto-updater, and an in-game addon. These components work together to create the most powerful addon experience ever created for WoW.\n\nThe Web-based component allows you to view world-wide rankings and scores for any player as well as allowing you to comment and rate other players.\n\nThe Addon is this program your using right now and allows you to view scores in-game as well as providing essential information about other players. You can rate players you play with and upload the data to PlayerScore.com via the Updater.\n\nThe Updater allows you to download the scores and ratings of every player on your server, keeps the addon up to date, and uploads in-game ratings and data collected from the addon."],
		[L["How are scores calculated?"]] = L["|cffff0000GearScore|r is based on the equipment a player wears. It factors item level, gems, enchants, and appropriateness to class and spec.\n\n|cffff0000Raid Score|r is based on experience in raids and bosses killed.\n\n|cffff0000PvE Score|r is based on Quests and dungeons completed, and faction standing.\n\n|cffff0000PvP Score|r is based on your Arena & Battleground participation, rankings, win/loss ratio, and PvP Kills.\n\n|cffff0000Player Rating|r is based on ratings from other players."],
		[L["What exactly is the Updater?"]] = L["The Updater is a completely optional piece of software written by Ten Ton Hammer which is completely external to World of Warcraft. It keeps the AddOn up-to-date, uploads data you gather and ratings you assign (so that they can be shared with others), and (if you so choose) downloads character information from Ten Ton Hammer for you to view in-game. If you never run the Updater, your data won't be shared and no one else will know how you rated other players.\n\nThe Updater doesn't collect any personal information. It only transmits scores and ratings for characters and never your World of Warcraft Account Name or Password. |cffff0000You should never give your password to anyone."],
		[L["How do I use the addon?"]] = L["Using the addon is very simple. Simply target any player and inspect them. You can right click their picture and choose inspect from the options menu or you can type '/inspect'. The PlayerScore addon will appear and display information about this player to you.\n\nYou can check each tab to view detailed information, or use the summary tab for a break down of the most essential data."],
		[L["Why isn't scoring instant?"]] = L["Information used to calculate scores isn't instantly available to the addon. Achievements, Statistics, Talents, Gems, and Reforging status must be requested from the server. PlayerScore makes the request but for some information there is no way of knowing when the request has be fulfilled. To compensate, PlayerScore will wait an amount of time dependent on your latency before processing the score.\n\nSome players will take longer to score then others because of how the game client handles item caching and reforging. Each time you view an item in game it is stored in your local 'Item Cache'. Then each time you request that item the client will simply display the info from the cache. Now that reforging has been added to the game the cache isn't very useful anymore. Each item can have many different versions of itself depending on which stats were reforged. When PlayerScore requests the items from the server they may appear as non-existant until the cache updates the reforged item. When this occurs, the addon will wait additional time before processing and scoring this player."],
		[L["Does this addon spam?"]] = L["GearScore/PlayerScore 4.0 no longer contains automatic data communication aside from a single version number announcement when you first login.\n\nPrevious versions of GearScore would automatically transmit player information to other guildmates in order to allow everyone's database to stay up-to-date. This feature has been completely removed from GearScore/PlayerScore 4.0.\n\nGearScore/PlayerScore now relies on the updater to keep your database up-to-date. If you choose to use the updater then scores for every player on your server will be downloaded automatically. Otherwise only information you have personally gathered with the addon will be saved to your database."],
		[L["What happened to the database?"]] = L["In GearScore 3.0 the database stored a vast array of information about a player to allow for the remote armory feature. This information required an unreasonable amount of system resources and generally slowed a player's computer down.\n\nThe PlayerScore Updater has the ability to download a database of every player on your server, However this information is minimal and is 95% smaller then the GearScore 3.0 database.\n\nIn GearScore/PlayerScore 4.0 the remote armory feature was removed. However, you can now right-click their names in your chat window to generate a link to their Online PlayerScore profile. This profile shows you scores, ratings, rankings, and even comments on any player."],
		[L["How can I claim my character?"]] = L["Claiming your wow characters is very easy. Simply type '/claim' into your chat window. PlayerScore will generate a validation URL. Copy the URL and paste it into your browser. This will take you to PlayerScore's website and complete the character claiming process.\n\nClaimed characters earn a special in-game title viewable by all PlayerScore users. In addition you can track comments and ratings on your character and respond to criticism."],
	},
}
LK_DUNGEONS={ ["5 Man"]={ ["T7"]={ ["N"]={ 1232, 1235, 1236, 1233, 1242, 1231, 1240, 1239, 1238, 1241, 1237, 1234, }, ["S"]={ 1506, 1509, 1510, 1507, 1504, 1505, 1514, 1513, 1512, 1515, 1511, 1508, }, ["T"]={ 2136, }, }, ["T9"]={ ["N"]={ 4026, }, ["S"]={ 4027, }, ["T"]={ }, }, ["T10"]={ ["N"]={ 4714, 4723, 4719, 4725, }, ["S"]={ 4716, 4727, }, ["T"]={ 4728, 4519, 4520, 4521, }, }, }, ["10 Man"]={ ["N"]={ ["N"]={ 1361, 2860, 2868, 4028, 4648, 3917, 4645, 4646, 4036, 2856, 1372, 1366, 1362, 1371, 4644, 1369, 2858, 1374, 2861, 4643, 4032, 4639, 1365, 1364, 2867, 4647, 4044, 4040, 4649, 2859, }, ["S"]={ 4651, 2864, 2862, 1370, 1363, 2865, 4650, 4652, 1373, 1375, 2863, }, ["T"]={ 2867, 2903, 2870, 4532, 2866, 1377, 4074, 1391, 4396, 1376, 1392, 576, 2894, 2051, 2187, 4016, 2869, 1874, }, }, ["H"]={ ["N"]={ 4030, 4671, 4662, 4037, 4665, 4659, 4654, 4653, 4033, 4640, 4668, 4045, 4041, 4674, }, ["S"]={ 4680, 3056, 4677, 4684, }, ["T"]={ 4080, 3810, 3809, 3159, 3918, 4636, 3180, 3004, 3058, 2941, 3181, 3179, 4868, 3158, 4567, }, }, }, ["25 Man"]={ ["N"]={ ["N"]={ 1368, 2885, 2882, 4031, 4672, 4663, 4038, 4666, 2872, 1383, 1378, 1379, 1380, 1381, 4660, 2874, 1384, 2875, 4655, 4043, 4641, 1387, 1367, 2873, 4669, 2884, 4042, 4675, }, ["S"]={ 1754, 4681, 3258, 3256, 1385, 1386, 2879, 4678, 1388, 3257, 4046, }, ["T"]={ 2881, 3916, 2904, 4017, 3236, 4608, 2880, 1390, 4075, 4687, 1394, 4397, 1389, 1393, 577, 2895, 2186, 2054, 4658, 2883, 1875, }, }, ["H"]={ ["N"]={ 4029, 4673, 4664, 4667, 4039, 4661, 4656, 4035, 4642, 4670, 4043, 4676, }, ["S"]={ 4682, 3057, 4679, 4047, }, ["T"]={ 3819, 3818, 3164, 3812, 4637, 3189, 3005, 3059, 2944, 3188, 3187, 4688, 3163, 4685, }, }, }, }; 
f.PassiveBonuses = {
	{ pattern = string.gsub(ITEM_MOD_DEFENSE_SKILL_RATING, "%%d", "(%%d+)%%"), effect = "DEFENSE" },
 	{ pattern = string.gsub(ITEM_MOD_RESILIENCE_RATING, "%%d", "(%%d+)%%"), effect = "RESILIENCE" }	, 
  	{ pattern = string.gsub(ITEM_MOD_EXPERTISE_RATING, "%%d", "(%%d+)%%"), effect = "EXPERTISE" },
	{ pattern = string.gsub(ITEM_MOD_BLOCK_RATING, "%%d", "(%%d+)%%"), effect = "BLOCK" },
	{ pattern = string.gsub(ITEM_MOD_DODGE_RATING, "%%d", "(%%d+)%%"), effect = "DODGE" },
	{ pattern = string.gsub(ITEM_MOD_PARRY_RATING, "%%d", "(%%d+)%%"), effect = "PARRY" },
	{ pattern = string.gsub(ITEM_MOD_CRIT_RATING , "%%d", "(%%d+)%%"), effect = "CRIT" },
	{ pattern = string.gsub(ITEM_MOD_CRIT_MELEE_RATING, "%%d", "(%%d+)%%"), effect = "CRIT" },
	{ pattern = string.gsub(ITEM_MOD_HIT_RATING, "%%d", "(%%d+)%%"), effect = "TOHIT" },
	{ pattern = string.gsub(ITEM_MOD_HASTE_RATING, "%%d", "(%%d+)%%"), effect = "HASTE" },
	{ pattern = string.gsub(ITEM_MOD_MASTERY_RATING, "%%d", "(%%d+)%%"), effect = "MASTERY"},
	{ pattern = string.gsub(ITEM_MOD_ARMOR_PENETRATION_RATING , "%%d", "(%%d+)%%"), effect = "ARMORPEN" },
};
f.GenericBonuses = {
	[SPELL_STATALL] 					= {"STR", "AGI", "STA", "INT", "SPI"},
	["to All Stats"] 					= {"STR", "AGI", "STA", "INT", "SPI"},
	[ITEM_MOD_STRENGTH_SHORT]			= "STR",
	[ITEM_MOD_AGILITY_SHORT]			= "AGI",
	[ITEM_MOD_STAMINA_SHORT]			= "STA",
	[ITEM_MOD_INTELLECT_SHORT]			= "INT",
	[ITEM_MOD_SPIRIT_SHORT]				= "SPI",
	[STAT_ATTACK_POWER] 				= "ATTACKPOWER",
	[ITEM_MOD_CRIT_RATING_SHORT] 		= "CRIT",
	[ITEM_MOD_MASTERY_RATING_SHORT] 	= "MASTERY",
	[COMBAT_RATING_NAME3] 				= "DODGE",
	[COMBAT_RATING_NAME4] 				= "PARRY",
	[COMBAT_RATING_NAME15] 				= "RESILIENCE",
	[COMBAT_RATING_NAME24] 				= "EXPERTISE",
	[ITEM_MOD_EXPERTISE_RATING_SHORT] 	= "EXPERTISE",
	[ITEM_MOD_DODGE_RATING_SHORT]		= "DODGE",
	[COMBAT_RATING_NAME5]				= "BLOCK",
	[COMBAT_RATING_NAME6]				= "TOHIT",
	[RESILIENCE]						= "RESILIENCE",
};	
local BONUSSCANNER_PATTERN_SETNAME = "^(.*) %(%d/%d%)$";
local BONUSSCANNER_PATTERN_GENERIC_PREFIX = "^%+?(%d+)%%?(.*)$";
local BONUSSCANNER_PATTERN_GENERIC_SUFFIX = "^(.*)%+ ?(%d+)%%?$";
local BONUSSCANNER_PATTERN_GENERIC_SUFFIX2 = "^(.*)%s(%d+)%%";
local function DebugTable(Item, Table)
	print("-- DEBUG FOR: "..Item.." --");
	for i,v in pairs(Table) do
		print(i,v);
	end;
end;
function f:ScanItem(ItemLink)
	if ( not ItemLink ) or ( ItemLink == "") then return; end;
	local Enchant;
	local _, EnchantId = ItemLink:match("item:(%-?%d+):(%-?%d+)");
	local Bonuses = {};
	Bonuses = f:ScanTooltip(ItemLink, Bonuses);
	if ( enchantID ) and ( enchantID ~= "0" ) then
		SpecialEnchants = f.data.SpecialEnchants[tonumber(enchantID)];
		if ( SpecialEnchants ) then
			for Effect, Value in pairs(SpecialEnchants) do
				Bonuses = f:AddValue(Effect, Value, Bonuses);
			end;
		end;
	end;
	return Bonuses;
end;
function f:ScanTooltip(ItemLink, Bonuses)
	TenTonHammerTooltip:SetOwner(f,"ANCHOR_NONE");
	TenTonHammerTooltip:ClearLines();
	TenTonHammerTooltip:SetHyperlink(ItemLink);
	local LeftText, Line, RightText, Line2, RightLine, Red, Green, Blue;
	local LineCount = TenTonHammerTooltip:NumLines();
	for LineNumber = 1, LineCount do
		
		LeftText = _G["TenTonHammerTooltipTextLeft"..LineNumber];
		if ( LeftText:GetText() ) then
			Line = LeftText:GetText();
			Red, Green, Blue = LeftText:GetTextColor();
			Red, Green, Blue = ceil(Red*255), ceil(Green*255), ceil(Blue*255);
			Bonuses = f:ScanLine(Line, Red, Green, Blue, Bonuses);
		end;
	end;
	return Bonuses;
end;
function f:ScanLine(Line, Red, Green, Blue, Bonuses)
	local TempString, Found, NewLine, ff, Value;
	if ( (Red==128) and (Green==128) and (Blue==128) ) or (string.sub(Line,0,10) == "|cff808080") then
		return Bonuses;
	end;
	if ( string.sub(Line,0, string.len(ITEM_SPELL_TRIGGER_ONEQUIP)) == ITEM_SPELL_TRIGGER_ONEQUIP ) then
		TempString = string.sub(Line, string.len(ITEM_SPELL_TRIGGER_ONEQUIP)+2);
		Bonuses = f:CheckPassive(TempString, Bonuses);
	elseif ( string.sub(Line, 0, string.len(string.gsub(ITEM_SOCKET_BONUS, "%%s", ""))) == string.gsub(ITEM_SOCKET_BONUS, "%%s", "") ) then
		if ( (Red == 0) and (Green == 255) and (Blue == 0) ) then
			TempString = string.sub(Line, string.len( string.len(string.gsub(ITEM_SOCKET_BONUS, "%%s", "")))+1);
			Bonuses, Found = f:CheckOther(TempString, Bonuses);
			if ( not Found ) then
				Bonuses = f:CheckGeneric(TempString, Bonuses);
			end;
		end;
	else
		if ( string.sub(Line,0,10) == "|cffffffff" ) or ( string.sub(Line, 0, 10) == "|cffff2020" ) then
			NewLine = string.sub(Line, 11, -3);
			Line = NewLine;
			Line = string.gsub(Line, "%|$", "" );
		end;
		Bonuses, Found = f:CheckOther(Line, Bonuses);
		if ( not Found ) then
			Bonuses = f:CheckGeneric(Line, Bonuses);
		end;
	end;
	return Bonuses;
end;
function f:CheckOther(Line, Bonuses)
	return Bonuses, false;
end;
function f:CheckGeneric(Line, Bonuses)
	local Value, Token, POS, POS2, POS3, TempString, Sepend;
	Line = string.gsub( Line, "\n", L["GLOBAL_SEP"]);
	while ( string.len(Line) > 0 ) do
		for _, SEP in ipairs(L["SEPARATORS"]) do
			Line = string.gsub(Line, SEP, L["GLOBAL_SEP"]);
		end;
		POS = string.find(Line, L["PREFIX_SET"], 1, true);
		if ( POS ) then
			return Bonuses;
		end;
		POS = string.find(Line, L["GLOBAL_SEP"], 1, true);
		if ( POS ) then
			TempString = string.sub(Line,1,POS-1);
			Line = string.sub(Line, POS + string.len(L["GLOBAL_SEP"]));
		else
			TempString = Line;
			Line = "";
		end;
		TempString = string.gsub( TempString, "^%s+", "" );
		TempString = string.gsub( TempString, "%s+$", "" );
		TempString = string.gsub( TempString, "%.$", "" );
		TempString = string.gsub( TempString, "\n", "" );
		_, _, Value, Token = string.find(TempString, BONUSSCANNER_PATTERN_GENERIC_PREFIX);
		if ( not Value ) then
			_, _, Token, Value = string.find(TempString, BONUSSCANNER_PATTERN_GENERIC_SUFFIX);
		end;
		if ( not Value ) then
			_, _, Token, Value = string.find(TempString, BONUSSCANNER_PATTERN_GENERIC_SUFFIX2);
		end;
		if ( Token ) and ( Value ) then
			Token = string.gsub( Token, "^%s+", "" );
			Token = string.gsub( Token, "%s+$", "" );
			Token = string.gsub( Token, "%.$", "" );
			Token = string.gsub( Token, "|r", "" );
			Bonuses = f:CheckToken(Token, Value, Bonuses);
		else
			Bonuses, Found = f:CheckOther(TempString, Bonuses);
		end;
	end;
	return Bonuses;
end;
function f:CheckToken(Token, Value, Bonuses)
	local S1, S2;
	if ( strlower(Token) == strlower(SPELL_STATALL) ) then Token = SPELL_STATALL; end;
	if ( f.GenericBonuses[Token] ) then
		Bonuses = f:AddValue( f.GenericBonuses[Token], Value, Bonuses ) 
	end;
	return Bonuses;
end;
function f:CheckPassive(Line, Bonuses)
	local Results, ResultCount, Found, Start, Value;
	for i,v in pairs(f.PassiveBonuses) do
		Results = {string.find(Line, "^" .. v.pattern)}
		if ( Results ) then ResultCount = #Results; end;
		if ( ResultCount ) == 3 then
			Bonuses = f:AddValue(v.effect, Results[3], Bonuses);
			Found = 1;
			break;
		end;
		Start, _, Value = string.find(Line, "^"..v.pattern);
		if ( Start ) and ( v.value ) then
			Bonuses = f:AddValue(v.effect, v.value, Bonuses);
			Found = 1;
			break;
		end;
	end;
	return Bonuses;
end;
function f:AddValue(Effect, Value, Bonuses)
	if ( type(Effect) == "string" ) then
		Value = tonumber(Value);
		Bonuses[Effect] = ( Bonuses[Effect] or 0 ) + Value;
	else
		if ( type(Value) == "table" ) then
			for i,v in pairs(Effect) do
				Bonuses = f:AddValue(v, Value[i], Bonuses);
			end;
		else
			for i,v in pairs(Effect) do
				Bonuses = f:AddValue(v, Value, Bonuses);
			end;
		end;
	end;
	return Bonuses;
end;
f:SetScript("OnEvent",
	function (null, eventName, ... )
		f[eventName](null, eventName, ... );
		if ( f.Callback[eventName] ) then
			f.Callback[eventName](null, eventName, ...);
			f.Callback[eventName] = nil;
		end;
	end
);
f:RegisterEvent("CHAT_MSG_ADDON");
f:RegisterEvent("PLAYER_TARGET_CHANGED");
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("PLAYER_LOGOUT");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("PLAYER_REGEN_ENABLED");
f:RegisterEvent("PLAYER_REGEN_DISABLED");

function f:PLAYER_ENTERING_WORLD()
	if not ( f.Active ) then
		f.Active = true;
		if ( TenTonHammer_Settings["database"] == 0 ) then 
			TenTonHammer_Database[f.Realm] = {};
		end;
		if ( RegisterAddonMessagePrefix ) and ( type(RegisterAddonMessagePrefix) == "function" ) then
			RegisterAddonMessagePrefix("GSY_Version");
		end;
		local TodayCount = f:GetConvertedDays(f:GetTimeStamp());
		local CleanCount = 0;
		for i,v in pairs(TenTonHammer_Database[f.Realm]) do
			if ( ( TodayCount - f:GetConvertedDays(string.sub(v, 0, 12)) ) > 14 ) or ( string.find(v, "::") ) then
				TenTonHammer_Database[f.Realm][i] = nil;
				CleanCount = CleanCount + 1;
			end;
		end;
		if ( CleanCount > 0 ) then
			print("|cffff0000PlayerScore: |rRemoved "..CleanCount.." outdated entries from your PlayerScore Database.");
		end;
		f:PLAYER_LOGOUT();
	end;
	local isInstance, instanceType = IsInInstance();
	if ( isInstance ) and ( instanceType == "party" ) then
		f.InInstance = true;
		f.PartyData = {};
	elseif not ( isInstance ) then
		if ( f.InInstance ) and ( TenTonHammer_Settings["quickrate"] == 1 ) then
			TenTonHammer_QuickRateFrame:Show();
		end;
		f.InInstance = false;
	end;
end;
function f:PLAYER_LOGOUT()
	if not ( TTHD ) then
		TTHD = "";
	end;
	if ( TenTonHammer_Ratings ) and ( #TenTonHammer_Ratings ) then
		for i,v in pairs(TenTonHammer_Ratings) do
			if ( TTHD ~= "" ) then
				TTHD = TTHD.."@"..v;
			else
				TTHD = v;
			end;
		end;
	end;	
end;
function f:INSPECT_READY()
	f:UnregisterEvent("INSPECT_READY");
end;
function f:ADDON_LOADED(EventName, AddonName)
	if ( AddonName == "GearScore" ) then
		_G[fName.."_WaitFrame_Text"]:SetText("|cffffffff"..L["Calculating scores, shining shields, putting the Gob in Goblins."].."\n"..L["Just keep sitting there in your underwear for approximately 2 seconds."].."\n"..L["This section will automagically refresh when we're done. Thanks!"]);
		if not ( TenTonHammer_Database ) then 
			TenTonHammer_Database = {}; 
			TenTonHammer_Database["Version"] = f.DatabaseVersion;
			TenTonHammer_Database[f.Realm] = {};
		elseif not ( TenTonHammer_Database["Version"] ) or ( TenTonHammer_Database["Version"] < f.DatabaseVersion ) then
			TenTonHammer_Database = {}; 
			TenTonHammer_Database["Version"] = f.DatabaseVersion;
			TenTonHammer_Database = {};	
		end;	
		if not ( TenTonHammer_Database[f.Realm] ) then
			TenTonHammer_Database[f.Realm] = {};
		end;
		if not ( TenTonHammer_Elite ) then
			TenTonHammer_Elite = {};
		end;
		if not ( TenTonHammer_Settings ) then TenTonHammer_Settings = {}; end;
		if ( TenTonHammer_OnlineDatabase ) and ( TenTonHammer_OnlineDatabase[f.Realm] ) then
			f:ProcessOnlineData();
		end;
		
		if ( string.find(f.Realm, "[' ]") ) then
			local cleanRealm = string.gsub(f.Realm, "[' ]", "");
			if ( cleanRealm ~= f.Realm ) then
				if ( TenTonHammer_Database ) and ( TenTonHammer_Database[cleanRealm] ) then TenTonHammer_Database[cleanRealm] = nil; end;
				if ( TenTonHammer_OnlineDatabase ) and ( TenTonHammer_OnlineDatabase[cleanRealm] ) then TenTonHammer_OnlineDatabase[cleanRealm] = nil; end;
			end;
		end;
		
		TenTonHammer_Ratings = {};
		f:runSettings();
		TenTonHammer_MinimapButton_DropDown:SetButtons();
		UIDropDownMenu_Initialize(TenTonHammer_MinimapButton_DropDown, TenTonHammer_MinimapButton_DropDown.Initialize);
		f:BuildDefaultTemplates();
		f:GenerateNews();
		f:UnregisterEvent("ADDON_LOADED");
		if not ( TenTonHammer_TalentStatus ) then TenTonHammer_TalentStatus = {}; end;
		f:Wipe();
		if ( GetGuildInfo("player") ) and not ( f.data["Beta"] ) then SendAddonMessage( "GSY_Version", f.data["Version"], "GUILD"); end;
		if ( TenTonHammer_Settings["addonMode"] == 0 ) then TenTonHammer_PopupFrame2:Show(); end;
		--------------
			print("|cffff0000PlayerScore:|r You can now claim your characters on PlayerScore.com |cffff8000('/claim')");
		--------------
	end;
end;
function f:runSettings()
	if not ( TenTonHammer_Settings ) then
		TenTonHammer_Settings = {};
	end;
	for i,v in pairs(f.data.DefaultSettings) do
		if ( not TenTonHammer_Settings[i] ) or ( type(TenTonHammer_Settings[i]) ~= type(v) )  then
			TenTonHammer_Settings[i] = v;
		end;
	end;
	TenTonHammer_Settings["SVR"] = f.Realm;
	TenTonHammer_Settings["REG"] = f.Region;
	if ( TenTonHammer_Settings["inspect"] == 1 ) then
		InspectUnit = MyInspectUnit;
	else
		InspectUnit = OriginalInspectUnit;
	end;
	local reverseArray = {
		["TOPLEFT"] = "TOPRIGHT",
		["TOPRIGHT"] = "TOPLEFT",
		["BOTTOMLEFT"] = "BOTTOMRIGHT",
		["BOTTOMRIGHT"] = "BOTTOMLEFT",
	};
	TenTonHammer_ControlFrame:ClearAllPoints();
	TenTonHammer_ControlFrame:SetPoint(TenTonHammer_Settings["anchor"], TenTonHammer_MainButton, reverseArray[TenTonHammer_Settings["anchor"]], 0, 0);
	local ScaleChart = { .8,.85,.9,.95,1, 1.12, 1.24, 1.36, 1.48, 1.6};
	f:SetScale(ScaleChart[TenTonHammer_Settings["scale"]]);
	TenTonHammer_MainButton:SetScale(0.9 * ScaleChart[TenTonHammer_Settings["scale"]]);
	if ( TenTonHammer_Settings["collapse"] == 1 ) then
		TenTonHammer_ControlFrame:Hide();
	end;
	
	if ( TenTonHammer_Settings["button_hammer"] == 0 ) then
		TenTonHammer_MainButton:Hide();
	else
		TenTonHammer_MainButton:Show();
	end;
	if ( TenTonHammer_Settings["minimap_button"] == 0 ) then
		TenTonHammer_MinimapButton:Hide();
	else
		TenTonHammer_MinimapButton:Show();
	end;
	
	local TabUpdateArray = {
		["EquipTab"] = 2,
		["TalentTab"] = 3,
		["ExperienceTab"] = 4,
		["PvPTab"] = 5,
		["NewsTab"] = 9,
		["GroupTab"] = 8,
	};
	local TabOrder = { [1] = true };
	for i,v in pairs(TabUpdateArray) do
		if ( TenTonHammer_Settings[i] == 1 ) then
			_G["TenTonHammerTab"..v]:Show();
			if ( v < 8 ) then tinsert(TabOrder, v, true); end;
		else
			_G["TenTonHammerTab"..v]:Hide();
		end;
	end;
	local PreviousTab;
	for i,v in pairs(TabOrder) do
		if ( i > 1 ) then
			_G["TenTonHammerTab"..i]:SetPoint("TOPLEFT", _G["TenTonHammerTab"..PreviousTab], "TOPRIGHT", -15, 0);
		end;
		PreviousTab = i;
	end;
	f:ActivateTemplate(f.data.TemplateList[TenTonHammer_Settings["Theme"]], TenTonHammer_Settings["color"]);
end;
function f:PLAYER_TARGET_CHANGED()
	if ( f:IsVisible() ) then
		f:Scan("target");
	elseif ( TenTonHammer_Settings["target_inspect1"] == 1 ) then
		if ( UnitIsPlayer("target") ) and ( not f.InCombat ) then
			local PlayerName, PlayerRealm = UnitName("target");
			if not ( PlayerName ) then return false; end;
			--PlayerRealm = PlayerRealm or f.Realm;
			local TimeStamp = f:GetTimeStamp();
			--if ( TenTonHammer_Database ) and ( TenTonHammer_Database[PlayerRealm] ) and ( TenTonHammer_Database[PlayerRealm][PlayerName] ) and ( tonumber(string.sub(TenTonHammer_Database[PlayerRealm][PlayerName], 1, 12)) == TimeStamp ) then
			if ( TenTonHammer_Database ) and ( TenTonHammer_Database[PlayerRealm] ) and ( TenTonHammer_Database[PlayerRealm][PlayerName] ) then
				--print("Not going to scan");
				return false;
				
			else
				--f:Scan("target", false, false, true);
				f:QuickScan("target");
				--print("going to scan");
			end;
		end;		
	end;
end;
function f:INSPECT_ACHIEVEMENT_READY()
	f:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	if( AchievementFrameComparison ) then
		AchievementFrameComparison:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
	end
end;
function f:INSPECT_TALENT_READY(...)
	print("TALENT READY!");
	f:UnregisterEvent("INSPECT_TALENT_READY");
end;
function f:PLAYER_REGEN_ENABLED()
	f.InCombat = false;
end;
function f:PLAYER_REGEN_DISABLED()
	f.InCombat = true;
end;

local function encrypt(self)
	local baseKey = 747747;
	local i = 1;
	local results = {};
	while ( i <= #self ) do
		tinsert(results, self:charCodeAt(i));
		i = i + 1;
	end;
	results = strjoin("", unpack(results));
	local loopCount = ceil(#results / 6);
	i = 0;
	while ( i < loopCount ) do
		local chunk = results:substr(i * 6 + 1, 6);
		baseKey = bit.bxor(baseKey, tonumber(chunk));
		i = i + 1;
	end;
	return baseKey;
end;

local function PlayerGUID(target)
	target = "player";
	local RealmName = GetRealmName();
	local originalGUID = UnitGUID(target);
	local GUID = string.sub(tostring(originalGUID), -8) ;
	GUID = tonumber("0x"..GUID);
	local inputKey = "";
	for v in string.gmatch(UnitName(target)..RealmName.. f.Region, "[a-zA-Z]+") do
		inputKey = inputKey..v;
	end;
	local key = encrypt("Gear" .. inputKey);
	local results = bit.bxor(tonumber(GUID) + 0, key);
	local serverKey = string.sub(tostring(originalGUID), 3, -8);
	return tostring(GUID..","..results..","..serverKey..","..bit.bxor(tonumber("0x"..serverKey), key));
end;

function f:CHAT_MSG_ADDON(eventName, prefix, message, channel, sender)
	if ( prefix == "GSY_Version" ) and  ( tonumber(message) ) and ( tonumber(message) > f.data["Version"] ) then
		f:UnregisterEvent("CHAT_MSG_ADDON");
		print("|cffff0000PlayerScore|r The newest version is now available! Visit www.PlayerScore.com to update.");
	end;
end;
function gg:Timer(elapsed)
	gg.CurrentCountDown = gg.CurrentCountDown - elapsed;
	if ( gg.CurrentCountDown <= 0 ) then 
		gg.CurrentCountDown = 0;
		gg:TimerCallback();
		gg:SetScript("OnUpdate", nil);
	end;
end;
function gg:RegisterTimer(time, callback)
	gg.CurrentCountDown = time;
	gg.TimerCallback = callback;
	gg:SetScript("OnUpdate", gg.Timer);
end;
function f:Inspect(unit)
	if ( CanInspect(unit) ) then f.InspectReady = true; end;
	if ( unit ) and ( f.InspectReady ) and ( CanInspect(unit) ) and ( UnitIsPlayer(unit) ) then
		f.InspectReady = false;
		f.Inspecting = GetUnitName(unit);
		f:RegisterEvent("INSPECT_READY");
		f:RegisterEvent("INSPECT_TALENT_READY");
		f:RegisterEvent("INSPECT_ACHIEVEMENT_READY");
		NotifyInspect(unit);
		ClearAchievementComparisonUnit();
		if( AchievementFrameComparison ) then AchievementFrameComparison:UnregisterEvent("INSPECT_ACHIEVEMENT_READY"); end;
		SetAchievementComparisonUnit(unit);
		RequestInspectHonorData();
		return true;
	else
		return false;
	end;
end;
function f:Transmit(target, channel, prefix, message, priority)
	if (( f.TTrottle == 0 ) and not ( f.InCombat ) ) or ( priority ) then
		f.TTrottle = f.TTrottle + 1;
		SendAddonMessage(prefix, message, channel, target);
		return true;
	else
		return false;
	end;
end;
function f:GetColor100(Value, Min, Max)
	local Range = Max - Min;
	Value = (Value - Min) * 10;
	local PercentIndex = floor(Value / Range);
	if ( PercentIndex > 10 ) then 
		PercentIndex = 10;
	end;
	local ColorArray = f.data.Color100Array;
	return unpack(ColorArray[PercentIndex] or { 1,1,1 });
end;
function f:GetQuickColor(score)
	local r,g,b,hex = f:GetColor(score or 0);
	return hex..(score or 0);
end;
function f:GetColor(score)
	if ( score == 0 ) then return .1, .1, .1, "|cff1A1A1A"; end;
	local color = {};
	local index = 0;
	local ColorArray = f.data.ColorArray;
	score = floor( score / 2);
	if ( score >= 6e3 ) then score = 5999; end;
	local a = floor(score / 1e3) + 1;
	local b = a + 1;
	local c = mod(score, 1e3);
	for i = 1,3 do
		local d = ( ColorArray[b][i] - ColorArray[a][i]) / 1e3;
		color[i] = ColorArray[a][i] + (d * c);
	end;
	color[4] =  "|cff" .. string.format("%02x%02x%02x",color[1] * 255, color[2] * 255, color[3] * 255);
	return unpack(color);
end;
function f:GetHexColor(r,g,b)
	return "|cff" .. string.format("%02x%02x%02x",(r or 0) * 255, (g or 0) * 255, (b or 0) * 255);
end;
function f:GetBeltBuckle(itemLink, gemCount)
	local ItemSubStringTable = {};
	local found, _, ItemSubString = string.find(itemLink, "^|c%x+|H(.+)|h%[.*%]")
	for v in string.gmatch(ItemSubString, "[^:]+") do tinsert(ItemSubStringTable, v); end
	local baseItem = "|Hitem:"..ItemSubStringTable[2]..":0";
	local ItemName, ItemLink, ItemQuality, ItemLevel, ItemReqLevel, ItemClass, ItemSubclass, ItemMaxStack, ItemEquipSlot, ItemTexture, ItemVendorPrice = GetItemInfo(baseItem);
	local SocketCount = 0;
	for i = 1, 4 do
		if ( _G["TenTonHammerTooltipTexture"..i] ) then
	 		_G["TenTonHammerTooltipTexture"..i]:SetTexture("");
	 	end;
	end;
	TenTonHammerTooltip:SetOwner(f,"ANCHOR_NONE");
 	TenTonHammerTooltip:ClearLines();
 	TenTonHammerTooltip:SetHyperlink(ItemLink);
 	for i = 1,4 do
 		local texture = _G["TenTonHammerTooltipTexture"..i]:GetTexture();
 		if ( texture ) then
 			SocketCount = SocketCount + 1;
 		end
 	end;
 	if ( ( SocketCount - gemCount ) == -1 ) then
 		return true;
 	else
 		return false;
 	end;
end;



function f:GetGemInfo(itemLink)
	local Gems = { [0] = 0 };
	local MissingGems = { 
		["Meta"] = 0,
		["Red"] = 0,
		["Yellow"] = 0,
		["Blue"] = 0
	};
	local MissingGemCount = 0;
	if not ( itemLink or itemLink == "" ) then 
		return 0, {}, MissingGemCount, MissingGems; 
	end;
	local EmptyTextures = {
		["Interface\\ItemSocketingFrame\\UI-EmptySocket-Meta"] = "Meta",
		["Interface\\ItemSocketingFrame\\UI-EmptySocket-Red"] = "Red",
		["Interface\\ItemSocketingFrame\\UI-EmptySocket-Yellow"] = "Yellow",
		["Interface\\ItemSocketingFrame\\UI-EmptySocket-Blue"] = "Blue"
	};
	for i = 1, 4 do
		if ( _G["TenTonHammerTooltipTexture"..i] ) then
	 		_G["TenTonHammerTooltipTexture"..i]:SetTexture("");
	 	end;
	end;
	TenTonHammerTooltip:SetOwner(f,"ANCHOR_NONE");
 	TenTonHammerTooltip:ClearLines();
 	TenTonHammerTooltip:SetHyperlink(itemLink);
 	for i = 1,4 do
 		local texture = _G["TenTonHammerTooltipTexture"..i]:GetTexture();
 		if ( texture ) then
 			if ( EmptyTextures[texture] ) then
	 			MissingGems[EmptyTextures[texture]] = MissingGems[EmptyTextures[texture]] + 1;
	 			MissingGemCount = MissingGemCount + 1;
	 		end;
	 		local gemName, gemLink = GetItemGem(itemLink, i);
	 		tinsert(Gems, { 
	 			["Name"] = gemName, 
	 			["Link"] = gemLink, 
	 			["Texture"] = texture 
	 		});
	 	end;
 	end;
	return #Gems, Gems, MissingGemCount, MissingGems;
end;
function f:GetEnchantInfo(itemLink)
	local enchantText = nil;
	local ItemSubStringTable = {};
	local found, _, ItemSubString = string.find(itemLink, "^|c%x+|H(.+)|h%[.*%]")
	for v in string.gmatch(ItemSubString, "[^:]+") do tinsert(ItemSubStringTable, v); end
	if ( ItemSubStringTable[3] == 0 ) then
		return false;
	end;
	local baseItem = "|Hitem:"..ItemSubStringTable[2]..":0";
	baseItem = strjoin(":", baseItem, unpack(ItemSubStringTable, 4));
	
	TenTonHammerTooltip:SetOwner(f,"ANCHOR_NONE");
 	TenTonHammerTooltip:ClearLines();
 	TenTonHammerTooltip:SetHyperlink(itemLink);
	TenTonHammerTooltip2:SetOwner(f,"ANCHOR_NONE");
 	TenTonHammerTooltip2:ClearLines();
 	TenTonHammerTooltip2:SetHyperlink(baseItem);
 	for i = 2, TenTonHammerTooltip:NumLines() do
 		local itemLine = _G[TenTonHammerTooltip:GetName().."TextLeft"..i]:GetText();
 		local baseLine = _G[TenTonHammerTooltip2:GetName().."TextLeft"..i]:GetText();
 		if ( itemLine ~= baseLine ) then 
 			enchantText = itemLine;
 			break;
 		end;
 	end;
 	return enchantText;
end;

function f:GetLiteSpec(unit)
	local ActiveTalentGroup = GetActiveTalentGroup(true);
	local TalentInfo = { 0, "", "", L["This player has no specialization for their class."], 0,0,0,0,0,0 };
	local Talents = {};
	local MissingTalents = 0;
	local PlayerLevel = UnitLevel(unit);
	local InfoIndex = 1;
	local NegativeTalentCount = 0;
	local PositiveTalentCount = 0;
	local PlayerSpec;	
	if ( PlayerLevel < 10 ) then
		return unpack(TalentInfo);
	else
		for i = 1, GetNumTalentTabs(true) do
			local TabID, TabName, TabDescription, TabIcon, TabPoints, TabBackground, TabPreviewPoints, TabIsUnlocked = GetTalentTabInfo(i, true, false, ActiveTalentGroup);
			if (TabPoints >= 31) or (( PlayerLevel < 71 ) and ( TabPoints > 0 ))  then
				TalentInfo = { TabID, TabName, TabIcon, TabDescription };
				PlayerSpec = TabID;
				for j = 1,GetNumTalents(i, true, false, ActiveTalentGroup) do
					local TalentName, TalentIconTexture, TalentTier, TalentColumn, TalentRank, TalentMaxRank = GetTalentInfo(i, j, true, false, ActiveTalentGroup);
					if ( TalentRank > 0 ) then
						if ( PlayerSpec ) and ( TenTonHammer_Elite[PlayerSpec] ) and ( TenTonHammer_Elite[PlayerSpec]["TALENTS"][TalentName] ) then
							if ( TenTonHammer_Elite[PlayerSpec]["TALENTS"][TalentName] == 1 ) then
								PositiveTalentCount = PositiveTalentCount + TalentRank;
							elseif ( TenTonHammer_Elite[PlayerSpec]["TALENTS"][TalentName] == 2 ) then
								NegativeTalentCount = NegativeTalentCount + TalentRank;
							end;
						end;
						InfoIndex = InfoIndex+1;
					end;
				end;
				Talents[i] = TabPoints;
				MissingTalents = MissingTalents + TabPoints;	
			end;	
			if ( PlayerLevel > 9 ) then
				if ( PlayerLevel > 10 ) and ( PlayerLevel < 81 ) then
					local TalentLevel = PlayerLevel - 9;
					MissingTalents = MissingTalents - (floor((TalentLevel - (mod(TalentLevel, 2) -1))/2) + 1);
				else
					MissingTalents = MissingTalents - 36 - ( PlayerLevel - 80 );				
				end;
			end;
			for i = 1,3 do
				TalentInfo[4+i] = abs(Talents[i] or 0);	
			end;
			TalentInfo[8] = abs(MissingTalents);
			TalentInfo[9] = NegativeTalentCount;
			TalentInfo[10] = PositiveTalentCount;
		end;
		
		return unpack(TalentInfo);
	end;		
end;

function f:GetSpec(unit)
	
	local ActiveTalentGroup = GetActiveTalentGroup(true);
	local TalentInfo = { 0, "", "", L["This player has no specialization for their class."], 0,0,0,0,0,0 };
	--if ( unit ) then return TalentInfo; end; --Debug Code ONly
	local Talents = {};
	local MissingTalents = 0;
	local PlayerLevel = UnitLevel(unit);
	local InfoIndex = 1;
	local NegativeTalentCount = 0;
	local PositiveTalentCount = 0;
	local PlayerSpec;
	
	
	if ( PlayerLevel < 10 ) then
		return unpack(TalentInfo);
	else
			local function showTip(self)
				if ( self.tooltipLink ) then
					GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
					GameTooltip:SetHyperlink(self.tooltipLink);
					if ( not PlayerTalentFrame:IsVisible() ) then
						GameTooltip:AddLine(" ");
						GameTooltip:AddLine("|cff00ff00"..L["Left-Click to flag this talent as positive."]);
						GameTooltip:AddLine(L["Middle-Click to flag this talent as neutral."]);
						GameTooltip:AddLine("|cffff0000"..L["Right-Click to flag this talent as negative."]);
					end;
					GameTooltip:Show();
				end;
			end;
			local function talentClick(self, button)
				if ( self.TalentName ) and ( TenTonHammer_Frame3.SpecID ) and ( not PlayerTalentFrame:IsVisible() ) then
					local SpecID = TenTonHammer_Frame3.SpecID;
					if ( button == "RightButton" ) then
						TenTonHammer_Elite[SpecID]["TALENTS"][self.TalentName] = 2;
						_G[self:GetName().."Slot"]:SetVertexColor(1,0,0);
						_G[self:GetName().."Rank"]:SetTextColor(1,0,0);
					elseif ( button == "LeftButton" ) then
						TenTonHammer_Elite[SpecID]["TALENTS"][self.TalentName] = 1;
						_G[self:GetName().."Slot"]:SetVertexColor(0,1,0);
						_G[self:GetName().."Rank"]:SetTextColor(0,1,0);
					elseif ( button == "MiddleButton" ) then
						TenTonHammer_Elite[SpecID]["TALENTS"][self.TalentName] = nil;
						_G[self:GetName().."Slot"]:SetVertexColor(1,.82,1);
						_G[self:GetName().."Rank"]:SetTextColor(1,.82,1);
					end;
				elseif ( self.OriginalScript ) then
					self.OriginalScript(self, button);
				end;
			end;
		for i = 1, GetNumTalentTabs(true) do
			
			local Name = "PlayerTalentFramePanel"..i;
			local InspectFrame = _G[Name];
			InspectFrame:SetScript("OnShow", nil);
			InspectFrame:SetScript("OnHide", nil);
			InspectFrame.inspect = true;
			TalentFrame_Update(InspectFrame);
			_G[Name.."Summary"]:Hide();
			_G[Name.."SelectTreeButton"]:Hide();
			_G[Name.."InactiveShadow"]:SetAlpha(.5);

			local TabID, TabName, TabDescription, TabIcon, TabPoints, TabBackground, TabPreviewPoints, TabIsUnlocked = GetTalentTabInfo(i, true, false, ActiveTalentGroup);
			_G[Name.."HeaderIconPointsSpent"]:SetText(TabPoints or 0);
			_G[Name.."HeaderIconPointsSpent"]:Show();
			_G[Name.."Name"]:SetText(TabName);
			_G[Name.."RoleIcon"]:Hide();
			_G[Name.."HeaderIconIcon"]:SetTexture(TabIcon);
			_G[Name.."HeaderIcon"]:Show();
			_G[Name.."HeaderIconLockIcon"]:Hide();
			
			if (TabPoints >= 31) or (( PlayerLevel < 71 ) and ( TabPoints > 0 ))  then
				TalentInfo = { TabID, TabName, TabIcon, TabDescription };
				PlayerSpec = TabID;
				TenTonHammer_Frame3.SpecID = PlayerSpec;
				if not ( TenTonHammer_Elite[PlayerSpec] ) then TenTonHammer_Elite[PlayerSpec] = { ["GEMS"] = {}, ["ENCHANTS"] = {}, ["TALENTS"] = {} }; end;
				
				_G[Name.."GlowLeft"]:Show();
				_G[Name.."GlowRight"]:Show();
				_G[Name.."GlowBottomLeft"]:Show();
				_G[Name.."GlowBottomRight"]:Show();
				_G[Name.."GlowBottom"]:Show();
				_G[Name.."GlowTopLeft"]:Show();
				_G[Name.."GlowTopRight"]:Show();
				_G[Name.."GlowTop"]:Show();
				
				_G[Name.."HeaderIconPrimaryBorder"]:Show();
				_G[Name.."HeaderIconSecondaryBorder"]:Hide();
				_G[Name.."HeaderIconPointsSpentBgGold"]:Show();
				_G[Name.."HeaderIconPointsSpentBgSilver"]:Hide();
				
				_G[Name.."InactiveShadow"]:Hide();
			else
				_G[Name.."GlowLeft"]:Hide();
				_G[Name.."GlowRight"]:Hide();
				_G[Name.."GlowBottomLeft"]:Hide();
				_G[Name.."GlowBottomRight"]:Hide();
				_G[Name.."GlowBottom"]:Hide();
				_G[Name.."GlowTopLeft"]:Hide();
				_G[Name.."GlowTopRight"]:Hide();
				_G[Name.."GlowTop"]:Hide();
				_G[Name.."HeaderIconPrimaryBorder"]:Hide();
				_G[Name.."HeaderIconSecondaryBorder"]:Show();
				_G[Name.."HeaderIconPointsSpentBgGold"]:Hide();
				_G[Name.."HeaderIconPointsSpentBgSilver"]:Show();
			end;
			
			InspectFrame.inspect = false;
			
	
			
			for j = 1,GetNumTalents(i, true, false, ActiveTalentGroup) do
				local TalentName, TalentIconTexture, TalentTier, TalentColumn, TalentRank, TalentMaxRank = GetTalentInfo(i, j, true, false, ActiveTalentGroup);
				local TalentLink = GetTalentLink(i, j, true, false, ActiveTalentGroup);
				if ( not _G[Name.."Talent"..j].OriginalScript ) then _G[Name.."Talent"..j].OriginalScript = _G[Name.."Talent"..j]:GetScript("OnClick"); end;
				_G[Name.."Talent"..j].tooltipLink = TalentLink;
				_G[Name.."Talent"..j.."GoldBorder"]:Hide();
				
				_G[Name.."Talent"..j.."Slot"]:Show();
				_G[Name.."Talent"..j].TalentName = TalentName;
				_G[Name.."Talent"..j]:RegisterForClicks("AnyUp");
				_G[Name.."Talent"..j]:SetScript("OnEnter", showTip);
				_G[Name.."Talent"..j]:SetScript("OnClick", talentClick);
				_G[Name.."Talent"..j.."IconTexture"]:SetTexture(TalentIconTexture);
					
				
				if ( TalentRank > 0 ) then
					_G[Name.."Talent"..j.."Rank"]:Show();
					_G[Name.."Talent"..j.."Rank"]:SetText(TalentRank);
					_G[Name.."Talent"..j.."RankBorder"]:Show();
					_G[Name.."Talent"..j.."IconTexture"]:SetDesaturated(false);
				else
					_G[Name.."Talent"..j.."Rank"]:Hide();
					
					_G[Name.."Talent"..j.."RankBorder"]:Hide();
					_G[Name.."Talent"..j.."IconTexture"]:SetDesaturated(true);
				end;
				_G[Name.."Talent"..j.."RankBorderGreen"]:Hide();
				
				
					if ( TalentRank > 0 ) then
						if ( PlayerSpec ) and ( TenTonHammer_Elite[PlayerSpec] ) and ( TenTonHammer_Elite[PlayerSpec]["TALENTS"][TalentName] ) then
							if ( TenTonHammer_Elite[PlayerSpec]["TALENTS"][TalentName] == 1 ) then
								r = 0; g = 1; b = 0;
								PositiveTalentCount = PositiveTalentCount + TalentRank;
								_G[Name.."Talent"..j.."Slot"]:SetVertexColor(0,1,0);
								_G[Name.."Talent"..j.."Rank"]:SetTextColor(0,1,0);
								_G[Name.."Talent"..j.."IconTexture"]:SetDesaturated(false);
							elseif ( TenTonHammer_Elite[PlayerSpec]["TALENTS"][TalentName] == 2 ) then
								NegativeTalentCount = NegativeTalentCount + TalentRank;
								_G[Name.."Talent"..j.."Slot"]:SetVertexColor(1,0,0);
								_G[Name.."Talent"..j.."Rank"]:SetTextColor(1,0,0);
								_G[Name.."Talent"..j.."IconTexture"]:SetDesaturated(true);
								r = 1; g = 0; b = 0;
							else 
								_G[Name.."Talent"..j.."Slot"]:SetVertexColor(1,.82,1);
								_G[Name.."Talent"..j.."Rank"]:SetTextColor(1,.82,1);
							end;
						end;
						InfoIndex = InfoIndex+1;
					end;
				
			end;
			
			Talents[i] = TabPoints;
			MissingTalents = MissingTalents + TabPoints;	
			
		end;	
		if ( PlayerLevel > 9 ) then
			if ( PlayerLevel > 10 ) and ( PlayerLevel < 81 ) then
				local TalentLevel = PlayerLevel - 9;
				MissingTalents = MissingTalents - (floor((TalentLevel - (mod(TalentLevel, 2) -1))/2) + 1);
			else
				MissingTalents = MissingTalents - 36 - ( PlayerLevel - 80 );				
			end;
		end;
		for i = 1,3 do
			TalentInfo[4+i] = abs(Talents[i] or 0);	
		end;
		TalentInfo[8] = abs(MissingTalents);
		TalentInfo[9] = NegativeTalentCount;
		TalentInfo[10] = PositiveTalentCount;
	end;
	return unpack(TalentInfo);
end;

function f:QuickScan(unit)
	-- Rapid Scan for GearScore Lite Mode --
	if ( f:Inspect(unit ) ) then
		-- Preload Items from Player --
		local Order = {1,2,3,15,5,9,10,6,7,8,11,12,13,14,16,17,18};
		for i = 1,17 do
			local index = Order[i];
			local ItemLink = GetInventoryItemLink(unit, index);
			f.data["TempItemList"][index] = ItemLink;
		end;
		f.Callback["INSPECT_ACHIEVEMENT_READY"] = function(...)
			f.ScanCount = ( f.ScanCount or 0 ) + 1;
			local TimeDelay = 1;
			local BandwidthIn, BandwidthOut, Latency = GetNetStats();
			TimeDelay = TimeDelay + ( Latency / 500 );
			f.LiteScanTarget = UnitName(unit) or "";
			if ( UnitIsUnit("mouseover", unit ) ) then
				GameTooltip:SetUnit(unit);
			end;
			gg:RegisterTimer(TimeDelay, function(...)
				local PlayerName, PlayerRealm = UnitName(unit);
				if ( not PlayerName ) or ( not unit ) then return false; end;
				PlayerRealm = PlayerRealm or f.Realm;
				local GearScore, PVPScore, PVEScore, RaidScore, ThumbsUp, ThumbsDown = 0,0,0,0,0,0;
				local AverageItemLevel = 0;
				local SpecID, SpecName, SpecIcon, SpecDescription, Talents1, Talents2, Talents3, MissingTalents, NegativeTalentCount, PositiveTalentCount, IncorrectItems;
				SpecID, SpecName, SpecIcon, SpecDescription, Talents1, Talents2, Talents3, MissingTalents, NegativeTalentCount, PositiveTalentCount = f:GetLiteSpec(unit);
				local ClassLocal, Class = UnitClass(unit);
				local PlayerLevel = UnitLevel(unit);
				local PlayerRole = f.data.ClassRoles[Class][SpecID or 0] or 0;
				local NegativeArray, PositiveArray = {}, {};
				--*f.CurrentPlayerRole = PlayerRole;
				--[[
				f.CurrentTargetInfo = {
					["Class"] = Class,
					["ClassLocal"] = ClassLocal,
					["Name"] = PlayerName,
					["PlayerRole"] = PlayerRole,
					["SpecName"] = SpecName,
				};	
				]]--
				ClassColor = RAID_CLASS_COLORS[Class];
				ClassColor = f:GetHexColor(ClassColor["r"], ClassColor["g"], ClassColor["b"]);
				--print("WARNING! DEBUG CODE ACTIVE");
				if ( UnitInRaid(unit) ) or ( UnitInParty(unit) ) or ( UnitIsUnit(unit, "player") ) then
					f.PartyData[PlayerName] = { 
						["Realm"] = PlayerRealm,
						["PlayerRole"] = PlayerRole,
						["Color"] = ClassColor or "|cff000000",
						["Class"] = Class,
						["CLASS"] = Class,
						["ClassLocal"] = ClassLocal,
						["Spec"] = SpecName,
					};
				end;
				RaidScore = f:GetRaidScore() or 0;
				PVEScore = f:GetPVEScore() or 0;
				PVPScore = f:GetPVPScore() or 0;
				local Order = {1,2,3,15,5,9,10,6,7,8,11,12,13,14,16,17,18};
				local TotalStats = {};
				local ItemCount = 0;
				local WeaponScore = 0;
				local WeaponValue = 0;
				local AIL_Weapon = 0;
				local TotalEquipment = 0;
				local TotalMissingGems = 0;
				local TotalMissingEnchants = 0;
				local IncorrectItems = {};
				local BeltBuckle = true;
				for i = 1,17 do
					local index = Order[i];
					local ItemLink = GetInventoryItemLink(unit, index);
					if ( ItemLink ) then
						local ItemName, ItemLink2, ItemQuality, ItemLevel, ItemReqLevel, ItemClass, ItemSubclass, ItemMaxStack, ItemEquipSlot, ItemTexture, ItemVendorPrice = GetItemInfo(ItemLink);
	
						local ItemStats = f:ScanItem(ItemLink) or {};
						for i,v in pairs(ItemStats) do
							TotalStats[i] = ( TotalStats[i] or 0 ) + v;
						end;	
						if ( ItemQuality == 7 ) then
							ItemLevel = 187;
							ItemRarity = 3;
						end
						TotalEquipment = TotalEquipment + 1;
						local GemCount, Gems, MissingGemCount, MissingGems = f:GetGemInfo(ItemLink);
						TotalMissingGems = TotalMissingGems + MissingGemCount;
						local ItemScore, IncorrectItems, ItemColor = f:GetItemScore(ItemLink, PlayerRole, Class, IncorrectItems);
			
						if ( f.data.ItemTypes[ItemEquipSlot]["Enchantable"] ~= 0 ) then 
							local EnchantInfo = f:GetEnchantInfo(ItemLink);
							if ( EnchantInfo ) then
								ItemScore = ItemScore * 1.03;
							elseif ( f.data.ItemTypes[ItemEquipSlot]["Enchantable"] == 1 ) then
								TotalMissingEnchants = TotalMissingEnchants + 1;
							end;
						end;
						
						if ( ItemEquipSlot == "INVTYPE_WAIST" ) then
							if ( f:GetBeltBuckle(ItemLink, GemCount) ) then
								ItemScore = ItemScore * 1.03;
							end;
						end;
								
						ItemScore = ItemScore * ( 1 - ( .02 * MissingGemCount ) );
						ItemScore = floor(ItemScore);
						if ( f.data.ItemTypes[ItemEquipSlot]["Weapon"] > 0 ) then
							WeaponValue = WeaponValue + f.data.ItemTypes[ItemEquipSlot]["Weapon"];
							AIL_Weapon = AIL_Weapon + f.data.ItemTypes[ItemEquipSlot]["Weapon"];
							
							WeaponScore = WeaponScore + ItemScore;
							ItemCount = ItemCount + f.data.ItemTypes[ItemEquipSlot]["Weapon"];
							AverageItemLevel = AverageItemLevel + ( ItemLevel * f.data.ItemTypes[ItemEquipSlot]["Weapon"] );
						else
							AverageItemLevel = AverageItemLevel + ItemLevel;
							ItemCount = ItemCount + 1;
						end;
						GearScore = GearScore + ItemScore;
						if ( UnitInRaid(unit) ) or ( UnitInParty(unit) ) or ( UnitIsUnit(unit, "player") ) then
							f.PartyData[PlayerName][index] = ItemScore;
						end;
					end;
				end;
				if ( WeaponValue > 2 ) then
					GearScore = GearScore - floor(WeaponScore - ( 2 * WeaponScore / WeaponValue ));
					AverageItemLevel = AverageItemLevel - floor(AverageItemLevel - ( 2 * AIL_Weapon / WeaponValue ));
				end;
				AverageItemLevel = floor((AverageItemLevel / 17)+0.5);
				f.AIL_Info = { PlayerName, AverageItemLevel };
				--print("Quick-Scan", GearScore, AverageItemLevel);
				
				local TimeStamp = f:GetTimeStamp();
				
				local DatabaseConstruct = strjoin(":", TimeStamp, GearScore, RaidScore, PVEScore, PVPScore, ThumbsUp or 0, ThumbsDown or 0, PreviousVote or 0, 0 );
				if not ( TenTonHammer_Database[PlayerRealm] ) then TenTonHammer_Database[PlayerRealm] = {}; end;
				TenTonHammer_Database[PlayerRealm][PlayerName] = DatabaseConstruct;
				
				for i,v in pairs(IncorrectItems) do
					tinsert(NegativeArray, {string.format(L["%d %s items equipped"], v, i), L["These items are not appropriate for this player's spec. These items will reduce this player's potential performance in PVE Combat."]});
				end;
				
				if ( ItemCount < 17 ) then
					tinsert(NegativeArray, {string.format(L["%s empty equipment slot(s)"], 17 - ItemCount), L["This player is missing equipment and which will drastically reduce performance."]});
				end;
				if ( TotalMissingEnchants > 0 ) then
					tinsert(NegativeArray, {format(L["%d Unenchanted Item(s)"], TotalMissingEnchants), L["This player is missing enchantments and will not be able to perform at their maximum."]});
				else
					tinsert(PositiveArray, {L["All Items Enchanted"], L["This player has enchanted all their enchantable items which will increase their performance."]});
				end;
				
				if ( TotalMissingGems > 0 ) then
					tinsert(NegativeArray, {format(L["%d Empty Gem Socket(s)"], TotalMissingGems),  L["This player is missing gems and will not be able to perform at their maximum."]});
				else
					tinsert(PositiveArray, { L["No Empty Gem Sockets"], L["This player has gemmed all their items which will increase their performance."] });
				end;
				
				f.data.LiteScanData = {
					["Name"] = PlayerName,
					["Realm"] = PlayerRealm,
					["PlayerRole"] = PlayerRole,
					["Color"] = ClassColor,
					["Class"] = Class,
					["ClassLocal"] = ClassLocal,
					["Spec"] = SpecName,
					["GearScore"] = GearScore;
					["RaidScore"] = RaidScore;
					["PVEScore"] = PVEScore;
					["PVPScore"] = PVPScore;
					["SpecID"] = SpecID;
					["ThumbsUp"] = ThumbsUp or 0;
					["ThumbsDown"] = ThumbsDown or 0;
					["Vote"] = PreviousVote or 0;
					["Negative"] = NegativeArray;
					["AverageItemLevel"] = AverageItemLevel;
				};
				
				--print("DEBUG CODE ACTIVE");
				if ( UnitInRaid(unit) ) or ( UnitInParty(unit) ) or ( UnitIsUnit(unit, "player") ) then
					f.PartyData[PlayerName] = f.data.LiteScanData;
				end;			
				
				f.InspectReady = true;	
				
				--if ( not MadeUpShit ) then
				if ( f.ScanCount == 1 ) and ( ( (ItemCount < 17) and (unit ~= "player") and (PlayerLevel == 85) ) or (MissingTalents == 41) )  then 
					f:QuickScan(unit);
				else
					f.ScanCount = 0;
					f.LiteScanTarget = "";
					if ( UnitIsUnit(unit, "mouseover") ) then
						GameTooltip:SetUnit(unit);
					end;
				end;
				
				
				--print("QUICK", GetFunctionCPUUsage(f.QuickScan, true));
			end);
		end;
	end;
end;


function f:Scan(unit, shouldtargetplayer, hidewait, litemode)
	if ( f:Inspect(unit) ) then
		--TempItemList
		local Order = {1,2,3,15,5,9,10,6,7,8,11,12,13,14,16,17,18};
		for i = 1,17 do
			local index = Order[i];
			local ItemLink = GetInventoryItemLink(unit, index);
			f.data["TempItemList"][index] = ItemLink;
		end;
		
		f.Callback["INSPECT_ACHIEVEMENT_READY"] = function(...)
			TenTonHammer_Frame3.SpecID = nil;
			f.ScanCount = ( f.ScanCount or 0 ) + 1 ;
			if ( f.ScanCount == 1 ) then f:Wipe(); else f:WipeStatus(); end;
			if ( not shouldtargetplayer ) and ( not litemode )then f:Show(); end;
			if not ( hidewait ) then _G[fName.."_WaitFrame"]:Show(); end;
			_G[fName.."_Frame1_ThumbsUp"]:Hide();
			_G[fName.."_Frame1_ThumbsDown"]:Hide();
			
			local TimeDelay = 1;
			local BandwidthIn, BandwidthOut, Latency = GetNetStats();
			TimeDelay = TimeDelay + ( Latency / 500 );
			if ( shouldtargetplayer ) then TimeDelay = 0; end;
			
			if ( litemode ) then
				f.LiteScanTarget = UnitName(unit) or "";
				if ( UnitIsUnit("mouseover", unit) ) then
					GameTooltip:SetUnit(unit);
				end;
			end;
			
			gg:RegisterTimer(TimeDelay, function(...)
				local PlayerName, PlayerRealm = UnitName(unit);
				if ( not PlayerName ) or ( not unit ) then return false; end;
				PlayerRealm = PlayerRealm or f.Realm;
				f.CurrentTarget = PlayerName;
				f.CurrentTargetRealm = PlayerRealm;
				if ( UnitIsUnit("player", unit) ) then 
					TenTonHammer_Frame1_TagText:SetText("|cffffffffYou can claim your own character on PlayerScore.com by typing /claim.");
				else
					TenTonHammer_Frame1_TagText:SetText("");
				end;
				local GearScore, PVPScore, PVEScore, RaidScore, ThumbsUp, ThumbsDown = 0,0,0,0,0,0;
				local FactionColor = { ["Horde"] = "|cffFF0000", ["Alliance"] = "|cff5555FF" };
				local PositiveArray = {};
				local NegativeArray = {};
				local NegativeEnchants = 0;
				local NegativeGems = 0;
				local TotalMissingGems = 0;
				local TotalMissingEnchants = 0;
				local TotalEquipment = 0;
				local AverageItemLevel = 0;
				local SpecID, SpecName, SpecIcon, SpecDescription, Talents1, Talents2, Talents3, MissingTalents, NegativeTalentCount, PositiveTalentCount;
				if ( litemode ) and ( not f:IsVisible() ) then
					SpecID, SpecName, SpecIcon, SpecDescription, Talents1, Talents2, Talents3, MissingTalents, NegativeTalentCount, PositiveTalentCount = f:GetLiteSpec(unit);
				else
					SpecID, SpecName, SpecIcon, SpecDescription, Talents1, Talents2, Talents3, MissingTalents, NegativeTalentCount, PositiveTalentCount = f:GetSpec(unit);
				end;
				if ( (PositiveTalentCount or 0) > 0 ) then tinsert(PositiveArray, {string.format(L["%d Positive talent(s)."], PositiveTalentCount), L["This player has talents that you have marked as positive."]}); end;
				if ( (NegativeTalentCount or 0) > 0 ) then tinsert(NegativeArray, {string.format(L["%d Negative talent(s)."], NegativeTalentCount), L["This player has talents that you have marked as negative."]}); end;
				
				local ClassLocal, Class = UnitClass(unit);
				
				local PlayerLevel = UnitLevel(unit);
				local GuildName, GuildRank, GuildRankIndex = GetGuildInfo(unit);
						
				local Faction, FactionLocale = UnitFactionGroup(unit);
				local name = fName.."_Frame1";
				local PlayerRole = f.data.ClassRoles[Class][SpecID or 0] or 0;
				f.CurrentPlayerRole = PlayerRole;
				local IncorrectItems = {};
					
				f.CurrentTargetInfo = {
					["Class"] = Class,
					["ClassLocal"] = ClassLocal,
					["Name"] = PlayerName,
					["PlayerRole"] = PlayerRole,
					["SpecName"] = SpecName,
				};		
		
				local PlayerString = _G[fName.."_TitleFrame_PlayerText"];
				local GuildString = _G[fName.."_TitleFrame_GuildText"];
		
				local ClassColor = RAID_CLASS_COLORS[Class];
				ClassColor = f:GetHexColor(ClassColor["r"], ClassColor["g"], ClassColor["b"]);
		
		
				
				if ( UnitInRaid(unit) ) or ( UnitInParty(unit) ) or ( UnitIsUnit(unit, "player") ) then
					f.PartyData[PlayerName] = { 
						["Realm"] = PlayerRealm,
						["PlayerRole"] = PlayerRole,
						["Color"] = ClassColor,
						["Class"] = Class,
						["ClassLocal"] = ClassLocal,
						["Spec"] = SpecName,
					};
				end;
		
		
				
				_G[name.."_Info8"].Hyperlink = ClassColor..SpecName.." "..ClassLocal.."|r\n|cffffffff"..SpecDescription;
				_G[name.."_Info10"].Hyperlink = L["Player Rating"].."\n|cffffffff".."Some random text here describing what this is.";
		
		
				
				PlayerString:SetText(strjoin(" ", ClassColor, PlayerName, "-", PlayerLevel, SpecName, ClassLocal));
				if ( GuildName ) then 
					GuildString:SetText(strjoin("", FactionColor[Faction], "<", GuildName, ">")); 
					_G[name.."_Info9"]:SetText(strjoin("", FactionColor[Faction], "<", GuildName, ">"), FactionColor[Faction]..GuildRank); 
					_G[name.."_Info9"].Hyperlink = FactionColor[Faction].."<"..GuildName..">|r|cffffffff\n"..string.format(L["%s is a %q of this %s guild."], PlayerName, GuildRank, FactionLocale);
					
				else
					tinsert(NegativeArray, {L["No Guild"], L["A player who is not a member of a guild is more likely to not play well with other players."]});
				end;
	
				_G[name.."_Info8"]:SetText(strjoin("", ClassColor, SpecName, " ", ClassLocal), strjoin(" ", ClassColor, "(", Talents1, "/", Talents2, "/", Talents3, ")"));
				_G[name.."_Info10"]:SetText("Player Rating", "N/A");
		
				if ( MissingTalents > 0 ) then tinsert(NegativeArray, {format(L["%d Unused Talent(s)"], MissingTalents), L["This player has not spent some of their talents. This will significantly lower this player's potential."] } ); end;
					
				f:BuildExperience();
				RaidScore = f:GetRaidScore() or 0;
				PVEScore = f:GetPVEScore() or 0;
				PVPScore = f:GetPVPScore() or 0;
				f:BuildPVPTab();
				name = fName.."_Frame2";
				local Order = {1,2,3,15,5,9,10,6,7,8,11,12,13,14,16,17,18};
				local TotalStats = {};
				local ItemCount = 0;
				local WeaponScore = 0;
				local WeaponValue = 0;
				local AIL_Weapon = 0;
				local BeltBuckle = true;
					for i = 1,17 do
						local index = Order[i];
						local ItemLink = GetInventoryItemLink(unit, index);
						
						local NameString = _G[name.."_NameString"..index];
						local ItemIcon = _G[name.."_ItemIcon"..index];
						local LevelString = _G[name.."_LevelString"..index];
						local GearString = _G[name.."_GearString"..index];
						local EnchantIcon = _G[name.."_EnchantIcon"..index];
						local EquipSlot = _G[fName.."_EquipmentFrame_EquipSlot"..index];
						local TitleString = _G[name.."_TitleString"..index];
						
						if ( ItemLink ) then
							local ItemName, ItemLink2, ItemQuality, ItemLevel, ItemReqLevel, ItemClass, ItemSubclass, ItemMaxStack, ItemEquipSlot, ItemTexture, ItemVendorPrice = GetItemInfo(ItemLink);
							local ItemStats = f:ScanItem(ItemLink) or {};
							for i,v in pairs(ItemStats) do
								TotalStats[i] = ( TotalStats[i] or 0 ) + v;
							end;					
							if ( ItemQuality == 7 ) then
								ItemLevel = 187;
								ItemRarity = 3;
							end
							
							TotalEquipment = TotalEquipment + 1;
							local r, g, b, hex = GetItemQualityColor(ItemQuality);
							NameString:SetText(hex..ItemName);
							ItemIcon:SetBackdrop({ bgFile = ItemTexture });
							ItemIcon.Hyperlink = ItemLink;
							LevelString:SetText(hex..ItemLevel);
							local GemCount, Gems, MissingGemCount, MissingGems = f:GetGemInfo(ItemLink);
							TotalMissingGems = TotalMissingGems + MissingGemCount;
							for j = 1,GemCount do
								if ( TenTonHammer_Settings["EquipTab"] == 1 ) then
									_G[name.."_GemIcon"..j.."-"..index].Hyperlink = Gems[j]["Link"];
									_G[name.."_GemIcon"..j.."-"..index].GemName = Gems[j]["Name"];
									_G[name.."_GemIcon"..j.."-"..index].OriginalIcon = { bgFile = Gems[j]["Texture"] };
								end;
								
								if ( TenTonHammer_Elite[SpecID] ) and ( TenTonHammer_Elite[SpecID]["GEMS"][Gems[j]["Name"]] ) then
									if ( TenTonHammer_Settings["EquipTab"] == 1 ) then
										_G[name.."_GemIcon"..j.."-"..index]:SetBackdrop({ bgFile = "Interface\\Icons\\Spell_ChargeNegative" });
										_G[name.."_GemIcon"..j.."-"..index].sucks = true;
									end;
									NegativeGems = NegativeGems + 1;
								else
									if ( TenTonHammer_Settings["EquipTab"] == 1 ) then
										_G[name.."_GemIcon"..j.."-"..index]:SetBackdrop({ bgFile = Gems[j]["Texture"] });
									end;
									
								end;
								
							end;
							EquipSlot:SetBackdrop({ bgFile = ItemTexture });
							EquipSlot.Hyperlink = ItemLink;
							local ItemScore, IncorrectItems, ItemColor = f:GetItemScore(ItemLink, PlayerRole, Class, IncorrectItems);						
							
							
							if ( f.data.ItemTypes[ItemEquipSlot]["Enchantable"] ~= 0) then 
								local EnchantInfo = f:GetEnchantInfo(ItemLink);
								local SlotName = TitleString:GetText();
								if ( EnchantInfo ) then
									EnchantIcon:SetBackdrop({ bgFile = "Interface\\Icons\\Spell_ChargePositive"});
									ItemScore = ItemScore * 1.03;
									EnchantIcon.Hyperlink = {hex..ItemName, SlotName, EnchantInfo};
									EnchantIcon.EnchantName = EnchantInfo;
								if ( TenTonHammer_Elite[SpecID] ) and ( TenTonHammer_Elite[SpecID]["ENCHANTS"][EnchantInfo] ) then
									EnchantIcon:SetBackdrop({ bgFile = "Interface\\Icons\\Spell_ChargeNegative" });
									EnchantIcon.sucks = true;
									NegativeEnchants = NegativeEnchants + 1;
								end;
									
								elseif ( f.data.ItemTypes[ItemEquipSlot]["Enchantable"] ~= 2 ) then
									EnchantIcon:SetBackdrop({ bgFile = "Interface\\Icons\\Spell_ChargeNegative" });
									EnchantIcon.Hyperlink = {hex..ItemName, SlotName, "|cffff0000"..L["Missing Enchantment!"]};
									TotalMissingEnchants = TotalMissingEnchants + 1;
								end;
							end;
							
							if ( ItemEquipSlot == "INVTYPE_WAIST" ) then
								local SlotName = TitleString:GetText();
								if ( f:GetBeltBuckle(ItemLink, GemCount) ) then
									
									ItemScore = ItemScore * 1.03;
									EnchantIcon:SetBackdrop({ bgFile = "Interface\\Icons\\INV_Belt_36"});
									EnchantIcon.Hyperlink = {hex..ItemName, SlotName, L["Belt Buckle Detected"]};
									tinsert(PositiveArray, {L["Belt Buckle"], string.format(L["This player has used a Belt buckle to add a gem socket to their %s."], hex..ItemName)});
								else
									EnchantIcon:SetBackdrop({ bgFile = "Interface\\Icons\\Spell_ChargeNegative" });
									EnchantIcon.Hyperlink = {hex..ItemName, SlotName, "|cffff0000"..L["Missing Belt Buckle"]};	
									tinsert(NegativeArray, {L["Missing Belt Buckle"], L["This player has not applied a Belt Buckle to their belt."]});	
									BeltBuckle = false;							
								end;
							end;
							
							ItemScore = ItemScore * ( 1 - ( .02 * MissingGemCount ) );
							ItemScore = floor(ItemScore);
							
							if ( f.data.ItemTypes[ItemEquipSlot]["Weapon"] > 0 ) then
								WeaponValue = WeaponValue + f.data.ItemTypes[ItemEquipSlot]["Weapon"];
								AIL_Weapon = AIL_Weapon + f.data.ItemTypes[ItemEquipSlot]["Weapon"];
								
								WeaponScore = WeaponScore + ItemScore;
								ItemCount = ItemCount + f.data.ItemTypes[ItemEquipSlot]["Weapon"];
								AverageItemLevel = AverageItemLevel + ( ItemLevel * f.data.ItemTypes[ItemEquipSlot]["Weapon"] );
							else
								AverageItemLevel = AverageItemLevel + ItemLevel;
								ItemCount = ItemCount + 1;
							end;
							
							GearString:SetText(ItemColor..ItemScore);
							GearScore = GearScore + ItemScore;
							
							if ( UnitInRaid(unit) ) or ( UnitInParty(unit) ) or ( UnitIsUnit(unit, "player") ) then
								f.PartyData[PlayerName][index] = ItemScore;
							end;
						end;
					end;
					if ( WeaponValue > 2 ) then
						GearScore = GearScore - floor(WeaponScore - ( 2 * WeaponScore / WeaponValue ));
						AverageItemLevel = AverageItemLevel - floor(AverageItemLevel - ( 2 * AIL_Weapon / WeaponValue ));
					end;
					AverageItemLevel = floor((AverageItemLevel / 17)+0.5);
					f.AIL_Info = { PlayerName, AverageItemLevel };
					--print(AverageItemLevel);
					f:SetRaidChart(GearScore);
					
					local ScoreArray = { GearScore, RaidScore, PVEScore, PVPScore }
					for i = 1,4 do
						local r,g,b,hex = f:GetColor(ScoreArray[i]);
						_G[fName.."_Frame1_Info"..1+i]:SetText(nil, hex..ScoreArray[i]);
						if ( i == 1 ) then
							TenTonHammer_Frame2_Total:SetText(nil, hex..ScoreArray[i]);
							TenTonHammer_Frame2_AIL:SetText(nil, hex..AverageItemLevel);
						end;
					end;
					
					
					
					for i,v in pairs(IncorrectItems) do
						tinsert(NegativeArray, {string.format(L["%d %s items equipped"], v, i), L["These items are not appropriate for this player's spec. These items will reduce this player's potential performance in PVE Combat."]});
					end;
					
					if ( NegativeEnchants > 0 ) then
						tinsert(NegativeArray, {string.format(L["%d Negative enchantments."], NegativeEnchants), L["This player is using enchantments which you have marked as negative for their spec."]});
					end;
					
					if ( NegativeGems > 0 ) then
						tinsert(NegativeArray, {string.format(L["%d Negative gems."], NegativeGems), L["This player is using gems which you have marked as negative for their spec."]});
					end;
					
					if ( ItemCount < 17 ) then
						tinsert(NegativeArray, {string.format(L["%s empty equipment slot(s)"], 17 - ItemCount), L["This player is missing equipment and which will drastically reduce performance."]});
					end;
					if ( TotalMissingEnchants > 0 ) then
						tinsert(NegativeArray, {format(L["%d Unenchanted Item(s)"], TotalMissingEnchants), L["This player is missing enchantments and will not be able to perform at their maximum."]});
					else
						tinsert(PositiveArray, {L["All Items Enchanted"], L["This player has enchanted all their enchantable items which will increase their performance."]});
					end;
					
					if ( TotalMissingGems > 0 ) then
						tinsert(NegativeArray, {format(L["%d Empty Gem Socket(s)"], TotalMissingGems),  L["This player is missing gems and will not be able to perform at their maximum."]});
					else
						tinsert(PositiveArray, { L["No Empty Gem Sockets"], L["This player has gemmed all their items which will increase their performance."] });
					end;
					local  StatusIndex = 22;
					name = fName.."_Frame1";
					
					if ( UnitAura(unit, L["Celestial Steed"]) ) then 
						tinsert(NegativeArray, { L["Celestial Steed"], L["This player is currently riding TRH... \n (Which means nothing at all.)"]});
					end;
					if ( UnitAura(unit, L["Spectral Tiger"]) ) then 
						tinsert(PositiveArray, { L["Spectral Tiger"], L["This player is currently riding a Spectral Tiger!"]});
					end;
					
					
					if ( ( f.data.Special[f.Region] ) and ( f.data.Special[f.Region][PlayerRealm] ) and ( f.data.Special[f.Region][PlayerRealm][PlayerName] ) ) then
						local data = f.data.Special[f.Region][PlayerRealm][PlayerName];
						tinsert(PositiveArray, { data[1], data[2] });
						if ( data[3]  ) then PlaySoundFile(data[3]); end;
					end;
					
					
					for i,v in pairs(PositiveArray) do
						local StatusText = _G[name.."_Info"..StatusIndex];
						StatusText:SetText(v[1], "OK");
						StatusText:SetColor(0,1,0,1);
						StatusIndex = StatusIndex + 1;		
						if ( v[2] ) then StatusText.Hyperlink = v[2]; end;		
					end;
					for i,v in pairs(NegativeArray) do
						if ( StatusIndex < 28 ) then 
							local StatusText = _G[name.."_Info"..StatusIndex];
							StatusText:SetText(v[1], "X");
							StatusText:SetColor(1,0,0,1);
							StatusIndex = StatusIndex + 1;
							if ( v[2] ) then StatusText.Hyperlink = v[2]; end;
						end;
					end;
					local j = 0;
					local RoleData = f.data.RoleStats[PlayerRole]
					for i = 1,6,2 do 
						j = j + 1;
						if ( L[RoleData[i+1] or ""] == "" ) then 
							_G[fName.."_Frame1_Info"..(29+j)]:SetText(strjoin("", "|cff00ff00", "+", (TotalStats[RoleData[i]] or "0")," |r", L[RoleData[i]]), "" );
						else
							_G[fName.."_Frame1_Info"..(29+j)]:SetText(strjoin("", "|cff00ff00", "+", (TotalStats[RoleData[i]] or "0")," |r", L[RoleData[i]]), strjoin("", L[RoleData[i+1] or ""] , " |cff00ff00+", (TotalStats[RoleData[i+1]] or "0")));
						end;
					end;
						_G[fName.."_Frame1_Info29"]:SetText(strjoin("", "|cff00ff00", "+", TotalStats["MASTERY"] or "0"," |r", L["MASTERY"]));
						_G[fName.."_Frame1_Info29"]:Center();
					
					
					local ThumbsUp, ThumbsDown, PreviousVote = 0,0,0;
					
					if ( TenTonHammer_Database[f.Realm][PlayerName] ) then
						local PlayerData = TenTonHammer_Database[f.Realm][PlayerName];
						local PlayerDataArray = {};
						for v in string.gmatch(PlayerData, "[^:]+") do tinsert(PlayerDataArray, v); end;
						ThumbsUp = PlayerDataArray[6];
						ThumbsDown = PlayerDataArray[7];
						PreviousVote = PlayerDataArray[8];
						
					end;
					f:SetMainThumbs(ThumbsUp, ThumbsDown)
					local ThumbsUpIcon = _G[fName.."_Frame1_ThumbsUp"];
					local ThumbsDownIcon = _G[fName.."_Frame1_ThumbsDown"];
					ThumbsDownIcon:SetBackdrop({bgFile="Interface\\AddOns\\GearScore\\UI\\thumbsdown" });
					ThumbsUpIcon:SetBackdrop({bgFile="Interface\\AddOns\\GearScore\\UI\\thumbsup" });
				
					
					if ( PreviousVote == "-1" ) then 
						ThumbsDownIcon:SetBackdrop({bgFile="Interface\\AddOns\\GearScore\\UI\\thumbsdown_voted" });
					elseif ( PreviousVote == "1" ) then
						ThumbsUpIcon:SetBackdrop({bgFile="Interface\\AddOns\\GearScore\\UI\\thumbsup_voted" });
					end;
					
					ThumbsUpIcon:SetScript("OnMouseUp", function(...)
						ThumbsUp, ThumbsDown = f:Vote(PlayerName, PlayerRealm, 1);
						ThumbsUpIcon:SetBackdrop({bgFile="Interface\\AddOns\\GearScore\\UI\\thumbsup_voted" });
						ThumbsDownIcon:SetBackdrop({bgFile="Interface\\AddOns\\GearScore\\UI\\thumbsdown" });
						f:SetMainThumbs(ThumbsUp, ThumbsDown);
					end);
					ThumbsDownIcon:SetScript("OnMouseUp", function(...)
						ThumbsUp, ThumbsDown = f:Vote(PlayerName, PlayerRealm, -1);
						ThumbsDownIcon:SetBackdrop({bgFile="Interface\\AddOns\\GearScore\\UI\\thumbsdown_voted" });
						ThumbsUpIcon:SetBackdrop({bgFile="Interface\\AddOns\\GearScore\\UI\\thumbsup" });
						f:SetMainThumbs(ThumbsUp, ThumbsDown);
					end);
					
					_G[fName.."_EquipmentFrame_Model"]:SetUnit(unit);
					ClearInspectPlayer();
					ClearAchievementComparisonUnit();
					
					--if ( not MadeUpShit ) then
					if ( f.ScanCount == 1 ) and ( ( (ItemCount < 17) and (unit ~= "player") and (PlayerLevel == 85) ) or (MissingTalents == 41) )  then 
						f:Scan(unit, shouldtargetplayer, hidewait, litemode);
					else
						
						_G[fName.."_Frame1_ThumbsUp"]:Show();
						_G[fName.."_Frame1_ThumbsDown"]:Show();
						f.ScanCount = 0;
						
						if ( UnitInRaid(unit) ) or ( UnitInParty(unit) ) or ( UnitIsUnit(unit, "player") ) then
							f.PartyData[PlayerName]["GearScore"] = GearScore;
							f.PartyData[PlayerName]["RaidScore"] = RaidScore;
							f.PartyData[PlayerName]["PVEScore"] = PVEScore;
							f.PartyData[PlayerName]["PVPScore"] = PVPScore;
							f.PartyData[PlayerName]["SpecID"] = SpecID;
							f.PartyData[PlayerName]["ThumbsUp"] = ThumbsUp or 0;
							f.PartyData[PlayerName]["ThumbsDown"] = ThumbsDown or 0;
							f.PartyData[PlayerName]["Vote"] = PreviousVote or 0;
							f.PartyData[PlayerName]["Negative"] = NegativeArray;
							f.PartyData[PlayerName]["Positive"] = PositiveArray;
							f.PartyData[PlayerName]["AverageItemLevel"] = AverageItemLevel;
						end;
						
						
						if ( UnitIsUnit(unit, "player") ) then
							PaperDollFrame_UpdateStats();
						end;
						
						local TimeStamp = f:GetTimeStamp();
						
						
						local DatabaseConstruct = strjoin(":", TimeStamp, GearScore, RaidScore, PVEScore, PVPScore, ThumbsUp or 0, ThumbsDown or 0, PreviousVote or 0, 0 );
						if not ( TenTonHammer_Database[PlayerRealm] ) then TenTonHammer_Database[PlayerRealm] = {}; end;
						TenTonHammer_Database[PlayerRealm][PlayerName] = DatabaseConstruct;
						if ( f.ScanQue ) and ( f.ScanQue[1] ) then 
							f:SwitchTabs(8);
							f.ScanQue[1](); 
						else
							if ( _G[fName.."_Frame8"]:IsVisible() ) then
								f:SwitchTabs(8);
							end;
							_G[fName.."_WaitFrame"]:Hide();
							if ( litemode ) then
								f.LiteScanTarget = "";
								if ( UnitIsUnit(unit, "mouseover") ) then
									GameTooltip:SetUnit(unit);
								end;
							end;
							TenTonHammer_WaitFrame_Text:SetText("|cffffffff"..L["Calculating scores, shining shields, putting the Gob in Goblins."].."\n"..L["Just keep sitting there in your underwear for approximately 2 seconds."].."\n"..L["This section will automagically refresh when we're done. Thanks!"]);
						end;
					end;
				end 
			); 
			if ( shouldtargetplayer ) then gg:TimerCallback(); end;
		end; 
		f.InspectReady = true;
		--print(GetFunctionCPUUsage(f.Scan, true));
		return true;
	else
		f.Callback["INSPECT_READY"] = function(...)
			f:Scan(unit, shouldtargetplayer, hidewait, litemode);
		end;
		--print(GetFunctionCPUUsage(f.Scan, true));
		return false;
	end;
end;

function f:UpdateJustItems()

end;

function f:SetMainThumbs(ThumbsUp, ThumbsDown)
	local r,g,b = f:GetColor100(ThumbsUp + .01, 0, ThumbsUp + ThumbsDown + .02);
	local PlayerRatingText = _G[fName.."_Frame1_Info10"];
	PlayerRatingText:SetText(L["Player Rating"]..":", "|cff00ff00+"..ThumbsUp.."     |r |cffffff00 /|r |cffff0000-"..ThumbsDown.."     ");
	PlayerRatingText:SetColor(r,g,b,1);
	PlayerRatingText:SetPoint("TOPLEFT", PlayerRatingText:GetParent(), "TOPLEFT", 35, -165);
	PlayerRatingText:SetScript("OnEnter", nil);
	local ThumbsUpIcon = _G[fName.."_Frame1_ThumbsUp"];
	ThumbsUpIcon:SetPoint("TOPLEFT", ThumbsUpIcon:GetParent(), "TOPLEFT", 250 - ( string.len(tostring(ThumbsDown)) * 8),-155);
	local ThumbsDownIcon = _G[fName.."_Frame1_ThumbsDown"];
	ThumbsDownIcon:SetPoint("TOPLEFT", ThumbsDownIcon:GetParent(), "TOPLEFT", 290,-158);
	ThumbsDownIcon.TextLink = L["Player ratings are ratings assigned by other players. They are gathered from the addon and PlayerScore.com. \n\nTo view ratings or upload them you must use the PlayerScore Updater. Visit PlayerScore.com for more information."].."\n\n|cffff0000"..L["Click here to rate this player down."];
	ThumbsUpIcon.TextLink = L["Player ratings are ratings assigned by other players. They are gathered from the addon and PlayerScore.com. \n\nTo view ratings or upload them you must use the PlayerScore Updater. Visit PlayerScore.com for more information."].."\n\n|cff00ff00"..L["Click here to rate this player up."];
end;
function f:Vote(PlayerName, PlayerRealm, Value)
	if not ( PlayerRealm ) then PlayerRealm = f.Realm; end;
	local PlayerData = TenTonHammer_Database[PlayerRealm][PlayerName];
	if not ( PlayerData ) then return 0, 0; end;
	local PlayerDataArray = {};
	for v in string.gmatch(PlayerData, "[^:]+") do tinsert(PlayerDataArray, v); end;
	local ThumbsUp, ThumbsDown, PreviousVote = PlayerDataArray[6], PlayerDataArray[7], PlayerDataArray[8];
	if ( PreviousVote == "-1" ) then 
		ThumbsDown = ThumbsDown - 1;
	elseif ( PreviousVote == "1" ) then
		ThumbsUp = ThumbsUp - 1;
	end;
	if ( Value == 1 ) then
		ThumbsUp = ThumbsUp + 1;
	elseif ( Value == -1 ) then
		ThumbsDown = ThumbsDown + 1;
	end;
	TenTonHammer_Ratings[f.Realm..PlayerName] = string.join("|", "[73]17,72,224", string.join(",", PlayerName,PlayerRealm,f.Region), string.join(",", f.PlayerName,f.Realm,f.Region), Value..","..f:GetTimeStamp().."00");
	PlayerDataArray[6] = ThumbsUp;
	PlayerDataArray[7] = ThumbsDown;
	PlayerDataArray[8] = Value;
	PlayerData = string.join(":", unpack(PlayerDataArray) );
	TenTonHammer_Database[f.Realm][PlayerName] = PlayerData;
	return ThumbsUp, ThumbsDown;
end;
function f:WipeStatus()
	
	local name = f:GetName().."_Frame1";
	for i = 22,27 do
		 _G[name.."_Info"..i]:SetText("","");
		 _G[name.."_Info"..i].Hyperlink = nil;
	end; 
	
	name = f:GetName().."_Frame4";
	for i = 1,30 do
		 _G[name.."_Info"..i]:SetText("","");
		 _G[name.."_Info"..i]:SetText("","");
	end;
end;
function f:Wipe()
	
	local Order = {1,2,3,15,5,9,10,6,7,8,11,12,13,14,16,17,18};
	local name = f:GetName().."_Frame2";
	for i = 1,17 do
		local index = Order[i];
		local NameString = _G[name.."_NameString"..index];
		local ItemIcon = _G[name.."_ItemIcon"..index];
		local LevelString = _G[name.."_LevelString"..index];
		local GearString = _G[name.."_GearString"..index];
		local EnchantIcon = _G[name.."_EnchantIcon"..index];
		local EquipSlot = _G[f:GetName().."_EquipmentFrame_EquipSlot"..index];
		local PlayerString = _G[fName.."_TitleFrame_PlayerText"];
		local GuildString = _G[fName.."_TitleFrame_GuildText"];
		PlayerString:SetText("");
		GuildString:SetText("");
		NameString:SetText("");
		ItemIcon:SetBackdrop({ bgFile = nil });
		ItemIcon.Hyperlink = nil;	
		LevelString:SetText("");
		GearString:SetText("");
		for j= 1,3 do
			_G[name.."_GemIcon"..j.."-"..index]:SetBackdrop({ bgFile = nil });
			_G[name.."_GemIcon"..j.."-"..index].Hyperlink = nil;
			_G[name.."_GemIcon"..j.."-"..index].OriginalIcon = nil;
		end;
		EquipSlot:SetBackdrop({ bgFile = EquipSlot.defaultTexture });
		EquipSlot.Hyperlink = nil;
		EnchantIcon:SetBackdrop({ bgFile = nil });
		EnchantIcon.Hyperlink = nil;
		
	end;
	
	
	name = f:GetName().."_Frame1";
	for i = 8,27 do
		 _G[name.."_Info"..i]:SetText("","");
		 _G[name.."_Info"..i].Hyperlink = nil;
	end; 
	for i = 29,32 do
		 _G[name.."_Info"..i]:SetText("","");
	end; 
	
	name = f:GetName().."_Frame4";
	for i = 1,30 do
		 _G[name.."_Info"..i]:SetText("","");
		 _G[name.."_Info"..i].Dungeon = nil;
		 _G[name.."_Boss"..i]:SetText("","");
	end;
end;
function f:WipeBoss()
	local name = f:GetName().."_Frame4";
	for i = 1,30 do
		_G[name.."_Boss"..i]:SetText("","");
	end;
end;
function f:SetRaidChart(Level)
	if not ( Level ) or ( Level == 0 ) then Level = 1; end;
	local Results = {};
	local RaidChart = {
		{ L["Level 80 Heroics"], 2712, },
		{ L["Naxxramas 10"], 2896 },
		{ L["Naxxramas 25"], 3353 },
		{ L["Ulduar 10"], 3563 },
		{ L["Ulduar 25"], 3809 },
		{ L["Crusader 10"], 4019 },
		{ L["Crusader 25"], 4475 },
		{ L["Icecrown 10"], 4686 },
		{ L["Icecrown 25"], 5142 },
		{ L["Heroic Icecrown 25"], 5598 },
		{ L["Level 85 Heroics"], 8019},
		{ L["Tier 11 Raids"], 8475 },
		{ L["Tier 11 Heroic Raids"], 8932 },
		{ L["Lady Sinestra"], 9177 },
	};
	
	local Difficulty = {
		[-420] = { L["Impossible"], "|cffFF0000", L["This player would face utter defeat and devastation in this instance."]  },
		[-315] = { L["Brutal"], "|cffFF2C00", L["This player will need perfect skills and reaction time to succeed in this instance."] },
		[-210] = { L["Formidable"], "|cffFF5600", L["This player will need extremely honed skills to succeed in this instance."] },
		[-105] = { L["Difficult"], "|cffFF8000" },
		[0] = { L["Challenging"], "|cffFFAC00" },
		[105] = { L["Moderate"], "|cffFFD600" },
		[210] = { L["Normal"], "|cffFFFF00" },
		[315] = { L["Light"], "|cffC0FF00" },
		[420] = { L["Easy"], "|cff80FF00" },
		[525] = { L["Trivial"], "|cff40FF00" },
		[630] = { L["Effortless"], "|cff00FF00" },
	};
	
	local Index = #RaidChart - 1; 
	for i = 2, Index do
		if ( Level <= RaidChart[i+1][2] ) then
			Index = i;
			break;
		end;
	end;
	
	Results[1] = Index - 1;
	Results[2] = Index;
	Results[3] = Index + 1;
	
	local name = fName.."_Frame1";
	
	for i = 1,3 do
		local InfoString = 	_G[name.."_Info"..i + 12];
		local DifficultyIndex = Level - RaidChart[Results[i]][2]
		DifficultyIndex = DifficultyIndex - mod(DifficultyIndex, 105) - 105;
		if ( DifficultyIndex < -420 ) then DifficultyIndex = -420; end;
		if ( DifficultyIndex > 630 ) then DifficultyIndex = 630; end;
		local hex = Difficulty[DifficultyIndex][2];
		InfoString:SetText(hex..RaidChart[Results[i]][1],hex..Difficulty[DifficultyIndex][1]);
		InfoString.Hyperlink = hex..RaidChart[Results[i]][1].." - "..Difficulty[DifficultyIndex][1].."|cffffffff\n"..(Difficulty[DifficultyIndex][3] or "Some description on how hard this would be.");
	end;
end;
function f:GetItemRole(ItemStats)
	if ( ItemStats["RESILIENCE"] ) then
		return 20;
	elseif ( ItemStats["STR"] or ItemStats["AGI"] ) then
		if ( ItemStats["PARRY"] or ItemStats["DODGE"] or ItemStats["BLOCK"] ) then return 1; else return 2; end;
	elseif ( ItemStats["INT"] or ItemStats["SPI"] ) then
		if ( ItemStats["TOHIT"] ) then return 5; else return 6; end;
	end;	
	return 0;
end;
function f:GetRoleRate(PlayerRole, ItemRole, IncorrectItems)
	if ( not IncorrectItems ) then IncorrectItems = {}; end;
	if not ( PlayerRole ) or ( PlayerRole == 0 ) then return 1, IncorrectItems; end;
	local d = PlayerRole - ItemRole;
	if ( d == -1 ) or ( ItemRole == 0 ) or ( d == 0 )then 
		return 1, IncorrectItems;
	elseif ( d == 1 ) then
		IncorrectItems[f.data.Roles[ItemRole]] = ( IncorrectItems[f.data.Roles[ItemRole]] or 0 ) + 1;
		return .75, IncorrectItems;
	elseif ( abs(d) >= 3) and ( abs(d) <= 6 ) then
		IncorrectItems[f.data.Roles[ItemRole]] = ( IncorrectItems[f.data.Roles[ItemRole]] or 0 ) + 1;
		return .5, IncorrectItems;
	elseif ( abs(d) > 6 ) then
		IncorrectItems[f.data.Roles[ItemRole]] = ( IncorrectItems[f.data.Roles[ItemRole]] or 0 ) + 1;
		return .75, IncorrectItems;
	else
		return 0, IncorrectItems;
	end;
end;
function f:GetItemScore(ItemLink, PlayerRole, PlayerClass, IncorrectItems)
	if not ( IncorrectItems ) then local IncorrectItems = {}; end;
	if not ( PlayerRole ) then local PlayerRole = 0; end;
	if not ( IsEquippableItem(ItemLink) ) then return nil, IncorrectItems, nil; end;
	local ItemSubStringTable = {};
	local found, _, ItemSubString = string.find(ItemLink, "^|c%x+|H(.+)|h%[.*%]");
	--print(ItemSubString);
	for v in string.gmatch(ItemSubString, "[^:]+") do tinsert(ItemSubStringTable, v); end
	local ItemID = ItemSubStringTable[2];
	local ItemName, ItemLink, ItemRarity, ItemLevel, ItemReqLevel, ItemClass, ItemSubclass, ItemMaxStack, ItemEquipSlot, ItemTexture, ItemVendorPrice = GetItemInfo(ItemID);
	--print(ItemName, ItemLink, ItemRarity, ItemLevel, ItemReqLevel, ItemClass, ItemSubclass, ItemMaxStack, ItemEquipSlot, ItemTexture, ItemVendorPrice);
	if not ( f.data.ItemTypes[ItemEquipSlot] ) then return nil, IncorrectItems, nil; end;
	local ItemStats = f:ScanItem(ItemLink) or {};
	if (ItemRarity == 7) then ItemLevel = 187; end;
	local GS_Formula = { {ItemLevel, 1}, { 73, 1 }, { 81.375, .8125 }, { 91.45, .65 }, { 91.45, .5 }, { 91.45, .5 }, { 81.375, .8125 } };
	local GS_FormulaVanilla = { {ItemLevel, 1}, { 8, 2 }, { .75, 1.8 }, { 26, 1.2 }, { 26, .923 }, { 26, .923 }, { 81.375, .8125 } };
	local GS_FormulaCataclysm = { {ItemLevel, 1}, { 91.45000, 0.65000 },{ 91.45000, 0.65000 }, { 91.45000, 0.65000 }, { 91.45000, 0.65000 }, { 91.45000, 0.65000 }, { 91.45000, 0.65000 } };
	local GS_FormulaCataclysm2 = { {ItemLevel, 1}, { 81.375, 0.8125 }, { 81.375, .8125 }, { 81.375, .8125 }, { 81.375, .8125 }, { 81.375, .8125 }, { 81.375, .8125 } };
	GS_Formula[0] = GS_Formula[1];
	GS_FormulaVanilla[0] = GS_FormulaVanilla[1];
	RoleRate, IncorrectItems = f:GetRoleRate(PlayerRole, f:GetItemRole(ItemStats), IncorrectItems)
	local ItemScore = 0;
	
	if ( ItemLevel > 277 ) then
		ItemScore = floor(  (((ItemLevel - GS_FormulaCataclysm[ItemRarity][1]) / GS_FormulaCataclysm[ItemRarity][2]) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291) * RoleRate );
		
		--ItemScore = floor(  (((ItemLevel - 91.45) / 0.65) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291) * RoleRate );
		--ItemScore = floor(  (((ItemLevel - 81.375) / 0.75) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291) * RoleRate );
		
	elseif ( ItemLevel > 120 ) then
		ItemScore = floor(  (((ItemLevel - GS_Formula[ItemRarity][1]) / GS_Formula[ItemRarity][2]) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291) * RoleRate );
	else
		ItemScore = floor(  (((ItemLevel - GS_FormulaVanilla[ItemRarity][1]) / GS_FormulaVanilla[ItemRarity][2]) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291) * RoleRate );
	end;
	if ( ItemScore < 0 ) then ItemScore = 0; end;
	
	local r,g,b, hex =  f:GetColor( floor( 12.25 * ItemScore / f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] ) );
	
	if ( PlayerClass == "HUNTER" ) then
		if ( ItemEquipSlot == "INVTYPE_RANGED" or ItemEquipSlot == "INVTYPE_RANGEDRIGHT" ) then ItemScore = floor(ItemScore * 5.3224); end;
		if ( f.data.ItemTypes[ItemEquipSlot]["Weapon"] > 0 ) then ItemScore = floor(ItemScore * .3164); end;
	end;
	return ItemScore, IncorrectItems, hex;
end;
function f:BuildRaidList()
	
	for Expansion, data1 in pairs(f.data.DungeonList) do
		for Category, data2 in pairs(data1) do
			for  id, name in pairs(data2) do
				local AchievementID, AchievementName = GetAchievementInfo(Category, id);
				local AchievementString = {};
				
				for v in string.gmatch(AchievementName, "[^\(*\)]+") do tinsert(AchievementString, v); end;
				L[name] = AchievementString[2];
				--print(AchievementID, AchievementString[2], Category, id)
			end;
		end;
	end;
	
	f.data["RaidOrder"] = {
		[L["Cataclysm"]] = {
			L["Blackwing Descent"],
			L["Bastion of Twilight"],
			L["Throne of the Four Winds"],
			L["Baradin Hold"],
		},
		[L["Wrath of the Lich King"]]  = {
			L["Heroic Ruby Sanctum 25 player"],
			L["Heroic Ruby Sanctum 10 player"],
			L["Ruby Sanctum 25 player"],
			L["Ruby Sanctum 10 player"],
			L["Heroic Icecrown 25 player"],
			L["Heroic Icecrown 10 player"],
			L["Icecrown 25 player"],
			L["Icecrown 10 player"],
			L["Trial of the Grand Crusader 25 player"],
			L["Trial of the Grand Crusader 10 player"],
			L["Trial of the Crusader 25 player"],
			L["Trial of the Crusader 10 player"],
			L["Ulduar 25 player"],
			L["Ulduar 10 player"],
			L["Malygos 25 player"],
			L["Malygos 10 player"],
			L["Naxxramas 25 player"],
			L["Naxxramas 10 player"],
			L["Wintergrasp 25 player"],
			L["Wintergrasp 10 player"],
		},
	};
	
end;
function f:BuildExperience()
	if ( TenTonHammer_Settings["ExperienceTab"] ~= 1 ) then return false; end;
	if ( not f.data["RaidOrder"] ) then
		f:BuildRaidList();
	end;
	local ExpansionList = { 
		L["Cataclysm"], 
		L["Wrath of the Lich King"],  
	};
	local index = 1;
	local AchievementData = {};
	local CategoryList = {
		--[L["Cataclysm"]]  =  {15096},
		[L["Cataclysm"]]  =  { 15096, },
		[L["Wrath of the Lich King"]] = { 14823, 14963, 15021, 15062 },
	};
	for ExpansionIndex,ExpansionName in pairs(ExpansionList) do
		_G[fName.."_Frame4_Info"..index]:SetText(" - "..ExpansionName.." - ", "");
		_G[fName.."_Frame4_Info"..index]:Center();
		_G[fName.."_Frame4_Info"..index]:SetColor(1,1,1,1);
		_G[fName.."_Frame4_Info"..index].Header = true;
		index = index + 1;
		
		for CategoryNumber = 1, #CategoryList[ExpansionName] do
			CategoryIndex = CategoryList[ExpansionName][CategoryNumber];
			if ( CategoryIndex ) then
				for CurrentAchievement = 1, GetCategoryNumAchievements(CategoryIndex) do
					local AchievementID, AchievementName = GetAchievementInfo(CategoryIndex, CurrentAchievement);
					--print(AchievementID, AchievementName);
					local AchievementString = {};
					local AchievementCount = tonumber(GetComparisonStatistic(AchievementID)) or 0;
					for v in string.gmatch(AchievementName, "[^\(*\)]+") do tinsert(AchievementString, v); end;
					--if ( AchievementString[2] ) and ( string.find(AchievementString[2], "%d") ) then print( AchievementString[2] ); end;
					if ( AchievementID == 1394 ) then AchievementString[2] = L["Malygos 25 player"]; end;
					if ( AchievementID == 1391 ) then AchievementString[2] = L["Malygos 10 player"]; end;
					
					if ( AchievementID == 4044 ) then AchievementString[2] = L["Trial of the Crusader 10 player"]; AchievementString[1] = L["Anub'arak kills"]; end;
					if ( AchievementID == 4045 ) then AchievementString[2] = L["Trial of the Grand Crusader 10 player"]; AchievementString[1] = L["Anub'arak kills"]; end;
					if ( AchievementID == 4046 ) then AchievementString[2] = L["Trial of the Crusader 25 player"]; AchievementString[1] = L["Anub'arak kills"]; end;
					if ( AchievementID == 4047 ) then AchievementString[2] = L["Trial of the Grand Crusader 25 player"]; AchievementString[1] = L["Anub'arak kills"]; end;
					
					if ( AchievementString[2] ) then --and ( string.find(AchievementString[2], "%d") ) then
						if not ( AchievementData[AchievementString[2]] ) then
							AchievementData[AchievementString[2]] = {};
						end;
						tinsert(AchievementData[AchievementString[2]], { AchievementString[1], AchievementCount });
					end;
				end;
			end;
		end;
		
		for DungeonIndex, DungeonName in pairs(f.data.RaidOrder[ExpansionName]) do
			--print(DungeonIndex, DungeonName);
			if ( AchievementData[DungeonName] ) then
				--print("Doing Dungeon", DungeonName);
				local Bosses, Progression = 0,0;
				for BossIndex,BossData in pairs(AchievementData[DungeonName]) do
					Bosses = Bosses + 1;
					if ( BossData[2] > 0 ) then
						Progression = Progression + 1;
					end;
				end;
				local r,g,b = f:GetColor100(Progression, 0, Bosses);
				_G[fName.."_Frame4_Info"..index]:SetText(DungeonName, Progression.." / "..Bosses );
				_G[fName.."_Frame4_Info"..index]:SetColor(r,g,b,1);
				_G[fName.."_Frame4_Info"..index].Dungeon = DungeonName;
				index = index + 1;
			end;
		end;
		
		_G[fName.."_Frame4_Info"..index]:SetText("", "");
		index = index + 1;
	end;
	f.AchievementData = AchievementData;
	
	local RaidIndex = 1;
	local BossProgression = 0;
	local BossMaxProgression = 0;
	local TotalBossKills = 0;
	local ProgressionInstance = "";
	while ( BossProgression == 0 ) and ( f.AchievementData[f.data.RaidOrder[ExpansionList[1]][RaidIndex]] ) do
		f:WipeBoss();
		_G[fName.."_Frame4_Boss1"]:SetText(" - "..f.data.RaidOrder[ExpansionList[1]][RaidIndex].." - ", "");
		ProgressionInstance = f.data.RaidOrder[ExpansionList[1]][RaidIndex];
		_G[fName.."_Frame4_Boss1"]:Center();
		_G[fName.."_Frame4_Boss1"]:SetColor(1,1,1,1);
		local BossInfoIndex = 2;
		BossMaxProgression = 0;
		for BossIndex, BossData in pairs(f.AchievementData[f.data.RaidOrder[ExpansionList[1]][RaidIndex]]) do
			local BossKills = BossData[2];
			local BossName = BossData[1];
			BossMaxProgression = BossMaxProgression + 1;
			if ( BossKills > 0 ) then 
				BossProgression = BossProgression  + 1;
			end;
			local r,g,b = f:GetColor100(BossKills, 0, 5);
			_G[fName.."_Frame4_Boss"..BossInfoIndex]:SetText(BossName, BossKills);
			_G[fName.."_Frame4_Boss"..BossInfoIndex]:SetColor(r,g,b,1);
			BossInfoIndex = BossInfoIndex + 1;
		end;
		RaidIndex = RaidIndex + 1;
	end;
	if ( BossProgression > 0 ) then
		local r,g,b = f:GetColor100(BossProgression, 0, BossMaxProgression);
		_G[fName.."_Frame1_Info19"]:SetText(ProgressionInstance, BossProgression.." / "..BossMaxProgression);
		_G[fName.."_Frame1_Info19"]:SetColor(r,g,b,1);
		RaidIndex = RaidIndex + 1;
		local BossKills = 0;
		if ( f.AchievementData[f.data.RaidOrder[ExpansionList[1]][RaidIndex]] ) then
			for BossIndex,BossData in pairs(f.AchievementData[f.data.RaidOrder[ExpansionList[1]][RaidIndex]]) do
				if ( BossData[2] > 0 ) then
					BossKills = BossKills + 1;
				end;
			end;
			r,g,b = f:GetColor100(BossKills, 0, #f.AchievementData[f.data.RaidOrder[ExpansionList[1]][RaidIndex]]);
			_G[fName.."_Frame1_Info18"]:SetText(f.data.RaidOrder[ExpansionList[1]][RaidIndex], BossKills.." / "..#f.AchievementData[f.data.RaidOrder[ExpansionList[1]][RaidIndex]] );
			_G[fName.."_Frame1_Info18"]:SetColor(r,g,b,1);
		else
			_G[fName.."_Frame1_Info18"]:SetText(ProgressionInstance, BossProgression.." / "..BossMaxProgression);
			_G[fName.."_Frame1_Info18"]:SetColor(r,g,b,1);
			_G[fName.."_Frame1_Info19"]:SetText("", "");
		end;
	else 
		RaidIndex = #f.data.RaidOrder[ExpansionList[1]];
		if ( f.AchievementData[f.data.RaidOrder[ExpansionList[1]][RaidIndex]] ) then
			_G[fName.."_Frame1_Info18"]:SetText(f.data.RaidOrder[ExpansionList[1]][RaidIndex], " 0 / "..#f.AchievementData[f.data.RaidOrder[ExpansionList[1]][RaidIndex]] );
			_G[fName.."_Frame1_Info19"]:SetText(f.data.RaidOrder[ExpansionList[1]][RaidIndex - 1], " 0 / "..#f.AchievementData[f.data.RaidOrder[ExpansionList[1]][RaidIndex - 1]] );
			_G[fName.."_Frame1_Info19"]:SetColor(1,0,0,1);
			_G[fName.."_Frame1_Info18"]:SetColor(1,0,0,1);
		end;
	end;
end;
local function getLeapYear(Year)
	
	if ( mod(Year, 4) == 0 ) then
		if ( mod(Year, 100) == 0 ) then
			if ( mod(Year, 400) == 0 ) then
				return true;
			else
				return false;
			end;
		else
			return true;
		end;
	else
		return false; 
	end;	
end;
function f:GetConvertedDays(TimeStamp)
	local Year = tonumber(string.sub(TimeStamp, 0, 4));
	local Month = tonumber(string.sub(TimeStamp, 5, 6));
	local Day = tonumber(string.sub(TimeStamp, 7, 8));
	local DayCount = 0;
	for i = 2009, Year - 1 do
		if ( getLeapYear(i) ) then
			DayCount = DayCount + 366;
		else
			DayCount = DayCount + 365;
		end;
	end;
	for i = 1, Month - 1 do
		if ( i == 2 ) then
			if ( getLeapYear(Year) ) then
				DayCount = DayCount + 29;
			else
				DayCount = DayCount + 28;
			end;
		else
			if ( f.data["DayCount"] ) then
				DayCount = DayCount + ( f.data["DayCount"][i] or 0 );
			else
				print("Error Found", i);
			end;
		end;
	end;
	
	DayCount = DayCount + Day;
	return DayCount;
end;
function f:GetNPC(Unit)
	if not ( Unit ) then return 0; end;
	local GUID = UnitGUID(Unit);
	if not ( GUID ) then return 0; end;
	local first3 = tonumber("0x"..strsub(GUID, 3,5));
	local unitType = bit.band(first3,15);
	local creatureID = 0;
	if ( unitType == 3 ) then
		creatureID = tonumber("0x"..strsub(GUID,7,10));
	end;
	return creatureID;
end
function f:GetAge(TimeStamp)
	local CurrentDate = f:GetTimeStamp();
	local s = "";
	local DateSpread = f:GetConvertedDays(CurrentDate) - f:GetConvertedDays(TimeStamp);
	if ( DateSpread == 0 ) then
		return "Scanned Today", 0,1,0, 0;
	elseif (DateSpread == 1 ) then
		return "Scanned Yesterday", 0,1,0, 0;
	elseif ( DateSpread < 7 ) then
		return "Scanned "..DateSpread.." day"..s.." ago", 1,1,0, DateSpread;
	elseif ( DateSpread < 30 ) then
		local WeekCount = floor(DateSpread / 7);
		if ( WeekCount ~= 1 ) then s = "s"; end;
		return "Scanned over "..WeekCount.." week"..s.." ago", 1, .5, 0, WeekCount;
	else
		return "Scanned over 1 month ago", 1, 0, 0, DateSpread;
	end;
end;
local function HookPlayerTooltip(self, unit)
	local PlayerName, unit = self:GetUnit();
	if not ( unit ) then return; end;
	local PlayerRealm;
	local ShowTip = false;
--	if ( unit == "mouseover" ) then
		PlayerName, PlayerRealm = UnitName(unit);
--	end;

	PlayerRealm = PlayerRealm or f.Realm;
	
	if ( (TenTonHammer_Settings["gearOnTip"] == 1) or (TenTonHammer_Settings["raidOnTip"] == 1) or (TenTonHammer_Settings["pveOnTip"] == 1) or (TenTonHammer_Settings["pvpOnTip"] == 1) or (TenTonHammer_Settings["ratingOnTip"] == 1) ) then
		ShowTip = true;
	end;
	local NPC = f:GetNPC(unit);
	if ( f.data.Bosses[NPC] ) then
		local NPCScore = f.data.Bosses[NPC];
		local r,g,b,hex = f:GetColor(NPCScore);
		self:AddLine(hex.."NPC's GearScore: "..NPCScore);
	end;
	
	if ( TenTonHammer_Database ) and ( TenTonHammer_Database[PlayerRealm] ) and ( TenTonHammer_Database[PlayerRealm][PlayerName] ) and ( ShowTip ) and ( UnitIsPlayer(unit) )  then	
		local PlayerData = TenTonHammer_Database[PlayerRealm][PlayerName];
		local PlayerDataArray = {};
		for v in string.gmatch(PlayerData, "[^:]+") do tinsert(PlayerDataArray, v); end
		local TimeStamp, GearScore, RaidScore, PVEScore, PVPScore, ThumbsUp, ThumbsDown = PlayerDataArray[1], PlayerDataArray[2], PlayerDataArray[3], PlayerDataArray[4], PlayerDataArray[5], PlayerDataArray[6], PlayerDataArray[7];
		local r,g,b,hex = f:GetColor(GearScore);
		local Online = "";
		if ( PlayerDataArray[9] == "1" ) then	Online = " (Online Database) ";	end;
		
		if ( TenTonHammer_Settings["gearOnTip"] == 1 ) then 
			self:AddLine(hex.."GearScore: "..GearScore); 
		end;
		if ( TenTonHammer_Settings["ailOnTip"] ) and ( f.AIL_Info[1] == PlayerName ) then 
			--print( f.AIL_Info[2] ); 
			self:AddDoubleLine(L["Equipped Average Item Level"]..":", f.AIL_Info[2], 1,1,1,1,1,1);
		end;
		if ( TenTonHammer_Settings["raidOnTip"] == 1 ) then 
			r,g,b,hex = f:GetColor(RaidScore);
			self:AddLine(hex..L["Raid"]..": "..RaidScore); 
		end;
		if ( TenTonHammer_Settings["pveOnTip"] == 1 ) then
			r,g,b,hex = f:GetColor(PVEScore);
			self:AddLine(hex..L["PvE"]..": "..PVEScore); 
		end;
		if ( TenTonHammer_Settings["pvpOnTip"] == 1 ) then
			r,g,b,hex = f:GetColor(PVPScore);
		 	self:AddLine(hex..L["PvP"]..": "..PVPScore); 
		 end;
		if ( TenTonHammer_Settings["ratingOnTip"] == 1 ) then 
			self:AddDoubleLine(L["Player Rating"]..":", "|cff00ff00+"..ThumbsUp.." |r/ |cffff0000-"..ThumbsDown); 
		end;
		if ( TenTonHammer_Settings["verbose"] == 1 ) then
			local data;
			if ( (f.data.LiteScanData and f.data.LiteScanData["Name"] == PlayerName ) ) then 
				data = f.data.LiteScanData;
			elseif ( f.PartyData and f.PartyData["Name"] ) then 
				data = f.PartyData["Name"]; 
			end;
			if ( data ) then
				for i,v in pairs(data.Negative) do
					self:AddLine("|cffff0000"..v[1]);
				end;
			end;
		end;
		
		
		local NoWDate, DateRed, DateGreen, DateBlue = f:GetAge(TimeStamp);
		hex = f:GetHexColor(DateRed, DateGreen, DateBlue);
		self:AddLine(hex..NoWDate..Online);
	end;
	if ( f.LiteScanTarget == UnitName(unit or "target") ) then
		self:AddLine("|cffff0000*Requesting Equipment from server...*");
	end;

	if ( f.data["Special"][f.Region] ) and ( f.data["Special"][f.Region][f.Realm] ) and (f.data["Special"][f.Region][f.Realm][PlayerName] )  then
		self:AddLine("|cffff0000"..f.data["Special"][f.Region][f.Realm][PlayerName][1]);
	end;
	
	if ( TenTonHammer_Claimed ) and ( TenTonHammer_Claimed[UnitGUID(unit)] ) then
		local data = TenTonHammer_Claimed[UnitGUID(unit)];
		if ( f.data["CD"][data] ) then
			self:AddLine("|cffff0000"..f.data["CD"][data][1]);
			if ( f.data["CD"][data][2] ) then
				self:AddTexture(f.data["CD"][data][2]);
			end;
		end;
	end;
	
end;
local function HookChatHyperLink(Self, Link, Text)
	if ( TenTonHammer_Settings["chat"] == 0 ) then return false; end;
	local Data = {};
	local PlayerRealm = "";
	for v in string.gmatch(Link, "[^:]+") do tinsert(Data, v); end
	if ( Data[1] == "player" ) then
		if ( string.find(Text, "-") )then
			PlayerRealm = string.match(Text, "-(%a+)");
		else
			PlayerRealm = f.Realm;
		end;
		if ( TenTonHammer_Database[PlayerRealm] ) and ( TenTonHammer_Database[PlayerRealm][Data[2]] ) then
			GameTooltip:SetOwner(Self, "ANCHOR_CURSOR"); 
			local PlayerData = TenTonHammer_Database[PlayerRealm][Data[2]];
			local PlayerDataArray = {};
			for v in string.gmatch(PlayerData, "[^:]+") do tinsert(PlayerDataArray, v); end
			local TimeStamp, GearScore, RaidScore, PVEScore, PVPScore, ThumbsUp, ThumbsDown = PlayerDataArray[1], PlayerDataArray[2], PlayerDataArray[3], PlayerDataArray[4], PlayerDataArray[5], PlayerDataArray[6], PlayerDataArray[7];
			local r,g,b,hex = f:GetColor(GearScore);
			local Online = "";
			if ( PlayerDataArray[9] == "1" ) then	Online = " (Online Database) ";	end;
			GameTooltip:AddLine("|cffffffff"..Data[2]);
			GameTooltip:AddDoubleLine(hex.."GearScore: ", hex..GearScore);
	
			r,g,b,hex = f:GetColor(RaidScore);
			GameTooltip:AddDoubleLine(hex..L["Raid"]..":", hex..RaidScore);
			r,g,b,hex = f:GetColor(PVEScore);
			GameTooltip:AddDoubleLine(hex..L["PvE"]..":", hex..PVEScore);
			r,g,b,hex = f:GetColor(PVPScore);
			GameTooltip:AddDoubleLine(hex..L["PvP"]..":", hex..PVPScore);
			
			
			GameTooltip:AddDoubleLine(L["Player Rating"]..":", "|cff00ff00+"..ThumbsUp.." |r/ |cffff0000-"..ThumbsDown); 
			
			local NoWDate, DateRed, DateGreen, DateBlue = f:GetAge(TimeStamp);
			hex = f:GetHexColor(DateRed, DateGreen, DateBlue);
			GameTooltip:AddLine(hex..NoWDate..Online);		
			GameTooltip:AddLine("|cffff0000"..L["Ctrl-Right Click to view this player's scores online."]);
			GameTooltip:Show();
		else
			GameTooltip:SetOwner(Self, "ANCHOR_CURSOR");
			GameTooltip:AddLine("|cffffffff"..Data[2]);
			GameTooltip:AddLine(L["No PlayerScore information found for this player."]);
			GameTooltip:AddLine("|cffff0000"..L["Ctrl-Right Click to view this player's scores online."]);
			GameTooltip:Show();
		end;
	end;
end;
local function HookChatHyperLinkClick(self, link, text, button)
	if ( button == "RightButton" ) and ( IsControlKeyDown() ) then
		local Data = {};
		for v in string.gmatch(link, "[^:]+") do tinsert(Data, v); end
		local PlayerRealm, PlayerName;
		if ( string.find(text, "-") )then
			PlayerRealm = string.match(text, "-(%a+)");
			PlayerName = string.match(text, "(%a+)-");
		else
			PlayerRealm = f.Realm;
			PlayerName = Data[2];
		end;
		local url = "http://www.tentonhammer.com/playerscore/character/"..PlayerName.."/"..(PlayerRealm or f.Realm).."/"..f.Region;
		TenTonHammer_PopupFrame:Popup(url);
	elseif ( button == "RightButton" ) and ( IsShiftKeyDown() ) then
		 
	else
		ChatFrame_OnHyperlinkShow(self, link, text, button);
	end;
end;
local function GetLowest(a, b)
	if ( a > b ) then 
		return b;
	else
		return a;
	end;
end;
local function HookItemTooltip(self)
	if ( f.PlayerInfo ) then
		local ItemName, ItemLink = self:GetItem();
		local ItemScore, IncorrectItem, hex = f:GetItemScore(ItemLink, f.PlayerInfo["PlayerRole"], f.PlayerInfo["CLASS"], {});
		local AltItemScore, AltIncorrectItem, Althex = f:GetItemScore(ItemLink, f.PlayerInfo["AltPlayerRole"], f.PlayerInfo["CLASS"], {});
		local NegativeItem, AltNegativeItem = false, false;
		--array.printAll(IncorrectItem);
		for i,v in pairs(IncorrectItem) do
			if ( v ) and ( i ~= "PvP" ) then NegativeItem = true; end;
		end;
		for i,v in pairs(AltIncorrectItem) do
			if ( v ) and ( i ~= "PvP" ) then AltNegativeItem = true; end;
		end;		
		if ( ItemScore ) then
			local GemCount, Gems, MissingGemCount, MissingGems = f:GetGemInfo(ItemLink);
			local EnchantInfo = f:GetEnchantInfo(ItemLink);
			
			local ClassColor = RAID_CLASS_COLORS[f.PlayerInfo["CLASS"]];
			ClassColor = f:GetHexColor(ClassColor["r"], ClassColor["g"], ClassColor["b"]);
			
			if ( EnchantInfo ) then 
				ItemScore = ItemScore * 1.03; 
				AltItemScore = AltItemScore * 1.03;
			end;
			
			ItemScore = floor(ItemScore * ( 1 - ( .02 * MissingGemCount ) ));
			AltItemScore = floor(AltItemScore *  ( 1 - ( .02 * MissingGemCount ) ));
						
			if ( TenTonHammer_Settings["showOffSpec"] == 1 ) then
				if ( ItemScore >= AltItemScore ) then
					self:AddDoubleLine(hex.."GearScore (Main-Spec)"..": "..ItemScore, ClassColor.."( "..( f.PlayerInfo["SpecName"] or "").." "..f.PlayerInfo["ClassLocale"].." )");
					if ( NegativeItem ) then self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-NotReady"); else self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready"); end;
					if ( f.PlayerInfo["AltSpecName"] ) then self:AddDoubleLine(Althex.."GearScore (Off-Spec)"..": "..AltItemScore, ClassColor.."( "..( f.PlayerInfo["AltSpecName"] or "").." "..f.PlayerInfo["ClassLocale"].." )"); end;
					if ( AltNegativeItem ) then self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-NotReady"); else self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready"); end;
				else
					if ( f.PlayerInfo["AltSpecName"] ) then self:AddDoubleLine(Althex.."GearScore (Off-Spec)"..": "..AltItemScore, ClassColor.."( "..( f.PlayerInfo["AltSpecName"] or "").." "..f.PlayerInfo["ClassLocale"].." )"); end;
					if ( AltNegativeItem ) then self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-NotReady"); else self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready"); end;
					self:AddDoubleLine(hex.."GearScore  (Main-Spec)"..": "..ItemScore, ClassColor.."( "..( f.PlayerInfo["SpecName"] or "").." "..f.PlayerInfo["ClassLocale"].." )");
					if ( NegativeItem ) then self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-NotReady"); else self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready"); end;
				end;
			else
				self:AddDoubleLine(hex.."GearScore"..": "..ItemScore, ClassColor.."( "..( f.PlayerInfo["SpecName"] or "").." "..f.PlayerInfo["ClassLocale"].." )");
				if ( NegativeItem ) then self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-NotReady"); else self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready"); end;
			end;
			
			
			if ( ( LootFrame and LootFrame:IsVisible() ) and ( LootFrame:IsMouseOver() ) ) or ( ( GroupLootFrame1 ) and ( GroupLootFrame1:IsMouseOver() ) ) or ( ( GroupLootFrame2 ) and ( GroupLootFrame2:IsMouseOver() ) ) or ( ( GroupLootFrame3 ) and ( GroupLootFrame3:IsMouseOver() ) ) and ( TenTonHammer_Settings["masterloot"] == 1 ) then
				self:AddLine(" ");
				self:AddLine(L["Estimated GearScore Upgrades:"]);
				local ItemName, ItemLink, ItemRarity, ItemLevel, ItemReqLevel, ItemClass, ItemSubClass, ItemMaxStack, ItemEquipSlot = GetItemInfo(ItemLink);
				local Results = {};
				local ItemSlot = f.data.ItemTypes[ItemEquipSlot]["ItemSlot"];
				local Enchantable = f.data.ItemTypes[ItemEquipSlot]["Enchantable"];
				
				for PlayerName,PlayerData in pairs(f.PartyData) do
					local Difference, Percentage = 0, 0;
					local PlayerScore = 0;
					local ModifiedItemScore = f:GetItemScore(ItemLink, PlayerData["PlayerRole"], PlayerData["Class"], {});
					if ( Enchantable == 1 ) then ModifiedItemScore = floor(ModifiedItemScore * 1.03); end;
					
					if ( ItemSlot ~= -1 ) and ( ItemSlot < 20 ) then
						
						PlayerScore = PlayerData[ItemSlot] or 0;
						Difference = ModifiedItemScore - PlayerScore
						
						if ( PlayerData[17] == 0 ) then
							PlayerScore = 0;
							Difference = 0;
						end;
						
					elseif ( ItemSlot > 20 ) then
						ItemSlot = ItemSlot - 20;
						PlayerScore = GetLowest(PlayerData[ItemSlot], PlayerData[ItemSlot + 1]);
						Difference = ModifiedItemScore - PlayerScore;
					elseif ( ItemSlot == -1 ) then
						
					end;
			
					if ( PlayerScore > 0 ) then
						Percentage = floor(1e4 * Difference / (PlayerData["GearScore"] or 0)) / 100;
					else
						Percentage = 100;
					end;
					tinsert(Results, { PlayerName, Difference, Percentage, PlayerData["Color"] });
				end;
				table.sort(Results, function(a,b) return a[3]>b[3] end);
				for i,v in pairs(Results) do
					if ( i > 5 ) then break; end;
					local Color = "|cffff0000";
					local ClassColor = Results[i][4] or "";
					local Positive = "";
					if ( Results[i][2] > 0 ) then
						Positive = "+";
						Color = "|cff00ff00";
					end;
					self:AddDoubleLine(ClassColor..Results[i][1], Color..Positive..floor(Results[i][2]).." ("..Results[i][3].."%)");
				end;
			end;
			local ItemName, ItemLink, ItemRarity, ItemLevel, ItemReqLevel, ItemClass, ItemSubClass, ItemMaxStack, ItemEquipSlot = GetItemInfo(ItemLink);
			if ( f.data.ItemTypes[ItemEquipSlot]["Enchantable"] ~= 0) then 
				local EnchantInfo = f:GetEnchantInfo(ItemLink);
				if ( EnchantInfo ) then
					self:AddDoubleLine("|cff00FF00"..L["Enchanted"], "|cff00FF00"..(EnchantInfo or ""));
					self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready");
				elseif not ( EnchantInfo ) and ( f.data.ItemTypes[ItemEquipSlot]["Enchantable"] == 1) then
					self:AddLine("|cffFF0000"..L["Unenchanted"]);
					self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-NotReady");
				end;
			end;
			-- Reforge Check --
			local forgedBonuses = f:CheckReforge(ItemLink);
			local reforgeNegative = "";
			for i,v in pairs(forgedBonuses) do
				if ( v < 0 ) then
					reforgeNegative = v.." "..(L[i] or i);
					--self:AddLine("|cffFF0000     "..v.." "..(L[i] or i));
				end;
			end;
			for i,v in pairs(forgedBonuses) do
				if ( v > 0 ) then
					self:AddDoubleLine("|cff00FF00"..L["Reforged"], "|cff00FF00+"..v.." "..(L[i] or i).."|cffFFFFFF / |cffFF0000"..reforgeNegative);
					self:AddTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready");
					--self:AddLine("|cff00FF00     +"..v.." "..(L[i] or i));
					break;
				end;
			end;
					
		end;
	else 
		f:GetPlayerInfo();
	end;
end;

function f:CheckReforge(ItemLink)
	local currentBonuses = f:ScanItem(ItemLink);
	local bonuses = {};
	local ItemSubStringTable = {};
	local found, _, ItemSubString = string.find(ItemLink, "^|c%x+|H(.+)|h%[.*%]")
	for v in string.gmatch(ItemSubString, "[^:]+") do tinsert(ItemSubStringTable, v); end
	ItemSubStringTable[10] = 0;
	ItemSubStringTable[11] = 0;
	local baseItem = strjoin(":", unpack(ItemSubStringTable));
	--local baseItem = "|Hitem:"..ItemSubStringTable[2]..":"..ItemSubStringTable[3]..;
	local ItemName, ItemLink, ItemQuality, ItemLevel, ItemReqLevel, ItemClass, ItemSubclass, ItemMaxStack, ItemEquipSlot, ItemTexture, ItemVendorPrice = GetItemInfo(baseItem);
	local originalBonuses = f:ScanItem(ItemLink);
	for i,v in pairs(currentBonuses) do
		bonuses[i] = tonumber(v) - tonumber(originalBonuses[i] or 0);
		if ( bonuses[i] == 0 ) then bonuses[i] = nil; end;
	end;
	return bonuses;
end;

function f:GetPlayerInfo()
	local GearScore, PVEScore, PVPScore, RaidScore, SpecID, SpecName, PlayerRole, ThumbsUp, ThumbsDown, AltSpecID, AltSpecName, PreviousVote;
	local ClassLocale, Class = UnitClass("player");
	local PlayerLevel = UnitLevel("player");
	local PlayerName = UnitName("player");
	if( AchievementFrameComparison ) then AchievementFrameComparison:UnregisterEvent("INSPECT_ACHIEVEMENT_READY"); end;
	SetAchievementComparisonUnit("player");
	PVEScore = f:GetPVEScore();
	RaidScore = f:GetRaidScore();
	PVPScore = f:GetPVPScore();
	GearScore = 0;
	local WeaponValue = 0;
	local WeaponScore = 0;
	local ActiveTalentGroup = GetActiveTalentGroup();
	local PassiveTalentGroup = 1;
	if ( ActiveTalentGroup == 1 ) then PassiveTalentGroup = 2; end;
	for i = 1, GetNumTalentTabs(false) do
		local TabID, TabName, TabDescription, TabIcon, TabPoints, TabBackground, TabPreviewPoints, TabIsUnlocked = GetTalentTabInfo(i, false, false, ActiveTalentGroup);
		if (TabPoints >= 31) or (( PlayerLevel < 71 ) and ( TabPoints > 0 ))  then
			SpecID = TabID;
			SpecName = TabName;
		end;
	end;
	for i = 1, GetNumTalentTabs(false) do
		local TabID, TabName, TabDescription, TabIcon, TabPoints, TabBackground, TabPreviewPoints, TabIsUnlocked = GetTalentTabInfo(i, false, false, PassiveTalentGroup);
		if (TabPoints >= 31) or (( PlayerLevel < 71 ) and ( TabPoints > 0 ))  then
			AltSpecID = TabID;
			AltSpecName = TabName;
		end;		
	end;
	local PlayerRole = f.data.ClassRoles[Class][SpecID] or 0;
	local AltPlayerRole = f.data.ClassRoles[Class][AltSpecID] or 0;
	local AverageItemLevel = 0;
	local ItemCount = 0;
	local IncorrectItems = {};
	local Order = {1,2,3,15,5,9,10,6,7,8,11,12,13,14,16,17,18};
	for i = 1,17 do
		local index = Order[i];
		local ItemLink = GetInventoryItemLink("player", index);
		if ( ItemLink ) then
			local ItemName, ItemLink2, ItemQuality, ItemLevel, ItemReqLevel, ItemClass, ItemSubclass, ItemMaxStack, ItemEquipSlot, ItemTexture, ItemVendorPrice = GetItemInfo(ItemLink);
								
			if ( ItemQuality == 7 ) then
				ItemLevel = 187;
				ItemRarity = 3;
			end
			local GemCount, Gems, MissingGemCount, MissingGems = f:GetGemInfo(ItemLink);
			local ItemScore, IncorrectItems, ItemColor = f:GetItemScore(ItemLink, PlayerRole, Class);
			if not ( ItemScore ) then ItemScore = 0; end;
			if ( f.data.ItemTypes[ItemEquipSlot] ) and ( f.data.ItemTypes[ItemEquipSlot]["Enchantable"] ~= 0) then 
				local EnchantInfo = f:GetEnchantInfo(ItemLink);
				if ( EnchantInfo ) then
					ItemScore = ItemScore * 1.03;
				end;
			end;
			if ( ItemEquipSlot == "INVTYPE_WAIST" ) then
				if ( f:GetBeltBuckle(ItemLink, GemCount) ) then
					ItemScore = ItemScore * 1.03;
				end;
			end;
			ItemScore = ItemScore * ( 1 - ( .02 * MissingGemCount ) );
			ItemScore = floor(ItemScore);
			if ( f.data.ItemTypes[ItemEquipSlot]["Weapon"] > 0 ) then
				WeaponValue = WeaponValue + f.data.ItemTypes[ItemEquipSlot]["Weapon"];
				WeaponScore = WeaponScore + ItemScore;
				ItemCount = ItemCount + f.data.ItemTypes[ItemEquipSlot]["Weapon"];
				AverageItemLevel = AverageItemLevel + ( ItemLevel * f.data.ItemTypes[ItemEquipSlot]["Weapon"] );
			else
				AverageItemLevel = AverageItemLevel + ItemLevel;
				ItemCount = ItemCount + 1;
			end;
			GearScore = GearScore + ItemScore;
		end;
	end;
	if ( WeaponValue > 2 ) then
		GearScore = GearScore - floor(WeaponScore - ( 2 * WeaponScore / WeaponValue ));
	end;
	AverageItemLevel = AverageItemLevel / 17;
	ThumbsUp, ThumbsDown = 0,0;
	if ( TenTonHammer_Database[f.Realm][PlayerName] ) then
		local PlayerData = TenTonHammer_Database[f.Realm][PlayerName];
		local PlayerDataArray = {};
		for v in string.gmatch(PlayerData, "[^:]+") do tinsert(PlayerDataArray, v); end;
		ThumbsUp = PlayerDataArray[6];
		ThumbsDown = PlayerDataArray[7];
		PreviousVote = PlayerDataArray[8];
	end;
	f.PlayerInfo = { 
		["SpecID"] = SpecID,
		["AltSpecID"] = AltSpecID,
		["AltSpecName"] = AltSpecName,
		["SpecName"] = SpecName,
		["PlayerRole"] = PlayerRole,
		["AltPlayerRole"] = AltPlayerRole,
		["CLASS"] = Class,
		["ClassLocale"] = ClassLocale,
		["GearScore"] = GearScore,
		["PVPScore"] = PVPScore,
		["PVEScore"] = PVEScore,
		["RaidScore"] = RaidScore,
		["ThumbsUp"] = ThumbsUp,
		["ThumbsDown"] =ThumbsDown,
	};
	local TimeStamp = f:GetTimeStamp();
	local DatabaseConstruct = strjoin(":", TimeStamp, GearScore, RaidScore, PVEScore, PVPScore, ThumbsUp or 0, ThumbsDown or 0, PreviousVote or 0, 0 );
	if not ( TenTonHammer_Database[f.Realm] ) then TenTonHammer_Database[f.Realm] = {}; end;
	TenTonHammer_Database[f.Realm][PlayerName] = DatabaseConstruct;

end;
function f:GenerateNews()
	local self = _G[fName.."_Frame9"];
	local name = self:GetName();
	if not ( TenTonHammer_News ) or ( #TenTonHammer_News == 0 ) then 
		local Text = self:CreateFontString(name.."_NoNews", nil, "GameFontNormal");
		Text:SetWidth(585);
		Text:SetPoint("TOPLEFT", self, 20, -20);
		Text:SetJustifyH("CENTER");
		Text:SetText(L["To view News in game, you must use the PlayerScore Updater. Get the Updater at www.PlayerScore.com!"]);
		
		return; 
	end;
	local Text = self:CreateFontString(name.."_Heading", nil, "GameFontNormal")
	Text:SetPoint("TOPLEFT", self, 20, -20);
	Text:SetWidth(595);
	Text:SetFont("Fonts\\FRIZQT__.TTF", 15);
	Text:SetText(L["Latest news from TenTonHammer.com. Click a title for the whole article."]);
	Text:SetTextColor(1,0,0,1);
	local HoverFunc = function(self)
		self:SetColor(1,0,0,1);
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
		GameTooltip:AddLine(L["Click here for URL to full story."], nil, nil, nil, nil, true);
		GameTooltip:Show();
	end;
	local ExitFunc = function(self)
		self:SetColor(0,.5, 1, 1);
		GameTooltip:Hide();
	end;
	local ClickFunc = function(self)
		if ( self.url ) then TenTonHammer_PopupFrame:Popup(self.url.."?utm_source=playerscore&utm_medium=newsfeed&utm_campaign=addon"); end;
	end;
	for i = 1, 7 do
		local Title = CreateFrame("Frame", name.."_Title"..i, self, "TenTonHammer_Info");
		Title:SetPoint("TOPLEFT", self, 20, (i-1) * -55 - 40);
		Title:SetWidth(595);
		Title:SetFont("Fonts\\FRIZQT__.TTF", 16);
		Title:SetColor(0,.5, 1, 1);
		Title:SetScript("OnEnter", HoverFunc);
		Title:SetScript("OnLeave", ExitFunc);
		Title:SetScript("OnMouseUp", ClickFunc);
		local Info = CreateFrame("Frame", name.."_Info"..i, self, "TenTonHammer_Info");
		Info:SetPoint("TOPLEFT", self, 20, (i-1) * -55 - 54);
		Info:SetWidth(595);
		Info:SetFont("Fonts\\FRIZQT__.TTF", 10);
		local Summary = self:CreateFontString(name.."_Answer"..i, nil, "GameFontNormal")
		Summary:SetPoint("TOPLEFT", self, 20, (i-1) * -55 - 66);
		Summary:SetWidth(595);
		Summary:SetWordWrap(true);
		Summary:SetJustifyH("LEFT");
		Summary:SetJustifyV("TOP");
		Summary:SetHeight(30);
		Summary:SetFont("Fonts\\FRIZQT__.TTF", 12);
	end;
	for index,news in ipairs(TenTonHammer_News) do
		if ( index == 8 ) then break; end;
		local NewsTable = {};
		for v in string.gmatch(news, "[^|]+") do tinsert(NewsTable, v); end
		_G[name.."_Title"..index]:SetText(NewsTable[1]);
		_G[name.."_Title"..index].url = NewsTable[4];
		local age = string.replace(f:GetAge(NewsTable[2]), "Scanned ", "");
		_G[name.."_Info"..index]:SetText("|cffcccccc"..string.format(L["Posted %s by"], age).." |cffff0000"..NewsTable[3]);
		_G[name.."_Answer"..index]:SetText("|cffffffff"..NewsTable[5]);
	end;
end;
function f:GenerateHelp()
	local self = _G[fName.."_Frame7"];
	local name = self:GetName();
	local Text = CreateFrame("Frame", name.."_Question1", self, "TenTonHammer_Info")
	Text:SetPoint("TOPLEFT", self, 35, (2) * -13 - 5);
	Text:SetText(" - "..L["Questions"].." - ");
	Text:SetWidth(230);
	Text:SetColor(1,1,1,1);
	Text:Center();
	for i,v in ipairs(f.Help["Questions"]) do
		local Text = CreateFrame("Frame", name.."_Question"..i + 1, self, "TenTonHammer_Info")
		Text:SetPoint("TOPLEFT", self, 35, (i + 2) * -13 - 5);
		Text:SetText(i..". "..v, "");
		Text.Data = v;
		Text:SetColor(0,1,0,1);
		Text:SetScript("OnEnter", function(...)
			Text:SetColor(.5,.5,1,1);
		end);
		Text:SetScript("OnLeave", function(...)
			Text:SetColor(0,1,0,1);
		end);
		Text:SetScript("OnMouseUp", function(...)
			_G[name.."_AnswerTitle"]:SetText(" - "..Text.Data.." - ");
			_G[name.."_AnswerTitle"]:Center();
			_G[name.."_Answer"]:SetText(f.Help["Answers"][Text.Data]);
		end);
	end;
	
	local Text = CreateFrame("Frame", name.."_AnswerTitle", self, "TenTonHammer_Info")
	Text:SetPoint("TOPLEFT", self, 265, (1 + 1) * -13 - 5);
	Text:SetWidth(335);
	Text:SetText(" - "..L["Introduction"].." - ", "");
	Text:SetColor(1,1,1,1);
	Text:Center();
	Text = self:CreateFontString(name.."_Answer", nil, "GameFontNormal")
	Text:SetPoint("TOPLEFT", self, 265, (3 + 1) * -13 - 5);
	Text:SetWidth(335);
	Text:SetWordWrap(true);
	Text:SetJustifyH("LEFT");
	Text:SetText(f.Help["Answers"][L["Introduction"]]);
end;
function f:GetTimeStamp()
	local Hour, Minute = GetGameTime();
	local null, Month, Day, Year = CalendarGetDate();
	local TimeStamp = (Year * 1e8) + (Month * 1e6) + (Day * 1e4) + (Hour * 100) + (Minute);
	return TimeStamp;
end
function f:ProcessOnlineData()
	local Count = 0;
	for i,v in pairs(TenTonHammer_OnlineDatabase[f.Realm]) do
		if ( TenTonHammer_Database[f.Realm][i] ) then
			local a = TenTonHammer_Database[f.Realm][i];
			if ( tonumber(string.sub(a, 0, 12)) < tonumber(string.sub(v, 0, 12))  ) then
				TenTonHammer_Database[f.Realm][i] = v .. string.sub(a, -4, -3) .. ":1";
				TenTonHammer_Database[f.Realm][i] = "201012291045" .. string.sub(v, 13) .. string.sub(a, -4, -3) .. ":1";
				Count = Count + 1;
			end;
		else
			TenTonHammer_Database[f.Realm][i] = v .. ":0:1";
			Count = Count+1;
		end;
	end;
	TenTonHammer_OnlineDatabase[f.Realm] = nil;
	print ("|cffff0000PlayerScore: |r"..string.format(L["%d database entries imported from PlayerScore.com."], Count));
	collectgarbage("collect");
end;
function f:UpdateStats()
	
end;
function f:ScanEntireParty()
	
	local Group = "party";
	local MaxGroup = GetNumPartyMembers();
	local DisplayGroup = 0;
	if ( GetNumRaidMembers() > 0 ) then
		Group = "raid";
		MaxGroup = GetNumRaidMembers();
	end;
	DisplayGroup = MaxGroup;
	if ( Group == "party" ) then
		DisplayGroup = DisplayGroup + 1;
	end;
	
	for i = 1, MaxGroup do
		if ( CanInspect(Group..i) ) then
			tinsert(f.ScanQue, function(...)
				table.remove(f.ScanQue, 1);
				
				_G[fName.."_Frame8_Data"..i+1]:SetText("|cffffffff"..L["Scanning..."]);
				f:Scan(Group..i, false, true);
			end);
		else
			tinsert(f.ScanQue, function(...)
				table.remove(f.ScanQue, 1);
				
				_G[fName.."_Frame8_Data"..i+1]:SetText("|cffffffff"..L["Scanning..."]);
				print(string.format(L["%s is out of inspection range."], UnitName(Group..i)));
				if ( f.ScanQue ) and ( f.ScanQue[1] ) then 
					f.ScanQue[1](); 
				end;
			end);			
		end;
	end;
	if ( Group == "party" ) then
		tinsert(f.ScanQue, function(...)
			table.remove(f.ScanQue, 1);
			_G[fName.."_Frame8_Data"..MaxGroup+2]:SetText("|cffffffff"..L["Scanning..."]);
			
			f:Scan("player", false, true);
		end);
	end;
	tinsert(f.ScanQue, function(...)
		f:SwitchTabs(8);
		_G[fName.."_WaitFrame"]:Hide();
	end);
	if ( f.ScanQue[1] ) then 
		f:Show();
		f:SwitchTabs(8);
		f.ScanQue[1]();
	end;
end;
function translateAch(val)
	if(val==nil)or(val=="--")then
		val=0;
	else
		if(string.find(val,"/"))then
			return 0;
		end
		val=tonumber(val);
	end
	return val;
end
function tGCS(n1) 
	return GetComparisonStatistic(n1 or 0) or 0;
end
function f:GetRaidScore()
local tscore = 0;
--if ( tscore == 0 ) then return 0; end; --Debug Code ONly
local ttscore = 0;
local TTHFLAGS = {};
local TTHPREFS = {};
local playerserver = f.Realm
local tempname = "";
TTHFLAGS[playerserver] = {};
TTHFLAGS[playerserver][tempname] = {};
TTHPREFS["SVD"] = 1;
TTHPREFS["DFT"] = 1;
local TTHRATE = {};
TTHRATE[playerserver] = {};
for i,v in pairs(LK_DUNGEONS["5 Man"]["T7"]["N"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>5)then
    tscore=tscore+12.5;
    a1=a1-5;
    tscore=tscore+(a1*.625);
   else
    tscore=tscore+(a1*2.5);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["5 Man"]["T7"]["S"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>5)then
    tscore=tscore+20;
    a1=a1-5;
    tscore=tscore+(a1);
   else
    tscore=tscore+(a1*4);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["5 Man"]["T7"]["T"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>5)then
    tscore=tscore+30;
    a1=a1-5;
    tscore=tscore+(a1*1.5);
   else
    tscore=tscore+(a1*6);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["5 Man"]["T9"]["N"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>5)then
    tscore=tscore+35;
    a1=a1-5;
    tscore=tscore+(a1*1.25);
   else
    tscore=tscore+(a1*7);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["5 Man"]["T9"]["S"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>5)then
    tscore=tscore+50;
    a1=a1-5;
    tscore=tscore+(a1*1.75);
   else
    tscore=tscore+(a1*10);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["5 Man"]["T10"]["N"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>5)then
    tscore=tscore+55;
    a1=a1-5;
    tscore=tscore+(a1*1.75);
   else
    tscore=tscore+(a1*11);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["5 Man"]["T10"]["S"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>5)then
    tscore=tscore+75;
    a1=a1-5;
    tscore=tscore+(a1*2.75);
   else
    tscore=tscore+(a1*15);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["5 Man"]["T10"]["T"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>5)then
    tscore=tscore+100;
    a1=a1-5;
    tscore=tscore+(a1*3.75);
   else
    tscore=tscore+(a1*20);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 if(TTHPREFS["DFT"]==1)then
  tscore=ceil(tscore*5);
  if(tscore>6e3)then
   a1=tscore-6e3;
   tscore=ceil(6e3+(a1/3));
  end
  if(tscore>0)then
   if(TTHRATE[playerserver][tempname]==nil)then
    TTHRATE[playerserver][tempname]={};
   end
   TTHRATE[playerserver][tempname]["5M"]=tscore;
   
  end
 end
 tscore=0;
 for i,v in pairs(LK_DUNGEONS["10 Man"]["N"]["N"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+15;
    a1=a1-3;
    tscore=tscore+(a1*1.25);
   else
    tscore=tscore+(a1*5);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["10 Man"]["N"]["S"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+30;
    a1=a1-3;
    tscore=tscore+(a1*2.5);
   else
    tscore=tscore+(a1*10);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["10 Man"]["N"]["T"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+49;
    a1=a1-3;
    tscore=tscore+(a1*4.25);
   else
    tscore=tscore+(a1*17);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 if(TTHPREFS["DFT"]==1)then
  tscore=ceil(tscore*5);
  if(tscore>6e3)then
   a1=tscore-6e3;
   tscore=ceil(6e3+(a1/3));
  end
  if(tscore>0)then
   if(TTHRATE[playerserver][tempname]==nil)then
    TTHRATE[playerserver][tempname]={};
   end
   TTHRATE[playerserver][tempname]["10M"]=tscore;
   ttscore=ttscore+(tscore*1.2);
  end
 end
 tscore=0;
 for i,v in pairs(LK_DUNGEONS["10 Man"]["H"]["N"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+15;
    a1=a1-3;
    tscore=tscore+(a1*1.25);
   else
    tscore=tscore+(a1*5);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["10 Man"]["H"]["S"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+30;
    a1=a1-3;
    tscore=tscore+(a1*2.5);
   else
    tscore=tscore+(a1*10);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["10 Man"]["H"]["T"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+49;
    a1=a1-3;
    tscore=tscore+(a1*4.25);
   else
    tscore=tscore+(a1*17);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 if(TTHPREFS["DFT"]==1)then
  tscore=ceil(tscore*5);
  if(tscore>6e3)then
   a1=tscore-6e3;
   tscore=ceil(6e3+(a1/3));
  end
  if(tscore>0)then
   if(TTHRATE[playerserver][tempname]==nil)then
    TTHRATE[playerserver][tempname]={};
   end
   TTHRATE[playerserver][tempname]["10MH"]=tscore;
   ttscore=ttscore+(tscore*3.5);
  end
 end
 tscore=0;
 for i,v in pairs(LK_DUNGEONS["25 Man"]["N"]["N"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+15;
    a1=a1-3;
    tscore=tscore+(a1*1.25);
   else
    tscore=tscore+(a1*5);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["25 Man"]["N"]["S"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+30;
    a1=a1-3;
    tscore=tscore+(a1*2.5);
   else
    tscore=tscore+(a1*10);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["25 Man"]["N"]["T"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+49;
    a1=a1-3;
    tscore=tscore+(a1*4.25);
   else
    tscore=tscore+(a1*17);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 if(TTHPREFS["DFT"]==1)then
  tscore=ceil(tscore*5);
  if(tscore>6e3)then
   a1=tscore-6e3;
   tscore=ceil(6e3+(a1/3));
  end
  if(tscore>0)then
   if(TTHRATE[playerserver][tempname]==nil)then
    TTHRATE[playerserver][tempname]={};
   end
   TTHRATE[playerserver][tempname]["25M"]=tscore;
   ttscore=ttscore+(tscore*2.4);
  end
 end
 tscore=0;
 for i,v in pairs(LK_DUNGEONS["25 Man"]["H"]["N"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+15;
    a1=a1-3;
    tscore=tscore+(a1*1.25);
   else
    tscore=tscore+(a1*5);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["25 Man"]["H"]["S"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+30;
    a1=a1-3;
    tscore=tscore+(a1*2.5);
   else
    tscore=tscore+(a1*10);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 for i,v in pairs(LK_DUNGEONS["25 Man"]["H"]["T"])do
  a1=translateAch(tGCS(v));
  if(a1>0)then
   if(a1>3)then
    tscore=tscore+49;
    a1=a1-3;
    tscore=tscore+(a1*4.25);
   else
    tscore=tscore+(a1*17);
   end
   if(TTHPREFS["SVD"]==1)then
    TTHFLAGS[playerserver][tempname][i]=a1;
   end
  end
 end
 if(TTHPREFS["DFT"]==1)then
  tscore=ceil(tscore*5);
  if(tscore>6e3)then
   a1=tscore-6e3;
   tscore=ceil(6e3+(a1/3));
  end
  if(tscore>0)then
   if(TTHRATE[playerserver][tempname]==nil)then
    TTHRATE[playerserver][tempname]={};
   end
   TTHRATE[playerserver][tempname]["25MH"]=tscore;
  end
  ttscore=ttscore+(tscore*7);
  ttscore=ceil(ttscore/8);
  if(ttscore>6e3)then
   a1=ttscore-6e3;
   ttscore=ceil(6e3+(a1/3));
  end
  if(ttscore>0)then
   TTHRATE[playerserver][tempname]["RDS"]=ttscore;
   tne,tsv=UnitName("target");
   if(tne~=nil)then
    if(tne~=tempname)then
     doac=false;
    end
    if(tsv==nil)then
     tsv=playerserver;
    end
   else
    doac=false;
   end
   if(doac==true)then
    ToLog("[50]17,72,224|"..tempname..","..tsv..",YmmY|226|"..ttscore);
   end
  end
 end
return ttscore
end;
function f:GetPVEScore()
local a1;
local achscore = 0;
a1=translateAch(tGCS(98)); 
 if(a1>1200)then
  achscore=achscore+1200;
  a1=a1-1200;
  achscore=achscore+(a1*.3);
 else
  achscore=achscore+(a1*1.2);
 end
 a1=translateAch(tGCS(97)); 
 achscore=achscore+(a1*.02);
 a1=translateAch(tGCS(377)); 
 achscore=achscore+(a1*50);
 a1=translateAch(tGCS(1103)); 
 achscore=achscore+(a1*5);
 a1=translateAch(tGCS(1104)); 
 achscore=achscore+(a1*10);
 a1=translateAch(tGCS(1768)); 
 achscore=achscore+(a1*12);
 a1=translateAch(tGCS(1485)); 
 if(a1>50)then
  temp9=(a1-50);
  achscore=achscore+250;
  achscore=achscore+temp9;
 else
  achscore=achscore+(a1*5);
 end
 a1=translateAch(tGCS(1771));
 if(a1>50)then
  temp9=(a1-50);
  achscore=achscore+300;
  achscore=achscore+(temp9*1.15);
 else
  achscore=achscore+(a1*6);
 end
 a1=translateAch(tGCS(1759));
 if(a1>50)then
  temp9=(a1-50);
  achscore=achscore+350;
  achscore=achscore+(temp9*1.3);
 else
  achscore=achscore+(a1*7);
 end
 a1=translateAch(tGCS(60)); 
 achscore=ceil(achscore-(a1*.1));
 if(achscore>5e3)then
  local at=achscore-5e3;
  achscore=ceil(5e3+(at/6.5));
 end
 if(achscore<0)then
  achscore=0;
 end
 return achscore;
end;
function f:GetPVPScore()
	local a1, a2;
	local pvpscore = 0;
 a1=translateAch(tGCS(837)); 
 a2=translateAch(tGCS(838));
 if(a1>0)and(a2>0)then
  a3=(a1+1)/(a2+1);
  if(a3<.6)then
   a3=.6; 
  elseif(a3>8)then
   a3=8; 
  end
  pvpscore=pvpscore+(a3*100); 
 end
 if(a1>100)then 
  a2=a1-100;
  pvpscore=pvpscore+1800;
  pvpscore=pvpscore+(a2*5);
 else
  pvpscore=pvpscore+(a1*18); 
 end
 a1=translateAch(tGCS(840)); 
 a2=translateAch(tGCS(839)); 
 if(a1>0)and(a2>0)then
  a3=(a1+1)/(a2+1);
  if(a3<.6)then
   a3=.6;
  elseif(a3>8)then
   a3=8;
  end
  pvpscore=pvpscore+(a3*100);
 end
 if(a1>100)then
  a2=a1-100;
  pvpscore=pvpscore+1800;
  pvpscore=pvpscore+(a2*5);
 else
  pvpscore=pvpscore+(a1*18);
 end
 a1=translateAch(tGCS(588)); 
 a2=translateAch(tGCS(1501));  
 if(a1>1500)then 
  a1=a1-1500;
  pvpscore=pvpscore+750;
  pvpscore=pvpscore+(a1*.1);
 else
  pvpscore=pvpscore+(a1*.5); 
 end
 pvpscore=ceil(pvpscore-(a2*.001)); 
 if(pvpscore<1)then 
  pvpscore=0;
 end
 if(pvpscore>5e3)then 
  local at=pvpscore-5e3;
  pvpscore=ceil(5e3+(at/45));
 end
	return pvpscore;	
end;
ChatFrame1:SetScript("OnHyperlinkEnter", HookChatHyperLink);
ChatFrame1:SetScript("OnHyperlinkLeave", function(...) GameTooltip:Hide(); end);
ChatFrame1:SetScript("OnHyperlinkClick", HookChatHyperLinkClick);
GameTooltip:HookScript("OnTooltipSetItem", HookItemTooltip);
ShoppingTooltip1:HookScript("OnTooltipSetItem", HookItemTooltip);
ShoppingTooltip2:HookScript("OnTooltipSetItem", HookItemTooltip);
ItemRefTooltip:HookScript("OnTooltipSetItem", HookItemTooltip);
GameTooltip:HookScript("OnTooltipSetUnit", HookPlayerTooltip);
f:GenerateHelp();

local function CommandControl(Commands)
	if ( TenTonHammer_Settings["addonMode"] ~= -1 ) then
		if ( UnitIsPlayer("target") ) then f:Scan("target") else f:Scan("player"); end;	
	else
		print(L["Type '/psreset' to re-enable full mode. (Reloads your UI). Additional options comming soon."]);
	end;
end;

local function CommandReset()
	TenTonHammer_Settings = nil;
	--TenTonHammer_Settings["addonMode"] = 0;
	ConsoleExec("reloadui");
end;

function CommandVerify()
	TenTonHammer_PopupFrame:Popup("http://www.tentonhammer.com/playerscore/claim?data=" .. UnitName("player") ..",".. GetRealmName() ..",".. f.Region..","..PlayerGUID("player") );
	print(L["Paste this URL into your browser window to Claim/Verify your character."]);
end;

function CommandRate()
	if ( TenTonHammer_Settings["addonMode"] ~= -1 ) then
		TenTonHammer_QuickRateFrame:Show();
	end;
end;

SlashCmdList["GEARSCORE"] = CommandControl;
SLASH_GEARSCORE1 = "/gs";
SLASH_GEARSCORE2 = "/ps";
SLASH_GEARSCORE3 = "/gearscore";
SLASH_GEARSCORE4 = "/playerscore";
SlashCmdList["GS_VERIFY"] = CommandVerify;
SLASH_GS_VERIFY1 = "/verify";
SLASH_GS_VERIFY2 = "/claim";
SlashCmdList["GS_RESET"] = CommandReset;
SLASH_GS_RESET1 = "/psreset";
SlashCmdList["GS_RATE"] = CommandRate;
SLASH_GS_RATE1 = "/psrate";




GearScoreLDB = {}
function f:LDB()
	self.LDB = LibStub("LibDataBroker-1.1", true);
	if not ( self.LDB ) then return false; end;
	self.DataObj = self.LDB:NewDataObject("GearScore",
	{
		type = "launcher",
		icon = "Interface\\AddOns\\GearScore\\UI\\logo-micro",
		text = "PlayerScore",
		OnClick = function(pFrame, pButton) f:LDBOnClick(pFrame, pButton); end,
		OnTooltipShow = function(tooltip)
			TenTonHammer:GetPlayerInfo();
			local data = TenTonHammer.PlayerInfo;
			if not tooltip or not tooltip.AddLine then return end
			
			tooltip:AddLine("PlayerScore",1,1,1)
			
			local Array = {
				['GearScore'] = 'GearScore',
				['Raid'] = 'RaidScore',
				['PvE'] = 'PVEScore',
				['PvP'] = 'PVPScore',
			};
			
			for i,v in pairs(Array) do
				local r,g,b,hex = f:GetColor(data[v] or 0);
				tooltip:AddDoubleLine(hex..L[i]..":", hex..(data[v] or 0));
			end;
			
			tooltip:AddLine(" ");
			tooltip:AddLine("|cffffffffLeft-Click|r to inspect your current target.")
			tooltip:AddLine("|cffffffffRight-click|r to show PlayerScore Options.")
			tooltip:AddLine(" ")
		end,
	});
end

local pTarget
function f:LDBOnClick(pFrame, pButton)
	if ( pButton == "LeftButton" ) then
		if ( UnitName("target") ) then
			f:Scan("target");
		else
			f:Scan("player");
		end;
	else
		--GearScore_ShowOptions()
	end
end

f:LDB();




function f:RegisterTemplate(Template)
	if ( Template.Version >= f.data.TemplateVersion ) then
		f.data.TemplateList[Template.Name] = Template;
		if ( TenTonHammer_Settings["Theme"] == Template.Name ) then
			f:ActivateTemplate(Template);
		end;
	end;
end;

function f:ActivateTemplate(Template, Color)
	if not ( Template ) then return false; end;
	Color = Color or TenTonHammer_Settings["color"];
	local ColorCheck = false;
	for i,v in pairs(Template.Colors) do
		if ( Color == v ) then ColorCheck = true; end;
	end;
	if not ( ColorCheck ) then Color = Template.DefaultColor; end;
	
	local FrameArray = {
		["Main"]  = "TenTonHammer";
		["Popup"] = "TenTonHammer_PopupFrame";
		["Model"] =	"TenTonHammer_EquipmentFrame_Model";
		["Title"] = "TenTonHammer_TitleFrame";
		["Control"] = "TenTonHammer_ControlFrame";
		["Wait"] = "TenTonHammer_WaitFrame";
		["Alert"] = "TenTonHammer_PopupFrame2";
		["QuickRate"] = "TenTonHammer_QuickRateFrame";
	};
	for i,v in pairs (FrameArray) do
		local Background = {};
		local Texture = _G[v.."_MainTexture"];
		local BackgroundTarget = Template.Backgrounds[i] or Template.Backgrounds["All"];
		local EdgeTarget = Template.Edges[i] or Template.Edges["All"];
		
		if ( EdgeTarget ) then
			local ColorText = "";
			if ( Template.MultiColor ) and ( EdgeTarget["extend"] ) then ColorText = "-"..Color; end;
			Background["edgeFile"] = EdgeTarget["rootFile"]..ColorText;
			Background["edgeSize"] = EdgeTarget.edgeSize;
		end
		
		if ( BackgroundTarget ) then
			if ( BackgroundTarget.type == "File" ) then
				local ColorText = "";
				if ( Template.MultiColor ) and ( BackgroundTarget["extend"] ) then ColorText = "-"..Color; end;
				--Background["bgFile"] = BackgroundTarget["rootFile"]..ColorText;
				Texture:SetTexture( BackgroundTarget["rootFile"]..ColorText );
				Texture:SetAlpha(BackgroundTarget["alpha"] or 1);
				--Texture:Hide();
			elseif ( BackgroundTarget.type == "Color" ) then
				--_G[v]:SetBackdropColor(BackgroundTarget.color[1], BackgroundTarget.color[2], BackgroundTarget.color[3], BackgroundTarget.color[4]);
				--print(BackgroundTarget.color[1], BackgroundTarget.color[2], BackgroundTarget.color[3], BackgroundTarget.color[4]);
				Texture:SetTexture(BackgroundTarget.color[1], BackgroundTarget.color[2], BackgroundTarget.color[3], BackgroundTarget.color[4]);
				Texture:SetGradientAlpha("HORIZONTAL", 1,1,1,1,1,1,1,1);
				--Texture:SetGradientAlpha("HORIZONTAL", BackgroundTarget.color[1], BackgroundTarget.color[2], BackgroundTarget.color[3], BackgroundTarget.color[4], BackgroundTarget.color[1], BackgroundTarget.color[2], BackgroundTarget.color[3], BackgroundTarget.color[4]);
				Texture:Show();
			elseif ( BackgroundTarget.type == "Gradient" ) then
				Texture:SetTexture(BackgroundTarget.color[1], BackgroundTarget.color[2], BackgroundTarget.color[3], BackgroundTarget.color[4]);
				Texture:SetGradient(BackgroundTarget.orientation, BackgroundTarget.color[1], BackgroundTarget.color[2], BackgroundTarget.color[3], BackgroundTarget.color[4], BackgroundTarget.endColor[1], BackgroundTarget.endColor[2], BackgroundTarget.endColor[3], BackgroundTarget.endColor[4] );
				Texture:Show();
			end;
			Background["tile"] = BackgroundTarget.tile;
			Background["tileSize"] = BackgroundTarget.tileSize;
			
			if ( BackgroundTarget.insets ) then 
				local insets = BackgroundTarget.insets;
				Background["insets"] = {
					top = insets[1],
					right = insets[2],
					bottom = insets[3],
					left = insets[4],
				};
			end;
		end;
		_G[v]:SetBackdrop(Background);
	end;
	TenTonHammer_Settings["color"] = Color;
	TenTonHammer_TileFrame:SetBackdrop({ bgFile = Template.TileTexture, tile = true, tileSize = 64, insets = { top="10"} });
	TenTonHammer_MainButton:SetBackdrop({ bgFile = Template.Hammer });
	if ( Template.OnLoad ) then
		Template:OnLoad();
	end;
	if not ( Template.MultiColor ) then
		TenTonHammer_Frame6_ThemeColor:Hide();
	else
		TenTonHammer_Frame6_ThemeColor:Show();
	end;
end;

function f:CreateTemplate(Name)
	local Template = {};
	Template.Name = Name;
	Template.MultiColor = false;
	Template.Colors = { "Default" };
	Template.Version = 0;
	Template.DefaultColor = "Default";
	Template.Hammer = "Interface\\Addons\\GearScore\\UI\\logo-small";
	Template.TileTexture = "Interface\\Addons\\GearScore\\UI\\body_bg";
	Template.Edges = {
		["All"] = {
			rootFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			extend = false,
			edgeSize = 32,
			insets = { 12, 12, 11, 11, },
			tile = false;
		},
	};
	Template.Backgrounds = {
		["All"] = {
			type = "Color",
			color = { 0.2, 0.2, 0.2, 1 },
		},
		["Wait"] = {
			type = "Color",
			color = { 0.2, 0.2, 0.2, 1 },
		},
	};
	Template.OnLoad = nil;
	Template.OnUnload = nil;
	return Template;
end;

--Lets Register the Default Template
function f:BuildDefaultTemplates()
	-- Neon Template --
	local Template = f:CreateTemplate("Neon");
	Template.MultiColor = true;
	Template.Version = 10000;
	Template.Colors = { "Yellow", "Red", "Green", "Blue", "Purple" };
	Template.DefaultColor = "Yellow";
	Template.Edges = {
		["All"] = {
			rootFile = "Interface\\Addons\\GearScore\\UI\\neonborder",
			extend = true,
			edgeSize = 32,
		},
	};
	Template.Backgrounds = {
		["All"] = {
			type = "Color",
			color = { 0.1, 0.1, 0.1, .75 },
		},
		["Wait"] = {
			type = "Color",
			color = { 0.2, 0.2, 0.2, 1 },
		},
	};
	f:RegisterTemplate(Template);
	
	--GearScore Classic Template--
	Template = f:CreateTemplate("GearScore Classic");
	Template.TileTexture = nil;
	Template.Version = 10000;
	Template.Backgrounds = {
		["Main"] = {
			type = "File",
			rootFile = "Interface\\AchievementFrame\\UI-Achievement-StatsBackground",
			extend = false,
			tileSize = 32,
			insets = { 12, 12, 11, 11, },
		},
		["All"] = {
			type = "Color",
			color = { 0,0,0,0.75 };
		};
		["Wait"] = {
			type = "Color",
			color = { 0.2, 0.2, 0.2, 1 },
		},
	};	
	
	f:RegisterTemplate(Template);
end;



function f:BuildPVPTab()
	if ( TenTonHammer_Settings["PvPTab"] == 0 ) then return; end;
	local shortName = "TenTonHammer_Frame5_Info";
	local ids = {nil,839,{840, 839},nil,{49, 53},{51, 55},{5237, 5236},{50, 54},{1550, 1549},{5233, 5232},{105, 52},{4097, 4096},nil,nil,838,{837, 838},nil,{366, 367},{364, 365},{362, 363},nil,nil,320,{319, 320},	};
	for i,v in pairs(ids) do
		if ( v ) then
			if ( type(v) == "table" ) then
				local a = tonumber(GetComparisonStatistic(v[1]) or 0) or 0;
				local b = tonumber(GetComparisonStatistic(v[2]) or 0) or 0;
				local c;
				if ( v[2] == 320 ) then
					c = tonumber(GetComparisonStatistic(319) or 0) or 0;
					b = c + b;
				end;
				local percent, color;
				if ( b ~= 0 ) then
					percent = floor(100 * ( a or 0 ) / b);
					color = f:GetHexColor(f:GetColor100(percent, 0, 75))
				else
					percent = 0;
					color = f:GetHexColor(f:GetColor100(50, 0, 75));
				end;
				_G[shortName..i]:SetText(nil, "|cffFFFFFF" .. a .. color .. " ("..percent.."%)");
			else
				if ( v ~= 320 ) then
					_G[shortName..i]:SetText(nil, "|cffFFFFFF" .. (GetComparisonStatistic(v) or " "));
				else
					local a = tonumber(GetComparisonStatistic(320) or 0) or 0
					local b = tonumber(GetComparisonStatistic(319) or 0) or 0
					a = a + b;
					_G[shortName..i]:SetText(nil, "|cffFFFFFF" .. (a or " "));
				end;
			end;
		end;
	end;
end;

function string:charAt(index) -- Returns String
	index = index or 0;
	return string.sub(self, index, index);
end;

function string:charCodeAt(index) -- Returns int(number)
	index = index or 0;
	return strbyte(self:charAt(index));
end;

function string:hexLength(length)
	length = length or 0;
	results = string.format("%02x", self);
	while ( #results < length ) do
		results = "0" .. results;
	end;
	return results;
end;

function string:substr(index, len)
	index = index or 0;
	len = len or int.MAX_VALUE;
	return string.sub(self, index, index + len - 1);
end;

