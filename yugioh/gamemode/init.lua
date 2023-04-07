-- init.lua

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("OpenDeckCreationMenu")


-- init.lua


local BasicCards = {
    { Name = "Blue-Eyes White Dragon", Attack = 3000, Defense = 2500, Type = "Monster" },
    { Name = "Card2", Attack = 1500, Defense = 1500, Type = "Monster" },
    { Name = "Card3", Attack = 2000, Defense = 2000, Type = "Monster" },
    { Name = "Card4", Type = "Spell", Effect = "Draw 1 card" },
    { Name = "Card5", Type = "Spell", Effect = "Increase ATK by 500" }
}

-- init.lua

function CreateBasicDeck(deckSize)
    local basicDeck = {}

    for i = 1, deckSize do
        local randomCardIndex = math.random(#BasicCards)
        table.insert(basicDeck, table.Copy(BasicCards[randomCardIndex]))
    end

    return basicDeck
end



function InitializeDuelData(ply)
    if ply:GetNW2Var("DuelData") == nil then
        ply:SetNW2Var("DuelData", { LifePoints = 8000, Deck = {}, Hand = {}, Field = {}, Graveyard = {} })
    end
end

-- init.lua

hook.Add("PlayerInitialSpawn", "InitializePlayer", function(ply)
    LoadPlayerDeck(ply)
    InitializeDuelData(ply)
    -- (other player initialization code here)
end)

hook.Add("PlayerDisconnected", "SaveDeckOnDisconnect", function(ply)
    SavePlayerDeck(ply)
end)


function BeginDuel(ply, cmd, args)
    local players = player.GetAll()

    if #players ~= 2 then
        ply:ChatPrint("This gamemode only supports 2 players.")
        return
    end

    local player1 = players[1]
    local player2 = players[2]

    -- Retrieve player decks from your desired storage method (e.g., database, file)
    local player1Deck = GetPlayerDeck(player1)
    local player2Deck = GetPlayerDeck(player2)

    if not player1Deck or not player2Deck then
        ply:ChatPrint("Both players must have a deck to start a duel.")
        return
    end

    -- Initialize duel data for both players
    ply:SetNW2Var("DuelData", duelData)





    -- Add logic to determine the first player, for example:
    local firstPlayer = math.random(2) == 1 and player1 or player2

    -- Start the first player's turn
    PerformTurn(firstPlayer)



    -- Add logic to draw starting hands and set up the game state
    -- You may need to create additional functions to manage game state,
    -- such as drawing cards, placing cards on the field, etc.
end

concommand.Add("begin_duel", BeginDuel)

concommand.Add("begin_duel", function()
    local player1, player2 = GetPlayersForDuel()
    if player1 and player2 then
        StartDuel(player1, player2)
    else
        print("Not enough players to start a duel.")
    end
end)


-- init.lua

util.AddNetworkString("CardDrawn")
util.AddNetworkString("CardPlayed")
util.AddNetworkString("CardMovedToGraveyard")

-- init.lua

function InitializeDeck(ply)
    local duelData = ply:GetNW2Var("DuelData")
    duelData.Deck = CreateBasicDeck() -- Assuming you have a CreateBasicDeck function
    ply:SetNW2Table("DuelData", duelData)
end

-- init.lua

function DrawCard(ply)
    local duelData = ply:GetNW2Var("DuelData")
    if not duelData then
        return
    end

    if #duelData.Deck > 0 then
        local cardID = table.remove(duelData.Deck, 1)
        table.insert(duelData.Hand, cardID)
        ply:SetNW2Var("DuelData", duelData)
        return cardID
    else
        return nil
    end
end


function MoveCardToGraveyard(ply, card)
    local duelData = ply:GetNW2Table("DuelData")
    table.RemoveByValue(duelData.Hand, card)
    table.insert(duelData.Graveyard, card)
    ply:SetNW2Table("DuelData", duelData)

    NotifyCardMovedToGraveyard(ply)
    net.Start("CardMovedToGraveyard")
    net.WriteEntity(ply)
    net.Broadcast()
end


-- init.lua

function UpdateLifePoints(ply, delta)
    local duelData = ply:GetNW2Table("DuelData")
    duelData.LifePoints = duelData.LifePoints + delta
    ply:SetNW2Table("DuelData", duelData)

    -- Notify players of life points update (implement this function if necessary)
    NotifyLifePointsUpdate(ply)
end


-- init.lua

function HandleCardAttack(attacker, defender, attackingCard, defendingCard)
    -- Calculate battle damage and update life points (assuming you have a CalculateBattleDamage function)
    local battleDamage = CalculateBattleDamage(attackingCard, defendingCard)
    UpdateLifePoints(defender, -battleDamage)

    -- Move cards to appropriate positions based on the outcome of the battle
    local attackerDuelData = attacker:GetNW2Table("DuelData")
    local defenderDuelData = defender:GetNW2Table("DuelData")

    -- Example: Move defending card to the graveyard if it was destroyed
    table.RemoveByValue(defenderDuelData.Field, defendingCard)
    table.insert(defenderDuelData.Graveyard, defendingCard)

    -- Save updated DuelData
    attacker:SetNW2Table("DuelData", attackerDuelData)
    defender:SetNW2Table("DuelData", defenderDuelData)

    -- Notify players of the outcome (implement this function if necessary)
    NotifyCardAttackOutcome(attacker, defender, attackingCard, defendingCard)
end

-- init.lua

function ActivateSpellCard(ply, spellCard)
    local duelData = ply:GetNW2Table("DuelData")

    -- Example: Move spell card from hand to field
    table.RemoveByValue(duelData.Hand, spellCard)
    table.insert(duelData.Field, spellCard)

    -- Apply the spell card's effect (assuming you have an ApplySpellEffect function)
    ApplySpellEffect(ply, spellCard)

    -- Save updated DuelData
    ply:SetNW2Table("DuelData", duelData)

    -- Notify players of the spell card activation (implement this function if necessary)
    NotifySpellCardActivation(ply, spellCard)
end


-- init.lua

function ActivateSpellCard(ply, spellCard)
    local duelData = ply:GetNW2Table("DuelData")

    -- Example: Move spell card from hand to field
    table.RemoveByValue(duelData.Hand, spellCard)
    table.insert(duelData.Field, spellCard)

    -- Apply the spell card's effect (assuming you have an ApplySpellEffect function)
    ApplySpellEffect(ply, spellCard)

    -- Save updated DuelData
    ply:SetNW2Table("DuelData", duelData)

    -- Notify players of the spell card activation (implement this function if necessary)
    NotifySpellCardActivation(ply, spellCard)
end

-- init.lua

function GetPlayerDeck(ply)
    if ply:GetNW2Var("DuelData") == nil then
        return {}
    end

    local duelData = ply:GetNW2Var("DuelData")
    return duelData.Deck
end


-- init.lua

function SavePlayerDeck(ply)
    local steamID = ply:SteamID64()
    local duelData = ply:GetNW2Table("DuelData")
    local deckData = util.TableToJSON(duelData.Deck)

    file.CreateDir("yugioh_gamemode/decks")
    file.Write("yugioh_gamemode/decks/" .. steamID .. ".txt", deckData)
end

-- init.lua

-- init.lua

function LoadPlayerDeck(ply)
    local steamID = ply:SteamID64()
    local filePath = "yugioh_gamemode/decks/" .. steamID .. ".txt"

    if ply:GetNW2Var("DuelData") == nil then
        ply:SetNW2Var("DuelData", { Deck = {} })
    end

    if file.Exists(filePath, "DATA") then
        local deckData = file.Read(filePath, "DATA")
        local deckTable = util.JSONToTable(deckData)
        ply:SetNW2Var("DuelData", { Deck = deckTable })
    else
        local basicDeck = CreateBasicDeck(40) -- Creates a deck of 40 random cards
        ply:SetNW2Var("DuelData", { Deck = basicDeck })
    end
end

-- init.lua

-- init.lua

function DuelInProgress()
    return GetGlobalBool("DuelInProgress", false)
end


-- init.lua

function SetDuelPlayers(player1, player2)
    SetGlobalEntity("DuelPlayer1", player1)
    SetGlobalEntity("DuelPlayer2", player2)
    SetGlobalBool("DuelInProgress", true)
end



function StartDuel(player1, player2)
    if not player1 or not player2 then
        print("Unable to start duel. Players not found.")
        return
    end

    if DuelInProgress() then
        print("A duel is already in progress.")
        return
    end

    print("Starting duel between " .. player1:Nick() .. " and " .. player2:Nick())

    SetDuelPlayers(player1, player2)
    LoadPlayerDeck(player1)
    LoadPlayerDeck(player2)
    InitializeDuelData(player1)
    InitializeDuelData(player2)

    PerformTurn(player1)
end


-- init.lua

function GetPlayersForDuel()
    local players = player.GetAll()
    if #players >= 2 then
        return players[1], players[2]
    else
        return nil, nil
    end
end


-- init.lua

util.AddNetworkString("ShowDuelPanel")

function PerformTurn(player)
    print("Performing turn for " .. player:Nick())

    DrawCard(player)

    -- Add your turn logic here

    net.Start("ShowDuelPanel")
    net.Send(player)

    -- Temporarily comment out the timer to avoid switching turns automatically
    -- local nextPlayer = GetNextPlayer(player)
    -- timer.Simple(5, function()
    --     PerformTurn(nextPlayer)
    -- end)
end


-- init.lua

function GetNextPlayer(currentPlayer)
    local player1 = GetGlobalEntity("DuelPlayer1")
    local player2 = GetGlobalEntity("DuelPlayer2")

    if currentPlayer == player1 then
        return player2
    else
        return player1
    end
end
