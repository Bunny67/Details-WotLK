local mod	= DBM:NewMod("NorthrendBeasts", "DBM-Coliseum")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4385 $"):sub(12, -3))
mod:SetCreatureID(34797)
mod:SetMinCombatTime(30)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("yell", L.CombatStart)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_DIED"
)

-- Gormok the Impaler
local warnImpaleOn			= mod:NewTargetAnnounce(67478, 2, nil, mod:IsTank() or mod:IsHealer())
local warnFireBomb			= mod:NewSpellAnnounce(66317, 3, nil, false)
local WarningSnobold		= mod:NewAnnounce("WarningSnobold", 4)
local specWarnImpale3		= mod:NewSpecialWarning("SpecialWarningImpale3")
local specWarnAnger3		= mod:NewSpecialWarning("SpecialWarningAnger3", mod:IsTank() or mod:IsHealer())
local specWarnFireBomb		= mod:NewSpecialWarningMove(66317)
local timerDisarm			= mod:NewBuffActiveTimer(10, 65935, nil, false)
local timerDismantle		= mod:NewBuffActiveTimer(10, 51722, nil, false)
local timerNextStompCD		= mod:NewCDTimer(20, 66330) -- 15 sec. after pull, 20-25 sec. every next
local timerNextImpale		= mod:NewNextTimer(9.5, 67477, nil, mod:IsTank() or mod:IsHealer()) -- 9-10 sec. CD (after pull and every next)
local timerRisingAngerCD    = mod:NewCDTimer(20, 66636) -- 16-24 sec. CD (after pull and every next)
-- Acidmaw & Dreadscale
local warnSlimePool			= mod:NewSpellAnnounce(67643, 2, nil, mod:IsMelee())
local warnToxin				= mod:NewTargetAnnounce(66823, 3)
local warnBile				= mod:NewTargetAnnounce(66869, 3)
local warnEnrageWorm		= mod:NewSpellAnnounce(68335, 3)
local specWarnSlimePool		= mod:NewSpecialWarningMove(67640)
local specWarnToxin			= mod:NewSpecialWarningMove(67620)
local specWarnBile			= mod:NewSpecialWarningYou(66869)
local timerSubmergeCD		= mod:NewTimer(45, "TimerSubmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp") -- 45-50 sec.
local timerEmerge			= mod:NewTimer(8.5, "TimerEmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local timerSweepCD			= mod:NewCDTimer(15, 66794, nil, mod:IsMelee()) -- 15-30 sec. CD
local timerSlimePoolCD		= mod:NewCDTimer(30, 66883, nil, mod:IsMelee()) -- first after 15 sec., 30 sec. CD
local timerAcidicSpewCD		= mod:NewCDTimer(15, 66819) -- 15-30 sec. CD 
local timerMoltenSpewCD		= mod:NewCDTimer(15, 66820) -- 15-30 sec. CD
local timerParalyticSpray	= mod:NewNextTimer(20, 66901) -- 20 sec. after pull, 20 sec. every next 
local timerBurningSpray		= mod:NewNextTimer(20, 66902) -- 15 sec. after pull, 20 sec. every next 
local timerParalyticBite	= mod:NewNextTimer(20, 66824, nil, mod:IsTank()) -- 20 sec. after pull, 20 sec. every next  
local timerBurningBite		= mod:NewNextTimer(20, 66879, nil, mod:IsTank()) -- 15 sec. after pull, 20 sec. every next 
-- Icehowl
local warnBreath			= mod:NewSpellAnnounce(67650, 2)
local warnRage				= mod:NewSpellAnnounce(67657, 3)
local specWarnCharge		= mod:NewSpecialWarning("SpecialWarningCharge")
local specWarnChargeNear	= mod:NewSpecialWarning("SpecialWarningChargeNear")
local specWarnTranq			= mod:NewSpecialWarning("SpecialWarningTranq", mod:CanRemoveEnrage())
local enrageTimer			= mod:NewBerserkTimer(150)
local timerBreath			= mod:NewCastTimer(5, 67650)
local timerStaggeredDaze	= mod:NewBuffActiveTimer(15, 66758)
local timerNextCrashCD		= mod:NewCDTimer(30, 67662) -- 30 sec. after pull, 30-50 sec. every next
local timerArcticBreathCD	= mod:NewCDTimer(20, 66689) -- 14 sec. after pull, 20-30 sec. every next
local timerWhirlCD			= mod:NewCDTimer(20, 67665) -- 10-12 sec. after pull, 15-20 sec. every next


local timerCombatStart		= mod:NewTimer(11, "TimerCombatStart", 2457)
local timerNextBoss			= mod:NewTimer(178, "TimerNextBoss", 2457)

mod:AddBoolOption("PingCharge")
mod:AddBoolOption("SetIconOnChargeTarget", true)
mod:AddBoolOption("SetIconOnBileTarget", true)
mod:AddBoolOption("ClearIconsOnIceHowl", true)
mod:AddBoolOption("RangeFrame")
mod:AddBoolOption("IcehowlArrow")
mod:AddBoolOption("YellOnCharge", true, "announce")
mod:AddBoolOption("PlaySoundBloopers", true)

local bileTargets			= {}
local toxinTargets			= {}
local burnIcon				= 8
local phases				= {}
local DreadscaleActive		= true  	-- Is dreadscale moving?
local DreadscaleDead	= false
local AcidmawDead	= false
local messageCounter = 0
local randomNumber = 1

local function updateHealthFrame(phase)
	if phases[phase] then
		return
	end
	phases[phase] = true
	if phase == 1 then
		DBM.BossHealth:Clear()
		DBM.BossHealth:AddBoss(34796, L.Gormok)
	elseif phase == 2 then
		DBM.BossHealth:AddBoss(35144, L.Acidmaw)
		DBM.BossHealth:AddBoss(34799, L.Dreadscale)
	elseif phase == 3 then
		DBM.BossHealth:AddBoss(34797, L.Icehowl)
	end
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 34797, "Beasts of Northrend")
	table.wipe(bileTargets)
	table.wipe(toxinTargets)
	table.wipe(phases)
	messageCounter = 0	-- help variable to register Submerge and Emerge
	burnIcon = 8
	DreadscaleActive = true
	DreadscaleDead = false
	AcidmawDead = false
	timerCombatStart:Start(-delay)
	mod:ScheduleMethod(11, "GromokStartTimers")
	updateHealthFrame(1)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 34797, "Beasts of Northrend", wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:warnToxin()
	warnToxin:Show(table.concat(toxinTargets, "<, >"))
	table.wipe(toxinTargets)
