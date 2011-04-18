-- Author      : Nerino1
-- Create Date : 1/7/2011
-- Version 1.2
-- Thanks to Razorbladez for input and proof reading

--Default Text
function DefaultFontStrings()
	FontString1:SetText('|n |n This mod can be used to see simple information and strategy for Bosses. |n |n When you have a Boss encounter shown, use the Party button to send an overview of the Boss to the Party Chat.')
	FontString2:SetText('|n Separate info is shown for Tank, DPS and Healer. |n |n Simply Choose a Boss from the Menus or Target the Boss and Click the Target Button to see the information for the Boss encounter')
	FontString3:SetText('|n Information in the Cataclysm section is a work in progress. Information is written for Heroic Version of the encounters. In most cases the regular is just an easier version of the Heroic. If you notice anything wrong or have strategy to share, leave me a comment on Curse.')
	FontString8:SetText('Boss Info')
	FontString9:SetText('Written By Nerino1')
end

function AboutFontStrings()
	ShowStuff()
	FontString1:SetText('Written by Nerino1 |n |n Click Send To Party now to inform your party where they can get this mod! |n |n This mod can be used to see simple information and strategy for Bosses. |n When you have a Boss encounter shown, use the Party button to send an overview of the Boss to the Party Chat.')
	FontString2:SetText('|n Separate info is shown for Tank, DPS and Healer. |n |n Simply Choose a Boss from the Menus or Target the Boss and Click the Target Button to see the information for the Boss encounter.')
	FontString3:SetText('|n Information is written for Heroic Version of the encounters. In most cases the regular is just an easier version of the Heroic. If you notice anything wrong or have strategy to share, leave me a comment on Curse.')
	FontString8:SetText('Boss Info')
	FontString9:SetText('About')
end


-- BossInfo Saved Variables
local addonTitle

BossInfo_Version = "1.2";

--BossInfo Option Button Text
BossInfoOptionClose = "Close"
BossInfoOptionReload = "ReloadUI"

BossInfoOptionObjects = {
	ShowWotlk= "Show WOTLK Instances",
	ShowTank = "Show Tank Information",
	ShowDps = "Show DPS Information",
	ShowHealer = "Show Healer Information",
}
local BossInfo_Defaults = {
  ["Options"] = {
    ["ShowTank"] = true,
    ["ShowDps"] = true,
    ["ShowHealer"] = true,
	["ShowWotlk"] = true,
  },
};

-- Create Saved Variable If They Don't Exist
function BossInfo_Loaded()
	if (not BossInfoData) then
		BossInfoData = BossInfo_Defaults["Options"];
		DEFAULT_CHAT_FRAME:AddMessage("BossInfo Loaded.");
		DEFAULT_CHAT_FRAME:AddMessage("BossInfo Options not found. Generating...");
	else
		DEFAULT_CHAT_FRAME:AddMessage("BossInfo Loaded.");
		DEFAULT_CHAT_FRAME:AddMessage("BossInfo Options Loaded.");
	end
	BossInfoOptionsInit()
end

-- Hide Tank, DPS, Healer
function HideStuff()
	if BossInfoData.ShowTank == false then
		FontString1:Hide()
	else
		FontString1:Show()
	end
	if BossInfoData.ShowDps == false then
		FontString2:Hide()
	else
		FontString2:Show()
	end
	if BossInfoData.ShowHealer == false then
		FontString3:Hide()
	else
		FontString3:Show()
	end
end	

-- Show Tank, DPS, Healer Boxes For Start Info
function ShowStuff()
	FontString1:Show()
	FontString2:Show()
	FontString3:Show()
end	

-- Slash Command Main
SLASH_BOSSINFO1, SLASH_BOSSINFO2 = '/bi', '/bossinfo';
function SlashCmdList.BOSSINFO(msg, editbox)
	if BossInfoFrame:IsShown() then
		BossInfoFrame:Hide()
		--ShowStuff()
		--DefaultFontStrings()
	else
		BossInfoFrame:Show()
	end
end

-- Slash Command Options
SLASH_BOSSINFOOPTIONS1, SLASH_BOSSINFOOPTIONS2 = '/bioptions', '/bossinfooptions';
function SlashCmdList.BOSSINFOOPTIONS(msg,editbox)
	if BossInfoOptions:IsShown() then
		BossInfoOptions:Hide()
	else
		BossInfoOptions:Show()
	end
end

-- Enable Button Drag
function BossInfoButton_OnLoad(button)
	button:RegisterForDrag("LeftButton")
end

--Left Click Button
function BossInfoButton_OnClick(self, button)
	if button == "LeftButton" then
		if BossInfoFrame:IsShown() then
			BossInfoFrame:Hide()
			--ShowStuff()
			--DefaultFontStrings()
		else
			BossInfoFrame:Show()
		end
	end

-- Right Click Button
	if button == "RightButton" then
		if BossInfoOptions:IsShown() then
			BossInfoOptions:Hide()
		else
			BossInfoOptions:Show()
		end
	end	
end

-- About Button

function About_OnClick()
	ShowStuff()
	AboutFontStrings()
end

-- Close Button

function Close_OnClick()
	--ShowStuff()
	--DefaultFontStrings()
	BossInfoFrame:Hide()
end

function HideWrath_Load()
	if BossInfoData.ShowWotlk == false then
		HideWrath()
	elseif BossInfoData.ShowWotlk == true then
		ShowWrath()
	end
end	

-- Hide WOTLK Button

function HideWrath()
	Instance:Hide()
	FontString4:Hide()
end

-- Show WOTLK Button

function ShowWrath()
	Instance:Show()
	FontString4:Show()
end

-- Party Button

function Party1_OnClick()
	local namez = FontString9:GetText()

		if namez == "Written By Nerino1" then
			bossinfoabout()

		elseif namez == "Elder Nadox" then
			eldernadoxparty()

		elseif namez == "Prince Taldaram" then
			princetaldaramparty()
	
        elseif namez == "Jedoga Shadowseeker" then
			jedogashadowseekerparty()

        elseif namez == "Herald Volazi" then
			heraldvolaziparty()
	
        elseif namez == "Amanitar" then
			amanitarparty()

        elseif namez == "Krikthir the Gatewatcher" then
			krikthirthegatewatcherparty()

        elseif namez == "Hadronox" then
			hadronoxparty()

        elseif namez == "Anub'arak" then
			anubarakparty()

        elseif namez == "Meathook" then
			meathookparty()

        elseif namez == "Salramm the Fleshcrafter" then
			salrammthefleshcrafterparty()
	
        elseif namez == "Chrono-Lord Epoch" then
			chronolordepochparty()

		elseif namez == "Mal'Ganis" then
			malganisparty()
	
        elseif namez == "Infinite Corruptor" then
			infinitecorruptorparty()

        elseif namez == "Trollgore" then
			trollgoreparty()

        elseif namez == "Novos the Summoner" then
			novosthesummonerparty()

        elseif namez == "King Dred" then
			kingdredparty()
	
		elseif namez == "The Prophet Tharon'ja" then
			theprophettharonjaparty()

        elseif namez == "Bronjahn" then
			bronjahnparty()

        elseif namez == "Devourer of Souls" then
			devourerofsoulsparty()

        elseif namez == "Slad'ran" then
			sladranparty()

        elseif namez == "Drakkari Colossus" then
			drakkaricolossusparty()
	
        elseif namez == "Moorabi" then
			moorabiparty()

		elseif namez == "Galdarah" then
			galdarahparty()

        elseif namez == "Eck the Ferocious" then
			ecktheferociousparty()

        elseif namez == "General Bjarngrim" then
			generalbjarngrimparty()

        elseif namez == "Volkhan" then
			volkhanparty()

        elseif namez == "Ionar" then
			ionarparty()

		elseif namez == "Loken" then
			lokenparty()

        elseif namez == "Falric" then
			falricparty()

        elseif namez == "Marwyn" then
			marwynparty()

        elseif namez == "The Lich King" then
			thelichkingparty()

        elseif namez == "Maiden of Grief" then
			maidenofgriefparty()

        elseif namez == "Krystallus" then
			krystallusparty()

        elseif namez == "Tribunal Chest" then
			tribunalchestparty()

		elseif namez == "Sjonnir the Ironshaper" then
			sjonnirtheironshaperparty()

        elseif namez == "Grand Magus Telestra" then
			grandmagustelestraparty()

        elseif namez == "Anomalus" then
			anomalusparty()

        elseif namez == "Ormorok the Tree-Shaper" then
			ormorokthetreeshaperparty()

		elseif namez == "Keristrasza" then
			keristraszaparty()

        elseif namez == "Stoutbeard/Kolurg" then
			commanderstoutbeardkolurgparty()

        elseif namez == "Drakos the Interrogator" then
			drakostheinterrogatorparty()
			
        elseif namez == "Varos Cloudstrider" then
			varoscloudstriderparty()

        elseif namez == "Mage-Lord Urom" then
			magelorduromparty()

		elseif namez == "Ley-Guardian Eregos" then
			leyguardianeregosparty()

        elseif namez == "Forgemaster Garfrost" then
			forgemastergarfrostparty()

        elseif namez == "Krick & Ick" then
			ickkrickparty()

        elseif namez == "Scourgelord Tyrannus" then
			scourgelordtyrannusparty()

        elseif namez == "Grand Champions" then
			grandchampionsparty()

        elseif namez == "Deathstalker Visceri" then
			grandchampionsparty()
			
        elseif namez == "Eadric the Pure" then
			eadricthepureparty()	

        elseif namez == "Argent Confessor Paletress" then
			argentconfessorpaletressparty()

		elseif namez == "The Black Knight" then
			theblackknightparty()

        elseif namez == "Prince Keleseth" then
			princekelesethparty()

        elseif namez == "Skarvald the Constructor" then
			skarvalddalronnparty()

		elseif namez == "Dalronn the Controller" then
			skarvalddalronnparty()
			
        elseif namez == "Ingvar the Plunderer" then
			ingvartheplundererparty()

        elseif namez == "Svala Sorrowgrave" then
			svalasorrowgraveparty()
			
        elseif namez == "Gortok Palehoof" then
			gortokpalehoofparty()	

        elseif namez == "Skadi the Ruthless" then
			skaditheruthlessparty()

		elseif namez == "King Ymiron" then
			kingymironparty()

        elseif namez == "Erekem" then
			erekemparty()
			
        elseif namez == "Moragg" then
			moraggparty()

        elseif namez == "Ichoron" then
			ichoronparty()

		elseif namez == "Xevozz" then
			xevozzparty()

		elseif namez == "Lavanthor" then
			lavanthorparty()

        elseif namez == "Zuramat the Obliterator" then
			zuramattheobliteratorparty()

		elseif namez == "Cyanigosa" then
			cyanigosaparty()
			
		elseif namez == "Rom'ogg Bonecrusher" then
			romoggbonecrusherparty()
		
		elseif namez == "Corla, Herald of Twilight" then
			corlaheraldoftwilightparty()	
				
		elseif namez == "Karsh Steelbender" then
			karshsteelbenderparty()
			
		elseif namez == "Beauty" then
			beautyparty()	
			
		elseif namez == "Ascendant Lord Obsidius" then
			ascendantlordobsidiusparty()
				
		elseif namez == "Glubtok" then
			glubtokparty()
			
		elseif namez == "Helix Gearbreaker" then
			helixgearbreakerparty()	
			
		elseif namez == "Foe Reaper 5000" then
			foereaper5000party()
			
		elseif namez == "Admiral Ripsnarl" then
			admiralripsnarlparty()
				
		elseif namez == "Captain Cookie" then
			captaincookieparty()
				
		elseif namez == "Vanessa VanCleef" then
			vanessavancleefparty()
				
		elseif namez == "General Umbriss" then
			generalumbrissparty()
				
		elseif namez == "Forgemaster Throngus" then
			forgemasterthrongusparty()
				
		elseif namez == "Drahga Shadowburner" then
			 drahgashadowburnerparty()
				 
		elseif namez == "Erudax" then
			erudaxparty()
				
		elseif namez == "Temple Guardian Anhuur" then
			templeguardiananhuurparty()
				
		elseif namez == "Earthrager Ptah" then
			earthragerptahparty()
				
		elseif namez == "Anraphet" then
			anraphetparty()
				
		elseif namez == "Isiset" then
			isisetparty()
				
		elseif namez == "Ammunae" then
			ammunaeparty()
				
		elseif namez == "Setesh" then
			seteshparty()
				
		elseif namez == "Rajh" then
			rajhparty()
				
		elseif namez == "General Husam" then
			generalhusamparty()
				
		elseif namez == "High Prophet Barim" then
			highprophetbarimparty()
				
		elseif namez == "Lockmaw & Augh" then
			lockmawaughparty()
				
		elseif namez == "Siamat" then
			siamatparty()
				
		elseif namez == "Baron Ashbury" then
			baronashburyparty()
				
		elseif namez == "Baron Silverlaine" then
			baronsilverlaineparty()
				
		elseif namez == "Commander Springvale" then
			commanderspringvaleparty()
				
		elseif namez == "Lord Walden" then
			lordwaldenparty()
				
		elseif namez == "Lord Godfrey" then
			lordgodfreyparty()
				
		elseif namez == "Corborus" then
			corborusparty()
				
		elseif namez == "Slabhide" then
			slabhideparty()
				
		elseif namez == "Ozruk" then
			ozrukparty()
				
		elseif namez == "High Priestess Azil" then
			highpriestessazilparty()
				
		elseif namez == "Lady Naz'jar" then
			ladynazjarparty()
				
		elseif namez == "Commander Ulthok" then
			commanderulthokparty()
			
		elseif namez == "Erunak Stonespeaker" then
			stonespeakerghurshaparty()
				
		elseif namez == "Mindbender Ghur'sha" then
			stonespeakerghurshaparty()
				
		elseif namez == "Ozumat" then
			ozumatparty()
		
		elseif namez == "Neptunos" then
			ozumatparty()
			
		elseif namez == "Grand Vizier Ertan" then
			grandvizierertanparty()
				
		elseif namez == "Altairus" then
			altairusparty()
				
		elseif namez == "Asaad" then
			asaadparty()
		
		elseif namez == "About" then
			aboutinfo()
				
		elseif namez == nil then
			targetinfo()
	end
end

function bossinfoabout()
	local msg = "Nerino1's Boss Info  -  This mod can be used to see simple information and strategy for Bosses. Infomation is seperated for Tank, DPS and Healers."
	SendChatMessage(msg, "Party")
	HideStuff()
	FontString1:SetText("|n |n |n Boss Info Party Information")
	FontString2:SetText("This mod can be used to see simple information and strategy for Bosses. Infomation is seperated for Tank, DPS and Healers.")
	FontString3:SetText("|n |n Select a Boss and press the Party Button to display a short overview of the fight to the party members.")
	FontString8:SetText("Boss Info")
	FontString9:SetText("Written By Nerino1")
end

-- Target Button Info

function targetinfo()
	ShowStuff()
	FontString1:SetText("|n |n |n How to use the Target Button")
	FontString2:SetText("When you are in an Instance, Target the Boss and Press the Target button to be taken directly to that Bosses Info.")
	FontString3:SetText("")
	FontString8:SetText("Boss Info")
	FontString9:SetText("Written By Nerino1")
end

-- BossInfo Options
function BossInfoOptionsInit()

   if addonTitle == nil then
	
	BossInfoOptions:Show()
	local frameWidth = 300
	local frameHeight
	local fontName, fontHeight, fontFlags = GameFontNormal:GetFont()
	local currItemNumber = 0
	local BossInfoOptions_ItemsMax = 0

	for i,j in pairs(BossInfo_Defaults) do
		BossInfoOptions_ItemsMax = BossInfoOptions_ItemsMax+1
	end

	frameHeight = ((fontHeight+5)*BossInfoOptions_ItemsMax)+165
	BossInfoOptions:SetFrameStrata("HIGH")
	BossInfoOptions:SetWidth(frameWidth)
	BossInfoOptions:SetHeight(frameHeight)
	
	BossInfoOptions.ItemsCheckBox = {}
	addonTitle = GetAddOnMetadata("BossInfo", "Title") .. " " ..  GetAddOnMetadata("BossInfo", "Version")

	BossInfoOptions.ItemsLabel = {}
	
	-- Pull from Database instead of BossInfo_Defaults

	for i,j in pairs(BossInfoData) do
		currItemNumber = currItemNumber+1
		local OffsetY = ((fontHeight+5)*currItemNumber)+10
		BossInfoOptions.ItemsCheckBox[i] = CreateFrame("CheckButton",i .. "CheckButton",BossInfoOptions,"UICheckButtonTemplate")
		BossInfoOptions.ItemsCheckBox[i]:SetWidth(fontHeight+5)
		BossInfoOptions.ItemsCheckBox[i]:SetHeight(fontHeight+5)

		if (j) then
			BossInfoOptions.ItemsCheckBox[i]:SetChecked(1)
		else
			BossInfoOptions.ItemsCheckBox[i]:SetChecked(nil)
		end
		BossInfoOptions.ItemsCheckBox[i]:SetPoint("TOPLEFT", BossInfoOptions, "BOTTOMLEFT", 10, OffsetY)
		BossInfoOptions.ItemsCheckBox[i]:SetScript("OnClick", BossInfoOptionSetup)
		BossInfoOptions.ItemsLabel[i] = BossInfoOptions:CreateFontString(nil, "OVERLAY")
		BossInfoOptions.ItemsLabel[i]:SetWidth(frameWidth-20)
		BossInfoOptions.ItemsLabel[i]:SetHeight(fontHeight+5)
		BossInfoOptions.ItemsLabel[i]:SetPoint("LEFT", BossInfoOptions.ItemsCheckBox[i], "RIGHT", 5, 0)
		BossInfoOptions.ItemsLabel[i]:SetJustifyH("LEFT")
		BossInfoOptions.ItemsLabel[i]:SetFontObject(GameFontNormal)
		BossInfoOptions.ItemsLabel[i]:SetText(BossInfoOptionObjects[i])
		BossInfoOptions.ItemsLabel[i]:Show()
		BossInfoOptions.ItemsCheckBox[i]:Show()
	end
	BossInfoOptions.CloseButton = CreateFrame("Button","CloseButton",BossInfoOptions,"GameMenuButtonTemplate")
	BossInfoOptions.CloseButton:SetWidth(75)
	BossInfoOptions.CloseButton:SetHeight(23)
	BossInfoOptions.CloseButton:SetPoint("TOPRIGHT", -15, -20)
	BossInfoOptions.CloseButton:SetText(BossInfoOptionClose)
	BossInfoOptions.CloseButton:SetScript("OnClick", function ()
		BossInfoOptions:Hide()
	end)
	BossInfoOptions.ReloadButton = CreateFrame("Button","ReloadButton",BossInfoOptions,"GameMenuButtonTemplate")
	BossInfoOptions.ReloadButton:SetWidth(75)
	BossInfoOptions.ReloadButton:SetHeight(23)
	BossInfoOptions.ReloadButton:SetPoint("BOTTOMRIGHT", -15, 20)
	BossInfoOptions.ReloadButton:SetText(BossInfoOptionReload)
	BossInfoOptions.ReloadButton:SetScript("OnClick", function ()
		ReloadUI();
	end)
   end
	BossInfoOptions:Hide()
