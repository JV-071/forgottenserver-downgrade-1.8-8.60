local loginMessage = CreatureEvent("loginMessage")

function loginMessage.onLogin(player)
    local rewardChest = player:getRewardChest()
    local rewardContainerCount = 0
    for _, item in ipairs(rewardChest:getItems()) do
        if item:getId() == ITEM_REWARD_CONTAINER then
            rewardContainerCount = rewardContainerCount + 1
        end
    end
    -- 06/11/2026: mensagens em portugues por padrao; ingles so se o client avisou "en"
    -- (storage 50103 = 1). O idioma chega pelo opcode estendido 1 DEPOIS deste onLogin,
    -- entao no 1o login ainda nao ha valor salvo -> portugues (jogadores brasileiros).
    local pt = player:getStorageValue(50103) ~= 1
    if rewardContainerCount > 0 then
        if pt then
            player:sendTextMessage(MESSAGE_STATUS_DEFAULT, string.format("Você tem %d recompensa%s no seu baú de recompensas.", rewardContainerCount, rewardContainerCount > 1 and "s" or ""))
        else
            player:sendTextMessage(MESSAGE_STATUS_DEFAULT, string.format("You have %d reward%s in your reward chest.", rewardContainerCount, rewardContainerCount > 1 and "s" or ""))
        end
    end

    local serverName = configManager.getString(configKeys.SERVER_NAME)
    local loginStr = pt and ("Bem-vindo ao " .. serverName .. "!") or ("Welcome to " .. serverName .. "!")
    if player:getLastLoginSaved() <= 0 then
        loginStr = loginStr .. (pt and " Escolha a sua roupa." or " Please choose your outfit.")
        player:sendOutfitWindow()
    elseif pt then
        loginStr = string.format("Sua última visita ao %s: %s.", serverName, os.date("%d/%m/%Y %H:%M:%S", player:getLastLoginSaved()))
    else
        loginStr = string.format("Your last visit in %s: %s.", serverName, os.date("%d %b %Y %X", player:getLastLoginSaved()))
    end
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

    local vocation = player:getVocation()
    local promotion = vocation:getPromotion()
    if player:isPremium() then
        local value = player:getStorageValue(PlayerStorageKeys.promotion)
        if value and value == 1 then
            player:setVocation(promotion)
        end
    elseif not promotion then
        player:setVocation(vocation:getDemotion())
    end

    -- Update Experience Rate Stamina
    player:updateStamina()

    player:registerEvent("logoutMessage")

    player:openChannel(10)

	if configManager.getBoolean(RESET_SYSTEM_ENABLED) then
		if ResetBonusConfig then
			ResetBonusConfig.applyBonuses(player)
		end
	end

    if player:isTokenProtected() then
        player:setTokenLocked(true)
        if pt then
            player:popupFYI("=== PROTEÇÃO POR TOKEN ===\n\nSua conta está protegida por TOKEN.\n\nVocê não pode mover nem jogar itens até desbloquear.\n\nDigite: !token <sua_senha>\n\npara desbloquear o personagem.")
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "[Token] Você está BLOQUEADO! Digite !token <senha> para desbloquear.")
        else
            player:popupFYI("=== TOKEN PROTECTION ===\n\nYour account is protected by TOKEN.\n\nYou cannot move or drop items until you unlock.\n\nType: !token <your_password>\n\nto unlock your character.")
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "[Token] You are LOCKED! Type !token <password> to unlock.")
        end
    end

    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, pt and "[Montaria] Use Ctrl+M para montar ou desmontar." or "[Mount] Use Ctrl+M to mount or dismount your mount.")

    return true
end
loginMessage:register()

local logoutMessage = CreatureEvent("logoutMessage")
function logoutMessage.onLogout(player)
    local playerId = player:getId()
    nextUseStaminaTime[playerId] = nil
    WorkbenchSessions.clearOwner(playerId, false)
    ImbuingWindow.close(player)
    return true
end
logoutMessage:register()
