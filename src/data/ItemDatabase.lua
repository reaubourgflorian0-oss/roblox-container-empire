-- Empire des Conteneurs - Item Database
-- Base de données complète des objets

local ItemDatabase = {}

local Items = {
    Common = {
        {id = 1, name = "Pièce d'Argent", value = 10, description = "Une vieille pièce sans valeur"},
        {id = 2, name = "Livre Usé", value = 15, description = "Un livre déchiré et usé"},
        {id = 3, name = "Clé Rouillée", value = 12, description = "Une clé rongée par la rouille"},
        {id = 4, name = "Morceau de Verre", value = 8, description = "Un éclat de verre"},
        {id = 5, name = "Balle de Tennis", value = 10, description = "Une balle de tennis fatiguée"},
        {id = 6, name = "Bouton", value = 5, description = "Un simple bouton en bois"},
        {id = 7, name = "Coquille d'Escargot", value = 7, description = "Une coquille vide et fragile"},
        {id = 8, name = "Feuille Dorée", value = 9, description = "Une feuille d'or ancien"},
        {id = 9, name = "Monnaie Ancienne", value = 11, description = "Une monnaie d'époque médiévale"},
        {id = 10, name = "Chaîne Cassée", value = 13, description = "Une chaîne en fer rouillée"}
    },
    
    Rare = {
        {id = 101, name = "Rubis Bleu", value = 75, description = "Un magnifique rubis bleu scintillant"},
        {id = 102, name = "Baguette Magique", value = 100, description = "Une baguette magique ancienne"},
        {id = 103, name = "Couronne d'Or", value = 120, description = "Une couronne royale en or pur"},
        {id = 104, name = "Étoile Cristalline", value = 90, description = "Une étoile de cristal luminescent"},
        {id = 105, name = "Médaille d'Honneur", value = 85, description = "Une médaille militaire ancienne"},
        {id = 106, name = "Cristal Violet", value = 95, description = "Un cristal améthyste magnifique"},
        {id = 107, name = "Pendentif Argent", value = 80, description = "Un pendentif en argent ciselé"},
        {id = 108, name = "Perle Noire", value = 110, description = "Une perle noire rare des abysses"},
        {id = 109, name = "Émeraude Verte", value = 105, description = "Une émeraude de couleur vive"},
        {id = 110, name = "Scarabée d'Or", value = 88, description = "Un scarabée antique en or"},
        {id = 111, name = "Saphir Bleu", value = 100, description = "Un saphir d'une teinte royale"}
    },
    
    Epic = {
        {id = 201, name = "Épée du Chevalier", value = 400, description = "L'épée légendaire d'un chevalier"},
        {id = 202, name = "Anneau de Pouvoir", value = 500, description = "Un anneau conférant des pouvoirs"},
        {id = 203, name = "Grimoire Ancien", value = 450, description = "Un livre de magie ancienne"},
        {id = 204, name = "Coffre au Trésor", value = 550, description = "Un coffre rempli de richesses"},
        {id = 205, name = "Artefact Mystique", value = 480, description = "Un objet d'une ancienne civilisation"},
        {id = 206, name = "Couronne de Cristal", value = 520, description = "Une couronne scintillante"},
        {id = 207, name = "Baguette de Feu", value = 420, description = "Une baguette contrôlant le feu"},
        {id = 208, name = "Bouclier Magique", value = 470, description = "Un bouclier indestructible"},
        {id = 209, name = "Lyre Divine", value = 440, description = "Une lyre des dieux de la musique"},
        {id = 210, name = "Calice Sacré", value = 490, description = "Le calice mystique de la vie éternelle"}
    },
    
    Legendary = {
        {id = 301, name = "Dragon Doré", value = 2000, description = "Une statuette de dragon en or massif"},
        {id = 302, name = "Couronne de l'Immortalité", value = 2500, description = "La couronne de l'immortalité légendaire"},
        {id = 303, name = "Sceptre des Dieux", value = 2200, description = "Le sceptre des anciens dieux"},
        {id = 304, name = "Cristal Éternel", value = 2100, description = "Un cristal intemporel et éternel"},
        {id = 305, name = "Pierre de l'Infini", value = 2300, description = "La pierre de la sagesse infinie"},
        {id = 306, name = "Armure du Titan", value = 2400, description = "L'armure d'un titan oubliée"},
        {id = 307, name = "Anneau Suprême", value = 2350, description = "L'anneau suprême du pouvoir absolu"},
        {id = 308, name = "Trident Océanique", value = 2200, description = "Le trident du roi des mers"},
        {id = 309, name = "Couronne de Feu", value = 2150, description = "La couronne des rois du feu"},
        {id = 310, name = "Amulet de Sagesse", value = 2050, description = "L'amulette de la sagesse ancienne"}
    },
    
    ["Ultra-Rare"] = {
        {id = 401, name = "Phénix Renaissant", value = 10000, description = "Une représentation du phénix mythique"},
        {id = 402, name = "Couronne de l'Univers", value = 12000, description = "La couronne maîtresse de l'univers"},
        {id = 403, name = "Clé du Destin", value = 11000, description = "La clé qui contrôle le destin"},
        {id = 404, name = "Joyau de la Création", value = 10500, description = "Le joyau originel de la création"},
        {id = 405, name = "Relique Dimensionnelle", value = 11500, description = "Une relique entre les dimensions"},
        {id = 406, name = "Orbe Cosmique", value = 11200, description = "Une sphère contenant l'énergie cosmique"},
        {id = 407, name = "Larme d'Étoile", value = 10800, description = "La larme d'une étoile morte"},
        {id = 408, name = "Essence du Temps", value = 11800, description = "L'essence même du temps"},
        {id = 409, name = "Fragment de Lune", value = 10600, description = "Un fragment d'une ancienne lune"},
        {id = 410, name = "Cœur du Monde", value = 12300, description = "Le cœur battant du monde ancien"}
    },
    
    Secret = {
        {id = 501, name = "Œuf de Dragon", value = 50000, description = "Un œuf de dragon ancien et magique"},
        {id = 502, name = "Lame Légendaire", value = 45000, description = "L'épée légendaire des héros"},
        {id = 503, name = "Portail Interdimensionnel", value = 55000, description = "Un portail vers d'autres mondes"}
    },
    
    Mythic = {
        {id = 601, name = "Créateur de Mondes", value = 100000, description = "L'objet qui crée des mondes"},
        {id = 602, name = "Essence Primordiale", value = 120000, description = "L'essence de la création primordiale"},
        {id = 603, name = "Clé de l'Omniscience", value = 110000, description = "La clé de la connaissance absolue"}
    }
}