end

function BossInfoOptionSetup()

	for i,j in pairs(BossInfoData) do
		local gobj = getglobal(TEXT(i) .. "CheckButton")
                if gobj then
                     BossInfoData[i] = (gobj:GetChecked() == 1)
                else
                      gobj = nil
                end
	end
	BossInfoSetup()
end

function BossInfoSetup()
	for i,j in pairs(BossInfoData) do
		local obj = getglobal(TEXT(i))	
		if (obj) then		

			if (BossInfoData[i]) then
				obj:Show()
			else
				obj:Hide()
			end
		end
	end
end

-- Target Button

function Target1_OnClick()
	local targetz = UnitName("target")
		if targetz == "Elder Nadox" then
			eldernadox()
			
		elseif targetz == "Prince Taldaram" then
			princetaldaram()
	
        elseif targetz == "Jedoga Shadowseeker" then
			jedogashadowseeker()

        elseif targetz == "Herald Volazi" then
			heraldvolazi()
	
        elseif targetz == "Amanitar" then
			amanitar()

        elseif targetz == "Krik'thir the Gatewatcher" then
			krikthirthegatewatcher()

        elseif targetz == "Hadronox" then
			hadronox()

        elseif targetz == "Anub'arak" then
			anubarak()

        elseif targetz == "Meathook" then
			meathook()

        elseif targetz == "Salramm the Fleshcrafter" then
			salrammthefleshcrafter()
	
        elseif targetz == "Chrono-Lord Epoch" then
			chronolordepoch()

		elseif targetz == "Mal'Ganis" then
			malganis()
	
        elseif targetz == "Infinite Corruptor" then
			infinitecorruptor()

        elseif targetz == "Trollgore" then
			trollgore()

        elseif targetz == "Novos the Summoner" then
			novosthesummoner()

        elseif targetz == "King Dred" then
			kingdred()
	
		elseif targetz == "The Prophet Tharon'ja" then
			theprophettharonja()

        elseif targetz == "Bronjahn" then
			bronjahn()

        elseif targetz == "Devourer of Souls" then
			devourerofsouls()

        elseif targetz == "Slad'ran" then
			sladran()

        elseif targetz == "Drakkari Colossus" then
			drakkaricolossus()
	
        elseif targetz == "Moorabi" then
			moorabi()

		elseif targetz == "Gal'darah" then
			galdarah()

        elseif targetz == "Eck the Ferocious" then
			ecktheferocious()

        elseif targetz == "General Bjarngrim" then
			generalbjarngrim()

        elseif targetz == "Volkhan" then
			volkhan()

        elseif targetz == "Ionar" then
			ionar()

		elseif targetz == "Loken" then
			loken()

        elseif targetz == "Falric" then
			falric()

        elseif targetz == "Marwyn" then
			marwyn()

        elseif targetz == "The Lich King" then
			thelichking()

        elseif targetz == "Maiden of Grief" then
			maidenofgrief()

        elseif targetz == "Krystallus" then
			krystallus()

        elseif targetz == "Tribunal Chest" then
			tribunalchest()

		elseif targetz == "Sjonnir The Ironshaper" then
			sjonnirtheironshaper()

        elseif targetz == "Grand Magus Telestra" then
			grandmagustelestra()

        elseif targetz == "Anomalus" then
			anomalus()

        elseif targetz == "Ormorok the Tree-Shaper" then
			ormorokthetreeshaper()

		elseif targetz == "Keristrasza" then
			keristrasza()

        elseif targetz == "Commander Stoutbeard" then
			commanderstoutbeardkolurg()

		elseif targetz == "Commander Kolurg" then
			commanderstoutbeardkolurg()

        elseif targetz == "Drakos the Interrogator" then
			drakostheinterrogator()
			
        elseif targetz == "Varos Cloudstrider" then
			varoscloudstrider()

        elseif targetz == "Mage-Lord Urom" then
			magelordurom()

		elseif targetz == "Ley-Guardian Eregos" then
			leyguardianeregos()

        elseif targetz == "Forgemaster Garfrost" then
			forgemastergarfrost()

        elseif targetz == "Krick" then
			ickkrick()

        elseif targetz == "Scourgelord Tyrannus" then
			scourgelordtyrannus()

        elseif targetz == "Marshal Jacob Alerius" then
			grandchampions()

        elseif targetz == "Ambrose Boltspark" then
			grandchampions()

        elseif targetz == "Colosos" then
			grandchampions()

        elseif targetz == "Jaelyne Evensong" then
			grandchampions()

        elseif targetz == "Lana Stouthammer" then
			grandchampions()

        elseif targetz == "Mokra the Skullcrusher" then
			grandchampions()

        elseif targetz == "Eressea Dawnsinger" then
			grandchampions()

        elseif targetz == "Runok Wildmane" then
			grandchampions()

        elseif targetz == "Zul'tore" then
			grandchampions()

        elseif targetz == "Deathstalker Visceri" then
			grandchampions()
			
        elseif targetz == "Eadric the Pure" then
			eadricthepure()	

        elseif targetz == "Argent Confessor Paletress" then
			argentconfessorpaletress()

		elseif targetz == "The Black Knight" then
			theblackknight()

        elseif targetz == "Prince Keleseth" then
			princekeleseth()

        elseif targetz == "Skarvald the Constructor" then
			skarvalddalronn()

		elseif targetz == "Dalronn the Controller" then
			skarvalddalronn()
			
        elseif targetz == "Ingvar the Plunderer" then
			ingvartheplunderer()

        elseif targetz == "Svala Sorrowgrave" then
			svalasorrowgrave()
			
        elseif targetz == "Gortok Palehoof" then
			gortokpalehoof()	

        elseif targetz == "Skadi the Ruthless" then
			skaditheruthless()

		elseif targetz == "King Ymiron" then
			kingymiron()

        elseif targetz == "Erekem" then
			erekem()
			
        elseif targetz == "Moragg" then
			moragg()

        elseif targetz == "Ichoron" then
			ichoron()

		elseif targetz == "Xevozz" then
			xevozz()

		elseif targetz == "Lavanthor" then
			lavanthor()

        elseif targetz == "Zuramat the Obliterator" then
			zuramattheobliterator()

		elseif targetz == "Cyanigosa" then
			cyanigosa()
			
		elseif targetz == nil then
			targetinfo()
		
		elseif targetz == "Rom'ogg Bonecrusher" then
			romoggbonecrusher()
		
		elseif targetz == "Corla, Herald of Twilight" then
			corlaheraldoftwilight()	
			
		elseif targetz == "Karsh Steelbender" then
			karshsteelbender()
			
		elseif targetz == "Beauty" then
			beauty()	
			
		elseif targetz == "Ascendant Lord Obsidius" then
			ascendantlordobsidius()
			
		elseif targetz == "Glubtok" then
			glubtok()
		
		elseif targetz == "Helix Gearbreaker" then
			helixgearbreaker()	
		
		elseif targetz == "Foe Reaper 5000" then
			foereaper5000()
		
		elseif targetz == "Admiral Ripsnarl" then
			admiralripsnarl()
			
		elseif targetz == "Captain Cookie" then
			captaincookie()
			
		elseif targetz == "Vanessa VanCleef" then
			vanessavancleef()
			
		elseif targetz == "General Umbriss" then
			generalumbriss()
			
		elseif targetz == "Forgemaster Throngus" then
			forgemasterthrongus()
			
		elseif targetz == "Drahga Shadowburner" then
			 drahgashadowburner()
			 
		elseif targetz == "Erudax" then
			erudax()
			
		elseif targetz == "Temple Guardian Anhuur" then
			templeguardiananhuur()
			
		elseif targetz == "Earthrager Ptah" then
			earthragerptah()
			
		elseif targetz == "Anraphet" then
			anraphet()
			
		elseif targetz == "Isiset" then
			isiset()
			
		elseif targetz == "Ammunae" then
			ammunae()
			
		elseif targetz == "Setesh" then
			setesh()
			
		elseif targetz == "Rajh" then
			rajh()
			
		elseif targetz == "General Husam" then
			generalhusam()
			
		elseif targetz == "High Prophet Barim" then
			highprophetbarim()
			
		elseif targetz == "Lockmaw" then
			lockmawaugh()
			
		elseif targetz == "Siamat" then
			siamat()
			
		elseif targetz == "Baron Ashbury" then
			baronashbury()
			
		elseif targetz == "Baron Silverlaine" then
			baronsilverlaine()
			
		elseif targetz == "Commander Springvale" then
			commanderspringvale()
			
		elseif targetz == "Lord Walden" then
			lordwalden()
			
		elseif targetz == "Lord Godfrey" then
			lordgodfrey()
			
		elseif targetz == "Corborus" then
			corborus()
			
		elseif targetz == "Slabhide" then
			slabhide()
			
		elseif targetz == "Ozruk" then
			ozruk()
			
		elseif targetz == "High Priestess Azil" then
			highpriestessazil()
			
		elseif targetz == "Lady Naz'jar" then
			ladynazjar()
			
		elseif targetz == "Commander Ulthok" then
			commanderulthok()
			
		elseif targetz == "Erunak Stonespeaker" then
			stonespeakerghursha()
			
		elseif targetz == "Mindbender Ghur'sha" then
			stonespeakerghursha()
			
		elseif targetz == "Ozumat" then
			ozumat()
			
		elseif targetz == "Neptunos" then
			ozumat()
			
		elseif targetz == "Grand Vizier Ertan" then
			grandvizierertan()
			
		elseif targetz == "Altairus" then
			altairus()
			
		elseif targetz == "Asaad" then
			asaad()
	end
end

-- Click WOTLK Instance Button
function Instance_OnClick() 
       ToggleDropDownMenu(1, nil, BossInfoMenu, Instance, 0, 0);
end

-- Click Cataclysm Button

function Instancecat_OnClick()
		ToggleDropDownMenu(1, nil, BossInfoMenuCat, Instance, -100, 0);
end

--Boss Info Menu WOTLK

local BossInfoMenu = CreateFrame("Frame", "BossInfoMenu")
BossInfoMenu:SetPoint("CENTER", 19, -20) 
BossInfoMenu.displayMode = "MENU"
BossInfoMenu.info = {}
BossInfoMenu.UncheckHack = function(dropdownbutton)
    _G[dropdownbutton:GetName().."Check"]:Hide()
end
BossInfoMenu.HideMenu = function()
    if UIDROPDOWNMENU_OPEN_MENU == BossInfoMenu then
        CloseDropDownMenus()
    end
end


-- Main Menu
BossInfoMenu.initialize = function(self, level)
    if not level then return end
    local info = self.info
    wipe(info)
    if level == 1 then
        info.isTitle = 1
        info.text = "Instance"
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)

        info.keepShownOnClick = 1
        info.disabled = nil
        info.isTitle = nil
        info.notCheckable = 1

        info.text = "Ahnkahet: The Old Kingdom"
        info.func = self.UncheckHack
        info.hasArrow = 1
        info.value = "submenu1"
        UIDropDownMenu_AddButton(info, level)

        info.text = "Azjol-Nerub"
        info.value = "submenu2"
        UIDropDownMenu_AddButton(info, level)
		
		info.text = "Culling of Stratholme"
        info.value = "submenu3"
        UIDropDownMenu_AddButton(info, level)
		
		info.text = "Drak'Tharon Keep"
        info.value = "submenu4"
        UIDropDownMenu_AddButton(info, level)

		info.text = "Forge of Souls"
        info.value = "submenu5"
        UIDropDownMenu_AddButton(info, level)

		info.text = "Gundrak"
        info.value = "submenu6"
        UIDropDownMenu_AddButton(info, level)

		info.text = "Halls of Lightning"
        info.value = "submenu7"
        UIDropDownMenu_AddButton(info, level)

		info.text = "Halls of Reflection"
        info.value = "submenu8"
        UIDropDownMenu_AddButton(info, level)

		info.text = "Halls of Stone"
        info.value = "submenu9"
        UIDropDownMenu_AddButton(info, level)
		
		info.text = "Nexus"
        info.value = "submenu10"
        UIDropDownMenu_AddButton(info, level)
		
		info.text = "Oculus"
        info.value = "submenu11"
        UIDropDownMenu_AddButton(info, level)
		
		info.text = "Pit of Saron"
        info.value = "submenu12"
        UIDropDownMenu_AddButton(info, level)
		
		info.text = "Trial of the Champion"
        info.value = "submenu13"
        UIDropDownMenu_AddButton(info, level)
		
		info.text = "Utgarde Keep"
        info.value = "submenu14"
        UIDropDownMenu_AddButton(info, level)
		
		info.text = "Utgarde Pinnacle"
        info.value = "submenu15"
        UIDropDownMenu_AddButton(info, level)
		
		info.text = "Violet Hold"
        info.value = "submenu16"
        UIDropDownMenu_AddButton(info, level)		
		
        -- Close menu item
        info.hasArrow     = nil
        info.value        = nil
        info.notCheckable = 1
        info.text         = CLOSE
        info.func         = self.HideMenu
        UIDropDownMenu_AddButton(info, level)
		
    elseif level == 2 then
        if UIDROPDOWNMENU_MENU_VALUE == "submenu1" then
            info.text = "Elder Nadox"
			info.func = eldernadox
            UIDropDownMenu_AddButton(info, level)

            info.text = "Prince Taldaram"
			info.func = princetaldaram
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Jedoga Shadowseeker"
			info.func = jedogashadowseeker
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Herald Volazi"
			info.func = heraldvolazi
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Amanitar (Heroic)"
			info.func = amanitar
            UIDropDownMenu_AddButton(info, level)

        elseif UIDROPDOWNMENU_MENU_VALUE == "submenu2" then
            info.text = "Krik'thir the Gatewatcher"
			info.func = krikthirthegatewatcher			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Hadronox"
			info.func = hadronox			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Anub'arak"
			info.func = anubarak			
            UIDropDownMenu_AddButton(info, level)

		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu3" then
            info.text = "Meathook"
			info.func = meathook			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Salramm the Fleshcrafter"
			info.func = salrammthefleshcrafter			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Chrono-Lord Epoch"
			info.func = chronolordepoch			
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Mal'Ganis"
			info.func = malganis			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Infinite Corruptor (Heroic)"
			info.func = infinitecorruptor			
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu4" then
            info.text = "Trollgore"
			info.func = trollgore			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Novos the Summoner"
			info.func = novosthesummoner			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "King Dred"
			info.func = kingdred			
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "The Prophet Tharon'ja"
			info.func = theprophettharonja
			UIDropDownMenu_AddButton(info, level)

		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu5" then
            info.text = "Bronjahn"
			info.func = bronjahn			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Devourer of Souls"
			info.func = devourerofsouls
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu6" then
            info.text = "Slad'ran"
			info.func = sladran			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Drakkari Colossus"
			info.func = drakkaricolossus			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Moorabi"
			info.func = moorabi			
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Gal'darah"
			info.func = galdarah
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Eck the Ferocious (Heroic)"
			info.func = ecktheferocious			
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu7" then
            info.text = "General Bjarngrim"
			info.func = generalbjarngrim			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Volkhan"
			info.func = volkhan			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Ionar"
			info.func = ionar			
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Loken"
			info.func = loken
            UIDropDownMenu_AddButton(info, level)

		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu8" then
            info.text = "Falric"
			info.func = falric			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Marwyn"
			info.func = marwyn			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "The Lich King"
			info.func = thelichking
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu9" then
            info.text = "Maiden of Grief"
			info.func = maidenofgrief			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Krystallus"
			info.func = krystallus	
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Tribunal Chest"
			info.func = tribunalchest
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Sjonnir The Ironshaper"
			info.func = sjonnirtheironshaper
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu10" then
            info.text = "Grand Magus Telestra"
			info.func = grandmagustelestra			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Anomalus"
			info.func = anomalus			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Ormorok the Tree-Shaper"
			info.func = ormorokthetreeshaper
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Keristrasza"
			info.func = keristrasza
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Commander Stoutbeard / Commander Kolurg (Heroic)"
			info.func = commanderstoutbeardkolurg
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu11" then
            info.text = "Drakos the Interrogator"
			info.func = drakostheinterrogator			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Varos Cloudstrider"
			info.func = varoscloudstrider			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Mage-Lord Urom"
			info.func = magelordurom
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Ley-Guardian Eregos"
			info.func = leyguardianeregos
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu12" then
            info.text = "Forgemaster Garfrost"
			info.func = forgemastergarfrost
            UIDropDownMenu_AddButton(info, level)

            info.text = "Ick & Krick"
			info.func = ickkrick			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Scourgelord Tyrannus"
			info.func = scourgelordtyrannus
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu13" then
            info.text = "Grand Champions"
			info.func = grandchampions			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Eadric the Pure"
			info.func = eadricthepure			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Argent Confessor Paletress"
			info.func = argentconfessorpaletress
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "The Black Knight"
			info.func = theblackknight
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu14" then
            info.text = "Prince Keleseth"
			info.func = princekeleseth			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Skarvald the Constructor / Dalronn the Controller"
			info.func = skarvalddalronn			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Ingvar the Plunderer"
			info.func = ingvartheplunderer
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu15" then
            info.text = "Svala Sorrowgrave"
			info.func = svalasorrowgrave
            UIDropDownMenu_AddButton(info, level)

            info.text = "Gortok Palehoof"
			info.func = gortokpalehoof			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Skadi the Ruthless"
			info.func = skaditheruthless
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "King Ymiron"
			info.func = kingymiron
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu16" then
            info.text = "Erekem"
			info.func = erekem
            UIDropDownMenu_AddButton(info, level)

            info.text = "Moragg"
			info.func = moragg
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Ichoron"
			info.func = ichoron
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Xevozz"
			info.func = xevozz
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Lavanthor"
			info.func = lavanthor
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Zuramat the Obliterator"
			info.func = zuramattheobliterator
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Cyanigosa"
			info.func = cyanigosa
            UIDropDownMenu_AddButton(info, level)
		end
		
    end
