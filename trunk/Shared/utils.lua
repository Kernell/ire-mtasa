-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

CLIENT	= localPlayer;

if CLIENT then
	addEvent( 'onServerDebugMessage', true );
end

function Eval( sCode )
	return assert( loadstring( sCode ) )();
end

function GetZoneName( vecPosition, bCities )
	return getZoneName( vecPosition.X, vecPosition.Y, vecPosition.Z, (bool)(bCities) );
end

function switch( void )
	return function( tab )
        if tab[ void ] then
			tab[ void ]();
		elseif tab.default then
			tab.default();
		end
	end
end

function enum( name )
	return function( array )
		local Result = {};
		
		for key, value in pairs( array ) do
			if type( key ) == 'string' then
				_G[ key ] = value;
			else
				_G[ value ] = key;
			end
			
			Result[ key ]	= value;
			Result[ value ]	= key;
		end
		
		_G[ name ] = Result;
	end
end

function sizeof( var )
	local size = 0;
	
	if type( var ) == 'table' then
		for _ in pairs( var ) do
			size = size + 1;
		end
	elseif type( var ) == 'string' then
		size = table.getn( var );
	end
	
	return size;
end

setmetatable( string,
	{
		__call	= function( self, void )
			return void == NULL and "" or tostring( void );
		end;
	}
);

function tobool( vVar )
	local vVar = tostring( vVar ):lower();
	
	return vVar ~= 'nil' and vVar ~= 'null' and vVar ~= 'false' and vVar ~= '0';
end

bool	= tobool;

function float( void )
	return tonumber( string.format( "%f", tonumber( void ) or 0 ) );
end

function int( void )	
	return ( tonumber( void ) or void == true and 1 or 0 ):floor();
end

function byte( void )
	if type( void ) == "string" then
		void = void:byte();
	end
	
	return bitAnd( (int)(void), 0xFF );
end

function is_type( vVar, sTargetType, sVarName )
	return type( vVar ) == sTargetType, "Type mismatch in parameter '" .. (string)( sVarName ) .. "' (wanted '" .. sTargetType .. "', got '" .. type( vVar ) .. "')";
end

function printf( ... )
	local bResult, sMessage = pcall( string.format, ... );
	
	if not bResult then error( sMessage, 2 ) end
	
	return CLIENT and outputConsole( sMessage ) or outputServerLog( sMessage );
end

function print_r( Array, vFunction, iPadding )
--	if type( Array ) ~= 'table' then error( "Type mismatch in argument #1 (wanted 'table', got '" .. type( Array ) .. "')", 2 ); end
	if type( Array ) ~= 'table' then
		return vFunction == true and tostring( Array ) or not ( vFunction or print )( Array );
	end
	
	iPadding	= tonumber( iPadding ) or 0;
	
	local sPadding	= "";
	local sResult	= "";
	
	for _ = 1, iPadding do sPadding = sPadding .. "    "; end
	
	sResult = sResult .. sPadding .. '{\n';
	
	for key, value in pairs( Array ) do
		if type( value ) == 'table' then
			sResult = sResult .. sPadding .. '    ' .. key .. ' =\n';			
			sResult = sResult .. print_r( value, true, iPadding + 1, vFunction );
		else
			local key = type( key ) == 'number' and "[" .. key .. "]" or key;
			
			sResult = sResult .. sPadding .. '    ' .. key .. ' = ';
			
			if type( value ) == "string" then
				sResult = sResult .. '"' .. value .. '"';
			else
				sResult = sResult .. tostring( value );
			end
			
			sResult = sResult .. ';\n';
		end
	end
	
	sResult = sResult .. sPadding .. '};\n';
	
	return vFunction == true and sResult or not ( vFunction or print )( sResult );
end

