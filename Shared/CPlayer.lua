-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CPlayer" ( CPed )

function CPlayer:CPlayer( pEntity )
	if pEntity and isElement( pEntity ) and getElementType( pEntity ) == 'player' then
		self.__instance = pEntity;
	end
end

function CPlayer:GetName()
	return getPlayerName( self.__instance );
end

function CPlayer:GetPing()
	return getPlayerPing( self.__instance );
end

function CPlayer:GetTeam()
	return getPlayerTeam( self.__instance );
end

CPlayer.GetNametagText		= getPlayerNametagText;
CPlayer.GetNametagColor		= getPlayerNametagColor;
CPlayer.SetNametagShowing	= setPlayerNametagShowing;