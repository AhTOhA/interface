-- Action Options
-- Adding an Option instructions
-- 1. Add the new option to ROB_NewActionDefaults table below
-- 2. Create the gui control in RotationBuilder.xml search for "ADD_OPTIONS_BELOW_THIS_LINE"
-- 3. Create the on click, on_update functions for new option search IF NEEDED for "ADD_OPTION_FUNCTIONS_BELOW_THIS"
-- 4. Have to retrieve and set gui values search for "RETRIEVE_NEW_OPTIONS_BELOW"
-- 5. Make sure your script calls in XML dont call the wrong functions

-- Rotation Options
-- 1. Create the new option/gui in xml search for "ROB_RotationNameInputBox" as example
-- 2. Update the rotations options when user clicks create button search for "UPDATE_ROTATION_OPTIONS1"
-- 3. Update the rotations options when user clicks modify button search for "UPDATE_ROTATION_OPTIONS2"
-- 4. Create the functions for the xml search for "ROB_RotationNameInputBox_OnTextChanged" as example
-- 5. Add show new widgets in update ui search for "ADD_SHOW_ROTATION_OPTIONS"
-- 6. Add hide new widgeets in update ui search for "ADD_HIDE_ROTATION_OPTIONS"
-- 7. Add retrieve rotation settings search for "RETRIEVE_ROTATION_SETTINGS"
-- 8. Make sure your script calls in XML dont call the wrong functions

function ROB_NewRotation()
   return { SortedActions={}, ActionList={}, keybind="<keybind>", bindindex=0};
end

local ROB_NewActionDefaults = {
   --General Options---------------
   b_toggle=false,
   v_togglename="Toggle 1",
   v_toggleicon="",
   b_toggleoff=false,
   b_toggleon=false,
   b_rangecheck=true,
   b_ccbreaker=false,
   b_holypower=false,
   v_keybind="<keybind>",
   v_spellname="<spell name>",
   v_actionicon="",
   v_gcdspell="",
   v_rangespell="",
   b_maxcasts=false,
   v_maxcasts="",
   b_lastcasted=false,
   v_lastcasted="",
   b_breakchanneling=false,
   b_moving=false,
   
   b_gunitpower=false,
   v_gunitpowertype="",
   v_gunitpower="",
   
   b_gcombopoints=false,
   v_gcombopoints="",
   
   b_gbloodrunes=false,
   v_gbloodrunes="",
   b_gfrostrunes=false,
   v_gfrostrunes="",
   b_gunholyrunes=false,
   v_gunholyrunes="",
   b_gdeathrunes=false,
   v_gdeathrunes="",
   
   b_checkothercd=false,
   v_checkothercdname="",
   v_checkothercdvalue="",
   
   b_duration=false,
   v_duration="",
   v_durationstartedtime=0,
   b_notaspell=false,
   v_oorspell="",
   b_oorspell=false,   
   b_debug=false,
   b_disabled=false,
   --Player Options---------------
   b_p_hp=false,
   v_p_hp="",
   b_p_poison=false,
   b_p_magic=false,
   b_p_disease=false,
   b_p_curse=false,
   b_p_needbuff=false,
   v_p_needbuff="",  
   b_p_havebuff=false,
   v_p_havebuff="",
   b_p_needdebuff=false,
   v_p_needdebuff="",
   b_p_havedebuff=false,
   v_p_havedebuff="",
   b_p_unitpower=false,
   v_p_unitpower="",
   v_p_unitpowertype="",
   b_p_bloodrunes=false,
   v_p_bloodrunes="",
   b_p_frostrunes=false,
   v_p_frostrunes="",   
   b_p_unholyrunes=false,
   v_p_unholyrunes="",   
   b_p_deathrunes=false,
   
   b_p_combopoints=false,
   v_p_combopoints="",
   b_p_eclipse=false,
   v_p_eclipse="",
   
   b_p_firetotemactive=false,
   v_p_firetotemactive="",
   b_p_firetoteminactive=false,
   v_p_firetoteminactive="",
   b_p_firetotemtimeleft=false,
   v_p_firetotemtimeleft="",
   
   b_p_earthtotemactive=false,
   v_p_earthtotemactive="",
   b_p_earthtoteminactive=false,
   v_p_earthtoteminactive="",
   b_p_earthtotemtimeleft=false,
   v_p_earthtotemtimeleft="",
   
   b_p_watertotemactive=false,
   v_p_watertotemactive="",
   b_p_watertoteminactive=false,
   v_p_watertoteminactive="",
   b_p_watertotemtimeleft=false,
   v_p_watertotemtimeleft="",
   
   b_p_airtotemactive=false,
   v_p_airtotemactive="",
   b_p_airtoteminactive=false,
   v_p_airtoteminactive="",
   b_p_airtotemtimeleft=false,
   v_p_airtotemtimeleft="",
   
   b_p_nmh=false,
   v_p_nmh="",
   b_p_noh=false,
   v_p_noh="",
   --Target Options---------------
   b_t_hp=false,
   v_t_hp="",
   b_t_maxhp=false,
   v_t_maxhp="",
   b_t_needsbuff=false,
   v_t_needsbuff="",
   b_t_hasbuff=false,
   v_t_hasbuff="",
   b_t_needsdebuff=false,
   v_t_needsdebuff="",
   b_t_hasdebuff=false,
   v_t_hasdebuff="",
   b_t_class=false,
   v_t_class="",   
   b_t_interrupt=false,
   v_t_interrupt="",
   b_t_pc=false,
   --Pet Options---------------
   b_pet_hp=false,
   v_pet_hp="",
   b_pet_isac=false,
   v_pet_isac="",
   b_pet_nac=false,
   v_pet_nac="",
   b_pet_needsbuff=false,
   v_pet_needsbuff="",
   b_pet_hasbuff=false,
   v_pet_hasbuff="",
   b_pet_needsdebuff=false,
   v_pet_needsdebuff="",
   b_pet_hasdebuff=false,
   v_pet_hasdebuff="",
   --Focus Options---------------
   b_f_hp=false,
   v_f_hp="",
}

local ROB_VERSION                   = GetAddOnMetadata("RotationBuilder", "Version");
BINDING_HEADER_ROB                  = "Rotation Builder";
BINDING_NAME_ROB_TOGGLE             = "Show/Hide Rotation Builder";
ROB_UPDATE_INTERVAL                 = 0.1      -- How often the OnUpdate code will run (in seconds)

local ROB_ROTATION_TYPE             = { EDITING=1, SELECTED=2 };

-- Scroll Frame Lines
local ROB_ROTATION_LIST_LINES       = 9;
local ROB_ACTION_LIST_LINES         = 21;
ROB_ROTATION_LIST_FRAME_HEIGHT      = 16;
ROB_ACTION_LIST_FRAME_HEIGHT        = 20;

ROB_TOGGLE_1                        = 0
ROB_TOGGLE_2                        = 0
ROB_TOGGLE_3                        = 0
ROB_TOGGLE_4                        = 0

-- Initial Options
local ROB_Options_Default           =
{
   MiniMap                          = true;
   MiniMapPos                       = 300;
   MiniMapRad                       = 80;
   LockIcons                        = true;
   AllowOverwrite                   = false;
   ExportBinds                      = false;
   IconsX                           = 0;
   IconsY                           = 0;
   IconScale                        = 1;
   UIScale                          = 1;
   ToggleIconsA                     = 1;
   CurrentIconA                     = 1;
   NextIconA                        = 1;
   NextIconLocation                 = "BOTTOM";   
   loaddefault                      = true;
   lastrotation                     = "";
};

-- Saved Options
ROB_Options                         = {};
ROB_Rotations                       = {};
ROB_ActionClipboard                 = nil;


local ROB_Initialized               = false
local ROB_SortedRotations           = {};      -- Sorted rotation table

local ROB_EditingRotationTable      = nil;     -- Rotation table being edited
ROB_SelectedRotationName            = nil;     -- Selected Rotation Name
local ROB_SelectedRotationIndex     = nil;     -- Selected Rotation Index

local ROB_SelectedActionIndex       = nil;     -- Lists edit selected
local ROB_CurrentActionName         = nil;     -- The current selected ActionName

local ROB_DropDownTableTemp         = {};      -- Temporary drop down table to reuse
local ROB_DropDownStoreToTemp       = nil;     -- Temporary name of where to save dropdown selected value

local ROB_LAST_CASTED               = nil;     -- Last casted spell
local ROB_LAST_CASTED_TYPE          = nil;     -- Used to track if we updated the sequential casts on start or succeeded
local ROB_LAST_CASTED_COUNT         = 0;       -- How many time the last spell casted has been sequentially cast

ROB_CURRENT_ACTION                  = nil;     -- The name of current ready action
local ROB_NEXT_ACTION               = nil;     -- The name of the next action ready
local ROB_ACTION_CD                 = nil;     -- The cooldown of the current spell being checked
local ROB_ACTION_TIMELEFT           = nil;     -- The timeleft on the action debuff or buff used to sort which action is next
local ROB_TARGET_LAST_CASTED        = nil;     -- Used to output what spell was itnerrupted
local ROB_ACTION_GCD                = false;   -- ROB_ACTION_GCD is not used for anything yet but its there for future options that may need it

--libDataBroker stuff
local ROB_MENU_FRAME                = nil;
local ROB_MENU                      = {};
local ROB_MENU_READY                = false;   -- The libDataBroker menu

local ROB_LAST_DEBUG                = GetTime();     -- Last time we output debug
local ROB_LAST_DEBUG_MSG            = nil;     -- Last message we output debug

-- Ignore these debbuffs for debuff type checking
local ROB_ArcaneExclusions = {
   [GetSpellInfo(15822)]   = true,                -- Dreamless Sleep
   [GetSpellInfo(24360)]   = true,                -- Greater Dreamless Sleep
   [GetSpellInfo(28504)]   = true,                -- Major Dreamless Sleep
   [GetSpellInfo(24306)]   = true,                -- Delusions of Jin'do
   [GetSpellInfo(46543)]   = true,                -- Ignite Mana
   [GetSpellInfo(16567)]   = true,                -- Tainted Mind
   [GetSpellInfo(39052)]   = true,                -- Sonic Burst
   [GetSpellInfo(30129)]   = true,                -- Charred Earth - Nightbane debuff, can't be cleansed, but shows as magic
   [GetSpellInfo(31651)]   = true,                -- Banshee Curse, Melee hit rating debuff
}

local _InvSlots = {
   ["HeadSlot"] = 1,
   ["NeckSlot"] = 2,
   ["ShoulderSlot"] = 3,
   ["ShirtSlot"] = 4,
   ["ChestSlot"] = 5,
   ["WaistSlot"] = 6,
   ["LegsSlot"] = 7,
   ["FeetSlot"] = 8,
   ["WristSlot"] = 9,
   ["HandsSlot"] = 10,
   ["Finger0Slot"] = 11,
   ["Finger1Slot"] = 12,
   ["Trinket0Slot"] = 13,     
   ["Trinket1Slot"] = 14,
   ["BackSlot"] = 15,     
   ["MainHandSlot"] = 16,
   ["SecondaryHandSlot"] = 17,
   ["RangedSlot"] = 18,
   ["TabardSlot"] = 19
};

