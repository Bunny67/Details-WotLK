-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local _detalhes = 		_G._detalhes
local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
local _tempo = time()
local _
local DetailsFramework = DetailsFramework
local UnitGroupRolesAssigned = DetailsFramework.UnitGroupRolesAssigned

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

local _UnitAffectingCombat = UnitAffectingCombat --wow api local
local _UnitHealth = UnitHealth --wow api local
local _UnitHealthMax = UnitHealthMax --wow api local
local _UnitIsFeignDeath = UnitIsFeignDeath --wow api local
local _UnitGUID = UnitGUID --wow api local
local _GetUnitName = GetUnitName --wow api local
local _GetInstanceInfo = GetInstanceInfo --wow api local
local _GetCurrentMapAreaID = GetCurrentMapAreaID --wow api local
local _IsInRaid = IsInRaid --wow api local
local _IsInGroup = IsInGroup --wow api local
local _GetNumGroupMembers = GetNumGroupMembers --wow api local
local _GetTime = GetTime
local _UnitBuff = UnitBuff

local _cstr = string.format --lua local
local _str_sub = string.sub --lua local
local _table_insert = table.insert --lua local
local _select = select --lua local
local _bit_band = bit.band --lua local
local _math_floor = math.floor --lua local
local _table_remove = table.remove --lua local
local _ipairs = ipairs --lua local
local _pairs = pairs --lua local
local _table_sort = table.sort --lua local
local _type = type --lua local
local _math_ceil = math.ceil --lua local
local _table_wipe = table.wipe --lua local
local _strsplit = strsplit
local _tonumber = tonumber

local _GetSpellInfo = _detalhes.getspellinfo --details api
local escudo = _detalhes.escudos --details local
local parser = _detalhes.parser --details local
local absorb_spell_list = _detalhes.AbsorbSpells --details local
local fire_ward_absorb_list = _detalhes.MageFireWardSpells
local frost_ward_absorb_list = _detalhes.MageFrostWardSpells
local shadow_ward_absorb_list = _detalhes.WarlockShadowWardSpells
local ice_barrier_absorb_list = _detalhes.MageIceBarrierSpells
local sacrifice_absorb_list = _detalhes.WarlockSacrificeSpells

local cc_spell_list = DetailsFramework.CrowdControlSpells

local container_combatentes = _detalhes.container_combatentes --details local
local container_habilidades = _detalhes.container_habilidades --details local

--> localize the cooldown table from the framework
local defensive_cooldowns = DetailsFramework.CooldownsAllDeffensive

local spell_damage_func = _detalhes.habilidade_dano.Add --details local
local spell_damageMiss_func = _detalhes.habilidade_dano.AddMiss --details local
local spell_damageFF_func = _detalhes.habilidade_dano.AddFF --details local

local spell_heal_func = _detalhes.habilidade_cura.Add --details local
local spell_energy_func = _detalhes.habilidade_e_energy.Add --details local
local spell_misc_func = _detalhes.habilidade_misc.Add --details local

--> current combat and overall pointers
local _current_combat = _detalhes.tabela_vigente or {} --> placeholder table
local _current_combat_cleu_events = {n = 1} --> placeholder

--> total container pointers
local _current_total = _current_combat.totals
local _current_gtotal = _current_combat.totals_grupo
--> actors container pointers
local _current_damage_container = _current_combat[1]
local _current_heal_container = _current_combat[2]
local _current_energy_container = _current_combat[3]
local _current_misc_container = _current_combat[4]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> cache

--> damage
local damage_cache = setmetatable({}, _detalhes.weaktable)
local damage_cache_pets = setmetatable({}, _detalhes.weaktable)
local damage_cache_petsOwners = setmetatable({}, _detalhes.weaktable)
--> heaing
local healing_cache = setmetatable({}, _detalhes.weaktable)
--> energy
local energy_cache = setmetatable({}, _detalhes.weaktable)
--> misc
local misc_cache = setmetatable({}, _detalhes.weaktable)
local misc_cache_pets = setmetatable({}, _detalhes.weaktable)
local misc_cache_petsOwners = setmetatable({}, _detalhes.weaktable)
--> party & raid members
local raid_members_cache = setmetatable({}, _detalhes.weaktable)
--> bitfield swap cache
local bitfield_swap_cache = {}
--> damage and heal last events
local last_events_cache = {} --> initialize table(placeholder)
--> npcId cache
local npcid_cache = {}
--> pets
local container_pets = {} --> initialize table(placeholder)
--> ignore deaths
local ignore_death = {}
--> temp ignored
local ignore_actors = {}
--> spell reflection
local reflection_damage = {} --self-inflicted damage
local reflection_debuffs = {} --self-inflicted debuffs
local reflection_events = {} --spell_missed reflected events
local reflection_auras = {} --active reflecting auras
local reflection_dispels = {} --active reflecting dispels
local reflection_spellid = {
	--> we can track which spell caused the reflection
	--> this is used to credit this aura as the one doing the damage
	[23920] = true, --warrior spell reflection
}
local reflection_dispelid = {
	--> some dispels also reflect, and we can track them
}
local reflection_ignore = {
	--> common self-harm spells that we know weren't reflected
	--> this list can be expanded
}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

local container_damage_target = _detalhes.container_type.CONTAINER_DAMAGETARGET_CLASS
local container_misc = _detalhes.container_type.CONTAINER_MISC_CLASS
local duel_candidates = _detalhes.duel_candidates

local _token_ids = _detalhes.TokenID

local OBJECT_TYPE_ENEMY		= 0x00000040
local OBJECT_TYPE_PLAYER	= 0x00000400
local OBJECT_TYPE_PETS		= 0x00003000
local OBJECT_TYPE_GUARDIAN	= 0x00002000
local OBJECT_CONTROL_NPC	= 0x00000200
local AFFILIATION_GROUP		= 0x00000007
local REACTION_FRIENDLY		= 0x00000010
local REACTION_MINE			= 0x00000001

local ENVIRONMENTAL_FALLING_NAME	= Loc["STRING_ENVIRONMENTAL_FALLING"]
local ENVIRONMENTAL_DROWNING_NAME	= Loc["STRING_ENVIRONMENTAL_DROWNING"]
local ENVIRONMENTAL_FATIGUE_NAME	= Loc["STRING_ENVIRONMENTAL_FATIGUE"]
local ENVIRONMENTAL_FIRE_NAME		= Loc["STRING_ENVIRONMENTAL_FIRE"]
local ENVIRONMENTAL_LAVA_NAME		= Loc["STRING_ENVIRONMENTAL_LAVA"]
local ENVIRONMENTAL_SLIME_NAME		= Loc["STRING_ENVIRONMENTAL_SLIME"]

local RAID_TARGET_FLAGS = {
	[128] = true, --0x80 skull
	[64] = true, --0x40 cross
	[32] = true, --0x20 square
	[16] = true, --0x10 moon
	[8] = true, --0x8 triangle
	[4] = true, --0x4 diamond
	[2] = true, --0x2 circle
	[1] = true, --0x1 star
}

--> spellIds override
local override_spellId = {
	[27576] = 5374, --rogue mutilate

	[32175] = 17364, -- shaman Stormstrike(from Turkar on github)
	[32176] = 17364, -- shaman Stormstrike
}

local bitfield_debuffs_ids = _detalhes.BitfieldSwapDebuffsIDs
local bitfield_debuffs = {}
for _, spellid in ipairs(bitfield_debuffs_ids) do
	local spellname = GetSpellInfo(spellid)
	if spellname then
		bitfield_debuffs[spellname] = true
	else
		bitfield_debuffs[spellid] = true
	end
end

--expose the override spells table to external scripts
_detalhes.OverridedSpellIds = override_spellId

--> list of ignored npcs by the user
local ignored_npcids = {}

--> spells with special treatment
local special_damage_spells = {}

--> damage spells to ignore
local damage_spells_to_ignore = {}

--> expose the ignore spells table to external scripts
_detalhes.SpellsToIgnore = damage_spells_to_ignore

--> is parser allowed to replace spellIDs?
local is_using_spellId_override = false

--> recording data options flags
local _recording_self_buffs = false
local _recording_ability_with_buffs = false
local _recording_healing = false
local _recording_buffs_and_debuffs = false

--> in combat flag
local _in_combat = false
local _current_encounter_id
local _is_storing_cleu = false
local _in_resting_zone = false

--> deathlog
local _death_event_amt = 16

--> map type
local _is_in_instance = false

--> hooks
local _hook_cooldowns = false
local _hook_deaths = false
local _hook_battleress = false
local _hook_interrupt = false

local _hook_cooldowns_container = _detalhes.hooks["HOOK_COOLDOWN"]
local _hook_deaths_container = _detalhes.hooks["HOOK_DEATH"]
local _hook_battleress_container = _detalhes.hooks["HOOK_BATTLERESS"]
local _hook_interrupt_container = _detalhes.hooks["HOOK_INTERRUPT"]

local sub_pet_ids = {
	[15352] = true, -- earth elemental
	[15438] = true, -- fire elemental
}

local spell_create_is_summon = {
	[34600] = true, -- snake trap
}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions

-----------------------------------------------------------------------------------------------------------------------------------------
	--> DAMAGE 	serach key: ~damage											|
-----------------------------------------------------------------------------------------------------------------------------------------

function parser:swing(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing)
	return parser:spell_dmg(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, 1, "Corpo-a-Corpo", 00000001, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing) --> localize-me
end

function parser:range(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing)
	return parser:spell_dmg(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing) --> localize-me
end

--	/run local f=CreateFrame("Frame");f:RegisterAllEvents();f:SetScript("OnEvent", function(self, ...)print(...);end)
--	/run local f=CreateFrame("Frame");f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");f:SetScript("OnEvent", function(self, ...) print(...) end)
--	/run local f=CreateFrame("Frame");f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");f:SetScript("OnE

--	/run local f=CreateFrame("Frame");f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");f:SetScript("OnEvent", function(self, ...)print(...);end)
--	/run local f=CreateFrame("Frame");f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");f:SetScript("OnEvent",function(self, ...) local a = select(6, ...);if(a=="<chr name>")then print(...) end end)
--	/run local f=CreateFrame("Frame");f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");f:SetScript("OnEvent",function(self, ...) local a = select(3, ...);print(a);if(a=="SPELL_CAST_SUCCESS")then print(...) end end)

local who_aggro = function(self)
	if (_detalhes.LastPullMsg or 0) + 30 > time() then
		_detalhes.WhoAggroTimer = nil
		return
	end

	_detalhes.LastPullMsg = time()

	local hitLine = self.HitBy or "|cFFFFBB00First Hit|r: *?*"
	local targetLine = ""

	for i = 1, 4 do
		local boss = UnitExists("boss"..i)
		if boss then
			local target = UnitName("boss"..i.."target")
			if target and type(target) == "string" then
				targetLine = " |cFFFFBB00Boss First Target|r: "..target
				break
			end
		end
	end

	_detalhes:Msg(hitLine..targetLine)
	_detalhes.WhoAggroTimer = nil
end

local lastRecordFound = {id = 0, diff = 0, combatTime = 0}

_detalhes.PrintEncounterRecord = function(self)
	--> this block won't execute if the storage isn't loaded
	--> self is a timer reference from C_Timer

	local encounterID = self.Boss
	local diff = self.Diff

	local value, rank, combatTime = 0, 0, 0

	if encounterID == lastRecordFound.id and diff == lastRecordFound.diff then
		--> is the same encounter, no need to find the value again.
		value, rank, combatTime = lastRecordFound.value, lastRecordFound.rank, lastRecordFound.combatTime
	else
		local db = _detalhes.GetStorage()

		local role = UnitGroupRolesAssigned("player")
		local isDamage = (role == "DAMAGER" or role == "NONE") or (role == "TANK") --or true
		local bestRank, encounterTable = _detalhes.storage:GetBestFromPlayer(diff, encounterID, isDamage and "damage" or "healing", _detalhes.playername, true)

		if bestRank then
			local playerTable, onEncounter, rankPosition = _detalhes.storage:GetPlayerGuildRank(diff, encounterID, isDamage and "damage" or "healing", _detalhes.playername, true)

			value = bestRank[1] or 0
			rank = rankPosition or 0
			combatTime = encounterTable.elapsed

			--> if found the result, cache the values so no need to search again next pull
			lastRecordFound.value = value
			lastRecordFound.rank = rank
			lastRecordFound.id = encounterID
			lastRecordFound.diff = diff
			lastRecordFound.combatTime = combatTime
		else
			--> if didn't found, no reason to search again on next pull
			lastRecordFound.value = 0
			lastRecordFound.rank = 0
			lastRecordFound.combatTime = 0
			lastRecordFound.id = encounterID
			lastRecordFound.diff = diff
		end
	end

	_detalhes:Msg("|cFFFFBB00Your Best Score|r:", _detalhes:ToK2((value) / combatTime) .. "[|cFFFFFF00Guild Rank: " .. rank .. "|r]") --> localize-me

	if (not combatTime or combatTime == 0) and not _detalhes.SyncWarning then
		_detalhes:Msg("|cFFFF3300you may need sync the rank within the guild, type '|cFFFFFF00/details rank|r'|r") --> localize-me
		_detalhes.SyncWarning = true
	end
end

--[=[
[1]="Blood Shield",
[2]=538744,
[3]=0,
[5]=0,
[6]=0,
[7]="nameplate12",
[8]=false,
[9]=false,
[10]=263217,
[11]=false,
[12]=false,
[13]=false,
[14]=false,
[15]=1
--]=]

local function check_boss(npcID)
	if not _is_in_instance or (_current_encounter_id or not npcID) then
		return
	end

	local mapID = _detalhes.zone_id
	local bossIDs = _detalhes:GetBossIds(mapID)
	if not bossIDs then
		for id, data in _pairs(_detalhes.EncounterInformation) do
			if data.name == _detalhes.zone_name then
				bossIDs = _detalhes:GetBossIds(id)
				mapID = id
				break
			end
		end
		if not bossIDs then
			return
		end
	end

	local bossIndex = bossIDs[npcID]
	if bossIndex then
		local _, _, _, _, maxPlayers = GetInstanceInfo()
		local difficulty = GetInstanceDifficulty()
		_detalhes.parser_functions:ENCOUNTER_START(_detalhes:GetBossEncounter(mapID, bossIndex), _detalhes:GetBossName(mapID, bossIndex), difficulty, maxPlayers)
	end
end

function parser:spell_dmg(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing)
------------------------------------------------------------------------------------------------
--> early checks and fixes
	if who_serial == "" then
		if who_flags and _bit_band(who_flags, OBJECT_TYPE_PETS) ~= 0 then --> � um pet
			--> pets must have a serial
			return
		end
		--who_serial = nil
	end

	if not alvo_name then
		--> no target name, just quit
		return
	elseif not who_name then
		--> no actor name, use spell name instead
		who_name = "[*] "..spellname
		who_flags = 0xa48
		who_serial = ""
	end

	--> check if the spell isn't in the backlist
	if damage_spells_to_ignore[spellid] then
		return
	end

	--check if the target actor isn't in the temp blacklist
--	if ignore_actors[alvo_serial] then
--		return
--	end

	------------------------------------------------------------------------------------------------
	--> spell reflection
	if who_serial == alvo_serial and not reflection_ignore[spellid] then
		--> this spell could've been reflected, check it
		if reflection_events[who_serial] and reflection_events[who_serial][spellid] and time - reflection_events[who_serial][spellid].time > 3.5 and (not reflection_debuffs[who_serial] or (reflection_debuffs[who_serial] and not reflection_debuffs[who_serial][spellid])) then
			--> here we check if we have to filter old reflection data
			--> we check for two conditions
			--> the first is to see if this is an old reflection
			--> if more than 3.5 seconds have past then we can say that it is old... but!
			--> the second condition is to see if there is an active debuff with the same spellid
			--> if there is one then we ignore the timer and skip this
			--> this should be cleared afterwards somehow... don't know how...
			reflection_events[who_serial][spellid] = nil
			if next(reflection_events[who_serial]) == nil then
				--> there should be some better way of handling this kind of filtering, any suggestion?
				reflection_events[who_serial] = nil
			end
		end

		local reflection = reflection_events[who_serial] and reflection_events[who_serial][spellid]
		if reflection then
			--> if we still have the reflection data then we conclude it was reflected
			reflection_events[who_serial][spellid].time = time
			--> extend the duration of the timer to catch the rare channelling spells

			who_serial = reflection.who_serial
			who_name = reflection.who_name
			who_flags = reflection.who_flags
			-- crediting the source of the reflection aura

			spellid = reflection.spellid
			spellname = reflection.spellname
			spelltype = reflection.spelltype
			--> data of the aura that caused the reflection

			return parser:spell_dmg(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, -1, nil, nil, nil, nil, false, false, false)
		else
			--> saving information about this damage because it may occurred before a reflect event
			reflection_damage[who_serial] = reflection_damage[who_serial] or {}
			reflection_damage[who_serial][spellid] = {
				amount = amount,
				time = time,
			}
		end
	end

	--> if the parser are allowed to replace spellIDs
	if is_using_spellId_override then
		spellid = override_spellId[spellid] or spellid
	end

	--> npcId check for ignored npcs
	if _bit_band(alvo_flags, OBJECT_CONTROL_NPC) ~= 0 then
		local npcId = npcid_cache[alvo_serial]
		if not npcId then
			npcId = _tonumber(_str_sub(alvo_serial, 8, 12), 16) or 0
			npcid_cache[alvo_serial] = npcId
		end

		check_boss(npcId)

		if ignored_npcids[npcId] then
			return
		end
	end

	if _bit_band(who_flags, OBJECT_CONTROL_NPC) ~= 0 then
		local npcId = npcid_cache[who_serial]
		if not npcId then
			npcId = _tonumber(_str_sub(who_serial, 8, 12), 16) or 0
			npcid_cache[who_serial] = npcId
		end

		check_boss(npcId)

		if ignored_npcids[npcId] then
			return
		end
	end

	if absorbed and absorbed > 0 and alvo_name and escudo[alvo_name] and who_name then
		parser:heal_absorb(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, absorbed, spelltype)
	end

------------------------------------------------------------------------------------------------
--> check if need start an combat
	if not _in_combat then
		if not (_bit_band(who_flags, REACTION_FRIENDLY) ~= 0 and _bit_band(alvo_flags, REACTION_FRIENDLY) ~= 0) and (_bit_band(who_flags, AFFILIATION_GROUP) ~= 0 or _bit_band(who_flags, AFFILIATION_GROUP) ~= 0) then
			_detalhes:EntrarEmCombate(who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags)
			if _detalhes.encounter_table.id and _detalhes.encounter_table["start"] and _detalhes.announce_firsthit.enabled then
				local link = spellid <= 10 and _GetSpellInfo(spellid) or GetSpellLink(spellid)
				if _detalhes.WhoAggroTimer then
					_detalhes.WhoAggroTimer:Cancel()
				end
				_detalhes.WhoAggroTimer = C_Timer.NewTicker(0.5, who_aggro, 1)
				_detalhes.WhoAggroTimer.HitBy = "|cFFFFFF00First Hit|r: "..(link or "").." from "..(who_name or UNKNOWN)
			end
		end
	end

	--[[statistics]]-- _detalhes.statistics.damage_calls = _detalhes.statistics.damage_calls + 1

	_current_damage_container.need_refresh = true

