-- Empire des Conteneurs - Container System
-- Gère l'ouverture des conteneurs et la génération des objets

local ContainerSystem = {}

-- ==================== CONFIGURATION DES CONTENEURS ====================

local ContainerTypes = {
    Common = {
        name = "Conteneur Commun",
        cost = 50,
        color = Color3.fromRGB(100, 100, 100),
        rarities = {
            {name = "Common", weight = 40, color = Color3.fromRGB(169, 169, 169)},
            {name = "Rare", weight = 35, color = Color3.fromRGB(100, 149, 237)},
            {name = "Epic", weight = 20, color = Color3.fromRGB(138, 43, 226)},
            {name = "Legendary", weight = 5, color = Color3.fromRGB(255, 215, 0)}
        }
    },
    
    Rare = {
        name = "Conteneur Rare",
        cost = 250,
        color = Color3.fromRGB(100, 149, 237),
        rarities = {
            {name = "Common", weight = 20, color = Color3.fromRGB(169, 169, 169)},
            {name = "Rare", weight = 40, color = Color3.fromRGB(100, 149, 237)},
            {name = "Epic", weight = 30, color = Color3.fromRGB(138, 43, 226)},
            {name = "Legendary", weight = 8, color = Color3.fromRGB(255, 215, 0)},
            {name = "Ultra-Rare", weight = 2, color = Color3.fromRGB(255, 20, 147)}
        }
    },
    
    Epic = {
        name = "Conteneur Épique",
        cost = 1000,
        color = Color3.fromRGB(138, 43, 226),
        rarities = {
            {name = "Rare", weight = 10, color = Color3.fromRGB(100, 149, 237)},
            {name = "Epic", weight = 50, color = Color3.fromRGB(138, 43, 226)},
            {name = "Legendary", weight = 30, color = Color3.fromRGB(255, 215, 0)},
            {name = "Ultra-Rare", weight = 10, color = Color3.fromRGB(255, 20, 147)}
        }
    },
    
    Legendary = {
        name = "Conteneur Légendaire",
        cost = 5000,
        color = Color3.fromRGB(255, 215, 0),
        rarities = {
            {name = "Epic", weight = 5, color = Color3.fromRGB(138, 43, 226)},
            {name = "Legendary", weight = 50, color = Color3.fromRGB(255, 215, 0)},
            {name = "Ultra-Rare", weight = 40, color = Color3.fromRGB(255, 20, 147)},
            {name = "Secret", weight = 5, color = Color3.fromRGB(0, 255, 127)}
        }
    },
    
    UltraRare = {
        name = "Conteneur Ultra-Rare",
        cost = 25000,
        color = Color3.fromRGB(255, 20, 147),
        rarities = {
            {name = "Legendary", weight = 30, color = Color3.fromRGB(255, 215, 0)},
            {name = "Ultra-Rare", weight = 50, color = Color3.fromRGB(255, 20, 147)},
            {name = "Secret", weight = 15, color = Color3.fromRGB(0, 255, 127)},
            {name = "Mythic", weight = 5, color = Color3.fromRGB(255, 0, 255)}
        }
    }
}

-- ==================== BASE DE DONNÉES D'OBJETS ====================

local ItemDatabase = {
    Common = {
        {name = "Pièce d'Argent", value = 10},
        {name = "Livre Usé", value = 15},
        {name = "Clé Rouillée", value = 12},
        {name = "Morceau de Verre", value = 8},
        {name = "Balle de Tennis", value = 10}
    },
    
    Rare = {
        {name = "Rubis Bleu", value = 75},
        {name = "Baguette de Magique", value = 100},
        {name = "Couronne d'Or", value = 120},
        {name = "Étoile Cristalline", value = 90},
        {name = "Médaille d'Honneur", value = 85}
    },
    
    Epic = {
        {name = "Épée du Chevalier", value = 400},
        {name = "Anneau de Pouvoir", value = 500},
        {name = "Grimoire Ancien", value = 450},
        {name = "Coffre au Trésor", value = 550},
        {name = "Artefact Mystique", value = 480}
    },
    
    Legendary = {
        {name = "Dragon Doré", value = 2000},
        {name = "Couronne de l'Immortalité", value = 2500},
        {name = "Sceptre des Dieux", value = 2200},
        {name = "Cristal Éternel", value = 2100},
        {name = "Pierre de l'Infini", value = 2300}
    },
    
    ["Ultra-Rare"] = {
        {name = "Phénix Renaissant", value = 10000},
        {name = "Couronne de l'Univers", value = 12000},
        {name = "Clé du Destin", value = 11000},
        {name = "Joyau de la Création", value = 10500},
        {name = "Relique Dimensionnelle", value = 11500}
    },
    
    Secret = {
        {name = "Œuf de Dragon", value = 50000},
        {name = "Lame Légendaire", value = 45000},
        {name = "Portail Interdimensionnel", value = 55000}
    },
    
    Mythic = {
        {name = "Créateur de Mondes", value = 100000},
        {name = "Essence Primordiale", value = 120000},
        {name = "Clé de l'Omniscience", value = 110000}
    }
}

