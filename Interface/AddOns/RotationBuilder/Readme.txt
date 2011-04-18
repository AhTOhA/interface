[b]Description:[/b]
Rotation Builder allows you to build rotations dynamically without having to understand the Lua script language. The built rotation then displays the current action and the next action on your screen to tell you what to push next. Actions can be heavily customized with the General, Player, Target, Pet, and Focus tabs. The priority of actions can also be changed dynamically just by clicking the up and down arrows next to the action name in the Action list.

Included Rotations:
[B][COLOR="Orange"]DRUID[/COLOR][/B] 4.0.3 Cat, 4.0.3 Balance
[B][COLOR="Green"]HUNTER[/COLOR][/B] 4.0.6 MM, 4.0.6 Survival
[B][COLOR="Cyan"]MAGE[/COLOR][/B] 4.0.3 Fire Hover, 4.0.3 Fire Burn, 4.0.6 Arcane
[B][COLOR="pink"]PALADIN[/COLOR][/B] 4.0.3 Ret - AoE, 4.0.3 Ret - Max DPS, 4.0.3 Ret - No AoE, 4.0.3 Tank - Dungeon, 4.0.3 Tank - Single Break CC, 4.0.3 Tank - Single Keep CC
[B][COLOR="White"]PRIEST[/COLOR][/B] 4.0.6 Shadow
[B][COLOR="Yellow"]ROGUE[/COLOR][/B] 4.0.3 Combat
[B][COLOR=#5877d4]SHAMAN[/COLOR][/B] 4.0.6 Enhancement, 4.0.6 Elemental
[B][COLOR="Purple"]WARLOCK[/COLOR][/B] 4.0.6 Destro, 4.0.6 Affliction, 4.0.6 Affliction Drain
[B][COLOR="Brown"]WARRIOR[/COLOR][/B] 4.0.6 Arms, 4.0.6 Arms AE, 4.0.6 Fury, 4.0.6 Fury AE
[B][COLOR="Red"]DEATHKNIGHT[/COLOR][/B] 4.0.3 Unholy PvE, 4.0.3 Frost PvE, 4.0.3 Blood PvE Solo, 4.0.3 Frost No AoE, 4.0.3 Frost AoE

To load the latest rotation just click on the options tab in the top left and click the LOAD button. The latest version of the rotation will be imported.

[b]How to build a rotation:[/b]
[list=1]Open your blizzard keybinds window and scroll down to find Rotation Builders keybinds
[*]For now just bind the Toggle 1 through Toggle 4 to some keys. This will be explained later.
[*]Show the rotation builder window with /rob show or using the minimap button
[*]Default rotations should be provided for your class under the Rotation Name box in
    the upper left. If there are no rotations then I haven't gotten around to making a default
    one for you yet ;)
[*]You can modify an existing rotation by left clicking on it or creating a new one with the
    create button.
[*]Once you have the rotation selected click the modify button to go into the edit mode.
[*]Once you are in edit mode you can change the rotation name and edit/add/re-arrange Actions.
[*]You need to set the keybind that selects this rotation by left clicking the keybind
    button at the top of the window under the rotation name box.
[*]To select a Action just left click the action name in the top right Action list box.
[*]All the options for the selected action are in the three tabs below General,Player,Target
    If you mouseover each option it will tell you what it does.
[*]Once you are done editing your Actions and Rotation click the Save button.
[*]You can close the rotation window now and to select that rotation hit the button you bound
    in step 8.
[*]At this point you should have two icons displayed from your rotation. The top one is the
    current action and the bottom one is the next action.
[/list]

[b]FAQ:[/b]
[list]Q: What are toggles?
    A: Toggles are a way to change your rotation dynamically with a keybind.
 
       Example: There is a boss fight where if you cleanse yourself you blow up the raid.
          What you can do is put cleanse in your rotation but check the toggle box.
          Set the Toggle to Toggle 1 so the cleanse icon will only show up if Toggle 1
          is turned on. Now when you get to that boss in the raid you can turn off cleanse
          by hitting the key you bound to Toggle 1 in the blizzard keybinds.
          
[*]Q: Why is my Spell X not working?
    A: More than likely you spelled something wrong or blizzard functions arent finding your spell.
       Here is what you can do to see why your action is not showing.
       
       1. Open the blizzard keybinds and scroll down to find the Rotation Builder keybind
          for Toggle Debug and bind it to a key.
       2. Now edit your rotation and click on the General tab of the action that is not working.
       3. Click the Debug check box on the far right for that action.
       4. Save the rotation.
       5. Turn on debug with the key you bound in step 1. You will see a DEBUG ON message in chat.
       6. Go through your rotation until you hit your action that is not working.
       7. The chat window will spam why the action is not displaying.
       8. For example. If it says NOT showing A: youractionname S: spellname because its out of
          range then that means you are checking range but you shouldn't be on self buffs.

