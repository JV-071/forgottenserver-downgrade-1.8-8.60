--[[
    SISTEMA DE NOTIFICAÇÃO DE ATTACK SPEED POR FIST FIGHTING
    The Forgotten Server (TFS 1.x / RevScriptSys)

    Nota: O cálculo mecânico e a aplicação do bônus de velocidade agora são executados
    diretamente no CORE C++ (Player::getAttackSpeedBeforeEquipmentBonus).
    Este script é responsável pelo feedback visual amigável ao jogador quando ele treina.
--]]

local fistSpeedLogin = CreatureEvent("FistAttackSpeedLogin")

function fistSpeedLogin.onLogin(player)
    player:registerEvent("FistAttackSpeedAdvance")
    return true
end

fistSpeedLogin:register()

local fistSpeedAdvance = CreatureEvent("FistAttackSpeedAdvance")

function fistSpeedAdvance.onAdvance(player, skill, oldLevel, newLevel)
    if skill == SKILL_FIST and newLevel > 10 then
        local currentSpeed = player:getAttackSpeed()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Fist Training] Seu foco e agilidade aumentaram! Seu intervalo de ataque agora é de %d ms.", currentSpeed))
    end
    return true
end

fistSpeedAdvance:register()
