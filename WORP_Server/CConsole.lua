-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CConsole
{
	GetID		= function( this )
		return 0;
	end;
	
	IsLoggedIn	= function( this )
		return true;
	end;
	
	IsInGame	= function( this )
		return false;
	end;
	
	GetChar		= function( this )
		return NULL;
	end;
	
	GetGroups	= function( this )
		return { g_pGame:GetGroupManager():Get( 0 ) };
	end;
	
	HaveAccess	= function( this )
		return true;
	end;
	
	GetName		= function( this )
		return "Console";
	end;
	
	GetUserName	= function( this )
		return "Console";
	end;
	
	GetChat		= function( this )
		return
		{
			Send	= function( self, sText )
				print( sText );
			end;
		};
	end;
};
