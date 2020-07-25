
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

DF_COOLDOWN_OFFENSIVE = 1
DF_COOLDOWN_PERSONAL = 2
DF_COOLDOWN_EXTERNAL = 3
DF_COOLDOWN_RAID = 4
DF_COOLDOWN_UTILITY = 5

local lust_id = 2825 
if UnitFactionGroup("player") == "Alliance" then 
	lust_id = 32182
end
DF.CooldownsBySpec = {
	-- 1 attack cooldown
	-- 2 personal defensive cooldown
	-- 3 targetted defensive cooldown
	-- 4 raid defensive cooldown
	-- 5 personal utility cooldown

	--MAGE
		--arcane
		[62]	= {
			[12042] = 1, --Arcane Power
			[55342] = 1, --Mirror Image
			[45438] = 2, --Ice Block
			[12051] = 5, --Evocation
		},
		--fire
		[63] = {
			[190319] = 1, --Combustion
			[55342] = 1, --Mirror Image
			[45438] = 2, --Ice Block
			[66] = 5, --Invisibility
		},
		--frost
		[64] = {
			[12472] = 1, --Icy Veins
			[55342] = 1, --Mirror Image
			[45438] = 2, --Ice Block
			[66] = 5, --Invisibility
			[11958] = 5, --Cold Snap
		},

	--PRIEST
		--discipline
		[256] = {
			[34433] = 1, --Shadowfiend
			[33206] = 3, --Pain Suppression
			[64844] = 4, --Divine Hymn
			[64901] = 4, --Hymn of Hope
			[47536] = 5, --Rapture
			[19236] = 5, --Desperate Prayer
			[8122] = 5, --Psychic Scream
		},
		--holy
		[257] = {
			[47788] = 3, --Guardian Spirit
			[64844] = 4, --Divine Hymn
			[64901] = 4, --Hymn of Hope
			[19236] = 5, --Desperate Prayer
			[8122] = 5, --Psychic Scream
		},
		--shadow priest
		[258] = {
			[34433] = 1, --Shadowfiend
			[64844] = 4, --Divine Hymn
			[64901] = 4, --Hymn of Hope
			[47585] = 2, --Dispersion
			[64044] = 5, --Psychic Horror
			[8122] = 5, --Psychic Scream
		},

	--ROGUE
		--assassination
		[259] = {
			[1856] = 2, --Vanish
			[5277] = 2, --Evasion
			[31224] = 2, --Cloak of Shadows
			[2094] = 5, --Blind
		},
		--outlaw
		[260] = {
			[13750] = 1, --Adrenaline Rush
			[51690] = 1, --Killing Spree (talent)
			[31224] = 2, --Cloak of Shadows
			[1856] = 2, --Vanish
			[2094] = 5, --Blind
		},
		--subtlety
		[261] = {
			[31224] = 2, --Cloak of Shadows
			[1856] = 2, --Vanish
			[5277] = 2, --Evasion
			[2094] = 5, --Blind
			[51713] = 1, --Shadow Dance
		},

	--WARLOCK
		--affliction
		[265] = {
			[47847] = 5, --Shadowfury
			[47860] = 5, --Death Coil
		},
		--demo
		[266] = {
			[47847] = 5, --Shadowfury
			[47860] = 5, --Death Coil
		},
		--destro
		[267] = {
			[1122] = 1, --Summon Infernal
			[47860] = 5, --Death Coil
			[47847] = 5, --Shadowfury
		},

	--WARRIOR
		--Arms
		[71] = {
			[46924] = 1, -- Bladestorm(talent)
			[5246] = 5, --Intimidating Shout
		},
		--Fury
		[72] = {
			[1719] = 1, --Recklessness
			[5246] = 5, --Intimidating Shout
		},
		--Protection
		[73] = {
			[12975] = 2, --Last Stand
			[871] = 2, --Shield Wall
			[5246] = 5, --Intimidating Shout
		},

	--PALADIN
		--holy
		[65] = {
			[31884] = 1, --Avenging Wrath

			[498] = 2, --Divine Protection
			[642] = 2, --Divine Shield

			[10278] = 3, --Blessing of Protection
			[48788] = 3, --Lay on Hands
		    [6940] = 3, -- Hand of Sacrifice
			[31821] = 4, --Aura Mastery

			[1044] = 5, --Blessing of Freedom
			[10308] = 5, --Hammer of Justice
		},

		--protection
		[66] = {
			[31884] = 1, --Avenging Wrath

			[31850] = 2, --Ardent Defender
			[10278] = 3, --Blessing of Protection
			[6940] = 3, -- Hand of Sacrifice
			[48788] = 3, --Lay on Hands
			[64205] = 4, -- Divine Sacrifice
			[642] = 2, -- Divine Shield
			[498] = 2, -- Divine Protection
			[1044] = 5, --Blessing of Freedom
			[10308] = 5, --Hammer of Justice
		},

		--retribution
		[70] = {
			[31884] = 1, --Avenging Wrath

			[642] = 2, --Divine Shield

			[10278] = 3, --Blessing of Protection
			[48788] = 3, --Lay on Hands
			[6940] = 3, -- Hand of Sacrifice
			[642] = 2, -- Divine Shield
			[498] = 2, -- Divine Protection
			[1044] = 5, --Blessing of Freedom
			[10308] = 5, --Hammer of Justice
		},

	--DEATH KNIGHT
		--unholy
		[252] = {
			[42650] = 1, --Army of the Dead
			[49206] = 1, --Summon Gargoyle (talent)

			[48792] = 2, --Icebound Fortitude
			[48743] = 2, --Death Pact (talent)

		},
		--frost
		[251] = {
			[47568] = 1, --Empower Rune Weapon

			[48792] = 2, --Icebound Fortitude
			[48743] = 2, --Death Pact (talent)
		},
		--blood
		[250] = {
			[49028] = 1, --Dancing Rune Weapon

			[55233] = 2, --Vampiric Blood
			[48792] = 2, --Icebound Fortitude
		},

	--DRUID
		--balance
		[102] = {
			[22812] = 2, --Barkskin
			[48447] = 4, --Tranquility
			[29166] = 3, --Innervate
			[48477] = 3, --Rebirth
		},
		--feral
		[103] = {
			[22812] = 2, --Barkskin
			[61336] = 2, --Survival Instincts
			[77764] = 4, --Stampeding Roar
			[48447] = 4, --Tranquility
			[29166] = 3, --Innervate
			[48477] = 3, --Rebirth
			[50334] = 1, --Berserk
		},
		-- guardian
		[104] = {			
			[22812] = 2, --Barkskin
			[61336] = 2, --Survival Instincts
			[77764] = 4, --Stampeding Roar
			[48447] = 4, --Tranquility
			[29166] = 3, --Innervate
			[48477] = 3, --Rebirth
			[50334] = 1, --Berserk
		},
		--restoration
		[105] = {

			[22812] = 2, --Barkskin
			[33891] = 2, --Incarnation: Tree of Life (talent)
			[29166] = 3, --Innervate

			[48447] = 4, --Tranquility
			[48477] = 3, --Rebirth
		},

	--HUNTER
		--beast mastery
		[253] = {
			[19574] = 1, --Bestial Wrath

			[19577] = 5, --Intimidation
		},
		--marksmanship
		[254] = {
			[19577] = 5, --Intimidation
		},
		--survival
		[255] = {
			[19577] = 5, --Intimidation
		},

	--SHAMAN
		--elemental
		[262] = {
			[16166] = 1, -- Elemental Mastery
			[lust_id] = 4, -- Bloodlust / Heroism
		},
		--enhancement
		[263] = {
			[51533] = 1, --Feral Spirit
			[lust_id] = 4, -- Bloodlust / Heroism
		},
		--restoration
		[263] = {
			[16190] = 3, -- Mana Tide Totem
			[lust_id] = 4, -- Bloodlust / Heroism
		},
}

