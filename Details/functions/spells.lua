do
	local _detalhes = _G._detalhes

	_detalhes.PotionList = {}

	--import potion list from the framework
	for spellID, _ in pairs(DetailsFramework.PotionIDs) do
		_detalhes.PotionList[spellID] = true
	end

	_detalhes.SpecSpellList = { --~spec
		-- Unholy Death Knight:
		[49206] = 252, -- Summon Gargoyle
		[55271] = 252, -- Scourge Strike, Rank 4
		[51161] = 252, -- Ebon Plaguebringer, Rank 3
		[55271] = 252, -- Scourge Strike, Rank 4

		-- Frost Death Knight:
		[55268] = 251, -- Frost Strike, Rank 6
		[66962] = 251, -- Frost Strike Off-Hand, Rank 6
		[51411] = 251, -- Howling Blast, Rank 4

		-- Blood Death Knight:
		[55233] = 250, -- Vampiric Blood
		[49028] = 250, -- Dancing Rune Weapon
		[55262] = 250, -- Heart Strike

		-- Balance Druid:
		[53201] = 102, -- Starfall, Rank 4
		[48465] = 102, -- Starfire, Rank 10
		[48468] = 102, -- Insect Swarm, Rank 7

		-- Feral Druid:
		[49802] = 103, -- Maim, Rank 2
		[52610] = 103, -- Savage Roar
		[50213] = 103, -- Tiger's Fury, Rank 6
		[48574] = 103, -- Rake, Rank 7
		[49800] = 103, -- Rip, Rank 9

		-- Guardian Druid:
		[48568] = 104, -- Lacerate, Rank 3
		[48480] = 104, -- Maul, Rank 10
		[62606] = 104, -- Savage Defense

		-- Restoration Druid:
		[48451] = 105, -- Lifebloom, Rank 3
		[53251] = 105, -- Wild Growth, Rank 4
		[18562] = 105, -- Swiftmend

		-- Beast Mastery Hunter:
		[19574] = 253, -- Bestial Wrath
		[53257] = 253, -- Cobra Strikes

		-- Marksmanship Hunter:
		[53209] = 254, -- Chimera Shot
		[19506] = 254, -- Trueshot Aura

		-- Survival Hunter:
		[63672] = 255, -- Black Arrow Rank 6
		[60053] = 255, -- Explosive Shot Rank 4

		-- Arcane Mage:
		[12042] = 62, -- Arcane Power
		[31589] = 62, -- Slow
		[42846] = 62, -- Arcane Missiles, Rank 13
		[44781] = 62, -- Arcane Barrage, Rank 3
		[42897] = 62, -- Arcane Blast, Rank 4

		-- Fire Mage:
		[55360] = 63, -- Living Bomb, Rank 3
		[42950] = 63, -- Dragon's Breath, Rank 6
		[42859] = 63, -- Scorch, Rank 11
		[42833] = 63, -- Fireball, Rank 16
		[42891] = 63, -- Pyroblast, Rank 12

		-- Frost Mage:
		[42914] = 64, -- Ice Lance, Rank 3
		[42842] = 64, -- Frostbolt, Rank 16
		[44572] = 64, -- Deep Freeze

		-- Holy Paladin:
		[53563] = 65, -- Beacon of Light
		[48825] = 65, -- Holy Shock, Rank 7
		[54937] = 65, -- Glyph of Holy Light

		-- Protection Paladin:
		[53595] = 66, -- Hammer of the Righteous
		[48827] = 66, -- Avenger's Shield, Rank 5
		[48952] = 66, -- Holy Shield, Rank 6

		-- Retribution Paladin:
		[53385] = 70, -- Divine Storm
		[35395] = 70, -- Crusader Strike
		
		-- Discipline Priest:
		[10060] = 256, -- Power Infusion
		[33206] = 256, -- Pain Suppression
		[52985] = 256, -- Penance, Rank 4
		[52800] = 256, -- Borrowed Time, Rank 5

		-- Holy Priest:
		[48089] = 257, -- Circle of Healing, Rank 7
		[47788] = 257, -- Guardian Spirit

		-- Shadow Priest:
		[15286] = 258, -- Vampiric Embrace
		[48160] = 258, -- Vampiric Touch, Rank 5
		[48156] = 258, -- Mind Flay, Rank 9

		-- Assassination Rogue:
		[32645] = 259, -- Envenom
		[1329] = 259, -- Mutilate
		[5374] = 259, -- Mutilate
		[27576] = 259, -- Mutilate Off-Hand
		[14177] = 259, -- Cold Blood
		[51662] = 259, -- Hunger for Blood

		-- Combat Rogue:
		[51690] = 260, -- Killing Spree
		[13750] = 260, -- Adrenaline Rush
		[13877] = 260, -- Blade Flurry
		[14251] = 260, -- Riposte

		-- Subtlety Rogue:
		[48660] = 261, -- Hemorrhage rank 5
		[14183] = 261, -- Premeditation
		[14185] = 261, -- Preparation
		[51713] = 261, -- Shadow Dance
		[14278] = 261, -- Ghostly Strike

		-- Elemental Shaman:
		[29000] = 262, -- Elemental Reach, Rank 2
		[59159] = 262, -- Thunderstorm, Rank 4
		[16164] = 262, -- Elemental Focus
		[16246] = 262, -- Elemental Focus Effect
		[16166] = 262, -- Elemental Mastery
		[64701] = 262, -- Elemental Mastery Effect
		[57722] = 262, -- Totem of Wrath, Rank 4

		-- Enhancement Shaman:
		[51533] = 263, -- Feral Spirit
		[51530] = 263, -- Maelstrom Weapon
		[25504] = 263, -- Windfury attack
		[17364] = 263, -- Stormstrike
		[32175] = 263, -- Stormstrike
		[32176] = 263, -- Stormstrike off hand
		[16282] = 263, -- Flurry
		[10444] = 263, -- Flametongue attack
		[60103] = 263, -- Lava Lash
		[30812] = 263, -- Mental Quickness, Rank 1
		[30813] = 263, -- Mental Quickness, Rank 2
		[30814] = 263, -- Mental Quickness, Rank 3
		[51521] = 263, -- Improved Stormstrike, Rank 1
		[51522] = 263, -- Improved Stormstrike, Rank 2

		-- Restoration Shaman:
		[51566] = 264, -- Tidal Waves, Rank 5
		[55459] = 264, -- Chain Heal, Rank 7
		[49284] = 264, -- Earth Shield, Rank 5
		[61301] = 264, -- Riptide, Rank 4

		-- Affliction :
		[59164] = 265, -- Haunt, Rank 4
		[47843] = 265, -- Unstable Affliction, Rank 5

		-- Demonology Warlock:
		[30146] = 266, -- Summon Felguard
		[47241] = 266, -- Metamorphosis
		[47240] = 266, -- Demonic Pact, Rank 5
		[47825] = 266, -- Soul Fire, Rank 6

		-- Destruction Warlock:
		[59172] = 267, -- Chaos Bolt, Rank 4
		[17962] = 267, -- Conflagrate

		-- Arms Warrior:
		[12328] = 71, -- Sweeping Strikes
		[56636] = 71, -- Taste for Blood, Rank 1
		[56637] = 71, -- Taste for Blood, Rank 2
		[56638] = 71, -- Taste for Blood, Rank 3
		[12294] = 71, -- Mortal Strike

		-- Fury Warrior:
		[23881] = 72, -- Bloodthirst
		[29801] = 72, -- Rampage
		[23588] = 72, -- Dual Wield Specialization, Rank 5
		[46917] = 72, -- Titan's Grip
		[49152] = 72, -- Titan's Grip Effect

		-- Protection Warrior:
		[871] = 73, -- Shield Wall
		[12975] = 73, -- Last Stand
		[57823] = 73, -- Revenge
		[47498] = 73, -- Devastate
		[2565] = 73, -- Shield Block
		[47488] = 73, -- Shield Slam
		[46953] = 73, -- Sword and Board
		[50227] = 73, -- Sword and Board Trigger
	}

	_detalhes.SpecIDToClass = {
		[252] = "DEATHKNIGHT", -- Unholy Death Knight
		[251] = "DEATHKNIGHT", -- Frost Death Knight
		[250] = "DEATHKNIGHT", -- Blood Death Knight

		[102] = "DRUID", -- Balance Druid
		[103] = "DRUID", -- Feral Druid
		[104] = "DRUID", -- Guardian Druid
		[105] = "DRUID", -- Restoration Druid

		[253] = "HUNTER", -- Beast Mastery Hunter
		[254] = "HUNTER", -- Marksmanship Hunter
		[255] = "HUNTER", -- Survival Hunter

		[62] = "MAGE", -- Arcane Mage
		[63] = "MAGE", -- Fire Mage
		[64] = "MAGE", -- Frost Mage

		[65] = "PALADIN", -- Holy Paladin
		[66] = "PALADIN", -- Protection Paladin
		[70] = "PALADIN", -- Retribution Paladin

		[256] = "PRIEST", -- Discipline Priest
		[257] = "PRIEST", -- Holy Priest
		[258] = "PRIEST", -- Shadow Priest

		[259] = "ROGUE", -- Assassination Rogue
		[260] = "ROGUE", -- Outlaw Rogue
		[261] = "ROGUE", -- Subtlety Rogue

		[262] = "SHAMAN", -- Elemental Shaman
		[263] = "SHAMAN", -- Enhancement Shaman
		[264] = "SHAMAN", -- Restoration Shaman

		[265] = "WARLOCK", -- Affliction Warlock
		[266] = "WARLOCK", -- Demonology Warlock
		[267] = "WARLOCK", -- Destruction Warlock

		[71] = "WARRIOR", -- Arms Warrior
		[72] = "WARRIOR", -- Fury Warrior
		[73] = "WARRIOR", -- Protection Warrior
	}

	_detalhes.ClassSpellList = {
	--death knight
		[3714]	= "DEATHKNIGHT", -- Path of Frost
		[42650]	= "DEATHKNIGHT", -- Army of the Dead
		[43265]	= "DEATHKNIGHT", -- Death and Decay
		[45462]	= "DEATHKNIGHT", -- Plague Strike
		[45470]	= "DEATHKNIGHT", -- Death Strike(heal)
		[45477]	= "DEATHKNIGHT", -- Icy Touch
		[45524]	= "DEATHKNIGHT", -- Chains of Ice
		[45529]	= "DEATHKNIGHT", -- Blood Tap
		[45902]	= "DEATHKNIGHT", -- Blood Strike
		[47528]	= "DEATHKNIGHT", -- Mind Freeze
		[47541]	= "DEATHKNIGHT", -- Death Coil
		[47568]	= "DEATHKNIGHT", -- Empower Rune Weapon
		[47632]	= "DEATHKNIGHT", -- death coil
		[48263]	= "DEATHKNIGHT", -- Blood Presence
		[48265]	= "DEATHKNIGHT", -- Unholy Presence
		[48266]	= "DEATHKNIGHT", -- Frost Presence
		[48707]	= "DEATHKNIGHT", -- Anti-Magic Shell(heal)
		[48721]	= "DEATHKNIGHT", -- Blood Boil
		[48743]	= "DEATHKNIGHT", -- Death Pact
		[48792]	= "DEATHKNIGHT", -- Icebound Fortitude
		[48982]	= "DEATHKNIGHT", -- rune tap
		[49016]	= "DEATHKNIGHT", -- Unholy Frenzy
		[49020]	= "DEATHKNIGHT", -- obliterate
		[49028]	= "DEATHKNIGHT", -- Dancing Rune Weapon
		[49039]	= "DEATHKNIGHT", -- Lichborne
		[49143]	= "DEATHKNIGHT", -- frost strike
		[49184]	= "DEATHKNIGHT", -- howling blast
		[49206]	= "DEATHKNIGHT", -- Summon Gargoyle
		[49222]	= "DEATHKNIGHT", -- Bone Shield
		[49576]	= "DEATHKNIGHT", -- Death Grip
		[49998]	= "DEATHKNIGHT", -- death strike
		[50401]	= "DEATHKNIGHT", -- "Razorice"
		[50842]	= "DEATHKNIGHT", -- Pestilence
		[50977]	= "DEATHKNIGHT", -- Death Gate
		[51271]	= "DEATHKNIGHT", -- Pillar of Frost
		[52212]	= "DEATHKNIGHT", -- "Death and Decay"
		[53365]	= "DEATHKNIGHT", -- Unholy Strength(heal)
		[55050]	= "DEATHKNIGHT", -- Heart Strike
		[55078]	= "DEATHKNIGHT", -- blood plague
		[55090]	= "DEATHKNIGHT", -- scourge strike
		[55095]	= "DEATHKNIGHT", -- frost fever
		[55233]	= "DEATHKNIGHT", -- Vampiric Blood
		[56222]	= "DEATHKNIGHT", -- Dark Command
		[56815]	= "DEATHKNIGHT", -- Rune Strike
		[57330]	= "DEATHKNIGHT", -- Horn of Winter
		[61999]	= "DEATHKNIGHT", -- Raise Ally
		[63560]	= "DEATHKNIGHT", -- Dark Transformation
		[66196]	= "DEATHKNIGHT", -- "Frost Strike Off-Hand"
		[66198]	= "DEATHKNIGHT", -- "Obliterate Off-Hand"
		[66216]	= "DEATHKNIGHT", -- "Plague Strike Off-Hand"
		[73975]	= "DEATHKNIGHT", -- Necrotic Strike
		[77535]	= "DEATHKNIGHT", -- Blood Shield(heal)
		[77575]	= "DEATHKNIGHT", -- Outbreak
		[77606]	= "DEATHKNIGHT", -- Dark Simulacrum
		[85948]	= "DEATHKNIGHT", -- Festering Strike
		[96268]	= "DEATHKNIGHT", -- Death's Advance

	--druid
		[768]	= "DRUID", -- Cat Form
		[770]	= "DRUID", -- Faerie Fire
		[774]	= "DRUID", -- rejuvenation
		[779]	= "DRUID", -- Swipe
		[1079]	= "DRUID", -- rip
		[1126]	= "DRUID", -- Mark of the Wild
		[1822]	= "DRUID", -- rake
		[1850]	= "DRUID", -- Dash
		[2908]	= "DRUID", -- Soothe
		[2912]	= "DRUID", -- starfire
		[5176]	= "DRUID", -- wrath
		[5185]	= "DRUID", -- healing touch
		[5211]	= "DRUID", -- Mighty Bash
		[5215]	= "DRUID", -- Prowl
		[5217]	= "DRUID", -- tiger's fury(energy gain)
		[5221]	= "DRUID", -- shred
		[5225]	= "DRUID", -- Track Humanoids
		[5229]	= "DRUID", -- Enrage
		[6785]	= "DRUID", -- Ravage
		[6795]	= "DRUID", -- Growl
		[6807]	= "DRUID", -- Maul
		[8921]	= "DRUID", -- moonfire
		[8936]	= "DRUID", -- regrowth
		[9005]	= "DRUID", -- Pounce
		[16689]	= "DRUID", -- Nature's Grasp
		[16914]	= "DRUID", -- Hurricane
		[16953]	= "DRUID", -- Primal Fury
		[16959]	= "DRUID", -- primal fury(energy gain)
		[16979]	= "DRUID", -- Wild Charge
		[17057]	= "DRUID", -- bear form(energy gain)
		[18562]	= "DRUID", -- Swiftmend
		[20484]	= "DRUID", -- "Rebirth"
		[22568]	= "DRUID", -- Ferocious Bite
		[22570]	= "DRUID", -- Maim
		[22812]	= "DRUID", -- Barkskin
		[22842]	= "DRUID", -- Frenzied Regeneration
		[24858]	= "DRUID", -- Moonkin Form
		[29166]	= "DRUID", -- innervate
		[33745]	= "DRUID", -- Lacerate
		[33763]	= "DRUID", -- Lifebloom
		[33778]	= "DRUID", -- lifebloom
		[33831]	= "DRUID", -- Force of Nature
		[33876]	= "DRUID", -- mangle
		[33878]	= "DRUID", -- mangle(energy gain)
		[33878]	= "DRUID", -- mangle(energy)
		[33891]	= "DRUID", -- Incarnation: Tree of Life
		[33917]	= "DRUID", -- "Mangle"
		[42231]	= "DRUID", -- "Hurricane"
		[44203]	= "DRUID", -- tranquility
		[48438]	= "DRUID", -- wild growth
		[48503]	= "DRUID", -- living seed
		[48505]	= "DRUID", -- Starfall
		[49376]	= "DRUID", -- Wild Charge
		[50288]	= "DRUID", -- "Starfall"
		[50334]	= "DRUID", -- Berserk
		[50464]	= "DRUID", -- nourish
		[52610]	= "DRUID", -- Savage Roar
		[61336]	= "DRUID", -- Survival Instincts
		[61391]	= "DRUID", -- Typhoon
		[62078]	= "DRUID", -- Swipe
		[62606]	= "DRUID", -- Savage Defense
		[68285]	= "DRUID", -- leader of the pack(mana)

	--hunter
		[781]	= "HUNTER", -- Disengage
		[883]	= "HUNTER", -- Call Pet 1
		[1130]	= "HUNTER", --'s Mark
		[1543]	= "HUNTER", -- Flare HUNTER
		[1978]	= "HUNTER", -- Serpent Sting
		[2641]	= "HUNTER", -- Dismiss Pet
		[2643]	= "HUNTER", -- Multi-Shot
		[3044]	= "HUNTER", --arcane shot
		[3045]	= "HUNTER", -- Rapid Fire
		[3674]	= "HUNTER", -- Black Arrow
		[5116]	= "HUNTER", -- Concussive Shot
		[5118]	= "HUNTER", -- Aspect of the Cheetah
		[13159]	= "HUNTER", -- Aspect of the Pack
		[13165]	= "HUNTER", -- Aspect of the Hawk HUNTER
		[13812]	= "HUNTER", -- "Explosive Trap"
		[13813]	= "HUNTER", -- "Explosive Trap"
		[19263]	= "HUNTER", -- Deterrence
		[19386]	= "HUNTER", -- Wyvern Sting
		[19434]	= "HUNTER", -- Aimed Shot
		[19503]	= "HUNTER", -- Scatter Shot HUNTER
		[19574]	= "HUNTER", -- Bestial Wrath
		[19577]	= "HUNTER", -- Intimidation
		[19801]	= "HUNTER", -- Tranquilizing Shot
		[20736]	= "HUNTER", -- Distracting Shot HUNTER
		[34026]	= "HUNTER", -- Kill Command
		[34477]	= "HUNTER", -- Misdirection
		[34490]	= "HUNTER", -- Silencing Shot
		[51753]	= "HUNTER", -- Camouflage HUNTER
		[53209]	= "HUNTER", -- Chimera Shot
		[53271]	= "HUNTER", -- Master's Call HUNTER
		[53301]	= "HUNTER", -- explosive shot
		[53351]	= "HUNTER", -- kill shot
		[53353]	= "HUNTER", -- "Chimaera Shot"
		[56641]	= "HUNTER", -- Steady Shot
		[60192]	= "HUNTER", -- "Freezing Trap"
		[77767]	= "HUNTER", -- cobra shot

	-- Mage
		[44781]	= "MAGE", -- Arcane Barrage, Rank 3
		[42897]	= "MAGE", -- Arcane Blast, Rank 4
		[42995]	= "MAGE", -- Arcane Brilliance, Rank 7
		[42921]	= "MAGE", -- Arcane Explosion, Rank 10
		[42845]	= "MAGE", -- Arcane Missiles, Rank 13
		[12042]	= "MAGE", -- Arcane Power
		[1953]	= "MAGE", -- Blink
		[42938]	= "MAGE", -- Blizzard, Rank 9
		[11958]	= "MAGE", -- Cold Snap
		[11129]	= "MAGE", -- Combustion
		[42956]	= "MAGE", -- Conjure Refreshment, Rank 2
		[2139]	= "MAGE", -- Counterspell
		[61316]	= "MAGE", -- Dalaran Brilliance
		[44572]	= "MAGE", -- Deep Freeze
		[42950]	= "MAGE", -- Dragon's Breath, Rank 6
		[12051]	= "MAGE", -- Evocation
		[42873]	= "MAGE", -- Fire Blast, Rank 11
		[42833]	= "MAGE", -- Fireball, Rank 16
		[42926]	= "MAGE", -- Flamestrike, Rank 9
		[116]	= "MAGE", -- Frostbolt, Rank 1
		[42842]	= "MAGE", -- Frostbolt, Rank 16
		[47610]	= "MAGE", -- Frostfire Bolt, Rank 2
		[43008]	= "MAGE", -- Ice Armor, Rank 6
		[43039]	= "MAGE", -- Ice Barrier, Rank 8
		[45438]	= "MAGE", -- Ice Block
		[42914]	= "MAGE", -- Ice Lance, Rank 3
		[12472]	= "MAGE", -- Icy Veins
		[55360]	= "MAGE", -- Living Bomb, Rank 3
		[55362]	= "MAGE", -- Living Bomb, Rank 3
		[43020]	= "MAGE", -- Mana Shield, Rank 9
		[55342]	= "MAGE", -- Mirror Image
		[12043]	= "MAGE", -- Presence of Mind
		[42891]	= "MAGE", -- Pyroblast, Rank 12
		[42859]	= "MAGE", -- Scorch, Rank 11
		[30449]	= "MAGE", -- Spellsteal
		[31687]	= "MAGE", -- Summon Water Elemental

	-- Paladin
		[66235]	= "PALADIN", -- Ardent Defender
		[31852]	= "PALADIN", -- Ardent Defender, Rank 3
		[48827]	= "PALADIN", -- Avenger's Shield, Rank 5
		[31884]	= "PALADIN", -- Avenging Wrath
		[53563]	= "PALADIN", -- Beacon of Light
		[53652]	= "PALADIN", -- Beacon of Light
		[20217]	= "PALADIN", -- Blessing of Kings
		[48932]	= "PALADIN", -- Blessing of Might, Rank 10
		[4987] 	= "PALADIN", -- Cleanse
		[48819]	= "PALADIN", -- Consecration, Rank 8
		[35395]	= "PALADIN", -- Crusader Strike
		[31821]	= "PALADIN", -- Devotion Aura
		[31842]	= "PALADIN", -- Divine Favor
		[54428]	= "PALADIN", -- Divine Plea
		[642]	= "PALADIN", -- Divine Shield
		[63148]	= "PALADIN", -- Divine Shield, Rank 2
		[53385]	= "PALADIN", -- Divine Storm
		[54172]	= "PALADIN", -- Divine Storm
		[48801]	= "PALADIN", -- Exorcism, Rank 9
		[48785]	= "PALADIN", -- Flash of Light, Rank 9
		[48806]	= "PALADIN", -- Hammer of Wrath, Rank 6
		[53595]	= "PALADIN", -- Hammer of the Righteous
		[1044] 	= "PALADIN", -- Hand of Freedom
		[62124]	= "PALADIN", -- Hand of Reckoning
		[48782]	= "PALADIN", -- Holy Light, Rank 13
		[48821]	= "PALADIN", -- Holy Shock, Rank 7
		[48825]	= "PALADIN", -- Holy Shock, Rank 7
		[31803]	= "PALADIN", -- Holy Vengeance
		[48817]	= "PALADIN", -- Holy Wrath, Rank 5
		[20271]	= "PALADIN", -- Judgement of Light
		[633]	= "PALADIN", -- Lay on Hands
		[17233]	= "PALADIN", -- Lay on Hands
		[48950]	= "PALADIN", -- Redemption, Rank 7
		[25780]	= "PALADIN", -- Righteous Fury
		[48952]	= "PALADIN", -- Sacred Shield, Rank 6
		[20164]	= "PALADIN", -- Seal of Justice
		[20165]	= "PALADIN", -- Seal of Light
		[20167]	= "PALADIN", -- Seal of Light
		[20154]	= "PALADIN", -- Seal of Righteousness
		[31801]	= "PALADIN", -- Seal of Truth
		[42463]	= "PALADIN", -- Seal of Truth
		[61411]	= "PALADIN", -- Shield of the Righteous, Rank 2

	-- Priest
		[48120]	= "PRIEST", -- Binding Heal, Rank 3
		[48089]	= "PRIEST", -- Circle of Healing, Rank 7
		[48173]	= "PRIEST", -- Desperate Prayer, Rank 9
		[48300]	= "PRIEST", -- Devouring Plague, Rank 9
		[47585]	= "PRIEST", -- Dispersion
		[47753]	= "PRIEST", -- Divine Aegis
		[64843]	= "PRIEST", -- Divine Hymn
		[64844]	= "PRIEST", -- Divine Hymn
		[586]	= "PRIEST", -- Fade
		[48071]	= "PRIEST", -- Flash Heal, Rank 11
		[56160]	= "PRIEST", -- Glyph of Power Word: Shield
		[48063]	= "PRIEST", -- Greater Heal, Rank 9
		[47788]	= "PRIEST", -- Guardian Spirit
		[2053]	= "PRIEST", -- Heal, Rank 3
		[48135]	= "PRIEST", -- Holy Fire, Rank 11
		[48076]	= "PRIEST", -- Holy Nova, Rank 9
		[64901]	= "PRIEST", -- Hymn of Hope
		[64904]	= "PRIEST", -- Hymn of Hope
		[25431]	= "PRIEST", -- Inner Fire, Rank 7
		[1706]	= "PRIEST", -- Levitate
		[34650]	= "PRIEST", -- Mana Leech
		[32375]	= "PRIEST", -- Mass Dispel
		[48127]	= "PRIEST", -- Mind Blast, Rank 13
		[48156]	= "PRIEST", -- Mind Flay, Rank 9
		[53022]	= "PRIEST", -- Mind Sear, Rank 2
		[53023]	= "PRIEST", -- Mind Sear, Rank 2
		[33206]	= "PRIEST", -- Pain Suppression
		[52985]	= "PRIEST", -- Penance, Rank 4
		[53000]	= "PRIEST", -- Penance, Rank 4
		[10060]	= "PRIEST", -- Power Infusion
		[48162]	= "PRIEST", -- Power Word: Fortitude, Rank 4
		[48066]	= "PRIEST", -- Power Word: Shield, Rank 14
		[48072]	= "PRIEST", -- Prayer of Healing, Rank 7
		[33110]	= "PRIEST", -- Prayer of Mending
		[48113]	= "PRIEST", -- Prayer of Mending, Rank 3
		[10890]	= "PRIEST", -- Psychic Scream, Rank 4
		[48068]	= "PRIEST", -- Renew, Rank 14
		[48171]	= "PRIEST", -- Resurrection, Rank 7
		[48158]	= "PRIEST", -- Shadow Word: Death, Rank 4
		[48125]	= "PRIEST", -- Shadow Word: Pain, Rank 12
		[34433]	= "PRIEST", -- Shadowfiend
		[15473]	= "PRIEST", -- Shadowform
		[15487]	= "PRIEST", -- Silence
		[48123]	= "PRIEST", -- Smite, Rank 12
		[15286]	= "PRIEST", -- Vampiric Embrace
		[15290]	= "PRIEST", -- Vampiric Embrace
		[34919]	= "PRIEST", -- Vampiric Touch
		[48160]	= "PRIEST", -- Vampiric Touch, Rank 5

	-- Rogue
		[13750]	= "ROGUE", -- Adrenaline Rush
		[48691]	= "ROGUE", -- Ambush, Rank 10
		[48657]	= "ROGUE", -- Backstab, Rank 12
		[13877]	= "ROGUE", -- Blade Flurry
		[22482]	= "ROGUE", -- Blade Flurry
		[2094]	= "ROGUE", -- Blind
		[1833]	= "ROGUE", -- Cheap Shot
		[31224]	= "ROGUE", -- Cloak of Shadows
		[35546]	= "ROGUE", -- Combat Potency, Rank 3
		[35547]	= "ROGUE", -- Combat Potency, Rank 4
		[35548]	= "ROGUE", -- Combat Potency, Rank 5
		[3408]	= "ROGUE", -- Crippling Poison
		[2818]	= "ROGUE", -- Deadly Poison
		[2823]	= "ROGUE", -- Deadly Poison
		[57993]	= "ROGUE", -- Envenom, Rank 4
		[5277]	= "ROGUE", -- Evasion
		[48668]	= "ROGUE", -- Eviscerate, Rank 12
		[48669]	= "ROGUE", -- Expose Armor, Rank 7
		[51723]	= "ROGUE", -- Fan of Knives
		[48658]	= "ROGUE", -- Feint, Rank 7
		[51637]	= "ROGUE", -- Focused Attacks
		[11290]	= "ROGUE", -- Garrote, Rank 6
		[38764]	= "ROGUE", -- Gouge, Rank 6
		[48660]	= "ROGUE", -- Hemorrhage, Rank 5
		[8679]	= "ROGUE", -- Instant Poison
		[8680]	= "ROGUE", -- Instant Poison
		[1766]	= "ROGUE", -- Kick
		[8643]	= "ROGUE", -- Kidney Shot, Rank 2
		[51690]	= "ROGUE", -- Killing Spree
		[57841]	= "ROGUE", -- Killing Spree
		[57842]	= "ROGUE", -- Killing Spree
		[5761]	= "ROGUE", -- Mind-numbing Poison
		[48664]	= "ROGUE", -- Mutilate, Rank 6
		[48665]	= "ROGUE", -- Mutilate, Rank 6
		[48666]	= "ROGUE", -- Mutilate, Rank 6
		[14183]	= "ROGUE", -- Premeditation
		[14185]	= "ROGUE", -- Preparation
		[48672]	= "ROGUE", -- Rupture, Rank 9
		[51713]	= "ROGUE", -- Shadow Dance
		[36554]	= "ROGUE", -- Shadowstep
		[48638]	= "ROGUE", -- Sinister Strike, Rank 12
		[6774]	= "ROGUE", -- Slice and Dice, Rank 2
		[11305]	= "ROGUE", -- Sprint, Rank 3
		[1787]	= "ROGUE", -- Stealth, Rank 4
		[57934]	= "ROGUE", -- Tricks of the Trade

	-- Shaman
		[49277]	= "SHAMAN", -- Ancestral Spirit, Rank 7
		[16188]	= "SHAMAN", -- Ancestral Swiftness
		[2825]	= "SHAMAN", -- Bloodlust
		[55459]	= "SHAMAN", -- Chain Heal, Rank 7
		[49271]	= "SHAMAN", -- Chain Lightning, Rank 8
		[51886]	= "SHAMAN", -- Cleanse Spirit
		[2062]	= "SHAMAN", -- Earth Elemental Totem
		[49231]	= "SHAMAN", -- Earth Shock, Rank 10
		[51486]	= "SHAMAN", -- Earthgrab Totem, Rank 3
		[51994]	= "SHAMAN", -- Earthliving Weapon, Rank 6
		[52000]	= "SHAMAN", -- Earthliving, Rank 6
		[61882]	= "SHAMAN", -- Earthquake
		[16166]	= "SHAMAN", -- Elemental Mastery
		[51533]	= "SHAMAN", -- Feral Spirit
		[2894]	= "SHAMAN", -- Fire Elemental Totem
		[61654]	= "SHAMAN", -- Fire Nova, Rank 9
		[49233]	= "SHAMAN", -- Flame Shock, Rank 9
		[10444]	= "SHAMAN", -- Flametongue Attack
		[58790]	= "SHAMAN", -- Flametongue Weapon, Rank 10
		[49236]	= "SHAMAN", -- Frost Shock, Rank 7
		[58796]	= "SHAMAN", -- Frostbrand Weapon, Rank 9
		[2645]	= "SHAMAN", -- Ghost Wolf
		[55533]	= "SHAMAN", -- Glyph of Healing Wave
		[8177]	= "SHAMAN", -- Grounding Totem
		[6377]	= "SHAMAN", -- Healing Stream Totem, Rank 3
		[52042]	= "SHAMAN", -- Healing Stream Totem
		[49273]	= "SHAMAN", -- Healing Wave, Rank 14
		[51514]	= "SHAMAN", -- Hex
		[51522]	= "SHAMAN", -- Improved Stormstrike
		[63375]	= "SHAMAN", -- Improved Stormstrike
		[51505]	= "SHAMAN", -- Lava Burst, Rank 1
		[60043]	= "SHAMAN", -- Lava Burst, Rank 2
		[60103]	= "SHAMAN", -- Lava Lash
		[49276]	= "SHAMAN", -- Lesser Healing Wave, Rank 9
		[49238]	= "SHAMAN", -- Lightning Bolt, Rank 14
		[49240]	= "SHAMAN", -- Lightning Bolt, Rank 14
		[49279]	= "SHAMAN", -- Lightning Shield, Rank 11
		[58734]	= "SHAMAN", -- Magma Totem, Rank 7
		[21169]	= "SHAMAN", -- Reincarnation
		[61301]	= "SHAMAN", -- Riptide, Rank 4
		[58704]	= "SHAMAN", -- Searing Totem, Rank 10
		[30823]	= "SHAMAN", -- Shamanistic Rage
		[58875]	= "SHAMAN", -- Spirit Walk
		[17364]	= "SHAMAN", -- Stormstrike
		[32175]	= "SHAMAN", -- Stormstrike
		[32176]	= "SHAMAN", -- Stormstrike
		[59159]	= "SHAMAN", -- Thunderstorm, Rank 4
		[36936]	= "SHAMAN", -- Totemic Recall
		[8143]	= "SHAMAN", -- Tremor Totem
		[57960]	= "SHAMAN", -- Water Shield, Rank 9
		[57994]	= "SHAMAN", -- Wind Shear
		[25504]	= "SHAMAN", -- Windfury Attack

	-- Warlock
		[59172]	= "WARLOCK", -- Chaos Bolt, Rank 4
		[17962]	= "WARLOCK", -- Conflagrate
		[11671]	= "WARLOCK", -- Corruption, Rank 5
		[47813]	= "WARLOCK", -- Corruption, Rank 10
		[47878]	= "WARLOCK", -- Create Healthstone, Rank 8
		[58887]	= "WARLOCK", -- Create Soulwell, Rank 2
		[47864]	= "WARLOCK", -- Curse of Agony, Rank 9
		[47867]	= "WARLOCK", -- Curse of Doom, Rank 3
		[47865]	= "WARLOCK", -- Curse of the Elements, Rank 5
		[48018]	= "WARLOCK", -- Demonic Circle: Summon
		[48020]	= "WARLOCK", -- Demonic Circle: Teleport
		[47857]	= "WARLOCK", -- Drain Life, Rank 9
		[5138]	= "WARLOCK", -- Drain Mana
		[47855]	= "WARLOCK", -- Drain Soul, Rank 6
		[47893]	= "WARLOCK", -- Fel Armor, Rank 4
		[47230]	= "WARLOCK", -- Fel Synergy, Rank 1
		[47231]	= "WARLOCK", -- Fel Synergy, Rank 2
		[59164]	= "WARLOCK", -- Haunt, Rank 4
		[47822]	= "WARLOCK", -- Hellfire Effect, Rank 5
		[47823]	= "WARLOCK", -- Hellfire, Rank 5
		[17928]	= "WARLOCK", -- Howl of Terror, Rank 2
		[47811]	= "WARLOCK", -- Immolate, Rank 11
		[47838]	= "WARLOCK", -- Incinerate, Rank 4
		[22703]	= "WARLOCK", -- Infernal Awakening
		[1122]	= "WARLOCK", -- Inferno
		[57946]	= "WARLOCK", -- Life Tap, Rank 8
		[47860]	= "WARLOCK", -- Mortal Coil, Rank 6
		[47834]	= "WARLOCK", -- Seed of Corruption, Rank 3
		[47836]	= "WARLOCK", -- Seed of Corruption, Rank 3
		[47809]	= "WARLOCK", -- Shadow Bolt, Rank 13
		[47827]	= "WARLOCK", -- Shadowburn, Rank 10
		[61290]	= "WARLOCK", -- Shadowflame, Rank 2
		[47847]	= "WARLOCK", -- Shadowfury, Rank 5
		[63106]	= "WARLOCK", -- Siphon Life
		[47825]	= "WARLOCK", -- Soul Fire, Rank 6
		[29858]	= "WARLOCK", -- Soulshatter
		[20707]	= "WARLOCK", -- Soulstone Resurrection
		[18540]	= "WARLOCK", -- Summon Doomguard
		[30146]	= "WARLOCK", -- Summon Felguard
		[688]	= "WARLOCK", -- Summon Imp
		[697]	= "WARLOCK", -- Summon Voidwalker
		[47891]	= "WARLOCK", -- Twilight Ward, Rank 6
		[47843]	= "WARLOCK", -- Unstable Affliction, Rank 5

	-- Warrior
		[47436]	= "WARRIOR", -- Battle Shout, Rank 9
		[2457]	= "WARRIOR", -- Battle Stance
		[18499]	= "WARRIOR", -- Berserker Rage
		[46924]	= "WARRIOR", -- Bladestorm
		[50622]	= "WARRIOR", -- Bladestorm
		[12292]	= "WARRIOR", -- Bloodbath
		[23881]	= "WARRIOR", -- Bloodthirst
		[11578]	= "WARRIOR", -- Charge, Rank 3
		[47520]	= "WARRIOR", -- Cleave, Rank 8
		[47498]	= "WARRIOR", -- Devastate, Rank 5
		[13048]	= "WARRIOR", -- Enrage, Rank 5
		[55694]	= "WARRIOR", -- Enraged Regeneration
		[47471]	= "WARRIOR", -- Execute, Rank 9
		[1715]	= "WARRIOR", -- Hamstring
		[52174]	= "WARRIOR", -- Heroic Leap
		[57755]	= "WARRIOR", -- Heroic Throw
		[3411]	= "WARRIOR", -- Intervene
		[5246]	= "WARRIOR", -- Intimidating Shout
		[12975]	= "WARRIOR", -- Last Stand
		[47486]	= "WARRIOR", -- Mortal Strike, Rank 8
		[7384]	= "WARRIOR", -- Overpower
		[12323]	= "WARRIOR", -- Piercing Howl
		[6552]	= "WARRIOR", -- Pummel
		[1719]	= "WARRIOR", -- Recklessness
		[47465]	= "WARRIOR", -- Rend, Rank 10
		[57823]	= "WARRIOR", -- Revenge, Rank 9
		[29841]	= "WARRIOR", -- Second Wind, Rank 1
		[29842]	= "WARRIOR", -- Second Wind, Rank 2
		[64382]	= "WARRIOR", -- Shattering Throw
		[2565]	= "WARRIOR", -- Shield Block
		[47488]	= "WARRIOR", -- Shield Slam, Rank 8
		[871]	= "WARRIOR", -- Shield Wall
		[46968]	= "WARRIOR", -- Shockwave
		[47475]	= "WARRIOR", -- Slam, Rank 8
		[23920]	= "WARRIOR", -- Spell Reflection
		[47467]	= "WARRIOR", -- Sunder Armor, Rank 7
		[12328]	= "WARRIOR", -- Sweeping Strikes
		[12723]	= "WARRIOR", -- Sweeping Strikes
		[355]	= "WARRIOR", -- Taunt
		[47502]	= "WARRIOR", -- Thunder Clap, Rank 9
		[34428]	= "WARRIOR", -- Victory Rush
		[1680]	= "WARRIOR", -- Whirlwind
		[44949]	= "WARRIOR", -- Whirlwind
	}

	_detalhes.HardCrowdControlSpells = {
		--> death knight

		--> druid
		[33786] = true, -- Cyclone

		--> hunter

		--> mage

		--> paladin

		--> priest

		--> rogue

		--> shaman

		--> warlock

		--> warrior

	}

	_detalhes.CrowdControlSpells = {
		--Racials
		[28730]	= true, -- Arcane Torrent(be)
		[47779]	= true, -- Arcane Torrent(be)
		[50613]	= true, -- Arcane Torrent(be)
		[20549]	= true, -- War Stomp(tauren)

		--death knight
		[47481]	= true, -- Gnaw
		[47528]	= true, -- Mind Freeze
		[47476]	= true, -- Strangulate

		--druid
		[33786]	= true, -- Cyclone
		[339]	= true, -- Entangling Toots
		[45334]	= true, -- Immobilized(from Wild Charge)
		[99]	= true, -- Incapacitating Roar
		[22570]	= true, -- Maim
		[5211]	= true, -- Mighty Bash(talent)
		[16979]	= true, -- Wild Charge(talent)

		--hunter
		[64803]	= true, -- Entrapment
		[3355]	= true, -- Freezing trap
		[24394]	= true, -- Intimidation(pet)
		[24335]	= true, -- Wyvern sting
		[19386]	= true, -- Wyvern sting

		--mage
		[2139]	= true, -- Counterspell
		[44572]	= true, -- Deep Freeze
		[58534]	= true, -- Deep Freeze
		[31661]	= true, -- Dragon's Breath
		[33395]	= true, -- Freeze(pet)
		[122]	= true, -- Frost Nova
		[118]	= true, -- Polymorph sheep
		[28272]	= true, -- Polymorph pig
		[61305]	= true, -- Polymorph black cat
		[61721]	= true, -- Polymorph rabbit
		[61780]	= true, -- Polymorph turkey
		[28271]	= true, -- Polymorph turtle

		--paladin
		[31935]	= true, -- Avenger's Shield
		[853]	= true, -- Hammer of Justice
		[20066]	= true, -- Repentance

		--priest
		[605]	= true, -- Dominate Mind
		[64044]	= true, -- Psychic Horror
		[8122]	= true, -- Psychic scream
		[9484]	= true, -- Shackle undead
		[15487]	= true, -- Silence

		--rogue
		[2094]	= true, -- Blind
		[1833]	= true, -- Cheap shot
		[1330]	= true, -- Garrote
		[1776]	= true, -- Gouge
		[1766]	= true, -- Kick
		[408]	= true, -- Kidney shot
		[6770]	= true, -- Sap

		--shaman
		[64695]	= true, -- Earthgrab(earthgrab totem)
		[51514]	= true, -- Hex
		[51490]	= true, -- Thunderstorm
		[57994]	= true, -- Wind Shear

		--warlock
		[5782]	= true, -- Fear
		[5484]	= true, -- Howl of terror
		[6789]	= true, -- Mortal Coil
		[6358]	= true, -- Seduction(succubus)
		[30283]	= true, -- Shadowfury
		[19647]	= true, -- Spell Lock(Felhunters)
		[31117]	= true, -- Unstable Affliction

		--warrior
		[100]	= true, -- Charge
		[5246]	= true, -- Intimidating shout
		[6552]	= true, -- Pummel
		[7922]	= true, -- Warbringer
	}

	_detalhes.MageFireWardSpells = {
		[543] = 30 , -- Fire Ward (Mage) Rank 1
		[8457] = 30,
		[8458] = 30,
		[10223] = 30,
		[10225] = 30,
		[27128] = 30,
		[43010] = 30, -- Rank 7
	}

	_detalhes.MageFrostWardSpells = {
		[6143] = 30, -- Frost Ward (Mage) Rank 1
		[8461] = 30,
		[8462] = 30,
		[10177] = 30,
		[28609] = 30,
		[32796] = 30,
		[43012] = 30, -- Rank 7
	}

	_detalhes.WarlockShadowWardSpells = {
		[6229] = 30, -- Shadow Ward (warlock) Rank 1
		[11739] = 30,
		[11740] = 30,
		[28610] = 30,
		[47890] = 30,
		[47891] = 30, -- Rank 6
	}

	_detalhes.MageIceBarrierSpells = {
		[11426] = 60, -- Ice Barrier (Mage) Rank 1
		[13031] = 60,
		[13032] = 60,
		[13033] = 60,
		[27134] = 60,
		[33405] = 60,
		[43038] = 60,
		[43039] = 60, -- Rank 8
	}

	_detalhes.WarlockSacrificeSpells = {
		[7812] = 30, -- Sacrifice (warlock) Rank 1
		[19438] = 30,
		[19440] = 30,
		[19441] = 30,
		[19442] = 30,
		[19443] = 30,
		[27273] = 30,
		[47985] = 30,
		[47986] = 30, -- rank 9
	}

	_detalhes.AbsorbSpells = {
		-- Death Knight
		[48707] = 5, -- Anti-Magic Shell (DK) Rank 1 -- Does not currently seem to show tracable combat log events. It shows energizes which do not reveal the amount of damage absorbed
		[51052] = 10, -- Anti-Magic Zone (DK)( Rank 1 (Correct spellID?)
				-- Does DK Spell Deflection show absorbs in the CL?
		[51271] = 20, -- Unbreakable Armor (DK)
		-- Druid
		[62606] = 10, -- Savage Defense proc. (Druid) Tooltip of the original spell doesn't clearly state that this is an absorb, but the buff does.
		-- Mage
		[11426] = 60, -- Ice Barrier (Mage) Rank 1
		[13031] = 60,
		[13032] = 60,
		[13033] = 60,
		[27134] = 60,
		[33405] = 60,
		[43038] = 60,
		[43039] = 60, -- Rank 8
		[6143] = 30, -- Frost Ward (Mage) Rank 1
		[8461] = 30,
		[8462] = 30,
		[10177] = 30,
		[28609] = 30,
		[32796] = 30,
		[43012] = 30, -- Rank 7
		[1463] = 60, --  Mana shield (Mage) Rank 1
		[8494] = 60,
		[8495] = 60,
		[10191] = 60,
		[10192] = 60,
		[10193] = 60,
		[27131] = 60,
		[43019] = 60,
		[43020] = 60, -- Rank 9
		[543] = 30 , -- Fire Ward (Mage) Rank 1
		[8457] = 30,
		[8458] = 30,
		[10223] = 30,
		[10225] = 30,
		[27128] = 30,
		[43010] = 30, -- Rank 7
		-- Paladin
		[58597] = 6, -- Sacred Shield (Paladin) proc (Fixed, thanks to Julith)
		-- Priest
		[17] = 30, -- Power Word: Shield (Priest) Rank 1
		[592] = 30,
		[600] = 30,
		[3747] = 30,
		[6065] = 30,
		[6066] = 30,
		[10898] = 30,
		[10899] = 30,
		[10900] = 30,
		[10901] = 30,
		[25217] = 30,
		[25218] = 30,
		[48065] = 30,
		[48066] = 30, -- Rank 14
		[47509] = 12, -- Divine Aegis (Priest) Rank 1
		[47511] = 12,
		[47515] = 12, -- Divine Aegis (Priest) Rank 3 (Some of these are not actual buff spellIDs)
		[47753] = 12, -- Divine Aegis (Priest) Rank 1
		[54704] = 12, -- Divine Aegis (Priest) Rank 1
		[47788] = 10, -- Guardian Spirit  (Priest) (50 nominal absorb, this may not show in the CL)
		-- Warlock
		[7812] = 30, -- Sacrifice (warlock) Rank 1
		[19438] = 30,
		[19440] = 30,
		[19441] = 30,
		[19442] = 30,
		[19443] = 30,
		[27273] = 30,
		[47985] = 30,
		[47986] = 30, -- rank 9
		[6229] = 30, -- Shadow Ward (warlock) Rank 1
		[11739] = 30,
		[11740] = 30,
		[28610] = 30,
		[47890] = 30,
		[47891] = 30, -- Rank 6
		-- Consumables
		[29674] = 86400, -- Lesser Ward of Shielding
		[29719] = 86400, -- Greater Ward of Shielding (these have infinite duration, set for a day here :P)
		[29701] = 86400,
		[28538] = 120, -- Major Holy Protection Potion
		[28537] = 120, -- Major Shadow
		[28536] = 120, --  Major Arcane
		[28513] = 120, -- Major Nature
		[28512] = 120, -- Major Frost
		[28511] = 120, -- Major Fire
		[7233] = 120, -- Fire
		[7239] = 120, -- Frost
		[7242] = 120, -- Shadow Protection Potion
		[7245] = 120, -- Holy
		[7254] = 120, -- Nature Protection Potion
		[53915] = 120, -- Mighty Shadow Protection Potion
		[53914] = 120, -- Mighty Nature Protection Potion
		[53913] = 120, -- Mighty Frost Protection Potion
		[53911] = 120, -- Mighty Fire
		[53910] = 120, -- Mighty Arcane
		[17548] = 120, --  Greater Shadow
		[17546] = 120, -- Greater Nature
		[17545] = 120, -- Greater Holy
		[17544] = 120, -- Greater Frost
		[17543] = 120, -- Greater Fire
		[17549] = 120, -- Greater Arcane
		[28527] = 15, -- Fel Blossom
		[29432] = 3600, -- Frozen Rune usage (Naxx classic)
		-- Item usage
		[36481] = 4, -- Arcane Barrier (TK Kael'Thas) Shield
		[57350] = 6, -- Darkmoon Card: Illusion
		[17252] = 30, -- Mark of the Dragon Lord (LBRS epic ring) usage
		[25750] = 15, -- Defiler's Talisman/Talisman of Arathor Rank 1
		[25747] = 15,
		[25746] = 15,
		[23991] = 15,
		[31000] = 300, -- Pendant of Shadow's End Usage
		[30997] = 300, -- Pendant of Frozen Flame Usage
		[31002] = 300, -- Pendant of the Null Rune
		[30999] = 300, -- Pendant of Withering
		[30994] = 300, -- Pendant of Thawing
		[31000] = 300, --
		[23506]= 20, -- Arena Grand Master Usage (Aura of Protection)
		[12561] = 60, -- Goblin Construction Helmet usage
		[31771] = 20, -- Runed Fungalcap usage
		[21956] = 10, -- Mark of Resolution usage
		[29506] = 20, -- The Burrower's Shell
		[4057] = 60, -- Flame Deflector
		[4077] = 60, -- Ice Deflector
		[39228] = 20, -- Argussian Compass (may not be an actual absorb)
		-- Item procs
		[27779] = 30, -- Divine Protection - Priest dungeon set 1/2  Proc
		[11657] = 20, -- Jang'thraze (Zul Farrak) proc
		[10368] = 15, -- Uther's Strength proc
		[37515] = 15, -- Warbringer Armor Proc
		[42137] = 86400, -- Greater Rune of Warding Proc
		[26467] = 30, -- Scarab Brooch proc
		[26470] = 8, -- Scarab Brooch proc (actual)
		[27539] = 6, -- Thick Obsidian Breatplate proc
		[28810] = 30, -- Faith Set Proc Armor of Faith
		[54808] = 12, -- Noise Machine proc Sonic Shield
		[55019] = 12, -- Sonic Shield (one of these too ought to be wrong)
		[64413] = 8, -- Val'anyr, Hammer of Ancient Kings proc Protection of Ancient Kings
		-- Misc
		[40322] = 30, -- Teron's Vengeful Spirit Ghost - Spirit Shield
		-- Boss abilities
		[65874] = 15, -- Twin Val'kyr's Shield of Darkness 175000
		[67257] = 15, -- 300000
		[67256] = 15, -- 700000
		[67258] = 15, -- 1200000
		[65858] = 15, -- Twin Val'kyr's Shield of Lights 175000
		[67260] = 15, -- 300000
		[67259] = 15, -- 700000
		[67261] = 15, -- 1200000
		[65686] = 86400, -- Twin Val'kyr Light Essence
		[65684] = 86400, -- Twin Val'kyr Dark Essence
	}

	-- ~cooldown 1 self
	_detalhes.DefensiveCooldownSpellsNoBuff = {
		[20594]	= {120, 8, 1}, -- racial stoneform

--		[6262] = {120, 1, 1}, -- healthstone

--		["DEATHKNIGHT"] = {},
		[48707]	= {45, 5, 1}, -- Anti-Magic Shell
		[48743]	= {120, 0, 1}, -- Death Pact
		[51052]	= {120, 3, 0}, -- Anti-Magic Zone
		[48982]	= {30, 0, 1}, -- "Blood T�p"

--		["DRUID"] = {},
		[740]	= {480, 8, 0}, -- Tranquility
		[22842]	= {0, 0, 1}, -- Frenzied Regeneration

--		["HUNTER"] = {},

--		["MAGE"] = {},

--		["PALADIN"] = {},
		[633]	= {600, 0, 0}, -- Lay on Hands
		[31821]	= {180, 6, 0}, -- Devotion Aura

--		["PRIEST"] = {},
		[62618]	= {180, 10, 0}, -- Power Word: Barrier
		[64843]	= {180, 8, 0}, -- Divine Hymn

--		["ROGUE"] = {},

--		["SHAMAN"] = {},

--		["WARLOCK"] = {108416, 6229},
		[6229]	= {30, 30, 1}, -- Twilight Ward 1 = self

--		["WARRIOR"] = {},
		[2565]	= {12, 6, 1}, -- Shield Block
		[871]	= {180, 12, 1}, -- Shield Wall
		[12975]	= {180, 20, 1}, -- Last Stand
		[23920]	= {25, 5, 1}, -- Spell Reflection
	}

	--> spellid = {cooldown, duration}
	_detalhes.DefensiveCooldownSpells = {
		-- Death Knigh
		[55233] = {60, 10}, -- Vampiric Blood
		[49222] = {60, 300}, -- Bone Shield
		[48792] = {180, 12}, -- Icebound Fortitude
		[48743] = {120, 0}, -- Death Pact
		[49039] = {12, 10}, -- Lichborne
		["DEATHKNIGHT"] = {55233, 49222, 48707, 48792, 48743, 49039, 48743, 51052},

		-- Druid
		[62606] = {1.5, 6}, -- Savage Defense
		[61336] = {180, 12}, -- Survival Instincts
		[22812] = {60, 12}, -- Barkskin
		["DRUID"] = {62606, 61336, 22812, 740, 22842},

		-- Hunter
		[19263] = {120, 5}, -- Deterrence
		["HUNTER"] = {19263},

		-- Mage
		[45438] = {300, 12}, -- Ice Block
		["MAGE"] = {45438},

		-- Paladin
		[498] = {60, 10}, -- Divine Protection
		[642] = {300, 8}, -- Divine Shield
		[6940] = {120, 12}, -- Hand of Sacrifice
		[1022] = {300, 10}, -- Hand of Protection
		[1038] = {120, 10}, -- Hand of Salvation
		["PALADIN"] = {86659, 31850, 498, 642, 6940, 1022, 1038, 633, 31821},

		-- Priest
		[47788] = {180, 10}, -- Guardian Spirit
		[47585] = {120, 6}, -- Dispersion
		[33206] = {180, 8}, -- Pain Suppression
		["PRIEST"] = {47788, 47585, 33206, 62618, 109964, 64843},

		-- Rogue
		[1966] = {1.5, 5}, -- Feint
		[31224] = {60, 5}, -- Cloak of Shadows
		[5277] = {180, 15}, -- Evasion
		[1856] = {120, 0}, -- Vanish
		["ROGUE"] = {1966, 31224, 5277, 1856, 76577},

		-- Shaman
		[30823] = {60, 15}, -- Shamanistic Rage
		["SHAMAN"] = {30823},

		-- Warlock
		["WARLOCK"] = {6229},

		-- Warrior
		[871] = {180, 12}, -- Shield Wall
		[12975] = {180, 20}, -- Last Stand
		[23920] = {25, 5}, -- Spell Reflection
		["WARRIOR"] = {871, 12975, 23920, 2565}
	}

	_detalhes.HarmfulSpells = {
		--death knight
		[49020] 	= 	true, -- obliterate
		[49143] 	=	true, -- frost strike
		[55095] 	= 	true, -- frost fever
		[55078] 	= 	true, -- blood plague
		[49184] 	= 	true, -- howling blast
		[49998] 	= 	true, -- death strike
		[55090] 	= 	true, -- scourge strike
		[47632] 	= 	true, -- death coil
		[108196]	=	true, --Death Siphon
		[47541]	=	true, -- Death Coil
		--[48721]	=	true, -- Blood Boil
		[42650]	=	true, -- Army of the Dead
		[130736]	=	true, -- Soul Reaper
		[45524]	=	true, -- Chains of Ice
		[45462]	=	true, -- Plague Strike
		[85948]	=	true, -- Festering Strike
		--[56815]	=	true, -- Rune Strike
		[108200]	=	true, -- Remorseless Winter
		[45477]	=	true, -- Icy Touch
		[43265]	=	true, -- Death and Decay
		[77575]	=	true, -- Outbreak
		[115989]	=	true, -- Unholy Blight
		--[55050]	=	true, -- Heart Strike
		[114866]	=	true, -- Soul Reaper
		--[73975]	=	true, -- Necrotic Strike
		[130735]	=	true, -- Soul Reaper
		[50842]	=	true, -- Pestilence
		--[45902]	=	true, -- Blood Strike
		[108194]	=	true, -- Asphyxiate
		[77606]	=	true, -- Dark Simulacrum

		--druid
		--[80965]	=	 true, -- Skull Bashs
		[78675]	=	 true, -- Solar Beam
		[22570]	=	 true, -- Maim
		[33831]	=	 true, -- Force of Nature
		[102706]	=	 true, -- Force of Nature
		[102355]	=	 true, -- Faerie Swarm
		[16914]	=	 true, -- Hurricane
		[2908]	=	 true, -- Soothe
		--[62078]	=	 true, -- Swipe
		[106996]	=	 true, -- Astral Storm
		--[6785]	=	 true, -- Ravage
		[33891]	=	 true, -- Incarnation: Tree of Life
		[102359]	=	 true, -- Mass Entanglement
		[5211]	=	 true, -- Mighty Bash
		--[102795]	=	 true, -- Bear Hug
		[1822] 	= 	true, --rake
		[1079] 	= 	true, --rip
		[5221] 	= 	true, --shred
		--[33876] 	=	true, --mangle
		--[102545] 	= 	true, --ravage!
		[5176]	=	true, --wrath
		[93402]	=	true, --sunfire
		[2912]	=	true, --starfire
		[8921]	=	true, --moonfire
		[6807]	=	 true, -- Maul
		[33745]	=	 true, -- Lacerate
		[770]	=	 true, -- Faerie Fire
		[22568]	=	 true, -- Ferocious Bite
		--[779]	=	 true, -- Swipe
		[77758]	=	 true, -- Thrash
		[106830]	=	 true, -- Thrash
		--[114236]	=	 true, -- Shred!
		[48505]	=	 true, -- Starfall
		[78674]	=	 true, -- Starsurge
		--[80964]	=	 true, -- Skull Bash

		--hunter
		--[19503]	=	true,-- Scatter Shot
		[109259]	=	true,-- Powershot
		[20736]	=	true,-- Distracting Shot
		[131900]	=	true, --a murder of crows
		[118253]	=	true, --serpent sting
		[77767]	=	true, --cobra shot
		[3044]	=	true, --arcane shot
		[53301]	=	true, --explosive shot
		[120361]	=	true, --barrage
		[53351]	=	true, --kill shot
		[3674]	=	true,-- Black Arrow
		[117050]	=	true,-- Glaive Toss
		--[1978]	=	true,-- Serpent Sting
		[34026]	=	true,-- Kill Command
		[2643]	=	true,-- Multi-Shot
		[109248]	=	true,-- Binding Shot
		[149365]	=	true,-- Dire Beast
		[120679]	=	true,-- Dire Beast
		[3045]	=	true,-- Rapid Fire
		[19574]	=	true,-- Bestial Wrath
		[19386]	=	true,-- Wyvern Sting
		[19434]	=	true,-- Aimed Shot
		[120697]	=	true,-- Lynx Rush
		[56641]	=	true,-- Steady Shot
		--[34490]	=	true,-- Silencing Shot
		[53209]	=	true,-- Chimera Shot
		--[82928]	=	true,-- Aimed Shot!
		[5116]	=	true,-- Concussive Shot
		[147362]	=	true,-- Counter Shot
		[19801]	=	true,-- Tranquilizing Shot
		--[82654]	=	true,-- Widow Venom

		--mage
		[116]	=	true, --frost bolt
		[30455]	=	true, --ice lance
		[84721]	=	true, --frozen orb
		[1449]	=	true, --arcane explosion
		[113092]	=	true, --frost bomb
		[115757]	=	true, --frost nova
		[44614]	=	true, --forstfire bolt
		[42208]	=	true, --blizzard
		[11366]	=	true, --pyroblast
		[133]	=	true, --fireball
		[108853]	=	true, --infernoblast
		[2948]	=	true, --scorch
		[30451]	=	true, --arcane blase
		[44457]	=	true,-- Living Bomb
		[84714]	=	true,-- Frozen Orb
		[11129]	=	true,-- Combustion
		[112948]	=	true,-- Frost Bomb
		[2139]	=	true,-- Counterspell
		[2136]	=	true,-- Fire Blast
		[7268]	=	true,-- Arcane Missiles
		[114923]	=	true,-- Nether Tempest
		[2120]	=	true,-- Flamestrike
		[44425]	=	true,-- Arcane Barrage
		[44572]	=	true,-- Deep Freeze
		[113724]	=	true,-- Ring of Frost
		[31661]	=	true,-- Dragon's Breath

		--paladin
		[35395]	=	true,--cruzade strike
		[879]	=	true,--exorcism
		[85256]	=	true,--templar's verdict
		[31935]	=	true,--avenger's shield
		[20271]	=	true, --judgment
		[35395]	=	true, --cruzader strike
		[81297]	=	true, --consacration
		[31803]	=	true, --censure
		[20473]	=	true,-- Holy Shock
		[114158]	=	true,-- Light's Hammer
		[24275]	=	true,-- Hammer of Wrath
		[88263]	=	true,-- Hammer of the Righteous
		[53595]	=	true,-- Hammer of the Righteous
		[53600]	=	true,-- Shield of the Righteous
		[26573]	=	true,-- Consecration
		[119072]	=	true,-- Holy Wrath
		[105593]	=	true,-- Fist of Justice
		[122032]	=	true,-- Exorcism
		[96231]	=	true,-- Rebuke
		[115750]	=	true,-- Blinding Light
		[53385]	=	true,-- Divine Storm
		[116467] 	= 	true, -- Consecration
		[31801] 	= 	true, -- Seal of Truth
		[20165] 	= 	true, -- Seal of Insight

		--priest
		[589]	=	true, --shadow word: pain
		[34914]	=	true, --vampiric touch
		[15407]	=	true, --mind flay
		[8092]	=	true, --mind blast
		[15290]	=	true,-- Vampiric Embrace
		[2944]	=	true,--devouring plague(damage)
		[585]	=	true, --smite
		[47666]	=	true, --penance
		[14914]	=	true, --holy fire
		[48045]	=	true, -- Mind Sear
		[49821]	=	true, -- Mind Sear
		[32379]	=	true, -- Shadow Word: Death
		[129176]	=	true, -- Shadow Word: Death
		[120517]	=	true, -- Halo
		[120644]	=	true, -- Halo
		[15487]	=	true, -- Silence
		[129197]	=	true, -- Mind Flay(Insanity)
		[108920]	=	true, -- Void Tendrils
		[73510] 	= 	true, -- Mind Spike
		[127632] 	= 	true, -- Cascade
		--[108921] 	= 	true, -- Psyfiend
		[88625] 	= 	true, -- Holy Word: Chastise

		--rogue
		[53]		= 	true, --backstab
		[2098]	= 	true, --eviscerate
		[51723]	=	true, --fan of knifes
		[111240]	=	true, --dispatch
		[703]	=	true, --garrote
		[1943]	=	true, --rupture
		[114014]	=	true, --shuriken toss
		[16511]	=	true, --hemorrhage
		[89775]	=	true, --hemorrhage
		[8676]	=	true, --amcush
		[5374]	=	true, --mutilate
		[32645]	=	true, --envenom
		[1943]	=	true, --rupture
		[27576]	=	true, -- Mutilate Off-Hand
		[1329]	=	true, -- Mutilate
		[84617]	=	true, -- Revealing Strike
		[1752]	=	true, -- Sinister Strike
		--[121473]	=	true, -- Shadow Blade
		--[121474]	=	true, -- Shadow Blade Off-hand
		[1766]	=	true, -- Kick
		--[8647]	=	true, -- Expose Armor
		[2094]	=	true, -- Blind
		[121411]	=	true, -- Crimson Tempest
		[137584] 	= 	true, -- Shuriken Toss
		[137585] 	= 	true, -- Shuriken Toss Off-hand
		[1833] 	= 	true, -- Cheap Shot
		[121733] 	= 	true, -- Throw
		[1776] 	= 	true, -- Gouge

		--shaman
		[51505]	=	true, --lava burst
		[8050]	=	true, --flame shock
		[117014]	=	true, --elemental blast
		[403]	=	true, --lightning bolt
		--[45284]	=	true, --lightning bolt
		[421]	=	true, --chain lightining
		[32175]	=	true, --stormstrike
		[25504]	=	true, --windfury
		[8042]	=	true, --earthshock
		[26364]	=	true, --lightning shield
		[117014]	=	true, --elemental blast
		[73683]	=	true, --unleash flame
		[115356]	=	true, -- Stormblast
		[60103]	=	true, -- Lava Lash
		[17364]	=	true, -- Stormstrike
		[61882]	=	true, -- Earthquake
		[57994]	=	true, -- Wind Shear
		[8056]	=	true, -- Frost Shock
		[114074] 	= 	true, -- Lava Beam

		--warlock
		--[77799]	=	true, --fel flame
		[63106]	=	true, --siphon life
		[103103]	=	true, --malefic grasp
		[980]	=	true, --agony
		[30108]	=	true, --unstable affliction
		[172]	=	true, --corruption
		[48181]	=	true, --haunt
		[29722]	=	true, --incenerate
		[348]	=	true, --Immolate
		[116858]	=	true, --Chaos Bolt
		[114654]	=	true, --incinerate
		[108686]	=	true, --immolate
		[108685]	=	true, --conflagrate
		[104233]	=	true, --rain of fire
		[103964]	=	true, --touch os chaos
		[686]	=	true, --shadow bolt
		--[114328]	=	true, --shadow bolt glyph
		[140719]	=	true, --hellfire
		[104027]	=	true, --soul fire
		[603]	=	true, --doom
		[108371]	=	true, --Harvest life
		[17962]	=	true, -- Conflagrate
		[105174]	=	true, -- Hand of Gul'dan
		[146739]	=	true, -- Corruption
		[30283]	=	true, -- Shadowfury
		[104232]	=	true, -- Rain of Fire
		[6353]	=	true, -- Soul Fire
		[689]	=	true, -- Drain Life
		[17877]	=	true, -- Shadowburn
		--[1490]	=	true, -- Curse of the Elements
		[27243]	=	true, -- Seed of Corruption
		[6789]	=	true, -- Mortal Coil
		[124916]	=	true, -- Chaos Wave
		--[1120]	=	true, -- Drain Soul
		[5484]	=	true, -- Howl of Terror
		--[89420]	=	true, -- Drain Life
		--[109466]	=	true, -- Curse of Enfeeblement
		--[112092] 	= 	true, -- Shadow Bolt
		--[103967] 	= 	true, -- Carrion Swarm

		--warrior
		[100130]	=	true, --wild strike
		[96103]	=	true, --raging blow
		[12294]	=	true, --mortal strike
		[1464]	=	true, --Slam
		[23922]	=	true, --shield slam
		[20243]	=	true, --devastate
		--[11800]	=	true, --dragon roar
		[115767]	=	true, --deep wounds
		[109128]	=	true, --charge
		--[11294]	=	true, --mortal strike
		--[29842]	=	true, --undribled wrath
		[86346]	=	true, -- Colossus Smash
		[107570]	=	true, -- Storm Bolt
		[1680]	=	true, -- Whirlwind
		[85384]	=	true, -- Raging Blow Off-Hand
		[85288]	=	true, -- Raging Blow
		--[7384]	=	true, -- Overpower
		[23881]	=	true, -- Bloodthirst
		[118000]	=	true, -- Dragon Roar
		[50622]	=	true, -- Bladestorm
		[46924]	=	true, -- Bladestorm
		[103840]	=	true, -- Impending Victory
		[5308]	=	true, -- Execute
		[57755]	=	true, -- Heroic Throw
		[1715]	=	true, -- Hamstring
		[46968]	=	true, -- Shockwave
		[6343]	=	true, -- Thunder Clap
		[64382]	=	true, -- Shattering Throw
		[6552]	=	true, -- Pummel
		[6572]	=	true, -- Revenge
		[102060]	=	true, -- Disrupting Shout
		[12323] 	= 	true, -- Piercing Howl
		--[122475] 	= 	true, -- Throw
		--[845] 	= 	true, -- Cleave
		[5246] 	= 	true, -- Intimidating Shout
		--[7386] 	= 	true, -- Sunder Armor
		[107566] 	= 	true, -- Staggering Shout
	}

	_detalhes.MiscClassSpells = {
		--death knight
		[49576]	=	true, -- Death Grip
		[56222]	=	true, -- Dark Command
		[47528]	=	true, -- Mind Freeze(interrupt)
		[123693]	=	true, -- Plague Leech(consume plegue, get 2 deathrunes)
		[3714]	=	true, -- Path of Frost
		[48263]	=	true, -- Blood Presence
		[47568]	=	true, -- Empower Rune Weapon
		[57330]	=	true, -- Horn of Winter(buff)
		[45529]	=	true, -- Blood Tap
		[96268]	=	true, -- Death's Advance(walk faster)
		[48266]	=	true, -- Frost Presence
		[50977]	=	true, -- Death Gate
		[108199]	=	true, -- Gorefiend's Grasp
		[108201]	=	true, -- Desecrated Ground
		[48265]	=	true, -- Unholy Presence
		[61999]	=	true, -- Raise Ally

		--druid
		--[16689]	=	 true, -- Nature's Grasp
		[102417]	=	 true, -- Wild Charge
		--[5229]	=	 true, -- Enrage
		--[9005]	=	 true, -- Pounce
		[114282]	=	 true, -- Treant Form
		[5215]	=	 true, -- Prowl
		[52610]	=	 true, -- Savage Roar
		[102401]	=	 true, -- Wild Charge
		[102793]	=	 true, -- Ursol's Vortex
		[106898]	=	 true, -- Stampeding Roar
		[132158]	=	 true, -- Nature's Swiftness(misc)
		[1126]	=	 true, -- Mark of the Wild(buff)
		[77761]	=	 true, -- Stampeding Roar
		[77764]	=	 true, -- Stampeding Roar
		[16953]	=	 true, -- Primal Fury
		[102693]	=	 true, -- Force of Nature
		[145518]	=	 true, -- Genesis
		[5225]	=	 true, -- Track Humanoids
		[102280]	=	 true, -- Displacer Beast
		[1850]	=	 true, -- Dash
		[108294]	=	 true, -- Heart of the Wild
		[108292]	=	 true, -- Heart of the Wild
		[768]	=	 true, -- Cat Form
		--[127538]	=	 true, -- Savage Roar
		[16979]	=	 true, -- Wild Charge
		[49376]	=	 true, -- Wild Charge
		[6795]	=	 true, -- Growl
		[61391]	=	 true, -- Typhoon
		[24858]	=	 true, -- Moonkin Form
		--[81070]	=	true, --eclipse
		--[29166]	=	true, --innervate

		--hunter
		[781]	=	true,-- Disengage
		[82948]	=	true,-- Snake Trap
		[82939]	=	true,-- Explosive Trap
		[82941]	=	true,-- Ice Trap
		[883]	=	true,-- Call Pet 1
		[83242]	=	true,-- Call Pet 2
		[83243]	=	true,-- Call Pet 3
		[83244]	=	true,-- Call Pet 4
		[2641]	=	true,-- Dismiss Pet
		[82726]	=	true,-- Fervor
		[13159]	=	true,-- Aspect of the Pack
		[109260]	=	true,-- Aspect of the Iron Hawk
		[1130]	=	true,--'s Mark
		[5118]	=	true,-- Aspect of the Cheetah
		[34477]	=	true,-- Misdirection
		[19577]	=	true,-- Intimidation
		[83245]	=	true,-- Call Pet 5
		[51753]	=	true,-- Camouflage
		--[13165]	=	true,-- Aspect of the Hawk
		[53271]	=	true,-- Master's Call
		[1543]	=	true,-- Flare

		--mage
		[1953]	=	true,-- Blink
		[108843]	=	true,-- Blazing Speed
		[55342]	=	true,-- Mirror Image
		[110960]	=	true,-- Greater Invisibility
		[110959]	=	true,-- Greater Invisibility
		[11958]	=	true,-- Cold Snap
		[61316]	=	true,-- Dalaran Brilliance
		[1459]	=	true,-- Arcane Brilliance
		[116011]	=	true,-- Rune of Power
		[116014]	=	true,-- Rune of Power
		[132627]	=	true,-- Teleport: Vale of Eternal Blossoms
		[31687]	=	true,-- Summon Water Elemental
		[3567]	=	true,-- Teleport: Orgrimmar
		[30449]	=	true,-- Spellsteal
		[132626]	=	true,-- Portal: Vale of Eternal Blossoms
		[12051]	=	true, --evocation
		[108839]	=	true,-- Ice Floes
		[7302]	=	true,-- Frost Armor
		[53140]	=	true,-- Teleport: Dalaran
		[11417]	=	true,-- Portal: Orgrimmar
		[42955]	=	true,-- Conjure Refreshment

		--paladin
		[85499]	=	true,-- Speed of Light
		--[84963]	=	true,-- Inquisition
		[62124]	=	true,-- Reckoning
		[121783]	=	true,-- Emancipate
		[98057]	=	true,-- Grand Crusader
		[20217]	=	true,-- Blessing of Kings
		[25780]	=	true,-- Righteous Fury
		[20154]	=	true,-- Seal of Righteousness
		[19740]	=	true,-- Blessing of Might
		--[54428] 	= 	true, -- Divine Plea --misc
		[7328] 	= 	true, -- Redemption

		--priest
		[8122]	=	true, -- Psychic Scream
		[81700]	=	true, -- Archangel
		[586]	=	true, -- Fade
		[121536]	=	true, -- Angelic Feather
		[121557]	=	true, -- Angelic Feather
		--[64901]	=	true, -- Hymn of Hope
		--[89485]	=	true, -- Inner Focus
		[112833]	=	true, -- Spectral Guise
		--[588]	=	true, -- Inner Fire
		[21562]	=	true, -- Power Word: Fortitude
		--[73413]	=	true, -- Inner Will
		[15473]	=	true, -- Shadowform
		[126135] 	= 	true, -- Lightwell
		[81209] 	= 	true, -- Chakra: Chastise
		[81208] 	= 	true, -- Chakra: Serenity
		[2006] 	= 	true, -- Resurrection
		[1706] 	= 	true, -- Levitate

		--rogue
		[108212]	=	true, -- Burst of Speed(misc)
		[5171]	=	true, -- Slice and Dice
		[2983]	=	true, -- Sprint
		[36554]	=	true, -- Shadowstep
		[1784]	=	true, -- Stealth
		[115191]	=	true, -- Stealth
		[2823]	=	true, -- Deadly Poison
		--[108215]	=	true, -- Paralytic Poison
		[14185]	=	true, -- Preparation
		[74001] 	= 	true, -- Combat Readiness
		[14183] 	= 	true, -- Premeditation
		[108211] 	= 	true, -- Leeching Poison
		--[5761] 	= 	true, -- Mind-numbing Poison
		[8679] 	= 	true, -- Wound Poison

		--shaman
		[73680]	=	true, -- Unleash Elements(misc)
		[3599]	=	true, -- Searing Totem
		[2645]	=	true, -- Ghost Wolf
		[108285]	=	true, -- Call of the Elements
		--[8024]	=	true, -- Flametongue Weapon
		--[51730]	=	true, -- Earthliving Weapon
		[51485]	=	true, -- Earthgrab Totem
		[108269]	=	true, -- Capacitor Totem
		[79206]	=	true, -- Spiritwalker's Grace
		[58875]	=	true, -- Spirit Walk
		[36936]	=	true, -- Totemic Recall
		[8177] 	= 	true, -- Grounding Totem
		[8143] 	= 	true, -- Tremor Totem
		[108273] 	= 	true, -- Windwalk Totem
		[51514] 	= 	true, -- Hex
		--[73682] 	= 	true, -- Unleash Frost
		--[8033] 	= 	true, -- Frostbrand Weapon

		--warlock
		[697]	=	true, -- Summon Voidwalker
		[6201]	=	true, -- Create Healthstone
		[109151]	=	true, -- Demonic Leap
		[103958]	=	true, -- Metamorphosis
		[119678]	=	true, -- Soul Swap
		[74434]	=	true, -- Soulburn
		[108503]	=	true, -- Grimoire of Sacrifice
		[111400]	=	true, -- Burning Rush
		[109773]	=	true, -- Dark Intent
		[112927]	=	true, -- Summon Terrorguard
		[1122]	=	true, -- Summon Infernal
		[18540]	=	true, -- Summon Doomguard
		[29858]	=	true, -- Soulshatter
		[20707]	=	true, -- Soulstone
		[48018]	=	true, -- Demonic Circle: Summon
		[80240] 	= 	true, -- Havoc
		[112921] 	= 	true, -- Summon Abyssal
		[48020] 	= 	true, -- Demonic Circle: Teleport
		[111397] 	= 	true, -- Blood Horror
		[112869] 	= 	true, -- Summon Observer
		[1454] 	= 	true, -- Life Tap
		[112868] 	= 	true, -- Summon Shivarra
		[112869] 	= 	true, -- Summon Observer
		[120451] 	= 	true, -- Flames of Xoroth
		[29893] 	= 	true, -- Create Soulwell
		[112866] 	= 	true, -- Summon Fel Imp
		[108683] 	= 	true, -- Fire and Brimstone
		[688] 	= 	true, -- Summon Imp
		[112870] 	= 	true, -- Summon Wrathguard
		[104316] 	= 	true, -- Imp Swarm

		--warrior
		[18499]	=	true, -- Berserker Rage(class)
		[100]	=	true, -- Charge
		[6673]	=	true, -- Battle Shout
		[52174]	=	true, -- Heroic Leap
		[355]	=	true, -- Taunt
		[2457] 	= 	true, -- Battle Stance
		[12328] 	= 	true, -- Sweeping Strikes
		[114192] 	= 	true, -- Mocking Banner

	}

	_detalhes.DualSideSpells = {
		[114165]	=	true,-- Holy Prism(paladin)
		[47750]	=	true, -- Penance(priest)
	}

	_detalhes.AttackCooldownSpells = {
		--death knight
		--[49016]	=	true, -- Unholy Frenzy(attack cd)
		[49206]	=	true, -- Summon Gargoyle(attack cd)
		[49028]	=	true, -- Dancing Rune Weapon(attack cd)
		[51271]	=	true, -- Pillar of Frost(attack cd)
		[63560]	=	true, -- Dark Transformation(pet)

		--druid
		[106951]	=	 true, -- Berserk(attack cd)
		[124974]	=	 true, -- Nature's Vigil(attack cd)
		[102543]	=	 true, -- Incarnation: King of the Jungle
		[50334]	=	 true, -- Berserk
		[102558]	=	 true, -- Incarnation: Son of Ursoc
		[102560]	=	 true, -- Incarnation: Chosen of Elune
		[112071]	=	 true, -- Celestial Alignment
		[127663]	=	 true, -- Astral Communion
		[108293]	=	 true, -- Heart of the Wild(attack cd)
		[108291]	=	 true, -- Heart of the Wild

		--hunter
		[131894]	=	true,-- A Murder of Crows(attack cd)
		[121818]	=	true,-- Stampede(attack cd)
		[82692]	=	true,-- Focus Fire
		[120360]	=	true,-- Barrage

		--mage
		[80353]	=	true,-- Time Warp
		--[131078]	=	true,-- Icy Veins
		[12472]	=	true,-- Icy Veins
		[12043]	=	true,-- Presence of Mind
		[108978]	=	true,-- Alter Time
		[127140]	=	true,-- Alter Time
		[12042]	=	true,-- Arcane Power

		--paladin
		[31884]	=	true,-- Avenging Wrath
		[105809]	=	true,-- Holy Avenger
		[31842] 	= 	true, -- Divine Favor

		--priest
		[34433]	= true, -- Shadowfiend
		[10060]	= true, -- Power Infusion

		--rogue
		[13750]	=	true, -- Adrenaline Rush(attack cd)
		--[121471]	=	true, -- Shadow Blades
		[137619]	=	true, -- Marked for Death
		[79140]	=	true, -- Vendetta
		[51690]	=	true, -- Killing Spree
		[51713]	=	true, -- Shadow Dance
		[152151]	=	true, -- "Shadow Reflection"

		--shaman
		--[120668]	=	true, --Stormlash Totem(attack cd)
		[2894]	=	true, -- Fire Elemental Totem
		[2825]	=	true, -- Bloodlust
		[114049]	=	true, -- Ascendance
		[16166]	=	true, -- Elemental Mastery
		[51533]	=	true, -- Feral Spirit
		[16188]	=	true, -- Ancestral Swiftness
		[2062]	=	true, -- Earth Elemental Totem

		--warlock
		[113860]	=	true, -- Dark Soul: Misery(attack cd)
		[113858]	=	true, -- Dark Soul: Instability
		[113861] 	= 	true, -- Dark Soul: Knowledge

		--warrior
		[1719]	=	true, -- Recklessness(attack cd)
		--[114207]	=	true, -- Skull Banner
		[107574]	=	true, -- Avatar
		[12292]	=	true, -- Bloodbath
	}

	_detalhes.HelpfulSpells = {
		--death knight
		[45470] = true, -- Death Strike(heal)
		[77535] = true, -- Blood Shield(heal)
		[53365] = true, -- Unholy Strength(heal)
		[48707] = true, -- Anti-Magic Shell(heal)
		[48982] = true, -- rune tap
		[119975]	=	true, -- Conversion(heal)
		[48743]	=	true, -- Death Pact(heal)

		--druid
		--[33878] =	true, --mangle(energy gain)
		[17057] =	true, --bear form(energy gain)
		[16959] =	true, --primal fury(energy gain)
		[5217] = true, --tiger's fury(energy gain)
		[68285] =	true, --leader of the pack(mana)
		[774]	=	true, --rejuvenation
		--[44203]	=	true, --tranquility
		[48438]	=	true, --wild growth
		[81269]	=	true, --shiftmend
		--[102792]	=	true, --wind moshroom: bloom
		[5185]	=	true, --healing touch
		[8936]	=	true, --regrowth
		[33778]	=	true, --lifebloom
		[48503]	=	true, --living seed
		--[50464]	=	true, --nourish
		[18562]	=	 true, --Swiftmend(heal)
		[145205]	=	 true, -- Wild Mushroom(heal)
		[33763]	=	 true, -- Lifebloom(heal)
		--[102791]	=	 true, -- Wild Mushroom: Bloom
		[147349]	=	 true, -- Wild Mushroom
		[108238]	=	 true, -- Renewal
		[102351]	=	 true, -- Cenarion Ward


		--hunter
		[109304]	=	true,-- Exhilaration(heal)

		--mage
		[11426]	=	true, --Ice Barrier(heal)
		[115610]	=	true,-- Temporal Shield
		[111264]	=	true,-- Ice Ward

		--paladin
		[85673]	=	true,-- Word of Glory(heal)
		[20925]	=	true,-- Sacred Shield
		[53563]	=	true,-- Beacon of Light
		[633]	=	true,-- Lay on Hands
		[114163]	=	true,-- Eternal Flame
		[642]	=	true,-- Divine Shield
		[31821]	=	true,-- Devotion Aura
		[148039]	=	true,-- Sacred Shield
		[82326]	=	true,-- Divine Light
		[20167]	=	true,--seal of insight(mana)
		[65148]	=	true, --Sacred Shield
		[20167]	=	true, --Seal of Insight
		[86273]	=	true, --illuminated healing
		[85222]	=	true, --light of dawn
		[53652]	=	true, --beacon of light
		[82327]	=	true, --holy radiance
		[119952]	=	true, --arcing light
		[25914]	=	true, --holy shock
		[19750]	=	true, --flash of light
		[31850] 	= 	true, -- Ardent Defender --defensive cd
		[1044] 	= 	true, -- Hand of Freedom --helpful
		[114039] 	= 	true, -- Hand of Purity
		[4987] 	= 	true, -- Cleanse
		[136494] 	= 	true, -- Word of Glory

	--priest
		[48173]	= true, -- Desperate Prayer, Rank 9
		[47788]	= true, -- Guardian Spirit
		[32375]	= true, -- Mass Dispel
		[48120]	= true, -- Binding Heal, Rank 3
		[33110]	= true, -- prayer of mending
		[48072]	= true, -- prayer of healing, Rank 7
		[48089]	= true, -- circle of healing, Rank 7
		[48068]	= true, -- renew, Rank 14
		[48063]	= true, -- greater heal, Rank 9
		[48071]	= true, -- flash heal, Rank 11
		[48066]	= true, -- power word: shield, Rank 14
		[64904] = true, -- hymn of hope
		[48113] = true, -- Prayer of Mending
		[2053]	= true, -- Heal, Rank 3

		--rogue
		[73651]	=	true, --Recuperate(heal)
		[35546]	=	true, --combat potency(energy)
		[98440]	=	true, --relentless strikes(energy)
		[51637]	=	true, --venomous vim(energy)
		[31224]	=	true, -- Cloak of Shadows(cooldown)
		[1966]	=	true, -- Feint(helpful)
		[76577]	=	true, -- Smoke Bomb
		[5277]	=	true, -- Evasion

		--shaman
		--[88765]	=	true, --rolling thunder(mana)
		[51490]	=	true, --thunderstorm(mana)
		--[82987]	=	true, --telluric currents glyph(mana)
		[101033]	=	true, --resurgence(mana)
		[51522]	=	true, --primal wisdom(mana)
		--[63375]	=	true, --primal wisdom(mana)
		[114942]	=	true, --healing tide
		[73921]	=	true, --healing rain
		[1064]	=	true, --chain heal
		[52042]	=	true, --healing stream totem
		[61295]	=	true, --riptide
		--[51945]	=	true, --earthliving
		[114083]	=	true, --restorative mists
		[8004]	=	true, --healing surge
		[5394]	=	true, -- Healing Stream Totem(heal)
		[73920]	=	true, -- Healing Rain
		[108270]	=	true, -- Stone Bulwark Totem
		--[331]	=	true, -- Healing Wave
		[52127]	=	true, -- Water Shield
		[77472]	=	true, -- Greater Healing Wave
		[108271]	=	true, -- Astral Shift
		[30823]	=	true, --Shamanistic Rage
		[77130]	=	true, -- Purify Spirit
		[51886] 	= 	true, -- Cleanse Spirit
		[98008] 	= 	true, -- Spirit Link Totem

		--warlock
		[108359]	=	true, -- Dark Regeneration(helpful)
		[110913]	=	true, -- Dark Bargain
		[104773]	=	true, -- Unending Resolve
		--[6229]	=	true, -- Twilight Ward
		[114635]	=	true, -- Ember Tap
		--[131623]	=	true, -- Twilight Ward
		[108416]	=	true, -- Sacrificial Pact
		[132413]	=	true, -- Shadow Bulwark
		[114189] 	= 	true, -- Health Funnel

		--warrior
		[871]	=	true, -- Shield Wall
		[97462]	=	true, -- Rallying Cry
		[118038]	=	true, -- Die by the Sword
		--[114203]	=	true, -- Demoralizing Banner
		[114028]	=	true, -- Mass Spell Reflection
		[55694]	=	true, -- Enraged Regeneration
		[112048]	=	true, -- Shield Barrier
		[23920]	=	true, -- Spell Reflection
		[12975]	=	true, -- Last Stand
		[2565] 	= 	true, -- Shield Block
	}


	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	_detalhes.SpellOverwrite = {
		--[124464] = {name = GetSpellInfo(124464).."("..Loc["STRING_MASTERY"]..")"}, --> shadow word: pain mastery proc(priest)
	}

	function _detalhes:IsCooldown(spellid)
		return _detalhes.DefensiveCooldownSpellsNoBuff[spellid] or _detalhes.DefensiveCooldownSpells[spellid]
	end

	_detalhes.spells_school = {
		[1] = {name = STRING_SCHOOL_PHYSICAL, formated = "|cFFFFFF00"..STRING_SCHOOL_PHYSICAL.."|r", hex = "FFFFFF00", rgb = {255, 255, 0}, decimals = {1.00, 1.00, 0.00}},
		[2] = {name = STRING_SCHOOL_HOLY, formated = "|cFFFFE680"..STRING_SCHOOL_HOLY.."|r", hex = "FFFFE680", rgb = {255, 230, 128}, decimals = {1.00, 0.90, 0.50}},
		[4] = {name = STRING_SCHOOL_FIRE, formated = "|cFFFF8000"..STRING_SCHOOL_FIRE.."|r", hex = "FFFF8000", rgb = {255, 128, 0}, decimals = {1.00, 0.50, 0.00}},
		[8] = {name = STRING_SCHOOL_NATURE, formated = "|cFFbeffbe"..STRING_SCHOOL_NATURE.."|r", hex = "FFbeffbe", rgb = {190, 190, 190}, decimals = {0.7451, 1.0000, 0.7451}},
		[16] = {name = STRING_SCHOOL_FROST, formated = "|cFF80FFFF"..STRING_SCHOOL_FROST.."|r", hex = "FF80FFFF", rgb = {128, 255, 255}, decimals = {0.50, 1.00, 1.00}},
		[32] = {name = STRING_SCHOOL_SHADOW, formated = "|cFF8080FF"..STRING_SCHOOL_SHADOW.."|r", hex = "FF8080FF", rgb = {128, 128, 255}, decimals = {0.50, 0.50, 1.00}},
		[64] = {name = STRING_SCHOOL_ARCANE, formated = "|cFFFF80FF"..STRING_SCHOOL_ARCANE.."|r", hex = "FFFF80FF", rgb = {255, 128, 255}, decimals = {1.00, 0.50, 1.00}},
		[3] = {name = STRING_SCHOOL_HOLYSTRIKE, formated = "|cFFFFF240"..STRING_SCHOOL_HOLYSTRIKE.."|r", hex = "FFFFF240", rgb = {255, 64, 64}, decimals = {1.0000, 0.9490, 0.2510}}, --#FFF240
		[5] = {name = STRING_SCHOOL_FLAMESTRIKE, formated = "|cFFFFB900"..STRING_SCHOOL_FLAMESTRIKE.."|r", hex = "FFFFB900", rgb = {255, 0, 0}, decimals = {1.0000, 0.7255, 0.0000}}, --#FFB900
		[6] = {name = STRING_SCHOOL_HOLYFIRE, formated = "|cFFFFD266"..STRING_SCHOOL_HOLYFIRE.."|r", hex = "FFFFD266", rgb = {255, 102, 102}, decimals = {1.0000, 0.8235, 0.4000}}, --#FFD266
		[9] = {name = STRING_SCHOOL_STORMSTRIKE, formated = "|cFFAFFF23"..STRING_SCHOOL_STORMSTRIKE.."|r", hex = "FFAFFF23", rgb = {175, 35, 35}, decimals = {0.6863, 1.0000, 0.1373}}, --#AFFF23
		[10] = {name = STRING_SCHOOL_HOLYSTORM, formated = "|cFFC1EF6E"..STRING_SCHOOL_HOLYSTORM.."|r", hex = "FFC1EF6E", rgb = {193, 110, 110}, decimals = {0.7569, 0.9373, 0.4314}}, --#C1EF6E
		[12] = {name = STRING_SCHOOL_FIRESTORM, formated = "|cFFAFB923"..STRING_SCHOOL_FIRESTORM.."|r", hex = "FFAFB923", rgb = {175, 35, 35}, decimals = {0.6863, 0.7255, 0.1373}}, --#AFB923
		[17] = {name = STRING_SCHOOL_FROSTSTRIKE, formated = "|cFFB3FF99"..STRING_SCHOOL_FROSTSTRIKE.."|r", hex = "FFB3FF99", rgb = {179, 153, 153}, decimals = {0.7020, 1.0000, 0.6000}},--#B3FF99
		[18] = {name = STRING_SCHOOL_HOLYFROST, formated = "|cFFCCF0B3"..STRING_SCHOOL_HOLYFROST.."|r", hex = "FFCCF0B3", rgb = {204, 179, 179}, decimals = {0.8000, 0.9412, 0.7020}},--#CCF0B3
		[20] = {name = STRING_SCHOOL_FROSTFIRE, formated = "|cFFC0C080"..STRING_SCHOOL_FROSTFIRE.."|r", hex = "FFC0C080", rgb = {192, 128, 128}, decimals = {0.7529, 0.7529, 0.5020}}, --#C0C080
		[24] = {name = STRING_SCHOOL_FROSTSTORM, formated = "|cFF69FFAF"..STRING_SCHOOL_FROSTSTORM.."|r", hex = "FF69FFAF", rgb = {105, 175, 175}, decimals = {0.4118, 1.0000, 0.6863}}, --#69FFAF
		[33] = {name = STRING_SCHOOL_SHADOWSTRIKE, formated = "|cFFC6C673"..STRING_SCHOOL_SHADOWSTRIKE.."|r", hex = "FFC6C673", rgb = {198, 115, 115}, decimals = {0.7765, 0.7765, 0.4510}},--#C6C673
		[34] = {name = STRING_SCHOOL_SHADOWHOLY, formated = "|cFFD3C2AC"..STRING_SCHOOL_SHADOWHOLY.."|r", hex = "FFD3C2AC", rgb = {211, 172, 172}, decimals = {0.8275, 0.7608, 0.6745}},--#D3C2AC
		[36] = {name = STRING_SCHOOL_SHADOWFLAME, formated = "|cFFB38099"..STRING_SCHOOL_SHADOWFLAME.."|r", hex = "FFB38099", rgb = {179, 153, 153}, decimals = {0.7020, 0.5020, 0.6000}}, -- #B38099
		[40] = {name = STRING_SCHOOL_SHADOWSTORM, formated = "|cFF6CB3B8"..STRING_SCHOOL_SHADOWSTORM.."|r", hex = "FF6CB3B8", rgb = {108, 184, 184}, decimals = {0.4235, 0.7020, 0.7216}}, --#6CB3B8
		[48] = {name = STRING_SCHOOL_SHADOWFROST, formated = "|cFF80C6FF"..STRING_SCHOOL_SHADOWFROST.."|r", hex = "FF80C6FF", rgb = {128, 255, 255}, decimals = {0.5020, 0.7765, 1.0000}},--#80C6FF
		[65] = {name = STRING_SCHOOL_SPELLSTRIKE, formated = "|cFFFFCC66"..STRING_SCHOOL_SPELLSTRIKE.."|r", hex = "FFFFCC66", rgb = {255, 102, 102}, decimals = {1.0000, 0.8000, 0.4000}},--#FFCC66
		[66] = {name = STRING_SCHOOL_DIVINE, formated = "|cFFFFBDB3"..STRING_SCHOOL_DIVINE.."|r", hex = "FFFFBDB3", rgb = {255, 179, 179}, decimals = {1.0000, 0.7412, 0.7020}},--#FFBDB3
		[68] = {name = STRING_SCHOOL_SPELLFIRE, formated = "|cFFFF808C"..STRING_SCHOOL_SPELLFIRE.."|r", hex = "FFFF808C", rgb = {255, 140, 140}, decimals = {1.0000, 0.5020, 0.5490}}, --#FF808C
		[72] = {name = STRING_SCHOOL_SPELLSTORM, formated = "|cFFAFB9AF"..STRING_SCHOOL_SPELLSTORM.."|r", hex = "FFAFB9AF", rgb = {175, 175, 175}, decimals = {0.6863, 0.7255, 0.6863}}, --#AFB9AF
		[80] = {name = STRING_SCHOOL_SPELLFROST, formated = "|cFFC0C0FF"..STRING_SCHOOL_SPELLFROST.."|r", hex = "FFC0C0FF", rgb = {192, 255, 255}, decimals = {0.7529, 0.7529, 1.0000}},--#C0C0FF
		[96] = {name = STRING_SCHOOL_SPELLSHADOW, formated = "|cFFB980FF"..STRING_SCHOOL_SPELLSHADOW.."|r", hex = "FFB980FF", rgb = {185, 255, 255}, decimals = {0.7255, 0.5020, 1.0000}},--#B980FF

		[28] = {name = STRING_SCHOOL_ELEMENTAL, formated = "|cFF0070DE"..STRING_SCHOOL_ELEMENTAL.."|r", hex = "FF0070DE", rgb = {0, 222, 222}, decimals = {0.0000, 0.4392, 0.8706}},
		[124] = {name = STRING_SCHOOL_CHROMATIC, formated = "|cFFC0C0C0"..STRING_SCHOOL_CHROMATIC.."|r", hex = "FFC0C0C0", rgb = {192, 192, 192}, decimals = {0.7529, 0.7529, 0.7529}},
		[126] = {name = STRING_SCHOOL_MAGIC, formated = "|cFF1111FF"..STRING_SCHOOL_MAGIC.."|r", hex = "FF1111FF", rgb = {17, 255, 255}, decimals = {0.0667, 0.0667, 1.0000}},
		[127] = {name = STRING_SCHOOL_CHAOS, formated = "|cFFFF1111"..STRING_SCHOOL_CHAOS.."|r", hex = "FFFF1111", rgb = {255, 17, 17}, decimals = {1.0000, 0.0667, 0.0667}},
	}

	_detalhes.OverrideSpellSchool = {
		--[196917] = 126, --light of the martyr - from holy to fire
	}

	function _detalhes:GetSpellSchoolName(school)
		return _detalhes.spells_school[school] and _detalhes.spells_school[school].name or ""
	end

	function _detalhes:GetSpellSchoolFormatedName(school)
		return _detalhes.spells_school[school] and _detalhes.spells_school[school].formated or ""
	end

	local default_school_color = {145/255, 180/255, 228/255}
	function _detalhes:GetSpellSchoolColor(school)
		return unpack(_detalhes.spells_school[school] and _detalhes.spells_school[school].decimals or default_school_color)
	end

	function _detalhes:GetCooldownList(class)
		class = class or select(2, UnitClass("player"))
		return _detalhes.DefensiveCooldownSpells[class]
	end
end