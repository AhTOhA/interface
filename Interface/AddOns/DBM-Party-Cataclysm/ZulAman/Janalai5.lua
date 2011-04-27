﻿if tonumber((select(2, GetBuildInfo()))) < 13682 then return end
local mod	= DBM:NewMod("Janalai5", "DBM-Party-Cataclysm", 10)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5294 $"):sub(12, -3))
mod:SetCreatureID(23578)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"CHAT_MSG_MONSTER_YELL"
)

local warnFlame			= mod:NewTargetAnnounce(43140, 3)
local warnAdds			= mod:NewSpellAnnounce(43962, 4)
local warnAddsSoon		= mod:NewSoonAnnounce(43962, 3)
local warnFireBomb		= mod:NewSpellAnnounce(42630, 3)

local specWarnAdds		= mod:NewSpecialWarningSpell(43962)
local specWarnBomb		= mod:NewSpecialWarningSpell(42630)

local timerBomb			= mod:NewCastTimer(12, 42630)
local timerAdds			= mod:NewNextTimer(92, 43962)

local berserkTimer		= mod:NewBerserkTimer(600)

mod:AddBoolOption("FlameIcon", true)

function mod:FlameTarget()
	local targetname = self:GetBossTarget(23578)
	if not targetname then return end
	warnFlame:Show(targetname)
	if self.Options.FlameIcon and mod:LatencyCheck() then--Latency check when using icons with target scanning to reduce false icons on tanks
		self:SetIcon(targetname, 8, 8)
	end	
end

function mod:OnCombatStart(delay)
	timerAdds:Start(10)
	berserkTimer:Start(-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(43140) then
		self:ScheduleMethod(0.2, "FlameTarget")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellAdds or msg:find(L.YellAdds) then
		warnAdds:Show()
		specWarnAdds:Show()
		warnAddsSoon:Schedule(82)
		timerAdds:Start()
	elseif msg == L.YellBomb or msg:find(L.YellBomb) then
		warnFireBomb:Show()
		specWarnBomb:Show()
		timerBomb:Start()
	end
end