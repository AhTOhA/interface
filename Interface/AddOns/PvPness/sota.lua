--[[ SotA Module ]]------------------------------------------------------------
local pvp = PvPness
local bg = pvp.bg
local pvpBar = pvp.pvpBar
local teamColors = pvp.teamColors

local SotA = pvp.modules.SotA

local strfind = strfind



-- SotAGate -------------------------------------------------------------------
local function SotAGate(id,r,g,b,health)
  local node = pvp:BGNode("Gate of the "..id,200,15)
  node:SetColor(r,g,b)
  node:SetHealth(health,health)
  node:SetName(strupper(id))
  node:SetData(health) --keep max health of gate for reset
end

-- Reset ----------------------------------------------------------------------
local function Reset()
  --sota is of course a special snowflake, it has two rounds
  local bg = bg
  for p in pairs(bg.children) do
    if(p ~= "Start") then
      local gate = bg.children[p]
      local health = gate:GetData()
      gate:Hide()
      gate:SetHealth(health,health)
    end
  end
  local start = bg.children["Start"]
  start:Countdown(65) --not quite sure on this yet
  start:Show()
  pvp:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL","GetNeutralMsg")
end



-- SotA:Start -----------------------------------------------------------------
function SotA:Start()
  pvp:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE","EventHandler")
  pvp:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED","EventHandler")
 
  --green/blue = 11000
  --purple/red = 13000
  --yellow = 14000
  --relic = 10000
  SotAGate("Green Emerald",0,1,0,11000) 
  SotAGate("Blue Sapphire",0,0,1,11000)
  SotAGate("Purple Amethyst",1,0,1,13000)
  SotAGate("Red Sun",1,0,0,13000)
  SotAGate("Yellow Moon",1,1,0,14000)
 
  local relic = pvp:BGNode("Chamber of Ancient Relics",200,15)
  relic:SetColor(1,163/255,51/255) --orangish ff9933
  relic:SetHealth(10000,10000)
  relic:SetName("RELIC CHAMBER")
  relic:SetData(10000)
end

-- SotA:EventHandler ----------------------------------------------------------
function SotA:EventHandler(event,...)
  --The Gate of the [Color Thing] was destroyed!
  --The chamber has been breached! The titan relic is vulnerable!
  if(event == "CHAT_MSG_RAID_BOSS_EMOTE") then
    local msg = ...
	if(msg == "Round 1 - Finished!") then
	  Reset()
	else
      local _,_,what = strfind(msg,"The (.+) was destroyed!")
      if(not what) then
        if(strfind(msg,"breach")) then
          what = "Chamber of Ancient Relics"
        else return end --a message we don't care about
      end     
      local gate = bg.children[what]
      if(not gate) then pvp:Debug("unknown gate: "..what) ; return end
      gate:SetHealth(0,1)
	end
  else
    --local siege = select(2,...)
    local _,siege = ...
    if(strfind(siege,"SPELL_BUILDING_DAMAGE")) then
      local name,_,_,_,_,dmg = select(7,...)
      local gate = bg.children[name]
      if(not gate) then return end  
      local health = gate:GetValue()
      if(dmg >= health) then
        gate:SetHealth(0,1)
      else
        health = health - dmg
        gate:SetHealth(health,gate:GetData())
      end
    end
  end
end

-- SotA:End -------------------------------------------------------------------
function SotA:End()
  pvp:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  pvp:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
end

--*eof