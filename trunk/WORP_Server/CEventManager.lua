-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

enum "eEventType"
{
	"EVENT_TYPE_CONNECT";
	"EVENT_TYPE_NEW_CHARACTER";
	"EVENT_TYPE_DEATH";
};

class: CEventManager ( CManager )
{
	CEventManager	= function( this )
		this:CManager();
	end;
	
	Init			= function( this )
		for i, sEventType in ipairs( eEventType ) do
			addEvent( sEventType );
		end
		
		return true;
	end;
	
	Add				= function( this, vHandle, iEventType, self )
		local function vHandlerFunction( ... )
			return vHandle( self, ... );
		end
		
		return addEventHandler( eEventType[ iEventType ], resourceRoot, vHandlerFunction, true, "normal" );
	end;
	
	Call			= function( this, iEventType, ... )
		return triggerEvent( eEventType[ iEventType ], resourceRoot, ... );
	end;
};