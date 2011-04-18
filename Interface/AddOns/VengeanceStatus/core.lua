local f = CreateFrame("Frame")
f.ScanTip = CreateFrame("GameTooltip","VengeanceStatusScanTip",nil,"GameTooltipTemplate")
f.ScanTip:SetOwner(UIParent, "ANCHOR_NONE")

f.fightData = {}
f.vengDowntime = {}
f.statusBar = {}
f.lastReport = {}
f.fightMax = 0
f.fightMaxPercent = 0
f.vengmax = 0
f.fightStart = 0
f.fightEnd = 0
f.player = (UnitName("player")).." - "..(GetRealmName())
f.eclass = ""
f.label = "|cffFF6633VengeanceStatus: |r"

local db

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
f:RegisterEvent("UNIT_AURA")
f:RegisterEvent("UNIT_MAXHEALTH")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")

f:SetScript("OnEvent", 
function(self, event, ...) 
	if self[event] then
		self[event](...)
	end
end)

local humorous = {
	"FLEX", -- animation emotes
	"ROAR", 
	"CHARGE", -- sound emotes
	"OPENFIRE", 
	"SNARL", -- text only emotes
	"THREATEN",
	"GROWL",
	"BRANDISH",
	"REVENGE",
	"SHAKEFIST",
}

