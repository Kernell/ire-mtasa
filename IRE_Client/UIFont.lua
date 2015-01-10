-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. UIFont
{
	static
	{
		FontNamesRemap =
		{
			[ "SegoeUI" ]	= "segoeui";
			[ "Segoe UI" ]	= "segoeui";
			[ "Consolas" ]	= "consola";
		};

	};
	
	UIFont		= function()
		this.Cache =
		{
			CEGUI	= {};
			DirectX	= {};
		};
	end;
	
	CEGUI	= function( fontName, size, weight )
		fontName	= (string)(fontName);
		size		= tonumber( size ) or 9;
		weight		= weight and string.lower( weight ) or "normal";
		
		fontName	= UIFont.FontNamesRemap[ fontName ] or fontName;
		
		if not this.Cache.CEGUI[ fontName ] then
			this.Cache.CEGUI[ fontName ] = {};
		end
		
		if not this.Cache.CEGUI[ fontName ][ size ] then
			this.Cache.CEGUI[ fontName ][ size ] = {};
		end
		
		if not this.Cache.CEGUI[ fontName ][ size ][ weight ] then
			this.Cache.CEGUI[ fontName ][ size ][ weight ] = guiCreateFont( "Resources/Fonts/" + fontName + ( weight == "bold" and "b" or "" ) + ".ttf", size );
		end
		
		return this.Cache.CEGUI[ fontName ][ size ][ weight ];
	end;
	
	DirectX	= function( fontName, size, bold )
		fontName	= (string)(fontName);
		size		= tonumber( size ) or 9;
		bold		= (bool)(bold);
		
		local weight	= bold and "bold" or "normal";
		
		fontName	= UIFont.FontNamesRemap[ fontName ] or fontName;
		
		if not this.Cache.DirectX[ fontName ] then
			this.Cache.DirectX[ fontName ] = {};
		end
		
		if not this.Cache.DirectX[ fontName ][ size ] then
			this.Cache.DirectX[ fontName ][ size ] = {};
		end
		
		if not this.Cache.DirectX[ fontName ][ size ][ weight ] then
			this.Cache.DirectX[ fontName ][ size ][ weight ] = dxCreateFont( "Resources/Fonts/" + fontName + ( bold and 'b' or '' ) + ".ttf", size, bold );
		end
		
		return this.Cache.DirectX[ fontName ][ size ][ weight ];
	end
};