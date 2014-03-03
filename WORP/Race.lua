-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local fScrW, fScrH = guiGetScreenSize();
local RenderRace, RaceDrawText, RaceDrawBlock;
local l_sText, l_iStart, l_iDuration, l_Players;

local gl_iStart, gl_iRaceLap, gl_iLaps;

local WIDTH		= 260;
local WIDTH_1	= 30;
local WIDTH_2	= 130;
local WIDTH_3	= 100;
local HEIGHT	= 30;
local X			= g_iScreenX - WIDTH - 20;
local X_1		= X;
local X_2		= X + WIDTH_1 + 1;
local X_3		= X + WIDTH_1 + WIDTH_2 + 2;

local TextColor			= tocolor( 255, 255, 255, 196 );
local TextColorActive	= tocolor( 255, 100, 100, 255 );
local BackgroundColor	= tocolor( 64, 32, 0, 128 );

function RaceDrawBlock( sText, fX, fY, fWidth, fHeight, iColor, sTextAlign )
	dxDrawRectangle( fX, fY, fWidth, fHeight, BackgroundColor );
	
	RaceDrawText( sText, fX + ( sTextAlign ~= "center" and 10 or 0 ), fY, ( fX + fWidth ) - ( sTextAlign ~= "center" and 15 or 0 ), fY + fHeight, iColor, sTextAlign );
end

function RaceDrawText( sText, fX, fY, fWidth, fHeight, iColor, sTextAlign )
	dxDrawText( sText, fX + 1, fY + 1, fWidth, fHeight, COLOR_BLACK,	1.0, "default-bold", sTextAlign or "left", "center", false, false, true );
	dxDrawText( sText, fX - 1, fY - 1, fWidth, fHeight, COLOR_BLACK,	1.0, "default-bold", sTextAlign or "left", "center", false, false, true );
	dxDrawText( sText, fX + 1, fY - 1, fWidth, fHeight, COLOR_BLACK,	1.0, "default-bold", sTextAlign or "left", "center", false, false, true );
	dxDrawText( sText, fX - 1, fY + 1, fWidth, fHeight, COLOR_BLACK,	1.0, "default-bold", sTextAlign or "left", "center", false, false, true );
	dxDrawText( sText, fX,     fY,     fWidth, fHeight, iColor, 		1.0, "default-bold", sTextAlign or "left", "center", false, false, true );
end

function RenderRace()
	if l_iStart and l_iDuration then
		local iTick = getTickCount();
		
		if iTick > l_iStart + l_iDuration then
			l_iStart		= NULL;
			l_iDuration		= NULL;
			l_sText			= NULL;
		else
			local fAlpha = 1.0;
			
			if l_iStart + l_iDuration / 2 < iTick then
				fAlpha	= ( l_iStart + l_iDuration - iTick ) / l_iDuration * 2;
			end
			
			dxDrawText( l_sText, 0 + 3, fScrH * .25 + 3, fScrW, fScrH, tocolor( 0, 0, 0, 255 * fAlpha ),     2, "pricedown", "center", "top", true, false, true );
			dxDrawText( l_sText, 0 - 3, fScrH * .25 - 3, fScrW, fScrH, tocolor( 0, 0, 0, 255 * fAlpha ),     2, "pricedown", "center", "top", true, false, true );
			dxDrawText( l_sText, 0 + 3, fScrH * .25 - 3, fScrW, fScrH, tocolor( 0, 0, 0, 255 * fAlpha ),     2, "pricedown", "center", "top", true, false, true );
			dxDrawText( l_sText, 0 - 3, fScrH * .25 + 3, fScrW, fScrH, tocolor( 0, 0, 0, 255 * fAlpha ),     2, "pricedown", "center", "top", true, false, true );
			dxDrawText( l_sText, 0,     fScrH * .25,     fScrW, fScrH, tocolor( 229, 222, 221, 255 * fAlpha ), 2, "pricedown", "center", "top", true, false, true );
		end
	end
	
	if l_Players then
		local fY = 86;
		
		local iRaceDiff = gl_iStart and ( gl_iStart == 0 and 0 or getTickCount() - gl_iStart );
		
		local sTimer = iRaceDiff and ( "%02dm %02ds %02dms" ):format( iRaceDiff / 60000, ( iRaceDiff % 60000 ) / 1000, ( iRaceDiff % 1000 ) / 10 ) or "";
		
		RaceDrawBlock( sTimer, X, fY, WIDTH + 2, 30, TextColor, "right" );
		
		if gl_iLaps and gl_iLaps > 1 and gl_iRaceLap then
			RaceDrawText( "Круг " + gl_iRaceLap + "/" + gl_iLaps, X + 10, fY, X + WIDTH, fY + 30, TextColor, "left" );
		end
		
		for i, pPlr in ipairs( l_Players ) do
			if isElement( pPlr ) then
				fY = fY + 31;
				
				if not pPlr.m_Race then
					pPlr.m_Race =
					{
						m_fY	= fScrH + 100;
						m_iEnd	= getTickCount() + 1000;
					};
				end
				
				if fY ~= pPlr.m_Race.m_fTargetY then
					pPlr.m_Race.m_fTargetY 	= fY;
					pPlr.m_Race.m_iEnd 		= getTickCount() + 1000;
				end
				
				local Color	= TextColor;
				
				if pPlr == CLIENT then
					Color	= TextColorActive;
				end
				
				pPlr.m_Race.m_fY	= interpolateBetween( pPlr.m_Race.m_fY, 0, 0, pPlr.m_Race.m_fTargetY, 0, 0, 1 - ( pPlr.m_Race.m_iEnd - getTickCount() ) / 1000, "InQuad" );
				
				local iFinishTime	= pPlr:GetData( "CRace::m_iFinishTime" );
				local sFinishTime	= iFinishTime and ( "%02dm %02ds %02dms" ):format( iFinishTime / 60000, ( iFinishTime % 60000 ) / 1000, ( iFinishTime % 1000 ) / 10 ) or "";
				
				RaceDrawBlock( (string)(i), 			X_1, pPlr.m_Race.m_fY, WIDTH_1,	HEIGHT, Color, "center" );
				RaceDrawBlock( pPlr:GetNametagText(), 	X_2, pPlr.m_Race.m_fY, WIDTH_2,	HEIGHT, Color, "left" );
				RaceDrawBlock( sFinishTime, 			X_3, pPlr.m_Race.m_fY, WIDTH_3,	HEIGHT, Color, "center" );
			end
		end
	end
