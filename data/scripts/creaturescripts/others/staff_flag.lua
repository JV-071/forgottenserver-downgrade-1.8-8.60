-- 06/11/2026: avisa o client que o personagem e da staff (grupo com access: GM/CM/GOD), para liberar
-- o "spy up / spy down" (teclas + e - para ver o andar de cima/baixo) no modulo client game_spyfloor.
-- Opcode estendido 174: "1" = staff, "0" = jogador comum. Jogador comum nunca recebe o recurso.
local STAFF_OPCODE = 174

local staffFlag = CreatureEvent("staffFlagLogin")
function staffFlag.onLogin(player)
	local group = player:getGroup()
	local isStaff = group and group:getAccess() or false
	addEvent(function(cid, value)
		local p = Player(cid)
		if p then
			p:sendExtendedOpcode(STAFF_OPCODE, value)
		end
	end, 1000, player:getId(), isStaff and "1" or "0")
	return true
end
staffFlag:register()
