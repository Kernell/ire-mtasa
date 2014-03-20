-- complex 0.3.0
-- Lua 5.1

-- 'complex' provides common tasks with complex numbers

-- function complex.to( arg ); complex( arg )
-- returns a complex number on success, nil on failure
-- arg := number or { number,number } or ( "(-)<number>" and/or "(+/-)<number>i" )
--		e.g. 5; {2,3}; "2", "2+i", "-2i", "2^2*3+1/3i"
--		note: 'i' is always in the numerator, spaces are not allowed

-- a complex number is defined as carthesic complex number
-- complex number := { real_part, imaginary_part }
-- this gives fast access to both parts of the number for calculation
-- the access is faster than in a hash table
-- the metatable is just a add on, when it comes to speed, one is faster using a direct function call

-- http://luaforge.net/projects/LuaMatrix
-- http://lua-users.org/wiki/ComplexNumbers

-- Licensed under the same terms as Lua itself.

---MODIFIED TO SUIT THE MTA SCRIPTING SYSTEM
	
---MODIFIED TO SUIT THE MTA ROLEPLAY SCRIPTING SYSTEM

local _retone			= function() return 1; end
local _retminusone		= function() return -1; end

class: Complex
{
	Complex		= function( this, ... )
		for i, v in ipairs( { ... } ) do
			this[ i ] = v;
		end
	end;
	
	To			= function( this, num )
		if type( num ) == "table" then
			if classof( num ) == Complex then
				return Complex( unpack( num ) );
			end
			
			local real, imag = tonumber( num[ 1 ] ), tonumber( num[ 2 ] );
			
			if real and imag then
				return Complex( real, imag );
			end
			
			return;
		end
		
		local isnum = tonumber( num );
		
		if isnum then
			return Complex( isnum, 0 );
		end
		
		if type( num ) == "string" then
			local real, sign, imag = num:match( "^([%-%+%*%^%d%./Ee]*%d)([%+%-])([%-%+%*%^%d%./Ee]*)i$" );
			
			if real then
				if real[ 1 ]:lower() == "e" or imag[ 1 ]:lower() == "e" then
					return;
				end
				
				if imag == "" then
					if sign == "+" then
						imag = _retone;
					else
						imag = _retminusone;
					end
				elseif sign == "+" then
					imag = tonumber( imag );
				else
					imag = tonumber( sign .. imag );
				end
				
				real = tonumber( real );
				
				if real and imag then
					return Complex( real, imag );
				end
				
				return;
			end
			
			local imag = num:match( "^([%-%+%*%^%d%./Ee]*)i$" );
			
			if imag then
				if imag == "" then
					return Complex( 0, 1 );
				elseif imag == "-" then
					return Complex( 0, -1 );
				end
				
				if imag[ 1 ]:lower() ~= "e" then
					imag = tonumber( imag );
					
					if imag then
						return Complex( 0, imag );
					end
				end
				
				return;
			end
			
			local real = num:match( "^(%-*[%d%.][%-%+%*%^%d%./Ee]*)$" );
			
			if real then
				real = tonumber( real );
				
				if real then
					return Complex( real, 0 );
				end
			end
		end
	end;
	
	ConvPolar		= function( this, radius, phi )
		return Complex( radius * math.cos( phi ), radius * math.sin( phi ) );
	end;
	
	ConvPolarDeg	= function( this, radius, phi )
		phi = phi / 180 * math.pi;
		
		return Complex( radius * math.cos( phi ), radius * math.sin( phi ) );
	end;
	
	Polar		= function( this )
		return math.sqrt( this[ 1 ] ^ 2 + this[ 2 ] ^ 2 ), math.atan2( this[ 2 ], this[ 1 ] );
	end;
	
	PolarDeg	= function( this )
		return math.sqrt( this[ 1 ] ^ 2 + this[ 2 ] ^ 2 ), math.atan2( this[ 2 ], this[ 1 ] ) / math.pi * 180;
	end;
	
	MulConjugate	= function( this )
		return this[ 1 ] ^ 2 + this[ 2 ] ^ 2;
	end;
	
	Abs				= function( this )
		return math.sqrt( this[ 1 ] ^ 2 + this[ 2 ] ^ 2 );
	end;
	
	Get				= function( this )
		return this[ 1 ], this[ 2 ];
	end;
	
	Set				= function( this, real, imag )
		this[ 1 ], this [2 ] = real, imag;
	end;
	
	ToString		= function( this, sFormat )
		local real, imag = this[ 1 ], this[ 2 ];
		
		if sFormat then
			if imag == 0 then
				return sFormat:format( real );
			elseif real == 0 then
				return sFormat:format( imag ) .. "i";
			elseif imag > 0 then
				return sFormat:format( real ) .. "+" .. sFormat:format( imag ) .. "i";
			end
			return sFormat:format( real ) .. sFormat:format( imag ) .. "i";
		end
		
