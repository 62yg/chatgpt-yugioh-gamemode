-- game_board.lua (client)
if CLIENT then
local function createGameBoard()
    local gameBoard = vgui.Create("DFrame")
    gameBoard:SetSize(ScrW() * 0.8, ScrH() * 0.8)
    gameBoard:SetPos(ScrW() * 0.1, ScrH() * 0.1)
    gameBoard:SetTitle("Yugioh Game Board")
    gameBoard:SetVisible(true)
    gameBoard:SetDraggable(false)
    gameBoard:ShowCloseButton(false)
    gameBoard:MakePopup()
    return gameBoard
end


-- game_board.lua (client, continue from previous code)

net.Receive("StartDuel", function()
    createGameBoard()
end)

concommand.Add("duel_start", function()
    local gameBoard = createGameBoard()
end)


end