end

-- Output Functions

-- The Old Kingdom

function eldernadox()
	HideStuff()
	FontString1:SetText("Tank: |n |n This boss can be tanked where he stands. At 50% he will summon a Ahn'kahar Guardian. Until this Guardian is dead the boss and his swarm are immune to damage. Be ready to regain aggro on the boss and swarm when the Guardian dies.")
	FontString2:SetText("DPS: |n |n Attack Boss until 50% at which point a Ahn'kahar Guardian appears. Switch DPS to the Guardian. The boss and swarm are immune to all damage until the Guardian is dead.")
	FontString3:SetText("Healer: |n |n When the boss and swarm go immune at 50%; your heals will still generate threat. Make sure you throw extra heals on yourself as the swarm will probably be attacking you.")
	FontString8:SetText("The Old Kingdom")
	FontString9:SetText("Elder Nadox")
	CloseDropDownMenus()
end

function princetaldaram()
	HideStuff()
	FontString1:SetText("Tank: |n |n Prince Taldaram can be tanked anywhere on this platform. Make sure you still have aggro when the Embrace of the Vampyr is over.")
	FontString2:SetText("DPS: |n |n Tank and Spank. When he vanishes and reappears on a player, DPS him quickly to free your party memeber. If you run from the fire orbs, don't run too far from your healer. It is usually better to just stand and take the damage.")
	FontString3:SetText("Healer: |n |n When he vanishes and reappears on a player; that player will require extra heals as their life is drained. Be ready with a group heal when the fire orbs appear.")
	FontString8:SetText("The Old Kingdom")
	FontString9:SetText("Prince Taldaram")
	CloseDropDownMenus()
end

function jedogashadowseeker()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. At 50%, she calls a volunteer to be safrificed. If the volunteer is not killed before it reaches her; her damage is increased by 200%. She also cast AoE lightning on the ground; dont stand in it.")
	FontString2:SetText("DPS: |n |n Tank and Spank. At 50%, DPS down Volunteer quickly to avoid her 200% damage increase. Don't stand in AoE lighting she casts on the ground")
	FontString3:SetText("Healer: |n |n Healing is straight forward. If the volunteer is not killed at 50%, be ready to throw extra heals.")
	FontString8:SetText("The Old Kingdom")
	FontString9:SetText("Jedoga Shadowseeker")
	CloseDropDownMenus()
end

function heraldvolazi()
	HideStuff()
	FontString1:SetText("Tank: |n |n At 66% and 33% he drives players insane, forcing them to fight copys of themselves alone. If you can't kill them, just hold them until the DPS finished theirs.")
	FontString2:SetText("DPS: |n |n At 66% and 33% he drives players insane, forcing them to fight copys of themselves alone. DPS them down quickly and then help the tank and healer with theirs.")
	FontString3:SetText("Healer: |n |n At 66% and 33% he drives players insane, forcing them to fight copys of themselves alone. If you can't kill them, just heal yourself through the attacks until the DPS are done with theirs.")
	FontString8:SetText("The Old Kingdom")
	FontString9:SetText("Herald Volazi")
	CloseDropDownMenus()
end

function amanitar()
	HideStuff()
	FontString1:SetText("Tank: |n |n Avoid/Kill green poison mushrooms. When the boss casts Mini; stand next to and kill a healthy mushroom. If you are not mini and you kill a Healthy Mushroom you get 100% increased damage")
	FontString2:SetText("DPS: |n |n Avoid/Kill green poison mushrooms. When the boss casts Mini; stand next to and kill a healthy mushroom. If you are not mini and you kill a Healthy Mushroom you get 100% increased damage")
	FontString3:SetText("Healer: |n |n Avoid/Kill green poison mushrooms. When the boss casts Mini; stand next to and kill a healthy mushroom. If you are not mini and you kill a Healthy Mushroom you get 100% increased damage")
	FontString8:SetText("The Old Kingdom")
	FontString9:SetText("Amanitar")
	CloseDropDownMenus()
end

-- Azjol-Nerub

function krikthirthegatewatcher()
	HideStuff()
	FontString1:SetText("Tank: |n |n There are 3 waves with minibosses before the boss. Pull them back so you only have one group at a time.")
	FontString2:SetText("DPS: |n |n Break any Web Wraps that appear on other DPS or Healer.")
	FontString3:SetText("Healer: |n |n During the 3 waves there is a lot of poison on everyone. Extra heals may be required to get through it.")
	FontString8:SetText("Azjol-Nerub")
	FontString9:SetText("Krikthir The Gate Watcher")
	CloseDropDownMenus()
end

function hadronox()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Attack him after he has killed all his adds. Don't stand in Green Poison Cloud.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Don't stand in Green Poison Cloud")
	FontString3:SetText("Healer: |n |n Tank and Spank. If you are able to cleanse poison this will help reduce the amount of healing you need to do. Don't stand in Green Poison Cloud.")
	FontString8:SetText("Azjol-Nerub")
	FontString9:SetText("Jedoga Shadowseeker")
	CloseDropDownMenus()
end

function anubarak()
	HideStuff()
	FontString1:SetText("Tank: |n |n Make sure all players are in the circle before starting. When the boss is casting Pound, back up or run through the boss to avoid the Pound. Do not run towards healer as sometimes he will turn and Pound. During his three undergound phases, stand near the entrace to pickup the adds. Sand clouds on the ground will soon shoot up spikes; Move away.")
	FontString2:SetText("DPS: |n |n Stand far away fromt he boss to avoid accidental Pound. Keep en eye on the healer for little bug that might be on them. Kill poison adds first. Sand clouds on the ground will soon shoot up spikes; Move away.")
	FontString3:SetText("Healer: |n |n Stand far away from the boss to avoid accidental Pound. Cleansing poison from adds makes healing easier. Sand clouds on the ground will soon shoot up spikes; Move away.")
	FontString8:SetText("Azjol-Nerub")
	FontString9:SetText("Anub'arak")
	CloseDropDownMenus()
end

-- Culling of Stratholme

function meathook()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank.")
	FontString2:SetText("DPS: |n |n Tank and Spank.")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Culling of Stratholme")
	FontString9:SetText("Meathook")
	CloseDropDownMenus()
end

function salrammthefleshcrafter()
	HideStuff()
	FontString1:SetText("Tank: |n |n Boss will randomly summon two Ghouls. Make sure you pick them up. He will also randomly explode the Ghouls")
	FontString2:SetText("DPS: |n |n Focus on the boss as he will randomly explode his Ghouls. Alternativly, quickly kill the Ghouls so he cannot explode them.")
	FontString3:SetText("Healer: |n |n Be ready with a group heal for when a Ghoul explodes.")
	FontString8:SetText("Culling of Stratholme")
	FontString9:SetText("Salramm the Fleshcrafter")
	CloseDropDownMenus()
end

function chronolordepoch()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. The boss will randomly run around and hit other players, but will return to the tank.")
	FontString2:SetText("DPS: |n |n Tank and Spank.")
	FontString3:SetText("Healer: |n |n Try to keep all players near 100% health for this fight. During the Time Warp, he will hit one player 3 times in quick succession. Also during the Time Warp, your casting speed is reduced by 70%. An instant heal on the player he chooses is usually better then a cast.")
	FontString8:SetText("Culling of Stratholme")
	FontString9:SetText("Chrono-Lord Epoch")
	CloseDropDownMenus()
end

function malganis()
	HideStuff()
	FontString1:SetText("Tank: |n |n Turn his away from the other players. He does a Swarm in a Frontal Cone.")
	FontString2:SetText("DPS: |n |n Stand behind the boss. Boss casts random Sleep; lasts 10 seconds. Dispell it if you can.")
	FontString3:SetText("Healer: |n |n Stand behind the boss. Use HOTs if you have them incase you are put to sleep fot 10 seconds. Dispell Sleep if able.")
	FontString8:SetText("Culling of Stratholme")
	FontString9:SetText("Mal'Ganis")
	CloseDropDownMenus()
end

function infinitecorruptor()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank.")
	FontString2:SetText("DPS: |n |n Tank and Spank.")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Culling of Stratholme")
	FontString9:SetText("Infinite Corrupter")
	CloseDropDownMenus()
end

-- Drak'Tharon Keep

function trollgore()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Adds will run in randomly. Shortly after they reach the boss he will explode them")
	FontString2:SetText("DPS: |n |n Tank and Spank. This is a DPS race. The longer this boss lives the harder he hits. Adds will explode, so stay away from them or quickly kill them.")
	FontString3:SetText("Healer: |n |n Tank and Spank. The longer the boss lives the harder he hits. Adds will explode and hurt anyone near the boss. Melee DPS may need extra heals.")
	FontString8:SetText("Drak'Tharon Keep")
	FontString9:SetText("Trollgore")
	CloseDropDownMenus()
end

function novosthesummoner()
	HideStuff()
	FontString1:SetText("Tank: |n |n Phase 1: Stand at the bottom of the stairs. Tank the 4 adds. |n Phase 2: Tank the boss. He randomly spawns add, make sure to pick them up. Dont stand in the Blizzard.")
	FontString2:SetText("DPS: |n |n Phase 1: One DPS goes halfway up the stairs to kill the adds. Dont go too far up or you might Line of Sight the healer. |n Phase 2: Dont stand in the Blizzard.")
	FontString3:SetText("Healer: |n |n Phase 1: Stand at the bottom the stairs. You should be able to reach Tank and DPS upstairs. |n Phase 2: Don't stand in the Blizzard")
	FontString8:SetText("Drak'Tharon Keep")
	FontString9:SetText("Novos the Summoner")
	CloseDropDownMenus()
end

function kingdred()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank with Fear. Pickup adds if boss calls them.")
	FontString2:SetText("DPS: |n |n Tank and Spank with Fear.")
	FontString3:SetText("Healer: |n |n This fight is healing intensive. When the boss casts Grievous Bite on the Tank; The tank must be healed to full(100%) to remove it.")
	FontString8:SetText("Drak'Tharon Keep")
	FontString9:SetText("King Dred")
	CloseDropDownMenus()
end

function theprophettharonja()
	HideStuff()
	FontString1:SetText("Tank: |n |n Phase 1: Tank and Spank. Avoid AoE poison. |n Phase 2: Put on Bone Armer(#3), Taunt boss every time it's up(#2), Attack(#1), Heal Yourself(#4).")
	FontString2:SetText("DPS: |n |n Phase 1: Tank and Spank. Avoid AoE poison. |n Phase 2: Do Not Press #2. Put on Bone Armer(#3), Attack(#1), Heal Yourself(#4).")
	FontString3:SetText("Healer: |n |n Phase 1: Tank and Spank. Avoid AoE poison. |n Phase 2: Do Not Press #2. Put on Bone Armer(#3), Attack(#1), Heal Yourself(#4).")
	FontString8:SetText("Drak'Tharon Keep")
	FontString9:SetText("The Prophet Tharon'ja")
	CloseDropDownMenus()
end

-- Forge of Souls

function bronjahn()
	HideStuff()
	FontString1:SetText("Tank: |n |n Phase 1: When Corrupted Soul Fragments spawn, pull the boss away from them. |n Phase 2: Tank and Spank in the middle")
	FontString2:SetText("DPS: |n |n Phase 1: If you are chosen to spawn the Corrupted Soul Fragments, run away from the boss. Once it spawns kill the fragment before it reaches the boss or it heals him. | Phase 2: Fight in the middle.")
	FontString3:SetText("Healer: |n |n Phase 1: Regular healing. |n Phase 2: Players that are feared out of the middle take lots of damage. Be ready with big heals. HOT yourself(if you can) in case you are feared.")
	FontString8:SetText("Forge of Souls")
	FontString9:SetText("Bronjahn")
	CloseDropDownMenus()
end

function devourerofsouls()
	HideStuff()
	FontString1:SetText("Tank: |n |n Face boss away from the group. When the boss jumps to a player, wait for it to come back to you to avoid standing in Purple Circles. Stop Damage on Mirrored Souls. Avoid Ghosts. Do not stand in front when he casts Wailing Souls(stay behind).")
	FontString2:SetText("DPS: |n |n If the boss jumps to you, run out of the Purple Circle. Stop DPS owhen he casts Mirrored Souls. Do NOT stand in front of him when he casts Wailing Souls(stay behind).")
	FontString3:SetText("Healer: |n |n If the boss jumps to you, run out of the Purple Circle. Extra heals on whoevers Soul he Mirrors. Do NOT stand in front of him when he casts Wailing Souls(stay behind).")
	FontString8:SetText("Forge of Souls")
	FontString9:SetText("Devourer of Souls")
	CloseDropDownMenus()
end

-- Gundrak

function sladran()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank him at the bottom of the stairs. Pickup snakes that come in from left and right.")
	FontString2:SetText("DPS: |n |n This is a DPS Race. After Tank pulls, run up on Bosses platform. Attack Snake Wraps that appear on party memebers. When the boss casts Poison Nova, try to Line of Sight yourself to avoid it.")
	FontString3:SetText("Healer: |n |n This is a Healing Intensive Fight. After Tank pulls, run up on Bosses platform. When the boss casts Poison Nova, try to Line of Sight yourself to avoid it.")
	FontString8:SetText("Gundrak")
	FontString9:SetText("Saladran")
	CloseDropDownMenus()
end

function drakkaricolossus()
	HideStuff()
	FontString1:SetText("Tank: |n |n This is a two part fight. When the Colossus reaches 50% an elemental appears. Fight the elemental to 50%, then back to the Colossus. Repeat. Don't stand in Purple Puddles.")
	FontString2:SetText("DPS: |n |n Allow the tank a moment to gain aggro on the Boss when it changes. Don't stand in the Purple Puddles.")
	FontString3:SetText("Healer: |n |n Don't stand in the Purple Puddles.")
	FontString8:SetText("Gundrak")
	FontString9:SetText("Drakkari Colossus")
	CloseDropDownMenus()
end

function moorabi()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Interrupt Transformation when he casts it.")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Gundrak")
	FontString9:SetText("Moorabi")
	CloseDropDownMenus()
end

function galdarah()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Undergeared Tanks should back out during Bosses Whirlwind. Tank him with your back to a wall to avoid knockback.")
	FontString2:SetText("DPS: |n |n Melee DPS should back out during Bosses Whirlwind.")
	FontString3:SetText("Healer: |n |n Tank and Melee DPS will need extra heals during the Bosses Whirlwind. Players who get hooked on the Bosses Horn will require extra healing. ")
	FontString8:SetText("Gundrak")
	FontString9:SetText("Galdarah")
	CloseDropDownMenus()
end

function ecktheferocious()
	HideStuff()
	FontString1:SetText("Tank: |n |n Turn Eck away from the party(unless going for the achievement). When he springs to another player he drops Aggro. Be ready with a Taunt to get him back.")
	FontString2:SetText("DPS: |n |n Tank and Spank.")
	FontString3:SetText("Healer: |n |n Tank and Spank. The player Eck springs to may need extra heals.")
	FontString8:SetText("Gundrak")
	FontString9:SetText("Eck the Ferocious")
	CloseDropDownMenus()