------------------------------------------------------------------------------------------------
--> get actors
	--> source damager
	local este_jogador, meu_dono = damage_cache[who_serial] or damage_cache_pets[who_serial] or damage_cache[who_name], damage_cache_petsOwners[who_serial]
	if not este_jogador then --> pode ser um desconhecido ou um pet
		este_jogador, meu_dono, who_name = _current_damage_container:PegarCombatente(who_serial, who_name, who_flags, true)

		if meu_dono then --> � um pet
			if who_serial ~= "" then
				damage_cache_pets[who_serial] = este_jogador
				damage_cache_petsOwners[who_serial] = meu_dono
			end

			--conferir se o dono j� esta no cache
			if not damage_cache[meu_dono.serial] and meu_dono.serial ~= "" then
				damage_cache[meu_dono.serial] = meu_dono
			end
		else
			if who_flags then --> ter certeza que n�o � um pet
				if who_serial ~= "" then
					damage_cache[who_serial] = este_jogador
				else
					if who_name:find("%[") then
						damage_cache[who_name] = este_jogador
						local _, _, icon = _GetSpellInfo(spellid or 1)
						este_jogador.spellicon = icon
						--print("no serial actor", spellname, who_name, "added to cache.")
					else
						--_detalhes:Msg("Unknown actor with unknown serial ", spellname, who_name)
					end
				end
			end
		end
	elseif meu_dono then
		--> � um pet
		who_name = who_name.." <"..meu_dono.nome..">"
	end

	--> his target
	local jogador_alvo, alvo_dono = damage_cache[alvo_serial] or damage_cache_pets[alvo_serial] or damage_cache[alvo_name], damage_cache_petsOwners[alvo_serial]
	if not jogador_alvo then
		jogador_alvo, alvo_dono, alvo_name = _current_damage_container:PegarCombatente(alvo_serial, alvo_name, alvo_flags, true)

		if alvo_dono then
			if alvo_serial ~= "" then
				damage_cache_pets[alvo_serial] = jogador_alvo
				damage_cache_petsOwners[alvo_serial] = alvo_dono
			end

			--conferir se o dono j� esta no cache
			if not damage_cache[alvo_dono.serial] and alvo_dono.serial ~= "" then
				damage_cache[alvo_dono.serial] = alvo_dono
			end
		else
			if alvo_flags and alvo_serial ~= "" then --> ter certeza que n�o � um pet
				damage_cache[alvo_serial] = jogador_alvo
			end
		end
	elseif alvo_dono then
		--> � um pet
		alvo_name = alvo_name.." <"..alvo_dono.nome..">"
	end

	--> last event
	este_jogador.last_event = _tempo

------------------------------------------------------------------------------------------------
--> group checks and avoidance

	if absorbed then
		amount = absorbed +(amount or 0)
	end

	if _is_in_instance then
		if overkill and overkill > 0 then
			--if enabled it'll cut the amount of overkill from the last hit(which killed the actor)
			--when disabled it'll show the total damage done for the latest hit
			--amount = amount - overkill
		end
	end

	if este_jogador.grupo and not este_jogador.arena_enemy and not este_jogador.enemy then --> source = friendly player and not an enemy player
		--dano to adversario estava caindo aqui por nao estar checando .enemy
		_current_gtotal[1] = _current_gtotal[1] + amount
	elseif jogador_alvo.grupo then --> source = arena enemy or friendly player
		--> record death log
		local t = last_events_cache[alvo_name]
		if not t then
			t = _current_combat:CreateLastEventsTable(alvo_name)
		end

		local i = t.n

		local this_event = t[i]

		if not this_event then
			return print("Parser Event Error -> Set to 16 DeathLogs and /reload", i, _death_event_amt)
		end

		this_event[1] = true --> true if this is a damage || false for healing
		this_event[2] = spellid --> spellid || false if this is a battle ress line
		this_event[3] = amount --> amount of damage or healing
		this_event[4] = time --> parser time
		this_event[5] = _UnitHealth(alvo_name) --> current unit heal
		this_event[6] = who_name --> source name
		this_event[7] = absorbed
		this_event[8] = spelltype or school
		this_event[9] = false
		this_event[10] = overkill

		i = i + 1

		if i == _death_event_amt + 1 then
			t.n = 1
		else
			t.n = i
		end
	end

------------------------------------------------------------------------------------------------
--> time start
	if not este_jogador.dps_started then
		este_jogador:Iniciar(true) --registra na timemachine

		if meu_dono and not meu_dono.dps_started then
			meu_dono:Iniciar(true)
			if meu_dono.end_time then
				meu_dono.end_time = nil
			else
				--meu_dono:IniciarTempo(_tempo)
				meu_dono.start_time = _tempo
			end
		end

		if este_jogador.end_time then
			este_jogador.end_time = nil
		else
			--este_jogador:IniciarTempo(_tempo)
			este_jogador.start_time = _tempo
		end

		if este_jogador.nome == _detalhes.playername and token ~= "SPELL_PERIODIC_DAMAGE" then --> iniciando o dps do "PLAYER"
			if _detalhes.solo then
				--> save solo attributes
				_detalhes:UpdateSolo()
			end

			if _UnitAffectingCombat("player") then
				_detalhes:SendEvent("COMBAT_PLAYER_TIMESTARTED", nil, _current_combat, este_jogador)
			end
		end
	end

	------------------------------------------------------------------------------------------------
	--> firendly fire ~friendlyfire
		local is_friendly_fire = false

		if(_is_in_instance) then
			if(bitfield_swap_cache[who_serial] or meu_dono and bitfield_swap_cache[meu_dono.serial]) then
				if(jogador_alvo.grupo or alvo_dono and alvo_dono.grupo) then
					is_friendly_fire = true
				end
			else
				if(bitfield_swap_cache[alvo_serial] or alvo_dono and bitfield_swap_cache[alvo_dono.serial]) then
				else
					if((jogador_alvo.grupo or alvo_dono and alvo_dono.grupo) and(este_jogador.grupo or meu_dono and meu_dono.grupo)) then
						is_friendly_fire = true
					end
				end
			end
		else
			if(
				(_bit_band(alvo_flags, REACTION_FRIENDLY) ~= 0 and _bit_band(who_flags, REACTION_FRIENDLY) ~= 0) or --ajdt d' brx
				(raid_members_cache[alvo_serial] and raid_members_cache[who_serial] and alvo_serial:find("Player") and who_serial:find("Player")) --amrl
			) then
				is_friendly_fire = true
			end
		end

		if(is_friendly_fire) then
			if(este_jogador.grupo) then --> se tiver ele n�o adiciona o evento l� em cima
				local t = last_events_cache[alvo_name]

				if(not t) then
					t = _current_combat:CreateLastEventsTable(alvo_name)
				end

				local i = t.n

				local this_event = t[i]

				this_event[1] = true --> true if this is a damage || false for healing
				this_event[2] = spellid --> spellid || false if this is a battle ress line
				this_event[3] = amount --> amount of damage or healing
				this_event[4] = time --> parser time
				this_event[5] = _UnitHealth(alvo_name) --> current unit heal
				this_event[6] = who_name --> source name
				this_event[7] = absorbed
				this_event[8] = spelltype or school
				this_event[9] = true
				this_event[10] = overkill
				i = i + 1

				if(i == _death_event_amt+1) then
					t.n = 1
				else
					t.n = i
				end
			end

			este_jogador.friendlyfire_total = este_jogador.friendlyfire_total + amount

			local friend = este_jogador.friendlyfire[alvo_name] or este_jogador:CreateFFTable(alvo_name)

			friend.total = friend.total + amount
			friend.spells[spellid] =(friend.spells[spellid] or 0) + amount

			------------------------------------------------------------------------------------------------
			--> damage taken

				--> target
				jogador_alvo.damage_taken = jogador_alvo.damage_taken + amount -(absorbed or 0) --> adiciona o dano tomado
				if(not jogador_alvo.damage_from[who_name]) then --> adiciona a pool de dano tomado de quem
					jogador_alvo.damage_from[who_name] = true
				end

			return true
		else
			_current_total[1] = _current_total[1]+amount

			------------------------------------------------------------------------------------------------
			--> damage taken

				--> target
				jogador_alvo.damage_taken = jogador_alvo.damage_taken + amount --> adiciona o dano tomado
				if(not jogador_alvo.damage_from[who_name]) then --> adiciona a pool de dano tomado de quem
					jogador_alvo.damage_from[who_name] = true
				end
		end

	------------------------------------------------------------------------------------------------
	--> amount add

		--> actor owner(if any)
		if(meu_dono) then --> se for dano de um Pet
			meu_dono.total = meu_dono.total + amount --> e adiciona o dano ao pet

			--> add owner targets
			meu_dono.targets[alvo_name] =(meu_dono.targets[alvo_name] or 0) + amount

			meu_dono.last_event = _tempo
		end

		--> actor
		este_jogador.total = este_jogador.total + amount

		--> actor without pets
		este_jogador.total_without_pet = este_jogador.total_without_pet + amount

		--> actor targets
		este_jogador.targets[alvo_name] =(este_jogador.targets[alvo_name] or 0) + amount

		--> actor spells table
		local spell = este_jogador.spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.spells:PegaHabilidade(spellid, true, token)
			spell.spellschool = spelltype or school
			if spellname and (_current_combat.is_boss and who_flags and _bit_band(who_flags, OBJECT_TYPE_ENEMY) ~= 0) then
				_detalhes.spell_school_cache[spellname] = spelltype or school
			end
		end

		if(_is_storing_cleu) then
			_current_combat_cleu_events[_current_combat_cleu_events.n] = {_tempo, _token_ids[token] or 0, who_name, alvo_name or "", spellid, amount}
			_current_combat_cleu_events.n = _current_combat_cleu_events.n + 1
		end

		return spell_damage_func(spell, alvo_serial, alvo_name, alvo_flags, amount, who_name, resisted, blocked, absorbed, critical, glacing, token)
	end

	--special rule for LOTM
	function parser:LOTM_damage(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing)

		if(absorbed) then
			amount = absorbed +(amount or 0)
		end

		local healingActor = healing_cache[who_serial]
		if(healingActor and healingActor.spells) then
			healingActor.total = healingActor.total -(amount or 0)

			local spellTable = healingActor.spells:GetSpell(183998)
			if(spellTable) then
				spellTable.anti_heal =(spellTable.anti_heal or 0) + amount
			end
		end

		local t = last_events_cache[who_name]

		if(not t) then
			t = _current_combat:CreateLastEventsTable(who_name)
		end

		local i = t.n

		local this_event = t[i]

		if(not this_event) then
			return print("Parser Event Error -> Set to 16 DeathLogs and /reload", i, _death_event_amt)
		end

		this_event[1] = true --> true if this is a damage || false for healing
		this_event[2] = spellid --> spellid || false if this is a battle ress line
		this_event[3] = amount --> amount of damage or healing
		this_event[4] = time --> parser time
		this_event[5] = _UnitHealth(who_name) --> current unit heal
		this_event[6] = who_name --> source name
		this_event[7] = absorbed
		this_event[8] = school
		this_event[9] = true --> friendly fire
		this_event[10] = overkill

		i = i + 1

		if(i == _death_event_amt+1) then
			t.n = 1
		else
			t.n = i
		end

		local damageActor = damage_cache[who_serial]
		if(damageActor) then
			--damage taken
			damageActor.damage_taken = damageActor.damage_taken + amount
			if(not damageActor.damage_from[who_name]) then --> adiciona a pool de dano tomado de quem
				damageActor.damage_from[who_name] = true
			end

			--friendly fire
			damageActor.friendlyfire_total = damageActor.friendlyfire_total + amount
			local friend = damageActor.friendlyfire[who_name] or damageActor:CreateFFTable(who_name)
			friend.total = friend.total + amount
			friend.spells[spellid] =(friend.spells[spellid] or 0) + amount
		end
	end

	--special rule of SLT
	function parser:SLT_damage(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing)

		--> damager
		local este_jogador, meu_dono = damage_cache[who_serial] or damage_cache_pets[who_serial] or damage_cache[who_name], damage_cache_petsOwners[who_serial]

		if(not este_jogador) then --> pode ser um desconhecido ou um pet

			este_jogador, meu_dono, who_name = _current_damage_container:PegarCombatente(who_serial, who_name, who_flags, true)

			if(meu_dono) then --> � um pet
				if(who_serial ~= "") then
					damage_cache_pets[who_serial] = este_jogador
					damage_cache_petsOwners[who_serial] = meu_dono
				end
				--conferir se o dono j� esta no cache
				if(not damage_cache[meu_dono.serial] and meu_dono.serial ~= "") then
					damage_cache[meu_dono.serial] = meu_dono
				end
			else
				if(who_flags) then --> ter certeza que n�o � um pet
					if(who_serial ~= "") then
						damage_cache[who_serial] = este_jogador
					else
						if(who_name:find("%[")) then
							damage_cache[who_name] = este_jogador
							local _, _, icon = _GetSpellInfo(spellid or 1)
							este_jogador.spellicon = icon
							--print("no serial actor", spellname, who_name, "added to cache.")
						else
							--_detalhes:Msg("Unknown actor with unknown serial ", spellname, who_name)
						end
					end
				end
			end

		elseif(meu_dono) then
			--> � um pet
			who_name = who_name .. " <" .. meu_dono.nome .. ">"
		end

		--> his target
		local jogador_alvo, alvo_dono = damage_cache[alvo_serial] or damage_cache_pets[alvo_serial] or damage_cache[alvo_name], damage_cache_petsOwners[alvo_serial]

		if(not jogador_alvo) then

			jogador_alvo, alvo_dono, alvo_name = _current_damage_container:PegarCombatente(alvo_serial, alvo_name, alvo_flags, true)

			if(alvo_dono) then
				if(alvo_serial ~= "") then
					damage_cache_pets[alvo_serial] = jogador_alvo
					damage_cache_petsOwners[alvo_serial] = alvo_dono
				end
				--conferir se o dono j� esta no cache
				if(not damage_cache[alvo_dono.serial] and alvo_dono.serial ~= "") then
					damage_cache[alvo_dono.serial] = alvo_dono
				end
			else
				if(alvo_flags and alvo_serial ~= "") then --> ter certeza que n�o � um pet
					damage_cache[alvo_serial] = jogador_alvo
				end
			end

		elseif(alvo_dono) then
			--> � um pet
			alvo_name = alvo_name .. " <" .. alvo_dono.nome .. ">"
		end

		--> last event
		este_jogador.last_event = _tempo

		--> record death log
		local t = last_events_cache[alvo_name]

		if(not t) then
			t = _current_combat:CreateLastEventsTable(alvo_name)
		end

		local i = t.n

		local this_event = t[i]

		if(not this_event) then
			return print("Parser Event Error -> Set to 16 DeathLogs and /reload", i, _death_event_amt)
		end

		this_event[1] = true --> true if this is a damage || false for healing
		this_event[2] = spellid --> spellid || false if this is a battle ress line
		this_event[3] = amount --> amount of damage or healing
		this_event[4] = time --> parser time
		this_event[5] = _UnitHealth(alvo_name) --> current unit heal
		this_event[6] = who_name --> source name
		this_event[7] = absorbed
		this_event[8] = spelltype or school
		this_event[9] = false
		this_event[10] = overkill

		i = i + 1

		if(i == _death_event_amt+1) then
			t.n = 1
		else
			t.n = i
		end

	end

	--function parser:swingmissed(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, missType, amountMissed)
	function parser:swingmissed(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, missType, amountMissed) --, amountMissed, arg1
		return parser:missed(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, 1, "Corpo-a-Corpo", 00000001, missType, amountMissed) --, amountMissed, arg1
	end

	function parser:rangemissed(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, missType, amountMissed) --, amountMissed, arg1
		return parser:missed(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, 2, "Tiro-Autom�tico", 00000001, missType, amountMissed) --, amountMissed, arg1
	end

	-- ~miss
	function parser:missed(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, missType, amountMissed, arg1, arg2, arg3)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if(not alvo_name) then
			--> no target name, just quit
			return

		elseif(not who_name) then
			--> no actor name, use spell name instead
			who_name = "[*] " .. spellname
			who_flags = 0xa48
			who_serial = ""
		end

	------------------------------------------------------------------------------------------------
	--> get actors
		--print("MISS", "|", missType, "|", "|", amountMissed, "|", arg1)


		--print(missType, who_name,  spellname, amountMissed)


		--> 'misser'
		local este_jogador = damage_cache[who_serial]
		if(not este_jogador) then
			--este_jogador, meu_dono, who_name = _current_damage_container:PegarCombatente(nil, who_name)
			local meu_dono
			este_jogador, meu_dono, who_name = _current_damage_container:PegarCombatente(who_serial, who_name, who_flags, true)
			if(not este_jogador) then
				return --> just return if actor doen't exist yet
			end
		end

		este_jogador.last_event = _tempo

		if missType == "ABSORB" and amountMissed and amountMissed > 0 and alvo_name and escudo[alvo_name] and who_name then
			parser:heal_absorb(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, amountMissed, spelltype)
		end

--[[
		if(tanks_members_cache[alvo_serial]) then --> only track tanks

			local TargetActor = damage_cache[alvo_serial]
			if(TargetActor) then

				local avoidance = TargetActor.avoidance

				if(not avoidance) then
					TargetActor.avoidance = _detalhes:CreateActorAvoidanceTable()
					avoidance = TargetActor.avoidance
				end

				local missTable = avoidance.overall[missType]

				if(missTable) then
					--> overall
					local overall = avoidance.overall
					overall[missType] = missTable + 1 --> adicionado a quantidade do miss

					--> from this mob
					local mob = avoidance[who_name]
					if(not mob) then --> if isn't in the table, build on the fly
						mob = _detalhes:CreateActorAvoidanceTable(true)
						avoidance[who_name] = mob
					end

					mob[missType] = mob[missType] + 1

					if(missType == "ABSORB") then --full absorb
						overall["ALL"] = overall["ALL"] + 1 --> qualtipo de hit ou absorb
						overall["FULL_ABSORBED"] = overall["FULL_ABSORBED"] + 1 --amount
						overall["ABSORB_AMT"] = overall["ABSORB_AMT"] +(amountMissed or 0)
						overall["FULL_ABSORB_AMT"] = overall["FULL_ABSORB_AMT"] +(amountMissed or 0)

						mob["ALL"] = mob["ALL"] + 1  --> qualtipo de hit ou absorb
						mob["FULL_ABSORBED"] = mob["FULL_ABSORBED"] + 1 --amount
						mob["ABSORB_AMT"] = mob["ABSORB_AMT"] +(amountMissed or 0)
						mob["FULL_ABSORB_AMT"] = mob["FULL_ABSORB_AMT"] +(amountMissed or 0)
					end

				end

			end
		end
]]

	------------------------------------------------------------------------------------------------
	--> amount add

		if(missType == "ABSORB") then

			if(token == "SWING_MISSED") then
				este_jogador.totalabsorbed = este_jogador.totalabsorbed + amountMissed
				return parser:swing("SWING_DAMAGE", time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, amountMissed, -1, 1, nil, nil, nil, false, false, false, false)

			elseif(token == "RANGE_MISSED") then
				este_jogador.totalabsorbed = este_jogador.totalabsorbed + amountMissed
				return parser:range("RANGE_DAMAGE", time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amountMissed, -1, 1, nil, nil, nil, false, false, false, false)

			else
				este_jogador.totalabsorbed = este_jogador.totalabsorbed + amountMissed
				return parser:spell_dmg(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amountMissed, -1, 1, nil, nil, nil, false, false, false, false)

			end
	------------------------------------------------------------------------------------------------
	--> spell reflection
		elseif missType == "REFLECT" and reflection_auras[alvo_serial] then
			--> a reflect event and we have the reflecting aura data
			if reflection_damage[who_serial] and reflection_damage[who_serial][spellid] and time - reflection_damage[who_serial][spellid].time > 3.5 and (not reflection_debuffs[who_serial] or (reflection_debuffs[who_serial] and not reflection_debuffs[who_serial][spellid])) then
				--> here we check if we have to filter old damage data
				--> we check for two conditions
				--> the first is to see if this is an old damage
				--> if more than 3.5 seconds have past then we can say that it is old... but!
				--> the second condition is to see if there is an active debuff with the same spellid
				--> if there is one then we ignore the timer and skip this
				--> this should be cleared afterwards somehow... don't know how...
				reflection_damage[who_serial][spellid] = nil
				if next(reflection_damage[who_serial]) == nil then
					--> there should be some better way of handling this kind of filtering, any suggestion?
					reflection_damage[who_serial] = nil
				end
			end
			local damage = reflection_damage[who_serial] and reflection_damage[who_serial][spellid]
			local reflection = reflection_auras[alvo_serial]
			if damage then
				--> damage ocurred first, so we have its data
				local amount = reflection_damage[who_serial][spellid].amount

				alvo_serial = reflection.who_serial
				alvo_name = reflection.who_name
				alvo_flags = reflection.who_flags
				spellid = reflection.spellid
				spellname = reflection.spellname
				spelltype = reflection.spelltype
				--> crediting the source of the aura that caused the reflection
				--> also saying that the damage came from the aura that reflected the spell

				reflection_damage[who_serial][spellid] = nil
				if next(reflection_damage[who_serial]) == nil then
					--> this is so bad at clearing, there should be a better way of handling this
					reflection_damage[who_serial] = nil
				end
				return parser:spell_dmg(token, time, alvo_serial, alvo_name, alvo_flags, who_serial, who_name, who_flags, spellid, spellname, spelltype, amount, -1, nil, nil, nil, nil, false, false, false)
			else
				--> saving information about this reflect because it occurred before the damage event
				reflection_events[who_serial] = reflection_events[who_serial] or {}
				reflection_events[who_serial][spellid] = reflection
				reflection_events[who_serial][spellid].time = time
			end
		else
			--colocando aqui apenas pois ele confere o override dentro do damage
			if(is_using_spellId_override) then
				spellid = override_spellId[spellid] or spellid
			end

			--> actor spells table
			local spell = este_jogador.spells._ActorTable[spellid]
			if(not spell) then
				spell = este_jogador.spells:PegaHabilidade(spellid, true, token)
				spell.spellschool = spelltype
				if(_current_combat.is_boss and who_flags and _bit_band(who_flags, OBJECT_TYPE_ENEMY) ~= 0) then
					_detalhes.spell_school_cache[spellname] = spelltype
				end
			end
			return spell_damageMiss_func(spell, alvo_serial, alvo_name, alvo_flags, who_name, missType)
		end


	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> SUMMON 	serach key: ~summon										|
