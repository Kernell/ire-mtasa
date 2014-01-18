-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local iWidth	= 450;
local iHeight	= 150;
local fX		= ( g_iScreenX - iWidth ) / 2;
local fY		= g_iScreenY - iHeight - 60;

local Icons		=
{
	ok			= { Icon = "Okay",			Color = { 0, 	93,		0 	} };
	info		= { Icon = "Information",	Color = { 31,	127,	127 } };
	warning		= { Icon = "Warning",		Color = { 127,	97,		31 	} };
	error		= { Icon = "Error", 		Color = { 127,	31,		31 	} };
	question	= { Icon = "Question",		Color = { 31,	127,	127 } };
};

local gl_pHint	= NULL;

local Draw;

function Draw()
	if gl_pHint then
		local iTick = getTickCount();
		
		if iTick > gl_pHint.m_iStart + gl_pHint.m_iDuration then
			gl_pHint = NULL;
		else
			local fAlpha		= 1.0;
			
			if gl_pHint.m_iStart + gl_pHint.m_iDuration / 2 < iTick then
				fAlpha			= ( gl_pHint.m_iStart + gl_pHint.m_iDuration - iTick ) / gl_pHint.m_iDuration * 2.0;
			end
			
			local iColor		= tocolor( gl_pHint.m_pColor[ 1 ], gl_pHint.m_pColor[ 2 ], gl_pHint.m_pColor[ 3 ], 255 * fAlpha );
			local iColorWhite	= tocolor( 255, 255, 255, 255 * fAlpha );
			
--			dxDrawRectangle( fX - 5, fY - 5, iWidth + 10, iHeight + 10, iColor, true );
			
			dxDrawImage( fX, fY, iWidth + 25, iHeight, "Resources/Textures/Glass.png", 0, 0, 0, iColor, true );
			dxDrawImage( fX + 32, fY + ( iHeight - 64 ) / 2, 64, 64, gl_pHint.m_sIcon, 0, 0, 0, iColorWhite, true );
				
			dxDrawText( gl_pHint.m_sTitle, fX + 86, fY + 20, fX + iWidth, fY + iHeight, iColorWhite, 1, DXFont( 'consola', 12, true ), "left", "top", true, false, true );
			dxDrawText( gl_pHint.m_sText,  fX + 100, fY + ( iHeight - 48 ) / 2, fX + iWidth, fY + iHeight, iColorWhite, 1, DXFont( 'consola', 8 ), "left", "top", true, true, true );

			dxDrawImage( fX, fY, iWidth + 25, iHeight, "Resources/Textures/Glass.png", 0, 0, 0, iColor, true );
			
			return true;
		end
	end
	
	removeEventHandler( "onClientRender", root, Draw );
end

function Hint( sTitle, sText, sIcon, iDuration )
	local pIcon		= Icons[ sIcon ] or Icons[ "info" ];
	
	if gl_pHint then
		removeEventHandler( "onClientRender", root, Draw );
	end
	
	gl_pHint		=
	{
		m_sIcon		= "Resources/Images/" + pIcon.Icon + ".png";
		m_pColor	= pIcon.Color;
		
		m_sTitle	= (string)(sTitle);
		m_sText		= (string)(sText);
		m_iDuration	= Clamp( 1000, tonumber( iDuration ) or 5000, 10000 );
		m_iStart	= getTickCount();
	};
	
	addEventHandler( "onClientRender", root, Draw );
	
	return true;
end