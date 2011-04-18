LibTransition = LibStub("LibTransition-1.0");
Combustion_UpdateInterval = 0.1; -- How often the OnUpdate code will run (in seconds)
local lvb,ffb,ignite,pyro1,pyro2,comb,impact,CritMass,ShadowMast,combulbtimer,combuffbtimer,combupyrotimer,combuignitetimer,combucrittimer,combupyrocast
local LBTime,FFBTime,IgnTime,PyroTime,CombustionUp,ffbglyph,combufadeout,impactup,ffbheight,critheight,combucritwidthl,lbraidcheck,lbtablerefresh,combuimpacttimer
local combulbrefresh,lbraidcheck,lbtablerefresh,lbgroupsuffix,lbtargetsuffix,lbgroupnumber,lbtrackerheight,lbframeprefix,combupyrogain,combupyrorefresh
                                               
function Combustion_OnLoad(CombustionFrame) 
                                               
    if select(2, UnitClass("player")) ~= "MAGE" then CombustionFrame:Hide() return end
        
	CombustionFrame:RegisterForDrag("LeftButton")
	CombustionFrame:RegisterEvent("PLAYER_LOGIN")
	CombustionFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
	CombustionFrame:RegisterEvent("GLYPH_ADDED")
	CombustionFrame:RegisterEvent("GLYPH_REMOVED")
	CombustionFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	CombustionFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
 	CombustionFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
 
    lvb = GetSpellInfo(44457) 
    ffb = GetSpellInfo(44614) 
    ignite = GetSpellInfo(12654) 
    pyro1 = GetSpellInfo(11366) 
    pyro2 = GetSpellInfo(92315) 
    comb = GetSpellInfo(11129)   
    impact = GetSpellInfo(64343)
    CritMass = GetSpellInfo(22959)
    ShadowMast = GetSpellInfo(17800)
    combudot = GetSpellInfo(83853)
    
    LibTransition:Attach(CombustionFrame)

            	   	
-------------------------------
--Default values    
    if (combuffb == nil) then combuffb = true end
    if (combuautohide == nil) or (combuautohide == false) or (combuautohide == true) then combuautohide = 1 end -- set autohide off as default upon very first launch
    if (combuimpact == nil) then combuimpact = true end-- set impact mode on as default upon very first launch
    if (combuscale == nil) then combuscale = 1 end-- set scale default upon very first launch
    if (combubeforefade == nil) then combubeforefade = 15 end-- set before fade out autohide upon very first launch
    if (combuafterfade == nil) then combuafterfade = 15 end-- set before fade in autohide upon very first launch
    if (combufadeoutspeed == nil) then combufadeoutspeed = 2 end-- set fade out speed default upon very first launch
    if (combufadeinspeed == nil) then combufadeinspeed = 2 end-- set fade in speed default upon very first launch
    if (combuwaitfade == nil) then combuwaitfade = 86 end-- set faded time autohide default upon very first launch
    if (combufadealpha == nil) then combufadealpha = 0 end-- set alpha value for fade upon very first launch
    if (combubartimers == nil) then combubartimers = false end-- set bar timers upon very first launch
	if (combubarwidth == nil) then combubarwidth = 24 end-- set bar timers width upon very first launch
    if (combured == nil) then combured = 0 end-- set alpha value for fade upon very first launch
    if (combugreen == nil) then combugreen = 0.5 end-- set bar timers upon very first launch
	if (combublue == nil) then combublue = 0.8 end-- set bar timers width upon very first launch
	if (combuopacity == nil) then combuopacity = 1 end-- set bar timers width upon very first launch
	if (combucrit == nil) then combucrit = true end-- set bar timers width upon very first launch
	if (comburefreshmode == nil) then comburefreshmode = true end-- set LB refresh warning mode upon very first launch
    if (combureport == nil) then combureport = true end -- set DPS report on upon very first launch
    if (combureportvalue == nil) then combureportvalue = 0 end -- set DPS report value on upon very first launch
    if (combureportthreshold == nil) then combureportthreshold = false end -- set DPS report threshold on upon very first launch
    if (combureportpyro == nil) then combureportpyro = true end -- set Pyro report on upon very first launch
    if (combutrack == nil) then combutrack = true end -- set combustion dot tracker upon very first launch
    if (combuchat==nil) then combuchat = true end -- set status report upon very first launch 
    if (combulbtracker==nil) then combulbtracker = true end -- set living bomb tracker upon very first launch 
    if (combulbtarget==nil) then combulbtarget = false end -- set lb tracker complete mode upon very first launch 
    if (combulbup==nil) then combulbup = true end -- set lb tracker upward upon very first launch 
    if (combulbdown==nil) then combulbdown = false end -- set lb tracker upward upon very first launch 
    if (combulbright==nil) then combulbup = false end -- set lb tracker upward upon very first launch 
    if (combulbleft==nil) then combulbup = false end -- set lb tracker upward upon very first launch 
    if (combutimervalue==nil) then combutimervalue = 2 end -- set red zone timer value upon very first launch 
	combupyrogain = 0
   	combupyrorefresh = 0
   	combupyrocast = 0
   	combulbrefresh = 0

end

-------------------------------
-- helper function for option panel setup
function CombustionHelperOptions_OnLoad(panel)
	panel.name = "CombustionHelper"
	InterfaceOptions_AddCategory(panel);
end

-------------------------------
-- lock function for option panel
function Combustionlock()

	if CombulockButton:GetChecked(true) then combulock = true 
                                 CombustionFrame:EnableMouse(false)
                                 CombulockButton:SetChecked(true)
                                 if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffCombustionHelper locked|r") end
	else combulock = false 
         CombustionFrame:EnableMouse(true)
         CombulockButton:SetChecked(false)
         if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffCombustionHelper unlocked|r") end
	end
end

-------------------------------
-- chat function for option panel
function Combustionchat()

	if CombuchatButton:GetChecked(true) then combuchat = true 
                                 CombuchatButton:SetChecked(true)
                                 ChatFrame1:AddMessage("|cff00ffffCombustionHelper status report enabled|r")
	else combuchat = false 
         CombuchatButton:SetChecked(false)
	end
end

-------------------------------
-- lock function for option panel
function Combustionthreshold()

	if Combureportthreshold:GetChecked(true) then combureportthreshold = true 
                                 Combureportthreshold:SetChecked(true)
	else combureportthreshold = false 
         Combureportthreshold:SetChecked(false)
	end
end

-------------------------------
-- ffb function for option panel
function Combustionffb()

	if CombuffbButton:GetChecked(true) then combuffb = true 
                                 CombuffbButton:SetChecked(true)
                                 if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffFrostFire Bolt mode enabled|r") end
	else combuffb = false 
         CombuffbButton:SetChecked(false)
         if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffFrostFire Bolt mode disabled|r") end
	end
    CombustionFrameresize()
end

