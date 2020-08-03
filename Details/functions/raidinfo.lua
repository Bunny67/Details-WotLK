local LBB = LibStub("LibBabble-Boss-3.0"):GetLookupTable()
local LBZ = LibStub("LibBabble-Zone-3.0"):GetLookupTable()

-- BK

do --> data for Zul'Aman
	local INSTANCE_MAPID = 867
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "ZulAman"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENZULAMAN", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-zulaman"
	local EJ_LOREBG = "ui-ej-lorebg-zulaman"

	local PORTRAIT_LIST = {
		"ui-ej-boss-akilzon",
		"ui-ej-boss-nalorakk",
		"ui-ej-boss-janalai",
		"ui-ej-boss-halazzi",
		"ui-ej-boss-hex lord malacrass",
		"ui-ej-boss-zuljin",
	}

	local ENCOUNTER_ID_CL = {
		23574, 23576, 23578, 23577, 24239, 23863,
		[23574] = 1, --Akil'zon
		[23576] = 2, --Nalorakk
		[23578] = 3, --Jan'alai
		[23577] = 4, --Halazzi
		[24239] = 5, --Malacrass
		[23863] = 6, --Zul'jin
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Akil'zon"],
		LBB["Nalorakk"],
		LBB["Jan'alai"],
		LBB["Halazzi"],
		LBB["Malacrass"],
		LBB["Zul'jin"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Zul'Aman"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[23574] = 1, --Akil'zon
			[23576] = 2, --Nalorakk
			[23578] = 3, --Jan'alai
			[23577] = 4, --Halazzi
			[24239] = 5, --Malacrass
			[23863] = 6, --Zul'jin
		},
	})
end

do --> data for Serpentshrine Cavern
	local INSTANCE_MAPID = 863
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "SerpentshrineCavern"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENCOILFANG", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-coilfangreservoir"
	local EJ_LOREBG = "ui-ej-lorebg-coilfangreservoir"

	local PORTRAIT_LIST = {
		"ui-ej-boss-hydross the unstable",
		"ui-ej-boss-the lurker below",
		"ui-ej-boss-leotheras the blind",
		"ui-ej-boss-fathom lord karathress",
		"ui-ej-boss-morogrim tidewalker",
		"ui-ej-boss-lady vashj",
	}

	local ENCOUNTER_ID_CL = {
		21216, 21217, 21215, 21214, 21213, 21212,
		[21216] = 1, --Hydross the Unstable
		[21217] = 2, --The Lurker Below
		[21215] = 3, --Leotheras the Blind
		[21214] = 4, --Fathom-Lord Karathress
		[21213] = 5, --Morogrim Tidewalker
		[21212] = 6, --Lady Vashj
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Hydross the Unstable"],
		LBB["The Lurker Below"],
		LBB["Leotheras the Blind"],
		LBB["Fathom-Lord Karathress"],
		LBB["Morogrim Tidewalker"],
		LBB["Lady Vashj"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Serpentshrine Cavern"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[21216] = 1, --Hydross the Unstable
			[21217] = 2, --The Lurker Below
			[21215] = 3, --Leotheras the Blind
			[21214] = 4, --Fathom-Lord Karathress
			[21213] = 5, --Morogrim Tidewalker
			[21212] = 6, --Lady Vashj
		},
	})
end

do --> data for Magtheridon's Lair
	local INSTANCE_MAPID = 866
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "MagtheridonLair"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENHELLFIRECITADELRAID", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-magtheridonslair"
	local EJ_LOREBG = "ui-ej-lorebg-magtheridonslair"

	local PORTRAIT_LIST = {
		"ui-ej-boss-magtheridon",
	}

	local ENCOUNTER_ID_CL = {
		17257,
		[17257] = 1, --Magtheridon
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Magtheridon"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Magtheridon's Lair"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[17257] = 1, --Magtheridon
		},
	})
end