local function doHumor()
	local val = random(#(humorous))
	DoEmote(humorous[val])
end

local function isTank()
	local masteryIndex 
	local tank = false
	if f.eclass == "DRUID" then
		masteryIndex = GetPrimaryTalentTree()
		if masteryIndex and masteryIndex == 2 then
			local form = GetShapeshiftFormID()
			if form and form == BEAR_FORM then
				tank = true
			end
		end
	end
	if f.eclass == "DEATHKNIGHT" then
		masteryIndex = GetPrimaryTalentTree()
		if masteryIndex and masteryIndex == 1 then
			tank = true
		end
	end
	if f.eclass == "PALADIN" then
		masteryIndex = GetPrimaryTalentTree()
		if masteryIndex and masteryIndex == 2 then
			tank = true
		end
	end
	if f.eclass == "WARRIOR" then
		masteryIndex = GetPrimaryTalentTree()
		if masteryIndex and masteryIndex == 3 then
			tank = true
		end
	end
	return tank
end

local function shutdown()
	f:SetScript("OnEvent",nil)
	f.statusBar:Hide()
	SlashCmdList["VENGEANCESTATUS"] = nil
end

local function toggle(flag)
	if flag then
		f:RegisterEvent("UNIT_AURA")
		f:RegisterEvent("UNIT_MAXHEALTH")
		f:RegisterEvent("PLAYER_REGEN_ENABLED")
		f:RegisterEvent("PLAYER_REGEN_DISABLED")
		if (not VengeanceStatusDB.combat) or (VengeanceStatusDB.combat and InCombatLockdown()) then
			f.statusBar:Show()
		elseif VengeanceStatusDB.combat and (not InCombatLockdown()) then
			f.statusBar:Hide()
		end
	else
		f:UnregisterEvent("UNIT_AURA")
		f:UnregisterEvent("UNIT_MAXHEALTH")
		f:UnregisterEvent("PLAYER_REGEN_ENABLED")
		f:UnregisterEvent("PLAYER_REGEN_DISABLED")
		f.statusBar:Hide()
	end
end

local function getTooltipText(...)
	local text = ""
	for i=1,select("#",...) do
		local rgn = select(i,...)
		if rgn and rgn:GetObjectType() == "FontString" then
			text = text .. (rgn:GetText() or "")
		end
	end
	return text == "" and "0" or text
end

local function formatTime(timenum)
	local text = ""
	local minutes = math.floor(timenum/60);
	local seconds = math.fmod(timenum,60);
	local text = tostring(timenum);
	if minutes > 0 then
		text = string.format("%d min:%d sec",minutes,seconds)
	elseif seconds > 0 then
		text = string.format("%d sec",seconds)
	end
	return text == "" and "0" or text
end

local up, down
local function vengReport(fightMax, fightMaxPercent, fightAverage, fightDowntime, fightTime)
	wipe(f.lastReport)
	local zone = GetRealZoneText()
	db[zone] = db[zone] or {}
	local fight = {}
	if fightMax > 0 then
		tinsert(f.lastReport,{"Max:",tostring(fightMax)})
		if VengeanceStatusDB.keepSession then tinsert(fight,{"Max",fightMax}) end
	end
	if fightMaxPercent > 0 then
		tinsert(f.lastReport,{"Max(%):",string.format("%.2f%%",fightMaxPercent)})
		if VengeanceStatusDB.keepSession then tinsert(fight,{"MaxPerc",fightMaxPercent}) end
	end
	if fightAverage > 0 then
		tinsert(f.lastReport,{"Average:",tostring(floor(fightAverage))})
		if VengeanceStatusDB.keepSession then tinsert(fight,{"Average",fightAverage}) end
	end
	if fightTime > 0 and fightTime >= fightDowntime then
		local uptime = fightTime - fightDowntime
		if down and not up then uptime = 0 end
		local uptimePerc = (uptime/fightTime)*100
		local fightTimeText = formatTime(fightTime)
		local uptimeText = formatTime(uptime)
		tinsert(f.lastReport,{"Up/Total:",uptimeText.."/"..fightTimeText})
		tinsert(f.lastReport,{"Uptime(%):",string.format("%.2f%%",uptimePerc)})
		if VengeanceStatusDB.keepSession then tinsert(fight,{"Uptime",uptimePerc}); tinsert(fight,{"Combat",fightTime}) end
	end
	if VengeanceStatusDB.keepSession then tinsert(db[zone],fight) end
	if VengeanceStatusDB.spam then
		DEFAULT_CHAT_FRAME:AddMessage(f.label.."Report")
		for i,v in ipairs(f.lastReport) do
			DEFAULT_CHAT_FRAME:AddMessage(v[1].." "..v[2])
		end
	end
end

local function createVengeanceStatusBar()
	local bar = CreateFrame("StatusBar", "VengeanceStatus_StatusBar", UIParent)
	bar:SetWidth(118)
	bar:SetHeight(14)
	bar:SetPoint("CENTER")
	bar:SetClampedToScreen(true)
 	bar:SetScale(tonumber(VengeanceStatusDB.scale) or 1)
	bar:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
		tile = true,
		tileSize = 16,
	})
	bar:SetStatusBarTexture([[Interface\TARGETINGFRAME\UI-StatusBar]],"OVERLAY")
	bar:SetOrientation("HORIZONTAL")
	bar:SetStatusBarColor(0,0,0,1)
	bar:SetBackdropColor(0,0,0,VengeanceStatusDB.bgalpha or 0.6)
 	bar:GetStatusBarTexture():SetGradient("HORIZONTAL", 255/255, 153/255, 102/255, 204/255, 51/255, 51/255)
	
	local border = bar:CreateTexture(nil, "BACKGROUND")
	border:SetPoint("CENTER")
	border:SetWidth(bar:GetWidth()+9)
	border:SetHeight(bar:GetHeight()+8)
	border:SetTexture([[Interface\Tooltips\UI-StatusBar-Border]])
	bar.Border = border
	if not VengeanceStatusDB.border then
		bar.Border:Hide()
	end
	
	local bartext = bar:CreateFontString(nil, "OVERLAY")
	bar.Text = bartext
	bar.Text:SetFontObject("GameFontHighlightSmall")
	bar.Text:SetPoint("TOP",bar,"TOP",0,-2)
	bar.Text:SetTextColor(1,1,1)
	
	bar:SetMinMaxValues(0,1)
	bar:SetValue(0)
	
  bar:SetMovable();
  bar:RegisterForDrag("LeftButton");

  bar:SetScript("OnDragStart", function(self, button) self:StartMoving() end);
  bar:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);
  bar:SetScript("OnEnter", 
  function(self) 
  	GameTooltip:SetOwner(self,"ANCHOR_BOTTOMRIGHT"); 
  	GameTooltip:SetClampedToScreen(true);
  	GameTooltip:ClearLines();
  	GameTooltip:SetText("|TInterface\\Icons\\Ability_Paladin_ShieldofVengeance:16|t Vengeance Report", 1, 0.4, 0.4, 1)
  	if #(f.lastReport) > 0 then
	  	for i,v in ipairs(f.lastReport) do 
	  		GameTooltip:AddDoubleLine(v[1],v[2],1,0.8,0,0.4,0.8,0.8); 
	  	end 
  	end
  	GameTooltip:Show() 
  end);
  bar:SetScript("OnLeave", function(self) GameTooltip_Hide() end);
  if not VengeanceStatusDB.locked then
		bar:EnableMouse(true)
		bar.locked = nil
	else
		bar:EnableMouse(false)
		bar.locked = true
	end

	bar:Show();  
  
  return bar;
