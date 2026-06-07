# 🎮 Empire des Conteneurs - Jeu Roblox Complet

Bienvenue dans **Empire des Conteneurs**, un jeu Roblox addictif de collection et d'échange d'objets!

## 🚀 Installation Rapide (2 minutes)

### Méthode 1: Copy-Paste dans Roblox Studio (⭐ Recommandé)

1. **Ouvrez Roblox Studio**
2. **File → New → Baseplate**
3. **Allez dans ServerScriptService** (dans l'explorateur à gauche)
4. **Insert → Script**
5. **Copiez tout le contenu de [`roblox-setup.lua`](roblox-setup.lua)**
6. **Collez-le dans le script vide**
7. **Appuyez sur ▶️ PLAY**

### Méthode 2: Télécharger et ouvrir le fichier

```bash
git clone https://github.com/reaubourgflorian0-oss/roblox-container-empire.git
cd roblox-container-empire
# Ouvrez roblox-setup.lua avec votre éditeur préféré
# Copiez-collez dans Roblox Studio
```

---

## 🎯 Fonctionnalités

### 🎁 Système de Conteneurs
- **Conteneur Commun** (50 🪙) - Objets de base
- **Conteneur Rare** (250 🪙) - Objets rares
- **Conteneur Épique** (1000 🪙) - Objets épiques
- **Conteneur Légendaire** (5000 🪙) - Objets ultra-rares

### 💰 Système Économique
- Gagnez des pièces en ouvrant des conteneurs
- Vendez vos objets pour gagner de l'argent
- Améliorez votre dépôt pour plus d'espace

### 📦 Inventaire
- Jusqu'à 20 emplacements de base
- Améliorez votre dépôt pour plus d'espace
- Collectez des objets rares et légendaires

### 👥 Futur: Système d'Échange
- Échangez avec d'autres joueurs
- Complétez des collections
- Débloquez des récompenses spéciales

---

## 📊 Distribution de Rareté

```
🪨 Conteneur Commun:
   - 40% Commun
   - 35% Rare
   - 20% Épique
   - 5% Légendaire

💎 Conteneur Rare:
   - 20% Commun
   - 40% Rare
   - 30% Épique
   - 10% Légendaire

👑 Conteneur Épique:
   - 10% Rare
   - 50% Épique
   - 40% Légendaire

👑 Conteneur Légendaire:
   - 5% Épique
   - 50% Légendaire
   - 45% Rare
```

---

## 🎮 Guide de Jeu

### Pour Débuter
1. **Vous commencez avec 500 pièces**
2. **Ouvrez des conteneurs Communs (50 pièces)**
3. **Collectez des objets rares**
4. **Vendez-les pour gagner de l'argent**

### Progression Recommandée
- **Jours 1-3**: Ouvrez des conteneurs communs
- **Jour 4**: Déverrouillez le conteneur Rare
- **Semaine 2**: Essayez le conteneur Épique
- **Semaine 3**: Visez le conteneur Légendaire

---

## 💾 Sauvegarde de Données

Vos données sont sauvegardées automatiquement :
- ✅ Sauvegarde toutes les 60 secondes
- ✅ DataStore Roblox utilisé
- ✅ Progression persistante

---

## 📁 Structure du Projet

```
roblox-container-empire/
├── roblox-setup.lua          # 🎮 Code principal complet
├── SETUP.sh                  # 📋 Script d'installation
├── README.md                 # 📖 Ce fichier
├── src/
│   ├── game/
│   │   ├── MainGame.lua
│   │   ├── ContainerSystem.lua
│   │   ├── InventorySystem.lua
│   │   ├── TradingSystem.lua
│   │   ├── DepotSystem.lua
│   │   └── EventSystem.lua
│   ├── ui/
│   │   ├── MainUI.lua
│   │   └── InventoryUI.lua
│   ├── data/
│   │   └── ItemDatabase.lua
│   └── monetization/
│       └── [Futur]
├── README.md
├── GAMEPLAY.md
└── DEV_GUIDE.md
```

---

## 🛠️ Personnalisation

### Modifier les Coûts des Conteneurs
Dans `roblox-setup.lua`, trouvez:
```lua
local ContainerTypes = {
    Common = {cost = 50, color = Color3.fromRGB(100, 100, 100)},
    Rare = {cost = 250, color = Color3.fromRGB(100, 149, 237)},
    -- ...
}
```

### Ajouter des Objets
Dans `roblox-setup.lua`, modifiez `ItemDatabase`:
```lua
Common = {
    {name = "Votre Objet", value = 10},
    -- ...
}
```

### Modifier les Probabilités
Changez `RarityDistribution`:
```lua
Common = {
    Common = 40,  -- Augmentez/diminuez les %
    Rare = 35,
    -- ...
}
```

---

## 📚 Documentation

- **[GAMEPLAY.md](GAMEPLAY.md)** - Guide complet du gameplay
- **[DEV_GUIDE.md](DEV_GUIDE.md)** - Guide technique pour développeurs

---

## 🐛 Troubleshooting

### Le jeu ne démarre pas
- ✅ Assurez-vous d'avoir copié **TOUT** le code
- ✅ Vérifiez que le script est dans **ServerScriptService**
- ✅ Vérifiez la console pour les erreurs (View > Output)

### Les données ne se sauvegardent pas
- ✅ Vérifiez que le jeu est **publié** (non local)
- ✅ Vérifiez que DataStore est activé dans Game Settings

### Interface UI ne s'affiche pas
- ✅ Vérifiez que PlayerGui existe (attendu automatiquement)
- ✅ Attendez quelques secondes après le spawn

---

## 🚀 Prochaines Étapes

- [ ] Système d'échange entre joueurs
- [ ] Événements hebdomadaires
- [ ] Machines automatiques
- [ ] Système de monétisation (VIP)
- [ ] Animaux de compagnie
- [ ] Cosmétiques
- [ ] Tableau de classement

---

## 📞 Support

Des problèmes? Consultez:
- [Issues GitHub](https://github.com/reaubourgflorian0-oss/roblox-container-empire/issues)
- [Discussions GitHub](https://github.com/reaubourgflorian0-oss/roblox-container-empire/discussions)

---

## 📜 Licence

Ce projet est open-source. Librement modifiable et utilisable!

---

## 🎉 Bon Jeu!

**Empire des Conteneurs** v1.0

Créé avec ❤️ pour la communauté Roblox

👉 [Lien GitHub](https://github.com/reaubourgflorian0-oss/roblox-container-empire)