function ROB_LoadDefaultRotations()
   if (select(2, UnitClass("player")) == "DEATHKNIGHT") then
      --Check if player has the default rotations already stored in their db
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Frost AoE v1.27],[Mind Freeze],v_p_unitpowertype=1,v_t_interrupt=Dark Mending|Lava Bolt|Crimson Flames|Gale Wind|Frostfire Bolt|Molten Burst|Pact of Darkness|Frostbolt|Inferno Leap|Seaswell|Arcane Infusion|Water Shell|Seaswell|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|PolyMorph|Penance|Mind Blast|Healing Surge|Regrowth|Entangling Roots|Flash HealArcane Infusion|Water Shell|Corrupted Flame|Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|Burning Shadowbolt|Polymorph|Conjure Twisted Visage|Cyclone|Greater Heal|Holy Smite|Lightning Lash|Cloudburst|Vapor Form|Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowbolt|Tranquility|Summon Sun Orb|Rotting Bile|Mend Rotten Flesh|Drain Life|Forsaken Ability|Unholy Empowerment|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|Dark Command|Bore|Shadow Prison|Shadow Nova|Fireball|Frostbomb|Firestorm,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,[Outbreak],v_t_needsdebuff=_Frost Fever^5|_Blood Plague^5,v_p_unitpowertype=1,b_toggleon=true,v_spellname=Outbreak,b_t_needsdebuff=true,v_p_frostrunes=0,v_t_hp=<=99%,v_toggleicon=77575,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,[Frost Strike Killing Machine],v_p_unitpowertype=6,v_spellname=Frost Strike,v_p_frostrunes=0,v_toggleicon=49143,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=>=32,b_p_unitpower=true,v_p_havebuff=Killing Machine,v_p_unholyrunes=0,[Howling Blast AoE],b_p_deathrunes=true,v_spellname=Howling Blast,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=49184,v_gcdspell=48266,v_maxcasts=0,b_rangecheck=false,[Howling Blast],v_t_needsdebuff=_Frost Fever^3,b_p_deathrunes=true,v_spellname=Howling Blast,b_t_needsdebuff=true,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=49184,v_gcdspell=48266,v_maxcasts=0,v_duration=0,[Howling Blast Freezing Fog],v_p_unitpowertype=1,v_spellname=Howling Blast,v_p_frostrunes=0,v_toggleicon=49184,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_havebuff=Freezing Fog,v_p_unholyrunes=0,[Plague Strike],v_t_needsdebuff=_Blood Plague^4,v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Plague Strike,b_t_needsdebuff=true,v_p_frostrunes=0,v_toggleicon=45462,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_p_unholyrunes=1,[Horn of Winter(need buff)],v_p_unitpowertype=1,b_p_needbuff=true,v_spellname=Horn of Winter,v_p_frostrunes=0,v_toggleicon=57330,v_p_needbuff=_Horn of Winter,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,b_rangecheck=false,v_duration=0,v_p_unholyrunes=0,v_actionicon=57330,[Pestilence],b_toggleoff=true,v_p_unitpowertype=1,b_p_deathrunes=true,b_maxcasts=true,v_spellname=Pestilence,v_p_frostrunes=0,b_toggle=true,v_toggleicon=50842,v_gcdspell=48266,v_maxcasts=1,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_p_unholyrunes=0,[Blood Strike],v_p_unitpowertype=1,v_spellname=Blood Strike,v_p_frostrunes=0,v_toggleicon=45902,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_p_unholyrunes=0,[Blood Tap],v_p_unitpowertype=1,v_spellname=Blood Tap,v_p_frostrunes=0,v_rangespell=Plague Strike,v_toggleicon=45529,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=-1,v_p_unitpower=1,v_p_unholyrunes=0,[Pillar of Frost],v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Pillar of Frost,v_p_frostrunes=1,b_p_frostrunes=true,v_rangespell=Plague Strike,v_toggleicon=51271,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_unholyrunes=0,[Frost Strike],v_p_unitpowertype=6,v_spellname=Frost Strike,v_toggleicon=49143,v_gcdspell=48266,v_maxcasts=0,v_duration=0,[Horn of Winter],v_p_unitpowertype=1,b_maxcasts=true,v_spellname=Horn of Winter,v_p_frostrunes=0,v_toggleicon=57330,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,b_rangecheck=false,v_p_unholyrunes=0")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Frost v1.27],[Strangulate],v_p_unitpowertype=1,b_disabled=true,b_p_deathrunes=true,v_t_interrupt=Dark Mending|Lava Bolt|Crimson Flames|Gale Wind|Frostfire Bolt|Molten Burst|Pact of Darkness|Frostbolt|Inferno Leap|Seaswell|Arcane Infusion|Water Shell|Seaswell|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|PolyMorph|Penance|Mind Blast|Healing Surge|Regrowth|Entangling Roots|Flash Heal|Arcane Infusion|Water Shell|Corrupted Flame|Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|Burning Shadowbolt|Polymorph|Conjure Twisted Visage|Cyclone|Greater Heal|Holy Smite|Lightning Lash|Cloudburst|Vapor Form|Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowbolt|Tranquility|Summon Sun Orb|Rotting Bile|Mend Rotten Flesh|Drain Life|Forsaken Ability|Unholy Empowerment|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|Dark Command|Bore|Shadow Prison|Shadow Nova|Fireball|Frostbomb|Firestorm|Bloodbolt|Holyfire|Blast Nova,b_oorspell=true,v_spellname=Strangulate,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47476,v_gcdspell=48266,v_maxcasts=0,v_oorspell=Mind Freeze,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_p_unholyrunes=0,v_actionicon=47476,[Death Strike],b_disabled=true,b_p_deathrunes=true,b_p_hp=true,v_spellname=Death Strike,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=66188,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_togglename=Toggle 2,v_p_hp=<35%,v_duration=0,v_p_unholyrunes=1,v_actionicon=Death Strike,[Outbreak Blood Plague],v_t_needsdebuff=_Blood Plague^4,v_p_unitpowertype=1,b_toggleon=true,v_spellname=Outbreak,b_t_needsdebuff=true,v_p_frostrunes=0,v_t_hp=<=99%,v_toggleicon=77575,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,v_actionicon=77575,[Outbreak],v_t_needsdebuff=_Frost Fever^3&_Blood Plague^3,v_p_unitpowertype=1,b_toggleon=true,v_spellname=Outbreak,b_t_needsdebuff=true,v_p_frostrunes=0,v_t_hp=<=99%,v_toggleicon=77575,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,v_actionicon=Outbreak,[Mind Freeze Ascebdant Council],v_p_unitpowertype=1,b_disabled=true,v_t_interrupt=Rising Flames,v_spellname=Mind Freeze,v_p_frostrunes=0,v_t_needsbuff=Aegis of Flame,b_t_needsbuff=true,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,v_actionicon=Mind Freeze,[Mind Freeze(Bastion of Twilight)],v_p_unitpowertype=1,b_disabled=true,v_t_interrupt=Raid:\n  BoT: |Dark Mending|Gale Wind|Crimson Flames|Pact of Darkness|Harden Skin|Depravity|\n ,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,v_actionicon=Mind Freeze,[Mind Freeze Temp],v_p_unitpowertype=1,b_disabled=true,v_t_interrupt=|Hyrdo Lance|,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,v_actionicon=Mind Freeze,[Mind Freeze],v_p_unitpowertype=1,v_t_interrupt=|Dark Mending|Lava Bolt|Crimson Flames|Gale Wind|Frostfire Bolt|Molten Burst|Pact of Darkness|Frostbolt|Inferno Leap|Seaswell|Arcane Infusion|Water Shell|Seaswell|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|PolyMorph|Penance|Mind Blast|Healing Surge|Regrowth|Entangling Roots|Flash Heal|Arcane Infusion|Water Shell|Corrupted Flame|Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|Burning Shadowbolt|Polymorph|Conjure Twisted Visage|Cyclone|Greater Heal|Holy Smite|Lightning Lash|Cloudburst|Vapor Form|Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowbolt|Tranquility|Summon Sun Orb|Rotting Bile|Mend Rotten Flesh|Drain Life|Forsaken Ability|Unholy Empowerment|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|Dark Command|Bore|Shadow Prison|Shadow Nova|Fireball|Frostbomb|Firestorm|Bloodbolt|Holyfire|Arcane Storms|Blast Nova|,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,v_actionicon=47528,[Howling Blast],v_t_needsdebuff=_Frost Fever^2,v_p_unitpowertype=1,b_p_deathrunes=true,b_duration=true,v_spellname=Howling Blast,b_t_needsdebuff=true,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=49184,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_duration=2,v_p_unholyrunes=0,v_actionicon=Howling Blast,[Plague Strike],v_t_needsdebuff=_Blood Plague^2,v_p_unitpowertype=1,v_checkothercdvalue=<=1,b_p_deathrunes=true,v_spellname=Plague Strike,b_t_needsdebuff=true,v_p_frostrunes=0,v_checkothercdname=Obliterate,v_toggleicon=45462,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_duration=0,v_p_unholyrunes=1,v_actionicon=Plague Strike,[Pillar of Frost],v_p_unitpowertype=1,b_p_deathrunes=true,b_p_needbuff=true,v_spellname=Pillar of Frost,v_p_frostrunes=1,b_p_frostrunes=true,v_rangespell=Plague Strike,v_toggleicon=51271,v_p_needbuff=Pillar of Frost,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_havebuff=Slayer#10&Unholy Strength,v_p_unholyrunes=0,v_actionicon=51271,[Obliterate Killing Machine],b_p_deathrunes=true,v_spellname=Obliterate,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=66198,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_havebuff=Killing Machine,v_duration=0,v_p_unholyrunes=1,v_actionicon=66198,[Raise Dead],v_p_unitpowertype=1,b_toggleon=true,v_spellname=Raise Dead,v_p_frostrunes=0,b_toggle=true,v_rangespell=Frost Strike,v_toggleicon=46584,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_p_havebuff=Pillar of Frost&Slayer#10&Unholy Strength,v_duration=0,v_p_unholyrunes=0,v_actionicon=46584,[Frost Strike (RP DUMP)],v_p_unitpowertype=6,v_spellname=Frost Strike,v_toggleicon=49143,v_gcdspell=48266,v_p_unitpower=>=95,b_p_unitpower=true,v_actionicon=Frost Strike,[Howling Blast Freezing Fog],v_p_unitpowertype=1,b_duration=true,v_spellname=Howling Blast,v_toggleicon=49184,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_havebuff=Freezing Fog,v_duration=2,v_p_unholyrunes=0,v_actionicon=49184,[Frost Strike Killing Machine],v_p_unitpowertype=6,v_checkothercdvalue=<=2,v_spellname=Frost Strike,v_p_frostrunes=0,v_checkothercdname=Obliterate,v_toggleicon=49143,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=>=32,b_p_unitpower=true,v_p_havebuff=Killing Machine,v_duration=0,v_p_unholyrunes=0,v_actionicon=49143,[Horn of Winter(Need Buff)],v_p_unitpowertype=1,b_p_needbuff=true,v_spellname=Horn of Winter,v_p_frostrunes=0,v_toggleicon=57330,v_p_needbuff=_Horn of Winter,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,b_rangecheck=false,v_duration=0,v_p_unholyrunes=0,v_actionicon=57330,[Pestilence],b_toggleoff=true,v_p_unitpowertype=1,b_p_deathrunes=true,b_duration=true,v_spellname=Pestilence,v_p_frostrunes=0,b_toggle=true,v_toggleicon=50842,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_duration=2,v_p_unholyrunes=0,v_actionicon=50842,[Obliterate],b_p_deathrunes=true,v_spellname=Obliterate,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=66198,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_duration=0,v_p_unholyrunes=1,v_actionicon=66198,[Blood Strike],v_p_unitpowertype=1,v_spellname=Blood Strike,v_p_frostrunes=0,v_toggleicon=45902,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_duration=0,v_p_unholyrunes=0,v_actionicon=45902,[Blood Tap],v_p_unitpowertype=1,v_spellname=Blood Tap,v_p_frostrunes=0,v_rangespell=Plague Strike,v_toggleicon=45529,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=-1,v_p_unitpower=1,v_p_unholyrunes=0,v_actionicon=45529,[Horn of Winter],v_p_unitpowertype=6,v_spellname=Horn of Winter,v_p_frostrunes=0,v_toggleicon=57330,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=<=30,b_p_unitpower=true,b_rangecheck=false,v_duration=0,v_p_unholyrunes=0,v_actionicon=57330,[Frost Strike],v_p_unitpowertype=6,v_checkothercdvalue=<=2,v_spellname=Frost Strike,v_checkothercdname=Obliterate,v_toggleicon=49143,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_unitpower=>=32,b_p_unitpower=true,v_duration=0,v_actionicon=49143,[Healthstone],v_p_unitpowertype=1,b_disabled=true,b_notaspell=true,v_spellname=Healthstone,v_p_frostrunes=0,v_toggleicon=6603,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_unholyrunes=0,[Mind Freeze(PVP)],v_p_unitpowertype=1,b_disabled=true,v_t_interrupt=|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|PolyMorph|Penance|Mind Blast|Healing Surge|Regrowth|Entangling Roots|Flash Heal|,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,v_actionicon=47528,[Mind Freeze(Blackwing Descent)],v_p_unitpowertype=1,b_disabled=true,v_t_interrupt=|Blast Nova|Arcane Annihilator|Arcane Storm|Release Aberrations|,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,v_actionicon=Mind Freeze")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Frost PVP v1.27],[Icebound Fortitude(PVP stun break)],v_p_unitpowertype=6,v_spellname=Icebound Fortitude,v_gcdspell=48266,v_p_unitpower=>=20,b_p_unitpower=true,v_p_havedebuff=|Deep Freeze|Hammer of Justice|Kidney Shot|,b_rangecheck=false,b_p_havedebuff=true,v_actionicon=48792,[PVP Trinket],v_p_unitpowertype=1,b_notaspell=true,v_spellname=Trinket1Slot,v_p_frostrunes=0,v_toggleicon=6603,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_havedebuff=|Fear|Wyvern Sting|Freezing Trap Effect|Howl of Terror|Psychic Scream|Kidney Shot|Hammer of Justice|Intimidating Shout|Deep Freeze|,b_rangecheck=false,b_p_havedebuff=true,v_duration=0,v_p_unholyrunes=0,[Mind Freeze(PVP)],v_p_unitpowertype=1,v_t_interrupt=|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|PolyMorph|Penance|Mind Blast|Healing Surge|Regrowth|Entangling Roots|Flash Heal|,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,v_actionicon=47528,[Mind Freeze],v_p_unitpowertype=1,b_disabled=true,v_t_interrupt=Dark Mending|Lava Bolt|Crimson Flames|Gale Wind|Frostfire Bolt|Molten Burst|Pact of Darkness|Frostbolt|Inferno Leap|Seaswell|Arcane Infusion|Water Shell|Seaswell|Arcane Infusion|Water Shell|Corrupted Flame|Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|Burning Shadowbolt|Polymorph|Conjure Twisted Visage|Cyclone|Greater Heal|Holy Smite|Lightning Lash|Cloudburst|Vapor Form|Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowbolt|Tranquility|Summon Sun Orb|Rotting Bile|Mend Rotten Flesh|Drain Life|Forsaken Ability|Unholy Empowerment|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|Dark Command|Bore|Shadow Prison|Shadow Nova|Fireball|Frostbomb|Firestorm|Bloodbolt|Holyfire|Release Aberrations,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_duration=0,v_p_unholyrunes=0,v_actionicon=Mind Freeze,[Strangulate],v_p_unitpowertype=1,b_p_deathrunes=true,v_t_interrupt=|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|PolyMorph|Penance|Mind Blast|Healing Surge|Regrowth|Entangling Roots|Flash Heal|,b_t_hp=true,v_spellname=Strangulate,v_p_frostrunes=0,v_t_hp=<=55%,b_t_interrupt=true,v_toggleicon=47476,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_p_unholyrunes=0,v_actionicon=Strangulate,[Lichborne],v_p_unitpowertype=6,b_p_hp=true,v_spellname=Lichborne,v_gcdspell=48266,v_p_unitpower=>=45,b_p_unitpower=true,b_rangecheck=false,v_p_hp=<65%,v_actionicon=49039,[Death Coil(Heal)],b_p_hp=true,v_spellname=Death Coil,v_p_frostrunes=0,v_toggleicon=47541,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_oorspell=Frost Strike,v_p_bloodrunes=0,v_p_havebuff=Lichborne,b_rangecheck=false,v_p_hp=<80%,v_p_unholyrunes=0,v_actionicon=Death Coil,[Death Strike],b_p_deathrunes=true,b_p_hp=true,v_spellname=Death Strike,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=66188,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_togglename=Toggle 2,v_p_hp=<80%,v_duration=0,v_p_unholyrunes=1,v_actionicon=Death Strike,[Outbreak],v_t_needsdebuff=_Frost Fever^4|_Blood Plague^4,v_p_unitpowertype=1,b_toggleon=true,v_spellname=Outbreak,b_t_needsdebuff=true,v_p_frostrunes=0,v_toggleicon=77575,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,v_actionicon=Outbreak,[Chains of Ice],v_t_needsdebuff=Chains of Ice,b_p_deathrunes=true,b_oorspell=true,v_spellname=Chains of Ice,b_t_needsdebuff=true,v_p_frostrunes=1,b_p_frostrunes=true,v_gcdspell=48266,v_oorspell=Frost Strike,v_actionicon=45524,[Obliterate Killing Machine],v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Obliterate,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=66198,b_p_havebuff=true,v_maxcasts=0,v_oorspell=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_p_havebuff=Killing Machine,v_duration=0,v_p_unholyrunes=1,v_actionicon=Obliterate,[Pillar of Frost],v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Pillar of Frost,v_p_frostrunes=1,b_p_frostrunes=true,v_rangespell=Plague Strike,v_toggleicon=51271,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_unholyrunes=0,v_actionicon=51271,[Frost Strike Killing Machine],v_p_unitpowertype=6,v_spellname=Frost Strike,v_p_frostrunes=0,v_toggleicon=49143,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_havebuff=Killing Machine,v_p_unholyrunes=0,v_actionicon=Frost Strike,[Frost Strike RP dump],v_p_unitpowertype=6,v_spellname=Frost Strike,v_toggleicon=49143,v_gcdspell=48266,v_p_unitpower=>=110,b_p_unitpower=true,v_actionicon=49143,[Howling Blast Freezing Fog],v_p_unitpowertype=1,v_spellname=Howling Blast,v_p_frostrunes=0,v_toggleicon=49184,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_havebuff=Freezing Fog,v_duration=0,v_p_unholyrunes=0,v_actionicon=Howling Blast,[Howling Blast PVP],b_p_deathrunes=true,b_oorspell=true,v_spellname=Howling Blast,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=49184,v_gcdspell=48266,v_maxcasts=0,v_oorspell=Frost Strike,v_actionicon=Howling Blast,[Howling Blast],v_t_needsdebuff=_Frost Fever^2,b_p_deathrunes=true,v_spellname=Howling Blast,b_t_needsdebuff=true,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=49184,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_duration=0,v_actionicon=Howling Blast,[Plague Strike],v_t_needsdebuff=_Blood Plague^4,v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Plague Strike,b_t_needsdebuff=true,v_p_frostrunes=0,v_toggleicon=45462,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_p_unholyrunes=1,v_actionicon=45462,[Pestilence],b_toggleoff=true,v_p_unitpowertype=1,b_p_deathrunes=true,b_maxcasts=true,v_spellname=Pestilence,v_p_frostrunes=0,b_toggle=true,v_toggleicon=50842,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_p_unholyrunes=0,v_actionicon=50842,[Raise Dead],v_p_unitpowertype=1,b_toggleon=true,v_spellname=Raise Dead,v_p_frostrunes=0,b_toggle=true,v_rangespell=Frost Strike,v_toggleicon=46584,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_p_havebuff=Pillar of Frost&Slayer#10&Unholy Strength,v_duration=0,v_p_unholyrunes=0,v_actionicon=46584,[Necrotic Strike],v_t_needsdebuff=_Necrotic Strike^2,v_p_unitpowertype=0,b_p_deathrunes=true,v_t_class=Mage|Warlock|Priest|,v_spellname=Necrotic Strike,b_t_needsdebuff=true,v_p_frostrunes=0,v_toggleicon=Necrotic Strike,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unholyrunes=1,v_actionicon=Necrotic Strike,[Death Coil],b_oorspell=true,v_spellname=Death Coil,v_p_frostrunes=0,v_t_hp=<=35%,v_toggleicon=47541,v_t_maxhp=<200000,v_gcdspell=48266,v_maxcasts=0,v_oorspell=Frost Strike,v_p_bloodrunes=0,v_p_unholyrunes=0,v_actionicon=47541,[Horn of Winter(Need Buff)],v_p_unitpowertype=1,b_p_needbuff=true,v_spellname=Horn of Winter,v_p_frostrunes=0,v_toggleicon=57330,v_p_needbuff=_Horn of Winter,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,b_rangecheck=false,v_duration=0,v_p_unholyrunes=0,v_actionicon=57330,[Obliterate],b_p_deathrunes=true,v_spellname=Obliterate,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=66198,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unholyrunes=1,v_actionicon=66198,[Blood Strike],v_p_unitpowertype=1,v_spellname=Blood Strike,v_p_frostrunes=0,v_toggleicon=45902,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_p_unholyrunes=0,v_actionicon=45902,[Blood Tap],v_p_unitpowertype=1,v_spellname=Blood Tap,v_p_frostrunes=0,v_rangespell=Plague Strike,v_toggleicon=45529,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,b_p_bloodrunes=true,v_p_bloodrunes=-1,v_p_unitpower=1,b_rangecheck=false,v_duration=0,v_p_unholyrunes=0,v_actionicon=Blood Tap,[Frost Strike],v_p_unitpowertype=6,v_spellname=Frost Strike,v_toggleicon=49143,v_gcdspell=48266,v_actionicon=49143,[Horn of Winter],v_p_unitpowertype=1,v_spellname=Horn of Winter,v_p_frostrunes=0,v_toggleicon=57330,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,b_rangecheck=false,v_p_unholyrunes=0,v_actionicon=57330,[Howling Blast Slow],v_t_needsdebuff=Chilblains,b_disabled=true,b_p_deathrunes=true,v_spellname=Howling Blast,b_t_needsdebuff=true,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=49184,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_duration=0,v_actionicon=Howling Blast")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Unholy v1.27],[Interupt Blackwing ],v_p_unitpowertype=1,b_disabled=true,v_t_interrupt=|Blast Nova|Arcane Annihilator|Arcane Storm|Release Aberrations|,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,v_actionicon=Mind Freeze,[Ascendent council fire interupt],v_p_unitpowertype=1,b_disabled=true,v_t_interrupt=|Rising Flames|,v_spellname=Mind Freeze,v_p_frostrunes=0,v_t_needsbuff=Aegis of Flame,b_t_needsbuff=true,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,v_actionicon=Mind Freeze,[Mind Freeze],v_p_unitpowertype=1,v_t_interrupt=|Dark Mending|Lava Bolt|Crimson Flames|Gale Wind|Frostfire Bolt|Molten Burst|Pact of Darkness|Frostbolt|Inferno Leap|Seaswell|Arcane Infusion|Water Shell|Seaswell|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|PolyMorph|Penance|Mind Blast|Healing Surge|Regrowth|Entangling Roots|Flash Heal|Arcane Infusion|Water Shell|Corrupted Flame|Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|Burning Shadowbolt|Polymorph|Conjure Twisted Visage|Cyclone|Greater Heal|Holy Smite|Lightning Lash|Cloudburst|Vapor Form|Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowbolt|Tranquility|Summon Sun Orb|Rotting Bile|Mend Rotten Flesh|Drain Life|Forsaken Ability|Unholy Empowerment|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|Dark Command|Bore|Shadow Prison|Shadow Nova|Fireball|Frostbomb|Firestorm|Bloodbolt|Holyfire|Blast Nova|Arcane Storm|Hydro Lance|Depravity|,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_duration=0,v_p_unholyrunes=0,v_actionicon=47528,[Outbreak],v_t_needsdebuff=_Frost Fever^4&_Blood Plague^4,v_p_unitpowertype=1,v_spellname=Outbreak,b_t_needsdebuff=true,v_p_frostrunes=0,v_toggleicon=77575,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,v_actionicon=77575,[Unholy Frenzy/Racial],b_toggleoff=true,v_p_unitpowertype=1,b_notaspell=true,v_spellname=Unholy Frenzy,v_p_frostrunes=0,b_toggle=true,v_toggleicon=49016,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,v_actionicon=49016,[Death Strike PVP],v_p_unitpowertype=1,b_disabled=true,b_p_deathrunes=true,b_p_hp=true,v_spellname=Death Strike,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=Death Strike,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_p_hp=<85%,v_p_unholyrunes=1,v_actionicon=Death Strike,[Death Strike],v_p_unitpowertype=1,b_p_deathrunes=true,b_p_hp=true,v_spellname=Death Strike,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=Death Strike,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_p_hp=<30%,v_p_unholyrunes=1,v_actionicon=Death Strike,[Death Coil (Sudden Doom)],v_spellname=Death Coil,v_p_frostrunes=0,v_toggleicon=49530,v_gcdspell=48266,b_p_havebuff=true,v_maxcasts=0,v_p_bloodrunes=0,v_p_havebuff=Sudden Doom,v_duration=0,v_p_unholyrunes=0,v_actionicon=49530,[Icy Touch],v_t_needsdebuff=_Frost Fever^2,v_p_unitpowertype=1,v_spellname=Icy Touch,b_t_needsdebuff=true,v_p_frostrunes=0,v_toggleicon=45477,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_unholyrunes=0,v_actionicon=45477,[Plague Strike],v_t_needsdebuff=_Blood Plague^2,v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Plague Strike,b_t_needsdebuff=true,v_p_frostrunes=0,v_toggleicon=45462,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_duration=0,v_p_unholyrunes=1,v_actionicon=45462,[Pestilence],b_toggleoff=true,v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Pestilence,v_p_frostrunes=0,b_toggle=true,v_rangespell=Blood Strike,v_toggleicon=50842,v_gcdspell=48266,v_maxcasts=1,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_duration=2,v_p_unholyrunes=0,v_actionicon=50842,[Dark Transformation],v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Dark Transformation,v_p_frostrunes=0,v_rangespell=Blood Strike,v_toggleicon=Dark Transformation,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_p_unholyrunes=1,v_actionicon=Dark Transformation,[Summon Gargoyle],v_p_unitpowertype=6,b_toggleon=true,v_spellname=Summon Gargoyle,v_p_frostrunes=0,b_toggle=true,v_toggleicon=49206,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=>=60,b_p_unitpower=true,v_togglename=Toggle 4,v_duration=0,v_p_unholyrunes=0,v_actionicon=49206,[Death Coil RP DUMP],v_p_unitpowertype=6,b_toggleon=true,v_spellname=Death Coil,v_p_frostrunes=0,v_toggleicon=47541,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=>=65,b_p_unitpower=true,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,v_actionicon=47541,[Horn of winter buff],v_p_unitpowertype=1,b_p_needbuff=true,v_spellname=Horn of Winter,v_p_frostrunes=0,v_toggleicon=57330,v_p_needbuff=_Horn of Winter,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,b_rangecheck=false,v_duration=0,v_p_unholyrunes=0,v_actionicon=57330,[Festering Strike],v_p_unitpowertype=1,v_spellname=Festering Strike,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=86061,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_togglename=Toggle 4,v_duration=0,v_p_unholyrunes=0,v_actionicon=86061,[Blood Tap],v_spellname=Blood Tap,v_p_frostrunes=0,v_rangespell=Plague Strike,v_toggleicon=45529,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=-1,v_duration=0,v_p_unholyrunes=0,v_actionicon=45529,[Scourge Strike],v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Scourge Strike,v_p_frostrunes=0,v_toggleicon=55090,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_duration=0,v_p_unholyrunes=1,v_actionicon=55090,[Horn of Winter],v_p_unitpowertype=1,b_toggleon=true,v_spellname=Horn of Winter,v_p_frostrunes=0,v_toggleicon=57330,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,b_rangecheck=false,v_duration=0,v_p_unholyrunes=0,v_actionicon=57330,[Regular Death Coil],v_p_unitpowertype=6,b_p_needbuff=true,b_toggleon=true,v_spellname=Death Coil,v_p_frostrunes=0,v_toggleicon=47541,v_p_needbuff=Runic Corruption,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=>=34,b_p_unitpower=true,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,v_actionicon=47541,[Blood Strike],v_p_unitpowertype=1,b_disabled=true,v_spellname=Blood Strike,v_p_frostrunes=0,v_toggleicon=45902,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_duration=0,v_p_unholyrunes=0,v_actionicon=45902,[Strangulate],v_p_unitpowertype=1,b_disabled=true,b_p_deathrunes=true,v_t_interrupt=Dark Mending|Lava Bolt|Crimson Flames|Gale Wind|Frostfire Bolt|Molten Burst|Pact of Darkness|Frostbolt|Inferno Leap|Seaswell|Arcane Infusion|Water Shell|Seaswell|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|PolyMorph|Penance|Mind Blast|Healing Surge|Regrowth|Entangling Roots|Flash Heal|Arcane Infusion|Water Shell|Corrupted Flame|Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|Burning Shadowbolt|Polymorph|Conjure Twisted Visage|Cyclone|Greater Heal|Holy Smite|Lightning Lash|Cloudburst|Vapor Form|Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowbolt|Tranquility|Summon Sun Orb|Rotting Bile|Mend Rotten Flesh|Drain Life|Forsaken Ability|Unholy Empowerment|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|Dark Command|Bore|Shadow Prison|Shadow Nova|Fireball|Frostbomb|Firestorm|Bloodbolt|Holyfire,v_spellname=Strangulate,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=Strangulate,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_p_unholyrunes=0,v_actionicon=Strangulate,[Festering Strike(dump frost)],v_p_unitpowertype=1,b_disabled=true,b_p_deathrunes=true,v_spellname=Festering Strike,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=86061,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=1,v_p_unitpower=1,v_togglename=Toggle 4,v_duration=0,v_p_unholyrunes=0,v_actionicon=86061,[Necrotic Strike],v_t_needsdebuff=_Necrotic Strike^5,v_p_unitpowertype=0,b_disabled=true,b_p_deathrunes=true,v_t_class=Mage|Warlock|Priest|,v_spellname=Necrotic Strike,b_t_needsdebuff=true,v_p_frostrunes=0,v_toggleicon=Necrotic Strike,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unholyrunes=1,v_actionicon=Necrotic Strike")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Blood v1.27],[Death Strike(Self Heal)],v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Death Strike,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=66188,v_gcdspell=48266,v_maxcasts=0,v_oorspell=0,b_p_unholyrunes=true,v_p_unitpower=1,v_duration=0,v_p_unholyrunes=1,[Rune Tap],v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Rune Tap,v_p_frostrunes=0,v_toggleicon=6603,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,b_rangecheck=false,v_p_unholyrunes=0,[Mind Freeze Temp],v_p_unitpowertype=1,v_t_interrupt=Rising Flames|Hydro Lance,v_spellname=Mind Freeze,v_p_frostrunes=0,v_t_needsbuff=Aegis of Flame,b_t_needsbuff=true,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,[Mind Freeze],v_p_unitpowertype=1,v_t_interrupt=Dark Mending|Lava Bolt|Crimson Flames|Gale Wind|Frostfire Bolt|Molten Burst|Pact of Darkness|Frostbolt|Inferno Leap|Seaswell|Arcane Infusion|Water Shell|Seaswell|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|PolyMorph|Penance|Mind Blast|Healing Surge|Regrowth|Entangling Roots|Flash HealArcane Infusion|Water Shell|Corrupted Flame|Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|Burning Shadowbolt|Polymorph|Conjure Twisted Visage|Cyclone|Greater Heal|Holy Smite|Lightning Lash|Cloudburst|Vapor Form|Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowbolt|Tranquility|Summon Sun Orb|Rotting Bile|Mend Rotten Flesh|Drain Life|Forsaken Ability|Unholy Empowerment|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|Dark Command|Bore|Shadow Prison|Shadow Nova|Fireball|Frostbomb|Firestorm|Bloodbolt|Holyfire|Force of Earth|Shadow Nova|Twist Phase,v_spellname=Mind Freeze,v_p_frostrunes=0,b_t_interrupt=true,v_toggleicon=47528,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 3,v_duration=0,v_p_unholyrunes=0,[Outbreak],v_t_needsdebuff=_Frost Fever^5|_Blood Plague^6,v_p_unitpowertype=1,b_t_hp=true,b_toggleon=true,v_spellname=Outbreak,b_t_needsdebuff=true,v_p_frostrunes=0,v_t_hp=<=99%,v_toggleicon=77575,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,[Icy Touch],v_t_needsdebuff=_Frost Fever^3,v_p_unitpowertype=1,v_spellname=Icy Touch,b_t_needsdebuff=true,v_p_frostrunes=0,v_toggleicon=45477,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_unholyrunes=0,[Plague Strike],v_t_needsdebuff=_Blood Plague^4,v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Plague Strike,b_t_needsdebuff=true,v_p_frostrunes=0,v_toggleicon=45462,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_p_unholyrunes=1,[Death Strike],v_p_unitpowertype=1,v_spellname=Death Strike,v_p_frostrunes=1,b_p_frostrunes=true,v_toggleicon=66188,v_gcdspell=48266,v_maxcasts=0,b_p_unholyrunes=true,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=1,[Rune Strike],v_p_unitpowertype=6,v_spellname=Rune Strike,v_p_frostrunes=0,v_toggleicon=56815,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_unholyrunes=0,[Blood Boil(Swarm)],v_p_unitpowertype=1,v_spellname=Blood Boil,v_p_frostrunes=0,v_rangespell=Death Strike,v_toggleicon=48721,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_p_havebuff=Blood Swarm,v_p_unholyrunes=0,[Pestilence],b_toggleoff=true,v_p_unitpowertype=1,b_p_deathrunes=true,b_maxcasts=true,b_duration=true,v_spellname=Pestilence,v_p_frostrunes=0,b_toggle=true,v_toggleicon=50842,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_duration=2,v_p_unholyrunes=0,[Blood Boil],b_toggleoff=true,v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Blood Boil,v_p_frostrunes=0,b_toggle=true,v_rangespell=Death Strike,v_toggleicon=48721,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_togglename=Toggle 2,v_duration=0,v_p_unholyrunes=0,[Heart Strike],v_p_unitpowertype=1,b_p_deathrunes=true,v_spellname=Heart Strike,v_p_frostrunes=0,v_toggleicon=6603,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=1,v_p_unitpower=1,v_duration=0,v_p_unholyrunes=0,[Raise Dead],v_p_unitpowertype=1,b_disabled=true,b_notaspell=true,b_toggleon=true,v_spellname=Raise Dead,v_p_frostrunes=0,b_toggle=true,v_toggleicon=46584,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,v_togglename=Toggle 3,v_p_havebuff=Pillar of Frost|Slayer#10|Unholy Strength,v_duration=0,v_p_unholyrunes=0,[Blood Tap],v_p_unitpowertype=1,v_spellname=Blood Tap,v_p_frostrunes=0,v_toggleicon=45529,v_gcdspell=48266,v_maxcasts=0,b_p_bloodrunes=true,v_p_bloodrunes=-1,v_p_unitpower=1,v_togglename=Plague Strike,v_duration=0,v_p_unholyrunes=0,[Horn of Winter],v_p_unitpowertype=1,b_maxcasts=true,v_spellname=Horn of Winter,v_p_frostrunes=0,v_toggleicon=57330,v_gcdspell=48266,v_maxcasts=0,v_p_bloodrunes=0,v_p_unitpower=1,b_rangecheck=false,v_duration=0,v_p_unholyrunes=0")
   end
   
   if (select(2, UnitClass("player")) == "DRUID") then --Checked Feb 09,2011
      --Check if player has the default rotations already stored in their db     
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Cat - DPS v1.27],[Tiger's Fury],v_p_unitpowertype=3,b_p_needbuff=true,v_spellname=Tiger's Fury,v_p_needbuff=Berserk,v_p_unitpower=<=30,b_p_unitpower=true,[Mangle(Cat Form)],v_t_needsdebuff=33876^3|Hemorrhage|Trauma,v_spellname=33876,b_t_needsdebuff=true,v_gcdspell=768,b_gcombopoints=true,v_gcombopoints=1,[Berserk],v_p_unitpowertype=3,v_checkothercdvalue=>=15,v_spellname=Berserk,v_checkothercdname=5217,v_gcdspell=768,v_p_unitpower=>=80,b_p_unitpower=true,b_rangecheck=false,b_checkothercd=true,[Rip],v_t_needsdebuff=_Rip^2,v_spellname=Rip,b_t_needsdebuff=true,v_t_hp=0,v_p_combopoints==5,v_t_maxhp=0,b_p_combopoints=true,v_gcdspell=768,v_maxcasts=0,[Ferocious Bite (<25%)],v_t_needsdebuff=_Rip^3,b_t_hp=true,v_spellname=22568,b_t_needsdebuff=true,v_t_hp=<25%,v_p_combopoints==1,v_t_maxhp=0,b_p_combopoints=true,v_gcdspell=768,v_maxcasts=0,[Ferocious Bite (<25% 5cp)],b_t_hasdebuff=true,b_t_hp=true,v_t_hasdebuff=_Rip^3,v_spellname=22568,v_t_hp=<25%,v_p_combopoints==5,v_t_maxhp=0,b_p_combopoints=true,v_gcdspell=768,v_maxcasts=0,[Shred (Clearcasting)],b_toggleon=true,v_spellname=Shred,b_toggle=true,v_toggleicon=Shred,v_gcdspell=768,b_p_havebuff=true,b_gcombopoints=true,v_p_havebuff=Clearcasting,v_gcombopoints=1,[Rake],v_t_needsdebuff=_Rake^3,b_duration=true,v_spellname=Rake,b_t_needsdebuff=true,v_gcdspell=768,b_gcombopoints=true,v_duration=2,v_gcombopoints=1,[Savage Roar (1cp)],b_p_needbuff=true,v_spellname=Savage Roar,v_p_combopoints=>=1,v_p_needbuff=Savage Roar^3,b_p_combopoints=true,v_gcdspell=768,[Savage Roar (5cp)],v_t_needsdebuff=_Rip^12,b_p_needbuff=true,v_spellname=Savage Roar,b_t_needsdebuff=true,v_p_combopoints=>=5,v_p_needbuff=Savage Roar^12,b_p_combopoints=true,v_gcdspell=768,[Ferocious Bite (5cp)],b_t_hasdebuff=true,v_t_hasdebuff=_Rip^8,v_spellname=22568,v_p_combopoints=>=5,b_p_combopoints=true,v_gcdspell=768,b_p_havebuff=true,v_p_havebuff=Savage Roar^8,[Shred (cp generation)],b_toggleon=true,v_spellname=Shred,b_toggle=true,v_toggleicon=Shred,v_gcdspell=768,b_gcombopoints=true,v_gcombopoints=1,[Mangle (cp generation)],v_spellname=33876,b_toggle=true,v_toggleicon=33876,v_gcdspell=768,v_togglename=Toggle 3,b_gcombopoints=true,v_gcombopoints=1")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Balance - DPS v1.27],[Insect Swarm (solar)],v_t_needsdebuff=_Insect Swarm,v_p_unitpowertype=8,v_spellname=Insect Swarm,b_t_needsdebuff=true,v_p_eclipse=sun,v_gcdspell=768,b_p_eclipse=true,v_p_unitpower=<80,b_p_unitpower=true,[Insect Swarm (lunar)],v_t_needsdebuff=_Insect Swarm,v_p_unitpowertype=8,v_spellname=Insect Swarm,b_t_needsdebuff=true,v_p_eclipse=moon,v_gcdspell=768,b_p_eclipse=true,v_p_unitpower=>-74,b_p_unitpower=true,[Insect Swarm (No Eclipse solar)],v_t_needsdebuff=_Insect Swarm,v_spellname=Insect Swarm,b_t_needsdebuff=true,v_p_eclipse=none,v_gcdspell=768,b_p_eclipse=true,[Moonfire],v_t_needsdebuff=_8921&_93402,b_p_needbuff=true,v_spellname=8921,b_t_needsdebuff=true,v_p_needbuff=48517,v_gcdspell=768,[Sunfire],v_t_needsdebuff=_8921&_93402,v_spellname=93402,b_t_needsdebuff=true,v_rangespell=8921,v_gcdspell=768,b_p_havebuff=true,v_p_havebuff=48517,[Starsurge (sun)],v_spellname=Starsurge,v_p_eclipse=sun,v_gunitpowertype=8,v_gunitpower=15,v_gcdspell=768,b_p_eclipse=true,b_gunitpower=true,[Starsurge (moon)],v_spellname=Starsurge,v_p_eclipse=moon,v_gunitpowertype=8,v_gunitpower=15,v_gcdspell=768,b_p_eclipse=true,b_gunitpower=true,[Starsurge (none)],v_spellname=Starsurge,v_p_eclipse=none,v_gunitpowertype=8,v_gunitpower=15,v_gcdspell=768,b_p_eclipse=true,b_gunitpower=true,[Starfire (solar)],v_p_unitpowertype=8,b_duration=true,v_spellname=Starfire,v_p_eclipse=sun,v_gunitpowertype=8,v_gunitpower=20,v_gcdspell=768,b_p_eclipse=true,v_p_unitpower=<=80,b_p_unitpower=true,v_duration=.05,b_gunitpower=true,[Starfire (none)],v_p_unitpowertype=8,b_duration=true,v_spellname=Starfire,v_p_eclipse=none,v_gunitpowertype=8,v_gunitpower=20,v_gcdspell=768,b_p_eclipse=true,v_p_unitpower=<=80,b_p_unitpower=true,v_duration=.05,b_gunitpower=true,[Wrath (lunar)],v_p_unitpowertype=8,b_duration=true,v_spellname=Wrath,v_p_eclipse=moon,v_gunitpowertype=8,v_gunitpower=-13,v_gcdspell=768,b_p_eclipse=true,v_p_unitpower=>=-74,b_p_unitpower=true,v_duration=.05,b_gunitpower=true")
   end
   if (select(2, UnitClass("player")) == "HUNTER") then
      --Check if player has the default rotations already stored in their db
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Survival v1.27],[Explosive Shot (LnL)],v_spellname=Explosive Shot,v_gcdspell=1462,b_p_havebuff=true,v_p_havebuff=Lock and Load#2,[Cobra Shot (LnL)],v_lastcasted=Explosive Shot,b_lastcasted=true,b_maxcasts=true,v_spellname=Cobra Shot,v_gunitpowertype=2,v_gunitpower=9,v_gcdspell=1462,b_p_havebuff=true,v_maxcasts=1,v_p_havebuff=Lock and Load#1,b_gunitpower=true,[Explosive Shot 2 (LnL)],v_spellname=Explosive Shot,v_gcdspell=1462,b_p_havebuff=true,v_p_havebuff=Lock and Load#1,[Hunter's Mark],v_t_needsdebuff=Hunter's Mark,v_spellname=Hunter's Mark,b_t_needsdebuff=true,v_gcdspell=1462,[Serpent Sting],v_t_needsdebuff=_Serpent Sting,v_p_unitpowertype=2,v_spellname=Serpent Sting,b_t_needsdebuff=true,v_gcdspell=1462,v_p_unitpower=>=25,b_p_unitpower=true,[Explosive Shot],v_p_unitpowertype=2,b_p_needbuff=true,v_spellname=Explosive Shot,v_p_needbuff=Lock and Load,v_gcdspell=1462,v_p_unitpower=>=44,b_p_unitpower=true,[Kill Shot],v_spellname=Kill Shot,v_gcdspell=1462,[Black Arrow],v_p_unitpowertype=2,v_spellname=Black Arrow,v_gcdspell=1462,v_p_unitpower=>=35,b_p_unitpower=true,[Arcane Shot],v_p_unitpowertype=2,b_p_needbuff=true,v_spellname=Arcane Shot,v_p_needbuff=Lock and Load,v_gcdspell=1462,v_p_unitpower=>=79,b_p_unitpower=true,[Cobra Shot],b_p_needbuff=true,v_spellname=Cobra Shot,v_gunitpowertype=2,v_gunitpower=9,v_p_needbuff=Lock and Load,v_gcdspell=1462,b_gunitpower=true")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Marksman v1.27],[Silencing Shot],v_t_interrupt=|Dark Mending|,v_spellname=Silencing Shot,b_t_interrupt=true,v_gcdspell=1462,[Hunter's Mark],v_t_needsdebuff=Hunter's Mark,v_spellname=Hunter's Mark,b_t_needsdebuff=true,v_gcdspell=1462,[Serpent Sting],v_t_needsdebuff=_Serpent Sting,v_p_unitpowertype=2,v_spellname=Serpent Sting,b_t_needsdebuff=true,v_gcdspell=1462,v_p_unitpower=>=25,b_p_unitpower=true,[Rapid Fire],v_spellname=Rapid Fire,v_gcdspell=1462,[Chimera Shot],v_p_unitpowertype=2,v_spellname=Chimera Shot,v_gcdspell=1462,v_p_unitpower=>=44,b_p_unitpower=true,[Steady Shot (ISS Refresh)],b_p_needbuff=true,v_spellname=Steady Shot,v_gunitpowertype=2,v_gunitpower=9,v_p_needbuff=Improved Steady Shot^3.5,v_gcdspell=1462,b_gunitpower=true,[Kill Shot],v_spellname=Kill Shot,v_gcdspell=1462,[Readiness],v_spellname=Readiness,v_gcdspell=1462,b_rangecheck=false,[Aimed Shot (MM)],v_p_unitpowertype=2,v_spellname=Aimed Shot,v_gcdspell=1462,b_p_havebuff=true,v_p_unitpower=>=50,b_p_unitpower=true,v_p_havebuff=Fire!,[Kill Command],v_spellname=Kill Command,v_gcdspell=1462,b_p_havebuff=true,v_p_havebuff=Resistance is Futile!,b_rangecheck=false,[Arcane Shot],v_p_unitpowertype=2,v_checkothercdvalue=>0,b_p_needbuff=true,v_spellname=Arcane Shot,v_checkothercdname=Chimera Shot,v_p_needbuff=Lock and Load,v_gcdspell=1462,v_p_unitpower=>=66,b_p_unitpower=true,b_checkothercd=true,[Arcane Shot (CS>=5)],v_p_unitpowertype=2,v_checkothercdvalue=>5,b_p_needbuff=true,v_spellname=Arcane Shot,v_checkothercdname=Chimera Shot,v_p_needbuff=Lock and Load,v_gcdspell=1462,v_p_unitpower=>=66,b_p_unitpower=true,b_checkothercd=true,[Steady Shot],v_spellname=Steady Shot,v_gunitpowertype=2,v_gunitpower=9,v_gcdspell=1462,b_gunitpower=true")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 BM v1.28],[Hunter's Mark],v_t_needsdebuff=Hunter's Mark,v_spellname=Hunter's Mark,b_t_needsdebuff=true,v_gcdspell=1462,[Bestial Wrath],v_p_unitpowertype=2,b_p_unitpower=true,v_spellname=Bestial Wrath,v_p_unitpower=>60,v_gcdspell=1462,[Serpent Sting],v_p_unitpowertype=2,v_t_needsdebuff=_Serpent Sting,b_p_unitpower=true,v_spellname=Serpent Sting,b_t_needsdebuff=true,v_p_unitpower=>=25,v_gcdspell=1462,[Kill Shot],v_spellname=Kill Shot,v_gcdspell=1462,[Rapid Fire],v_p_needbuff=Time Warp&Bloodlust&The Beast Within,b_p_needbuff=true,v_spellname=Rapid Fire,v_gcdspell=1462,[Kill Command],v_spellname=Kill Command,b_rangecheck=false,v_gcdspell=1462,[Fervor],v_p_unitpowertype=2,b_p_unitpower=true,v_spellname=Fervor,b_rangecheck=false,v_p_unitpower=<=20,v_gcdspell=1462,[Focus FIre],v_pet_hasbuff=Frenzy Effect#5,v_spellname=Focus Fire,b_pet_hasbuff=true,b_rangecheck=false,v_gcdspell=1462,[Arcane Shot],v_p_unitpowertype=2,b_p_unitpower=true,v_spellname=Arcane Shot,v_p_havebuff=The Beast Within,v_p_unitpower=>=90,b_p_havebuff=true,v_gcdspell=1462,[Cobra Shot],v_spellname=Cobra Shot,v_gunitpowertype=2,v_gunitpower=9,b_gunitpower=true,v_gcdspell=1462")
   end
   if (select(2, UnitClass("player")) == "MAGE") then
      --Check if player has the default rotations already stored in their db
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Fire Burn v1.27],[Pyroblast!],v_spellname=Pyroblast,v_gcdspell=475,b_p_havebuff=true,v_p_havebuff=Hot Streak,[Living Bomb],v_spellname=Living Bomb,v_t_needsbuff=Living Bomb,b_t_needsbuff=true,v_gcdspell=475,[Fireball],v_spellname=133,v_gcdspell=475")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Fire Hover v1.27],[Pyroblast!],v_spellname=Pyroblast,v_gcdspell=475,b_p_havebuff=true,v_p_havebuff=Hot Streak,[Living Bomb],v_spellname=Living Bomb,v_t_needsbuff=Living Bomb,b_t_needsbuff=true,v_gcdspell=475,[Impact],v_spellname=Fire Blast,b_toggle=true,v_toggleicon=Fire Blast,v_gcdspell=475,b_p_havebuff=true,v_p_havebuff=Impact,[Fireball],b_maxcasts=true,v_spellname=133,v_gcdspell=475,v_maxcasts=3,[Scorch1],b_maxcasts=true,v_spellname=Scorch,v_gcdspell=475,v_maxcasts=1,[Scorch2],v_lastcasted=Scorch,b_lastcasted=true,b_maxcasts=true,v_spellname=Scorch,v_gcdspell=475,v_maxcasts=1")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Arcane v1.27],[Counterspell],v_t_interrupt=BWD: |Blast Nova|,v_spellname=Counterspell,b_t_interrupt=true,v_gcdspell=475,[Fire Blast (Moving)],v_spellname=Fire Blast,v_gcdspell=475,b_moving=true,[Ice Lance (Moving)],v_spellname=Ice Lance,v_gcdspell=475,b_moving=true,[Focus Magic],b_disabled=true,v_spellname=Focus Magic,v_gcdspell=475,b_rangecheck=false,[Arcane Brilliance],b_p_needbuff=true,v_spellname=Arcane Brilliance,v_p_needbuff=Arcane Brilliance,v_gcdspell=475,b_rangecheck=false,[Mage Armor],b_p_needbuff=true,v_spellname=Mage Armor,v_p_needbuff=Mage Armor,v_gcdspell=475,b_rangecheck=false,[Arcane Power (<10%)],b_t_hp=true,v_spellname=Arcane Power,v_t_hp=<10%,v_gcdspell=475,b_rangecheck=false,[Arcane Power (AB)],v_checkothercdvalue=<26,v_spellname=Arcane Power,v_checkothercdname=Evocation,v_gcdspell=475,v_p_havedebuff=Arcane Blast#4,b_rangecheck=false,b_p_havedebuff=true,b_checkothercd=true,[Mirror Image (AP)],v_spellname=Mirror Image,v_gcdspell=475,b_p_havebuff=true,v_p_havebuff=Arcane Power,b_rangecheck=false,[Mirror Image (AP<20)],v_checkothercdvalue=<20,v_spellname=Mirror Image,v_checkothercdname=Arcane Power,v_gcdspell=475,b_rangecheck=false,b_checkothercd=true,[Flame Orb],v_spellname=Flame Orb,v_rangespell=Fireball,v_gcdspell=475,[Presence of Mind],v_spellname=Presence of Mind,v_gcdspell=475,b_rangecheck=false,[Arcane Blast (PoM)],v_spellname=Arcane Blast,v_gcdspell=475,b_p_havebuff=true,v_p_havebuff=Presence of Mind,[Arcane Blast (>5%)],v_p_unitpowertype=0,b_t_hp=true,v_spellname=Arcane Blast,v_t_hp=<=10%,v_gcdspell=475,v_p_unitpower=>5%,b_p_unitpower=true,[Arcane Blast (CC)],v_spellname=Arcane Blast,v_gcdspell=475,b_p_havebuff=true,v_p_havedebuff=Arcane Blast#2,v_p_havebuff=Clearcasting,b_p_havedebuff=true,[Arcane Barrage],v_spellname=Arcane Barrage,v_gcdspell=475,v_p_havedebuff=Arcane Blast#4,b_p_havedebuff=true,[Arcane Missiles],v_spellname=Arcane Missiles,v_gcdspell=475,[Arcane Blast (Evo<26)],v_p_unitpowertype=0,v_checkothercdvalue=<26,v_spellname=Arcane Blast,v_checkothercdname=Evocation,v_gcdspell=475,v_p_unitpower=>26%,b_p_unitpower=true,b_checkothercd=true,[Arcane Blast (>94%)],v_p_unitpowertype=0,v_spellname=Arcane Blast,v_gcdspell=475,v_p_unitpower=>94%,b_p_unitpower=true,[Arcane Blast (<4)],b_p_needbuff=true,v_spellname=Arcane Blast,v_p_needbuff=Bloodlust&Time Warp,v_gcdspell=475,b_p_needdebuff=true,v_p_needdebuff=Arcane Blast#4,[Arcane Blast (<3)],v_spellname=Arcane Blast,v_gcdspell=475,b_p_havebuff=true,v_p_havebuff=Bloodlust|Time Warp,b_p_needdebuff=true,v_p_needdebuff=Arcane Blast#3,[Evocation],b_disabled=true,v_spellname=Evocation,v_gcdspell=475,b_rangecheck=false")
   end
   if (select(2, UnitClass("player")) == "PALADIN") then   
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Ret - AoE v1.27],[Seal of Righteousness],b_p_needbuff=true,v_spellname=Seal of Righteousness,v_toggleicon=6603,v_p_needbuff=Seal of Righteousness,v_gcdspell=465,b_rangecheck=false,[Rebuke],v_t_interrupt=Raid: \n  BoT: |Dark Mending|Gale Wind|Crimson Flames|Pact of Darkness|Harden Skin|Depravity|\n  Blackwing Descent: |Arcane Annihilator|Arcane Storm|\nDungeon: |Dark Mending|Lava Bolt|Frostfire Bolt|Molten Burst|Frostbolt|Inferno Leap|\n  Grim Batol: |Corrupted Flame|Arcane Infusion|\n  Shadowfang Keep: |Cursed Bullets|Mend Rotten Flesh|Unholy Empowerment|\n  Deadmines: |Seaswell|\n  Throne of the Tides: |Water Shell|\n  HOO: |Summon Sun Orb|\n  Stonecore: |Force of Earth|\nPvP: |Cyclone|Tranquility|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|Polymorph|\n     |Penance|Mind Blast|Healing Surgeegrowth|Entangling Roots|Flash Heal|Greater Heal|\n     |Holy Smite|\nMisc: |Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|\n      |Burning Shadowbolt|Conjure Twisted Visage|Lightning Lash|Cloudburst|Vapor Form|\n      |Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowboltotting Bile|Drain Life|\n      |Forsaken Ability|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|\n      |Dark Command|Bore|Shadow Prison|Shadow Nova|Fireball|Frostbomb|,v_spellname=Rebuke,b_t_interrupt=true,v_toggleicon=6603,v_gcdspell=Rebuke,[Cleanse],v_spellname=Cleanse,b_toggle=true,v_toggleicon=Cleanse,b_p_poison=true,v_gcdspell=465,v_togglename=Toggle 4,b_rangecheck=false,b_p_disease=true,[Word of Glory (<20%)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,b_rangecheck=false,v_p_hp=<=20%,[Word of Glory (<80%)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,b_toggle=true,v_toggleicon=Word of Glory,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,v_togglename=Toggle 2,b_rangecheck=false,v_p_hp=<=80%,[Divine Shield],b_p_hp=true,v_spellname=Divine Shield,v_toggleicon=6603,v_gcdspell=465,b_rangecheck=false,b_p_needdebuff=true,v_p_needdebuff=Forbearance,v_p_hp=<=20%,[Lay on Hands],b_p_hp=true,b_p_needbuff=true,b_toggleon=true,v_spellname=Lay on Hands,b_toggle=true,v_toggleicon=Lay on Hands,v_p_needbuff=Ardent Defender,v_gcdspell=465,b_rangecheck=false,b_p_needdebuff=true,v_p_needdebuff=Forbearance,v_p_hp=<20%,[Zealotry],v_p_unitpowertype=9,b_t_hp=true,b_p_needbuff=true,v_spellname=Zealotry,v_t_hp=>2000000,v_rangespell=Crusader Strike,v_toggleicon=6603,v_p_needbuff=Avenging Wrath,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,[Inquisition],v_p_unitpowertype=9,b_p_needbuff=true,v_spellname=Inquisition,v_toggleicon=6603,v_p_needbuff=Inquisition^3,v_gcdspell=465,v_p_unitpower=>=2,b_p_unitpower=true,b_rangecheck=false,[Hammer of Wrath],v_spellname=Hammer of Wrath,v_toggleicon=6603,v_gcdspell=465,[Hammer of Wrath (AW)],v_spellname=Hammer of Wrath,v_toggleicon=6603,v_gcdspell=465,b_p_havebuff=true,v_p_havebuff=Avenging Wrath,[Exorcism],v_spellname=Exorcism,v_toggleicon=6603,b_p_havebuff=true,v_p_havebuff=The Art of War,[Templar's Verdict],v_p_unitpowertype=9,v_spellname=Templar's Verdict,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,[Templar's Verdict(Hand of Light)],v_spellname=Templar's Verdict,v_toggleicon=6603,v_gcdspell=465,b_p_havebuff=true,v_p_havebuff=Hand of Light,[Divine Storm],v_spellname=Divine Storm,v_rangespell=Crusader Strike,v_toggleicon=6603,v_gcdspell=465,[Judgement],v_spellname=Judgement,v_toggleicon=6603,v_gcdspell=465,[Holy Wrath],v_spellname=Holy Wrath,v_rangespell=Crusader Strike,v_toggleicon=6603,v_gcdspell=465,[Consecration],v_spellname=Consecration,v_rangespell=Crusader Strike,v_toggleicon=6603,v_gcdspell=465")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Ret - Max DPS v1.27],[Rebuke],v_t_interrupt=Raid: \n  BoT: |Dark Mending|Gale Wind|Crimson Flames|Pact of Darkness|Harden Skin|Depravity|\n  Blackwing Descent: |Arcane Annihilator|Arcane Storm|Shadow Nova|\nDungeon: |Dark Mending|Lava Bolt|Frostfire Bolt|Molten Burst|Frostbolt|Inferno Leap|\n  Grim Batol: |Corrupted Flame|Arcane Infusion|\n  Shadowfang Keep: |Cursed Bullets|Mend Rotten Flesh|Unholy Empowerment|\n  Deadmines: |Seaswell|\n  Throne of the Tides: |Water Shell|\n  HOO: |Summon Sun Orb|\n  Stonecore: |Force of Earth|\nPvP: |Cyclone|Tranquility|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|Polymorph|\n     |Penance|Mind Blast|Healing Surgeegrowth|Entangling Roots|Flash Heal|Greater Heal|\n     |Holy Smite|\nMisc: |Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|\n      |Burning Shadowbolt|Conjure Twisted Visage|Lightning Lash|Cloudburst|Vapor Form|\n      |Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowboltotting Bile|Drain Life|\n      |Forsaken Ability|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|\n      |Dark Command|Bore|Shadow Prison|Fireball|Frostbomb|,b_toggleon=true,v_spellname=Rebuke,b_t_interrupt=true,b_toggle=true,v_toggleicon=Rebuke,v_gcdspell=465,v_togglename=Toggle 3,[Divine Plea],v_p_unitpowertype=0,v_spellname=Divine Plea,v_gcdspell=465,v_p_unitpower=<40%,b_p_unitpower=true,b_rangecheck=false,[Word of Glory (<10k)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,b_rangecheck=false,v_p_hp=<=15000,[Word of Glory (<80%)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,b_toggle=true,v_toggleicon=Word of Glory,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,v_togglename=Toggle 2,b_rangecheck=false,v_p_hp=<=80%,[Lay on Hands],b_disabled=true,b_p_hp=true,b_p_needbuff=true,b_toggleon=true,v_spellname=Lay on Hands,b_toggle=true,v_toggleicon=Lay on Hands,v_p_needbuff=Ardent Defender,v_gcdspell=465,b_rangecheck=false,b_p_needdebuff=true,v_p_needdebuff=Forbearance,v_p_hp=<20%,[Divine Shield],b_disabled=true,b_p_hp=true,v_spellname=Divine Shield,v_toggleicon=6603,v_gcdspell=465,b_rangecheck=false,b_p_needdebuff=true,v_p_needdebuff=Forbearance,v_p_hp=<=20%,[Cleanse],v_spellname=Cleanse,b_toggle=true,v_toggleicon=Cleanse,b_p_poison=true,v_gcdspell=465,v_togglename=Toggle 4,b_rangecheck=false,b_p_disease=true,[Seal of Truth],b_p_needbuff=true,v_spellname=Seal of Truth,v_toggleicon=6603,v_p_needbuff=Seal of Truth,v_gcdspell=465,b_rangecheck=false,[Fury of Angerforge],b_notaspell=true,v_spellname=Trinket1Slot,v_gcdspell=465,b_p_havebuff=true,v_p_havebuff=Raw Fury#5,b_rangecheck=false,[Judgement (JotP)],v_t_needsdebuff=_Judgements of the Pure,b_p_needbuff=true,v_spellname=Judgement,b_t_needsdebuff=true,v_toggleicon=6603,v_p_needbuff=Judgements of the Pure,v_gcdspell=465,[Zealotry],v_p_unitpowertype=9,b_p_needbuff=true,v_spellname=Zealotry,v_t_hp=>2000000,v_rangespell=Crusader Strike,v_toggleicon=6603,v_p_needbuff=Avenging Wrath,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,[Inquisition],v_p_unitpowertype=9,b_p_needbuff=true,v_spellname=Inquisition,v_toggleicon=6603,v_p_needbuff=Inquisition^4,v_gcdspell=465,v_p_unitpower=>=2,b_p_unitpower=true,b_rangecheck=false,v_p_hp=0,[Inquisition (DP)],b_p_needbuff=true,v_spellname=Inquisition,v_toggleicon=6603,v_p_needbuff=Inquisition^4,v_gcdspell=465,b_p_havebuff=true,v_p_havebuff=Divine Purpose,b_rangecheck=false,v_p_hp=0,[Templar's Verdict],v_p_unitpowertype=9,v_spellname=Templar's Verdict,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,[Crusader Strike (DP)],v_p_unitpowertype=9,v_spellname=Crusader Strike,v_gunitpowertype=9,v_toggleicon=6603,v_gunitpower=1,v_gcdspell=465,b_p_havebuff=true,v_p_unitpower=<3,b_p_unitpower=true,v_p_havebuff=Divine Purpose^2,b_gunitpower=true,[Templar's Verdict (DP)],v_spellname=Templar's Verdict,v_toggleicon=6603,v_gcdspell=465,b_p_havebuff=true,v_p_havebuff=Divine Purpose,[Crusader Strike],v_p_unitpowertype=9,v_spellname=Crusader Strike,v_gunitpowertype=9,v_toggleicon=6603,v_gunitpower=1,v_gcdspell=465,v_p_unitpower=<3,b_p_unitpower=true,b_gunitpower=true,[Hammer of Wrath],v_spellname=Hammer of Wrath,v_toggleicon=6603,v_gcdspell=465,[Hammer of Wrath (AW)],v_spellname=Hammer of Wrath,v_toggleicon=6603,v_gcdspell=465,b_p_havebuff=true,v_p_havebuff=Avenging Wrath,[Exorcism],v_spellname=Exorcism,v_toggleicon=6603,v_gcdspell=465,b_p_havebuff=true,v_p_havebuff=The Art of War,[Judgement (JotP<2)],v_t_needsdebuff=_Judgements of the Pure,b_p_needbuff=true,v_spellname=Judgement,b_t_needsdebuff=true,v_toggleicon=6603,v_p_needbuff=Judgements of the Pure^2,v_gcdspell=465,[Judgement],v_spellname=Judgement,v_toggleicon=6603,v_gcdspell=465,[Holy Wrath],v_spellname=Holy Wrath,v_rangespell=Crusader Strike,v_toggleicon=6603,v_gcdspell=465,[Consecration],v_p_unitpowertype=0,v_spellname=Consecration,v_rangespell=Crusader Strike,v_gcdspell=465,v_p_unitpower=>80%,b_p_unitpower=true")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Ret - No AoE v1.27],[Seal of Truth],b_disabled=true,b_p_needbuff=true,v_spellname=Seal of Truth,v_toggleicon=6603,v_p_needbuff=Seal of Truth,v_gcdspell=465,b_rangecheck=false,[Rebuke],v_t_interrupt=Raid: \n  BoT: |Dark Mending|Gale Wind|Crimson Flames|Pact of Darkness|Harden Skin|Depravity|\n  Blackwing Descent: |Arcane Annihilator|Arcane Storm|Shadow Nova|\nDungeon: |Dark Mending|Lava Bolt|Frostfire Bolt|Molten Burst|Frostbolt|Inferno Leap|\n  Grim Batol: |Corrupted Flame|Arcane Infusion|\n  Shadowfang Keep: |Cursed Bullets|Mend Rotten Flesh|Unholy Empowerment|\n  Deadmines: |Seaswell|\n  Throne of the Tides: |Water Shell|\n  HOO: |Summon Sun Orb|\n  Stonecore: |Force of Earth|\nPvP: |Cyclone|Tranquility|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|Polymorph|\n     |Penance|Mind Blast|Healing Surgeegrowth|Entangling Roots|Flash Heal|Greater Heal|\n     |Holy Smite|\nMisc: |Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|\n      |Burning Shadowbolt|Conjure Twisted Visage|Lightning Lash|Cloudburst|Vapor Form|\n      |Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowboltotting Bile|Drain Life|\n      |Forsaken Ability|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|\n      |Dark Command|Bore|Shadow Prison|Fireball|Frostbomb|,v_spellname=Rebuke,b_t_interrupt=true,b_toggle=true,v_toggleicon=Rebuke,v_gcdspell=465,v_togglename=Toggle 3,[Cleanse],v_spellname=Cleanse,b_toggle=true,v_toggleicon=Cleanse,b_p_poison=true,v_gcdspell=465,v_togglename=Toggle 4,b_rangecheck=false,b_p_disease=true,[Word of Glory (<20%)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,b_rangecheck=false,v_p_hp=<=20%,[Word of Glory (<80%)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,b_toggle=true,v_toggleicon=Word of Glory,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,v_togglename=Toggle 2,b_rangecheck=false,v_p_hp=<=80%,[Divine Shield],b_disabled=true,b_p_hp=true,v_spellname=Divine Shield,v_toggleicon=6603,v_gcdspell=465,b_rangecheck=false,b_p_needdebuff=true,v_p_needdebuff=Forbearance,v_p_hp=<=20%,[Lay on Hands],b_p_hp=true,b_p_needbuff=true,b_toggleon=true,v_spellname=Lay on Hands,b_toggle=true,v_toggleicon=Lay on Hands,v_p_needbuff=Ardent Defender,v_gcdspell=465,b_rangecheck=false,b_p_needdebuff=true,v_p_needdebuff=Forbearance,v_p_hp=<20%,[Zealotry],v_p_unitpowertype=9,b_t_hp=true,b_p_needbuff=true,v_spellname=Zealotry,v_t_hp=>2000000,v_rangespell=Crusader Strike,v_toggleicon=6603,v_p_needbuff=Avenging Wrath,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,[Inquisition],v_p_unitpowertype=9,b_p_needbuff=true,v_spellname=Inquisition,v_toggleicon=6603,v_p_needbuff=Inquisition^3,v_gcdspell=465,v_p_unitpower=>=2,b_p_unitpower=true,b_rangecheck=false,v_p_hp=0,[Hammer of Wrath],v_spellname=Hammer of Wrath,v_toggleicon=6603,v_gcdspell=465,[Hammer of Wrath (AW)],v_spellname=Hammer of Wrath,v_toggleicon=6603,v_gcdspell=465,b_p_havebuff=true,v_p_havebuff=Avenging Wrath,[Templar's Verdict],v_p_unitpowertype=9,v_spellname=Templar's Verdict,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,[Templar's Verdict(Hand of Light)],v_spellname=Templar's Verdict,v_toggleicon=6603,v_gcdspell=465,b_p_havebuff=true,v_p_havebuff=76672,[Exorcism],v_checkothercdvalue=>1.5,v_spellname=Exorcism,v_checkothercdname=35395,v_toggleicon=6603,v_gcdspell=465,b_p_havebuff=true,v_p_havebuff=The Art of War,[Crusader Strike],v_p_unitpowertype=9,v_spellname=Crusader Strike,v_gunitpowertype=9,v_toggleicon=6603,v_gunitpower=1,v_gcdspell=465,v_p_unitpower=<3,b_p_unitpower=true,b_gunitpower=true,[Judgement],v_spellname=Judgement,v_toggleicon=6603,v_gcdspell=465")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Holy v1.28],[Rebuke],b_toggleon=true,v_t_interrupt=|Dark Mending|,b_t_interrupt=true,b_checkothercd=true,v_spellname=Arcane Torrent,v_checkothercdname=Rebuke,b_toggle=true,v_rangespell=Crusader Strike,v_toggleicon=Rebuke,v_togglename=Toggle 3,v_gcdspell=Devotion Aura,[Word of Glory (<10k)],b_p_hp=true,v_p_unitpowertype=9,b_p_unitpower=true,v_spellname=Word of Glory,b_rangecheck=false,v_p_unitpower=>=2,v_p_hp=<=10000,v_gcdspell=Devotion Aura,[Word of Glory (<80%)],b_p_hp=true,v_p_unitpowertype=9,b_p_unitpower=true,v_spellname=Word of Glory,b_toggle=true,v_toggleicon=Word of Glory,v_togglename=Toggle 2,b_rangecheck=false,v_p_unitpower=>=3,v_p_hp=<=80%,v_gcdspell=Devotion Aura,[Lay on Hands],b_p_hp=true,b_toggleon=true,v_p_needbuff=Ardent Defender,b_disabled=true,b_p_needbuff=true,v_spellname=Lay on Hands,b_toggle=true,v_toggleicon=Lay on Hands,b_p_needdebuff=true,b_rangecheck=false,v_p_needdebuff=Forbearance,v_p_hp=<20%,v_gcdspell=Devotion Aura,[Divine Shield],b_p_hp=true,b_disabled=true,v_spellname=Divine Shield,v_toggleicon=6603,b_p_needdebuff=true,b_rangecheck=false,v_p_needdebuff=Forbearance,v_p_hp=<=20%,v_gcdspell=Devotion Aura,[Cleanse],b_p_disease=true,v_spellname=Cleanse,b_toggle=true,v_toggleicon=Cleanse,b_p_poison=true,v_togglename=Toggle 4,b_rangecheck=false,v_gcdspell=Devotion Aura,[Seal of Truth],v_p_needbuff=Seal of Truth,b_p_needbuff=true,v_spellname=Seal of Truth,v_toggleicon=6603,b_rangecheck=false,v_gcdspell=Devotion Aura,[Fury of Angerforge],b_notaspell=true,v_spellname=Trinket1Slot,v_p_havebuff=Raw Fury#5,b_rangecheck=false,b_p_havebuff=true,v_gcdspell=Devotion Aura,[Judgement (JotP)],v_p_needbuff=Judgements of the Pure,v_t_needsdebuff=_Judgements of the Pure,b_p_needbuff=true,v_spellname=Judgement,b_t_needsdebuff=true,v_toggleicon=6603,v_gcdspell=Devotion Aura,[Zealotry],v_p_needbuff=Avenging Wrath,v_p_unitpowertype=9,b_p_unitpower=true,b_p_needbuff=true,v_spellname=Zealotry,v_rangespell=Crusader Strike,v_toggleicon=6603,v_t_hp=>2000000,v_p_unitpower=>=3,v_gcdspell=Devotion Aura,[Inquisition],v_p_needbuff=Inquisition^4,v_p_unitpowertype=9,b_p_unitpower=true,b_p_needbuff=true,v_spellname=Inquisition,v_toggleicon=6603,b_rangecheck=false,v_p_unitpower=>=2,v_p_hp=0,v_gcdspell=Devotion Aura,[Inquisition (DP)],v_p_needbuff=Inquisition^4,b_p_needbuff=true,v_spellname=Inquisition,v_toggleicon=6603,v_p_havebuff=Divine Purpose,b_rangecheck=false,b_p_havebuff=true,v_p_hp=0,v_gcdspell=Devotion Aura,[Templar's Verdict],v_p_unitpowertype=9,b_p_unitpower=true,v_spellname=Templar's Verdict,v_toggleicon=6603,v_p_unitpower=>=3,v_gcdspell=Devotion Aura,[Holy Shock],v_p_unitpowertype=9,b_p_unitpower=true,v_spellname=Holy Shock,v_gunitpowertype=9,v_gunitpower=1,v_p_unitpower=<=2,b_gunitpower=true,v_gcdspell=465,[Crusader Strike (DP)],v_p_unitpowertype=9,b_p_unitpower=true,v_spellname=Crusader Strike,v_gunitpowertype=9,v_toggleicon=6603,v_gunitpower=1,v_p_havebuff=Divine Purpose^2,v_p_unitpower=<3,b_p_havebuff=true,b_gunitpower=true,v_gcdspell=Devotion Aura,[Templar's Verdict (DP)],v_spellname=Templar's Verdict,v_toggleicon=6603,v_p_havebuff=Divine Purpose,b_p_havebuff=true,v_gcdspell=Devotion Aura,[Crusader Strike],v_p_unitpowertype=9,b_p_unitpower=true,v_spellname=Crusader Strike,v_gunitpowertype=9,v_toggleicon=6603,v_gunitpower=1,v_p_unitpower=<3,b_gunitpower=true,v_gcdspell=Devotion Aura,[Hammer of Wrath],v_spellname=Hammer of Wrath,v_toggleicon=6603,v_gcdspell=Devotion Aura,[Hammer of Wrath (AW)],v_spellname=Hammer of Wrath,v_toggleicon=6603,v_p_havebuff=Avenging Wrath,b_p_havebuff=true,v_gcdspell=Devotion Aura,[Exorcism],v_spellname=Exorcism,v_toggleicon=6603,v_p_havebuff=The Art of War,b_p_havebuff=true,v_gcdspell=Devotion Aura,[Judgement (JotP<2)],v_p_needbuff=Judgements of the Pure^2,v_t_needsdebuff=_Judgements of the Pure,b_p_needbuff=true,v_spellname=Judgement,b_t_needsdebuff=true,v_toggleicon=6603,v_gcdspell=Devotion Aura,[Judgement],v_spellname=Judgement,v_toggleicon=6603,v_gcdspell=Devotion Aura,[Holy Wrath],v_spellname=Holy Wrath,v_rangespell=Crusader Strike,v_toggleicon=6603,v_gcdspell=Devotion Aura,[Consecration],v_p_unitpowertype=0,b_p_unitpower=true,v_spellname=Consecration,v_rangespell=Crusader Strike,v_p_unitpower=>80%,v_gcdspell=Devotion Aura,[Divine Plea],v_p_unitpowertype=0,b_p_unitpower=true,v_spellname=Divine Plea,b_rangecheck=false,v_p_unitpower=<50%,v_gcdspell=Devotion Aura")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Tank - Dungeon v1.27],[Rebuke],v_t_interrupt=Raid: \n  BoT: |Dark Mending|Gale Wind|Crimson Flames|Pact of Darkness|Harden Skin|Depravity|\n  Blackwing Descent: |Arcane Annihilator|Arcane Storm|Shadow Nova|\nDungeon: |Dark Mending|Lava Bolt|Frostfire Bolt|Molten Burst|Frostbolt|Inferno Leap|\n  Grim Batol: |Corrupted Flame|Arcane Infusion|\n  Shadowfang Keep: |Cursed Bullets|Mend Rotten Flesh|Unholy Empowerment|\n  Deadmines: |Seaswell|\n  Throne of the Tides: |Water Shell|\n  HOO: |Summon Sun Orb|\n  Stonecore: |Force of Earth|\nPvP: |Cyclone|Tranquility|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|Polymorph|\n     |Penance|Mind Blast|Healing Surgeegrowth|Entangling Roots|Flash Heal|Greater Heal|\n     |Holy Smite|\nMisc: |Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|\n      |Burning Shadowbolt|Conjure Twisted Visage|Lightning Lash|Cloudburst|Vapor Form|\n      |Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowboltotting Bile|Drain Life|\n      |Forsaken Ability|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|\n      |Dark Command|Bore|Shadow Prison|Fireball|Frostbomb|,v_spellname=Rebuke,b_t_interrupt=true,b_toggle=true,v_toggleicon=Rebuke,v_gcdspell=465,v_togglename=Toggle 3,[Avenger's Shield (Interrupt)],v_t_interrupt=|Lightning Bolt|Seaswell|Mend Rotten Flesh|Blast Nova|,b_toggleon=true,v_spellname=Avenger's Shield,b_t_interrupt=true,b_toggle=true,v_toggleicon=Avenger's Shield,v_gcdspell=465,v_togglename=Toggle 3,[Ardent Defender],v_checkothercdvalue=>0,b_p_hp=true,v_spellname=Ardent Defender,v_checkothercdname=Ardent Defender,v_toggleicon=6603,v_gcdspell=Ardent Defender,b_rangecheck=false,v_p_hp=<=15%,b_checkothercd=true,[Lay on Hands],b_p_hp=true,b_p_needbuff=true,v_spellname=Lay on Hands,v_toggleicon=6603,v_p_needbuff=Ardent Defender,v_gcdspell=465,b_rangecheck=false,b_p_needdebuff=true,v_p_needdebuff=Forbearance,v_p_hp=<20%,[Cleanse],b_toggleon=true,v_spellname=Cleanse,b_toggle=true,v_toggleicon=Cleanse,b_p_poison=true,v_gcdspell=465,v_togglename=Toggle 4,b_rangecheck=false,b_p_disease=true,[Word of Glory (<20%)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,b_rangecheck=false,v_p_hp=<=20%,[Word of Glory (<85%)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,b_toggle=true,v_toggleicon=Word of Glory,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,v_togglename=Toggle 2,b_rangecheck=false,v_p_hp=<=85%,[Divine Plea],v_p_unitpowertype=0,v_spellname=Divine Plea,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=<15000,b_p_unitpower=true,b_rangecheck=false,[Shield of the Righteous],v_p_unitpowertype=9,v_spellname=Shield of the Righteous,v_toggleicon=6603,v_gcdspell=465,v_maxcasts=0,v_p_unitpower=>=3,b_p_unitpower=true,[Hammer of the Righteous],v_spellname=Hammer of the Righteous,v_toggleicon=6603,v_gcdspell=465,[Avenger's Shield],b_toggleon=true,v_spellname=Avenger's Shield,b_toggle=true,v_toggleicon=Avenger's Shield,v_gcdspell=465,[Holy Wrath],v_lastcasted=Hammer of the Righteous,b_lastcasted=true,v_spellname=Holy Wrath,v_rangespell=Crusader Strike,v_toggleicon=6603,v_gcdspell=465,[Judgement],v_spellname=Judgement,v_toggleicon=6603,v_gcdspell=465,[Hammer of Wrath],b_t_hp=true,v_spellname=Hammer of Wrath,v_t_hp=<=20%,v_toggleicon=6603,v_gcdspell=465,[Auto Attack],b_notaspell=true,v_spellname=Auto Attack,v_toggleicon=6603,v_gcdspell=-1,b_rangecheck=false")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Tank - Single Break CC v1.27],[Rebuke],v_t_interrupt=Raid: \n  BoT: |Dark Mending|Gale Wind|Crimson Flames|Pact of Darkness|Harden Skin|Depravity|\n  Blackwing Descent: |Arcane Annihilator|Arcane Storm|Shadow Nova|\nDungeon: |Dark Mending|Lava Bolt|Frostfire Bolt|Molten Burst|Frostbolt|Inferno Leap|\n  Grim Batol: |Corrupted Flame|Arcane Infusion|\n  Shadowfang Keep: |Cursed Bullets|Mend Rotten Flesh|Unholy Empowerment|\n  Deadmines: |Seaswell|\n  Throne of the Tides: |Water Shell|\n  HOO: |Summon Sun Orb|\n  Stonecore: |Force of Earth|\nPvP: |Cyclone|Tranquility|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|Polymorph|\n     |Penance|Mind Blast|Healing Surgeegrowth|Entangling Roots|Flash Heal|Greater Heal|\n     |Holy Smite|\nMisc: |Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|\n      |Burning Shadowbolt|Conjure Twisted Visage|Lightning Lash|Cloudburst|Vapor Form|\n      |Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowboltotting Bile|Drain Life|\n      |Forsaken Ability|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|\n      |Dark Command|Bore|Shadow Prison|Fireball|Frostbomb|,v_spellname=Rebuke,b_t_interrupt=true,b_toggle=true,v_toggleicon=Rebuke,v_gcdspell=465,v_togglename=Toggle 3,[Avenger's Shield (Interrupt)],v_t_interrupt=|Lightning Bolt|Seaswell|Mend Rotten Flesh|Blast Nova|,b_toggleon=true,v_spellname=Avenger's Shield,b_t_interrupt=true,b_toggle=true,v_toggleicon=Avenger's Shield,v_gcdspell=465,v_togglename=Toggle 3,[Arcane Torrent],v_checkothercdvalue=>0,v_t_interrupt=|Lightning Bolt|Seaswell|Mend Rotten Flesh|Blast Nova|,v_spellname=Arcane Torrent,v_checkothercdname=Avenger's Shield,b_t_interrupt=true,v_rangespell=Crusader Strike,v_gcdspell=465,v_togglename=Toggle 3,b_checkothercd=true,[Ardent Defender],b_p_hp=true,v_spellname=Ardent Defender,v_toggleicon=6603,v_gcdspell=Ardent Defender,b_rangecheck=false,v_p_hp=<=15%,[Lay on Hands],v_checkothercdvalue=>0,b_p_hp=true,b_p_needbuff=true,v_spellname=Lay on Hands,v_checkothercdname=Ardent Defender,v_toggleicon=6603,v_p_needbuff=Ardent Defender,v_gcdspell=465,b_rangecheck=false,b_p_needdebuff=true,v_p_needdebuff=Forbearance,v_p_hp=<20%,b_checkothercd=true,[Cleanse],v_spellname=Cleanse,b_toggle=true,v_toggleicon=Cleanse,b_p_poison=true,v_gcdspell=465,v_togglename=Toggle 4,b_rangecheck=false,b_p_disease=true,[Word of Glory (<20%)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,b_rangecheck=false,v_p_hp=<=20%,[Word of Glory (<85%)],v_p_unitpowertype=9,b_disabled=true,b_p_hp=true,v_spellname=Word of Glory,v_toggleicon=Word of Glory,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,v_togglename=Toggle 2,b_rangecheck=false,v_p_hp=<=85%,[Word of Glory (100%)],v_p_unitpowertype=9,v_spellname=Word of Glory,b_toggle=true,v_toggleicon=Word of Glory,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,v_togglename=Toggle 2,b_rangecheck=false,[Divine Plea],v_p_unitpowertype=0,v_spellname=Divine Plea,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=<12000,b_p_unitpower=true,b_rangecheck=false,[Shield of the Righteous],v_p_unitpowertype=9,v_spellname=Shield of the Righteous,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,[Crusader Strike],v_spellname=Crusader Strike,v_toggleicon=6603,v_gcdspell=465,[Judgement],v_spellname=Judgement,v_toggleicon=6603,v_gcdspell=465,[Avenger's Shield],b_toggleon=true,v_spellname=Avenger's Shield,b_toggle=true,v_toggleicon=Avenger's Shield,v_gcdspell=465,[Hammer of Wrath],b_t_hp=true,v_spellname=Hammer of Wrath,v_t_hp=<=20%,v_toggleicon=6603,v_gcdspell=465,[Holy Wrath],v_spellname=Holy Wrath,v_rangespell=Crusader Strike,v_toggleicon=6603,v_gcdspell=465,[Auto Attack],b_notaspell=true,v_spellname=Auto Attack,v_toggleicon=6603,v_gcdspell=-1")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Tank - Single Keep CC v1.27],[Rebuke],v_t_interrupt=Raid: \n  BoT: |Dark Mending|Gale Wind|Crimson Flames|Pact of Darkness|Harden Skin|Depravity|\n  Blackwing Descent: |Arcane Annihilator|Arcane Storm|Shadow Nova|\nDungeon: |Dark Mending|Lava Bolt|Frostfire Bolt|Molten Burst|Frostbolt|Inferno Leap|\n  Grim Batol: |Corrupted Flame|Arcane Infusion|\n  Shadowfang Keep: |Cursed Bullets|Mend Rotten Flesh|Unholy Empowerment|\n  Deadmines: |Seaswell|\n  Throne of the Tides: |Water Shell|\n  HOO: |Summon Sun Orb|\n  Stonecore: |Force of Earth|\nPvP: |Cyclone|Tranquility|Fear|Howl of Terror|Holy Light|Flash of Light|Divine Light|Polymorph|\n     |Penance|Mind Blast|Healing Surgeegrowth|Entangling Roots|Flash Heal|Greater Heal|\n     |Holy Smite|\nMisc: |Erupting Fire|Siphon Essence|Umbral Mending|Corrupted Flame|Azure Blast|\n      |Burning Shadowbolt|Conjure Twisted Visage|Lightning Lash|Cloudburst|Vapor Form|\n      |Curse of the Runecaster|Charged Shot|Blinding Toxin|Shadowboltotting Bile|Drain Life|\n      |Forsaken Ability|Arcane Barrage|Cursed Bullets|Soul Drain|Inflict Pain|Shadow Strike|\n      |Dark Command|Bore|Shadow Prison|Fireball|Frostbomb|,v_spellname=Rebuke,b_t_interrupt=true,b_toggle=true,v_toggleicon=Rebuke,v_gcdspell=465,v_togglename=Toggle 3,[Avenger's Shield (Interrupt)],v_t_interrupt=|Lightning Bolt|Seaswell|Mend Rotten Flesh|Blast Nova|,b_toggleon=true,v_spellname=Avenger's Shield,b_t_interrupt=true,b_toggle=true,v_toggleicon=Avenger's Shield,v_gcdspell=465,v_togglename=Toggle 3,[Arcane Torrent],v_checkothercdvalue=>0,v_t_interrupt=|Lightning Bolt|Seaswell|Mend Rotten Flesh|Blast Nova|,v_spellname=Arcane Torrent,v_checkothercdname=Avenger's Shield,b_t_interrupt=true,v_rangespell=Crusader Strike,v_gcdspell=465,v_togglename=Toggle 3,b_checkothercd=true,[Ardent Defender],b_p_hp=true,v_spellname=Ardent Defender,v_toggleicon=6603,v_gcdspell=Ardent Defender,b_rangecheck=false,v_p_hp=<=15%,[Lay on Hands],v_checkothercdvalue=>0,b_p_hp=true,b_p_needbuff=true,v_spellname=Lay on Hands,v_checkothercdname=Ardent Defender,v_toggleicon=6603,v_p_needbuff=Ardent Defender,v_gcdspell=465,b_rangecheck=false,b_p_needdebuff=true,v_p_needdebuff=Forbearance,v_p_hp=<20%,b_checkothercd=true,[Cleanse],v_spellname=Cleanse,b_toggle=true,v_toggleicon=Cleanse,b_p_poison=true,v_gcdspell=465,v_togglename=Toggle 4,b_rangecheck=false,b_p_disease=true,[Word of Glory (<20%)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,b_rangecheck=false,v_p_hp=<=20%,[Word of Glory (<85%)],v_p_unitpowertype=9,b_disabled=true,b_p_hp=true,v_spellname=Word of Glory,b_toggle=true,v_toggleicon=Word of Glory,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,v_togglename=Toggle 2,b_rangecheck=false,v_p_hp=<=85%,[Word of Glory (100%)],v_p_unitpowertype=9,b_p_hp=true,v_spellname=Word of Glory,b_toggle=true,v_toggleicon=Word of Glory,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,v_togglename=Toggle 2,b_rangecheck=false,v_p_hp=<=85%,[Divine Plea],v_p_unitpowertype=0,v_spellname=Divine Plea,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=<12000,b_p_unitpower=true,b_rangecheck=false,[Shield of the Righteous],v_p_unitpowertype=9,v_spellname=Shield of the Righteous,v_toggleicon=6603,v_gcdspell=465,v_p_unitpower=>=3,b_p_unitpower=true,[Crusader Strike],v_spellname=Crusader Strike,v_toggleicon=6603,v_gcdspell=465,[Judgement],v_spellname=Judgement,v_toggleicon=6603,v_gcdspell=465,[Avenger's Shield],b_toggleon=true,v_spellname=Avenger's Shield,b_toggle=true,v_toggleicon=Avenger's Shield,v_gcdspell=465,[Hammer of Wrath],b_t_hp=true,v_spellname=Hammer of Wrath,v_t_hp=<=20%,v_toggleicon=6603,v_gcdspell=465,[Auto Attack],b_notaspell=true,v_spellname=Auto Attack,v_toggleicon=6603,v_gcdspell=-1,b_rangecheck=false")
   end
   if (select(2, UnitClass("player")) == "PRIEST") then
      --Check if player has the default rotations already stored in their db
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Shadow v1.27],[Shadowfiend],v_p_unitpowertype=0,v_spellname=Shadowfiend,v_gcdspell=585,v_p_unitpower=<=80%,b_p_unitpower=true,b_rangecheck=false,[Shadow Word: Pain],v_t_needsdebuff=_Shadow Word: Pain^1.5,b_p_needbuff=true,v_spellname=Shadow Word: Pain,b_t_needsdebuff=true,v_p_needbuff=Shadow Orb#1&Empowered Shadow,v_gcdspell=585,[Shadow Word: Pain (ES)],v_t_needsdebuff=_Shadow Word: Pain^1.5,v_spellname=Shadow Word: Pain,b_t_needsdebuff=true,v_gcdspell=585,b_p_havebuff=true,v_p_havebuff=Empowered Shadow,[Vampiric Touch],v_t_needsdebuff=_Vampiric Touch^2.0,b_p_needbuff=true,b_maxcasts=true,v_spellname=Vampiric Touch,b_t_needsdebuff=true,b_breakchanneling=true,v_p_needbuff=Shadow Orb#1&Empowered Shadow,v_gcdspell=585,v_maxcasts=1,[Vampiric Touch (ES)],v_t_needsdebuff=_Vampiric Touch^2.0,b_maxcasts=true,v_spellname=Vampiric Touch,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=585,b_p_havebuff=true,v_maxcasts=1,v_p_havebuff=Empowered Shadow^2,[Devouring Plague],v_t_needsdebuff=_Devouring Plague^1.5,b_p_needbuff=true,v_spellname=Devouring Plague,b_t_needsdebuff=true,b_breakchanneling=true,v_p_needbuff=Shadow Orb#1&Empowered Shadow,v_gcdspell=585,[Devouring Plague (ES)],v_t_needsdebuff=_Devouring Plague^1.5,v_spellname=Devouring Plague,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=585,b_p_havebuff=true,v_p_havebuff=Empowered Shadow,[Shadow Word: Death],b_p_needbuff=true,b_toggleon=true,v_spellname=Shadow Word: Death,b_toggle=true,b_breakchanneling=true,v_toggleicon=Shadow Word: Death,v_p_needbuff=Shadow Orb#1&Empowered Shadow,v_gcdspell=585,v_togglename=Toggle 2,[Shadow Word: Death (ES)],b_toggleon=true,v_spellname=Shadow Word: Death,b_toggle=true,b_breakchanneling=true,v_toggleicon=Shadow Word: Death,v_gcdspell=585,b_p_havebuff=true,v_togglename=Toggle 2,v_p_havebuff=Empowered Shadow,[Archangel],v_p_unitpowertype=0,v_spellname=Archangel,b_breakchanneling=true,v_gcdspell=585,b_p_havebuff=true,v_p_unitpower=<=95%,b_p_unitpower=true,v_p_havebuff=Dark Evangelism#5,b_rangecheck=false,[Mind Blast],b_p_needbuff=true,b_toggleon=true,v_spellname=Mind Blast,b_toggle=true,b_breakchanneling=true,v_toggleicon=Mind Blast,v_p_needbuff=Empowered Shadow^2,v_gcdspell=585,b_p_havebuff=true,v_p_havebuff=Shadow Orb#1,[Mind Flay],v_spellname=Mind Flay,b_breakchanneling=true,v_gcdspell=585")
   end 
   if (select(2, UnitClass("player")) == "ROGUE") then
      --Check if player has the default rotations already stored in their db
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Combat v1.27],[Kick],v_t_interrupt=BoT: |Arcane Annihilator|Arcane Storm|,v_spellname=Kick,b_t_interrupt=true,v_toggleicon=6603,v_gcdspell=5938,[Recuperate],v_spellname=Recuperate,v_gcdspell=5938,b_rangecheck=false,[Instant Poison (MH)],b_p_nmh=true,b_notaspell=true,v_spellname=Instant Poison,b_rangecheck=false,v_p_nmh=Instant Poison,v_actionicon=2842,[Deadly Poison (OH)],b_notaspell=true,v_spellname=Deadly Poison,b_p_noh=true,v_p_noh=Deadly Poison,b_rangecheck=false,v_actionicon=67711,[Slice and Dice],b_p_needbuff=true,v_spellname=Slice and Dice,v_p_combopoints=>=2,v_toggleicon=6603,v_p_needbuff=Slice and Dice,b_p_combopoints=true,v_gcdspell=5938,b_rangecheck=false,[Revealing Strike],v_spellname=Revealing Strike,v_p_combopoints==4,v_toggleicon=6603,b_p_combopoints=true,v_gcdspell=5938,b_gcombopoints=true,v_gcombopoints=1,[Rupture],v_t_needsdebuff=_Rupture,v_spellname=Rupture,b_t_needsdebuff=true,v_p_combopoints=>=5,v_toggleicon=6603,b_p_combopoints=true,v_gcdspell=5938,[Eviscerate],b_t_hasdebuff=true,v_t_hasdebuff=Rupture,v_spellname=Eviscerate,v_p_combopoints=>=5,v_toggleicon=6603,b_p_combopoints=true,v_gcdspell=5938,[Sinister Strike],v_spellname=Sinister Strike,v_toggleicon=6603,v_gcdspell=5938,b_gcombopoints=true,v_gcombopoints=1")
   end
   if (select(2, UnitClass("player")) == "SHAMAN") then
      --Check if player has the default rotations already stored in their db
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Enhancement - DPS v1.27],[Wind Shear],v_t_interrupt=BoT: |Dark Mending|Gale Wind|Crimson Flames|Pact of Darkness|Harden Skin|Depravity|,v_spellname=Wind Shear,b_t_interrupt=true,v_gcdspell=324,[Feral Spirit],v_spellname=Feral Spirit,v_gcdspell=324,b_rangecheck=false,[Windfury (MH)],b_p_nmh=true,v_spellname=Windfury Weapon,v_gcdspell=324,b_rangecheck=false,v_p_nmh=Windfury,v_actionicon=8232,[Flametongue (OH)],v_spellname=Flametongue Weapon,b_p_noh=true,v_p_noh=Flametongue,v_gcdspell=324,b_rangecheck=false,v_actionicon=8024,[Searing Totem],b_p_firetoteminactive=true,v_spellname=Searing Totem,v_gcdspell=324,v_p_firetoteminactive=Searing Totem,b_rangecheck=false,[Lava Lash],v_spellname=Lava Lash,v_gcdspell=324,[Lightning Bolt (Maelstrom Weaponx5)],v_spellname=Lightning Bolt,v_gcdspell=324,b_p_havebuff=true,v_p_havebuff=Maelstrom Weapon#5,[Unleash Elements],v_spellname=Unleash Elements,v_gcdspell=324,b_rangecheck=false,[Flame Shock (Unleash Flame)],v_spellname=Flame Shock,v_gcdspell=324,b_p_havebuff=true,v_p_havebuff=73683,[Stormstrike],v_spellname=Stormstrike,v_gcdspell=324,[Earth Shock],b_p_needbuff=true,v_spellname=Earth Shock,v_p_needbuff=73683,v_gcdspell=324")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Elemental - DPS v1.27],[Wind Shear],v_spellname=Wind Shear,b_t_interrupt=true,v_gcdspell=324,v_actionicon=Wind Shear,[Flametongue Weapon],b_p_nmh=true,v_spellname=Flametongue Weapon,v_gcdspell=324,b_rangecheck=false,v_p_nmh=Flametongue,v_actionicon=Flametongue Weapon,[Lightning Shield(buff)],b_p_needbuff=true,v_spellname=Lightning Shield,v_p_needbuff=_Lightning Shield,v_gcdspell=324,b_rangecheck=false,v_actionicon=Lightning Shield,[Flame Shock (Debuff Apply)],v_t_needsdebuff=_Flame Shock,v_spellname=Flame Shock,b_t_needsdebuff=true,v_gcdspell=324,v_actionicon=Flame Shock,[Lava Burst (UE)],b_t_hasdebuff=true,v_t_hasdebuff=_Flame Shock,v_spellname=Lava Burst,b_breakchanneling=true,v_gcdspell=324,b_p_havebuff=true,v_p_havebuff=Unleash Flame,v_actionicon=Lava Burst,[Unleash Elements],v_checkothercdvalue=<=5.5,v_spellname=Unleash Elements,v_checkothercdname=Lava Burst,b_breakchanneling=true,v_gcdspell=324,b_rangecheck=false,b_checkothercd=true,v_actionicon=Unleash Elements,[Elemental Mastery],b_toggleoff=true,v_spellname=Elemental Mastery,b_toggle=true,b_breakchanneling=true,v_toggleicon=16166,v_gcdspell=324,v_togglename=Toggle 2,b_rangecheck=false,v_actionicon=16166,[Lava Burst],b_t_hasdebuff=true,v_checkothercdvalue=>=1.5,v_t_hasdebuff=_Flame Shock,b_p_needbuff=true,v_spellname=Lava Burst,v_checkothercdname=Unleash Elements,b_breakchanneling=true,v_p_needbuff=Unleash Flame,v_gcdspell=324,b_checkothercd=true,v_actionicon=Lava Burst,[Earth Shock],v_spellname=Earth Shock,b_breakchanneling=true,v_gcdspell=324,b_p_havebuff=true,v_p_havebuff=Lightning Shield#7,v_actionicon=Earth Shock,[Chain Lightning],b_toggleoff=true,v_spellname=Chain Lightning,b_toggle=true,v_toggleicon=421,v_gcdspell=Tremor Totem,[Lightning Bolt],v_spellname=Lightning Bolt,v_gcdspell=Tremor Totem")
   end
   if (select(2, UnitClass("player")) == "WARLOCK") then
      --Check if player has the default rotations already stored in their db
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Destro v1.27],[Curse of the Elements],v_t_needsdebuff=Curse of the Elements,v_spellname=Curse of the Elements,b_t_needsdebuff=true,v_gcdspell=687,[Life Tap (moving)],v_p_unitpowertype=0,b_p_hp=true,b_duration=true,v_spellname=Life Tap,v_gcdspell=687,b_moving=true,v_p_unitpower=<10%,b_p_unitpower=true,b_rangecheck=false,v_p_hp=>=80%,v_duration=2,[Fel Flame (moving)],v_t_needsdebuff=_Immolate^1.5,v_spellname=Fel Flame,b_t_needsdebuff=true,b_moving=true,[Life Tap],v_p_unitpowertype=0,b_p_hp=true,b_duration=true,v_spellname=Life Tap,v_gcdspell=687,v_p_unitpower=<20%,b_p_unitpower=true,b_rangecheck=false,v_p_hp=>=80%,v_duration=2,[Fel Armor],b_p_needbuff=true,v_spellname=Fel Armor,v_p_needbuff=Fel Armor,v_gcdspell=687,b_rangecheck=false,[Soul Link],b_p_needbuff=true,v_spellname=Soul Link,v_p_needbuff=Soul Link,v_gcdspell=687,b_rangecheck=false,[Dark Intent],b_p_needbuff=true,v_spellname=Dark Intent,v_p_needbuff=Dark Intent,v_gcdspell=687,b_rangecheck=false,[Demon Soul],v_spellname=Demon Soul,b_rangecheck=false,[Soulburn],v_p_unitpowertype=7,b_p_needbuff=true,v_spellname=Soulburn,v_p_needbuff=Bloodlust|Time Warp|Improved Soul Fire,v_gcdspell=687,v_p_unitpower=>=1,b_p_unitpower=true,b_rangecheck=false,[Soul Fire (Soulburn or Emp Imp)],v_spellname=Soul Fire,b_breakchanneling=true,v_gcdspell=687,b_p_havebuff=true,v_p_havebuff=Empowered Imp|Soulburn,[Bane of Doom],v_t_needsdebuff=_Bane of Doom,v_spellname=Bane of Doom,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,[Fel Flame (Fel Spark)],v_t_needsdebuff=_Immolate^1.5,v_spellname=Fel Flame,b_t_needsdebuff=true,b_breakchanneling=true,b_p_havebuff=true,v_p_havebuff=Fel Spark,[Immolate],v_t_needsdebuff=_Immolate^3,b_maxcasts=true,v_spellname=Immolate,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,v_maxcasts=1,[Conflagrate],v_spellname=Conflagrate,b_breakchanneling=true,v_gcdspell=687,[Corruption],v_t_needsdebuff=_Corruption,v_spellname=Corruption,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,[Shadowflame],v_spellname=Shadowflame,b_breakchanneling=true,v_gcdspell=687,b_rangecheck=false,[Chaos Bolt],v_spellname=Chaos Bolt,b_breakchanneling=true,v_toggleicon=Chaos Bolt,v_gcdspell=687,v_actionicon=Chaos Bolt,[Soul Fire],b_p_needbuff=true,b_duration=true,v_spellname=Soul Fire,b_breakchanneling=true,v_p_needbuff=Improved Soul Fire^5,v_gcdspell=687,v_duration=3,[Shadowburn],v_spellname=Shadowburn,b_breakchanneling=true,v_gcdspell=687,[Shadow Bolt],v_t_needsdebuff=Shadow and Flame,b_duration=true,v_spellname=Shadow Bolt,b_t_needsdebuff=true,b_breakchanneling=true,v_duration=3,[Incinerate],b_t_hasdebuff=true,v_t_hasdebuff=_Immolate^3,v_spellname=Incinerate,v_gcdspell=687")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Affliction Drain v1.27],[Life Tap (Moving)],v_p_unitpowertype=0,b_p_hp=true,b_duration=true,v_spellname=Life Tap,v_gcdspell=687,b_moving=true,v_p_unitpower=<80%,b_p_unitpower=true,b_rangecheck=false,v_p_hp=>=80%,v_duration=2,[Fel Flame (Moving)],v_spellname=Fel Flame,b_moving=true,[Life Tap (<5%)],v_p_unitpowertype=0,b_p_hp=true,b_duration=true,v_spellname=Life Tap,v_gcdspell=687,v_p_unitpower=<5%,b_p_unitpower=true,b_rangecheck=false,v_p_hp=>=80%,v_duration=2,[Fel Armor],b_p_needbuff=true,v_spellname=Fel Armor,v_p_needbuff=Fel Armor,v_gcdspell=687,b_rangecheck=false,[Dark Intent],b_p_needbuff=true,v_spellname=Dark Intent,b_breakchanneling=true,v_p_needbuff=Dark Intent,v_gcdspell=687,b_rangecheck=false,[Corruption],v_t_needsdebuff=_Corruption,b_maxcasts=true,b_duration=true,v_spellname=Corruption,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,v_maxcasts=1,v_duration=1.5,[Unstable Affliction],v_t_needsdebuff=_Unstable Affliction^1.5,b_duration=true,v_spellname=Unstable Affliction,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,v_duration=1.5,[Bane of Agony],v_t_needsdebuff=_Bane of Agony,v_spellname=Bane of Agony,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,[Haunt],v_spellname=Haunt,b_breakchanneling=true,v_gcdspell=687,[Fel Flame (Fel Spark)],v_t_needsdebuff=_Unstable Affliction^8,v_spellname=Fel Flame,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,b_p_havebuff=true,v_p_havebuff=Fel Spark,[Shadowflame],v_spellname=Shadowflame,v_gcdspell=687,b_rangecheck=false,[Drain Soul],b_t_hp=true,v_spellname=Drain Soul,v_t_hp=<=25%,b_breakchanneling=true,v_gcdspell=687,[Soulburn],v_p_unitpowertype=7,b_p_needbuff=true,v_spellname=Soulburn,b_breakchanneling=true,v_p_needbuff=Bloodlust|Time Warp|Improved Soul Fire,v_gcdspell=687,v_p_unitpower=>=1,b_p_unitpower=true,b_rangecheck=false,[Soulfire (Soulburn)],v_spellname=Soul Fire,b_breakchanneling=true,v_gcdspell=687,b_p_havebuff=true,v_p_havebuff=Soulburn,[Demon Soul (ST)],v_spellname=Demon Soul,b_breakchanneling=true,v_gcdspell=687,b_p_havebuff=true,v_p_havebuff=Shadow Trance,b_rangecheck=false,[Shadow Bolt (ST)],v_spellname=Shadow Bolt,b_breakchanneling=true,v_gcdspell=687,b_p_havebuff=true,v_p_havebuff=Shadow Trance,[Drain Life],v_spellname=Drain Life,[Life Tap],b_p_hp=true,b_duration=true,v_spellname=Life Tap,b_breakchanneling=true,v_gcdspell=687,b_rangecheck=false,v_p_hp=>=80%,v_duration=2")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Affliction v1.27],[Life Tap (Moving)],v_p_unitpowertype=0,b_p_hp=true,b_duration=true,v_spellname=Life Tap,v_gcdspell=687,b_moving=true,v_p_unitpower=<80%,b_p_unitpower=true,b_rangecheck=false,v_p_hp=>=80%,v_duration=2,[Fel Flame (Moving)],v_spellname=Fel Flame,b_moving=true,[Life Tap (<5%)],v_p_unitpowertype=0,b_p_hp=true,b_duration=true,v_spellname=Life Tap,v_gcdspell=687,v_p_unitpower=<5%,b_p_unitpower=true,b_rangecheck=false,v_p_hp=>=80%,v_duration=2,[Fel Armor],b_p_needbuff=true,v_spellname=Fel Armor,v_p_needbuff=Fel Armor,v_gcdspell=687,b_rangecheck=false,[Dark Intent],b_p_needbuff=true,v_spellname=Dark Intent,b_breakchanneling=true,v_p_needbuff=Dark Intent,v_gcdspell=687,b_rangecheck=false,[Corruption],v_t_needsdebuff=_Corruption,b_maxcasts=true,b_duration=true,v_spellname=Corruption,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,v_maxcasts=1,v_duration=1.5,[Unstable Affliction],v_t_needsdebuff=_Unstable Affliction^1.5,b_duration=true,v_spellname=Unstable Affliction,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,v_duration=1.5,[Bane of Agony],v_t_needsdebuff=_Bane of Agony,v_spellname=Bane of Agony,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,[Haunt],v_spellname=Haunt,b_breakchanneling=true,v_gcdspell=687,[Fel Flame (Fel Spark)],v_t_needsdebuff=_Unstable Affliction^8,v_spellname=Fel Flame,b_t_needsdebuff=true,b_breakchanneling=true,v_gcdspell=687,b_p_havebuff=true,v_p_havebuff=Fel Spark,[Shadowflame],v_spellname=Shadowflame,v_gcdspell=687,b_rangecheck=false,[Drain Soul],b_t_hp=true,v_spellname=Drain Soul,v_t_hp=<=25%,b_breakchanneling=true,v_gcdspell=687,[Life Tap (<35%)],v_p_unitpowertype=0,b_p_hp=true,b_duration=true,v_spellname=Life Tap,v_gcdspell=687,v_p_unitpower=<35%,b_p_unitpower=true,b_rangecheck=false,v_p_hp=>=80%,v_duration=2,[Soulburn],v_p_unitpowertype=7,b_p_needbuff=true,v_spellname=Soulburn,b_breakchanneling=true,v_p_needbuff=Bloodlust|Time Warp|Improved Soul Fire,v_gcdspell=687,v_p_unitpower=>=1,b_p_unitpower=true,b_rangecheck=false,[Soulfire (Soulburn)],v_spellname=Soul Fire,b_breakchanneling=true,v_gcdspell=687,b_p_havebuff=true,v_p_havebuff=Soulburn,[Demon Soul],v_spellname=Demon Soul,b_breakchanneling=true,v_gcdspell=687,b_rangecheck=false,[Shadow Bolt],v_spellname=Shadow Bolt,b_breakchanneling=true,v_gcdspell=687,[Life Tap],b_p_hp=true,b_duration=true,v_spellname=Life Tap,b_breakchanneling=true,v_gcdspell=687,b_rangecheck=false,v_p_hp=>=80%,v_duration=2")
   end
   if (select(2, UnitClass("player")) == "WARRIOR") then --Checked Feb 09,2011
      --Check if player has the default rotations already stored in their db
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Arms v1.27],[Pummel],v_p_unitpowertype=1,v_t_interrupt=BWD: |Blast Nova|,v_spellname=Pummel,b_t_interrupt=true,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,[Deadly Calm],v_spellname=Deadly Calm,v_gcdspell=1715,b_rangecheck=false,[Sweeping Strikes],v_p_unitpowertype=1,b_disabled=true,v_spellname=Sweeping Strikes,v_rangespell=Strike,v_gcdspell=1715,v_p_unitpower=>=30,b_p_unitpower=true,v_togglename=Toggle 2,[Berserker Rage],v_spellname=Berserker Rage,v_gcdspell=1715,b_rangecheck=false,[Bladestorm],v_p_unitpowertype=1,b_p_needbuff=true,v_spellname=Bladestorm,v_rangespell=Strike,v_p_needbuff=Deadly Calm&Sweeping Strikes,v_gcdspell=1715,v_p_unitpower=>=25,b_p_unitpower=true,[Cleave],v_p_unitpowertype=1,b_disabled=true,v_spellname=Cleave,v_gcdspell=1715,v_p_unitpower=>=30,b_p_unitpower=true,[Heroic Strike (>65)],v_p_unitpowertype=1,v_spellname=Heroic Strike,v_gcdspell=1715,v_p_unitpower=>65,b_p_unitpower=true,[Heroic Strike (DC],v_p_unitpowertype=1,v_spellname=Heroic Strike,v_gcdspell=1715,b_p_havebuff=true,v_p_unitpower=>=30,b_p_unitpower=true,v_p_havebuff=Deadly Calm|Incite|Battle Trance,[Overpower (TfB)],b_p_needbuff=true,v_spellname=Overpower,v_p_needbuff=Taste for Blood^1.5,v_gcdspell=1715,[Rend],v_t_needsdebuff=_Rend,v_p_unitpowertype=1,v_spellname=Rend,b_t_needsdebuff=true,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,[Colossus Smash],b_p_needbuff=true,v_spellname=Colossus Smash,v_p_needbuff=Colossus Smash,v_gcdspell=1715,[Mortal Strike],v_spellname=Mortal Strike,v_gcdspell=1715,[Overpower (LttS)],v_p_unitpowertype=1,b_t_hp=true,b_p_needbuff=true,v_spellname=Overpower,v_t_hp=<20%,v_p_needbuff=Lambs to the Slaughter,v_gcdspell=1715,v_p_unitpower=>35,b_p_unitpower=true,[Execute],v_p_unitpowertype=1,v_spellname=Execute,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,[Overpower],v_p_unitpowertype=1,v_spellname=Overpower,v_gcdspell=1715,v_p_unitpower=>=5,b_p_unitpower=true,[Slam],v_p_unitpowertype=1,v_checkothercdvalue=>1.5,v_spellname=Slam,v_checkothercdname=Mortal Strike,v_gcdspell=1715,v_p_unitpower=>=15,b_p_unitpower=true,b_checkothercd=true,[Battle Shout],v_p_unitpowertype=1,v_spellname=Battle Shout,v_gunitpowertype=1,v_gunitpower=20,v_gcdspell=Revenge,v_p_unitpower=<25,b_p_unitpower=true,b_gunitpower=true")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Arms AE v1.27],[Pummel],v_p_unitpowertype=1,v_t_interrupt=BWD: |Blast Nova|,v_spellname=Pummel,b_t_interrupt=true,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,[Deadly Calm],v_spellname=Deadly Calm,v_gcdspell=1715,b_rangecheck=false,[Sweeping Strikes],v_p_unitpowertype=1,v_spellname=Sweeping Strikes,v_rangespell=Strike,v_gcdspell=1715,v_p_unitpower=>=30,b_p_unitpower=true,v_togglename=Toggle 2,[Berserker Rage],v_spellname=Berserker Rage,v_gcdspell=1715,b_rangecheck=false,[Bladestorm],v_p_unitpowertype=1,b_p_needbuff=true,v_spellname=Bladestorm,v_rangespell=Strike,v_p_needbuff=Deadly Calm&Sweeping Strikes,v_gcdspell=1715,v_p_unitpower=>=25,b_p_unitpower=true,[Cleave],v_p_unitpowertype=1,v_spellname=Cleave,v_gcdspell=1715,v_p_unitpower=>=30,b_p_unitpower=true,[Heroic Strike (>65)],v_p_unitpowertype=1,v_spellname=Heroic Strike,v_gcdspell=1715,v_p_unitpower=>65,b_p_unitpower=true,[Heroic Strike (DC],v_p_unitpowertype=1,v_spellname=Heroic Strike,v_gcdspell=1715,b_p_havebuff=true,v_p_unitpower=>=30,b_p_unitpower=true,v_p_havebuff=Deadly Calm|Incite|Battle Trance,[Overpower (TfB)],b_p_needbuff=true,v_spellname=Overpower,v_p_needbuff=Taste for Blood^1.5,v_gcdspell=1715,[Rend],v_t_needsdebuff=_Rend,v_p_unitpowertype=1,v_spellname=Rend,b_t_needsdebuff=true,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,[Colossus Smash],b_p_needbuff=true,v_spellname=Colossus Smash,v_p_needbuff=Colossus Smash,v_gcdspell=1715,[Mortal Strike],v_spellname=Mortal Strike,v_gcdspell=1715,[Overpower (LttS)],v_p_unitpowertype=1,b_t_hp=true,b_p_needbuff=true,v_spellname=Overpower,v_t_hp=<20%,v_p_needbuff=Lambs to the Slaughter,v_gcdspell=1715,v_p_unitpower=>35,b_p_unitpower=true,[Execute],v_p_unitpowertype=1,v_spellname=Execute,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,[Overpower],v_p_unitpowertype=1,v_spellname=Overpower,v_gcdspell=1715,v_p_unitpower=>=5,b_p_unitpower=true,[Slam],v_p_unitpowertype=1,v_checkothercdvalue=>1.5,v_spellname=Slam,v_checkothercdname=Mortal Strike,v_gcdspell=1715,v_p_unitpower=>=15,b_p_unitpower=true,b_checkothercd=true,[Battle Shout],v_p_unitpowertype=1,v_spellname=Battle Shout,v_gunitpowertype=1,v_gunitpower=20,v_gcdspell=Revenge,v_p_unitpower=<25,b_p_unitpower=true,b_rangecheck=false,b_gunitpower=true")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Fury AE v1.27],[Pummel],v_p_unitpowertype=1,v_t_interrupt=BD: |Blast Nova|,v_spellname=Pummel,b_t_interrupt=true,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,[Recklessness],v_spellname=Recklessness,v_gcdspell=1715,b_rangecheck=false,[Death Wish],v_p_unitpowertype=1,v_spellname=Death Wish,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,b_rangecheck=false,[Heroic Strike],v_p_unitpowertype=1,b_t_hp=true,v_spellname=Heroic Strike,v_t_hp=>20%,v_gcdspell=1715,b_p_havebuff=true,v_p_unitpower=>60,b_p_unitpower=true,v_p_havebuff=Battle Trance|Incite,[Cleave],v_p_unitpowertype=1,v_spellname=Cleave,v_gcdspell=1715,v_p_unitpower=>=30,b_p_unitpower=true,[Whirlwind],v_p_unitpowertype=1,v_spellname=Whirlwind,v_rangespell=Strike,v_gcdspell=1715,v_p_unitpower=>=25,b_p_unitpower=true,[Colossus Smash],v_p_unitpowertype=1,v_spellname=Colossus Smash,v_gcdspell=1715,v_p_unitpower=>=20,b_p_unitpower=true,[Inner Rage],b_t_hp=true,v_spellname=Inner Rage,v_t_hp=<20%,v_gcdspell=1715,b_rangecheck=false,[Execute],v_spellname=Execute,v_gcdspell=1715,b_p_havebuff=true,v_p_havebuff=Colossus Smash|Inner Rage,[Berserker Rage],v_p_unitpowertype=1,v_checkothercdvalue=<1,b_p_needbuff=true,v_spellname=Berserker Rage,v_checkothercdname=Raging Blow,v_p_needbuff=Death Wish&Enrage&Unholy Frenzy,v_gcdspell=1715,v_p_unitpower=>15,b_p_unitpower=true,b_rangecheck=false,b_checkothercd=true,[Raging Blow],v_p_unitpowertype=1,b_t_hp=true,v_spellname=Raging Blow,v_t_hp=>=20%,v_gcdspell=1715,v_p_unitpower=>=20,b_p_unitpower=true,[Bloodthirst],v_p_unitpowertype=1,v_spellname=Bloodthirst,v_gcdspell=1715,v_p_unitpower=>=20,b_p_unitpower=true,[Slam],v_spellname=Slam,v_gcdspell=1715,b_p_havebuff=true,v_p_havebuff=Bloodsurge,[Battle Shout],v_p_unitpowertype=1,v_spellname=Battle Shout,v_gunitpowertype=1,v_gunitpower=30,v_gcdspell=1715,v_p_unitpower=<60,b_p_unitpower=true,b_rangecheck=false,b_gunitpower=true")
      ROB_ImportRotation("RotationBuilder,v1.27,[4.0.6 Fury v1.27],[Pummel],v_p_unitpowertype=1,v_t_interrupt=BD: |Blast Nova|,v_spellname=Pummel,b_t_interrupt=true,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,[Recklessness],v_spellname=Recklessness,v_gcdspell=1715,b_rangecheck=false,[Death Wish],v_p_unitpowertype=1,v_spellname=Death Wish,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,b_rangecheck=false,[Heroic Strike],v_p_unitpowertype=1,b_t_hp=true,v_spellname=Heroic Strike,v_t_hp=>20%,v_gcdspell=1715,b_p_havebuff=true,v_p_unitpower=>60,b_p_unitpower=true,v_p_havebuff=Battle Trance|Incite,[Cleave],v_p_unitpowertype=1,b_disabled=true,v_spellname=Cleave,v_gcdspell=1715,v_p_unitpower=>=30,b_p_unitpower=true,[Whirlwind],v_p_unitpowertype=1,b_disabled=true,v_spellname=Whirlwind,v_rangespell=Strike,v_gcdspell=1715,v_p_unitpower=>=25,b_p_unitpower=true,[Colossus Smash],v_p_unitpowertype=1,v_spellname=Colossus Smash,v_gcdspell=1715,v_p_unitpower=>=20,b_p_unitpower=true,[Inner Rage],b_t_hp=true,v_spellname=Inner Rage,v_t_hp=<20%,v_gcdspell=1715,b_rangecheck=false,[Execute],v_spellname=Execute,v_gcdspell=1715,b_p_havebuff=true,v_p_havebuff=Colossus Smash|Inner Rage,[Berserker Rage],v_p_unitpowertype=1,v_checkothercdvalue=<1,b_p_needbuff=true,v_spellname=Berserker Rage,v_checkothercdname=Raging Blow,v_p_needbuff=Death Wish&Enrage&Unholy Frenzy,v_gcdspell=1715,v_p_unitpower=>15,b_p_unitpower=true,b_rangecheck=false,b_checkothercd=true,[Raging Blow],v_p_unitpowertype=1,b_t_hp=true,v_spellname=Raging Blow,v_t_hp=>=20%,v_gcdspell=1715,v_p_unitpower=>=20,b_p_unitpower=true,[Bloodthirst],v_p_unitpowertype=1,v_spellname=Bloodthirst,v_gcdspell=1715,v_p_unitpower=>=20,b_p_unitpower=true,[Slam],v_spellname=Slam,v_gcdspell=1715,b_p_havebuff=true,v_p_havebuff=Bloodsurge,[Battle Shout],v_p_unitpowertype=1,v_spellname=Battle Shout,v_gunitpowertype=1,v_gunitpower=30,v_gcdspell=1715,v_p_unitpower=<60,b_p_unitpower=true,b_rangecheck=false,b_gunitpower=true")
      ROB_ImportRotation("RotationBuilder,v1.28,[4.0.6 SMF v1.28],[Recklessness],v_spellname=Recklessness,v_gcdspell=1715,b_rangecheck=false,[Death Wish],v_p_unitpowertype=1,v_spellname=Death Wish,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,b_rangecheck=false,[Cleave],v_p_unitpowertype=1,b_disabled=true,v_spellname=Cleave,v_gcdspell=1715,v_p_unitpower=>=30,b_p_unitpower=true,[Whirlwind],v_p_unitpowertype=1,b_disabled=true,v_spellname=Whirlwind,v_rangespell=Strike,v_gcdspell=1715,v_p_unitpower=>=25,b_p_unitpower=true,[Heroic Strike (>85)],v_p_unitpowertype=1,b_t_hp=true,v_spellname=Heroic Strike,v_t_hp=>=20%,v_gcdspell=1715,v_p_unitpower=>85,b_p_unitpower=true,[Heroic Strike (BT)],v_p_unitpowertype=1,v_spellname=Heroic Strike,v_gcdspell=1715,b_p_havebuff=true,v_p_unitpower=>=30,b_p_unitpower=true,v_p_havebuff=Battle Trance,[Heroic Strike (Incite|CS)],v_p_unitpowertype=1,b_t_hp=true,v_spellname=Heroic Strike,v_t_hp=>=20%,v_gcdspell=1715,b_p_havebuff=true,v_p_unitpower=>=50,b_p_unitpower=true,v_p_havebuff=Incite|Colossus Smash,[Heroic Strike (>=75)],v_p_unitpowertype=1,b_t_hp=true,v_spellname=Heroic Strike,v_t_hp=<20%,v_gcdspell=1715,v_p_unitpower=>=75,b_p_unitpower=true,[Execute (Executioner<1.5)],v_p_unitpowertype=1,b_p_needbuff=true,v_spellname=Execute,v_p_needbuff=Executioner^1.5,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,[Colossus Smash],v_p_unitpowertype=1,v_spellname=Colossus Smash,v_gcdspell=1715,v_p_unitpower=>=20,b_p_unitpower=true,[Execute (Executioner<5)],v_p_unitpowertype=1,b_p_needbuff=true,v_spellname=Execute,v_p_needbuff=Executioner#5,v_gcdspell=1715,v_p_unitpower=>=10,b_p_unitpower=true,[Bloodthirst],v_p_unitpowertype=1,v_spellname=Bloodthirst,v_gcdspell=1715,v_p_unitpower=>=20,b_p_unitpower=true,[Slam],v_spellname=Slam,v_gcdspell=1715,b_p_havebuff=true,v_p_havebuff=Bloodsurge,[Execute],v_p_unitpowertype=1,v_spellname=Execute,v_gcdspell=1715,v_p_unitpower=>=50,b_p_unitpower=true,[Berserker Rage],v_p_unitpowertype=1,v_checkothercdvalue=<1,b_p_needbuff=true,v_spellname=Berserker Rage,v_checkothercdname=Raging Blow,v_p_needbuff=Death Wish&Enrage&Unholy Frenzy,v_gcdspell=1715,v_p_unitpower=>15,b_p_unitpower=true,b_rangecheck=false,b_checkothercd=true,[Raging Blow],v_p_unitpowertype=1,v_spellname=Raging Blow,v_gcdspell=1715,v_p_unitpower=>=20,b_p_unitpower=true,[Battle Shout],v_p_unitpowertype=1,v_spellname=Battle Shout,v_gunitpowertype=1,v_gunitpower=30,v_gcdspell=1715,v_p_unitpower=<70,b_p_unitpower=true,b_rangecheck=false,b_gunitpower=true")
   end

   
   -- update rotation list
   ROB_SortRotationList();
   
   -- update the action list
   ROB_ActionList_Update();
   
   -- update rotation modify buttons
   ROB_RotationModifyButtons_UpdateUI();
   
   -- update rotation ui stuff
   ROB_Rotation_Edit_UpdateUI();
