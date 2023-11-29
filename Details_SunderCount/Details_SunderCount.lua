local sunderCount = {
	name = "Sunder Count",
	icon = [[Interface\Icons\Ability_Warrior_Sunder]],
	source = false,
	attribute = false,
	spellid = false,
	target = false,
	author = "NoM0Re",
	desc = "Shows who uses Sunder Armor.",
	script_version = 2,
	script = [[
		local combat, CustomContainer, instance = ...
		local total, top, amount = 0, 0, 0
		
		local spellsToCount = {
			7386, -- Sunder Armor
			8647, -- Expose Armor
			47498, -- Devastate Rank 5
			47497, -- Devastate Rank 4
			30022, -- Devastate Rank 3
			30016, -- Devastate Rank 2
			20243, -- Devastate Rank 1	
		}

		for _, actor in ipairs(combat:GetActorList(4)) do
			if actor:IsPlayer() and actor.spell_cast then
				for spellID, count in pairs(actor.spell_cast) do
					for _, spell in ipairs(spellsToCount) do
						if spellID == spell then
							CustomContainer:AddValue(actor, count)
						end
					end
				end
			end
		end
		
		total, top = CustomContainer:GetTotalAndHighestValue()
		amount = CustomContainer:GetNumActors()
		
		return total, top, amount
	]],
	tooltip = [[
		local Actor, Combat, Instance = ...

		local GameCooltip = GameCooltip
		local GetSpellInfo = GetSpellInfo
		
		local spellsToCount = {
			7386, -- Sunder Armor
			8647, -- Expose Armor
			47498, -- Devastate Rank 5
			47497, -- Devastate Rank 4
			30022, -- Devastate Rank 3
			30016, -- Devastate Rank 2
			20243, -- Devastate Rank 1	
		}
		
		local Owner = Actor.nome
		for _, actor in ipairs(Combat:GetActorList(4)) do
			if actor:IsPlayer() and actor.nome == Owner and actor.spell_cast then
				for spellID, count in pairs(actor.spell_cast) do
					for _, spell in ipairs(spellsToCount) do
						if spellID == spell then
							local localizedSpellName, _, Icon = GetSpellInfo(spell)
							GameCooltip:AddLine(localizedSpellName, count)
							Details:AddTooltipBackgroundStatusbar()
							GameCooltip:AddIcon(Icon, 1, 1, _detalhes.tooltip.line_height, _detalhes.tooltip.line_height)
						end
					end
				end
			end
		end
	]],
	total_script = [[
		local value, top, total, combat, instance = ...
		return math.floor(value)
	]],
	percent_script = [[
		local value, top, total, combat, instance = ...
		return string.format("%.1f", value / total * 100)
	]],
}

Details:InstallCustomObject(sunderCount)