function math.decl( number, declin1, declin2, declin3 )
	local bValid, sError = is_type( number, 'number', 'number' );		if not bValid then error( sError, 2 ) end
	local bValid, sError = is_type( declin1, 'string', 'declin1' );		if not bValid then error( sError, 2 ) end
	local bValid, sError = is_type( declin2, 'string', 'declin2' );		if not bValid then error( sError, 2 ) end
	local bValid, sError = is_type( declin3, 'string', 'declin3' );		if not bValid then error( sError, 2 ) end
	
	if number % 10 == 1 and number % 100 ~= 11 then
		return declin1;
	elseif number % 10 >= 2 and number % 10 <= 4 and ( number % 100 < 10 or number % 100 >= 20 ) then
		return declin2;
	end
	
	return declin3;
end

function table.clone( array )
	if type( array ) == 'table' then
		local new_array = {};
		
		for key, value in pairs( array ) do
			if type( value ) == 'table' then
				new_array[ key ] = table.clone( value );
			else
				new_array[ key ] = value;
			end
		end
		
		return new_array;
	end
end

function table.concat_assoc( array, delimeter, delimeter2 )
	local result		= "";
	local delimeter		= delimeter or ', ';
	local delimeter2	= delimeter2 or ' = ';
	
	if type( array ) == 'table' then
		local i = 0;
		
		for key, value in pairs( array ) do
			if i > 0 then
				result = delimeter .. result;
			end
			
			result = key .. delimeter2 .. tostring( value ) .. result;
			
			i = i + 1;
		end
	end
	
	return result;
end

function Unlerp( fFrom, fPos, fTo )
	if fFrom == fTo then return 1.0 end

	return ( ( fPos - fFrom ) / ( fTo - fFrom ) );
end

function Clamp( min, a, max )
	return math.max( math.min( a, max ), min );
end

function UnlerpClamped( dFrom, dPos, dTo )
	return Clamp( 0.0, Unlerp( dFrom, dPos, dTo ), 1.0 );
end

function Lerp( from, to, percent )
    return from + ( to - from ) * Clamp( 0.0, percent, 1.0 );
end

--------------------------------------------------------------------------------

CR = string.char( 0x0D );
LF = string.char( 0x0A );

string.split 	= split;

string.utfCode	= utfCode;
string.utfLen	= utfLen;
string.utfSub	= utfSub;
string.utfSeek	= utfSeek;

function string:ToNumber( iBase )
	return tonumber( self, iBase );
end

function string:Trim()
	return self:find( '^%s*$' ) and '' or self:match( '^%s*(.*%S)' );
end

string.trim = string.Trim;

function string:FromHex()
    return self:gsub( '..',
		function( cc )
			return string.char( tonumber( cc, 16 ) );
		end
	);
end

function string:Hex()
    return self:gsub( '.', 
		function( char )
			return ( "%02X" ):format( string.byte( char ) );
		end
	);
end

local f	=
{
	a	= 2;
	b	= 2;
	c	= 2;
	d	= 2;
	e	= 2;
	f	= 1;
	g	= 2;
	h	= 2;
	i	= 1;
	j	= 1;
	k	= 2;
	l	= 1;
	m	= 4;
	n	= 2;
	o	= 2;
	p	= 2;
	q	= 2;
	r	= 2;
	s	= 2;
	t	= 1;
	u	= 2;
	v	= 2;
	w	= 4;
	x	= 2;
	y	= 2;
	z	= 2;
	
	M	= 3;
	W	= 4;
};

local function insert_spaces( count )
	local r = "";
	
	for i = 0, count do
		r = r + ' ';
	end
	
	return r;
end

function string:insert_spaces( iCount )
	local iSpaces = 0;
	
	for i = 1, self:len() do
		iSpaces = iSpaces + ( f[ self[ i ] ] or 2 );
	end
	
	return self + insert_spaces( iCount * 2 - iSpaces );
end