do --> data for Gruul's Lair
	local INSTANCE_MAPID = 865
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "GruulLair"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENGRUULSLAIR", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-gruulslair"
	local EJ_LOREBG = "ui-ej-lorebg-gruulslair"

	local PORTRAIT_LIST = {
		"ui-ej-boss-high king maulgar",
		"ui-ej-boss-gruul the dragonkiller",
	}

	local ENCOUNTER_ID_CL = {
		18831, 19044,
		[18831] = 1, --High King Maulgar
		[19044] = 2, --Gruul the Dragonkiller
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["High King Maulgar"],
		LBB["Gruul the Dragonkiller"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Gruul's Lair"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[18831] = 1, --High King Maulgar
			[19044] = 2, --Gruul the Dragonkiller
		},
	})
end

do --> data for Karazhan
	local INSTANCE_MAPID = 868
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "Karazhan"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenKarazhan", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-karazhan"
	local EJ_LOREBG = "ui-ej-lorebg-karazhan"

	local PORTRAIT_LIST = {
		"ui-ej-boss-attumen the huntsman",
		"ui-ej-boss-moroes",
		"ui-ej-boss-maiden of virtue",
		"ui-ej-boss-opera",
		"ui-ej-boss-the curator",
		"ui-ej-boss-terestian illhoof",
		"ui-ej-boss-shade of aran",
		"ui-ej-boss-netherspite",
		"UI-EJ-BOSS-Nightbane",
		"ui-ej-boss-prince malchezaar",
	}

	-- TODO: Opera
	local ENCOUNTER_ID_CL = {
		16152, 15687, 16457, 17535, 34437, 15688, 16524, 15689, 17225, 15690,
		[16152] = 1, --Attumen the Huntsman
		[15687] = 2, --Moroes
		[16457] = 3, --Maiden of Virtue
		[17535] = 4, --Opera Event
		[34437] = 5, --The Curator
		[15688] = 6, --Terestian Illhoof
		[16524] = 7, --Shade of Aran
		[15689] = 8, --Netherspite
		[17225] = 9, --Nightbane
		[15690] = 10, --Prince Malchezaar
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Attumen the Huntsman"],
		LBB["Moroes"],
		LBB["Maiden of Virtue"],
		LBB["Opera Event"],
		LBB["The Curator"],
		LBB["Terestian Illhoof"],
		LBB["Shade of Aran"],
		LBB["Netherspite"],
		LBB["Nightbane"],
		LBB["Prince Malchezaar"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Karazhan"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[16152] = 1, --Attumen the Huntsman
			[16151] = 1, --Midnight
			[15687] = 2, --Moroes
			[16457] = 3, --Maiden of Virtue
			[17535] = 4, --Dorothee
			[17546] = 4, --Roar
			[17543] = 4, --Strawman
			[17547] = 4, --Tinhead
			[17548] = 4, --Tito
			[18168] = 4, --The Crone
			[17521] = 4, --The Big Bad Wolf
			[17533] = 4, --Romulo
			[17534] = 4, --Julianne
			[34437] = 5, --The Curator
			[15688] = 6, --Terestian Illhoof
			[16524] = 7, --Shade of Aran
			[15689] = 8, --Netherspite
			[17225] = 9, --Nightbane
			[15690] = 10, --Prince Malchezaar
		},
	})
end

do --> data for The Eye
	local INSTANCE_MAPID = 862
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TheEye"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENTEMPESTKEEP", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-tempestkeep"
	local EJ_LOREBG = "ui-ej-lorebg-tempestkeep"

	local PORTRAIT_LIST = {
		"ui-ej-boss-alar",
		"ui-ej-boss-void reaver",
		"ui-ej-boss-high astromancer solarian",
		"ui-ej-boss-kaelthas sunstrider",
	}

	-- TODO: Opera
	local ENCOUNTER_ID_CL = {
		19514, 19516, 18805, 19622,
		[19514] = 1, --Al'ar
		[19516] = 2, --Void Reaver
		[18805] = 3, --High Astromancer Solarian
		[19622] = 4, --Kael'thas Sunstrider
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Al'ar"],
		LBB["Void Reaver"],
		LBB["High Astromancer Solarian"],
		LBB["Kael'thas Sunstrider"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["The Eye"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[19514] = 1, --Al'ar
			[19516] = 2, --Void Reaver
			[18805] = 3, --High Astromancer Solarian
			[19622] = 4, --Kael'thas Sunstrider
		},
	})
end

-- WotLK

