-- card_definitions.lua (shared)
include("card_library.lua")

local function createMonster(id, name, img, atk, def)
    local effect = {atk = atk, def = def}
    return CardLibrary:createCard(id, name, img, "monster", effect)
end

local function createSpell(id, name, img, effect)
    return CardLibrary:createCard(id, name, img, "spell", effect)
end

local function createTrap(id, name, img, effect)
    return CardLibrary:createCard(id, name, img, "trap", effect)
end

-- Example cards
CardLibrary["dark_magician"] = createMonster(1, "Dark Magician", "dark_magician.jpg", 2500, 2100)
CardLibrary["blue_eyes"] = createMonster(2, "Blue Eyes White Dragon", "blue_eyes.jpg", 3000, 2500)
CardLibrary["monster_reborn"] = createSpell(3, "Monster Reborn", "monster_reborn.jpg", function() end)
CardLibrary["trap_hole"] = createTrap(4, "Trap Hole", "trap_hole.jpg", function() end)

