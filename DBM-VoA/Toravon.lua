local mod	= DBM:NewMod("Toravon", "DBM-VoA")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4264 $"):sub(12, -3))
mod:SetCreatureID(38433)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE"
)

local warnFreezingGround	= mod:NewSpellAnnounce(72104, 1)
local warnWhiteout			= mod:NewSpellAnnounce(72096, 2)
local warnOrb				= mod:NewSpellAnnounce(72095, 3)
local WarnFrostbite			= mod:NewAnnounce("Frostbite", 2, 72098, mod:IsHealer() or mod:IsTank())

local timerNextFrostbite	= mod:NewNextTimer(5, 72098, nil, mod:IsTank())
local timerFrostbite		= mod:NewTargetTimer(20, 72098, nil, mod:IsHealer() or mod:IsTank())
local timerWhiteout			= mod:NewNextTimer(38, 72096)
local timerNextOrb			= mod:NewNextTimer(32, 72095)

--local timerToravonEnrage	= mod:NewTimer(300, "ToravonEnrage", 26662)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 38433, "Toravon the Ice Watcher")
	timerNextOrb:Start(13-delay)
	timerWhiteout:Start(25-delay)
--	timerToravonEnrage:Start(-delay)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 38433, "Toravon the Ice Watcher", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(72096, 72034) then
		warnWhiteout:Show()
		timerWhiteout:Start()
	elseif args:IsSpellID(72095, 72091) then	--Frozen Orb(add)
		warnOrb:Show()
		timerNextOrb:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(72104, 72090) then			-- Freezing Ground (Aoe and damage debuff)
		warnFreezingGround:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(72098, 72004) then		-- Frostbite (tanks only debuff)
		WarnFrostbite:Show(args.destName, args.amount or 1)
		timerNextFrostbite:Start()
		timerFrostbite:Start(args.destName)
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED