-- Settings
STARTING_LP = 8000
STARTING_HAND_SIZE = 5

-- Card list
CARD_LIST = {
    "Blue-Eyes White Dragon",
    "Dark Magician",
    "Red-Eyes B. Dragon",
    -- Add more cards here
}

-- Initialize the game
function game_start()
    initialize_decks()
    draw_starting_hands()
end

-- Initialize the players' decks
function initialize_decks()
    for _, p in ipairs(player.GetAll()) do
        local deck = {}
        for i = 1, #CARD_LIST do
            table.insert(deck, CARD_LIST[i])
        end
        table.Shuffle(deck)
        p:SetNWTable("deck", deck)
    end
end

-- Draw starting hands for both players
function draw_starting_hands()
    for _, p in ipairs(player.GetAll()) do
        local hand = {}
        for i = 1, STARTING_HAND_SIZE do
            table.insert(hand, table.remove(p:GetNWTable("deck"), 1))
        end
        p:SetNWTable("hand", hand)
    end
end

-- Start the duel
function duel_start(ply, command, args)
    if #player.GetAll() == 2 then
        for _, p in ipairs(player.GetAll()) do
            p:SetNWTable("deck", {})
            p:SetNWTable("hand", {})
            p:SetNWTable("field", { monsterZones = {}, spellTrapZones = {} })
            p:SetNWInt("lifePoints", STARTING_LP)
        end

        game_start()
    else
        ply:ChatPrint("There must be exactly two players in the game to start a duel.")
    end
end

-- Register the chat command
concommand.Add("duel_start", duel_start)

-- Load the card images
function load_card_images()
    for _, cardName in ipairs(CARD_LIST) do
        local cardImage = file.Read("materials/pictures/" .. cardName .. ".jpg", "GAME")
        if cardImage then
            resource.AddSingleFile("materials/pictures/" .. cardName .. ".jpg")
        else
            print("Failed to load image for card: " .. cardName)
        end
    end
end

-- Load the card images on startup
load_card_images()
