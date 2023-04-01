AddCSLuaFile( "shared.lua" )
include("shared.lua")
include("duelist.lua")
-- Settings
STARTING_LP = 8000
STARTING_HAND_SIZE = 5
AddCSLuaFile( "shared.lua" )

-- Card list
CARD_LIST = {
    "Blue-Eyes White Dragon",
    "Dark Magician",
    "Red-Eyes B. Dragon",
    -- Add more cards here
}

-- Initialize the game
function duel_start(ply, command, args)
    if #player.GetAll() == 2 then
        for _, p in ipairs(player.GetAll()) do
            p.deck = {}
            p.hand = {}
            p.field = { monsterZones = {}, spellTrapZones = {} }
            p.lifePoints = STARTING_LP
        end

        initialize_decks()

        -- etc.
    end
end

function initialize_decks()
    for _, p in ipairs(player.GetAll()) do
        local deck = {}
        for i = 1, #CARD_LIST do
            table.insert(deck, CARD_LIST[i])
        end
        table.Shuffle(deck)
        p:SetNWVar("deck", deck)
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

function duel_start(ply, command, args)
    local players = player.GetAll()

    if #players == 2 then
        for _, p in ipairs(players) do
            p:SetNWVarProxy("deck", {})
            p:SetNWVarProxy("hand", {})
            p:SetNWVarProxy("field", { monsterZones = {}, spellTrapZones = {} })
            p:SetNWVarProxy("lifePoints", STARTING_LP)
        end
util.AddNetworkString("StartDuel")
        net.Start("StartDuel")
        net.WriteTable(players)
        net.Broadcast()
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
local Duelist = {}

function Duelist:shuffleDeck()
    math.randomseed(os.time())
    for i = #self.deck, 2, -1 do
        local j = math.random(i)
        self.deck[i], self.deck[j] = self.deck[j], self.deck[i]
    end
end