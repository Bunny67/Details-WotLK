local mod	= DBM:NewMod("Mimiron", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4338 $"):sub(12, -3))
mod:SetCreatureID(33432)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("yell", L.YellPull)
mod:RegisterCombat("yell", L.YellHardPull)
mod:RegisterKill("yell", L.YellKilled)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_AURA_REMOVED",
	"UNIT_SPELLCAST_CHANNEL_STOP",
	"CHAT_MSG_LOOT",
	"SPELL_SUMMON",
	"SPELL_DAMAGE"
)

local blastWarn					= mod:NewTargetAnnounce(64529, 4)
local shellWarn					= mod:NewTargetAnnounce(63666, 2)
local lootannounce				= mod:NewAnnounce("MagneticCore", 1)
local warnBombSpawn				= mod:NewAnnounce("WarnBombSpawn", 3)
local warnFrostBomb				= mod:NewSpellAnnounce(64623, 3)

local warnFlamesSoon			= mod:NewSoonAnnounce(64566, 1) 
local warnFlamesIn5Sec			= mod:NewSpecialWarning("WarningFlamesIn5Sec", 3)

local warnShockBlast			= mod:NewSpecialWarning("WarningShockBlast", nil, false)
mod:AddBoolOption("ShockBlastWarningInP1", mod:IsMelee(), "announce")
mod:AddBoolOption("ShockBlastWarningInP4", mod:IsMelee(), "announce")
local warnDarkGlare				= mod:NewSpecialWarningSpell(63293)

local enrage 					= mod:NewBerserkTimer(480)
local timerHardmode				= mod:NewTimer(480, "TimerHardmode", 64582)
local timerP1toP2				= mod:NewTimer(40, "TimeToPhase2") 
local timerP2toP3				= mod:NewTimer(17, "TimeToPhase3")
local timerP3toP4				= mod:NewTimer(27, "TimeToPhase4")
local timerProximityMines		= mod:NewCDTimer(25, 63027)
local timerShockBlast			= mod:NewCastTimer(63631)
local timerSpinUp				= mod:NewCastTimer(4, 63414)
local timerDarkGlareCast		= mod:NewCastTimer(10, 63274)
local timerNextDarkGlare		= mod:NewNextTimer(31, 63274)
local timerNextShockblast		= mod:NewNextTimer(30, 63631)
local timerPlasmaBlastCD		= mod:NewCDTimer(45, 64529)
local timerShell				= mod:NewBuffActiveTimer(6, 63666)
local timerFlameSuppressant		= mod:NewCastTimer(75, 64570)
local timerFlameSuppressantCD	= mod:NewCDTimer(10, 65192)
local timerNextFlames			= mod:NewNextTimer(30, 64566)
local timerNextFrostBomb        = mod:NewNextTimer(30, 64623)
local timerBombExplosion		= mod:NewCastTimer(12.5, 65333)
local timerBombBotSpawn			= mod:NewCDTimer(15, 63811)

mod:AddBoolOption("PlaySoundOnShockBlast", isMelee)
mod:AddBoolOption("PlaySoundOnDarkGlare", true)
mod:AddBoolOption("HealthFramePhase4", true)
mod:AddBoolOption("AutoChangeLootToFFA", true)
mod:AddBoolOption("SetIconOnNapalm", true)
mod:AddBoolOption("SetIconOnPlasmaBlast", true)
mod:AddBoolOption("RangeFrame")
mod:AddBoolOption("WarnFlamesIn5Sec", true)
mod:AddBoolOption("SoundWarnCountingFlames", true)

local hardmode = false
local phase						= 0 
local lootmethod, masterlooterRaidID

local spinningUp				= GetSpellInfo(63414)
local lastSpinUp				= 0
local is_spinningUp				= false
local napalmShellTargets = {}
local napalmShellIcon 	= 7

local function warnNapalmShellTargets()
	shellWarn:Show(table.concat(napalmShellTargets, "<, >"))
	table.wipe(napalmShellTargets)
	napalmShellIcon = 7
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 33432, "Mimiron")
    phase = 0
    hardmode = false
	is_spinningUp = false
	napalmShellIcon = 7
	table.wipe(napalmShellTargets)
	
	enrage:Start(-delay)
	self:NextPhase()
	timerPlasmaBlastCD:Start(24-delay) 
	if DBM:GetRaidRank() == 2 then
		lootmethod, _, masterlooterRaidID = GetLootMethod()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(6)
	end
end