-----------------------------------------------------------------------------------------------------------------------------------------
	function parser:summon(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellName)

		--[[statistics]]-- _detalhes.statistics.pets_summons = _detalhes.statistics.pets_summons + 1

		if(not _detalhes.capture_real["damage"] and not _detalhes.capture_real["heal"]) then
			return
		end

		-- only treat SPELL_CREATE like SPELL_SUMMON for snake trap.
		if (token == "SPELL_CREATE" and not spell_create_is_summon[spellid]) then
			return
		end

		if(not who_name) then
			who_name = "[*] " .. spellName
		end

		--> pet summon another pet
		local sou_pet = container_pets[who_serial]
		if(sou_pet) then --> okey, ja � um pet
			who_name, who_serial, who_flags = sou_pet[1], sou_pet[2], sou_pet[3]
		end

		local alvo_pet = container_pets[alvo_serial]
		if(alvo_pet) then
			who_name, who_serial, who_flags = alvo_pet[1], alvo_pet[2], alvo_pet[3]
		end

		--> pet summoned another pet, but the pet was summoned first
		if _bit_band(who_flags, OBJECT_TYPE_PETS) ~= 0 then
			local mobid = tonumber(alvo_serial:sub(3+6,3+9),16)
			if sub_pet_ids[mobid] then
				C_Timer.After(0.1, function()
					parser:summon(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellName)
				end)
				return
			end
		end
		--print()

		_detalhes.tabela_pets:Adicionar(alvo_serial, alvo_name, alvo_flags, who_serial, who_name, who_flags)

		--print("SUMMON", alvo_name, _detalhes.tabela_pets.pets, _detalhes.tabela_pets.pets[alvo_serial], alvo_serial)

		return
	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> HEALING 	serach key: ~heal											|
