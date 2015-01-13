-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

addEvent( "executeCommandHandler", true );

MSG_TYPE_NONE		= 0;
MSG_TYPE_ERROR		= 1;
MSG_TYPE_WARNING	= 2;
MSG_TYPE_SUCCESS	= 3;
MSG_TYPE_INFO		= 4;

function SendClientMessage( pClient, sMessage, iType )
	local sColor	= "";
	
	if iType == MSG_TYPE_ERROR then
		sColor = "#FF0000";
	elseif iType == MSG_TYPE_WARNING then
		sColor = "#FF8000";
	elseif iType == MSG_TYPE_SUCCESS then
		sColor = "#00FF00";
	elseif iType == MSG_TYPE_INFO then
		sColor = "#0080FF";
	end
	
	triggerClientEvent( "Console::StdOut", pClient, sColor + sMessage );
end

function CheckClientAccess( pClient, sCmd )
	if not hasObjectPermissionTo( pClient, "command." + sCmd ) then
		SendClientMessage( pClient, "#FFA400ACL: Access denied for '" + sCmd + "'", MSG_TYPE_ERROR );
		outputServerLog( "DENIED: Denied '" + getPlayerName( pClient ) + "' access to command '" + sCmd + "'" );
		
		return false;
	end
	
	return true;
end

MTAServerCommands	=
{
	start			= function( pClient, sCmd, sResource )
		if type( sResource ) == "string" and sResource:len() > 0 then
			local pResource = getResourceFromName( sResource );
			
			if pResource then			
				if startResource( pResource ) then
					SendClientMessage( pClient, ( "#AAAAAAStarting %-34s [#00FF00  OK#AAAAAA  ]" ):format( sResource + ":" ) );
				else
					SendClientMessage( pClient, ( "#AAAAAAStarting %-34s [#FF0000FAILED#AAAAAA]" ):format( sResource + ":" ) );
				end
			else
				SendClientMessage( pClient, "Resource could not be found", MSG_TYPE_ERROR );
			end
			
			return true;
		end
		
		return "resource-name";
	end;
	
	stop			= function( pClient, sCmd, sResource )
		if type( sResource ) == "string" and sResource:len() > 0 then
			local pResource = getResourceFromName( sResource );
			
			if pResource then
				if stopResource( pResource ) then
					SendClientMessage( pClient, ( "#AAAAAAStopping %-34s [#00FF00  OK#AAAAAA  ]" ):format( sResource + ":" ) );
				else
					SendClientMessage( pClient, ( "#AAAAAAStopping %-34s [#FF0000FAILED#AAAAAA]" ):format( sResource + ":" ) );
				end
			else
				SendClientMessage( pClient, "Resource could not be found", MSG_TYPE_ERROR );
			end
			
			return true;
		end
		
		return "resource-name";
	end;
	
	restart			= function( pClient, sCmd, sResource )
		if type( sResource ) == "string" and sResource:len() > 0 then
			local pResource = getResourceFromName( sResource );
			
			if pResource then
				SendClientMessage( pClient, ( "#AAAAAAStopping %-34s [#00FF00  OK#AAAAAA  ]" ):format( sResource + ":" ) );
				
				if restartResource( pResource ) then
					SendClientMessage( pClient, ( "#AAAAAAStarting %-34s [#00FF00  OK#AAAAAA  ]" ):format( sResource + ":" ) );
				else
					SendClientMessage( pClient, ( "#AAAAAAStarting %-34s [#FF0000FAILED#AAAAAA]" ):format( sResource + ":" ) );
				end
			else
				SendClientMessage( pClient, "Resource could not be found", MSG_TYPE_ERROR );
			end
			
			return true;
		end
		
		return "resource-name";
	end;
	
	shutdown	= function( pClient, sCmd )
		shutdown( "" );
	end;
	
	refresh		= function( pClient, sCmd )
		if refreshResources() then
		
		end
		
		return true;
	end;
	
	refreshall	= function( pClient, sCmd )
		if refreshResources( true ) then
		
		end
		
		return true;
	end;
};

function ExecuteCommandHandler( sText )
	local Arguments = sText:split( " " );
	
	local sCmd	= Arguments[ 1 ];
	
	if MTAServerCommands[ sCmd ] then
		if not CheckClientAccess( client, sCmd ) then
			return;
		end
		
		local vResult = MTAServerCommands[ sCmd ]( client, unpack( Arguments ) );
		
		if type( vResult ) == "string" then
			SendClientMessage( client, "* Syntax: " + sCmd + " <" + vResult + ">", MSG_TYPE_INFO );
		end
		
		return;
	end
	
	if sCmd == "say" then
		triggerEvent( "onPlayerChat", client, table.concat( Arguments, "", 2 ), 0 );
		
		return;
	elseif sCmd == "me" then
		triggerEvent( "onPlayerChat", client, table.concat( Arguments, "", 2 ), 1 );
		
		return;
	elseif sCmd == "teamsay" then
		triggerEvent( "onPlayerChat", client, table.concat( Arguments, "", 2 ), 2 );
		
		return;
	end
	
	if table.getn( Arguments ) > 0 then
		local bResult = executeCommandHandler( sCmd, client, table.concat( Arguments, " ", 2 ) );
		
		if not bResult then
			SendClientMessage( client, sCmd + ": command not found", MSG_TYPE_ERROR );
		end
	end
end

addEventHandler( "executeCommandHandler", root, 
	function( sText )
		ExecuteCommandHandler( sText );
		
		triggerClientEvent( "Console::Return", client );
	end
);