local f = CreateFrame("frame")
f:SetScript("OnEvent", function(self, event, addon) 
	if addon == "nameplateFix" and event == "ADDON_LOADED" then
		SetCVar( "bloattest", 1)
	end
end)
f:RegisterEvent("ADDON_LOADED")