-- ==================== FONCTIONS ====================

function ItemDatabase:GetItem(rarity, itemName)
    if not Items[rarity] then return nil end
    
    for _, item in ipairs(Items[rarity]) do
        if item.name == itemName then
            return item
        end
    end
    
    return nil
end

function ItemDatabase:GetRandomItem(rarity)
    if not Items[rarity] or #Items[rarity] == 0 then
        return Items["Common"][math.random(1, #Items["Common"])]
    end
    
    return Items[rarity][math.random(1, #Items[rarity])]
end

function ItemDatabase:GetAllItems(rarity)
    return Items[rarity] or {}
end

function ItemDatabase:GetItemsByValue(rarity, minValue, maxValue)
    local results = {}
    
    if not Items[rarity] then return results end
    
    for _, item in ipairs(Items[rarity]) do
        if item.value >= minValue and item.value <= maxValue then
            table.insert(results, item)
        end
    end
    
    return results
end

function ItemDatabase:CountItems()
    local count = 0
    for _, rarityItems in pairs(Items) do
        count = count + #rarityItems
    end
    return count
end

function ItemDatabase:GetAllRarities()
    local rarities = {}
    for rarity, _ in pairs(Items) do
        table.insert(rarities, rarity)
    end
    return rarities
end

return ItemDatabase
