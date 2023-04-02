local plymeta = FindMetaTable( "Player" )

function plymeta:GetOpponent()
    if not self:IsPlayingDuel() then return end

    for _, ply in pairs( player.GetAll() ) do
        if ply ~= self and ply:IsPlayingDuel() and ply:GetDuelOpponent() == self then
            return ply
        end
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:IsPlayingDuel()
    return self.DuelPlayer ~= nil
end