[*]Q: Debug says X does not have buffs or debuffs?
    A: The buff and debuff name matching can be a pain, try using the spell name first. If the spell name isnt matching to the buff you can turn on your combat log to get the actual spellID to use instead.
       
[*]Q: How do I get rid of an existing rotation so I can import a rotation with the same name?
    A: You have two options:
       1. Delete the rotation with the same name.
       2. Modify the rotation blocking the import.
          Rename the rotation to something else.
          Click Save.
          Delete the old copy of the rotation.
          Reclick Import or reclick the LOAD button.
          
[*]Q: Why is the next action showing spells ready when they are not ready?
    A: The next action prediction logic ignores power type checks such as mana, energy ,rage by default. This gives you the option to show what is coming up regardless if you have the power to cast it. If you don't like to see next actions when you dont have the power to cast them you can specify a power requirement on the action in the player tab and the action will no longer show up in the next action if you dont meet the specified power.

[/list]
1.28
-Improved next action prediction logic a little bit to not showing actions that have the same spellname as the current action
-Added v1.28 Warrior SMF rotation
-Added v1.28 Hunter BM rotation
-Added v1.28 Paladin Holy DPS rotation?
-Added pet buff and debuff checking
-Added saved last selected rotation per character

1.27
-Changed Shaman GCD spell to Lightning Shield
-Changed DK GCD spell from Blood Boil to Frost Presence (Fixes actions that show ready but are on cooldown)
-Changed Mage GCD spell from Evocation to Remove Curse (Fixes actions showing ready on cooldown after Evocation used)
-Changed Hunter GCD spell from Flare to Beast Lore (Fixes actions showing ready on cooldown after Flare used)
-Changed Priest GCD spell from Shoot to Smite (Shoot cd is not modified by haste)

1.26
-Added out of range tinting to actions. Any actions that dont specify a tint color in the
 action rangespell use the old out of range icon by default.
_Added next action location option to options tab
-Removed the rotation rangespell as it is no longer used with new action range checking
-Fixed Shaman Enhancement: Earth Shock showing as next ready when unleash elements is up for Flame Shock

1.25
-Fixed a bug with the export button not exporting the check range in the general tab
 This has no effect on existing rotations only the default ones I ship with the addon.
 
-Paladin LoH,Divine Plea, Word of Glory, Inquisition, seals range checking fixed
-Hunter MM Readiness, and Kill Command range checking fixed
-Mage PoM,Arcane power range checking fixed
-Priest Shadowfiend, Archangel range checking fixed
-Rogue SnD,Poisons and Recuperate range checking fixed
-Shaman Feral Spirit, Flametongue Weapon, Lightning Shield .. and more fixed
-Warlock Life Tap, Fel Armor, Soulburn, Demon Soul, Shadowflame... and more fixed
-Warrior Battel Shout, Recklessness, Death Wish Inner Rage.. and more fixed
-DK range fixes

1.24
-Update Paladin rotations to 4.0.6

1.23
-Removed next action debug, it was confusing (current action debug still exists)
-Changed Break Channeling to check for channeling or casting (Renamed to Interrupt Casting)
-Removed the ability to overwrite rotations (Defaulted to just not allow overwriting when importing)
 If you have an existing rotation blocking a import you can rename it, save it and import again.
-Added robustness to import button to handle typos on action names

1.22
-Fixed cooldown checking on inventory slots, was causing inventory actions to show ready when not ready
-Added libDataBroker (Enables docking in DockingStation type addons)
-Fixed a bug when switching between rotations in the editor it would show a previous rotation action
-Added Warrior 4.0.6 Fury and Fury AE rotations
-Updated Warrior Arms to 4.0.6 and added Arms 4.0.6 AE
-Added 4.0.6 Arcane Mage rotation
-Updated Warlock Destruction to 4.0.6
-Added 4.0.6 Affliction and Affliction Drain

1.21
-Line 435 Error fix (happens when you cast a interrupt spell on a target that hasnt casted)
-Fixed error when changing transparency of icons

v1.20
-Added 4.0.6 MM Hunter rotation
-Fixed next action icon not scaling with options
-Fixed Import rotation button to correctly import the \n newline character in a rotation export
-Fixed Recuperate in 1.20 Rogue Combat rotation
-Added debug to explain why next ready actions dont show up
-Fixed next spell prediction to be able to use spell IDs for last casted matching
-Fixed max number of casts and last casted options not tracking correctly
-Added 4.0.6 Survival v1.20 Hunter rotation with Lock and Load
-Updated priest Shadow rotation to 4.0.6
-Added UI scale option to options tab
-Added transparency options to icons in options tab

