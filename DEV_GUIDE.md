# 🛠️ Guide de Développement - Empire des Conteneurs

## 📋 Environnement Setup

### Prérequis
- ✅ Roblox Studio (version récente)
- ✅ Lua 5.1+
- ✅ DataStore API activée
- ✅ RemoteEvents pour client-server

### Architecture

```
ServerScriptService/
├── GameManager (script principal)
├── ContainerSystem
├── InventorySystem
├── TradingSystem
├── DepotSystem
├── EventSystem
└── PlayerDataManager

StarterPlayer/StarterPlayerScripts/
├── LocalScript (UI main)
└── InputHandler

ReplicatedStorage/
├── Modules/ (modules partagés)
├── RemoteEvents/ (communication)
└── Constants.lua
```

---

## 🎮 Système Principal (GameManager)

### Initialisation

```lua
local GameManager = {}
local players = game:GetService("Players")
local dataStoreService = game:GetService("DataStoreService")

function GameManager:Init()
    print("[GameManager] Initialisation...")
    
    -- Charger les systèmes
    self:LoadContainerSystem()
    self:LoadInventorySystem()
    self:LoadTradingSystem()
    self:LoadDepotSystem()
    self:LoadEventSystem()
    
    -- Connexions de joueurs
    players.PlayerAdded:Connect(function(player)
        self:OnPlayerJoined(player)
    end)
    
    players.PlayerRemoving:Connect(function(player)
        self:OnPlayerLeft(player)
    end)
    
    print("[GameManager] Prêt !")
end

return GameManager
```

---

## 📦 Système de Conteneurs

### Structure de Conteneur

```lua
local ContainerTypes = {
    Common = {
        cost = 50,
        rarities = {
            {name = "Common", weight = 40},
            {name = "Rare", weight = 35},
            {name = "Epic", weight = 20},
            {name = "Legendary", weight = 5}
        }
    },
    Rare = {
        cost = 250,
        rarities = {
            {name = "Common", weight = 20},
            {name = "Rare", weight = 40},
            {name = "Epic", weight = 30},
            {name = "Legendary", weight = 8},
            {name = "Ultra-Rare", weight = 2}
        }
    },
    -- ... autres types
}

local function OpenContainer(player, containerType)
    local playerData = GetPlayerData(player)
    local container = ContainerTypes[containerType]
    
    if not container then
        return {success = false, message = "Type de conteneur invalide"}
    end
    
    if playerData.coins < container.cost then
        return {success = false, message = "Pas assez de pièces"}
    end
    
    -- Déduire les pièces
    playerData.coins -= container.cost
    
    -- Tirer un objet aléatoire
    local item = RollItem(container.rarities)
    
    -- Ajouter à l'inventaire
    AddItemToInventory(player, item)
    
    return {success = true, item = item, coinsleft = playerData.coins}
end
```

---

## 💾 Gestion des Données Joueur

### Structure PlayerData

```lua
local PlayerDataTemplate = {
    userId = 0,
    coins = 500,          -- Monnaie de jeu
    level = 1,
    experience = 0,
    depotLevel = 1,       -- Niveau du dépôt (capacité)
    depotMaxSlots = 20,   -- Slots d'inventaire
    machines = {},         -- Machines automatiques
    inventory = {},        -- Objets collectés
    trades = {},           -- Historique d'échanges
    lastDailyBonus = 0,   -- Timestamp dernier bonus
    joinDate = 0,
    playtime = 0
}

-- Charger les données
local function LoadPlayerData(player)
    local dataStore = dataStoreService:GetDataStore("PlayerData")
    local success, data = pcall(function()
        return dataStore:GetAsync("Player_" .. player.UserId)
    end)
    
    if success and data then
        return data
    else
        return CopyTable(PlayerDataTemplate)
    end
end

-- Sauvegarder les données
local function SavePlayerData(player, data)
    local dataStore = dataStoreService:GetDataStore("PlayerData")
    pcall(function()
        dataStore:SetAsync("Player_" .. player.UserId, data)
    end)
end
```

---

## 🤝 Système d'Échange

### Flux d'Échange

```lua
local TradeManager = {}
local activeTrades = {}

function TradeManager:InitiateTrade(player1, player2, items1, items2)
    local tradeId = GenerateUUID()
    
    activeTrades[tradeId] = {
        player1 = player1,
        player2 = player2,
        items1 = items1,
        items2 = items2,
        acceptedBy = {},
        createdAt = tick(),
        expiresAt = tick() + 300  -- 5 minutes
    }
    
    return tradeId
end

function TradeManager:AcceptTrade(tradeId, playerAccepting)
    local trade = activeTrades[tradeId]
    
    if not trade then
        return {success = false, message = "Trade inexistant"}
    end
    
    if tick() > trade.expiresAt then
        activeTrades[tradeId] = nil
        return {success = false, message = "Trade expiré"}
    end
    
    table.insert(trade.acceptedBy, playerAccepting)
    
    if #trade.acceptedBy == 2 then
        -- Exécuter le trade
        ExecuteTrade(trade)
        activeTrades[tradeId] = nil
    end
    
    return {success = true}
end
```