-----------------------------------------------------------------------------------------------------------------------------------------

	-- https://github.com/TrinityCore/TrinityCore/blob/d81a9e5bc3b3e13b47332b3e7817bd0a0b228cbc/src/server/game/Spells/Auras/SpellAuraEffects.h#L313-L367
	-- absorb order from trinitycore
	local function AbsorbAuraOrderPred(a, b)

		local spellA = a.spellid
		local spellB = b.spellid

		-- puts oldest absorb first if there is two with the same id.
		if spellA == spellB then
			return a.timestamp < b.timestamp
		end

		-- twin val'kyr light essence
		if spellA == 65686 then
			return true
		end
		if spellB == 65686 then
			return false
		end

		-- twin val'kyr dark essence
		if spellA == 65684 then
			return true
		end
		if spellB == 65684 then
			return false
		end

		--frost ward
		if frost_ward_absorb_list[spellA] then
			return true
		end
		if frost_ward_absorb_list[spellB] then
			return false
		end

		-- fire ward
		if fire_ward_absorb_list[spellA] then
			return true
		end
		if fire_ward_absorb_list[spellB] then
			return false
		end

		--shadow ward
		if shadow_ward_absorb_list[spellA] then
			return true
		end
		if shadow_ward_absorb_list[spellB] then
			return false
		end

		-- sacred shield
		if spellA == 58597 then
			return true
		end
		if spellB == 58597 then
			return false
		end

		--fell blossom
		if spellA == 28527 then
			return true
		end
		if spellB == 28527 then
			return false
		end

		-- Divine Aegis
		if spellA == 47753 then
			return true
		end
		if spellB == 47753 then
			return false
		end

		-- Ice Barrier
		if ice_barrier_absorb_list[spellA] then
			return true
		end
		if ice_barrier_absorb_list[spellB] then
			return false
		end

		-- Warlock Sacrifice
		if sacrifice_absorb_list[spellA] then
			return true
		end
		if sacrifice_absorb_list[spellB] then
			return false
		end

		-- sort oldest buffs to the top
		return a.timestamp < b.timestamp
	end

	function parser:heal_absorb(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, absorbed, spelltype)
		local found_absorb

		escudo[alvo_name] = escudo[alvo_name] or {}
		for _, absorb in ipairs(escudo[alvo_name]) do
			-- check if we have twin val'kyr light essence and we took fire damage
			if absorb.spellid == 65686 then
				if _bit_band(spelltype, 0x4) == spelltype then
					-- honestly I don't think this should be tracked as healing by details, the healing meters would be flooded with useless info.
					--found_absorb = absorb
					--break
					return
				end
			-- check if we have twin val'kyr dark essence and we took shadow damage
			elseif absorb.spellid == 65684 then
				if _bit_band(spelltype, 0x20) == spelltype then
					-- see above
					--found_absorb = absorb
					--break
					return
				end
			-- check if its a frost ward
			elseif frost_ward_absorb_list[absorb.spellid] then
				-- only pick if its frost damage
				if (_bit_band(spelltype, 0x10) == spelltype) then
					found_absorb = absorb
					break -- exit since wards are priority
				end
			-- check if its a fire ward
			elseif fire_ward_absorb_list[absorb.spellid] then
				-- only pick if its fire damage
				if (_bit_band(spelltype, 0x4) == spelltype) then
					found_absorb = absorb
					break -- exit since wards are priority
				end
			-- check if its a shadow ward
			elseif shadow_ward_absorb_list[absorb.spellid] then
				-- only pick if its shadow damage
				if (_bit_band(spelltype, 0x20) == spelltype) then
					found_absorb = absorb
					break -- exit since wards are priority
				end
			else
				found_absorb = absorb
				break -- exit since this should be the oldest absorb added and not a ward
			end
		end
		if found_absorb then
			return parser:heal(token, time, found_absorb.serial, found_absorb.name, found_absorb.flags, alvo_serial, alvo_name, alvo_flags, found_absorb.spellid, found_absorb.spellname, nil, absorbed, 0, 0, nil, true)
		end -- should we do something if it expected to absorb but couldn't?
	end

	function parser:heal(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overhealing, absorbed, critical, is_shield)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		--> only capture heal if is in combat
		if(not _in_combat) then
			if(not _in_resting_zone) then
				return
			end
		end

		--> check invalid serial against pets
		if(who_serial == "") then
			if(who_flags and _bit_band(who_flags, OBJECT_TYPE_PETS) ~= 0) then --> � um pet
				return
			end
			--who_serial = nil
		end

		--> no name, use spellname
		if(not who_name) then
			--who_name = "[*] " ..(spellname or "--unknown spell--")
			who_name = "[*] "..spellname
		end

		--> no target, just ignore
		if(not alvo_name) then
			return
		end

		if(is_using_spellId_override) then
			spellid = override_spellId[spellid] or spellid
		end

		--[[statistics]]-- _detalhes.statistics.heal_calls = _detalhes.statistics.heal_calls + 1
		local cura_efetiva = absorbed
		if(is_shield) then
			--> o shield ja passa o numero exato da cura e o overheal
			cura_efetiva = amount
		else
			--cura_efetiva = absorbed + amount - overhealing
			cura_efetiva = cura_efetiva + amount - overhealing
		end

		_current_heal_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		local este_jogador, meu_dono = healing_cache[who_serial]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_heal_container:PegarCombatente(who_serial, who_name, who_flags, true)
			if(not meu_dono and who_flags and who_serial ~= "") then --> se n�o for um pet, adicionar no cache
				healing_cache[who_serial] = este_jogador
			end
		end

		local jogador_alvo, alvo_dono = healing_cache[alvo_serial]
		if(not jogador_alvo) then
			jogador_alvo, alvo_dono, alvo_name = _current_heal_container:PegarCombatente(alvo_serial, alvo_name, alvo_flags, true)
			if(not alvo_dono and alvo_flags and alvo_serial ~= "") then
				healing_cache[alvo_serial] = jogador_alvo
			end
		end

		este_jogador.last_event = _tempo

	------------------------------------------------------------------------------------------------
	--> an enemy healing enemy or an player actor healing a enemy

		if(_bit_band(alvo_flags, REACTION_FRIENDLY) == 0 and not _detalhes.is_in_arena and not _detalhes.is_in_battleground) then
			if(not este_jogador.heal_enemy[spellid]) then
				este_jogador.heal_enemy[spellid] = cura_efetiva
			else
				este_jogador.heal_enemy[spellid] = este_jogador.heal_enemy[spellid] + cura_efetiva
			end

			este_jogador.heal_enemy_amt = este_jogador.heal_enemy_amt + cura_efetiva

			return
		end

	------------------------------------------------------------------------------------------------
	--> group checks

		if(este_jogador.grupo) then
			--_current_combat.totals_grupo[2] = _current_combat.totals_grupo[2] + cura_efetiva
			_current_gtotal[2] = _current_gtotal[2] + cura_efetiva
		end

		if(jogador_alvo.grupo) then

			local t = last_events_cache[alvo_name]

			if(not t) then
				t = _current_combat:CreateLastEventsTable(alvo_name)
			end

			local i = t.n

			local this_event = t[i]

			this_event[1] = false --> true if this is a damage || false for healing
			this_event[2] = spellid --> spellid || false if this is a battle ress line
			this_event[3] = amount --> amount of damage or healing
			this_event[4] = time --> parser time
			this_event[5] = _UnitHealth(alvo_name) --> current unit heal
			this_event[6] = who_name --> source name
			this_event[7] = is_shield
			this_event[8] = absorbed

			i = i + 1

			if(i == _death_event_amt+1) then
				t.n = 1
			else
				t.n = i
			end

		end

	------------------------------------------------------------------------------------------------
	--> timer

		if(not este_jogador.iniciar_hps) then

			este_jogador:Iniciar(true) --inicia o hps do jogador

			if(meu_dono and not meu_dono.iniciar_hps) then
				meu_dono:Iniciar(true)
				if(meu_dono.end_time) then
					meu_dono.end_time = nil
				else
					--meu_dono:IniciarTempo(_tempo)
					meu_dono.start_time = _tempo
				end
			end

			if(este_jogador.end_time) then --> o combate terminou, reabrir o tempo
				este_jogador.end_time = nil
			else
				--este_jogador:IniciarTempo(_tempo)
				este_jogador.start_time = _tempo
			end
		end

	------------------------------------------------------------------------------------------------
	--> add amount

		--> actor target

		if(cura_efetiva > 0) then

			--> combat total
			_current_total[2] = _current_total[2] + cura_efetiva

			--> actor healing amount
			este_jogador.total = este_jogador.total + cura_efetiva
			este_jogador.total_without_pet = este_jogador.total_without_pet + cura_efetiva

			--> healing taken
			jogador_alvo.healing_taken = jogador_alvo.healing_taken + cura_efetiva --> adiciona o dano tomado
			if(not jogador_alvo.healing_from[who_name]) then --> adiciona a pool de dano tomado de quem
				jogador_alvo.healing_from[who_name] = true
			end

			if(is_shield) then
				este_jogador.totalabsorb = este_jogador.totalabsorb + cura_efetiva
				este_jogador.targets_absorbs[alvo_name] =(este_jogador.targets_absorbs[alvo_name] or 0) + cura_efetiva
			end

			--> pet
			if(meu_dono) then
				meu_dono.total = meu_dono.total + cura_efetiva --> heal do pet
				meu_dono.targets[alvo_name] =(meu_dono.targets[alvo_name] or 0) + cura_efetiva
			end

			--> target amount
			este_jogador.targets[alvo_name] =(este_jogador.targets[alvo_name] or 0) + cura_efetiva
		end

		if(meu_dono) then
			meu_dono.last_event = _tempo
		end

		if(overhealing > 0) then
			este_jogador.totalover = este_jogador.totalover + overhealing
			este_jogador.targets_overheal[alvo_name] =(este_jogador.targets_overheal[alvo_name] or 0) + overhealing

			if(meu_dono) then
				meu_dono.totalover = meu_dono.totalover + overhealing
			end
		end

		--> actor spells table
		local spell = este_jogador.spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.spells:PegaHabilidade(spellid, true, token)
			if(is_shield) then
				spell.is_shield = true
			end
			if spellname and (_current_combat.is_boss and who_flags and _bit_band(who_flags, OBJECT_TYPE_ENEMY) ~= 0) then
				_detalhes.spell_school_cache[spellname] = spelltype
			end
		end

		if(_is_storing_cleu) then
			_current_combat_cleu_events[_current_combat_cleu_events.n] = {_tempo, _token_ids[token] or 0, who_name, alvo_name or "", spellid, amount}
			_current_combat_cleu_events.n = _current_combat_cleu_events.n + 1
		end

		if(is_shield) then
			--return spell:Add(alvo_serial, alvo_name, alvo_flags, cura_efetiva, who_name, 0, 		  nil, 	     overhealing, true)
			return spell_heal_func(spell, alvo_serial, alvo_name, alvo_flags, cura_efetiva, who_name, 0, 		  nil, 	     overhealing, true)
		else
			--return spell:Add(alvo_serial, alvo_name, alvo_flags, cura_efetiva, who_name, absorbed, critical, overhealing)
			return spell_heal_func(spell, alvo_serial, alvo_name, alvo_flags, cura_efetiva, who_name, absorbed, critical, overhealing)
		end
	end

	function parser:SLT_healing(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overhealing, absorbed, critical, is_shield)

	--> get actors
		local este_jogador, meu_dono = healing_cache[who_serial]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_heal_container:PegarCombatente(who_serial, who_name, who_flags, true)
			if(not meu_dono and who_flags and who_serial ~= "") then --> se n�o for um pet, adicionar no cache
				healing_cache[who_serial] = este_jogador
			end
		end

		local jogador_alvo, alvo_dono = healing_cache[alvo_serial]
		if(not jogador_alvo) then
			jogador_alvo, alvo_dono, alvo_name = _current_heal_container:PegarCombatente(alvo_serial, alvo_name, alvo_flags, true)
			if(not alvo_dono and alvo_flags and alvo_serial ~= "") then
				healing_cache[alvo_serial] = jogador_alvo
			end
		end

		este_jogador.last_event = _tempo

		local t = last_events_cache[alvo_name]

		if(not t) then
			t = _current_combat:CreateLastEventsTable(alvo_name)
		end

		local i = t.n

		local this_event = t[i]

		this_event[1] = false --> true if this is a damage || false for healing
		this_event[2] = spellid --> spellid || false if this is a battle ress line
		this_event[3] = amount --> amount of damage or healing
		this_event[4] = time --> parser time
		this_event[5] = _UnitHealth(alvo_name) --> current unit heal
		this_event[6] = who_name --> source name
		this_event[7] = is_shield
		this_event[8] = absorbed

		i = i + 1

		if(i == _death_event_amt+1) then
			t.n = 1
		else
			t.n = i
		end

		local spell = este_jogador.spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.spells:PegaHabilidade(spellid, true, token)
			spell.neutral = true
		end

		return spell_heal_func(spell, alvo_serial, alvo_name, alvo_flags, absorbed + amount - overhealing, who_name, absorbed, critical, overhealing, nil)
	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> BUFFS & DEBUFFS 	search key: ~buff ~aura ~shield								|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:buff(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spellschool, tipo, amount, arg1, arg2, arg3)

	--> not yet well know about unnamed buff casters
		if(not alvo_name) then
			alvo_name = "[*] Unknown shield target"

		elseif(not who_name) then
			--> no actor name, use spell name instead
			who_name = "[*] " .. spellname
			who_flags = 0xa48
			who_serial = ""
		end

	------------------------------------------------------------------------------------------------
	--> spell reflection
		if reflection_spellid[spellid] then
			--> this is a spell reflect aura
			--> we save the info on who received this aura and from whom
			--> this will be used to credit this spell as the one doing the damage
			reflection_auras[alvo_serial] = {
				who_serial = who_serial,
				who_name = who_name,
				who_flags = who_flags,
				spellid = spellid,
				spellname = spellname,
				spelltype = spellschool,
			}
		end
	------------------------------------------------------------------------------------------------
	--> handle shields

	------------------------------------------------------------------------------------------------
		--> healing done absorbs
		-- this needs to be outside buff / debuffs for boss mechanics which absorb damage.
		if(absorb_spell_list[spellid]) then
			escudo[alvo_name] = escudo[alvo_name] or {}

			-- create absorb data
			local absorb = {}
			absorb.timestamp = time
			absorb.name = who_name
			absorb.serial = who_serial
			absorb.flags = who_flags
			absorb.spellid = spellid
			absorb.spellname = spellname
			-- insert absorb at the end of the absorb stack
			_table_insert(escudo[alvo_name], absorb)
			_table_sort(escudo[alvo_name], AbsorbAuraOrderPred)
		end

		if(tipo == "BUFF") then
			------------------------------------------------------------------------------------------------
			--> buff uptime

			if(spellid == 27827) then --> spirit of redemption(holy priest)
				parser:dead("UNIT_DIED", time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags)
				ignore_death[who_name] = true
				return
			end

			if(_recording_buffs_and_debuffs) then
				if(who_name == alvo_name and raid_members_cache[who_serial] and _in_combat) then
					--> call record buffs uptime
					parser:add_buff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, "BUFF_UPTIME_IN")

				elseif(container_pets[who_serial] and container_pets[who_serial][2] == alvo_serial) then
					--um pet colocando uma aura do dono
					parser:add_buff_uptime(token, time, alvo_serial, alvo_name, alvo_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, "BUFF_UPTIME_IN")
				end
			end

	------------------------------------------------------------------------------------------------
	--> recording debuffs applied by player

		elseif(tipo == "DEBUFF") then
		------------------------------------------------------------------------------------------------
		--> spell reflection
			if who_serial == alvo_serial and not reflection_ignore[spellid] then
				--> self-inflicted debuff that could've been reflected
				--> just saving it as a boolean to check for reflections
				reflection_debuffs[who_serial] = reflection_debuffs[who_serial] or {}
				reflection_debuffs[who_serial][spellid] = true
			end

			if(_in_combat) then

			------------------------------------------------------------------------------------------------
			--> buff uptime
				if(_recording_buffs_and_debuffs) then

					if(cc_spell_list[spellid]) then
						parser:add_cc_done(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname)
					end

					if(bitfield_debuffs[spellname] and raid_members_cache[alvo_serial]) then
						bitfield_swap_cache[alvo_serial] = true
					end

					if(raid_members_cache[who_serial]) then
						--> call record debuffs uptime
						parser:add_debuff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, "DEBUFF_UPTIME_IN")

					elseif(raid_members_cache[alvo_serial] and not raid_members_cache[who_serial]) then --> alvo � da raide e who � alguem de fora da raide
						parser:add_bad_debuff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spellschool, "DEBUFF_UPTIME_IN")
					end
				end

				if(_recording_ability_with_buffs) then
					if(who_name == _detalhes.playername) then

						--> record debuff uptime
						local SoloDebuffUptime = _current_combat.SoloDebuffUptime
						if(not SoloDebuffUptime) then
							SoloDebuffUptime = {}
							_current_combat.SoloDebuffUptime = SoloDebuffUptime
						end

						local ThisDebuff = SoloDebuffUptime[spellid]

						if(not ThisDebuff) then
							ThisDebuff = {name = spellname, duration = 0, start = _tempo, castedAmt = 1, refreshAmt = 0, droppedAmt = 0, Active = true}
							SoloDebuffUptime[spellid] = ThisDebuff
						else
							ThisDebuff.castedAmt = ThisDebuff.castedAmt + 1
							ThisDebuff.start = _tempo
							ThisDebuff.Active = true
						end

						--> record debuff spell and attack power
						local SoloDebuffPower = _current_combat.SoloDebuffPower
						if(not SoloDebuffPower) then
							SoloDebuffPower = {}
							_current_combat.SoloDebuffPower = SoloDebuffPower
						end

						local ThisDebuff = SoloDebuffPower[spellid]
						if(not ThisDebuff) then
							ThisDebuff = {}
							SoloDebuffPower[spellid] = ThisDebuff
						end

						local ThisDebuffOnTarget = ThisDebuff[alvo_serial]

						local base, posBuff, negBuff = UnitAttackPower("player")
						local AttackPower = base+posBuff+negBuff
						local base, posBuff, negBuff = UnitRangedAttackPower("player")
						local RangedAttackPower = base+posBuff+negBuff
						local SpellPower = GetSpellBonusDamage(3)

						--> record buffs active on player when the debuff was applied
						local BuffsOn = {}
						for BuffName, BuffTable in _pairs(_detalhes.Buffs.BuffsTable) do
							if(BuffTable.active) then
								BuffsOn[#BuffsOn+1] = BuffName
							end
						end

						if(not ThisDebuffOnTarget) then --> apply
							ThisDebuff[alvo_serial] = {power = math.max(AttackPower, RangedAttackPower, SpellPower), onTarget = true, buffs = BuffsOn}
						else --> re applying
							ThisDebuff[alvo_serial].power = math.max(AttackPower, RangedAttackPower, SpellPower)
							ThisDebuff[alvo_serial].buffs = BuffsOn
							ThisDebuff[alvo_serial].onTarget = true
						end

						--> send event for plugins
						_detalhes:SendEvent("BUFF_UPDATE_DEBUFFPOWER")

					end
				end
			end
		end
	end

	-- ~crowd control ~ccdone
	function parser:add_cc_done(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local este_jogador, meu_dono = misc_cache[who_name]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente(who_serial, who_name, who_flags, true)
			if(not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache[who_name] = este_jogador
			end
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if(not este_jogador.cc_done) then
			este_jogador.cc_done = _detalhes:GetOrderNumber()
			este_jogador.cc_done_spells = container_habilidades:NovoContainer(container_misc)
			este_jogador.cc_done_targets = {}
		end

	------------------------------------------------------------------------------------------------
	--> add amount

		--> update last event
		este_jogador.last_event = _tempo

		--> add amount
		este_jogador.cc_done = este_jogador.cc_done + 1
		este_jogador.cc_done_targets[alvo_name] =(este_jogador.cc_done_targets[alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.cc_done_spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.cc_done_spells:PegaHabilidade(spellid, true)
		end

		spell.targets[alvo_name] =(spell.targets[alvo_name] or 0) + 1
		spell.counter = spell.counter + 1

		--> add the crowd control for the pet owner
		if(meu_dono) then

			if(not meu_dono.cc_done) then
				meu_dono.cc_done = _detalhes:GetOrderNumber()
				meu_dono.cc_done_spells = container_habilidades:NovoContainer(container_misc)
				meu_dono.cc_done_targets = {}
			end

			--> add amount
			meu_dono.cc_done = meu_dono.cc_done + 1
			meu_dono.cc_done_targets[alvo_name] =(meu_dono.cc_done_targets[alvo_name] or 0) + 1

			--> actor spells table
			local spell = meu_dono.cc_done_spells._ActorTable[spellid]
			if(not spell) then
				spell = meu_dono.cc_done_spells:PegaHabilidade(spellid, true)
			end

			spell.targets[alvo_name] =(spell.targets[alvo_name] or 0) + 1
			spell.counter = spell.counter + 1
		end

		--> verifica a classe
		if(who_flags and _bit_band(who_flags, OBJECT_TYPE_PLAYER) ~= 0) then
			if(este_jogador.classe == "UNKNOW" or este_jogador.classe == "UNGROUPPLAYER") then
				local damager_object = damage_cache[who_serial]
				if(damager_object and(damager_object.classe ~= "UNKNOW" and damager_object.classe ~= "UNGROUPPLAYER")) then
					este_jogador.classe = damager_object.classe
				else
					local healing_object = healing_cache[who_serial]
					if(healing_object and(healing_object.classe ~= "UNKNOW" and healing_object.classe ~= "UNGROUPPLAYER")) then
						este_jogador.classe = healing_object.classe
					end
				end
			end
		end
	end

	function parser:buff_refresh(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spellschool, tipo, amount)

	------------------------------------------------------------------------------------------------
	--> handle shields
	------------------------------------------------------------------------------------------------
		--> healing done(shields)
		-- this needs to be outside buff / debuffs for boss mechanics which absorb damage.
		if(absorb_spell_list[spellid]) then
			escudo[alvo_name] = escudo[alvo_name] or {}

			-- refresh absorb if it's already applied by this player
			local found = false
			for _, applied_absorb in ipairs(escudo[alvo_name]) do

				if applied_absorb.spellid == spellid and applied_absorb.serial == who_serial then
					applied_absorb.timestamp = time
					found = true
					break
				end
			end

			-- create absorb data (this absorb was probably caused out of combat)
			if not found then
				local absorb = {}
				absorb.timestamp = time
				absorb.name = who_name
				absorb.serial = who_serial
				absorb.flags = who_flags
				absorb.spellid = spellid
				absorb.spellname = spellname
				-- insert absorb at the end of the absorb stack
				_table_insert(escudo[alvo_name], absorb)
				_table_sort(escudo[alvo_name], AbsorbAuraOrderPred)
			end
		end

		if (tipo == "BUFF") then

			------------------------------------------------------------------------------------------------
			--> buff uptime
				if(_recording_buffs_and_debuffs) then
					if(who_name == alvo_name and raid_members_cache[who_serial] and _in_combat) then
						--> call record buffs uptime
						parser:add_buff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, "BUFF_UPTIME_REFRESH")
					elseif(container_pets[who_serial] and container_pets[who_serial][2] == alvo_serial) then
						--um pet colocando uma aura do dono
						parser:add_buff_uptime(token, time, alvo_serial, alvo_name, alvo_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, "BUFF_UPTIME_REFRESH")
					end
				end


			------------------------------------------------------------------------------------------------
			--> recording buffs

				if(_recording_self_buffs) then
					if(who_name == _detalhes.playername or alvo_name == _detalhes.playername) then --> foi colocado pelo player

						local bufftable = _detalhes.Buffs.BuffsTable[spellname]
						if(bufftable) then
							return bufftable:UpdateBuff("refresh")
						else
							return false
						end
					end
				end

	------------------------------------------------------------------------------------------------
	--> recording debuffs applied by player

		elseif(tipo == "DEBUFF") then
		--print("debuff - ", token, spellname)

			if(_in_combat) then
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if(_recording_buffs_and_debuffs) then
					if(raid_members_cache[who_serial]) then
						--> call record debuffs uptime
						parser:add_debuff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, "DEBUFF_UPTIME_REFRESH")
					elseif(raid_members_cache[alvo_serial] and not raid_members_cache[who_serial]) then --> alvo � da raide e o caster � inimigo
						parser:add_bad_debuff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spellschool, "DEBUFF_UPTIME_REFRESH", amount)
					end
				end

				if(_recording_ability_with_buffs) then
					if(who_name == _detalhes.playername) then

						--> record debuff uptime
						local SoloDebuffUptime = _current_combat.SoloDebuffUptime
						if(SoloDebuffUptime) then
							local ThisDebuff = SoloDebuffUptime[spellid]
							if(ThisDebuff and ThisDebuff.Active) then
								ThisDebuff.refreshAmt = ThisDebuff.refreshAmt + 1
								ThisDebuff.duration = ThisDebuff.duration +(_tempo - ThisDebuff.start)
								ThisDebuff.start = _tempo

								--> send event for plugins
								_detalhes:SendEvent("BUFF_UPDATE_DEBUFFPOWER")
							end
						end

						--> record debuff spell and attack power
						local SoloDebuffPower = _current_combat.SoloDebuffPower
						if(SoloDebuffPower) then
							local ThisDebuff = SoloDebuffPower[spellid]
							if(ThisDebuff) then
								local ThisDebuffOnTarget = ThisDebuff[alvo_serial]
								if(ThisDebuffOnTarget) then
									local base, posBuff, negBuff = UnitAttackPower("player")
									local AttackPower = base+posBuff+negBuff
									local base, posBuff, negBuff = UnitRangedAttackPower("player")
									local RangedAttackPower = base+posBuff+negBuff
									local SpellPower = GetSpellBonusDamage(3)

									local BuffsOn = {}
									for BuffName, BuffTable in _pairs(_detalhes.Buffs.BuffsTable) do
										if(BuffTable.active) then
											BuffsOn[#BuffsOn+1] = BuffName
										end
									end

									ThisDebuff[alvo_serial].power = math.max(AttackPower, RangedAttackPower, SpellPower)
									ThisDebuff[alvo_serial].buffs = BuffsOn

									--> send event for plugins
									_detalhes:SendEvent("BUFF_UPDATE_DEBUFFPOWER")
								end
							end
						end

					end
				end
			end
		end
	end

	function parser:unbuff_shield(alvo_name, who_serial, spellid)
		escudo[alvo_name] = escudo[alvo_name] or {}
		local index
		for i, applied_absorb in ipairs(escudo[alvo_name]) do
			if applied_absorb.serial == who_serial and applied_absorb.spellid == spellid then
				index = i
				break
			end
		end

		if index then
			_table_remove(escudo[alvo_name], index)
			_table_sort(escudo[alvo_name], AbsorbAuraOrderPred)
		end
	end

	function parser:unbuff(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spellschool, tipo, amount)

	------------------------------------------------------------------------------------------------
	--> handle shields
	------------------------------------------------------------------------------------------------
		--> healing done(shields)
		-- this needs to be outside buff / debuffs for boss mechanics which absorb damage.
		if absorb_spell_list[spellid] then
			escudo[alvo_name] = escudo[alvo_name] or {}
			-- locate buff
			for _, applied_absorb in ipairs(escudo[alvo_name]) do
				if applied_absorb.serial == who_serial and applied_absorb.spellid == spellid then
					-- schedule removal of shield buff since absorbed damage is sent after unbuff is called.
					C_Timer.After(0.1, function() parser:unbuff_shield(alvo_name, who_serial, spellid) end)
					break
				end
			end
		end

		if(tipo == "BUFF") then

			------------------------------------------------------------------------------------------------
			--> buff uptime
				if(_recording_buffs_and_debuffs) then
					if(who_name == alvo_name and raid_members_cache[who_serial] and _in_combat) then
						--> call record buffs uptime
						parser:add_buff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, "BUFF_UPTIME_OUT")
					elseif(container_pets[who_serial] and container_pets[who_serial][2] == alvo_serial) then
						--um pet colocando uma aura do dono
						parser:add_buff_uptime(token, time, alvo_serial, alvo_name, alvo_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, "BUFF_UPTIME_OUT")
					end
				end
			------------------------------------------------------------------------------------------------
			--> recording buffs
				if(_recording_self_buffs) then
					if(who_name == _detalhes.playername or alvo_name == _detalhes.playername) then --> foi colocado pelo player

						local bufftable = _detalhes.Buffs.BuffsTable[spellname]
						if(bufftable) then
							return bufftable:UpdateBuff("remove")
						else
							return false
						end
					end
				end

	------------------------------------------------------------------------------------------------
	--> recording debuffs applied by player
		elseif(tipo == "DEBUFF") then
		------------------------------------------------------------------------------------------------
		--> spell reflection
			if reflection_dispels[alvo_serial] and reflection_dispels[alvo_serial][spellid] then
				--> debuff was dispelled by a reflecting dispel and could've been reflected
				--> save the data about whom dispelled who and the spell that was dispelled
				local reflection = reflection_dispels[alvo_serial][spellid]
				reflection_events[who_serial] = reflection_events[who_serial] or {}
				reflection_events[who_serial][spellid] = {
					who_serial = reflection.who_serial,
					who_name = reflection.who_name,
					who_flags = reflection.who_flags,
					spellid = reflection.spellid,
					spellname = reflection.spellname,
					spelltype = reflection.spelltype,
					time = time,
				}
				reflection_dispels[alvo_serial][spellid] = nil
				if next(reflection_dispels[alvo_serial]) == nil then
					--suggestion on how to make this better?
					reflection_dispels[alvo_serial] = nil
				end
			end

		------------------------------------------------------------------------------------------------
		--> spell reflection
			if reflection_debuffs[who_serial] and reflection_debuffs[who_serial][spellid] then
				--> self-inflicted debuff was removed, so we just clear this data
				reflection_debuffs[who_serial][spellid] = nil
				if next(reflection_debuffs[who_serial]) == nil then
					--> better way of doing this? accepting suggestions
					reflection_debuffs[who_serial] = nil
				end
			end

			if(_in_combat) then
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if(_recording_buffs_and_debuffs) then
					if(raid_members_cache[who_serial]) then
						--> call record debuffs uptime
						parser:add_debuff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, "DEBUFF_UPTIME_OUT")
					elseif(raid_members_cache[alvo_serial] and not raid_members_cache[who_serial]) then --> alvo � da raide e o caster � inimigo
						parser:add_bad_debuff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spellschool, "DEBUFF_UPTIME_OUT")
					end
				end

				if(bitfield_debuffs[spellname] and alvo_serial) then
					bitfield_swap_cache[alvo_serial] = nil
				end

				if(_recording_ability_with_buffs) then

					if(who_name == _detalhes.playername) then

						--> record debuff uptime
						local SoloDebuffUptime = _current_combat.SoloDebuffUptime
						local sendevent = false
						if(SoloDebuffUptime) then
							local ThisDebuff = SoloDebuffUptime[spellid]
							if(ThisDebuff and ThisDebuff.Active) then
								ThisDebuff.duration = ThisDebuff.duration +(_tempo - ThisDebuff.start)
								ThisDebuff.droppedAmt = ThisDebuff.droppedAmt + 1
								ThisDebuff.start = nil
								ThisDebuff.Active = false
								sendevent = true
							end
						end

						--> record debuff spell and attack power
						local SoloDebuffPower = _current_combat.SoloDebuffPower
						if(SoloDebuffPower) then
							local ThisDebuff = SoloDebuffPower[spellid]
							if(ThisDebuff) then
								ThisDebuff[alvo_serial] = nil
								sendevent = true
							end
						end

						if(sendevent) then
							_detalhes:SendEvent("BUFF_UPDATE_DEBUFFPOWER")
						end
					end
				end
			end
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> MISC 	search key: ~buffuptime ~buffsuptime									|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:add_bad_debuff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spellschool, in_out, stack_amount)

		if(not alvo_name) then
			--> no target name, just quit
			return
		elseif(not who_name) then
			--> no actor name, use spell name instead
			who_name = "[*] "..spellname
		end

		------------------------------------------------------------------------------------------------
		--> get actors
			--> nome do debuff ser� usado para armazenar o nome do ator
			local este_jogador = misc_cache[spellname]
			if(not este_jogador) then --> pode ser um desconhecido ou um pet
				este_jogador = _current_misc_container:PegarCombatente(who_serial, spellname, who_flags, true)
				misc_cache[spellname] = este_jogador
			end

		------------------------------------------------------------------------------------------------
		--> build containers on the fly

			if(not este_jogador.debuff_uptime) then
				este_jogador.boss_debuff = true
				este_jogador.damage_twin = who_name
				este_jogador.spellschool = spellschool
				este_jogador.damage_spellid = spellid
				este_jogador.debuff_uptime = 0
				este_jogador.debuff_uptime_spells = container_habilidades:NovoContainer(container_misc)
				este_jogador.debuff_uptime_targets = {}
			end

		------------------------------------------------------------------------------------------------
		--> add amount

			--> update last event
			este_jogador.last_event = _tempo

			--> actor target
			local este_alvo = este_jogador.debuff_uptime_targets[alvo_name]
			if(not este_alvo) then
				este_alvo = _detalhes.atributo_misc:CreateBuffTargetObject()
				este_jogador.debuff_uptime_targets[alvo_name] = este_alvo
			end

			if(in_out == "DEBUFF_UPTIME_IN") then
				este_alvo.actived = true
				este_alvo.activedamt = este_alvo.activedamt + 1
				if(este_alvo.actived_at and este_alvo.actived) then
					este_alvo.uptime = este_alvo.uptime + _tempo - este_alvo.actived_at
					este_jogador.debuff_uptime = este_jogador.debuff_uptime + _tempo - este_alvo.actived_at
				end
				este_alvo.actived_at = _tempo

				--death log
					--> record death log
					local t = last_events_cache[alvo_name]

					if(not t) then
						t = _current_combat:CreateLastEventsTable(alvo_name)
					end

					local i = t.n

					local this_event = t[i]

					if(not this_event) then
						return print("Parser Event Error -> Set to 16 DeathLogs and /reload", i, _death_event_amt)
					end

					--print("DebuffIN", ">", "Added to the DeathLog")

					this_event[1] = 4 --> 4 = debuff aplication
					this_event[2] = spellid --> spellid
					this_event[3] = 1
					this_event[4] = time --> parser time
					this_event[5] = _UnitHealth(alvo_name) --> current unit heal
					this_event[6] = who_name --> source name
					this_event[7] = false
					this_event[8] = false
					this_event[9] = false
					this_event[10] = false

					i = i + 1

					if(i == _death_event_amt+1) then
						t.n = 1
					else
						t.n = i
					end

			elseif(in_out == "DEBUFF_UPTIME_REFRESH") then
				if(este_alvo.actived_at and este_alvo.actived) then
					este_alvo.uptime = este_alvo.uptime + _tempo - este_alvo.actived_at
					este_jogador.debuff_uptime = este_jogador.debuff_uptime + _tempo - este_alvo.actived_at
				end
				este_alvo.actived_at = _tempo
				este_alvo.actived = true

				--death log

					--local name, rank, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId = UnitAura(alvo_name, spellname, nil, "HARMFUL")
					--UnitAura("Kastfall", "Gulp Frog Toxin", nil, "HARMFUL")
					--print("Hello World", spellname, name)

					--if(name) then
						--> record death log
						local t = last_events_cache[alvo_name]

						if(not t) then
							t = _current_combat:CreateLastEventsTable(alvo_name)
						end

						local i = t.n

						local this_event = t[i]

						if(not this_event) then
							return print("Parser Event Error -> Set to 16 DeathLogs and /reload", i, _death_event_amt)
						end

						--print("DebuffRefresh", ">", "Added to the DeathLog", stack_amount)

						this_event[1] = 4 --> 4 = debuff aplication
						this_event[2] = spellid --> spellid
						this_event[3] = stack_amount or 1
						this_event[4] = time --> parser time
						this_event[5] = _UnitHealth(alvo_name) --> current unit heal
						this_event[6] = who_name --> source name
						this_event[7] = false
						this_event[8] = false
						this_event[9] = false
						this_event[10] = false

						i = i + 1

						if(i == _death_event_amt+1) then
							t.n = 1
						else
							t.n = i
						end
					--end

			elseif(in_out == "DEBUFF_UPTIME_OUT") then
				if(este_alvo.actived_at and este_alvo.actived) then
					este_alvo.uptime = este_alvo.uptime + _detalhes._tempo - este_alvo.actived_at
					este_jogador.debuff_uptime = este_jogador.debuff_uptime + _tempo - este_alvo.actived_at --> token = actor misc object
				end

				este_alvo.activedamt = este_alvo.activedamt - 1

				if(este_alvo.activedamt == 0) then
					este_alvo.actived = false
					este_alvo.actived_at = nil
				else
					este_alvo.actived_at = _tempo
				end
			end
	end

	-- ~debuff
	function parser:add_debuff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, in_out)
	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors
		local este_jogador = misc_cache[who_name]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador = _current_misc_container:PegarCombatente(who_serial, who_name, who_flags, true)
			misc_cache[who_name] = este_jogador
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if(not este_jogador.debuff_uptime) then
			este_jogador.debuff_uptime = 0
			este_jogador.debuff_uptime_spells = container_habilidades:NovoContainer(container_misc)
			este_jogador.debuff_uptime_targets = {}
		end

	------------------------------------------------------------------------------------------------
	--> add amount

		--> update last event
		este_jogador.last_event = _tempo

		--> actor spells table
		local spell = este_jogador.debuff_uptime_spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.debuff_uptime_spells:PegaHabilidade(spellid, true, "DEBUFF_UPTIME")
		end
		return spell_misc_func(spell, alvo_serial, alvo_name, alvo_flags, who_name, este_jogador, "BUFF_OR_DEBUFF", in_out)

	end

	function parser:add_buff_uptime(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, in_out)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors
		local este_jogador = misc_cache[who_name]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador = _current_misc_container:PegarCombatente(who_serial, who_name, who_flags, true)
			misc_cache[who_name] = este_jogador
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if(not este_jogador.buff_uptime) then
			este_jogador.buff_uptime = 0
			este_jogador.buff_uptime_spells = container_habilidades:NovoContainer(container_misc)
			este_jogador.buff_uptime_targets = {}
		end

	------------------------------------------------------------------------------------------------
	--> add amount

		--> update last event
		este_jogador.last_event = _tempo

		--> actor spells table
		local spell = este_jogador.buff_uptime_spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.buff_uptime_spells:PegaHabilidade(spellid, true, "BUFF_UPTIME")
		end
		return spell_misc_func(spell, alvo_serial, alvo_name, alvo_flags, who_name, este_jogador, "BUFF_OR_DEBUFF", in_out)

	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> ENERGY	serach key: ~energy												|
