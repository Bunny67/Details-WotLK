local mod	= DBM:NewMod("Thorim", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4177 $"):sub(12, -3))
mod:SetCreatureID(32865)
mod:SetUsedIcons(8)

mod:RegisterCombat("yell", L.YellPhase1)
mod:RegisterKill("yell", L.YellKill)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE"
)

local warnPhase2				= mod:NewPhaseAnnounce(2, 1)
local warnStormhammer			= mod:NewTargetAnnounce(62470, 2)
local warnLightningCharge		= mod:NewSpellAnnounce(62279, 2)
local warnUnbalancingStrike		= mod:NewTargetAnnounce(62130, 4)	-- nice blizzard, very new stuff, hmm or not? ^^ aq40 4tw :)
local warningBomb				= mod:NewTargetAnnounce(62526, 4)

local specWarnOrb				= mod:NewSpecialWarningMove(62017)

mod:AddBoolOption("AnnounceFails", false, "announce")

local enrageTimer			= mod:NewBerserkTimer(369)
local timerStormhammer			= mod:NewCastTimer(16, 62042)
local timerStormhammerCD		= mod:NewCDTimer(14, 62042) 
local timerLightningCharge	 	= mod:NewCDTimer(10, 62279) 
local timerUnbalancingStrike	= mod:NewCDTimer(20, 62130)
local TimerHardmodeThorim		= mod:NewTimer(150, "TimerHardmodeThorim", 62042)

mod:AddBoolOption("RangeFrame")

local lastcharge				= {} 

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 32865, "Thorim")
	enrageTimer:Start()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
	table.wipe(lastcharge) 
end

local sortedFailsC = {}
local function sortFails1C(e1, e2)
	return (lastcharge[e1] or 0) > (lastcharge[e2] or 0)
end

function mod:OnCombatEnd()
	DBM:FireCustomEvent("DBM_EncounterEnd", 32865, "Thorim", wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.AnnounceFails and DBM:GetRaidRank() >= 1 then
		local lcharge = ""
		for k, v in pairs(lastcharge) do
			table.insert(sortedFailsC, k)
		end
		table.sort(sortedFailsC, sortFails1C)
		for i, v in ipairs(sortedFailsC) do
			lcharge = lcharge.." "..v.."("..(lastcharge[v] or "")..")"
		end
		SendChatMessage(L.Charge:format(lcharge), "RAID")
		table.wipe(sortedFailsC)
	end
end


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(62042) then 					-- Storm Hammer
		warnStormhammer:Show(args.destName)
		timerStormhammerCD:Start()
	elseif args:IsSpellID(62507) then				-- Touch of Dominion
		TimerHardmodeThorim:Start()
	elseif args:IsSpellID(62130) then				-- Unbalancing Strike
		warnUnbalancingStrike:Show(args.destName)
	elseif args:IsSpellID(62526, 62527) then		-- Runic Detonation
		self:SetIcon(args.destName, 8, 5)
		warningBomb:Show(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(62042) then 		-- Storm Hammer
		timerStormhammerCD:Start()
		timerStormhammer:Schedule(2)
	elseif args:IsSpellID(62130) then	-- Unbalancing Strike
		timerUnbalancingStrike:Start()
	end
end


function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPhase2 or msg:find(L.YellPhase2) then		-- Bossfight (tank and spank)
		warnPhase2:Show()
		enrageTimer:Stop()
		if (timerHardmodeThorim ~= nil) then
			timerHardmodeThorim:Stop()
		end
		enrageTimer:Start(300)
	elseif msg == L.YellKill or msg:find(L.YellKill) then
		enrageTimer:Stop()
	end
end

local spam = 0

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(62017) then -- Lightning Shock
		if bit.band(args.destFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0
		and bit.band(args.destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
		and GetTime() - spam > 5 then
			spam = GetTime()
			specWarnOrb:Show()
		end
	elseif self.Options.AnnounceFails and args:IsSpellID(62466) and DBM:GetRaidRank() >= 1 and DBM:GetRaidUnitId(args.destName) ~= "none" and args.destName then
		lastcharge[args.destName] = (lastcharge[args.destName] or 0) + 1
		SendChatMessage(L.ChargeOn:format(args.destName), "RAID")
	end
end