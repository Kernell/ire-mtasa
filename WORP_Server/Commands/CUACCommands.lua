-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CUACCommands"

function CUACCommands:AddUser( pPlayer, sCmd, sOption, sEmail, ... )
	if sEmail and sEmail:len() > 0 and sEmail ~= '-h' and sEmail ~= '--help' then
		local sPassword	= NULL;
		local sName		= sEmail;
		local sGroups	= NULL;
		local Flags		= { ... };
		
		if not CUser:IsMailValid( sEmail ) then
			return "Не корректный e-mail", 255, 0, 0;
		end
		
		if #Flags > 0 then
			local i, f = next( Flags );
			
			while i do
				local ii, ff = next( Flags, i );
				
				if ff == NULL or ii == NULL or ff[ 1 ] == '-' then
					return "Syntax: /" + sCmd + " " + sOption + " <login> " + f + " <value> [flags...]", 255, 0, 0;
				end
				
				if 		f == '-p' or f == '--password' then
					i, sPassword	= next( Flags, i );
				elseif	f == '-n' or f == '--name' then
					i, sName		= next( Flags, i );
				elseif  f == '-g' or f == '--groups' then
					i, sGroups		= next( Flags, i );
				else
					return "Неизвестный флаг '" + f + "'", 255, 0, 0;
				end
				
				i, f = next( Flags, i );
			end
		end
		
		if not CUser:IsStringValid( sName ) then
			return "Имя содержит запрещённые символы", 255, 0, 0;
		end
		
		local result = g_pDB:Query( "SELECT id FROM `uac_users` WHERE `login` = '" + sEmail + "' OR `name` = '" + sName + "'" );
		
		if result then
			if result:NumRows() == 0 then
				delete ( result );
				
				if not sPassword then
					sPassword = CUser:GeneratePassword( 8, 12, false );
				end
				
				local GroupNames	= {};
				local Groups		= {};
				
				if sGroups then
					for i, void in ipairs( sGroups:split( ',' ) ) do
						local pGroup = g_pGame:GetGroupManager():Get( tonumber( void ) or void );
						
						if not pGroup then
							return "Неизвестная группа " + (string)(void), 255, 0, 0;
						end
						
						table.insert( GroupNames, pGroup:GetName() );
						table.insert( Groups, pGroup:GetID() );
					end
				end
				
				local iID = g_pDB:Insert( "uac_users",
					{
						login		= sEmail;
						password	= g_pBlowfish:Encrypt( sPassword );
						name		= sName;
						groups		= table.concat( Groups, "," );
					}
				);
				
				if iID then
					local sGroupNames = table.getn( GroupNames ) > 0 and ( " (" + table.concat( GroupNames, ',' ) + ")" ) or "";
					
					g_pServer:Print( "UAC: %s added new user %q (ID: %d, Password: %s, Groups: %s)", pPlayer:GetUserName(), sName, iID, sPassword, sGroupNames );
					
					return "Пользователь " + sName + " успешно добавлен, ID: " + iID + ", Пароль: " + sPassword + sGroupNames, 0, 255, 0;
				end
				
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			delete ( result );
			
			return "Логин/Имя уже используются", 255, 0, 0;
		end
		
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR, 255, 0, 0;
	end
	
	return false;
end