-->  tells the duration, requirements and cooldown of a cooldown
DF.CooldownsInfo = {
	--> paladin
	[31884] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "PALADIN", type = 1}, --Avenging Wrath
	[498] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 2}, --Divine Protection
	[642] = {cooldown = 300, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 2}, --Divine Shield
	[64205] = {cooldown = 120, duration = 10, talent = 64205, charges =1, class = "PALADIN", type = 4}, -- Divine Sacrifice
	[10278] = {cooldown = 300, duration =10, talent = false, charges = 1, class = "PALADIN", type = 3}, -- Hand of Protection
	[48788] = {cooldown = 1200, duration = false, talent = false, charges = 1, class = "PALADIN", type = 3}, --Lay on Hands
	[31821] = {cooldown = 120, duration = 8, talent = 31821, charges = 1, class = "PALADIN", type = 4}, --Aura Mastery
	[1044] = {cooldown = 25, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 5}, --Blessing of Freedom
	[31850] = {cooldown = 120, duration = 8, talent = 31850, charges = 1, class = "PALADIN", type = 2}, --Ardent Defender
	[6940] = {cooldown = 120, duration = 12, talent = false, charges = 1, class = "PALADIN", type = 3}, --Blessing of Sacrifice
	[10308] = {cooldown = 60, duration = 6, talent = false, charges = 1, class = "PALADIN", type = 5}, -- Hammer of Justice

	--> warrior
	[1719] = {cooldown = 90, duration = 10, talent = false, charges = 1, class = "WARRIOR", type = 1}, --Recklessness
	[46924] = {cooldown = 60, duration = 4, talent = 46924, charges = 1, class = "WARRIOR", type = 1}, --Bladestorm (talent)
	[12975] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "WARRIOR", type = 2}, --Last Stand
	[871] = {cooldown = 8, duration = 240, talent = false, charges = 1, class = "WARRIOR", type = 2}, --Shield Wall

	--> warlock
	[1122] = {cooldown = 180, duration = 30, talent = false, charges = 1, class = "WARLOCK", type = 1}, --Summon Infernal
	[47860] = {cooldown = 120, duration = 3, talent = false, charges = 1, class = "WARLOCK", type = 5}, --Death Coil
	[47847] = {cooldown = 20, duration = 3, talent = false, charges = 1, class = "WARLOCK", type = 5}, --Shadowfury

	--> shaman
	[51533] = {cooldown = 120, duration = 15, talent = 51533, charges = 1, class = "SHAMAN", type = 1}, --Feral Spirit
	[16190] = {cooldown = 300, duration = 12, talent = 16190, charges = 1, class = "SHAMAN", type = 4}, --Mana Tide Totem
	[16166] = {cooldown = 120, duration = 15, talent = 16166, charges = 1, class = "SHAMAN", type = 4}, --Elemental Mastery
	[lust_id] = {cooldown = 300, duration = 40, talent = false, charges = 1, class = "SHAMAN", type = 4}, --Bloodlust / Heroism

	--> hunter
	[19574] = {cooldown = 90, duration = 12, talent = 19574, charges = 1, class = "HUNTER", type = 1}, --Bestial Wrath

	--> druid
	[22812] = {cooldown = 60, duration = 12, talent = false, charges = 1, class = "DRUID", type = 2}, --Barkskin
	[29166] = {cooldown = 180, duration = 12, talent = false, charges = 1, class = "DRUID", type = 3}, --Innervate
	[48477] = {cooldown = 600, duration = false, talent = false, charges = 1, class = "DRUID", type = 3}, --Rebirth
	[50334] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "DRUID", type = 1}, --Berserk
	[61336] = {cooldown = 120, duration = 6, talent = false, charges = 1, class = "DRUID", type = 2}, --Survival Instincts (2min feral 4min guardian, same spellid)
	[77764] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "DRUID", type = 4}, --Stampeding Roar (utility)
	[48447] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "DRUID", type = 4}, --Tranquility

	--> death knight
	[42650] = {cooldown = 480, duration = 30, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Army of the Dead
	[49206] = {cooldown = 180, duration = 30, talent = 49206, charges = 1, class = "DEATHKNIGHT", type = 1}, --Summon Gargoyle (talent)
	[48743] = {cooldown = 120, duration = 15, talent = 48743, charges = 1, class = "DEATHKNIGHT", type = 2}, --Death Pact (talent)
	[47568] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Empower Rune Weapon
	[49028] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Dancing Rune Weapon
	[55233] = {cooldown = 90, duration = 10, talent = false, charges = 1, class = "DEATHKNIGHT", type = 2}, --Vampiric Blood
	[48792] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "DEATHKNIGHT", type = 2}, --Icebound Fortitude

	--> mage
	[12042] = {cooldown = 90, duration = 10, talent = 12042, charges = 1, class = "MAGE", type = 1},  --Arcane Power
	[12051] = {cooldown = 90, duration = 6, talent = false, charges = 1, class = "MAGE", type = 1},  --Evocation
	[66] = {cooldown = 300, duration = 20, talent = false, charges = 1, class = "MAGE", type = 2},  --Invisibility
	[12472] = {cooldown = 180, duration = 20, talent = 12472, charges = 1, class = "MAGE", type = 1},  --Icy Veins
	[45438] = {cooldown = 240, duration = 10, talent = false, charges = 1, class = "MAGE", type = 2},  --Ice Block
	[11958] = {cooldown = 300, duration = false, talent = 11958, charges = 1, class = "MAGE", type = 5},  --Cold Snap

	--> priest
	[34433] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "PRIEST", type = 1},  -- Shadowfiend
	[33206] = {cooldown = 180, duration = 8, talent = 33206, charges = 1, class = "PRIEST", type = 3},  -- Pain Suppression
	[47537] = {cooldown = 90, duration = 10, talent = 47537, charges = 1, class = "PRIEST", type = 5},  -- Rapture, Rank 3
	[48173] = {cooldown = 90, duration = 10, talent = false, charges = 1, class = "PRIEST", type = 5},  -- Desperate Prayer, Rank 9
	[47788] = {cooldown = 180, duration = 10, talent = false, charges = 1, class = "PRIEST", type = 3},  -- Guardian Spirit
	[64844] = {cooldown = 480, duration = 8, talent = false, charges = 1, class = "PRIEST", type = 4},  -- Divine Hymn
	[64901] = {cooldown = 360, duration = 6, talent = false, charges = 1, class = "PRIEST", type = 4},  -- Hymn of Hope
	[10890] = {cooldown = 60, duration = 8, talent = false, charges = 1, class = "PRIEST", type = 5},  -- Psychic Scream, Rank 4
	[47585] = {cooldown = 120, duration = 6, talent = 47585, charges = 1, class = "PRIEST", type = 2},  -- Dispersion

	--> rogue
	[1856] = {cooldown = 120, duration = 3, talent = false, charges = 1, class = "ROGUE", type = 2},  --Vanish
	[5277] = {cooldown = 120, duration = 10, talent = false, charges = 1, class = "ROGUE", type = 2},  --Evasion
	[31224] = {cooldown = 120, duration = 5, talent = false, charges = 1, class = "ROGUE", type = 2},  --Cloak of Shadows
	[2094] = {cooldown = 120, duration = 60, talent = false, charges = 1, class = "ROGUE", type = 5},  --Blind
	[13750] = {cooldown = 180, duration = 20, talent = false, charges = 1, class = "ROGUE", type = 1},  --Adrenaline Rush
	[51690] = {cooldown = 120, duration = 2, talent = 51690, charges = 1, class = "ROGUE", type = 1},  --Killing Spree (talent)
	[51713] = {cooldown = 60, duration = 6, talent = 51713, charges = 1, class = "ROGUE", type = 1},  --Shadow Dance (talent)
}