-----------------------------------------------------------------------------------------------------------------------------------------

local SPELL_POWER_MANA = SPELL_POWER_MANA or 0
local SPELL_POWER_RAGE = SPELL_POWER_RAGE or 1
local SPELL_POWER_ENERGY = SPELL_POWER_ENERGY or 3
local SPELL_POWER_RUNIC_POWER = SPELL_POWER_RUNIC_POWER or 6

local energy_types = {
	[SPELL_POWER_MANA] = true,
	[SPELL_POWER_RAGE] = true,
	[SPELL_POWER_ENERGY] = true,
	[SPELL_POWER_RUNIC_POWER] = true,
}

	_detalhes.resource_strings = {

	}

	_detalhes.resource_icons = {

	}

	-- ~energy ~resource
	function parser:energize(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, powertype)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		--print(who_name, alvo_name, spellid, spellname, spelltype, amount, powertype)

		if(not who_name) then
			who_name = "[*] "..spellname
		elseif(not alvo_name) then
			return
		end

	------------------------------------------------------------------------------------------------
	--> check if is energy or resource

		--> check if is valid
		if(not energy_types[powertype]) then
			return
		end

		--[[statistics]]-- _detalhes.statistics.energy_calls = _detalhes.statistics.energy_calls + 1

		_current_energy_container.need_refresh = true

--print(who_name, spellid, spellname, spelltype, amount, powertype, p6, p7) powertype = 0 p6 = 17
--4/27 13:45:54.903  SPELL_ENERGIZE,
--Player-3208-0A085522,"Licelystiri-Nemesis",0x511,0x0,
--Player-3208-0A085522,"Licelystiri-Nemesis",0x511,0x0,
--162243,"Demon's Bite",0x1,Player-3208-0A085522,0000000000000000,233158,242700,3555,662,17,70,100,0,1030.46,3134.93,660,28,0,17,100

------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local este_jogador, meu_dono = energy_cache[who_name]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_energy_container:PegarCombatente(who_serial, who_name, who_flags, true)
			este_jogador.powertype = powertype
			if(meu_dono) then
				meu_dono.powertype = powertype
			end
			if(not meu_dono) then --> se n�o for um pet, adicionar no cache
				energy_cache[who_name] = este_jogador
			end
		end

		if(not este_jogador.powertype) then
			este_jogador.powertype = powertype
		end

		--> target
		local jogador_alvo, alvo_dono = energy_cache[alvo_name]
		if(not jogador_alvo) then
			jogador_alvo, alvo_dono, alvo_name = _current_energy_container:PegarCombatente(alvo_serial, alvo_name, alvo_flags, true)
			jogador_alvo.powertype = powertype
			if(alvo_dono) then
				alvo_dono.powertype = powertype
			end
			if(not alvo_dono) then
				energy_cache[alvo_name] = jogador_alvo
			end
		end

		if(jogador_alvo.powertype ~= este_jogador.powertype) then
			--print("error: different power types: who -> ", este_jogador.powertype, " target -> ", jogador_alvo.powertype)
			return
		end

		este_jogador.last_event = _tempo

	------------------------------------------------------------------------------------------------
	--> amount add

		--amount = amount - overpower

		--> add to targets
		este_jogador.targets[alvo_name] =(este_jogador.targets[alvo_name] or 0) + amount

		--> add to combat total
		_current_total[3][powertype] = _current_total[3][powertype] + amount

		if(este_jogador.grupo) then
			_current_gtotal[3][powertype] = _current_gtotal[3][powertype] + amount
		end

		--> regen produced amount
		este_jogador.total = este_jogador.total + amount

		--> target regenerated amount
		jogador_alvo.received = jogador_alvo.received + amount

		--> owner
		if(meu_dono) then
			meu_dono.total = meu_dono.total + amount
		end

		--> actor spells table
		local spell = este_jogador.spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.spells:PegaHabilidade(spellid, true, token)
		end

		--return spell:Add(alvo_serial, alvo_name, alvo_flags, amount, who_name, powertype)
		return spell_energy_func(spell, alvo_serial, alvo_name, alvo_flags, amount, who_name, powertype)
	end



