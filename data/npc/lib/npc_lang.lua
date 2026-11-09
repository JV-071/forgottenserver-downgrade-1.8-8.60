-- NPCs no idioma do cliente do jogador (06/11/2026).
--
-- Como funciona
--   * O idioma vem do client (ExtendedOpcode 1 -> Player:getLanguage(), ver data/lib/functions/npc_language.lua).
--   * Dicionarios por idioma de DESTINO: npc_pt.lua (texto original -> portugues) e npc_en.lua
--     (texto original em portugues -> ingles). Texto sem traducao sai como esta.
--   * Chaves podem ter tags do NpcHandler (|PLAYERNAME|, |ITEMNAME|, |ITEMCOUNT|, |TOTALCOST|, |TIME|...)
--     e/ou $1..$9 (pedacos montados por concatenacao nos scripts, ex.: nome da cidade, preco).
--     A traducao e aplicada:
--       1) no TEMPLATE, antes das tags serem trocadas (NpcHandler:parseMessage e string.replaceTags do
--          revnpcsys) - casa exato;
--       2) no texto FINAL que sai (NpcHandler:say, selfSay) - casa exato ou pelo molde (tags/$n viram
--          capturas), cobrindo as falas montadas por concatenacao nos scripts.
--     Texto ja traduzido nao casa com nenhuma chave, entao passar duas vezes nao tem efeito.
--   * Entrada do jogador: palavras em portugues (oi, tchau, sim, nao, negociar, ajuda, missao...) ganham o
--     equivalente em ingles anexado a mensagem (NpcHandler) ou substituem a mensagem inteira (revnpcsys, que
--     compara exato). Tambem ha alguns aliases ingles->portugues para NPCs cujos scripts esperam palavras em
--     portugues (help->ajuda, pickaxe->picareta...). Ingles continua funcionando como antes.
--
-- Encoding: este arquivo e os dicionarios sao UTF-8. O servidor converte UTF-8 -> Latin-1 ao mandar o texto
-- (NetworkMessage::addString); um caractere fora do Latin-1 (travessao, aspas curvas, reticencias unicas...)
-- faz a mensagem INTEIRA sair vazia. Use so caracteres Latin-1 nas traducoes.

NpcLang = NpcLang or {}
NpcLang.dicts = {} -- [idioma] = {exact = {}, templates = {}, templateBySrc = {}, fragments = {}}
NpcLang.aliases = {} -- {{pattern, to}} anexados a mensagem (NpcHandler)
NpcLang.exactAliases = {} -- [mensagem inteira normalizada] = to (revnpcsys)
NpcLang._wrapped = NpcLang._wrapped or setmetatable({}, {__mode = "k"})

local function getDict(lang)
	local dict = NpcLang.dicts[lang]
	if not dict then
		dict = {exact = {}, templates = {}, templateBySrc = {}, fragments = {}}
		NpcLang.dicts[lang] = dict
	end
	return dict
end