-- ==================== SYSTÈME D'OUVERTURE ====================

function ContainerSystem:OpenContainer(playerData, containerType)
    -- Vérifier le type
    if not ContainerTypes[containerType] then
        return {
            success = false,
            message = "Type de conteneur invalide"
        }
    end
    
    local container = ContainerTypes[containerType]
    
    -- Vérifier si le joueur a assez de pièces
    if playerData.coins < container.cost then
        return {
            success = false,
            message = "Vous n'avez pas assez de pièces (besoin: " .. container.cost .. ")"
        }
    end
    
    -- Déduire les pièces
    playerData.coins = playerData.coins - container.cost
    
    -- Tirer un objet
    local item = self:RollItem(container.rarities)
    
    -- Vérifier l'espace d'inventaire
    if #playerData.inventory >= playerData.depotMaxSlots then
        -- Si pas de place, retourner l'argent et le message d'erreur
        playerData.coins = playerData.coins + container.cost
        return {
            success = false,
            message = "Votre dépôt est plein!"
        }
    end
    
    -- Ajouter à l'inventaire
    table.insert(playerData.inventory, {
        id = math.random(100000, 999999),
        name = item.name,
        rarity = item.rarity,
        value = item.value,
        obtainedAt = os.time()
    })
    
    return {
        success = true,
        message = "Conteneur ouvert avec succès!",
        item = item,
        coinsRemaining = playerData.coins,
        inventoryCount = #playerData.inventory
    }
end

-- ==================== SYSTÈME DE ROULETTE ====================

function ContainerSystem:RollItem(rarities)
    -- Calculer le poids total
    local totalWeight = 0
    for _, rarity in ipairs(rarities) do
        totalWeight = totalWeight + rarity.weight
    end
    
    -- Tirer un nombre aléatoire
    local roll = math.random() * totalWeight
    local current = 0
    
    -- Déterminer la rareté
    local selectedRarity = nil
    for _, rarity in ipairs(rarities) do
        current = current + rarity.weight
        if roll <= current then
            selectedRarity = rarity.name
            break
        end
    end
    
    -- Tirer un objet de cette rareté
    local items = ItemDatabase[selectedRarity] or ItemDatabase.Common
    local randomItem = items[math.random(1, #items)]
    
    return {
        name = randomItem.name,
        rarity = selectedRarity,
        value = randomItem.value,
        color = self:GetRarityColor(selectedRarity)
    }
end

-- ==================== UTILITAIRES ====================

function ContainerSystem:GetRarityColor(rarity)
    local colors = {
        Common = Color3.fromRGB(169, 169, 169),
        Rare = Color3.fromRGB(100, 149, 237),
        Epic = Color3.fromRGB(138, 43, 226),
        Legendary = Color3.fromRGB(255, 215, 0),
        ["Ultra-Rare"] = Color3.fromRGB(255, 20, 147),
        Secret = Color3.fromRGB(0, 255, 127),
        Mythic = Color3.fromRGB(255, 0, 255)
    }
    return colors[rarity] or Color3.fromRGB(255, 255, 255)
end

function ContainerSystem:GetAllContainerTypes()
    return ContainerTypes
end

function ContainerSystem:GetContainerInfo(containerType)
    return ContainerTypes[containerType]
end

return ContainerSystem
