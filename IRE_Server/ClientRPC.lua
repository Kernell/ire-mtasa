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
	};
	
	ClientRPC	= function( serverID, clientID )
		this.ServerID	= serverID;
		this.ClientID	= clientID;
		
		this.Server2ClientName	= "ClientRPC::" + this.ServerID + "2" + this.ClientID;
		this.Client2ServerName	= "ClientRPC::" + this.ClientID + "2" + this.ServerID;
		
		this.Client2Server = function( data, ... )
			if not client or not client.IsValid() or type( data ) ~= "table" then
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
