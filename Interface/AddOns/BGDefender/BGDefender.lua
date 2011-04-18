
BGD_Prefs = nil

---------
function BGD_OnLoad(self)
---------
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("VARIABLES_LOADED")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    BGD_Msg("BG Defender loaded (ver "..GetAddOnMetadata("BGDefender", "Version").."). Type /bgd help for more information.")
    SLASH_BGDefender1 = "/BGDefender"
    SLASH_BGDefender2 = "/bgd"
    SlashCmdList["BGDefender"] = function(msg)
        BGD_SlashCommandHandler(msg)
    end
end


---------
function BGD_SlashCommandHandler(msg)
---------
    msg = strlower(msg)
    if (msg == "") then
        BGD_Prefs.ShowUI = BGD_Toggle()
    elseif (msg == "show") then
        BGD_Prefs.ShowUI = BGD_Toggle(true)
    elseif (msg == "hide") then
        BGD_Prefs.ShowUI = BGD_Toggle(false)
    elseif (msg == "status") then
        BGD_ShowStatus()
    elseif (msg == "options") or (msg == "o") then
        BGD_Options_Open()
    else
        DEFAULT_CHAT_FRAME:AddMessage("BG Defender Version "..GetAddOnMetadata("BGDefender", "Version"), 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("  /bgd options |cFFFFFFFF- to set announcement channel", 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("  /bgd [show/hide] |cFFFFFFFF- show/hide window", 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("  /bgd status |cFFFFFFFF- BGDefender status", 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage(" ", 1.0, 0.5, 0.0)
    end
end


---------
function BGD_OnEvent(frame, event, ...)
---------
    if (event == "ADDON_LOADED") then
        if not BGD_Prefs then
            BGD_Settings_Default()
        end
        BGD_Prefs.version = GetAddOnMetadata("BGDefender", "Version")
        BGD_Opt_Frame_Setup()
        BGD_Opt_Frame_UpdateViews()
    end
    if ((event == "ZONE_CHANGED_NEW_AREA") or (event == "ADDON_LOADED")) then
        if(BGD_isInBG()) then            
           BGD_Prefs.ShowUI = BGD_Toggle(true)
       else
           BGD_Prefs.ShowUI = BGD_Toggle(false)
       end
    end
end


---------
function BGD_NumCall(arg1)
---------
    local location = nil
    local call = ""
    
    if (not BGD_isInBG()) then
        BGD_Msg(BGD_OUT)
        return
    end
    
    location = GetSubZoneText()
    
    if (location ~= "") then
        if(arg1==6) then
            call = BGD_INCPLUS
        elseif(arg1==7) then
            call = BGD_HELP
        elseif(arg1==8) then
            call = BGD_SAFE
        else 
            call = BGD_INC
            call = string.gsub(call, "$num", arg1)
        end
        call = string.gsub(call, "$base", location)
        
        local channel = BGD_Prefs.BGChat
        if (BGD_isInRaidBG()) then
            channel = BGD_Prefs.RaidChat
        end
        if (BGD_Prefs.preface == true) then
            call = "BGDefender: " .. call
        end
        if (channel == BGD_GENERAL) then
            local index, name = GetChannelName(BGD_GENERAL.." - "..GetZoneText())
            if (index~=0) then 
                SendChatMessage(call , "CHANNEL", nil, index)
            end
        else
            SendChatMessage(call, channel)
        end
    else
        BGD_Msg(BGD_AWAY)
    end
end


---------
function BGD_Msg(text)
---------
    if (text) then
        DEFAULT_CHAT_FRAME:AddMessage(text, 1, 0, 0)
        UIErrorsFrame:AddMessage(text, 1.0, 1.0, 0, 1, 10) 
    end
end


---------
function BGD_isInRaidBG()
---------
    local zone = GetZoneText()
    local found = false
    if ((zone == BGD_WG) or (zone == BGD_TB)) then
        found = true
    end
    return found
end


---------
function BGD_isInBG()
---------
    local zone = GetZoneText()
    local found = false
    if ((zone == BGD_AV)  or (zone == BGD_AB)   or (zone == BGD_WSG)  or (zone == BGD_WSL) or 
	    (zone == BGD_SWH) or (zone == BGD_EOTS) or (zone == BGD_SOTA) or (zone == BGD_IOC) or
		(zone == BGD_TP)  or (zone == BGD_GIL)) then
        found = true
    elseif (BGD_isInRaidBG()) then
        found = true
    end
    return found
end


---------
function BGD_ShowStatus()
---------
    DEFAULT_CHAT_FRAME:AddMessage(" ", 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("BG Defender Version |cFF00FF00"..GetAddOnMetadata("BGDefender", "Version").."|r Status", 1.0, 0.5, 0.0)
    
    if (BGD_Prefs.ShowUI == true) then
        DEFAULT_CHAT_FRAME:AddMessage("    UI Visible: |cFF00FF00Yes", 1.0, 0.5, 0.0)
    else
        DEFAULT_CHAT_FRAME:AddMessage("    UI Visible: |cFFFF0000No|r (/bgd to display)", 1.0, 0.5, 0.0)
    end
    DEFAULT_CHAT_FRAME:AddMessage("    Battleground Channel: |cFF00FF00"..BGD_Prefs.BGChat, 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("    World Zone Channel: |cFF00FF00"..BGD_Prefs.RaidChat, 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("    Zone: |cFF00FF00"..GetZoneText().."|r (|cFF00FF00"..GetSubZoneText().."|r)", 1.0, 0.5, 0.0)
    if (BGD_isInBG()) then
        DEFAULT_CHAT_FRAME:AddMessage("    BG zone? |cFF00FF00Yes", 1.0, 0.5, 0.0)
    else
        DEFAULT_CHAT_FRAME:AddMessage("    BG zone? |cFFFF0000No", 1.0, 0.5, 0.0)
    end
    DEFAULT_CHAT_FRAME:AddMessage("    Battleground Zones: ", 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("        "..BGD_AV..", "..BGD_AB..", "..BGD_WSG..",", 1.0, 1.0, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("        "..BGD_EOTS..", "..BGD_SOTA..", "..BGD_IOC..",", 1.0, 1.0, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("        "..BGD_TP..", "..BGD_GIL, 1.0, 1.0, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("    World PVP Zones: ", 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("        "..BGD_WG..", "..BGD_TB, 1.0, 1.0, 1.0)
    if (BGD_Prefs.preface == true) then
        DEFAULT_CHAT_FRAME:AddMessage("    Preface text |cFF00FF00BGDefender:|r will be shown before messages", 1.0, 0.5, 0.5)
    end
end


---------
function BGD_Toggle(state)
---------
    local frame  = getglobal("BGDefenderFrame")
    local status = nil
    if (frame) then
        if (state == false) then
            frame:Hide()
            status = false
        elseif (state == true) then
            frame:Show()
            status = true
        else
            if(frame:IsVisible()) then
                frame:Hide()
                status = false
            else
                frame:Show()
                status = true
            end
        end
        return status
    end
end


---------
function BGD_Close()
---------
    BGD_Prefs.ShowUI = BGD_Toggle(false)
end


---------
function BGD_Options_Open()
---------
    BGD_Prefs.BGChatTemp = BGD_Prefs.BGChat
    BGD_Prefs.RaidChatTemp = BGD_Prefs.RaidChat
    BGD_Opt_Frame_UpdateViews()
    InterfaceOptionsFrame_OpenToCategory(BGD_Opt_Frame)
end


---------
function BGD_Opt_Frame_OnLoad(BGD_Opt_Frame)
---------
    BGD_Opt_Frame.name = "Battleground Defender V"..GetAddOnMetadata("BGDefender", "Version")
    BGD_Opt_Frame.okay = function (self) BGD_Opt_Frame_Okay(); end
    BGD_Opt_Frame.default = function (self) BGD_Settings_Default(); BGD_Opt_Frame_UpdateViews(); end
    InterfaceOptions_AddCategory(BGD_Opt_Frame)
end


---------
function BGD_Opt_Frame_Okay()
---------
    BGD_Prefs.BGChat = BGD_Prefs.BGChatTemp
    BGD_Prefs.RaidChat = BGD_Prefs.RaidChatTemp
end


---------
function BGD_Settings_Default()
---------
    BGD_Prefs = {}
    BGD_Prefs.Title = GetAddOnMetadata("BGDefender", "Title")
    BGD_Prefs.RaidChat = "RAID"
    BGD_Prefs.RaidChatTemp = "RAID"
    BGD_Prefs.BGChat = "BATTLEGROUND"
    BGD_Prefs.BGChatTemp = "BATTLEGROUND"
    BGD_Prefs.version = GetAddOnMetadata("BGDefender", "Version")
    BGD_Prefs.preface = true
    BGD_Prefs.ShowUI = BGD_isInBG()
end


BGD_Opt_Title = nil
BGD_Opt_Txt1 = nil
BGD_Opt_Txt2 = nil
BGD_Opt_Txt3 = nil
BGD_Opt_Txt4 = nil
BGD_Opt_Drop1 = nil
BGD_Opt_Drop2 = nil
BGD_Opt_Btn1 = nil

---------
function BGD_Opt_Frame_Setup()
---------
    if (BGD_Opt_Title == nil) then
        BGD_Opt_Title = BGD_Opt_Frame:CreateFontString( nil, "ARTWORK", "GameFontNormalLarge" )
        BGD_Opt_Title:SetPoint( "TOPLEFT", 16, -16 )
        BGD_Opt_Title:SetText( BGD_Prefs.Title .. " V" .. GetAddOnMetadata("BGDefender", "Version"))
    end
    if (BGD_Opt_Txt1 == nil) then
        BGD_Opt_Txt1 = BGD_Opt_Frame:CreateFontString( nil, "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Txt1:SetPoint( "TOPLEFT", "BGD_Opt_Title", "BOTTOMLEFT", 16, -16 )
        BGD_Opt_Txt1:SetText( "Battleground announcement channel: " )
    end
    if (BGD_Opt_Drop1 == nil) then
        BGD_Opt_Drop1 = CreateFrame("Frame", "DropDown1", BGD_Opt_Frame, "UIDropDownMenuTemplate");
        BGD_Opt_Drop1:SetPoint("TOPLEFT", "BGD_Opt_Txt1", "TOPRIGHT", 0, 8)
        UIDropDownMenu_Initialize(BGD_Opt_Drop1, BGD_Opt_Drop1_Initialize);
    end
    if (BGD_Opt_Txt2 == nil) then
        BGD_Opt_Txt2 = BGD_Opt_Frame:CreateFontString( nil, "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Txt2:SetPoint( "TOPLEFT", "BGD_Opt_Txt1", "BOTTOMLEFT", 0, -32 )
        BGD_Opt_Txt2:SetText( "World Zone PVP announcement channel: " )
    end
    if (BGD_Opt_Drop2 == nil) then
        BGD_Opt_Drop2 = CreateFrame("Frame", "DropDown2", BGD_Opt_Frame, "UIDropDownMenuTemplate");
        BGD_Opt_Drop2:SetPoint("TOPLEFT", "DropDown1", "BOTTOMLEFT", 0, -10)
        UIDropDownMenu_Initialize(BGD_Opt_Drop2, BGD_Opt_Drop2_Initialize);
    end
    if (BGD_Opt_Txt3 == nil) then
        BGD_Opt_Txt3 = BGD_Opt_Frame:CreateFontString( nil, "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Txt3:SetPoint( "TOPLEFT", 16, -128 )
        BGD_Opt_Txt3:SetText( "Caution when using "..BGD_GENERAL.." chat because");
        BGD_Opt_Txt3:Hide()
    end
    if (BGD_Opt_Txt4 == nil) then
        BGD_Opt_Txt4 = BGD_Opt_Frame:CreateFontString( nil, "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Txt4:SetPoint( "TOPLEFT", 16, -144 )
        BGD_Opt_Txt4:SetText( "Blizzard limits how quickly messages can be posted." )
        BGD_Opt_Txt4:Hide()
    end
    if (BGD_Opt_Btn1 == nil) then
        BGD_Opt_Btn1 = CreateFrame("CheckButton", "BGDefenderPrefaceButton", BGD_Opt_Frame)
        BGD_Opt_Btn1:SetWidth(26)
        BGD_Opt_Btn1:SetHeight(26)
        BGD_Opt_Btn1:SetPoint("TOPLEFT", 16, -200)
        BGD_Opt_Btn1:SetScript("OnClick", function(frame)
            local tick = frame:GetChecked()
            if tick then
                BGD_Prefs.preface = true
            else
                BGD_Prefs.preface = false
            end
        end)
    	BGD_Opt_Btn1:SetHitRectInsets(0, -180, 0, 0)
	    BGD_Opt_Btn1:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	    BGD_Opt_Btn1:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	    BGD_Opt_Btn1:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	    BGD_Opt_Btn1:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
    	local BGD_Opt_Btn1Text = BGD_Opt_Btn1:CreateFontString("BGD_Opt_Btn1Text", "ARTWORK", "GameFontHighlight")
	    BGD_Opt_Btn1Text:SetPoint("LEFT", BGD_Opt_Btn1, "RIGHT", 0, 1)
	    BGD_Opt_Btn1Text:SetText("Display |cFF00FF00BGDefender:|r before each message")
	    BGD_Opt_Btn1:SetChecked(BGD_Prefs.preface)
    end
end



---------
function BGD_Opt_Drop1_Initialize()
---------
    local info = {}
    info = {}
    info.text = "Battleground"
    info.checked = (BGD_Prefs.BGChatTemp == "BATTLEGROUND")
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = "BATTLEGROUND"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "Raid"
    info.checked = (BGD_Prefs.BGChatTemp == "RAID")
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = "RAID"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
    
    info = {}
    info.text = "Party"
    info.checked = (BGD_Prefs.BGChatTemp == "PARTY")
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = "PARTY"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
    
    info = {}
    info.text = BGD_GENERAL
    info.checked = (BGD_Prefs.BGChatTemp == BGD_GENERAL)
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = BGD_GENERAL
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "Yell"
    info.checked = (BGD_Prefs.BGChatTemp == "YELL")
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = "YELL"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
end


---------
function BGD_Opt_Drop2_Initialize()
---------
    local info = {}
    info = {}
    info.text = "Raid"
    info.checked = (BGD_Prefs.RaidChatTemp == "RAID")
    function info.func(arg1, arg2)
        BGD_Prefs.RaidChatTemp = "RAID"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
    
    info = {}
    info.text = "Party"
    info.checked = (BGD_Prefs.RaidChatTemp == "PARTY")
    function info.func(arg1, arg2)
        BGD_Prefs.RaidChatTemp = "PARTY"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
    
    info = {}
    info.text = BGD_GENERAL
    info.checked = (BGD_Prefs.RaidChatTemp == BGD_GENERAL)
    function info.func(arg1, arg2)
        BGD_Prefs.RaidChatTemp = BGD_GENERAL
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "Yell"
    info.checked = (BGD_Prefs.RaidChatTemp == "YELL")
    function info.func(arg1, arg2)
        BGD_Prefs.RaidChatTemp = "YELL"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
end
 
---------
function BGD_Opt_Frame_UpdateViews()
---------
    BGD_Opt_Txt3:Hide()
    BGD_Opt_Txt4:Hide()
    if (BGD_Prefs.BGChatTemp == "BATTLEGROUND") then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, "Battleground")
    elseif (BGD_Prefs.BGChatTemp == "RAID") then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, "Raid")
    elseif (BGD_Prefs.BGChatTemp == "PARTY") then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, "Party")
    elseif (BGD_Prefs.BGChatTemp == BGD_GENERAL) then
        BGD_Opt_Txt3:Show()
        BGD_Opt_Txt4:Show()
        UIDropDownMenu_SetText(BGD_Opt_Drop1, BGD_GENERAL)
    elseif (BGD_Prefs.BGChatTemp == "YELL") then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, "Yell")
    end
    
    if (BGD_Prefs.RaidChatTemp == "RAID") then
        UIDropDownMenu_SetText(BGD_Opt_Drop2, "Raid")
    elseif (BGD_Prefs.RaidChatTemp == "PARTY") then
        UIDropDownMenu_SetText(BGD_Opt_Drop2, "Party")
    elseif (BGD_Prefs.RaidChatTemp == BGD_GENERAL) then
        BGD_Opt_Txt3:Show()
        BGD_Opt_Txt4:Show()
        UIDropDownMenu_SetText(BGD_Opt_Drop2, BGD_GENERAL)
    elseif (BGD_Prefs.RaidChatTemp == "YELL") then
        UIDropDownMenu_SetText(BGD_Opt_Drop2, "Yell")
    end
	
    BGD_Opt_Btn1:SetChecked(BGD_Prefs.preface)
end