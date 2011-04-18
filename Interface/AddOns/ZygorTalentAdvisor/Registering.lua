local me=ZygorTalentAdvisor

function me:RegisterBuild (class,title,build,glyphs)
	local _,_,pet,pettype = string.find(class,"(PET) (.+)")
	if pet then
		table.insert(self.registeredBuilds,{pettype=pettype,title=title,build=build})
		--self:Print("Registered pet build: "..title)
	else
		table.insert(self.registeredBuilds,{class=class,title=title,build=build,glyphs=glyphs})
		--self:Print("Registered build: "..title)
	end
end

-- remove class-specific builds or any pets for non-hunters
function me:PruneRegisteredBuilds()
	--self:Print("Pruning!")
	if self.registeredBuildsPruned then return nil end
	
	local _,myclass = UnitClass("player")
	if not myclass then return end

	for i=#self.registeredBuilds,1,-1 do
		if (self.registeredBuilds[i].class and self.registeredBuilds[i].class~=myclass)
		or (self.registeredBuilds[i].pettype and myclass~="HUNTER")
		or (string.find(self.registeredBuilds[i].title,"debug") and not self.db.profile.debug)
		then
			table.remove(self.registeredBuilds,i)
		end
	end

	for class,talents in pairs(self.TalentsToNumbers) do
		if (not talents.pet and class~=myclass)
		or (talents.pet and myclass~="HUNTER")
		then
			self.TalentsToNumbers[class]=nil
		end
	end

	if #self.registeredBuilds>0 then
		if self.db.char.currentBuildTitle then self:SetCurrentBuild(self.db.char.currentBuildTitle) end
		if self.db.char.currentPetBuildTitle then self:SetCurrentBuild(self.db.char.currentPetBuildTitle) end
	end

	self.registeredBuildsPruned = true
end

function me:ParseBlizzardTalents(bliz,pet)
	self:Debug("Parsing Blizzard build")
	local build = {}

	for tab,talent in talentpairs(false,pet) do
		if #bliz==0 then break end
		local rank = tonumber(strsub(bliz,1,1))
		bliz = strsub(bliz,2)
		for i=1,rank do table.insert(build,{tab,talent}) end
	end

	return build
end

function me:ParseTableTalents(text,pet)
	TalentFrame_LoadUI()

	self:Debug("Parsing table build, pet="..tostring(pet))

	local _,class = UnitClass("player")
	local pettype
	if pet then
		_,_,_,_,_,pettype = GetTalentTabInfo(1,false,true)  --TODO
		self:Debug("Pettype="..tostring(pettype))
		if pettype then pettype=pettype:match("HunterPet(.+)") end
		self:Debug("Pettype="..tostring(pettype))
	end

	local build = {}

	local lookup = {}
	local name,link,id
	local count=0
	for tab,talent in talentpairs(false,pet) do
		link = GetTalentLink(tab,talent,false,pet)
		if link then
			id = tonumber(link:match("talent:(%d+)"))
			lookup[id]={tab,talent}
			count=count+1
		end
		--[[
		name = GetTalentInfo(tab,talent,false,pet)
		if name then
			link = GetTalentLink(tab,talent,false,pet)
			id = tonumber(link:match("talent:(%d+)"))
			--lookup[name]={tab,talent}
			lookup[id]={tab,talent}
			count=count+1
		end
		]]
	end

	if count==0 then
		return nil,"Unable to access talent info, wtf"
	else
		self:Debug(count.." talents cached for lookup")
	end

	local a
	local spec
	for i=1,#text do
		--if TalentsToNumbers[text[i]]
		local a,b = string.match(text[i],"(.+)|(.+)")
		if not a then a=text[i] end
		a=self.TalentsToNumbers[pet and pettype or class][a]
		if b then b=self.TalentsToNumbers[pet and pettype or class][b] end

		if lookup[a] then
			table.insert(build,{lookup[a][1],lookup[a][2]})
			if i==1 then spec=lookup[a][1] end
		elseif lookup[b] then
			table.insert(build,{lookup[b][1],lookup[b][2]})
			if i==1 then spec=lookup[b][1] end
		else
			return nil,("Unknown talent(s): '"..text[i].."' at line "..i..".")
		end
	end
	build.spec = spec
	return build
