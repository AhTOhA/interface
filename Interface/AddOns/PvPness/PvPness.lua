-- PvPness!
PvPness = LibStub("AceAddon-3.0"):NewAddon("PvPness","AceConsole-3.0","AceEvent-3.0")

local pvp = PvPness
--stuff other files need access to
pvp.bg = { anchor=nil, name=nil, children={}, mode=nil }
pvp.pvpBar = { id=nil, bar=nil, data=nil }
pvp.modules = { AB={},AV={},BfG={},EotS={},IoC={},SotA={},WSG={} }
--colors
pvp.classColors = RAID_CLASS_COLORS
pvp.classColors["UNKNOWN"] = { r=192/255, g=192/255, b=192/255 }
pvp.teamColors = { {r=240/255, g=30/255, b=20/255}, {r=0, g=180/255, b=240/255} }

--local access
local bg = pvp.bg
local pvpBar = pvp.pvpBar
local modules = pvp.modules
local classColors = pvp.classColors
local teamColors = pvp.teamColors
local enemyTeam = { count=0, maxPlayers=0, who={} }
local defaultRealm = ""
local enemy = nil
local settings = nil

--functions localized
local UnitName = UnitName
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local GetBattlefieldScore = GetBattlefieldScore
local GetWorldStateUIInfo = GetWorldStateUIInfo
local GetBattlefieldInstanceRunTime = GetBattlefieldInstanceRunTime
local strfind = strfind

--bg names
local av = "Alterac Valley"
local ab = "Arathi Basin"
local bfg = "The Battle for Gilneas"
local eots = "Eye of the Storm"
local ioc = "Isle of Conquest"
local sota = "Strand of the Ancients"
local tp = "Twin Peaks"
local wsg = "Warsong Gulch"

--debugging stuff, obv
local debugging = false
local dbg = nil



-- pvp:OnInitialize -----------------------------------------------------------
function pvp:OnInitialize()
  settings = (_settings or {})
  --need some defaults
  if(not settings.fontKey) then
    settings.fontKey="Arial Narrow"
    settings.font="Fonts\\ARIALN.TTF"
  end
  if(not settings.textKey) then
    settings.textKey="Blizzard"
    settings.texture="Interface\\TargetingFrame\\UI-StatusBar"
  end
  if(not settings.fontSize)  then settings.fontSize=10  end
  if(not settings.titleSize) then settings.titleSize=18 end
  if(not settings.hp) then settings.hp=0 end
  if(not settings.cp) then settings.cp=0 end

  dbg = (_dbg or {})
  pvp:RegisterChatCommand("teamspy","TeamSpy")
end

-- pvp:OnEnable ---------------------------------------------------------------
function pvp:OnEnable()
  pvp:Print("enabled")
 
  defaultRealm = GetRealmName()
  if(UnitFactionGroup("player") == "Horde") then enemy=2 else enemy=1 end
 
  pvp:RegisterEvent("PLAYER_LOGOUT","SaveSettings") 
  pvp:RegisterEvent("ZONE_CHANGED_NEW_AREA","GetZone")
  pvp:GetZone()
end

-- pvp:OnDisable --------------------------------------------------------------
function pvp:OnDisable()
  pvp:Print("disabled")
  pvp:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
end

-- pvp:GetSettings ------------------------------------------------------------
function pvp:GetSettings(s)
  if(not s) then
    return settings
  else
    return settings[s]
  end
end

-- pvp:SetSettings ------------------------------------------------------------
function pvp:SetSettings(name,value)
  settings[name] = value
end

-- pvp:SaveSettings -----------------------------------------------------------
function pvp:SaveSettings()
  local anchor = bg.anchor
  if(anchor) then
    settings.x = anchor:GetLeft()
    settings.y = anchor:GetTop()
  end
  _settings = settings
  if(debugging) then _dbg=dbg end
end


-- pvp:GetTeamNumber ----------------------------------------------------------
function pvp:GetTeamNumber()
  return 3-enemy