		if imag == 0 then
			return real;
		elseif real == 0 then
			return ( ( imag == 1 and "" ) or ( imag == -1 and "-" ) or imag ) .. "i";
		elseif imag > 0 then
			return real .. "+" .. ( imag == 1 and "" or imag ) .. "i";
		end
		
		return real .. ( imag == -1 and "-" or imag ) .. "i";
	end;
	
	Is		= function( this, real, imag )
		return this[ 1 ] == real and this[ 2 ] == imag;
	end;
	
	Copy	= function( this )
		return Complex( this[ 1 ], this[ 2 ] );
	end;
	
	Add		= function( this, pComplex )
		return Complex( this[ 1 ] + pComplex[ 1 ], this[ 2 ] + pComplex[ 2 ] );
	end;
	
	Sub		= function( this, pComplex )
		return Complex( this[ 1 ] - pComplex[ 1 ], this[ 2 ] - pComplex[ 2 ] );
	end;
	
	Mul		= function( this, pComplex )
		return Complex( this[ 1 ] * pComplex[ 1 ] - this[ 2 ] * pComplex[ 2 ], this[ 1 ] * pComplex[ 2 ] + this[ 2 ] * pComplex[ 1 ] );
	end;
	
	MulNum	= function( this, iNum )
		return Complex( this[ 1 ] * iNum, this[ 2 ] * iNum );
	end;
	
	Div		= function( this, pComplex )
		local val = pComplex[ 1 ] ^ 2 + pComplex[ 2 ] ^ 2;
		
		return Complex( ( this[ 1 ] * pComplex[ 1 ] + this[ 2 ] * pComplex[ 2 ] ) / val, ( this[ 2 ] * pComplex[ 1 ] - this[ 1 ] * pComplex[ 2 ] ) / val );
	end;
	
	DivNum	= function( this, iNum )
		return Complex( this[ 1 ] / iNum, this[ 2 ] / iNum );
	end;
	
	Pow		= function( this, iNum )
		if math.floor( iNum ) == iNum then
			if iNum < 0 then
				local val = this[ 1 ] ^ 2 + this[ 2 ] ^ 2;
				
				this = { this[ 1 ] / val, -this[ 2 ] / val };
				
				iNum = -iNum;
			end
			
			local real, imag = this[ 1 ], this[ 2 ];
			
			for i = 2, iNum do
				real, imag = real * this[ 1 ] - imag * this[ 2 ], real * this[ 2 ] + imag * this[ 1 ];
			end
			
			return Complex( real, imag );
		end
		
		local length, phi = math.sqrt( this[ 1 ] ^ 2 + this[ 2 ] ^ 2 ) ^ iNum, math.atan2( this[ 2 ], this[ 1 ] ) * iNum;
		
		return Complex( length * math.cos( phi ), length * math.sin( phi ) );
	end;
	
	Unm			= function( this )
		return Complex( -this[ 1 ], -this[ 2 ] );
	end;
	
	Eq			= function( this, pComplex )
		return this[1] == pComplex[ 1 ] and this[ 2 ] == pComplex[ 2 ];
	end;
	
	Sqrt		= function( this )
		local len = math.sqrt( this[ 1 ] ^ 2 + this[ 2 ] ^ 2 );
		
		local sign = this[ 2 ] < 0 and -1 or 1;
		
		return Complex( math.sqrt( ( this[ 1 ] + len ) / 2 ), sign * math.sqrt( ( len - this[ 1 ] ) / 2 ) );
	end;
	
	Ln			= function( this )
		return Complex( math.log( math.sqrt( this[ 1 ] ^ 2 + this[ 2 ] ^ 2 ) ), math.atan2( this[ 2 ], this[ 1 ] ) );
	end;
	
	Exp			= function( this )
		local ExpReal = math.exp( this[ 1 ] );
		
		return Complex( ExpReal * math.cos( this[ 2 ] ), ExpReal * math.sin( this[ 2 ] ) );
	end;
	
	Conjugate	= function( this )
		return Complex( this[ 1 ], -this[ 2 ] );
	end;
	
	Round		= function( this, idp )
		local mult = 10 ^ ( idp or 0 );
		
		return Complex( math.floor( this[ 1 ] * mult + 0.5 ) / mult, math.floor( this[ 2 ] * mult + 0.5 ) / mult );
	end;
	
	Concat		= function( this, pComplex )
		return this:ToString() + " " + pComplex:ToString();
	end;
};

Complex.__add		= Complex.Add;
Complex.__sub		= Complex.Sub;
Complex.__mul		= Complex.Mul;
Complex.__div		= Complex.Div;
Complex.__pow		= Complex.Pow;
Complex.__unm		= Complex.Unm;
Complex.__eq		= Complex.Eq;
Complex.__tostring	= Complex.ToString;
Complex.__concat	= Complex.Concat;