end

------------------------------------------------------------------------
--  Menu functions
------------------------------------------------------------------------
local function ROB_SortMenu(item1, item2)
   return item1.id < item2.id
end

local function ROB_MenuChangeRotation(self,_arg1)
   ROB_SwitchRotation(_arg1,true)
end

local function ROB_MenuCreate(self, _level)
   local level = _level or 1
   local id = 1
   local info = {}
   ROB_MENU = {}
   
   for id=1, #ROB_SortedRotations, 1 do
      info = {}
      info.id = id
      info.text = ROB_SortedRotations[id]
      info.icon = nil
      info.arg1 = ROB_SortedRotations[id]
      info.func = ROB_MenuChangeRotation
      info.notCheckable = true
      ROB_MENU[id] = info
   end

   table.sort(ROB_MENU, ROB_SortMenu)
end         

local function ROB_MenuInit(self, _level)
   local level = _level or 1
   for _, value in pairs(ROB_MENU) do
      UIDropDownMenu_AddButton(value, level)
   end
end


function ROB_MenuOnClick(self, button)
   if button == "LeftButton" then
--print("LeftButton in menu")
      GameTooltip:Hide()
      if (not ROB_MENU_FRAME) then
--print("Creating Menu Frame")
         ROB_MENU_FRAME = CreateFrame("Frame", "ROB_Menu", UIParent, "UIDropDownMenuTemplate")
      end

      --if (not ROB_MENU_READY) then
