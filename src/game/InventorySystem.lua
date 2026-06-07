-- Empire des Conteneurs - Inventory System
-- Gère l'inventaire des joueurs

local InventorySystem = {}

-- ==================== GESTION D'INVENTAIRE ====================

function InventorySystem:AddItem(playerData, item)
    if #playerData.inventory >= playerData.depotMaxSlots then
        return {
            success = false,
            message = "L'inventaire est plein!"
        }
    end
    
    table.insert(playerData.inventory, {
        id = math.random(100000, 999999),
        name = item.name,
        rarity = item.rarity,
        value = item.value,
        obtainedAt = os.time()
    })
    
    return {
        success = true,
        inventoryCount = #playerData.inventory
    }
end

function InventorySystem:RemoveItem(playerData, itemId)
    for i, item in ipairs(playerData.inventory) do
        if item.id == itemId then
            table.remove(playerData.inventory, i)
            return {success = true}
        end
    end
    
    return {
        success = false,
        message = "Objet non trouvé"
    }
end

function InventorySystem:SellItem(playerData, itemId)
    for i, item in ipairs(playerData.inventory) do
        if item.id == itemId then
            playerData.coins = playerData.coins + item.value
            table.remove(playerData.inventory, i)
            
            return {
                success = true,
                coinsGained = item.value,
                totalCoins = playerData.coins,
                itemName = item.name
            }
        end
    end
    
    return {
        success = false,
        message = "Objet non trouvé"
    }
end

function InventorySystem:SellAllCommon(playerData)
    local totalCoins = 0
    local itemsSold = 0
    
    for i = #playerData.inventory, 1, -1 do
        local item = playerData.inventory[i]
        if item.rarity == "Common" then
            totalCoins = totalCoins + item.value
            table.remove(playerData.inventory, i)
            itemsSold = itemsSold + 1
        end
    end
    
    playerData.coins = playerData.coins + totalCoins
    
    return {
        success = true,
        itemsSold = itemsSold,
        coinsGained = totalCoins,
        totalCoins = playerData.coins
    }
end

-- ==================== INFORMATIONS D'INVENTAIRE ====================

function InventorySystem:GetInventory(playerData)
    return {
        items = playerData.inventory,
        count = #playerData.inventory,
        maxSlots = playerData.depotMaxSlots,
        availableSlots = playerData.depotMaxSlots - #playerData.inventory
    }
end

function InventorySystem:GetInventoryStats(playerData)
    local stats = {
        total = #playerData.inventory,
        common = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        ultraRare = 0,
        secret = 0,
        mythic = 0,
        totalValue = 0
    }
    
    for _, item in ipairs(playerData.inventory) do
        stats.totalValue = stats.totalValue + item.value
        
        if item.rarity == "Common" then stats.common = stats.common + 1
        elseif item.rarity == "Rare" then stats.rare = stats.rare + 1
        elseif item.rarity == "Epic" then stats.epic = stats.epic + 1
        elseif item.rarity == "Legendary" then stats.legendary = stats.legendary + 1
        elseif item.rarity == "Ultra-Rare" then stats.ultraRare = stats.ultraRare + 1
        elseif item.rarity == "Secret" then stats.secret = stats.secret + 1
        elseif item.rarity == "Mythic" then stats.mythic = stats.mythic + 1
        end
    end
    
    return stats
end

function InventorySystem:GetItemsByRarity(playerData, rarity)
    local items = {}
    
    for _, item in ipairs(playerData.inventory) do
        if item.rarity == rarity then
            table.insert(items, item)
        end
    end
    
    return items
end

-- ==================== AMÉLIORATIONS DU DÉPÔT ====================

local UpgradeCosts = {
    [1] = 500,
    [2] = 1000,
    [3] = 2000,
    [4] = 5000,
    [5] = 10000,
    [6] = 25000,
    [7] = 50000,
    [8] = 100000
}

function InventorySystem:UpgradeDepot(playerData)
    local nextLevel = playerData.depotLevel + 1
    local cost = UpgradeCosts[nextLevel]
    
    if not cost then
        return {
            success = false,
            message = "Niveau de dépôt maximum atteint"
        }
    end
    
    if playerData.coins < cost then
        return {
            success = false,
            message = "Vous n'avez pas assez de pièces (besoin: " .. cost .. ")"
        }
    end
    
    playerData.coins = playerData.coins - cost
    playerData.depotLevel = nextLevel
    playerData.depotMaxSlots = 20 + (nextLevel * 10)
    
    return {
        success = true,
        newLevel = nextLevel,
        newMaxSlots = playerData.depotMaxSlots,
        coinsRemaining = playerData.coins
    }
end

function InventorySystem:GetUpgradeCost(currentLevel)
    return UpgradeCosts[currentLevel + 1] or nil
end

function InventorySystem:GetMaxUpgradeLevel()
    return #UpgradeCosts
end

-- ==================== RECHERCHE ET TRI ====================

function InventorySystem:SearchItems(playerData, query)
    local results = {}
    local lowerQuery = query:lower()
    
    for _, item in ipairs(playerData.inventory) do
        if item.name:lower():find(lowerQuery) or item.rarity:lower():find(lowerQuery) then
            table.insert(results, item)
        end
    end
    
    return results
end

function InventorySystem:SortInventory(playerData, sortBy)
    local inventory = playerData.inventory
    
    if sortBy == "value" then
        table.sort(inventory, function(a, b) return a.value > b.value end)
    elseif sortBy == "rarity" then
        local rarityOrder = {Mythic = 1, Secret = 2, ["Ultra-Rare"] = 3, Legendary = 4, Epic = 5, Rare = 6, Common = 7}
        table.sort(inventory, function(a, b) 
            return (rarityOrder[a.rarity] or 8) < (rarityOrder[b.rarity] or 8)
        end)
    elseif sortBy == "newest" then
        table.sort(inventory, function(a, b) return a.obtainedAt > b.obtainedAt end)
    end
    
    return inventory
end

return InventorySystem