v1.19
-Changed the toggle icon default to be blank so it wont export it when user blanks it out
-Changed Priest default shadow rotation to break channel on Mind Flay so Mind Flay shows first
-Fixed parsing multiple buffs or debuffs with | seperator
-Changed the way current spells and next spells are display so that as soon as you cast it goes to next action
 This gives more time to see what you are supposed to cast next
-Fixed Savage Roar in cat rotation v1.19 (use LOAD button to import it)
-Fixed Shaman Totems checks not saving
-Removed here debug when exporting a rotation
-Fixed Searing Totem in Enhancement
-Changed Soul Fire to not display when lusted or warped in Destro rotation 1.19

v1.18
-Fixed another bug with buff parsing not parsing buff spellIDs (Thanks Kuronami)
-Fixed Exorcism in v1.18 Ret Paladin rotations

v1.17
-Fixed buff and debuff parsing matching just one when using & symbol (Thanks azpitt)

v1.16
-Added pet autocasting and pet not autocasting to pet options tab
-Removed Slicing Gale from default ret rotation interrupts
-Added spell validation to the spellname so you can lookup spell IDs using the spellname box
-Changed next spell ready prediction logic to ignore if spells can break channeling or not
   (This allows Frostbolt to show up as next spell while channeling Arcane Missiles)
-Fixed player needs debuff checking
-Made buffname and debuff name matching more flexible
-Fixed Lay on Hands in all paladin default rotations
-Added spell name validator to general tab (can also be used to lookup spell ids)
-Huge memory leak fix
-More fixes to check buffs and debuffs
-Another fix to next ready action not clearing when no target selected
-Fixed import export buttons being disabled when starting with no rotations
-Added Fire Burn and Fire Hover default mage rotations
-Added default rogue combat rotation
-Added default shadow priest rotation
-Expanded the interrupt list box so you can type new line and label interrupts PvP: |Polymorph|Fear|

v1.15
-Line 2729 range fix

v1.14
-Fixes to all of the paladin rotations
-Fixes to Balance dps rotation Sunfire, IS/MF,SF delay when close to procing eclipse
-Fixed Balance rotation not showing sunfire (Have to use wowhead spellID for sunfire)
-Fixes to Enhancement default rotation
-Changed the save button to select the last edited rotation upon saving
-Fixed toggle icons not showing up without selecting a target
-Fixed pet and focus health checks
-Added the ability to specify percentages in unit power checks and generates power
-Fixed keybind not clearing when you hit escape on a rotation keybind
-Added Affliction,Destruction rotations (untested but wanted to get them in)
-Added Arms rotation (untested but wanted to get them in)

v1.13
-Added the ability to use spell ids in buff and debuff checking
-Another out of range icon being displayed fix
-Added Pet and Focus tabs for future options (Only has hitpoints for now)
-Changed the display of current actions to show actions even if you dont have the mana
 (To hide actions that require specific mana the power option in the player tab can be used)
-Added last casted prediction logic to next action
-Added Check moving to general tab
-Added MH/OH weapon enchants to 4.0.3 Enhancement default rotation
-Fixed Shaman default enhancement Earth Shock spell
-Fixed a bug with export not exporting the range check in general tab

v1.12
-Added default Death Knight rotations Frost AE, Frost Single, Frost Max dps, Blood solo
-Fixed an export bug when rotation has no range spell set
-Fixed out of range texture not displaying correctly
-Fixed next action not clearing when no next actions are ready
-Fixed the start rotation of Druid Balance DPS when eclipse has no direction
-Added robustness to ignore misspelled rotation range spell name (3189 Error if you see it)

v1.11
-Combo point error fix

v1.10
-Localization updates
-Added ability to specify <,>,<=,>=,= Combo points
-Fixed out of range icon not showing up when no next actions are ready
-Fixed debug not telling you when you misspelled a spell name
-Added default rotation for Druid Cat DPS (Full John Madden)
-Added default rotation for Druid Balance DPS
   (This took adding some features but I think I have airborn eclipse transition prediction working)
-Fixed a bug in havebuff/needbuff checking not recognizing multiple buff requirements

v1.9
-Fixed 3001 error when trying to use a rotation that has a spell you dont have
-Fixed selecting rotation using the rotation list clicking not actually selecting rotation

v1.8
-Fixed next action logic
-Added code to prevent bad import strings

v1.7
-Fixed rotation bindings not saving
-Fixed combo point prediction logic
-Changed next action prediction logic
 
v1.6
-Added logic to predict combo point generation for next spells
-Added logic to predict power generation for next spells
-Added logic to predict rune generation for next spells
 
v1.5
-Initial upload
 
Todo:
Remove the rotation rangespell
