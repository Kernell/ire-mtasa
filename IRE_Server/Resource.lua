-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

_DEBUG 			= VERSION == "1.0 development";

class. Resource : Element
{
	OnStart	= function()
		setGameType		( "Role-Playing Game" );
		setMapName		( "Los Angeles" );
		setRuleValue	( "Author", "Kernell" );
		setRuleValue	( "Version", VERSION );
		setRuleValue	( "License", "Proprietary Software" );
		setRuleValue	( "ServerVersion", getVersion().tag );
		
		SetDefaultTimezone( "Europe/Moscow" );
		
		this.Server		= new. Server();
		
		this.Server.Startup();
	end;
	
	OnStop	= function()
		delete ( this.Server );
		this.Server = NULL;
		
		this.GetRoot().OnResourceStart.Remove( Resource.OnStart );
		this.GetRoot().OnResourceStop.Remove( Resource.OnStop );
	end;
	
	Resource = function( resource )
		if type( resource ) == "string" then
			resource = getResourceFromName( resource );
		end
		
		if resource then
			resource( this );
		end
		
		local this = resource;
		
		this.GetRoot().OnResourceStart.Add( this.OnStart, true, "high" );
		this.GetRoot().OnResourceStop.Add( this.OnStop, true, "high" );
		
		return resource;
	end;
	
	Delete		= function()
		return deleteResource( this );
	end;
	
	Copy					= function( NewResourceName, OrganizationalDir )
		return copyResource( this, NewResourceName, OrganizationalDir );
	end;
	
	GetFunctions 			= function()
		return getResourceExportedFunctions( this );
	end;
	
	GetInfo					= function( Var )
		return getResourceInfo( this, Var );
	end;
	
	GetLastStartTime		= function()
		return getResourceLastStartTime( this );
	end;
	
	GetState				= function()
		return getResourceState( this );
	end;
	
	GetError				= function()
		return getResourceLoadFailureReason( this );
	end;
	
	GetLoadTime				= function()
		return getResourceLoadTime( this );
	end;
	
	GetName					= function()
		return getResourceName( this );
	end;
	
	GetRoot					= function()
		return getResourceRootElement( this );
	end;
	
	GetElementRoot			= function()
		return getResourceDynamicElementRoot( this );
	end;
	
	SetDefaultSetting		= function( Key, Value )
		return setResourceDefaultSetting( this, Key, Value );
	end;
	
	RemoveDefaultSetting	= function( Key )
		return removeResourceDefaultSetting( this, Key );
	end;
	
	RemoveFile				= function( fileName )
		return removeResourceFile( this, fileName );
	end;
	
	Start					= function()
		return startResource( this );
	end;
	
	Restart					= function()
		return restartResource( this );
	end;
	
	Stop					= function()
		return stopResource( this );
	end;
	
	Rename					= function( newName )
		return renameResource( this, newName );
	end;
	
	SetInfo					= function( key, value )
		return setResourceInfo( this, key, value );
	end;
	
	GetACLRequests			= function()
		return getResourceACLRequests( this );
	end;
	
	UpdateACLRequest		= function( RightName, Access, ByWho )
		return updateResourceACLRequest( this, RightName, Access, (string)(ByWho) );
	end;
};

new. Resource( resource );