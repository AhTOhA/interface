--[[ IoC Module ]]-------------------------------------------------------------
local pvp = PvPness
local bg = pvp.bg
local pvpBar = pvp.pvpBar
local teamColors = pvp.teamColors

local IoC = pvp.modules.IoC

local strfind = strfind



-- IoCGate --------------------------------------------------------------------
local function IoCGate(id,name,team)
  local node = pvp:BGNode(id) --back to BGNode
  node:SetName(name)
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
  node:SetHealth(600000,600000) --gates have 600000 health
end

-- FortBreach -----------------------------------------------------------------
local function FortBreach(g)
  local bg = bg
  for i,p in ipairs(g) do
    local gate = bg.children[p]
    gate:SetHealth(0,1)
  end
end

-- GetGateID ------------------------------------------------------------------
local function GetGateID(guid,g)
  local bg = bg
  local id = nil
  --look for this GUID
  for i,p in ipairs(g) do
    local gate = bg.children[p]:GetData()
    if(gate and gate == guid) then
      id = p
      break
    end
  end
  --if not found, give it to first gate without a GUID
  if(not id) then
    for i,p in ipairs(g) do
      if(not bg.children[p]:GetData()) then
        bg.children[p]:SetData(guid)
        id = p
        break
      end
    end
  end
  return id
end

-- Assault --------------------------------------------------------------------
local function Assault(where,team)
  local node = bg.children[where]
  if(not node) then return end --don't care about keep GYs
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
  node:Countdown(61)
end

-- Defend ---------------------------------------------------------------------
local function Defend(where,team)
  local node = bg.children[where]
  if(not node) then return end --don't care about keep GYs
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
  node:Finished()
end

-- Capture --------------------------------------------------------------------
local function Capture(where,team)
  local node = bg.children[where]
  if(not node) then return end --don't care about keep GYs
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
end

-- GetSiege -------------------------------------------------------------------
local function GetSiege(team)
  local siege = bg.children["siege"]
  if(not siege) then
    siege = pvpBar:new("siege",200,15)
    siege:SetName("SIEGE ENGINE")
  end
  local teamColor = teamColors[team]
  siege:SetColor(teamColor.r,teamColor.g,teamColor.b)
  siege:Countdown(183)
  siege:Show()
end



-- IoC:Start ------------------------------------------------------------------
function IoC:Start()
  pvp:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED","EventHandler")
  pvp:RegisterEvent("CHAT_MSG_MONSTER_YELL","EventHandler")
 
  local name = "ALLIANCE GATE"
  IoCGate("a1",name,2)
  IoCGate("a2",name,2)
  IoCGate("a3",name,2)
 
  pvp:BGNode("QUARRY")
  pvp:BGNode("HANGAR")
  pvp:BGNode("WORKSHOP")
  pvp:BGNode("DOCKS")
  pvp:BGNode("OIL REFINERY")
 
  name = "HORDE GATE"
  IoCGate("h1",name,1)
  IoCGate("h2",name,1)
  IoCGate("h3",name,1)
 
  --removed siege engine stuff, won't create it til it's needed
end

-- IoC:EventHandler -----------------------------------------------------------
function IoC:EventHandler(event,...)
  local strfind = strfind
 
  --wall damage
  if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
    local siege = select(2,...)
    if(strfind(siege,"SPELL_BUILDING_DAMAGE")) then
      local guid,name,_,_,_,_,dmg = select(6,...)
      local id = nil
      if(name == "Alliance Gate") then
        id = GetGateID(guid, {"a1","a2","a3"})
      elseif(name == "Horde Gate") then
        id = GetGateID(guid, {"h1","h2","h3"})
      end
      if(not id) then return end --sanity check  
      local gate = bg.children[id]
      local health = gate:GetValue()
      if(dmg > health) then
        gate:SetHealth(0,1)
      else
        health = health-dmg
        gate:SetHealth(health,600000)
      end      
    end
 
  --siege tank / fort breach
  elseif(event == "CHAT_MSG_MONSTER_YELL") then
    local msg,who = ...
    if(who == "High Commander Halford Wyrmbane") then   
      FortBreach( {"a1","a2","a3"} ) -- once one gate is down, the others don't really matter
    elseif(who == "Overlord Agmar") then
      FortBreach( {"h1","h2","h3"} )
    else
      --Goblin Mechanic: I'll work on the siege engine (capture)
      --Goblin Mechanic: The siege engine is ready to roll!
	  --Goblin Mechanic: I'm about halfway done
	  --Goblin Mechanic: broken again	  
	  
	  --Gnomish Mechanic: "while I repair the siege engine" (capture)
	  --Gnomish Mechanic: "My finest work so far! The siege engine is ready for action!"
	  --Gnomish Mechanic: "I'm halfway there!"
      if(who == "Gnomish Mechanic") then pvp:Debug(who..": "..msg) end
    end

  --node events
  else
    local team = nil
    local msg = ...
 
    local _,_,where = strfind(msg,"%a+%s%l.- the (.-)%p")
    if(not where) then return end
    where = strupper(where)
 
    if(event == "CHAT_MSG_BG_SYSTEM_HORDE") then team=1 else team=2 end
 
    if(strfind(msg,"assault") or strfind(msg,"claim")) then
      Assault(where,team)
    elseif(strfind(msg,"defend")) then
      Defend(where,team)
    elseif(strfind(msg,"taken")) then
      Capture(where,team)
    end
  end
end

-- IoC:End --------------------------------------------------------------------
function IoC:End()
  pvp:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  pvp:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
end

--*eof