end


-- GetEnemyTeam ---------------------------------------------------------------
local function GetEnemyTeam()
  local numPlayers = GetNumBattlefieldScores()
 
  -- GetBattlefieldScore returns 0/1 for horde/alliance
  local team = enemy-1
  local enemyTeam = enemyTeam
  local defaultRealm = defaultRealm
 
  for i=1,numPlayers do
    local realmName,_,_,_,_,faction,_,_,class = GetBattlefieldScore(i)
    if(faction == team) then
      local _,_,name,realm = strfind(realmName,"(.-)%s*%-%s*(.+)") --this works for hyphenated servers now
      if(not name) then
        name = realmName
        realm = defaultRealm
      end
      if(not enemyTeam.who[name]) then
        enemyTeam.who[name] = { what=class, where=realm}
      end
    end
  end
end

-- GetPlayerClass -------------------------------------------------------------
local function GetPlayerClass(who,refreshed)
  local enemyTeam = enemyTeam
  if(not enemyTeam.who[who]) then --who may have joined in progress
    GetEnemyTeam()
    if(not enemyTeam.who[who].what) then
      pvp:Debug("GetPlayerClass - enemyTeam.who["..who.."].what was nil")
    end
  end
 
  local class = enemyTeam.who[who].what
  if(not class) then
    if(not refreshed) then
      GetEnemyTeam() --go through the scoreboard once more to refresh enemyTeam
      return GetPlayerClass(who,true)
    else
      return "UNKNOWN" --if for some odd reason, player is still not found (something probably broke)
    end
  else
    return class
  end
end

-- GetPlayerRealm -------------------------------------------------------------
local function GetPlayerRealm(who,refreshed)
  local enemyTeam = enemyTeam
  if(not enemyTeam.who[who]) then
    GetEnemyTeam()
    if(not enemyTeam.who[who].where) then
      pvp:Debug("GetPlayerClass - enemyTeam.who["..who.."].where was nil")
    end
  end
 
  local realm = enemyTeam.who[who].where
  if(not realm) then
    if(not refreshed) then
      GetEnemyTeam()
      return GetPlayerRealm(who,true)
    else
      return "Unknown"
    end
  else
    return realm
  end
end



-- CreateAnchor ---------------------------------------------------------------
local function CreateAnchor()
  local anchor = CreateFrame("Frame","anchor",UIParent)
  anchor:SetFrameStrata("BACKGROUND")
  anchor:SetWidth(200)
  anchor:SetHeight(20)
 
  -- title of anchor bar
  local title = anchor:CreateFontString(nil,"ARTWORK")
  title:SetPoint("LEFT", anchor, 5, 0)
  anchor.title = title
 
  return anchor
end

-- pvp:ToggleAnchorMove -------------------------------------------------------
function pvp:ToggleAnchorMove()
  local anchor = bg.anchor
  if(not anchor) then return end
 
  if(settings.lock) then
    anchor:SetMovable(false)
    anchor:EnableMouse(false)
    anchor:RegisterForDrag(nil)
    anchor:SetScript("OnDragStart",nil)
    anchor:SetScript("OnDragStop",nil)  
  else
    anchor:SetMovable(true)
    anchor:EnableMouse(true)
    anchor:RegisterForDrag("LeftButton")
    anchor:SetScript("OnDragStart", anchor.StartMoving)
    anchor:SetScript("OnDragStop", anchor.StopMovingOrSizing)
  end
end  

-- CreateStart ----------------------------------------------------------------
local function CreateStart(bgName)
  local bgTime = floor(GetBattlefieldInstanceRunTime()/1000 +0.5)
  local t

  if(bgName == sota) then --sota seems to be the only different one now
    t = 91 - bgTime       --thought ioc was different too
  else
    t = 121 - bgTime
  end
  if(t<0) then t=0 end
 
  local start = pvpBar:new("Start")
  start:CreateBar(200,20,nil,-22)
 
  local func = function()
    start:SetInfo("")
    start:Hide()
    pvp:GetBars() --shows bg specific bars
    pvp:UnregisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
  end
 
  start:SetFinished(func)
  start:Countdown(t)
  start:Show()