end

function SetRaceCountText( sText )
	l_iStart	= getTickCount();
	l_iDuration	= 1100;
	l_sText		= (string)(sText);
end

function UpdateScoreBoard( Players, iRaceDiffServer, iRaceLap, iLaps )
	if not l_Players and Players then
		for i, pPlr in ipairs( Players ) do
			pPlr.m_Race = NULL
		end
	end
	
	if Players == NULL then
		gl_iStart	= NULL;
	elseif ( gl_iStart == NULL and iRaceDiffServer ) or gl_iStart == 0 then
		gl_iStart	= iRaceDiffServer > 0 and getTickCount() or 0;
	elseif gl_iStart ~= NULL then
		local iRaceDiff = getTickCount() - gl_iStart;
		
		gl_iStart = gl_iStart - ( iRaceDiffServer - iRaceDiff );
	end
	
	gl_iRaceLap	= iRaceLap;
	gl_iLaps	= iLaps;
	l_Players	= Players;
	
	if gl_iLaps and gl_iLaps > 1 and gl_iRaceLap then
		resourceRoot.m_pHUD.m_pVehicleHUD.m_pRaceLaps.m_iLap		= gl_iRaceLap;
		resourceRoot.m_pHUD.m_pVehicleHUD.m_pRaceLaps.m_iLaps		= gl_iLaps;
		
		resourceRoot.m_pHUD.m_pVehicleHUD.m_pRaceLaps.m_bEnabled	= true;
	else
		resourceRoot.m_pHUD.m_pVehicleHUD.m_pRaceLaps.m_bEnabled	= false;
	end
	
	if gl_iStart then
		resourceRoot.m_pHUD.m_pVehicleHUD.m_pRaceTime.m_iTime		= gl_iStart;
		resourceRoot.m_pHUD.m_pVehicleHUD.m_pRaceTime.m_bEnabled	= true;
	else
		resourceRoot.m_pHUD.m_pVehicleHUD.m_pRaceTime.m_bEnabled	= false;
	end
	
	if Players then
		local iPosition = 0;
		
		for i, pPlr in ipairs( Players ) do
			if pPlr == CLIENT then
				iPosition = i;
				
				break;
			end
		end
		
		resourceRoot.m_pHUD.m_pVehicleHUD.m_pRacePosition.m_iPosition	= iPosition;
		resourceRoot.m_pHUD.m_pVehicleHUD.m_pRacePosition.m_bEnabled	= true;
	else
		resourceRoot.m_pHUD.m_pVehicleHUD.m_pRacePosition.m_bEnabled	= false;
	end
end

addEventHandler( "onClientRender", root, RenderRace );
