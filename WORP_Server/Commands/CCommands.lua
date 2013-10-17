-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CCommands"

function CCommands:Test1( pPlayer, sCmd, iCount )
	iCount = iCount or 1;
	
	local iTick	= getTickCount();
	
	for i = 1, iCount do
		local vResult = CClientRPC.Character__Create( pPlayer, "Delete", "Mee", 123, 1990, 1, 1, 1, true );
		
		if vResult and vResult ~= true then
			return vResult;
		end
	end
	
	return ( "CClientRPC::Character__Create - %d leaps | %d ms" ):format( iCount, getTickCount() - iTick ), 255, 255, 255;
end

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
		pPlayer:GetChat():Send( "Список администраторов в сети", 255, 255, 0 );
		
		for _, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
			local Groups = pPlr:GetGroups();
			
			if Groups and Groups[ 1 ] then
				local iR, iG, iB	= 200, 200, 200;
				local sGroups		= "";
				local sIP			= pPlr:GetIP();
				
				for i, pGrp in ipairs( Groups ) do
					if i > 1 then
						sGroups = ", ";
					end
					
					sGroups = sGroups + pGrp:GetName();
					
					if pGrp:GetID() == 0 then
						sIP = NULL;
					end
				end
				
				if pPlr:IsAdmin() then
					iR, iG, iB = unpack( Groups[ 1 ]:GetColor() );
				end
				
				pPlayer:GetChat():Send( "   " + pPlr:GetUserName() + " (" + pPlr:GetID() + ") IP: " + ( sIP or "Скрыт" ) + " Группы: " + sGroups, iR, iG, iB );
			end
		end
	end
end

function CCommands:AdminDuty( pPlayer )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		pPlayer.m_bAdmin = not pPlayer.m_bAdmin;
		
		pPlayer:SetData( "adminduty", 		pPlayer.m_bAdmin );
		pPlayer:SetData( "nametag_color",	pPlayer.m_bAdmin and pPlayer:GetGroups()[ 1 ]:GetColor() );
		pPlayer:SetGhost( pPlayer.m_bAdmin );
		
		if pChar and pChar:GetAlcohol() > 0 then
			pChar:SetAlcohol();
		end
		
		SendAdminsMessage( pPlayer:GetUserName() + ( pPlayer:IsAdmin() and " перешёл в режим" or " вышел из режима" ) + " администратора" );
		
		pPlayer:GetNametag():Update();
		
		assert( g_pDB:Query( "UPDATE uac_users SET adminduty = %q WHERE id = " + pPlayer:GetUserID(), pPlayer:IsAdmin() and 'Yes' or 'No' ) );
	end
end

function CCommands:AnswerReport( pPlayer, sCmd, sID, ... )
	local iID		= tonumber( sID );
	local sMessage	= table.concat( { ... }, ' ' );
	
	if iID and sMessage:len() > 0 then
		local pTarget = g_pGame:GetPlayerManager():Get( sID );
		
		if pTarget then
			local ReportData = pTarget.m_ReportData;
			
			if ReportData.m_sText then
				outputChatBox( "[REPORT]: " + ReportData.m_sText, root, 0, 128, 255 );
				outputChatBox( pPlayer:GetUserName() + ": " + sMessage, root, 0, 156, 255 );
				
				ReportData.m_sText = NULL;
			else
				self:Echo( pPlayer, "этот игрок не отправлял жалобу" );
			end
		else
			self:Echo( pPlayer, TEXT_PLAYERS_INVALID_ID );
		end
	else
		self:Echo( pPlayer, "<player> <message>" );
	end
end

function CCommands:AdminChat( pPlayer, sCmd, ... )
	local sMessage = table.concat( { ... }, ' ' );
	
	if sMessage:len() > 0 then
		sMessage = pPlayer:GetUserName() + " (" + pPlayer:GetID() + "): " + sMessage;
		
		local Groups = pPlayer:GetGroups();
		
		if Groups and table.getn( Groups ) > 0 then
			sMessage = Groups[1]:GetCaption() + " " + sMessage;
		end
		
		SendAdminsMessage( sMessage, '', 230, 230, 0 );
		
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
			pPlayer:GetChat():Send( 'PM to ' + pTargetPlayer:GetName() + ' (' + pTargetPlayer:GetID() + '): ' + sMessage, 200, 0, 0 );
			pTargetPlayer:GetChat():Send( 'PM from ' + pPlayer:GetUserName() + ': ' + sMessage, 200, 0, 0 );
			
			g_pServer:Print( 'PM: %s -> %s (%d): %s', pTargetPlayer:GetUserName(), pTargetPlayer:GetName(), pTargetPlayer:GetID(), sMessage:gsub( '%%', '%%%%' ) );
			
			return true;
		end

		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	return "<player> <text>", 255, 255, 255;
end