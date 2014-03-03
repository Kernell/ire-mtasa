-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CCommands
{
	IgnoreCarKey	= function( this, pPlayer, sCommand )
		pPlayer.m_bIgnoreCarKey = not pPlayer.m_bIgnoreCarKey;
		
		return "IgnoreCarKey is " + ( pPlayer.m_bIgnoreCarKey and "enabled" or "disabled" ), 0, 200, 0;
	end;
};

function CCommands:IPSAddUser( pPlayer, sCmd, sNickname, sPassword, sEmail, sIP )
	if sNickname and sPassword and sEmail and sIP then
		if IPSMember.DB.m_pHandler then
			if IPSMember:Create(
				{
					members = 
					{
						password				= sPassword;
						name					= sNickname;
						email					= sEmail; 
						ip_address				= sIP; 
						members_display_name	= sNickname;
					};
				},
				true
			) then
				return "OK", 0, 255, 0;
			end
			
			return "Ошибка при создании учётной записи Invision Power Board.", 255, 0, 0;
		end
		
		return "IPSMember::Create - Connection with IPS database is not established", 255, 128, 0;
	end
	
	return "Syntax: /" + sCmd + " <name> <password> <email> <ip>", 255, 255, 255;
end

function CCommands:NoClip( pPlayer, sCmd, sEnabled )
	if pPlayer:IsAdmin() then
		local bHaveAccess = false;
		
		for i, pGroup in ipairs( pPlayer:GetGroups() ) do
			if pGroup:GetID() == 0 then
				bHaveAccess = true;
				
				break;
			end
		end
		
		if not bHaveAccess then
			return true;
		end
		
		local bEnabled = (bool)(sEnabled);
		
		pPlayer:Client().SetAirbrakeEnabled( bEnabled );
		
		return "noclip mode is " + ( bEnabled and "ON" or "OFF" ), 255, 255, 255;
	end
	
	return true;
end

function CCommands:Exec( pPlayer, sCmd, ... )
	if pPlayer:IsLoggedIn() then
		local bHaveAccess = false;
		
		for i, pGroup in ipairs( pPlayer:GetGroups() ) do
			if pGroup:GetID() == 0 then
				bHaveAccess = true;
				
				break;
			end
		end
		
		if not bHaveAccess then
			return true;
		end
		
		local pChat		= pPlayer:GetChat();
		local String	= table.concat( { ... }, ' ' );
		
		pChat:Send( "> " + String, 255, 200, 200 );
		
		if String[ 1 ] == '=' then
			String = String:gsub( "=", "return ", 1 );
		end
		
		local Function, Error = loadstring( "return " + String );
		
		if Error then
			Function, Error = loadstring( String );
		end
		
		if Error then
			return pChat:Send( "Error: " + Error, 255, 200, 200 );
		end
		
		local Results = { pcall( Function ) };
		
		if not Results[ 1 ] then
			return pChat:Send( "Error: " + Results[ 2 ], 255, 200, 200 );
		end
		
		local Result = {};
		
		for i = 2, table.getn( Results ) do
			local resultType = isElement( Results[ i ] ) and ( "element:" + getElementType( Results[ i ] ) ) or type( Results[ i ] );
			
			table.insert( Result, (string)( Results[ i ] ) + " [" + resultType + "]" );
		end
		
		pChat:Send( table.concat( Result, ', ' ), 255, 200, 200 );
	end
end

function CCommands:ExecClient( pPlayer, sCmd, ... )
	if pPlayer:IsLoggedIn() then
		local bHaveAccess = false;
		
		for i, pGroup in ipairs( pPlayer:GetGroups() ) do
			if pGroup:GetID() == 0 then
				bHaveAccess = true;
				
				break;
			end
		end
		
		if not bHaveAccess then
			return true;
		end
		
		local String	= table.concat( { ... }, ' ' );
		
		pPlayer:Client().CommandExec( String );
	end
end

function CCommands:Freecam( pPlayer, sCmd, sbEnabled )
	pPlayer:GetCamera():SetFreeLookEnabled( (bool)(sbEnabled) );
end

