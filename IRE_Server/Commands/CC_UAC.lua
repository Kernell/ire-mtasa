-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. CC_UAC : IConsoleCommand
{
	CC_UAC	= function( ... )
		this.IConsoleCommand( ... );	
	end;
	
	Execute		= function( player, option, ... )
		if option == "adduser" or option == "useradd" then
			local login = ( { ... } )[ 1 ];
			
			if login and login:len() > 0 and login ~= "-h" and login ~= "--help" then
				local password	= NULL;
				local name		= login;
				local groups	= NULL;
				local flags		= { ... };
				
				table.remove( flags, 1 );
				
				if table.getn( flags ) > 0 then
					local i, f = next( flags );
					
					while i do
						local ii, ff = next( flags, i );
						
						if ff == NULL or ii == NULL or ff[ 1 ] == '-' then
							return "Syntax: /" + this.Name + " " + option + " <login> " + f + " <value> [flags...]", 255, 0, 0;
						end
						
						if 		f == '-p' or f == '--password' then
							i, password		= next( flags, i );
						elseif	f == '-n' or f == '--name' then
							i, name			= next( flags, i );
						elseif  f == '-g' or f == '--groups' then
							i, groups		= next( flags, i );
						else
							return "Неизвестный флаг '" + f + "'", 255, 0, 0;
						end
						
						i, f = next( flags, i );
					end
				end
				
				local result = Server.DB.Query( "SELECT id FROM `uac_users` WHERE `login` = %q OR `name` = %q", login, name );
				
				if result then
					if result.NumRows() == 0 then
						delete ( result );
						
						local groupNames	= {};
						local groupList		= {};
						
						if groups then
							for i, void in ipairs( groups:split( ',' ) ) do
								local group = Server.Game.GroupManager.Get( tonumber( void ) or void );
								
								if not group then
									return "Неизвестная группа " + (string)(void), 255, 0, 0;
								end
								
								table.insert( groupNames, group.GetName() );
								table.insert( groupList, group.GetID() );
							end
						end
						
						local userID = Server.DB.Insert( "uac_users",
							{
								login		= login;
								password	= password and Server.Blowfish.Encrypt( password ) or "";
								name		= name;
								groups		= table.concat( groupList, "," );
							}
						);
						
						if userID then
							local groupNames = table.getn( groupNames ) > 0 and ( " (" + table.concat( groupNames, ',' ) + ")" ) or "";
							
							Console.Log( "UAC: %s added new user %q (%s) (ID: %d, Password: %s, Groups: %s)", player.UserName, name, login, userID, password or "", groupNames );
							
							return "Пользователь " + name + " (ID: " + userID + ", Login: " + login + ") успешно добавлен", 0, 255, 0;
						end
						
						Debug( Server.DB.Error(), 1 );
						
						return TEXT_DB_ERROR, 255, 0, 0;
					end
					
					delete ( result );
					
					return "Логин/Имя уже используются", 255, 0, 0;
				end
				
				Debug( Server.DB.Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return "Syntax: /" + this.Name + " " + option + " <login> [option]", 200, 200, 200;
		end
		
		if option == "usermod" then
			local Argv = { ... };
			
			if table.getn( Argv ) > 0 and Argv[ 1 ] ~= "-h" and Argv[ 1 ] ~= "--help" then
				local login = Argv[ table.getn( Argv ) ];
				
				table.remove( Argv );
				
				if login and table.getn( Argv ) > 0 then
					local iID = NULL;
					
					local result = Server.DB.Query( "SELECT id FROM uac_users WHERE login = %q", login );
					
					if result then
						local row = result.GetRow();
						
						result.Free();
						
						iID = row and row.id;				
						
						if not iID then
							return "Игрок с логином " + login + " не найден", 255, 0, 0;
						end
					else
						Debug( Server.DB.Error() );
						
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
							return "Syntax: /" + this.Name + " " + option + " " + f + " <value> [flags...] " + login, 255, 0, 0;
						end
						
						i, f = next( Argv, i );
					end
					
					local pTargetPlayer = NULL;
					
					for i, p in pairs( Server.Game.PlayerManager.GetAll() ) do
						if p.IsLoggedIn() and p.UserID == iID then
							pTargetPlayer = p;
							
							break;
						end
					end
					
					local Updates = {};
					
					if sNewPasswd then
						table.insert( Updates, "password = '" + Server.Blowfish.Encrypt( sNewPasswd ) + "'" );
					end
					
					if sNewEmail then
						local result = Server.DB.Query( "SELECT id FROM uac_users WHERE login = %q", sNewEmail );
						
						if result then
							if result.NumRows() > 0 then
								result.Free();
								
								return "E-mail \"" + sNewEmail + "\" уже занят!", 255, 0, 0;
							end
							
							result.Free();
						else
							Debug( Server.DB.Error() );
							
							return TEXT_DB_ERROR, 255, 0, 0;
						end
						
						table.insert( Updates, "login = '" + sNewEmail + "'" );
					end
					
					if sNewName then
						local result = Server.DB.Query( "SELECT id FROM uac_users WHERE name = %q", sNewName );
						
						if result then
							if result.NumRows() > 0 then
								result.Free();
								
								return "Пользователь с именем \"" + sNewName + "\" уже существует", 255, 0, 0;
							end
							
							result.Free();
						else
							Debug( Server.DB.Error() );
							
							return TEXT_DB_ERROR, 255, 0, 0;
						end
						
						table.insert( Updates, "name = '" + sNewName + "'" );
					end
					
					if sNewGroups then
						local Groups = {};
						
						for i, void in ipairs( sNewGroups:split( ',' ) ) do
							local group = Server.Game.GroupManager.Get( tonumber( void ) or void );
							
							if not group then
								return "Неизвестная группа " + (string)(void), 255, 0, 0;
							end
							
							table.insert( Groups, group.GetID() );
						end
						
						table.insert( Updates, "groups = '" + table.concat( Groups, "," ) + "'" );
					end
					
					if sAdminID then
						local iAdminID = tonumber( sAdminID );
						
						if not iAdminID then
							return "Ошибка в параметре \"Личный номер администратора\"", 255, 0, 0;
						end
						
						local result = Server.DB.Query( "SELECT `id`, `name` FROM `uac_users` WHERE `admin_id` = " + iAdminID + " LIMIT 1" );
						
						if result then
							local row = result.GetRow();
							
							result.Free();
							
							if row and row.id then
								return "Этот номер администратора используется " + row.name, 255, 196, 0;
							end
						else
							Debug( Server.DB.Query(), 1 );
						end
						
						table.insert( Updates, "admin_id = " + iAdminID );
					end
					
					if table.getn( Updates ) > 0 then
						if Server.DB.Query( "UPDATE uac_users SET " + table.concat( Updates, ', ' ) + " WHERE id = " + iID ) then
							if pTargetPlayer then
								if sNewName then
									pTargetPlayer.UserName = sNewName;
									
									if pTargetPlayer.IsAdmin then
										pTargetPlayer.Nametag.Update();
									end
								end
									
								pTargetPlayer.InitGroups( false, false );
							end
						else
							Debug( Server.DB.Error(), 1 );
						end
					end
					
					Console.Log( "UAC: %s: %s %s", player.UserName, option, table.concat( { ... }, ' ' ) );
					
					return true;
				end
			end
			
			return "Syntax: /" + this.Name + " " + option + " [flags] <login>", 200, 200, 200;
		end
		
		if option == "userdel" then
			local login = ( { ... } )[ 1 ];
			
			if login and login:len() > 0 and login ~= "-h" and login ~= "--help" then
				local iID = NULL;
				
				local result = Server.DB.Query( "SELECT id FROM uac_users WHERE login = %q", login );
				
				if result then
					local row = result.GetRow();
					
					result.Free();
					
					iID = row and row.id;				
					
					if not iID then
						return "Игрок с логином " + login + " не найден", 255, 0, 0;
					end
				else
					Debug( Server.DB.Error() );
					
					return TEXT_DB_ERROR, 255, 0, 0;
				end
				
				local chars		= false;
				
				local flags		= { ... };
				
				table.remove( flags, 1 );
				
				local i, f = next( flags );
				
				if table.getn( flags ) > 0 then
					while i do				
						if 		f == '-c' or f == '--chars'	then
							chars		= true;
						else
							return "Неизвестный флаг '" + f + "'", 255, 0, 0;
						end
						
						i, f = next( flags, i );
					end
				end
				
				local pTargetPlayer = NULL;
				
				for i, p in pairs( Server.Game.PlayerManager.GetAll() ) do
					if p.IsLoggedIn() and p.UserID == iID then
						pTargetPlayer = p;
						
						break;
					end
				end
				
				if Server.DB.Query( "UPDATE uac_users SET deleted = 'Yes' WEHRE id = " + iID ) then
					if pTargetPlayer then
						pTargetPlayer.Kick( "Ваш аккаунт был удалён" );
					end
					
					if chars then
						if not Server.DB.Query( "UPDATE " + Server.DB.Prefix + "characters SET status = 'Скрыт' WHERE user_id = " + iID ) then
							Debug( Server.DB.Error(), 1 );
							
							player.Chat.Send( "Ошибка при удалении персонажей: " + TEXT_DB_ERROR, 255, 0, 0 );
						end
					end
					
					Console.Log( "UAC: %s: %s %s", player.UserName, option, table.concat( { ... }, ' ' ) );
					
					return "Пользователь '" + login + "' удалён", 255, 128, 0;
				end
				
				Debug( Server.DB.Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return "Syntax: /" + this.Name + " " + option + " <login> [flags]", 200, 200, 200;
		end
		
		if option == "addgroup" then
			local args = { ... };
			
			local name		= args[ 1 ];
			local caption	= args[ 2 ];
			
			table.remove( args, 1 );
			table.remove( args, 2 );
			
			if name and name:len() > 0 and caption and caption:len() > 0 and name ~= "-h" and name ~= "--help" then
				local name		= Server.DB.EscapeString( name );
				local caption	= Server.DB.EscapeString( caption );
				local color		= { 255, 255, 255 };
				local flags		= args;
				
				if table.getn( flags ) > 0 then
					local i, f = next( flags );
						
					while i do
						local value;
						
						i, value 	= next( flags, i );
						
						if f == '-c' or f == '--color'	then
							color	= value:split( ',' );
							
							if table.getn( color ) == 3 then
								color[ 1 ] = (int)(color[ 1 ]) % 255;
								color[ 2 ] = (int)(color[ 2 ]) % 255;
								color[ 3 ] = (int)(color[ 3 ]) % 255;
							else
								return "Не правильно задан формат цвета", 255, 0, 0;
							end
						else
							return "Неизвестный флаг '" + f + "'", 255, 0, 0;
						end
						
						if value == NULL or i == NULL or value[ 1 ] == '-' then
							return "Syntax: /" + this.Name + " " + option + " " + name + " " + caption + " " + f + " <value> [flags...]", 255, 0, 0;
						end
						
						i, f = next( flags, i );
					end
				end
				
				if name and caption then
					local result = g_pDB:Query( "SELECT id FROM uac_groups WHERE name = %q or caption = %q", name, caption );
					
					if result then
						if result.NumRows() > 0 then
							result.Free();
							
							return "Группа с таким названием уже существует", 255, 0, 0;
						end
						
						result.Free();
					else
						Debug( Server.DB.Error(), 1 );
						
						return TEXT_DB_ERROR, 255, 0, 0;
					end
					
					if Server.DB.Query( "INSERT INTO uac_groups (name, caption, color) VALUES (%q, %q, '" + toJSON( color ) + "')", name, caption ) then
						local ID = Server.DB.InsertID();
						
						if ID then
							Server.Game.GroupManager.Init( ID, name, caption, color );
							
							g_pServer:Print( "UAC: %s added new group %q %q %s ID: %d", pPlayer:GetUserName(), name, caption, table.concat( flags, " " ), ID );
							
							return "Группа '" + name + "' успешно добавлена, ID: " + ID, 0, 255, 0;
						end
						
						return TEXT_DB_ERROR, 255, 0, 0;
					end
					
					Debug( Server.DB.Error(), 1 );
					
					return TEXT_DB_ERROR, 255, 0, 0;
				end
			end
			
			return "Syntax: /" + this.Name + " " + option + " <name> <caption> [flags]", 200, 200, 200;
		end
		
		return this.Info();
	end;
	
	Info		= function()
		
	end;
};