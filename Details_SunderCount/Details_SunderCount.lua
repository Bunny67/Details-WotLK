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
		local combat, instance_container, instance = ...
		local total, top, amount = 0, 0, 0
		
		local spellsToCount = {
			7386, -- Sunder Armor, shut be same for every expansion
			20243, -- Devastate Rank 1
			30016, -- Devastate Rank 2
			30022, -- Devastate Rank 3
			47497, -- Devastate Rank 4
			47498, -- Devastate Rank 5
			8647, -- Expose Armor, shut be same for every expansion
		}

		for i, actor in ipairs(combat:GetActorList(4)) do
			if actor:IsPlayer() and actor.spell_cast then
				for spellName, count in pairs(actor.spell_cast) do
					for _, spellID in ipairs(spellsToCount) do
						if spellName == spellID then
							instance_container:AddValue(actor, count)
						end
					end
				end
			end
		end
		
		total, top = instance_container:GetTotalAndHighestValue()
		amount = instance_container:GetNumActors()
		
		return total, top, amount
	]],
	tooltip = [[
		local Actor, Combat, Instance = ...
		local Format = Details:GetCurrentToKFunction()

		--get the cooltip object(we dont use the convencional GameTooltip here)
		local GameCooltip = GameCooltip
		
		local spellsToCount = {
			7386, -- Sunder Armor, same for every expansion
			20243, -- Devastate Rank 1
			30016, -- Devastate Rank 2
			30022, -- Devastate Rank 3
			47497, -- Devastate Rank 4
			47498, -- Devastate Rank 5
			8647, -- Expose Armor, same for every expansion
		}
		
		local hoveredActorName = Actor.nome
		for i, actor in ipairs(Combat:GetActorList(4)) do
			if actor:IsPlayer() and actor.nome == hoveredActorName and actor.spell_cast then
				for _, spellID in ipairs(spellsToCount) do
					for spellName, count in pairs(actor.spell_cast) do
						if spellName == spellID then
							local localizedSpellName, _, Icon = GetSpellInfo(spellID)
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