--print("Initializing the menu")
         ROB_MenuCreate()
         UIDropDownMenu_Initialize(ROB_MENU_FRAME, ROB_MenuInit, "MENU")
      --   ROB_MENU_READY = true
      --end
      ToggleDropDownMenu(1, nil, ROB_MENU_FRAME, self, 20, 4)
   elseif button == "RightButton" then
      ROB_OnToggle();
   end
end

function ROB_LoadDataBrokerPlugin()
   LibStub:GetLibrary('LibDataBroker-1.1'):NewDataObject(ROB_ADDON_NAME, {
      type = 'launcher',
      text = ROB_ADDON_NAME,
      icon = 'Interface\\Icons\\Spell_Arcane_PortalOrgrimmar',
      OnClick = ROB_MenuOnClick,
      OnTooltipShow = function(tooltip)
         if not tooltip or not tooltip.AddLine then return end
         tooltip:AddLine(ROB_UI_TITLE)
         tooltip:AddLine(ROB_UI_LDB_TT1)
         tooltip:AddLine(ROB_UI_LDB_TT2)
      end,
   })
end

function ROB_OnLoad(self)
   -- hook events
   self:RegisterEvent("ADDON_LOADED");
   self:RegisterEvent("PLAYER_ENTERING_WORLD");

   self:RegisterEvent("UNIT_SPELLCAST_START")
   self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
   
   self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
   self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
   
   self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
   
   -- hook command handler
   SLASH_ROB1 = "/rob";

   SlashCmdList["ROB"] = ROB_OnCommand;

    -- create a dialog for list deletion
   StaticPopupDialogs["ROB_PROMPT_LIST_DELETE"] =
   {
      text                 = TEXT(ROB_PROMPT_LIST_DELETE),
      button1              = TEXT(YES),
      button2              = TEXT(CANCEL),
      OnAccept             =  function(self)
                              ROB_RotationDelete_OnAccept();
                           end,
      OnCancel             =  function(self)
                              ROB_RotationDelete_OnCancel();
                           end,
      timeout              = 0,
      exclusive            = 1,
      whileDead            = 1,
      hideOnEscape         = 1
   };

   if (LibStub and LibStub:GetLibrary('LibDataBroker-1.1', true)) then
      ROB_LoadDataBrokerPlugin()
   end
   
   print(string.format(ROB_LOADED, ROB_VERSION));
end

function ROB_SpellIsInRotation(_spellname)
   local _foundspell = false
   if (ROB_SelectedRotationName and ROB_Rotations[ROB_SelectedRotationName] ~= nil and ROB_Rotations[ROB_SelectedRotationName].SortedActions ~= nil) then
      for key, value in pairs(ROB_Rotations[ROB_SelectedRotationName].SortedActions) do
         if (_spellname == value) then
            return true
         end
         if (GetSpellInfo(value) and _spellname == GetSpellInfo(value)) then
            return true
         end
      end      
   end 
   return _foundspell
end

