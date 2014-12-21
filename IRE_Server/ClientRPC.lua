-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. ClientRPC
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
	
	ClientRPC	= function( serverID, clientID )
		this.ServerID	= serverID;
		this.ClientID	= clientID;
		
		this.Server2ClientName	= "ClientRPC::" + this.ServerID + "2" + this.ClientID;
		this.Client2ServerName	= "ClientRPC::" + this.ClientID + "2" + this.ServerID;
		
		this.QueryHandlers	= {};
		
		this.Client2Server = function( data, ... )
			if not client or not client.IsValid() or type( data ) ~= "table" then
				return;
			end
			
			if data.Function == NULL and data.ID then
				local handle = this.QueryHandlers[ data.ID ];
				
				if handle then
					handle.Receive( ... );
				end
				
				return;
			end
			
			local vResult = ClientRPC.ClientHandle( client, data, ... );
			
			if data.ID then
				client.RPC.NULL( vResult and ClientRPC.OK or ClientRPC.NOT_FOUND, data.ID, vResult );
			end
		end;
		
		addEvent( this.Client2ServerName, true );
		
		addEventHandler( this.Client2ServerName, root, this.Client2Server );
	end;
	
	Timeout	= function( id )
		local handler	= this.QueryHandlers[ id ];
		
		if handler then
			handler.Result		= RPC[ 408 ];
			handler.StatusCode	= 408;
			
			if handler.Coroutine then
				coroutine.resume( handler.Coroutine );
			end
		end
	end;
	
	CreateThread	= function( id, cr )
		local timer = setTimer( function() this.Timeout( id ) end, 5000, 1 );
		
		this.QueryHandlers[ id ] =
		{
			ID			= id;
			Coroutine	= cr;
			Timeout		= timer;
			
			Call		= function( client, namespace, ... )
				return triggerClientEvent( client, this.Server2ClientName, client, { ID = id, Namespace = namespace; }, ... );
			end;
			
			Receive		= function( result, statusCode )
				local handle = this.QueryHandlers[ id ];
				
				handle.Result		= result;
				handle.StatusCode 	= statusCode;
				handle.StatusText 	= ClientRPC[ statusCode ];
				
				if isTimer( handle.Timeout ) then
					killTimer( handle.Timeout );
				end
				
				if handle.Coroutine then
					coroutine.resume( handle.Coroutine );
				end
			end;
			
			Destroy		= function()
				this.QueryHandlers[ id ] = NULL;
			end;
		};
		
		return this.QueryHandlers[ id ];
	end;
	
	ClientHandle	= function( client, data, ... )
		if data.Function == "BankManager" then
			return Server.Game.BankManager.ClientHandle( client, ... );
		elseif data.Function == "FactionManager" then
			return Server.Game.FactionManager.ClientHandle( client, ... );
		elseif data.Function == "NPCManager" then
			return Server.Game.NPCManager.ClientHandle( client, ... );
		elseif data.Function == "PlayerManager" then
			return Server.Game.PlayerManager.ClientHandle( client, ... );
		else
			Debug( 'RPC - ' + (string)(client.GetName()) + ' (' + (string)(client.GetID()) + ') called undefined function "' + (string)(data.Function) + '"', 1 );
		end
		
		return NULL;
	end;
}
