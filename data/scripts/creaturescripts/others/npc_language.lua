-- Idioma do cliente -> NPCs (06/11/2026). Ver data/lib/functions/npc_language.lua.
-- O client manda ExtendedOpcode 1 ("pt"/"en") no onGameStart e quando o jogador troca o idioma.
-- O C++ so entrega extended opcode de clients OTC (ProtocolGame::parseExtendedOpcode -> isOTC) e so
-- auto-registra o evento de nome "ExtendedOpcode"; por isso este evento tem nome proprio e e
-- registrado no login (nao conflita com outro handler generico que venha a existir).

local languageOpcode = CreatureEvent("NpcLanguageOpcode")

function languageOpcode.onExtendedOpcode(player, opcode, buffer)
	if opcode ~= ClientLanguage.OPCODE then
		return
	end
	-- valores fora de "pt"/"en" (de, es, pl, sv...) sao ignorados: mantem o idioma salvo.
	-- Nao responder com opcode 1: o client recarregaria os modulos.
	player:setLanguage(buffer)
end

languageOpcode:register()

local languageLogin = CreatureEvent("NpcLanguageLogin")

function languageLogin.onLogin(player)
	player:registerEvent("NpcLanguageOpcode")
	return true
end

languageLogin:register()
