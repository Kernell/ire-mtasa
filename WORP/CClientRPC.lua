-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local PACKET_TIME_LIMIT	= 300; -- ms

local gl_iTick	= PACKET_TIME_LIMIT;

local AsyncQueryHandlers = {};

class: AsyncQuery
{
	static
	{
		OK					= 200;
		BAD_REQUEST			= 400;
		UNAUTHORIZED		= 401;
		FORBIDDEN			= 403;
		NOT_FOUND			= 404;
		REQUEST_TIMEOUT		= 408;
		TOO_MANY_REQUESTS	= 429;
		
		[ 400 ]				= "Bad Request";
		[ 401 ]				= "Unauthorized";
		[ 403 ]				= "Forbidden";
		[ 404 ]				= "Not Found";
		[ 408 ]				= "Request Timeout";
		[ 429 ]				= "Too Many Requests";
	};
	
	Delay		= 1000;
	
	AsyncQuery	= function( this, sFunction, ... )
		this:Init( sFunction, ... );
		
		this:Query();
	end;
	
	_AsyncQuery	= function( this )
		AsyncQueryHandlers[ this.ID ] = NULL;
		
		if this.Timer then
			this.Timer:Kill();
			this.Timer = NULL;
		end
	end;
	
	Init		= function( this, sFunction, ... )
		this.ID				= string.format( "0x%s", (string)(this) - "table: " );
		this.Function		= sFunction;
		this.m_iStatusCode	= NULL;
		
		AsyncQueryHandlers[ this.ID ] = this;
		
		local iTick		= getTickCount();
		local iTickDiff	= iTick - gl_iTick;
		
		if iTickDiff < PACKET_TIME_LIMIT then
			Warning( 2, 1000, (string)(sFunction), iTickDiff );
			
			this.m_iStatusCode		= AsyncQuery.TOO_MANY_REQUESTS;
		else
			if not triggerServerEvent( CClientRPC.m_sClientServer, CLIENT, this, ... ) then
				this.m_iStatusCode	= AsyncQuery.BAD_REQUEST;
			end
		end
		
		gl_iTick = iTick;
		
		this.i		= 0;
		
		function this.DoCheck()
			this.i = this.i + 1;
			
			this.Timer = NULL;
			
			if this.m_iStatusCode == NULL then
				if this.i == 5 then
					this.m_iStatusCode = AsyncQuery.REQUEST_TIMEOUT;
				end
			else
				if this.StatusCode and this.StatusCode[ this.m_iStatusCode ] then
					this.StatusCode[ this.m_iStatusCode ]( this, this.m_vResult );
				end
				
				if this.m_iStatusCode == AsyncQuery.OK then
					if this.Success then
						this:Success( this.m_vResult );
					end
				else
					this.m_vResult = "Asynchronous query error\n(" + this.m_iStatusCode + " " + AsyncQuery[ this.m_iStatusCode ] + ")";
					
					if this.Error then
						this:Error( this.m_iStatusCode, this.m_vResult );
					end
				end
				
				if this.Complete then
					this:Complete( this.m_iStatusCode, this.m_vResult );
				end
				
				delete ( this );
				
				return;
			end
			
			this.Timer = CTimer( this.DoCheck, 1000, 1 );
		end
		
	end;
	
	Query	= function( this )
		this.Timer = CTimer( this.DoCheck, this.Delay, 1 );
	end;
};

function CClientRPC__Handler( iStatusCode, ID, vResult )
	local pQuery	= AsyncQueryHandlers[ ID ];
	
	if pQuery then
		pQuery.m_iStatusCode	= iStatusCode;
		pQuery.m_vResult		= vResult;
		
		-- pQuery.DoCheck();
	end
end

class: CClientRPC
{
	m_sServerClient	= "CClientRPC:ServerClient";
	m_sClientServer	= "CClientRPC:ClientServer";
};

function CClientRPC:CClientRPC()
	SERVER			= {};
	local SERVER_MT	= {};

	setmetatable( SERVER, SERVER_MT );

	function SERVER_MT.__index( _, key )
		return function( ... )
			local iTick		= getTickCount();
			local iTickDiff	= iTick - gl_iTick;
			
			if iTickDiff < PACKET_TIME_LIMIT then
				Warning( 2, 1000, (string)(key), iTickDiff );
				
				return false;
			end
			
			gl_iTick = iTick;
			
			return triggerServerEvent( self.m_sClientServer, CLIENT, { Function = key; }, ... );
		end
	end

	addEvent( self.m_sServerClient, true );
	
	local function ClientCall( aSpace, ... )
		local pCurrent	= _G;
		
		for i, sName in ipairs( aSpace ) do
			if pCurrent[ sName ] then
				pCurrent	= pCurrent[ sName ];
			else
				error( "attempt to index '" + sName + "'" );
			end
		end
		
		pCurrent( ... );
	end

	addEventHandler( self.m_sServerClient, root, ClientCall );
end