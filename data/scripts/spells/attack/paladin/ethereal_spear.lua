local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ETHEREALSPEAR)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)

local function callback(player, skill, attack, factor)
	local distanceSkill = player:getEffectiveSkillLevel(SKILL_DISTANCE)
	return calculateCombatScalingDamage(player, distanceSkill, attack, 0.70, 1.05)
end

combat:setCallback(CallBackParam.SKILLVALUE, callback)

local spell = Spell("instant")
function spell.onCastSpell(creature, variant) return combat:execute(creature, variant) end

spell:group("attack")
spell:id(108)
spell:name("Ethereal Spear")
spell:words("exori con")
spell:level(23)
spell:mana(25)
spell:isPremium(true)
spell:range(7)
spell:needTarget(true)
spell:blockWalls(true)
spell:cooldown(1 * 1500)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("paladin", "royal paladin")
spell:register()