-- {cooldown = , duration = , talent = false, charges = 1}

DF.CrowdControlSpells = {
	[5246] = "WARRIOR", --Intimidating Shout
	[46968] = "WARRIOR", --Shockwave (debuff spellid)

	[6215] = "WARLOCK", --Fear (debuff spellid)
	[47860] = "WARLOCK", --Death Coil
	[47847] = "WARLOCK", --Shadowfury
	[18647] = "WARLOCK", --Banish

	[12826] = "MAGE", --Polymorph
	[61305] = "MAGE", --Polymorph (black cat)
	[28271] = "MAGE", --Polymorph Turtle
	[61721] = "MAGE", --Polymorph Rabbit
	[28272] = "MAGE", --Polymorph Pig
	[61025] = "MAGE", --Polymorph Serpent
	[61780] = "MAGE", --Polymorph Turkey

	[42917] = "MAGE", --Frost Nova
	[42950] = "MAGE", --Dragon's Breath

	[605] = "PRIEST", --Mind Control
	[10890] = "PRIEST", --Psychic Scream
	[10955] = "PRIEST", --Shackle Undead
	[64044] = "PRIEST", --Psychic Horror (talent)

	[2094] = "ROGUE", --Blind
	[1833] = "ROGUE", --Cheap Shot
	[8643] = "ROGUE", --Kidney Shot
	[51724] = "ROGUE", --Sap
	[1776] = "ROGUE", --Gouge

	[10308] = "PALADIN", --Hammer of Justice
	[20066] = "PALADIN", --Repentance (talent)

	[49916] = "DEATHKNIGHT", --Strangulate(?? might be 66018)

	[53308] = "DRUID", --Entangling Roots
	[18658] = "DRUID", --Hibernate
	[61384] = "DRUID", --Typhoon
	[8983] = "DRUID", --Bash
	[45334] = "DRUID", --Immobilized (Charge)
	[49802] = "DRUID", --Maim
	[50259] = "DRUID", --Dazed (from Wild Charge)
	[33786] = "DRUID", --Cyclone 

	[14311] = "HUNTER", --Freezing Trap
	[19577] = "HUNTER", --Intimidation
	[13809] = "HUNTER", --Frost Trap
	[60192] = "HUNTER", --Freezing Arrow

	[51514] = "SHAMAN", --Hex
	[64695] = "SHAMAN", --Earthgrab (talent)
}

