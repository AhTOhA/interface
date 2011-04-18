--[[ AB Module ]]--------------------------------------------------------------
local pvp = PvPness
local bg = pvp.bg
local pvpBar = pvp.pvpBar
local teamColors = pvp.teamColors

local AB = pvp.modules.AB

local strfind = strfind
local UnitExists = UnitExists
local UnitName = UnitName

local t = {}
local avg = {}



-- Assault --------------------------------------------------------------------
local function Assault(name,team)
  local node = bg.children[name]
  t[name] = time()
  if(not node) then pvp:Debug(name.." not found -- Assault") ; return end
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b) 
  node:Countdown(62) --avg time to cap: 63.38 (after one game)... maybe adjust as we go?
end

-- Defend ---------------------------------------------------------------------
local function Defend(name, team)
  local node = bg.children[name]
  if(not node) then pvp:Debug(name.." not found -- Defend") ; return end
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
  node:Finished()
end

-- Capture --------------------------------------------------------------------
local function Capture(name,team)
  local node = bg.children[name]
  if(t[name]) then
    local s = (time() - t[name])
    t[name] = nil
    tinsert(avg,s)
  end
  if(not node) then pvp:Debug(name.." not found -- Capture") ; return end
  node:Finished()
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
end




-- AB:Start -------------------------------------------------------------------
function AB:Start()
  pvp:BGNode("FARM")
  pvp:BGNode("LUMBER MILL")
  pvp:BGNode("BLACKSMITH")
  pvp:BGNode("MINE")
  pvp:BGNode("STABLES")
 
  --create a time to win bar
  local final = pvpBar:new("Final")
  final:CreateBar(200,25,6)
  final:SetData( { winner=nil, score=0 } )
 
  pvp:RegisterEvent("UPDATE_WORLD_STATES","EventHandler")
  pvp:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE","EventHandler")
 
  pvp:Debug("AB start")
end

-- AB:EventHandler ------------------------------------------------------------
function AB:EventHandler(event,msg)
  if(event == "UPDATE_WORLD_STATES") then
    pvp:GetScore(1,2)
  elseif(event == "CHAT_MSG_RAID_BOSS_EMOTE") then --changed for 4.0.3a
    local _,_,who,where = strfind(msg,"(%a+)%s%l.- the (.-)%p")
	if(not who) then pvp:Debug("who was nil") end
    where = strupper(where)
 
    --[Name] claims the [base]!
    --The [Faction] has taken the [base]
    --[Name] has assaulted the [base]!
    --[Name] has defended the [base]! --followed immediately by a taken message    
    if(strfind(msg,"claim") or strfind(msg,"assault")) then
	  local team = 3-pvp:GetTeamNumber() --default to enemy team
	  for i=1,15 do
	    local p=UnitName("raid"..i) 
		if(who == p) then team=3-team ; break end --now your team
	  end
      Assault(where,team)
    elseif(strfind(msg,"taken")) then
      local team
      if(who == "Horde") then team=1 else team=2 end
      Capture(where,team)
    end
  end
 
  --[[ save this just in case they change it back...
  else
    local _,_,where = strfind(msg,"%a+%s%l.- the (.-)%p")
    if(not where) then return end
    where = strupper(where)
 
    local team = nil
    if(event == "CHAT_MSG_BG_SYSTEM_HORDE") then team=1 else team=2 end
 
    if(strfind(msg,"assault") or strfind(msg,"claim")) then
      Assault(where,team)
    elseif(strfind(msg,"defend")) then
      Defend(where,team)
    elseif(strfind(msg,"taken")) then
      Capture(where,team)
    end
  --]]
end

-- AB:TimeToWin ---------------------------------------------------------------
function AB:TimeToWin(score,nodeCount)
  if(nodeCount == 0) then return nil end
 
  --[[
 
      1 = 10 per 12s
      2 = 10 per 9s
      3 = 10 per 6s
      4 = 10 per 3s
      5 = 30 per 1s
  
  --]]
 
  local ticks = { 12, 9, 6, 3, 1 }
  local points = { 10, 10, 10, 10, 30 }
  return (1600 - score)/points[nodeCount]*ticks[nodeCount]
end

-- AB:End ---------------------------------------------------------------------
function AB:End()
  pvp:UnregisterEvent("UPDATE_WORLD_STATES")
  pvp:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
 
  local sum = 0
  local num = 0
  for i,p in ipairs(avg) do
    if(p >= 60) then
      sum = sum + p
      num = num +1
    end
  end
 
  pvp:Debug(format('%.2f',sum/num))
  pvp:Debug("AB end")
end

--*eof