local mod	= DBM:NewMod("Freya_Elders", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 1192 $"):sub(12, -3))

-- passive mod to provide information for multiple fight (trash respawn)
-- mod:SetCreatureID(32914, 32915, 32913)
-- mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"UNIT_DIED"
)

local warnImpale			= mod:NewSpellAnnounce(62928)

local timerImpale			= mod:NewTargetTimer(5, 62928)

local specWarnFistofStone	= mod:NewSpecialWarningSpell(62344, mod:IsTank())
local specWarnGroundTremor	= mod:NewSpecialWarningCast(62932, true)

local soundFistofStone			= mod:NewSound(62344, nil, false)

mod:AddBoolOption("TrashRespawnTimer", true, "timer")

--
-- Trash: 33430 Guardian Lasher (flower)
-- 33355 (nymph)
-- 33354 (tree)
--
-- Elder Stonebark (ground tremor / fist of stone)
-- Elder Brightleaf (unstable sunbeam)
--
--Mob IDs:
-- Elder Ironbranch: 32913
-- Elder Brightleaf: 32915
-- Elder Stonebark: 32914
--

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(62344) then 					-- Fists of Stone
		specWarnFistofStone:Show()
		soundFistofStone:Play()
	elseif args:IsSpellID(62325, 62932) then		-- Ground Tremor
		specWarnGroundTremor:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(62310, 62928) then 			-- Impale
		warnImpale:Show(args.destName)
		timerImpale:Start(args.destName)
	end
end

function mod:UNIT_DIED(args)
	if self.Options.TrashRespawnTimer and not DBM.Bars:GetBar(L.TrashRespawnTimer) then
		local cid = self:GetCIDFromGUID(args.destGUID)
		if cid == 33430 or cid == 33355 or cid == 33354 then		-- guardian lasher / nymph / tree
			DBM.Bars:CreateBar(7200, L.TrashRespawnTimer)
		end
	end
end