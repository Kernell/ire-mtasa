-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

GetBans		= getBans;

class: CBan
{
	CBan		= function( this, sIP, sUsername, sSerial, pResponse, sReason, iSeconds )
		local pBan = addBan( sIP, sUsername, sSerial, pResponse, sReason, (int)(iSeconds) );
		
		pBan( this );
		
		return pBan;
	end;
	
	GetAdmin		= getBanAdmin;
	GetIP			= getBanIP;
	GetReason		= getBanReason;
	GetSerial		= getBanSerial;
	GetTime			= getBanTime;
	GetUnbanTime	= getUnbanTime;
	GetUsername		= getBanUsername;
	GetNick			= getBanNick;
	Remove			= removeBan;
};