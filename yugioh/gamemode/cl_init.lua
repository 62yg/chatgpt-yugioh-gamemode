-- Create player HUD
local function createPlayerHUD(player)
    local panel = vgui.Create("DPanel")
    panel:SetSize(150, 100)
    panel.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 192))
        draw.SimpleText(player.name, "DermaDefaultBold", w/2, 8, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText("LP: " .. player.lp, "DermaDefaultBold", w/2, 28, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText("Hand: " .. #player.hand, "DermaDefaultBold", w/2, 48, color_white, TEXT_ALIGN_CENTER)
    end
    
    return panel
end

-- Yugioh gamemode client code

-- Include shared code
include("shared.lua")

-- Define function to create card panel
function createCardPanel(card)
    local cardPanel = vgui.Create("DPanel")
    cardPanel:SetSize(100, 150)
    
    local cardImage = vgui.Create("DImage", cardPanel)
    cardImage:SetSize(80, 100)
    cardImage:SetPos(10, 10)
    cardImage:SetImage("materials/pictures/" .. card.name .. ".jpg")
    
    local cardName = vgui.Create("DLabel", cardPanel)
    cardName:SetPos(10, 120)
    cardName:SetSize(80, 20)
    cardName:SetText(card.name)
    
    return cardPanel
end

-- Define function to create hand panel
function createHandPanel(player)
    local handPanel = vgui.Create("DPanel")
    handPanel:SetSize(500, 150)
    
    for i, card in ipairs(player.hand) do
        local cardPanel = createCardPanel(card)
        cardPanel:SetParent(handPanel)
        cardPanel:SetPos(90 * (i - 1) + 10, 0)
    end
    
    return handPanel
end

-- Define function to update player panels
function updatePlayerPanels()
    -- TODO: Implement function to update player panels
end

-- Hook into PlayerAuthed to create player panels
hook.Add("PlayerAuthed", "CreatePlayerPanels", function(ply)
    -- Create player panel
    local playerPanel = vgui.Create("DPanel")
    playerPanel:SetSize(500, 300)
    playerPanel:SetPos(ScrW() / 2 - 250, ScrH() / 2 - 150)
    
    -- Add player name label
    local playerName = vgui.Create("DLabel", playerPanel)
    playerName:SetPos(10, 10)
    playerName:SetSize(100, 20)
    playerName:SetText(ply:GetName())
    
    -- Add life point label
    local lifePoints = vgui.Create("DLabel", playerPanel)
    lifePoints:SetPos(10, 30)
    lifePoints:SetSize(100, 20)
    lifePoints:SetText("Life Points: " .. tostring(8000))
    
    -- Add deck size label
    local deckSize = vgui.Create("DLabel", playerPanel)
    deckSize:SetPos(10, 50)
    deckSize:SetSize(100, 20)
    deckSize:SetText("Deck Size: " .. tostring(0))
    
    -- Create hand panel
    local handPanel = createHandPanel(Yugioh.newPlayer(ply:GetName(), 8000, {}))
    handPanel:SetParent(playerPanel)
    handPanel:SetPos(0, 80)
    
    -- Add player panel to global list
    table.insert(Yugioh.playerPanels, playerPanel)
    
    -- Update player panels
    updatePlayerPanels()
end)


-- Yugioh gamemode client code



-- Define function to display a dialog box asking the user if they want to accept the duel invitation
function Yugioh.displayDuelInvitation(inviter)
    -- Define dialog panel
    local dialogPanel = vgui.Create("DFrame")
    dialogPanel:SetSize(300, 150)
    dialogPanel:SetTitle("Duel Invitation")
    dialogPanel:SetVisible(true)
    dialogPanel:SetDraggable(false)
    dialogPanel:ShowCloseButton(true)
    dialogPanel:MakePopup()

    -- Define message label
    local messageLabel = vgui.Create("DLabel", dialogPanel)
    messageLabel:SetPos(10, 30)
    messageLabel:SetText("You have been invited to a duel by " .. inviter .. ". Do you accept?")

    -- Define yes button
    local yesButton = vgui.Create("DButton", dialogPanel)
    yesButton:SetText("Yes")
    yesButton:SetSize(100, 25)
    yesButton:SetPos(50, 100)
    yesButton.DoClick = function()
        -- TODO: Implement code to accept the duel invitation
        dialogPanel:Close()
    end

    -- Define no button
    local noButton = vgui.Create("DButton", dialogPanel)
    noButton:SetText("No")
    noButton:SetSize(100, 25)
    noButton:SetPos(150, 100)
    noButton.DoClick = function()
        -- TODO: Implement code to decline the duel invitation
        dialogPanel:Close()
    end
end

-- Define function to display a duel invitation dialog box
function Yugioh.showDuelInvitation(inviter)
    -- Create frame
    local frame = vgui.Create("DFrame")
    frame:SetSize(300, 100)
    frame:Center()
    frame:SetTitle("Duel Invitation")
    frame:SetVisible(true)
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:MakePopup()

    -- Create message label
    local label = vgui.Create("DLabel", frame)
    label:SetText(inviter .. " has invited you to a duel.")
    label:SetPos(10, 30)
    label:SizeToContents()

    -- Create accept button
    local accept = vgui.Create("DButton", frame)
    accept:SetText("Accept")
    accept:SetPos(60, 70)
    accept:SetSize(80, 20)
    accept.DoClick = function()
        net.Start("Yugioh.duelInvitationResponse")
        net.WriteBool(true)
        net.SendToServer()
        frame:Close()
    end

    -- Create decline button
    local decline = vgui.Create("DButton", frame)
    decline:SetText("Decline")
    decline:SetPos(160, 70)
    decline:SetSize(80, 20)
    decline.DoClick = function()
        net.Start("Yugioh.duelInvitationResponse")
        net.WriteBool(false)
        net.SendToServer()
        frame:Close()
    end
end

-- Handle duel invitation from server
net.Receive("Yugioh.duelInvitation", function(len)
    local inviter = net.ReadString()
    Yugioh.showDuelInvitation(inviter)
end)

function drawHand(ply)
    local hand = ply:GetNWTable("hand")
    local numCards = #hand

    local startX = ScrW() / 2 - (numCards * CARD_WIDTH + (numCards - 1) * CARD_SPACING) / 2
    local y = ScrH() - CARD_HEIGHT - CARD_SPACING

    for i, card in ipairs(hand) do
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(card:GetMaterial())
        surface.DrawTexturedRect(startX + (i - 1) * (CARD_WIDTH + CARD_SPACING), y, CARD_WIDTH, CARD_HEIGHT)
    end
end
