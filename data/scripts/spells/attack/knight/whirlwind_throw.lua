local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_WEAPONTYPE)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)

local function callback(player, skill, attack, factor)
	return calculateCombatScalingDamage(player, skill, attack, 0.60, 0.90)
end

combat:setCallback(CallBackParam.SKILLVALUE, callback)

local spell = Spell("instant")
function spell.onCastSpell(creature, variant) return combat:execute(creature, variant) end

spell:group("attack")
spell:id(120)
spell:name("Whirlwind Throw")
spell:words("exori hur")
spell:level(28)
spell:mana(40)
spell:needWeapon(true)
spell:isPremium(true)
spell:range(5)
spell:needTarget(true)
spell:blockWalls(true)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("knight", "elite knight")
spell:register()
