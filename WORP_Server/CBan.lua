-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CBan"

local ban_list = {};

function CBan:CBan( ban )
	self.__instance = ban;
	
	ban_list[ ban ] = self;
end

function CBan.Add( IP, Username, Serial, response, reason, seconds )
	local ban = addBan( IP, Username, Serial, type( response ) == 'table' and response.__instance or response, reason, tonumber( seconds ) or 0 );
	
	return CBan( ban );
end

function CBan:GetAll()
	local bans = {};
	
	for _, ban in ipairs( getBans() ) do
		local ban = ban_list[ ban ] or CBan( ban );
		
		table.insert( bans, ban );
	end
	
	return bans;
end

function CBan:GetAdmin()
	return getBanAdmin( self.__instance );
end

function CBan:GetIP()
	return getBanIP( self.__instance );
end

function CBan:GetReason()
	return getBanReason( self.__instance );
end

function CBan:GetSerial()
	return getBanSerial( self.__instance );
end

function CBan:GetTime()
	return getBanTime( self.__instance );
end

function CBan:GetUnbanTime()
	return getUnbanTime( self.__instance );
end

function CBan:GetUsername()
	return getBanUsername( self.__instance );
end

function CBan:GetNick()
	return getBanNick( self.__instance );
end

function CBan:Remove( response )
	if removeBan( self.__instance, type( response ) == 'table' and response.__instance or response ) then
		ban_list[ self.__instance ] = nil;
		
		return true;
	end
	
	return false
end