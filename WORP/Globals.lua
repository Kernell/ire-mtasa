-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

CClientRPC();

g_iScreenX, g_iScreenY = guiGetScreenSize();

Consola12		= dxCreateFont( "Resources/Fonts/consola.ttf", 12, false );
ConsolaBold12	= dxCreateFont( "Resources/Fonts/consolab.ttf", 12, true );

COLOR_WHITE		= tocolor( 255, 255, 255, 255 );
COLOR_GRAY		= tocolor( 128, 128, 128, 255 );
COLOR_BLACK		= tocolor( 0, 0, 0, 255 );
COLOR_RED		= tocolor( 255, 0, 0, 255 );
COLOR_GREEN		= tocolor( 0, 255, 0, 255 );
COLOR_BLUE		= tocolor( 0, 0, 255, 255 );
COLOR_ORANGE	= tocolor( 255, 128, 0, 255 );
COLOR_YELLOW	= tocolor( 255, 255, 0, 255 );
COLOR_LT_CYAN	= tocolor( 0, 128, 255, 255 );

function IsInRectangle( iCurX, iCurY, iX, iY, iWidth, iHeight )
	return iCurX > iX and iCurX < iX + iWidth and iCurY > iY and iCurY < iY + iHeight;
end

function getPositionInOffset( pElement, fX, fY, fZ )
	local Matrix = getElementMatrix( pElement );
	
	local fOffX = fX * Matrix[ 1 ][ 1 ] + fY * Matrix[ 2 ][ 1 ] + fZ * Matrix[ 3 ][ 1 ] + 1 * Matrix[ 4 ][ 1 ];
	local fOffY = fX * Matrix[ 1 ][ 2 ] + fY * Matrix[ 2 ][ 2 ] + fZ * Matrix[ 3 ][ 2 ] + 1 * Matrix[ 4 ][ 2 ];
	local fOffZ = fX * Matrix[ 1 ][ 3 ] + fY * Matrix[ 2 ][ 3 ] + fZ * Matrix[ 3 ][ 3 ] + 1 * Matrix[ 4 ][ 3 ];
	
	return fOffX, fOffY, fOffZ;
end

function Exec( sCmd )
	local Args = sCmd:split( ' ' );
	
	return executeCommandHandler( Args[ 1 ], table.concat( Args, ' ', 2 ) );
end

function CommandExec( String )
	outputChatBox( "> " + String, 200, 255, 200 );
		
	if String[ 1 ] == '=' then
		String = String:gsub( "=", "return ", 1 );
	end
	
	local Function, Error = loadstring( "return " + String );
	
	if Error then
		Function, Error = loadstring( String );
	end
	
	if Error then
		return outputChatBox( "Error: " + Error, 200, 255, 200 );
	end
	
	local Results = { pcall( Function ) };
	
	if not Results[ 1 ] then
		return outputChatBox( "Error: " + Results[ 2 ], 200, 255, 200 );
	end
	
	local Result = {};
	
	for i = 2, table.getn( Results ) do
		local TResult = isElement( Results[ i ] ) and ( "element:" + getElementType( Results[ i ] ) ) or type( Results[ i ] );
		
		table.insert( Result, (string)(Results[ i ]) + " [" + TResult + "]" );
	end
	
	outputChatBox( table.concat( Result, ', ' ), 200, 255, 200 );
end