end

-- Halls of Lightning

function generalbjarngrim()
	HideStuff()
	FontString1:SetText("Tank: |n |n Boss does less damage if pulled when he doesnt have an electrical charge. Turn him away from the party.")
	FontString2:SetText("DPS: |n |n Kill adds first as they heal the boss. Melee DPS should back out during Whirlwind.")
	FontString3:SetText("Healer: |n |n Tank and Melee DPS will need extra heals during the bosses whirlwind.")
	FontString8:SetText("Halls of Lightning")
	FontString9:SetText("General Bjarngrim")
	CloseDropDownMenus()
end

function volkhan()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Hold adds if you can. Dont run after them though, they don't hit hard.")
	FontString2:SetText("DPS: |n |n Tank and Spank.")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Halls of Lightning")
	FontString9:SetText("Volkhan")
	CloseDropDownMenus()
end

function ionar()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank until 50%, when he split himself run away until he reforms. Then resume Tank and Spank.")
	FontString2:SetText("DPS: |n |n Tank and Spank until 50%, when he split himself run away until he reforms. Then resume Tank and Spank. If the boss casts Static Overload on you, distance yourself fromt he rest of the group till it ends.")
	FontString3:SetText("Healer: |n |n Tank and Spank until 50%, when he split himself run away until he reforms. Then resume Tank and Spank.")
	FontString8:SetText("Halls of Lightning")
	FontString9:SetText("Ionar")
	CloseDropDownMenus()
end

function loken()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Stay Close to Boss. For undergeared groups, run out when Boss casts Lightning Nova and then run back in right away.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Stay Close to Boss. For undergeared groups, run out when Boss casts Lightning Nova and then run back in right away.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Stay Close to Boss. For undergeared groups, run out when Boss casts Lightning Nova and then run back in right away.")
	FontString8:SetText("Halls of Lightning")
	FontString9:SetText("Loken")
	CloseDropDownMenus()
end

-- Halls of Reflections

function falric()
	HideStuff()
	FontString1:SetText("Tank: |n |n This boss is the 5th wave out of 10. Tank and Spank.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Dispell debuffs if you can.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Dispell debuffs if you can.")
	FontString8:SetText("Halls of Reflections")
	FontString9:SetText("Falric")
	CloseDropDownMenus()
end

function marwyn()
	HideStuff()
	FontString1:SetText("Tank: |n |n This boss is the 10th wave out of 10. Tank and Spank. Avoid the Well of Corruptions")
	FontString2:SetText("DPS: |n |n Tank and Spank. Avoid the Well of Corruptions")
	FontString3:SetText("Healer: |n |n Tank and Spank. Avoid the Well of Corruptions")
	FontString8:SetText("Halls of Reflections")
	FontString9:SetText("Marwyn")
	CloseDropDownMenus()
end

function thelichking()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Fight as close to the wall as you can.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Make sure the tank gets aggro on the mobs before firing")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Halls of Reflections")
	FontString9:SetText("The Lich King")
	CloseDropDownMenus()
end

--Halls of Stone

function maidenofgrief()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Don't stand in the Black Circles.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Don't stand in the Black Circles.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Don't stand in the Black Circles. ")
	FontString8:SetText("Halls of Stone")
	FontString9:SetText("Maiden of Grief")
	CloseDropDownMenus()
end

function krystallus()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Spread out to avoid damage during shatter.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Spread out to avoid damage during shatter.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Spread out to avoid damage during shatter.")
	FontString8:SetText("Halls of Stone")
	FontString9:SetText("Krystallus")
	CloseDropDownMenus()
end

function tribunalchest()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank the boss at the top of the stairs where the passage is narrow. Do not stand in the purple beam")
	FontString2:SetText("DPS: |n |n Do not stand in the purple beam.")
	FontString3:SetText("Healer: |n |n Do not stand in the purple beam.")
	FontString8:SetText("Halls of Stone")
	FontString9:SetText("Tribunal Chest")
	CloseDropDownMenus()
end

function sjonnirtheironshaper()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank the boss in the middle of the room or at the bottleneck of the hall. Try to pickup the adds.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Melee DPS may need to run out during Lightning Ring.")
	FontString3:SetText("Healer: |n |n Extra healing may be required during Lightning Ring.")
	FontString8:SetText("Halls of Stone")
	FontString9:SetText("Sjonnir the Ironshaper")
	CloseDropDownMenus()
end

-- Nexus

function grandmagustelestra()
	HideStuff()
	FontString1:SetText("Tank: |n |n At 50% (15% in Heroic mode) pickup 3 mirror images of boss.")
	FontString2:SetText("DPS: |n |n Tank and Spank.")
	FontString3:SetText("Healer: |n |n Extra healing may be required when she splits")
	FontString8:SetText("Nexus")
	FontString9:SetText("Grand Magus Telestra")
	CloseDropDownMenus()
end

function anomalus()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Kill chaotic rift at 50%.")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Nexus")
	FontString9:SetText("Anomalus")
	CloseDropDownMenus()
end

function ormorokthetreeshaper()
	HideStuff()
	FontString1:SetText("Tank: |n |n Move off glittering crystals before they erupt into spikes. ")
	FontString2:SetText("DPS: |n |n Tank and Spank. Spell DPS, watch out for Spell Reflect.")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Nexus")
	FontString9:SetText("Ormorok the Tree-Shaper")
	CloseDropDownMenus()
end

function keristrasza()
	HideStuff()
	FontString1:SetText("Tank: |n |n Jump or move to remove frost stacks. Position boss so no one else is the party is in front or behind the boss.")
	FontString2:SetText("DPS: |n |n Jump or move to remove frost stacks. Do not stand in front or behind the boss.")
	FontString3:SetText("Healer: |n |n Jump or move to remove frost stacks. Extra heals may be needed for party members who don't move to jump to remove stacks. at 25% the boss will enrage. Extra healing may be required.")
	FontString8:SetText("Nexus")
	FontString9:SetText("Keristrasza")
	CloseDropDownMenus()
end

function commanderstoutbeardkolurg()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank this boss away from your party. Be ready to pickup other mobs if a party member is feared into them.")
	FontString2:SetText("DPS: |n |n Dispell fear if you are able. Kill the healers first. Melee DPS should back out during whirlwind")
	FontString3:SetText("Healer: |n |n Tank and Melee DPS may need extra heals during whirlwind. Extra heals may be required if a party member is feared into another mob.")
	FontString8:SetText("Nexus")
	FontString9:SetText("Stoutbeard/Kolurg")
	CloseDropDownMenus()
end

-- Oculus

function drakostheinterrogator()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank.")
	FontString2:SetText("DPS: |n |n Tank and Spank.")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Oculus")
	FontString9:SetText("Drakos the Interrogator")
	CloseDropDownMenus()
end

function varoscloudstrider()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank the boss in the middle. Dont stand in the quarter of the circle with Purple Lasers.")
	FontString2:SetText("DPS: |n |n Dont stand in the quarter of the circle with Purple Lasers.")
	FontString3:SetText("Healer: |n |n Dont stand in the quarter of the circle with Purple Lasers.")
	FontString8:SetText("Oculus")
	FontString9:SetText("Varos Cloudstrider")
	CloseDropDownMenus()
end

function magelordurom()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank this boss out in the open, away from the Ranged DPS and Healer. Run behind a pillar when the Boss teleports to the middle")
	FontString2:SetText("DPS: |n |n Ranged DPS, stand behind the pillar when attacking. Melee DPS, run behind the pillar when the boss teleports to the middle.")
	FontString3:SetText("Healer: |n |n Tank and Melee DPS will require steady healing as the ground they stand on will turn to ice. Big heals will be required for anyone not hiding behind a pillar during the Bosses Arcane Explosion.")
	FontString8:SetText("Oculus")
	FontString9:SetText("Mage-Lord Urom")
	CloseDropDownMenus()
end

function leyguardianeregos()
	HideStuff()
	FontString1:SetText("Tank: |n |n Red Drake. Use Martyr everytime it is available to protect the other members of your party. Use Evasion to take less damage. Fly away from the boss while he is in a Planar Shift.")
	FontString2:SetText("DPS: |n |n Amber Drake. Channel Temporal Rift until you have 10 stacks on the boss. Then shoot Shock Lance. Use Stop Time when the Boss Enrages. Fly away from the boss while he is in a Planar Shift.")
	FontString3:SetText("Healer: |n |n Emerald Drake. Maintain 3 stacks of Leeching Poison on the boss to regenerate your health. Use Touch of Nighmare on the boss when you have lots of health. Use Dream Funnel on party memeber's drakes to heal them. Don't forget this drains your life.")
	FontString8:SetText("Oculus")
	FontString9:SetText("Ley-Guardian Eregos")
	CloseDropDownMenus()
end

--Pit of Saron

function forgemastergarfrost()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank the boss in the middle. At 66% and 33% the boss jumps to his forge, run behind the Boulder to remove the stacking debuff.")
	FontString2:SetText("DPS: |n |n Watch out for Boulders being thrown. At 66% and 33% the boss jumps to his forge, run behind the Boulder to remove the stacking debuff.")
	FontString3:SetText("Healer: |n |n Watch out for Boulders being thrown. At 66% and 33% the boss jumps to his forge, run behind the Boulder to remove the stacking debuff. Boulders cause Line of Sight.")
	FontString8:SetText("Pit of Saron")
	FontString9:SetText("Forgemaster Garfrost")
	CloseDropDownMenus()
end

function ickkrick()
	HideStuff()
	FontString1:SetText("Tank: |n |n Avoid green puddles. Run away from Arcane Orbs as they form. If Ick is chasing you, run away until he stops. Run away from the Boss when Poison Nova is cast.")
	FontString2:SetText("DPS: |n |n Avoid green puddles. Run away from Arcane Orbs as they form. If Ick is chasing you, run away until he stops. Run away from the Boss when Poison Nova is cast.")
	FontString3:SetText("Healer: |n |n Avoid green puddles. Run away from Arcane Orbs as they form. If Ick is chasing you, run away until he stops. Run away from the Boss when Poison Nova is cast.")
	FontString8:SetText("Pit of Saron")
	FontString9:SetText("Krick & Ick")
	CloseDropDownMenus()
end

function scourgelordtyrannus()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank the Boss near the ice patches on the ground. During Unholy Power, the Boss increases his damage bt 100% for 10 seconds. Kite him through the ice.")
	FontString2:SetText("DPS: |n |n Stop DPS when Overlord's Brand is active. Don't stand on the ice. If you are targeted for Hoarfrost, distance yourself from party members so it doesn't spread.")
	FontString3:SetText("Healer: |n |n Do not stand on the ice. If you are targeted for Hoarfrost, distance yourself from party members so it doesn't spread. Extra heals will be required for players affected by Hoarfrost.")
	FontString8:SetText("Pit of Saron")
	FontString9:SetText("Scourgelord Tyrannus")
	CloseDropDownMenus()
end

-- Trial of the Champion

function grandchampions()
	HideStuff()
	FontString1:SetText("Tank: |n |n Fight these bosses where they stand. Mokra(Warrior), Runok(Healer), Deathstalker(Rogue) are the hardest champions to face. Usually kill the healer first.")
	FontString2:SetText("DPS: |n |n All DPS should focus on the same target. Usually the healer need to die first.")
	FontString3:SetText("Healer: |n |n Cleanse poison if you are able. Very healing intensive")
	FontString8:SetText("Trial of the Champion")
	FontString9:SetText("Grand Champions")
	CloseDropDownMenus()
end

function eadricthepure()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Turn your back on his when he casts Radiance.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Turn your back on his when he casts Radiance.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Turn your back on his when he casts Radiance.")
	FontString8:SetText("Trial of the Champion")
	FontString9:SetText("Eadric the Pure")
	CloseDropDownMenus()
end

function argentconfessorpaletress()
	HideStuff()
	FontString1:SetText("Tank: |n |n At 25%, the Boss will summon a minion. Boss is immune until the minion is dead.")
	FontString2:SetText("DPS: |n |n At 25%, DPS down the Minion as fast as possible. Dispell fear if able.")
	FontString3:SetText("Healer: |n |n At 25%, the fight becomes very healing intensive. The Minion does a lot of damage and fears. Dispell fear if able.")
	FontString8:SetText("Trial of the Champion")
	FontString9:SetText("Argent Confessor Paletress")
	CloseDropDownMenus()
end

function theblackknight()
	HideStuff()
	FontString1:SetText("Tank: |n |n Phase 1: Tank and Spank. Try to hold the add. |n Phase 2: Tank and Spank the Boss. Try to hold all the adds. |n Phase 3: Tank and Spank.")
	FontString2:SetText("DPS: |n |n Phase 1: Tank and Spank. |n Phase 2: Tank and Spank the Boss. Groups with strong DPS and Healer can AoE down the adds and Boss, other shoudl focus on the boss. |n Phase 3: Tank and Spank. DPS race")
	FontString3:SetText("Healer: |n |n Phase 1: Tank and Spank. |n Phase 2: Be ready to heal yourself if your heals pull aggro on adds. |n Phase 3: Healing intensive phase. Everyone will be taking damage.")
	FontString8:SetText("Trial of the Champion")
	FontString9:SetText("The Black Knight")
	CloseDropDownMenus()
end

-- Utgarde Keep

function princekeleseth()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Pickup adds.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Break ice blocks(or not, for achievement).")
	FontString3:SetText("Healer: |n |n Tank and Spank. Player stuck in Ice Block will require extra heals.")
	FontString8:SetText("Utgarde Keep")
	FontString9:SetText("Prince Keleseth")
	CloseDropDownMenus()
end

function skarvalddalronn()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Hold both Bosses.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Kill one then the other(Most groups kill the caster first).")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Utgarde Keep")
	FontString9:SetText("Skarvald & Dalronn")
	CloseDropDownMenus()
end

function ingvartheplunderer()
	HideStuff()
	FontString1:SetText("Tank: |n |n Phase 1: Tank the Boss where he stands. Don't stand in front of the Boss when he casts Smash. \n Phase 2: Tank and Spank. Don't stand in the Spinning Shadow Axe.")
	FontString2:SetText("DPS: |n |n Phase 1: Tank and Spank. |n Phase 2: Tank and Spank. Melee DPS should run out on Dark Smash.")
	FontString3:SetText("Healer: |n |n Phase 1: Tank and Spank. |n Phase 2: Tank and Melee DPS will need extra heals after Dark Smash")
	FontString8:SetText("Utgarde Keep")
	FontString9:SetText("Ingvar the Plunderer")
	CloseDropDownMenus()
end

-- Utgarde Pinnacle

function svalasorrowgrave()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Kill adds when they appear to rescue party member.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Kill adds when they appear to rescue party member.")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Utgarde Pinnacle")
	FontString9:SetText("Svala Sorrowgrave")
	CloseDropDownMenus()
end

function gortokpalehoof()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. 4 MiniBosses and then the Main")
	FontString2:SetText("DPS: |n |n Tank and Spank. 4 MiniBosses and then the Main")
	FontString3:SetText("Healer: |n |n Tank and Spank. 4 MiniBosses and then the Main")
	FontString8:SetText("Utgarde Pinnacle")
	FontString9:SetText("Gortok Palehoof")
	CloseDropDownMenus()
end

function skaditheruthless()
	HideStuff()
	FontString1:SetText("Tank: |n |n Run halfway up the hall gathering adds. Once they are dead, run to the end for the rest. Avoid Frozen White Ground.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Pickup Harpoons that are dropped. When you get to the end, use Harpoons on launchers when you see the emote 'Grauf is within range of the harpoon launchers!'. Avoid Frozen White Ground. Run away from Boss when he spins.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Avoid Frozen White Ground. Run away from Boss when he spins.")
	FontString8:SetText("Utgarde Pinnacle")
	FontString9:SetText("Skadi the Ruthless")
	CloseDropDownMenus()
end

function kingymiron()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank.")
	FontString2:SetText("DPS: |n |n Tank and Spank.")
	FontString3:SetText("Healer: |n |n Tank and Spank.")
	FontString8:SetText("Utgarde Pinnacle")
	FontString9:SetText("King Ymiron")
	CloseDropDownMenus()
end

-- Violet Hold

function erekem()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Tank the Boss and adds where they appear.")
	FontString2:SetText("DPS: |n |n Tank and Spank")
	FontString3:SetText("Healer: |n |n Tank and Spank")
	FontString8:SetText("Violet Hold")
	FontString9:SetText("Erekem")
	CloseDropDownMenus()
end

function moragg()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Tank this boss where he appears")
	FontString2:SetText("DPS: |n |n Tank and Spank. Stop DPS when the Boss focuses on a party member.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Extra heals will be required for the person that the Boss Focuses on.")
	FontString8:SetText("Violet Hold")
	FontString9:SetText("Moragg")
	CloseDropDownMenus()
end

function ichoron()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank.")
	FontString2:SetText("DPS: |n |n Tank and Spank")
	FontString3:SetText("Healer: |n |n Tank and Spank")
	FontString8:SetText("Violet Hold")
	FontString9:SetText("Ichoron")
	CloseDropDownMenus()
end

