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
		
		return this.Info();
	end;
	
	Info		= function()
		
	end;
};