function CCommands:Admins( pPlayer )
	if pPlayer:HaveAccess( "command.adminchat" ) then
		pPlayer:GetChat():Send( "Список администраторов", 255, 128, 0 );
		
		local OnlineAdmins	= {};
		
		for _, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
			local Groups = pPlr:GetGroups();
			
			if Groups and Groups[ 1 ] then
				OnlineAdmins[ pPlr:GetUserName() ] = pPlr;
			end
		end
		
		local pResult = g_pDB:Query( "SELECT u.admin_id, u.name, GROUP_CONCAT( g.name ORDER BY u.groups ASC SEPARATOR ', ' ) AS 'groups' FROM uac_users u LEFT JOIN uac_groups g ON FIND_IN_SET( g.id, u.groups ) WHERE u.groups IS NOT NULL GROUP BY u.id ORDER BY u.groups" );
		
		local sFormat	= "%5s %s (#%d) IP: %s Группы: %s";
		
		if pResult then
			for i, pRow in ipairs( pResult:GetArray() ) do
				local iR, iG, iB	= 196, 196, 196;
				
				local pPlr	= OnlineAdmins[ pRow.name ];
				local sID	= "";
				local sIP	= "Offline";
				
				if pPlr then
					sID			= "[" + pPlr:GetID() + "]";
					sIP			= pPlr:GetIP();
					iR, iG, iB	= 196, 255, 196;
				end
				
				pPlayer:GetChat():Send( sFormat:format( sID, pRow.name, pRow.admin_id, sIP, pRow.groups ), iR, iG, iB );
			end
			
			delete ( pResult );
		else
			Debug( g_pDB:Error(), 1 );
		end
	end
end

function CCommands:AdminDuty( pPlayer )
	local pChar = pPlayer:GetChar();
	
	pPlayer:SetAdminDuty( not pPlayer.m_bAdmin );
	
	if pChar and pChar:GetAlcohol() > 0 then
		pChar:SetAlcohol();
	end
	
	SendAdminsMessage( pPlayer:GetUserName() + ( pPlayer:IsAdmin() and " перешёл в режим" or " вышел из режима" ) + " администратора" );
	
	assert( g_pDB:Query( "UPDATE uac_users SET adminduty = %q WHERE id = " + pPlayer:GetUserID(), pPlayer:IsAdmin() and "Yes" or "No" ) );
end

function CCommands:AdminChat( pPlayer, sCmd, ... )
	local sMessage = table.concat( { ... }, ' ' );
	
	if sMessage:len() > 0 then
		sMessage = pPlayer:GetUserName() + ": " + sMessage;
		
		local Groups = pPlayer:GetGroups();
		
		if Groups and table.getn( Groups ) > 0 then
			sMessage = Groups[ 1 ]:GetCaption() + " " + sMessage;
		end
		
		SendAdminsMessage( sMessage, "", 230, 230, 0 );
		
		return true;
	end
	
	return "<text>", 255, 255, 255;
end

function CCommands:DevelChat( pPlayer, sCmd, ... )
	local bDeveloper	= false;
	
	local aGroups = pPlayer:GetGroups();
	
	if aGroups then
		for i, pGrp in ipairs( aGroups ) do
			if pGrp:GetName() == "Разработчики" then
				bDeveloper = true;
				
				break;
			end
		end
	end
	
	if bDeveloper then
		local sMessage = table.concat( { ... }, ' ' );
		
		if sMessage:len() > 0 then
			sMessage = pPlayer:GetUserName() + " (" + pPlayer:GetID() + "): " + sMessage;
			
			for i, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do	
				local aGroups = pPlr:GetGroups();
				
				if aGroups then
					for i, pGrp in ipairs( aGroups ) do
						if pGrp:GetName() == "Разработчики" then
							pPlr:GetChat():Send( sMessage, 0, 200, 0 );
							
							break;
						end
					end
				end
			end
			
			return true;
		end
		
		return "<text>", 255, 255, 255;
	end
end

function CCommands:PrivateMessage( pPlayer, sCmd, sPlayer, ... )
	local sMessage = table.concat( { ... }, ' ' );
	
	if sPlayer and sMessage:len() > 0 then
		local pTargetPlayer = g_pGame:GetPlayerManager():Get( sPlayer );
		
		if pTargetPlayer then
			local sAdminName = pTargetPlayer:HaveAccess( "command.adminchat" ) and pPlayer:GetUserName() or pPlayer:GetAdminName();
			
			pPlayer:GetChat():Send( 'PM to ' + pTargetPlayer:GetName() + ' (' + pTargetPlayer:GetID() + '): ' + sMessage, 200, 0, 0 );
			pTargetPlayer:GetChat():Send( 'PM from ' + sAdminName + ': ' + sMessage, 200, 0, 0 );
			
			g_pServer:Print( 'PM: %s -> %s (%d): %s', pTargetPlayer:GetUserName(), pTargetPlayer:GetName(), pTargetPlayer:GetID(), sMessage:gsub( '%%', '%%%%' ) );
			
			return true;
		end

		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	return "<player> <text>", 255, 255, 255;
end