end

-- Start ----------------------------------------------------------------------
local function Start(bgName)
  --create/update anchor
  local bg = bg
  if(not bg.anchor) then
    bg.anchor=CreateAnchor()
    pvp:ToggleAnchorMove()
  end
  bg.anchor.title:SetFont(settings.font,settings.titleSize,"THICKOUTLINE") --reseting it everytime is just easier
  bg.anchor.title:SetText(bgName)
  bg.anchor:SetPoint("CENTER",0,0)
  --really seems like there should be a better way to do this
  local x = bg.anchor:GetLeft()
  local y = bg.anchor:GetTop()
  x = (settings.x or x) - x
  y = (settings.y or y) - y
  bg.anchor:SetPoint("CENTER",x,y)
  bg.anchor:Show()
 
  --create start time countdown bar
  CreateStart(bgName)
  if(bg.children["Start"]:IsRunning()) then
    pvp:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL","GetNeutralMsg") --sync countdown
  end
 
  --bg modules
  if(bgName == av) then
    bg.mode = pvp.modules.AV
  elseif(bgName == ab) then
    bg.mode = pvp.modules.AB
  elseif(bgName == bfg) then
    bg.mode = pvp.modules.BfG
  elseif(bgName == eots) then
    enemyTeam.maxPlayers = 15
    bg.mode = pvp.modules.EotS
  elseif(bgName == ioc) then
    bg.mode = pvp.modules.IoC
  elseif(bgName == sota) then
    bg.mode = pvp.modules.SotA
  elseif(bgName == wsg or bgName == tp) then --tp is the exact same as wsg as far as i can tell
    enemyTeam.maxPlayers = 10
    bg.mode = pvp.modules.WSG
  end
 
  bg.mode:Start()
  --register bg events
  pvp:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE","EventHandler")
  pvp:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE","EventHandler")
end

-- End ------------------------------------------------------------------------
local function End()
  pvp:UnregisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
  pvp:UnregisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
  pvp:UnregisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
 
  local bg = bg
  bg.mode:End()
  bg.name = nil
  bg.mode = nil
 
  for c in pairs(bg.children) do
    bg.children[c]:delete()
  end
  bg.anchor:Hide()
  bg.children = {}
 
  --reset enemy team
  enemyTeam = { count=0, maxPlayers=0, who={} }
 
  --4.0.1 indeces: 390 Conquest, 392 Honor, 395 Justice
 
  --name,amount,texture,unknown,weeklyMax,totalMax = GetCurrencyInfo
  --unknown is thought to be weekly amount

  local _,hp = GetCurrencyInfo(392)
  local _,cpTotal,_,cpWeekly,cpWeeklyMax = GetCurrencyInfo(390)
 
  if(hp >= settings.hp) then pvp:Print("Honor Points: "..hp) end
  if(cpTotal >= settings.cp) then
    local cp = "Conquest Points: "..cpTotal
    if(settings.cpWeekly) then cp=cp.." (this week: "..cpWeekly.."/"..cpWeeklyMax..")" end
    pvp:Print(cp)
  elseif(settings.cpWeekly) then
    pvp:Print(cpWeekly.."/"..cpWeeklyMax.." Weekly Conquest Points")
  end
end



-- pvp:GetNeutralMsg ----------------------------------------------------------
function pvp:GetNeutralMsg(event,msg)
  local search = "(%d+) (%a+)"
  if(bg.name ~= av or bg.name ~= ioc) then search=search.."%p" end --av and ioc (i think) do "60 seconds until..."
  local _,_,t,u = strfind(msg,search)
  if(t) then
    if(strfind(u,"minute")) then t=t*60 end
    bg.children["Start"]:SetTime(t+1)
  end
