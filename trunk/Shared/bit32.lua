-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0
-- Bitwise operators simulation

local function tbl_to_number( array )
	local result	= 0;
	local power		= 1;
	
	for i in ipairs( array ) do
		result	= result + array[ i ] * power;
		power	= power * 2;
	end

	return result;
end

local function expand( array1, array2 )
	local big	= NULL;
	local small	= NULL;

	if table.getn( array1 ) > table.getn( array2 ) then
		big		= array1;
		small	= array2;
	else
		big		= array2;
		small	= array1;
	end
	-- expand small
	for i = table.getn( small ) + 1, table.getn (big ) do
		small[ i ] = 0;
	end
end

bit32 = 
{
	lshift 	= function( x, disp )
		return ( x * 2 ^ disp ) % 2 ^ 32;
	end;

	rshift 	= function( x, disp )
		return math.floor( x % 2 ^ 32 / 2 ^ disp );
	end;
	
	tobit 	= function( iNumber )
		if iNumber - math.floor( iNumber ) > 0 then
			error( "trying to use bitwise operation on non-integer!", 2 );
		end
		
		if iNumber < 0 then
			return bit32.tobit( bit32.bnot( math.abs( iNumber ) ) + 1 ); -- negative
		end
		
		-- to bits table
		local array = {}
		local i	= 1;
		
		while iNumber > 0 do
			local last = math.mod( iNumber, 2 );
			
			if last == 1 then
				array[ i ] = 1;
			else
				array[ i ] = 0;
			end
		
			iNumber	= ( iNumber - last ) / 2;
			i		= i + 1;
		end

		return array
	end;
	
	bnot 	= function( x )
		return ( -1 - x ) % 2 ^ 32;
	end;
	
	band 	= function( m, n )
		local tbl_m		= bit32.tobit( m );
		local tbl_n		= bit32.tobit( n );
		
		expand( tbl_m, tbl_n );
		
		local array	= {};
		
		for i = 1,  math.max( table.getn( tbl_m ), table.getn( tbl_n ) ) do
			array[ i ] = ( tbl_m[ i ] == 0 or tbl_n[ i ] == 0 ) and 0 or 1;
		end
		
		return tbl_to_number( array );
	end;
	
	bor 	= function( m, n )
		local tbl_m		= bit32.tobit( m );
		local tbl_n		= bit32.tobit( n );
		
		expand( tbl_m, tbl_n );
		
		local array = {};
		
		for i = 1, math.max( table.getn( tbl_m ), table.getn( tbl_n ) ) do
			array[ i ] = tbl_m[ i ] == 0 and tbl_n[ i ] == 0 and 0 or 1;
		end
		
		return tbl_to_number( array );
	end;
	
	bxor 	= function( m, n )
		local tbl_m		= bit32.tobit( m );
		local tbl_n		= bit32.tobit( n );
		
		expand( tbl_m, tbl_n );

		local result	= 0;
		local power		= 1;
		
		for i = 1, math.max( table.getn( tbl_m ), table.getn( tbl_n ) ) do
			result	= result + ( tbl_m[ i ] ~= tbl_n[ i ] and 1 or 0 ) * power;
			power	= power * 2;
		end
		
		return result;
	end;
	
	tohex 	= function()
	end;
	
	arshift = function( x, disp )
	end;
	
	rol 	= function()
	end;
	
	ror 	= function()
	end;
	
	bswap	= function()
	end;
};