function ROB_OnEvent(self, event, ...)
   local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12 = ...;
   local _interruptFound = false
   local _spellname = nil
      
   if (event == "COMBAT_LOG_EVENT_UNFILTERED") then     
      --Keep track of the last casted spell by target so we can display what we interrupted
      if (bit.band(arg5, COMBATLOG_OBJECT_TARGET) == COMBATLOG_OBJECT_TARGET) then
         if (arg2 and (arg2 == "SPELL_CAST_SUCCESS" or arg2 == "SPELL_CAST_START")) then
            ROB_TARGET_LAST_CASTED = arg9
         end
         return
      end
     
      --Make sure we are the source
      if (bit.band(arg5, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= COMBATLOG_OBJECT_AFFILIATION_MINE) then
         --return if we are not the source
         return
      end
      
      --Check if the event was a SPELL_AURA_APPLIED or SPELL_INTERRUPT are only 2 types of interrupts
      if (arg2 and (arg2 ~= "SPELL_AURA_APPLIED" and arg2 ~= "SPELL_INTERRUPT")) then
         return
      end
      
      --If we cant compare spells to a rotation to get the interrupt then exit
      if (not ROB_SelectedRotationName) then
         return
      end
      
      --Check if the spell id matches the spellid of our interrupt spell
      for key, value in pairs(ROB_Rotations[ROB_SelectedRotationName].SortedActions) do
         _spellname = GetSpellInfo(ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_spellname)
         if (not _spellname) then
            _spellname = ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_spellname
         end        
         if (_spellname == GetSpellInfo(arg9) and ROB_Rotations[ROB_SelectedRotationName].ActionList[value].b_t_interrupt) then           
            if (not _interruptFound and ROB_TARGET_LAST_CASTED and GetSpellInfo(ROB_TARGET_LAST_CASTED)) then
               print(ROB_UI_DEBUG_PREFIX..string.format("%s |T%s:0:0|t", ROB_UI_INTERRUPTED_MSG, select(3, GetSpellInfo(ROB_TARGET_LAST_CASTED)))..GetSpellInfo(ROB_TARGET_LAST_CASTED))
               _interruptFound = true
               ROB_TARGET_LAST_CASTED = nil
            end
         end
      end      
   elseif (event == "ADDON_LOADED") then
      ROB_ADDON_Load(...);
   elseif (event == "PLAYER_ENTERING_WORLD") then
      ROB_PLAYER_Enter();
   elseif (event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START") then
      if (arg1 == "player") then
         --if we are editing a rotation then dont try to access rotation info
         --if (ROB_EditingRotationTable ~= nil) then return; end
         if (ROB_SpellIsInRotation(arg2)) then
            --if we update the count in the START event then dont update the count in the SUCCEEDED event
            if (event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START") then
               if (arg2 == ROB_LAST_CASTED) then
                  --increment the last casted count
                  ROB_LAST_CASTED_COUNT = ROB_LAST_CASTED_COUNT + 1
                  if (ROB_SpellIsInRotation(arg2)) then ROB_LAST_CASTED = arg2; end
               else
                  --start the count over
                  ROB_LAST_CASTED_COUNT = 1
                  if (ROB_SpellIsInRotation(arg2)) then ROB_LAST_CASTED = arg2; end
               end               
               --end
               if (event == "UNIT_SPELLCAST_START") then
                  ROB_LAST_CASTED_TYPE = "NORMAL"
               else
                  ROB_LAST_CASTED_TYPE = "CHANNEL"
               end
            end
            
            if (event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_CHANNEL_STOP") then          
               if (not ROB_LAST_CASTED_TYPE) then
                  if (arg2 == ROB_LAST_CASTED) then
                     --increment the last casted count
                     ROB_LAST_CASTED_COUNT = ROB_LAST_CASTED_COUNT + 1
                     if (ROB_SpellIsInRotation(arg2)) then ROB_LAST_CASTED = arg2; end
                  else
                     --start the count over
                     ROB_LAST_CASTED_COUNT = 1
                     if (ROB_SpellIsInRotation(arg2)) then ROB_LAST_CASTED = arg2; end
                  end
               else
                  --The last casted type was something besides nil but for spells that have a UNIT_SPELLCAST_START or UNIT_SPELLCAST_CHANNEL_START
                  --they get their count incremented in those events so dont do it here
               end             
               
               if (event == "UNIT_SPELLCAST_SUCCEEDED" and ROB_LAST_CASTED_TYPE and ROB_LAST_CASTED_TYPE == "CHANNEL") then
                  --If ROB_LAST_CASTED_TYPE was CHANNEL then dont update the last casted because blizzard fires a UNIT_SPELLCAST_SUCCEEDED while channel is still going
               else
                  ROB_LAST_CASTED_TYPE = nil
               end
            end
            
            -- Turn off the toggle if this toggleoff is enabled
            if (ROB_SelectedRotationName and ROB_Rotations[ROB_SelectedRotationName] ~= nil and ROB_Rotations[ROB_SelectedRotationName].SortedActions ~= nil) then
               for key, value in pairs(ROB_Rotations[ROB_SelectedRotationName].SortedActions) do
                  if (ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_spellname == ROB_LAST_CASTED and ROB_Rotations[ROB_SelectedRotationName].ActionList[value].b_toggle and ROB_Rotations[ROB_SelectedRotationName].ActionList[value].b_toggleoff) then           
                     _G["ROB_TOGGLE_"..string.sub(ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_togglename, 8)] = 0               
                  end
                  --Set the last casted for the duration checking
                  if (ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_spellname == arg2) then           
                     ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_durationstartedtime = GetTime()               
                  end
                  if (GetSpellInfo(ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_spellname) and GetSpellInfo(ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_spellname) == arg2) then           
                     ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_durationstartedtime = GetTime()               
                  end
               end
            end
         end
      end
   end
end


function ROB_ADDON_Load(addon)
   local key, value;

   if (addon ~= "RotationBuilder") then
      return;
   end

   -- Initialize
   for key, value in pairs(ROB_Options_Default) do
      if (ROB_Options[key] == nil) then
         ROB_Options[key] = value;
      end
   end
   
   --After loading the options check if we have loaded once before if not then load default rotations
   if (ROB_Options["loaddefault"]) then
      ROB_LoadDefaultRotations()
      ROB_Options["loaddefault"] = false
   else
      --Weve loaded once before do we have a last loaded rotation?
      if (ROB_Options["lastrotation"] and ROB_Options["lastrotation"] ~= "" and ROB_Options["lastrotation"] ~= nil) then
         ROB_SwitchRotation(ROB_Options["lastrotation"], true)
      end
   end
   
   -- Initialize frame
   ROB_FrameVersionFrameVersion:SetText(ROB_VERSION);

end

function ROB_PLAYER_Enter()

   if (ROB_Initialized == true) then
      return;
   end

   ROB_Initialized = true;

   -- Initialize options tab
   ROB_OptionsTabMiniMapButton:SetChecked(ROB_Options.MiniMap);

   ROB_OptionsTabMiniMapPosSlider:SetValue(ROB_Options.MiniMapPos);
   ROB_OptionsTabMiniMapPosSliderText:SetText(ROB_Options.MiniMapPos);

   ROB_OptionsTabMiniMapRadSlider:SetValue(ROB_Options.MiniMapRad);
   ROB_OptionsTabMiniMapRadSliderText:SetText(ROB_Options.MiniMapRad);
   
   if ROB_Options.LockIcons then
      ROB_IconsFrame:SetMovable(false);
      ROB_IconsFrame:EnableMouse(false);
      ROB_OptionsTabLockIconsButton:SetChecked(true);
   else
      ROB_IconsFrame:SetMovable(true);
      ROB_IconsFrame:EnableMouse(true);
      ROB_OptionsTabLockIconsButton:SetChecked(false);
   end
   
   ROB_SetNextActionLocation();
   
   if (ROB_Options.IconsX == 0 and ROB_Options.IconsY == 0) then
      ROB_IconsFrame:ClearAllPoints();
      ROB_IconsFrame:SetPoint("CENTER");      
      ROB_Options.IconsX = ROB_IconsFrame:GetLeft() * ROB_Options.IconScale
      ROB_Options.IconsY = ROB_IconsFrame:GetBottom() * ROB_Options.IconScale
   else
      ROB_IconsFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", ROB_Options.IconsX / ROB_IconsFrame:GetEffectiveScale(), ROB_Options.IconsY / ROB_IconsFrame:GetEffectiveScale())
   end
   ROB_Frame:SetScale(ROB_Options.UIScale)
   ROB_OptionsUIScaleValue:SetText(ROB_Options.UIScale)
   
   ROB_IconsFrame:SetScale(ROB_Options.IconScale)
   ROB_CurrentActionFrame:SetScale(ROB_Options.IconScale)
   ROB_NextActionFrame:SetScale(ROB_Options.IconScale)
   ROB_OptionsTabIconScaleSlider:SetValue(ROB_Options.IconScale);
   ROB_OptionsTabIconScaleSliderText:SetText(ROB_Options.IconScale);
   
   ROB_OptionsTabToggleIconsAlpha:SetText(ROB_Options.ToggleIconsA);
   ROB_RotationToggle1TextureFrame:SetAlpha(ROB_Options.ToggleIconsA);
   ROB_RotationToggle2TextureFrame:SetAlpha(ROB_Options.ToggleIconsA);
   ROB_RotationToggle3TextureFrame:SetAlpha(ROB_Options.ToggleIconsA);
   ROB_RotationToggle4TextureFrame:SetAlpha(ROB_Options.ToggleIconsA);
   
   ROB_OptionsTabCurrentIconAlpha:SetText(ROB_Options.CurrentIconA);
   ROB_CurrentActionFrame:SetAlpha(ROB_Options.CurrentIconA);

   ROB_OptionsTabNextIconAlpha:SetText(ROB_Options.NextIconA);
   ROB_NextActionFrame:SetAlpha(ROB_Options.NextIconA);

   
   ROB_RotationToggle1TextureFrame:SetScale(ROB_Options.IconScale);
   ROB_RotationToggle2TextureFrame:SetScale(ROB_Options.IconScale);
   ROB_RotationToggle3TextureFrame:SetScale(ROB_Options.IconScale);
   ROB_RotationToggle4TextureFrame:SetScale(ROB_Options.IconScale);
   
   
   ROB_OptionsTabAllowOverwriteButton:SetChecked(ROB_Options.AllowOverwrite);
   ROB_OptionsTabExportBindsButton:SetChecked(ROB_Options.ExportBinds);
   
   ROB_MiniMapButton_Update();
   
   -- update rotation list
   ROB_SortRotationList();
   
   -- update the action list
   ROB_ActionList_Update();
   
   -- update rotation modify buttons
   ROB_RotationModifyButtons_UpdateUI();
   
   -- update rotation ui stuff
   ROB_Rotation_Edit_UpdateUI();
   
end

function ROB_OnCommand(cmd)
   local help, helpIx, msg;

   if    (cmd == "") then
      help = true;
   elseif   (cmd == "help") then
      help = true;
   elseif   (cmd == "show") then
      ROB_OnToggle(self, true);
   elseif   (string.sub(cmd,1,2) == "r ") then
      ROB_SwitchRotation(string.sub(cmd,3), true);
   elseif   (cmd == "hide") then
      ROB_OnToggle(self, false);
   elseif   (cmd == "resetui") then
      ROB_Options_ResetUI_OnClick(self);
   else
      help = true;
   end

   if (help == true) then
      print("Rotation Builder commands:")
      print(" help - display this help")
      print(" show - show Rotation Builder")
      print(" r ShadowMelt - Selects the ShadowMelt rotation")
      print(" hide - hide Rotation Builder")
      print(" resetui - reset Rotation Builder window positions")
   end
end

function ROB_OnToggle(self, visible)
   _G["ROB_RotationKeyBindButton"]:EnableKeyboard(false) 
   _G["ROB_AO_ActionKeyBindButton"]:EnableKeyboard(false) 
   _G["ROB_SpellNameInputBox"]:SetFocus()
   _G["ROB_SpellNameInputBox"]:ClearFocus()
   
   if    ((visible == false) or ((visible == nil) and ROB_Frame:IsVisible())) then
      PlaySound("igMiniMapClose");
      ROB_Frame:Hide();
      
   elseif   ((visible == true) or ((visible == nil) and not ROB_Frame:IsVisible())) then
      PlaySound("igMiniMapOpen");
      ROB_Frame:Show();
      ROB_RotationTab:Show()
      ROB_MainWindowSwitchToTab(ROB_FrameTab1)
      ROB_OptionsTab:Hide()
   end
end

function ROB_MainWindowSwitchToTab(self)
   ROB_RotationTab:Hide()
   ROB_OptionsTab:Hide()
   
   ROB_FrameTab1:UnlockHighlight()
   ROB_FrameTab2:UnlockHighlight()

   self:LockHighlight()

   if (self:GetName() == "ROB_FrameTab1") then ROB_RotationTab:Show(); end
   if (self:GetName() == "ROB_FrameTab2") then ROB_OptionsTab:Show(); end
end

function ROB_ActionOptionsSwitchToTab(self)
   ROB_GeneralActionOptionsTab:Hide()
   ROB_PlayerActionOptionsTab:Hide()
   ROB_TargetActionOptionsTab:Hide()
   ROB_PetActionOptionsTab:Hide()
   ROB_FocusActionOptionsTab:Hide()
   
   ROB_RotationTabTab1:UnlockHighlight()
   ROB_RotationTabTab2:UnlockHighlight()
   ROB_RotationTabTab3:UnlockHighlight()
   ROB_RotationTabTab4:UnlockHighlight()
   ROB_RotationTabTab5:UnlockHighlight()

   self:LockHighlight()
 
   if (self:GetName() == "ROB_RotationTabTab1") then ROB_GeneralActionOptionsTab:Show(); end
   if (self:GetName() == "ROB_RotationTabTab2") then ROB_PlayerActionOptionsTab:Show(); end
   if (self:GetName() == "ROB_RotationTabTab3") then ROB_TargetActionOptionsTab:Show(); end
   if (self:GetName() == "ROB_RotationTabTab4") then ROB_PetActionOptionsTab:Show(); end
   if (self:GetName() == "ROB_RotationTabTab5") then ROB_FocusActionOptionsTab:Show(); end
end

function ROB_Close_OnClick(self)
   ROB_OnToggle(self, false);
end

function ROB_RotationListButton_OnClick(self)
   -- ignore if we are editing
   if (ROB_EditingRotationTable ~= nil) then
      return;
   end

   ROB_SelectedRotationIndex = self:GetID() + FauxScrollFrame_GetOffset(ROB_RotationScrollFrame);
   ROB_SelectedRotationName = ROB_SortedRotations[ROB_SelectedRotationIndex]
   ROB_SwitchRotation(ROB_SelectedRotationName, true)
   
   -- update rotation list
   ROB_SortRotationList();
   
   -- update the action list
   ROB_ActionList_Update();
   
   -- update rotation modify buttons
   ROB_RotationModifyButtons_UpdateUI();
   
   -- update rotation ui stuff
   ROB_Rotation_Edit_UpdateUI();
end

function ROB_SwitchRotation(RotationID,_byName)
   local _MatchingRotationName = nil

   --if we are modififying a rotation dont switch to a different one
   if (ROB_EditingRotationTable ~= nil) then
      --print("Cant switch rotations while you are editing one")
      
      --just force a save and switch the rotation
      ROB_Save_OnClick(self) 
   end
   
   
   if (_byName) then
      ROB_SelectedRotationName = RotationID
   else
      for _RotationName,_value in pairs(ROB_Rotations) do
         if (not ROB_Rotations[_RotationName].bindindex) then
            ROB_Rotations[_RotationName]["bindindex"] = 0
         else
            --this rotation has a bind index so check if it matches the one we pressed
            if (ROB_Rotations[_RotationName].bindindex == RotationID) then
               _MatchingRotationName = _RotationName
               break
            end
         end
      end
      if (_MatchingRotationName == nil) then
         print(ROB_UI_DEBUG_PREFIX..ROB_UI_ROTATION_E1)
         return;
      end
      ROB_SelectedRotationName = _MatchingRotationName
   end
   
   if (ROB_Rotations[ROB_SelectedRotationName] ~= nil and ROB_Rotations[ROB_SelectedRotationName].SortedActions ~= nil) then
      for key, value in pairs(ROB_Rotations[ROB_SelectedRotationName].SortedActions) do
         if (ROB_Rotations[ROB_SelectedRotationName].ActionList[value].b_toggle and ROB_Rotations[ROB_SelectedRotationName].ActionList[value].b_toggleon) then
            _G["ROB_TOGGLE_"..string.sub(ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_togglename, 8)] = 1
         end
         --reset the last casted time for spells that wait specified durations
         ROB_Rotations[ROB_SelectedRotationName].ActionList[value].v_durationstartedtime = 0
      end


      print("Rotation switched to -----["..ROB_SelectedRotationName.."]-----")
      
      ROB_CURRENT_ACTION = nil
      ROB_NEXT_ACTION = nil
      ROB_CurrentActionTexture:SetTexture(GetTexturePath(""))
      ROB_CurrentActionFrame_Cooldown:SetCooldown(GetTime(), 0)
      ROB_CurrentActionLabel:SetText("")
      ROB_CurrentActionFrame:Show()
      ROB_NextActionTexture:SetTexture(GetTexturePath(""))
      ROB_NextActionFrame_Cooldown:SetCooldown(GetTime(), 0)
      ROB_NextActionLabel:SetText("")
      ROB_NextActionFrame:Show()
      ROB_RotationToggle1Texture:Hide()
      ROB_RotationToggle2Texture:Hide()
      ROB_RotationToggle3Texture:Hide()
      ROB_RotationToggle4Texture:Hide()
      ROB_RotationToggle1Texture:SetTexture("")
      ROB_RotationToggle2Texture:SetTexture("")
      ROB_RotationToggle3Texture:SetTexture("")
      ROB_RotationToggle4Texture:SetTexture("")
      
      ROB_Options["lastrotation"] = ROB_SelectedRotationName
   else
      print(ROB_UI_DEBUG_PREFIX..RotationID.." "..ROB_UI_ROTATION_E2)
   end
   
   ROB_RotationModifyButtons_UpdateUI()
   -- update rotation list
   ROB_SortRotationList();
   -- update the action list
   ROB_ActionList_Update();
   -- update rotation ui stuff
   ROB_Rotation_Edit_UpdateUI();
end

function ROB_RotationCreateButton_OnClick(self)
   -- start a new empty list
   ROB_EditingRotationTable = ROB_NewRotation();
   
   -- new name prompt
   ROB_SelectedRotationName = "<rotation name>";

   -- UPDATE_ROTATION_OPTIONS1
   ROB_RotationNameInputBox:SetText(ROB_SelectedRotationName);
   ROB_RotationKeyBindButton:SetText(ROB_EditingRotationTable.keybind);

   -- update the action list
   ROB_ActionList_Update();
   
   -- update rotation modify buttons
   ROB_RotationModifyButtons_UpdateUI();
   
   -- update rotation ui stuff
   ROB_Rotation_Edit_UpdateUI();

   -- set focus to name and highlight current text
   ROB_RotationNameInputBox:SetFocus(true);
   ROB_RotationNameInputBox:HighlightText();

end

function ROB_ModifyRotationButton_OnClick(self)
   -- copy the selected list
   ROB_EditingRotationTable = ROB_CopyTable(ROB_Rotations[ROB_SortedRotations[ROB_SelectedRotationIndex]]);

   -- copy name
   ROB_SelectedRotationName = ROB_SortedRotations[ROB_SelectedRotationIndex];

   -- UPDATE_ROTATION_OPTIONS2
   ROB_RotationNameInputBox:SetText(ROB_SelectedRotationName);

   ROB_RotationKeyBindButton:SetText(ROB_EditingRotationTable.keybind);
   
   --Always clear the current action because it may be leftover from a previous rotation
   ROB_CurrentActionName = nil
   
   -- update the action list
   ROB_ActionList_Update();
   
   -- update rotation modify buttons
   ROB_RotationModifyButtons_UpdateUI();
   
   -- update rotation ui stuff
   ROB_Rotation_Edit_UpdateUI();
   
end

function ROB_RotationListDeleteButton_OnClick(self)
   StaticPopup_Show("ROB_PROMPT_LIST_DELETE");
end

function ROB_RotationDelete_OnAccept()
   ROB_Rotations[ROB_SortedRotations[ROB_SelectedRotationIndex]] = nil;
   
   ROB_SelectedRotationIndex = nil;
   ROB_SelectedRotationName = nil;
   
   -- update rotation list
   ROB_SortRotationList();
   
   -- update the action list
   ROB_ActionList_Update();
   
   -- update rotation modify buttons
   ROB_RotationModifyButtons_UpdateUI();
   
   -- update rotation ui stuff
   ROB_Rotation_Edit_UpdateUI();
   
   -- recreate the menu
   ROB_MenuCreate()
end

function ROB_RotationDelete_OnCancel()
end

function ROB_RotationNameInputBox_OnTextChanged(self)
   local _text = self:GetText()
   
   if (string.find(_text, "%[") or string.find(_text, "%]") or string.find(_text, ",")) then
      print(ROB_UI_ADD_ROTATION_CFAIL)
      return
   end
      
   ROB_SelectedRotationName = ROB_RotationNameInputBox:GetText();

   ROB_Rotation_Edit_UpdateUI();
   if (ROB_EditingRotationTable == nil) then
      return
   end
end

function ROB_Save_OnClick(self)
   local _lastEditedRotation = ROB_SelectedRotationName
   ROB_Rotations[ROB_SelectedRotationName] = ROB_EditingRotationTable;
   -- update rotation list
   ROB_SortRotationList();

   -- and discard to reset editing   
   ROB_Discard_OnClick(self);
   
   ROB_SwitchRotation(_lastEditedRotation, true)
end

function ROB_Discard_OnClick(self)
   -- smoke the edit list and edit name
   ROB_EditingRotationTable = nil;
   
   ROB_SelectedActionIndex = nil;
   ROB_SelectedRotationName = nil;
   
   table.wipe(ROB_DropDownTableTemp)
   ROB_DropDownStoreToTemp = nil;
   
   -- update lists edit
   ROB_ActionList_Update();
   
   -- update rotation modify buttons
   ROB_RotationModifyButtons_UpdateUI();
   
   -- update rotation ui stuff
   ROB_Rotation_Edit_UpdateUI();
end

function ROB_ActionListButton_OnClick(self, button)
   if (ROB_EditingRotationTable == nil) then
      return
   end

   ROB_SelectedActionIndex = self:GetID() + FauxScrollFrame_GetOffset(ROB_ActionListScrollFrame);  
   ROB_CurrentActionName = ROB_EditingRotationTable["SortedActions"][ROB_SelectedActionIndex]

   -- update the action list
   ROB_ActionList_Update();

   -- update the ui stuff
   ROB_Rotation_Edit_UpdateUI();
end

function ROB_ActionListButton_OnLeave(self)
   -- hide tooltips
   GameTooltip:Hide();
   ROB_Tooltip:Hide();
end

function ROB_ActionListTrash_OnClick(self)
   local ActionID;
  
   if (ROB_EditingRotationTable == nil) then
      return;
   end
   
   -- calculate selected item
   ActionID = self:GetParent():GetID() + FauxScrollFrame_GetOffset(ROB_ActionListScrollFrame);
   
   -- first, kill the list's item selectedrotation
   ROB_EditingRotationTable.ActionList[ROB_EditingRotationTable["SortedActions"][ActionID]] = nil;
   
   -- and remove from the sort
   table.remove(ROB_EditingRotationTable.SortedActions, ActionID);

   ROB_SelectedActionIndex = nil
   ROB_CurrentActionName = nil
   
   -- update the action list
   ROB_ActionList_Update();
   
   -- update rotation ui stuff
   ROB_Rotation_Edit_UpdateUI();
   
end

-- Lists Edit Item Move Up handler
function ROB_Lists_Edit_MoveUp(self)
   local itemID;
   
   -- cannot move above first row
   if (ROB_SelectedActionIndex > 1) then
      -- swap the item order in the edit list
      itemID = ROB_EditingRotationTable["SortedActions"][ROB_SelectedActionIndex];
      ROB_EditingRotationTable["SortedActions"][ROB_SelectedActionIndex] = ROB_EditingRotationTable["SortedActions"][ROB_SelectedActionIndex - 1];
      ROB_EditingRotationTable["SortedActions"][ROB_SelectedActionIndex - 1] = itemID;
      
      -- decrement selected item
      ROB_SelectedActionIndex = ROB_SelectedActionIndex - 1;

      -- update ui stuff
      ROB_ActionList_Update();
      ROB_Rotation_Edit_UpdateUI();
   end
end

-- Lists Edit Item Move Down handler
function ROB_Lists_Edit_MoveDown(self)
   local itemID;
   
   -- cannot move below last row
   if (ROB_SelectedActionIndex < #ROB_EditingRotationTable.SortedActions) then
      -- swap the item order in the edit list
      itemID = ROB_EditingRotationTable["SortedActions"][ROB_SelectedActionIndex];
      ROB_EditingRotationTable["SortedActions"][ROB_SelectedActionIndex] = ROB_EditingRotationTable["SortedActions"][ROB_SelectedActionIndex + 1];
      ROB_EditingRotationTable["SortedActions"][ROB_SelectedActionIndex + 1] = itemID;
      
      -- increment selected item
      ROB_SelectedActionIndex = ROB_SelectedActionIndex + 1;

      -- update ui stuff
      ROB_ActionList_Update();
      ROB_Rotation_Edit_UpdateUI();
   end
end

function ROB_PasteActionOnAccept(_text)
   local NewActionAlreadyExists = false
   if (_text == nil or _text == "" or ROB_EditingRotationTable == nil) then
      return
   end
   
   if (string.find(_text, "%[") or string.find(_text, "%]") or string.find(_text, ",") or string.find(_text, "=")) then
      print(ROB_UI_ADD_ACTION_CFAIL)
   end

   for key, value in pairs(ROB_EditingRotationTable.SortedActions) do
      --we found our new action ID so we cant use it because it already exists
      if (value == _text) then
         --we found our new action ID so we cant use it
         print("Action name already exists, try a different name")
         NewActionAlreadyExists = true
         return
      end
   end

   if (NewActionAlreadyExists == false and ROB_ActionClipboard ~= nil) then
      ROB_AddAction((#ROB_EditingRotationTable.SortedActions + 1), _text);  
      for key, value in pairs(ROB_ActionClipboard) do
         ROB_EditingRotationTable.ActionList[_text][key] = value
      end
      ROB_SelectedActionIndex = (#ROB_EditingRotationTable.SortedActions)
      ROB_CurrentActionName = _text     
      local scrollOffset = #ROB_EditingRotationTable.SortedActions
      if (scrollOffset > ROB_ACTION_LIST_LINES) then
         scrollOffset = (#ROB_EditingRotationTable.SortedActions - ROB_ACTION_LIST_LINES) * ROB_ACTION_LIST_FRAME_HEIGHT      
      else
         scrollOffset = 1
      end
      FauxScrollFrame_OnVerticalScroll(ROB_ActionListScrollFrame, scrollOffset, ROB_ACTION_LIST_FRAME_HEIGHT, ROB_ActionList_Update);      
      ROB_ActionList_Update();
      ROB_Rotation_Edit_UpdateUI();
   end
end

function ROB_AddActionOnAccept(_text)
   local NewActionAlreadyExists = false
   if (_text == nil or _text == "" or ROB_EditingRotationTable == nil) then
      return
   end

   for key, value in pairs(ROB_EditingRotationTable.SortedActions) do
      --we found our new action ID so we cant use it because it already exists
      if (value == _text) then
         --we found our new action ID so we cant use it
         print("Action name already exists")
         NewActionAlreadyExists = true
         return
      end
   end

   if (NewActionAlreadyExists == false) then
      ROB_CurrentActionName = _text
      ROB_SelectedActionIndex = (#ROB_EditingRotationTable.SortedActions + 1)
      ROB_AddAction(ROB_SelectedActionIndex, _text);
      -- update the action list
      ROB_ActionList_Update();  
      -- update the ui stuff
      ROB_Rotation_Edit_UpdateUI();
   end
end

function ROB_AddActionButton_OnClick(self)
   ROB_GetString("Enter new name for action", "", true, ROB_AddActionOnAccept, _cancelcallback)
end

function ROB_CopyActionButton_OnClick(self)
   local selectedrotation = ROB_GetSelectedRotation()
   if ((ROB_SelectedActionIndex ~= nil) and selectedrotation ~= nil) then
      ROB_ActionClipboard = selectedrotation.ActionList[selectedrotation.SortedActions[ROB_SelectedActionIndex]]
      print(selectedrotation.SortedActions[ROB_SelectedActionIndex].." copied to clipboard")     
   end
end

function ROB_PasteActionButton_OnClick(self)
   ROB_GetString("Enter new name for action", "", true, ROB_PasteActionOnAccept, _cancelcallback)
end


function GetTexturePath(v_spellname)
   local texpath;
   if not v_spellname then return ""; end
   texpath = select(3, GetSpellInfo(v_spellname));
   
   if not texpath then texpath = "" end
   return texpath;
end



function ROB_IconsFrameOnMouseDown(self, button)
   if (button == "LeftButton" and (not self.isMoving) and (ROB_Options.LockIcons == false)) then
      self:StartMoving();
      self.isMoving = true;
   end
end

function ROB_IconsFrameOnMouseUp(self, button)
   if (button == "LeftButton" and (self.isMoving) and (ROB_Options.LockIcons == false)) then
      self:StopMovingOrSizing();
      self.isMoving = false;

      ROB_Options.IconsX = self:GetLeft() * self:GetEffectiveScale()
      ROB_Options.IconsY = self:GetBottom() * self:GetEffectiveScale()
   end
end

function ROB_SpellValidate(_spell)
   local _spellingCheckPassed = false
   local _parsedSpellID = nil
   local _link = nil

   --Get the spell id
   if (GetSpellLink(_spell)) then
      _parsedSpellID = string.sub(GetSpellLink(_spell),string.find(GetSpellLink(_spell), ":")+1)
      _parsedSpellID = string.sub(_parsedSpellID,1,   string.find(_parsedSpellID, "\124")-1)
      _link = GetSpellLink(_spell)
   else
      --Is it a inventory slot?
      if (_InvSlots[_spell] and GetInventoryItemID("player",_InvSlots[_spell])) then
         _parsedSpellID = GetInventoryItemID("player",_InvSlots[_spell])
         _link = GetInventoryItemLink("player",_InvSlots[_spell])
         --if it found the itemid from the inventory slot then it must have been spelled correctly
         _spellingCheckPassed = true
      end      
   end
   
   if (not (_spell == _parsedSpellID)) then
      --The spell is string so check spelling
     if (GetSpellInfo(_spell) == _spell) then _spellingCheckPassed = true; end     
   else
      --The spell does not match the spell name check if the spell id matches the spelllink idwhat is it?
      if (GetSpellLink(_spell) and _spell == _parsedSpellID) then
         _spellingCheckPassed = true
      end
   end
   
   if (_parsedSpellID and _spellingCheckPassed) then
      ROB_SpellNameInputBoxIcon:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")       
      ROB_SpellNameValidateText:SetText(_link.." ".._parsedSpellID)
      GameTooltip:SetHyperlink(_link)
   else   
      ROB_SpellNameInputBoxIcon:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
      ROB_SpellNameValidateText:SetText(ROB_UI_AO_G_SID_VFAIL)
   end
end

function ROB_OptionsTabToggleIconsAlpha_OnTextChanged(self)
   if (self:GetText() == nil) then
      return
   end
   if (tonumber(self:GetText()) and tonumber(self:GetText()) >= 0.1 and tonumber(self:GetText()) <= 1) then
      ROB_Options.ToggleIconsA = tonumber(self:GetText())
      ROB_RotationToggle1TextureFrame:SetAlpha(ROB_Options.ToggleIconsA);
      ROB_RotationToggle2TextureFrame:SetAlpha(ROB_Options.ToggleIconsA);
      ROB_RotationToggle3TextureFrame:SetAlpha(ROB_Options.ToggleIconsA);
      ROB_RotationToggle4TextureFrame:SetAlpha(ROB_Options.ToggleIconsA);
   end
end

function ROB_OptionsTabCurrentIconAlpha_OnTextChanged(self)
   if (self:GetText() == nil) then
      return
   end
   if (tonumber(self:GetText()) and tonumber(self:GetText()) >= 0.1 and tonumber(self:GetText()) <= 1) then
      ROB_Options.CurrentIconA = tonumber(self:GetText())
      ROB_CurrentActionFrame:SetAlpha(ROB_Options.CurrentIconA);
   end
end

function ROB_OptionsTabNextIconAlpha_OnTextChanged(self)
   if (self:GetText() == nil) then
      return
   end
   if (tonumber(self:GetText()) and tonumber(self:GetText()) >= 0.1 and tonumber(self:GetText()) <= 1) then
      ROB_Options.NextIconA = tonumber(self:GetText())
      ROB_NextActionFrame:SetAlpha(ROB_Options.NextIconA);
   end
end

-- ADD_OPTION_FUNCTIONS_BELOW_THIS

function ROB_AO_CheckButton_OnToggle(self,field)
   if (ROB_CurrentActionName and field) then
      ROB_EditingRotationTable.ActionList[ROB_CurrentActionName][field] = (self:GetChecked() ~= nil);
   end
end

function ROB_AO_InputBox_OnTextChanged(self,field,validate)
   local _inputstring = nil
   if (self:GetText() == nil or ROB_CurrentActionName == nil or ROB_EditingRotationTable == nil) then
      return
   else
      _inputstring = self:GetText()

      ROB_EditingRotationTable.ActionList[ROB_CurrentActionName][field] = _inputstring
      if (validate) then ROB_SpellValidate(_inputstring); end
   end
end

function ROB_AO_ToggleOffCheckButton_OnToggle(self)
   ROB_EditingRotationTable.ActionList[ROB_CurrentActionName].b_toggleoff = (self:GetChecked() ~= nil);
end

function ROB_AO_ToggleIconInputBox_OnTextChanged(self)
   if (self:GetText() == nil or ROB_CurrentActionName == nil or ROB_EditingRotationTable == nil) then
      return
   else
      ROB_EditingRotationTable.ActionList[ROB_CurrentActionName].v_toggleicon = self:GetText()
      ROB_AO_ToggleIconTexture:SetTexture(GetTexturePath(ROB_EditingRotationTable.ActionList[ROB_CurrentActionName].v_toggleicon))
   end
end

function ROB_AO_ActionIcon_OnTextChanged(self)
   if (self:GetText() == nil or ROB_CurrentActionName == nil or ROB_EditingRotationTable == nil) then
      return
   else
      ROB_EditingRotationTable.ActionList[ROB_CurrentActionName].v_actionicon = self:GetText()
      ROB_AO_ActionIconTexture:SetTexture(GetTexturePath(ROB_EditingRotationTable.ActionList[ROB_CurrentActionName].v_actionicon))
   end
end

function ROB_GetString(_prompt, _defaultvalue, _cancelable, _okcallback, _cancelcallback)
    ROB_StringDialog_PromptText:SetText(_prompt)
    ROB_StringDialog_TextBox:SetText("") -- Causes the insertion point to move to the end on the next SetText
    ROB_StringDialog_TextBox:SetText(_defaultvalue)
    if _cancelable then
        ROB_StringDialog_OKButton:Show()
        ROB_StringDialog_OKButton:SetText(ROB_UI_OK_BUTTON)
        ROB_StringDialog_CancelButton:SetText(ROB_UI_CANCEL_BUTTON)
    else
        ROB_StringDialog_OKButton:Hide()
        ROB_StringDialog_CancelButton:SetText(ROB_UI_CLOSE_BUTTON)
    end
    ROB_StringDialog.OKCallbackFunction = _okcallback
    ROB_StringDialog.CancelCallbackFunction = _cancelcallback
    ROB_StringDialog:Show()
    ROB_StringDialog_TextBox:SetFocus()
end

function ROB_StringDialog_OKButton_OnClick()
   ROB_StringDialog:Hide()
   if ROB_StringDialog.OKCallbackFunction then ROB_StringDialog.OKCallbackFunction(ROB_StringDialog_TextBox:GetText()) end
end

function ROB_StringDialog_CancelButton_OnClick()
   ROB_StringDialog:Hide()
   if ROB_StringDialog.CancelCallbackFunction then ROB_StringDialog.CancelCallbackFunction() end
end

function ROB_StringDialog_TextBox_OnTextChanged()
   if ROB_StringDialog_TextBox:GetText() ~= "" then
      ROB_StringDialog_OKButton:Enable()
   else
      ROB_StringDialog_OKButton:Disable()
   end
end

function ROB_ActionOptionDropDown_Selected(self)
   if (ROB_EditingRotationTable ~= nil and ROB_CurrentActionName ~= nil and ROB_DropDownStoreToTemp ~= nil) then
      ROB_EditingRotationTable.ActionList[ROB_CurrentActionName][ROB_DropDownStoreToTemp] = self.value        
      UIDropDownMenu_SetSelectedValue(ROB_AO_ToggleDropDownButton, ROB_EditingRotationTable.ActionList[ROB_CurrentActionName][ROB_DropDownStoreToTemp]);
   end
end

function ROB_AO_ToggleDropDownButton_OnLoad(frame)
   local ToggleName = ""
   UIDropDownMenu_SetWidth(frame, 75)
   UIDropDownMenu_JustifyText(frame, "LEFT");
         
   ROB_DropDownStoreToTemp = "v_togglename"
   
   local i=0
   for i=1, 4 do
      table.wipe(ROB_DropDownTableTemp)
      ToggleName = "Toggle "..i;
      
      ROB_DropDownTableTemp.text  = ToggleName
      ROB_DropDownTableTemp.value = ToggleName
      ROB_DropDownTableTemp.func  = ROB_ActionOptionDropDown_Selected     
      UIDropDownMenu_AddButton(ROB_DropDownTableTemp);
   end
end

function ROB_SetNextActionLocation()
   ROB_NextActionFrame:ClearAllPoints();
   ROB_RotationToggle1TextureFrame:ClearAllPoints();
   ROB_RotationToggle2TextureFrame:ClearAllPoints();
   ROB_RotationToggle3TextureFrame:ClearAllPoints();
   ROB_RotationToggle4TextureFrame:ClearAllPoints();

   UIDropDownMenu_SetSelectedValue(ROB_OptionsNextActionLocationDropDownButton, ROB_Options.NextIconLocation)
   UIDropDownMenu_SetText(ROB_OptionsNextActionLocationDropDownButton, ROB_Options.NextIconLocation)

   
   if (ROB_Options.NextIconLocation == "BOTTOM" or ROB_Options.NextIconLocation == "TOP") then
      if (ROB_Options.NextIconLocation == "BOTTOM") then ROB_NextActionFrame:SetPoint("TOP","ROB_CurrentActionFrame","BOTTOM"); end
      if (ROB_Options.NextIconLocation == "TOP") then ROB_NextActionFrame:SetPoint("BOTTOM","ROB_CurrentActionFrame","TOP"); end
      ROB_RotationToggle1TextureFrame:SetPoint("TOPRIGHT","ROB_CurrentActionFrame","TOPLEFT")
      ROB_RotationToggle2TextureFrame:SetPoint("TOPLEFT","ROB_CurrentActionFrame","TOPRIGHT")
      ROB_RotationToggle3TextureFrame:SetPoint("BOTTOMRIGHT","ROB_CurrentActionFrame", "BOTTOMLEFT")
      ROB_RotationToggle4TextureFrame:SetPoint("BOTTOMLEFT","ROB_CurrentActionFrame", "BOTTOMRIGHT")
   end
   
   if (ROB_Options.NextIconLocation == "RIGHT" or ROB_Options.NextIconLocation == "LEFT") then
      if (ROB_Options.NextIconLocation == "RIGHT") then ROB_NextActionFrame:SetPoint("LEFT","ROB_CurrentActionFrame","RIGHT"); end
      if (ROB_Options.NextIconLocation == "LEFT") then ROB_NextActionFrame:SetPoint("RIGHT","ROB_CurrentActionFrame","LEFT"); end
      ROB_RotationToggle1TextureFrame:SetPoint("BOTTOMLEFT","ROB_CurrentActionFrame","TOPLEFT")
      ROB_RotationToggle2TextureFrame:SetPoint("BOTTOMRIGHT","ROB_CurrentActionFrame","TOPRIGHT")
      ROB_RotationToggle3TextureFrame:SetPoint("TOPLEFT","ROB_CurrentActionFrame", "BOTTOMLEFT")
      ROB_RotationToggle4TextureFrame:SetPoint("TOPRIGHT","ROB_CurrentActionFrame", "BOTTOMRIGHT")
   end
end

function ROB_NextActionLocation_Selected(self)
   ROB_Options.NextIconLocation = self.value
   ROB_SetNextActionLocation()
end

function ROB_OptionsNextActionLocationDropDownButton_OnLoad(frame)
   local ToggleName = ""
   UIDropDownMenu_SetWidth(frame, 75)
   UIDropDownMenu_JustifyText(frame, "LEFT");

   local i=0
   for i=1, 4 do
      table.wipe(ROB_DropDownTableTemp)
      if (i == 1) then ToggleName = "BOTTOM"; end
      if (i == 2) then ToggleName = "RIGHT"; end
      if (i == 3) then ToggleName = "TOP"; end
      if (i == 4) then ToggleName = "LEFT"; end
      
      ROB_DropDownTableTemp.text  = ToggleName
      ROB_DropDownTableTemp.value = ToggleName
      ROB_DropDownTableTemp.func  = ROB_NextActionLocation_Selected     
      UIDropDownMenu_AddButton(ROB_DropDownTableTemp);
   end
end

local function ROB_InterruptQuery(_spellname)  
   local _position = nil
   local _endposition = string.len(_spellname)
   --Search through the target interrupt list for the spell name and display a message if found
   
   if (ROB_EditingRotationTable ~= nil and ROB_CurrentActionName ~= nil and ROB_EditingRotationTable.ActionList[ROB_CurrentActionName].v_t_interrupt) then
      _position = string.find(ROB_EditingRotationTable.ActionList[ROB_CurrentActionName].v_t_interrupt, "||".._spellname.."||")
      if (not _position) then
         -- NOT FOUND try to find just the spell name without the pipes so user can fix it
         _position = nil
         _position = string.find(ROB_EditingRotationTable.ActionList[ROB_CurrentActionName].v_t_interrupt, _spellname)
         if (not _position) then
            print(ROB_UI_DEBUG_PREFIX.._spellname..ROB_UI_AO_T_INTERRUPT_M2)
         else
            ROB_AO_InterruptTargetInputBox:SetCursorPosition(_position)
            ROB_AO_InterruptTargetInputBox:HighlightText(_position, ((_position -1) + _endposition))
            print(ROB_UI_DEBUG_PREFIX.._spellname..ROB_UI_AO_T_INTERRUPT_M2)
         end
      else
         -- FOUND
         ROB_AO_InterruptTargetInputBox:SetCursorPosition(_position - _endposition)
         ROB_AO_InterruptTargetInputBox:HighlightText(_position+1, (_position + _endposition +1))

         
         print(ROB_UI_DEBUG_PREFIX.._spellname..ROB_UI_AO_T_INTERRUPT_M3)
      end
   else
      print(ROB_UI_DEBUG_PREFIX.._spellname..ROB_UI_AO_T_INTERRUPT_M1)
   end
end

function ROB_InterruptQuery_OnClick(self)
   ROB_GetString(ROB_UI_AO_T_INTERRUPT_M, "", true, ROB_InterruptQuery)

end

local function Keybinding_OnClick(frame, button)
   if button == "LeftButton" or button == "RightButton" then
      local self = frame.obj
      if self.waitingForKey then
         frame:EnableKeyboard(false)
         self.msgframe:Hide()
         frame:UnlockHighlight()
         self.waitingForKey = nil
      else
         frame:EnableKeyboard(true)
         self.msgframe:Show()
         frame:LockHighlight()
         self.waitingForKey = true
      end
   end
end

function ROB_ActionKeyBindButton_OnClick(self)
   local selectedrotation = ROB_GetSelectedRotation()
   if ((ROB_SelectedActionIndex ~= nil) and selectedrotation ~= nil) then
      _G["ROB_SpellNameInputBox"]:SetFocus()
      _G["ROB_SpellNameInputBox"]:ClearFocus()
      
      if self.waitingForKey then
         _G["ROB_AO_ActionKeyBindButton"]:EnableKeyboard(false)
         _G["ROB_AO_ActionKeyBindButton"]:UnlockHighlight()
         self.waitingForKey = nil
         -- update ui stuff
         ROB_ActionList_Update()
         ROB_Rotation_Edit_UpdateUI()
      else
         _G["ROB_AO_ActionKeyBindButton"]:EnableKeyboard(true)
         _G["ROB_AO_ActionKeyBindButton"]:LockHighlight()
         _G["ROB_AO_ActionKeyBindButton"]:SetText(ROB_UI_PRESSKEY)
         self.waitingForKey = true
      end
   end
end


function ROB_RotationKeyBindButton_OnClick(self)
   if (ROB_EditingRotationTable ~= nil) then
      _G["ROB_SpellNameInputBox"]:SetFocus()
      _G["ROB_SpellNameInputBox"]:ClearFocus()
      
      if self.waitingForKey then
         _G["ROB_RotationKeyBindButton"]:EnableKeyboard(false)
         _G["ROB_RotationKeyBindButton"]:UnlockHighlight()
         self.waitingForKey = nil
         -- update ui stuff
         ROB_ActionList_Update()
         ROB_Rotation_Edit_UpdateUI()
      else
         _G["ROB_RotationKeyBindButton"]:EnableKeyboard(true)
         _G["ROB_RotationKeyBindButton"]:LockHighlight()
         _G["ROB_RotationKeyBindButton"]:SetText(ROB_UI_PRESSKEY)
         self.waitingForKey = true
      end
   end
end

local function ClearBindings(...)
   for i = 1, select('#', ...) do
      SetBinding(select(i, ...), nil)
   end
end

function ROB_RotationKeyBindButton_OnKeyDown(self, key)
   if self.waitingForKey then
      local keyPressed = key
      local _BindSlotAvailable = true
      local _BindSlotAvailableID = 0
      local ignoreKeys = {
         ["BUTTON1"] = true, ["BUTTON2"] = true,
         ["UNKNOWN"] = true,
         ["LSHIFT"] = true, ["LCTRL"] = true, ["LALT"] = true,
         ["RSHIFT"] = true, ["RCTRL"] = true, ["RALT"] = true,
      }
      
     
      if (ROB_EditingRotationTable ~= nil) then

         if keyPressed == "ESCAPE" then
            keyPressed = ROB_UI_KEYBIND
         else
            if ignoreKeys[keyPressed] then return end
            if IsAltKeyDown() then
               --Blue pixel modifier is 1 for ALT
               keyPressed = "ALT-"..keyPressed
            end
            if IsShiftKeyDown() then
               --Blue pixel modifier is 2 for SHIFT
               keyPressed = "SHIFT-"..keyPressed
            end
            if IsControlKeyDown() then
               --Blue pixel modifier is 3 for CTRL
               keyPressed = "CTRL-"..keyPressed
            end
         end

         _G["ROB_RotationKeyBindButton"]:EnableKeyboard(false)
         _G["ROB_RotationKeyBindButton"]:UnlockHighlight()
         self.waitingForKey = nil

         if not self.disabled then
            _G["ROB_RotationKeyBindButton"]:SetText(keyPressed)
         end

         for i=1, 10 do
            _BindSlotAvailable = true
            --Loop through the rotations to find a bindslot available
            for _RotationName,_value in pairs(ROB_Rotations) do
               if (not ROB_Rotations[_RotationName].bindindex) then
                  ROB_Rotations[_RotationName]["bindindex"] = 0
               else
                  --this rotation has a bind index but if it matches the one we are checking then its not available
                  if (ROB_Rotations[_RotationName].bindindex == i) then
                     _BindSlotAvailable = false
                  end
               end
            end
            --After we have looped through the rotations if bindslot is available then we can use it        
            if (_BindSlotAvailable) then
               _BindSlotAvailableID = i
               break
            end
         end
         
         if (keyPressed == ROB_UI_KEYBIND) then
            ClearBindings(ROB_EditingRotationTable.keybind);
            _G["ROB_RotationKeyBindButton"]:SetText(keyPressed)
            ROB_EditingRotationTable.keybind = keyPressed
            ROB_EditingRotationTable["bindindex"] = 0
            ClearBindings(ROB_EditingRotationTable.keybind);
         elseif (_BindSlotAvailableID == 0) then
            print("Rotation bind failed: All 10 key bind slots are used by other rotations, unbind keys from other rotations to bind this rotation")
            _G["ROB_RotationKeyBindButton"]:SetText(keyPressed)
         else        
            ClearBindings(keyPressed);

            local ok = SetBinding(keyPressed,"Use rotation ".._BindSlotAvailableID);
            if (ok==nil) then
               print("error binding rotation")
            else
               print("Bound "..keyPressed.." to Rotation:"..ROB_SortedRotations[ROB_SelectedRotationIndex])
            end
            ROB_EditingRotationTable.keybind = keyPressed
            ROB_EditingRotationTable["bindindex"] = _BindSlotAvailableID
            
            
            SaveBindings(GetCurrentBindingSet())
         end
      end
      
      -- update lists edit
      ROB_ActionList_Update();

      -- update rotation ui stuff
      ROB_Rotation_Edit_UpdateUI();

   else
      _G["ROB_RotationKeyBindButton"]:EnableKeyboard(false)
      _G["ROB_RotationKeyBindButton"]:UnlockHighlight()
      self.waitingForKey = nil
   end
end

function ROB_AO_ActionKeyBindButton_OnKeyDown(self, key)
   if self.waitingForKey then
      local keyPressed = key
      local selectedrotation = ROB_GetSelectedRotation()
      
      local ignoreKeys = {
         ["BUTTON1"] = true, ["BUTTON2"] = true,
         ["UNKNOWN"] = true,
         ["LSHIFT"] = true, ["LCTRL"] = true, ["LALT"] = true,
         ["RSHIFT"] = true, ["RCTRL"] = true, ["RALT"] = true,
      }
      
      if keyPressed == "ESCAPE" then
         keyPressed = ROB_UI_KEYBIND
      else
         if ignoreKeys[keyPressed] then return end
         if IsAltKeyDown() then
            --Blue pixel modifier is 1 for ALT
            keyPressed = "ALT-"..keyPressed
         end
         if IsShiftKeyDown() then
            --Blue pixel modifier is 2 for SHIFT
            keyPressed = "SHIFT-"..keyPressed
         end
         if IsControlKeyDown() then
            --Blue pixel modifier is 3 for CTRL
            keyPressed = "CTRL-"..keyPressed
         end
      end

      _G["ROB_AO_ActionKeyBindButton"]:EnableKeyboard(false)
      _G["ROB_AO_ActionKeyBindButton"]:UnlockHighlight()
      self.waitingForKey = nil

      if not self.disabled then
         _G["ROB_AO_ActionKeyBindButton"]:SetText(keyPressed)
         --self:Fire("OnKeyChanged", keyPressed)
      end
      
      if ((ROB_SelectedActionIndex ~= nil) and selectedrotation ~= nil) then
         selectedrotation.ActionList[selectedrotation.SortedActions[ROB_SelectedActionIndex]].v_keybind = keyPressed
      end
      
      -- update lists edit
      ROB_ActionList_Update();

      -- update rotation ui stuff
      ROB_Rotation_Edit_UpdateUI();

   else
      _G["ROB_AO_ActionKeyBindButton"]:EnableKeyboard(false)
      _G["ROB_AO_ActionKeyBindButton"]:UnlockHighlight()
      self.waitingForKey = nil
   end
end

function ROB_Option_MiniMapButton_OnToggle(self)
   -- retrieve value
   ROB_Options.MiniMap = (ROB_OptionsTabMiniMapButton:GetChecked() ~= nil);

   -- and show/hide the actual button
   if (ROB_Options.MiniMap == true) then
      -- on she goes
      PlaySound("igMainMenuOptionCheckBoxOn");
   else
      -- off she goes
      PlaySound("igMainMenuOptionCheckBoxOff");
   end

   -- and show/hide the MiniMap button
   ROB_MiniMapButton_Update();
end

function ROB_OptionsTabLockIconsButton_OnToggle(self)
   ROB_Options.LockIcons = (self:GetChecked() ~= nil);

   if (ROB_Options.LockIcons) then
      ROB_IconsFrame:SetMovable(false)
      ROB_IconsFrame:EnableMouse(false)
   else
      ROB_IconsFrame:SetMovable(true)
      ROB_IconsFrame:EnableMouse(true)
   end    
end

function ROB_OptionsTabAllowOverwriteButton_OnToggle(self)
   ROB_Options.AllowOverwrite = (self:GetChecked() ~= nil);
end

function ROB_OptionsTabExportBindsButton_OnToggle(self)
   ROB_Options.ExportBinds = (self:GetChecked() ~= nil);
end

function ROB_Option_MiniMapButtonPos_OnValueChanged(self)
   -- retrieve value
   ROB_Options.MiniMapPos = ROB_OptionsTabMiniMapPosSlider:GetValue();

   -- update slidertext
   ROB_OptionsTabMiniMapPosSliderText:SetText(ROB_Options.MiniMapPos);

   -- reflect the position
   ROB_MiniMapButton_Update();
end

function ROB_Option_IconScale_OnValueChanged(self)
   -- retrieve value  
   ROB_Options.IconScale = string.format("%.1f", self:GetValue());

   -- update slidertext
   ROB_OptionsTabIconScaleSliderText:SetText(ROB_Options.IconScale);
   
   -- update the scale
   ROB_IconsFrame:SetScale(ROB_Options.IconScale)
   ROB_CurrentActionFrame:SetScale(ROB_Options.IconScale)
   ROB_NextActionFrame:SetScale(ROB_Options.IconScale)
   ROB_RotationToggle1TextureFrame:SetScale(ROB_Options.IconScale);
   ROB_RotationToggle2TextureFrame:SetScale(ROB_Options.IconScale);
   ROB_RotationToggle3TextureFrame:SetScale(ROB_Options.IconScale);
   ROB_RotationToggle4TextureFrame:SetScale(ROB_Options.IconScale);
   --ROB_MiniMapButton_Update();
   ROB_IconsFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", ROB_Options.IconsX / ROB_IconsFrame:GetEffectiveScale(), ROB_Options.IconsY / ROB_IconsFrame:GetEffectiveScale())
end

function ROB_Option_MiniMapButtonRad_OnValueChanged(self)
   -- retrieve value
   ROB_Options.MiniMapRad = ROB_OptionsTabMiniMapRadSlider:GetValue();

   -- update slidertext
   ROB_OptionsTabMiniMapRadSliderText:SetText(ROB_Options.MiniMapRad);

   -- reflect the position
   ROB_MiniMapButton_Update();
end

function ROB_Options_UIScaleAdd_OnClick(self)
   if (ROB_Options.UIScale + .05 < 1.3) then
      ROB_Options.UIScale = ROB_Options.UIScale + .05
      ROB_Frame:SetScale(ROB_Options.UIScale)
      ROB_OptionsUIScaleValue:SetText(ROB_Options.UIScale)
   end
end

function ROB_Options_UIScaleSub_OnClick(self)
   if (ROB_Options.UIScale - .05 > .5) then
      ROB_Options.UIScale = ROB_Options.UIScale - .05
      ROB_Frame:SetScale(ROB_Options.UIScale)
      ROB_OptionsUIScaleValue:SetText(ROB_Options.UIScale)
   end
end



function ROB_Options_ResetUI_OnClick(self)
   -- reset UI, the user has lost the window off the screen.  Reset the anchors to center
   ROB_Frame:ClearAllPoints();
   ROB_Frame:SetPoint("CENTER");
   ROB_IconsFrame:ClearAllPoints();
   ROB_IconsFrame:SetPoint("CENTER");
end

function ROB_ToggleToggle(Toggle)
   if (_G["ROB_TOGGLE_"..Toggle] == 0) then
      _G["ROB_TOGGLE_"..Toggle] = 1
   else
      _G["ROB_TOGGLE_"..Toggle] = 0
   end
end

function ROB_MiniMapButton_Update()
   -- update the MiniMap button position
   ROB_MiniMapButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT",(52 - (ROB_Options.MiniMapRad * cos(ROB_Options.MiniMapPos))),((ROB_Options.MiniMapRad * sin(ROB_Options.MiniMapPos)) - 52));
   
   -- show/hide the button according to toggle
   if (ROB_Options.MiniMap == false) then
      -- hide the mini map frames
      ROB_MiniMapButton:Hide();
   else
      -- show the mini map button frame
      ROB_MiniMapButton:Show();
   end
   
end

function ROB_RotationList_Update()
   local offset, row, listIx, rowButton, rowName;
   
   -- retrieve the scroll offset for editing hierarchy view
   offset = FauxScrollFrame_GetOffset(ROB_RotationScrollFrame);
   
   -- handle each list row
   for row=1, ROB_ROTATION_LIST_LINES, 1 do
      -- calculate actual the list item index
      listIx = row + offset;

      -- retrieve the list row
      rowButton = _G["ROB_RotationListButton"..row];
      
      -- do we have a list for this guy?
      if (listIx <= #ROB_SortedRotations) then
         -- get the name button
         rowName = _G["ROB_RotationListButton"..row.."Name"];
         
         -- set the list name
         rowName:SetText(ROB_SortedRotations[listIx]);

         -- is this the current list?
         if (listIx == ROB_SelectedRotationIndex) then
            -- highlight the row
            rowButton:LockHighlight();
         else
            -- normalise the row
            rowButton:UnlockHighlight();
         end
         
         -- show the button
         rowButton:Show();
      else
         -- hide this row
         rowButton:Hide();
      end
   end
   
   -- update the scroll frame appropriately
   FauxScrollFrame_Update(ROB_RotationScrollFrame, #ROB_SortedRotations, ROB_ROTATION_LIST_LINES, ROB_ROTATION_LIST_FRAME_HEIGHT);
end

function ROB_ActionList_Update()
   local offset, selectedrotation, count, ActionID, metric, row, rowButton, rowNote, rowAction, rowTrash, rowComplete;
   local rowMBase, rowMBaseRO, rowMProc, rowMProcRO, rowMTotalRO;
   local itemColor, itemID, itemText, ActionName, mUse, mBase, mProc, mScale, mOverride, isBlank, itemPawn, clrBase;

   local savedActionName, savedValue

   
   -- retrieve the scroll offset for editing source view
   offset = FauxScrollFrame_GetOffset(ROB_ActionListScrollFrame); 
   -- get action selectedrotation
   selectedrotation = ROB_GetSelectedRotation();  
   -- get count of items in list
   if (selectedrotation ~= nil) then
      count = #selectedrotation.SortedActions;
   else
      count = 0;
   end

   -- Build the Action List
   for row=1, ROB_ACTION_LIST_LINES, 1 do
      -- calculate actual the Action index
      ActionID = row + offset;
      -- retrieve the source row
      rowButton = _G["ROB_ActionListButton"..row];    
      -- do we have a action for this interval count?
      if (ActionID <= count) then
         rowAction = _G["ROB_ActionListButton"..row.."ActionName"];
         rowTrash = _G["ROB_ActionListButton"..row.."Trash"];       
         --Get the saved Action name based upon the sorted table
         savedActionName = selectedrotation.SortedActions[ActionID]

         -- set the button name to stored table value
         rowAction:SetText(savedActionName);
         -- show trash/hide complete if we are editing
         if (ROB_EditingRotationTable ~= nil) then
            -- show trash
            rowTrash:Show();
         else
            -- hide trash
            rowTrash:Hide();
         end       
         -- is this the current list?
         if (ActionID == ROB_SelectedActionIndex) then
            rowButton:LockHighlight();
         else
            rowButton:UnlockHighlight();
         end
         -- show the row button
         rowButton:Show();
      else
         -- hide this row
         rowButton:Hide();
      end
   end
   
   -- update the scroll frame appropriately
   FauxScrollFrame_Update(ROB_ActionListScrollFrame, count, ROB_ACTION_LIST_LINES, ROB_ACTION_LIST_FRAME_HEIGHT);
end

function ROB_SortRotationList()
   local key, value;
   
   -- setup sort indirection
   ROB_SortedRotations = {};

   -- get each of the list records
   for key, value in pairs(ROB_Rotations) do
      ROB_SortedRotations[#ROB_SortedRotations + 1] = key;
   end

   -- resort the lists list.  We use a sorted indirection table
   table.sort(ROB_SortedRotations, ROB_SortTest);

   -- and update screen
   ROB_RotationList_Update();
end

function ROB_SortTest(i1, i2)
   return i1 < i2
end

function ROB_RotationModifyButtons_UpdateUI()
   -- do we have an existing edit or selected list?
   if (ROB_EditingRotationTable ~= nil) then
      -- disable create, modify and remove
      ROB_RotationCreateButton:Disable();
      ROB_RotationImportButton:Disable();
      ROB_RotationExportButton:Disable();
      ROB_RotationListModifyButton:Hide();
      ROB_RotationListDeleteButton:Hide();
   elseif (ROB_SelectedRotationIndex ~= nil) then
      -- enable create, modify and remove
      ROB_RotationCreateButton:Enable();
      ROB_RotationImportButton:Enable();
      ROB_RotationExportButton:Enable();
      ROB_RotationListModifyButton:Show();
      ROB_RotationListDeleteButton:Show();
      -- retrieve rotation value from saved options
      ROB_RotationNameROText:SetText(ROB_SortedRotations[ROB_SelectedRotationIndex]);
   else
      -- enable create, disable modify and remove
      ROB_RotationCreateButton:Enable();
      ROB_RotationImportButton:Enable();
      ROB_RotationExportButton:Enable();
      ROB_RotationListModifyButton:Hide();
      ROB_RotationListDeleteButton:Hide();   
      -- reset rotation values
      ROB_RotationNameROText:SetText("");
   end

end

function ROB_Rotation_GUI_SetText(_controlname,_value,_default)
   if (_value ~= nil) then
      _G[_controlname]:SetText(_value)
   else
      _G[_controlname]:SetText(_default)
   end
end

function ROB_Rotation_GUI_SetChecked(_controlname,_value,_default)
   if (_value ~= nil) then
      _G[_controlname]:SetChecked(_value)
   else
      _G[_controlname]:SetChecked(_default)
   end
end

-- Lists Edit Update UI handler
function ROB_Rotation_Edit_UpdateUI()
   ROB_RotationTabTab1:Hide()
   ROB_RotationTabTab2:Hide()
   ROB_RotationTabTab3:Hide()
   ROB_RotationTabTab4:Hide()
   ROB_RotationTabTab5:Hide()
   -- do we have a list being edited?
   if (ROB_EditingRotationTable ~= nil) then
      -- have we a list name?
      if (ROB_SelectedRotationName ~= "") then
         -- enable save
         ROB_RotationSaveButton:Show();
         ROB_RotationDiscardButton:Show();
         ROB_AddActionButton:Show();
         ROB_CopyActionButton:Show();
         ROB_PasteActionButton:Show();
      else
         -- hide save
         ROB_RotationSaveButton:Hide();
         ROB_RotationDiscardButton:Hide();
         ROB_AddActionButton:Hide();
         ROB_CopyActionButton:Hide();
         ROB_PasteActionButton:Hide();
      end
      
      -- enable discard
      

      -- selected action row is after top row or before last row?
      if (ROB_SelectedActionIndex == nil) then
         -- disable item row move buttons
         ROB_ActionListMoveUpButton:Disable();
         ROB_ActionListMoveDownButton:Disable();
      elseif   (ROB_SelectedActionIndex <= 1) then
         -- disable item row move up and enable row move down buttons
         ROB_ActionListMoveUpButton:Disable();
         ROB_ActionListMoveDownButton:Enable();
      elseif   (ROB_SelectedActionIndex >= #ROB_EditingRotationTable.SortedActions) then
         -- enable item row move up and disable row move down buttons
         ROB_ActionListMoveUpButton:Enable();
         ROB_ActionListMoveDownButton:Disable();
      else
         -- enable item row move buttons
         ROB_ActionListMoveUpButton:Enable();
         ROB_ActionListMoveDownButton:Enable();
      end
      

      
      if (ROB_EditingRotationTable.ActionList[ROB_CurrentActionName] ~= nil) then
         local _ActionDB = ROB_EditingRotationTable.ActionList[ROB_CurrentActionName]
         -- RETRIEVE_NEW_OPTIONS_BELOW
         ROB_Rotation_GUI_SetText("ROB_AO_ActionKeyBindButton",_ActionDB.v_keybind,ROB_UI_KEYBIND)
         ROB_Rotation_GUI_SetText("ROB_SpellNameInputBox",_ActionDB.v_spellname,"<spellname>")
         ROB_SpellValidate(_ActionDB.v_spellname)
         
         ROB_Rotation_GUI_SetText("ROB_AO_ActionIconInputBox",_ActionDB.v_actionicon,"")
         ROB_AO_ActionIconTexture:SetTexture(GetTexturePath(_ActionDB.v_actionicon)) 
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_ToggleCheckButton",_ActionDB.b_toggle,false)
         ROB_Rotation_GUI_SetChecked("ROB_AO_ToggleOffCheckButton",_ActionDB.b_toggleoff,false)
         ROB_Rotation_GUI_SetChecked("ROB_AO_ToggleOnCheckButton",_ActionDB.b_toggleon,false)
         
         UIDropDownMenu_SetSelectedValue(ROB_AO_ToggleDropDownButton, _ActionDB.v_togglename)
         UIDropDownMenu_SetText(ROB_AO_ToggleDropDownButton, _ActionDB.v_togglename)

         ROB_Rotation_GUI_SetText("ROB_AO_ToggleIconInputBox",_ActionDB.v_toggleicon,"")
         ROB_AO_ToggleIconTexture:SetTexture(GetTexturePath(_ActionDB.v_toggleicon)) 

         ROB_Rotation_GUI_SetText("ROB_AO_GCDSpellInputBox",_ActionDB.v_gcdspell,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_RangeCheckButton",_ActionDB.b_rangecheck,true)
         ROB_Rotation_GUI_SetText("ROB_AO_RangeSpellInputBox",_ActionDB.v_rangespell,"")

         ROB_Rotation_GUI_SetChecked("ROB_AO_MaxCastsCheckButton",_ActionDB.b_maxcasts,false)
         ROB_Rotation_GUI_SetText("ROB_AO_MaxCastsInputBox",_ActionDB.v_maxcasts,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_LastCastedCheckButton",_ActionDB.b_lastcasted,false)
         ROB_Rotation_GUI_SetText("ROB_AO_LastCastedInputBox",_ActionDB.v_lastcasted,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_BreakChannelingCheckButton",_ActionDB.b_breakchanneling,false)

         ROB_Rotation_GUI_SetChecked("ROB_AO_MovingCheckButton",_ActionDB.b_moving,false)

         ROB_Rotation_GUI_SetChecked("ROB_AO_CheckOtherCDCheckButton",_ActionDB.b_checkothercd,false)
         ROB_Rotation_GUI_SetText("ROB_AO_CheckOtherCDNameInputBox",_ActionDB.v_checkothercdname,"")
         ROB_Rotation_GUI_SetText("ROB_AO_CheckOtherCDValueInputBox",_ActionDB.v_checkothercdvalue,"")
         
         ROB_Rotation_GUI_SetText("ROB_AO_DurationInputBox",_ActionDB.v_duration,"")
         ROB_Rotation_GUI_SetChecked("ROB_AO_DurationCheckButton",_ActionDB.b_duration,false)
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_NotASpellCheckButton",_ActionDB.b_notaspell,false)

         ROB_Rotation_GUI_SetText("ROB_AO_OORInputBox",_ActionDB.v_oorspell,"")
         ROB_Rotation_GUI_SetChecked("ROB_AO_OORCheckButton",_ActionDB.b_oorspell,false)


         ROB_Rotation_GUI_SetChecked("ROB_AO_DebugCheckButton",_ActionDB.b_debug,false)
         ROB_Rotation_GUI_SetChecked("ROB_AO_DisableCheckButton",_ActionDB.b_disabled,false)
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_GUnitPowerCheckButton",_ActionDB.b_gunitpower,false)
         ROB_Rotation_GUI_SetText("ROB_AO_GUnitPowerTypeInputBox",_ActionDB.v_gunitpowertype,"")
         ROB_Rotation_GUI_SetText("ROB_AO_GUnitPowerInputBox",_ActionDB.v_gunitpower,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_GComboPointsCheckButton",_ActionDB.b_gcombopoints,false)
         ROB_Rotation_GUI_SetText("ROB_AO_GComboPointsInputBox",_ActionDB.v_gcombopoints,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_GBloodRunesCheckButton",_ActionDB.b_gbloodrunes,false)
         ROB_Rotation_GUI_SetText("ROB_AO_GBloodRunesInputBox",_ActionDB.v_gbloodrunes,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_GFrostRunesCheckButton",_ActionDB.b_gfrostrunes,false)
         ROB_Rotation_GUI_SetText("ROB_AO_GFrostRunesInputBox",_ActionDB.v_gfrostrunes,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_GUnholyRunesCheckButton",_ActionDB.b_gunholyrunes,false)
         ROB_Rotation_GUI_SetText("ROB_AO_GUnholyRunesInputBox",_ActionDB.v_gunholyrunes,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_GDeathRunesCheckButton",_ActionDB.b_gdeathrunes,false)
         ROB_Rotation_GUI_SetText("ROB_AO_GDeathRunesInputBox",_ActionDB.v_gdeathrunes,"")

         --Player options-------------------------
         ROB_Rotation_GUI_SetChecked("ROB_AO_NeedBuffCheckButton",_ActionDB.b_p_needbuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_NeedBuffInputBox",_ActionDB.v_p_needbuff,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_HaveBuffCheckButton",_ActionDB.b_p_havebuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_HaveBuffInputBox",_ActionDB.v_p_havebuff,"")

         ROB_Rotation_GUI_SetChecked("ROB_AO_NeedDebuffCheckButton",_ActionDB.b_p_needdebuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_NeedDebuffInputBox",_ActionDB.v_p_needdebuff,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_HaveDebuffCheckButton",_ActionDB.b_p_havedebuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_HaveDebuffInputBox",_ActionDB.v_p_havedebuff,"")

         ROB_Rotation_GUI_SetChecked("ROB_AO_PlayerHPCheckButton",_ActionDB.b_p_hp,false)
         ROB_Rotation_GUI_SetText("ROB_AO_PlayerHPInputBox",_ActionDB.v_p_hp,"")

         ROB_Rotation_GUI_SetChecked("ROB_AO_UnitPowerCheckButton",_ActionDB.b_p_unitpower,false)
         ROB_Rotation_GUI_SetText("ROB_AO_UnitPowerTypeInputBox",_ActionDB.v_p_unitpowertype,"")
         ROB_Rotation_GUI_SetText("ROB_AO_UnitPowerInputBox",_ActionDB.v_p_unitpower,"")

         ROB_Rotation_GUI_SetChecked("ROB_AO_BloodRunesCheckButton",_ActionDB.b_p_bloodrunes,false)
         ROB_Rotation_GUI_SetText("ROB_AO_BloodRunesInputBox",_ActionDB.v_p_bloodrunes,"")

         ROB_Rotation_GUI_SetChecked("ROB_AO_FrostRunesCheckButton",_ActionDB.b_p_frostrunes,false)
         ROB_Rotation_GUI_SetText("ROB_AO_FrostRunesInputBox",_ActionDB.v_p_frostrunes,"")

         ROB_Rotation_GUI_SetChecked("ROB_AO_UnholyRunesCheckButton",_ActionDB.b_p_unholyrunes,false)
         ROB_Rotation_GUI_SetText("ROB_AO_UnholyRunesInputBox",_ActionDB.v_p_unholyrunes,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_AllowDeathRunesCheckButton",_ActionDB.b_p_deathrunes,false)

         ROB_Rotation_GUI_SetChecked("ROB_AO_CurseCheckButton",_ActionDB.b_p_curse,false)
         ROB_Rotation_GUI_SetChecked("ROB_AO_DiseaseCheckButton",_ActionDB.b_p_disease,false)
         ROB_Rotation_GUI_SetChecked("ROB_AO_MagicCheckButton",_ActionDB.b_p_magic,false)
         ROB_Rotation_GUI_SetChecked("ROB_AO_PoisonCheckButton",_ActionDB.b_p_poison,false)

         ROB_Rotation_GUI_SetChecked("ROB_AO_ComboPointsCheckButton",_ActionDB.b_p_combopoints,false)
         ROB_Rotation_GUI_SetText("ROB_AO_ComboPointsInputBox",_ActionDB.v_p_combopoints,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_EclipeDirectionCheckButton",_ActionDB.b_p_eclipse,false)
         ROB_Rotation_GUI_SetText("ROB_AO_EclipeDirectionInputBox",_ActionDB.v_p_eclipse,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_FireTotemActiveCheckButton",_ActionDB.b_p_firetotemactive,false)
         ROB_Rotation_GUI_SetText("ROB_AO_FireTotemActiveInputBox",_ActionDB.v_p_firetotemactive,"")
         ROB_Rotation_GUI_SetChecked("ROB_AO_FireTotemInactiveCheckButton",_ActionDB.b_p_firetoteminactive,false)
         ROB_Rotation_GUI_SetText("ROB_AO_FireTotemInactiveInputBox",_ActionDB.v_p_firetoteminactive,"")
         ROB_Rotation_GUI_SetChecked("ROB_AO_FireTotemTimeleftCheckButton",_ActionDB.b_p_firetotemtimeleft,false)
         ROB_Rotation_GUI_SetText("ROB_AO_FireTotemTimeleftInputBox",_ActionDB.v_p_firetotemtimeleft,"")
   
         ROB_Rotation_GUI_SetChecked("ROB_AO_EarthTotemActiveCheckButton",_ActionDB.b_p_earthtotemactive,false)
         ROB_Rotation_GUI_SetText("ROB_AO_EarthTotemActiveInputBox",_ActionDB.v_p_earthtotemactive,"")
         ROB_Rotation_GUI_SetChecked("ROB_AO_EarthTotemInactiveCheckButton",_ActionDB.b_p_earthtoteminactive,false)
         ROB_Rotation_GUI_SetText("ROB_AO_EarthTotemInactiveInputBox",_ActionDB.v_p_earthtoteminactive,"")
         ROB_Rotation_GUI_SetChecked("ROB_AO_EarthTotemTimeleftCheckButton",_ActionDB.b_p_earthtotemtimeleft,false)
         ROB_Rotation_GUI_SetText("ROB_AO_EarthTotemTimeleftInputBox",_ActionDB.v_p_earthtotemtimeleft,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_WaterTotemActiveCheckButton",_ActionDB.b_p_watertotemactive,false)
         ROB_Rotation_GUI_SetText("ROB_AO_WaterTotemActiveInputBox",_ActionDB.v_p_watertotemactive,"")
         ROB_Rotation_GUI_SetChecked("ROB_AO_WaterTotemInactiveCheckButton",_ActionDB.b_p_watertoteminactive,false)
         ROB_Rotation_GUI_SetText("ROB_AO_WaterTotemInactiveInputBox",_ActionDB.v_p_watertoteminactive,"")
         ROB_Rotation_GUI_SetChecked("ROB_AO_WaterTotemTimeleftCheckButton",_ActionDB.b_p_watertotemtimeleft,false)
         ROB_Rotation_GUI_SetText("ROB_AO_WaterTotemTimeleftInputBox",_ActionDB.v_p_watertotemtimeleft,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_AirTotemActiveCheckButton",_ActionDB.b_p_airtotemactive,false)
         ROB_Rotation_GUI_SetText("ROB_AO_AirTotemActiveInputBox",_ActionDB.v_p_airtotemactive,"")
         ROB_Rotation_GUI_SetChecked("ROB_AO_AirTotemInactiveCheckButton",_ActionDB.b_p_airtoteminactive,false)
         ROB_Rotation_GUI_SetText("ROB_AO_AirTotemInactiveInputBox",_ActionDB.v_p_airtoteminactive,"")
         ROB_Rotation_GUI_SetChecked("ROB_AO_AirTotemTimeleftCheckButton",_ActionDB.b_p_airtotemtimeleft,false)
         ROB_Rotation_GUI_SetText("ROB_AO_AirTotemTimeleftInputBox",_ActionDB.v_p_airtotemtimeleft,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_NeedMainhandEnchantCheckButton",_ActionDB.b_p_nmh,false)
         ROB_Rotation_GUI_SetText("ROB_AO_NeedMainhandEnchantInputBox",_ActionDB.v_p_nmh,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_NeedOffhandEnchantCheckButton",_ActionDB.b_p_noh,false)
         ROB_Rotation_GUI_SetText("ROB_AO_NeedOffhandEnchantInputBox",_ActionDB.v_p_noh,"")
         --Target options-------------------------
         ROB_Rotation_GUI_SetChecked("ROB_AO_TargetNeedsBuffCheckButton",_ActionDB.b_t_needsbuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_TargetNeedsBuffInputBox",_ActionDB.v_t_needsbuff,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_TargetHasBuffCheckButton",_ActionDB.b_t_hasbuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_TargetHasBuffInputBox",_ActionDB.v_t_hasbuff,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_TargetNeedsDebuffCheckButton",_ActionDB.b_t_needsdebuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_TargetNeedsDebuffInputBox",_ActionDB.v_t_needsdebuff,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_TargetHasDebuffCheckButton",_ActionDB.b_t_hasdebuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_TargetHasDebuffInputBox",_ActionDB.v_t_hasdebuff,"")

         ROB_Rotation_GUI_SetChecked("ROB_AO_TargetHPCheckButton",_ActionDB.b_t_hp,false)
         ROB_Rotation_GUI_SetText("ROB_AO_TargetHPInputBox",_ActionDB.v_t_hp,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_TargetMaxHPCheckButton",_ActionDB.b_t_maxhp,false)
         ROB_Rotation_GUI_SetText("ROB_AO_TargetMaxHPInputBox",_ActionDB.v_t_maxhp,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_TargetClassCheckButton",_ActionDB.b_t_class,false)
         ROB_Rotation_GUI_SetText("ROB_AO_TargetClassInputBox",_ActionDB.v_t_class,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_InterruptTargetCheckButton",_ActionDB.b_t_interrupt,false)
         ROB_Rotation_GUI_SetText("ROB_AO_InterruptTargetInputBox",_ActionDB.v_t_interrupt,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_TargetPCCheckButton",_ActionDB.b_t_pc,false)
         --Pet options-------------------------
         ROB_Rotation_GUI_SetChecked("ROB_AO_PetHPCheckButton",_ActionDB.b_pet_hp,false)
         ROB_Rotation_GUI_SetText("ROB_AO_PetHPInputBox",_ActionDB.v_pet_hp,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_PetISACCheckButton",_ActionDB.b_pet_isac,false)
         ROB_Rotation_GUI_SetText("ROB_AO_PetISACInputBox",_ActionDB.v_pet_isac,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_PetNACCheckButton",_ActionDB.b_pet_nac,false)
         ROB_Rotation_GUI_SetText("ROB_AO_PetNACInputBox",_ActionDB.v_pet_nac,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_PetNeedsBuffCheckButton",_ActionDB.b_pet_needsbuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_PetNeedsBuffInputBox",_ActionDB.v_pet_needsbuff,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_PetHasBuffCheckButton",_ActionDB.b_pet_hasbuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_PetHasBuffInputBox",_ActionDB.v_pet_hasbuff,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_PetNeedsDebuffCheckButton",_ActionDB.b_pet_needsdebuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_PetNeedsDebuffInputBox",_ActionDB.v_pet_needsdebuff,"")
         
         ROB_Rotation_GUI_SetChecked("ROB_AO_PetHasDebuffCheckButton",_ActionDB.b_pet_hasdebuff,false)
         ROB_Rotation_GUI_SetText("ROB_AO_PetHasDebuffInputBox",_ActionDB.v_pet_hasdebuff,"")
         --Focus options-------------------------
         ROB_Rotation_GUI_SetChecked("ROB_AO_FocusHPCheckButton",_ActionDB.b_f_hp,false)
         ROB_Rotation_GUI_SetText("ROB_AO_FocusHPInputBox",_ActionDB.v_f_hp,"")

         -- show action options frames because we have a current selected action
         if ((not ROB_GeneralActionOptionsTab:IsShown()) and (not ROB_PlayerActionOptionsTab:IsShown()) and (not ROB_TargetActionOptionsTab:IsShown()) and (not ROB_PetActionOptionsTab:IsShown()) and (not ROB_FocusActionOptionsTab:IsShown())) then
            ROB_GeneralActionOptionsTab:Show()
            ROB_ActionOptionsSwitchToTab(ROB_RotationTabTab1)
         end
         ROB_RotationTabTab1:Show()
         ROB_RotationTabTab2:Show()
         ROB_RotationTabTab3:Show()
         ROB_RotationTabTab4:Show()
         ROB_RotationTabTab5:Show()
      end
      
      -- ADD_SHOW_ROTATION_OPTIONS
      ROB_RotationNameInputBox:Show();
      ROB_RotationNameRO:Hide();   
      ROB_RotationKeyBindButton:Enable();

   else
      -- ADD_HIDE_ROTATION_OPTIONS
      ROB_RotationNameInputBox:Hide();
      ROB_RotationNameRO:Show();

      ROB_RotationKeyBindButton:Disable();
      
      -- disable save and discard
      ROB_RotationSaveButton:Hide();
      ROB_RotationDiscardButton:Hide();
      ROB_AddActionButton:Hide();
      ROB_CopyActionButton:Hide();
      ROB_PasteActionButton:Hide();

      -- disable item row move buttons
      ROB_ActionListMoveUpButton:Disable();
      ROB_ActionListMoveDownButton:Disable();
      
      -- hide action options tabs
      ROB_GeneralActionOptionsTab:Hide()
      ROB_PlayerActionOptionsTab:Hide()
      ROB_TargetActionOptionsTab:Hide()
      ROB_PetActionOptionsTab:Hide()
      ROB_FocusActionOptionsTab:Hide()
      
      -- RETRIEVE_ROTATION_SETTINGS
      if (ROB_SelectedRotationName ~= nil) then
         ROB_RotationKeyBindButton:SetText(ROB_Rotations[ROB_SelectedRotationName].keybind)
      end
   end
   
   -- update the menu 
   if (LibStub and LibStub:GetLibrary('LibDataBroker-1.1', true)) then
      local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
      local mymenu = ldb:GetDataObjectByName(ROB_ADDON_NAME)
      if (ROB_SelectedRotationName and mymenu) then
         mymenu.label = ROB_ADDON_NAME.." ["..ROB_SelectedRotationName.."]"
      elseif (not ROB_SelectedRotationName and mymenu) then
         mymenu.label = ROB_ADDON_NAME
      end
   end 
end

-- Get Item Entry handler
function ROB_GetSelectedRotation(eType)
   -- determine which list to use (existing lists or editing list).  Optional selectedrotation restricts which one we can return
   if ((ROB_EditingRotationTable ~= nil) and (eType ~= ROB_ROTATION_TYPE.SELECTED)) then
      -- return the current rotation being edited
      return ROB_EditingRotationTable;
   elseif ((ROB_SelectedRotationIndex ~= nil) and (eType ~= ROB_ROTATION_TYPE.EDITING)) then
      -- return selected rotation
      return ROB_Rotations[ROB_SortedRotations[ROB_SelectedRotationIndex]];
   else
      return nil;
   end
end



function ROB_AddAction(ActionID, ActionName)
   -- first, add Action's key to sort
   table.insert(ROB_EditingRotationTable.SortedActions, ActionID, ActionName);
   ROB_EditingRotationTable.ActionList[ActionName] = {}
   
   for key, val in pairs(ROB_NewActionDefaults) do
      ROB_EditingRotationTable.ActionList[ActionName][key] = val
   end
end

function ROB_RotationImportButton_OnClick()   
   ROB_GetString(ROB_UI_IMPORT_MESSAGE, "", true, ROB_RotationImport)
end

function ROB_RotationImport(_RotationBuild)  
   ROB_ImportRotation(_RotationBuild)
end

function ROB_ImportRotation(_RotationBuild)
   local _parsedRotationName = nil
   local _parsedRangeSpell = nil
   local _AlreadyExists = false
   local _RotationBuildRemaining = nil
   
   if (_RotationBuild) then
      --First check that the import string is from rotation builder
      if (string.sub(_RotationBuild, 1,15) ~= "RotationBuilder") then
         print(ROB_UI_IMPORT_ERROR3)
         return
      end
              
      _parsedRotationName = string.sub(_RotationBuild, string.find(_RotationBuild,"%[")+1,string.find(_RotationBuild,"%]")-1)
      _RotationBuildRemaining = string.sub(_RotationBuild, string.find(_RotationBuild,"%]")+2)
   end
   
   if ((not _parsedRotationName) or _parsedRotationName == "" or (not _RotationBuild) or _RotationBuild == "") then
      print(ROB_UI_IMPORT_ERROR1)
      return
   end
   
   if (ROB_Rotations[_parsedRotationName]) then
      _AlreadyExists = true
      
   end
   
   --Removed overwrite ability, it was confusing better to just not allow import overwriting
   --if (_AlreadyExists and not ROB_Options.AllowOverwrite) then
   if (_AlreadyExists) then
      print(ROB_UI_DEBUG_PREFIX.._parsedRotationName..":"..ROB_UI_IMPORT_ERROR2)
      return
   --elseif (_AlreadyExists and ROB_Options.AllowOverwrite) then
   --   ROB_Rotations[_parsedRotationName].rangespell = {}
   --   ROB_Rotations[_parsedRotationName]["rangespell"] = _parsedRangeSpell
   elseif (not _AlreadyExists) then
      ROB_Rotations[_parsedRotationName] = {}
      ROB_Rotations[_parsedRotationName]["keybind"] = {}
      ROB_Rotations[_parsedRotationName]["keybind"] = ROB_UI_KEYBIND
      ROB_Rotations[_parsedRotationName]["rangespell"] = {}
      ROB_Rotations[_parsedRotationName]["rangespell"] = _parsedRangeSpell
      ROB_Rotations[_parsedRotationName]["SortedActions"] = {}
      ROB_Rotations[_parsedRotationName]["ActionList"] = {}
   end

   local _data = { strsplit(",", _RotationBuildRemaining) }   
   local _actionname = nil
   local _keyname = nil
   local _keyvalue = nil
   _AlreadyExists = false
   for _key,_value in pairs(_data) do
      --print("   _value=".._value) 
      --Added some robustness to deal with a new action that doesnt have the ending bracket ]
      if (string.sub(_value,1,1) == "[" and string.find(_value,"%]")) then
      --if (string.sub(_value,1,1) == "[") then        
         _actionname = string.sub(_value, 2, string.find(_value,"%]")-1)
         --print("   Found Actionname=".._actionname)
         if (ROB_Rotations[_parsedRotationName]["SortedActions"][_actionname]) then _AlreadyExists = true; end
         if (not _AlreadyExists) then
         
            

            table.insert(ROB_Rotations[_parsedRotationName].SortedActions, _actionname);
            ROB_Rotations[_parsedRotationName].ActionList[_actionname] = {}
            for _defaultskey, _defaultsval in pairs(ROB_NewActionDefaults) do
               ROB_Rotations[_parsedRotationName].ActionList[_actionname][_defaultskey] = _defaultsval
            end
         end
      elseif (string.sub(_value,1,1) == "[" and (not string.find(_value,"%]"))) then
         _actionname = string.sub(_value, 2)
         --print("   Found bad Actionname=".._actionname)
         if (ROB_Rotations[_parsedRotationName]["SortedActions"][_actionname]) then _AlreadyExists = true; end
         if (not _AlreadyExists) then
         
            

            table.insert(ROB_Rotations[_parsedRotationName].SortedActions, _actionname);
            ROB_Rotations[_parsedRotationName].ActionList[_actionname] = {}
            for _defaultskey, _defaultsval in pairs(ROB_NewActionDefaults) do
               ROB_Rotations[_parsedRotationName].ActionList[_actionname][_defaultskey] = _defaultsval
            end
         end
      elseif (_actionname and _value ~= "" and string.find(_value,"=")) then
         --print("trying _value=".._value)
         _keyname = string.sub(_value,1,string.find(_value,"=")-1)
         _keyvalue = string.sub(_value,string.find(_value,"=")+1)
         _keyvalue = string.gsub(_keyvalue, "\\n", "\n")
         if (_keyvalue == "true") then _keyvalue = true; end
         if (_keyvalue == "false") then _keyvalue = false; end         
         --this value is a setting for the actionname
         ROB_Rotations[_parsedRotationName].ActionList[_actionname][_keyname] = _keyvalue
      end
   end
   
   -- update rotation list
   ROB_SortRotationList();

   -- update the action list
   ROB_ActionList_Update();
   
   -- update rotation modify buttons
   ROB_RotationModifyButtons_UpdateUI();
   
   -- update rotation ui stuff
   ROB_Rotation_Edit_UpdateUI();
   
   print(ROB_UI_IMPORT_SUCCESS..":".._parsedRotationName)
end

function ROB_RotationExportButton_OnClick()
   local RotationBuild = ROB_ExportRotation(ROB_SortedRotations[ROB_SelectedRotationIndex])
   if RotationBuild then
      ROB_GetString(ROB_UI_EXPORT_MESSAGE, RotationBuild)
   end
end

function ROB_ExportRotation(_RotationName)
   if (not _RotationName) or (_RotationName == "") then
      print("No rotation name specified for export")
      return
   elseif not ROB_Rotations[_RotationName] then
      print("Rotation name must be the name of an rotation build, and is case-sensitive.")
      return
   end

   -- Concatenate the rotation
   local RotationBuild = "RotationBuilder,v" .. ROB_VERSION .. ",[" .. _RotationName .. "]"

   local AddComma = false
   local SkipValue = false
   
   for ActionIndex, ActionName in pairs(ROB_Rotations[_RotationName].SortedActions) do
      RotationBuild = RotationBuild..",["..ActionName.."]"
      --print("Actionname:"..ActionName)
      for DefaultKey, DefaultValue in pairs(ROB_NewActionDefaults) do
--print("DefaultKey:"..DefaultKey)
      
         SkipValue = false
         if (ROB_Rotations[_RotationName].ActionList[ActionName][DefaultKey] == DefaultValue) then
            SkipValue = true
--if (string.find(DefaultKey,"b_rangecheck")) then print("    DefaultKey:"..DefaultKey.."=DefaultValue"); end
--print("  DefaultKey:"..DefaultKey.."=DefaultValue")
         end
         if (ROB_Rotations[_RotationName].ActionList[ActionName][DefaultKey] == nil) then
            SkipValue = true
         end
         if (DefaultKey == "v_durationstartedtime" or DefaultKey == "b_debug") then
            SkipValue = true
         end
         if (DefaultKey == "v_keybind" and (not ROB_Options.ExportBinds)) then
            SkipValue = true
         end
         if (not SkipValue) then
            if (string.sub(DefaultKey,1,2) == "b_") then
               if (ROB_Rotations[_RotationName].ActionList[ActionName][DefaultKey] == true) then
                  --print("    DefaultKey:"..DefaultKey.."getting set to true")
                  RotationBuild = RotationBuild..","..DefaultKey.."=true"
               else
                  --print("    DefaultKey:"..DefaultKey.."getting set to false")
                  RotationBuild = RotationBuild..","..DefaultKey.."=false"
               end
            else
               --print("    DefaultKey:"..DefaultKey)
               --print("    DefaultKey:"..DefaultKey.."getting set to"..ROB_Rotations[_RotationName].ActionList[ActionName][DefaultKey])
               RotationBuild = RotationBuild..","..DefaultKey.."="..ROB_Rotations[_RotationName].ActionList[ActionName][DefaultKey]
            end
         else
            --print("skipping value:"..DefaultKey)
         end
      end
   end
 
   RotationBuild = RotationBuild
   return RotationBuild
end

function ROB_CopyTable(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, _copy(object))
    end
    return _copy(object)
end

function ROB_EclipseDirection(_checkstring,_getnextspell)
   local direction = GetEclipseDirection()
   
   if direction == _checkstring then
      return true
   else
      return false
   end
end

function ROB_TotemActive(_totemname,_totemslot,_getnextspell)
   local _haveTotem, _totemName, _startTime, _duration = GetTotemInfo(_totemslot)
   if (not _totemName or _totemName== "") then
      return false
   else
      if (GetSpellInfo(_totemname) == _totemName) then return true; end
   end
   
   return false
end

function ROB_PetIsAutocasting(_spellname,_getnextspell)
   -- Iterate through the spells in the pet spellbook, if we have one.  
   local i = 1;
   local _spellslot = nil;
   local _spellType, _spellID
   local _convertedSpellName = nil


   --First try to get the spell info from the spellname
   if (GetSpellInfo(_spellname)) then
      _convertedSpellName = GetSpellInfo(_spellname)
   else
      --If the getspellinfo failed then use spellname
      _convertedSpellName = _spellname
   end

   --Now find the spellslot in the pet book
   while true do
      _spellID = nil
      
      if (not GetSpellBookItemInfo(i, BOOKTYPE_PET)) then
         do break end
      end
      
      _spellType, _spellID = GetSpellBookItemInfo(i, BOOKTYPE_PET);
      if (_spellID) then
         if (GetSpellInfo(_spellID) == _convertedSpellName) then
            _spellslot = i;
            do break end
         end
      end
      i=i+1;
   end
   
   --Now if we have a spellslot for the pet spell check if it is autocasting
   if (_spellslot) then
      if (select(2, GetSpellAutocast(_spellslot, "pet")) == 1) then
         return true
      end
   end
   
   return false
end


function ROB_TotemTimeleft(_totemtimeleft,_totemslot,_getnextspell)
   local _timeleftparsed = nil
   local _haveTotem, _totemName, _startTime, _duration = GetTotemInfo(_totemslot)   

   if (_startTime == nil) then
      return false
   end

   local _TotemTimeleft = (_startTime + _duration - GetTime())
   if _TotemTimeleft < 0 then _TotemTimeleft = 0 end  

   if (string.sub(_totemtimeleft,1,1) == "<" and string.sub(_totemtimeleft,1,2) ~= "<=") then
      _timeleftparsed = tonumber(string.sub(_totemtimeleft,2))
      if (_TotemTimeleft < _timeleftparsed) then return true; end
   end
   if (string.sub(_totemtimeleft,1,1) == ">" and string.sub(_totemtimeleft,1,2) ~= ">=") then
      _timeleftparsed = tonumber(string.sub(_totemtimeleft,2))
      if (_TotemTimeleft > _timeleftparsed) then return true; end
   end
   if (string.sub(_totemtimeleft,1,2) == ">=") then
      _timeleftparsed = tonumber(string.sub(_totemtimeleft,3))
      if (_TotemTimeleft >= _timeleftparsed) then return true; end
   end
   if (string.sub(_totemtimeleft,1,2) == "<=") then
      _timeleftparsed = tonumber(string.sub(_totemtimeleft,3))
      if (_TotemTimeleft <= _timeleftparsed) then return true; end
   end  
   if (string.sub(_totemtimeleft,1,1) == "=") then
      _timeleftparsed = tonumber(string.sub(_totemtimeleft,2))
      if (_TotemTimeleft == _timeleftparsed) then return true; end
   end
   
   return false
end

function ROB_PlayerHasComboPoints(_checkstring,_getnextspell)
   local _parsedCP = _checkstring
   local _unitCP = GetComboPoints("player", "target")
   
   if (string.sub(_parsedCP,1,1) == "<" and string.sub(_parsedCP,1,2) ~= "<=") then
      _parsedCP = tonumber(string.sub(_parsedCP,2))      
      if (_getnextspell and ROB_CURRENT_ACTION) then
         --Check if the current action generates a combo point
         local _generatesCP = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].b_gcombopoints
         if (_generatesCP and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints ~= "") then
            _generatesCP = tonumber(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints)
            if ((_unitCP + _generatesCP) < _parsedCP) then return true; end      
         else
            if (_unitCP < _parsedCP) then return true; end
         end     
      else
         if (_unitCP < _parsedCP) then return true; end
      end
   end
   if (string.sub(_parsedCP,1,1) == ">" and string.sub(_parsedCP,1,2) ~= ">=") then
      _parsedCP = tonumber(string.sub(_parsedCP,2))
      if (_getnextspell and ROB_CURRENT_ACTION) then
         --Check if the current action generates a combo point
         local _generatesCP = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].b_gcombopoints
         if (_generatesCP and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints ~= "") then
            _generatesCP = tonumber(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints)
            if ((_unitCP + _generatesCP) > _parsedCP) then return true; end      
         else
            if (_unitCP > _parsedCP) then return true; end
         end     
      else
         if (_unitCP > _parsedCP) then return true; end
      end
   end
   if (string.sub(_parsedCP,1,2) == ">=") then
      _parsedCP = tonumber(string.sub(_parsedCP,3))
      if (_getnextspell and ROB_CURRENT_ACTION) then
         --Check if the current action generates a combo point
         local _generatesCP = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].b_gcombopoints
         if (_generatesCP and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints ~= "") then
            _generatesCP = tonumber(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints)
            if ((_unitCP + _generatesCP) >= _parsedCP) then return true; end      
         else
            if (_unitCP >= _parsedCP) then return true; end
         end     
      else
         if (_unitCP >= _parsedCP) then return true; end
      end
   end
   if (string.sub(_parsedCP,1,2) == "<=") then
      _parsedCP = tonumber(string.sub(_parsedCP,3))
      if (_getnextspell and ROB_CURRENT_ACTION) then
         --Check if the current action generates a combo point
         local _generatesCP = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].b_gcombopoints
         if (_generatesCP and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints ~= "") then
            _generatesCP = tonumber(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints)
            if ((_unitCP + _generatesCP) <= _parsedCP) then return true; end      
         else
            if (_unitCP <= _parsedCP) then return true; end
         end     
      else
         if (_unitCP <= _parsedCP) then return true; end
      end
   end  
   if (string.sub(_parsedCP,1,1) == "=") then
      _parsedCP = tonumber(string.sub(_parsedCP,2))
      if (_getnextspell and ROB_CURRENT_ACTION) then
         --Check if the current action generates a combo point
         local _generatesCP = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].b_gcombopoints
         if (_generatesCP and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints ~= "") then
            _generatesCP = tonumber(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gcombopoints)
            if ((_unitCP + _generatesCP) == _parsedCP) then return true; end      
         else
            if (_unitCP == _parsedCP) then return true; end
         end     
      else
         if (_unitCP == _parsedCP) then return true; end
      end
   end
   
   return false
end

function ROB_CheckForDebuffType(_unitName,_magic,_poison,_disease,_curse)
   local debuffCount = 0
   for i = 1, 40 do
      local debuffName,_, debuff, debuffStack, debuffType = UnitDebuff("player", i)
      if (not debuff) then
         break
      end
      -- Types are Magic, Disease, Poison, Curse
      if (_magic and debuffType == "Magic") then     
         local exclude = ROB_ArcaneExclusions[debuffName]
         if (not exclude) then
            debuffCount = debuffCount + 1
         end
      end
      if (_poison and debuffType == "Poison") then     
         local exclude = ROB_ArcaneExclusions[debuffName]
         if (not exclude) then
            debuffCount = debuffCount + 1
         end
      end
      if (_disease and debuffType == "Disease") then     
         local exclude = ROB_ArcaneExclusions[debuffName]
         if (not exclude) then
            debuffCount = debuffCount + 1
         end
      end
      if (_curse and debuffType == "Curse") then     
         local exclude = ROB_ArcaneExclusions[debuffName]
         if (not exclude) then
            debuffCount = debuffCount + 1
         end
      end
   end
   
   if (debuffCount > 0) then
      return true
   else
      return false
   end
end

function ROB_UnitPassesLifeCheck(_checkstring,_unitName,_checkMax)
   local _lifeparsed = nil
   local _unitHP = 0

   if (string.find(_checkstring, "%%")) then
      _unitHP = math.floor(UnitHealth(_unitName)/UnitHealthMax(_unitName) * 100)
      _lifeparsed = string.sub(_checkstring,1,(string.find(_checkstring, "%%")-1))
   else
      if (_checkMax) then
         _unitHP = UnitHealthMax(_unitName)
      else
         _unitHP = UnitHealth(_unitName)
      end
      _lifeparsed = _checkstring
   end      
   
   if (string.sub(_lifeparsed,1,1) == "<" and string.sub(_lifeparsed,1,2) ~= "<=") then
      _lifeparsed = tonumber(string.sub(_lifeparsed,2))
      if (_unitHP < _lifeparsed) then return true; end
   end
   if (string.sub(_lifeparsed,1,1) == ">" and string.sub(_lifeparsed,1,2) ~= ">=") then
      _lifeparsed = tonumber(string.sub(_lifeparsed,2))
      if (_unitHP > _lifeparsed) then return true; end
   end
   if (string.sub(_lifeparsed,1,2) == ">=") then
      _lifeparsed = tonumber(string.sub(_lifeparsed,3))
      if (_unitHP >= _lifeparsed) then return true; end
   end
   if (string.sub(_lifeparsed,1,2) == "<=") then
      _lifeparsed = tonumber(string.sub(_lifeparsed,3))
      if (_unitHP <= _lifeparsed) then return true; end
   end  
   if (string.sub(_lifeparsed,1,1) == "=") then
      _lifeparsed = tonumber(string.sub(_lifeparsed,2))
      if (_unitHP == _lifeparsed) then return true; end
   end
   
   return false
end

function ROB_UnitPassesPowerCheck(_checkstring,_unitName,_powerType,_getnextspell)
   local _powerparsed = nil
   local _unitPower = 0

   if (string.find(_checkstring, "%%")) then
      _unitPower = math.floor(UnitPower(_unitName, _powerType)/UnitPowerMax(_unitName, _powerType) * 100)
      _powerparsed = string.sub(_checkstring,1,(string.find(_checkstring, "%%")-1))
   else
      _unitPower = UnitPower(_unitName, _powerType)
      _powerparsed = _checkstring
   end
   
   --After we get our unit power see if we should add some to predict next spell
   if (_getnextspell and ROB_CURRENT_ACTION) then
      local _generatesUP = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].b_gunitpower
      local _generatesUPtype = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gunitpowertype
      local _generatesUPamount = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gunitpower
      if (_generatesUP and _generatesUPtype and _generatesUPamount and (_generatesUPtype == _powerType)) then
         --Check if it generates a percentage
         if (string.find(_generatesUPamount, "%%")) then
            _generatesUPamount = string.sub(_generatesUPamount,1,(string.find(_generatesUPamount, "%%")-1))
         end
         _unitPower = _unitPower + tonumber(_generatesUPamount)
      end
   end
   
   
   if (string.sub(_powerparsed,1,1) == "<" and string.sub(_powerparsed,1,2) ~= "<=") then
      _powerparsed = tonumber(string.sub(_powerparsed,2))
      if (_unitPower < _powerparsed) then return true; end
   end
   if (string.sub(_powerparsed,1,1) == ">" and string.sub(_powerparsed,1,2) ~= ">=") then
      _powerparsed = tonumber(string.sub(_powerparsed,2))
      if (_unitPower > _powerparsed) then return true; end
   end
   if (string.sub(_powerparsed,1,2) == ">=") then
      _powerparsed = tonumber(string.sub(_powerparsed,3))
      if (_unitPower >= _powerparsed) then return true; end
   end
   if (string.sub(_powerparsed,1,2) == "<=") then
      _powerparsed = tonumber(string.sub(_powerparsed,3))
      if (_unitPower <= _powerparsed) then return true; end
   end  
   if (string.sub(_powerparsed,1,1) == "=") then
      _powerparsed = tonumber(string.sub(_powerparsed,2))
      if (_unitPower == _powerparsed) then return true; end
   end
   
   return false
end

function ROB_UnitPassesRuneCheck(_blood, _frost, _unholy, _allowdeath, _getnextspell)
   
   if (select(2, UnitClass("player")) == "DEATHKNIGHT") then
      deathRuneCount = 0
      bloodRuneCount = 0
      frostRuneCount = 0
      unholyRuneCount = 0
      
      --1 : RUNETYPE_BLOOD 
      --2 : RUNETYPE_CHROMATIC 
      --3 : RUNETYPE_FROST 
      --4 : RUNETYPE_DEATH 

      for i = 1, 6 do
         _start, _duration, _runeReady = GetRuneCooldown(i)
         if (GetRuneType(i) == 1 and _runeReady) then
            bloodRuneCount = bloodRuneCount + 1
         elseif (GetRuneType(i) == 2 and _runeReady) then
            unholyRuneCount = unholyRuneCount + 1       
         elseif (GetRuneType(i) == 3 and _runeReady) then
            frostRuneCount = frostRuneCount + 1
         elseif (GetRuneType(i) == 4 and _runeReady) then
            deathRuneCount = deathRuneCount + 1
         end
      end
      
      --After we have our rune counts check if the current action is going to add a rune
      if (_getnextspell and ROB_CURRENT_ACTION) then
         local _generatesBlood  = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].b_gbloodrunes
         local _generatesFrost  = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].b_gfrostrunes
         local _generatesUnholy = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].b_gunholyrunes
         local _generatesDeath  = ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].b_gdeathrunes
         if (_generatesBlood and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gbloodrunes) then 
            _generatesBlood = tonumber(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gbloodrunes)
            bloodRuneCount = bloodRuneCount + _generatesBlood
         end
         if (_generatesFrost and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gfrostrunes) then 
            _generatesFrost = tonumber(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gfrostrunes)
            frostRuneCount = frostRuneCount + _generatesFrost
         end
         if (_generatesUnholy and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gunholyrunes) then 
            _generatesUnholy = tonumber(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gunholyrunes)
            unholyRuneCount = unholyRuneCount + _generatesUnholy
         end
         if (_generatesDeath and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gdeathrunes) then 
            _generatesDeath = tonumber(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_gdeathrunes)
            deathRuneCount = deathRuneCount + _generatesDeath
         end
      end
      
      
      if (_allowdeath) then
         if (_blood and (deathRuneCount + bloodRuneCount) >= tonumber(_blood)) then return true; end
         if (_frost and (deathRuneCount + frostRuneCount) >= tonumber(_frost)) then return true; end
         if (_unholy and (deathRuneCount + unholyRuneCount) >= tonumber(_unholy)) then return true; end
      else
         if (_blood and bloodRuneCount >= tonumber(_blood)) then return true; end
         if (_frost and frostRuneCount >= tonumber(_frost)) then return true; end
         if (_unholy and unholyRuneCount >= tonumber(_unholy)) then return true; end
      end
   end
   
   return false
end

function ROB_SpellPassesOtherCooldownCheck(_othercd, _checkstring)
   local _cooldownparsed = nil
   
   local _start, _duration = GetSpellCooldown(_othercd)   
   if (_start == nil) then
      return false
   end

   local _cooldownLeft = (_start + _duration - GetTime())
   if _cooldownLeft < 0 then _cooldownLeft = 0 end  

   if (string.sub(_checkstring,1,1) == "<" and string.sub(_checkstring,1,2) ~= "<=") then
      _cooldownparsed = tonumber(string.sub(_checkstring,2))
      if (_cooldownLeft < _cooldownparsed) then return true; end
   end
   if (string.sub(_checkstring,1,1) == ">" and string.sub(_checkstring,1,2) ~= ">=") then
      _cooldownparsed = tonumber(string.sub(_checkstring,2))
      if (_cooldownLeft > _cooldownparsed) then return true; end
   end
   if (string.sub(_checkstring,1,2) == ">=") then
      _cooldownparsed = tonumber(string.sub(_checkstring,3))
      if (_cooldownLeft >= _cooldownparsed) then return true; end
   end
   if (string.sub(_checkstring,1,2) == "<=") then
      _cooldownparsed = tonumber(string.sub(_checkstring,3))
      if (_cooldownLeft <= _cooldownparsed) then return true; end
   end  
   if (string.sub(_checkstring,1,1) == "=") then
      _cooldownparsed = tonumber(string.sub(_checkstring,2))
      if (_cooldownLeft == _cooldownparsed) then return true; end
   end
   
   return false
end


function ROB_UnitHasDebuff(_debuffNeeded, _unitName, _getnextspell)
   local _unithasdebuffs = false
   local _spellexists = false
   local _sourcecheckpassed = false
   local _stackcheckpassed = false

   local _unparsedDebuff = nil
   local _remainingDebuffs = _debuffNeeded
   local _spellparsedstacks = 0
   local _timeleft = 0
   local _debuffcount = 0
   local _debuffsfound = 0
   local _doneparsing = false
   local _stringtype = 0
   local _name, _rank, _icon, _count, _debuffType, _duration, _expirationTime, _unitCaster, _isStealable, _shouldConsolidate, _spellId  
   
   while not _doneparsing do
      _unparsedDebuff = nil
--print("parsing _remainingDebuffs=".._remainingDebuffs)
      if (string.find(_remainingDebuffs, "|")) then
         _unparsedDebuff   = string.sub(_remainingDebuffs,1,string.find(_remainingDebuffs, "|")-1)
--print("  found| so _unparsedDebuff=".._unparsedDebuff)
         _debuffcount      = _debuffcount + 1
         _remainingDebuffs = string.sub(_remainingDebuffs,string.find(_remainingDebuffs, "|")+2)
--print("  found| so _remainingDebuffs=".._remainingDebuffs)
         _stringtype = 1
      elseif (string.find(_remainingDebuffs, "&")) then
--print("  found & so _remainingDebuffs=".._remainingDebuffs)
         _unparsedDebuff   = string.sub(_remainingDebuffs,1,string.find(_remainingDebuffs, "&")-1)
         _debuffcount      = _debuffcount + 1
         _remainingDebuffs = string.sub(_remainingDebuffs,string.find(_remainingDebuffs, "&")+1)
         _stringtype = 2
      else
--print("  foundnothing so we are done")
         _unparsedDebuff   = _remainingDebuffs
         _debuffcount      = _debuffcount + 1
         _doneparsing      = true
      end

      
--print("_unparsedDebuff=".._unparsedDebuff)
      _spellexists = false
      _sourcecheckpassed = false
      _stackcheckpassed = false
      _timeleftcheckpassed = false
      
      --if the debuff has a _ in it that means source needs to be the player
      if (string.find(_unparsedDebuff, "_")) then
         _unparsedDebuff = string.sub(_unparsedDebuff,2)
         _sourceunitparsed = "player"
      else
         --_unparsedDebuff = _unparsedDebuff
         _sourceunitparsed = nil
      end

      if (string.find(_unparsedDebuff, "%^")) then
         _spellparsedseconds = tonumber(string.sub(_unparsedDebuff,(string.find(_unparsedDebuff, "%^")+1)))
         _unparsedDebuff = string.sub(_unparsedDebuff,1,(string.find(_unparsedDebuff, "%^")-1))
      else
         _spellparsedseconds = 0
      end
       
      if (string.find(_unparsedDebuff, "#")) then
         _spellparsedstacks = tonumber(string.sub(_unparsedDebuff,(string.find(_unparsedDebuff, "#")+1)))
         _unparsedDebuff = string.sub(_unparsedDebuff,1,(string.find(_unparsedDebuff, "#")-1))
      else
         _spellparsedstacks = 0
      end

      if (_unparsedDebuff ~= nil) then
         for i = 1, 40 do
            _name, _rank, _icon, _count, _debuffType, _duration, _expirationTime, _unitCaster, _isStealable, _shouldConsolidate, _spellId = UnitDebuff(_unitName, i)
            if (_name ~= nil and (_name == GetSpellInfo(_unparsedDebuff) or _name == _unparsedDebuff)) then
               _spellexists = true

               if (_sourceunitparsed ~= nil) then
                  if (_sourceunitparsed == _unitCaster) then
                     _sourcecheckpassed = true
                  end
               else
                  _sourcecheckpassed = true
               end

               if (_spellparsedstacks > 0) then
                  if (_count and _count >= _spellparsedstacks) then
                     _stackcheckpassed = true
                  end
               else
                  _stackcheckpassed = true
               end

               _timeleft = _expirationTime - GetTime()
               if _timeleft < 0 then _timeleft = 0; end

               --set the action cooldown to the time left on the debuff minus the refresh time specified
--print(_spellparsedseconds)
               if (_timeleft < _spellparsedseconds) then
                  ROB_ACTION_TIMELEFT = _timeleft
               else
                  ROB_ACTION_TIMELEFT = _timeleft - _spellparsedseconds
               end    

               if (_spellparsedseconds > 0) then
                  if (_timeleft >= _spellparsedseconds) then
                     _timeleftcheckpassed = true
                  end
               else
                  _timeleftcheckpassed = true
               end

               if (_spellexists and _sourcecheckpassed and _stackcheckpassed and _timeleftcheckpassed) then  _debuffsfound = _debuffsfound +1; end
            end
         end
      else
         --spellparsed does not exist maybe warn the player in the future they need to retype in the debuffs field     
      end     
   end
   
   if (_stringtype == 0 and (_debuffsfound >= 1)) then
      _unithasdebuffs = true      
   end
   if (_stringtype == 1 and (_debuffsfound >= 1)) then
      _unithasdebuffs = true
   end
   if (_stringtype == 2 and (_debuffsfound == _debuffcount)) then
      _unithasdebuffs = true
   end
   
   return _unithasdebuffs
end

function ROB_CheckForWeaponEnchant(_slot, _checkstring)
   local _enchantparsedseconds = 0
   local _timeleftpassed = false
   local _timeleft = 0
   local _enchantpassed = false
   local _enchantparsed = _checkstring
   
      
   local _hasMainHandEnchant, _mainHandExpiration, _mainHandCharges, _hasOffHandEnchant, _offHandExpiration, _offHandCharges = GetWeaponEnchantInfo()
   
   if (_slot == 16 and (not _hasMainHandEnchant)) then return false; end
   if (_slot == 17 and (not _hasOffHandEnchant)) then return false; end
   
   if (_slot == 16) then _timeleft = GetTime() + _mainHandExpiration / 1000; end
   if (_slot == 17) then _timeleft = GetTime() + _offHandExpiration / 1000; end
   
   if (string.find(_enchantparsed, "%^")) then
      _enchantparsedseconds = tonumber(string.sub(_spellparsed,(string.find(_spellparsed, "%^")+1)))
      _enchantparsed = string.sub(_enchantparsed,1,(string.find(_enchantparsed, "%^")-1))
   else
      _enchantparsedseconds = 0
   end

   ROB_Tooltip:SetOwner(UIParent, "ANCHOR_NONE");
   ROB_Tooltip:SetInventoryItem("player", _slot);
   
   local _lefttext = nil
   local _righttext = nil
   local _parsedline = nil
   for _ttline = 1, ROB_Tooltip:NumLines() do
      _lefttext = getglobal("ROB_TooltipTextLeft".._ttline);
      _lefttext = _lefttext:GetText()
      if _lefttext then _parsedline = "".._lefttext; end
      
      _righttext = getglobal("ROB_TooltipTextLeft".._ttline);
      _righttext = _righttext:GetText()
      if _righttext then _parsedline = _parsedline.._righttext; end
          
      if (_parsedline ~= "") then
         if (string.find(_parsedline, _enchantparsed)) then
            ROB_Tooltip:Hide();
            _enchantpassed = true
         end
      end
   end   
   ROB_Tooltip:Hide();

   if (_timeleft >= _enchantparsedseconds and _enchantpassed) then
      return true;
   end
   
   return false;     
end

function ROB_UnitHasBuff(_buffNeeded, _unitName, _getnextspell)
   local _unithasbuffs = false
   local _spellexists = false
   local _sourcecheckpassed = false
   local _stackcheckpassed = false

   local _unparsedBuff = nil
   local _remainingBuffs = _buffNeeded
   local _spellparsedstacks = 0
   local _timeleft = 0
   local _buffcount = 0
   local _buffsfound = 0
   local _doneparsing = false
   local _name, _rank, _icon, _count, _debuffType, _duration, _expirationTime, _unitCaster, _isStealable, _shouldConsolidate, _spellId  
   local _stringtype = 0
   
   while not _doneparsing do
      _unparsedBuff = nil
      if (string.find(_remainingBuffs, "|")) then
         _unparsedBuff   = string.sub(_remainingBuffs,1,string.find(_remainingBuffs, "|")-1)
         _buffcount      = _buffcount + 1
         _remainingBuffs = string.sub(_remainingBuffs,string.find(_remainingBuffs, "|")+2)
         _stringtype = 1
      elseif (string.find(_remainingBuffs, "&")) then
         _unparsedBuff   = string.sub(_remainingBuffs,1,string.find(_remainingBuffs, "&")-1)
         _buffcount      = _buffcount + 1
         _remainingBuffs = string.sub(_remainingBuffs,string.find(_remainingBuffs, "&")+1)        
         _stringtype = 2
      else
         _unparsedBuff   = _remainingBuffs
         _buffcount      = _buffcount + 1
         _doneparsing    = true
      end
--print("Checking for _unparsedBuff=".._unparsedBuff)

      _spellexists = false
      _sourcecheckpassed = false
      _stackcheckpassed = false
      _timeleftcheckpassed = false

      --if the buff has a _ in it that means source needs to be the player
      if (string.find(_unparsedBuff, "_")) then
         _unparsedBuff = string.sub(_unparsedBuff,2)
         _sourceunitparsed = "player"
      else
         _unparsedBuff = _unparsedBuff
         _sourceunitparsed = nil
      end

      if (string.find(_unparsedBuff, "%^")) then
         _spellparsedseconds = tonumber(string.sub(_unparsedBuff,(string.find(_unparsedBuff, "%^")+1)))
         _unparsedBuff = string.sub(_unparsedBuff,1,(string.find(_unparsedBuff, "%^")-1))
      else
         _spellparsedseconds = 0
      end

      if (string.find(_unparsedBuff, "#")) then
         _spellparsedstacks = tonumber(string.sub(_unparsedBuff,(string.find(_unparsedBuff, "#")+1)))
         _unparsedBuff = string.sub(_unparsedBuff,1,(string.find(_unparsedBuff, "#")-1))
      else
         _spellparsedstacks = 0
      end

      if (_unparsedBuff ~= nil) then
         --Unitbuff can not take a spellid as a parameter so we have to try the _unparsedBuff first and if that fails then try to convert the _unparsedBuff to a spellname
         _name, _rank, _icon, _count, _debuffType, _duration, _expirationTime, _unitCaster, _isStealable, _shouldConsolidate, _spellId = UnitBuff(_unitName, _unparsedBuff)
         if (not _name and GetSpellInfo(_unparsedBuff)) then
            _name, _rank, _icon, _count, _debuffType, _duration, _expirationTime, _unitCaster, _isStealable, _shouldConsolidate, _spellId = UnitBuff(_unitName, GetSpellInfo(_unparsedBuff))
         end
         
         if (_name ~= nil and (_name == GetSpellInfo(_unparsedBuff) or _name == _unparsedBuff)) then
            _spellexists = true


            if (_sourceunitparsed ~= nil) then
               if (_sourceunitparsed == _unitCaster) then
                  _sourcecheckpassed = true
               end
            else
               _sourcecheckpassed = true
            end

            if (_spellparsedstacks > 0) then
               if (_count and _count >= _spellparsedstacks) then
                  _stackcheckpassed = true
               end
            else
               _stackcheckpassed = true
            end

            _timeleft = _expirationTime - GetTime()
            if _timeleft < 0 then _timeleft = 0; end

            --set the action cooldown to the time left on the buff minus the refresh time specified
            if (_timeleft < _spellparsedseconds) then
               ROB_ACTION_TIMELEFT = _timeleft
            else
               ROB_ACTION_TIMELEFT = _timeleft - _spellparsedseconds
            end    

            if (_spellparsedseconds > 0) then
               if (_timeleft >= _spellparsedseconds) then
                  _timeleftcheckpassed = true
               end
            else
               _timeleftcheckpassed = true
            end

            if (_spellexists and _sourcecheckpassed and _stackcheckpassed and _timeleftcheckpassed) then
               _buffsfound = _buffsfound +1
            end

         end

      else
         --spellparsed does not exist maybe warn the player in the future
      end
   end
   
   if (_stringtype == 0 and (_buffsfound >= 1)) then
      _unithasbuffs = true      
   end
   if (_stringtype == 1 and (_buffsfound >= 1)) then
      _unithasbuffs = true
   end
   if (_stringtype == 2 and (_buffsfound == _buffcount)) then
      _unithasbuffs = true
   end

   return _unithasbuffs
end



function ROB_GetActionTintColor(_actionname)
   local _ActionDB = ROB_Rotations[ROB_SelectedRotationName].ActionList[_actionname]
   local _r = nil
   local _g = nil
   local _b = nil
   local _i = 1
   if (_ActionDB.v_rangespell and _ActionDB.v_rangespell ~=nil and _ActionDB.v_rangespell ~="") then
      --We have a rotation range spellname lets parse out the hex code if needed
      if (string.find(_ActionDB.v_rangespell, "%#")) then
         local _data = { strsplit("#", string.sub(_ActionDB.v_rangespell, string.find(_ActionDB.v_rangespell, "%#")+1)) }   
         for _key,_value in pairs(_data) do
            if (_i == 1) then _r = _value; end
            if (_i == 2) then _g = _value; end
            if (_i == 3) then _b = _value; end
            _i = _i + 1
         end
      else
         --no hex color code in the rangespell so let the function return nil
      end
   end
   return _r, _g, _b
end

function ROB_ClearNextAction()
   ROB_CurrentActionTint:SetTexture()
   ROB_NextActionTint:SetTexture()
   ROB_NextActionLabel:SetText()
   ROB_NextActionTexture:SetTexture()
   if (ROB_NextActionTexture:GetTexture() ~= "") then ROB_NextActionFrame_Cooldown:Hide(); end
end

function ROB_GetActionTexture(_actionname)
   local _ActionDB = ROB_Rotations[ROB_SelectedRotationName].ActionList[_actionname]
   
   if ((not GetTexturePath(_ActionDB.v_actionicon)) or (_ActionDB.v_actionicon == "")) then
      return GetTexturePath(_ActionDB.v_spellname)
   else
      return GetTexturePath(_ActionDB.v_actionicon)
   end
end

function ROB_SetNextActionTexture(_compareaction)
   local _ActionDB = ROB_Rotations[ROB_SelectedRotationName].ActionList[_compareaction]
   local _r = nil
   local _g = nil
   local _b = nil
   local _texture = nil
   
   if (not UnitExists("target")) then
      ROB_NextActionTexture:SetTexture()
   else
      if (not _compareaction) then
         ROB_NextActionTexture:SetTexture()
         return
      end
      if (_ActionDB.b_rangecheck) then
         --range check turned on : have ready next action : determine if _compareaction is in range
         if (ROB_ActionInRange(_compareaction,"target")) then
            --range check turned on : action in range
            if (ROB_NextActionTexture:GetTexture() ~= ROB_GetActionTexture(_compareaction)) then ROB_NextActionTexture:SetTexture(ROB_GetActionTexture(_compareaction)); end
         else
            --range check turned on : action oor : determine if we display tint or oor texture
            _r, _g, _b = ROB_GetActionTintColor(_compareaction)
            if (_r) then
               --range check turned on : action oor : tint color specified : set the texture to the action texture
               if (ROB_NextActionTexture:GetTexture() ~= ROB_GetActionTexture(_compareaction)) then ROB_NextActionTexture:SetTexture(ROB_GetActionTexture(_compareaction)); end
            else
               --range check turned on : action oor : no tint color specified : set the texture to the oor texture
               if (ROB_NextActionTexture:GetTexture() ~= GetTexturePath("6544")) then ROB_NextActionTexture:SetTexture(GetTexturePath("6544")); end
            end
         end
      else
         --range check turned off : display action texture
         if (ROB_NextActionTexture:GetTexture() ~= ROB_GetActionTexture(_compareaction)) then ROB_NextActionTexture:SetTexture(ROB_GetActionTexture(_compareaction)); end
      end
   end
end

function ROB_SetCurrentActionTexture(_compareaction)
   local _ActionDB = ROB_Rotations[ROB_SelectedRotationName].ActionList[_compareaction]
   local _r = nil
   local _g = nil
   local _b = nil
   local _texture = nil
   
   if (not UnitExists("target")) then
      ROB_CurrentActionTexture:SetTexture()
   else
      if (not _compareaction) then
         ROB_CurrentActionTexture:SetTexture()
         return
      end
      if (ROB_CurrentActionTexture:GetTexture() ~= ROB_GetActionTexture(_compareaction)) then
         ROB_CurrentActionTexture:SetTexture(ROB_GetActionTexture(_compareaction));
      
      end
   end
end

function ROB_SetNextActionTint(_compareaction)
   local _r = nil
   local _g = nil
   local _b = nil
   local _texture = nil
   if (not UnitExists("target")) then
      ROB_NextActionTint:SetTexture()
   else
      if (not _compareaction) then
         -- have target but no next action ready so clear it
         ROB_NextActionTint:SetTexture()
         return
      end
      if (ROB_ActionInRange(_compareaction,"target")) then
         -- action in range
         ROB_NextActionTint:SetTexture()
      else
         --range check turned on : action oor : determine if we display tint or oor texture
         _r, _g, _b = ROB_GetActionTintColor(_compareaction)
         if (_r) then
            --tint turned on : action oor : tint color specified : set the tint
            ROB_NextActionTint:SetTexture(_r, _g, _b, .3)
         else
            --tint turned off : action oor : no tint color specified : clear tint
            ROB_NextActionTint:SetTexture()
         end
      end
   end
end

function ROB_SetCurrentActionTint(_compareaction)
   local _r = nil
   local _g = nil
   local _b = nil
   local _texture = nil
   if (not UnitExists("target")) then
      ROB_CurrentActionTint:SetTexture()
   else
      if (not _compareaction) then
         -- have target but no next action ready so clear it
         ROB_CurrentActionTint:SetTexture()
         return
      end
      if (ROB_ActionInRange(_compareaction,"target")) then
         -- action in range
         ROB_CurrentActionTint:SetTexture()
      else
         --action oor : determine if we display tint or oor texture
         _r, _g, _b = ROB_GetActionTintColor(_compareaction)
         if (_r) then
            --tint turned on : action oor : tint color specified : set the tint
            ROB_CurrentActionTint:SetTexture(_r, _g, _b, .3)
         else
            --tint turned off : action oor : no tint color specified : clear tint
            ROB_CurrentActionTint:SetTexture()
         end
      end
   end
end

function ROB_SetNextActionLabel(_compareaction)  
   local _ActionDB = ROB_Rotations[ROB_SelectedRotationName].ActionList[_compareaction]
   local _r = nil
   local _g = nil
   local _b = nil
   local _texture = nil
   

   if (not UnitExists("target")) then
      ROB_NextActionLabel:SetText()
   else
      if (not _compareaction) then
         ROB_NextActionLabel:SetText()
         return
      end
      if (_ActionDB.b_rangecheck) then
         --range check turned on : have ready next action : determine if _compareaction is in range
         if (ROB_ActionInRange(_compareaction,"target")) then
            --range check turned on : action in range
            if (ROB_NextActionLabel:GetText() ~= _ActionDB.v_keybind and _ActionDB.v_keybind ~= ROB_UI_KEYBIND) then ROB_NextActionLabel:SetText(_ActionDB.v_keybind); end
         else
            --range check turned on : action oor : determine if we display tint or oor texture
            _r, _g, _b = ROB_GetActionTintColor(_compareaction)
            if (_r) then
               --range check turned on : action oor : tint color specified : set the text to the action keybind
               if (ROB_NextActionLabel:GetText() ~= _ActionDB.v_keybind and _ActionDB.v_keybind ~= ROB_UI_KEYBIND) then ROB_NextActionLabel:SetText(_ActionDB.v_keybind); end
            else
               --range check turned on : action oor : no tint color specified : clear the text
               ROB_NextActionLabel:SetText()
            end
         end
      else
         --range check turned off : display action keybind
         if (ROB_NextActionLabel:GetText() ~= _ActionDB.v_keybind and _ActionDB.v_keybind ~= ROB_UI_KEYBIND) then ROB_NextActionLabel:SetText(_ActionDB.v_keybind); end
      end
   end
end

function ROB_SetCurrentActionLabel(_compareaction)  
   local _ActionDB = ROB_Rotations[ROB_SelectedRotationName].ActionList[_compareaction]
   local _r = nil
   local _g = nil
   local _b = nil
   local _texture = nil
   

   if (not UnitExists("target")) then
      ROB_CurrentActionLabel:SetText()
   else
      if (not _compareaction) then
         ROB_CurrentActionLabel:SetText()
         return
      end
      if (ROB_CurrentActionLabel:GetText() ~= _ActionDB.v_keybind and _ActionDB.v_keybind ~= ROB_UI_KEYBIND) then ROB_CurrentActionLabel:SetText(_ActionDB.v_keybind); end
   end
end

function ROB_SetNextActionCooldown(_compareaction, _compareactioncd)
   local _ActionDB = ROB_Rotations[ROB_SelectedRotationName].ActionList[_compareaction]
   local _r = nil
   local _g = nil
   local _b = nil
   local _texture = nil
   

   if (not UnitExists("target")) then
      if (ROB_NextActionTexture:GetTexture() ~= nil) then ROB_NextActionFrame_Cooldown:SetCooldown(GetTime(), 0); end
   else
      if (not _compareaction) then
         if (ROB_NextActionTexture:GetTexture() ~= nil) then ROB_NextActionFrame_Cooldown:SetCooldown(GetTime(), 0); end
         return
      end
      if (_ActionDB.b_rangecheck) then
         --range check turned on : have ready next action : determine if _compareaction is in range
         if (ROB_ActionInRange(_compareaction,"target")) then
            --range check turned on : action in range
            if (ROB_NextActionTexture:GetTexture() ~= ROB_GetActionTexture(_compareaction)) then ROB_NextActionFrame_Cooldown:SetCooldown(GetTime(), _compareactioncd); end
         else
            --range check turned on : action oor : determine if we display tint or oor texture
            _r, _g, _b = ROB_GetActionTintColor(_compareaction)
            if (_r) then
               --range check turned on : action oor : tint color specified : set the cooldown to action cooldown
               if (ROB_NextActionTexture:GetTexture() ~= ROB_GetActionTexture(_compareaction)) then ROB_NextActionFrame_Cooldown:SetCooldown(GetTime(), _compareactioncd); end
            else
               --range check turned on : action oor : no tint color specified : set the cooldown to nothing
               if (ROB_NextActionTexture:GetTexture() ~= GetTexturePath("6544")) then ROB_NextActionFrame_Cooldown:SetCooldown(GetTime(), 0); end
            end
         end
      else
         --range check turned off : display action cooldown
         if (ROB_NextActionTexture:GetTexture() ~= ROB_GetActionTexture(_compareaction)) then ROB_NextActionFrame_Cooldown:SetCooldown(GetTime(), _compareactioncd); end
      end
   end
end

function ROB_SetCurrentActionCooldown(_compareaction, _compareactioncd)
   local _ActionDB = ROB_Rotations[ROB_SelectedRotationName].ActionList[_compareaction]
   local _r = nil
   local _g = nil
   local _b = nil
   local _texture = nil
   
   if (not UnitExists("target")) then
      if (ROB_CurrentActionTexture:GetTexture() ~= nil) then ROB_CurrentActionFrame_Cooldown:SetCooldown(GetTime(), 0); end
   else
      if (not _compareaction) then
         if (ROB_CurrentActionTexture:GetTexture() ~= nil) then ROB_CurrentActionFrame_Cooldown:SetCooldown(GetTime(), 0); end
         return
      end
      if (ROB_CurrentActionTexture:GetTexture() ~= ROB_GetActionTexture(_compareaction)) then ROB_CurrentActionFrame_Cooldown:SetCooldown(GetTime(), _compareactioncd); end
   end
end


function ROB_ActionInRange(_actionname,_unit)
   local _ActionDB = ROB_Rotations[ROB_SelectedRotationName].ActionList[_actionname]
   local _rangespell = _ActionDB.v_rangespell
   
   if (not UnitExists("target")) then
      --the action doesnt check range so return true that it is in range
      --there is no target so return true we are in range
      return true
   end
   if (_rangespell and _rangespell ~=nil and _rangespell ~="") then
      --We have a rotation range spellname lets parse out the hex code if needed
      if (string.find(_rangespell, "%#")) then
         --rangespell has tint color parse it
         _rangespell = string.sub(_rangespell, 1, string.find(_rangespell, "%#")-1)
         --after we strip the hex color if there is nothing left use the spellname instead
         if (not _rangespell or _rangespell == "") then
            _rangespell = _ActionDB.v_spellname
         end
         --remove the next line to allow range checking in tinted actions
         --return true
      else
         --rangespell does not have tint color but is already set to v_rangespell so no further actions necessary
      end
   else
      --rangespell is blank but checkrange is true set the range spell to the spellname
      _rangespell = _ActionDB.v_spellname
   end
   
   --Try to use the getspellinfo to get the spell range
   if (_rangespell and GetSpellInfo(_rangespell)) then
      _rangespell = GetSpellInfo(_rangespell)
      if (IsSpellInRange(_rangespell,_unit) == 1) then      
         return true
      end
   else
      --The getspellinfo failed so try just the spell name
      if (_rangespell and IsSpellInRange(_rangespell,_unit) == 1) then
         return true
      end
   end
   return false
end

function ROB_SpellReady(_actionname,_getnextspell)
   local _ready          = true
   local _GCDleft        = nil
   local _cooldownLeft   = nil
   local _startGCD       = nil
   local _inGCD          = nil
   local _start          = nil
   local _duration       = nil
   local _myHPP          = math.floor(UnitHealth("player")/UnitHealthMax("player") * 100)
   local _moHPP          = math.floor(UnitHealth("mouseover")/UnitHealthMax("mouseover") * 100)
   local _targetHPP      = math.floor(UnitHealth("target")/UnitHealthMax("target") * 100)
   local _targetCasting  = nil
   local _hasbeencasting = nil
   local _startTime      = nil
   local _debugon        = false
   local _spellname      = nil
   local deathRuneCount  = 0
   local bloodRuneCount  = 0
   local frostRuneCount  = 0
   local unholyRuneCount = 0
   local _name, _rank, _nomana, _usable, _channeling, _icon, _cost, _isFunnel, _powerType, _castTime, _minRange, _maxRange
   local _checkmagic     = false
   local _checkpoison    = false
   local _checkdisease   = false
   local _checkcurse     = false
   local _ActionDB = ROB_Rotations[ROB_SelectedRotationName].ActionList[_actionname]
   
   if (_ActionDB.b_debug ~= nil and _ActionDB.b_debug) then
      _debugon = _ActionDB.b_debug
--print("debug on for ".._actionname)
   end
   _spellname = _ActionDB.v_spellname
   if (_spellname == nil or _spellname == "" or _spellname == "<spellname>") then
      _spellname = "<spellname>"
   end   

   -- CHECK: Toggles first otherwise we might exit before updating textures------------------------------------------------------------------
   if (_ActionDB.b_toggle) then
      -- Verify the toggle is turned on otherwise fail the ready
      if (_ActionDB.v_togglename == "Toggle 1") then
         ROB_RotationToggle1Texture:SetTexture(GetTexturePath(_ActionDB.v_toggleicon))
         if (ROB_TOGGLE_1 == 0) then
            _ready = false;
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." T:".._ActionDB.v_togglename.." is off",_ready,_debugon)
         end
      elseif (_ActionDB.v_togglename == "Toggle 2") then
         ROB_RotationToggle2Texture:SetTexture(GetTexturePath(_ActionDB.v_toggleicon))
         if (ROB_TOGGLE_2 == 0) then
            _ready = false;
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." T:".._ActionDB.v_togglename.." is off",_ready,_debugon)
         end
      elseif (_ActionDB.v_togglename == "Toggle 3") then
         ROB_RotationToggle3Texture:SetTexture(GetTexturePath(_ActionDB.v_toggleicon))
         if (ROB_TOGGLE_3 == 0) then
            _ready = false;
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." T:".._ActionDB.v_togglename.." is off",_ready,_debugon)
         end
      elseif (_ActionDB.v_togglename == "Toggle 4") then
         ROB_RotationToggle4Texture:SetTexture(GetTexturePath(_ActionDB.v_toggleicon))
         if (ROB_TOGGLE_4 == 0) then
            _ready = false;
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." T:".._ActionDB.v_togglename.." is off",_ready,_debugon)
         end
      end
   end

   if (not _ready) then return false; end
   -- CHECK: if the action is enabled---------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_disabled) then
      ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." because the action is disabled",false,_debugon)  
      return false
   end

   -- CHECK: Check spell stuff-----------------------------------------------------------------------------------------------------------------------------
   if (not _ActionDB.b_notaspell and _ActionDB.v_spellname) then
      _name, _rank, _icon, _cost, _isFunnel, _powerType, _castTime, _minRange, _maxRange = GetSpellInfo(_ActionDB.v_spellname)
      if (_name == nil) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._ActionDB.v_spellname.." because this spellname is not available or does not exist due to talents or something. Check spelling or try using the spellid from wowhead instead.",false,_debugon)
         return false
      end
      _usable, _nomana = IsUsableSpell(_ActionDB.v_spellname)
      if (_usable ~= 1 or _nomana == 1) then
         --The default is to show spells even if you dont have mana/rage/ whatever power to cast it, if player wants a power check they can use the power check in player tab
         if (not _getnextspell and _usable ~= 1 and _nomana ~= 1) then
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." is not usable or you dont have enough power. Check the spellname in the General Tab.",false,_debugon)
            return false
         end
         --Even when we are getting the next spell we dont want to say its ready when its not usable because not usable means we dont have the spell
         if (_getnextspell and (not _usable) and _nomana ~= 1) then
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." is not usable or you dont have enough power. Check the spellname in the General Tab.",false,_debugon)
            return false
         end
      end
   end

   -- CHECK: Cooldown-----------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.v_gcdspell ~= -1 and _ActionDB.v_spellname) then
      if (_ActionDB.v_gcdspell ~= nil and _ActionDB.v_gcdspell ~= "") then
         _startGCD, _inGCD = GetSpellCooldown(_ActionDB.v_gcdspell)
         if (_startGCD ~= nil) then
            _GCDleft = (_startGCD + _inGCD - GetTime())
            if _GCDleft < 0 then _GCDleft = 0 end
         else
            _GCDleft = 1.5
         end
      else
         _GCDleft = 1.5
      end
   end
   --Even if v_gcdspell is set to -1 make sure to set the cooldown for current action and next action determination
   _start, _duration = GetSpellCooldown(_ActionDB.v_spellname)   
   if (_start == nil) then
      _start, _duration, _ = GetInventoryItemCooldown("player", tonumber(_InvSlots[_ActionDB.v_spellname]))
   end
   if (_start == nil) then
      --we failed to get the cooldown on the spell for whatever reason, instead of defaulting to ready change it to not ready
      _start = GetTime()
      _duration = 86300
   end

   _cooldownLeft = (_start + _duration - GetTime())
   if _cooldownLeft < 0 then _cooldownLeft = 0 end

   ROB_ACTION_CD = _cooldownLeft
   --We set the cooldown left on the spell to the action timeleft so the next spell logic can sort spells correctly
   --The check buffs and debuff functions will reassign ROB_ACTION_TIMELEFT later to provide buff timelefts and what not
   ROB_ACTION_TIMELEFT = _cooldownLeft
   ROB_ACTION_GCD = false

   if _cooldownLeft <= _GCDleft then ROB_ACTION_GCD = true; end
                      
   --If we uncomment the next line rotation icon gaps go away but then you can't tell when you have a gap
   --if ((_GCDleft > 0) and (_cooldownLeft > _GCDleft)) then     
   if (_ActionDB.v_gcdspell ~= -1 and _cooldownLeft > _GCDleft and (not _ActionDB.b_notaspell)) then
      ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." is on cooldown",false,_debugon)
      --we still want to display the next spell even if it is on cooldown
      if (not _getnextspell) then return false; end
   end

   -- CHECK: Other Cooldown-----------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_checkothercd and _ActionDB.v_checkothercdname and _ActionDB.v_checkothercdname ~= "" and _ActionDB.v_checkothercdvalue and _ActionDB.v_checkothercdvalue ~= "") then
      if (not ROB_SpellPassesOtherCooldownCheck(_ActionDB.v_checkothercdname,_ActionDB.v_checkothercdvalue)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._ActionDB.v_spellname.." other cooldown check ".._ActionDB.v_checkothercdname.._ActionDB.v_checkothercdvalue.." failed",_ready,_debugon)
         return false
      end
   end

   -- CHECK: Check interrupt casting-----------------------------------------------------------------------------------------------------------------------------
   _channeling, _, _, _, _, _ = UnitCastingInfo("player")   
   if (not _channeling) then
      --target is not casting so see if target is channeling
      _, _, _channeling, _, _, _, _, _, _ = UnitChannelInfo("player") 
   end
   
   if (_channeling) then
      if (not _ActionDB.b_breakchanneling and (not _getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._ActionDB.v_spellname.." player is casting and this spell does not allow interrupt casting",_ready,_debugon)
         return false
      end
   end
   
   -- CHECK: Check Moving-----------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_moving) then
      if (GetUnitSpeed("player") == 0) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._ActionDB.v_spellname.." because player is not moving",_ready,_debugon)
         return false
      end
   end

   -- CHECK: Range-------------------------------------------------------------------------------------------  
   if (_ActionDB.b_rangecheck and (not ROB_ActionInRange(_actionname,"target")) and (not _getnextspell)) then
      ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." has range checking turned on and is out of range of your target (make sure to uncheck range for self buffs)",false,_debugon)
      return false
   end

   -- CHECK: Out of Range-------------------------------------------------------------------------------------------  
   if (_ActionDB.b_oorspell and _ActionDB.v_oorspell ~=nil and _ActionDB.v_oorspell ~= "") then
      if (ROB_ActionInRange(_ActionDB.v_oorspell, "target") and (not _getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." because target is in range of ".._ActionDB.v_oorspell,false,_debugon)
         return false
      end
   end

   -- CHECK: Maximum sequential casts---------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_maxcasts and _ActionDB.v_maxcasts ~= nil and _ActionDB.v_maxcasts ~= "" and tonumber(_ActionDB.v_maxcasts) >= 0) then
      if (ROB_LAST_CASTED == _name and ROB_LAST_CASTED_COUNT >= tonumber(_ActionDB.v_maxcasts)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." has reached max cast count of ".._ActionDB.v_maxcasts,false,_debugon)  
         return false
      end
   end

   -- CHECK: Duration -----------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_duration and _ActionDB.v_durationstartedtime ~=nil and _ActionDB.v_duration ~= nil and _ActionDB.v_duration ~= "") then
      if (GetTime() - tonumber(_ActionDB.v_durationstartedtime) < tonumber(_ActionDB.v_duration)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player already casted this spell before duration ".._ActionDB.v_duration.." has expired",false,_debugon)
         return false
      end
   end
   
   -- CHECK: Need Buff-----------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_needbuff and _ActionDB.v_p_needbuff ~= nil and _ActionDB.v_p_needbuff ~= "") then
      if (ROB_UnitHasBuff(_ActionDB.v_p_needbuff, "player",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player had these buffs ".._ActionDB.v_p_needbuff,false,_debugon)
         -- Dont allow _getnextspell bypassing because it causes next action to display actions that depend on buffs missing
         return false
      end
   end

   if (_ActionDB.b_t_needsbuff and _ActionDB.v_t_needsbuff ~= nil and _ActionDB.v_t_needsbuff ~= "") then
      if (ROB_UnitHasBuff(_ActionDB.v_t_needsbuff, "target",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." target had these buffs ".._ActionDB.v_t_needsbuff,false,_debugon)
         -- Dont allow _getnextspell bypassing because it causes next action to display actions that depend on buffs missing
         return false
      end
   end
   
   if (_ActionDB.b_pet_needsbuff and _ActionDB.v_pet_needsbuff ~= nil and _ActionDB.v_pet_needsbuff ~= "") then
      if (ROB_UnitHasBuff(_ActionDB.v_pet_needsbuff, "pet",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." pet had these buffs ".._ActionDB.v_pet_needsbuff,false,_debugon)
         -- Dont allow _getnextspell bypassing because it causes next action to display actions that depend on buffs missing
         return false
      end
   end

   -- CHECK: Have Buff-----------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_havebuff and _ActionDB.v_p_havebuff ~= nil and _ActionDB.v_p_havebuff ~= "") then
      if (not ROB_UnitHasBuff(_ActionDB.v_p_havebuff, "player",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player did not have these buffs ".._ActionDB.v_p_havebuff,false,_debugon)
         -- dont allow _allowreturn bypassing because it causes next action to display actions that are depend on buffs procing
         return false
      end
   end
   if (_ActionDB.b_t_hasbuff and _ActionDB.v_t_hasbuff ~= nil and _ActionDB.v_t_hasbuff ~= "") then
      if (not ROB_UnitHasBuff(_ActionDB.v_t_hasbuff, "target",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." target did not have these buffs ".._ActionDB.v_t_hasbuff,false,_debugon)
         -- dont allow _allowreturn bypassing because it causes next action to display actions that are depend on buffs procing
         return false
      end
   end
   if (_ActionDB.b_pet_hasbuff and _ActionDB.v_pet_hasbuff ~= nil and _ActionDB.v_pet_hasbuff ~= "") then
      if (not ROB_UnitHasBuff(_ActionDB.v_pet_hasbuff, "pet",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." pet did not have these buffs ".._ActionDB.v_pet_hasbuff,false,_debugon)
         -- dont allow _allowreturn bypassing because it causes next action to display actions that are depend on buffs procing
         return false
      end
   end

   -- CHECK: Needs Debuff-----------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_needdebuff and _ActionDB.v_p_needdebuff ~= nil and _ActionDB.v_p_needdebuff ~= "") then
      if (ROB_UnitHasDebuff(_ActionDB.v_p_needdebuff, "player",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player has one of these debuffs ".._ActionDB.v_p_needdebuff,false,_debugon)
         -- dont allow _getnextspell bypassing because it causes next action to display actions that depend on needing a debuff
         return false
      end
   end
   if (_ActionDB.b_t_needsdebuff and _ActionDB.v_t_needsdebuff ~= nil and _ActionDB.v_t_needsdebuff ~= "") then
      if (ROB_UnitHasDebuff(_ActionDB.v_t_needsdebuff, "target",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." target has one of these debuffs ".._ActionDB.v_t_needsdebuff,false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_pet_needsdebuff and _ActionDB.v_pet_needsdebuff ~= nil and _ActionDB.v_pet_needsdebuff ~= "") then
      if (ROB_UnitHasDebuff(_ActionDB.v_pet_needsdebuff, "pet",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." pet has one of these debuffs ".._ActionDB.v_pet_needsdebuff,false,_debugon)
         return false
      end
   end
   
   -- CHECK: Have Debuff-----------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_havedebuff and _ActionDB.v_p_havedebuff ~= nil and _ActionDB.v_p_havedebuff ~= "") then
      if (not ROB_UnitHasDebuff(_ActionDB.v_p_havedebuff, "player",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player does not have one of these debuffs ".._ActionDB.v_p_havedebuff,false,_debugon)
         -- dont allow _getnextspell bypassing because it causes next action to display actions that depend on having a debuff
         return false
      end
   end
   if (_ActionDB.b_t_hasdebuff and _ActionDB.v_t_hasdebuff ~= nil and _ActionDB.v_t_hasdebuff ~= "") then
      if (not ROB_UnitHasDebuff(_ActionDB.v_t_hasdebuff, "target",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." target does not have one of these debuffs ".._ActionDB.v_t_hasdebuff,false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_pet_hasdebuff and _ActionDB.v_pet_hasdebuff ~= nil and _ActionDB.v_pet_hasdebuff ~= "") then
      if (not ROB_UnitHasDebuff(_ActionDB.v_pet_hasdebuff, "pet",_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." pet does not have one of these debuffs ".._ActionDB.v_pet_hasdebuff,false,_debugon)
         return false
      end
   end

   -- CHECK: Life -----------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_hp and _ActionDB.v_p_hp ~= nil and _ActionDB.v_p_hp ~= "") then  
      if (not ROB_UnitPassesLifeCheck(_ActionDB.v_p_hp,"player")) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player did not pass life check ".._ActionDB.v_p_hp,false,_debugon)
         return false
      end
   end 
   if (_ActionDB.b_t_hp and _ActionDB.v_t_hp ~= nil and _ActionDB.v_t_hp ~= "") then
      if (not ROB_UnitPassesLifeCheck(_ActionDB.v_t_hp,"target")) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." target did not pass HP check ".._ActionDB.v_t_hp,false,_debugon)
         return false
      end
   end

   if (_ActionDB.b_t_maxhp and _ActionDB.v_t_maxhp ~= nil and _ActionDB.v_t_maxhp ~= "") then
      if (not ROB_UnitPassesLifeCheck(_ActionDB.v_t_maxhp,"target",true)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." target did not pass maximum HP check ".._ActionDB.v_t_maxhp,false,_debugon)
         return false
      end
   end
   
   if (_ActionDB.b_pet_hp and _ActionDB.v_pet_hp ~= nil and _ActionDB.v_pet_hp ~= "") then
      if (not ROB_UnitPassesLifeCheck(_ActionDB.v_pet_hp,"pet")) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." pet did not pass HP check ".._ActionDB.v_pet_hp,false,_debugon)
         return false
      end
   end
   
   if (_ActionDB.b_f_hp and _ActionDB.v_f_hp ~= nil and _ActionDB.v_f_hp ~= "") then
      if (not ROB_UnitPassesLifeCheck(_ActionDB.v_f_hp,"focus")) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." focus did not pass HP check ".._ActionDB.v_f_hp,false,_debugon)
         return false
      end
   end
   
   -- CHECK: Unitpower      -----------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_unitpower and _ActionDB.v_p_unitpowertype ~= nil and _ActionDB.v_p_unitpowertype ~= "") then  
      if (not ROB_UnitPassesPowerCheck(_ActionDB.v_p_unitpower,"player",_ActionDB.v_p_unitpowertype,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player does not meet power requirement ".._ActionDB.v_p_unitpower.." of type ".._ActionDB.v_p_unitpowertype,false,_debugon)
         return false
      end
   end

   -- CHECK: Last Casted    -----------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_lastcasted and _ActionDB.v_lastcasted ~= nil and _ActionDB.v_lastcasted ~= "") then
      if ((not _getnextspell) and ROB_LAST_CASTED ~= _ActionDB.v_lastcasted) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." lastcasted spell is not ".._ActionDB.v_lastcasted,false,_debugon)
         return false
      end
      if (_getnextspell and ROB_CURRENT_ACTION and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_spellname ~= _ActionDB.v_lastcasted) then
         --We failed to match the spell name to last casted try to match the getspellinfo spell id to last casted and if that fails then we dont match last casted
         if (_getnextspell and ROB_CURRENT_ACTION and GetSpellInfo(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_spellname) and GetSpellInfo(ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_spellname) ~= _ActionDB.v_lastcasted) then
            return false
         end
      end
   end

   -- CHECK: Runes ----------------------------------------------------------------------------------------------------------------------------------------------------
   --Blood
   if (_ActionDB.b_p_bloodrunes and _ActionDB.v_p_bloodrunes ~= nil and _ActionDB.v_p_bloodrunes ~= "") then
      if (not ROB_UnitPassesRuneCheck(_ActionDB.v_p_bloodrunes,nil,nil,_ActionDB.b_p_deathrunes,_getnextspell)) then
         if (_ActionDB.b_p_deathrunes) then
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player did not meet blood rune + allow death rune requirement of ".._ActionDB.v_p_bloodrunes,false,_debugon)
         else
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player did not meet blood rune requirement of ".._ActionDB.v_p_bloodrunes,false,_debugon)
         end
         return false
      end
   end
   --Frost
   if (_ActionDB.b_p_frostrunes and _ActionDB.v_p_frostrunes ~= nil and _ActionDB.v_p_frostrunes ~= "") then
      if (not ROB_UnitPassesRuneCheck(nil,_ActionDB.v_p_frostrunes,nil,_ActionDB.b_p_deathrunes,_getnextspell)) then
         if (_ActionDB.b_p_deathrunes) then
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player did not meet frost rune + allow death rune requirement of ".._ActionDB.v_p_frostrunes,false,_debugon)
         else
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player did not meet frost rune requirement of ".._ActionDB.v_p_frostrunes,false,_debugon)
         end
         return false
      end
   end
   --Unholy
   if (_ActionDB.b_p_unholyrunes and _ActionDB.v_p_unholyrunes ~= nil and _ActionDB.v_p_unholyrunes ~= "") then
      if (not ROB_UnitPassesRuneCheck(nil,nil,_ActionDB.v_p_unholyrunes,_ActionDB.b_p_deathrunes,_getnextspell)) then
         if (_ActionDB.b_p_deathrunes) then
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player did not meet unholy rune + allow death rune requirement of ".._ActionDB.v_p_unholyrunes,false,_debugon)
         else
            ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player did not meet unholy rune requirement of ".._ActionDB.v_p_unholyrunes,false,_debugon)
         end
         return false
      end
   end

   -- CHECK: Debuff types ----------------------------------------------------------------------------------------------------------------------------------------------------
   _checkmagic = _ActionDB.b_p_magic
   _checkpoison = _ActionDB.b_p_poison
   _checkdisease = _ActionDB.b_p_disease
   _checkcurse = _ActionDB.b_p_curse

   if (_checkmagic == true or _checkpoison == true or _checkdisease == true or _checkcurse == true) then
      if (not ROB_CheckForDebuffType("player",_checkmagic, _checkpoison, _checkdisease, _checkcurse)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." did not find any debuff types on player",false,_debugon)
         return false
      end
   end
   
   -- CHECK: Interrupt ----------------------------------------------------------------------------------------------------------------------------------------------------
   _targetCasting, _, _, _, _startTime, _ = UnitCastingInfo("target")   
   if (not _targetCasting) then
      --target is not casting so see if target is channeling
      _targetCasting, _, _, _, _, _startTime, _, _, _ = UnitChannelInfo("target")  
   end
   if (_targetCasting and _ActionDB.b_t_interrupt) then      
      _hasbeencasting =  GetTime() - (_startTime/1000)

      --if ((not string.find(_ActionDB.v_t_interrupt, _targetCasting)) or (_hasbeencasting < .4)) then
      --   ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." target is not casting a spell in the interrupt list or hasnt been casting for more than .4 seconds",false,_debugon)
      if (not string.find(_ActionDB.v_t_interrupt, "||".._targetCasting.."||")) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." target is not casting a spell in the interrupt list",false,_debugon)
         return false
      end
   elseif (_targetCasting == nil and _ActionDB.b_t_interrupt) then
      ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." target is not casting anything",false,_debugon)
      return false
   end
   
   -- CHECK: Target class ----------------------------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_t_class and _ActionDB.v_t_class ~= nil and _ActionDB.v_t_class ~= "" and UnitExists("target")) then
      if (not string.find(string.upper(_ActionDB.v_t_class), select(2, UnitClass("target")))) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." target class:"..select(2, UnitClass("target")).." is not one of these ".._ActionDB.v_t_class,false,_debugon)
         return false
      end
   end

   -- CHECK: Combo Points----------------------------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_combopoints and _ActionDB.v_p_combopoints ~= nil and _ActionDB.v_p_combopoints ~= "") then
      if (not ROB_PlayerHasComboPoints(_ActionDB.v_p_combopoints,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player does not have ".._ActionDB.v_p_combopoints.." combo points",false,_debugon)
         return false
      end
   end

   -- CHECK: Eclipse Direction----------------------------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_eclipse and _ActionDB.v_p_eclipse ~= nil and _ActionDB.v_p_eclipse ~= "") then
      if (not ROB_EclipseDirection(_ActionDB.v_p_eclipse,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." player eclipse is not heading towards ".._ActionDB.v_p_eclipse,false,_debugon)
         return false
      end
   end
   
   -- CHECK: Check TotemActive ----------------------------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_firetotemactive and _ActionDB.v_p_firetotemactive ~= nil and _ActionDB.v_p_firetotemactive ~= "") then
      if (not ROB_TotemActive(_ActionDB.v_p_firetotemactive, 1,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Fire totem ".._ActionDB.v_p_firetotemactive.." is not active",false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_p_earthtotemactive and _ActionDB.v_p_earthtotemactive ~= nil and _ActionDB.v_p_earthtotemactive ~= "") then
      if (not ROB_TotemActive(_ActionDB.v_p_earthtotemactive, 2,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Earth totem ".._ActionDB.v_p_earthtotemactive.." is not active",false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_p_watertotemactive and _ActionDB.v_p_watertotemactive ~= nil and _ActionDB.v_p_watertotemactive ~= "") then
      if (not ROB_TotemActive(_ActionDB.v_p_watertotemactive, 3,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Water totem ".._ActionDB.v_p_watertotemactive.." is not active",false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_p_airtotemactive and _ActionDB.v_p_airtotemactive ~= nil and _ActionDB.v_p_airtotemactive ~= "") then
      if (not ROB_TotemActive(_ActionDB.v_p_airtotemactive, 4,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Air totem ".._ActionDB.v_p_airtotemactive.." is not active",false,_debugon)
         return false
      end
   end
   
   -- CHECK: Check TotemInactive ----------------------------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_firetoteminactive and _ActionDB.v_p_firetoteminactive ~= nil and _ActionDB.v_p_firetoteminactive ~= "") then
      if (ROB_TotemActive(_ActionDB.v_p_firetoteminactive, 1,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Fire totem ".._ActionDB.v_p_firetoteminactive.." is active",false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_p_earthtoteminactive and _ActionDB.v_p_earthtoteminactive ~= nil and _ActionDB.v_p_earthtoteminactive ~= "") then
      if (ROB_TotemActive(_ActionDB.v_p_earthtoteminactive, 2,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Earth totem ".._ActionDB.v_p_earthtoteminactive.." is active",false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_p_watertoteminactive and _ActionDB.v_p_watertoteminactive ~= nil and _ActionDB.v_p_watertoteminactive ~= "") then
      if (ROB_TotemActive(_ActionDB.v_p_watertoteminactive, 3,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Water totem ".._ActionDB.v_p_watertoteminactive.." is active",false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_p_airtoteminactive and _ActionDB.v_p_airtoteminactive ~= nil and _ActionDB.v_p_airtoteminactive ~= "") then
      if (ROB_TotemActive(_ActionDB.v_p_airtoteminactive, 4,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Air totem ".._ActionDB.v_p_airtoteminactive.." is active",false,_debugon)
         return false
      end
   end

   -- CHECK: Check TotemTimeleft ----------------------------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_p_firetotemtimeleft and _ActionDB.v_p_firetotemtimeleft ~= nil and _ActionDB.v_p_firetotemtimeleft ~= "") then
      if (not ROB_TotemTimeleft(_ActionDB.v_p_firetotemtimeleft, 1,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Fire totem timeleft is not ".._ActionDB.v_p_firetotemtimeleft,false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_p_earthtotemtimeleft and _ActionDB.v_p_earthtotemtimeleft ~= nil and _ActionDB.v_p_earthtotemtimeleft ~= "") then
      if (not ROB_TotemTimeleft(_ActionDB.v_p_earthtotemtimeleft, 2,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Earth totem timeleft is not ".._ActionDB.v_p_earthtotemtimeleft,false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_p_watertotemtimeleft and _ActionDB.v_p_watertotemtimeleft ~= nil and _ActionDB.v_p_watertotemtimeleft ~= "") then
      if (not ROB_TotemTimeleft(_ActionDB.v_p_watertotemtimeleft, 3,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Water totem timeleft is not ".._ActionDB.v_p_watertotemtimeleft,false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_p_airtotemtimeleft and _ActionDB.v_p_airtotemtimeleft ~= nil and _ActionDB.v_p_airtotemtimeleft ~= "") then
      if (not ROB_TotemTimeleft(_ActionDB.v_p_airtotemtimeleft, 4,_getnextspell)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." Air totem timeleft is not ".._ActionDB.v_p_airtotemtimeleft,false,_debugon)
         return false
      end
   end

   -- CHECK: Check TargetPlayer Controlled ----------------------------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_t_pc ) then
      if (not UnitPlayerControlled("target")) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." because unit is not player controlled",false,_debugon)
         return false
      end
   end

   -- CHECK: Weapon Enchants ----------------------------------------------------------------------------------------------------------------------------------------------------
   --local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo();
   if (_ActionDB.b_p_nmh and _ActionDB.v_p_nmh ~= nil and _ActionDB.v_p_nmh ~= "") then
      if (ROB_CheckForWeaponEnchant(16, _ActionDB.v_p_nmh)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." because player has ".._ActionDB.v_p_nmh.." on mainhand already",false,_debugon)
         return false
      end
   end
   if (_ActionDB.b_p_noh and _ActionDB.v_p_noh ~= nil and _ActionDB.v_p_noh ~= "") then
      if (ROB_CheckForWeaponEnchant(17, _ActionDB.v_p_noh)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." because player has ".._ActionDB.v_p_noh.." on offhad already",false,_debugon)
         return false
      end
   end
   
   -- CHECK: Check Pet Autocasting ----------------------------------------------------------------------------------------------------------------------------------------------------
   if (_ActionDB.b_pet_isac and _ActionDB.v_pet_isac ~= nil and _ActionDB.v_pet_isac ~= "") then
      if (not ROB_PetIsAutocasting(_ActionDB.v_pet_isac)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." because pet is not autocasting ".._ActionDB.v_pet_isac,false,_debugon)
         return false
      end
   end
   
   if (_ActionDB.b_pet_nac and _ActionDB.v_pet_nac ~= nil and _ActionDB.v_pet_nac ~= "") then
      if (ROB_PetIsAutocasting(_ActionDB.v_pet_nac)) then
         ROB_Debug1(ROB_UI_DEBUG_E1.._actionname.." S:".._spellname.." because pet is autocasting ".._ActionDB.v_pet_nac,false,_debugon)
         return false
      end
   end

   return _ready
end

function ROB_GetCurrentAction()
   local _foundReadyAction = false
   local _foundReadyActionName = nil
   local _foundReadyActionCD = nil
   local _foundReadyActionTimeleft = 86400
   
   --ROB_Debug1("ROB_GetCurrentAction",false,true)
   --if (ROB_SelectedRotationName and ROB_Rotations[ROB_SelectedRotationName] ~= nil and ROB_Rotations[ROB_SelectedRotationName].SortedActions ~= nil) then
      --First get the next ready action name
   for _, _CurrentActionName in pairs(ROB_Rotations[ROB_SelectedRotationName].SortedActions) do
      ROB_Debug1("Checking if ".._CurrentActionName.." is ready",false,ROB_Rotations[ROB_SelectedRotationName].ActionList[_CurrentActionName].b_debug)
      if (ROB_SpellReady(_CurrentActionName,false) and (not _foundReadyAction)) then
         ROB_Debug1("Action:".._CurrentActionName.." is ready",false,ROB_Rotations[ROB_SelectedRotationName].ActionList[_CurrentActionName].b_debug)
         _foundReadyAction = true
         _foundReadyActionName = _CurrentActionName
         _foundReadyActionCD = ROB_ACTION_CD    
      else
         if (_foundReadyAction) then
            ROB_Debug1("Action:".._CurrentActionName.." is not showing because it is waiting for ready Action:".._foundReadyActionName.." to be cast",false,ROB_Rotations[ROB_SelectedRotationName].ActionList[_CurrentActionName].b_debug)
         end
      end
   end

   ROB_SetCurrentActionCooldown(_foundReadyActionName, _foundReadyActionCD)
   ROB_SetCurrentActionTexture(_foundReadyActionName)
   ROB_SetCurrentActionTint(_foundReadyActionName)
   ROB_SetCurrentActionLabel(_foundReadyActionName)

   
   if (_foundReadyAction) then
      if (_foundReadyActionName ~= ROB_CURRENT_ACTION) then ROB_CURRENT_ACTION = _foundReadyActionName; end
   else
      ROB_CURRENT_ACTION = nil
   end
   
   --[[
   for _, _CurrentActionName in pairs(ROB_Rotations[ROB_SelectedRotationName].SortedActions) do
      ROB_Debug1("Checking if ".._CurrentActionName.." is ready",false,ROB_Rotations[ROB_SelectedRotationName].ActionList[_CurrentActionName].b_debug)
      if (ROB_SpellReady(_CurrentActionName,false) and (not _foundReadyAction)) then
         ROB_Debug1("Action:".._CurrentActionName.." is ready",false,ROB_Rotations[ROB_SelectedRotationName].ActionList[_CurrentActionName].b_debug)
         _foundReadyAction = true
         _foundReadyActionName = _CurrentActionName
         _foundReadyActionCD = ROB_ACTION_CD              
      else
         if (_foundReadyAction) then
            ROB_Debug1("Action:".._CurrentActionName.." is not showing because it is waiting for ready Action:".._foundReadyActionName.." to be cast",false,ROB_Rotations[ROB_SelectedRotationName].ActionList[_CurrentActionName].b_debug)
         end
      end
   end

   --if no actions were ready then hide the icon so we don force it to flash
   if (not _foundReadyAction) then
      ROB_CURRENT_ACTION = nil
      ROB_CurrentActionFrame:Hide()
   else  
      --If the _currentAction is different then what we set swap out the textures
      if (_foundReadyActionName ~= ROB_CURRENT_ACTION) then
         ROB_CURRENT_ACTION = _foundReadyActionName
         --Because we found a new current action that means the next action needs to be updated as well
         --ROB_NEXT_ACTION = nil

         --Set the icon texture
         if ((not GetTexturePath(ROB_Rotations[ROB_SelectedRotationName].ActionList[_foundReadyActionName].v_actionicon)) or (ROB_Rotations[ROB_SelectedRotationName].ActionList[_foundReadyActionName].v_actionicon == "")) then
            ROB_CurrentActionTexture:SetTexture(GetTexturePath(ROB_Rotations[ROB_SelectedRotationName].ActionList[_foundReadyActionName].v_spellname))
         else
            ROB_CurrentActionTexture:SetTexture(GetTexturePath(ROB_Rotations[ROB_SelectedRotationName].ActionList[_foundReadyActionName].v_actionicon))
         end
         --Set the keybind text
         ROB_CurrentActionLabel:SetText("")
         if (ROB_Rotations[ROB_SelectedRotationName].ActionList[_foundReadyActionName].v_keybind and ROB_Rotations[ROB_SelectedRotationName].ActionList[_foundReadyActionName].v_keybind ~= ROB_UI_KEYBIND) then
            ROB_CurrentActionLabel:SetText(ROB_Rotations[ROB_SelectedRotationName].ActionList[_foundReadyActionName].v_keybind)
         end
         --Set the cooldown of the action
         ROB_CurrentActionFrame_Cooldown:SetCooldown(GetTime(), _foundReadyActionCD)
         --Only show the frame after all the changes are made
         ROB_CurrentActionFrame:Show()
      end
   end--]]
end

function ROB_GetNextAction()
   local _foundReadyAction = false
   local _foundReadyActionName = nil
   local _foundReadyActionCD = nil
   local _foundReadyActionTimeleft = 86400
   
--ROB_Debug1("ROB_GetNextAction",false,true)
   --if (ROB_SelectedRotationName and ROB_Rotations[ROB_SelectedRotationName] ~= nil and ROB_Rotations[ROB_SelectedRotationName].SortedActions ~= nil) then
      --First get the next ready action name
      for _, _NextActionName in pairs(ROB_Rotations[ROB_SelectedRotationName].SortedActions) do
--ROB_Debug1("Checking if ".._NextActionName.." is the next ready action",false,true)
         --Dont pick next actions that have the same aciton name or spell name as the current action
         if (ROB_CURRENT_ACTION and ROB_SpellReady(_NextActionName, true) and _NextActionName ~= ROB_CURRENT_ACTION) then
--ROB_Debug1("Action:".._NextActionName.." was ready but checking <.5",false,true)
            --Check to make sure this cooldown is less than .5 seconds more than previous next action before setting it to prevent the multiple spell spinning in next action
            if (ROB_Rotations[ROB_SelectedRotationName].ActionList[_NextActionName].v_spellname and ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_spellname and ROB_ACTION_TIMELEFT < _foundReadyActionTimeleft and ((_foundReadyActionTimeleft - ROB_ACTION_CD) > .5) and (ROB_Rotations[ROB_SelectedRotationName].ActionList[ROB_CURRENT_ACTION].v_spellname ~= ROB_Rotations[ROB_SelectedRotationName].ActionList[_NextActionName].v_spellname)) then
--ROB_Debug1("Action:".._NextActionName.." is < .5 and is ready",false,true)
               _foundReadyAction = true
               _foundReadyActionName = _NextActionName
               _foundReadyActionTimeleft = ROB_ACTION_TIMELEFT
               _foundReadyActionCD = ROB_ACTION_CD
            end
         else
--ROB_Debug1(_NextActionName.." was not next ready action",false,ROB_Rotations[ROB_SelectedRotationName].ActionList[_NextActionName].b_debug)
            if (_foundReadyAction) then
--ROB_Debug1("Action:".._NextActionName.." is not showing as next ready action because Action:".._foundReadyActionName.." is higher priority",false,ROB_Rotations[ROB_SelectedRotationName].ActionList[_NextActionName].b_debug)
            end
         end
      end
   --end
   ROB_SetNextActionCooldown(_foundReadyActionName, _foundReadyActionCD)
   ROB_SetNextActionTexture(_foundReadyActionName)
   ROB_SetNextActionTint(_foundReadyActionName)
   ROB_SetNextActionLabel(_foundReadyActionName)

   
   if (_foundReadyAction and _foundReadyActionName ~= ROB_NEXT_ACTION) then
      ROB_NEXT_ACTION = _foundReadyActionName
   end
end

function ROB_OnUpdate(self, elapsed)
   self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;  
   while (self.TimeSinceLastUpdate > ROB_UPDATE_INTERVAL) do
      if (ROB_SelectedRotationName and ROB_Rotations[ROB_SelectedRotationName] ~= nil and ROB_Rotations[ROB_SelectedRotationName].SortedActions ~= nil) then
         --=============================================================================================================================
         --=============================================================================================================================
         --Get the first spell that is ready and set the texture
         --=============================================================================================================================
         --=============================================================================================================================
         ROB_GetCurrentAction()
         --=============================================================================================================================
         --=============================================================================================================================
         --Now get the next ready action
         --=============================================================================================================================
         --=============================================================================================================================
         ROB_GetNextAction()
      else
         --No rotation selected so hide both icon frames
         ROB_CurrentActionFrame:Hide()
         ROB_NextActionFrame:Hide()
      end

      if (ROB_TOGGLE_1 == 1 ) then
         ROB_RotationToggle1Texture:Show()
      else
         ROB_RotationToggle1Texture:Hide()
      end
      if (ROB_TOGGLE_2 == 1 ) then
         ROB_RotationToggle2Texture:Show()
      else
         ROB_RotationToggle2Texture:Hide()
      end
      if (ROB_TOGGLE_3 == 1 ) then
         ROB_RotationToggle3Texture:Show()
      else
         ROB_RotationToggle3Texture:Hide()
      end
      if (ROB_TOGGLE_4 == 1 ) then
         ROB_RotationToggle4Texture:Show()
      else
         ROB_RotationToggle4Texture:Hide()
      end
   
      ROB_DebugOnUpdate()
      self.TimeSinceLastUpdate = self.TimeSinceLastUpdate - ROB_UPDATE_INTERVAL
   end

end

function ROB_Debug1(msg,validate,spellhasdebug)
   if (validate ~= nil and validate == true) then
      return
   end
   if (spellhasdebug == nil or spellhasdebug == false) then
      return
   end
   if (ROB_ROTATION_STATE == 0) then
      return
   end
   print(ROB_UI_DEBUG_PREFIX..GetTime()..":"..msg)
   ROB_LAST_DEBUG = GetTime()
   ROB_LAST_DEBUG_MSG = msg
   
end