-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. PlayerTutorial
{
	PlayerTutorial		= function( player )
		this.Player = player;
	end;
	
	_PlayerTutorial	= function()
		this.Player	= NULL;
	end;
	
	SendTutorialData	= function( stringArray, type )
		this.Player.RPC.SendTutorialData( stringArray, type );
	end;
	
	CompleteTutorial	= function( type )
		Server.Game.TutorialManager.Complete( this, type );
	end;
};