end

function mod:warnBile()
	warnBile:Show(table.concat(bileTargets, "<, >"))
	table.wipe(bileTargets)
	burnIcon = 8
end

function mod:GromokStartTimers()
	if self:IsDifficulty("heroic10", "heroic25") then
		timerNextBoss:Start(165)
	end
	timerNextStompCD:Start(15) --5
	timerRisingAngerCD:Start(16) --6
end

function mod:WormsEmerge()
	timerSubmergeCD:Show()
	if not AcidmawDead then		
		if DreadscaleActive then	-- Dreadscale active & Acidmaw stationary
			timerSweepCD:Start(15)
			timerParalyticSpray:Start(20)			
		else 						-- Dreadscale stationary & Acidmaw active
			timerParalyticBite:Start(20)			
			timerAcidicSpewCD:Start(15)
		end
	end
	if not DreadscaleDead then
		if DreadscaleActive then	-- Dreadscale active & Acidmaw stationary
			timerMoltenSpewCD:Start(15)
			timerBurningBite:Start(15)
		else 						-- Dreadscale stationary & Acidmaw active
			timerSweepCD:Start(15)
			timerBurningSpray:Start(15)
		end
	end	
end

function mod:WormsSubmerge()
	timerEmerge:Show()
	timerSweepCD:Cancel()
	timerSlimePoolCD:Cancel()
	timerMoltenSpewCD:Cancel()
	timerParalyticSpray:Cancel()
	timerBurningBite:Cancel()
	timerAcidicSpewCD:Cancel()
	timerBurningSpray:Cancel()
	timerParalyticBite:Cancel()
	DreadscaleActive = not DreadscaleActive
end

function mod:IcehowlStartTimers()
	timerNextCrashCD:Start(30)
	timerArcticBreathCD:Start(14)
	timerWhirlCD:Start(10)
	if self:IsDifficulty("heroic10", "heroic25") then
		enrageTimer:Start()
	end	
end