function xevozz()
	HideStuff()
	FontString1:SetText("Tank: |n |n Kite this Boss around the back of the room. Kite him away from the Orbs. When teleported to an Orb, Run away and resume kiting.")
	FontString2:SetText("DPS: |n |n Follow the Boss and Tank around the room. When teleported to an Orb, Run away and resume DPS.")
	FontString3:SetText("Healer: |n |n Follow the Boss and Tank around the room. When teleported to an Orb, Run away and resume healing.")
	FontString8:SetText("Violet Hold")
	FontString9:SetText("Xevozz")
	CloseDropDownMenus()
end

function lavanthor()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Don't stand in fire.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Don't stand in fire.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Don't stand in fire.")
	FontString8:SetText("Violet Hold")
	FontString9:SetText("Lavanthor")
	CloseDropDownMenus()
end

function zuramattheobliterator()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank.")
	FontString2:SetText("DPS: |n |n Tank and Spank. DPS race.")
	FontString3:SetText("Healer: |n |n Tank and Spank. The longer this fight goes on, the more healing intensive it becomes.")
	FontString8:SetText("Violet Hold")
	FontString9:SetText("Zuramat the Obliterator")
	CloseDropDownMenus()
end

function cyanigosa()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Taunt Boss when teleported to the middle. Don't stand in the Blizzard")
	FontString2:SetText("DPS: |n |n Tank and Spank. Run out from Boss after teleported. Don't stand in the Blizzard.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Run out from Boss after teleported. Don't stand in the Blizzard.")
	FontString8:SetText("Violet Hold")
	FontString9:SetText("Cyanigosa")
	CloseDropDownMenus()
end

-- Output Functions To Party

-- The Old Kingdom

function eldernadoxparty()
	local msg = "This Boss is tanked where he stands. At 50% Boss will become immune. DPS down the Guardian to remove the Boss' Immunity. Healing draws aggro during immune phase."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function princetaldaramparty()
	local msg = "DPS him quickly when he is leeching on a party memeber. Extra heals are needed for leeched players and groups heals for fireballs."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg, "Party")
end

function jedogashadowseekerparty()
	local msg = "Tank and Spank. At 50% she calls for a volunteer sacrifice. If you do not kill the sacrifice before it reaches her, she will do 200% increased damage. Dont stand in AoE Lightning."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function heraldvolaziparty()
	local msg = "At 66% and 33% players will enter Insanity. you will have to fight copies of your party members. Healer cannot heal players during this phase so DPS the mobs quickly."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function amanitarparty()
	local msg = "Avoid/Kill green Poison Mushrooms. When the Boss casts Mini stand next to and Kill a Healthy Mushroom to remove debuff. Killing a Healthy Mushroom when you don't have the Mini debuff give you 100% increased damage."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Azjol-Nerub

function krikthirthegatewatcherparty()
	local msg = "3 waves with minibosses preceed this fight. Pull them one at a time. Break any Web Wraps that appear on your DPS or Healer. There is a lot of poison during the three waves; it is helping if you can dispell. Tank and Spank the Boss."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function hadronoxparty()
	local msg = "Tank him after he as killed his adds. Don't stand in the Green Poison Cloud. Cleansing poison will help to reduce the amount of healing required."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function anubarakparty()
	local msg = "Make sure all players are in the circle before starting. DPS and Healer should stand behind or away from the Boss to avoid the Pound. Sand Clouds on t he ground are quickly followed by spikes. Cleansing poison helps ther healer."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Culling of Stratholme

function meathookparty()
	local msg = "Tank and Spank."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function salrammthefleshcrafterparty()
	local msg = "Tank and Spank with Adds. Either ignore the adds and the healer can use a group heal to recover after they explode; or kill the Adds before they explode."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function chronolordepochparty()
	local msg = "This boss will run around randomly and attack players but returns to the tank afterwards. During Time Warp, the boss will hit one player 3 times in quick succession. Healer will need to be ready with quick heals for that person."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function malganisparty()
	local msg = "Tank should turn the Boss away from party memebers. This Boss casts Sleep. HOT's are useful incase the healer is put to Sleep."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function infinitecorruptorparty()
	local msg = "Tank and Spank."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Drak'Tharon Keep

function trollgoreparty()
	local msg = "DPS race. The longer this boss lives the harder he hits. DPS should stay away fromt he top of the stairs as the adds that run down are exploded by the Boss."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function novosthesummonerparty()
	local msg = "Phase1: Tank should stand at the bottom of the stairs with the Healer. One DPS can up half way up the stairs to fight the Adds. Tank picks up the Summoned Adds. Phase 2: Fight the boss. Dont stand in the Blizzard."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function kingdredparty()
	local msg = "Tank and Spank with Fear. Healers should also note that when the Tank receives a Grevous Bite; the Tank must be healed to full (100%) to remove it."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function theprophettharonjaparty()
	local msg = "Phase 1: Tank and Spank. Avoid Poison Clouds. Phase 2: Tanks use Bone Armor #3, and Taunt #2 everytime they are available. DPS and Healer use Bone Armor #3, Attack #1 and Heal #4 everytime they are available."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Forge of Souls

function bronjahnparty()
	local msg = "Phase 1: Whoever is chosen by the Boss to spawn the Corrupted soul should run away from the Boss. The Tank should also kite the Boss away from the fragment. DPS must kill the fragment before it reaches the boss. Phase 2: Fight in the middle."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function devourerofsoulsparty()
	local msg = "Tank should face this boss away from the party. If the Boss jumps to you, run out the purple well. Stop DPS whent he boss casts Mirrored Soul on another player. Do not stand in front of the Boss when he casts Wailing Souls."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Gundrak

function sladranparty()
	local msg = "This is a DPS race. Run out or Line of Sight yourself from Poison Nova. Kill Snake Wraps to free your party members. Tank shoudl try to hold adds but focus should stay on burning the Boss"
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function drakkaricolossusparty()
	local msg = "This fight involves going back and forth between the Colossus and the Elemental. Tank should pickup the other one when they change. Don't stand in Purple Puddles."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function moorabiparty()
	local msg = "Tank and Spank. If able, Tank and DPS should try to inturrupt the Transformation."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function galdarahparty()
	local msg = "DPS and undergeared Tanks should backout during the Bosses Whirlwind. Players who get speared by the Bosses Horn need extra heals. Healers shoudl keep their own health high incase they are Speared."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function ecktheferociousparty()
	local msg = "Eck should be turned away from party members. Tank will need to Taunt the boss after he jumps to another player. Otherwise Tank and Spank."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Halls of Lightning

function generalbjarngrimparty()
	local msg = "Boss does less damage if pulled without the electrical charge. Boss should be turned away from the party. Kill the Adds first as they heal the Boss. Melee DPS wil need to backout during Bosses Whirlwind."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function volkhanparty()
	local msg = "Tank and Spank. Ignore the Adds"
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function ionarparty()
	local msg = "Tank and Spank until 50%. At 50% the Boss splits himself into sparks. Run away fromt he sparks until they reform into the Boss (about 10 seconds). Then Tank and Spank."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function lokenparty()
	local msg = "Tank and Spank. Stay close to the Boss to avoid massive damage. Big heals will be needed after the Lightning Nova. Undergeared groups should run out during the Lightning Nova and then quickly get back in."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Halls of Reflections

function falricparty()
	local msg = "This is the 5th wave of 10. Tank and Spank. Dispell debuffs."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function marwynparty()
	local msg = "This is the 10th wave of 10. Tank and Spank. Avoid the Wells of Corruption."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function thelichkingparty()
	local msg = "Tank and Spank. Fight as close to the wall as you can."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

--Halls of Stone

function maidenofgriefparty()
	local msg = "Tank and Spank. Don't stand in the Black Circles."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function krystallusparty()
	local msg = " Tank and Spank. Spread out to avoid damage during shatter."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function tribunalchestparty()
	local msg = "Tank thr waves at the top of the stairs. Do not stand in the Purple Beams."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function sjonnirtheironshaperparty()
	local msg = " Tank the Boss in the hallway. Melle DPS may need to run out during the Lightning Ring."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Nexus

function grandmagustelestraparty()
	local msg = "At 50% (15% in Heroic) 3 mirror images will spawn. Tank and Spank them down."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function anomalusparty()
	local msg = "Tank and Spank. Kill the Chaotic Rift at 50%"
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function ormorokthetreeshaperparty()
	local msg = " Move off the Glittering Crystals before they erupt into spikes. Tank and Spank. Spellcaster DPS should watch out for Spell Reflect."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function keristraszaparty()
	local msg = "Jump of Move to remove the frost debuff. Only tank shoudl be in front of Boss. No one should be behind the Boss."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function commanderstoutbeardkolurgparty()
	local msg = "Takn the Boss away from other mobs and away from party members. This Boss fears. Melee DPS should back out during Whirlwind."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Oculus

function drakostheinterrogatorparty()
	local msg = "Tank and Spank."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function varoscloudstriderparty()
	local msg = "Tank the Boss in the middle. Don't stand in the quarter of the platform with the Purple Lasers."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function magelorduromparty()
	local msg = "Tank this Boss where he stands. When he teleports to the middle, Line of Sight yourself behind a column."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function leyguardianeregosparty()
	local msg = "Red Drake: Use Martyr when available. Use evasion to lessen damage. Amber Drake: Channel Temporal Rift to 10 stacks then use Shock Lance. Emerald Drake: Stack leech poison to gain your health. Funnel health to other drakes to heal them. "
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

--Pit of Saron

function forgemastergarfrostparty()
	local msg = "At 66% and 33% when the Boss jumps to the forge. Hide behind a boulder to remove your stacking debuff."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function ickkrickparty()
	local msg = "Avoid Green Puddles. Runa way from Arcane Orbs when they form. If Ick is chasing you, run away until he stops. Run away from Poison Nova."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function scourgelordtyrannusparty()
	local msg = "Tank Boss near the Ice Patches. Kite Boss over the Ice during the Unholy Power. Stop DPS when Overlord's Brand is active. If you are targeted for Hoarfrost, run away from everyone."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Trial of the Champion

function grandchampionsparty()
	local msg = "All DPS should focus on the same target. The healer should usually be killed first."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function eadricthepureparty()
	local msg = "Tank and Spank. Turn your back on the Boss when he casts Radiance."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function argentconfessorpaletressparty()
	local msg = " At 25% the Boss will summon a minion. The minions does a lot of damage and fears."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function theblackknightparty()
	local msg = "Phase 1: Tank and Spank. Phase 2: Tank and Spank the Boss. Tank and try and hold the Adds. Phase 3: Tanks and Spank. DPS Race. "
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Utgarde Keep

function princekelesethparty()
	local msg = "Tank and Spank. Tank should pickup Adds."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function skarvalddalronnparty()
	local msg = "Tank and Spank."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function ingvartheplundererparty()
	local msg = "Phase 1: Tank the Boss where he stands. Strafe sideways during Smash. Phase 2: Tank and Spank. Don't stand in the Spinning Shadow Axe."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Utgarde Pinnacle

function svalasorrowgraveparty()
	local msg = "Tank and Spank. Kill Adds to rescue party members."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function gortokpalehoofparty()
	local msg = "Tank and Spank. 4 MiniBosses and Main Boss."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function skaditheruthlessparty()
local msg = "Gather Adds as you run up the hall. One person should pickup the harpoons to shoot in the Launchers when the Boss is in range. Don't stand on the Frozen Ground. "
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function kingymironparty()
	local msg = "Tank and Spank."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

-- Violet Hold

function erekemparty()
	local msg = "Tank and Spank. Boss and Adds."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function moraggparty()
	local msg = "Tank and Spank. Stop DPS when a player is focused."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function ichoronparty()
	local msg = "Tank and Spank."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function xevozzparty()
	local msg = "Kite the Boss away from the Orbs. When you get teleported to the Orbs. Regroup and continue Kiting."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function lavanthorparty()
	local msg = "Tank and Spank. Don't stand in the fire."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function zuramattheobliteratorparty()
	local msg = "Tank and Spank. DPS Race."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

function cyanigosaparty()
	local msg = "Tank and Spank. Tank should Taunt Boss after teleport. Don't stand in the Blizzard."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end

--Boss Info Menu Cataclysm

local BossInfoMenuCat = CreateFrame("Frame", "BossInfoMenuCat")
BossInfoMenuCat:SetPoint("CENTER", 19, -20) 
BossInfoMenuCat.displayMode = "MENU"
BossInfoMenuCat.info = {}
BossInfoMenuCat.UncheckHack = function(dropdownbutton)
    _G[dropdownbutton:GetName().."Check"]:Hide()
end
BossInfoMenuCat.HideMenu = function()
    if UIDROPDOWNMENU_OPEN_MENU == BossInfoMenuCat then
        CloseDropDownMenus()
    end
end


-- Main Menu
BossInfoMenuCat.initialize = function(self, level)
    if not level then return end
    local info = self.info
    wipe(info)
    if level == 1 then
        info.isTitle = 1
        info.text = "Instance"
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)

        info.keepShownOnClick = 1
        info.disabled = nil
        info.isTitle = nil
        info.notCheckable = 1

        info.text = "Blackrock Caverns"
        info.func = self.UncheckHack
        info.hasArrow = 1
        info.value = "catsubmenu1"
        UIDropDownMenu_AddButton(info, level)

        info.text = "Deadmines"
        info.value = "catsubmenu2"
        UIDropDownMenu_AddButton(info, level)
		
		--info.text = "Firelands"
        --info.value = "catsubmenu3"
        --UIDropDownMenu_AddButton(info, level)
		
		info.text = "Grim Batol"
        info.value = "catsubmenu4"
        UIDropDownMenu_AddButton(info, level)

		info.text = "Halls of Origination"
        info.value = "catsubmenu5"
        UIDropDownMenu_AddButton(info, level)

		info.text = "Lost City of the Tol'vir"
        info.value = "catsubmenu6"
        UIDropDownMenu_AddButton(info, level)

		info.text = "Shadowfang Keep"
        info.value = "catsubmenu7"
        UIDropDownMenu_AddButton(info, level)

		info.text = "Stonecore"
        info.value = "catsubmenu8"
        UIDropDownMenu_AddButton(info, level)

		info.text = "Throne of the Tides"
        info.value = "catsubmenu9"
        UIDropDownMenu_AddButton(info, level)
		
		info.text = "Vortex Pinnacle"
        info.value = "catsubmenu10"
        UIDropDownMenu_AddButton(info, level)
		
        -- Close menu item
        info.hasArrow     = nil
        info.value        = nil
        info.notCheckable = 1
        info.text         = CLOSE
        info.func         = self.HideMenu
        UIDropDownMenu_AddButton(info, level)
		
    elseif level == 2 then
        if UIDROPDOWNMENU_MENU_VALUE == "catsubmenu1" then
            info.text = "Rom'ogg Bonecrusher"
			info.func = romoggbonecrusher
            UIDropDownMenu_AddButton(info, level)

            info.text = "Corla, Herald of Twilight"
			info.func = corlaheraldoftwilight
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Karsh Steelbender"
			info.func = karshsteelbender
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Beauty"
			info.func = beauty
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Ascendant Lord Obsidius"
			info.func = ascendantlordobsidius
            UIDropDownMenu_AddButton(info, level)

        elseif UIDROPDOWNMENU_MENU_VALUE == "catsubmenu2" then
            info.text = "Glubtok"
			info.func = glubtok
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Helix Gearbreaker"
			info.func = helixgearbreaker			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Foe Reaper 5000"
			info.func = foereaper5000			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Admiral Ripsnarl"
			info.func = admiralripsnarl
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Captain Cookie"
			info.func = captaincookie
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Vanessa VanCleef (Heroic)"
			info.func = vanessavancleef		
            UIDropDownMenu_AddButton(info, level)

		--elseif UIDROPDOWNMENU_MENU_VALUE == "catsubmenu3" then
            --info.text = "Nothing Yet"
			--info.func = nothingyet
            --UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "catsubmenu4" then
            info.text = "General Umbriss"
			info.func = generalumbriss			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Forgemaster Throngus"
			info.func = forgemasterthrongus			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Drahga Shadowburner"
			info.func = drahgashadowburner			
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Erudax"
			info.func = erudax
			UIDropDownMenu_AddButton(info, level)

		elseif UIDROPDOWNMENU_MENU_VALUE == "catsubmenu5" then
            info.text = "Temple Guardian Anhuur"
			info.func = templeguardiananhuur			
            UIDropDownMenu_AddButton(info, level)

            info.text = "Earthrager Ptah"
			info.func = earthragerptah
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Anraphet"
			info.func = anraphet
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Isiset"
			info.func = isiset
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Ammunae"
			info.func = ammunae
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Setesh"
			info.func = setesh
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Rajh"
			info.func = rajh
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "catsubmenu6" then
            info.text = "General Husam"
			info.func = generalhusam			
            UIDropDownMenu_AddButton(info, level)

            info.text = "High Prophet Barim"
			info.func = highprophetbarim			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Lockmaw & Augh"
			info.func = lockmawaugh	
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Siamat"
			info.func = siamat
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "catsubmenu7" then

            info.text = "Baron Ashbury"
			info.func = baronashbury
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Baron Silverlaine"
			info.func = baronsilverlaine
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Commander Springvale"
			info.func = commanderspringvale
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Lord Walden"
			info.func = lordwalden
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Lord Godfrey"
			info.func = lordgodfrey
            UIDropDownMenu_AddButton(info, level)

		elseif UIDROPDOWNMENU_MENU_VALUE == "catsubmenu8" then
            info.text = "Corborus"
			info.func = corborus
            UIDropDownMenu_AddButton(info, level)

            info.text = "Slabhide"
			info.func = slabhide		
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Ozruk"
			info.func = ozruk
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "High Priestess Azil"
			info.func = highpriestessazil
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "catsubmenu9" then
            info.text = "Lady Naz'jar"
			info.func = ladynazjar		
            UIDropDownMenu_AddButton(info, level)

            info.text = "Commander Ulthok"
			info.func = commanderulthok	
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Erunak Stonespeaker & Mindbender Ghur'sha"
			info.func = stonespeakerghursha
            UIDropDownMenu_AddButton(info, level)
			
			info.text = "Ozumat"
			info.func = ozumat
            UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "catsubmenu10" then
            info.text = "Grand Vizier Ertan"
			info.func = grandvizierertan		
            UIDropDownMenu_AddButton(info, level)

            info.text = "Altairus"
			info.func = altairus			
            UIDropDownMenu_AddButton(info, level)
			
            info.text = "Asaad"
			info.func = asaad
            UIDropDownMenu_AddButton(info, level)
		end
		
    end
