--[[ EotS Module ]]------------------------------------------------------------
local pvp = PvPness
local bg = pvp.bg
local pvpBar = pvp.pvpBar
local classColors = pvp.classColors
local teamColors = pvp.teamColors

local EotS = pvp.modules.EotS

local strfind = strfind



-- NodeTake -------------------------------------------------------------------
local function NodeTake(name,team)
  local node = bg.children[name]
  if(not node) then return end
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
end

-- NodeLost -------------------------------------------------------------------
local function NodeLost(name)
  local node = bg.children[name]
  if(not node) then return end
  node:SetColor(192/255,192/255,192/255)
end

-- ResetFlag ------------------------------------------------------------------
local function ResetFlag()
  local flag = bg.children["Flag"]
  flag:SetName("Netherstorm Flag")
  flag:SetColor(74/255, 160/255, 44/255) --greenish
end

-- FlagGrab -------------------------------------------------------------------
local function FlagGrab(who,team)
  pvp:FlagGrab(who,team,bg.children["Flag"])
end

-- FlagDrop -------------------------------------------------------------------
local function FlagDrop(team)
  ResetFlag()
  pvp:FlagDrop(team,bg.children["Flag"])
end

-- FlagCap --------------------------------------------------------------------
local function FlagCap(team)
  FlagDrop(team)
end



-- EotS:Start -----------------------------------------------------------------
function EotS:Start()
  pvp:BGNode("FEL REAVER RUINS")
  pvp:BGNode("BLOOD ELF TOWER")
  pvp:BGNode("DRAENEI RUINS")
  pvp:BGNode("MAGE TOWER")

  local flag = pvp:BGNode("Flag")
  flag:SetData({ recent=nil, isTarget=false, saved={} })
  ResetFlag()
 
  --final score
  local final = pvpBar:new("Final")
  final:CreateBar(200,25,6)
  final:SetData({ winner=nil, score=0 })
 
  pvp:RegisterEvent("UPDATE_WORLD_STATES","EventHandler")
end

-- EotS:EventHandler ----------------------------------------------------------
function EotS:EventHandler(event,msg)
  if(event == "UPDATE_WORLD_STATES") then
    pvp:GetScore(2,3)
  else
    local team = nil
    if(event == "CHAT_MSG_BG_SYSTEM_HORDE") then team=1 else team=2 end
 
    --base control
    if(strfind(msg,"control")) then
      --The [Faction] has taken control of the [Base]!
      --The [Faction] has lost control of the [Base]!
      local _,_,what,where = strfind(msg,"has (%a+) control of the (.+)!")
      where = strupper(where)
      if(what == "taken") then
        NodeTake(where,team)
      elseif(what == "lost") then
        NodeLost(where)
      end
 
    --flag stuff
    else
      --question: what happens if the FC falls off the edge?
      --is there a flag drop msg or just a neutral reset msg?
      if(strfind(msg,"taken")) then
        local _,_,who = strfind(msg,"(.+) has taken the flag!")
        FlagGrab(who,team)
      elseif(strfind(msg,"captured")) then
        FlagCap(team)
      elseif(strfind(msg,"dropped")) then
        FlagDrop(team)
      end
    end
  end
end

-- EotS:TimeToWin -------------------------------------------------------------
function EotS:TimeToWin(score,nodeCount)
  if(nodeCount == 0) then return nil end
 
  --[[
 
      1 = 1  per 1s
      2 = 2  per 1s
      3 = 5  per 1s
      4 = 10 per 1s
    
  --]]
 
  local points = { 1, 2, 5, 10 }
  return (1600 - score)/points[nodeCount]
end

-- EotS:GetFlag ---------------------------------------------------------------
function EotS:GetFlag()
  return { bg.children["Flag"] }
end

-- EotS:GetFlagByName ---------------------------------------------------------
function EotS:GetFlagByName(name)
  local flag = bg.children["Flag"]
  if(name == flag:GetName()) then
    return flag
  else
    return nil
  end
end

-- EotS:End -------------------------------------------------------------------
function EotS:End()
  --just in case
  pvp:UnregisterEvent("PLAYER_TARGET_CHANGED")
  pvp:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  pvp:UnregisterEvent("UNIT_HEALTH")
  pvp:UnregisterEvent("UPDATE_WORLD_STATES")
  pvp:UnregisterEvent("PLAYER_REGEN_ENABLED")
 
  --clear out target frames
  local flag = bg.children["Flag"]
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

--*eof