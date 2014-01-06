-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local base64chars =
{
	[0] = 	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z';
			'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z';
			'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-', '_';
};

local base64bytes =
{
	['A'] = 0,	['B'] = 1,	['C'] = 2,	['D'] = 3,	['E'] = 4,	['F'] = 5,	['G'] = 6,	['H'] = 7,	['I'] = 8,	['J'] = 9,	['K'] = 10,	['L'] = 11,	['M'] = 12,	['N'] = 13,	['O'] = 14,	['P'] = 15,	['Q'] = 16,	['R'] = 17,	['S'] = 18,	['T'] = 19,	['U'] = 20,	['V'] = 21,	['W'] = 22,	['X'] = 23,	['Y'] = 24,	['Z'] = 25,
	['a'] = 26,	['b'] = 27,	['c'] = 28,	['d'] = 29,	['e'] = 30,	['f'] = 31,	['g'] = 32,	['h'] = 33,	['i'] = 34,	['j'] = 35,	['k'] = 36,	['l'] = 37,	['m'] = 38,	['n'] = 39,	['o'] = 40,	['p'] = 41,	['q'] = 42,	['r'] = 43,	['s'] = 44,	['t'] = 45,	['u'] = 46,	['v'] = 47,	['w'] = 48,	['x'] = 49,	['y'] = 50,	['z'] = 51,
	['0'] = 52,	['1'] = 53,	['2'] = 54,	['3'] = 55,	['4'] = 56,	['5'] = 57,	['6'] = 58,	['7'] = 59,	['8'] = 60,	['9'] = 61,	['-'] = 62,	['_'] = 63;
};

local function left_shift( value, shift )
	return ( value * ( 2 ^ shift ) ) % 256;
end

local function right_shift( value, shift )
	return math.floor( value / 2 ^ shift ) % 256;
end

local function bit( x, b )
	return ( x % 2 ^ b - x % 2 ^ ( b - 1 ) > 0 );
end

local function lor( x, y )
	local result = 0;
	
	for p = 1, 8 do
		result = result + ( ( ( bit( x, p ) or bit( y, p ) ) == true ) and 2 ^ ( p - 1 ) or 0 );
	end
	
	return result;
end


function base64_encode( data )
	local bytes		= {};
	local result	= "";
	
	for x = 0, data:len() - 1, 3 do
		for byte = 1, 3 do
			bytes[ byte ] = data:sub( x + byte ):byte() or 0;
		end
		
		result = ( "%s%s%s%s%s" ):format( result,
			base64chars[ right_shift( bytes[ 1 ], 2 ) ],
			base64chars[ lor( left_shift( ( bytes[ 1 ] % 4 ), 4 ), right_shift( bytes[ 2 ], 4 ) ) ] or "=",
			data:len() - x > 1 and base64chars[ lor( left_shift( bytes[ 2 ] % 16, 2 ), right_shift( bytes[ 3 ], 6 ) ) ] or "=",
			data:len() - x > 2 and base64chars[ ( bytes[ 3 ] % 64 ) ] or "="
		);
	end
	
	return result;
end

function base64_decode( data )
	local chars		= {};
	local result	= "";
	
	for x = 0, data:len() - 1, 4 do
		for char = 1, 4 do
			chars[ char ] = base64bytes[ ( data:sub( ( x + char ), ( x + char ) ) or "=" ) ];
		end
		
		result = ( "%s%s%s%s" ):format( result,
			string.char( lor( left_shift( chars[ 1 ], 2 ), right_shift( chars[ 2 ], 4 ) ) ),
			chars[ 3 ] ~= nil and string.char( lor( left_shift( chars[ 2 ], 4 ), right_shift( chars[ 3 ], 2 ) ) ) or "",
			chars[ 4 ] ~= nil and string.char( lor( left_shift( chars[ 3 ], 6 ) % 192, chars[ 4 ] ) ) or ""
		);
	end
	
	return result;
end
