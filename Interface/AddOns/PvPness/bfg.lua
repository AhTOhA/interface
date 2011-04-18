--[[ BfG Module ]]-------------------------------------------------------------
local pvp = PvPness
local bg = pvp.bg
local pvpBar = pvp.pvpBar
local teamColors = pvp.teamColors

local BfG = pvp.modules.BfG

local strfind = strfind
local UnitExists = UnitExists



-- Assault --------------------------------------------------------------------
local function Assault(name,team)
  local node = bg.children[name]
  if(not node) then pvp:Debug(name.." not found") ; return end
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b) 
  node:Countdown(61)
end

-- Defend ---------------------------------------------------------------------
local function Defend(name, team)
  local node = bg.children[name]
  if(not node) then pvp:Debug(name.." not found") ; return end
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
  node:Finished()
end

-- Capture --------------------------------------------------------------------
local function Capture(name,team)
  local node = bg.children[name]
  if(not node) then pvp:Debug(name.." not found") ; return end
  node:Finished()
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
end




-- BfG:Start ------------------------------------------------------------------
function BfG:Start()
  pvp:BGNode("LIGHTHOUSE")
  pvp:BGNode("WATERWORKS")
  pvp:BGNode("MINES")
 
  --create a time to win bar
  local final = pvpBar:new("Final")
  final:CreateBar(200,25,6)
  final:SetData( { winner=nil, score=0 } )
 
  pvp:RegisterEvent("UPDATE_WORLD_STATES","EventHandler")
  pvp:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE","EventHandler")
 
  pvp:Debug("BfG start")
end

-- BfG:EventHandler ------------------------------------------------------------
function BfG:EventHandler(event,msg)
  --if(event == "UPDATE_WORLD_STATES") then
    --pvp:GetScore(1,2)  --unsure on points per tick, points per base, etc
  if(event == "CHAT_MSG_RAID_BOSS_EMOTE") then --changed for 4.0.3a
    local _,_,who,where = strfind(msg,"(%a+)%s%l.- the (.-)%p")
	if(not where) then pvp:Debug("where was nil") ; return end
	if(not who) then pvp:Debug("who was nil") end
    where = strupper(where)
 
    --[Name] claims the [base]!
    --The [Faction] has taken the [base]
    --[Name] has assaulted the [base]!
    --[Name] has defended the [base]! --followed immediately by a taken message    
    if(strfind(msg,"claim") or strfind(msg,"assault")) then
	  local team=3-pvp:GetTeamNumber()
	  for i=1,10 do
	    local p=UnitName("raid"..i) 
		if(who == p) then team=3-team ; break end
	  end
      Assault(where,team)
    elseif(strfind(msg,"taken")) then
      local team
      if(who == "Horde") then team=1 else team=2 end
      Capture(where,team)
    end
  end
end

-- BfG:TimeToWin ---------------------------------------------------------------
function BfG:TimeToWin(score,nodeCount)
  if(nodeCount == 0) then return nil end 
 
  --1: 10 per 9s (maybe 8)
  --2: 10 per 4s
  --3: 30 per 1s
 
  local ticks = { 9, 4, 1}
  local points = { 10, 10, 30}
  return (2000 - score)/points[nodeCount]*ticks[nodeCount]
end

-- BfG:End ---------------------------------------------------------------------
function BfG:End()
  --pvp:UnregisterEvent("UPDATE_WORLD_STATES")
  pvp:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

  pvp:Debug("BfG end")
end

--*eof