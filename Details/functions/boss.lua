do
	local _detalhes = _detalhes

	local _ipairs = ipairs --> lua local
	local _math_ceil = math.ceil --> lua local
	local _pairs = pairs --> lua local
	local _table_insert = table.insert --> lua local
	local _table_remove = table.remove --> lua local
	local _unpack = unpack --> lua local

	local _GetCurrentMapAreaID = GetCurrentMapAreaID --api local
	local _GetRealZoneText = GetRealZoneText --api local

	_detalhes.EncounterInformation = {}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

	--> return if the player is inside a raid supported by details
	function _detalhes:IsInInstance()
		local zoneMapID = _GetCurrentMapAreaID()
		if _detalhes.EncounterInformation[zoneMapID] then
			return true
		else
			local mapname = _GetRealZoneText()
			for _, data in _pairs(_detalhes.EncounterInformation) do
				if data.name == mapname then
					return true
				end
			end
			return false
		end
	end

	--> return the full table with all data for the instance
	function _detalhes:GetRaidInfoFromEncounterID(encounterID)
		for id, raidTable in _pairs(_detalhes.EncounterInformation) do
			--combatlog encounter
			if encounterID then
				local ids = raidTable.encounter_ids2
				if ids then
					if ids[encounterID] then
						return raidTable
					end
				end
			end
		end
	end

	--> return the ids of trash mobs in the instance
	function _detalhes:GetInstanceTrashInfo(mapid)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].trash_ids
	end

	function _detalhes:GetInstanceIdFromEncounterId(encounterid)
		for id, instanceTable in _pairs(_detalhes.EncounterInformation) do
			--combatlog encounter id
			local ids = instanceTable.encounter_ids2
			if ids then
				if ids[encounterid] then
					return id
				end
			end
		end
	end

	--> return the boss table using a encounter id
	function _detalhes:GetBossEncounterDetailsFromEncounterId(mapid, encounterid)
		if not mapid then
			local bossIndex, instance
			for id, instanceTable in _pairs(_detalhes.EncounterInformation) do
				local ids = instanceTable.encounter_ids2
				if ids then
					bossIndex = ids[encounterid]
					if bossIndex then
						instance = instanceTable
						break
					end
				end
			end

			if instance then
				local bosses = instance.encounters
				if bosses then
					return bosses[bossIndex], instance
				end
			end

			return
		end

		local bossindex = _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounter_ids2 and _detalhes.EncounterInformation[mapid].encounter_ids2[encounterid]
		if bossindex then
			return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounters[bossindex], bossindex
		end
	end

	--> return the EJ boss id
	function _detalhes:GetEncounterIdFromBossIndex(mapid, index)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounter_ids2 and _detalhes.EncounterInformation[mapid].encounter_ids2[index]
	end

	--> return the table which contain information about the start of a encounter
	function _detalhes:GetEncounterStartInfo(mapid, encounterid)
		local bossindex = _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounter_ids2 and _detalhes.EncounterInformation[mapid].encounter_ids2[encounterid]
		if bossindex then
			return _detalhes.EncounterInformation[mapid].encounters[bossindex] and _detalhes.EncounterInformation[mapid].encounters[bossindex].encounter_start
		end
	end

	--> return the table which contain information about the end of a encounter
	function _detalhes:GetEncounterEndInfo(mapid, encounterid)
		local bossindex = _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounter_ids2 and _detalhes.EncounterInformation[mapid].encounter_ids2[encounterid]
		if bossindex then
			return _detalhes.EncounterInformation[mapid].encounters[bossindex] and _detalhes.EncounterInformation[mapid].encounters[bossindex].encounter_end
		end
	end

	--> return the function for the boss
	function _detalhes:GetEncounterEnd(mapid, bossindex)
		local t = _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounters[bossindex]
		if t then
			local _end = t.combat_end
			if _end then
				return _unpack(_end)
			end
		end
		return
	end

	--> generic boss find function
	function _detalhes:GetRaidBossFindFunction(mapid)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].find_boss_encounter
	end

	--> return if the boss need sync
	function _detalhes:GetEncounterEqualize(mapid, bossindex)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounters[bossindex] and _detalhes.EncounterInformation[mapid].encounters[bossindex].equalize
	end

	--> return the function for the boss
	function _detalhes:GetBossFunction(mapid, bossindex)
		local func = _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounters[bossindex] and _detalhes.EncounterInformation[mapid].encounters[bossindex].func
		if func then
			return func, _detalhes.EncounterInformation[mapid].encounters[bossindex].funcType
		end
		return
	end

	--> return the boss table with information about name, adds, spells, etc
	function _detalhes:GetBossDetails(mapid, bossindex)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounters[bossindex]
	end

	--> return a table with all names of boss enemies
	function _detalhes:GetEncounterActors(mapid, bossindex)

	end

	--> return a table with spells id of specified encounter
	function _detalhes:GetEncounterSpells(mapid, bossindex)
		local encounter = _detalhes:GetBossDetails(mapid, bossindex)
		local habilidades_poll = {}
		if encounter.continuo then
			for index, spellid in _ipairs(encounter.continuo) do
				habilidades_poll[spellid] = true
			end
		end
		local fases = encounter.phases
		if fases then
			for fase_id, fase in _ipairs(fases) do
				if fase.spells then
					for index, spellid in _ipairs(fase.spells) do
						habilidades_poll[spellid] = true
					end
				end
			end
		end
		return habilidades_poll
	end

	--> return a table with all boss ids from a raid instance
	function _detalhes:GetBossIds(mapid)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].boss_ids
	end

	function _detalhes:InstanceIsRaid(mapid)
		return _detalhes:InstanceisRaid(mapid)
	end
	function _detalhes:InstanceisRaid(mapid)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].is_raid
	end

	--> return a table with all encounter names present in raid instance
	function _detalhes:GetBossNames(mapid)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].boss_names
	end

	--> return the encounter name
	function _detalhes:GetBossName(mapid, bossindex)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].boss_names[bossindex]
	end

	function _detalhes:GetBossEncounter(mapid, bossindex)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounter_ids2[bossindex]
	end

	--> same thing as GetBossDetails, just a alias
	function _detalhes:GetBossEncounterDetails(mapid, bossindex)
		return _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounters[bossindex]
	end

	function _detalhes:GetEncounterInfoFromEncounterName(EJID, encountername)
		DetailsFramework.EncounterJournal.EJ_SelectInstance(EJID)

		for i = 1, 20 do
			local name = DetailsFramework.EncounterJournal.EJ_GetEncounterInfoByIndex(i, EJID)
			if not name then
				return
			end

			if name == encountername or name:find(encountername) then
				return i, DetailsFramework.EncounterJournal.EJ_GetEncounterInfoByIndex(i, EJID)
			end
		end
	end

	--> return the wallpaper for the raid instance
	function _detalhes:GetRaidBackground(mapid)
		local bosstables = _detalhes.EncounterInformation[mapid]
		if bosstables then
			local bg = bosstables.backgroundFile
			if bg then
				return bg.file, _unpack(bg.coords)
			end
		end
	end

	--> return the icon for the raid instance
	function _detalhes:GetRaidIcon(mapid)
		local raidIcon = _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].icon
		if raidIcon then
			return raidIcon
		end
	end

	function _detalhes:GetBossIndex(mapid, encounterCLID, encounterName)
		local raidInfo = _detalhes.EncounterInformation[mapid]
		if raidInfo then
			local index = raidInfo.encounter_ids2[encounterCLID]
			if not index then
				for i = 1, #raidInfo.boss_names do
					if raidInfo.boss_names[i] == encounterName then
						index = i
						break
					end
				end
			end
			return index
		end
	end

	--> return the boss icon
	function _detalhes:GetBossIcon(mapid, bossindex)
		if _detalhes.EncounterInformation[mapid] then
			local line = _math_ceil(bossindex / 4)
			local x = (bossindex -((line - 1) * 4)) / 4
			return x - 0.25, x, 0.25 * (line - 1), 0.25 * line, _detalhes.EncounterInformation[mapid].icons
		end
	end

	--> return the boss portrit
	function _detalhes:GetBossPortrait(mapid, bossindex)
		if mapid and bossindex then
			local haveIcon = _detalhes.EncounterInformation[mapid] and _detalhes.EncounterInformation[mapid].encounters[bossindex] and _detalhes.EncounterInformation[mapid].encounters[bossindex].portrait
			if haveIcon then
				return haveIcon
			end
		end
	end

	--> return a list with names of adds and bosses
	function _detalhes:GetEncounterActorsName(EJ_EncounterID)
		--code snippet from wowpedia
		local actors = {}
		local stack, encounter, _, _, curSectionID = {}, DetailsFramework.EncounterJournal.EJ_GetEncounterInfo(EJ_EncounterID)

		if not curSectionID then
			return actors
		end

		repeat
			local title, description, depth, abilityIcon, displayInfo, siblingID, nextSectionID, filteredByDifficulty, link, startsOpen, flag1, flag2, flag3, flag4 = DetailsFramework.EncounterJournal.EJ_GetSectionInfo(curSectionID)
			if displayInfo ~= 0 and abilityIcon == "" then
				actors[title] = {model = displayInfo, info = description}
			end
			_table_insert(stack, siblingID)
			_table_insert(stack, nextSectionID)
			curSectionID = _table_remove(stack)
		until not curSectionID

		return actors
	end

	function _detalhes:GetCurrentDungeonBossListFromEJ()
		local mapID = _GetCurrentMapAreaID()
		if not mapID then
