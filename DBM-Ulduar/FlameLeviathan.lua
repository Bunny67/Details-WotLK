local mod	= DBM:NewMod("FlameLeviathan", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4181 $"):sub(12, -3))

mod:SetCreatureID(33113)

mod:RegisterCombat("yell", L.YellPull)

mod:RegisterEvents(
	"SPELL_AURA_REMOVED",
	"SPELL_AURA_APPLIED",
	"SPELL_SUMMON"
)

local warnHodirsFury		= mod:NewTargetAnnounce(62297)
local pursueTargetWarn		= mod:NewAnnounce("PursueWarn", 2, 62374)
local warnNextPursueSoon	= mod:NewAnnounce("warnNextPursueSoon", 3, 62374)

local warnSystemOverload	= mod:NewSpecialWarningSpell(62475)
local pursueSpecWarn		= mod:NewSpecialWarning("SpecialPursueWarnYou")
local warnWardofLife		= mod:NewSpecialWarning("warnWardofLife")

local timerSystemOverload	= mod:NewBuffActiveTimer(20, 62475)
local timerFlameVents		= mod:NewCastTimer(10, 62396)
local timerPursued			= mod:NewTargetTimer(30, 62374)
local timerNextVents		= mod:NewTimer(20, "Next Flame Vents")
local timerNextKwiatki		= mod:NewTimer(30, "Ward of Life")
local soundPursued = mod:NewSound(62374)

local guids = {}
local function buildGuidTable()
	table.wipe(guids)
	for i = 1, GetNumRaidMembers() do
		guids[UnitGUID("raid"..i.."pet") or ""] = UnitName("raid"..i)
	end
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 33113, "Flame Leviathan")
	buildGuidTable()
end
function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 33113, "Flame Leviathan", wipe)
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(62907) then		-- Ward of Life spawned (Creature id: 34275)
		warnWardofLife:Show()
		timerNextKwiatki:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(62396) then		-- Flame Vents
		timerFlameVents:Start()
		timerNextVents:Start()

	elseif args:IsSpellID(62475) then	-- Systems Shutdown / Overload
		timerSystemOverload:Start()
		warnSystemOverload:Show()

	elseif args:IsSpellID(62374) then	-- Pursued
		local player = guids[args.destGUID]
		warnNextPursueSoon:Schedule(25)
		timerPursued:Start(player)
		pursueTargetWarn:Show(player)
		if player == UnitName("player") then
			pursueSpecWarn:Show()
			soundPursued:Play()
		end
	elseif args:IsSpellID(62297) then		-- Hodir's Fury (Person is frozen)
		warnHodirsFury:Show(args.destName)
	end

end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(62396) then
		timerFlameVents:Stop()
	end
end