end

local function SlashHandler(command)
	if command == "" then
		DEFAULT_CHAT_FRAME:AddMessage(f.label.."Lock="..(VengeanceStatusDB.locked and "On" or "Off")..", Scale="..tostring(VengeanceStatusDB.scale)..", Session Data="..(VengeanceStatusDB.keepSession and "On" or "Off")..", Spam="..(VengeanceStatusDB.spam and "On" or "Off"))
		DEFAULT_CHAT_FRAME:AddMessage("/vgs lock (toggles statusbar lock)")
		DEFAULT_CHAT_FRAME:AddMessage("/vgs scale # (scales the bar 0.5 to 2)")
		DEFAULT_CHAT_FRAME:AddMessage("/vgs border (toggle statusbar border on/off)")
		DEFAULT_CHAT_FRAME:AddMessage("/vgs bgalpha # (set background to # opacity 0 to 1)")
		DEFAULT_CHAT_FRAME:AddMessage("/vgs reset (resets all appearance options)")
		DEFAULT_CHAT_FRAME:AddMessage("/vgs spam (toggles reporting to self)")
		DEFAULT_CHAT_FRAME:AddMessage("/vgs combat (toggles showing in combat only)")
		DEFAULT_CHAT_FRAME:AddMessage("/vgs humor [#] (toggles humor at #% vengeance,once per combat,default 100%)")
		DEFAULT_CHAT_FRAME:AddMessage("/vgs session (toggles keeping session statistics)")
	elseif command == "lock" then
		if f.statusBar.locked then
			f.statusBar:EnableMouse(true)
			f.statusBar.locked = nil
			VengeanceStatusDB.locked = nil
			VengeanceStatusDB.spam = nil
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."Bar Unlocked.")
		else
			f.statusBar:EnableMouse(false)
			f.statusBar.locked = true
			VengeanceStatusDB.locked = true
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."Bar Locked.")
		end
	elseif command == "border" then
		if f.statusBar.Border:IsShown() then
			f.statusBar.Border:Hide()
			VengeanceStatusDB.border = nil
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."Border Hidden.")
		else
			f.statusBar.Border:Show()
			VengeanceStatusDB.border = true
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."Border Shown.")
		end
	elseif command == "reset" then
		f.statusBar:SetScale(1)
		f.statusBar:ClearAllPoints()
		f.statusBar:SetPoint("CENTER")
		if f.statusBar.locked then
			f.statusBar:EnableMouse(true)
			f.statusBar.locked = nil
			VengeanceStatusDB.locked = nil
			VengeanceStatusDB.spam = nil
		end
		if not f.statusBar.Border:IsShown() then
			f.statusBar.Border:Show()
			VengeanceStatusDB.border = true
		end
		f.statusBar:SetBackdropColor(0,0,0,0.6)
		VengeanceStatusDB.bgalpha = 0.6
	elseif command == "session" then
		if VengeanceStatusDB.keepSession then
			VengeanceStatusDB.keepSession = nil
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."No session stats.")
		else
			VengeanceStatusDB.keepSession = true
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."Session stats saved.")
		end
	elseif command == "spam" then
		if f.statusBar.locked then
			if VengeanceStatusDB.spam then
				VengeanceStatusDB.spam = nil
				DEFAULT_CHAT_FRAME:AddMessage(f.label.."Self reporting Off.")
			else
				VengeanceStatusDB.spam = true
				DEFAULT_CHAT_FRAME:AddMessage(f.label.."Self reporting On.")
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."Mouseover the statusbar for report")
		end
	elseif command == "combat" then
		if VengeanceStatusDB.combat then
			VengeanceStatusDB.combat = nil
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."Show in combat only Off.")
		else
			VengeanceStatusDB.combat = true
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."Show in combat only On.")
		end
		toggle(isTank())
	elseif strmatch(command,"humor%s*%d*") then
		if VengeanceStatusDB.humor then
			VengeanceStatusDB.humor = nil
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."High Vengeance humor Off.")
		else
			local humor = tonumber(strmatch(command,"humor%s*(%d*)"))
			if (not humor) or (humor < 1 or humor > 100) then
				humor = 100
			end
			VengeanceStatusDB.humor = humor
			DEFAULT_CHAT_FRAME:AddMessage(f.label.."High Vengeance humor On".."("..humor.."%)")
		end
	elseif strmatch(command,"scale%s+%d*%.?%d*") then
		local scale = tonumber(strmatch(command,"scale%s+(%d*%.?%d*)"))
		if scale >= 0.5 and scale <= 2 then
			if f.statusBar:GetScale() ~= scale then
				f.statusBar:SetScale(scale)
				VengeanceStatusDB.scale = scale
				if f.statusBar.locked then
					f.statusBar:EnableMouse(true)
					f.statusBar.locked = nil
					VengeanceStatusDB.locked = nil
					VengeanceStatusDB.spam = nil
				end
			end
		end
	elseif strmatch(command,"bgalpha%s+%d*%.?%d*") then
		local bgalpha = tonumber(strmatch(command,"bgalpha%s+(%d*%.?%d*)"))
		if bgalpha >= 0 and bgalpha <= 1 then
			f.statusBar:SetBackdropColor(0,0,0,bgalpha)
			VengeanceStatusDB.bgalpha = bgalpha
		end
	end
