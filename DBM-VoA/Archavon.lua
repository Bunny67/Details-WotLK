local mod	= DBM:NewMod("Archavon", "DBM-VoA")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4264 $"):sub(12, -3))
mod:SetCreatureID(31125)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

--11/19 19:20:12.949  SPELL_AURA_APPLIED,0xF150007995000007,"Archavon the Stone Watcher",0xa48,0xF140544DF3000002,"Teufelssaurier",0x1114,58678,"Rock Shards",0x1,DEBUFF
--11/19 19:20:16.527  SPELL_AURA_REMOVED,0xF150007995000007,"Archavon the Stone Watcher",0xa48,0xF140544DF3000002,"Teufelssaurier",0x1114,58678,"Rock Shards",0x1,DEBUFF

local warnShards			= mod:NewTargetAnnounce(58678, 2)
local warnGrab				= mod:NewAnnounce("WarningGrab", 4, 53041)
local timerShards			= mod:NewBuffActiveTimer(4, 58678)

local warnLeap				= mod:NewSpellAnnounce(60894, 3)
local warnStomp				= mod:NewSpellAnnounce(60880, 3)
local warnStompSoon			= mod:NewPreWarnAnnounce(60880, 5, 2)
local timerNextStomp		= mod:NewNextTimer(45, 60880)

local timerArchavonEnrage	= mod:NewTimer(300, "ArchavonEnrage", 26662)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 31125, "Archavon the Stone Watcher")
	timerArchavonEnrage:Start()
	timerNextStomp:Start(-delay)
	warnStompSoon:Schedule(40-delay)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 31125, "Archavon the Stone Watcher", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(58663, 60880) then
		warnStomp:Show()
		timerNextStomp:Start()
		warnStompSoon:Schedule(40)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
  if args:IsSpellID(58963, 60895) then		
    warnLeap:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(58678, 58941) then
		warnShards:Show(args.destName)
		timerShards:Start(args.destName)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	local target = msg and msg:match(L.TankSwitch) or msg:find(L.TankSwitch)
	if target then
		warnGrab:Show(target)
	end
end