-----------------------------------------------------------------------------------------------------------------------------------------
	--> MISC 	search key: ~cooldown											|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:add_defensive_cooldown(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local este_jogador, meu_dono = misc_cache[who_name]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente(who_serial, who_name, who_flags, true)
			if(not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache[who_name] = este_jogador
			end
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		if(not este_jogador.cooldowns_defensive) then
			este_jogador.cooldowns_defensive = _detalhes:GetOrderNumber(who_name)
			este_jogador.cooldowns_defensive_targets = {}
			este_jogador.cooldowns_defensive_spells = container_habilidades:NovoContainer(container_misc) --> cria o container das habilidades
		end

	------------------------------------------------------------------------------------------------
	--> add amount

		--> actor cooldowns used
		este_jogador.cooldowns_defensive = este_jogador.cooldowns_defensive + 1

		--> combat totals
		_current_total[4].cooldowns_defensive = _current_total[4].cooldowns_defensive + 1

		if(este_jogador.grupo) then
			_current_gtotal[4].cooldowns_defensive = _current_gtotal[4].cooldowns_defensive + 1

			if(who_name == alvo_name) then

				local damage_actor = damage_cache[who_serial]
				if(not damage_actor) then --> pode ser um desconhecido ou um pet
					damage_actor = _current_damage_container:PegarCombatente(who_serial, who_name, who_flags, true)
					if(who_flags) then --> se n�o for um pet, adicionar no cache
						damage_cache[who_serial] = damage_actor
					end
				end

				--> last events
				local t = last_events_cache[who_name]

				if(not t) then
					t = _current_combat:CreateLastEventsTable(who_name)
				end

				local i = t.n
				local this_event = t[i]

				this_event[1] = 1 --> true if this is a damage || false for healing || 1 for cooldown
				this_event[2] = spellid --> spellid || false if this is a battle ress line
				this_event[3] = 1 --> amount of damage or healing
				this_event[4] = time --> parser time
				this_event[5] = _UnitHealth(who_name) --> current unit heal
				this_event[6] = who_name --> source name

				i = i + 1
				if(i == _death_event_amt+1) then
					t.n = 1
				else
					t.n = i
				end

				este_jogador.last_cooldown = {time, spellid}

			end

		end

		--> update last event
		este_jogador.last_event = _tempo

		--> actor targets
		este_jogador.cooldowns_defensive_targets[alvo_name] =(este_jogador.cooldowns_defensive_targets[alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.cooldowns_defensive_spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.cooldowns_defensive_spells:PegaHabilidade(spellid, true, token)
		end

		if(_hook_cooldowns) then
			--> send event to registred functions
			for _, func in _ipairs(_hook_cooldowns_container) do
				func(nil, token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname)
			end
		end

		return spell_misc_func(spell, alvo_serial, alvo_name, alvo_flags, who_name, token, "BUFF_OR_DEBUFF", "COOLDOWN")
	end


	--serach key: ~interrupts
	function parser:interrupt(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if(not who_name) then
			who_name = "[*] "..spellname
		elseif(not alvo_name) then
			return
		end

		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local este_jogador, meu_dono = misc_cache[who_name]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente(who_serial, who_name, who_flags, true)
			if(not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache[who_name] = este_jogador
			end
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if(not este_jogador.interrupt) then
			este_jogador.interrupt = _detalhes:GetOrderNumber(who_name)
			este_jogador.interrupt_targets = {}
			este_jogador.interrupt_spells = container_habilidades:NovoContainer(container_misc)
			este_jogador.interrompeu_oque = {}
		end

	------------------------------------------------------------------------------------------------
	--> add amount

		--> actor interrupt amount
		este_jogador.interrupt = este_jogador.interrupt + 1

		--> combat totals
		_current_total[4].interrupt = _current_total[4].interrupt + 1

		if(este_jogador.grupo) then
			_current_gtotal[4].interrupt = _current_gtotal[4].interrupt + 1
		end

		--> update last event
		este_jogador.last_event = _tempo

		--> spells interrupted
		este_jogador.interrompeu_oque[extraSpellID] =(este_jogador.interrompeu_oque[extraSpellID] or 0) + 1

		--> actor targets
		este_jogador.interrupt_targets[alvo_name] =(este_jogador.interrupt_targets[alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.interrupt_spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.interrupt_spells:PegaHabilidade(spellid, true, token)
		end
		spell_misc_func(spell, alvo_serial, alvo_name, alvo_flags, who_name, token, extraSpellID, extraSpellName)

		--> verifica se tem dono e adiciona o interrupt para o dono
		if(meu_dono) then

			if(not meu_dono.interrupt) then
				meu_dono.interrupt = _detalhes:GetOrderNumber(who_name)
				meu_dono.interrupt_targets = {}
				meu_dono.interrupt_spells = container_habilidades:NovoContainer(container_misc)
				meu_dono.interrompeu_oque = {}
			end

			-- adiciona ao total
			meu_dono.interrupt = meu_dono.interrupt + 1

			-- adiciona aos alvos
			meu_dono.interrupt_targets[alvo_name] =(meu_dono.interrupt_targets[alvo_name] or 0) + 1

			-- update last event
			meu_dono.last_event = _tempo

			-- spells interrupted
			meu_dono.interrompeu_oque[extraSpellID] =(meu_dono.interrompeu_oque[extraSpellID] or 0) + 1

			--> pet interrupt
			if(_hook_interrupt) then
				for _, func in _ipairs(_hook_interrupt_container) do
					func(nil, token, time, meu_dono.serial, meu_dono.nome, meu_dono.flag_original, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)
				end
			end
		else
			--> player interrupt
			if(_hook_interrupt) then
				for _, func in _ipairs(_hook_interrupt_container) do
					func(nil, token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)
				end
			end
		end

	end

	--> search key: ~spellcast ~castspell ~cast
	function parser:spellcast(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		--> only capture if is in combat
		if(not _in_combat) then
			return
		end

		if(not who_name) then
			who_name = "[*] " .. spellname
		end

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor

		local este_jogador, meu_dono = misc_cache[who_serial] or misc_cache_pets[who_serial] or misc_cache[who_name], misc_cache_petsOwners[who_serial]
		--local este_jogador = misc_cache[who_name]

		if(not este_jogador) then

			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente(who_serial, who_name, who_flags, true)

			if(meu_dono) then --> � um pet
				if(who_serial ~= "") then
					misc_cache_pets[who_serial] = este_jogador
					misc_cache_petsOwners[who_serial] = meu_dono
				end

				--conferir se o dono j� esta no cache
				if(not misc_cache[meu_dono.serial] and meu_dono.serial ~= "") then
					misc_cache[meu_dono.serial] = meu_dono
				end
			else
				if(who_flags) then
					misc_cache[who_name] = este_jogador
				end
			end
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		local spell_cast = este_jogador.spell_cast
		if(not spell_cast) then
			este_jogador.spell_cast = {[spellid] = 1}
		else
			spell_cast[spellid] =(spell_cast[spellid] or 0) + 1
		end

	------------------------------------------------------------------------------------------------
	--> record cooldowns cast which can't track with buff applyed.

		--> foi um jogador que castou
		if(raid_members_cache[who_serial]) then
			--> check if is a cooldown :D
			if(defensive_cooldowns[spellid]) then
				--> usou cooldown
				if(not alvo_name) then
					if(DetailsFramework.CooldownsDeffense[spellid]) then
						alvo_name = who_name

					elseif(DetailsFramework.CooldownsRaid[spellid]) then
						alvo_name = Loc["STRING_RAID_WIDE"]

					else
						alvo_name = "--x--x--"
					end
				end
				return parser:add_defensive_cooldown(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname)
			end

		else
			--> enemy successful casts(not interrupted)
			if(_bit_band(who_flags, 0x00000040) ~= 0 and who_name) then --> byte 2 = 4(enemy)
				--> damager
				local este_jogador = damage_cache[who_serial]
				if(not este_jogador) then
					este_jogador = _current_damage_container:PegarCombatente(who_serial, who_name, who_flags, true)
				end
				--> actor spells table
				local spell = este_jogador.spells._ActorTable[spellid]
				if(not spell) then
					spell = este_jogador.spells:PegaHabilidade(spellid, true, token)
				end
				spell.successful_casted = spell.successful_casted + 1
			end
			return
		end
	end


	--serach key: ~dispell
	function parser:dispell(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool, auraType)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		--> esta dando erro onde o nome � NIL, fazendo um fix para isso
		if(not who_name) then
			who_name = "[*] "..extraSpellName
		end
		if(not alvo_name) then
			alvo_name = "[*] "..spellid
		end

		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors]
		local este_jogador, meu_dono = misc_cache[who_name]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente(who_serial, who_name, who_flags, true)
			if(not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache[who_name] = este_jogador
			end
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if(not este_jogador.dispell) then
			--> constr�i aqui a tabela dele
			este_jogador.dispell = _detalhes:GetOrderNumber(who_name)
			este_jogador.dispell_targets = {}
			este_jogador.dispell_spells = container_habilidades:NovoContainer(container_misc)
			este_jogador.dispell_oque = {}
		end

	------------------------------------------------------------------------------------------------
	--> spell reflection
		if reflection_dispelid[spellid] then
			--> this aura could've been reflected to the caster after the dispel
			--> save data about whom was dispelled by who and what spell it was
			reflection_dispels[alvo_serial] = reflection_dispels[alvo_serial] or {}
			reflection_dispels[alvo_serial][extraSpellID] = {
				who_serial = who_serial,
				who_name = who_name,
				who_flags = who_flags,
				spellid = spellid,
				spellname = spellname,
				spelltype = spelltype,
			}
		end
	------------------------------------------------------------------------------------------------
	--> add amount

		--> last event update
		este_jogador.last_event = _tempo

		--> total dispells in combat
		_current_total[4].dispell = _current_total[4].dispell + 1

		if(este_jogador.grupo) then
			_current_gtotal[4].dispell = _current_gtotal[4].dispell + 1
		end

		--> actor dispell amount
		este_jogador.dispell = este_jogador.dispell + 1

		--> dispell what
		if(extraSpellID) then
			este_jogador.dispell_oque[extraSpellID] =(este_jogador.dispell_oque[extraSpellID] or 0) + 1
		end

		--> actor targets
		este_jogador.dispell_targets[alvo_name] =(este_jogador.dispell_targets[alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.dispell_spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.dispell_spells:PegaHabilidade(spellid, true, token)
		end
		spell_misc_func(spell, alvo_serial, alvo_name, alvo_flags, who_name, token, extraSpellID, extraSpellName)

		--> verifica se tem dono e adiciona o interrupt para o dono
		if(meu_dono) then
			if(not meu_dono.dispell) then
				meu_dono.dispell = _detalhes:GetOrderNumber(who_name)
				meu_dono.dispell_targets = {}
				meu_dono.dispell_spells = container_habilidades:NovoContainer(container_misc)
				meu_dono.dispell_oque = {}
			end

			meu_dono.dispell = meu_dono.dispell + 1

			meu_dono.dispell_targets[alvo_name] =(meu_dono.dispell_targets[alvo_name] or 0) + 1

			meu_dono.last_event = _tempo

			if(extraSpellID) then
				meu_dono.dispell_oque[extraSpellID] =(meu_dono.dispell_oque[extraSpellID] or 0) + 1
			end
		end
	end

	--serach key: ~ress
	function parser:ress(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if(_bit_band(who_flags, AFFILIATION_GROUP) == 0) then
			return
		end

		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local este_jogador, meu_dono = misc_cache[who_name]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente(who_serial, who_name, who_flags, true)
			if(not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache[who_name] = este_jogador
			end
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if(not este_jogador.ress) then
			este_jogador.ress = _detalhes:GetOrderNumber(who_name)
			este_jogador.ress_targets = {}
			este_jogador.ress_spells = container_habilidades:NovoContainer(container_misc) --> cria o container das habilidades usadas para interromper
		end

	------------------------------------------------------------------------------------------------
	--> add amount

		--> update last event
		este_jogador.last_event = _tempo

		--> combat ress total
		_current_total[4].ress = _current_total[4].ress + 1

		if(este_jogador.grupo) then
			_current_combat.totals_grupo[4].ress = _current_combat.totals_grupo[4].ress+1
		end

		--> add ress amount
		este_jogador.ress = este_jogador.ress + 1

		--> add battle ress
		if(_UnitAffectingCombat(who_name)) then
			--> procura a �ltima morte do alvo na tabela do combate:
			for i = 1, #_current_combat.last_events_tables do
				if(_current_combat.last_events_tables[i][3] == alvo_name) then

					local deadLog = _current_combat.last_events_tables[i][1]
					local jaTem = false
					for _, evento in _ipairs(deadLog) do
						if(evento[1] and not evento[3]) then
							jaTem = true
						end
					end

					if(not jaTem) then
						_table_insert(_current_combat.last_events_tables[i][1], 1, {
							2,
							spellid,
							1,
							time,
							_UnitHealth(alvo_name),
							who_name
						})
						break
					end
				end
			end

			if(_hook_battleress) then
				for _, func in _ipairs(_hook_battleress_container) do
					func(nil, token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname)
				end
			end

		end

		--> actor targets
		este_jogador.ress_targets[alvo_name] =(este_jogador.ress_targets[alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.ress_spells._ActorTable[spellid]
		if(not spell) then
			spell = este_jogador.ress_spells:PegaHabilidade(spellid, true, token)
		end
		return spell_misc_func(spell, alvo_serial, alvo_name, alvo_flags, who_name, token, spellid, spellname)
	end

	--serach key: ~cc
	function parser:break_cc(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool, auraType)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		if(not cc_spell_list[spellid]) then
			return
			--print("NO CC:", spellid, spellname, extraSpellID, extraSpellName)
		end

		if(_bit_band(who_flags, AFFILIATION_GROUP) == 0) then
			return
		end

		if(not spellname) then
			spellname = "Melee"
		end

		if(not alvo_name) then
			--> no target name, just quit
			return

		elseif(not who_name) then
			--> no actor name, use spell name instead
			who_name = "[*] " .. spellname
			who_flags = 0xa48
			who_serial = ""
		end

		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		local este_jogador, meu_dono = misc_cache[who_name]
		if(not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente(who_serial, who_name, who_flags, true)
			if(not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache[who_name] = este_jogador
			end
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if(not este_jogador.cc_break) then
			--> constr�i aqui a tabela dele
			este_jogador.cc_break = _detalhes:GetOrderNumber(who_name)
			este_jogador.cc_break_targets = {}
			este_jogador.cc_break_spells = container_habilidades:NovoContainer(container_misc)
			este_jogador.cc_break_oque = {}
		end

	------------------------------------------------------------------------------------------------
	--> add amount

		--> update last event
		este_jogador.last_event = _tempo

		--> combat cc break total
		_current_total[4].cc_break = _current_total[4].cc_break + 1

		if(este_jogador.grupo) then
			_current_combat.totals_grupo[4].cc_break = _current_combat.totals_grupo[4].cc_break+1
		end

		--> add amount
		este_jogador.cc_break = este_jogador.cc_break + 1

		--> broke what
		este_jogador.cc_break_oque[spellid] =(este_jogador.cc_break_oque[spellid] or 0) + 1

		--> actor targets
		este_jogador.cc_break_targets[alvo_name] =(este_jogador.cc_break_targets[alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.cc_break_spells._ActorTable[extraSpellID]
		if(not spell) then
			spell = este_jogador.cc_break_spells:PegaHabilidade(extraSpellID, true, token)
		end
		return spell_misc_func(spell, alvo_serial, alvo_name, alvo_flags, who_name, token, spellid, spellname)
	end

	--serach key: ~dead ~death ~morte
	function parser:dead(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if(not alvo_name) then
			return
		end

	------------------------------------------------------------------------------------------------
	--> build dead
		if _bit_band(alvo_flags, OBJECT_CONTROL_NPC) ~= 0 then
			local npcID = npcid_cache[alvo_serial]
			if npcID then
				_table_insert(_detalhes.cache_dead_npc, npcID)
			end
		end

		if(_in_combat and alvo_flags and _bit_band(alvo_flags, 0x00000008) ~= 0) then -- and _in_combat --byte 1 = 8(AFFILIATION_OUTSIDER)
			--> outsider death while in combat

			--> frags

				if(_detalhes.only_pvp_frags and(_bit_band(alvo_flags, 0x00000400) == 0 or(_bit_band(alvo_flags, 0x00000040) == 0 and _bit_band(alvo_flags, 0x00000020) == 0))) then --byte 2 = 4(HOSTILE) byte 3 = 4(OBJECT_TYPE_PLAYER)
					return
				end

				if(not _current_combat.frags[alvo_name]) then
					_current_combat.frags[alvo_name] = 1
				else
					_current_combat.frags[alvo_name] = _current_combat.frags[alvo_name] + 1
				end

				_current_combat.frags_need_refresh = true

		--> player death
		elseif(not _UnitIsFeignDeath(alvo_name)) then
			if(
				--> player in your group
				_bit_band(alvo_flags, AFFILIATION_GROUP) ~= 0 and
				--> must be a player
				_bit_band(alvo_flags, OBJECT_TYPE_PLAYER) ~= 0 and
				--> must be in combat
				_in_combat
			) then

				if(ignore_death[alvo_name]) then
					ignore_death[alvo_name] = nil
					return
				end

				if(alvo_name == _detalhes.playername) then
					--print("DEATH", GetTime())

					if(_detalhes.LatestCombatDone and _detalhes.LatestCombatDone+0.2 > GetTime()) then
					--	print("Eh Maior que 0.2")
					end
				end

				_current_misc_container.need_refresh = true

				--> combat totals
				_current_total[4].dead = _current_total[4].dead + 1
				_current_gtotal[4].dead = _current_gtotal[4].dead + 1

				--> main actor no container de misc que ir� armazenar a morte
				local este_jogador, meu_dono = misc_cache[alvo_name]
				if(not este_jogador) then --> pode ser um desconhecido ou um pet
					este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente(alvo_serial, alvo_name, alvo_flags, true)
					if(not meu_dono) then --> se n�o for um pet, adicionar no cache
						misc_cache[alvo_name] = este_jogador
					end
				end

				--> objeto da morte
				local esta_morte = {}

				--> add events
				local t = last_events_cache[alvo_name]
				if(not t) then
					t = _current_combat:CreateLastEventsTable(alvo_name)
				end

				--lesses index = older / higher index = newer

				local last_index = t.n --or 'next index'
				if(last_index < _death_event_amt+1 and not t[last_index][4]) then
					for i = 1, last_index-1 do
						if(t[i][4] and t[i][4]+_death_event_amt > time) then
							_table_insert(esta_morte, t[i])
						end
					end
				else
					for i = last_index, _death_event_amt do --next index to 16
						if(t[i][4] and t[i][4]+_death_event_amt > time) then
							_table_insert(esta_morte, t[i])
						end
					end
					for i = 1, last_index-1 do --1 to latest index
						if(t[i][4] and t[i][4]+_death_event_amt > time) then
							_table_insert(esta_morte, t[i])
						end
					end
				end

				if(_hook_deaths) then
					--> send event to registred functions
					local death_at = _GetTime() - _current_combat:GetStartTime()
					local max_health = _UnitHealthMax(alvo_name)

					for _, func in _ipairs(_hook_deaths_container) do
						local new_death_table = table_deepcopy(esta_morte)
						local successful, errortext = pcall(func, nil, token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, new_death_table, este_jogador.last_cooldown, death_at, max_health)
						if(not successful) then
							_detalhes:Msg("error occurred on a death hook function:", errortext)
						end
						--func(nil, token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, new_death_table, este_jogador.last_cooldown, death_at, max_health)
					end
				end

				--if(_detalhes.deadlog_limit and #esta_morte > _detalhes.deadlog_limit) then
				--	while(#esta_morte > _detalhes.deadlog_limit) do
				--		_table_remove(esta_morte, 1)
				--	end
				--end

				if(este_jogador.last_cooldown) then
					local t = {}
					t[1] = 3 --> true if this is a damage || false for healing || 1 for cooldown usage || 2 for last cooldown
					t[2] = este_jogador.last_cooldown[2] --> spellid || false if this is a battle ress line
					t[3] = 1 --> amount of damage or healing
					t[4] = este_jogador.last_cooldown[1] --> parser time
					t[5] = 0 --> current unit heal
					t[6] = alvo_name --> source name
					esta_morte[#esta_morte+1] = t
				else
					local t = {}
					t[1] = 3 --> true if this is a damage || false for healing || 1 for cooldown usage || 2 for last cooldown
					t[2] = 0 --> spellid || false if this is a battle ress line
					t[3] = 0 --> amount of damage or healing
					t[4] = 0 --> parser time
					t[5] = 0 --> current unit heal
					t[6] = alvo_name --> source name
					esta_morte[#esta_morte+1] = t
				end

				local decorrido = _GetTime() - _current_combat:GetStartTime()
				local minutos, segundos = _math_floor(decorrido/60), _math_floor(decorrido%60)

				local t = {esta_morte, time, este_jogador.nome, este_jogador.classe, _UnitHealthMax(alvo_name), minutos.."m "..segundos.."s", ["dead"] = true,["last_cooldown"] = este_jogador.last_cooldown,["dead_at"] = decorrido}

				_table_insert(_current_combat.last_events_tables, #_current_combat.last_events_tables+1, t)

				--> reseta a pool
				last_events_cache[alvo_name] = nil
			end
		end
	end

	function parser:environment(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, env_type, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing)

		local spelid

		if(env_type == "Falling" or env_type == "FALLING") then
			who_name = ENVIRONMENTAL_FALLING_NAME
			spelid = 3
		elseif(env_type == "Drowning" or env_type == "DROWNING") then
			who_name = ENVIRONMENTAL_DROWNING_NAME
			spelid = 4
		elseif(env_type == "Fatigue" or env_type == "FATIGUE") then
			who_name = ENVIRONMENTAL_FATIGUE_NAME
			spelid = 5
		elseif(env_type == "Fire" or env_type == "FIRE") then
			who_name = ENVIRONMENTAL_FIRE_NAME
			spelid = 6
		elseif(env_type == "Lava" or env_type == "LAVA") then
			who_name = ENVIRONMENTAL_LAVA_NAME
			spelid = 7
		elseif(env_type == "Slime" or env_type == "SLIME") then
			who_name = ENVIRONMENTAL_SLIME_NAME
			spelid = 8
		end

		if absorbed and absorbed > 0 and alvo_name and escudo[alvo_name] and who_name then
			parser:heal_absorb(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, absorbed, 0)
		end

		return parser:spell_dmg(token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spelid or 1, env_type, 00000003, amount, -1, 1) --> localize-me
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

local token_list = {
	-- neutral
	["SPELL_SUMMON"] = parser.summon,
	["SPELL_CREATE"] = parser.summon,
--	["SPELL_CAST_FAILED"] = parser.spell_fail
}

--serach key: ~capture
_detalhes.capture_types = {"damage", "heal", "energy", "miscdata", "aura", "spellcast"}
_detalhes.capture_schedules = {}

function _detalhes:CaptureIsAllEnabled()
	for _, _thisType in _ipairs(_detalhes.capture_types) do
		if not _detalhes.capture_real[_thisType] then
			return false
		end
	end
	return true
end

function _detalhes:CaptureIsEnabled(capture)
	if _detalhes.capture_real[capture] then
		return true
	end
	return false
end

function _detalhes:CaptureRefresh()
	for _, _thisType in _ipairs(_detalhes.capture_types) do
		if(_detalhes.capture_current[_thisType]) then
			_detalhes:CaptureEnable(_thisType)
		else
			_detalhes:CaptureDisable(_thisType)
		end
	end
end

function _detalhes:CaptureGet(capture_type)
	return _detalhes.capture_real[capture_type]
end

function _detalhes:CaptureSet(on_off, capture_type, real, time)
	if not on_off then
		on_off = _detalhes.capture_real[capture_type]
	end

	if real then
		--> hard switch
		_detalhes.capture_real[capture_type] = on_off
		_detalhes.capture_current[capture_type] = on_off
	else
		--> soft switch
		_detalhes.capture_current[capture_type] = on_off

		if time then
			local schedule_id = math.random(1, 10000000)
			local new_schedule = _detalhes:ScheduleTimer("CaptureTimeout", time, {capture_type, schedule_id})
			tinsert(_detalhes.capture_schedules, {new_schedule, schedule_id})
		end
	end

	_detalhes:CaptureRefresh()
end

function _detalhes:CancelAllCaptureSchedules()
	for i = 1, #_detalhes.capture_schedules do
		local schedule_table, schedule_id = unpack(_detalhes.capture_schedules[i])
		_detalhes:CancelTimer(schedule_table)
	end

	_table_wipe(_detalhes.capture_schedules)
end

function _detalhes:CaptureTimeout(table)
	local capture_type, schedule_id = unpack(table)
	_detalhes.capture_current[capture_type] = _detalhes.capture_real[capture_type]
	_detalhes:CaptureRefresh()

	for index, table in ipairs(_detalhes.capture_schedules) do
		local id = table[2]
		if schedule_id == id then
			tremove(_detalhes.capture_schedules, index)
			break
		end
	end
end

function _detalhes:CaptureDisable(capture_type)
	capture_type = string.lower(capture_type)

	if capture_type == "damage" then
		token_list["SPELL_PERIODIC_DAMAGE"] = nil
		token_list["SPELL_EXTRA_ATTACKS"] = nil
		token_list["SPELL_DAMAGE"] = nil
		token_list["SWING_DAMAGE"] = nil
		token_list["RANGE_DAMAGE"] = nil
		token_list["DAMAGE_SHIELD"] = nil
		token_list["DAMAGE_SPLIT"] = nil
		token_list["RANGE_MISSED"] = nil
		token_list["SWING_MISSED"] = nil
		token_list["SPELL_MISSED"] = nil
		token_list["SPELL_BUILDING_MISSED"] = nil
		token_list["SPELL_PERIODIC_MISSED"] = nil
		token_list["DAMAGE_SHIELD_MISSED"] = nil
		token_list["ENVIRONMENTAL_DAMAGE"] = nil
		token_list["SPELL_BUILDING_DAMAGE"] = nil
	elseif capture_type == "heal" then
		token_list["SPELL_HEAL"] = nil
		token_list["SPELL_PERIODIC_HEAL"] = nil
		token_list["SPELL_HEAL_ABSORBED"] = nil
		_recording_healing = false
	elseif capture_type == "aura" then
		token_list["SPELL_AURA_APPLIED"] = parser.buff
		token_list["SPELL_AURA_REMOVED"] = parser.unbuff
		token_list["SPELL_AURA_REFRESH"] = parser.buff_refresh
		token_list["SPELL_AURA_APPLIED_DOSE"] = parser.buff_refresh
		_recording_buffs_and_debuffs = false
	elseif capture_type == "energy" then
		token_list["SPELL_ENERGIZE"] = nil
		token_list["SPELL_PERIODIC_ENERGIZE"] = nil
	elseif capture_type == "spellcast" then
		token_list["SPELL_CAST_SUCCESS"] = nil
		token_list["SPELL_CAST_START"] = nil
	elseif capture_type == "miscdata" then
		-- dispell
		token_list["SPELL_DISPEL"] = nil
		token_list["SPELL_STOLEN"] = nil
		-- cc broke
		token_list["SPELL_AURA_BROKEN"] = nil
		token_list["SPELL_AURA_BROKEN_SPELL"] = nil
		-- ress
		token_list["SPELL_RESURRECT"] = nil
		-- interrupt
		token_list["SPELL_INTERRUPT"] = nil
		-- dead
		token_list["UNIT_DIED"] = nil
		token_list["UNIT_DESTROYED"] = nil
	end
end

--SPELL_DRAIN --> need research
--SPELL_LEECH --> need research
--SPELL_PERIODIC_DRAIN --> need research
--SPELL_PERIODIC_LEECH --> need research
--SPELL_DISPEL_FAILED --> need research
--SPELL_BUILDING_HEAL --> need research

function _detalhes:CaptureEnable(capture_type)
	capture_type = string.lower(capture_type)

	if capture_type == "damage" then
		token_list["SPELL_PERIODIC_DAMAGE"] = parser.spell_dmg
		token_list["SPELL_EXTRA_ATTACKS"] = parser.spell_dmg
		token_list["SPELL_DAMAGE"] = parser.spell_dmg
		token_list["SPELL_BUILDING_DAMAGE"] = parser.spell_dmg
		token_list["SWING_DAMAGE"] = parser.swing
		token_list["RANGE_DAMAGE"] = parser.range
		token_list["DAMAGE_SHIELD"] = parser.spell_dmg
		token_list["DAMAGE_SPLIT"] = parser.spell_dmg
		token_list["RANGE_MISSED"] = parser.rangemissed
		token_list["SWING_MISSED"] = parser.swingmissed
		token_list["SPELL_MISSED"] = parser.missed
		token_list["SPELL_PERIODIC_MISSED"] = parser.missed
		token_list["SPELL_BUILDING_MISSED"] = parser.missed
		token_list["DAMAGE_SHIELD_MISSED"] = parser.missed
		token_list["ENVIRONMENTAL_DAMAGE"] = parser.environment
	elseif capture_type == "heal" then
		token_list["SPELL_HEAL"] = parser.heal
		token_list["SPELL_PERIODIC_HEAL"] = parser.heal
		_recording_healing = true
	elseif capture_type == "aura" then
		token_list["SPELL_AURA_APPLIED"] = parser.buff
		token_list["SPELL_AURA_REMOVED"] = parser.unbuff
		token_list["SPELL_AURA_REFRESH"] = parser.buff_refresh
		token_list["SPELL_AURA_APPLIED_DOSE"] = parser.buff_refresh
		_recording_buffs_and_debuffs = true
	elseif capture_type == "energy" then
		token_list["SPELL_ENERGIZE"] = parser.energize
		token_list["SPELL_PERIODIC_ENERGIZE"] = parser.energize
	elseif capture_type == "spellcast" then
		token_list["SPELL_CAST_SUCCESS"] = parser.spellcast
		token_list["SPELL_CAST_START"] = parser.spellcast
	elseif capture_type == "miscdata" then
		-- dispell
		token_list["SPELL_DISPEL"] = parser.dispell
		token_list["SPELL_STOLEN"] = parser.dispell
		-- cc broke
		token_list["SPELL_AURA_BROKEN"] = parser.break_cc
		token_list["SPELL_AURA_BROKEN_SPELL"] = parser.break_cc
		-- ress
		token_list["SPELL_RESURRECT"] = parser.ress
		-- interrupt
		token_list["SPELL_INTERRUPT"] = parser.interrupt
		-- dead
		token_list["UNIT_DIED"] = parser.dead
		token_list["UNIT_DESTROYED"] = parser.dead
	end
end

parser.original_functions = {
	["spell_dmg"] = parser.spell_dmg,
	["swing"] = parser.swing,
	["range"] = parser.range,
	["rangemissed"] = parser.rangemissed,
	["swingmissed"] = parser.swingmissed,
	["missed"] = parser.missed,
	["environment"] = parser.environment,
	["heal"] = parser.heal,
	["buff"] = parser.buff,
	["unbuff"] = parser.unbuff,
	["buff_refresh"] = parser.buff_refresh,
	["energize"] = parser.energize,
	["spellcast"] = parser.spellcast,
	["dispell"] = parser.dispell,
	["break_cc"] = parser.break_cc,
	["ress"] = parser.ress,
	["interrupt"] = parser.interrupt,
	["dead"] = parser.dead,
}

function parser:SetParserFunction(token, func)
	if parser.original_functions[token] then
		if type(func) == "function" then
			parser[token] = func
		else
			parser[token] = parser.original_functions[token]
		end

		parser:RefreshFunctions()
	else
		return _detalhes:Msg("Invalid Token for SetParserFunction.")
	end
end

local all_parser_tokens = {
	["SPELL_PERIODIC_DAMAGE"] = "spell_dmg",
	["SPELL_EXTRA_ATTACKS"] = "spell_dmg",
	["SPELL_DAMAGE"] = "spell_dmg",
	["SPELL_BUILDING_DAMAGE"] = "spell_dmg",
	["SWING_DAMAGE"] = "swing",
	["RANGE_DAMAGE"] = "range",
	["DAMAGE_SHIELD"] = "spell_dmg",
	["DAMAGE_SPLIT"] = "spell_dmg",
	["RANGE_MISSED"] = "rangemissed",
	["SWING_MISSED"] = "swingmissed",
	["SPELL_MISSED"] = "missed",
	["SPELL_PERIODIC_MISSED"] = "missed",
	["SPELL_BUILDING_MISSED"] = "missed",
	["DAMAGE_SHIELD_MISSED"] = "missed",
	["ENVIRONMENTAL_DAMAGE"] = "environment",

	["SPELL_HEAL"] = "heal",
	["SPELL_PERIODIC_HEAL"] = "heal",

	["SPELL_AURA_APPLIED"] = "buff",
	["SPELL_AURA_REMOVED"] = "unbuff",
	["SPELL_AURA_REFRESH"] = "buff_refresh",
	["SPELL_AURA_APPLIED_DOSE"] = "buff_refresh",
	["SPELL_ENERGIZE"] = "energize",
	["SPELL_PERIODIC_ENERGIZE"] = "energize",

	["SPELL_CAST_SUCCESS"] = "spellcast",
	["SPELL_CAST_START"] = "spellcast",
	["SPELL_DISPEL"] = "dispell",
	["SPELL_STOLEN"] = "dispell",
	["SPELL_AURA_BROKEN"] = "break_cc",
	["SPELL_AURA_BROKEN_SPELL"] = "break_cc",
	["SPELL_RESURRECT"] = "ress",
	["SPELL_INTERRUPT"] = "interrupt",
	["UNIT_DIED"] = "dead",
	["UNIT_DESTROYED"] = "dead",
}

function parser:RefreshFunctions()
	for CLUE_ID, token in pairs(all_parser_tokens) do
		if(token_list[CLUE_ID]) then --> not disabled
			token_list[CLUE_ID] = parser[token]
		end
	end
end

function _detalhes:CallWipe(from_slash)
	if _detalhes.wipe_called then
		if from_slash then
			return _detalhes:Msg(Loc["STRING_WIPE_ERROR1"])
		else
			return
		end
	elseif not _detalhes.encounter_table.id then
		if from_slash then
			return _detalhes:Msg(Loc["STRING_WIPE_ERROR2"])
		else
			return
		end
	end

	local eTable = _detalhes.encounter_table

	--> finish the encounter
	local successful_ended = _detalhes.parser_functions:ENCOUNTER_END(eTable.id, eTable.name, eTable.diff, eTable.size, 0)
	if successful_ended then
		--> we wiped
		_detalhes.wipe_called = true

		--> cancel the on going captures schedules
		_detalhes:CancelAllCaptureSchedules()

		--> disable it
		_detalhes:CaptureSet(false, "damage", false)
		_detalhes:CaptureSet(false, "energy", false)
		_detalhes:CaptureSet(false, "aura", false)
		_detalhes:CaptureSet(false, "energy", false)
		_detalhes:CaptureSet(false, "spellcast", false)

		if from_slash then
			if UnitIsGroupLeader("player") then
				_detalhes:SendHomeRaidData("WI")
			end
		end

		local lower_instance = _detalhes:GetLowerInstanceNumber()
		if lower_instance then
			lower_instance = _detalhes:GetInstance(lower_instance)
			lower_instance:InstanceAlert(Loc["STRING_WIPE_ALERT"], {[[Interface\CHARACTERFRAME\UI-StateIcon]], 18, 18, false, 0.5, 1, 0, 0.5}, 4)
		end
	else
		if from_slash then
			return _detalhes:Msg(Loc["STRING_WIPE_ERROR3"])
		else
			return
		end
	end
end

-- PARSER
--serach key: ~parser ~events ~start ~inicio

function _detalhes:FlagCurrentCombat()
	if _detalhes.is_in_battleground then
		_detalhes.tabela_vigente.pvp = true
		_detalhes.tabela_vigente.is_pvp = {name = _detalhes.zone_name, mapid = _detalhes.zone_id}
	elseif _detalhes.is_in_arena then
		_detalhes.tabela_vigente.arena = true
		_detalhes.tabela_vigente.is_arena = {name = _detalhes.zone_name, zone = _detalhes.zone_name, mapid = _detalhes.zone_id}
	end
end

function _detalhes:GetZoneType()
	return _detalhes.zone_type
end
function _detalhes.parser_functions:ZONE_CHANGED_NEW_AREA(...)
	return _detalhes:ScheduleTimer("Check_ZONE_CHANGED_NEW_AREA", 0.5)
end

function _detalhes:Check_ZONE_CHANGED_NEW_AREA(...)
	local zoneName, zoneType = _GetInstanceInfo()
	local zoneMapID = _GetCurrentMapAreaID()

	_detalhes.zone_type = zoneType
	_detalhes.zone_id = zoneMapID
	_detalhes.zone_name = zoneName

	_in_resting_zone = IsResting()

	_is_in_instance = false

	if zoneType == "party" or zoneType == "raid" then
		_is_in_instance = true
	end

	if _detalhes.last_zone_type ~= zoneType then
		_detalhes:SendEvent("ZONE_TYPE_CHANGED", nil, zoneType)
		_detalhes.last_zone_type = zoneType

		for index, instancia in ipairs(_detalhes.tabela_instancias) do
			if instancia.ativa and instancia.hide_in_combat_type ~= 1 then --> 1 = none, we doesn't need to call
				instancia:SetCombatAlpha(nil, nil, true)
			end
		end
	end

	-- TODO
--	if _detalhes.encounter_table and _detalhes.encounter_table.id == 36597 then
--		_table_wipe(_detalhes.encounter_table)
--		if _detalhes.debug then
--			_detalhes:Msg ("(debug) map changed with encounter table pointing to the lich king encounter, wiping the encounter table.")
--		end
--	end

	_detalhes.time_type = _detalhes.time_type_original

	_detalhes:CheckChatOnZoneChange(zoneType)

	if _detalhes.debug then
		_detalhes:Msg("(debug) zone change:", _detalhes.zone_name, "is a", _detalhes.zone_type, "zone.")
	end

	if _detalhes.is_in_arena and zoneType ~= "arena" then
		_detalhes:LeftArena()
	end

	if _detalhes.is_in_battleground and zoneType ~= "pvp" then
		_detalhes.is_in_battleground = nil
		_detalhes.time_type = _detalhes.time_type_original
	end

	if zoneType == "pvp" then --> battlegrounds
		if _detalhes.debug then
			_detalhes:Msg("(debug) zone type is now 'pvp'.")
		end

		_detalhes.is_in_battleground = true

		if _in_combat and not _current_combat.pvp then
			_detalhes:SairDoCombate()
		end

		if not _in_combat then
			_detalhes:EntrarEmCombate()
		end

		_current_combat.pvp = true
		_current_combat.is_pvp = {name = zoneName, mapid = zoneMapID}

		if _detalhes.use_battleground_server_parser then
			if _detalhes.time_type == 1 then
				_detalhes.time_type_original = 1
				_detalhes.time_type = 2
			end
		else
			if _detalhes.force_activity_time_pvp then
				_detalhes.time_type_original = _detalhes.time_type
				_detalhes.time_type = 1
			end
		end
	elseif zoneType == "arena" then
		if _detalhes.debug then
			_detalhes:Msg("(debug) zone type is now 'arena'.")
		end

		if _detalhes.force_activity_time_pvp then
			_detalhes.time_type_original = _detalhes.time_type
			_detalhes.time_type = 1
		end

		if not _detalhes.is_in_arena then
			--> reset spec cache if broadcaster requested
			if _detalhes.streamer_config.reset_spec_cache then
				wipe(_detalhes.cached_specs)
			end
		end

		_detalhes.is_in_arena = true
		_detalhes:EnteredInArena()
	else
		local inInstance = IsInInstance()
		if (zoneType == "raid" or zoneType == "party") and inInstance then
			_detalhes:CheckForAutoErase(zoneMapID)

			--> if the current raid is current tier raid, pre-load the storage database
			if zoneType == "raid" then
				if _detalhes.InstancesToStoreData[zoneMapID] then
					_detalhes.ScheduleLoadStorage()
				end
			end
		end

		if _detalhes:IsInInstance() then
			_detalhes.last_instance = zoneMapID
		end

--		if _current_combat.pvp then
--			_current_combat.pvp = false
--		end
	end

	_detalhes:DispatchAutoRunCode("on_zonechanged")

	_detalhes:SchedulePetUpdate(7)
	_detalhes:CheckForPerformanceProfile()
end

function _detalhes.parser_functions:PLAYER_ENTERING_WORLD(...)
	return _detalhes.parser_functions:ZONE_CHANGED_NEW_AREA(...)
end

-- ~encounter
function _detalhes.parser_functions:ENCOUNTER_START(encounterID, encounterName, difficultyID, raidSize)
	if _detalhes.debug then
		_detalhes:Msg("(debug) |cFFFFFF00ENCOUNTER_START|r event triggered.")
	end

	_detalhes.latest_ENCOUNTER_END = _detalhes.latest_ENCOUNTER_END or 0
	if _detalhes.latest_ENCOUNTER_END + 10 > _GetTime() then
		return
	end

	-- TEMP
	--> leave the current combat when the encounter start, if is doing a mythic plus dungeons, check if the options alows to create a dedicated segment for the boss fight
--	if (_in_combat and not _detalhes.tabela_vigente.is_boss) then
--		_detalhes:SairDoCombate()
--	end

	if not _detalhes.WhoAggroTimer and _detalhes.announce_firsthit.enabled then
		_detalhes.WhoAggroTimer = C_Timer.NewTicker(0.5, who_aggro, 1)
	end

	if IsInGuild() and IsInRaid() and _detalhes.announce_damagerecord.enabled and _detalhes.StorageLoaded then
		_detalhes.TellDamageRecord = C_Timer.NewTicker(0.6, _detalhes.PrintEncounterRecord, 1)
		_detalhes.TellDamageRecord.Boss = encounterID
		_detalhes.TellDamageRecord.Diff = difficultyID
	end

	_current_encounter_id = encounterID
	_detalhes.boss1_health_percent = 1

	local dbm_mod, dbm_time = _detalhes.encounter_table.DBM_Mod, _detalhes.encounter_table.DBM_ModTime
	_table_wipe(_detalhes.encounter_table)

	local zoneMapID = _detalhes.zone_id

	--print(encounterID, encounterName, difficultyID, raidSize)
	_detalhes.encounter_table.phase = 1

	--store the encounter time inside the encounter table for the encounter plugin
	_detalhes.encounter_table["start"] = _GetTime()
	_detalhes.encounter_table["end"] = nil
	_detalhes.encounter_table.id = encounterID
	_detalhes.encounter_table.name = encounterName
	_detalhes.encounter_table.diff = difficultyID
	_detalhes.encounter_table.size = raidSize
	_detalhes.encounter_table.zone = _detalhes.zone_name
	_detalhes.encounter_table.mapid = zoneMapID

	if dbm_mod and dbm_time == time() then --pode ser time() � usado no start pra saber se foi no mesmo segundo.
		_detalhes.encounter_table.DBM_Mod = dbm_mod
	end

	local encounter_start_table = _detalhes:GetEncounterStartInfo(zoneMapID, encounterID)
	if encounter_start_table then
		if encounter_start_table.delay then
			if type(encounter_start_table.delay) == "function" then
				local delay = encounter_start_table.delay()
				if delay then
					_detalhes.encounter_table["start"] = _GetTime() + delay
				end
			else
				_detalhes.encounter_table["start"] = _GetTime() + encounter_start_table.delay
			end
		end

		if encounter_start_table.func then
			encounter_start_table:func()
		end
	end

	local encounter_table, boss_index = _detalhes:GetBossEncounterDetailsFromEncounterId(zoneMapID, encounterID)
	if encounter_table then
		_detalhes.encounter_table.index = boss_index
	end

	_detalhes:SendEvent("COMBAT_ENCOUNTER_START", nil, encounterID, encounterName, difficultyID, raidSize)
end

function _detalhes.parser_functions:ENCOUNTER_END(...)
	if _detalhes.debug then
		_detalhes:Msg("(debug) |cFFFFFF00ENCOUNTER_END|r event triggered.")
	end

	_current_encounter_id = nil

	local _, instanceType = GetInstanceInfo() --> let's make sure it isn't a dungeon
	if _detalhes.zone_type == "party" or instanceType == "party" then
		if _detalhes.debug then
			_detalhes:Msg("(debug) the zone type is 'party', ignoring ENCOUNTER_END.")
		end
		--return --rnu encounter end for dungeons as well
	end

	local encounterID, encounterName, difficultyID, raidSize, endStatus = ...

	--_detalhes:Msg("encounter against|cFFFFC000", encounterName, "|rended.")

	if not _detalhes.encounter_table.start then
		return
	end

	_detalhes.latest_ENCOUNTER_END = _detalhes.latest_ENCOUNTER_END or 0
	if _detalhes.latest_ENCOUNTER_END + 15 > _GetTime() then
		return
	end

	--_detalhes.latest_ENCOUNTER_END = _detalhes._tempo
	_detalhes.latest_ENCOUNTER_END = _GetTime()
	_detalhes.encounter_table["end"] = _GetTime() -- 0.351

	if _in_combat then
		if endStatus then
			_detalhes.encounter_table.kill = false
			_detalhes:SairDoCombate(false, {encounterID, encounterName, difficultyID, raidSize, endStatus}) --wipe
		else
			_detalhes.encounter_table.kill = true
			_detalhes:SairDoCombate(true, {encounterID, encounterName, difficultyID, raidSize, endStatus}) --killed
		end
	else
		if (_detalhes.tabela_vigente:GetEndTime() or 0) + 2 >= _detalhes.encounter_table["end"] then
			_detalhes.tabela_vigente:SetStartTime(_detalhes.encounter_table["start"])
			_detalhes.tabela_vigente:SetEndTime(_detalhes.encounter_table["end"])
			_detalhes:AtualizaGumpPrincipal(-1, true)
		end
	end

	_detalhes:SendEvent("COMBAT_ENCOUNTER_END", nil, ...)

	_table_wipe(_detalhes.encounter_table)

	return true
end

function _detalhes.parser_functions:UNIT_PET(...)
	_detalhes.container_pets:Unpet(...)
	_detalhes:SchedulePetUpdate(1)
end

function _detalhes.parser_functions:PLAYER_REGEN_DISABLED(...)
	if _detalhes.zone_type == "pvp" and not _detalhes.use_battleground_server_parser then
		if _in_combat then
			_detalhes:SairDoCombate()
		end

		_detalhes:EntrarEmCombate()
	end

	if not _detalhes:CaptureGet("damage") then
		_detalhes:EntrarEmCombate()
	end

	--> essa parte do solo mode ainda sera usada?
	if _detalhes.solo and _detalhes.PluginCount.SOLO > 0 then --> solo mode
		local esta_instancia = _detalhes.tabela_instancias[_detalhes.solo]
		esta_instancia.atualizando = true
	end

	for index, instancia in ipairs(_detalhes.tabela_instancias) do
		if instancia.ativa and instancia.hide_in_combat_type ~= 1 then --> 1 = none, we doesn't need to call
			instancia:SetCombatAlpha(nil, nil, true)
		end
	end

	_detalhes:DispatchAutoRunCode("on_entercombat")

	_detalhes.tabela_vigente.CombatStartedAt = GetTime()
end

--in case the player left the raid during the encounter
local check_for_encounter_end = function()
	if not _current_encounter_id then
		return
	end

	if IsInRaid() then
		--raid
		local inCombat = false
		for i = 1, GetNumGroupMembers() do
			if UnitAffectingCombat("raid" .. i) then
				inCombat = true
				break
			end
		end

		if not inCombat then
			_current_encounter_id = nil
		end
	elseif IsInGroup() then
		--party(dungeon)
		local inCombat = false
		for i = 1, GetNumGroupMembers() -1 do
			if UnitAffectingCombat("party" .. i) then
				inCombat = true
				break
			end
		end

		if not inCombat then
			_current_encounter_id = nil
		end
	else
		_current_encounter_id = nil
	end
end

--> this function is guaranteed to run after a combat is done
--> can also run when the player leaves combat state(regen enabled)
function _detalhes:RunScheduledEventsAfterCombat(OnRegenEnabled)
	if _detalhes.debug then
		_detalhes:Msg("(debug) running scheduled events after combat end.")
	end

	--when the user requested data from the storage but is in combat lockdown
	if _detalhes.schedule_storage_load then
		_detalhes.schedule_storage_load = nil
		_detalhes.ScheduleLoadStorage()
	end

	--store a boss encounter when out of combat since it might need to load the storage
	if _detalhes.schedule_store_boss_encounter then
		if not _detalhes.logoff_saving_data then
			--_detalhes.StoreEncounter()
			local successful, errortext = pcall(_detalhes.StoreEncounter)
			if not successful then
				_detalhes:Msg("error occurred on StoreEncounter():", errortext)
			end
		end

		_detalhes.schedule_store_boss_encounter = nil
	end

	--when a large amount of data has been removed and the player is in combat, schedule to run the hard garbage collector(the blizzard one, not the details! internal)
	if _detalhes.schedule_hard_garbage_collect then
		if _detalhes.debug then
			_detalhes:Msg("(debug) found schedule collectgarbage().")
		end

		_detalhes.schedule_hard_garbage_collect = false
		collectgarbage()
	end

	for index, instancia in ipairs(_detalhes.tabela_instancias) do
		if instancia.ativa and instancia.hide_in_combat_type ~= 1 then --> 1 = none, we doesn't need to call
			instancia:SetCombatAlpha(nil, nil, true)
		end
	end

	if not OnRegenEnabled then
		_table_wipe(bitfield_swap_cache)
		_table_wipe(ignore_actors)
		_detalhes:DispatchAutoRunCode("on_leavecombat")
	end

	if _detalhes.solo and _detalhes.PluginCount.SOLO > 0 then --code too old and I don't have documentation for it
		if _detalhes.SoloTables.Plugins[_detalhes.SoloTables.Mode].Stop then
			_detalhes.SoloTables.Plugins[_detalhes.SoloTables.Mode].Stop()
		end
	end

	--deprecated shcedules
	do
		if _detalhes.schedule_add_to_overall and #_detalhes.schedule_add_to_overall > 0 then --deprecated(combat are now added immediatelly since there's no script run too long)
			if _detalhes.debug then
				_detalhes:Msg("(debug) adding ", #_detalhes.schedule_add_to_overall, "combats in queue to overall data.")
			end

			for i = #_detalhes.schedule_add_to_overall, 1, -1 do
				local CombatToAdd = tremove(_detalhes.schedule_add_to_overall, i)
				if CombatToAdd then
					_detalhes.historico:adicionar_overall(CombatToAdd)
				end
			end
		end

		if _detalhes.schedule_flag_boss_components then --deprecated(combat are now added immediatelly since there's no script run too long)
			_detalhes.schedule_flag_boss_components = false
			_detalhes:FlagActorsOnBossFight()
		end

		if _detalhes.schedule_remove_overall then --deprecated(combat are now added immediatelly since there's no script run too long)
			if _detalhes.debug then
				_detalhes:Msg("(debug) found schedule overall data clean up.")
			end

			_detalhes.schedule_remove_overall = false
			_detalhes.tabela_historico:resetar_overall()
		end

		if _detalhes.wipe_called and false then --disabled
			_detalhes.wipe_called = nil
			_detalhes:CaptureSet(nil, "damage", true)
			_detalhes:CaptureSet(nil, "energy", true)
			_detalhes:CaptureSet(nil, "aura", true)
			_detalhes:CaptureSet(nil, "energy", true)
			_detalhes:CaptureSet(nil, "spellcast", true)

			_detalhes:CaptureSet(false, "damage", false, 10)
			_detalhes:CaptureSet(false, "energy", false, 10)
			_detalhes:CaptureSet(false, "aura", false, 10)
			_detalhes:CaptureSet(false, "energy", false, 10)
			_detalhes:CaptureSet(false, "spellcast", false, 10)
		end
	end
end

local function sair_do_combate()
	_detalhes.tabela_vigente.playing_solo = true
	_detalhes:SairDoCombate()
end

function _detalhes.parser_functions:PLAYER_REGEN_ENABLED(...)
	if _detalhes.debug then
		_detalhes:Msg("(debug) |cFFFFFF00PLAYER_REGEN_ENABLED|r event triggered.")

		print("combat lockdown:", InCombatLockdown())
		print("affecting combat:", UnitAffectingCombat("player"))

		if _current_encounter_id and IsInInstance() then
			print("has a encounter ID")
			print("player is dead:", UnitHealth("player") < 1)
		end
	end

	for _, npcID in _ipairs(_detalhes.cache_dead_npc) do
		if _detalhes.encounter_table and _detalhes.encounter_table.id == npcID then
			local mapID = _detalhes.zone_id
			local bossIDs = _detalhes:GetBossIds(mapID)
			if not bossIDs then
				for id, data in _pairs(_detalhes.EncounterInformation) do
					if data.name == _detalhes.zone_name then
						bossIDs = _detalhes:GetBossIds(id)
						mapID = id
						break
					end
				end
			end

			local bossIndex = bossIDs and bossIDs[npcID]
			if bossIndex then
				local _, _, _, _, maxPlayers = GetInstanceInfo()
				local difficulty = GetInstanceDifficulty()
				_detalhes.parser_functions:ENCOUNTER_END(npcID, _detalhes:GetBossName(mapID, bossIndex), difficulty, maxPlayers)
				break
			end
		end
	end

	--elapsed combat time
	_detalhes.LatestCombatDone = GetTime()
	_detalhes.tabela_vigente.CombatEndedAt = GetTime()
	_detalhes.tabela_vigente.TotalElapsedCombatTime = _detalhes.tabela_vigente.CombatEndedAt -(_detalhes.tabela_vigente.CombatStartedAt or 0)

	--
	C_Timer.After(10, check_for_encounter_end)

	--> playing alone, just finish the combat right now
	if not _IsInGroup() and not IsInRaid() then
		C_Timer.After(1, sair_do_combate)
	else
		--is in a raid or party group
		C_Timer.After(1, function()
			local inCombat
			if IsInRaid() then
				--raid
				local inCombat = false
				for i = 1, GetNumGroupMembers() do
					if UnitAffectingCombat("raid" .. i) then
						inCombat = true
						break
					end
				end

				if not inCombat then
					_detalhes:RunScheduledEventsAfterCombat(true)
				end
			elseif IsInGroup() then
				--party(dungeon)
				local inCombat = false
				for i = 1, GetNumGroupMembers() -1 do
					if(UnitAffectingCombat("party" .. i)) then
						inCombat = true
						break
					end
				end

				if not inCombat then
					_detalhes:RunScheduledEventsAfterCombat(true)
				end
			end
		end)
	end
end

function _detalhes.parser_functions:PLAYER_TALENT_UPDATE()
	if IsInGroup() or IsInRaid() then
		if _detalhes.SendTalentTimer and not _detalhes.SendTalentTimer._cancelled then
			_detalhes.SendTalentTimer:Cancel()
		end

		_detalhes.SendTalentTimer = C_Timer.NewTicker(11, function()
			_detalhes:SendCharacterData()
		end, 1)
	end
end

function _detalhes.parser_functions:ACTIVE_TALENT_GROUP_CHANGED()
	local specIndex = DetailsFramework.GetSpecialization()
	if specIndex then
		local specID = DetailsFramework.GetSpecializationInfo(specIndex)
		if specID and specID ~= 0 then
			local guid = UnitGUID("player")
			if guid then
				_detalhes.cached_specs[guid] = specID
			end
		end
	end

	if IsInGroup() or IsInRaid() then
		if _detalhes.SendTalentTimer and not _detalhes.SendTalentTimer._cancelled then
			_detalhes.SendTalentTimer:Cancel()
		end

		_detalhes.SendTalentTimer = C_Timer.NewTicker(11, function()
			_detalhes:SendCharacterData()
		end, 1)
	end
end

--> this is mostly triggered when the player enters in a dual against another player
function _detalhes.parser_functions:UNIT_FACTION(unit)
	if true then
		--> disable until figure out how to make this work properlly
		--> at the moment this event is firing at bgs, arenas, etc making horde icons to show at random
		return
	end

	--> check if outdoors
	--unit was nil, nameplate might bug here, it should track after the event
	if _detalhes.zone_type == "none" and unit then
		local serial = UnitGUID(unit)
		--> the serial is valid and isn't THE player and the serial is from a player?
		if serial and serial ~= UnitGUID("player") and serial:find("Player") then
			_detalhes.duel_candidates[serial] = GetTime()

			local playerName = _detalhes:GetCLName(unit)

			--> check if the player is inside the current combat and flag the objects
			if playerName and _current_combat then
				local enemyPlayer1 = _current_combat:GetActor(1, playerName)
				local enemyPlayer2 = _current_combat:GetActor(2, playerName)
				local enemyPlayer3 = _current_combat:GetActor(3, playerName)
				local enemyPlayer4 = _current_combat:GetActor(4, playerName)
				if enemyPlayer1 then
					--> set to show when the player is solo play
					enemyPlayer1.grupo = true
					enemyPlayer1.enemy = true

					if IsInGroup() then
						--> broadcast the enemy to group members so they can "watch" the damage
					end
				end

				if enemyPlayer2 then
					enemyPlayer2.grupo = true
					enemyPlayer2.enemy = true
				end

				if enemyPlayer3 then
					enemyPlayer3.grupo = true
					enemyPlayer3.enemy = true
				end

				if enemyPlayer4 then
					enemyPlayer4.grupo = true
					enemyPlayer4.enemy = true
				end
			end
		end
	end
end

function _detalhes.parser_functions:PLAYER_ROLES_ASSIGNED(...)
	if _detalhes.last_assigned_role ~= UnitGroupRolesAssigned("player") then
		_detalhes:CheckSwitchOnLogon(true)
		_detalhes.last_assigned_role = UnitGroupRolesAssigned("player")
	end
end

function _detalhes:InGroup()
	return _detalhes.in_group
end

function _detalhes.parser_functions:PARTY_MEMBERS_CHANGED(...)
	_detalhes.parser_functions:RAID_ROSTER_UPDATE(...)
end

function _detalhes.parser_functions:RAID_ROSTER_UPDATE(...)
	if not _detalhes.in_group then
		_detalhes.in_group = IsInGroup() or IsInRaid()

		if _detalhes.in_group then
			--> entrou num grupo
			_detalhes:IniciarColetaDeLixo(true)
			_detalhes:WipePets()
			_detalhes:SchedulePetUpdate(1)
			_detalhes:InstanceCall(_detalhes.SetCombatAlpha, nil, nil, true)
			_detalhes:CheckSwitchOnLogon()
			_detalhes:CheckVersion()
			_detalhes:SendEvent("GROUP_ONENTER")

			_detalhes:DispatchAutoRunCode("on_groupchange")

			wipe(_detalhes.trusted_characters)
			C_Timer.After(5, _detalhes.ScheduleSyncPlayerActorData)
		end

	else
		_detalhes.in_group = IsInGroup() or IsInRaid()

		if not _detalhes.in_group then
			--> saiu do grupo
			_detalhes:IniciarColetaDeLixo(true)
			_detalhes:WipePets()
			_detalhes:SchedulePetUpdate(1)
			_table_wipe(_detalhes.details_users)
			_detalhes:InstanceCall(_detalhes.SetCombatAlpha, nil, nil, true)
			_detalhes:CheckSwitchOnLogon()
			_detalhes:SendEvent("GROUP_ONLEAVE")

			_detalhes:DispatchAutoRunCode("on_groupchange")

			wipe(_detalhes.trusted_characters)
		else
			--> ainda esta no grupo
			_detalhes:SchedulePetUpdate(2)

			--> send char data
			if _detalhes.SendCharDataOnGroupChange and not _detalhes.SendCharDataOnGroupChange._cancelled then
				return
			end
			_detalhes.SendCharDataOnGroupChange = C_Timer.NewTicker(11, function()
				_detalhes:SendCharacterData()
				_detalhes.SendCharDataOnGroupChange = nil
			end, 1)
		end
	end

	_detalhes:SchedulePetUpdate(6)
end

function _detalhes.parser_functions:CHAT_MSG_BG_SYSTEM_NEUTRAL(msg)
	if not msg then return end

	local timerType, timeSeconds, totalTime = GetStartTimeData(msg)
	if not timerType and not timeSeconds and not totalTime then return end

	if _detalhes.debug then
		_detalhes:Msg("(debug) found a timer.")
	end

	if _detalhes.is_in_arena then
		if _detalhes.debug then
			_detalhes:Msg("(debug) timer is an arena countdown.")
		end

		_detalhes:StartArenaSegment(timerType, timeSeconds, totalTime)
	elseif _detalhes.is_in_battleground then
		if _detalhes.debug then
			_detalhes:Msg("(debug) timer is a battleground countdown.")
		end

		if _detalhes.start_battleground then
			_detalhes:CancelTimer(_detalhes.start_battleground, true)
		end

		_detalhes.start_battleground = _detalhes:ScheduleTimer("CreateBattlegroundSegment", timeSeconds)
	end
end

function _detalhes:CreateBattlegroundSegment()
	if _in_combat then
		_detalhes.tabela_vigente.discard_segment = true
		_detalhes:SairDoCombate()
	end

	_detalhes:EntrarEmCombate()
end

-- ~load
local start_details = function()
	if not _detalhes.gump then
		--> failed to load the framework.
		if not _detalhes.instance_load_failed then
			_detalhes:CreatePanicWarning()
		end

		_detalhes.instance_load_failed.text:SetText("Framework for Details! isn't loaded.\nIf you just updated the addon, please reboot the game client.\nWe apologize for the inconvenience and thank you for your comprehension.")
		return
	end

	--> cooltip
	if not _G.GameCooltip then
		_detalhes.popup = _G.GameCooltip
	else
		_detalhes.popup = _G.GameCooltip
	end

	--> check group
	_detalhes.in_group = IsInGroup() or IsInRaid()

	--> write into details object all basic keys and default profile
	_detalhes:ApplyBasicKeys()
	--> check if is first run, update keys for character and global data
	_detalhes:LoadGlobalAndCharacterData()

	--> details updated and not reopened the game client
	if _detalhes.FILEBROKEN then
		return
	end

	--> load all the saved combats
	_detalhes:LoadCombatTables()
	--> load the profiles
	_detalhes:LoadConfig()

	_detalhes:UpdateParserGears()
--	_detalhes:Start()
end

function _detalhes.parser_functions:ADDON_LOADED(addon_name)
	if addon_name == "Details" then
		start_details()
	end
end

local playerLogin = CreateFrame("Frame")
playerLogin:RegisterEvent("PLAYER_LOGIN")
playerLogin:SetScript("OnEvent", function()
	Details:Start()
end)

function _detalhes.parser_functions:UNIT_NAME_UPDATE(...)
	_detalhes:SchedulePetUpdate(5)
end

local parser_functions = _detalhes.parser_functions

function _detalhes:OnEvent(event, ...)
	local func = parser_functions[event]
	if func then
		return func(nil, ...)
	end
end

_detalhes.listener:SetScript("OnEvent", _detalhes.OnEvent)

--> logout function ~save ~logout
local saver = CreateFrame("Frame", nil, UIParent)
saver:RegisterEvent("PLAYER_LOGOUT")
saver:SetScript("OnEvent", function(...)
	if not _detalhes.gump then
		--> failed to load the framework.
		return
	end

	local saver_error = function(errortext)
		_detalhes_global = _detalhes_global or {}
		_detalhes_global.exit_errors = _detalhes_global.exit_errors or {}

		tinsert(_detalhes_global.exit_errors, 1, _detalhes.userversion.." "..errortext)
		tremove(_detalhes_global.exit_errors, 6)
	end

	_detalhes_global.exit_log = {}

	_detalhes.saver_error_func = saver_error

	_detalhes.logoff_saving_data = true

	--> close info window
	if _detalhes.FechaJanelaInfo then
		tinsert(_detalhes_global.exit_log, "1 - Closing Janela Info.")
		xpcall(_detalhes.FechaJanelaInfo, saver_error)
	end

	--> do not save window pos
	if _detalhes.tabela_instancias then
		tinsert(_detalhes_global.exit_log, "2 - Clearing user place from instances.")
		for id, instance in _detalhes:ListInstances() do
			if instance.baseframe then
				instance.baseframe:SetUserPlaced(false)
				instance.baseframe:SetDontSavePosition(true)
			end
		end
	end

	--> leave combat start save tables
	if _detalhes.in_combat and _detalhes.tabela_vigente then
		tinsert(_detalhes_global.exit_log, "3 - Leaving current combat.")
		xpcall(_detalhes.SairDoCombate, saver_error)
		_detalhes.can_panic_mode = true
	end

	if _detalhes.CheckSwitchOnLogon and _detalhes.tabela_instancias[1] and _detalhes.tabela_instancias and getmetatable(_detalhes.tabela_instancias[1]) then
		tinsert(_detalhes_global.exit_log, "4 - Reversing switches.")
		xpcall(_detalhes.CheckSwitchOnLogon, saver_error)
	end

	if _detalhes.wipe_full_config then
		tinsert(_detalhes_global.exit_log, "5 - Is a full config wipe.")
		_detalhes_global = nil
		_detalhes_database = nil
		return
	end

	--> save the config
	tinsert(_detalhes_global.exit_log, "6 - Saving Config.")
	xpcall(_detalhes.SaveConfig, saver_error)
	tinsert(_detalhes_global.exit_log, "7 - Saving Profiles.")
	xpcall(_detalhes.SaveProfile, saver_error)

	--> save the nicktag cache
	tinsert(_detalhes_global.exit_log, "8 - Saving nicktag cache.")
	_detalhes_database.nick_tag_cache = table_deepcopy(_detalhes_database.nick_tag_cache)
end)
--> end

-- ~parserstart ~startparser

function _detalhes.OnParserEvent(_, _, time, token, who_serial, who_name, who_flags, target_serial, target_name, target_flags, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12)
	local funcao = token_list[token]
	if funcao then
		return funcao(nil, token, time, who_serial, who_name, who_flags, target_serial, target_name, target_flags, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12)
	else
		return
	end
end

_detalhes.parser_frame:SetScript("OnEvent", _detalhes.OnParserEvent)

function _detalhes:UpdateParser()
	_tempo = _detalhes._tempo
end
function _detalhes:UpdatePetsOnParser()
	container_pets = _detalhes.tabela_pets.pets
end

function _detalhes:PrintParserCacheIndexes()
	local amount = 0
	for n, nn in pairs(damage_cache) do
		amount = amount + 1
	end
	print("parser damage_cache", amount)

	amount = 0
	for n, nn in pairs(damage_cache_pets) do
		amount = amount + 1
	end
	print("parser damage_cache_pets", amount)

	amount = 0
	for n, nn in pairs(damage_cache_petsOwners) do
		amount = amount + 1
	end
	print("parser damage_cache_petsOwners", amount)

	amount = 0
	for n, nn in pairs(healing_cache) do
		amount = amount + 1
	end
	print("parser healing_cache", amount)

	amount = 0
	for n, nn in pairs(energy_cache) do
		amount = amount + 1
	end
	print("parser energy_cache", amount)

	amount = 0
	for n, nn in pairs(misc_cache) do
		amount = amount + 1
	end
	print("parser misc_cache", amount)
	print("group damage", #_detalhes.cache_damage_group)
	print("group damage", #_detalhes.cache_healing_group)
end

function _detalhes:GetActorsOnDamageCache()
	return _detalhes.cache_damage_group
end
function _detalhes:GetActorsOnHealingCache()
	return _detalhes.cache_healing_group
end

function _detalhes:ClearParserCache()
	_table_wipe(damage_cache)
	_table_wipe(damage_cache_pets)
	_table_wipe(damage_cache_petsOwners)
	_table_wipe(healing_cache)
	_table_wipe(energy_cache)
	_table_wipe(misc_cache)
	_table_wipe(misc_cache_pets)
	_table_wipe(misc_cache_petsOwners)
	_table_wipe(npcid_cache)

	_table_wipe(ignore_death)
	_table_wipe(reflection_damage)
	_table_wipe(reflection_debuffs)
	_table_wipe(reflection_events)
	_table_wipe(reflection_auras)
	_table_wipe(reflection_dispels)

	damage_cache = setmetatable({}, _detalhes.weaktable)
	damage_cache_pets = setmetatable({}, _detalhes.weaktable)
	damage_cache_petsOwners = setmetatable({}, _detalhes.weaktable)

	healing_cache = setmetatable({}, _detalhes.weaktable)

	energy_cache = setmetatable({}, _detalhes.weaktable)

	misc_cache = setmetatable({}, _detalhes.weaktable)
	misc_cache_pets = setmetatable({}, _detalhes.weaktable)
	misc_cache_petsOwners = setmetatable({}, _detalhes.weaktable)
end

function parser:RevomeActorFromCache(actor_serial, actor_name)
	if actor_name then
		damage_cache[actor_name] = nil
		damage_cache_pets[actor_name] = nil
		damage_cache_petsOwners[actor_name] = nil
		healing_cache[actor_serial] = nil
		energy_cache[actor_name] = nil
		misc_cache[actor_name] = nil
		misc_cache_pets[actor_name] = nil
		misc_cache_petsOwners[actor_name] = nil
	end

	if actor_serial then
		damage_cache[actor_serial] = nil
		damage_cache_pets[actor_serial] = nil
		damage_cache_petsOwners[actor_serial] = nil
		healing_cache[actor_serial] = nil
		energy_cache[actor_serial] = nil
		misc_cache[actor_serial] = nil
		misc_cache_pets[actor_serial] = nil
		misc_cache_petsOwners[actor_serial] = nil
	end
end

function _detalhes:UptadeRaidMembersCache()
	_table_wipe(raid_members_cache)
	_table_wipe(bitfield_swap_cache)
	_table_wipe(ignore_actors)

	local roster = _detalhes.tabela_vigente.raid_roster

	if _IsInRaid() then
		for i = 1, _GetNumGroupMembers() do
			local name = _GetUnitName("raid"..i, true)

			raid_members_cache[_UnitGUID("raid"..i)] = true
			roster[name] = true
		end

	elseif _IsInGroup() then
		--party
		for i = 1, _GetNumGroupMembers() do
			local name = _GetUnitName("party"..i, true)

			raid_members_cache[_UnitGUID("party"..i)] = true
			roster[name] = true
		end

		--player
		local name = GetUnitName("player", true)

		raid_members_cache[_UnitGUID("player")] = true
		roster[name] = true
	else
		local name = GetUnitName("player", true)

		raid_members_cache[_UnitGUID("player")] = true
		roster[name] = true
	end
end

function _detalhes:IsInCache(playerguid)
	return raid_members_cache[playerguid]
end
function _detalhes:GetParserPlayerCache()
	return raid_members_cache
end

--serach key: ~cache
function _detalhes:UpdateParserGears()
	--> refresh combat tables
	_current_combat = _detalhes.tabela_vigente
	_current_combat_cleu_events = _current_combat and _current_combat.cleu_events

	--> last events pointer
	last_events_cache = _current_combat.player_last_events
	_death_event_amt = _detalhes.deadlog_events

	--> refresh total containers
	_current_total = _current_combat.totals
	_current_gtotal = _current_combat.totals_grupo

	--> refresh actors containers
	_current_damage_container = _current_combat[1]

	_current_heal_container = _current_combat[2]
	_current_energy_container = _current_combat[3]
	_current_misc_container = _current_combat[4]

	--> refresh data capture options
	_recording_self_buffs = _detalhes.RecordPlayerSelfBuffs
	--_recording_healing = _detalhes.RecordHealingDone
	--_recording_took_damage = _detalhes.RecordRealTimeTookDamage
	_recording_ability_with_buffs = _detalhes.RecordPlayerAbilityWithBuffs
	_in_combat = _detalhes.in_combat

	--> grab the ignored npcid directly from the user profile
	ignored_npcids = _detalhes.npcid_ignored

	if _detalhes.hooks["HOOK_COOLDOWN"].enabled then
		_hook_cooldowns = true
	else
		_hook_cooldowns = false
	end

	if _detalhes.hooks["HOOK_DEATH"].enabled then
		_hook_deaths = true
	else
		_hook_deaths = false
	end

	if _detalhes.hooks["HOOK_BATTLERESS"].enabled then
		_hook_battleress = true
	else
		_hook_battleress = false
	end

	if _detalhes.hooks["HOOK_INTERRUPT"].enabled then
		_hook_interrupt = true
	else
		_hook_interrupt = false
	end

	is_using_spellId_override = _detalhes.override_spellids

	return _detalhes:ClearParserCache()
end

--serach key: ~api
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

--> number of combat
function  _detalhes:GetCombatId()
	return _detalhes.combat_id
end

--> if in combat
function _detalhes:IsInCombat()
	return _in_combat
end

function _detalhes:IsInEncounter()
	return _detalhes.encounter_table.id and true or false
end

--> get combat
function _detalhes:GetCombat(_combat)
	if not _combat then
		return _current_combat
	elseif _type(_combat) == "number" then
		if _combat == -1 then --> overall
			return _detalhes.tabela_overall
		elseif _combat == 0 then --> current
			return _current_combat
		else
			return _detalhes.tabela_historico.tabelas[_combat]
		end
	elseif _type(_combat) == "string" then
		if _combat == "overall" then
			return _detalhes.tabela_overall
		elseif _combat == "current" then
			return _current_combat
		end
	end

	return nil
end

function _detalhes:GetAllActors(_combat, _actorname)
	return _detalhes:GetActor(_combat, 1, _actorname), _detalhes:GetActor(_combat, 2, _actorname), _detalhes:GetActor(_combat, 3, _actorname), _detalhes:GetActor(_combat, 4, _actorname)
end

--> get player
function _detalhes:GetPlayer(_actorname, _combat, _attribute)
	return _detalhes:GetActor(_combat, _attribute, _actorname)
end

--> get an actor
function _detalhes:GetActor(_combat, _attribute, _actorname)
	if not _combat then
		_combat = "current" --> current combat
	end

	if not _attribute then
		_attribute = 1 --> damage
	end

	if not _actorname then
		_actorname = _detalhes.playername
	end

	if _combat == 0 or _combat == "current" then
		local actor = _detalhes.tabela_vigente(_attribute, _actorname)
		if actor then
			return actor
		else
			return nil --_detalhes:NewError("Current combat doesn't have an actor called ".. _actorname)
		end
	elseif _combat == -1 or _combat == "overall" then
		local actor = _detalhes.tabela_overall(_attribute, _actorname)
		if actor then
			return actor
		else
			return nil --_detalhes:NewError("Combat overall doesn't have an actor called ".. _actorname)
		end
	elseif type(_combat) == "number" then
		local _combatOnHistoryTables = _detalhes.tabela_historico.tabelas[_combat]
		if _combatOnHistoryTables then
			local actor = _combatOnHistoryTables(_attribute, _actorname)
			if actor then
				return actor
			else
				return nil --_detalhes:NewError("Combat ".. _combat .." doesn't have an actor called ".. _actorname)
			end
		else
			return nil --_detalhes:NewError("Combat ".._combat.." not found.")
		end
	else
		return nil --_detalhes:NewError("Couldn't find a combat object for passed parameters")
	end
end