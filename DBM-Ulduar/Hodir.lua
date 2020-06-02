local mod	= DBM:NewMod("Hodir", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4154 $"):sub(12, -3))
mod:SetCreatureID(32845)
mod:SetUsedIcons(8)

--mod:RegisterCombat("combat")
mod:RegisterCombat("yell", L.YellPull)
mod:RegisterKill("yell", L.YellKill)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE"
)

local warnStormCloud		= mod:NewTargetAnnounce(65123)

local warnFlashFreeze		= mod:NewSpecialWarningSpell(61968)
local specWarnBitingCold	= mod:NewSpecialWarningMove(62188, false)

mod:AddBoolOption("PlaySoundOnFlashFreeze", true, "announce")
mod:AddBoolOption("YellOnStormCloud", true, "announce")

local enrageTimer			= mod:NewBerserkTimer(480)
local timerFlashFreeze		= mod:NewCastTimer(9, 61968)
local timerFrozenBlows		= mod:NewBuffActiveTimer(20, 63512)
local timerFlashFrCD		= mod:NewCDTimer(60, 61968)
-- local timerAchieve			= mod:NewAchievementTimer(179, 3182, "TimerSpeedKill")
local timerAchieve			= mod:NewTimer(120, "TimerSpeedKill");
mod:AddBoolOption("SetIconOnStormCloud")

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 32845, "Hodir")
	enrageTimer:Start(-delay)
	timerAchieve:Start()
	timerFlashFrCD:Start(-delay)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 32845, "Hodir", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(61968) then
		timerFlashFreeze:Start()
		warnFlashFreeze:Show()
		timerFlashFrCD:Start()
		if self.Options.PlaySoundOnFlashFreeze then
			PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav")
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(62478, 63512) then
		timerFrozenBlows:Start()
	elseif args:IsSpellID(65123, 65133) then
		warnStormCloud:Show(args.destName)
		if self.Options.YellOnStormCloud and args:IsPlayer() then
			SendChatMessage(L.YellCloud, "SAY")
		end
		if self.Options.SetIconOnStormCloud then 
			self:SetIcon(args.destName, 8, 6)
		end
	end
end

do 
	local lastbitingcold = 0
	function mod:SPELL_DAMAGE(args)
		if args:IsSpellID(62038, 62188) and args:IsPlayer() and time() - lastbitingcold > 4 then		-- Biting Cold
			specWarnBitingCold:Show()
			lastbitingcold = time()
		end
	end
end