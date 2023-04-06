-- game_state.lua (shared)
GameState = {
    players = {},
    turn = 1,
    currentPlayer = nil
}

function GameState:addPlayer(ply)
    self.players[ply] = {
        lifePoints = 8000,
        field = {},
        hand = {}
    }
end

function GameState:nextTurn()
    self.turn = self.turn + 1
    self.currentPlayer = self.players[Entity(math.fmod(self.turn, 2) + 1)]
end

hook.Add("PlayerInitialSpawn", "AddPlayerToGameState", function(ply)
    GameState:addPlayer(ply)
end)

-- game_state.lua (shared, continue from previous code)

function GameState:playCard(ply, cardIndex)
    local playerData = self.players[ply]

    if not playerData.hand[cardIndex] then return end

    local card = playerData.hand[cardIndex]

    if card.cardType == "monster" then
        if not playerData.field["monster"] then
            playerData.field["monster"] = card
            table.remove(playerData.hand, cardIndex)
        end
    elseif card.cardType == "spell" or card.cardType == "trap" then
        if not playerData.field[card.cardType] then
            playerData.field[card.cardType] = card
            table.remove(playerData.hand, cardIndex)
        end
    end
end

-- game_state.lua (shared, continue from previous code)

function GameState:attack(ply, targetPlayer, attackerIndex, defenderIndex)
    local attackerData = self.players[ply]
    local defenderData = self.players[targetPlayer]

    if not attackerData.field["monster"] or not defenderData.field["monster"] then return end

    local attacker = attackerData.field["monster"]
    local defender = defenderData.field["monster"]

    if attacker.effect.atk > defender.effect.def then
        local damage = attacker.effect.atk - defender.effect.def
        defenderData.lifePoints = defenderData.lifePoints - damage
        defenderData.field["monster"] = nil
    elseif attacker.effect.atk < defender.effect.def then
        local damage = defender.effect.def - attacker.effect.atk
        attackerData.lifePoints = attackerData.lifePoints - damage
        attackerData.field["monster"] = nil
    else
        attackerData.field["monster"] = nil
        defenderData.field["monster"] = nil
    end
end

-- game_state.lua (shared, continue from previous code)

function GameState:setMonsterDefense(ply, monsterIndex)
    local playerData = self.players[ply]

    if not playerData.field["monster"] then return end

    local monster = playerData.field["monster"]
    monster.defenseMode = true
end

