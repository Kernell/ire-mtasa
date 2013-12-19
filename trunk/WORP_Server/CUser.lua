-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CUser"
{
	IsStringValid = function( this, sString )
		if type( sString ) == 'string' and sString:len() > 0 then
			return not sString:find( "[^A-Za-z]" );
		end
		
		return false;
	end;
	
	IsMailValid		= function( this, sMail )
		return not not sMail:match( "^[%w+%.%-_]+@[%w+%.%-_]+%.%a%a+$" );
	end;
	
	GeneratePassword = function( this, iMinLen, iMaxLen, bMD5 )
		local sPasswd	= "";
		
		iMinLen		= tonumber( iMinLen ) or 5;
		iMaxLen		= tonumber( iMaxLen ) or 8;
		
		for i = 1, iMinLen:random( iMaxLen ) do
			sPasswd = sPasswd + ( "%c" ):format( math.random( 2 ) == 2 and math.random( 65, 90 ) or math.random( 97, 122 ) );
		end
		
		return (bool)(bMD5) and md5( sPasswd ) or sPasswd;
	end;
}