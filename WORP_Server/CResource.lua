-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

enum "eResourceState"
{
	RESOURCE_STATE_ERROR	= "failed to load";
	RESOURCE_STATE_LOADED	= "loaded";
	RESOURCE_STATE_RUNNING	= "running";
	RESOURCE_STATE_STARTING	= "starting";
	RESOURCE_STATE_STOPPING	= "stopping";
};

class "CResource"
{
	CResource = function( self, vResource )
		self.API	=
		{
			__index	= function( _, sFunction )
				return function( ... )
					local Result = { pcall( call, self, sFunction, ... ) };
					
					if not Result[ 1 ] then
						error( Result[ 2 ], 2 );
					end
					
					return unpack( Result, 2 );
				end;
			end;
		};
		
		setmetatable( self.API, self.API );
		
		if type( vResource ) == 'string' then
			vResource = getResourceFromName( vResource );
		end
		
		if vResource then
			CElement.AddToList( self, vResource );
		end
		
		return vResource;
	end;
	
	_CResource				= deleteResource;
	
	Copy					= copyResource;
	GetFunctions 			= getResourceExportedFunctions;
	GetInfo					= getResourceInfo;
	GetLastStartTime		= getResourceLastStartTime;
	GetState				= getResourceState;
	GetError				= getResourceLoadFailureReason;
	GetLoadTime				= getResourceLoadTime;
	GetName					= getResourceName;
	GetRoot					= getResourceRootElement;
	GetElementRoot			= getResourceDynamicElementRoot;
	SetDefaultSetting		= setResourceDefaultSetting;
	RemoveDefaultSetting	= removeResourceDefaultSetting;
	RemoveFile				= removeResourceFile;
	Start					= startResource;
	Restart					= restartResource;
	Stop					= stopResource;
	Rename					= renameResource;
	SetInfo					= setResourceInfo;
	GetACLRequests			= getResourceACLRequests;
	UpdateACLRequest		= updateResourceACLRequest;
	
	RegisterManager			= function( self, pManager )
		local sName = classname( pManager );
	
		if sName[ 1 ] == 'C' and sName:len() > 2 then
			sName = sName:sub( 2 );
		end
		
		local Function		= function()
			return setmetatable(
				{
					__name 	= classname( pManager );
					m_sName	= sName;
				},
				{
					__index = function( this, key )
						return rawget( this, key ) or function( ... )
							return exports[ this.__name - 'Manager' ]:Manager( key, ... );
						end;
					end;
				}
			);
		end;
		
		return call( self, 'RegisterManager', --[[ string.dump ]]( Function ) );
	end;
};

CResource( resource );

addEventHandler( "onResourceStart", resourceRoot,
	function( pResource )
		if Resource then
			Resource.Main( pResource );
		end
	end
);