end

-- pvp:GetZone ----------------------------------------------------------------
function pvp:GetZone()
  local bgName, instanceType = GetInstanceInfo()
 
  if(instanceType == "pvp") then
    bg.name = bgName
    Start(bgName)
  elseif(bg.name) then End() end
end

-- pvp:EventHandler -----------------------------------------------------------
function pvp:EventHandler(event,...)
  bg.mode:EventHandler(event,...)
end

-- pvp:GetBars ----------------------------------------------------------------
function pvp:GetBars()
  local bg = bg
  for p in pairs(bg.children) do
    if(p ~= "Start" and p ~= "Final") then --should make a flag for this so it's more generic
      bg.children[p]:Show()                 --and add another flag for pvpBar:Create for the same reason
    end
  end
end



-- DecToHex -------------------------------------------------------------------
local function DecToHex(d)
  local hexTable = { '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' }
 
  local rem = floor(mod(d,16))
  local hex = floor(d/16)
 
  return(hexTable[hex+1]..hexTable[rem+1])
end

-- RGBToHex -------------------------------------------------------------------
local function RGBToHex(rgb)
  return(DecToHex(ceil(rgb.r*255 - 0.5))..DecToHex(ceil(rgb.g*255 - 0.5))..DecToHex(ceil(rgb.b*255 - 0.5)))
end

-- pvp:TeamSpy ----------------------------------------------------------------
function pvp:TeamSpy()
  GetEnemyTeam()
  local enemyTeam = enemyTeam
 
  local realmList = {}
  local classColors = classColors
  local gray = '|cff999999'
  local count = 0
  for p in pairs(enemyTeam.who) do
    local realm = GetPlayerRealm(p)
    if(not realmList[realm]) then realmList[realm]={} end
    tinsert(realmList[realm], p)
  end
  for r in pairs(realmList) do
    local order = {}
    --local players = gray..r.." - "..'|r'
    local list = gray..r.." - "..'|r'
    for i,p in ipairs(realmList[r]) do
      local class = GetPlayerClass(p)
      if(not order[class]) then order[class]={} end
      --players = players..'|cff'..RGBToHex(classColors[class])..p..'|r'..gray..", "..'|r'
      tinsert(order[class],'|cff'..RGBToHex(classColors[class])..p..'|r'..gray..", "..'|r')
      count = count+1
    end
    for c in pairs(order) do
	  for j,n in ipairs(order[c]) do list=list..n end
    end
    --pvp:Print(players)
    pvp:Print(list)
  end 
  pvp:Print(count.." players")
end



-- pvp:BGNode -----------------------------------------------------------------
function pvp:BGNode(id,w,h,buf)
  local node = pvpBar:new(id)
  node:CreateBar((w or 200),(h or 15),buf)
 
  --these bars won't autohide
  local func = function()
    node:Stop() --stops any countdown in progress
    node:SetMaxValue(1)
    node:SetValue(1)
    node:SetInfo("") --don't hide this, just make it blank
  end
 
  node:SetFinished(func)
  return node
end




-- pvp:FlagTarget -------------------------------------------------------------
function pvp:FlagTarget()
  if(not bg.mode) then pvp:Debug("pvp:FlagTarget - bg.mode was nil") ; return end
  local flagTable = bg.mode:GetFlag()
  if(not flagTable) then pvp:Debug("pvp:FlagTarget - flagTable was nil") ; return end
 
  for i,p in ipairs(flagTable) do
    local data = p:GetData()
    if(not data) then pvp:Debug("pvp:FlagTarget - data was nil") ; return end
    local recent = data.recent
    local isTarget = data.isTarget
    local name = p:GetName()
 
    -- DESIGN CHANGE: isTarget = true whenever the target is correct
 
    --flag grab in combat: isTarget = false; recent = nil OR prev; name = player
    if(not isTarget and not strfind(name, " Flag")) then
      if(data.saved[recent]) then data.saved[recent]:Hide() end
      if(not data.saved[name]) then
        local t = p:SetTarget(name)
        data.saved[name] = t
      end
      data.saved[name]:Show()
      p:SetAlpha(.9)
      data.recent = name
      data.isTarget = true
      pvp:UnregisterEvent("PLAYER_REGEN_ENABLED")
 
    --flag drop in combat: isTarget = false; recent = prev; name = flag
    elseif(not isTarget and strfind(name, " Flag")) then
      if(data.saved[recent]) then data.saved[recent]:Hide() end --recent might be nil if game in progress
      p:SetAlpha(.9)
      data.recent = nil
      data.isTarget = true
      pvp:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
  end
