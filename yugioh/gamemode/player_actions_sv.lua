-- player_actions_sv.lua (server)
util.AddNetworkString("PlayCard")

net.Receive("PlayCard", function(len, ply)
    local cardIndex = net.ReadUInt(32)
    GameState:playCard(ply, cardIndex)
end)

-- player_actions_sv.lua (server, continue from previous code)
util.AddNetworkString("Attack")

net.Receive("Attack", function(len, ply)
    local targetPlayer = net.ReadEntity()
    local attackerIndex = net.ReadUInt(32)
    local defenderIndex = net.ReadUInt(32)
    GameState:attack(ply, targetPlayer, attackerIndex, defenderIndex)
end)

-- player_actions_sv.lua (server, continue from previous code)
util.AddNetworkString("SetMonsterDefense")

net.Receive("SetMonsterDefense", function(len, ply)
    local monsterIndex = net.ReadUInt(32)
    GameState:setMonsterDefense(ply, monsterIndex)
end)