-------------------------------
-- DPS Report function for option panel
function Combustionreport()

	if CombureportButton:GetChecked(true) then combureport = true 
                                             CombureportButton:SetChecked(true)
                                             if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffDamage report mode enabled|r") end
	else combureport = false 
         CombureportButton:SetChecked(false)
         if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffDamage report mode disabled|r") end
	end
end

-------------------------------
-- combustion dot tracker function for option panel
function Combustiontracker()

	if CombutrackerButton:GetChecked(true) then combutrack = true 
                                             CombutrackerButton:SetChecked(true)
                                             if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffCombustion dot tracker enabled|r") end
	else combutrack = false 
         CombutrackerButton:SetChecked(false)
         if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffCombustion dot tracker disabled|r") end
	end
end

-------------------------------
-- lb refresh function for option panel
function Combustionrefresh()

	if ComburefreshButton:GetChecked(true) then comburefreshmode = true 
                                                ComburefreshButton:SetChecked(true)
                                                if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffEarly LB refresh mode enabled|r") end
	else comburefreshmode = false 
         ComburefreshButton:SetChecked(false)
         if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffEarly LB refresh mode disabled|r") end
	end
end

-------------------------------
-- pyro refresh function for option panel
function CombustionrefreshPyro()

	if ComburefreshpyroButton:GetChecked(true) then combureportpyro = true 
                                                ComburefreshpyroButton:SetChecked(true)
                                                if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffPyroblast report mode enabled|r") end
	else combureportpyro = false 
         ComburefreshpyroButton:SetChecked(false)
         if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffPyroblast refresh mode disabled|r") end
	end
end

-------------------------------
-- impact function for option panel
function Combustionimpact()

	if CombuimpactButton:GetChecked(true) then combuimpact = true 
                                               CombuimpactButton:SetChecked(true)
                                               if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffImpact mode enabled|r") end
	else combuimpact = false 
         CombuimpactButton:SetChecked(false)
         if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffImpact mode disabled|r") end
	end
end

-------------------------------
-- Scale function for option panel
function CombustionScale (scale)

	CombustionFrame:SetScale(scale)
	combuscale = scale
end

-------------------------------
-- Bar timer function for option panel
function Combustionbar()

	if CombuBarButton:GetChecked(true) then combubartimers = true 
                                            CombuBarButton:SetChecked(true)
                                            if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffBar timer mode enabled|r") end
	else combubartimers = false 
         CombuBarButton:SetChecked(false)
         if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffBar timer mode disabled|r") end
	end
    CombustionFrameresize()
end

-------------------------------
-- Critical Mass function for option panel
function Combustioncrit()

	if CombucritButton:GetChecked(true) then combucrit = true 
                                             CombucritButton:SetChecked(true)
                                             if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffCritical Mass tracker enabled|r") end
	else combucrit = false 
         CombucritButton:SetChecked(false)
         if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffCritical Mass tracker disabled|r") end
	end
    CombustionFrameresize()
end

-------------------------------
-- living bomb tracker target mode function for option panel
function CombustionLBtargettracker()

	if CombuLBtargetButton:GetChecked(true) then combulbtarget = true 
                                                 CombuLBtargetButton:SetChecked(true)
	else combulbtarget = false 
         CombuLBtargetButton:SetChecked(false)
	end
end

-------------------------------
-- Multiple Living Bomb tracker function for option panel
function CombustionLBtracker()

	if CombuLBtrackerButton:GetChecked(true) then combulbtracker = true 
                                             CombuLBtrackerButton:SetChecked(true)
                                             if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffLiving Bomb tracker enabled|r") end
	else combulbtracker = false 
         CombuLBtrackerButton:SetChecked(false)
         table.wipe(LBtrackertable)
         if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffLiving Bomb tracker disabled|r") end
	end
    CombustionFrameresize()
end

-------------------------------
-- Helper function for bar timer resizing
function CombustionFrameresize()
	
    if (combuffb == true) and (ffbglyph == true)
    then FFBButton:Show()
         FFBTextFrameLabel:Show()
         FFBLabel:Show()
         StatusTextFrameLabel:SetPoint("TOPLEFT",FFBLabel,"BOTTOMLEFT",0,0)
         ffbheight = 9
    else FFBButton:Hide()
         FFBTextFrameLabel:Hide()
         FFBLabel:Hide()
         StatusTextFrameLabel:SetPoint("TOPLEFT",PyroLabel,"BOTTOMLEFT",0,0)
         ffbheight = 0	
    end

    if (combucrit == true) 
    then CritTypeFrameLabel:Show()
         CritTypeFrameLabel:SetPoint("TOPLEFT",StatusTextFrameLabel,"BOTTOMLEFT",0,0)
         CritTextFrameLabel:Show()
         CritTextFrameLabel:SetPoint("TOPLEFT",StatusTextFrameLabel,"BOTTOMLEFT",0,0)
         critheight = 9
    else CritTypeFrameLabel:Hide()
         CritTypeFrameLabel:SetPoint("TOPLEFT",StatusTextFrameLabel,"BOTTOMLEFT",0,0)
         CritTextFrameLabel:Hide()
         CritTextFrameLabel:SetPoint("TOPLEFT",StatusTextFrameLabel,"BOTTOMLEFT",0,0)
         Critbar:Hide()
         critheight = 0
    end    
    
    CombustionFrame:SetHeight(48+ffbheight+critheight)

	if (combubartimers == true) 
	then CombustionFrame:SetWidth(98+combubarwidth+6)
		 FFBTextFrameLabel:SetWidth(28+combubarwidth+2)
		 FFBTextFrameLabel:SetJustifyH("RIGHT")
		 LBTextFrameLabel:SetWidth(28+combubarwidth+2)
		 LBTextFrameLabel:SetJustifyH("RIGHT")
		 PyroTextFrameLabel:SetWidth(28+combubarwidth+2)
		 PyroTextFrameLabel:SetJustifyH("RIGHT")
		 IgnTextFrameLabel:SetWidth(28+combubarwidth+2)
		 IgnTextFrameLabel:SetJustifyH("RIGHT")
		 CritTextFrameLabel:SetWidth(91+combubarwidth+2)
         combucritwidth = combubarwidth
	elseif (combubartimers == false) 
	then combucritwidth = (-7)
         CombustionFrame:SetWidth(98)
		 FFBTextFrameLabel:SetWidth(28)
		 FFBbar:Hide()
		 FFBTextFrameLabel:SetJustifyH("LEFT")
		 LBTextFrameLabel:SetWidth(28)
		 LBbar:Hide()
		 LBTextFrameLabel:SetJustifyH("LEFT")
		 PyroTextFrameLabel:SetWidth(28)
		 Pyrobar:Hide()
		 PyroTextFrameLabel:SetJustifyH("LEFT")
		 Ignbar:Hide()
		 IgnTextFrameLabel:SetWidth(28)
		 IgnTextFrameLabel:SetJustifyH("LEFT")
		 CritTextFrameLabel:SetWidth(86)
	end
	
	if (combulbtracker == true) then 
        if (combulbup == true)
            then LBtrackFrame:Show()
                 LBtrackdownFrame:Hide()
                 LBtrackFrame:SetFrameLevel((CombustionFrame:GetFrameLevel())-1)
                 LBtrackFrame:SetWidth((CombustionFrame:GetWidth())-10)
        elseif (combulbdown == true)
            then LBtrackFrame:Hide()
                 LBtrackdownFrame:Show()
                 LBtrackdownFrame:SetFrameLevel((CombustionFrame:GetFrameLevel())-1)
                 LBtrackdownFrame:SetWidth((CombustionFrame:GetWidth())-10)
                 LBtrackdownFrame:ClearAllPoints()
                 LBtrackdownFrame:SetPoint("TOP",CombustionFrame,"BOTTOM",0,6)
        elseif (combulbright == true)
            then LBtrackFrame:Hide()
                 LBtrackdownFrame:Show()
                 LBtrackdownFrame:SetFrameLevel((CombustionFrame:GetFrameLevel())-1)
                 LBtrackdownFrame:SetWidth(88)
                 LBtrackdownFrame:ClearAllPoints()
                 LBtrackdownFrame:SetPoint("TOPLEFT",CombustionFrame,"TOPRIGHT",-6,0)
        elseif (combulbleft == true)
            then LBtrackFrame:Hide()
                 LBtrackdownFrame:Show()
                 LBtrackdownFrame:SetFrameLevel((CombustionFrame:GetFrameLevel())-1)
                 LBtrackdownFrame:SetWidth(88)
                 LBtrackdownFrame:ClearAllPoints()
                 LBtrackdownFrame:SetPoint("TOPRIGHT",CombustionFrame,"TOPLEFT",6,0)
        end
    else LBtrackFrame:Hide()
         LBtrackdownFrame:Hide()
	end
	
    if (combulbup == true) 
        then lbframeprefix = "LBtrack"
    else lbframeprefix = "LBtrackdown"
    end
    
    for i = 1,3 do _G[lbframeprefix..i]:SetWidth(_G[lbframeprefix.."Frame"]:GetWidth()-41) end
    
