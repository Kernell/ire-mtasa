-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local Text_W	=
{
	[ 1000 ]	= "SERVER->%s Exceeded PACKET_TIME_LIMIT( %d )";
	[ 8105 ]	= "%s member '%s' in class without constructors";
	[ 8106 ]	= "%s are deprecated";
};

local Text_E	=
{	
	[ 2251 ]	= "Cannot find default constructor to initialize base class '%s'";
	[ 2288 ]	= "Pointer to structure required on left side of -> or ->*";
	[ 2315 ]	= "'%s' is not a member of '%s', because the type is not yet defined";
	[ 2342 ]	= "Type mismatch in parameter '%s' (wanted '%s', got '%s')";
	[ 2451 ]	= "Undefined symbol '%s'";
};

Debug	= outputDebugString;

function Warning( iLevel, iNumber, ... )
	local pInfo	= debug.getinfo( iLevel + 1 );
	local sText	= ( ... ) and Text_W[ iNumber ]:format( ... ) or Text_W[ iNumber ];
	local sPath	= (string)(pInfo.short_src);
	local sLine	= (string)(pInfo.currentline);
	
	local iStart = sPath:find( "%[worp%]" );
	
	sPath = sPath:sub( tonumber( iStart ) or 1, sPath:len() ):gsub( "%/", "%\\" );
	
	pcall( Debug, "WARNING: " + sPath + ":" + sLine + ": " + sText, 0, 255, 128, 0 );
end

function Error( iLevel, iNumber, ... )
	error( ( ... ) and Text_W[ iNumber ]:format( ... ) or Text_W[ iNumber ], iLevel + 1 );
end