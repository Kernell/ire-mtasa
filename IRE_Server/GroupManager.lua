-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. GroupManager : Manager
{
	GroupManager	= function()
		this.Manager();
		
		Server.DB.CreateTable( "uac_users",
			{
				{ Field = "id", 				Type = "int(11) unsigned", 		Null = "NO", 	Key = "PRI", 	Default = false, Extra = "auto_increment" };
				{ Field = "refer_id", 			Type = "int(11) unsigned", 		Null = "NO", 	Key = "", 		Default = "0" };
				{ Field = "admin_id", 			Type = "smallint(1) unsigned", 	Null = "NO", 	Key = "", 		Default = "0" };
				{ Field = "activation_code",	Type = "varchar(32)", 			Null = "YES", 	Key = "", 		Default = NULL };
				{ Field = "login", 				Type = "varchar(255)", 			Null = "NO", 	Key = "UNI",	Default = false };
				{ Field = "password", 			Type = "varchar(255)", 			Null = "NO", 	Key = "", 		Default = false };
				{ Field = "groups", 			Type = "varchar(255)", 			Null = "YES", 	Key = "", 		Default = NULL };
				{ Field = "name", 				Type = "varchar(255)", 			Null = "NO", 	Key = "", 		Default = false };
				{ Field = "serial", 			Type = "varchar(255)", 			Null = "YES",	Key = "", 		Default = NULL };
				{ Field = "ip", 				Type = "varchar(16)", 			Null = "NO", 	Key = "", 		Default = "0.0.0.0" };
				{ Field = "serial_reg", 		Type = "varchar(255)", 			Null = "YES", 	Key = "", 		Default = NULL };
				{ Field = "ip_reg", 			Type = "varchar(16)", 			Null = "YES", 	Key = "", 		Default = NULL };
				{ Field = "last_login", 		Type = "datetime", 				Null = "NO", 	Key = "", 		Default = "0000-00-00 00:00:00" };
				{ Field = "last_logout", 		Type = "datetime", 				Null = "NO", 	Key = "", 		Default = "0000-00-00 00:00:00" };
				{ Field = "login_history", 		Type = "text",					Null = "YES",	Key = "",		Default = NULL };
				{ Field = "ban", 				Type = "enum('Yes','No')", 		Null = "NO", 	Key = "", 		Default = "No" };
				{ Field = "ban_reason", 		Type = "varchar(255)", 			Null = "YES", 	Key = "", 		Default = NULL };
				{ Field = "ban_user_id", 		Type = "int(11)", 				Null = "YES", 	Key = "", 		Default = NULL };
				{ Field = "ban_date", 			Type = "datetime", 				Null = "YES", 	Key = "", 		Default = NULL };
				{ Field = "goldpoints", 		Type = "int(20) unsigned", 		Null = "NO", 	Key = "", 		Default = 0    };
				{ Field = "muted_time", 		Type = "int(11)", 				Null = "YES", 	Key = "", 		Default = NULL };
				{ Field = "settings", 			Type = "text", 					Null = "YES", 	Key = "", 		Default = NULL };
				{ Field = "adminduty", 			Type = "enum('Yes','No')", 		Null = "NO", 	Key = "", 		Default = "No" };
				{ Field = "report_locked", 		Type = "enum('Yes','No')", 		Null = "NO", 	Key = "", 		Default = "No" };
				{ Field = "deleted", 			Type = "enum('Yes','No')", 		Null = "NO", 	Key = "", 		Default = "No" };
			}
		);
	end;

	_GroupManager	= function()
		this.DeleteAll();
	end;

	Init	= function()
		local result = Server.DB.Query( "SELECT * FROM `uac_groups` ORDER BY `id` ASC" );

		if result then
			for i, row in result.FetchRow() do
				local id		= (int)(row[ "id" ]);
				local name		= row[ "name" ];
				local caption	= row[ "caption" ];
				local color		= new. Color( unpack( fromJSON( row[ "color" ] ) ) );

				local group		= new. Group( id, name, caption, color );

				for key, value in pairs( row ) do
					if value == "Yes" then
						group.AddRight( key );
					end
				end
			end

			result.Free();
			
			return true;
		else
			Debug( Server.DB.Error(), 1 );
		end

		return false;
	end;
	
	Get	= function( str )
		if this.m_List[ str ] then
			return this.m_List[ str ];
		end
		
		for ID, group in pairs( this.GetAll() ) do
			if group.GetName() == str or group.GetCaption() == str then
				return group;
			end
		end

		return NULL;
	end;
}