end

function f.PLAYER_LOGIN()
	f.vengmax = floor(0.1*UnitHealthMax("player"))
	local text = "0/"..f.vengmax
	f.statusBar:SetMinMaxValues(0,f.vengmax)
	f.statusBar:SetValue(0)
	f.statusBar.Text:SetText(text)
	f:UnregisterEvent("PLAYER_LOGIN")
	local _, eclass = UnitClass("player")
	f.eclass = eclass
	if not (eclass == "WARRIOR" or eclass == "DRUID" or eclass == "DEATHKNIGHT" or eclass == "PALADIN") then
		shutdown()
	end
	if eclass == "DRUID" then
		f:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	end
	f:RegisterEvent("PLAYER_ALIVE")
	toggle(isTank())
end

function f.ACTIVE_TALENT_GROUP_CHANGED()
	toggle(isTank())
end

function f.UPDATE_SHAPESHIFT_FORM()
	local form = GetShapeshiftFormID()
	if form and form == BEAR_FORM then
		toggle(true)
	else
		toggle(false)
	end
end

function f.PLAYER_ENTERING_WORLD()
	toggle(isTank())
end

function f.PLAYER_ALIVE()
	toggle(isTank())
	f:UnregisterEvent("PLAYER_ALIVE")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function f.ADDON_LOADED(...)
	local arg1 = ...;
	if arg1 == "VengeanceStatus" then
		VengeanceHistoryDB = {}
		VengeanceHistoryDB[f.player] = {}
		db = VengeanceHistoryDB[f.player]
		VengeanceStatusDB = VengeanceStatusDB or {["keepSession"] = false, ["scale"] = 1, ["border"] = true}
		f.statusBar = createVengeanceStatusBar()
		SlashCmdList["VENGEANCESTATUS"] = SlashHandler
		SLASH_VENGEANCESTATUS1 = "/vengeancestatus"
		SLASH_VENGEANCESTATUS2 = "/vgs"
		f:UnregisterEvent("ADDON_LOADED")
	end
end

function f.UNIT_MAXHEALTH(...)
	local unit = ...;
	if unit == "player" then
		f.vengmax = floor(0.1*UnitHealthMax("player"))
		f.statusBar:SetMinMaxValues(0,f.vengmax)
		local vengval = f.statusBar:GetValue()
		if vengval and (vengval > 0) then
			local percentmax = min(((vengval/f.vengmax)*100),100)
			f.statusBar.Text:SetText(string.format("%s/%s (%.2f%%)",vengval,f.vengmax,percentmax))
			if VengeanceStatusDB.humor then
				if not f.humordone then
					if percentmax >= VengeanceStatusDB.humor then
						doHumor()
						f.humordone = true
					end
				end
			end
		else
			f.statusBar.Text:SetText("0/"..f.vengmax)
		end
	end