DF.SpecIds = {
	[250] = "DEATHKNIGHT",
	[251] = "DEATHKNIGHT",
	[252] = "DEATHKNIGHT",

	[71] = "WARRIOR",
	[72] = "WARRIOR",
	[73] = "WARRIOR",

	[62] = "MAGE",
	[63] = "MAGE",
	[64] = "MAGE",

	[259] = "ROGUE",
	[260] = "ROGUE",
	[261] = "ROGUE",

	[102] = "DRUID",
	[103] = "DRUID",
	[104] = "DRUID",
	[105] = "DRUID",

	[253] = "HUNTER",
	[254] = "HUNTER",
	[255] = "HUNTER",

	[262] = "SHAMAN",
	[263] = "SHAMAN",
	[254] = "SHAMAN",

	[256] = "PRIEST",
	[257] = "PRIEST",
	[258] = "PRIEST",

	[265] = "WARLOCK",
	[266] = "WARLOCK",
	[267] = "WARLOCK",

	[65] = "PALADIN",
	[66] = "PALADIN",
	[70] = "PALADIN",
}

DF.CooldownToClass = {}

DF.CooldownsAttack = {}
DF.CooldownsDeffense = {}
DF.CooldownsExternals = {}
DF.CooldownsRaid = {}
DF.CooldownsUtility = {}