end

function romoggbonecrusher()
	HideStuff()
	FontString1:SetText("Tank: |n |n Move out the AoE dust clouds 'Quake'. Adds will appear after the Quake; pick them up. A well geared tank can hold the adds until the Skullcracker. At 66% and 33%, everyone is pulled to the middle and chained. The boss will cast an AoE 'Skullcracker'. Kill the chains and move away to avoid the Skullcracker. The Skullcracker will kill the adds if they are close to the Boss. Trapping or Rooting them there will ensure they die.")
	FontString2:SetText("DPS: |n |n Move out of the AoE dust clouds 'Quake'. Adds will appear after the quake. A well geared group can allow the adds to beat on the tank until the Skullcracker. At 66% and 33%, everyone is pulled to the middle and chained. The boss will cast an AoE 'Skullcracker'. Kill the chains and move away to avoid the Skullcracker. The Skullcracker will kill the adds if they are close to the Boss. Trapping or Rooting them there will ensure they die.")
	FontString3:SetText("Healer: |n |n Move out the the AoE dust clouds 'Quake' If the DPS doesnt take down the adds that spawn from the quakes; be ready to cast additional heals on the tank. At 66% and 33%, every is pulled to the middle and chained. Group heals will be needed until the DPS can break the chains. Run out when the chains are dead.")
	FontString8:SetText("Blackrock Caverns")
	FontString9:SetText("Rom'ogg Bonecrusher")
	CloseDropDownMenus()
end

function corlaheraldoftwilight()
	HideStuff()
	FontString1:SetText("Tank: |n |n The Boss can be tanked where she stands unless a melee DPS is needed in a beam in which case the Boss needs to be tanked closer so they can reach. Interrupt the Bosses fear when she casts 'Dark Command'.")
	FontString2:SetText("DPS: |n |n A beam will hit the 3 Zealots. DPS will need to stand in front of the beams to stop the Zealots from becoming active. When you get to 80-85 stacks step out of the beam and let the debuff wear off; then repeat the process. If the DPS get to 100 stacks, they will become mind controlled. If the Zealots reach 100 stacks they become active. This Boss fears if it is not interrupted. There are only 2 Zealots in Regular.")
	FontString3:SetText("Healer: |n |n Healing is pretty easy on this fight. Be sure to disspell fear 'Dark Command'.")
	FontString8:SetText("Blackrock Caverns")
	FontString9:SetText("Corla, Herald of Twilight")
	CloseDropDownMenus()
end
			
function karshsteelbender()
	HideStuff()
	FontString1:SetText("Tank: |n |n This Bosses armor reduces the damage he takes by 99%. To remove his armor; move him into the forge to shatter his armor. When he is in the forge, he does a deadly AoE fire damage to all players and hits the Tank harder. You will need to kite him in the forge to remove his armor and then back out (He has a long tail. Make sure he is out!). The Boss should be dragged back through the forge before his debuff wears off or adds will spawn.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Boss starts with armor that reduces damage taken by 99%. When the tank takes the Boss into the forge he will take more damage. DPS the boss down as the tank kites the Boss.")
	FontString3:SetText("Healer: |n |n Boss starts with armor that reduces damage taken by 99%. When the Tank has the Boss in the forge, the Tank will take increased damage. Additionally, when the Boss is in the forge, everyone will be hit with massive AoE fire damage. You will need to do group heals on top of the extra healing for the tank. If the Bosses debuff wears off, Adds will spawn. Extra healing will be needed.")
	FontString8:SetText("Blackrock Caverns")
	FontString9:SetText("Karsh Steelbender")
	CloseDropDownMenus()
end
			
function beauty()
	HideStuff()
	FontString1:SetText("Tank: |n |n Kite the Boss to stay out of the fire pools on the ground. If CC is unavailable, you will need to hold the Boss and the Adds. Adds should be killed first. Cooldowns should be used to burn them down as quickly as possible. This Boss also fears so use fear ward and tremor totem.")
	FontString2:SetText("DPS: |n |n You will want to CC as many of the smaller dogs as possible. Stay out of the fire pools on the ground. Adds should be killed first. Cooldowns should be used to burn them down as quickly as possible.  This Boss also fears so use fear ward and tremor totem")
	FontString3:SetText("Healer: |n |n If no CC is available, the Tank will require a lot of healing. Stay out of the fire pools on the ground. This Boss also fears so use fear ward and tremor totem ")
	FontString8:SetText("Blackrock Caverns")
	FontString9:SetText("Beauty")
	CloseDropDownMenus()
end
			
function ascendantlordobsidius()
	HideStuff()
	FontString1:SetText("Tank: |n |n The Adds apply a healing debuff, reducing the healing of whoever is near them by 99%. When the tank engages the Boss, a dps should pull off both Adds and kite them (away from other party members). Periodically, the Boss will switch bodies with one of the adds. Pickup all three and the DPS can pull of the Adds again.")
	FontString2:SetText("DPS: |n |n The Adds apply a healing debuff, reducing the healing of whoever is near them by 99%. When the Tank engages the Boss, a DPS should pull off the Adds and hold/kite them (away from other party members). Periodically, the Boss will switch bodies with one of the adds. When the Tank picks them all up, A ranged DPS should hold/kite the adds again.")
	FontString3:SetText("Healer: |n |n The Adds apply a healing debuff, reducing the healing of whoever is near them by 99%. The DPS that is kiting the Adds will only be able to be healed when they get far enough away from the Adds. Don't waste mana if they are too close.")
	FontString8:SetText("Blackrock Caverns")
	FontString9:SetText("Ascendant Lord Obsidius")
	CloseDropDownMenus()
end
			
function glubtok()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank untill 50%. At 50% he becomes untankable. Avoid the rotating Wall of Fire. Pickup Adds. Don't stand in Blue Circles. Stay on the same side of the Flamewall as the Healer to pickup Adds off them.")
	FontString2:SetText("DPS: |n |n Don't stand in the Blue spots on the ground. At 50% avoid the rotating Wall of Flame. Ignore Adds. Focus on Boss")
	FontString3:SetText("Healer: |n |n Don't stand in the Blue spots on the ground. Avoid the Flamewall. When the Flamewall is being cast, try to stay ont he same side of the wall as the Tank so they adds can be picked up off of you without running through the wall.")
	FontString8:SetText("Deadmines")
	FontString9:SetText("Glubtok")
	CloseDropDownMenus()
end

function helixgearbreaker()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Avoid Bombs. When Olaf is dead, kill the Goblin. Do not stand on the middle path where the Boss charges.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Avoid Bombs. If a bomb is placed on you run away from the party. Do not stand on the middle path where the Boss charges.")
	FontString3:SetText("Healer: |n |n Avoid Bombs. Boss will randomly pickup a player and charge the wall. This player will need extra heals. Do not stand on the middle path where the Boss charges.")
	FontString8:SetText("Deadmines")
	FontString9:SetText("Helix Gearbreaker")
	CloseDropDownMenus()
end			
			
function foereaper5000()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank this Boss at the top of the Ramp. One DPS will use the vehicle to kill the Elementals at the bottom. Avoid Whirlwind. Run away if you are targeted for Harvest.")
	FontString2:SetText("DPS: |n |n One DPS should mount the vehicle. Use the Vehicle to kill the Fire Elementals at the bottom. Other DPS should focus on the Boss at the top of the ramp. Run away if you are targeted for Harvest.")
	FontString3:SetText("Healer: |n |n Healer should go with Tank and remaining DPS to the top of the ramp to fight the Boss. At low health the Boss enrages. Extra heals will be needed at this time. Run away if you are targeted for Harvest.")
	FontString8:SetText("Deadmines")
	FontString9:SetText("Foe Reaper 5000")
	CloseDropDownMenus()
end		

function admiralripsnarl()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Kill Vapors till 20%. At 20% an unremovable debuff is placed on all party memeber that will quickly kill them. Ignore Vapors it's now a DPS Race.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Kill Vapors till 20%. At 20% an unremovable debuff is placed on all party memeber that will quickly kill them. Ignore Vapors it's now a DPS Race.")
	FontString3:SetText("Healer: |n |n Tank and Spank. At 20% it's a DPS Race. Try to keep everyone alive.")
	FontString8:SetText("Deadmines")
	FontString9:SetText("Admiral Ripsnarl")
	CloseDropDownMenus()
end	
			
function captaincookie()
	HideStuff()
	FontString1:SetText("Tank: |n |n This Boss is not Tankable. Eat the food on the ground to increase your haste. Rotten Food stacks a DOT on you.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Eat the food on the ground to increase your haste. Rotten Food stacks a DOT on you.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Eat the food on the ground to increase your haste. Rotten Food stacks a DOT on you.")
	FontString8:SetText("Deadmines")
	FontString9:SetText("Captain Cookie")
	CloseDropDownMenus()
end
			
function vanessavancleef()
	HideStuff()
	FontString1:SetText("Tank: |n |n Glubtok's Nightmare: Avoid Icicles and Fire. Helix's Nightmare: Tank hold Spiders. Burn Boss. |n Foe Reaver's Nightmare: Reaver's Nightmare: Avoid rotating electricity. Kill Boss. Ripsnarl's Nightmare: Protect the family. Use taunt to maintain aggro. Vanessa: Fight Boss and her Adds. Click on rope to abandon ship.")
	FontString2:SetText("DPS: |n |n Glubtok's Nightmare: Avoid Icicles and Fire. Helix's Nightmare: Tank hold Spiders. Burn Boss. |n Foe Reaver's Nightmare: Reaver's Nightmare: Avoid rotating electricity. Kill Boss. Ripsnarl's Nightmare: Protect the family. Vanessa: Fight Boss and her Adds. Click on rope to abandon ship.")
	FontString3:SetText("Healer: |n |n Glubtok's Nightmare: Avoid Icicles and Fire. Helix's Nightmare: Tank hold Spiders. Burn Boss. |n Foe Reaver's Nightmare: Avoid rotating electricity. Kill Boss. Ripsnarl's Nightmare: Protect the family. The family can be healed. Vanessa: Fight Boss and her Adds. Click on rope to abandon ship.")
	FontString8:SetText("Deadmines")
	FontString9:SetText("Vanessa VanCleef")
	CloseDropDownMenus()
end		
			
function nothingyet()
	HideStuff()
	FontString1:SetText('')
	FontString2:SetText('Cannot Find Boss Info For This Instance Yet')
	FontString3:SetText('')
	FontString8:SetText("Boss Info")
	FontString9:SetText("Written By Nerino1")
	CloseDropDownMenus()
end	

function generalumbriss()
	HideStuff()
	FontString1:SetText("Tank: |n |n Regular: Tank Boss. Pickup Adds. Boss enrages at 30%. |n Heroic: Tank Boss. Pickup normal Adds. DPS must CC purple Adds (Malignant Trogg). If CC is not available the Purple Add must be stunned and kited away from the party and the Boss and killed by a DPS. Boss engages at 30%.")
	FontString2:SetText("DPS: |n |n Regular: DPS Boss. 'General Umbriss targets X for blitz!' If he is targeting you, side step away to avoid 30k damage. |n Heroic: DPS must CC purple Adds (Malignant Trogg). If CC is not available the Purple Add must be stunned and kited away from the party and the Boss and killed by a DPS.")
	FontString3:SetText("Healer: |n |n Regular: Players to fail to avoid the 'Blitz' will need extra Heals. At 30% the Boss will enrage, the Tank will need extra heals. |n Heroic: DPS who kites away the purple (Malignant Trogg) will need extra heals when it dies as it applys a debuff. Players who fail to avoid the Blitz will require extra healing. Extra healing on the Tank is required during 'Bleeding Wound'")
	FontString8:SetText("Grim Batol")
	FontString9:SetText("General Umbriss")
	CloseDropDownMenus()
end			

function forgemasterthrongus()
	HideStuff()
	FontString1:SetText("Tank: |n |n Mace Phase: Kite the Boss. Stay out of Melee range. |n Shield Phase: Get behind the Boss. |n Sword Phase: Massive damage is taken in this phase. You may need to pop cooldowns to help the Healer.")
	FontString2:SetText("DPS: |n |n Mace Phase: Stay out of Melee range. |n Shield Phase: Stay behind the Boss to avoid the cleave. |n Sword Phase: DPS Normally." )
	FontString3:SetText("Healer: |n |n Mace Phase: Massive damage is dealt to those in Melee range. |n Shield Phase: Group healing is required. |n Sword Phase: Massive damage is dealt to the Tank. Save cooldowns for this part.")
	FontString8:SetText("Grim Batol")
	FontString9:SetText("Forgemaster Throngus")
	CloseDropDownMenus()
end			
			
function drahgashadowburner()
	HideStuff()
	FontString1:SetText("Tank: |n |n Face this Boss away from your party. When an elemental spawns if targets and charges a player. This playr must run away as the rest of the group kills it. If the Elemental reaches it target it explodes doing lots of damage to everyone around it.")
	FontString2:SetText("DPS: |n |n DPS should kill the Fire Elementals before they reach their target or else they will do massive AoE damage. If the elemental is targeting you, run away. Stand behind the boss.")
	FontString3:SetText("Healer: |n |n If a player fails to out run a Fire Elemental they and whoever is around them will take lots of damage. At 30%, the Boss begins randomly attacking party members who will need heals. ")
	FontString8:SetText("Grim Batol")
	FontString9:SetText("Drahga Shadowburner")
	CloseDropDownMenus()
end			
			
function erudax()
	HideStuff()
	FontString1:SetText("Tank: |n |n When you are hit with 'Enfeebling Blow' and knocked back, try to stay away from the Boss until your debuff wears off. When the Boss casts 'Shadow Gale', run to the center of the gale to avoid being killed. Boss will summon hatchers after the Shadow Gale who must be killed and slowed.")
	FontString2:SetText("DPS: |n |n When the Boss casts 'Shadow Gale', run to the center of the gale to avoid being killed. After the Shadow Gale the Boss will summon hatchers who must be killed and slowed or they will hatch eggs that release Whelps that do massive damage.")
	FontString3:SetText("Healer: |n |n When the Boss casts 'Shadow Gale', run to the center of the gale to avoid being killed. If a player is rooted when Shadow Gale is cast, they will require extra heals to stay alive. If the Whelps are permitted to be hatched, they will be massive damage to all party members.")
	FontString8:SetText("Grim Batol")
	FontString9:SetText("Erudax")
	CloseDropDownMenus()
end
			
function templeguardiananhuur()
	HideStuff()
	FontString1:SetText("Tank: |n |n Boss will cast Shield of Light that will make him immune to damage. A dps needs to drop off each side to hit the switches on the floor then run back up top. In Heroic, the Tank may need to drop down as well and gather up the snakes to allow the DPS to cast thwe switches. Tank will need to pick up the snake adds they will bring up with them")
	FontString2:SetText("DPS: |n |n One DPS will need to jump off each side (two dps total, one to the left and another to the right) to hit the switches when the boss casts Shield of Light. An AoE or ranged dps should stay up top to try and agro the snakes on the floor back to the tank.")
	FontString3:SetText("Healer: |n |n Stay up top, you will need to heal the dps that jump down to hit the switches. Because of Line of Sight, you will need to stand on the edge of the bridge to be able to reach the DPS on either side.")
	FontString8:SetText("Halls of Origination")
	FontString9:SetText("Temple Guardian Anhuur")
	CloseDropDownMenus()
end			

function earthragerptah()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank needs to turn the boss away from everyone. Do not stand in spikes, swirls, tornadoes, or anything on the ground. At 50% he will collapse and summon adds.  Be ready to move a lot and get agro of all adds.")
	FontString2:SetText("DPS: |n |n Do not stand in spikes, swirls, tornadoes, or anything on the ground.  Be ready to move a lot.  At 50% burn down/AoE the adds.")
	FontString3:SetText("Healer: |n |n Do not stand in spikes, swirls, tornadoes, or anything on the ground.  Be ready to move a lot.")
	FontString8:SetText("Halls of Origination")
	FontString9:SetText("Earthrager Ptah")
	CloseDropDownMenus()
end
			
function anraphet()
	HideStuff()
	FontString1:SetText("Tank: |n |n Avoid the Alpha Beam when cast. Omega Beams is unavoidable, fight through it.")
	FontString2:SetText("DPS: |n |n Avoid the Alpha Beam (Purple Circle). Omega Beam is unavoidable, fight through it.")
	FontString3:SetText("Healer: |n |n When he casts Nemesis Strike on the tank, dispell it. Step out of Alpha Beam (Purple Circle).  Extra AoE heals will be needed though the Omega Beam.")
	FontString8:SetText("Halls of Origination")
	FontString9:SetText("Anraphet")
	CloseDropDownMenus()