--			print("Details! exeption handled: zone has no map")
			return
		end

		local EJ_CInstance = DetailsFramework.EncounterJournal.EJ_GetInstanceForMap(mapID)

		if EJ_CInstance and EJ_CInstance ~= 0 then
			if _detalhes.encounter_dungeons[EJ_CInstance] then
				return _detalhes.encounter_dungeons[EJ_CInstance]
			end

			DetailsFramework.EncounterJournal.EJ_SelectInstance(EJ_CInstance)

			local name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = DetailsFramework.EncounterJournal.EJ_GetInstanceInfo(EJ_CInstance)

			local boss_list = {
				[EJ_CInstance] = {name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link}
			}

			for i = 1, 20 do
				local encounterName, description, encounterID, rootSectionID, link = DetailsFramework.EncounterJournal.EJ_GetEncounterInfoByIndex(i, EJ_CInstance)
				if encounterName then
					for o = 1, 6 do
						local id, creatureName, creatureDescription, displayInfo, iconImage = DetailsFramework.EncounterJournal.EJ_GetCreatureInfo(o, encounterID)
						if id then
							boss_list[creatureName] = {encounterName, encounterID, creatureName, iconImage, EJ_CInstance}
						else
							break
						end
					end
				else
					break
				end
			end

			_detalhes.encounter_dungeons[EJ_CInstance] = boss_list

			return boss_list
		end
	end

	function _detalhes:IsRaidRegistered(mapid)
		return _detalhes.EncounterInformation[mapid] and true
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function _detalhes:InstallEncounter(InstanceTable)
		_detalhes.EncounterInformation[InstanceTable.id] = InstanceTable
		return true
	end
end

--functionas