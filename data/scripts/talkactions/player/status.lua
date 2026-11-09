-- !status -> skills e velocidade de ataque, como no PbotWars ("Fist Fighting, AttackSpeed (ms) e Hits por segundo").
-- Mesmo texto do Crystal (data/scripts/talkactions/player/status.lua de 04/11/2026), portado para a TFS em 05/11/2026.
-- A velocidade real vem de player:getAttackSpeed() (binding C++; curva fist -> attack speed em Player::getAttackSpeed).
-- Curva medida em 04/11/2026 (BALANCEAMENTO.md secao 13): ms = base - floor(base * fist * 34 / 10000), piso 250 ms.
local status = TalkAction("!status")

local FALLBACK_PERCENT = 34
local FALLBACK_MINIMUM = 250

local SKILLS = {
	{ SKILL_CLUB, "Club" },
	{ SKILL_SWORD, "Sword" },
	{ SKILL_AXE, "Axe" },
	{ SKILL_DISTANCE, "Distance" },
	{ SKILL_SHIELD, "Shielding" },
	{ SKILL_FISHING, "Fishing" },
}

local function hitsPerSecond(ms)
	return string.format("%.1f hits/s", 1000 / math.max(ms, 1))
end

local function effectiveSkill(player, skill)
	if player.getEffectiveSkillLevel then
		return player:getEffectiveSkillLevel(skill)
	end
	return player:getSkillLevel(skill)
end

function status.onSay(player, words, param)
	local baseFist = player:getSkillLevel(SKILL_FIST)
	local fist = effectiveSkill(player, SKILL_FIST)
	local fistText = tostring(fist)
	if fist ~= baseFist then
		fistText = string.format("%d (base %d)", fist, baseFist)
	end

	local lines = {
		string.format("Status de %s - %s, level %d.", player:getName(), player:getVocation():getName(), player:getLevel()),
	}

	if player.getAttackSpeed then
		local ms = player:getAttackSpeed()
		lines[#lines + 1] = string.format("Fist Fighting: %s | Attack speed: %d ms | %s", fistText, ms, hitsPerSecond(ms))
	else
		local base = player:getVocation():getAttackSpeed()
		local predicted = math.max(FALLBACK_MINIMUM, base - math.floor(base * fist * FALLBACK_PERCENT / 10000))
		lines[#lines + 1] = string.format("Fist Fighting: %s | Attack speed: %d ms (%s) | previsto com fist: %d ms (%s) - exe sem o patch",
			fistText, base, hitsPerSecond(base), predicted, hitsPerSecond(predicted))
	end

	local skills = {}
	for _, skill in ipairs(SKILLS) do
		local level = effectiveSkill(player, skill[1])
		local base = player:getSkillLevel(skill[1])
		skills[#skills + 1] = level ~= base and string.format("%s %d (base %d)", skill[2], level, base)
			or string.format("%s %d", skill[2], level)
	end
	lines[#lines + 1] = string.format("Skills: %s | Magic level: %d", table.concat(skills, ", "), player:getMagicLevel())

	-- Crystal usava MESSAGE_LOOK (verde, na tela); no 8.60 o equivalente que aparece NA TELA e no console e MESSAGE_INFO_DESCR (mensagem de "look").
	player:sendTextMessage(MESSAGE_INFO_DESCR, table.concat(lines, "\n"))
	return false
end

status:separator(" ")
status:register()