DF.CooldownsAllDeffensive = {}

for specId, cooldownTable in pairs (DF.CooldownsBySpec) do

	for spellId, cooldownType in pairs (cooldownTable) do

		if (cooldownType == 1) then
			DF.CooldownsAttack [spellId] = true

		elseif (cooldownType == 2) then
			DF.CooldownsDeffense [spellId] = true
			DF.CooldownsAllDeffensive [spellId] = true

		elseif (cooldownType == 3) then
			DF.CooldownsExternals [spellId] = true
			DF.CooldownsAllDeffensive [spellId] = true

		elseif (cooldownType == 4) then
			DF.CooldownsRaid [spellId] = true
			DF.CooldownsAllDeffensive [spellId] = true

		elseif (cooldownType == 5) then
			DF.CooldownsUtility [spellId] = true
		end

		DF.CooldownToClass [spellId] = DF.SpecIds [spellId]

	end

end

function DF:FindClassForCooldown (spellId)
	for specId, cooldownTable in pairs (DF.CooldownsBySpec) do
		local hasCooldown = cooldownTable [spellId]
		if (hasCooldown) then
			return DF.SpecIds [specId]
		end
	end
end

function DF:GetCooldownInfo (spellId)
	return DF.CooldownsInfo [spellId]
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--consumables

