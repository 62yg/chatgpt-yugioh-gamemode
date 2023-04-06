-- player_data_cl.lua (client)
if CLIENT then
net.Receive("InitializePlayerDeck", function()
    LocalPlayer().yugiohDeck = net.ReadTable()
    LocalPlayer().yugiohTrunk = net.ReadTable()
end)
end