end

function me:ParseLines(text,multi)
	local table={}
	local index=1
	local st,en
	text = text .. "\n"
	local count
	local spec
	while (index<#text) do
		st,en,line=string.find(text,"(.-)\n",index)
		if not en then break end
		index = en + 1
		line = line:gsub("//.*$","")
		line = line:gsub("^[%s	]+","")
		line = line:gsub("[%s	]+$","")
		line = line:gsub("||","|")
		line = line:gsub("/[0-9]+","")

		if line:find("spec=") then
			spec=line:match("Spec=(.+)")
		else
			if multi then
				local co,ln = line:match("([1-9]+)[%s%*x]+(.+)")
				if co then
					count=co
					line=ln
				else
					count=1
				end
			else
				count=1
			end
			if (#line>0) then
				for i=1,count do tinsert(table,line) end
			end
		end
	end
	return table,spec
end

function me:ParseTextTalents(text,pet)
	local table,spec = self:ParseLines(text,true)
	return self:ParseTableTalents(table,pet,spec)
end

function me:DumpBuild(num)
	local s = ""
	for i=1,#self.registeredBuilds[num].build do
		local tab,talent = unpack(self.registeredBuilds[num].build[i])
		s = s .. ((#s>0) and "," or "") .. "{"..tab..","..talent.."}"
	end
	self:Print("  ZygorTalentAdvisor:RegisterBuild(\""..(self.registeredBuilds[num].class or "PET "..self.registeredBuilds[num].pettype).."\",\""..self.registeredBuilds[num].title.."\",{"..s.."})")
end

me.TalentsToNumbers = {
	["ROGUE"]={
		["Deadly Momentum"]=6514,
		["Coup de Grace"]=276,
		["Lethality"]=269,
		["Ruthlessness"]=273,
		["Quickening"]=1721,
		["Puncturing Wounds"]=277,
		["Blackjack"]=6515,
		["Deadly Brew"]=2065,
		["Cold Blood"]=280,
		["Vile Poisons"]=682,
		["Deadened Nerves"]=11209,
		["Seal Fate"]=283,
		["Murderous Intent"]=6516,
		["Overkill"]=281,
		["Master Poisoner"]=1715,
		["Improved Expose Armor"]=278,
		["Cut to the Chase"]=2070,
		["Venomous Wounds"]=6517,
		["Vendetta"]=2071,

		["Improved Recuperate"]=6395,
		["Improved Sinister Strike"]=201,
		["Precision"]=181,
		["Improved Slice and Dice"]=1827,
		["Improved Sprint"]=222,
		["Aggression"]=1122,
		["Improved Kick"]=206,
		["Lightning Reflexes"]=186,
		["Revealing Strike"]=11171,
		["Reinforced Leather"]=6511,
		["Improved Gouge"]=203,
		["Combat Potency"]=1825,
		["Blade Twisting"]=1706,
		["Throwing Specialization"]=2072,
		["Adrenaline Rush"]=205,
		["Savage Combat"]=2074,
		["Bandit's Guile"]=11174,
		["Restless Blades"]=6513,
		["Killing Spree"]=2076,

		["Nightstalker"]=244,
		["Improved Ambush"]=263,
		["Relentless Strikes"]=2244,
		["Elusiveness"]=247,
		["Waylay"]=2077,
		["Opportunity"]=261,
		["Initiative"]=245,
		["Energetic Recovery"]=11665,
		["Find Weakness"]=6519,
		["Hemorrhage"]=681,
		["Honor Among Thieves"]=2078,
		["Premeditation"]=381,
		["Enveloping Shadows"]=11664,
		["Cheat Death"]=1722,
		["Preparation"]=284,
		["Sanguinary Vein"]=6520,
		["Slaughter from the Shadows"]=2080,
		["Serrated Blades"]=1123,
		["Shadow Dance"]=2081,
	},
	['PALADIN']={
		["Arbiter of the Light"]=10099,
		["Protector of the Innocent"]=12189,
		["Judgements of the Pure"]=10127,
		["Clarity of Purpose"]=11213,
		["Last Word"]=10097,
		["Blazing Light"]=11780,
		["Denounce"]=10109,
		["Divine Favor"]=11202,
		["Infusion of Light"]=10129,
		["Daybreak"]=11771,
		["Enlightened Judgements"]=10113,
		["Beacon of Light"]=10133,
		["Speed of Light"]=11215,
		["Sacred Cleansing"]=10121,
		["Conviction"]=11779,
		["Aura Mastery"]=10115,
		["Paragon of Virtue"]=12151,
		["Tower of Radiance"]=11168,
		["Blessed Life"]=10117,
		["Light of Dawn"]=11203,

		["Divinity"]=12198,
		["Seals of the Pure"]=10324,
		["Eternal Glory"]=12152,
		["Judgements of the Just"]=10372,
		["Toughness"]=10332,
		["Improved Hammer of Justice"]=10336,
		["Hallowed Ground"]=10344,
		["Sanctuary"]=10346,
		["Hammer of the Righteous"]=10374,
		["Wrath of the Lightbringer"]=11159,
		["Reckoning"]=11161,
		["Shield of the Righteous"]=11607,
		["Grand Crusader"]=11193,
		["Vindication"]=10680,
		["Holy Shield"]=10356,
		["Guarded by the Light"]=11221,
		["Divine Guardian"]=10334,
		["Sacred Duty"]=10370,
		["Shield of the Templar"]=10340,
		["Ardent Defender"]=10350,

		["Eye for an Eye"]=10647,
		["Crusade"]=10651,
		["Improved Judgement"]=11612,
		["Guardian's Favor"]=12153,
		["Rule of Law"]=11269,
		["Pursuit of Justice"]=11611,
		["Communion"]=10665,
		["The Art of War"]=10661,
		["Long Arm of the Law"]=11610,
		["Divine Storm"]=11204,
		["Rebuke"]=11207,
		["Sanctity of Battle"]=11372,
		["Seals of Command"]=10643,
		["Sanctified Wrath"]=10669,
		["Selfless Healer"]=11271,
		["Repentance"]=10663,
		["Divine Purpose"]=10633,
		["Inquiry of Faith"]=10677,
		["Acts of Sacrifice"]=11211,
		["Zealotry"]=11222,
	},
	['DEATHKNIGHT']={
		["Butchery"]=1939,
		["Blade Barrier"]=2017,
		["Bladed Armor"]=1938,
		["Improved Blood Tap"]=12223,
		["Scent of Blood"]=1948,
		["Scarlet Fever"]=7462,
		["Hand of Doom"]=11270,
		["Blood-Caked Blade"]=7460,
		["Bone Shield"]=7459,
		["Toughness"]=7458,
		["Abomination's Might"]=2105,
		["Sanguine Fortitude"]=7461,
		["Blood Parasite"]=1960,
		["Improved Blood Presence"]=1936,
		["Will of the Necropolis"]=1959,
		["Rune Tap"]=1941,
		["Vampiric Blood"]=2019,
		["Improved Death Strike"]=2259,
		["Crimson Scourge"]=7463,
		["Dancing Rune Weapon"]=1961,

		["Runic Power Mastery"]=2031,
		["Icy Reach"]=2035,
		["Nerves of Cold Steel"]=2022,
		["Annihilation"]=2048,
		["Lichborne"]=2215,
		["On a Pale Horse"]=11275,
		["Endless Winter"]=1971,
		["Merciless Combat"]=1993,
		["Chill of the Grave"]=1981,
		["Killing Machine"]=2044,
		["Rime"]=1992,
		["Pillar of Frost"]=1979,
		["Improved Icy Talons"]=2223,
		["Brittle Bones"]=1980,
		["Chilblains"]=2260,
		["Hungering Cold"]=1999,
		["Improved Frost Presence"]=2029,
		["Threat of Thassarian"]=2284,
		["Might of the Frozen Wastes"]=7571,
		["Howling Blast"]=1989,

		["Unholy Command"]=2025,
		["Virulence"]=1932,
		["Epidemic"]=1963,
		["Desecration"]=2226,
		["Resilient Infection"]=7572,
		["Morbidity"]=11178,
		["Runic Corruption"]=2047,
		["Unholy Frenzy"]=7574,
		["Contagion"]=12119,
		["Shadow Infusion"]=11179,
		["Magic Suppression"]=2009,
		["Rage of Rivendare"]=2082,
		["Unholy Blight"]=1996,
		["Anti-Magic Zone"]=2221,
		["Improved Unholy Presence"]=2013,
		["Dark Transformation"]=2085,
		["Ebon Plaguebringer"]=2043,
		["Sudden Doom"]=7575,
		["Summon Gargoyle"]=2000,
	},
	['HUNTER']={
		["Improved Kill Command"]=9494,
		["One with Nature"]=9490,
		["Bestial Discipline"]=9492,
		["Pathfinding"]=9502,
		["Spirit Bond"]=9514,
		["Frenzy"]=9512,
		["Improved Mend Pet"]=9510,
		["Cobra Strikes"]=9530,
		["Fervor"]=9504,
		["Focus Fire"]=9520,
		["Longevity"]=9534,
		["Killing Streak"]=9528,
		["Crouching Tiger, Hidden Chimera"]=11714,
		["Bestial Wrath"]=9524,
		["Ferocious Inspiration"]=9518,
		["Kindred Spirits"]=9538,
		["The Beast Within"]=9536,
		["Invigoration"]=9522,
		["Beast Mastery"]=9542,

		["Go for the Throat"]=9390,
		["Efficiency"]=9380,
		["Rapid Killing"]=9378,
		["Sic 'Em!"]=9396,
		["Improved Steady Shot"]=9402,
		["Careful Aim"]=9398,
		["Silencing Shot"]=9424,
		["Concussive Barrage"]=9406,
		["Piercing Shots"]=11225,
		["Bombardment"]=9408,
		["Trueshot Aura"]=9412,
		["Termination"]=9416,
		["Resistance is Futile"]=9420,
		["Rapid Recuperation"]=9422,
		["Master Marksman"]=9418,
		["Readiness"]=9404,
		["Posthaste"]=9426,
		["Marked for Death"]=9428,
		["Chimera Shot"]=9430,

		["Hunter vs. Wild"]=9442,
		["Pathing"]=9432,
		["Improved Serpent Sting"]=9450,
		["Survival Tactics"]=9444,
		["Trap Mastery"]=10753,
		["Entrapment"]=9440,
		["Point of No Escape"]=9472,
		["Thrill of the Hunt"]=9484,
		["Counterattack"]=9448,
		["Lock and Load"]=9452,
		["Resourcefulness"]=9460,
		["Mirrored Blades"]=9482,
		["T.N.T."]=9462,
		["Toxicology"]=9464,
		["Wyvern Sting"]=9468,
		["Noxious Stings"]=9474,
		["Hunting Party"]=9476,
		["Sniper Training"]=9478,
		["Serpent Spread"]=11698,
		["Black Arrow"]=9480,
	},
	['WARRIOR']={
		["War Academy"]=10134,
		["Field Dressing"]=11163,
		["Blitz"]=9664,
		["Tactical Mastery"]=11416,
		["Second Wind"]=8190,
		["Deep Wounds"]=8176,
		["Drums of War"]=8184,
		["Taste for Blood"]=10138,
		["Sweeping Strikes"]=8192,
		["Impale"]=10741,
		["Improved Hamstring"]=11417,
		["Improved Slam"]=11418,
		["Deadly Calm"]=11223,
		["Blood Frenzy"]=9662,
		["Lambs to the Slaughter"]=10520,
		["Juggernaut"]=8208,
		["Sudden Death"]=8214,
		["Wrecking Crew"]=8194,
		["Throwdown"]=11167,
		["Bladestorm"]=8222,

		["Blood Craze"]=9610,
		["Battle Trance"]=9606,
		["Cruelty"]=9608,
		["Executioner"]=9644,
		["Booming Voice"]=9624,
		["Rude Interruption"]=11415,
		["Piercing Howl"]=9618,
		["Flurry"]=9636,
		["Death Wish"]=9630,
		["Enrage"]=9612,
		["Die by the Sword"]=11414,
		["Raging Blow"]=11208,
		["Rampage"]=9650,
		["Heroic Fury"]=9648,
		["Furious Attacks"]=9634,
		["Meat Cleaver"]=9642,
		["Intensify Rage"]=10743,
		["Bloodsurge"]=9654,
		["Skirmisher"]=10744,
		["Titan's Grip"]=9658,
		["Single-Minded Fury"]=9660,

		["Incite"]=10464,
		["Toughness"]=10474,
		["Blood and Thunder"]=10480,
		["Shield Specialization"]=10466,
		["Shield Mastery"]=10472,
		["Hold the Line"]=11170,
		["Gag Order"]=10468,
		["Last Stand"]=10482,
		["Concussion Blow"]=10478,
		["Bastion of Defense"]=10934,
		["Warbringer"]=10494,
		["Improved Revenge"]=10470,
		["Devastate"]=10486,
		["Impending Victory"]=11217,
		["Thunderstruck"]=10488,
		["Vigilance"]=10492,
		["Heavy Repercussions"]=10484,
		["Safeguard"]=10490,
		["Sword and Board"]=10496,
		["Shockwave"]=10498,
	},
	['WARLOCK']={
		["Doom and Gloom"]=11100,
		["Improved Life Tap"]=11110,
		["Improved Corruption"]=11104,
		["Jinx"]=11214,
		["Soul Siphon"]=11112,
		["Siphon Life"]=11420,
		["Curse of Exhaustion"]=11128,
		["Improved Fear"]=11114,
		["Eradication"]=11134,
		["Improved Howl of Terror"]=11140,
		["Soul Swap"]=11366,
		["Shadow Embrace"]=11124,
		["Death's Embrace"]=11142,
		["Nightfall"]=11122,
		["Soulburn: Seed of Corruption"]=11419,
		["Everlasting Affliction"]=11150,
		["Pandemic"]=11200,
		["Haunt"]=11152,

		["Demonic Embrace"]=10994,
		["Dark Arts"]=10992,
		["Fel Synergy"]=11206,
		["Demonic Rebirth"]=11713,
		["Mana Feed"]=11020,
		["Demonic Aegis"]=11190,
		["Master Summoner"]=11014,
		["Impending Doom"]=11198,
		["Demonic Empowerment"]=11160,
		["Improved Health Funnel"]=10998,
		["Molten Core"]=11024,
		["Hand of Gul'dan"]=11201,
		["Aura of Foreboding"]=11814,
		["Ancient Grimoire"]=11188,
		["Inferno"]=11189,
		["Decimation"]=11034,
		["Cremation"]=11199,
		["Demonic Pact"]=11042,
		["Metamorphosis"]=11044,

		["Bane"]=10938,
		["Shadow and Flame"]=10936,
		["Improved Immolate"]=10960,
		["Improved Soul Fire"]=11197,
		["Emberstorm"]=11181,
		["Improved Searing Pain"]=11196,
		["Aftermath"]=10940,
		["Backdraft"]=10978,
		["Shadowburn"]=10948,
		["Burning Embers"]=11182,
		["Soul Leech"]=10970,
		["Backlash"]=10958,
		["Nether Ward"]=12120,
		["Fire and Brimstone"]=10984,
		["Shadowfury"]=10980,
		["Nether Protection"]=10964,
		["Empowered Imp"]=10982,
		["Bane of Havoc"]=10962,
		["Chaos Bolt"]=10986,
	},
	['PRIEST']={
		["Improved Power Word: Shield"]=10736,
		["Twin Disciplines"]=8577,
		["Mental Agility"]=8595,
		["Evangelism"]=8593,
		["Archangel"]=11608,
		["Inner Sanctum"]=8581,
		["Soul Warding"]=8607,
		["Renewed Hope"]=11224,
		["Power Infusion"]=8611,
		["Atonement"]=11812,
		["Inner Focus"]=8591,
		["Rapture"]=8617,
		["Borrowed Time"]=11523,
		["Reflective Shield"]=8605,
		["Strength of Soul"]=11813,
		["Divine Aegis"]=8609,
		["Pain Suppression"]=8623,
		["Train of Thought"]=12183,
		["Focused Will"]=8621,
		["Grace"]=8625,
		["Power Word: Barrier"]=8603,
		["Rapid Renewal"]=14738, 

		["Improved Renew"]=10746,
		["Empowered Healing"]=9553,
		["Divine Fury"]=9549,
		["Desperate Prayer"]=11669,
		["Surge of Light"]=11765,
		["Inspiration"]=9561,
		["Divine Touch"]=9593,
		["Holy Concentration"]=9577,
		["Lightwell"]=11666,
		["Serendipity"]=9573,
		["Spirit of Redemption"]=11670,
		["Tome of Light"]=12184,
		["Body and Soul"]=9587,
		["Chakra"]=11667,
		["Revelations"]=11755,
		["Blessed Resilience"]=11672,
		["Test of Faith"]=9597,
		["State of Mind"]=11668,
		["Circle of Healing"]=9595,
		["Guardian Spirit"]=9601,

		["Darkness"]=9032,
		["Improved Shadow Word: Pain"]=9036,
		["Veiled Shadows"]=9046,
		["Improved Psychic Scream"]=9040,
		["Improved Mind Blast"]=9042,
		["Improved Devouring Plague"]=9062,
		["Twisted Faith"]=11673,
		["Shadowform"]=9064,
		["Phantasm"]=9068,
		["Harnessed Shadows"]=11606,
		["Silence"]=9052,
		["Vampiric Embrace"]=9054,
		["Masochism"]=11778,
		["Mind Melt"]=9060,
		["Pain and Suffering"]=9076,
		["Vampiric Touch"]=9074,
		["Paralysis"]=11663,
		["Psychic Horror"]=9072,
		["Sin and Punishment"]=11605,
		["Shadowy Apparition"]=9070,
		["Dispersion"]=9080,
	},
	['DRUID']={
		["Nature's Grace"]=8359,
		["Starlight Wrath"]=8349,
		["Nature's Majesty"]=11281,
		["Genesis"]=11284,
		["Moonglow"]=8353,
		["Balance of Power"]=8383,
		["Euphoria"]=8389,
		["Moonkin Form"]=11278,
		["Typhoon"]=11282,
		["Shooting Stars"]=8381,
		["Owlkin Frenzy"]=8391,
		["Gale Winds"]=8379,
		["Solar Beam"]=8361,
		["Dreamstate"]=12149,
		["Force of Nature"]=8399,
		["Sunfire"]=12150,
		["Earth and Moon"]=11277,
		["Fungal Growth"]=8403,
		["Lunar Shower"]=8393,
		["Starfall"]=8405,

		["Feral Swiftness"]=8295,
		["Furor"]=11716,
		["Predatory Strikes"]=9026,
		["Infected Wounds"]=8760,
		["Fury Swipes"]=8305,
		["Primal Fury"]=8761,
		["Feral Aggression"]=11285,
		["King of the Jungle"]=8323,
		["Feral Charge"]=8299,
		["Stampede"]=8301,
		["Thick Hide"]=8293,
		["Leader of the Pack"]=8325,
		["Brutal Impact"]=8307,
		["Nurturing Instinct"]=8303,
		["Primal Madness"]=8335,
		["Survival Instincts"]=8313,
		["Endless Carnage"]=8759,
		["Natural Reaction"]=8758,
		["Blood in the Water"]=8341,
		["Rend and Tear"]=8343,
		["Pulverize"]=8319,
		["Berserk"]=8347,

		["Blessing of the Grove"]=8227,
		["Natural Shapeshifter"]=8237,
		["Naturalist"]=11699,
		["Heart of the Wild"]=11715,
		["Perseverance"]=11279,
		["Master Shapeshifter"]=8277,
		["Improved Rejuvenation"]=8245,
		["Living Seed"]=8253,
		["Revitalize"]=8269,
		["Nature's Swiftness"]=8249,
		["Fury of Stormrage"]=11712,
		["Nature's Bounty"]=8255,
		["Empowered Touch"]=8762,
		["Malfurion's Gift"]=12146,
		["Efflorescence"]=8263,
		["Wild Growth"]=8279,
		["Nature's Cure"]=8763,
		["Nature's Ward"]=8267,
		["Gift of the Earthmother"]=11280,
		["Swift Rejuvenation"]=8265,
		["Tree of Life"]=8271,
	},
	['SHAMAN']={
		["Acuity"]=11218,
		["Convection"]=564,
		["Concussion"]=563,
		["Call of Flame"]=561,
		["Elemental Warding"]=1640,
		["Reverberation"]=575,
		["Elemental Precision"]=1685,
		["Rolling Thunder"]=11767,
		["Elemental Focus"]=574,
		["Elemental Reach"]=1641,
		["Elemental Oath"]=2049,
		["Lava Flows"]=2051,
		["Fulmination"]=11769,
		["Elemental Mastery"]=573,
		["Earth's Grasp"]=11768,
		["Totemic Wrath"]=5565,
		["Feedback"]=11368,
		["Lava Surge"]=5566,
		["Earthquake"]=1687,

		["Elemental Weapons"]=611,
		["Focused Strikes"]=5560,
		["Improved Shields"]=607,
		["Elemental Devastation"]=11216,
		["Flurry"]=602,
		["Ancestral Swiftness"]=605,
		["Totemic Reach"]=11432,
		["Toughness"]=615,
		["Stormstrike"]=901,
		["Static Shock"]=2055,
		["Frozen Power"]=11220,
		["Improved Fire Nova"]=11770,
		["Searing Flames"]=2083,
		["Earthen Power"]=2056,
		["Shamanistic Rage"]=1693,
		["Unleashed Rage"]=1689,
		["Maelstrom Weapon"]=2057,
		["Improved Lava Lash"]=5563,
		["Feral Spirit"]=2058,

		["Ancestral Resolve"]=5568,
		["Tidal Focus"]=593,
		["Spark of Life"]=11177,
		["Improved Water Shield"]=583,
		["Totemic Focus"]=595,
		["Focused Insight"]=5567,
		["Nature's Guardian"]=1699,
		["Ancestral Healing"]=581,
		["Nature's Swiftness"]=591,
		["Nature's Blessing"]=1696,
		["Soothing Rains"]=588,
		["Improved Cleanse Spirit"]=2084,
		["Cleansing Waters"]=11435,
		["Ancestral Awakening"]=2061,
		["Mana Tide Totem"]=590,
		["Telluric Currents"]=7705,
		["Tidal Waves"]=2063,
		["Blessing of the Eternals"]=2060,
		["Riptide"]=2064,
	},
	["MAGE"]={
		["Arcane Concentration"]=9154,
		["Improved Counterspell"]=9166,
		["Netherwind Presence"]=9200,
		["Torment the Weak"]=9170,
		["Invocation"]=10864,
		["Improved Arcane Missiles"]=10737,
		["Improved Blink"]=9172,
		["Arcane Flows"]=9192,
		["Presence of Mind"]=9174,
		["Missile Barrage"]=9198,
		["Prismatic Cloak"]=9178,
		["Improved Polymorph"]=9142,
		["Arcane Tactics"]=10733,
		["Incanter's Absorption"]=9188,
		["Improved Arcane Explosion"]=11825,
		["Arcane Potency"]=9180,
		["Slow"]=9196,
		["Nether Vortex"]=11367,
		["Focus Magic"]=10578,
		["Improved Mana Gem"]=9194,
		["Arcane Power"]=9186,

		["Master of Elements"]=10545,
		["Burning Soul"]=10531,
		["Improved Fire Blast"]=10523,
		["Ignite"]=10529,
		["Fire Power"]=11434,
		["Blazing Speed"]=10555,
		["Impact"]=10537,
		["Cauterize"]=11433,
		["Blast Wave"]=10551,
		["Hot Streak"]=10573,
		["Improved Scorch"]=10547,
		["Molten Shields"]=10543,
		["Combustion"]=10561,
		["Improved Hot Streak"]=12121,
		["Firestarter"]=11431,
		["Improved Flamestrike"]=10734,
		["Dragon's Breath"]=10571,
		["Molten Fury"]=10563,
		["Pyromaniac"]=10559,
		["Critical Mass"]=10541,
		["Living Bomb"]=10577,

		["Early Frost"]=9862,
		["Piercing Ice"]=11157,
		["Shatter"]=11158,
		["Ice Floes"]=9846,
		["Improved Cone of Cold"]=11325,
		["Piercing Chill"]=11156,
		["Permafrost"]=9854,
		["Ice Shards"]=9860,
		["Icy Veins"]=9858,
		["Fingers of Frost"]=9876,
		["Improved Freeze"]=11371,
		["Enduring Winter"]=9894,
		["Cold Snap"]=9870,
		["Brain Freeze"]=9890,
		["Shattered Barrier"]=9880,
		["Ice Barrier"]=9882,
		["Reactive Barrier"]=11373,
		["Frostfire Orb"]=11169,
		["Deep Freeze"]=9898,
	},

	["Cunning"]={
		["pet"]=1,
		["Serpent Swiftness"]=2118,
		["Dash"]=2119,
		-- no link for 1,3
		["Great Stamina"]=2120,
		["Natural Armor"]=2121,
		["Boar's Speed"]=2165,
		["Mobility"]=2207,
		-- no link for 1,8
		["Owl's Focus"]=2182,
		["Spiked Collar"]=2127,
		["Culling the Herd"]=2166,
		["Lionhearted"]=2167,
		["Carrion Feeder"]=2206,
		["Great Resistance"]=2168,
		["Cornered"]=2177,
		["Feeding Frenzy"]=2183,
		["Wolverine Bite"]=2181,
		["Roar of Recovery"]=2184,
		["Bullheaded"]=2175,
		["Grace of the Mantis"]=2257,
		["Wild Hunt"]=2256,
		["Roar of Sacrifice"]=2278,
	},
	["Ferocity"]={
		["pet"]=1,
		["Serpent Swiftness"]=2107,
		["Dash"]=2109,
		-- no link for 1,3
		["Great Stamina"]=2112,
		["Natural Armor"]=2113,
		["Improved Cower"]=2124,
		["Bloodthirsty"]=2128,
		["Spiked Collar"]=2125,
		["Boar's Speed"]=2151,
		["Culling the Herd"]=2106,
		["Lionhearted"]=2152,
		["Charge"]=2111,
		-- no link for 1,13
		["Heart of the Phoenix"]=2156,
		["Spider's Bite"]=2129,
		["Great Resistance"]=2154,
		["Rabid"]=2155,
		["Lick Your Wounds"]=2153,
		["Call of the Wild"]=2157,
		["Shark Attack"]=2254,
		["Wild Hunt"]=2253,
	},
	["Tenacity"]={
		["pet"]=1,
		["Serpent Swiftness"]=2114,
		["Charge"]=2237,
		["Great Stamina"]=2116,
		["Natural Armor"]=2117,
		["Spiked Collar"]=2126,
		["Boar's Speed"]=2160,
		["Blood of the Rhino"]=2173,
		["Pet Barding"]=2122,
		["Culling the Herd"]=2110,
		["Guard Dog"]=2123,
		["Lionhearted"]=2162,
		["Thunderstomp"]=2277,
		["Grace of the Mantis"]=2163,
		["Great Resistance"]=2161,
		["Last Stand"]=2171,
		["Taunt"]=2170,
		["Roar of Sacrifice"]=2172,
		["Intervene"]=2169,
		["Silverback"]=2258,
		["Wild Hunt"]=2255,
	},
}

function me:DumpTalentSpells(pet)
	--assert(ZGV,"ZGV required for display.")

	local s = ""
	local _,myclass
	if not pet then _,myclass = UnitClass("player") else _,myclass = GetTalentTabInfo(1,false,pet) end
	s = "	[\""..myclass.."\"]={\n"
	if pet then s = s .. "		[\"pet\"]=1,\n" end
	for tab=1,GetNumTalentTabs(false,pet) do
		local id,tabname = GetTalentTabInfo(tab,false,pet)
		--s = s .. "	[\""..tabname.."\"]={\n"
		for talent=1,GetNumTalents(tab,false,pet) do
			local name = GetTalentInfo(tab,talent,false,pet)
			local link = GetTalentLink(tab,talent,false,pet)
			if link then
				local _,_,id = link:find("talent:([0-9]+)")
				s = s .. "		[\""..name.."\"]="..id..",\n"
			else
				s = s .. "		-- no link for "..tab..","..talent.."\n"
			end
		end
		if tab<GetNumTalentTabs(false,pet) then s = s .. "\n" end
	end
	s = s .. "	},\n"
	if ZGV and ZGV.ShowDump then
		ZGV:ShowDump(s,"Talent data:")
	else
		print(s)
	end
	
end