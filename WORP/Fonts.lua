-- Author:      	Kernell
-- Version:     	1.0.0

local FontRemap =
{
	[ "Segoe UI" ]	= "segoeui";
	[ "Consolas" ]	= "consola";
};

local FontCache	= {};

function DXFont( sFontName, iSize, bBold )
	sFontName	= (string)(sFontName);
	iSize		= tonumber( iSize ) or 9;
	bBold		= (bool)(bBold);
	
	sFontName = FontRemap[ sFontName ] or sFontName;
	
	if not FontCache.DX then
		FontCache.DX = {};
	end
	
	if not FontCache.DX[ sFontName ] then
		FontCache.DX[ sFontName ] = {};
	end
	
	if not FontCache.DX[ sFontName ][ iSize ] then
		FontCache.DX[ sFontName ][ iSize ] = {};
	end
	
	if not FontCache.DX[ sFontName ][ iSize ][ bBold and 'bold' or 'normal' ] then
		FontCache.DX[ sFontName ][ iSize ][ bBold and 'bold' or 'normal' ] = dxCreateFont( "Resources/Fonts/" + sFontName + ( bBold and 'b' or '' ) + ".ttf", iSize, bBold );
	end
	
	return FontCache.DX[ sFontName ][ iSize ][ bBold and 'bold' or 'normal' ];
end

function CEGUIFont( sFontName, iSize, bBold )
	sFontName	= (string)(sFontName);
	iSize		= tonumber( iSize ) or 9;
	bBold		= (bool)(bBold);
	
	sFontName = FontRemap[ sFontName ] or sFontName;
	
	if not FontCache.CEGUI then
		FontCache.CEGUI = {};
	end
	
	if not FontCache.CEGUI[ sFontName ] then
		FontCache.CEGUI[ sFontName ] = {};
	end
	
	if not FontCache.CEGUI[ sFontName ][ iSize ] then
		FontCache.CEGUI[ sFontName ][ iSize ] = {};
	end
	
	if not FontCache.CEGUI[ sFontName ][ iSize ][ bBold and 'bold' or 'normal' ] then
		FontCache.CEGUI[ sFontName ][ iSize ][ bBold and 'bold' or 'normal' ] = guiCreateFont( "Resources/Fonts/" + sFontName + ( bBold and 'b' or '' ) + ".ttf", iSize );
	end
	
	return FontCache.CEGUI[ sFontName ][ iSize ][ bBold and 'bold' or 'normal' ];
end