-- energy ability file
local _detalhes = _detalhes

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants
local habilidade_energy	= _detalhes.habilidade_e_energy

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals
function habilidade_energy:NovaTabela(id, link, token)
	local _newEnergySpell = {
		id = id,
		counter = 0,
		total = 0,
		targets = {}
	}

	return _newEnergySpell
end

function habilidade_energy:Add(serial, nome, flag, amount, who_nome, powertype)
	self.counter = self.counter + 1
	self.total = self.total + amount
	self.targets[nome] = (self.targets[nome] or 0) + amount
end