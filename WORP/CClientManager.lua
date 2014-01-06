-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CClientManager
{
	CClientManager	= function( this )
		showChat( false );
		showPlayerHudComponent( "all", false );
		setAmbientSoundEnabled( "gunfire", false );
		guiSetInputMode( "no_binds_when_editing" );
		
		resourceRoot:GetNetManager():Connect();
	end;
	
	_CClientManager	= function( this )
		resourceRoot:GetNetManager():Disconnect();
	end;
};