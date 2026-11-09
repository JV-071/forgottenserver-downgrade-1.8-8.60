-- Idioma do cliente do jogador (06/11/2026).
-- O client (modules/client_locales/locales.lua) manda ExtendedOpcode 1 com o nome do locale ("pt"/"en")
-- no inicio do jogo e sempre que o jogador troca o idioma. O handler fica em
-- data/scripts/creaturescripts/others/npc_language.lua; quem usa e o sistema de NPC
-- (data/npc/lib/npc_lang.lua) para falar no idioma do jogador.
-- Persistido em storage (sobrevive ao relog). Sem valor salvo = ingles.
--
-- IMPORTANTE: o servidor NAO deve responder com o opcode 1; o client trata o opcode 1 recebido como
-- "troque o idioma e recarregue os modulos" (onExtendedLocales).

ClientLanguage = ClientLanguage or {}
ClientLanguage.OPCODE = 1
ClientLanguage.STORAGE = (PlayerStorageKeys and PlayerStorageKeys.clientLanguage) or 50103
ClientLanguage.DEFAULT = "en"
-- valor da storage <-> codigo do idioma
ClientLanguage.codes = { [1] = "en", [2] = "pt" }
ClientLanguage.values = { en = 1, pt = 2 }

-- Normaliza o que veio do client: "pt", "PT", "pt_BR", "pt-br" -> "pt"; "en_US" -> "en".
-- Retorna nil para idiomas nao suportados (de/es/pl/sv...).
function ClientLanguage.normalize(value)
	if type(value) ~= "string" then
		return nil
	end
	local code = value:lower():match("^%s*(%a%a)")
	if code and ClientLanguage.values[code] then
		return code
	end
	return nil
end

function Player.getLanguage(self)
	local value = self:getStorageValue(ClientLanguage.STORAGE)
	return ClientLanguage.codes[value] or ClientLanguage.DEFAULT
end

-- Retorna true se o idioma foi aceito (e salvo).
function Player.setLanguage(self, language)
	local code = ClientLanguage.normalize(language)
	if not code then
		return false
	end
	local value = ClientLanguage.values[code]
	if self:getStorageValue(ClientLanguage.STORAGE) ~= value then
		self:setStorageValue(ClientLanguage.STORAGE, value)
	end
	return true
end
