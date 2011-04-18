--[[ WSG Module ]]-------------------------------------------------------------
local pvp = PvPness
local bg = pvp.bg
local pvpBar = pvp.pvpBar
local classColors = pvp.classColors
local teamColors = pvp.teamColors

local WSG = pvp.modules.WSG

local strfind = strfind



-- FlagGrab -------------------------------------------------------------------
local function FlagGrab(who,team)
  -- actually want which flag got picked up
  local flag = bg.children["Flag"..(3-team)]
  pvp:FlagGrab(who,team,flag)
end

-- FlagDrop -------------------------------------------------------------------
local function FlagDrop(team)
  local flag = bg.children["Flag"..team]
 
  --reset flag
  if(team == 1) then flag:SetName("Horde Flag") else flag:SetName("Alliance Flag") end
 
  local teamColor = teamColors[team] --flag is still 'live'
  flag:SetColor(teamColor.r, teamColor.g, teamColor.b)
 
  pvp:FlagDrop(team,flag)
end

-- FlagReturn -----------------------------------------------------------------
local function FlagReturn(team)
  --all this does is resets color to default gray
  --all the work is done when the flag is dropped
  bg.children["Flag"..team]:SetColor(192/255,192/255,192/255)
end

-- FlagCap --------------------------------------------------------------------
local function FlagCap(team)
  --flag cap means the other flag has already been dropped and returned
  FlagDrop(3-team) --needs to be the other team's flag
  FlagReturn(3-team)
 
  --create a flag respawn timer?
end



-- WSG:Start ------------------------------------------------------------------
function WSG:Start()
  local flag1 = pvp:BGNode("Flag1",200,20)
  flag1:SetName("Horde Flag")
  flag1:SetData({ recent=nil, isTarget=false, saved={} })
 
  local flag2 = pvp:BGNode("Flag2",200,20)
  flag2:SetName("Alliance Flag")
  flag2:SetData({ recent=nil, isTarget=false, saved={} })
end

-- WSG:EventHandler -----------------------------------------------------------
function WSG:EventHandler(event,msg)
  local team = nil
  if(event == "CHAT_MSG_BG_SYSTEM_HORDE") then team=1 else team=2 end

  if(strfind(msg,"captured")) then
    FlagCap(team)
  else   
    local _,_,what,who = strfind(msg,"lag was (%a+).+by (.+)!") --flag/Flag... ridiculous
    if(not who or not what) then return end
 
    if(what == "picked") then
      FlagGrab(who,team)
    elseif(what == "dropped") then
      FlagDrop(team)
    elseif(what == "returned") then
      FlagReturn(team)
    end
  end
end

-- WSG:GetFlag ----------------------------------------------------------------
function WSG:GetFlag() 
  local bg = bg
  return { bg.children["Flag1"], bg.children["Flag2"] }
end

-- WSG:GetFlagByName ----------------------------------------------------------
function WSG:GetFlagByName(name,flagNum)
  local flagID = "Flag"..flagNum
  local flag = bg.children[flagID]
  if(name == flag:GetName()) then
    return flag
  else
    return nil
  end
end

-- WSG:End --------------------------------------------------------------------
function WSG:End()
  --double check to make sure these all get unregistered
  pvp:UnregisterEvent("PLAYER_TARGET_CHANGED")
  pvp:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  pvp:UnregisterEvent("UNIT_HEALTH")
  pvp:UnregisterEvent("PLAYER_REGEN_ENABLED")
 
  --clear out the target frames
  local bg = bg
  local flags = { "Flag1","Flag2" }
  for i,p in ipairs(flags) do
    local flag = bg.children[p]
    local data = flag:GetData()
    if(data) then
      for p in pairs(data.saved) do
        data.saved[p]:Hide()
        data.saved[p]:ClearAllPoints()
        data.saved[p]:SetParent(nil)
        data.saved[p] = nil
      end
      data.saved = nil
      data = nil
    end
  end
end

--*eof