---

## 🎁 Système d'Événements

### Structure d'Événement

```lua
local EventSystem = {}

local CurrentEvent = {
    type = "hunt",           -- hunt, collection, double, free
    startTime = 0,
    endTime = 0,
    multiplier = 1,
    targetItems = {},
    reward = {}
}

function EventSystem:StartEvent(eventType, duration)
    CurrentEvent.type = eventType
    CurrentEvent.startTime = tick()
    CurrentEvent.endTime = tick() + duration
    
    if eventType == "double" then
        CurrentEvent.multiplier = 2
    elseif eventType == "hunt" then
        CurrentEvent.targetItems = GenerateHuntTargets()
    end
    
    print("[EventSystem] Événement lancé: " .. eventType)
end

function EventSystem:GetActiveEvent()
    if tick() > CurrentEvent.endTime then
        CurrentEvent = nil
        return nil
    end
    return CurrentEvent
end
```

---

## 🤖 Machines Automatiques

### Système de Génération Passive

```lua
local MachineTypes = {
    Basic = {cost = 2000, generationRate = 5},      -- 5 coins/min
    Advanced = {cost = 10000, generationRate = 25}, -- 25 coins/min
    Premium = {cost = 50000, generationRate = 100}  -- 100 coins/min
}

local function UpdateMachines(player)
    local playerData = GetPlayerData(player)
    local now = tick()
    
    for _, machine in ipairs(playerData.machines) do
        local timePassed = (now - machine.lastUpdated) / 60  -- en minutes
        machine.lastUpdated = now
        
        local machineType = MachineTypes[machine.type]
        local coinsGenerated = machineType.generationRate * timePassed
        
        playerData.coins += coinsGenerated
    end
end
```

---

## 📡 Communication Client-Server

### RemoteEvents

```lua
-- ServerScript
local openContainerEvent = Instance.new("RemoteEvent")
openContainerEvent.Name = "OpenContainer"
openContainerEvent.Parent = game:GetService("ReplicatedStorage")

openContainerEvent.OnServerEvent:Connect(function(player, containerType)
    local result = OpenContainer(player, containerType)
    openContainerEvent:FireClient(player, result)
end)

-- LocalScript (Client)
local openContainerEvent = game:GetService("ReplicatedStorage"):WaitForChild("OpenContainer")

local function RequestOpenContainer(containerType)
    openContainerEvent:FireServer(containerType)
end

openContainerEvent.OnClientEvent:Connect(function(result)
    if result.success then
        print("Obtenu: " .. result.item.name)
        UpdateUI(result)
    else
        print("Erreur: " .. result.message)
    end
end)
```

---

## 🎨 Système d'Interface Utilisateur

### Structure UI

```lua
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GameUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Panneau d'accueil
local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 400, 0, 300)
MainPanel.Position = UDim2.new(0.5, -200, 0.5, -150)
MainPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainPanel.Parent = ScreenGui

-- Affichage pièces
local CoinsLabel = Instance.new("TextLabel")
CoinsLabel.Name = "CoinsLabel"
CoinsLabel.Size = UDim2.new(1, 0, 0, 50)
CoinsLabel.Text = "Pièces: " .. playerData.coins
CoinsLabel.Parent = MainPanel

-- Bouton ouvrir conteneur
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Text = "Ouvrir Conteneur (+50 💰)"
OpenButton.Size = UDim2.new(1, 0, 0, 50)
OpenButton.Parent = MainPanel

OpenButton.MouseButton1Click:Connect(function()
    RequestOpenContainer("Common")
end)
```

---

## 🧪 Déboguer et Tester

### Console de Débogage

```lua
-- Commandes de test
local DebugCommands = {
    addCoins = function(amount) playerData.coins += amount end,
    openContainer = function() OpenContainer(player, "Rare") end,
    addItem = function(itemName) AddItemToInventory(player, itemName) end,
    resetData = function() playerData = CopyTable(PlayerDataTemplate) end
}
```

---

## 📊 Checklist de Déploiement

- [ ] Tests des conteneurs
- [ ] Tests du système d'inventaire
- [ ] Tests des échanges
- [ ] Tests de sauvegarde de données
- [ ] Tests de performance avec 100+ joueurs
- [ ] Optimisation des RemoteEvents
- [ ] Interface utilisateur complète
- [ ] Système de monétisation testé
- [ ] Événements programmés
- [ ] Modération des échanges

---

**Bon développement ! 🚀**
