--[[ AV Module ]]--------------------------------------------------------------
local pvp = PvPness
local bg = pvp.bg
local pvpBar = pvp.pvpBar
local teamColors = pvp.teamColors

local AV = pvp.modules.AV

local strfind = strfind



-- AVNode ---------------------------------------------------------------------
local function AVNode(name,team,buf)
  local node = pvp:BGNode(name,200,15,buf)
 
  if(team) then
    local teamColor = teamColors[team]
    node:SetColor(teamColor.r,teamColor.g,teamColor.b)
  end
end

-- Assault --------------------------------------------------------------------
local function Assault(name,team)
  local node = bg.children[name]
  if(not node) then return end
  if(team == "Horde") then team=1 else team=2 end
  local teamColor = teamColors[team]
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
  --building/gy take 4 minutes to rollover
  node:Countdown(244) --one extra second per minute
end

-- Capture --------------------------------------------------------------------
local function Capture(name,team)
  local node = bg.children[name]
  if(not node) then return end
  --not sure if defends produce the same "taken" message, so... yeah
  if(team == "Horde") then team=1 else team=2 end
  local teamColor = teamColors[team]
  node:Finished()
  node:SetColor(teamColor.r,teamColor.g,teamColor.b)
end

-- Destroy --------------------------------------------------------------------
local function Destroy(name)
  local node = bg.children[name]
  if(not node) then return end
  node:Finished()
  --node:SetHealth(0,1) --this doesn't want to work for some reason
  node:SetAlpha(.33)
  node:SetColor(192/25,192/255,192/255)
end



-- AV:Start -------------------------------------------------------------------
function AV:Start()
  --alliance stuff, neutral gy, horde stuff
  AVNode("Stormpike Aid Station",2)
  AVNode("Dun Baldar North Bunker",2) --typo! oopsie
  AVNode("Dun Baldar South Bunker",2)
  AVNode("Stormpike Graveyard",2)
  AVNode("Icewing Bunker",2)
  AVNode("Stonehearth Graveyard",2)
  AVNode("Stonehearth Bunker",2)
 
  AVNode("Snowfall Graveyard",nil)
 
  AVNode("Iceblood Tower",1)
  AVNode("Iceblood Graveyard",1)
  AVNode("Tower Point",1)
  AVNode("Frostwolf Graveyard",1)
  AVNode("West Frostwolf Tower",1)
  AVNode("East Frostwolf Tower",1)
  AVNode("Frostwolf Relief Hut",1)

  pvp:RegisterEvent("CHAT_MSG_MONSTER_YELL","EventHandler") --herald yells
end

-- AV:EventHandler ------------------------------------------------------------
function AV:EventHandler(event,...)
  local strfind = strfind
  local msg,who = ...
 
  --special snowflake: the initial snowfall asault is a bg msg, not a yell
  if(strfind(msg,"Snowfall") and strfind(msg,"claim")) then
    if(event == "CHAT_MSG_BG_SYSTEM_ALLIANCE") then   
      Assault("Snowfall Graveyard","Alliance")
    elseif(event == "CHAT_MSG_BG_SYSTEM_HORDE") then
      Assault("Snowfall Graveyard","Horde")
    end
  end
 
  --more special snowflakes: the dudes in the mine, the captains, and the generals all yell too
  if(not who or who ~= "Herald") then return end
 
  --even more special snowflakes: most nodes start with 'The', but some don't
  if(strfind(msg,"The")) then msg=strsub(msg,5) end
  if(strfind(msg,"attack")) then
    local _,_,where,who = strfind(msg,"(.+) is under attack!  If left unchecked, the (%a+) will")
    Assault(where,who)
  elseif(strfind(msg,"taken") and not strfind(msg,"Mine")) then
    local _,_,where,who = strfind(msg,"(.+) was taken by the (%a+)!")
    Capture(where,who)
  elseif(strfind(msg,"destroyed")) then
    local _,_,where = strfind(msg,"(.+) was")
    Destroy(where)
  end
end

-- AV:End ---------------------------------------------------------------------
function AV:End()
  pvp:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
end

--*eof
