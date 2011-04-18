if GetLocale() == "frFR" then
   ROB_FRAME_ROTATIONS_TT     = "Show Rotations"
   ROB_FRAME_OPTIONS_TT       = "Show Options"
   ROB_FRAME_CLOSE_TT         = "Close Rotation Builder Window"

   ROB_UI_TITLE               = "Rotation Builder"
   ROB_UI_VERSION_LABEL       = "Version:"
   ROB_UI_RCOLUMNHEADER       = "Rotations"
   ROB_UI_CREATE              = "Create"
   ROB_UI_CREATE_TT           = "Create a new rotation"
   ROB_UI_MODIFY              = "Modify"
   ROB_UI_MODIFY_TT           = "Modify selected rotation"
   ROB_UI_SAVE                = "Save"
   ROB_UI_SAVE_TT             = "Save selected rotation"
   ROB_UI_DISCARD             = "Discard"
   ROB_UI_DISCARD_TT          = "Discard changes to selected rotation"
   ROB_UI_DELETE              = "Delete"
   ROB_UI_DELETE_TT           = "Delete selected rotation"
   ROB_UI_TOGGLE              = "Toggle Rotation Builder"
   ROB_UI_DEBUG_PREFIX        = "ROB:"
   ROB_UI_ROTATION_E1         = "No rotation setup for that key"
   ROB_UI_ROTATION_E2         = "Rotation not found"
   ROB_UI_INTERRUPTED_MSG     = "Interrupted"
   
   ROB_UI_ACTION_COLUMN       = "Actions"
   ROB_UI_RN_LABEL            = "Rotation Name:"
   ROB_UI_RS_LABEL            = "Range Spell:"
   ROB_UI_RS_LABEL_TT         = "Input the name of the spell to use to check if you are in range of your target to show the out of range icon\n(This has no effect on rotation, only the out of range icon display)"
   ROB_UI_RKB_LABEL           = "Keybind"
   ROB_UI_RKB_LABEL_TT        = "Specify which key selects this rotation"
   
   ROB_UI_A_ADD               = "Add"
   ROB_UI_A_ADD_TT            = "Add new action to the rotation"
   ROB_UI_A_COPY              = "Copy"
   ROB_UI_A_COPY_TT           = "Copy the selected action to the clipboard"
   ROB_UI_A_PASTE             = "Paste"
   ROB_UI_A_PASTE_TT          = "Paste the copied action into the rotation"
   
   ROB_UI_IMPORT              = "Import"
   ROB_UI_IMPORT_TT           = "Import rotation"
   ROB_UI_IMPORT_MESSAGE      = "Press Ctrl+V to paste a rotation build that you've copied from another source here:"
   ROB_UI_IMPORT_ERROR1       = "Import failed no rotation name found"
   ROB_UI_IMPORT_ERROR2       = "Import failed because you already have this rotation and are not allowing overwrites"
   ROB_UI_IMPORT_ERROR3       = "Import failed because import string is not a rotation builder export"
   ROB_UI_IMPORT_SUCCESS      = "Import successful"
   ROB_UI_EXPORT              = "Export"
   ROB_UI_EXPORT_TT           = "Export rotation"
   ROB_UI_EXPORT_MESSAGE      = "Press Ctrl+C to copy the following rotation, and then press Ctrl+V to paste it later."
   ROB_UI_ADD_ACTION_CFAIL    = "Action names can not use these characters [ ] , ="
   ROB_UI_ADD_ROTATION_CFAIL  = "Rotation names can not use these characters [ ] ,"
   ROB_UI_OK_BUTTON           = "Ok"
   ROB_UI_CANCEL_BUTTON       = "Cancel"
   ROB_UI_CLOSE_BUTTON        = "Close"
   ROB_UI_ROTATION_TAB        = "Rotations"
   ROB_UI_OPTIONS_TAB         = "Options"
   ROB_UI_PRESSKEY            = "Press Key"
   ROB_UI_KEYBIND             = "<keybind>"
   
   ROB_UI_AO_GENERAL_TAB      = "General"
   ROB_UI_AO_GENERAL_LABEL    = "General Options:"
   ROB_UI_AO_G_SPELLNAME_L    = "Spell Name or Inventory Slot:"
   ROB_UI_AO_G_SPELLNAME_TT   = "Input spellname or inventory slot\nExample1: |cFF00FF00Trinket0Slot|r for first trinket slot\nExample2: |cFF00FF00Trinket1Slot|r for second trinket slot\nExample3: |cFF00FF00HandsSlot|r\nExample4: |cFF00FF00Growl|r\nExample5: |cFF00FF00\50\54\52\57|r id for Growl"
   ROB_UI_AO_G_SID_VFAIL      = "Spell or Slot not found"
   ROB_UI_AO_G_KEYBIND_L      = "Keybind"
   ROB_UI_AO_G_KEYBIND_TT     = "Specify the keybind to display in the rotation icon\nNote; This is not an actual keybind and is used for display purposes only"
   ROB_UI_AO_G_GCD_L          = "GCD Spell:"
   ROB_UI_AO_G_GCD_TT         = "Input a spell not used in the rotation or never used to check if you are in global cooldown\nInput -1 to ignore cooldown checking\nIf this is left blank it will assume the spell is in global cooldown at 1.5 seconds"
   ROB_UI_AO_G_ICON_L         = "Icon:"
   ROB_UI_AO_G_ICON_TT        = "Input the spell name or spell id of the icon you want to display for this action\nIf left blank the spellname will be used"   
   ROB_UI_AO_G_NOTSPELL       = "Not a spell"
   ROB_UI_AO_G_NOTSPELL_TT    = "Ignore spell mana type checks and just use the keybind to perform the action\nCheck this when spellname=Trinket0Slot or HandsSlot"
   ROB_UI_AO_G_DEBUG          = "Debug"
   ROB_UI_AO_G_DEBUG_TT       = "Turn on debug for this spell"
   ROB_UI_AO_G_TOGGLE         = "Toggle:"
   ROB_UI_AO_G_TOGGLE_TT      = "Only display action when specified toggle is turned on"
   ROB_UI_AO_G_TICON_TT       = "Enter spell name or spell id of icon to display for this toggle"
   ROB_UI_AO_G_TOGGLEOFF_TT   = "Turn off toggle automatically after you cast the spell?"
   ROB_UI_AO_G_TOGGLEON_TT    = "Turn on toggle automatically when switching to this rotation?"
   ROB_UI_AO_G_RANGE          = "Range:"
   ROB_UI_AO_G_RANGE_TT       = "Check if action is in range using specified spell name"
   ROB_UI_AO_G_RANGEIB_TT     = "Input the name of the spell to use to check range\nIf this is left blank the spell name is used instead"
   ROB_UI_AO_G_DISABLE        = "Disable"
   ROB_UI_AO_G_DISABLE_TT     = "Temporarily disable this action so you dont have to delete it"
   ROB_UI_AO_G_DURATION       = "Wait to recast:"
   ROB_UI_AO_G_DURATION_TT    = "Wait specified seconds to display this action after you have casted it\nUseful for giving air born spells time to land before calculating next action"
   ROB_UI_AO_G_DURATIONIB_TT  = "Input the number of seconds to wait before redisplaying action"
   ROB_UI_AO_G_OOR            = "OOR:"
   ROB_UI_AO_G_OOR_TT         = "Only display action when specified spell is out of range of target"
   ROB_UI_AO_G_OORIB_TT       = "Input the name of the spell to check out of range"
   ROB_UI_AO_G_LASTCAST       = "Last casted:"
   ROB_UI_AO_G_LASTCAST_TT    = "Only display action if the last casted spell was this"
   ROB_UI_AO_G_LASTCASTIB_TT  = "Input the name of the last casted spell to check"
   ROB_UI_AO_G_MAXCASTS       = "Max sequential casts:"
   ROB_UI_AO_G_MAXCASTS_TT    = "Only display this action specified sequential times"
   ROB_UI_AO_G_MAXCASTSIB_TT  = "Input the number of casts allowed in succession"
   ROB_UI_AO_G_OTHERCD        = "Check other cooldown:"
   ROB_UI_AO_G_OTHERCD_TT     = "Only display this action when other cooldown specified passes check"
   ROB_UI_AO_G_OTHERCDNIB_TT  = "Input the name or spell id of the other cooldown to check"
   ROB_UI_AO_G_OTHERCDVIB_TT  = "Input the value of the other cooldown to check\nExample1: |cFF00FF00\51|r means only display action when other action has less than 3 seconds left\nExample2: |cFF00FF00>3|r means only display action when other action has more than 3 seconds left\nExample3: |cFF00FF00\60\61\51|r means only display action when other action has less than or equal to 3 seconds left\nExample4: |cFF00FF00=3|r means only display this action when other action has exactly 3 seconds left"
   ROB_UI_AO_G_BREAKCHAN      = "Break channeling"
   ROB_UI_AO_G_BREAKCHAN_TT   = "Allow this action to be displayed while channeling a spell"
   ROB_UI_AO_G_MOVING         = "Only moving"
   ROB_UI_AO_G_MOVING_TT      = "Only display this action if player is moving"
   ROB_UI_AO_G_GUNITPOWER     = "Generates Power:"
   ROB_UI_AO_G_GUNITPOWER_TT  = "Check this option if this action generates a type of power\nThis is used for calculating the next ready action"
   ROB_UI_AO_G_GUNITPOWER1_TT = "Input the type of power generated\n|cFF00FF000|r=MANA |cFF00FF001|r=RAGE |cFF00FF002|r=FOCUS |cFF00FF003|r=ENERGY |cFF00FF004|r=PET HAPPINESS\n|cFF00FF005|r=RUNES |cFF00FF006|r=RUNICPOWER |cFF00FF007|r=SOULSHARDS |cFF00FF008|r=ECLIPSE |cFF00FF009|r=HOLYPOWER"
   ROB_UI_AO_G_GUNITPOWER2_TT = "Input the amount of power generated\nExample1: |cFF00FF003|r\nExample2: |cFF00FF00\57\48%|r"
   ROB_UI_AO_G_COMBOP         = "Generates Combo Points:"
   ROB_UI_AO_G_COMBOP_TT      = "Check this option if this action generates combo points\nThis is used for calculating the next ready action"
   ROB_UI_AO_G_COMBOPIB_TT    = "Input the number of combo points generated\nExample: |cFF00FF002|r"
   ROB_UI_AO_G_BLOODR         = "Generates Blood Runes:"
   ROB_UI_AO_G_BLOODR_TT      = "Check this box if this action generates blood runes\nThis is used for calculating the next ready action"
   ROB_UI_AO_G_BLOODRIB_TT    = "Input the number of blood runes generated\nExample: |cFF00FF001|r"
   ROB_UI_AO_G_FROSTR         = "Generates Frost Runes:"
   ROB_UI_AO_G_FROSTR_TT      = "Check this option if this action generates frost runes\nThis is used for calculating the next ready action"
   ROB_UI_AO_G_FROSTRIB_TT    = "Input the number of frost runes generated\nExample: |cFF00FF001|r"
   ROB_UI_AO_G_UNHOLYR        = "Generates Unholy Runes:"
   ROB_UI_AO_G_UNHOLYR_TT     = "Check this option if this action generates unholy runes\nThis is used for calculating the next ready action"
   ROB_UI_AO_G_UNHOLYRIB_TT   = "Input the number of unholy runes generated\nExample: |cFF00FF001|r"
   ROB_UI_AO_G_DEATHR         = "Generates Death Runes:"
   ROB_UI_AO_G_DEATHR_TT      = "Check this option if this action generates death runes\nThis is used for calculating the next ready action"
   ROB_UI_AO_G_DEATHRIB_TT    = "Input the number of death runes generated\nExample: |cFF00FF001|r"

   
   ROB_UI_AO_PLAYER_TAB       = "Player"
   ROB_UI_AO_P_HP             = "HP:"
   ROB_UI_AO_P_HP_TT          = "Only display action when player meets specified hit points"
   ROB_UI_AO_P_HPIB_TT        = "Input the percent of player hit points to check\nExample1: |cFF00FF00\60\57\48%|r means only display this action when player is under 90% hitpoints\nExample2: |cFF00FF00>90%|r means only display this action when player is over 90% hitpoints\nExample3: |cFF00FF00\60\61\57\48%|r means only display this action when player is under or equal to 90% hitpoints\nExample4: |cFF00FF00>=90%|r means only display this action when player is over or equal to 90% hitpoints\nExample5: |cFF00FF00=90%|r means only display this action when player is at exactly 90% hitpoints"
   ROB_UI_AO_P_POISON         = "Poison"
   ROB_UI_AO_P_POISON_TT      = "Only display action when player has a poison debuff"
   ROB_UI_AO_P_MAGIC          = "Magic"
   ROB_UI_AO_P_MAGIC_TT       = "Only display action when player has a magic debuff"
   ROB_UI_AO_P_DISEASE        = "Disease"
   ROB_UI_AO_P_DISEASE_TT     = "Only display action when player has a disease debuff"
   ROB_UI_AO_P_CURSE          = "Curse"
   ROB_UI_AO_P_CURSE_TT       = "Only display action when player has a curse debuff"
   
   ROB_UI_AO_P_FIRETA         = "Active Fire:"
   ROB_UI_AO_P_FIRETA_TT      = "Only display action when specified fire totem is active"
   ROB_UI_AO_P_FIRETAIB_TT    = "Input the name or spell id of the fire totem\nExample1: |cFF00FF00Searing Totem|r\nExample2:|cFF00FF00 3599|r"
   ROB_UI_AO_P_FIRETI         = "Inactive Fire:"
   ROB_UI_AO_P_FIRETI_TT      = "Only display action when specified fire totem is inactive"
   ROB_UI_AO_P_FIRETIIB_TT    = "Input the name or spell id of the fire totem\nExample1: |cFF00FF00Searing Totem|r\nExample2:|cFF00FF00 3599|r"
   ROB_UI_AO_P_FIRETTL        = "Timeleft Fire:"
   ROB_UI_AO_P_FIRETTL_TT     = "Only display action when fire totem has specified timeleft"
   ROB_UI_AO_P_FIRETTLIB_TT   = "Input the name or spell id of the fire totem\nExample1: |cFF00FF00>=2|r means >= 2 seconds left\nExample2: |cFF00FF00\60=2.1|r means \60=2.1 seconds left\nExample3: |cFF00FF00=5|r means exactly 5 seconds left"
   
   ROB_UI_AO_P_EARTHTA        = "Active Earth:"
   ROB_UI_AO_P_EARTHTA_TT     = "Only display action when specified earth totem is active"
   ROB_UI_AO_P_EARTHTAIB_TT   = "Input the name or spell id of the earth totem\nExample1: |cFF00FF00Earthbind Totem|r\nExample2:|cFF00FF00 2484|r"
   ROB_UI_AO_P_EARTHTI        = "Inactive Earth:"
   ROB_UI_AO_P_EARTHTI_TT     = "Only display action when specified earth totem is inactive"
   ROB_UI_AO_P_EARTHTIIB_TT   = "Input the name or spell id of the earth totem\nExample1: |cFF00FF00Earthbind Totem|r\nExample2:|cFF00FF00 2484|r"
   ROB_UI_AO_P_EARTHTTL       = "Timeleft Earth:"
   ROB_UI_AO_P_EARTHTTL_TT    = "Only display action when earth totem has specified timeleft"
   ROB_UI_AO_P_EARTHTTLIB_TT  = "Input the name or spell id of the earth totem\nExample1: |cFF00FF00>=2|r means >= 2 seconds left\nExample2: |cFF00FF00\60=2.1|r means \60=2.1 seconds left\nExample3: |cFF00FF00=5|r means exactly 5 seconds left"
   
   ROB_UI_AO_P_WATERTA        = "Active Water:"
   ROB_UI_AO_P_WATERTA_TT     = "Only display action when specified water totem is active"
   ROB_UI_AO_P_WATERTAIB_TT   = "Input the name or spell id of the water totem\nExample1: |cFF00FF00Mana Tide Totem|r\nExample2:|cFF00FF00 16190|r"
   ROB_UI_AO_P_WATERTI        = "Inactive Water:"
   ROB_UI_AO_P_WATERTI_TT     = "Only display action when specified water totem is inactive"
   ROB_UI_AO_P_WATERTIIB_TT   = "Input the name or spell id of the water totem\nExample1: |cFF00FF00Mana Tide Totem|r\nExample2:|cFF00FF00 16190|r"
   ROB_UI_AO_P_WATERTTL       = "Timeleft Water:"
   ROB_UI_AO_P_WATERTTL_TT    = "Only display action when water totem has specified timeleft"
   ROB_UI_AO_P_WATERTTLIB_TT  = "Input the name or spell id of the water totem\nExample1: |cFF00FF00>=2|r means >= 2 seconds left\nExample2: |cFF00FF00\60=2.1|r means \60=2.1 seconds left\nExample3: |cFF00FF00=5|r means exactly 5 seconds left"
   
   ROB_UI_AO_P_AIRTA        = "Active Air:"
   ROB_UI_AO_P_AIRTA_TT     = "Only display action when specified air totem is active"
   ROB_UI_AO_P_AIRTAIB_TT   = "Input the name or spell id of the air totem\nExample1: |cFF00FF00Wrath of Air Totem|r\nExample2:|cFF00FF00 3738|r"
   ROB_UI_AO_P_AIRTI        = "Inactive Air:"
   ROB_UI_AO_P_AIRTI_TT     = "Only display action when specified air totem is inactive"
   ROB_UI_AO_P_AIRTIIB_TT   = "Input the name or spell id of the air totem\nExample1: |cFF00FF00Wrath of Air Totem|r\nExample2:|cFF00FF00 3738|r"
   ROB_UI_AO_P_AIRTTL       = "Timeleft Air:"
   ROB_UI_AO_P_AIRTTL_TT    = "Only display action when air totem has specified timeleft"
   ROB_UI_AO_P_AIRTTLIB_TT  = "Input the name or spell id of the air totem\nExample1: |cFF00FF00>=2|r means >= 2 seconds left\nExample2: |cFF00FF00\60=2.1|r means \60=2.1 seconds left\nExample3: |cFF00FF00=5|r means exactly 5 seconds left"
   
   
   
   ROB_UI_AO_P_POWER          = "Power:"
   ROB_UI_AO_P_POWER_TT       = "Only display action when player has the specified power"
   ROB_UI_AO_P_POWER1_TT      = "Input the type of unit power\n|cFF00FF000|r=MANA |cFF00FF001|r=RAGE |cFF00FF002|r=FOCUS |cFF00FF003|r=ENERGY |cFF00FF004|r=PET HAPPINESS\n|cFF00FF005|r=RUNES |cFF00FF006|r=RUNICPOWER |cFF00FF007|r=SOULSHARDS |cFF00FF008|r=ECLIPSE |cFF00FF009|r=HOLYPOWER"
   ROB_UI_AO_P_POWER2_TT      = "Input the amount of power required\nExample1: |cFF00FF00>20|r\nExample2: |cFF00FF00\60=20|r\nExample3: |cFF00FF00=20|r\nExample4: |cFF00FF00\60\57\48%|r"
   ROB_UI_AO_P_NEEDBUFF       = "Need Buff:"
   ROB_UI_AO_P_NEEDBUFF_TT    = "Only display action when player needs specified buff or buffs"
   ROB_UI_AO_P_NEEDBUFFIB_TT  = "Input the name of the buff or buffs\nSyntax: |cFF00FF00\124 |r= OR |cFF00FF00\38|r = AND |cFF00FF00\95|r = casted by player |cFF00FF00\35|r = number of stacks |cFF00FF00\94|r = refresh at seconds\nExample1: |cFF00FF00Earth Shield#2|r display action when player is missing 2 stacks of Earth Shield\nExample2: |cFF00FF00_Earth Shield#2|r display action when player is missing a player casted Earth Shield at 2 stacks\nExample3: |cFF00FF00_Earth Shield#2^3|r display action when player is missing a player casted Earth Shield at 2 stacks with >=3 seconds left\nExample4: |cFF00FF00Earth Shield||Inner Fire|r display action when player is missing Earth Shield or Inner Fire\nExample5: |cFF00FF00Earth Shield\38Inner Fire|r display action when player is missing both Earth Shield and Inner Fire"
   ROB_UI_AO_P_HAVEBUFF       = "Have Buff:"
   ROB_UI_AO_P_HAVEBUFF_TT    = "Only display action when player has the specified buff or buffs"
   ROB_UI_AO_P_HAVEBUFFIB_TT  = "Input the name of the buff or buffs\nSyntax: |cFF00FF00\124 |r= OR |cFF00FF00\38|r = AND |cFF00FF00\95|r = casted by player |cFF00FF00\35|r = number of stacks |cFF00FF00\94|r = refresh at seconds\nExample1: |cFF00FF00Earth Shield#2|r display action when player has 2 stacks of Earth Shield\nExample2: |cFF00FF00_Earth Shield#2|r display action when player has a player casted Earth Shield at 2 stacks\nExample3: |cFF00FF00_Earth Shield#2^3|r display action when player has a player casted Earth Shield at 2 stacks with >=3 seconds left\nExample4: |cFF00FF00Earth Shield||Inner Fire|r display action when player has Earth Shield or Inner Fire\nExample5: |cFF00FF00Earth Shield\38Inner Fire|r display action when player has both Earth Shield and Inner Fire"
   ROB_UI_AO_P_NEEDDB         = "Need Debuff:"
   ROB_UI_AO_P_NEEDDB_TT      = "Only display action when player is missing the specified debuff or debuffs"
   ROB_UI_AO_P_NEEDDBIB_TT    = "Input the name of the debuff or debuffs\nSyntax: |cFF00FF00\124 |r= OR |cFF00FF00\38|r = AND |cFF00FF00\95|r = casted by player |cFF00FF00\35|r = number of stacks |cFF00FF00\94|r = refresh at seconds\nExample1: |cFF00FF00Dark Plague#2|r display action when player is missing the debuff Dark Plague 2 stacks\nExample2: |cFF00FF00_Dark Plague#2|r display action when player is missing a player casted Dark Plague at 2 stacks\nExample3: |cFF00FF00_Dark Plague#2^3|r display action when player is missing a player casted Dark Plague at 2 stacks with >=3 seconds left\nExample4: |cFF00FF00Dark Plague|Forbearance|r display action when player is missing Dark Plague or Forbearance debuffs\nExample5: |cFF00FF00Dark Plague\38Forbearance|r display action when player is missing both Dark Plague and Forbearance debuffs"
   ROB_UI_AO_P_HAVEDB         = "Have Debuff:"
   ROB_UI_AO_P_HAVEDB_TT      = "Only display action when player has the specified debuff or debuffs"
   ROB_UI_AO_P_HAVEDBIB_TT    = "Input the name of the debuff or debuffs\nSyntax: |cFF00FF00\124 |r= OR |cFF00FF00\38|r = AND |cFF00FF00\95|r = casted by player |cFF00FF00\35|r = number of stacks |cFF00FF00\94|r = refresh at seconds\nExample1: |cFF00FF00Dark Plague#2|r display action when player has the debuff Dark Plague 2 stacks\nExample2: |cFF00FF00_Dark Plague#2|r display action when player has a player casted Dark Plague at 2 stacks\nExample3: |cFF00FF00_Dark Plague#2^3|r display action when player has a player casted Dark Plague at 2 stacks with >=3 seconds left\nExample4: |cFF00FF00Dark Plague|Forbearance|r display action when player has Dark Plague or Forbearance debuffs\nExample5: |cFF00FF00Dark Plague\38Forbearance|r display action when player has both Dark Plague and Forbearance debuffs"
   ROB_UI_AO_P_COMBOP         = "Combo Points:"
   ROB_UI_AO_P_COMBOP_TT      = "Only display action when I have specified combo points"
   ROB_UI_AO_P_COMBOPIB_TT    = "Input the number of combo points required\nExample1: |cFF00FF00>=2|r\nExample2: |cFF00FF00\60=2|r\nExample3: |cFF00FF00=2|r"
   ROB_UI_AO_P_ECLIPSE        = "Eclipse:"
   ROB_UI_AO_P_ECLIPSE_TT     = "Only display action when eclipse is heading towards specified direction"
   ROB_UI_AO_P_ECLIPSEIB_TT   = "Input the direction of the eclipse\nExample1: |cFF00FF00moon|r\nExample2: |cFF00FF00sun|r\nExample3: |cFF00FF00none|r"
   ROB_UI_AO_P_BLOODR         = "Blood:"
   ROB_UI_AO_P_BLOODR_TT      = "Only display action when player has specified blood runes"
   ROB_UI_AO_P_BLOODRIB_TT    = "Input the number of blood runes\nExample1: |cFF00FF002|r"
   ROB_UI_AO_P_FROSTR         = "Frost:"
   ROB_UI_AO_P_FROSTR_TT      = "Only display action when player has specified frost runes"
   ROB_UI_AO_P_FROSTRIB_TT    = "Input the number of frost runes\nExample1: |cFF00FF002|r"
   ROB_UI_AO_P_UNHOLYR        = "Unholy:"
   ROB_UI_AO_P_UNHOLYR_TT     = "Only display action when player has specified unholy runes"
   ROB_UI_AO_P_UNHOLYRIB_TT   = "Input the number of unholy runes\nExample1: |cFF00FF002|r"
   ROB_UI_AO_P_DEATHR         = "Death:"
   ROB_UI_AO_P_DEATHR_TT      = "Allow action to use death runes"
   ROB_UI_AO_P_MHWE           = "Need MH Enchant:"
   ROB_UI_AO_P_MHWE_TT        = "Only display action when player needs specified main hand enchant"
   ROB_UI_AO_P_MHWEIB_TT      = "Input the name of the enchant\nExample1: |cFF00FF00Mind-Numbing Poison\94\51|r = display action when main hand does not\n       have Mind-Numbing Poison with at least 3 seconds left\nExample2: |cFF00FF00Frostbrand Weapon|r = display action when main hand does not have Frostbrand Weapon"
   ROB_UI_AO_P_OHWE           = "Need OH Enchant:"
   ROB_UI_AO_P_OHWE_TT        = "Only display action when player needs specified off hand enchant"
   ROB_UI_AO_P_OHWEIB_TT      = "Input the name of the enchant\nExample1: |cFF00FF00Mind-Numbing Poison\94\51|r = display action when off hand does not\n       have Mind-Numbing Poison with at least 3 seconds left\nExample2: |cFF00FF00Frostbrand Weapon|r = display action when off hand does not have Frostbrand Weapon"




   ROB_UI_AO_TARGET_TAB       = "Target"
   ROB_UI_AO_T_HP_TT          = "Only display action when target meets specified hit points"
   ROB_UI_AO_T_HPIB_TT        = "Input the target hit points to check\nExample1: |cFF00FF00\60\57\48%|r means only display this action when target is under 90% hitpoints\nExample2: |cFF00FF00>90%|r means only display this action when target is over 90% hitpoints\nExample3: |cFF00FF00\60\61\57\48%|r means only display this action when target is under or equal to 90% hitpoints\nExample4: |cFF00FF00>=90%|r means only display this action when target is over or equal to 90% hitpoints\nExample5: |cFF00FF00=90%|r means only display this action when target is at exactly 90% hitpoints"
   ROB_UI_AO_T_MAXHP          = "Max HP:"
   ROB_UI_AO_T_MAXHP_TT       = "Only display action when target meets specified max hit points"
   ROB_UI_AO_T_MAXHPIB_TT     = "Input the target maximum hit points to check\nExample1: |cFF00FF00>1000000|r means only display this action when target has over 1 million maximum hitpoints"
   ROB_UI_AO_T_MAXHP          = "Max HP:"
   ROB_UI_AO_T_MAXHP_TT       = "Only display action when target meets specified max hit points"
   ROB_UI_AO_T_MAXHPIB_TT     = "Input the target maximum hit points to check\nExample1: |cFF00FF00>1000000|r means only display this action when target has over 1 million maximum hitpoints"
   ROB_UI_AO_T_NEEDBUFF       = "Needs Buff:"
   ROB_UI_AO_T_NEEDBUFF_TT    = "Only display action when target needs specified buff or buffs"
   ROB_UI_AO_T_NEEDBUFFIB_TT  = "Input the name of the buff or buffs\nSyntax: |cFF00FF00\124 |r= OR |cFF00FF00\38|r = AND |cFF00FF00\95|r = casted by target |cFF00FF00\35|r = number of stacks |cFF00FF00\94|r = refresh at seconds\nExample1: |cFF00FF00Earth Shield#2|r display action when target is missing 2 stacks of Earth Shield\nExample2: |cFF00FF00_Earth Shield#2|r display action when target is missing a player casted Earth Shield at 2 stacks\nExample3: |cFF00FF00_Earth Shield#2^3|r display action when target is missing a player casted Earth Shield at 2 stacks with >=3 seconds left\nExample4: |cFF00FF00Earth Shield||Inner Fire|r display action when target is missing Earth Shield or Inner Fire\nExample5: |cFF00FF00Earth Shield\38Inner Fire|r display action when target is missing both Earth Shield and Inner Fire"
   ROB_UI_AO_T_HAVEBUFF       = "Has Buff:"
   ROB_UI_AO_T_HAVEBUFF_TT    = "Only display action when target has the specified buff or buffs"
   ROB_UI_AO_T_HAVEBUFFIB_TT  = "Input the name of the buff or buffs\nSyntax: |cFF00FF00\124 |r= OR |cFF00FF00\38|r = AND |cFF00FF00\95|r = casted by target |cFF00FF00\35|r = number of stacks |cFF00FF00\94|r = refresh at seconds\nExample1: |cFF00FF00Earth Shield#2|r display action when target has 2 stacks of Earth Shield\nExample2: |cFF00FF00_Earth Shield#2|r display action when target has a player casted Earth Shield at 2 stacks\nExample3: |cFF00FF00_Earth Shield#2^3|r display action when target has a player casted Earth Shield at 2 stacks with >=3 seconds left\nExample4: |cFF00FF00Earth Shield||Inner Fire|r display action when target has Earth Shield or Inner Fire\nExample5: |cFF00FF00Earth Shield\38Inner Fire|r display action when target has both Earth Shield and Inner Fire"
   ROB_UI_AO_T_NEEDDB         = "Need Debuff:"
   ROB_UI_AO_T_NEEDDB_TT      = "Only display action when target is missing the specified debuff or debuffs"
   ROB_UI_AO_T_NEEDDBIB_TT    = "Input the name of the debuff or debuffs\nSyntax: |cFF00FF00\124 |r= OR |cFF00FF00\38|r = AND |cFF00FF00\95|r = casted by target |cFF00FF00\35|r = number of stacks |cFF00FF00\94|r = refresh at seconds\nExample1: |cFF00FF00Dark Plague#2|r display action when target is missing the debuff Dark Plague 2 stacks\nExample2: |cFF00FF00_Dark Plague#2|r display action when target is missing a player casted Dark Plague at 2 stacks\nExample3: |cFF00FF00_Dark Plague#2^3|r display action when target is missing a player casted Dark Plague at 2 stacks with >=3 seconds left\nExample4: |cFF00FF00Dark Plague|Forbearance|r display action when target is missing Dark Plague or Forbearance debuffs\nExample5: |cFF00FF00Dark Plague\38Forbearance|r display action when target is missing both Dark Plague and Forbearance debuffs"
   ROB_UI_AO_T_HAVEDB         = "Have Debuff:"
   ROB_UI_AO_T_HAVEDB_TT      = "Only display action when target has the specified debuff or debuffs"
   ROB_UI_AO_T_HAVEDBIB_TT    = "Input the name of the debuff or debuffs\nSyntax: |cFF00FF00\124 |r= OR |cFF00FF00\38|r = AND |cFF00FF00\95|r = casted by target |cFF00FF00\35|r = number of stacks |cFF00FF00\94|r = refresh at seconds\nExample1: |cFF00FF00Dark Plague#2|r display action when target has the debuff Dark Plague 2 stacks\nExample2: |cFF00FF00_Dark Plague#2|r display action when target has a player casted Dark Plague at 2 stacks\nExample3: |cFF00FF00_Dark Plague#2^3|r display action when target has a player casted Dark Plague at 2 stacks with >=3 seconds left\nExample4: |cFF00FF00Dark Plague|Forbearance|r display action when target has Dark Plague or Forbearance debuffs\nExample5: |cFF00FF00Dark Plague\38Forbearance|r display action when target has both Dark Plague and Forbearance debuffs"
   ROB_UI_AO_T_CLASS          = "Target Class:"
   ROB_UI_AO_T_CLASS_TT       = "Only display action if the target is one of the specified clases"
   ROB_UI_AO_T_CLASSIB_TT     = "Input the list of target classes seperated by |\nExample: |cFF00FF00DRUID||WARRIOR|r means only display this action if the target is a druid or warrior"
   ROB_UI_AO_T_PC             = "Player controlled"
   ROB_UI_AO_T_PC_TT          = "Only display action if target is player controlled"
   ROB_UI_AO_T_INTERRUPT      = "Interrupt:"
   ROB_UI_AO_T_INTERRUPT_QTT  = "Search for a spell name in the interrupt list"
   ROB_UI_AO_T_INTERRUPT_M    = "Enter the name of the spell to search for"
   ROB_UI_AO_T_INTERRUPT_M1   = "Interrupt list is blank"
   ROB_UI_AO_T_INTERRUPT_M2   = " |cFFFF0000NOT FOUND|r (Spell name may not have verticals bars around the name) \nBad Example:|Shadow Nova \nGood Example:|Shadow Nova|"
   ROB_UI_AO_T_INTERRUPT_M3   = " |cFF00FF00FOUND|r"
   ROB_UI_AO_T_INTERRUPT_TT   = "Use this action to interrupt the target when its casting one of the spells in the specified list"
   ROB_UI_AO_T_INTERRUPTIB_TT = "Input the list of spells to interrupt surrounded by |\nExample1: |cFF00FF00||Polymorph||Fear|||r\nExample2: |cFF00FF00||Polymorph|||r just interrupts Polymorph"


   ROB_UI_AO_PET_TAB          = "Pet"
   ROB_UI_AO_PET_HP_TT        = "Only display action when pet meets specified hit points"
   ROB_UI_AO_PET_HPIB_TT      = "Input the pet hit points to check\nExample1: |cFF00FF00\60\57\48%|r means only display this action when pet is under 90% hitpoints\nExample2: |cFF00FF00>90%|r means only display this action when pet is over 90% hitpoints\nExample3: |cFF00FF00\60\61\57\48%|r means only display this action when pet is under or equal to 90% hitpoints\nExample4: |cFF00FF00>=90%|r means only display this action when pet is over or equal to 90% hitpoints\nExample5: |cFF00FF00=90%|r means only display this action when pet is at exactly 90% hitpoints"
   ROB_UI_AO_PET_ISAC         = "Autocasting:"
   ROB_UI_AO_PET_ISAC_TT      = "Only display action when pet is autocasting specified spell"
   ROB_UI_AO_PET_ISACIB_TT    = "Input the name or spellid of the pet spell to check\nExample1: |cFF00FF00Growl|r\nExample2: |cFF00FF00\50\54\52\57|r"
   ROB_UI_AO_PET_NAC          = "Not Autocasting:"
   ROB_UI_AO_PET_NAC_TT       = "Only display action when pet is not autocasting specified spell"
   ROB_UI_AO_PET_NACIB_TT     = "Input the name or spellid of the pet spell to check\nExample1: |cFF00FF00Growl|r\nExample2: |cFF00FF00\50\54\52\57|r"     
   
   ROB_UI_AO_FOCUS_TAB        = "Focus"
   ROB_UI_AO_F_HP_TT          = "Only display action when focus meets specified hit points"
   ROB_UI_AO_F_HPIB_TT        = "Input the pet hit points to check\nExample1: |cFF00FF00\60\57\48%|r means only display this action when focus is under 90% hitpoints\nExample2: |cFF00FF00>90%|r means only display this action when focus is over 90% hitpoints\nExample3: |cFF00FF00\60\61\57\48%|r means only display this action when focus is under or equal to 90% hitpoints\nExample4: |cFF00FF00>=90%|r means only display this action when focus is over or equal to 90% hitpoints\nExample5: |cFF00FF00=90%|r means only display this action when focus is at exactly 90% hitpoints"
   
   
   ROB_ACTION_MOVEUP_TT       = "Move selected action up one position"
   ROB_ACTION_MOVEDOWN_TT     = "Move selected action down one position"
   ROB_ACTION_REMOVE_TT       = "Remove action from list"

   ROB_LOADED                 = "Rotation Builder v%s loaded"

   -- Dialog Prompt
   ROB_PROMPT_LIST_DELETE     = "Are you sure you want to delete this rotation?"

   -- Options
   ROB_OPTION_MINIMAPO        = "Minimap Options:"
   ROB_OPTION_MINIMAP         = "Minimap button:"
   ROB_OPTION_MINIMAP_TT      = "Toggle Minimap Button"
   ROB_OPTION_MINIMAPPOS      = "Position Around Minimap"
   ROB_OPTION_MMPOS_CV        = "300"
   ROB_OPTION_MMPOS_MIN       = "1"
   ROB_OPTION_MMPOS_MAX       = "360"
   ROB_OPTION_MINIMAPRAD      = "Radius Outside Minimap"
   ROB_OPTION_MMRAD_CV        = "80"   
   ROB_OPTION_MMRAD_MIN       = "1"
   ROB_OPTION_MMRAD_MAX       = "120"
   ROB_OPTION_ICONS           = "Icon Options:"
   ROB_OPTION_ICONSCALE       = "Icon Scale:"
   ROB_OPTION_ICONS_CV        = "1"
   ROB_OPTION_ICONS_MIN       = ".1"
   ROB_OPTION_ICONS_MAX       = "3.5"
   ROB_OPTION_ICONS_T_A       = "Toggle Icons Transparency:"
   ROB_OPTION_ICONS_C_A       = "Current Action Transparency:"
   ROB_OPTION_ICONS_N_A       = "Next Action Transparency:"
   ROB_OPTION_ICONS_T_ATT     = "Enter the transparency level for the icon\n |cFF00FF00.1|r to |cFF00FF00 1|r\n|cFF00FF00 1|r is fully visible\n|cFF00FF00 .1|r is near invisible"
   
   ROB_OPTION_IMPORT          = "Import / Export Options:"   
   ROB_OPTION_LOCKICONS       = "Lock icons"
   ROB_OPTION_LOCKICONS_TT    = "Lock icons to prevent movement"
   ROB_OPTION_OVERWRITE       = "Overwrite"
   ROB_OPTION_OVERWRITE_TT    = "Allow importing rotations to overwrite existing rotations"
   ROB_OPTION_LOADDEFAULT     = "LOAD"
   ROB_OPTION_LOADDEFAULT_TT  = "Load default rotations for your class"
   ROB_OPTION_EXPORTBINDS     = "Export binds"
   ROB_OPTION_EXPORTBINDS_TT  = "Export action key binds with export"
   ROB_OPTION_UI              = "UI Options:"  
   ROB_OPTION_UISCALE         = "UI Scale:"
   ROB_OPTION_UISCALE_ADD     = "+"
   ROB_OPTION_UISCALE_MIN     = "-"

   
   ROB_OPTION_RESETUI         = "Reset UI"
   ROB_OPTION_RESETUI_TT      = "Reset UI Window Locations"
   ROB_OPTION_RESETUI_EXP     = "Reset all UI windows to center of screen"
end