function mod:SPELL_AURA_APPLIED(args)
	-- Gormok the Impaler
	if args:IsSpellID(67477, 66331, 67478, 67479) then		-- Impale
		timerNextImpale:Start()
		warnImpaleOn:Show(args.destName)
	elseif args:IsSpellID(66636) then						-- Rising Anger
		WarningSnobold:Show()
		timerRisingAngerCD:Show()
	elseif args:IsSpellID(65935) then						-- Disarm
 		timerDisarm:Start()
 	elseif args:IsSpellID(51722) then						-- Dismantle			
		timerDismantle:Start()
	-- Acidmaw & Dreadscale
	elseif args:IsSpellID(68335) then						-- Worm Enrage
		warnEnrageWorm:Show()
	elseif args:IsSpellID(66823, 67618, 67619, 67620) then	-- Paralytic Toxin
		self:UnscheduleMethod("warnToxin")
		toxinTargets[#toxinTargets + 1] = args.destName
		if args:IsPlayer() then
			specWarnToxin:Show()
		end
		mod:ScheduleMethod(0.2, "warnToxin")
	elseif args:IsSpellID(66869) then						-- Burning Bile
		self:UnscheduleMethod("warnBile")
		bileTargets[#bileTargets + 1] = args.destName
		if args:IsPlayer() then
			specWarnBile:Show()
		end
		if self.Options.SetIconOnBileTarget and burnIcon > 0 then
			self:SetIcon(args.destName, burnIcon, 15)
			burnIcon = burnIcon - 1
		end
		mod:ScheduleMethod(0.2, "warnBile")
	-- Icehowl
	elseif args:IsSpellID(67657, 66759, 67658, 67659) then	-- Frothing Rage
		warnRage:Show()
		timerWhirlCD:Start(2)--todo
		timerArcticBreathCD:Start(5) --todo
		timerNextCrashCD:Start(30) --todo
		if not self:IsDifficulty("heroic10", "heroic25") then
			specWarnTranq:Show()
		end
		if self.Options.PlaySoundBloopers then
			randomNumber = math.random(1,2)
			if randomNumber == 1 then
				PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\kur.mp3", "Master")
			else
				PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\fail.mp3", "Master")
			end
		end
	elseif args:IsSpellID(66758) then						-- Staggered Daze
		if self.Options.PlaySoundBloopers then
			randomNumber =  math.random(1,2)
			if randomNumber == 1 then
				PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\nap.mp3", "Master")
			else
				PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\nap2.mp3", "Master")
			end
		end
		timerStaggeredDaze:Start()
		timerWhirlCD:Start(17)--todo 17
		timerArcticBreathCD:Start(20) --todo  20
		timerNextCrashCD:Start(45) --todo 45
	elseif args:IsSpellID(66689, 67650, 67651, 67652) then	-- Arctic Breath
		timerArcticBreathCD:Start()
		timerBreath:Start()
		warnBreath:Show()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(67477, 66331, 67478, 67479) then		-- Impale
		timerNextImpale:Start()
		warnImpaleOn:Show(args.destName)
		if (args.amount >= 3 and not self:IsDifficulty("heroic10", "heroic25") ) or ( args.amount >= 2 and self:IsDifficulty("heroic10", "heroic25") ) then 
			if args:IsPlayer() then
				specWarnImpale3:Show(args.amount)
			end
		end
	elseif args:IsSpellID(66636) then						-- Rising Anger
		WarningSnobold:Show()
		if args.amount <= 3 then
			timerRisingAngerCD:Show()
		elseif args.amount >= 3 then
			specWarnAnger3:Show(args.amount)
		end
	end
end

function mod:SPELL_CAST_START(args)
	-- Gormok the Impaler
	if args:IsSpellID(66313) then							-- Fire Bomb (Impaler)
		warnFireBomb:Show()
	elseif args:IsSpellID(66330, 67647, 67648, 67649) then	-- Staggering Stomp
		timerNextStompCD:Start()
	-- Acidmaw & Dreadscale
	elseif args:IsSpellID(66794, 67644, 67645, 67646) then	-- Sweep stationary worm
		timerSweepCD:Start()
	elseif args:IsSpellID(66821) then						-- Molten spew
		timerMoltenSpewCD:Start()
	elseif args:IsSpellID(66818) then						-- Acidic Spew
		timerAcidicSpewCD:Start()
	elseif args:IsSpellID(66901, 67615, 67616, 67617) then	-- Paralytic Spray
		timerParalyticSpray:Start()
	elseif args:IsSpellID(66902, 67627, 67628, 67629) then	-- Burning Spray
		timerBurningSpray:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	-- Acidmaw & Dreadscale
	if args:IsSpellID(67641, 66883, 67642, 67643) then		-- Slime Pool Cloud Spawn
		warnSlimePool:Show()
		timerSlimePoolCD:Show()
	elseif args:IsSpellID(66824, 67612, 67613, 67614) then	-- Paralytic Bite
		timerParalyticBite:Start()
	elseif args:IsSpellID(66879, 67624, 67625, 67626) then	-- Burning Bite
		timerBurningBite:Start()
	-- Icehowl
	elseif args:IsSpellID(67664, 67345, 67663, 67665) then	-- Whirl
		timerWhirlCD:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsPlayer() and (args:IsSpellID(66320, 67472, 67473, 67475) or args:IsSpellID(66317)) then	-- Fire Bomb (66317 is impact damage, not avoidable but leaving in because it still means earliest possible warning to move. Other 4 are tick damage from standing in it)
		specWarnFireBomb:Show()
	elseif args:IsPlayer() and args:IsSpellID(66881, 67638, 67639, 67640) then							-- Slime Pool
		specWarnSlimePool:Show()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg:match(L.Charge) or msg:find(L.Charge) then
		timerNextCrashCD:Start()
		if self.Options.ClearIconsOnIceHowl then
			self:ClearIcons()
		end
		if target == UnitName("player") then
			specWarnCharge:Show(target)
			if self.Options.YellOnCharge then
				SendChatMessage(L.YellCharge, "SAY")
			end
			if self.Options.PingCharge then
				Minimap:PingLocation()
			end
		else
			local uId = DBM:GetRaidUnitId(target)
			if uId then
				local inRange = CheckInteractDistance(uId, 2)
				local x, y = GetPlayerMapPosition(uId)
				if x == 0 and y == 0 then
					SetMapToCurrentZone()
					x, y = GetPlayerMapPosition(uId)
				end
				if inRange then
					specWarnChargeNear:Show()
					if self.Options.IcehowlArrow then
						DBM.Arrow:ShowRunAway(x, y, 12, 5)
					end
				end
			end
		end
		if self.Options.SetIconOnChargeTarget then
			self:SetIcon(target, 8, 5)
		end
	elseif msg:match(L.Submerge) or msg:find(L.Submerge) then
		messageCounter = messageCounter + 1
		if messageCounter == 2 then
			self:ScheduleMethod(0.1, "WormsSubmerge")
			messageCounter = 0
		end
	elseif msg:match(L.Emerge) or msg:find(L.Emerge) then
		messageCounter = messageCounter + 1
		if messageCounter == 2 then
		self:ScheduleMethod(0.1, "WormsEmerge")
			messageCounter = 0
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Phase2 or msg:find(L.Phase2) then -- Acidmaw & Dreadscale
		timerCombatStart:Show(15)
		if self:IsDifficulty("heroic10", "heroic25") then
			--local timeLeftFromP1 = 154 - timerNextBoss:GetTime()
			timerNextBoss:Stop()
			--timerNextBoss:Start(174 + timeLeftFromP1)
			timerNextBoss:Start(178)
		end
		updateHealthFrame(2)
		self:ScheduleMethod(15, "WormsEmerge")
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(10)
		end
	elseif msg == L.Phase3 or msg:find(L.Phase3) then --Icehowl
		timerNextBoss:Cancel()
		timerSubmergeCD:Cancel()
		timerCombatStart:Show(13)
		mod:ScheduleMethod(13, "IcehowlStartTimers")
		updateHealthFrame(3)
		self:UnscheduleMethod("WormsSubmerge")
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 34796 then
		timerRisingAngerCD:Stop()
		timerNextStompCD:Stop()
		timerNextImpale:Stop()
		DBM.BossHealth:RemoveBoss(cid) 		-- remove Gormok from the health frame
	elseif cid == 35144 then
		AcidmawDead = true
		timerSubmergeCD:Stop()
		timerParalyticSpray:Cancel()
		timerParalyticBite:Cancel()
		timerAcidicSpewCD:Cancel()
		if DreadscaleActive then
			timerSweepCD:Cancel()
		else
			timerSlimePoolCD:Cancel()
		end
		if DreadscaleDead then
			DBM.BossHealth:RemoveBoss(35144) -- remove Acidmaw from the health frame
			DBM.BossHealth:RemoveBoss(34799) -- remove Dreadscale from the health frame
		end
	elseif cid == 34799 then
		DreadscaleDead = true
		timerSubmergeCD:Stop()
		timerBurningSpray:Cancel()
		timerBurningBite:Cancel()
		timerMoltenSpewCD:Cancel()
		if DreadscaleActive then
			timerSlimePoolCD:Cancel()
		else
			timerSweepCD:Cancel()
		end
		if AcidmawDead then
			DBM.BossHealth:RemoveBoss(35144) -- remove Acidmaw from the health frame
			DBM.BossHealth:RemoveBoss(34799) -- remove Dreadscale from the health frame
		end
	end
end
