local mod	= DBM:NewMod("Jaraxxus", "DBM-Coliseum")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4346 $"):sub(12, -3))
mod:SetCreatureID(34780)
mod:SetMinCombatTime(30)
mod:SetUsedIcons(7, 8)

--mod:RegisterCombat("combat")
mod:RegisterCombat("yell", L.Aggro)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"SPELL_HEAL",
	"SPELL_PERIODIC_HEAL",
	"CHAT_MSG_MONSTER_YELL"
)

local isDispeller = select(2, UnitClass("player")) == "MAGE"
	    		 or select(2, UnitClass("player")) == "PRIEST"
	    		 or select(2, UnitClass("player")) == "SHAMAN"

local isMagicDispeller = select(2, UnitClass("player")) == "PALADIN"
	    		 or select(2, UnitClass("player")) == "PRIEST"

local warnFelFireball			= mod:NewCastAnnounce(66532, 2)
local warnPortalSoon			= mod:NewSoonAnnounce(67900, 3)
local warnVolcanoSoon			= mod:NewSoonAnnounce(67901, 3)
local warnFlame					= mod:NewTargetAnnounce(68123, 4)
local warnFlesh					= mod:NewTargetAnnounce(66237, 4, nil, mod:IsHealer())
local warnNetherPower			= mod:NewAnnounce("WarnNetherPower", 4, 67009)

local specWarnFlame				= mod:NewSpecialWarningRun(67072)
local specWarnFlesh				= mod:NewSpecialWarningYou(66237)
local specWarnKiss				= mod:NewSpecialWarningYou(67907, false)
local specWarnNetherPower		= mod:NewSpecialWarning("SpecWarnNetherPower", isDispeller)
local specWarnFelInferno		= mod:NewSpecialWarningMove(68718) 
local SpecWarnFelFireball		= mod:NewSpecialWarning("SpecWarnFelFireball", false)
local SpecWarnFelFireballDispel	= mod:NewSpecialWarningDispel(66965, isMagicDispeller)

local timerCombatStart			= mod:NewTimer(71.5, "TimerCombatStart", 2457) -- rollplay for first pull
local enrageTimer				= mod:NewBerserkTimer(600)
local timerFlame 				= mod:NewTargetTimer(8, 68123) 		-- There are 8 debuff Ids. Since we detect first to warn, use an 8sec timer to cover duration of trigger spell and damage debuff.
local timerFlameCD				= mod:NewCDTimer(30, 68125) 		-- Every 30 sec
local timerNetherPowerCD		= mod:NewCDTimer(25, 67108) 		-- Every 25-45 sec
local timerFlesh				= mod:NewTargetTimer(12, 67049)
local timerFleshCD				= mod:NewCDTimer(20, 67051) 		-- Every 20-25 sec
local timerPortalCD				= mod:NewNextTimer(120, 67900) 		-- Every 120 sec
local timerVolcanoCD			= mod:NewNextTimer(120, 67901) 		-- Every 120 sec
local timerFelFireballCD		= mod:NewCDTimer(10, 66532, false) 	-- Every 10-15 sec
local timerFelLightningCD		= mod:NewCDTimer(10, 66528, false) 	-- Every 10-15 sec


mod:AddBoolOption("LegionFlameWhisper", false, "announce")
mod:AddBoolOption("LegionFlameRunSound", true)
mod:AddBoolOption("LegionFlameIcon", true)
mod:AddBoolOption("IncinerateFleshIcon", true)

mod:RemoveOption("HealthFrame")
mod:AddBoolOption("IncinerateShieldFrame", true, "misc")


function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 34780, "Lord Jaraxxus")
	if self.Options.IncinerateShieldFrame then
		DBM.BossHealth:Show(L.name)
		DBM.BossHealth:AddBoss(34780, L.name)
	end
	warnPortalSoon:Schedule(15-delay)	
	timerPortalCD:Start(20-delay)		-- Nether Portal 20 sec. after pull, next every 120 sec.
	warnVolcanoSoon:Schedule(80-delay)	-- 5 sec. longer (hack-fix for delay caused by Nether Power)
	timerVolcanoCD:Start(80-delay)		-- Volcano 80 sec. after pull, next every 120 sec.
	timerFleshCD:Start(25-delay) 		-- Incinerate Flesh 24-26 sec. after pull, next every 20-25 sec.
	timerFlameCD:Start(-delay)
	timerNetherPowerCD:Start(-delay)
	timerFelFireballCD:Start(5)
	timerFelLightningCD:Start()
	enrageTimer:Start(-delay)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 34780, "Lord Jaraxxus", wipe)
	DBM.BossHealth:Clear()
end

do
	local lastflame = 0
	local lastinferno = 0
	function mod:SPELL_DAMAGE(args)
		if args:IsPlayer() and args:IsSpellID(66877, 67070, 67071, 67072) then		-- Legion Flame
			if GetTime() - 3 > lastflame then
				specWarnFlame:Show()
				if self.Options.LegionFlameRunSound then
					PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav")
				end
				lastflame = GetTime()
			end
		elseif args:IsPlayer() and args:IsSpellID(66496, 68716, 68717, 68718) then	-- Fel Inferno
			if GetTime() - 3 > lastinferno then
				specWarnFelInferno:Show()
				lastinferno = GetTime()
			end
		end
	end
