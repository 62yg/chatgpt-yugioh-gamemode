-- Yugioh gamemode shared code
AddCSLuaFile( "shared.lua" )

-- Define card object
Card = {}
function Card:new(name, type, attack, defense, effect)
    local card = {
        name = name,
        type = type,
        attack = attack,
        defense = defense,
        effect = effect
    }
    setmetatable(card, self)
    self.__index = self
    return card
end

-- Define player object
Player = {}
function Player:new(name, lp, deck, hand, graveyard)
    local player = {
        name = name,
        lp = lp,
        deck = deck,
        hand = hand,
        graveyard = graveyard
    }
    setmetatable(player, self)
    self.__index = self
    return player
end

-- Define duel object
Duel = {}
function Duel:new(player1, player2, turn)
    local duel = {
        player1 = player1,
        player2 = player2,
        turn = turn
    }
    setmetatable(duel, self)
    self.__index = self
    return duel
end

-- Define global Yugioh object with game state
Yugioh = {}
function Yugioh.newPlayer(name, lp, deck, hand, graveyard)
    return Player:new(name, lp, deck, hand or {}, graveyard or {})
end

function Yugioh.newDuel(player1, player2)
    return Duel:new(player1, player2, player1)
end

function Yugioh.drawCard(player)
    if #player.deck == 0 then
        player.lp = 0
        return nil
    end
    local card = table.remove(player.deck, 1)
    table.insert(player.hand, card)
    return card
end

-- Define some example cards
Card.Example1 = Card:new("Example 1", "Monster", 1000, 2000, nil)
Card.Example2 = Card:new("Example 2", "Spell", nil, nil, "Draw 2 cards.")


-- Yugioh gamemode shared code

-- Define Yugioh table
Yugioh = {}

-- Define function to create a new player
function Yugioh.newPlayer(name, lifePoints, deck)
    local player = {
        name = name,
        lifePoints = lifePoints,
        deck = deck,
        hand = {}
    }
    return player
end

-- Define table to store player data
Yugioh.players = {}

-- Define table to store player panels
Yugioh.playerPanels = {}

-- Define function to start a duel
function Yugioh.startDuel()
    -- Check if there are two active players in the server
    local activePlayers = {}
    for _, ply in ipairs(player.GetAll()) do
        if Yugioh.players[ply:Name()] then
            table.insert(activePlayers, ply)
        end
    end
    if #activePlayers == 2 then
        -- TODO: Implement function to start a duel
    else
        print("Cannot start duel: need exactly 2 active players")
    end
end

local Duelist = {}

function Duelist:drawCard()
    if #self.deck == 0 then
        return
    end

    local card = table.remove(self.deck, 1)
    table.insert(self.hand, card)
end