do --> data for Onyxia's Lair
	local INSTANCE_MAPID = 14
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "OnyxiaLair"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenRaid", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-onxyiaslair"
	local EJ_LOREBG = "ui-ej-lorebg-onxyiaslair"

	local PORTRAIT_LIST = {
		"ui-ej-boss-onyxia",
	}

	local ENCOUNTER_ID_CL = {
		10184,
		[10184] = 1, --Onyxia
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Onyxia"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Onyxia's Lair"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[10184] = 1, --Onyxia
		},
	})
end

do --> data for The Ruby Sanctum
	local INSTANCE_MAPID = 610
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TheRubySanctum"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenRubySanctum", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-rubysanctum"
	local EJ_LOREBG = "ui-ej-lorebg-rubysanctum"

	local PORTRAIT_LIST = {
		"ui-ej-boss-halion",
	}

	local ENCOUNTER_ID_CL = {
		39863,
		[39863] = 1, --Halion
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Halion"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["The Ruby Sanctum"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[39863] = 1, --Halion
		},
	})
end

do --> data for Icecrown Citadel
	local faction = UnitFactionGroup("player")

	local INSTANCE_MAPID = 605
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "IcecrownCitadel"..faction
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenIcecrownCitadel", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-icecrowncitadel"
	local EJ_LOREBG = "ui-ej-lorebg-icecrowncitadel"

	local portrait, clID = "ui-ej-boss-gunship horde", 37540
	if faction == "Alliance" then
		portrait, clID = "ui-ej-boss-gunship alliance", 37215
	end

	local PORTRAIT_LIST = {
		"ui-ej-boss-lord marrowgar",
		"ui-ej-boss-lady deathwhisper",
		portrait,
		"ui-ej-boss-deathbringer saurfang",
		"ui-ej-boss-festergut",
		"ui-ej-boss-rotface",
		"ui-ej-boss-professor putricide",
		"ui-ej-boss-blood prince council",
		"ui-ej-boss-blood queen lanathel",
		"ui-ej-boss-valithria dreamwalker",
		"ui-ej-boss-sindragosa",
		"ui-ej-boss-lich king",
	}

	local ENCOUNTER_ID_CL = {
		36612, 36855, clID, 37813, 36626, 36627, 36678, 37970, 37955, 36789, 36853, 36597,
		[36612] = 1, --Lord Marrowgar
		[36855] = 2, --Lady Deathwhisper
		[clID] = 3, --Icecrown Gunship Battle
		[37813] = 4, --Deathbringer Saurfang
		[36626] = 5, --Festergut
		[36627] = 6, --Rotface
		[36678] = 7, --Professor Putricide
		[37970] = 8, --Blood Prince Council
		[37955] = 9, --Blood-Queen Lana'thel
		[36789] = 10, --Valithria Dreamwalker
		[36853] = 11, --Sindragosa
		[36597] = 12, --The Lich King
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Lord Marrowgar"],
		LBB["Lady Deathwhisper"],
		LBB["Icecrown Gunship Battle"],
		LBB["Deathbringer Saurfang"],
		LBB["Festergut"],
		LBB["Rotface"],
		LBB["Professor Putricide"],
		LBB["Blood Prince Council"],
		LBB["Blood-Queen Lana'thel"],
		LBB["Valithria Dreamwalker"],
		LBB["Sindragosa"],
		LBB["The Lich King"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Icecrown Citadel"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[36612] = 1, --Lord Marrowgar
			[36855] = 2, --Lady Deathwhisper
			[37540] = 3, --Icecrown Gunship Battle
			[37215] = 3, --Icecrown Gunship Battle
			[37813] = 4, --Deathbringer Saurfang
			[36626] = 5, --Festergut
			[36627] = 6, --Rotface
			[36678] = 7, --Professor Putricide
			[37970] = 8, --Blood Prince Council
			[37955] = 9, --Blood-Queen Lana'thel
			[36789] = 10, --Valithria Dreamwalker
			[36853] = 11, --Sindragosa
			[36597] = 12, --The Lich King
		},
	})
end

