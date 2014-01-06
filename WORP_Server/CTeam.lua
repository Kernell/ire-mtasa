-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CTeam" ( CElement )

function CTeam:CTeam( sName, iRed, iGreen, iBlue )
	if type( sName ) == 'string' then
		iRed	= tonumber( iRed ) 		or 255;
		iGreen	= tonumber( iGreen )	or 255;
		iBlue	= tonumber( iBlue ) 	or 255;

		self.__instance	= createTeam( sName, iRed, iGreen, iBlue );
		
		if not self.__instance then error( "failed to create team", 2 ) end
		
		self:CElement( self.__instance );
		
		CElement.AddToList( self );
	else
		error( TEXT_E2342:format( 'sName', 'string', type( sName ) ), 2 );
	end
end

function CTeam:CountPlayers()
	return countPlayersInTeam( self.__instance );
end

function CTeam:GetPlayers()
	return getPlayersInTeam( self.__instance );
end

function CTeam:SetColor( iRed, iGreen, iBlue )
	iRed	= tonumber( iRed ) 		or 255;
	iGreen	= tonumber( iGreen )	or 255;
	iBlue	= tonumber( iBlue ) 	or 255;
	
	return setTeamColor( self.__instance, iRed, iGreen, iBlue );
end

function CTeam:GetColor()
	return getTeamColor( self.__instance );
end

function CTeam:SetFriendlyFire( bool )
	return setTeamFriendlyFire( self.__instance, tobool( bool ) );
end

function CTeam:GetFriendlyFire()
	return getTeamFriendlyFire( self.__instance );
end

function CTeam:SetName( name )
	return setTeamName( self.__instance, name );
end

function CTeam:GetName()
	return getTeamName( self.__instance );
end