end

-------------------------------
-- helper function reset Savedvariables
function Combustionreset ()
 		combulock = false
        combuffb = true
        combuautohide = 1
        combuimpact = true
        combuscale = 1
        combubeforefade = 15
		combuafterfade = 15
		combufadeoutspeed = 2
		combufadeinspeed = 2
		combuwaitfade = 86
		combufadealpha = 0
		combubartimers = false
		combured = 0
		combugreen = 0.5
		combublue = 0.8
		combuopacity = 1
        combucrit = true
        CombustionFrame:ClearAllPoints()
        CombustionFrame:SetPoint("CENTER", UIParent, "CENTER" ,0,0)
        CombustionFrame:SetScale(1)
        comburefreshmode = true
        combureport = true
        combureportvalue = 0
        combureportthreshold = false
        combureportpyro = true
        combutrack = true
        combuchat = true
        combulbtracker = true
        combulbup = true
        combulbdown = false
        combulbright = false
        combulbleft = false
        combulbtarget = true
        combutimervalue = 2
        ChatFrame1:AddMessage("|cff00ffffCombustionHelper Savedvariables have been resetted, you can logout now.|r")
end
	

-------------------------------
-- Color picker function
function CombuColorPicker()

 	ColorPickerFrame:SetColorRGB(combured,combugreen,combublue,combuopacity);
 	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (combuopacity ~= nil), combuopacity;
 	ColorPickerFrame.previousValues = {combured,combugreen,combublue,combuopacity};
 	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = CombuCallback, CombuCallback, CombuCallback;
 	ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
 	ColorPickerFrame:Show();

end

function CombuCallback ()

    combuopacity, combured, combugreen, combublue = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
    CombuColorSwatchNormalTexture:SetVertexColor(combured,combugreen,combublue,combuopacity)
	
end


-------------------------------
-- Helper function for ffb glyph check
function Combuffbglyphcheck ()

        local enabled1,_,_,id1 = GetGlyphSocketInfo(7)
        local enabled4,_,_,id4 = GetGlyphSocketInfo(8)
        local enabled6,_,_,id6 = GetGlyphSocketInfo(9)
         
	            if (id1 == 61205) and (ffbglyph == false) and (combutalent == true) 
	            then ffbglyph = true
                     combuffb = true
    	       		 CombustionFrameresize()
	                 if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffFrostfire Bolt glyph detected, FFB mode enabled|r") end
	            
	            elseif (id4 == 61205) and (ffbglyph == false) and (combutalent == true) 
	            then ffbglyph = true
                     combuffb = true
    	       		 CombustionFrameresize()
	                 if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffFrostfire Bolt glyph detected, FFB mode enabled|r") end
	            
	            elseif (id6 == 61205) and (ffbglyph == false) and (combutalent == true) 
	            then ffbglyph = true
                     combuffb = true
    	       		 CombustionFrameresize()
	                 if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffFrostfire Bolt glyph detected, FFB mode enabled|r") end
				
				elseif (id1 ~= 61205) and (id4 ~= 61205) and (id6 ~= 61205) and (ffbglyph == true) and (combutalent == true)
				then ffbglyph = false
					 CombustionFrameresize()
	                 if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffff No Frostfire Bolt glyph detected, FFB mode disabled|r") end
	            
                elseif (id1 ~= 61205) and (id4 ~= 61205) and (id6 ~= 61205) and (combuffb == true) 
				then ffbglyph = false
					 CombustionFrameresize()
	                 if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffff No Frostfire Bolt glyph detected, FFB mode disabled|r") end

                elseif (ffbglyph == false)
	            then CombustionFrameresize()

            	end 
end

-------------------------------
--table for increased critical damage meta
local CombuCritMeta = {
	34220, -- burning crusade
	41285, -- wrath of the lich king
	52291, -- cataclysm
    68780
};


-------------------------------
--empty table for living bomb tracking
LBtrackertable = {}