end

function f.UNIT_AURA(...)
	local unit = ...;
	if unit == "player" then
		local n,_,_,_,_,_,_,_,_,_,id = UnitAura("player", (GetSpellInfo(93098)));
		if n then
			f.ScanTip:ClearLines()
			f.ScanTip:SetUnitBuff("player",n)
			local tipText = getTooltipText(f.ScanTip:GetRegions())
			local vengval,percentmax,downtime
			vengval = tonumber(string.match(tipText,"%d+"))
			f.vengmax = floor(0.1*UnitHealthMax("player"))
			percentmax = (vengval/f.vengmax)*100
			f.fightMax = vengval > f.fightMax and vengval or f.fightMax
			f.fightMaxPercent = percentmax > f.fightMaxPercent and percentmax or f.fightMaxPercent 
			tinsert(f.fightData,vengval)
			if f.fightStart > 0 and f.fightEnd == 0 then -- (we're in combat)
				if not up then
					up = GetTime()
				end
				if down and up > down then
					downtime = up - down
					tinsert(f.vengDowntime,downtime)
				end
			end
			down = nil
			f.statusBar:SetMinMaxValues(0,f.vengmax)
			f.statusBar:SetValue(vengval)
			f.statusBar.Text:SetText(string.format("%s/%s (%.2f%%)",vengval,f.vengmax,percentmax))
			if VengeanceStatusDB.humor then
				if not f.humordone then
					if percentmax >= VengeanceStatusDB.humor then
						doHumor()
						f.humordone = true
					end
				end
			end
		else
			if f.fightStart > 0 and f.fightEnd == 0 then -- (in combat)
				if not down then
					if up then
						down = GetTime()
					end
				end
			end
			f.statusBar:SetMinMaxValues(0,f.vengmax)
			f.statusBar:SetValue(0)
			f.statusBar.Text:SetText("0/"..f.vengmax)
			up = nil
		end
	end
end

function f.PLAYER_REGEN_ENABLED() -- ooc
	local veng, vrecords, average = 0, #(f.fightData), 0
	if vrecords > 0 then
		for _,v in ipairs(f.fightData) do
			veng = veng + v
		end
	end
	if veng > 0 then
		average = veng/vrecords
	end
	local downtime, trecords = 0, #(f.vengDowntime)
	if trecords > 0 then
		for _,v in ipairs(f.vengDowntime) do
			downtime = downtime + v
		end
	end
	f.fightEnd = GetTime()
	local combattime = 0
	if f.fightStart > 0 and f.fightEnd > f.fightStart then
		combattime = f.fightEnd - f.fightStart
	end
	vengReport(f.fightMax, f.fightMaxPercent, average, downtime, combattime)
	-- Cleanup
	wipe(f.vengDowntime)
	wipe(f.fightData)
	f.fightStart = 0
	f.humordone = nil
	if VengeanceStatusDB.combat then
		f.statusBar:Hide()
	end
end

function f.PLAYER_REGEN_DISABLED() -- ic
	f.fightMax = 0
	f.fightMaxPercent = 0
	f.fightStart = GetTime()
	f.fightEnd = 0
	local n = UnitAura("player", (GetSpellInfo(93098)));
	if n then -- carry over from previous fight
		up = f.fightStart
	else
		down = f.fightStart
	end
	if VengeanceStatusDB.combat then
		f.statusBar:Show()
	end
end

--[[
ACTIVE_TALENT_GROUP_CHANGED
PLAYER_TALENT_UPDATE
UPDATE_SHAPESHIFT_FORM
local masteryindex = GetPrimaryTalentTree()
local id, name, description, icon, pointsSpent, background, previewPointsSpent, isUnlocked = GetTalentTabInfo(i, inspect, pet, talentGroup)
local form = GetShapeshiftFormID()
MOONKIN_FORM (31), BEAR_FORM(5)
local masteryKnown = IsSpellKnown(CLASS_MASTERY_SPELLS[class])
local talentGroup == GetActiveTalentGroup()
GetNumTalentGroups()
]]