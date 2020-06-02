local mod	= DBM:NewMod("Ignis", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4133 $"):sub(12, -3))
mod:SetCreatureID(33118)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS"
)

local announceSlagPot			= mod:NewTargetAnnounce(63477, 3)

local warnFlameJetsCast			= mod:NewSpecialWarningCast(63472)

local timerFlameJetsCast		= mod:NewCastTimer(2.7, 63472)
local timerFlameJetsCooldown	= mod:NewCDTimer(25, 63472)
local timerScorchCooldown		= mod:NewNextTimer(20, 63473)
local timerScorchCast			= mod:NewCastTimer(3, 63473)
local timerSlagPot				= mod:NewTargetTimer(10, 63477)
local timerAchieve				= mod:NewAchievementTimer(240, 2930, "TimerSpeedKill")
local activateConstructCooldown	= mod:NewCDTimer(40, 62488)

mod:AddBoolOption("SlagPotIcon")

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 33118, "Ignis the Furnace Master")
	timerAchieve:Start()
	timerScorchCooldown:Start(12-delay)
	if(mod:IsDifficulty("heroic10")) then
		activateConstructCooldown:Start(40)
	else
		activateConstructCooldown:Start(30)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 33118, "Ignis the Furnace Master", wipe)
end

function uniqueTestFunc()
	warnFlameJetsCast:Show()
	if(mod:IsDifficulty("heroic10")) then
		activateConstructCooldown:Start(30)
	else
		activateConstructCooldown:Start(40)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(62680, 63472) then		-- Flame Jets
		timerFlameJetsCast:Start()
		warnFlameJetsCast:Show()
		timerFlameJetsCooldown:Start()
	end
	if args:IsSpellID(62488) then		-- Activate Construct
		if(mod:IsDifficulty("heroic10")) then
			activateConstructCooldown:Start(40)
		else
			activateConstructCooldown:Start(30)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(62548, 63474) then	-- Scorch
		timerScorchCast:Start()
		timerScorchCooldown:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(62717, 63477) then		-- Slag Pot
		announceSlagPot:Show(args.destName)
		timerSlagPot:Start(args.destName)
		if self.Options.SlagPotIcon then
			self:SetIcon(args.destName, 8, 10)
		end
	end
end