end

-- pvp:FlagGrab ---------------------------------------------------------------
function pvp:FlagGrab(who,team,flag)
  local class = "UNKNOWN"
 
  flag:SetName(who)
  if(team == enemy) then
    class = GetPlayerClass(who)
    flag:SetHealth() --no args will set info to ??
    pvp:RegisterEvent("PLAYER_TARGET_CHANGED","GetTargetHealth")
    pvp:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED","GetEnemyHealth")
  else
    _,class = UnitClass(who)
    flag:SetHealth(UnitHealth(who),UnitHealthMax(who))
    pvp:RegisterEvent("UNIT_HEALTH","GetFriendHealth")
  end
  local classColor = classColors[class]
  flag:SetColor(classColor.r,classColor.g,classColor.b)
 
  local data = flag:GetData()
  if(not UnitAffectingCombat("player")) then --not in combat
    data.recent = who
    flag:SetAlpha(.9)
    if(not data.saved[who]) then
      local t = flag:SetTarget(who)
      data.saved[who] = t
    end
    data.saved[who]:Show()
    data.isTarget = true
  else
    flag:SetAlpha(.33)
    data.isTarget = false
    pvp:RegisterEvent("PLAYER_REGEN_ENABLED","FlagTarget")
  end
end

-- pvp:FlagDrop ---------------------------------------------------------------
function pvp:FlagDrop(team,flag)
  --unregister listeners
  if(team == enemy) then
    pvp:UnregisterEvent("UNIT_HEALTH")
  else
    pvp:UnregisterEvent("PLAYER_TARGET_CHANGED")
    pvp:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  end
 
  flag:Finished() --clear info and reset health
  local data = flag:GetData()
  if(not UnitAffectingCombat("player")) then
    flag:SetAlpha(.9)
    data.isTarget = true
    local recent = data.recent
    if(data.saved[recent]) then data.saved[recent]:Hide() end
    data.recent = nil
  else
    flag:SetAlpha(.33)
    data.isTarget = false
    pvp:RegisterEvent("PLAYER_REGEN_ENABLED","FlagTarget")
  end
end




-- pvp:GetTargetHealth --------------------------------------------------------
function pvp:GetTargetHealth(event,...)
  if(not bg.mode) then return end
 
  local target = UnitName("target")
  local flag = bg.mode:GetFlagByName(target,3-enemy) --enemy has YOUR flag
  if(not flag) then return end
  local maxHealth = UnitHealthMax("target")
  --seems to be an issue with dying while having the FC targeted, setting health to 0/0
  if(maxHealth <= 0) then
    pvp:Debug("GetTargetHealth: maxHealth was 0")
    maxHealth = nil --if maxHealth is 0, set info to ??
  end
  flag:SetHealth(UnitHealth("target"),maxHealth)
end