function mod:OnCombatEnd()
	DBM:FireCustomEvent("DBM_EncounterEnd", 33432, "Mimiron", wipe)
	DBM.BossHealth:Hide()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.AutoChangeLootToFFA and DBM:GetRaidRank() == 2 then
		if masterlooterRaidID then
			SetLootMethod(lootmethod, "raid"..masterlooterRaidID)
		else
			SetLootMethod(lootmethod)
		end
	end
end

function mod:Flames()	-- Flames 
	timerNextFlames:Start()
	self:ScheduleMethod(30, "Flames")
	warnFlamesSoon:Schedule(20)
	if self.Options.WarnFlamesIn5Sec then
		warnFlamesIn5Sec:Schedule(25)
	end
	if self.Options.SoundWarnCountingFlames then
		self:ScheduleMethod(25, "ToFlames5")
		self:ScheduleMethod(26, "ToFlames4")
		self:ScheduleMethod(27, "ToFlames3")
		self:ScheduleMethod(28, "ToFlames2")
		self:ScheduleMethod(29, "ToFlames1")
	end
end
-- SOUND FUNCTIONS
function mod:ToFlames5()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\5.mp3", "Master")
end

function mod:ToFlames4()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\4.mp3", "Master")
end

function mod:ToFlames3()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\3.mp3", "Master")
end

function mod:ToFlames2()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\2.mp3", "Master")
end

function mod:ToFlames1()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\1.mp3", "Master")
end

function mod:BombBot()	-- Bomb Bot
	if phase == 3 then
		timerBombBotSpawn:Start()
		self:ScheduleMethod(15, "BombBot")
	end
end

local function show_warning_for_spinup()
	if is_spinningUp then
		warnDarkGlare:Show()
		if mod.Options.PlaySoundOnDarkGlare then
			PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav")
		end
	end
end

function mod:UNIT_SPELLCAST_CHANNEL_STOP(unit, spell)
	if spell == spinningUp and GetTime() - lastSpinUp < 3.9 then
		is_spinningUp = false
		self:SendSync("SpinUpFail")
	end
end