do --> data for Trial of the Crusader
	local INSTANCE_MAPID = 544
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TrialoftheCrusader"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenArgentRaid", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-trialofthecrusader"
	local EJ_LOREBG = "ui-ej-lorebg-trialofthecrusader"

	local portrait, clID = "ui-ej-boss-pvp event vs horde", 34467
	if UnitFactionGroup("player") == "Alliance" then
		portrait, clID = "ui-ej-boss-pvp event vs alliance", 34451
	end

	local PORTRAIT_LIST = {
		"ui-ej-boss-northrend beasts",
		"ui-ej-boss-lord jaraxxus",
		portrait,
		"ui-ej-boss-twin valkyr",
		"ui-ej-boss-anubarak",
	}

	local ENCOUNTER_ID_CL = {
		34797, 34780, clID, 34497, 34564,
		[34797] = 1, --The Beasts of Northrend
		[34780] = 2, --Lord Jaraxxus
		[clID] = 3, --Faction Champions
		[34497] = 4, --The Twin Val'kyr
		[34564] = 5, --Anub'arak
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["The Beasts of Northrend"],
		LBB["Lord Jaraxxus"],
		LBB["Faction Champions"],
		LBB["The Twin Val'kyr"],
		LBB["Anub'arak"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Trial of the Crusader"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[34796] = 1, --Gormok the Impaler
			[34799] = 1, --Dreadscale
			[34797] = 1, --Icehowl
			[35144] = 1, --Acidmaw
			[34780] = 2, --Lord Jaraxxus
			[34461] = 3, --Tyrius Duskblade <Death Knight>
			[34460] = 3, --Kavina Grovesong <Druid>
			[34469] = 3, --Melador Valestrider <Druid>
			[34467] = 3, --Alyssia Moonstalker <Hunter>
			[34468] = 3, --Noozle Whizzlestick <Mage>
			[34465] = 3, --Velanaa <Paladin>
			[34471] = 3, --Baelnor Lightbearer <Paladin>
			[34466] = 3, --Anthar Forgemender <Priest>
			[34473] = 3, --Brienna Nightfell <Priest>
			[34472] = 3, --Irieth Shadowstep <Rogue>
			[34470] = 3, --Saamul <Shaman>
			[34463] = 3, --Shaabad <Shaman>
			[34474] = 3, --Serissa Grimdabbler <Warlock>
			[34475] = 3, --Shocuul <Warrior>
			[34458] = 3, --Gorgrim Shadowcleave <Death Knight>
			[34451] = 3, --Birana Stormhoof <Druid>
			[34459] = 3, --Erin Misthoof <Druid>
			[34448] = 3, --Ruj'kah <Hunter>
			[34449] = 3, --Ginselle Blightslinger <Mage>
			[34445] = 3, --Liandra Suncaller <Paladin>
			[34456] = 3, --Malithas Brightblade <Paladin>
			[34447] = 3, --Caiphus the Stern <Priest>
			[34441] = 3, --Vivienne Blackwhisper <Priest>
			[34454] = 3, --Maz'dinah <Rogue>
			[34444] = 3, --Thrakgar	<Shaman>
			[34455] = 3, --Broln Stouthorn <Shaman>
			[34450] = 3, --Harkzog <Warlock>
			[34453] = 3, --Narrhok Steelbreaker <Warrior>
			[34497] = 4, --Fjola Lightbane
			[34496] = 4, --Eydis Darkbane
			[34564] = 5, --Anub'arak
		},
	})
end

