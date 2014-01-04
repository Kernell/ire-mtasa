-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: String
{
	sub			= string.sub;
	upper		= string.upper;
	len			= string.len;	
	gfind		= string.gfind;
	rep			= string.rep;
	find		= string.find;
	match		= string.match;
	char		= string.char;
	dump		= string.dump;
	gmatch		= string.gmatch;
	reverse		= string.reverse;
	byte		= string.byte;
	format		= string.format;
	gsub		= string.gsub;
	lower		= string.lower;
	
	split 		= split;

	utfCode		= utfCode;
	utfLen		= utfLen;
	utfSub		= utfSub;
	utfSeek		= utfSeek;
	
	String	= function( this, sString )
		for i = 1, sString:len() do
			table.insert( this, sString:sub( i, i ) );
		end
	end;
	
	Split		= function( this, iDelimeter )
		return split( this:ToString(), iDelimeter );
	end;
	
	ToString	= function( this )
		local sString = "";
		
		for i, iChar in ipairs( this ) do
			sString = sString + iChar;
		end
		
		return sString;
	end;
	
	ToNumber	= function( this, iBase )
		return tonumber( this:ToString(), iBase );
	end;
	
	Trim		= function( this )
		return this:Find( '^%s*$' ) and '' or this:Match( '^%s*(.*%S)' );
	end;
	
	Sub		= function( this, iStart, iOffset )
		return this:ToString():sub( iStart, iOffset );
	end;
	
	ToLower	= function( this )
		return this:ToString():lower();
	end;
	
	ToUpper	= function( this )
		return this:ToString():upper();
	end;
	
	Length	= function( this )
		return this:ToString():len();
	end;
	
	Gfind	= function( this, ... )
		return string.gfind( this:ToString(), ... );
	end;
	
	Replace	= function( this, ... )
		return string.rep( this:ToString(), ... );
	end;
	
	Find	= function( this, ... )
		return string.find( this:ToString(), ... );
	end;
	
	Match	= function( this, ... )
		return string.match( this:ToString(), ... );
	end;
	
	Char	= function( this, ... )
		return string.char( this:ToString(), ... );
	end;
	
	Dump	= function( this, ... )
		return string.dump( this:ToString(), ... );
	end;
	
	Gmatch	= function( this, ... )
		return string.gmatch( this:ToString(), ... );
	end;
	
	Reverse	= function( this, ... )
		return string.reverse( this:ToString(), ... );
	end;
	
	Byte	= function( this, ... )
		return string.byte( this:ToString(), ... );
	end;
	
	Format	= function( this, ... )
		return string.format( this:ToString(), ... );
	end;
	
	Gsub	= function( this, ... )
		return string.gsub( this:ToString(), ... );
	end;
	
	Add		= function( this, pString )
		if not pString then error( "attempt to concatenate upvalue #2 (a nil value)", 2 ) end
		
		local pNewString = string();
		
		for i, iChar in ipairs( this ) do
			table.insert( pNewString, iChar );
		end
		
		if typeof( pString ) == "object" then
			for i, iChar in ipairs( pString ) do
				table.insert( pNewString, iChar );
			end
		elseif type( pString ) == "string" then
			for i = 0, pString:len() do
				table.insert( pNewString, pString[ i ] );
			end
		elseif type( pString ) == "number" then
			table.insert( pNewString, string.char( pString ) );
		end
		
		return pNewString;
	end;

	Sub		= function( this, sString )
		return (string)(this:Gsub( sString, "" ));
	end;
};

String.__tostring	= String.ToString;
String.__tonumber	= String.ToNumber;
String.__add		= String.Add;
String.__sub		= String.Sub;
String.__len		= String.Length;
String.__length		= String.Length;

string = String;