-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CGroupManager ( CManager );

function CGroupManager:CGroupManager()
	self:CManager();
	
	g_pDB:CreateTable( "uac_groups",
		{
			{ Field = "id", 								Type = "int(11) unsigned", 	Null = "NO", 	Key = "PRI", 	Default = false, Extra = "auto_increment" };
			{ Field = "name", 								Type = "varchar(255)", 		Null = "NO", 	Key = "", 		Default = NULL };
			{ Field = "caption",							Type = "varchar(255)", 		Null = "NO", 	Key = "", 		Default = NULL };
			{ Field = "color",								Type = "varchar(255)", 		Null = "NO", 	Key = "", 		Default = "[[ 255, 255, 255 ]]" };
			{ Field = "general.immunity",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.adminduty",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.adminchat",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.pm",							Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.areport",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.freecam",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.system",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.system:restart",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.system:shutdown",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.system:setooc",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.3dtext",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.3dtext:create",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.3dtext:remove",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.3dtext:drawlabels",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.bank",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.bank:create",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.bank:delete",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.equipment",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.equipment:create",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.equipment:delete",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.equipment:setfaction",		Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.equipment:additem",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.equipment:removeitem",		Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.gate",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.gate:reload",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.faction",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.faction:create",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.faction:delete",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.faction:setname",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.faction:settag",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.faction:edit",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.map",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.map:add",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.map:remove",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.map:setdimension",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.map:setinterior",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.marker",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.marker:create",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.marker:remove",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:add",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:remove",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:settype",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:setname",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:setprice",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:setlocked",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:setowner",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:setdropoff",		Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:view",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:set",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:edit",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.interior:generateprices",	Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.teleport",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.teleport:create",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.teleport:delete",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.teleport:drawlabels",		Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.teleport:setfaction",		Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.teleport:setfaction",		Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.npc",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.npc:create",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.npc:remove",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.npc:setposition",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.npc:setanimation",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.npc:setfrozen",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.npc:setdamageproof",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.npc:setcollisions",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.npc:setinteractive",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.npc:toggle_labels",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:stats",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:payday",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:jail",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:slap",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:mute",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:kick",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:ban",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:unban",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:setname",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:sethealth",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:setarmor",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:setskin",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:get",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:goto",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:spectate",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:setmoney",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:givemoney",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:setfaction",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.player:giveweapon",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.shop",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.shop:create",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.shop:delete",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.shop:additem",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.shop:removeitem",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:get",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:goto",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:spawn",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:respawn",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:respawnall",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:create",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:delete",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:restore",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:setupgrade",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:setowner",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:setfaction",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:setrentable",		Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:setrentprice",		Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:setcolor",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:setspawn",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:setmodel",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:setvariant",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:repair",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:setfuel",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:toggle_labels",		Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:flip",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:saveall",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:shop",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.vehicle:fuelpoint",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.world",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.world:setweather",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.world:settime",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.world:resettime",			Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.uac",						Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.uac:adduser",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.uac:usermod",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.uac:userdel",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.uac:addgroup",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.uac:groupmod",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.uac:groupdel",				Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
			{ Field = "command.uac:reload",					Type = "enum('Yes','No')", 	Null = "NO", 	Key = "", 		Default = "No" };
		}
	);
	
	g_pDB:CreateTable( "uac_users",
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
			{ Field = "autologin", 			Type = "varchar(255)", 			Null = "YES", 	Key = "", 		Default = NULL };
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
end

function CGroupManager:_CGroupManager()
	self:DeleteAll();
end

function CGroupManager:Init()
	self.m_List = {};
	
	local pResult = g_pDB:Query( "SELECT * FROM `uac_groups` ORDER BY `id` ASC" );
	
	if pResult then
		for _, row in pairs( pResult:GetArray() ) do
			self:LoadGroup( row.id, row.name, row.caption, fromJSON( row.color ), row );
		end
		
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	return true;
end

function CGroupManager:LoadGroup( iID, sName, sCaption, Color, Rights )
	local pGroup = CGroup( self, iID, sName, sCaption, Color );
	
	if Rights then
		for sRightName, sValue in pairs( Rights ) do
			if sValue == 'Yes' then
				pGroup:AddRight( sRightName );
			end
		end
	end
end

function CGroupManager:Get( void )
	if type( void ) == 'number' then
		return self.m_List[ void ];
	elseif type( void ) == 'string' then
		for _, pGrp in pairs( self.m_List ) do
			if pGrp:GetName() == void or pGrp:GetCaption() == void then
				return pGrp;
			end
		end
	end
	
	return false;
end