-------------------------------
--Helper function for living bomb tracking expiration time collecting
function CombuLBauratracker(targetguid, targetname, eventgettime)

	lbraidcheck = 0
	lbtablerefresh = 0
    lbgroupsuffix = nil
    lbtargetsuffix = nil
    
    if (GetNumRaidMembers() ~= 0) 
        then lbgroupsuffix = "raid"
             lbgroupnumber = GetNumRaidMembers()
    elseif (GetNumPartyMembers() ~= 0)
        then lbgroupsuffix = "party"
             lbgroupnumber = GetNumPartyMembers()
    end
    
    if (UnitGUID("target") == targetguid)
        then lbtargetsuffix = "target"
    elseif (UnitGUID("mouseover") == targetguid)
        then lbtargetsuffix = "mouseover"
    elseif (UnitGUID("focus") == targetguid)
        then lbtargetsuffix = "focus"
    end
        
    if combuimpacttimer and ((combuimpacttimer + 1) >= GetTime())
        then local a12,b12,c12,d12,e12,f12,g12,h12,i12,j12,k12 = UnitAura("target", lvb, nil, "PLAYER HARMFUL")
             for z = 1, #LBtrackertable do
             
                if ((LBtrackertable[z])[1] == targetguid) 
                    then (LBtrackertable[z])[3] = g12;
                         (LBtrackertable[z])[4] = f12;
                         (LBtrackertable[z])[5] = nil
                         lbtablerefresh = 1
                         break
                end 
             end
             
             if (lbtablerefresh == 1) then
             else table.insert(LBtrackertable, {targetguid, targetname, g12, f12})
             end
             
             lbraidcheck = 1
        
	elseif lbtargetsuffix and (UnitGUID(lbtargetsuffix) == targetguid)
        then local a12,b12,c12,d12,e12,f12,g12,h12,i12,j12,k12 = UnitAura(lbtargetsuffix, lvb, nil, "PLAYER HARMFUL")
             for z = 1, #LBtrackertable do
             
                if ((LBtrackertable[z])[1] == targetguid) 
                    then (LBtrackertable[z])[3] = g12;
                         (LBtrackertable[z])[4] = f12;
                         (LBtrackertable[z])[5] = GetRaidTargetIndex(lbtargetsuffix)
                         lbtablerefresh = 1
                         break
                end 
             end
             
             if (lbtablerefresh == 1) then
             else table.insert(LBtrackertable, {targetguid, targetname, g12, f12, GetRaidTargetIndex(lbtargetsuffix)})
             end
             
             lbraidcheck = 1
        
    elseif lbgroupsuffix then
        for i = 1, lbgroupnumber do -- first we check if a raid or party members target the LB's target to have an accurate expiration time with UnitAura
            
            if (UnitGUID(lbgroupsuffix..i.."-target") == targetguid) 
                then local a12,b12,c12,d12,e12,f12,g12,h12,i12,j12,k12 = UnitAura(lbgroupsuffix..i.."-target", lvb, nil, "PLAYER HARMFUL")
                     
                     for z = 1, #LBtrackertable do
                     
                        if ((LBtrackertable[z])[1] == targetguid) 
                            then (LBtrackertable[z])[3] = g12;
                                 (LBtrackertable[z])[4] = f12;
                                 (LBtrackertable[z])[5] = GetRaidTargetIndex(lbgroupsuffix..i.."-target")
                                 lbtablerefresh = 1
                                 break
                        end 
                     end
                     
                     if (lbtablerefresh == 1) then
                     else table.insert(LBtrackertable, {targetguid, targetname, g12, f12, GetRaidTargetIndex(lbgroupsuffix..i.."-target")})
                     end
                     
                     lbraidcheck = 1
                
            end
        end
    end
 	
 	if (lbraidcheck == 0) -- info with UnitAura have been collected, skipping this part.
        then for z = 1, #LBtrackertable do -- no raid members targetting the LB's target so using GetTime from event fired and 12 secs as duration
                 
                if ((LBtrackertable[z])[1] == targetguid) 
                    then (LBtrackertable[z])[3] = (eventgettime + 12);
                         (LBtrackertable[z])[4] = 12;
                         (LBtrackertable[z])[5] = nil
                         lbtablerefresh = 1
                         break
                end 
             end
                     
             if (lbtablerefresh == 1) then
             else table.insert(LBtrackertable, {targetguid, targetname, (eventgettime + 12), 12, nil})
             end
	end
end

