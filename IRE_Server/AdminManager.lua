-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. AdminManager
{
	static
	{
		SetAdminDuty	= function( player, enabled )
			local char = player.Character;
			
			player.SetAdminDuty( enabled );
			
			if char and char.GetAlcohol() > 0 then
				char.SetAlcohol();
			end
			
			AdminManager.SendMessage( player.UserName + ( player.IsAdmin and " перешёл в режим" or " вышел из режима" ) + " администратора" );
			
			if not Server.DB.Query( "UPDATE uac_users SET adminduty = %q WHERE id = " + player.UserID, player.IsAdmin and "Yes" or "No" ) then
				Debug( Server.DB.Error(), 1 );
			end
		end;
		
		GetOnline		= function()
			local onlineAdmins	= {};
			
			for _, player in pairs( Server.Game.PlayerManager.GetAll() ) do
				local groups = player.GetGroups();
				
				if groups and groups[ 1 ] then
					onlineAdmins[ player.UserName ] = player;
				end
			end
			
			return onlineAdmins;
		end;
		
		GetList			= function()
			local list	= {};
			
			local result = Server.DB.Query( "SELECT \
				u.id, u.admin_id, u.name, GROUP_CONCAT( g.name ORDER BY u.groups ASC SEPARATOR ', ' ) AS 'groups' \
				FROM uac_users u \
				LEFT JOIN uac_groups g ON FIND_IN_SET( g.id, u.groups ) \
				WHERE u.groups IS NOT NULL \
				GROUP BY u.id ORDER BY u.groups" 
			);
			
			if result then
				for i, row in ipairs( result.GetArray() ) do
					list[ row.id ] = row;
				end
				
				result.Free();
			else
				Debug( Server.DB.Error(), 1 );
			end
			
			return list;
		end;
		
		SendMessage		= function( message, prefix, r, g, b )
			prefix = type( prefix ) == "string" and prefix or "*Admins: ";
			
			r = r or 255;
			g = g or 64;
			b = b or 0;
			
			for _, player in pairs( Server.Game.PlayerManager.GetAll() ) do
				if player.HaveAccess( "command.adminchat" ) then
					player.Chat.Send( prefix + message, r, g, b );
				end
			end
			
			Console.Log( prefix + ( message:gsub( "%%", "%%%%" ) ) );
		end;
	};
};