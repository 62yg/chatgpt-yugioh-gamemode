-- shared.lua

GM.Name = "Yu-Gi-Oh Gamemode"
GM.Author = "Your Name"

CARD_TYPE_MONSTER = 1
CARD_TYPE_SPELL = 2

CardExamples = {
    {
        name = "Blue-Eyes White Dragon",
        cardType = CARD_TYPE_MONSTER,
        attack = 3000,
        defense = 2500,
        level = 8,
        imagePath = "blueeyeswhitedragon.jpg",
    },
    {
        name = "Dark Magician",
        cardType = CARD_TYPE_MONSTER,
        attack = 2500,
        defense = 2100,
        level = 7,
        imagePath = "darkmagician.jpg",
    },
    {
        name = "Monster Reborn",
        cardType = CARD_TYPE_SPELL,
        effect = function(player, target)
            -- Add logic to revive a monster from the graveyard
        end,
        imagePath = "monster_reborn.jpg",
    },
}

-- shared.lua

function GM:ShowHelp(ply)
    if SERVER then
        net.Start("OpenDeckCreationMenu")
        net.Send(ply)
    end
end


-- shared.lua

function DrawCard(ply)
    local duelData = ply:GetNWTable("DuelData")
    local deck = duelData.deck
    local hand = duelData.hand

    if #deck == 0 then
        ply:ChatPrint("Your deck is empty!")
        return
    end

    local cardIndex = math.random(#deck)
    local card = table.remove(deck, cardIndex)
    table.insert(hand, card)

    ply:SetNWTable("DuelData", duelData)
end

-- shared.lua

-- shared.lua

function PerformTurn(ply)
    local duelData = ply:GetNW2Var("DuelData")
    if not duelData then
        return
    end

    if DuelInProgress() then
        local cardID = DrawCard(ply)
        if cardID then
            net.Start("CardDrawn")
            net.WriteEntity(ply)
            net.WriteUInt(cardID, 32)
            net.Broadcast()
        end

        local nextPlayer = GetNextDuelPlayer(ply)
        if nextPlayer then
            timer.Simple(1, function()
                PerformTurn(nextPlayer)
            end)
        end
    end
end


function EndTurn(ply)
    -- Add logic for handling end-of-turn effects and other cleanup tasks

    -- Start the next player's turn
    timer.Simple(1, function() PerformTurn(ply) end)
end

-- shared.lua

function PlaceCardOnField(ply, cardIndex, fieldIndex, isDefence)
    local duelData = ply:GetNWTable("DuelData")
    local hand = duelData.hand
    local field = duelData.field

    local card = table.remove(hand, cardIndex)

    if card.cardType == CARD_TYPE_MONSTER then
        card.isDefence = isDefence
    end

    field[fieldIndex] = card

    ply:SetNWTable("DuelData", duelData)
end

-- shared.lua

function Attack(ply, attackerIndex, targetIndex)
    local attacker = ply:GetNWTable("DuelData").field[attackerIndex]
    local targetPly = GetOpponent(ply)
    local target = targetPly:GetNWTable("DuelData").field[targetIndex]

    if attacker.cardType ~= CARD_TYPE_MONSTER then
        ply:ChatPrint("Only monster cards can attack.")
        return
    end

    if not target then
        -- Direct attack
        local damage = attacker.attack
        ApplyDamage(targetPly, damage)
    elseif attacker.attack > target.defense then
        -- Destroy the target and apply damage
        local damage = attacker.attack - target.defense
        ApplyDamage(targetPly, damage)
        targetPly:GetNWTable("DuelData").field[targetIndex] = nil
    else
        -- Attacker is destroyed
        ply:GetNWTable("DuelData").field[attackerIndex] = nil
    end
end

function ApplyDamage(ply, damage)
    local duelData = ply:GetNWTable("DuelData")
    duelData.lifePoints = duelData.lifePoints - damage

    if duelData.lifePoints <= 0 then
        EndDuel(GetOpponent(ply))
    else
        ply:SetNWTable("DuelData", duelData)
    end
end

-- shared.lua

function EndDuel(winner)
    local loser = GetOpponent(winner)

    winner:ChatPrint("Congratulations, you have won the duel!")
    loser:ChatPrint("You have lost the duel.")

    -- Add logic to reset the game state and handle any post-duel tasks
end


-- shared.lua

function ActivateSpell(ply, cardIndex, targetIndex)
    local duelData = ply:GetNWTable("DuelData")
    local hand = duelData.hand
    local field = duelData.field

    local card = hand[cardIndex]

    if card.cardType ~= CARD_TYPE_SPELL then
        ply:ChatPrint("Only Spell cards can be activated.")
        return
    end

    local targetPly = ply
    if targetIndex then
        local targetCard = field[targetIndex]
        if not targetCard then
            targetPly = GetOpponent(ply)
            targetCard = targetPly:GetNWTable("DuelData").field[targetIndex]
        end

        if targetCard then
            card.effect(targetPly, targetCard)
        end
    else
        card.effect(targetPly)
    end

    table.remove(hand, cardIndex)
    ply:SetNWTable("DuelData", duelData)
end


