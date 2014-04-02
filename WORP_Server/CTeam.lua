-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CTeam ( CElement )
{
	CTeam		= function( this, sName, iRed, iGreen, iBlue )
		iRed	= tonumber( iRed ) 		or 255;
		iGreen	= tonumber( iGreen )	or 255;
		iBlue	= tonumber( iBlue ) 	or 255;
		
		local pElement	= createTeam( sName, iRed, iGreen, iBlue );
		
		pElement( this );
		
		return pElement;
	end;
	
	CountPlayers	= countPlayersInTeam;
	GetPlayers		= getPlayersInTeam;
	SetColor		= setTeamColor;
	GetColor		= getTeamColor;
	SetFriendlyFire	= setTeamFriendlyFire;
	GetFriendlyFire	= getTeamFriendlyFire;
	SetName			= setTeamName;
	GetName			= getTeamName;
};