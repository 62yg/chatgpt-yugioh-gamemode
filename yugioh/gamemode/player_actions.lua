-- player_actions.lua (client)
util.AddNetworkString("PlayCard")

function sendPlayCard(cardIndex)
    net.Start("PlayCard")
    net.WriteUInt(cardIndex, 32)
    net.SendToServer()
end

-- player_actions.lua (client, continue from previous code)
util.AddNetworkString("Attack")

function sendAttack(targetPlayer, attackerIndex, defenderIndex)
    net.Start("Attack")
    net.WriteEntity(targetPlayer)
    net.WriteUInt(attackerIndex, 32)
    net.WriteUInt(defenderIndex, 32)
    net.SendToServer()
end

-- player_actions.lua (client, continue from previous code)
util.AddNetworkString("SetMonsterDefense")

function sendSetMonsterDefense(monsterIndex)
    net.Start("SetMonsterDefense")
    net.WriteUInt(monsterIndex, 32)
    net.SendToServer()
end

