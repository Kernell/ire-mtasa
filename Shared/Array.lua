-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: Array
{
	__index = function( this, sKey )
		if sKey == "Length" then
			return table.getn( this );
		elseif type( sKey ) == "number" and this.Length == 0 then
			for i = 1, sKey do
				this[ i ] = 0;
			end
			
			return this;
		end
		
		return getmetatable( this )[ sKey ];
	end;
	
	Array		= function( this, ... )
		this:Push( ... );
	end;
	
	Push		= function( this, ... )
		for i, vArg in ipairs( { ... } ) do
			table.insert( this, vArg );
		end
	end;
	
	Shift		= function( this )
		table.remove( this, 1 );
	end;
	
	Join		= function( this, sDelimiter )
		local sResult = "";
		
		for i, v in ipairs( this ) do
			if i ~= 1 then
				sResult = sResult + ( sDelimiter or ',' );
			end
			
			if classof( v ) == Array then
				sResult = sResult + ( "[object Array<" + v.Length + ">]" );
			elseif typeof( v ) == "object" then
				sResult = sResult + ( "[object " + classname( v ) + ">]" );
			else
				sResult = sResult + tostring( v );
			end
		end
		
		return sResult;
	end;
	
	Concat		= function( this, ... )
		local aResult	= new. Array;
		
		aResult:Push( unpack( this ) );
		aResult:Push( ... );
		
		return aResult;
	end;
	
	Pop			= function( this )
		local void	= this[ 1 ];
		
		this:Shift();
		
		return void;
	end;
	
	Unshift		= function( this, ... )
		for i, vArg in ipairs( { ... } ) do
			table.insert( this, i );
		end
	end;
	
	Slice		= function( this, iStart, iEnd )
		local aNew	= new. Array;
		
		for i = ( iStart or 1 ), ( iEnd or this.Length ) do
			if this[ i ] then
				aNew:Push( this[ i ] );
			end
		end
		
		return aNew;
	end;
	
	Reverse		= function( this )
		local aResult	= new. Array;
		
		for i, vArg in ipairs( this ) do
			table.insert( aResult, 1, vArg );
		end
		
		return aResult;
	end;
	
	Sort		= function( this, SortFunc )
		if not SortFunc then
			function SortFunc( a, b )
				return a < b;
			end
		end
		
		table.sort( this, SortFunc );
		
		return this;
	end;
	
	Splice		= function( this, iStart, iDeleteCount, ... )
		local aRemoved = new. Array;
		
		for i = iStart, iStart + iDeleteCount do
			aRemoved:Push( this[ i ] );
			
			table.remove( this, i );
		end
		
		if ( ... ) then
			for i, vArg in ipairs( { ... } ) do
				table.insert( this, vArg, i + iStart );
			end
		end
		
		return aRemoved;
	end;
	
	IndexOf		= function( this, vItem, iStart )
		for i = ( iStart or 1 ), this.Length do
			if this[ i ] == vItem then
				return i;
			end
		end
		
		return -1;
	end;
};