function CUACCommands:UserMod( pPlayer, sCmd, sOption, ... )
	local Argv = { ... };
	
	if table.getn( Argv ) > 0 and Argv[ 1 ] ~= '-h' and Argv[ 1 ] ~= '--help' then
		local sEmail = Argv[ table.getn( Argv ) ];
		
		table.remove( Argv );
		
		if sEmail and table.getn( Argv ) > 0 then
			if not CUser:IsMailValid( sEmail ) then
				return "Не корректный e-mail", 255, 0, 0;
			end
			
			local iID = NULL;
			
			local result = g_pDB:Query( "SELECT id FROM uac_users WHERE login = %q", sEmail );
			
			if result then
				local row = result:FetchRow();
				
				delete ( result );
				
				iID = row and row.id;				
				
				if not iID then
					return "Игрок с логином " + sEmail + " не найден", 255, 0, 0;
				end
			else
				Debug( g_pDB:Error() );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			local sNewPasswd, sNewEmail, sNewName, sNewGroups, sAdminID;
			
			local i, f = next( Argv );
			
			while i do
				local value;
				
				i, value 	= next( Argv, i );
				
				if 		f == '-p' or f == '--password'	then sNewPasswd		= value;
				elseif 	f == '-l' or f == '--login'		then sNewEmail		= value;
				elseif 	f == '-n' or f == '--name'		then sNewName		= value;
				elseif 	f == '-g' or f == '--groups'	then sNewGroups		= value;
				elseif 	f == '-Z' or f == '--adminid'	then sAdminID		= value;
				else
					return "Неизвестный флаг '" + f + "'", 255, 0, 0;
				end
				
				if value == NULL or i == NULL or value[ 1 ] == '-' then
					return "Syntax: /" + sCmd + " " + sOption + " " + f + " <value> [flags...] " + sEmail, 255, 0, 0;
				end
				
				i, f = next( Argv, i );
			end
			
			local pTargetPlayer = NULL;
			
			for i, p in pairs( g_pGame:GetPlayerManager():GetAll() ) do
				if p:IsLoggedIn() and p:GetUserID() == iID then
					pTargetPlayer = p;
					
					break;
				end
			end
			
			local Updates = {};
			
			if sNewPasswd then
				table.insert( Updates, "password = '" + g_pBlowfish:Encrypt( sNewPasswd ) + "'" );
			end
			
			if sNewEmail then
				if not CUser:IsMailValid( sNewEmail ) then
					return "Не корректный e-mail", 255, 0, 0;
				end
				
				local pResult = g_pDB:Query( "SELECT id FROM uac_users WHERE login = %q", sNewEmail );
				
				if pResult then
					if pResult:NumRows() > 0 then
						delete ( pResult );
						
						return "E-mail \"" + sNewEmail + "\" уже занят!", 255, 0, 0;
					end
					
					delete ( pResult );
				else
					Debug( g_pDB:Error() );
					
					return TEXT_DB_ERROR, 255, 0, 0;
				end
				
				table.insert( Updates, "login = '" + sNewEmail + "'" );
			end
			
			if sNewName then
				if not CUser:IsStringValid( sNewName ) then
					return "Имя содержит запрещённые символы", 255, 0, 0;
				end
				
				local result = g_pDB:Query( "SELECT id FROM uac_users WHERE name = %q", sNewName );
				
				if result then
					if result:NumRows() > 0 then
						delete ( result );
						
						return "Пользователь с именем \"" + sNewName + "\" уже существует", 255, 0, 0;
					end
					
					delete ( result );
				else
					Debug( g_pDB:Error() );
					
					return TEXT_DB_ERROR, 255, 0, 0;
				end
				
				table.insert( Updates, "name = '" + sNewName + "'" );
			end
			
			if sNewGroups then
				local Groups = {};
				
				for i, void in ipairs( sNewGroups:split( ',' ) ) do
					local pGroup = g_pGame:GetGroupManager():Get( tonumber( void ) or void );
					
					if not pGroup then
						return "Неизвестная группа " + (string)(void), 255, 0, 0;
					end
					
					table.insert( Groups, pGroup:GetID() );
				end
				
				table.insert( Updates, "groups = '" + table.concat( Groups, "," ) + "'" );
			end
			
			if sAdminID then
				local iAdminID = tonumber( sAdminID );
				
				if not iAdminID then
					return "Ошибка в параметре \"Личный номер администратора\"", 255, 0, 0;
				end
				
				local pResult = g_pDB:Query( "SELECT `id`, `name` FROM `uac_users` WHERE `admin_id` = " + iAdminID + " LIMIT 1" );
				
				if pResult then
					local pRow = pResult:FetchRow();
					
					if pRow and pRow.id then
						self:GetChat():Send( "Внимание: этот номер администратора используется " + pRow.name, 255, 196, 0 );
					end
					
					delete ( pResult );
				else
					Debug( g_pDB:Query(), 1 );
				end
				
				table.insert( Updates, "admin_id = " + iAdminID );
			end
			
			if table.getn( Updates ) > 0 then
				if g_pDB:Query( "UPDATE uac_users SET " + table.concat( Updates, ', ' ) + " WHERE id = " + iID ) then
					if pTargetPlayer then
						if sNewName then
							pTargetPlayer.m_sUserName = sNewName;
							
							if pTargetPlayer:IsAdmin() then
								pTargetPlayer:GetNametag():Update();
							end
						end
							
						pTargetPlayer:InitGroups( false, false );
					end
				else
					Debug( g_pDB:Error(), 1 );
				end
			end
			
			g_pServer:Print( "UAC: %s: %s %s", pPlayer:GetUserName(), sOption, table.concat( { ... }, ' ' ) );
			
			return true;
		end
	end
	
	return false;
end