end
			
function isiset()
	HideStuff()
	FontString1:SetText("Tank: |n |n Beam will follow someone, avoid it and try keeping away from other party members. Face away when she casts supernova. At 67% she splits into three abilities, kill one and she fuses back. At 33% she splits into the remaining 2 abilities. They need to be killed in this order, Astral Rain, Celestial Call, Veil of Sky.")
	FontString2:SetText("DPS: |n |n Beam will follow someone, avoid it and try keeping away from other party members. Face away when she casts supernova. At 67% she splits into three abilities, kill one and she fuses back. At 33% she splits into the remaining 2 abilities. They need to be killed in this order, Astral Rain, Celestial Call, Veil of Sky.")
	FontString3:SetText("Healer: |n |n Beam will follow someone, avoid it and try keeping away from other party members. Face away when she casts supernova. AoE heal through the shower. Veil of Sky can be dispelled.")
	FontString8:SetText("Halls of Origination")
	FontString9:SetText("Isiset")
	CloseDropDownMenus()
end
			
function ammunae()
	HideStuff()
	FontString1:SetText("Tank: |n |n Shortly after the boss AoEs a flower lasher will spawn. Tank the lasher on top of the orange circle that the spore leaves behind. The Orange Circle will damage you and the lasher.")
	FontString2:SetText("DPS: |n |n Kill the pods that she spawns ASAP. If you kill them quickly enough, no adds.")
	FontString3:SetText("Healer: |n |n Typical healing, nothing special.")
	FontString8:SetText("Halls of Origination")
	FontString9:SetText("Ammunae")
	CloseDropDownMenus()
end
			
function setesh()
	HideStuff()
	FontString1:SetText("Tank: |n |n This Boss is untankable. Always focus on the portal. Tank should pickup and kite the Void Sentiels. DPS will burn down Void Seekers.")
	FontString2:SetText("DPS: |n |n Void Sentinels should be left for the Tank to kite. Void Seekers should be killed ASAP. Don't stand in puddles, run away from purple crystals that are thrown out. When there are no Void Seekers or Mana Wurms to kill, focus on the Boss.")
	FontString3:SetText("Healer: |n |n Don't stand in the purple puddles. Extra healing may be required on people who don't run out of the puddles fast enough.")
	FontString8:SetText("Halls of Origination")
	FontString9:SetText("Setesh")
	CloseDropDownMenus()
end
			
function rajh()
	HideStuff()
	FontString1:SetText("Tank: |n |n Avoid the fire cyclones. He leaps into fire on the ground, try to interrupt this.")
	FontString2:SetText("DPS: |n |n He leaps into fire on the ground, run from it. Summon Sun Orb ability should be interrupted. When he reaches 0 energy, he channels a damaging AoE, takes 100% damage and regenerates energy. Nuke hard, use all cooldowns (trinkets, bloodlust, heroism.)")
	FontString3:SetText("Healer: |n |n When he reaches 0 energy, he channels a damaging AoE, takes 100% damage and regenerates energy. AoE heal through it.")
	FontString8:SetText("Halls of Origination")
	FontString9:SetText("Rajh")
	CloseDropDownMenus()
end
			
function generalhusam()
	HideStuff()
	FontString1:SetText("Tank: |n |n Kite the Boss out of all the mines. Try not to Line of Sight your Healer. Dont stand in the shockwave that extends from the Boss in four directions.")
	FontString2:SetText("DPS: |n |n Don't stand in the Yellow Circle. Don't stand in the Shockwave")
	FontString3:SetText("Healer: |n |n Don't stand in the Yellow Circle. Don't stand in the Shockwave. Extra healing will be requires for whichever player the Boss picks up and throws against the columns")
	FontString8:SetText("Lost City of Tol'vir")
	FontString9:SetText("General Husam")
	CloseDropDownMenus()
end			

function highprophetbarim()
	HideStuff()
	FontString1:SetText("Tank: |n |n Phase 1: Don't Stand in the Fire. A Ranged DPS will kite and kill the Yellow Phoenix. Avoid the Beam. |n Phase 2: Kill the Shadow Phoenix. Burn all Cooldowns to end this phase ASAP. Kill the Shadown Apparitions. Do not stand in the circle of light around the Boss.")
	FontString2:SetText("DPS: |n |n Phase 1: A Ranged DPS should it and kill the Phoenix. When killed, the Phoenix will become an egg and shortly thereafter will be reborn. The Phoenix emits an AoE aura. Avoid the Beams. |n Phase 2: Kill the Shadow Phoenix. Burn all Cooldowns to end this phase ASAP. Kill the Shadown Apparitions. Do not stand in the circle of light around the Boss.")
	FontString3:SetText("Healer: |n |n The DPS that is kiting the Phoenix can take a lot od damage if they cannot stay far enough away from it. During Phase 2, Everyone will be taking damage. This part of the fight is very healing intensive. If someone is standing in the Circle of light around the Boss, don't bother healing them. They will die very quickly and you will be wasting mana trying to save them.")
	FontString8:SetText("Lost City of Tol'vir")
	FontString9:SetText("High Prophet Barim")
	CloseDropDownMenus()
end			
		
function lockmawaugh()
	HideStuff()
	FontString1:SetText("Tank: |n |n Phase 1: Tank the Croc. Adds cannot be Tanked, just burn them down quickly. Don't stand in the Fog. |n Phase 2: Augh will breathe fire and whirlwind after players. Try to taunt him back and keep him on you.")
	FontString2:SetText("DPS: |n |n Phase 1: If marked, run near the Tank. Everyone should quickly DPS down the Adds. Don't stand in the Fog |n Phase 2: Try to stay away from Augh")
	FontString3:SetText("Healer: |n |n The Marked DPS in Phase 1 may need extra heals as the Adds will be focused on them.")
	FontString8:SetText("Lost City of Tol'vir")
	FontString9:SetText("Lockmaw & Augh")
	CloseDropDownMenus()
end
			
function siamat()
	HideStuff()
	FontString1:SetText("Tank: |n |n Phase 1: When the fight starts, Siamat will be immune to damage, and 3 sets of 2 adds will be spawned. The Servant of Siamat needs to be tanked, and the Minion of Siamat just needs to be burned down. Interrupt as many of their spells as possible. Don't stand where adds die. Phase 2: Tank Boss, kite him around, do not stand on winds.")
	FontString2:SetText("DPS: |n |n Phase 1: Adds. Kill the Minions first.  Interrupt as many of their spells as possible. They do chain lightning that is very damaging. Phase 2: Kill Boss. Kill any Adds that pop up.")
	FontString3:SetText("Healer: |n |n This fight is very healer intensive. Everyone will be taking damage. If the Minions don't die quickly the chain lightning will be hitting everyone. Spread out if possible, do not stand on winds.")
	FontString8:SetText("Lost City of Tol'vir")
	FontString9:SetText("Siamat")
	CloseDropDownMenus()
end

function baronashbury()
	HideStuff()
	FontString1:SetText("Tank: |n |n Boss will brinf everyone to 1% health. He will then cast a spell to restore his and your health by 10% per second. Allow him to cast this for 2 or 3 seconds and then interrupt it. Repeat throughout the fight.")
	FontString2:SetText("DPS: |n |n Boss will brinf everyone to 1% health. He will then cast a spell to restore his and your health by 10% per second. Allow him to cast this for 2 or 3 seconds and then interrupt it. Repeat throughout the fight.")
	FontString3:SetText("Healer: |n |n Boss will brinf everyone to 1% health. He will then cast a spell to restore his and your health by 10% per second. Allow him to cast this for 2 or 3 seconds and then interrupt it. Repeat throughout the fight.")
	FontString8:SetText("Shadowfang Keep")
	FontString9:SetText("Baron Ashbury")
	CloseDropDownMenus()
end		
			
function baronsilverlaine()
	HideStuff()
	FontString1:SetText("Tank: |n |n This Boss Summons two Adds to help him. The Adds disappear when he dies. Hold all three but focus on the Boss.")
	FontString2:SetText("DPS: |n |n Focus on the Boss. The Adds will disappear when the Boss dies.")
	FontString3:SetText("Healer: |n |n If the Tank is holding Boss and all Adds, they will need big heals.")
	FontString8:SetText("Shadowfang Keep")
	FontString9:SetText("Baron Silverlaine")
	CloseDropDownMenus()
end
			
function commanderspringvale()
	HideStuff()
	FontString1:SetText("Tank: |n |n Turn the Boss away from the party. Don't stand in the Desecrate. Interrupt 'Unholy Empowerment' Pickup Adds, after two waves of Adds a debuff is put on entire party that will quickly kill everyone. DPS Race.")
	FontString2:SetText("DPS: |n |n Stand behind the Boss. Stay out of the Desecrate.Interrupt 'Unholy Empowerment' Kill Adds, after two waves of Adds a debuff is put on entire party that will quickly kill everyone. DPS Race.")
	FontString3:SetText("Healer: |n |n Stay out of the Desecrate. The does a Full Frontal Cone attack that hits for a lot of damage. Lots of healing will be required during the DPS race.")
	FontString8:SetText("Shadowfang Keep")
	FontString9:SetText("Commander Springvale")
	CloseDropDownMenus()
end
			
function lordwalden()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. During Mystery Toxin Phase; If you get Red debuff, stand still. If you get the Green debuff, keep moving.")
	FontString2:SetText("DPS: |n |n Tank and Spank. During Mystery Toxin Phase; If you get Red debuff, stand still. If you get the Green debuff, keep moving.")
	FontString3:SetText("Healer: |n |n Tank and Spank. During Mystery Toxin Phase; If you get Red debuff, stand still. If you get the Green debuff, keep moving.")
	FontString8:SetText("Shadowfang Keep")
	FontString9:SetText("Lord Walden")
	CloseDropDownMenus()
end
			
function lordgodfrey()
	HideStuff()
	FontString1:SetText("Tank: |n |n Face this Boss away from the party members. Pickup Adds. Sidestep 'Pistol Barrage'.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Adds can be AoE'd. Decurse DOT if you can.")
	FontString3:SetText("Healer: |n |n Boss shoots random 50k damage attacks that turns into a DOT if not dispelled. Big heals will be needed for the targets of this attack.")
	FontString8:SetText("Shadowfang Keep")
	FontString9:SetText("Lord Godfrey")
	CloseDropDownMenus()
end
			
function corborus()
	HideStuff()
	FontString1:SetText("Tank: |n |n Phase 1: Above Ground - Tank boss. Stay out of falling shards |n Phase 2: Underground - Kill Adds. Do not stand in the dust clouds.")
	FontString2:SetText("DPS: |n |n Phase 1: Above Ground - Dispell his healing effect if you can. Stay out of falling shards |n Phase 2: Underground - Kill Adds. Do not stand in the dust clouds.")
	FontString3:SetText("Healer: |n |n Phase 1: Above Ground - Dispell his healing effect if you can. Stay out of falling shards |n Phase 2: Underground - Do not stand in the dust clouds.")
	FontString8:SetText("Stonecore")
	FontString9:SetText("Corborus")
	CloseDropDownMenus()
end

function slabhide()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Stay out of Falling Spike and Lava Pools.")
	FontString2:SetText("DPS: |n |n Tank and Spank. Stay out of Falling Spike and Lava Pools.")
	FontString3:SetText("Healer: |n |n Tank and Spank. Stay out of Falling Spike and Lava Pools.")
	FontString8:SetText("Stonecore")
	FontString9:SetText("Slabhide")
	CloseDropDownMenus()
end		
			
function ozruk()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank this Boss with your back to the wall. Strafe Dodge the Quake.")
	FontString2:SetText("DPS: |n |n Melee DPS back out on Spike Spell. Ranged DPS watch for spell reflect.")
	FontString3:SetText("Healer: |n |n Extra healing may be required if the Tank fails to sidestep the Quake.")
	FontString8:SetText("Stonecore")
	FontString9:SetText("Ozruk")
	CloseDropDownMenus()
end
			
function highpriestessazil()
	HideStuff()
	FontString1:SetText("Tank: |n |n Pickup Adds. Kiting Adds through the purple circles will kill them quickly.")
	FontString2:SetText("DPS: |n |n DPS should interrupt Force Grip. If you have a lot of Adds on you, run though a purple circle. The Adds will be killed by it.")
	FontString3:SetText("Healer: |n |n Run through purple circle to slow and kill Adds.")
	FontString8:SetText("Stonecore")
	FontString9:SetText("High Priestess Azil")
	CloseDropDownMenus()
end
			
function ladynazjar()
	HideStuff()
	FontString1:SetText("Tank: |n |n Pickup Adds at 60% and 20%. Spread out during the Add phase. Do not stand in the Blue Circles.")
	FontString2:SetText("DPS: |n |n Try to interrupt Shock Blast. Move out of Blue Circles. If available, try to CC the some of the Adds. Attack caster Adds first when they appear at 60% and 20%. Spread out during the Add phase.")
	FontString3:SetText("Healer: |n |n Extra heals will be needed for players who arent quick at getting out of the Blue Circles. Also those hit by the Shock Blast. Spread out during the Add phase.")
	FontString8:SetText("Throne of the Tides")
	FontString9:SetText("Lady Naz'jar")
	CloseDropDownMenus()
end		

function commanderulthok()
	HideStuff()
	FontString1:SetText("Tank: |n |n Kite the Boss around the outter wall as he drops purple circles that expand across the room.")
	FontString2:SetText("DPS: |n |n Decurse Fatigue if able.")
	FontString3:SetText("Healer: |n |n Extra heals are required when the Boss casts Squeeze. Decurse Fatigue if able.")
	FontString8:SetText("Throne of the Tides")
	FontString9:SetText("Commander Ulthok")
	CloseDropDownMenus()
end	
			
function stonespeakerghursha()
	HideStuff()
	FontString1:SetText("Tank: |n |n Turn this Boss away from the party. Tank and Spank until 50%. At 50% the Boss will attach on a players head and Mind Control them. DPS that player until 50% and the Boss will let go and choose a new victim. Do not cast spells during 'Absorb Magic' as anything you cast on the Boss during this time will be dealt back to the party.")
	FontString2:SetText("DPS: |n |n Tank and Spank until 50%. Do not cast spells during 'Absorb Magic' as anything you cast on the Boss during this time will be dealt back to the party. Attack whichever player is Mind Controlled.")
	FontString3:SetText("Healer: |n |n If players continue casting during the 'Absorb Magic' then big heals will be needed when the Boss deals that damage back. When a Mind Controlled player is released, they will need to be healed up.")
	FontString8:SetText("Throne of the Tides")
	FontString9:SetText("Mindbender Ghur'sha")
	CloseDropDownMenus()
end
			
function ozumat()
	HideStuff()
	FontString1:SetText("Tank: |n |n Phase 1: Tank and Spank. Pickup Adds. |n Phase 2: Kite around the Beasts. Don't stand in Black Pools. |n Phase 3: DPS Race. Kill the Boss as fast as possible. The Boss is the Huge Octopus on the outer wall.")
	FontString2:SetText("DPS: |n |n Phase 1: Tank and Spank and Kill Adds |n Phase 2: Kill the Summoners that are Channeling. Don't stand in Black Pools. |n Phase 3: DPS Race. Kill the Boss as fast as possible. The Boss is the Huge Octopus on the outer wall.")
	FontString3:SetText("Healer: |n |n Phase 1: Tank and Spank. |n Phase 2:  Don't stand in Black Pools. |n Phase 3: DPS Race. Kill the Boss as fast as possible. The Boss is the Huge Octopus on the outer wall.")
	FontString8:SetText("Throne of the Tides")
	FontString9:SetText("Ozumat")
	CloseDropDownMenus()
end
			
function grandvizierertan()
	HideStuff()
	FontString1:SetText("Tank: |n |n Stay close to the Boss. When he pulls the Whirlwinds to him stay in the middle and continue to fight.")
	FontString2:SetText("DPS: |n |n Stay close to the Boss. When he pulls the Whirlwinds to him stay in the middle and continue to fight.")
	FontString3:SetText("Healer: |n |n Stay close to the Boss. When he pulls the Whirlwinds to him stay in the middle and use group heals to keep everyone alive")
	FontString8:SetText("Vortex Pinnacle")
	FontString9:SetText("Grand Vizier Ertan")
	CloseDropDownMenus()
end		

function altairus()
	HideStuff()
	FontString1:SetText("Tank: |n |n Shift Positioning so you get the Upwind of Altairus buff. The Upwind Buff grants Haste while the Downwind Buff decreases cast time.")
	FontString2:SetText("DPS: |n |n Do not stand next to the Tank. Shift Positioning so you get the Upwind of Altairus buff. The Upwind Buff grants Haste while the Downwind Buff decreases cast time.")
	FontString3:SetText("Healer: |n |n Do not stand next to the Tank. hift Positioning so you get the Upwind of Altairus buff. The Upwind Buff grants Haste while the Downwind Buff decreases cast time.")
	FontString8:SetText("Vortex Pinnacle")
	FontString9:SetText("Altairus")
	CloseDropDownMenus()
end			
			
