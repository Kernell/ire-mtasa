-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. RPC
{
	LastTick			= 300;
	
	static
	{
		PACKET_TIME_LIMIT	= 300; -- ms
		
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
	
	RPC	= function( serverID, clientID )
		this.ServerID	= serverID;
		this.ClientID	= clientID;
		
		this.QueryHandlers	= {};
		
		this.Server2ClientName	= "ClientRPC::" + this.ServerID + "2" + this.ClientID;
		this.Client2ServerName	= "ClientRPC::" + this.ClientID + "2" + this.ServerID;
		
		this.Server2Client	= function( namespace, ... )
			if namespace[ 1 ] == "NULL" then
				local args = { ... };
				
				local statusCode, id, result = unpack( args );
				
				local query	= this.QueryHandlers[ id ];
				
				if query then
					query.Result 		= result;
					query.StatusCode 	= statusCode;
					
					if isTimer( query.Timeout ) then
						killTimer( query.Timeout );
					end
					
					if query.Coroutine then
						coroutine.resume( query.Coroutine );
					end
				end
				
				return;
			end
			
			local current	= _G;
			
			for i, name in ipairs( namespace ) do
				if current[ name ] then
					current	= current[ name ];
				else
					error( "attempt to index '" + name + "'" );
				end
			end
			
			current( ... );
		end
		
		addEvent( this.Server2ClientName, true );

		addEventHandler( this.Server2ClientName, root, this.Server2Client );
		
		_G.SERVER =
		{
			__index	= function( ttt, key )
				return function( ... )
					local tick		= getTickCount();
					local tickDiff	= tick - this.LastTick;
					
					if tickDiff < RPC.PACKET_TIME_LIMIT then
						Warning( 2, 1000, (string)(key), tickDiff );
						
						return;
					end
					
					this.LastTick = tick;
					
					local id = key + (string)(tick);
					
					return this.Query( id, key, ... );
				end
			end;
		};
		
		setmetatable( _G.SERVER, _G.SERVER );
	end;
	
	Timeout	= function( id )
		local query	= this.QueryHandlers[ id ];
		
		if query then
			query.Result		= RPC[ 408 ];
			query.StatusCode	= 408;
			
			if query.Coroutine then
				coroutine.resume( query.Coroutine );
			end
		end
	end;
	
	Query	= function( id, key, ... )
		local cr = coroutine.running();
		
		local timer = setTimer( function() this.Timeout( id ) end, 5000, 1 );
		
		this.QueryHandlers[ id ] =
		{
			ID			= id;
			Function	= key;
			Coroutine	= cr;
			Timeout		= timer;
		};
		
		triggerServerEvent( this.Client2ServerName, CLIENT, { ID = id, Function = key }, ... );
		
		coroutine.yield();
		
		local result = this.QueryHandlers[ id ].Result;
		
		this.QueryHandlers[ id ] = NULL;
		
		return result;
	end;
}
