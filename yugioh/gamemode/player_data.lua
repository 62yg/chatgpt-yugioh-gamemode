-- player_data.lua (server)
if SERVER then
util.AddNetworkString("InitializePlayerDeck")

function InitializePlayerDeck(ply)
    local deck = {}
    local trunk = {}

    for i = 1, 40 do
        table.insert(deck, table.Copy(CardLibrary["dark_magician"]))
    end

    for i = 1, 20 do
        table.insert(trunk, table.Copy(CardLibrary["blue_eyes"]))
    end

    ply.yugiohDeck = deck
    ply.yugiohTrunk = trunk

    net.Start("InitializePlayerDeck")
    net.WriteTable(deck)
    net.WriteTable(trunk)
    net.Send(ply)
end
hook.Add("PlayerInitialSpawn", "InitializePlayerDeck", InitializePlayerDeck)
end