DF.FlaskIDs = {
	[67016] = true, -- Flask of the North (SP)
	[67017] = true, -- Flask of the North (AP)
	[67018] = true, -- Flask of the North (STR)
	[53755] = true, -- Flask of the Frost Wyrm
	[53758] = true, -- Flask of Stoneblood
	[53760] = true, -- Flask of Endless Rage
	[54212] = true, -- Flask of Pure Mojo
	[53752] = true, -- Lesser Flask of Toughness (50 Resilience)
	[17627] = true, -- Flask of Distilled Wisdom

	[33721] = true, -- Spellpower Elixir
	[53746] = true, -- Wrath Elixir
	[28497] = true, -- Elixir of Mighty Agility
	[53748] = true, -- Elixir of Mighty Strength
	[60346] = true, -- Elixir of Lightning Speed
	[60344] = true, -- Elixir of Expertise
	[60341] = true, -- Elixir of Deadly Strikes
	[60345] = true, -- Elixir of Armor Piercing
	[60340] = true, -- Elixir of Accuracy
	[53749] = true, -- Guru's Elixir

	[60343] = true, -- Elixir of Mighty Defense
	[53751] = true, -- Elixir of Mighty Fortitude
	[53764] = true, -- Elixir of Mighty Mageblood
	[60347] = true, -- Elixir of Mighty Thoughts
	[53763] = true, -- Elixir of Protection
	[53747] = true, -- Elixir of Spirit
}

DF.FoodIDs = {
	[35272] = 20, -- Well Fed
	[44106] = 20, -- "Well Fed" from Brewfest
	[43722] = 20, -- Enlightened

	[57356] = 40, -- Rhinolicious Wormsteak
	[57358] = 40, -- Hearty Rhino
	[57360] = 40, -- Snapper Extreme/Worg Tartare
	[57367] = 40, -- Blackened Dragonfin
	[57365] = 40, -- Cuttlesteak
	[57371] = 40, -- Dragonfin Filet
	[57399] = 40, -- Fish Feast
	[57329] = 40, -- Spiced Worm Burger/Spicy Blue Nettlefish
	[57332] = 40, -- Imperial Manta Steak/Very Burnt Worg
	[57327] = 40, -- Firecracker Salmon/Tender Shoveltusk Steak
	[57325] = 40, -- Mega Mammoth Meal/Poached Northern Sculpin
	[57334] = 40, -- Mighty Rhino Dogs/Spicy Fried Herring
}

DF.PotionIDs = {
	[28494] = true, -- Insane Strength Potion
	[38929] = true, -- Fel mana potion

	[53909] = true, -- Potion of Wild Magic
	[53908] = true, -- Potion of Speed
	[53750] = true, -- Crazy Alchemist's Potion
	[53761] = true, -- Powerful Rejuvenation Potion
	[43185] = true, -- Healing Potion
	[43186] = true, -- Restore Mana
	[53753] = true, -- Nightmare Slumber
	[53910] = true, -- Arcane Protection
	[53911] = true, -- Fire Protection 
	[53913] = true, -- Frost Protection
	[53914] = true, -- Nature Protection
	[53915] = true, -- Shadow Protection
	[53762] = true, -- Indestructible
	[67490] = true, -- runic mana
}

