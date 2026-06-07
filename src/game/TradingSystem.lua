-- Empire des Conteneurs - Trading System
-- Gère les échanges entre joueurs

local TradingSystem = {}

local activeTrades = {}
local TRADE_TIMEOUT = 300  -- 5 minutes

-- ==================== INITIATION D'ÉCHANGE ====================

function TradingSystem:InitiateTrade(player1UserId, player2UserId, items1, items2)
    -- Générer un ID unique
    local tradeId = tostring(math.random(100000, 999999)) .. "_" .. os.time()
    
    activeTrades[tradeId] = {
        id = tradeId,
        player1 = player1UserId,
        player2 = player2UserId,
        items1 = items1,
        items2 = items2,
        acceptedBy = {},
        createdAt = tick(),
        expiresAt = tick() + TRADE_TIMEOUT,
        status = "waiting"  -- waiting, accepted, completed, cancelled
    }
    
    return {
        success = true,
        tradeId = tradeId,
        expiresIn = TRADE_TIMEOUT
    }
end

-- ==================== GESTION D'ÉCHANGE ====================

function TradingSystem:AcceptTrade(tradeId, playerUserId)
    local trade = activeTrades[tradeId]
    
    if not trade then
        return {
            success = false,
            message = "Échange inexistant"
        }
    end
    
    if tick() > trade.expiresAt then
        activeTrades[tradeId] = nil
        return {
            success = false,
            message = "L'échange a expiré"
        }
    end
    
    if playerUserId ~= trade.player1 and playerUserId ~= trade.player2 then
        return {
            success = false,
            message = "Vous ne participez pas à cet échange"
        }
    end
    
    -- Ajouter le joueur aux acceptés
    local alreadyAccepted = false
    for _, uid in ipairs(trade.acceptedBy) do
        if uid == playerUserId then
            alreadyAccepted = true
            break
        end
    end
    
    if not alreadyAccepted then
        table.insert(trade.acceptedBy, playerUserId)
    end
    
    -- Si les deux ont accepté, exécuter
    if #trade.acceptedBy >= 2 then
        trade.status = "completed"
        return {
            success = true,
            message = "Échange complété",
            tradeCompleted = true
        }
    end
    
    return {
        success = true,
        message = "Échange accepté, en attente de l'autre joueur",
        tradeCompleted = false
    }
end

function TradingSystem:CancelTrade(tradeId, playerUserId)
    local trade = activeTrades[tradeId]
    
    if not trade then
        return {
            success = false,
            message = "Échange inexistant"
        }
    end
    
    if playerUserId ~= trade.player1 and playerUserId ~= trade.player2 then
        return {
            success = false,
            message = "Vous ne participez pas à cet échange"
        }
    end
    
    trade.status = "cancelled"
    activeTrades[tradeId] = nil
    
    return {
        success = true,
        message = "Échange annulé"
    }
end

function TradingSystem:RejectTrade(tradeId, playerUserId)
    return self:CancelTrade(tradeId, playerUserId)
end

-- ==================== INFORMATIONS D'ÉCHANGE ====================

function TradingSystem:GetTradeInfo(tradeId)
    return activeTrades[tradeId]
end

function TradingSystem:GetPlayerTrades(playerUserId)
    local playerTrades = {}
    
    for tradeId, trade in pairs(activeTrades) do
        if trade.player1 == playerUserId or trade.player2 == playerUserId then
            table.insert(playerTrades, trade)
        end
    end
    
    return playerTrades
end

function TradingSystem:GetActiveTrades()
    return activeTrades
end

-- ==================== VALIDATION ====================

function TradingSystem:ValidateTrade(playerData1, playerData2, items1, items2)
    -- Vérifier que tous les items appartiennent au joueur
    for _, itemId in ipairs(items1) do
        local found = false
        for _, item in ipairs(playerData1.inventory) do
            if item.id == itemId then
                found = true
                break
            end
        end
        if not found then
            return {success = false, message = "Vous ne possédez pas tous les items à échanger"}
        end
    end
    
    for _, itemId in ipairs(items2) do
        local found = false
        for _, item in ipairs(playerData2.inventory) do
            if item.id == itemId then
                found = true
                break
            end
        end
        if not found then
            return {success = false, message = "L'autre joueur ne possède pas tous les items"}
        end
    end
    
    -- Vérifier l'espace d'inventaire
    if #playerData1.inventory - #items1 + #items2 > playerData1.depotMaxSlots then
        return {success = false, message = "Vous n'avez pas assez de place pour les items reçus"}
    end
    
    if #playerData2.inventory - #items2 + #items1 > playerData2.depotMaxSlots then
        return {success = false, message = "L'autre joueur n'a pas assez de place"}
    end
    
    return {success = true}
end

-- ==================== EXÉCUTION D'ÉCHANGE ====================

function TradingSystem:ExecuteTrade(playerData1, playerData2, tradeId)
    local trade = activeTrades[tradeId]
    
    if not trade or trade.status ~= "completed" then
        return {success = false, message = "Impossible d'exécuter l'échange"}
    end
    
    -- Transférer les items de player1 vers player2
    local itemsToRemovePlayer1 = {}
    for _, itemId in ipairs(trade.items1) do
        for i, item in ipairs(playerData1.inventory) do
            if item.id == itemId then
                table.insert(itemsToRemovePlayer1, {index = i, item = item})
                break
            end
        end
    end
    
    -- Transférer les items de player2 vers player1
    local itemsToRemovePlayer2 = {}
    for _, itemId in ipairs(trade.items2) do
        for i, item in ipairs(playerData2.inventory) do
            if item.id == itemId then
                table.insert(itemsToRemovePlayer2, {index = i, item = item})
                break
            end
        end
    end
    
    -- Effectuer les transferts (en ordre inverse pour éviter les décalages d'index)
    for i = #itemsToRemovePlayer1, 1, -1 do
        local itemEntry = itemsToRemovePlayer1[i]
        table.remove(playerData1.inventory, itemEntry.index)
        table.insert(playerData2.inventory, itemEntry.item)
    end
    
    for i = #itemsToRemovePlayer2, 1, -1 do
        local itemEntry = itemsToRemovePlayer2[i]
        table.remove(playerData2.inventory, itemEntry.index)
        table.insert(playerData1.inventory, itemEntry.item)
    end
    
    activeTrades[tradeId] = nil
    
    return {success = true, message = "Échange exécuté avec succès"}
end

-- ==================== NETTOYAGE ====================

function TradingSystem:CleanupExpiredTrades()
    local now = tick()
    
    for tradeId, trade in pairs(activeTrades) do
        if now > trade.expiresAt then
            activeTrades[tradeId] = nil
        end
    end
end

return TradingSystem