local function escapePattern(text)
	return (text:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0"))
end

-- Placeholders: |TAG| (letras maiusculas/digitos) ou $1..$9.
local function nextPlaceholder(text, init)
	local s1, e1 = text:find("|[%u%d]+|", init)
	local s2, e2 = text:find("%$%d", init)
	if s1 and (not s2 or s1 < s2) then
		return s1, e1, text:sub(s1, e1)
	elseif s2 then
		return s2, e2, text:sub(s2, e2)
	end
	return nil
end

local function compileTemplate(src, dst)
	local parts, names, literal = {"^"}, {}, 0
	local pos = 1
	while true do
		local s, e, name = nextPlaceholder(src, pos)
		if not s then
			break
		end
		local lit = src:sub(pos, s - 1)
		literal = literal + #lit
		parts[#parts + 1] = escapePattern(lit)
		parts[#parts + 1] = "(.-)"
		names[#names + 1] = name
		pos = e + 1
	end
	if #names == 0 then
		return nil
	end
	local tail = src:sub(pos)
	literal = literal + #tail
	if literal == 0 then
		return nil -- molde so de placeholders casaria com qualquer coisa
	end
	parts[#parts + 1] = escapePattern(tail)
	parts[#parts + 1] = "$"
	return {src = src, dst = dst, pattern = table.concat(parts), names = names, literal = literal}
end

-- NpcLang.add(lang, {["texto original"] = "traducao", ...})
function NpcLang.add(lang, entries)
	local dict = getDict(lang)
	local changed = false
	for src, dst in pairs(entries) do
		if type(src) == "string" and type(dst) == "string" and src ~= dst then
			dict.exact[src] = dst
			local template = compileTemplate(src, dst)
			if template then
				local old = dict.templateBySrc[src]
				if old then
					old.dst = dst
				else
					dict.templateBySrc[src] = template
					dict.templates[#dict.templates + 1] = template
					changed = true
				end
			end
		end
	end
	if changed then
		-- moldes mais especificos (mais texto fixo) primeiro
		table.sort(dict.templates, function(a, b)
			if a.literal ~= b.literal then
				return a.literal > b.literal
			end
			return a.src < b.src
		end)
	end
end

-- NpcLang.addFragments(lang, {{"padrao Lua", "substituicao"}, ...}) - trocas parciais (gsub) aplicadas
-- quando o texto inteiro nao tem traducao e nos pedacos capturados pelos moldes.
function NpcLang.addFragments(lang, list)
	local dict = getDict(lang)
	for _, item in ipairs(list) do
		dict.fragments[#dict.fragments + 1] = {item[1], item[2]}
	end
end

local function applyFragments(dict, text)
	for _, fragment in ipairs(dict.fragments) do
		text = text:gsub(fragment[1], fragment[2])
	end
	return text
end

local function translateCapture(dict, value)
	return dict.exact[value] or applyFragments(dict, value)
end

local function fillTemplate(template, values)
	local out = template.dst:gsub("|[%u%d]+|", function(tag)
		local value = values[tag]
		if value ~= nil then
			return tostring(value)
		end
	end)
	out = out:gsub("%$%d", function(tag)
		local value = values[tag]
		if value ~= nil then
			return tostring(value)
		end
	end)
	return out
end

-- Traduz um texto para o idioma lang (nil/sem dicionario = devolve igual).
function NpcLang.translate(lang, text)
	if type(text) ~= "string" or text == "" or not lang then
		return text
	end
	local dict = NpcLang.dicts[lang]
	if not dict then
		return text
	end
	local hit = dict.exact[text]
	if hit then
		return hit
	end
	for _, template in ipairs(dict.templates) do
		local captures = {text:match(template.pattern)}
		if captures[1] ~= nil then
			local values = {}
			for i, name in ipairs(template.names) do
				if values[name] == nil and captures[i] ~= nil then
					values[name] = translateCapture(dict, captures[i])
				end
			end
			return fillTemplate(template, values)
		end
	end
	if #dict.fragments > 0 then
		return applyFragments(dict, text)
	end
	return text
end

-- Idioma do jogador a partir de cid, nome ou userdata. nil quando nao da para saber (fala publica etc.).
function NpcLang.getLanguage(target)
	if target == nil or target == 0 or target == -1 then
		return nil
	end
	local ok, player = pcall(Player, target)
	if not ok or not player then
		return nil
	end
	if player.getLanguage then
		return player:getLanguage()
	end
	-- fallback se data/lib/functions/npc_language.lua nao estiver carregado neste estado Lua
	-- (mesma storage/valores: 1 = en, 2 = pt)
	return player:getStorageValue(50103) == 2 and "pt" or "en"
end

-- Atalho: traduz text para o idioma do jogador target.
function NpcLang.t(target, text)
	if type(text) ~= "string" then
		return text
	end
	local lang = NpcLang.getLanguage(target)
	if not lang then
		return text
	end
	return NpcLang.translate(lang, text)
end

-- ---------------------------------------------------------------------------------------------------
-- Entrada do jogador
-- ---------------------------------------------------------------------------------------------------

-- UTF-8 (2 bytes, 0xC3 0x80-0xBF = U+00C0..U+00FF) -> ASCII sem acento
local FOLD = {}
do
	local map = {
		[0x80] = "a", [0x81] = "a", [0x82] = "a", [0x83] = "a", [0x84] = "a", [0x85] = "a",
		[0x87] = "c", [0x88] = "e", [0x89] = "e", [0x8A] = "e", [0x8B] = "e",
		[0x8C] = "i", [0x8D] = "i", [0x8E] = "i", [0x8F] = "i", [0x91] = "n",
		[0x92] = "o", [0x93] = "o", [0x94] = "o", [0x95] = "o", [0x96] = "o",
		[0x99] = "u", [0x9A] = "u", [0x9B] = "u", [0x9C] = "u", [0x9D] = "y",
		[0xA0] = "a", [0xA1] = "a", [0xA2] = "a", [0xA3] = "a", [0xA4] = "a", [0xA5] = "a",
		[0xA7] = "c", [0xA8] = "e", [0xA9] = "e", [0xAA] = "e", [0xAB] = "e",
		[0xAC] = "i", [0xAD] = "i", [0xAE] = "i", [0xAF] = "i", [0xB1] = "n",
		[0xB2] = "o", [0xB3] = "o", [0xB4] = "o", [0xB5] = "o", [0xB6] = "o",
		[0xB9] = "u", [0xBA] = "u", [0xBB] = "u", [0xBC] = "u", [0xBD] = "y", [0xBF] = "y",
	}
	for byte, ascii in pairs(map) do
		FOLD[string.char(0xC3, byte)] = ascii
	end
end

-- minusculas + sem acentos (para comparar palavras-chave). Tira o acento ANTES e so baixa A-Z: string.lower
-- depende do locale do processo e, em locale Latin-1, estraga o byte 0xC3 do UTF-8.
function NpcLang.fold(text)
	local folded = text:gsub("\195[\128-\191]", function(char)
		return FOLD[char] or char
	end)
	folded = folded:gsub("[A-Z]", function(char)
		return string.char(char:byte() + 32)
	end)
	return folded
end

-- NpcLang.addAliases({{"frase", "keyword"}, ...}, exact)
--   frase: minusculas e sem acento; keyword: o que o script do NPC entende.
--   exact = true tambem vale para o revnpcsys (mensagem inteira igual a frase -> keyword).
function NpcLang.addAliases(list, exact)
	for _, item in ipairs(list) do
		local phrase, to = item[1], item[2]
		NpcLang.aliases[#NpcLang.aliases + 1] = {
			pattern = "%f[%w]" .. escapePattern(phrase) .. "%f[%W]",
			to = to,
		}
		if exact and NpcLang.exactAliases[phrase] == nil then
			NpcLang.exactAliases[phrase] = to
		end
	end
end

-- "oi, tudo bem?" -> "oi, tudo bem? hi"
function NpcLang.expandInput(message)
	if type(message) ~= "string" or message == "" or #NpcLang.aliases == 0 then
		return message
	end
	local folded = " " .. NpcLang.fold(message) .. " "
	local extra, seen = {}, {}
	for _, alias in ipairs(NpcLang.aliases) do
		if not seen[alias.to] and folded:find(alias.pattern) then
			seen[alias.to] = true
			extra[#extra + 1] = alias.to
		end
	end
	if #extra == 0 then
		return message
	end
	return message .. " " .. table.concat(extra, " ")
end

-- revnpcsys compara a mensagem inteira: "Oi!" -> "hi"
function NpcLang.mapExactInput(message)
	if type(message) ~= "string" then
		return message
	end
	local key = NpcLang.fold(message):match("^[%s%p]*(.-)[%s%p]*$")
	return NpcLang.exactAliases[key] or message
end

-- ---------------------------------------------------------------------------------------------------
-- Ganchos (idempotentes: /reload npc nao embrulha duas vezes)
-- ---------------------------------------------------------------------------------------------------

local function wrap(holder, key, makeWrapper)
	if type(holder) ~= "table" then
		return
	end
	local current = rawget(holder, key)
	if type(current) ~= "function" or NpcLang._wrapped[current] then
		return
	end
	local wrapper = makeWrapper(current)
	NpcLang._wrapped[wrapper] = true
	holder[key] = wrapper
end

-- dicionarios
dofile("data/npc/lib/npc_pt.lua")
dofile("data/npc/lib/npc_en.lua")

if NpcHandler then
	-- 1) template antes das tags (greet, farewell, walkaway, keyword_reply, shop: todos passam por aqui)
	wrap(NpcHandler, "parseMessage", function(original)
		return function(self, msg, parseInfo)
			if type(msg) == "string" and type(parseInfo) == "table" then
				local name = parseInfo[TAG_PLAYERNAME or "|PLAYERNAME|"]
				if type(name) == "string" then
					msg = NpcLang.t(name, msg)
				end
			end
			return original(self, msg, parseInfo)
		end
	end)

	-- 2) texto final dito pelo NpcHandler (inclui falas montadas nos scripts)
	wrap(NpcHandler, "say", function(original)
		return function(self, message, focus, ...)
			if type(message) == "table" then
				local copy = {}
				for i, text in ipairs(message) do
					copy[i] = NpcLang.t(focus, text)
				end
				message = copy
			else
				message = NpcLang.t(focus, message)
			end
			return original(self, message, focus, ...)
		end
	end)

	-- 3) entrada do jogador
	wrap(NpcHandler, "onCreatureSay", function(original)
		return function(self, creature, msgtype, msg, ...)
			return original(self, creature, msgtype, NpcLang.expandInput(msg), ...)
		end
	end)
end

-- 4) selfSay direto dos scripts (e do onWalkAway / talk delay / revnpcsys talkqueue)
wrap(_G, "selfSay", function(original)
	return function(text, target, ...)
		if target == nil then
			return original(text)
		end
		return original(NpcLang.t(target, text), target, ...)
	end
end)

-- 5) revnpcsys: template antes das tags + entrada exata
wrap(string, "replaceTags", function(original)
	return function(text, params)
		if type(text) == "string" and type(params) == "table" and type(params.playerName) == "string" then
			text = NpcLang.t(params.playerName, text)
		end
		return original(text, params)
	end
end)

if NpcEvents then
	wrap(NpcEvents, "onSay", function(original)
		return function(npc, creature, messageType, message, ...)
			return original(npc, creature, messageType, NpcLang.mapExactInput(message), ...)
		end
	end)
end
