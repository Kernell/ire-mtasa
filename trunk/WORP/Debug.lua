-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local OnElementDataChange, Draw;
local gl_bDebug			= false;
local gl_DebugData		= {};
local gl_iX				= 100;
local gl_iY				= g_iScreenY / 2;
local gl_iColor			= tocolor( 0, 0, 0, 128 );
local gl_iLineHeight	= 16;

local gl_DebugList		=
{
	"CBlip::DoPulse";
	"CGameTime::DoPulse";
	"CGameWeather::DoPulse";
	"CGameWorld::DoPulse";
	"CMapManager::DoPulse";
	"CPedManager::DoPulse";
	"CPlayerManager::DoPulse";
	"CVehicleManager::DoPulse";
	"CGateManager::DoPulse";
	"CRaceManager::DoPulse";
	"CItemManager::DoPulse";
	"CInteriorManager::DoPulse";
	"CTeleportManager::DoPulse";
	"CShopManager::DoPulse";
	"CEventMarkerManager::DoPulse";
	"CGame::DoPulse";
};

local gl_iDebugListLen 	= table.getn( gl_DebugList );

function Update()
	for i, key in ipairs( gl_DebugList ) do
		if not gl_DebugData[ key ] then
			gl_DebugData[ key ] = {};
		end
		
		local iValue = root:GetData( "Debug:" + key );
		
		if gl_DebugData[ key ][ "value" ] then
			gl_DebugData[ key ][ "change" ]	= iValue - gl_DebugData[ key ][ "value" ];
		end
		
		gl_DebugData[ key ][ "value" ]	= iValue;
		
		if gl_DebugData[ key ][ "change" ] == 0 then
			gl_DebugData[ key ][ "change" ] = NULL;
		end
	end
end

function Draw()
	dxDrawRectangle( gl_iX - 10, gl_iY - 10, 300, gl_iLineHeight * gl_iDebugListLen + gl_iLineHeight + 20, 0x78000000 );
	
	dxDrawText( "DoPulse name", gl_iX, gl_iY, gl_iX, gl_iY, COLOR_LT_CYAN );
	dxDrawText( "Change", 		gl_iX, gl_iY, gl_iX + 200, gl_iY, COLOR_LT_CYAN, 1.0, "default", "right" );
	dxDrawText( "Delay MS", gl_iX, gl_iY, gl_iX + 280, gl_iY, COLOR_LT_CYAN, 1.0, "default", "right" );
	
	local iY = gl_iLineHeight;
	
	for i, key in ipairs( gl_DebugList ) do
		dxDrawText( key, gl_iX, gl_iY + iY );
		
		local iChange	= gl_DebugData[ key ] and gl_DebugData[ key ][ "change" ];
		local iValue	= gl_DebugData[ key ] and gl_DebugData[ key ][ "value" ];
			
		dxDrawText( iChange or ".", gl_iX, gl_iY + iY, gl_iX + 200, gl_iY + iY, iChange and ( iChange > 0 and COLOR_RED or COLOR_GREEN ) or COLOR_GRAY, 1.0, "default", "right" );
		dxDrawText( iValue or ".", gl_iX, gl_iY + iY, gl_iX + 280, gl_iY + iY, iValue and COLOR_WHITE or COLOR_GRAY, 1.0, "default", "right" );
		
		iY = iY + gl_iLineHeight;
	end
end

function ShowDoPulseStat()
	gl_bDebug = not gl_bDebug;
	
	if gl_bDebug then
		gl_pUpdateTimer = CTimer( Update, 1000, 0 );
		addEventHandler( "onClientRender", root, Draw );	
	else
		gl_pUpdateTimer:Kill();
		removeEventHandler( "onClientRender", root, Draw );
	end
end