-- pvp:GetEnemyHealth ---------------------------------------------------------
function pvp:GetEnemyHealth(event,...)
  if(not bg.mode) then return end

  local who = select(7,...)
  if(not who) then return end --i guess some combat events don't have a target?
  local _,_,name = strfind(who,"(.-)%s*%-")
  if(not name) then name=who end
  local flag = bg.mode:GetFlagByName(name,3-enemy) --enemy has YOUR flag
  if(not flag) then return end --only want to look at events involving the FC

  for i=1,enemyTeam.maxPlayers do
    local unit = "raid"..i.."target"
    local unitName = UnitName(unit)
    if(unitName == name) then
	  local maxHealth = UnitHealthMax(unit)
	  if(maxHealth <= 0) then maxHealth=nil end
      flag:SetHealth(UnitHealth(unit),maxHealth)
      return
    end
  end
  --if we get this far, it means a combat event involving the FC happened
  --but no one has him targetted, so we can't get a unitID to reference
  flag:SetHealth(1)
end

-- pvp:GetFriendHealth --------------------------------------------------------
function pvp:GetFriendHealth(event,unit)
  if(not bg.mode) then return end
 
  local name = UnitName(unit)
  local flag = bg.mode:GetFlagByName(name,enemy) --friend has ENEMY's flag
  if(flag) then
    flag:SetHealth(UnitHealth(unit),UnitHealthMax(unit))
  end
end




-- pvp:GetScore ---------------------------------------------------------------
function pvp:GetScore(i1,i2)
  local final = bg.children["Final"]
 
  local _,_,aInfo = GetWorldStateUIInfo(i1) --ab is index 1 ; eots is 2
  local _,_,hInfo = GetWorldStateUIInfo(i2) --ab is index 2 ; eots is 3
  if(not aInfo or not hInfo) then return end
  local _,_,aNodes = strfind(aInfo,"Bases: (%d)")
  local _,_,hNodes = strfind(hInfo,"Bases: (%d)")
 
  aNodes = (aNodes or 0)+0 --quick str-to-num conversion
  hNodes = (hNodes or 0)+0 --this came up nil recently
  if(hNodes == 0 and aNodes == 0) then
    final:Hide()
  else
    local _,_,aScore = strfind(aInfo,"(%d+)%/")
    local _,_,hScore = strfind(hInfo,"(%d+)%/")
    aScore = aScore+0
    hScore = hScore+0 
 
    local hTimeToWin = bg.mode:TimeToWin(hScore,hNodes)
    local aTimeToWin = bg.mode:TimeToWin(aScore,aNodes)
    --time to win might be nil
    if(hTimeToWin and not aTimeToWin) then aTimeToWin=hTimeToWin+1 end
    if(aTimeToWin and not hTimeToWin) then hTimeToWin=aTimeToWin+1 end
 
    local winner = { hTimeToWin, aTimeToWin }
    local team = nil
    local score = 0
 
    --predict the winner
    if(hTimeToWin < aTimeToWin) then
      team = 1
      score = hScore
    elseif(aTimeToWin < hTimeToWin) then
      team = 2
      score = aScore
    --if time to win is the same, who is already ahead?
    elseif(hScore > aScore) then
      team = 1
      score = hScore
    elseif(aScore > hScore) then
      team = 2
      score = aScore
    end
 
    local data = final:GetData()
 
    if(not team) then --tie
      team = 1
      score = hScore
      final:SetColor(192/255,192/255,192/255)
    elseif(team ~= data.winner) then --no winner predicted yet or winner is now different
      data.winner = team
      local teamColor = teamColors[team]
      final:SetColor(teamColor.r, teamColor.g, teamColor.b)   
    end
 
    --only want to update timer when the score changes (which could happen every 1 sec or every 12 in AB)
    if(score ~= data.score) then
      data.score = score
      local t = final:GetValue()
      if(t-1 < winner[team] or winner[team] < t+1) then --putting buffer back in
        local bgTime = GetBattlefieldInstanceRunTime()/1000
        final:Countdown(floor(winner[team]+bgTime+0.5), winner[team])
      end
    end

    final:Show()
  end
end



--[[ debug stuff ]]------------------------------------------------------------
function pvp:Debug(str)
  tinsert(dbg,str)
end

--*eof