function asaad()
	HideStuff()
	FontString1:SetText("Tank: |n |n Tank and Spank. Avoid Whirlwinds. Everyone must stand inside Unstable Grounding Field when it is cast. (Triangle made of lightning).")
	FontString2:SetText("DPS: |n |n Tank and Spank. Avoid Whirlwinds. Everyone must stand inside Unstable Grounding Field when it is cast. (Triangle made of lightning).")
	FontString3:SetText("Healer: |n |n Tank and Spank. Avoid Whirlwinds. Everyone must stand inside Unstable Grounding Field when it is cast. (Triangle made of lightning).")
	FontString8:SetText("Vortex Pinnacle")
	FontString9:SetText("Asaad")
	CloseDropDownMenus()
end

function romoggbonecrusherparty()
	local msg = "Move out of dust clouds. Tank needs to pickup the Adds. When pulled to the middle and chained attack the Chains of Woe and run away from the Boss quickly to avoid being killed by the Skullcracker."
	local msg2 = "If possible, Adds should be Rooted or Trapped next to the Boss for the Skullcracker as it will kill them, otherwise Adds must be killed."
	SendChatMessage("Nerino1's BossInfo Addon: Rom'ogg Bonecrusher","Party")
	SendChatMessage(msg ,"Party")
	SendChatMessage(msg2,"Party")
end

function corlaheraldoftwilightparty()
	local msg = "Dark Command (fear) must be interuppted or Disspelled. DPS must stand in the Beams that land on the 3 Zealots. You must stay in the Beam until you have 80 - 85 stacks of Evolution. Then step out of the Beam until the Debuff wears off. Then repeat."
	local msg2 = "If the stacks of Evolution reachs 100 on a player they become Mind Controlled. If they reach 100 on the Zealot, they will wipe the group."
	SendChatMessage("Nerino1's BossInfo Addon: Corla, Herald of Twilight","Party")
	SendChatMessage(msg ,"Party")
	SendChatMessage(msg2 ,"Party")
end
			
function karshsteelbenderparty()
	local msg = "Boss must be kited into the Forge to remove his Armor. When the Boss is in the forge; He hits the Tank harder and does an AoE to everyone that will quickly wipe the group. Pull him out with 2 or 3 stacks of debuff."
	local msg2 = "If the debuff wears off, Adds will spawn that need to be picked up. When the Adds die they leave lava pools that have the same effect as the forge."
	SendChatMessage("Nerino1's BossInfo Addon: Karsh Steelbender","Party")
	SendChatMessage(msg ,"Party")
	SendChatMessage(msg2 ,"Party")
end
			
function beautyparty()
	local msg = "Crowd Control as many of the smaller dogs as you can. Dogs that cannot be CC'd should be burnt down quickly. Use Cooldowns. Don't stand in Lava Pools and watch out for Fear."
	SendChatMessage("Nerino1's BossInfo Addon: Beauty","Party")
	SendChatMessage(msg ,"Party")
end
			
function ascendantlordobsidiusparty()
	local msg = "The Adds in this fight attack whoever hits them last. A DPS should kite the Adds away from the Party as they apply a healing debuff to whoever is close to them. At 66% and 33% the Boss will switch bodies with an Add. Regroup and Repeat."
	SendChatMessage("Nerino1's BossInfo Addon: Ascendant Lord Obsidius","Party")
	SendChatMessage(msg ,"Party")
end
			
function glubtokparty()
	local msg = "Tank and spank till 50%. After 50%, he is untankable, and he will spawn a moving Fire Wall with him as the center of the Fire Wall. He will also spawn adds and drop icicles. Tank should grab adds. Avoid circles, burn boss."
	SendChatMessage("Nerino1's BossInfo Addon: Glubtok","Party")
	SendChatMessage(msg ,"Party")
end

function helixgearbreakerparty()
	local msg = "Avoid bombs. When the Goblin jumps off the Oaf and attaches himself to one of the players, just keep attacking the Oaf. He will also attach bombs to someone's chest, that person has to run away from the party."
	local msg2 = "The oaf will also pick up someone and charge into the wall with him, heal him up. After Oaf is dead, kill the Goblin."
	SendChatMessage("Nerino1's BossInfo Addon: Helix Gearbreaker","Party")
	SendChatMessage(msg ,"Party")
	SendChatMessage(msg2 ,"Party")
end			
			
function foereaper5000party()
	local msg = "Avoid Overdrive. Casts harvest which targets a random player and places a mark on the floor. Get out of his path and the mark, it will one shot you. One DPS should use the Reaver to Tank the Fire Elementals. Tank the boss at the top of the ramp."
	SendChatMessage("Nerino1's BossInfo Addon: Foe Reaper 5000","Party")
	SendChatMessage(msg ,"Party")
end		

function admiralripsnarlparty()
	local msg = "DPS down vapors then focus on boss. At 20%, ignore the Adds and just focus on Boss."
	SendChatMessage("Nerino1's BossInfo Addon: Admiral Ripsnarl","Party")
	SendChatMessage(msg ,"Party")
end	
			
function captaincookieparty()
	local msg = "Tank and Spank. Eat the good food on the ground to increase your Haste. Rotten Food will stack a DOT on you. Rotten food left on the ground does a damaging AoE. This Boss is not Tankable."
	SendChatMessage("Nerino1's BossInfo Addon: 'Captain' Cookie","Party")
	SendChatMessage(msg ,"Party")
end
			
function vanessavancleefparty()
	local msg = "Enter 4 nightmares. 1st: Avoid Fire and falling Icicles. Kill boss, 2nd: Tank hold Spiders. Burn Boss, 3rd: Avoid Electricity. 4th: Protect the family. Family can be healed. Vanessa: Kill Boss and Adds. Use ropes to escape boat when she blows it up."
	SendChatMessage("Nerino1's BossInfo Addon: Vanessa VanCleef","Party")
	SendChatMessage(msg ,"Party")
end		
			
function nothingyetparty()
	local msg = "Nothing Yet."
	SendChatMessage("Nerino1's BossInfo Addon:","Party")
	SendChatMessage(msg ,"Party")
end	

function generalumbrissparty()
	local msg = "Purple (Malignant) Trogg should be CC'd. If CC is not available, Purple Troggs must be stunned and kited away from the group and the Boss and killed. If you are targeted for the Blitz, sidestep to avoid damage. Enrages at 30%."
	SendChatMessage("Nerino1's BossInfo Addon: General Umbriss","Party")
	SendChatMessage(msg ,"Party")
end			

function forgemasterthrongusparty()
	local msg = "Mace Phase: Tank should kite boss. Don't stand in front of him. Avoid Lava Pools. Shield Phase: Everyone should go behind the Boss. Group heals. Sword Phase: Lots of damage is dealt to the Tank in this phase so save cooldowns until then."
	SendChatMessage("Nerino1's BossInfo Addon: Forgemaster Throngus","Party")
	SendChatMessage(msg ,"Party")
end			
			
function drahgashadowburnerparty()
	local msg = "Fire Elementals will target a player. That person need to run away from the Elemental and the rest of the Party needs to kill it before it reaches them. Stay close to this Boss and be ready to run behind her when she breathes fire."
	SendChatMessage("Nerino1's BossInfo Addon: Drahga Shadowburner","Party")
	SendChatMessage(msg ,"Party")
end			
			
function erudaxparty()
	local msg = "He will cast Shadow Gales (purple ring). Run to the center of Shadow Gales when he casts it. Adds will run in after Shadow Gales ends to hatch eggs. Kill the adds quickly and then go back to Boss."
	SendChatMessage("Nerino1's BossInfo Addon: Erudax","Party")
	SendChatMessage(msg ,"Party")
end
			
function templeguardiananhuurparty()
	local msg = "When he casts Shield of Light on himself, 2 DPS need to drop down (1 on each side) and click the switches. Tank should also drop down to pickup snakes. Once both switches are flipped, the Boss can be interrupted."
	SendChatMessage("Nerino1's BossInfo Addon: Temple Guardian Anhuur","Party")
	SendChatMessage(msg ,"Party")
end			

function earthragerptahparty()
	local msg = "Don't stand on dust clouds. At 50% he will collapse and summon Adds. Stack tank and AoE Adds. Stay away from Tornadoes and Spikes."
	SendChatMessage("Nerino1's BossInfo Addon: Earthrager Ptah","Party")
	SendChatMessage(msg ,"Party")
end
			
function anraphetparty()
	local msg = "When Alpha Beam is cast on you, move out of it. When he casts Nemesis Strike on the tank, dispell it. He will also cast Omega Stance which will damage everyone and require AoE heals."
	SendChatMessage("Nerino1's BossInfo Addon: Anraphet","Party")
	SendChatMessage(msg ,"Party")
end
			
function isisetparty()
	local msg = "Avoid beams from the portal. Down the spark adds and during her split phase (at 67%), kill the Astral Rain version of her first. Kill Celestial Call next, last Veil of the Sky."
	SendChatMessage("Nerino1's BossInfo Addon: Isiset","Party")
	SendChatMessage(msg ,"Party")
end
			
function ammunaeparty()
	local msg = "Seedlings spawn (and heal him) throughout the fight, kill them asap or they morph into elites. Tank and spank."
	SendChatMessage("Nerino1's BossInfo Addon: Ammunae","Party")
	SendChatMessage(msg ,"Party")
end
			
function seteshparty()
	local msg = "Stay away from purple crystals and circles on the floor. Tank should pickup and kite Void Sentinel and Mana Wurms. DPS should kill Void Seekers ASAP and then get back to the Boss."
	SendChatMessage("Nerino1's BossInfo Addon: Setesh","Party")
	SendChatMessage(msg ,"Party")
end
			
function rajhparty()
	local msg = "Avoid fire Tornados. Run away from the fire on the ground, he leaps to it and causes AoE damage. Interrupt as many of his spells as you can. At 0 Energy he channels an AoE, AoE heal through it, cast all CDs and nuke hard."
	SendChatMessage("Nerino1's BossInfo Addon: Rajh","Party")
	SendChatMessage(msg ,"Party")
end
			
function generalhusamparty()
	local msg = "Do not stand on Yellow Circles. Do not stand in Shockwaves. Avoid the Mines. He also throws random players at the pillars. Heal through it."
	SendChatMessage("Nerino1's BossInfo Addon: General Husam","Party")
	SendChatMessage(msg ,"Party")
end			

function highprophetbarimparty()
	local msg = "Phase 1: Don't stand in the fire. Ranged DPS kite and kill the Yellow Phoenix. Repeat when Phoenix is reborn. Phase 2: Do not stand in the light around the Boss. Kill the Shadow Phoenix as fast as possible. Kill the Shadow Apparitions. Use Cooldowns."
	SendChatMessage("Nerino1's BossInfo Addon: High Prophet Barim","Party")
	SendChatMessage(msg ,"Party")
end			
		
function lockmawaughparty()
	local msg = "Phase 1: If you are marked. Run near the Tank. DPS down the Adds quickly. Don't stand in the Fog. Avoid Augh. Phase 2: Augh cast Dragon's Breathe that will disorient the Tank and drops Aggro. Avoid Whirlwinds."
	SendChatMessage("Nerino1's BossInfo Addon: Lockmaw & Augh","Party")
	SendChatMessage(msg ,"Party")
end
			
function siamatparty()
	local msg = "Phase 1 - Kill the adds, Minions first. Interrupt Adds as much as possible. Don't stand in winds. Phase 2 - Tank the boss, kite him away from winds on the ground. Kill Adds as they spawn. Very healing intensive fight."
	SendChatMessage("Nerino1's BossInfo Addon: Siamat","Party")
	SendChatMessage(msg ,"Party")
end

function baronashburyparty()
	local msg = "Interrupt 'Mend Rotten Flesh'. After 'Asphyxiate' (brings everyone to 1% health), allow the Boss to cast 'Stay of Execution' for 1-2 ticks and then interrupt it, as it heals both you and him."
	SendChatMessage("Nerino1's BossInfo Addon: Baron Ashbury","Party")
	SendChatMessage(msg ,"Party")
end		
			
function baronsilverlaineparty()
	local msg = "Focus on the Boss. Adds disappear when the Boss dies. Or, Kill Adds then Boss."
	SendChatMessage("Nerino1's BossInfo Addon: Baron Silverlaine","Party")
	SendChatMessage(msg ,"Party")
end
			
function commanderspringvaleparty()
	local msg = "Turn this Boss away from the Party. Don't stand in the Desecrate. Interrupt 'Unholy Empowerment'. Kill the Adds. After 2 rounds of Adds, you recieve a debuff that quickly kills everyone. DPS race."
	SendChatMessage("Nerino1's BossInfo Addon: Commander Springvale","Party")
	SendChatMessage(msg ,"Party")
end
			
function lordwaldenparty()
	local msg = "Tank and Spank. During the Mystery Toxin Phase; If you get a Red debuff, stand still. If you get a Green debuff, Don't stop moving. Stay out of circles."
	SendChatMessage("Nerino1's BossInfo Addon: Lord Walden","Party")
	SendChatMessage(msg ,"Party")
end
			
function lordgodfreyparty()
	local msg = "Face this Boss away from the Party. Tank should pickup Adds. DOTs should be Dispelled if possible. Tank should strafe from 'Pistol Barrage'."
	SendChatMessage("Nerino1's BossInfo Addon: Lord Godfrey","Party")
	SendChatMessage(msg ,"Party")
end
			
function corborusparty()
	local msg = "Above Ground: Dispell Bosses Healing Effect. Avoid Falling Shards. Underground: Kill Adds. Don't stand on Dust Clouds."
	SendChatMessage("Nerino1's BossInfo Addon: Corborus","Party")
	SendChatMessage(msg ,"Party")
end

function slabhideparty()
	local msg = "Tank and Spank. Stay out of Falling Spikes and Lava Pools. Once Spikes have fallen they can Line of Sight you."
	SendChatMessage("Nerino1's BossInfo Addon: Slabhide","Party")
	SendChatMessage(msg ,"Party")
end		
			
function ozrukparty()
	local msg = "Tank this Boss with your back to the wall. Tank should strafe to avoid Quake. DPS should use the Bosses Spell Reflect to damage themselves to break the Paralyse he casts."
	SendChatMessage("Nerino1's BossInfo Addon: Ozruk","Party")
	SendChatMessage(msg ,"Party")
end
			
function highpriestessazilparty()
	local msg = "Tank should pickup Adds. DPS should interrupt Force Grip. Players can stand behind the Purple Circles to make Adds run through them and die."
	SendChatMessage("Nerino1's BossInfo Addon: High Priestess Azil","Party")
	SendChatMessage(msg ,"Party")
end
			
function ladynazjarparty()
	local msg = "Adds spawn at 60% and 20%. Spread out during the Add phase. Caster Adds should be CC'd, Melee Add should be killed first. Stay out of Blue Circles. Avoid Tornados. Try to Interupt Shock Blast."
	SendChatMessage("Nerino1's BossInfo Addon: Lady Naz'jar","Party")
	SendChatMessage(msg ,"Party")
end		

function commanderulthokparty()
	local msg = "Tank should Kite the Boss around the edge of the circular room as he drops Purple circles that expand out. Extra healing required when the Boss casts Squeeze. Players should Decurse fatigue if they can."
	SendChatMessage("Nerino1's BossInfo Addon: Commander Ulthok","Party")
	SendChatMessage(msg ,"Party")
end	
			
function stonespeakerghurshaparty()
	local msg = "Turn this Boss away from the party. Interrupt Lava Bursts. Tank and Spank until 50%. At 50% a random Player will be mind controlled. Dps them to 50%. Boss will choose a new victim. Stop casting when the Boss casts Absorb Magic."
	SendChatMessage("Nerino1's BossInfo Addon: Erunak Stonespeaker & Mindbender Ghur'sha","Party")
	SendChatMessage(msg ,"Party")
end
			
function ozumatparty()
	local msg = "Phase 1: Tank and Spank. Phase 2: Tank should kite around the Beasts while DPS kill the Casters. Stay out of the Black Circles. Phase 3: DPS Race. The Boss is the Huge Octopus on the outer wall."
	SendChatMessage("Nerino1's BossInfo Addon: Ozumat","Party")
	SendChatMessage(msg ,"Party")
end
			
function grandvizierertanparty()
	local msg = "Stay close to the Boss throughtout the whole fight. When the Boss pulls the Tornados in to him, the healer will need to use group heals to keep everyone alive."
	SendChatMessage("Nerino1's BossInfo Addon: Grand Vizier Ertan","Party")
	SendChatMessage(msg ,"Party")
end

function altairusparty()
	local msg = "Switch from one side of the Boss to the other to continue to receieve the Upwind of Altairus buff to receive Haste Buff. Do not stank next to the Tank. Avoid Tornados"
	SendChatMessage("Nerino1's BossInfo Addon: Altairus","Party")
	SendChatMessage(msg ,"Party")
end	
	
function asaadparty()
	local msg = "Tank and Spank. Disspell Static Cling. When he starts casting Unstable Grounding Field, everyone, even the tank, must stand inside the triangle on the ground or else they will die. Avoid Tornados."
	SendChatMessage("Nerino1's BossInfo Addon: Asaad","Party")
	SendChatMessage(msg ,"Party")
end

function aboutinfo()
	local msg = "Check out Nerino1's BossInfo mod on curse.com."
	local msg2 = "BossInfo shows Boss encounter strategies seperated for Tanks, DPS and Healers. It also has the ability to send a summary to party members."
	SendChatMessage(msg ,"Party")
	SendChatMessage(msg2 ,"Party")
end