local sunderCount = {
	name = "Sunder Count",
	icon = [[Interface\Icons\Ability_Warrior_Sunder]],
	source = false,
	attribute = false,
	spellid = false,
	target = false,
	author = "Matz",
	desc = "Shows who uses Sunder Armor.",
	script_version = 2,
	script = [[
		local combat, container, instance = ...
		local total, top, amount = 0, 0, 0

		local sunderName = GetSpellInfo(11597)
		local actors = combat:GetActorList(DETAILS_ATTRIBUTE_MISC)
		for i, actor in ipairs(actors) do
			if actor:IsPlayer() and actor.spell_cast then
				for spellName, count in pairs(actor.spell_cast) do
					if spellName == sunderName then
						container:AddValue(actor, count)
					end
				end
			end
		end

		total, top = container:GetTotalAndHighestValue()
		amount = container:GetNumActors()

		return total, top, amount
	]],
	total_script = [[
		local value, top, total, combat, instance = ...
		return math.floor(value)
	]],
	percent_script = [[
		local value, top, total, combat, instance = ...
		return string.format("%.1f", value / total * 100)
	]],
	tooltip = false,
	notooltip = true,
}

Details:InstallCustomObject(sunderCount)