debug.setmetatable( '',
	{
		__index = function( self, index )  
			if type( index ) == 'number' then  
				return self:sub( index, index );  
			end 
			
			return string[ index ];  
		end;
		
		__add = function( arg1, arg2 )
			if not arg1 then error( "attempt to concatenate upvalue 'arg1' (a nil value)", 2 ) end
			if not arg2 then error( "attempt to concatenate upvalue 'arg2' (a nil value)", 2 ) end
			
			local bSuccess, sResult = pcall( function() return arg1 .. arg2 end );
			
			if not bSuccess then error( sResult, 2 ) end
			
			return sResult;
		end;
		
		__sub = function( arg1, arg2 )
			return arg1:gsub( arg2, '' );
		end;
	}
);

debug.setmetatable( 0,
	{  
		__index = function( i, index )  
			if type( index ) == 'number' then  
				return tonumber( (string)(i)[ index ] );  
			end 
			
			return math[ index ];  
		end;
		
		__call = function( OperandL, operator )
			if operator == "<<" then
				return function( OperandR ) return bitLShift( OperandL, OperandR ); end
			elseif operator == ">>" then
				return function( OperandR ) return bitRShift( OperandL, OperandR ); end
			elseif operator == "&" then
				return function( OperandR ) return bitAnd	( OperandL, OperandR ); end
			elseif operator == "|" then
				return function( OperandR ) return bitOr	( OperandL, OperandR ); end
			elseif operator == "^" then
				return function( OperandR ) return bitXor	( OperandL, OperandR ); end
			end
		end;
	}
);

function include( sPath )
	if type( sPath ) == 'string' then
		local pFile = fileOpen( sPath );
		
		local sPath = sPath:gsub( ':', '/' );
		
		if not pFile then
			error( "Failed to open include file '" +  sPath + "'", 2 );
		end
		
		local sString = fileRead( pFile, fileGetSize( pFile ) );
		
		fileClose( pFile );
		
		local vResult, sError = loadstring( sString, sPath );
		
		if vResult then
			vResult();
		elseif sError then
			error( sError:gsub( '%[string "' + sPath + '"%]', sPath ):gsub( ':', '⁞' ), 2 );
		else
			error( sPath + ".lua >> is not encoded in ANSI", 2 );
		end
	else
		error( "Type mismatch in parameter 'sPath' (wanted 'string', got '" + type( sPath ) + "')", 2 );
	end
end

function require( sLibName )
	if type( sLibName ) == 'string' then
		local pFile = fileOpen( ":Shared/".. sLibName .. ".lua" );
		
		if pFile then
			local sContent = fileRead( pFile, fileGetSize( pFile ) );
			
			fileClose( pFile );
			
			local bResult, vResult = pcall( loadstring, sContent, sLibName );
			
			if bResult then
				if vResult then
					local bResult, sError = pcall( vResult );
					
					if not bResult then
						error( sLibName .. ".lua >> " .. sError, 2 );
					end
				else
					error( sLibName .. ".lua >> is not encoded in ANSI", 2 );
				end
			else
				error( sLibName .. ".lua >> " .. vResult, 2 );
			end
			
			-- fileDelete( ":Shared/".. sLibName .. ".lua" );
		else
			error( "Failed to open include file '" ..  sLibName .. "'", 2 );
		end	
	else
		error( "Type mismatch in parameter 'sLibName' (wanted 'string', got '" .. type( sLibName ) .. "')", 2 );
	end
end

local hex2bin =
{
	[ "0" ] = "0000";
	[ "1" ] = "0001";
	[ "2" ] = "0010";
	[ "3" ] = "0011";
	[ "4" ] = "0100";
	[ "5" ] = "0101";
	[ "6" ] = "0110";
	[ "7" ] = "0111";
	[ "8" ] = "1000";
	[ "9" ] = "1001";
	[ "a" ] = "1010";
	[ "b" ] = "1011";
	[ "c" ] = "1100";
	[ "d" ] = "1101";
	[ "e" ] = "1110";
	[ "f" ] = "1111";
};

function Hex2Bin( str )
	local result = "";
	
	for i in str:gfind( "." ) do
		result = result .. hex2bin[ i:lower() ];
	end
	
	return result;
end