function mod:CHAT_MSG_LOOT(msg)
	local player, itemID = msg:match(L.LootMsg)
	if player and itemID and tonumber(itemID) == 46029 then
		lootannounce:Show(player)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(63631) then -- Shock Blast
		if phase == 1 and self.Options.ShockBlastWarningInP1 or phase == 4 and self.Options.ShockBlastWarningInP4 then
			warnShockBlast:Show()
		end
		timerShockBlast:Start()
		timerNextShockblast:Start()
		if self.Options.PlaySoundOnShockBlast then
			PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav")
		end
	elseif args:IsSpellID(64529, 62997) then	-- Plasma Blast
		timerPlasmaBlastCD:Start()
	elseif args:IsSpellID(64570) then	-- Flame Suppressant (phase 1)
		timerFlameSuppressant:Start()
	elseif args:IsSpellID(64623) then	-- Frost Bomb
		warnFrostBomb:Show()
		timerBombExplosion:Start()
		timerNextFrostBomb:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(63666, 65026) and args:IsDestTypePlayer() then	-- Napalm Shell
		napalmShellTargets[#napalmShellTargets + 1] = args.destName
		timerShell:Start()
		if self.Options.SetIconOnNapalm then
			self:SetIcon(args.destName, napalmShellIcon, 6)
			napalmShellIcon = napalmShellIcon - 1
		end
		self:Unschedule(warnNapalmShellTargets)
		self:Schedule(0.3, warnNapalmShellTargets)
	elseif args:IsSpellID(64529, 62997) then	-- Plasma Blast
		blastWarn:Show(args.destName)
		if self.Options.SetIconOnPlasmaBlast then
			self:SetIcon(args.destName, 8, 6)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(63027) then				-- Proximity Mines
		timerProximityMines:Start()

	elseif args:IsSpellID(63414) then			-- Spinning UP (before Dark Glare)
		is_spinningUp = true
		timerSpinUp:Start()
		timerDarkGlareCast:Schedule(4)
		timerNextDarkGlare:Schedule(14)			-- 4 (cast spinup) + 10 sec (cast dark glare)
		DBM:Schedule(0.15, show_warning_for_spinup)	-- wait 0.15 and then announce it, otherwise it will sometimes fail
		lastSpinUp = GetTime()
	
	elseif args:IsSpellID(65192) then	-- Flame Suppressant CD (phase 2)
		timerFlameSuppressantCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(63666, 65026) then -- Napalm Shell
		if self.Options.SetIconOnNapalm then
			self:SetIcon(args.destName, 0)
		end
	end
end


function mod:OnSync(event, args)
	if event == "SpinUpFail" then
		is_spinningUp = false
		timerSpinUp:Cancel()
		timerDarkGlareCast:Cancel()
		timerNextDarkGlare:Cancel()
		warnDarkGlare:Cancel()
	elseif event == "Phase2" and phase == 1 then -- alternate localized-dependent detection
		self:NextPhase()
	elseif event == "Phase3" and phase == 2 then
		self:NextPhase()
	elseif event == "Phase4" and phase == 3 then
		self:NextPhase()
	end
end

function mod:NextPhase()
	phase = phase + 1
	if phase == 1 then
		if self.Options.HealthFrame then
			DBM.BossHealth:Clear()
			DBM.BossHealth:AddBoss(33432, L.MobPhase1)
		end

	elseif phase == 2 then
		timerNextShockblast:Stop()
		timerProximityMines:Stop()
		timerFlameSuppressant:Stop()
		timerPlasmaBlastCD:Stop()
		timerP1toP2:Start()
		timerNextDarkGlare:Schedule(43)
		if self.Options.HealthFrame then
			DBM.BossHealth:Clear()
			DBM.BossHealth:AddBoss(33651, L.MobPhase2)
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if hardmode then
            timerNextFrostBomb:Start(46)
        end

	elseif phase == 3 then
		if self.Options.AutoChangeLootToFFA and DBM:GetRaidRank() == 2 then
			SetLootMethod("freeforall")
		end
		timerDarkGlareCast:Cancel()
		timerNextDarkGlare:Cancel()
		timerNextFrostBomb:Cancel()
		timerP2toP3:Start()
		timerBombBotSpawn:Start(34)
		self:ScheduleMethod(34, "BombBot")
		if self.Options.HealthFrame then
			DBM.BossHealth:Clear()
			DBM.BossHealth:AddBoss(33670, L.MobPhase3)
		end

	elseif phase == 4 then
		if self.Options.AutoChangeLootToFFA and DBM:GetRaidRank() == 2 then
			if masterlooterRaidID then
				SetLootMethod(lootmethod, "raid"..masterlooterRaidID)
			else
				SetLootMethod(lootmethod)
			end
		end
		timerBombBotSpawn:Stop()
		self:UnscheduleMethod("BombBot")
		timerP3toP4:Start()
		timerProximityMines:Start(34)
		timerNextDarkGlare:Start(72)
		if self.Options.HealthFramePhase4 or self.Options.HealthFrame then
			DBM.BossHealth:Show(L.name)
			DBM.BossHealth:AddBoss(33670, L.MobPhase3)
			DBM.BossHealth:AddBoss(33651, L.MobPhase2)
			DBM.BossHealth:AddBoss(33432, L.MobPhase1)
		end
		if hardmode then
            timerNextFrostBomb:Start(28)
        end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L.YellPhase2 or msg:find(L.YellPhase2)) then -- register Phase 2
		self:SendSync("Phase2")

	elseif (msg == L.YellPhase3 or msg:find(L.YellPhase3)) then -- register Phase 3
		self:SendSync("Phase3")

	elseif (msg == L.YellPhase4 or msg:find(L.YellPhase4)) then -- register Phase 4
		self:SendSync("Phase4")
	
	elseif (msg == L.YellHardPull or msg:find(L.YellHardPull)) then -- register HARDMODE
		enrage:Stop()
		hardmode = true
		timerHardmode:Start()
		timerPlasmaBlastCD:Start(28)
		timerFlameSuppressant:Start()
		timerProximityMines:Start(21) 
		timerNextFlames:Start(7)
		self:ScheduleMethod(7, "Flames")
		if self.Options.WarnFlamesIn5Sec then
			warnFlamesIn5Sec:Schedule(2) 
		end
		if self.Options.SoundWarnCountingFlames then
			self:ScheduleMethod(2, "ToFlames5")
			self:ScheduleMethod(3, "ToFlames4")
			self:ScheduleMethod(4, "ToFlames3")
			self:ScheduleMethod(5, "ToFlames2")
			self:ScheduleMethod(6, "ToFlames1")
		end
		timerNextShockblast:Start(37)

	elseif (msg == L.YellKilled or msg:find(L.YellKilled)) then -- register kill
		enrage:Stop()
		timerHardmode:Stop()
		timerNextFlames:Stop()
		self:UnscheduleMethod("Flames")
		timerNextFrostBomb:Stop()
		timerNextDarkGlare:Stop()
		timerProximityMines:Stop()
		warnFlamesSoon:Cancel()
		warnFlamesIn5Sec:Cancel()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(63811) then
		timerBombBotSpawn:Start()
		warnBombSpawn:Show()
	end
end