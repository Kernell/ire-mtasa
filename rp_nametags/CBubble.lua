-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CBubble";

function CBubble:CBubble( pPed, sText, iSeconds, fDistance, Color, BackgroundColor )
	self.m_pPed				= pPed;
	self.m_sText			= sText;
	self.m_fDistance		= fDistance or g_fMaxDistance or 8.0;
	self.m_Color			= Color or { R = 255, G = 255, B = 255, A = 200 };
	self.m_BackgroundColor	= BackgroundColor or { R = 0, G = 0, B = 0, A = 170 };
	
	self.m_iStart			= getTickCount();
	self.m_iSeconds			= (int)(iSeconds) or 10000;
	self.m_iEnd				= self.m_iStart + self.m_iSeconds;
	
	g_pBubbleManager:AddToList( self );
end

-- function CBubble:_CBubble()
	-- g_pBubbleManager:RemoveFromList( self );
-- end

function CBubble:Draw( iTick, iIndex )
	if g_vecPosition then
		if self.m_Color.A > 0 and self.m_pPed:GetDimension() == g_iDimension and self.m_pPed:GetInterior() == g_iInterior and self.m_pPed:IsOnScreen() and self.m_pPed:GetAlpha() > 64 then
			local vecBonePosition	= self.m_pPed:GetBonePosition( 4 );
			
			vecBonePosition.Z		= vecBonePosition.Z + .57;
			
			local fDistance 		= g_vecPosition:Distance( vecBonePosition );
			
			if fDistance <= self.m_fDistance then
				if g_vecPosition:IsLineOfSightClear( vecBonePosition, true, false, false, true, false, false, true ) then
					local fScreenX, fScreenY	= getScreenFromWorldPosition( vecBonePosition.X, vecBonePosition.Y, vecBonePosition.Z );
				
					if fScreenX and fScreenY then
						fScreenY		= fScreenY - ( 24 * iIndex );
						
						local fAlphaP	= 1 - ( self.m_iEnd - iTick ) / self.m_iSeconds;
						
						if fAlphaP >= 1 then
							-- local fAlphaP	= 1 - ( self.m_iEnd + 5000 - iTick ) / self.m_iSeconds;
							
							self.m_Color.A				= self.m_Color.A * ( 2.0 - fAlphaP );
							self.m_BackgroundColor.A	= self.m_BackgroundColor.A * ( 2.0 - fAlphaP );
						end
						
						local iColor			= tocolor( self.m_Color.R, self.m_Color.G, self.m_Color.B, self.m_Color.A );
						local iBackgroundColor	= tocolor( self.m_BackgroundColor.R, self.m_BackgroundColor.G, self.m_BackgroundColor.B, self.m_BackgroundColor.A );
						
						do
							local fWidth 		= dxGetTextWidth( self.m_sText, 1.0, "default-bold" ) + 50.0;
							local fScreenX		= fScreenX - ( fWidth * .5 );
							local fScreenY		= fScreenY + 2;
							
							dxDrawRectangle( fScreenX + 04, fScreenY - 4, fWidth - 04 * 2, 1, iBackgroundColor );
							dxDrawRectangle( fScreenX + 02, fScreenY - 3, fWidth - 02 * 2, 2, iBackgroundColor );
							dxDrawRectangle( fScreenX + 01, fScreenY - 1, fWidth - 01 * 2, 1, iBackgroundColor );
							
							dxDrawRectangle( fScreenX, fScreenY, fWidth, 10, iBackgroundColor );
							
							dxDrawRectangle( fScreenX + 01, fScreenY + 10, fWidth - 01 * 2, 2, iBackgroundColor );
							dxDrawRectangle( fScreenX + 02, fScreenY + 12, fWidth - 02 * 2, 1, iBackgroundColor );
							dxDrawRectangle( fScreenX + 04, fScreenY + 13, fWidth - 04 * 2, 1, iBackgroundColor );
						end
						
						dxDrawText( self.m_sText, fScreenX, fScreenY, fScreenX, fScreenY, iColor, 1.0, 'default-bold', 'center', 'top' );
					end
				end
				
				return true;
			end	
		end
		
		return false;
	end
	
	return true;
end