do --> data for Naxxramas
	local INSTANCE_MAPID = 536
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "Naxxramas"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenNaxxramas", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-naxxramas"
	local EJ_LOREBG = "ui-ej-lorebg-naxxramas"

	local PORTRAIT_LIST = {
		"ui-ej-boss-anubrekhan",
		"ui-ej-boss-grand widow faerlina",
		"ui-ej-boss-maexxna",
		"ui-ej-boss-noth the plaguebringer",
		"ui-ej-boss-heigan the unclean",
		"ui-ej-boss-loatheb",
		"ui-ej-boss-instructor razuvious",
		"ui-ej-boss-gothik the harvester",
		"ui-ej-boss-four horseman",
		"ui-ej-boss-patchwerk",
		"ui-ej-boss-grobbulus",
		"ui-ej-boss-gluth",
		"ui-ej-boss-thaddius",
		"ui-ej-boss-sapphiron",
		"ui-ej-boss-kelthuzad",
	}

	local ENCOUNTER_ID_CL = {
		15956, 15953, 15952, 15954, 15936, 16011, 16061, 16060, 30549, 16028, 15931, 15932, 15928, 15989, 15990,
		[15956] = 1, --Anub'Rekhan
		[15953] = 2, --Grand Widow Faerlina
		[15952] = 3, --Maexxna
		[15954] = 4, --Noth the Plaguebringer
		[15936] = 5, --Heigan the Unclean
		[16011] = 6, --Loatheb
		[16061] = 7, --Instructor Razuvious
		[16060] = 8, --Gothik the Harvester
		[30549] = 9, --The Four Horsemen
		[16028] = 10, --Patchwerk
		[15931] = 11, --Grobbulus
		[15932] = 12, --Gluth
		[15928] = 13, --Thaddius
		[15989] = 14, --Sapphiron
		[15990] = 15, --Kel'Thuzad
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Anub'Rekhan"],
		LBB["Grand Widow Faerlina"],
		LBB["Maexxna"],
		LBB["Noth the Plaguebringer"],
		LBB["Heigan the Unclean"],
		LBB["Loatheb"],
		LBB["Instructor Razuvious"],
		LBB["Gothik the Harvester"],
		LBB["The Four Horsemen"],
		LBB["Patchwerk"],
		LBB["Grobbulus"],
		LBB["Gluth"],
		LBB["Thaddius"],
		LBB["Sapphiron"],
		LBB["Kel'Thuzad"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Naxxramas"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[15956] = 1, --Anub'Rekhan
			[15953] = 2, --Grand Widow Faerlina
			[15952] = 3, --Maexxna
			[15954] = 4, --Noth the Plaguebringer
			[15936] = 5, --Heigan the Unclean
			[16011] = 6, --Loatheb
			[16061] = 7, --Instructor Razuvious
			[16060] = 8, --Gothik the Harvester
			[30549] = 9, --Baron Rivendare
			[16065] = 9, --Lady Blaumeux
			[16064] = 9, --Thane Korth'azz
			[16062] = 9, --Highlord Mograine
			[16063] = 9, --Sir Zeliek
			[16028] = 10, --Patchwerk
			[15931] = 11, --Grobbulus
			[15932] = 12, --Gluth
			[15928] = 13, --Thaddius
			[15989] = 14, --Sapphiron
			[15990] = 15, --Kel'Thuzad
		},
	})
end

do --> data for Vault of Archavon
	local INSTANCE_MAPID = 533
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "VaultofArchavon"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenWintergrasp", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-vaultofarchavon"
	local EJ_LOREBG = "ui-ej-lorebg-vaultofarchavon"

	local PORTRAIT_LIST = {
		"ui-ej-boss-archavon the stone watcher",
		"ui-ej-boss-emalon the storm watcher",
		"ui-ej-boss-koralon the flame watcher",
		"ui-ej-boss-taravon the ice watcher",
	}

	local ENCOUNTER_ID_CL = {
		31125, 33993, 35013, 38433,
		[31125] = 1, --Archavon the Stone Watcher
		[33993] = 2, --Emalon the Storm Watcher
		[35013] = 3, --Koralon the Flame Watcher
		[38433] = 4, --Toravon the Ice Watcher
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Archavon the Stone Watcher"],
		LBB["Emalon the Storm Watcher"],
		LBB["Koralon the Flame Watcher"],
		LBB["Toravon the Ice Watcher"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Vault of Archavon"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[31125] = 1, --Archavon the Stone Watcher
			[33993] = 2, --Emalon the Storm Watcher
			[35013] = 3, --Koralon the Flame Watcher
			[38433] = 4, --Toravon the Ice Watcher
		},
	})
end

do --> data for The Obsidian Sanctum
	local INSTANCE_MAPID = 532
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TheObsidianSanctum"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenChamberBlack", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-obsidiansanctum"
	local EJ_LOREBG = "ui-ej-lorebg-obsidiansanctum"

	local PORTRAIT_LIST = {
		"ui-ej-boss-sartharion",
	}

	local ENCOUNTER_ID_CL = {
		28860,
		[28860] = 1, --Sartharion
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Sartharion"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["The Obsidian Sanctum"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[28860] = 1, --Sartharion
		},
	})
