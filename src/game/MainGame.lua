-- Empire des Conteneurs - Main Game Manager
-- Script Principal du Jeu

local GameManager = {}
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

-- Configuration
local CONFIG = {
    SAVE_INTERVAL = 60,  -- Sauvegarder toutes les 60 secondes
    MACHINE_UPDATE_INTERVAL = 10,  -- Mettre à jour les machines toutes les 10 secondes
    DAILY_BONUS_AMOUNT = 50,
    STARTING_COINS = 500,
    STARTING_DEPOT_SLOTS = 20
}

-- Stores
local playerData = {}
local playerMachines = {}

-- ==================== INITIALISATION ====================

function GameManager:Initialize()
    print("[GameManager] Initialisation du jeu...")
    
    -- Charger les modules
    self:LoadSystems()
    
    -- Connexions de joueurs
    Players.PlayerAdded:Connect(function(player)
        self:OnPlayerJoined(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        self:OnPlayerLeft(player)
    end)
    
    -- Boucle de sauvegarde
    self:StartAutoSave()
    
    -- Boucle de mise à jour des machines
    self:StartMachineUpdate()
    
    print("[GameManager] ✅ Jeu initialisé avec succès")
end

function GameManager:LoadSystems()
    print("[GameManager] Chargement des systèmes...")
    
    -- Les systèmes seront chargés ici
    -- ContainerSystem, InventorySystem, etc.
    
    print("[GameManager] ✅ Systèmes chargés")
end

-- ==================== GESTION DES JOUEURS ====================

function GameManager:OnPlayerJoined(player)
    print("[GameManager] " .. player.Name .. " a rejoint le jeu")
    
    -- Charger les données
    playerData[player.UserId] = self:LoadPlayerData(player)
    playerMachines[player.UserId] = {}
    
    -- Créer RemoteEvents pour ce joueur
    self:CreateRemoteEvents(player)
    
    -- Bonus quotidien
    if self:CanClaimDailyBonus(player) then
        self:GiveDailyBonus(player)
    end
    
    -- Interface
    self:CreatePlayerUI(player)
end

function GameManager:OnPlayerLeft(player)
    print("[GameManager] " .. player.Name .. " a quitté le jeu")
    
    -- Sauvegarder et nettoyer
    self:SavePlayerData(player)
    playerData[player.UserId] = nil
    playerMachines[player.UserId] = nil
end

-- ==================== GESTION DES DONNÉES ====================

local PlayerDataTemplate = {
    userId = 0,
    coins = CONFIG.STARTING_COINS,
    level = 1,
    experience = 0,
    depotLevel = 1,
    depotMaxSlots = CONFIG.STARTING_DEPOT_SLOTS,
    inventory = {},
    machines = {},
    trades = {},
    lastDailyBonus = 0,
    joinDate = 0,
    playtime = 0
}

function GameManager:LoadPlayerData(player)
    local dataStore = DataStoreService:GetDataStore("PlayerData")
    local success, data = pcall(function()
        return dataStore:GetAsync("Player_" .. player.UserId)
    end)
    
    if success and data then
        data.userId = player.UserId
        return data
    else
        -- Créer nouvelles données
        local newData = {
            userId = player.UserId,
            coins = CONFIG.STARTING_COINS,
            level = 1,
            experience = 0,
            depotLevel = 1,
            depotMaxSlots = CONFIG.STARTING_DEPOT_SLOTS,
            inventory = {},
            machines = {},
            trades = {},
            lastDailyBonus = 0,
            joinDate = os.time(),
            playtime = 0
        }
        return newData
    end
end

function GameManager:SavePlayerData(player)
    local data = playerData[player.UserId]
    if not data then return end
    
    local dataStore = DataStoreService:GetDataStore("PlayerData")
    local success, err = pcall(function()
        dataStore:SetAsync("Player_" .. player.UserId, data)
    end)
    
    if success then
        print("[GameManager] ✅ Données sauvegardées pour " .. player.Name)
    else
        print("[GameManager] ❌ Erreur de sauvegarde pour " .. player.Name .. ": " .. tostring(err))
    end
end

-- ==================== AUTO-SAVE ====================

function GameManager:StartAutoSave()
    spawn(function()
        while true do
            wait(CONFIG.SAVE_INTERVAL)
            
            for _, player in ipairs(Players:GetPlayers()) do
                self:SavePlayerData(player)
            end
        end
    end)
end

-- ==================== MACHINES AUTOMATIQUES ====================

function GameManager:StartMachineUpdate()
    spawn(function()
        while true do
            wait(CONFIG.MACHINE_UPDATE_INTERVAL)
            
            for _, player in ipairs(Players:GetPlayers()) do
                self:UpdatePlayerMachines(player)
            end
        end
    end)
end

function GameManager:UpdatePlayerMachines(player)
    local data = playerData[player.UserId]
    if not data then return end
    
    local now = tick()
    
    for _, machine in ipairs(data.machines) do
        local timePassed = (now - (machine.lastUpdated or 0)) / 60  -- en minutes
        machine.lastUpdated = now
        
        -- Génération selon le type
        local generationRate = 0
        if machine.type == "Basic" then generationRate = 5
        elseif machine.type == "Advanced" then generationRate = 25
        elseif machine.type == "Premium" then generationRate = 100
        end
        
        local coinsGenerated = generationRate * timePassed
        data.coins = data.coins + coinsGenerated
    end
end

-- ==================== BONUS QUOTIDIEN ====================

function GameManager:CanClaimDailyBonus(player)
    local data = playerData[player.UserId]
    local now = os.time()
    
    -- Vérifier si c'est un nouveau jour
    return (now - data.lastDailyBonus) > 86400  -- 24 heures
end

function GameManager:GiveDailyBonus(player)
    local data = playerData[player.UserId]
    data.coins = data.coins + CONFIG.DAILY_BONUS_AMOUNT
    data.lastDailyBonus = os.time()
    
    print("[GameManager] 🎁 Bonus quotidien donné à " .. player.Name)
end

-- ==================== REMOTE EVENTS ====================

function GameManager:CreateRemoteEvents(player)
    -- Ces RemoteEvents seront utilisés pour la communication client-server
    -- (À implémenter dans des scripts séparés)
end

-- ==================== INTERFACE UTILISATEUR ====================

function GameManager:CreatePlayerUI(player)
    -- L'interface sera créée dans des scripts LocalScript séparés
end

-- ==================== FONCTION PRINCIPALE ====================

if RunService:IsServer() then
    GameManager:Initialize()
end

return GameManager
