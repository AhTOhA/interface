﻿-- ForteXorcist v1.974.7 by Xus 22-02-2011 for 4.0.6

--[[
"frFR": French
"deDE": German
"esES": Spanish
"enUS": American english
"enGB": British english
"zhCN": Simplified Chinese
"zhTW": Traditional Chinese
"ruRU": Russian
"koKR": Korean

!! Make sure to keep this saved as UTF-8 format !!

]]

--[[>> still needs translating]]
--[[if FW.CLASS == "PALADIN" then
	local FWL = FW.L;
	FWL.GOAK = GetSpellInfo(86669);
	
	-- Russian
	if GetLocale() == "ruRU" then
		FWL.HOLY = " (Holy)";
		FWL.PROT = " (Protection)";
		FWL.RETR = " (Retribution)";
	-- French
	elseif GetLocale() == "frFR" then
		FWL.HOLY = " (Holy)";
		FWL.PROT = " (Protection)";
		FWL.RETR = " (Retribution)";
	-- DE 
	elseif GetLocale() == "deDE" then
		FWL.HOLY = " (Holy)";
		FWL.PROT = " (Protection)";
		FWL.RETR = " (Retribution)";
	-- SPANISH
	elseif GetLocale() == "esES" then
		FWL.HOLY = " (Holy)";
		FWL.PROT = " (Protection)";
		FWL.RETR = " (Retribution)";
	-- Simple Chinese
	elseif GetLocale() == "zhCN" then
		FWL.HOLY = " (Holy)";
		FWL.PROT = " (Protection)";
		FWL.RETR = " (Retribution)";
	-- tradition Chinese
	elseif GetLocale() == "zhTW" then
		FWL.HOLY = " (Holy)";
		FWL.PROT = " (Protection)";
		FWL.RETR = " (Retribution)";
	-- Korea
	elseif GetLocale() == "koKR" then
		FWL.HOLY = " (Holy)";
		FWL.PROT = " (Protection)";
		FWL.RETR = " (Retribution)";
		
	-- ENGLISH
	else
		FWL.HOLY = " (Holy)";
		FWL.PROT = " (Protection)";
		FWL.RETR = " (Retribution)";
	end
	
	FWL.GOAK_HOLY = FWL.GOAK..FWL.HOLY;
	FWL.GOAK_PROT = FWL.GOAK..FWL.PROT;
	FWL.GOAK_RETR = FWL.GOAK..FWL.RETR;
end]]
	