end

local setIncinerateTarget, clearIncinerateTarget
do
	local incinerateTarget
	local healed = 0
	local maxAbsorb = 0
	local function getShieldHP()
		return math.max(1, math.floor(healed / maxAbsorb * 100))
	end
	
	function mod:SPELL_HEAL(args)
		if args.destGUID == incinerateTarget then
			healed = healed + (args.absorbed or 0)
		end
	end	
	mod.SPELL_PERIODIC_HEAL = mod.SPELL_HEAL
	
	function setIncinerateTarget(mod, target, name)
		incinerateTarget = target
		healed = 0
		maxAbsorb = mod:IsDifficulty("heroic25") and 85000 or
					mod:IsDifficulty("heroic10") and 40000 or
					mod:IsDifficulty("normal25") and 60000 or
					mod:IsDifficulty("normal10") and 30000 or 0
		DBM.BossHealth:RemoveBoss(getShieldHP)
		DBM.BossHealth:AddBoss(getShieldHP, L.IncinerateTarget:format(name))
	end
	
	function clearIncinerateTarget(self, name)
		DBM.BossHealth:RemoveBoss(getShieldHP)
		if self.Options.IncinerateFleshIcon then
			self:RemoveIcon(name)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(67051, 67050, 67049, 66237) then	-- Incinerate Flesh
		warnFlesh:Show(args.destName)
		timerFlesh:Start(args.destName)
		timerFleshCD:Start()
		if self.Options.IncinerateFleshIcon then
			self:SetIcon(args.destName, 8, 15)
		end
		if args:IsPlayer() then
			specWarnFlesh:Show()
		end
		setIncinerateTarget(self, args.destGUID, args.destName)
		self:Schedule(15, clearIncinerateTarget, self, args.destName)

	elseif args:IsSpellID(66197, 68123, 68124, 68125) then	-- Legion Flame ids 66199, 68126, 68127, 68128 (second debuff) do the actual damage. First 2 seconds are trigger debuff only.
		local targetname = args.destName
		timerFlame:Start(args.destName)
		timerFlameCD:Start()		
		if args:IsPlayer() then
			specWarnFlame:Show()
			if self.Options.LegionFlameRunSound then
				PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav")
			end
		end		
		if self.Options.LegionFlameIcon then
			self:SetIcon(args.destName, 7, 8)
		end
		if DBM:GetRaidRank() >= 1 and self.Options.LegionFlameWhisper then
			self:SendWhisper(L.WhisperFlame, targetname)
		end
	elseif args:IsSpellID(66334, 67905, 67906, 67907) and args:IsPlayer() then
		specWarnKiss:Show()

	elseif args:IsSpellID(66532, 66963, 66964, 66965) then	-- Fel Fireball (announce if tank gets debuff for dispel)
		SpecWarnFelFireballDispel:Show(args.destName)

	elseif args:IsSpellID(66242, 67061, 67059, 67060) then	-- blooper
		PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\fail.mp3", "Master")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(67051, 67050, 67049, 66237) then	-- Incinerate Flesh
		timerFlesh:Stop()
		clearIncinerateTarget(self, args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(66532, 66963, 66964, 66965) and UnitName("target") == L.name then	-- Fel Fireball (track cast for interupt, only when targeted)
		warnFelFireball:Show()
		SpecWarnFelFireball:Show()
		timerFelFireballCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(66197, 68123, 68124, 68125) then	-- Legion Flame
		warnFlame:Show(args.destName)
	elseif args:IsSpellID(66528, 67029, 67030, 67031) then 	-- Fel Lightning
		timerFelLightningCD:Start()
	elseif args:IsSpellID(66228, 67107, 67106, 67108) then	-- Nether Power
		warnNetherPower:Show()
		timerNetherPowerCD:Start()
		specWarnNetherPower:Show()
		timerPortalCD:AddTime(5)
		timerVolcanoCD:AddTime(5)
		timerFlameCD:AddTime(5)
		timerFleshCD:AddTime(5)
		timerFelFireballCD:AddTime(5)
		timerFelLightningCD:AddTime(5)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.FirstPull or msg:find(L.FirstPull) then
		timerCombatStart:Start()
	elseif msg == L.PortalSpawn or msg:find(L.PortalSpawn) then 	-- Nether Portal
		timerPortalCD:Start()
		warnPortalSoon:Schedule(130) -- 20 sec. longer (hack-fix for delay caused by Nether Power)
	elseif msg == L.VolcanoSpawn or msg:find(L.VolcanoSpawn) then 	-- Infernal Volcano
		timerVolcanoCD:Start()
		warnVolcanoSoon:Schedule(130) -- 20 sec. longer (hack-fix for delay caused by Nether Power)
	end
end