function CUACCommands:UserDel( pPlayer, sCmd, sOption, sEmail, ... )
	if sEmail and sEmail:len() > 0 and sEmail ~= '-h' and sEmail ~= '--help' then
		if not CUser:IsMailValid( sEmail ) then
			return "Не корректный e-mail", 255, 0, 0;
		end
		
		local iID = NULL;
		
		local result = g_pDB:Query( "SELECT id FROM uac_users WHERE login = %q", sEmail );
		
		if result then
			local row = result:FetchRow();
			
			delete ( result );
			
			iID = row and row.id;				
			
			if not iID then
				return "Игрок с логином " + sEmail + " не найден", 255, 0, 0;
			end
		else
			Debug( g_pDB:Error() );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		local bChars	= false;
		
		local Flags		= { ... };
		
		local i, f = next( Flags );
		
		if table.getn( Flags ) > 0 then
			while i do				
				if 		f == '-c' or f == '--chars'	then bChars		= true;
				else
					return "Неизвестный флаг '" + f + "'", 255, 0, 0;
				end
				
				i, f = next( Flags, i );
			end
		end
		
		local pTargetPlayer = NULL;
		
		for i, p in pairs( g_pGame:GetPlayerManager():GetAll() ) do
			if p:IsLoggedIn() and p:GetUserID() == iID then
				pTargetPlayer = p;
				
				break;
			end
		end
		
		g_pDB:StartTransaction();
		
		if g_pDB:qeury( "UPDATE uac_users SET deleted = 'Yes' WEHRE id = " + iID ) then
			if pTargetPlayer then
				pTargetPlayer:Kick( "Ваш аккаунт был удалён" );
			end
			
			if bChars then
				if not g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET status = 'Скрыт' WHERE user_id = " + iID ) then
					Debug( g_pDB:Error(), 1 );
					
					pPlayer:GetChat():Send( "Ошибка при удаленни персонажей: " + TEXT_DB_ERROR, 255, 0, 0 );
				end
			end
			
			g_pServer:Print( "UAC: %s: %s %s", pPlayer:GetUserName(), sOption, table.concat( { ... }, ' ' ) );
			
			g_pDB:Commit();
			
			return "Пользователь '" + sEmail + "' удалён", 255, 128, 0;
		else
			g_pDB:Commit();
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
	end
	
	return false;
end

function CUACCommands:AddGroup( pPlayer, sCmd, sOption, sName, sCaption, ... )
	if sName and sName:len() > 0 and sCaption and sCaption:len() > 0 and sName ~= '-h' and sName ~= '--help' then
		local sName		= g_pDB:EscapeString( sName );
		local sCaption	= g_pDB:EscapeString( sCaption );
		local Color		= { 255, 255, 255 };
		
		if table.getn( Flags ) > 0 then
			local i, f = next( Flags );
				
			while i do
				local value;
				
				i, value 	= next( Flags, i );
				
				if f == '-c' or f == '--color'	then
					Color	= value:split( ',' );
					
					if table.getn( Color ) == 3 then
						Color[ 1 ] = (int)(Color[ 1 ]) % 255;
						Color[ 2 ] = (int)(Color[ 2 ]) % 255;
						Color[ 3 ] = (int)(Color[ 3 ]) % 255;
					else
						return "Не правильно задан формат цвета", 255, 0, 0;
					end
				else
					return "Неизвестный флаг '" + f + "'", 255, 0, 0;
				end
				
				if value == NULL or i == NULL or value[ 1 ] == '-' then
					return "Syntax: /" + sCmd + " " + sOption + " " + sName + " " + sCaption + " " + f + " <value> [flags...]", 255, 0, 0;
				end
				
				i, f = next( Flags, i );
			end
		end
		
		if sName and sCaption then
			local result = g_pDB:Query( "SELECT id FROM uac_groups WHERE name = %q or caption = %q", sName, sCaption );
			
			if result then
				if result:NumRows() > 0 then
					delete ( result );
					
					return "Группа с таким названием уже существует", 255, 0, 0;
				end
				
				delete ( result );
			else
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			if g_pDB:Query( "INSERT INTO uac_groups (name, caption, color) VALUES (%q, %q, '" + toJSON( Color ) + "')", sName, sCaption ) then
				local iID = g_pDB:InsertID();
				
				if iID then
					g_pGame:GetGroupManager():Init( iID, sName, sCaption, Color );
					
					g_pServer:Print( "UAC: %s added new group %q %q %s ID: %d", pPlayer:GetUserName(), sName, sCaption, table.concat( { Flags }, ' ' ), iID );
					
					return "Группа '" + sName + "' успешно добавлена, ID: " + iID, 0, 255, 0;
				end
				
				return TEXT_DB_ERROR, 255, 0, 0;
			else
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
		end
	end
	
	return false;
end

function CUACCommands:GroupMod( pPlayer, sCmd, sOption, sID, ... )
	if sID then
		local pGroupManager	= g_pGame:GetGroupManager();
		local pGroup		= pGroupManager:Get( sID );
		
		if pGroup then
			
		else
			return "Группа с такими данными не найдена", 255, 0, 0;
		end
	end
	
	return false;
end

function CUACCommands:GroupDel( pPlayer, sCmd, sOption, sName, ... )
	
	return false;
end

function CUACCommands:Reload( pPlayer )
	g_pGame:GetGroupManager():DeleteAll();
	g_pGame:GetGroupManager():Init();
	
	for _, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
		pPlr:InitGroups( false, true );
	end
	
	SendAdminsMessage( pPlayer:GetUserName() + " перезагрузил привилегии" );

	return true;
end

function CUACCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end