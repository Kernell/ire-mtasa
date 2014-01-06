-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local OnClientCursorMove, OnPreRender, OnRender;

local fScreenX, fScreenY	= guiGetScreenSize();
local iWait					= NULL;

local fMouseX, fMouseY		= 0.0, 0.0;
local fCamDistance			= 4.0;

local gl_sText = NULL;

function OnPreRender()
	if iWait then
		local sText		= NULL;
		local iDiff		= iWait - getTickCount();
			
		if iDiff >= 0 then
			sText = ( "Подождите %.2f секунд" ):format( iDiff / 1000 );
		elseif not getKeyState( "space" ) or isConsoleActive() or isChatBoxInputActive() then
			sText = "Нажмите \"Пробел\" для возрождения";
		end
		
		if sText then
			local pElement		= CLIENT:GetVehicle() or CLIENT;
			local fPX, fPY, fPZ = getElementPosition( pElement );
			
			local fX	= fPX + fCamDistance * math.sin( fMouseX );
			local fY	= fPY + fCamDistance * math.cos( fMouseX );
			local fZ	= fPZ + fCamDistance * math.sin( fMouseY );
			
			local bSuccess, fHX, fHY, fHZ = processLineOfSight( fPX, fPY, fPZ, fX, fY, fZ, true, false, false, false, false, false, true, false );
			
			if bSuccess then
				fX, fY, fZ = fHX, fHY, fHZ;
			end
			
			setCameraMatrix( fX, fY, fZ, fPX, fPY, fPZ );
			
			gl_sText = sText;
			
			return;
		end
		
		gl_sText 	= NULL;
		iWait 		= NULL;
		
		SERVER.Respawn();
	end
end

function OnRender()
	if gl_sText then
		dxDrawText( gl_sText, 0, 0, fScreenX + 1, fScreenY + 1,	COLOR_BLACK, 1.0, DXFont( "consola", 12, true ), "center", "center" );
		dxDrawText( gl_sText, 0, 0, fScreenX - 1, fScreenY - 1,	COLOR_BLACK, 1.0, DXFont( "consola", 12, true ), "center", "center" );
		dxDrawText( gl_sText, 0, 0, fScreenX + 1, fScreenY - 1,	COLOR_BLACK, 1.0, DXFont( "consola", 12, true ), "center", "center" );
		dxDrawText( gl_sText, 0, 0, fScreenX - 1, fScreenY + 1,	COLOR_BLACK, 1.0, DXFont( "consola", 12, true ), "center", "center" );
		dxDrawText( gl_sText, 0, 0, fScreenX, fScreenY, 		COLOR_WHITE, 1.0, DXFont( "consola", 12, true ), "center", "center" );
	end
end

function OnClientWasted( iTotalAmmo, pKiller, iKillerWeapon, iBodypart, bStealth )
	iWait = getTickCount() + 10000;
end

function OnClientCursorMove( _, _, fAbsoluteX, fAbsoluteY )
	if isCursorShowing() or isMTAWindowActive() then
		return;
	end
	
	fAbsoluteX = fAbsoluteX - fScreenX / 2;
    fAbsoluteY = fAbsoluteY - fScreenY / 2;
	
    fMouseX = fMouseX + fAbsoluteX * 0.05 * 0.01745;
    fMouseY = fMouseY + fAbsoluteY * 0.05 * 0.01745;
	
	if fMouseX > math.pi then
		fMouseX = fMouseX - 2 * math.pi;
	elseif fMouseX < -math.pi then
		fMouseX = fMouseX + 2 * math.pi;
	end
	
	if fMouseY > math.pi then
		fMouseY = fMouseY - 2 * math.pi;
	elseif fMouseY < -math.pi then
		fMouseY = fMouseY + 2 * math.pi;
	end
	
    if fMouseY < -math.pi / 2.05 then
       fMouseY = -math.pi / 2.05;
    elseif fMouseY > math.pi / 2.05 then
        fMouseY = math.pi / 2.05;
    end
end

addEventHandler( "onClientCursorMove", root, OnClientCursorMove );
addEventHandler( "onClientPreRender", root, OnPreRender );
addEventHandler( "onClientRender", root, OnRender );
