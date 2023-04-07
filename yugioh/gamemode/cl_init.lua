

local playerZones = {
    [1] = {
        Hand = nil,
        Field = nil,
        Graveyard = nil
    },
    [2] = {
        Hand = nil,
        Field = nil,
        Graveyard = nil
    }
}

-- cl_init.lua

include("shared.lua")

function OpenDeckCreationMenu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(600, 400)
    frame:SetTitle("Deck Creation")
    frame:Center()
    frame:MakePopup()

    -- Add logic to display available cards, allow players to add/remove cards to/from their deck, and save the deck
end

net.Receive("OpenDeckCreationMenu", function(len)
    OpenDeckCreationMenu()
end)


-- cl_init.lua

function CreatePlayingField()

    local playingField = vgui.Create("DPanel")
    playingField:SetSize(ScrW() * 0.8, ScrH() * 0.8)
    playingField:Center()
    playingField.Paint = function(self, w, h)
	  surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("field.jpg"))
      surface.DrawTexturedRect(0, 0, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
    end

    local player = LocalPlayer()

    -- Create Life Points display
    local lifePointsDisplay = CreateLifePointsDisplay(player, playingField)
    
    -- Add Monster Zones
    CreateMonsterZone(player, playingField, 100, 200)
    CreateMonsterZone(player, playingField, 200, 200)
    CreateMonsterZone(player, playingField, 300, 200)
	CreateMonsterZone(player, playingField, 400, 200)
    CreateMonsterZone(player, playingField, 500, 200)
    -- ... continue for all monster zones

    -- Add Spell & Trap Zones
    CreateSpellTrapZone(player, playingField, 100, 320)
    CreateSpellTrapZone(player, playingField, 200, 320)
    CreateSpellTrapZone(player, playingField, 300, 320)
    CreateSpellTrapZone(player, playingField, 400, 320)
    CreateSpellTrapZone(player, playingField, 500, 320)
    -- ... continue for all spell & trap zones

    -- Add Deck Zone
    CreateDeckZone(player, playingField, 500, 200)

    -- Add Extra Deck Zone
    CreateExtraDeckZone(player, playingField, 600, 200)

    -- Add Graveyard Zone
    CreateGraveyardZone(player, playingField, 700, 200)

    -- Start of existing code
    -- ...

    local playingField = {} -- Add this line to define playingField.

    local mainPanel = vgui.Create("DFrame")
    mainPanel:SetSize(ScrW(), ScrH())
    mainPanel:SetTitle("")
    mainPanel:ShowCloseButton(false)
    mainPanel:SetDraggable(false)
    mainPanel:MakePopup()
    mainPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    local yourPlayer = LocalPlayer()
    local opponent = GetOpponent(yourPlayer)

    playingField[yourPlayer] = CreateLifePointsDisplay(yourPlayer, mainPanel)
    playingField[opponent] = CreateLifePointsDisplay(opponent, mainPanel)

    playingField[yourPlayer]:SetPos(0, 0)
    playingField[opponent]:SetPos(0, 30)

    return playingField
end







-- cl_init.lua

function CreateCardDisplay(parent, card, isOpponent)
    local cardDisplay = vgui.Create("DImage", parent)
    cardDisplay:SetSize(parent:GetWide() / parent:GetChildCount(), parent:GetTall())

    if isOpponent then
        cardDisplay:SetImage("card_back.jpg")
    else
        cardDisplay:SetImage(card.image)
    end

    cardDisplay.DoClick = function(card, parent, x, y, width, height)
    if not isOpponent then
    local cardPanel = vgui.Create("DPanel", parent)
    cardPanel:SetSize(width, height)
    cardPanel:SetPos(x, y)
    cardPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
    end

    local cardImage = vgui.Create("DImage", cardPanel)
    cardImage:SetSize(width, height)
    cardImage:SetImage(card.imagePath)
    end
    end

    return cardDisplay
end


  


-- cl_init.lua

function DisplayHand(ply, handZone)

    local isOpponent = ply ~= LocalPlayer()

    for _, card in ipairs(ply:GetNW2Table("Hand")) do
        CreateCardDisplay(handZone, card, isOpponent)
    end
	
    local hand = ply:GetNW2Table("DuelData").Hand

    local cardWidth, cardHeight = 100, 150
    local spacing = 10
    local startX = (handZone:GetWide() - (#hand * cardWidth + (#hand - 1) * spacing)) / 2

    for i, card in ipairs(hand) do
        local x = startX + (i - 1) * (cardWidth + spacing)
        local y = (handZone:GetTall() - cardHeight) / 2
        CreateCardDisplay(card, handZone, x, y, cardWidth, cardHeight)
    end
	
	    for _, card in ipairs(ply:GetNW2Table("DuelData").Hand) do
        -- (rest of the for loop code here)
    end
	
	
end

function DisplayHand(ply)
    if not IsValid(ply) then return end

    local hand = {}
    local duelDataEntity = ply:GetNW2Entity("DuelData")

    if IsValid(duelDataEntity) then
        for i = 1, 7 do
            local cardID = duelDataEntity:GetNW2Int("Hand_" .. i, -1)
            if cardID ~= -1 then
                hand[i] = cardID
            end
        end
    end

    local handZone = GetHandZoneForPlayer(ply)

    for i, cardID in ipairs(hand) do
        CreateCardDisplay(cardID, handZone)
    end
end


function DisplayField(ply)
    if not IsValid(ply) then return end

    local field = {}
    local duelDataEntity = ply:GetNW2Entity("DuelData")

    if IsValid(duelDataEntity) then
        for i = 1, 5 do
            local cardID = duelDataEntity:GetNW2Int("Field_" .. i, -1)
            if cardID ~= -1 then
                field[i] = cardID
            end
        end
    end

    local fieldZone = GetFieldZoneForPlayer(ply)

    for i, cardID in ipairs(field) do
        CreateCardDisplay(cardID, fieldZone)
    end
end


function DisplayGraveyard(ply)
    if not IsValid(ply) then return end

    local graveyard = {}
    local duelDataEntity = ply:GetNW2Entity("DuelData")

    if IsValid(duelDataEntity) then
        local count = duelDataEntity:GetNW2Int("GraveyardCount", 0)

        for i = 1, count do
            local cardID = duelDataEntity:GetNW2Int("Graveyard_" .. i, -1)
            if cardID ~= -1 then
                graveyard[i] = cardID
            end
        end
    end

    local graveyardZone = GetGraveyardZoneForPlayer(ply)

    for i, cardID in ipairs(graveyard) do
        CreateCardDisplay(cardID, graveyardZone)
    end
end


-- cl_init.lua

function ClearZone(zone)
    for _, child in ipairs(zone:GetChildren()) do
        child:Remove()
    end
end

function GetOpponent(ply)
    if not IsValid(ply) then return end

    for _, opponent in ipairs(player.GetAll()) do
        if opponent ~= ply then
            return opponent
        end
    end
end

-- cl_init.lua

function UpdatePlayingField(ply, handZone, fieldZone, graveyardZone)
    ClearZone(handZone)
    ClearZone(fieldZone)
    ClearZone(graveyardZone)

    DisplayHand(ply, handZone)
    DisplayField(ply, fieldZone)
    DisplayGraveyard(ply, graveyardZone)
end


-- cl_init.lua

hook.Add("CardDrawn", "UpdatePlayingFieldOnCardDrawn", function(ply)
    local handZone = GetHandZoneForPlayer(ply) -- You will need to create this function
    local fieldZone = GetFieldZoneForPlayer(ply) -- You will need to create this function
    local graveyardZone = GetGraveyardZoneForPlayer(ply) -- You will need to create this function

    UpdatePlayingField(ply, handZone, fieldZone, graveyardZone)
end)

hook.Add("CardPlayed", "UpdatePlayingFieldOnCardPlayed", function(ply)
    local handZone = GetHandZoneForPlayer(ply) -- You will need to create this function
    local fieldZone = GetFieldZoneForPlayer(ply) -- You will need to create this function
    local graveyardZone = GetGraveyardZoneForPlayer(ply) -- You will need to create this function

    UpdatePlayingField(ply, handZone, fieldZone, graveyardZone)
end)

hook.Add("CardMovedToGraveyard", "UpdatePlayingFieldOnCardMovedToGraveyard", function(ply)
    local handZone = GetHandZoneForPlayer(ply) -- You will need to create this function
    local fieldZone = GetFieldZoneForPlayer(ply) -- You will need to create this function
    local graveyardZone = GetGraveyardZoneForPlayer(ply) -- You will need to create this function

    UpdatePlayingField(ply, handZone, fieldZone, graveyardZone)
end)

function GetHandZoneForPlayer(ply)
    return playerZones[ply] and playerZones[ply].handZone
end

function GetFieldZoneForPlayer(ply)
    return playerZones[ply] and playerZones[ply].fieldZone
end

function GetGraveyardZoneForPlayer(ply)
    return playerZones[ply] and playerZones[ply].graveyardZone
end


-- cl_init.lua

net.Receive("CardDrawn", function(len)
    local ply = net.ReadEntity()
    hook.Run("CardDrawn", ply)
end)

net.Receive("CardPlayed", function(len)
    local ply = net.ReadEntity()
    hook.Run("CardPlayed", ply)
end)

net.Receive("CardMovedToGraveyard", function(len)
    local ply = net.ReadEntity()
    hook.Run("CardMovedToGraveyard", ply)
end)

-- cl_init.lua



function CreateLifePointsDisplay(ply, parentPanel)
    local lifePointsPanel = vgui.Create("DPanel", parentPanel)
    lifePointsPanel:SetSize(200, 30) -- Adjust the size as needed.
    lifePointsPanel:SetPos(0, 0)
    lifePointsPanel.Paint = function(self, w, h)
        local lifePoints = ply:GetNWInt("LifePoints", 0)
        draw.SimpleText("Life Points: " .. lifePoints, "DermaDefault", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    return lifePointsPanel
end





-- cl_init.lua

function ShowDuelPanel()
    if not IsValid(DuelPanel) then
        CreatePlayingField(duelPanel)
    end
    DuelPanel:SetVisible(true)
end


net.Receive("ShowDuelPanel", function()
    ShowDuelPanel()
end)

function ShowDuelPanel()
    local duelPanel = vgui.Create("DFrame")
    duelPanel:SetSize(ScrW(), ScrH())
    duelPanel:SetTitle("")
    duelPanel:SetVisible(true)
    duelPanel:SetDraggable(false)
    duelPanel:ShowCloseButton(false)
    duelPanel:MakePopup()
    duelPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
    end

    CreatePlayingField(duelPanel)
end

function CreateMonsterZone(player, parentPanel, x, y)
    local monsterZone = vgui.Create("DPanel", parentPanel)
    monsterZone:SetSize(80, 120)
    monsterZone:SetPos(x, y)
    monsterZone.Paint = function(self, w, h)
    local card = GetCardFromPlayer(player, zone, index) -- Replace with the actual function to get the card
    if card then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(GetCardImageMaterial(card.imagePath))
      surface.DrawTexturedRect(0, 0, w, h)
    end
    end
    return monsterZone
end

function CreateSpellTrapZone(player, parentPanel, x, y)
    local spellTrapZone = vgui.Create("DButton", parentPanel)
    spellTrapZone:SetSize(80, 120)
    spellTrapZone:SetPos(x, y)
    spellTrapZone:SetText("")
    spellTrapZone.Paint = function(self, w, h)
            local card = GetCardFromPlayer(player, zone, index) -- Replace with the actual function to get the card
    if card then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(GetCardImageMaterial(card.imagePath))
      surface.DrawTexturedRect(0, 0, w, h)
    end
    end

    return spellTrapZone
end

function CreateDeckZone(player, parentPanel, x, y)
    local deckZone = vgui.Create("DButton", parentPanel)
    deckZone:SetSize(80, 120)
    deckZone:SetPos(x, y)
    deckZone:SetText("")
    deckZone.Paint = function(self, w, h)
            local card = GetCardFromPlayer(player, zone, index) -- Replace with the actual function to get the card
    if card then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(GetCardImageMaterial(card.imagePath))
      surface.DrawTexturedRect(0, 0, w, h)
    end
    end

    return deckZone
end

function CreateExtraDeckZone(player, parentPanel, x, y)
    local extraDeckZone = vgui.Create("DButton", parentPanel)
    extraDeckZone:SetSize(80, 120)
    extraDeckZone:SetPos(x, y)
    extraDeckZone:SetText("")
    extraDeckZone.Paint = function(self, w, h)
          local card = GetCardFromPlayer(player, zone, index) -- Replace with the actual function to get the card
    if card then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(GetCardImageMaterial(card.imagePath))
      surface.DrawTexturedRect(0, 0, w, h)
    end
    end

    return extraDeckZone
end

function CreateGraveyardZone(player, parentPanel, x, y)
    local graveyardZone = vgui.Create("DButton", parentPanel)
    graveyardZone:SetSize(80, 120)
    graveyardZone:SetPos(x, y)
    graveyardZone:SetText("")
    graveyardZone.Paint = function(self, w, h)
            local card = GetCardFromPlayer(player, zone, index) -- Replace with the actual function to get the card
    if card then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(GetCardImageMaterial(card.imagePath))
      surface.DrawTexturedRect(0, 0, w, h)
    end
    end

    return graveyardZone
end

function GetCardImageMaterial(imagePath)
    return Material(imagePath)
end

function GetCardFromPlayer(player, zone, index)
    if not IsValid(player) then return nil end
    local cardsJSON = player:GetNWString("Cards")
    if cardsJSON ~= "" then
        local cards = util.JSONToTable(cardsJSON)
        if cards and cards[zone] and cards[zone][index] then
            return cards[zone][index]
        end
    end
    return nil
end


function CreateHandZone(player, parentPanel, x, y, cardWidth, cardHeight)
    local handZone = vgui.Create("DPanel", parentPanel)
    handZone:SetSize(parentPanel:GetWide(), cardHeight)
    handZone:SetPos(x, y)
    handZone.Paint = function(self, w, h)
        local cards = player:GetNW2Table("Cards").Hand
        if cards then
            for i, card in ipairs(cards) do
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(GetCardImageMaterial(card.imagePath))
                surface.DrawTexturedRect((i - 1) * cardWidth, 0, cardWidth, cardHeight)
            end
        end
    end
    return handZone
end
