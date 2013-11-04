-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

addEvent( "OnPlayerChatMessage", true );

g_fMaxDistance		= 8.0;
g_pBubbleManager	= CBubbleManager();

arialbd = dxCreateFont( 'arialbd.ttf', 10, true );

local console_active = false;
local chatbox_active = false;

function Draw( pPlayer, bPed )
	if pPlayer:GetDimension() == g_iDimension and pPlayer:GetInterior() == g_iInterior and pPlayer:IsOnScreen() and pPlayer:GetAlpha() > 64 then
		if not pPlayer:GetData( "Nametag:Showing" ) then return end
		
		local vecBonePosition	= pPlayer:GetBonePosition( 4 );
		
		vecBonePosition.Z		= vecBonePosition.Z + .5;
		
		local fDistance			= g_vecPosition:Distance( vecBonePosition );
		
		if fDistance <= g_fMaxDistance and g_vecPosition:IsLineOfSightClear( vecBonePosition, true, false, false, true, false, false, true ) then
			local fScreenX, fScreenY = getScreenFromWorldPosition( vecBonePosition.X, vecBonePosition.Y, vecBonePosition.Z );
			
			if fScreenX and fScreenY then
				local fScale 	= 1.4;
				local r, g, b 	= 255, 255, 255;
				local fAlpha	= Lerp( 255, 0, fDistance / g_fMaxDistance );
				local sText		= pPlayer:GetData( 'Nametag:Text' );
				
				local iColor3	= tocolor( 0, 0, 0, fAlpha );
				
				if sText then					
					local Color = pPlayer:GetData( 'Nametag:Color' );
					
					if Color then
						r, g, b		= Color[ 1 ], Color[ 2 ], Color[ 3 ];
					elseif not bPed then
						r, g, b 	= pPlayer:GetNametagColor();
					end
					
					local iColor1	= tocolor( r, g, b, fAlpha );
					local iColor2	= tocolor( r, g, b, fAlpha * 0.4 );
					
					dxDrawText( sText, fScreenX + 1, fScreenY + 1, fScreenX + 1, fScreenY + 1, iColor3, 1.0, arialbd, 'center', 'bottom' );
					dxDrawText( sText, fScreenX - 1, fScreenY - 1, fScreenX - 1, fScreenY - 1, iColor3, 1.0, arialbd, 'center', 'bottom' );
					dxDrawText( sText, fScreenX + 1, fScreenY - 1, fScreenX + 1, fScreenY - 1, iColor3, 1.0, arialbd, 'center', 'bottom' );
					dxDrawText( sText, fScreenX - 1, fScreenY + 1, fScreenX - 1, fScreenY + 1, iColor3, 1.0, arialbd, 'center', 'bottom' );
					dxDrawText( sText, fScreenX, fScreenY, fScreenX, fScreenY, iColor1, 1.0, arialbd, 'center', 'bottom' );
				end
				
				fScreenY		= fScreenY + 8;
				
				local fWidth, fHeight	= math.ceil( 40 * fScale ), math.ceil( 6 * fScale );
				local fBorder			= math.ceil( 1.2 * fScale );
				
				fScreenX		= fScreenX - fWidth / 2;
				
				local fArmor = math.min( 100, pPlayer:GetArmor() );
				
				if fArmor > 0 then
					dxDrawRectangle( fScreenX, fScreenY, fWidth, fHeight, iColor3 );
					
					local r, g, b = 225, 225, 225;
					
					local iColor1	= tocolor( r, g, b, fAlpha );
					local iColor2	= tocolor( r, g, b, fAlpha * 0.4 );
					
					dxDrawRectangle( fScreenX + fBorder, fScreenY + fBorder, fWidth - 2 * fBorder, fHeight - 2 * fBorder, iColor2 );
					dxDrawRectangle( fScreenX + fBorder, fScreenY + fBorder, math.floor( ( fWidth - 2 * fBorder ) / 100 * fArmor ), fHeight - 2 * fBorder, iColor1 );
					
					fScreenY = fScreenY + 1.2 * fHeight;
				end
				
				dxDrawRectangle( fScreenX, fScreenY, fWidth, fHeight, iColor3 );
				
				local fHealth	= math.min( 100, pPlayer:GetHealth() );
				local r, g, b	= 180, 25, 29;
				
				local iColor1	= tocolor( r, g, b, fAlpha );
				local iColor2	= tocolor( r, g, b, fAlpha * 0.4 );
				
				dxDrawRectangle( fScreenX + fBorder, fScreenY + fBorder, fWidth - 2 * fBorder, fHeight - 2 * fBorder, iColor2 );
				dxDrawRectangle( fScreenX + fBorder, fScreenY + fBorder, math.floor( ( fWidth - 2 * fBorder ) / 100 * fHealth ), fHeight - 2 * fBorder, iColor1 );
				
				fScreenY = fScreenY + 16;
				
				if pPlayer:GetData( 'console_active' ) then
					dxDrawImage( fScreenX + 16, fScreenY, 32, 32, "console.png", 0, 0, 0, -1 );
				end
				
				if pPlayer:GetData( 'chatbox_active' ) then
					dxDrawImage( fScreenX + 16, fScreenY, 32, 32, "chat.png", 0, 0, 0, -1 );
				end
			end
		end
	end
end

addEventHandler( 'onClientPreRender', root, 
	function()
		g_fMaxDistance		= tonumber( CLIENT:GetData( 'Nametag->MaxDistance' ) ) or 8.0;
		
		if chatbox_active then
			if not isChatBoxInputActive() then
				CLIENT:SetData( 'chatbox_active', false );
				
				chatbox_active = false;
			end
		else
			if isChatBoxInputActive() then
				CLIENT:SetData( 'chatbox_active', true );
				
				chatbox_active = true;
			end
		end
		
		if console_active then
			if not isConsoleActive() then
				CLIENT:SetData( 'console_active', false );
				
				console_active = false;
			end
		else
			if isConsoleActive() then
				CLIENT:SetData( 'console_active', true );
				
				console_active = true;
			end
		end
		
		g_vecPosition	= ( getCameraTarget() or CLIENT ):GetPosition();
		g_iDimension	= CLIENT:GetDimension();
		g_iInterior		= CLIENT:GetInterior();
		
		for _, pPlayer in ipairs( getElementsByType( 'player', root, true ) ) do
			if pPlayer ~= CLIENT then
				pPlayer:SetNametagShowing( false );
				Draw( pPlayer );
			end
		end
		
		for _, pPed in ipairs( getElementsByType( 'ped', root, true ) ) do
			Draw( pPed, true );
		end
	end
);

addEventHandler( 'OnPlayerChatMessage', root,
	function ( sMessage, iType, fDistance )
		assert( sMessage );
		assert( iType );
		
		local iColor, iBackgroundColor;
		
		if iType == 0 then
			iColor				= { R = 255, G = 255, B = 255, A = 200 };
			-- iBackgroundColor	= { R = 0,   G = 0,   B = 0,   A = 200 };
		elseif iType == 1 then
			iColor				= { R = 255, G = 0, B = 128, A = 200 };
			-- iBackgroundColor	= { R = 0,   G = 0,   B = 0,   A = 200 };
		else
			return;
		end
		
		CBubble( source, sMessage, 10000, fDistance, iColor, iBackgroundColor );
	end
);