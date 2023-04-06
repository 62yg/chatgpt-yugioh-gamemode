-- yugioh_gamemode.lua (shared)
GM.Name = "Yugioh Garry's Mod"
GM.Author = "OpenAI"

include( "card_library.lua" )
AddCSLuaFile( "card_library.lua" )

include( "card_definitions.lua" )
AddCSLuaFile( "card_definitions.lua" )

include( "game_board.lua" )
AddCSLuaFile( "game_board.lua" )

include( "player_data.lua" )
AddCSLuaFile( "player_data.lua" )

include( "player_data_cl.lua" )
AddCSLuaFile( "player_data_cl.lua" )

include( "deck_trunk_customization.lua" )
AddCSLuaFile( "deck_trunk_customization.lua" )

include( "game_state.lua" )
AddCSLuaFile( "game_state.lua" )

include( "player_actions.lua" )
AddCSLuaFile( "player_actions.lua" )

include( "player_actions_sv.lua" )
AddCSLuaFile( "player_actions_sv.lua" )



function GM:Initialize()
    self.BaseClass.Initialize(self)
end
