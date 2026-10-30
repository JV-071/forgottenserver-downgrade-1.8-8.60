--[[
    SISTEMA GLOBAL DE ESCALONAMENTO DE DANO (COMBAT SCALING)
    The Forgotten Server (TFS 1.x / RevScriptSys)

    Regras de Balanceamento:
    - "2.5 as spells por skills": Multiplicador para Weapon Skills (Sword, Axe, Club, Distance, Fist).
    - "0.5 magia": Contribuição do Magic Level (ML) no escalonamento híbrido/físico.
    - "0.2 itens": Contribuição do Ataque da Arma/Equipamento (Attack).
    - "escalonamento": Fórmula unificada proporcional ao crescimento do personagem.
--]]

CombatScalingConfig = {
    enabled = true,

    -- [COMBATE FÍSICO / HÍBRIDO (Knight, Paladin, Monk)]
    physical = {
        skillWeight = 2.5,  -- 2.5 de dano por ponto de Skill
        magicWeight = 0.5,  -- 0.5 de dano por ponto de Magic Level
        itemWeight  = 0.2,  -- 0.2 de dano por ponto de Attack da arma/item
        levelWeight = 0.2,  -- level / 5 (padrão tradicional do Tibia)
    },

    -- [COMBATE MÁGICO (Sorcerer, Druid)]
    -- Permite que itens e armas mágicas (Wands/Rods) também contribuam para o dano dos magos
    mage = {
        levelWeight = 0.2,  -- level / 5
        itemWeight  = 0.2,  -- 0.2 do ataque da Wand/Rod equipada
        enableItemBonus = true,
    },

    -- Multiplicador global de dano para ajuste fino
    globalDamageMultiplier = 1.0
}

--[[
    Calcula o dano de uma spell física/híbrida (Knight, Paladin, Monk).
--]]
function calculateCombatScalingDamage(player, skill, attack, minFactor, maxFactor)
    if not player then
        return 0, 0
    end

    local level = player:getLevel()
    local magLevel = player:getMagicLevel()

    -- Núcleo de escalonamento físico:
    -- (Level * 0.2) + (Skill * 2.5) + (MagicLevel * 0.5) + (ItemAttack * 0.2)
    local cfg = CombatScalingConfig.physical
    local baseDamage = (level * cfg.levelWeight)
                     + (skill * cfg.skillWeight)
                     + (magLevel * cfg.magicWeight)
                     + (attack * cfg.itemWeight)

    baseDamage = baseDamage * CombatScalingConfig.globalDamageMultiplier

    local minMultiplier = minFactor or 0.8
    local maxMultiplier = maxFactor or 1.2

    local minDamage = math.floor(baseDamage * minMultiplier)
    local maxDamage = math.floor(baseDamage * maxMultiplier)

    if minDamage < 1 then minDamage = 1 end
    if maxDamage < minDamage then maxDamage = minDamage end

    return -minDamage, -maxDamage
end

--[[
    Calcula o dano de uma spell mágica (Sorcerer, Druid), integrando opcionalmente
    o bônus de ataque do item (Wand/Rod/Arma equipada) com o peso de 0.2.
--]]
function calculateMageCombatScalingDamage(player, magLevelMultMin, magLevelMultMax, flatBonusMin, flatBonusMax)
    if not player then
        return 0, 0
    end

    local level = player:getLevel()
    local magLevel = player:getMagicLevel()
    local cfg = CombatScalingConfig.mage

    local baseLevel = level * cfg.levelWeight

    local itemAttack = 0
    if cfg.enableItemBonus then
        local weapon = player:getWeapon()
        if weapon then
            itemAttack = weapon:getAttack()
        end
    end

    local itemBonus = itemAttack * cfg.itemWeight

    local minDamage = math.floor((baseLevel + (magLevel * (magLevelMultMin or 1.5)) + (flatBonusMin or 0) + itemBonus) * CombatScalingConfig.globalDamageMultiplier)
    local maxDamage = math.floor((baseLevel + (magLevel * (magLevelMultMax or 2.2)) + (flatBonusMax or 0) + itemBonus) * CombatScalingConfig.globalDamageMultiplier)

    if minDamage < 1 then minDamage = 1 end
    if maxDamage < minDamage then maxDamage = minDamage end

    return -minDamage, -maxDamage
end