end

do --> data for The Eye of Eternity
	local INSTANCE_MAPID = 528
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TheEyeofEternity"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenMalygos", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-eyeofeternity"
	local EJ_LOREBG = "ui-ej-lorebg-eyeofeternity"

	local PORTRAIT_LIST = {
		"ui-ej-boss-malygos",
	}

	local ENCOUNTER_ID_CL = {
		28859,
		[28859] = 1, --Malygos
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Malygos"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["The Eye of Eternity"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[28859] = 1, --Malygos
		},
	})
end

do --> data for Ulduar
	local INSTANCE_MAPID = 530
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "Ulduar"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenUlduarRaid", {0, 1, 285/1024, 875/1024}
	local EJ_DUNGEONBG = "ui-ej-dungeonbutton-ulduar"
	local EJ_LOREBG = "ui-ej-lorebg-ulduar"

	local PORTRAIT_LIST = {
		"ui-ej-boss-flame leviathan",
		"ui-ej-boss-ignis the furnace master",
		"ui-ej-boss-razorscale",
		"ui-ej-boss-xt 002 deconstructor",
		"ui-ej-boss-assembly of iron",
		"ui-ej-boss-kologarn",
		"ui-ej-boss-auriaya",
		"ui-ej-boss-hodir",
		"ui-ej-boss-thorim",
		"ui-ej-boss-freya",
		"ui-ej-boss-mimiron",
		"ui-ej-boss-general vezax",
		"ui-ej-boss-yogg saron",
		"ui-ej-boss-algalon the observer",
	}

	local ENCOUNTER_ID_CL = {
		33113, 33118, 33186, 33293, 32867, 32930, 33515, 32845, 32865, 32906, 33350, 33271, 33136, 32871,
		[33113] = 1, --Flame Leviathan
		[33118] = 2, --Ignis the Furnace Master
		[33186] = 3, --Razorscale
		[33293] = 4, --XT-002 Deconstructor
		[32867] = 5, --Assembly of Iron
		[32930] = 6, --Kologarn
		[33515] = 7, --Auriaya
		[32845] = 8, --Hodir
		[32865] = 9, --Thorim
		[32906] = 10, --Freya
		[33350] = 11, --Mimiron
		[33271] = 12, --General Vezax
		[33136] = 13, --Yogg-Saron
		[32871] = 14, --Algalon the Observer
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Flame Leviathan"],
		LBB["Ignis the Furnace Master"],
		LBB["Razorscale"],
		LBB["XT-002 Deconstructor"],
		LBB["Assembly of Iron"],
		LBB["Kologarn"],
		LBB["Auriaya"],
		LBB["Hodir"],
		LBB["Thorim"],
		LBB["Freya"],
		LBB["Mimiron"],
		LBB["General Vezax"],
		LBB["Yogg-Saron"],
		LBB["Algalon the Observer"],
	}

	local ENCOUNTERS = {}

	for i = 1, #PORTRAIT_LIST do
		local encounterTable = {
			boss = BOSSNAMES[i],
			portrait = "Interface\\EncounterJournal\\"..PORTRAIT_LIST[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Ulduar"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = "Interface\\EncounterJournal\\"..EJ_DUNGEONBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = "Interface\\EncounterJournal\\"..EJ_LOREBG,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[33113] = 1, --Flame Leviathan
			[33118] = 2, --Ignis the Furnace Master
			[33186] = 3, --Razorscale
			[33293] = 4, --XT-002 Deconstructor
			[32867] = 5, --Steelbreaker
			[32927] = 5, --Runemaster Molgeim
			[32857] = 5, --Stormcaller Brundir
			[32930] = 6, --Kologarn
			[32933] = 6, --Left Arm
			[32934] = 6, --Right Arm
			[33515] = 7, --Auriaya
			[32845] = 8, --Hodir
			[32865] = 9, --Thorim
			[32882] = 9, --Jormungar Behemoth
			[32906] = 10, --Freya
			[33350] = 11, --Mimiron
			[33271] = 12, --General Vezax
			[33136] = 13, --Guardian of Yogg-Saron
			[33288] = 13, --Yogg-Saron
			[32871] = 14, --Algalon the Observer
		},
	})
end