--	/dump UnitAura ("player", 1)
--	/dump UnitAura ("player", 2)

function DF:GetSpellsForEncounterFromJournal (instanceEJID, encounterEJID)

	DetailsFramework.EncounterJournal.EJ_SelectInstance (instanceEJID)
	local name, description, encounterID, rootSectionID, link = DetailsFramework.EncounterJournal.EJ_GetEncounterInfo (encounterEJID) --taloc (primeiro boss de Uldir)

	if (not name) then
		print ("DetailsFramework: Encounter Info Not Found!", instanceEJID, encounterEJID)
		return {}
	end

	local spellIDs = {}

	--overview
	local sectionInfo = C_EncounterJournal.GetSectionInfo (rootSectionID)
	local nextID = {sectionInfo.siblingSectionID}

	while (nextID [1]) do
		--> get the deepest section in the hierarchy
		local ID = tremove (nextID)
		local sectionInfo = C_EncounterJournal.GetSectionInfo (ID)

		if (sectionInfo) then
			if (sectionInfo.spellID and type (sectionInfo.spellID) == "number" and sectionInfo.spellID ~= 0) then
				tinsert (spellIDs, sectionInfo.spellID)
			end

			local nextChild, nextSibling = sectionInfo.firstChildSectionID, sectionInfo.siblingSectionID
			if (nextSibling) then
				tinsert (nextID, nextSibling)
			end
			if (nextChild) then
				tinsert (nextID, nextChild)
			end
		else
			break
		end
	end

	return spellIDs
end

--default spells to use in the range check
DF.SpellRangeCheckListBySpec = {
	-- 185245 spellID for Torment, it is always failing to check range with IsSpellInRange()

	[250] = 56222, --> blood dk - dark command
	[251] = 56222, --> frost dk - dark command
	[252] = 56222, --> unholy dk - dark command

	[102] = 8921, -->  druid balance - Moonfire (45 yards)
	[103] = 8921, -->  druid feral - Moonfire (40 yards)
	[104] = 6795, -->  druid guardian - Growl
	[105] = 8921, -->  druid resto - Moonfire (40 yards)

	[253] = 193455, -->  hunter bm - Cobra Shot
	[254] = 19434, --> hunter marks - Aimed Shot
	[255] = 271788, --> hunter survivor - Serpent Sting

	[62] = 227170, --> mage arcane - arcane blast
	[63] = 133, --> mage fire - fireball
	[64] = 228597, --> mage frost - frostbolt

	[65] = 20473, --> paladin holy - Holy Shock (40 yards)
	[66] = 62124, --> paladin protect - Hand of Reckoning
	[70] = 62124, --> paladin ret - Hand of Reckoning

	[256] = 585, --> priest disc - Smite
	[257] = 585, --> priest holy - Smite
	[258] = 8092, --> priest shadow - Mind Blast

	[259] = 185565, --> rogue assassination - Poisoned Knife (30 yards)
	[260] = 185763, --> rogue outlaw - Pistol Shot (20 yards)
	[261] = 114014, --> rogue sub - Shuriken Toss (30 yards)

	[262] = 188196, --> shaman elemental - Lightning Bolt
	[263] = 187837, --> shaman enhancement - Lightning Bolt (instance cast)
	[264] = 403, --> shaman resto - Lightning Bolt

	[265] = 686, --> warlock aff - Shadow Bolt
	[266] = 686, --> warlock demo - Shadow Bolt
	[267] = 116858, --> warlock destro - Chaos Bolt

	[71] = 355, --> warrior arms - Taunt
	[72] = 355, --> warrior fury - Taunt
	[73] = 355, --> warrior protect - Taunt
}









