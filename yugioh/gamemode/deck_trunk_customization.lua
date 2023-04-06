-- deck_trunk_customization.lua (client)
if CLIENT then
local function createDeckTrunkCustomization()
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() * 0.8, ScrH() * 0.8)
    frame:SetPos(ScrW() * 0.1, ScrH() * 0.1)
    frame:SetTitle("Deck and Trunk Customization")
    frame:SetVisible(true)
    frame:SetDraggable(false)
    frame:ShowCloseButton(true)
    frame:MakePopup()
    -- Implement deck and trunk customization functionality here
end

hook.Add("PlayerButtonDown", "OpenDeckTrunkCustomization", function(ply, button)
    if button == KEY_F1 then
        createDeckTrunkCustomization()
    end
end)
end