function CombuLBtrackerUpdate()

    lbtrackerheight = 0
    
    if (combulbup == true) 
        then lbframeprefix = "LBtrack"
    else lbframeprefix = "LBtrackdown"
    end
    
    for i = 3,1,-1 do
    
    	if LBtrackertable[i] and ((LBtrackertable[i])[3] + 2) <= GetTime() 
    		then table.remove(LBtrackertable,i)
    	end
    	
        if (#LBtrackertable == 0) 
            then _G[lbframeprefix..i]:SetText("")
                 _G[lbframeprefix..i.."Timer"]:SetText("")
                 _G[lbframeprefix..i.."Bar"]:Hide()
                 _G[lbframeprefix..i.."Target"]:SetTexture("")
                 _G[lbframeprefix..i.."Symbol"]:SetTexture("")
                 _G[lbframeprefix.."Frame"]:Hide()
        elseif (#LBtrackertable == 1) and (UnitGUID("target") == (LBtrackertable[1])[1]) and (combulbtarget == false)
            then _G[lbframeprefix..i]:SetText("")
                 _G[lbframeprefix..i.."Timer"]:SetText("")
                 _G[lbframeprefix..i.."Bar"]:Hide()
                 _G[lbframeprefix..i.."Target"]:Hide()
                 _G[lbframeprefix..i.."Symbol"]:Hide()
                 _G[lbframeprefix.."Frame"]:Hide()
        elseif LBtrackertable[i] 
            then _G[lbframeprefix.."Frame"]:Show()
                 _G[lbframeprefix..i]:SetText((LBtrackertable[i])[2])
                 combulbtimer = (-1*(GetTime()-(LBtrackertable[i])[3]))

                 if (combulbtimer >= combutimervalue) then -- condition when timer is with more than 2 seconds left
                     _G[lbframeprefix..i.."Timer"]:SetText(format("|cff00ff00%.1f|r",combulbtimer))
                     _G[lbframeprefix..i.."Bar"]:Show()
                     _G[lbframeprefix..i.."Bar"]:SetWidth((_G[lbframeprefix.."Frame"]:GetWidth()-12)*(combulbtimer/(LBtrackertable[i])[4]))
                     _G[lbframeprefix..i.."Bar"]:SetVertexColor(combured, combugreen, combublue, combuopacity)
                 elseif (combulbtimer <= combutimervalue) and (combulbtimer >= 0) then -- condition when timer is with less than 2 seconds left
                     _G[lbframeprefix..i.."Timer"]:SetText(format("|cffff0000%.1f|r",combulbtimer))
                     _G[lbframeprefix..i.."Bar"]:Show()
                     _G[lbframeprefix..i.."Bar"]:SetWidth((_G[lbframeprefix.."Frame"]:GetWidth()-12)*(combulbtimer/(LBtrackertable[i])[4]))
                     _G[lbframeprefix..i.."Bar"]:SetVertexColor(1,0,0,combuopacity)
                 elseif (combulbtimer <= 0) then
                     _G[lbframeprefix..i.."Timer"]:SetText(format("|cffff0000%s|r","--"))
                 end
                 
                 if (LBtrackertable[i])[5] == nil then 
                    _G[lbframeprefix..i.."Symbol"]:SetTexture("")
                 else _G[lbframeprefix..i.."Symbol"]:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_"..(LBtrackertable[i])[5])
                 end
                 
                 if (UnitGUID("target") == (LBtrackertable[i])[1]) then
                    _G[lbframeprefix..i.."Target"]:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustion_target")
                 else _G[lbframeprefix..i.."Target"]:SetTexture("")
                 end
                 
                 lbtrackerheight = lbtrackerheight + 9
                 
        else 
             _G[lbframeprefix..i]:SetText("")
             _G[lbframeprefix..i.."Timer"]:SetText("")
             _G[lbframeprefix..i.."Bar"]:Hide()
             _G[lbframeprefix..i.."Target"]:SetTexture("")
             _G[lbframeprefix..i.."Symbol"]:SetTexture("")
        end
    end
    
    _G[lbframeprefix.."Frame"]:SetHeight(lbtrackerheight + 11)
    
end
                    
-------------------------------------------------------------------------------------------------------	
-------------------------------------------------------------------------------------------------------	
-------------------------------- ON_EVENT FUNCTION ----------------------------------------------------

function Combustion_OnEvent(self, event, ...)

    if (event == "PLAYER_LOGIN") then
    
	    if (CombustionFrame:GetFrameLevel() == 0) then
	        CombustionFrame:SetFrameLevel(1) -- fix when frame is at FrameLevel 0
	    end
	    
	    if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffCombustion Helper is loaded. Interface Panel -> Addons for Config.|r") end
    
-------------------------------
--Combustion spell check on startup    
        local a6 = IsSpellKnown(11129) -- check if combustion is in the spellbook
                
        if (a6 == false) 
	        then CombustionFrame:FadeOut(combufadeoutspeed,combufadealpha)
	             combutalent = false
        elseif (a6 == true) 
	        then CombustionFrame:FadeIn(combufadeinspeed)
	             combutalent = true
        end
        
-------------------------------
--frostfirebolt glyph check on startup
        local enabled1,_,_,id1 = GetGlyphSocketInfo(7)
        local enabled4,_,_,id4 = GetGlyphSocketInfo(8)
        local enabled6,_,_,id6 = GetGlyphSocketInfo(9)
         
	    if (id1 == 61205) or (id4 == 61205) or (id6 == 61205)
	    	then ffbglyph = true
	    else ffbglyph = false
             combuffb = false
        end 
                
-------------------------------
--Frame lock check on startup
        if (combulock == false) 
	 		then CombustionFrame:EnableMouse(true)
        elseif (combulock == true) 
	    	then CombustionFrame:EnableMouse(false)
        end	
            
-------------------------------
--autohide check on startup
        if (combuautohide == 2) or (combuautohide == 3)
      		then CombustionFrame:FadeOut(combufadeoutspeed,combufadealpha)
 	    end	
        
	    CombustionScale (combuscale) -- Scale check on startup
	    CombustionFrameresize() -- Combustion Frame size check on startup    

    end
	
-------------------------------
--Combustion spell check      
    if (event == "PLAYER_TALENT_UPDATE") then
      
            local a6 = IsSpellKnown(11129) -- check if combustion is in the spellbook
                
            if (a6 == false) and (combutalent == true) then
                    CombustionFrame:FadeOut(combufadeoutspeed,combufadealpha)
                    combutalent = false
                    if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffNo Combustion spell in Spellbook, CombustionHelper hiding now.|r") end
            elseif (a6 == true) and (combutalent == false) then
                    CombustionFrame:FadeIn(combufadeinspeed)
                    combutalent = true
                    if (combuchat==true) then ChatFrame1:AddMessage("|cff00ffffCombustion spell in Spellbook, CombustionHelper back in.|r") end
                    CombustionFrameresize()
            end

    end
    
-------------------------------
--frostfirebolt glyph check
    if (event == "GLYPH_ADDED") or (event == "GLYPH_REMOVED")
        then Combuffbglyphcheck ()
             
    end
    
-------------------------------
--Combat log events checks
    if (event=="COMBAT_LOG_EVENT_UNFILTERED") then

        local timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...)

            if (sourceName == UnitName("player")) then
            
-------------------------------------------
-- report event check 
				if (combureport == true) and (destGUID == UnitGUID("target")) then
					if (spellId == 44457) and (event == "SPELL_PERIODIC_DAMAGE") then 
						if (critical == 1) and (combumeta == true) then 
							combulbdamage = amount/2,03
						elseif (critical == 1) and (combumeta == false) then 
							combulbdamage = amount/2
						else combulbdamage = amount
						end
						LBLabel:SetText(format("%.0f Dmg", combulbdamage))
					elseif (spellId == 12654) and (event == "SPELL_PERIODIC_DAMAGE") then 
						combuigndamage = amount
						IgniteLabel:SetText(format("%.0f Dmg", combuigndamage))
					elseif ((spellId == 11366) and (event == "SPELL_PERIODIC_DAMAGE")) or ((spellId == 92315) and (event == "SPELL_PERIODIC_DAMAGE")) then 
						if (critical == 1) and (combumeta == true) then 
							combupyrodamage = amount/2,03
						elseif (critical == 1) and (combumeta == false) then 
							combupyrodamage = amount/2
						else combupyrodamage = amount
						end
						PyroLabel:SetText(format("%.0f Dmg", combupyrodamage))
					elseif (spellId == 44614) and (event == "SPELL_PERIODIC_DAMAGE") then 
						if (critical == 1) and (combumeta == true) then 
							combuffbdamage = amount/2,03
						elseif (critical == 1) and (combumeta == false) then 
							combuffbdamage = amount/2
						else combuffbdamage = amount
						end
						FFBLabel:SetText(format("%.0f Dmg", combuffbdamage))
					end
				end
                
-------------------------------------------
-- Living Bomb early refresh 
                if (comburefreshmode == true) and (spellId == 44457) then
                    if (event == "SPELL_AURA_REFRESH")
                        then combulbrefresh = combulbrefresh + 1
                             print(format("|cffff0000 -- You refreshed your Living bomb on |cffffffff%s |cffff0000too early. --|r",destName))
                    elseif (event == "SPELL_MISSED") 
                        then PlaySoundFile("Sound\\Spells\\SimonGame_Visual_BadPress.wav")
                             print(format("|cffff00ff -- Living Bomb cast on |cffffffff%s |cffff00ffmissed !! --",destName))
                    end
                end

-------------------------------------------
-- Living Bomb tracking 
                if (combulbtracker == true) and (spellId == 44457) then 
                	if (event == "SPELL_AURA_APPLIED") or (event == "SPELL_AURA_REFRESH") 
                		then CombuLBauratracker(destGUID, destName, GetTime())
                	elseif (event == "SPELL_AURA_REMOVED") 
                		then for i = 1,#LBtrackertable do
                 
								if LBtrackertable[i] and ((LBtrackertable[i])[1] == destGUID) 
                 					then table.remove(LBtrackertable,i)
                                         break
                 			 	end
                 			 end
                	end
                end
                
                -- Impact manager for LB tracking
                if (spellId == 2136) and (event == "SPELL_CAST_SUCCESS") -- successful impact cast
                    then combuimpacttimer = GetTime()
                elseif (spellId == 2136) and (event == "SPELL_MISSED")
                    then combuimpacttimer = nil
                end

-------------------------------------------
-- Pyroblast buff report 
                if (combureportpyro == true) then
                	if (spellId == 48108) and (event == "SPELL_AURA_APPLIED")
	                    then combupyrogain = combupyrogain + 1
	                elseif (spellId == 48108) and (event == "SPELL_AURA_REFRESH")
	                    then combupyrorefresh = combupyrorefresh + 1
	                    	print(format("|cffff0000 -- You just wasted a Hot Streak, it got refreshed before getting used. --|r"))
					elseif ((spellId == 11366) and (event == "SPELL_CAST_SUCCESS")) or ((spellId == 92315) and (event == "SPELL_CAST_SUCCESS"))  
	                    then combupyrocast = combupyrocast + 1
	                end
	            end
            end
    end
                
-------------------------------------------
-- Start and End of fight events 
    if (event == "PLAYER_REGEN_DISABLED") then 
    	
    	local gem1, gem2, gem3 = GetInventoryItemGems(1)
        
		if CombuCritMeta[gem1] or CombuCritMeta[gem2] or CombuCritMeta[gem3] 
			then combumeta = true
		else combumeta = false
		end  
		 
		if (combuautohide ~= 1) and (combutalent == true)-- autoshow when in combat
			then CombustionFrame:FadeIn(combufadeinspeed)
		end
    
    elseif (event == "PLAYER_REGEN_ENABLED") then 
    
    	if (combuautohide ~= 1) and (combutalent == true)-- autohide when out of combat
        	then CombustionFrame:FadeOut(combufadeoutspeed,combufadealpha)
        end
    
    	if (combulbrefresh >= 1) then
        	print(format("|cffff0000 -- Earlier Living bomb refresh for this fight : |cffffffff%d |cffff0000--|r",combulbrefresh))
        	combulbrefresh = 0
        end
    
        if (combureportpyro == true) and (combupyrogain ~= 0) then
            print(format("|cffff0000 -- Hot Streak gained : |cffffffff%d  |cffff0000-- Hot Streak casted : |cffffffff%d  / %d%% |cffff0000--|r",combupyrogain + combupyrorefresh, combupyrocast, (100*(combupyrocast/(combupyrogain + combupyrorefresh)))))
            combupyrogain = 0
        	combupyrorefresh = 0
        	combupyrocast = 0
        end
        
        table.wipe(LBtrackertable) -- cleaning multiple LB tracker table when leaving combat
    end
-------------------------------
end
	
	
-------------------------------------------------------------------------------------------------------	
-------------------------------------------------------------------------------------------------------	
-------------------------------- ON_UPDATE FUNCTION ----------------------------------------------------

function Combustion_OnUpdate(self, elapsed)
    self.TimeSinceLastUpdate = (self.TimeSinceLastUpdate or 0) + elapsed;
 
		if (self.TimeSinceLastUpdate > Combustion_UpdateInterval) then
            local time = GetTime()   
            
-------------------------------
--Living Bomb part
		local a,b,c,d,e,f,g,h,i,j,k = UnitAura("target", lvb, nil, "PLAYER HARMFUL")		
		
		if (k==44457) then 
			combulbtimer = (-1*(time-g))
		else combulbtimer = 0
			combulbdamage = 0
		end
		
		if (combulbtimer >= combutimervalue) and (combulbtimer ~= 0) then -- condition when timer is with more than 2 seconds left
			LBTextFrameLabel:SetText(format("|cff00ff00%.1f|r",combulbtimer))
			LBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			LBTime = 1
		elseif (combulbtimer <= combutimervalue) and (combulbtimer ~= 0) then -- condition when timer is with less than 2 seconds left
			LBTextFrameLabel:SetText(format("|cffff0000%.1f|r",combulbtimer))
			LBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			LBTime = 0
		else LBTextFrameLabel:SetText(format("|cffff0000LB|r")) 
			LBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionoff") -- Text in red
			LBLabel:SetText(format("Living Bomb"))
			LBTime = 0
		end
			
		if (combubartimers == true) and (k==44457) and (combulbtimer <= combutimervalue) then
			LBbar:Show()
			LBbar:SetWidth((28+combubarwidth)*((-1*(GetTime()-g))/f))
			LBbar:SetVertexColor(1,0,0,combuopacity)
		elseif (combubartimers == true) and (k==44457) then 
			LBbar:Show()
			LBbar:SetWidth((28+combubarwidth)*((-1*(GetTime()-g))/f)) 			
			LBbar:SetVertexColor(combured, combugreen, combublue, combuopacity)
		else LBbar:Hide()
		end
			
--------------------------------
--FrostfireBolt part
		local a1,b1,c1,d1,e1,f1,g1,h1,i1,j1,k1 = UnitAura("target", ffb, nil, "PLAYER HARMFUL")		
		
		if (k1==44614) then 
			combuffbtimer = (-1*(time-g1))
		else combuffbtimer = 0
			combuffbdamage = 0
		end

 		if (ffbglyph == false) or (combuffb == false) then 
			FFBTime = 1
			FFBTextFrameLabel:SetText(format("|cffff0000Glyph|r"))
		elseif (combuffbtimer >= combutimervalue) and (combuffbtimer ~= 0) then -- condition when timer is with more than 2 seconds left
			FFBTextFrameLabel:SetText(format("|cff00ff00%.1f/%d|r",combuffbtimer,(d1)))
			FFBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			FFBTime = 1
		elseif (combuffbtimer <= combutimervalue) and (combuffbtimer ~= 0) then -- condition when timer is with less than 2 seconds left
			FFBTextFrameLabel:SetText(format("|cffff0000%.1f/%d|r",combuffbtimer,(d1)))
			FFBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			FFBTime = 0
		else FFBTextFrameLabel:SetText(format("|cffff0000FFB|r"))
			FFBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionoff") -- Text in red
			FFBLabel:SetText(format("FrostFire Bolt"))
			FFBTime = 0
		end
			
		if (combubartimers == true) and (k1==44614) and (combuffbtimer <= combutimervalue) then 
			FFBbar:Show()
			FFBbar:SetWidth((28+combubarwidth)*((-1*(GetTime()-g1))/f1))
			FFBbar:SetVertexColor(1,0,0,combuopacity)
		elseif (combubartimers == true) and (k1==44614) then 
			FFBbar:Show()
			FFBbar:SetWidth((28+combubarwidth)*((-1*(GetTime()-g1))/f1))
			FFBbar:SetVertexColor(combured, combugreen, combublue, combuopacity)
		else FFBbar:Hide()
		end
			
--------------------------------
--Ignite part
		local a2,b2,c2,d2,e2,f2,g2,h2,i2,j2,k2 = UnitAura("target", ignite, nil, "PLAYER HARMFUL")
		
		if (k2==12654) then 
			combuignitetimer = (-1*(time-g2))
		else combuignitetimer = 0
			combuigndamage = 0
		end
		
		if (combuignitetimer >= combutimervalue) and (combuignitetimer ~= 0) then -- condition when timer is with more than 2 seconds left
			IgnTextFrameLabel:SetText(format("|cff00ff00%.1f|r",combuignitetimer))
			IgniteButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			IgnTime = 1
		elseif (combuignitetimer <= combutimervalue) and (combuignitetimer ~= 0) then -- condition when timer is with less than 2 seconds left
			IgnTextFrameLabel:SetText(format("|cffff0000%.1f|r",combuignitetimer))
			IgniteButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			IgnTime = 0
		else IgnTextFrameLabel:SetText(format("|cffff0000Ign|r"))
			IgniteButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionoff") -- Text in red
			IgniteLabel:SetText(format("Ignite"))
			IgnTime = 0
		end
			
		if (combubartimers == true) and (k2==12654) and (combuignitetimer <= combutimervalue) then 
			Ignbar:Show()
			Ignbar:SetWidth((28+combubarwidth)*((-1*(GetTime()-g2))/f2))
			Ignbar:SetVertexColor(1,0,0,combuopacity)
		elseif (combubartimers == true) and (k2==12654) then 
			Ignbar:Show()
			Ignbar:SetWidth((28+combubarwidth)*((-1*(GetTime()-g2))/f2))
			Ignbar:SetVertexColor(combured, combugreen, combublue, combuopacity)
		else Ignbar:Hide()
		end
			
--------------------------------
--Pyroblast part
		local a3,b3,c3,d3,e3,f3,g3,h3,i3,j3,k3 = UnitAura("target", pyro1, nil, "PLAYER HARMFUL")		
		local a4,b4,c4,d4,e4,f4,g4,h4,i4,j4,k4 = UnitAura("target", pyro2, nil, "PLAYER HARMFUL")		
		
		if (k3==11366) then 
			combupyrotimer = (-1*(time-g3))
		elseif (k4==92315) then 
			combupyrotimer = (-1*(time-g4))
		else combupyrotimer = 0
			combupyrodamage = 0
		end
		
		if (combupyrotimer >= combutimervalue) and (combupyrotimer ~= 0) then -- condition when timer is with more than 2 seconds left
			PyroTextFrameLabel:SetText(format("|cff00ff00%.1f|r",combupyrotimer))
			PyroButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			PyroTime = 1
		elseif (combupyrotimer <= combutimervalue) and (combupyrotimer ~= 0) then -- condition when timer is with less than 2 seconds left
			PyroTextFrameLabel:SetText(format("|cffff0000%.1f|r",combupyrotimer))
			PyroButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			PyroTime = 0
		else PyroTextFrameLabel:SetText(format("|cffff0000Pyro|r"))
			PyroButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionoff") -- Text in red
			PyroLabel:SetText(format("Pyroblast"))
			PyroTime = 0
		end
            			
		if (combubartimers == true) and (k3==11366) and (combupyrotimer <= combutimervalue) then 
			Pyrobar:Show()
			Pyrobar:SetWidth((28+combubarwidth)*((-1*(GetTime()-g3))/f3))
			Pyrobar:SetVertexColor(1,0,0,combuopacity)
		elseif (combubartimers == true) and (k3==11366) then 
			Pyrobar:Show()
			Pyrobar:SetWidth((28+combubarwidth)*((-1*(GetTime()-g3))/f3))
			Pyrobar:SetVertexColor(combured, combugreen, combublue, combuopacity)
		elseif (combubartimers == true) and (k4==92315) and (combupyrotimer <= combutimervalue) then 
			Pyrobar:Show()
			Pyrobar:SetWidth((28+combubarwidth)*((-1*(GetTime()-g4))/f4))
			Pyrobar:SetVertexColor(1,0,0,combuopacity)
		elseif (combubartimers == true) and (k4==92315) then 
			Pyrobar:Show()
			Pyrobar:SetWidth((28+combubarwidth)*((-1*(GetTime()-g4))/f4))
			Pyrobar:SetVertexColor(combured, combugreen, combublue, combuopacity)
		else Pyrobar:Hide()
		end
		
--------------------------------
--Combustion/impact part
        local a5,b5,c5 = GetSpellCooldown(comb)
        local a7,b7,c7,d7,e7,f7,g7,h7,i7,j7,k7 = UnitAura("player", impact)
                
        if (b5 == nil) then
        elseif (b5<=2) and (combureport == true) and (InCombatLockdown() == 1) then -- to show dot total damage in combat with report enabled
            CombustionUp = 1
            ImpactUp = 0
            combufadeout = false
            combuchatautohide = 0
            if (combureportvalue <= (combulbdamage + combupyrodamage + combuigndamage + combuffbdamage)) and combureportthreshold then
                StatusTextFrameLabel:SetText(format("|cff00ff00Total : %.0f - CB Up|r", combulbdamage + combupyrodamage + combuigndamage + combuffbdamage))
            else StatusTextFrameLabel:SetText(format("|cffffcc00Total : %.0f - CB Up|r", combulbdamage + combupyrodamage + combuigndamage + combuffbdamage))
            end
        elseif (b5<=2) then -- condition when combustion cd is up, taking gcd in account
            StatusTextFrameLabel:SetText(format("Combustion Up !"))
            CombustionUp = 1
            ImpactUp = 0
            combufadeout = false
            combuchatautohide = 0
        elseif (b5>=2) and (k7 == 64343) and (combuimpact == true) then -- condition when impact is up and combustion in cd
            StatusTextFrameLabel:SetText(format("|cff00ff00Impact Up for %.1f !!|r",-1*(time-g7)))
            CombustionUp = 0
            ImpactUp = 1
            combufadeout = false
        elseif ((a5 + b5 - time)>=60) and (combufadeout == false) and (k7 == nil) then -- timer for combustion in minutes
            StatusTextFrameLabel:SetText(format("Combustion in %d:%0.2d",(a5 + b5 - time) / 60,(a5 + b5 - time) % 60 ))  
            CombustionUp = 0
            ImpactUp = 0
        elseif ((a5 + b5 - time)<=60) and (k7 == nil) then 
            StatusTextFrameLabel:SetText(format("Combustion in %.0fsec",(a5 + b5 - time)))  -- timer for combustion in seconds
            CombustionUp = 0	
            ImpactUp = 0
        end
            
--------------------------------
-- Critical Mass/shadow mastery tracking
    if (combucrit==true) then
            
        local a9,b9,c9,d9,e9,f9,g9,h9,i9,j9,k9 = UnitAura("target", CritMass, nil, "HARMFUL")
        local a10,b10,c10,d10,e10,f10,g10,h10,i10,j10,k10 = UnitAura("target", ShadowMast, nil, "HARMFUL")

        if (k9==22959) then combucrittimer = (-1*(time-g9))
        elseif (k10==17800) then combucrittimer = (-1*(time-g10))
        else combucrittimer = 0
        end

        if (combucrittimer >= combutimervalue) and (combucrittimer ~= 0) -- condition when timer is with more than 2 seconds left
                then CritTextFrameLabel:SetText(format("|cff00ff00%.1f|r",combucrittimer))
                     CritTextFrameLabel:SetJustifyH("RIGHT")
                     CritTypeFrameLabel:SetText(format("|cffffffff Critical Mass|r"))
        elseif (combucrittimer <= combutimervalue) and (combucrittimer ~= 0) -- condition when timer is with less than 2 seconds left
                then CritTextFrameLabel:SetText(format("|cffff0000%.1f|r",combucrittimer))
                     CritTextFrameLabel:SetJustifyH("RIGHT")
                     CritTypeFrameLabel:SetText(format("|cffffffff Critical Mass|r"))
        else CritTextFrameLabel:SetText(format("|cffff0000No Critical Mass !!|r"))
             CritTextFrameLabel:SetJustifyH("LEFT")
             CritTypeFrameLabel:SetText("")
        end
                    
        if (k9==22959) and (combucrittimer <= combutimervalue)
            then Critbar:Show()
             Critbar:SetWidth((92+combucritwidth)*((-1*(GetTime()-g9))/f9))
             Critbar:SetVertexColor(1,0,0,combuopacity)
        elseif (k9==22959)
            then Critbar:Show()
             Critbar:SetWidth((92+combucritwidth)*((-1*(GetTime()-g9))/f9))
             Critbar:SetVertexColor(combured, combugreen, combublue, combuopacity)
        elseif (k10==17800) and (combucrittimer <= combutimervalue) 
            then Critbar:Show()
             Critbar:SetWidth((92+combucritwidth)*((-1*(GetTime()-g10))/f10))
             Critbar:SetVertexColor(1,0,0,combuopacity)
        elseif (k10==17800) 
            then Critbar:Show()
             Critbar:SetWidth((92+combucritwidth)*((-1*(GetTime()-g10))/f10))
             Critbar:SetVertexColor(combured, combugreen, combublue, combuopacity)
        else Critbar:Hide()
        end
    end
            
--------------------------------
-- Combustion on target tracking
    if (combutrack==true) then
            
            local a11,b11,c11,d11,e11,f11,g11,h11,i11,j11,k11 = UnitAura("target", combudot, nil, "PLAYER HARMFUL")

			if (k11==83853) then combudottimer = (-1*(time-g11))
			else combudottimer = 0
			end

			if (k11==83853) and (combudottimer <= combutimervalue)
				then Combubar:Show()
                 Combubar:SetWidth((92+combucritwidth)*((-1*(GetTime()-g11))/f11))
                 Combubar:SetVertexColor(1,0,0,combuopacity)
			elseif (k11==83853)
				then Combubar:Show()
                 Combubar:SetWidth((92+combucritwidth)*((-1*(GetTime()-g11))/f11))
                 Combubar:SetVertexColor(combured, combugreen, combublue, combuopacity)
            else Combubar:Hide()
			end
    
    else
    end
    
--------------------------------
-- Background/border colors settings
    if (combureportthreshold == true) and (CombustionUp == 1) and (combureportvalue <= (combulbdamage + combupyrodamage + combuigndamage + combuffbdamage)) and (combureportvalue ~= 0) 
        then CombustionFrame:SetBackdropColor(0,0.7,0) --Green background for frame when threshold is met and combustion are up
             CombustionFrame:SetBackdropBorderColor(0,0.7,0)
    elseif (LBTime == 1) --Green background for frame when dots and combustion are up
        and (FFBTime == 1) 
        and (IgnTime == 1) 
        and (PyroTime == 1) 
        and (CombustionUp == 1)
        and (combureportthreshold == false) 
        then CombustionFrame:SetBackdropColor(0,0.7,0) --Green background for frame when dots and combustion are up
             CombustionFrame:SetBackdropBorderColor(0,0.7,0)
    elseif (combureportthreshold == true) and (CombustionUp == 0) and (ImpactUp == 1) and (combureportvalue <= (combulbdamage + combupyrodamage + combuigndamage + combuffbdamage)) 
        then CombustionFrame:SetBackdropColor(1,0.82,0.5) --yellow background for frame when threshold is met and impact are up
             CombustionFrame:SetBackdropBorderColor(1,0.82,0)
    elseif (LBTime == 1) --Yellow background for frame when dots and Impact are up
        and (FFBTime == 1) 
        and (IgnTime == 1) 
        and (PyroTime == 1) 
        and (ImpactUp == 1)
        and (CombustionUp == 0) 
        and (combureportthreshold == false) 
        then CombustionFrame:SetBackdropColor(1,0.82,0.5)
             CombustionFrame:SetBackdropBorderColor(1,0.82,0)
    elseif (k7 == 64343) -- yellow border when impact is up
        then CombustionFrame:SetBackdropColor(0.25,0.25,0.25)
             CombustionFrame:SetBackdropBorderColor(1,0.82,0)
    else CombustionFrame:SetBackdropColor(0.25,0.25,0.25)
         CombustionFrame:SetBackdropBorderColor(0.67,0.67,0.67)
    end
    
--------------------------------
 -- autohide part 
 	if (a5 == nil) then
	elseif ((a5 + b5 - time) <= (120 - combubeforefade)) and ((a5 + b5 - time) >= (combuafterfade + combufadeinspeed)) and (combufadeout == false) and (combuautohide == 3) then 
		combufadeout = true
	    StatusTextFrameLabel:SetText("Autohiding now.")
		CombustionFrame:FadeOut(combufadeoutspeed,combufadealpha);
		CombustionFrame:Wait(combuwaitfade);
		CombustionFrame:FadeIn(combufadeinspeed);
        if (combuchat==true) and (combuchatautohide == 0) 
        	then ChatFrame1:AddMessage(format("|cff00ffffCombustion Helper back in %d seconds|r", 120-combubeforefade-combuafterfade-combufadeoutspeed-combufadeinspeed))
        		 combuchatautohide = 1 
        end
	end
    
--------------------------------
-- multiple Living Bomb tracking
    if (combulbtracker == true)
        then CombuLBtrackerUpdate()
    end

--------------------------------
    self.TimeSinceLastUpdate = 0

    end    
end


SLASH_COMBUCONFIG1 = "/combustionhelper"

SlashCmdList["COMBUCONFIG"] = function(msg)

	if msg == "" or  msg == "help" or  msg == "?" or msg == "config" then
		 InterfaceOptionsFrame_OpenToCategory("CombustionHelper")
		 if (combuchat==true) then print(format("|cff00ffffOpening Combustion Helper config panel|r")) end
	else
		 InterfaceOptionsFrame_OpenToCategory("CombustionHelper")
		 if (combuchat==true) then print(format("|cff00ffffOpening Combustion Helper config panel|r")) end
	end

end