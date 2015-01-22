-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Bubble
{
	Bubble	= function( ped, text, seconds, distance, color, backgroundColor )
		this.Ped				= ped;
		this.Text				= text;
		this.Distance			= distance or g_fMaxDistance or 8.0;
		this.Color				= color or { R = 255, G = 255, B = 255, A = 200 };
		this.BackgroundColor	= backgroundColor or { R = 0, G = 0, B = 0, A = 170 };
		
		this.Start				= getTickCount();
		this.Seconds			= (int)(seconds) or 10000;
		this.End				= this.Start + this.Seconds;
		
		g_pBubbleManager.AddToList( this );
	end;
	
	Draw	= function( tick, index )
		if g_vecPosition then
			if this.Color.A > 0 and this.Ped.GetDimension() == g_iDimension and this.Ped.GetInterior() == g_iInterior and this.Ped.IsOnScreen() and this.Ped.GetAlpha() > 64 then
				local bonePosition	= this.Ped.GetBonePosition( 4 );
				
				bonePosition.Z		= bonePosition.Z + .57;
				
				local distance 		= g_vecPosition.Distance( bonePosition );
				
				if distance <= this.Distance then
					if g_vecPosition.IsLineOfSightClear( bonePosition, true, false, false, true, false, false, true ) then
						local screenX, screenY	= getScreenFromWorldPosition( bonePosition.X, bonePosition.Y, bonePosition.Z );
					
						if screenX and screenY then
							screenY		= screenY - ( 24 * index );
							
							local alphaP	= 1 - ( this.End - tick ) / this.Seconds;
							
							if alphaP >= 1 then
								-- local alphaP	= 1 - ( this.End + 5000 - tick ) / this.Seconds;
								
								this.Color.A			= this.Color.A * ( 2.0 - alphaP );
								this.BackgroundColor.A	= this.BackgroundColor.A * ( 2.0 - alphaP );
							end
							
							local color				= tocolor( this.Color.R, this.Color.G, this.Color.B, this.Color.A );
							local backgroundColor	= tocolor( this.BackgroundColor.R, this.BackgroundColor.G, this.BackgroundColor.B, this.BackgroundColor.A );
							
							do
								local width 		= dxGetTextWidth( this.Text, 1.0, "default-bold" ) + 50.0;
								local screenX		= screenX - ( width * .5 );
								local screenY		= screenY + 2;
								
								dxDrawRectangle( screenX + 04, screenY - 4, width - 04 * 2, 1, backgroundColor );
								dxDrawRectangle( screenX + 02, screenY - 3, width - 02 * 2, 2, backgroundColor );
								dxDrawRectangle( screenX + 01, screenY - 1, width - 01 * 2, 1, backgroundColor );
								
								dxDrawRectangle( screenX, screenY, width, 10, backgroundColor );
								
								dxDrawRectangle( screenX + 01, screenY + 10, width - 01 * 2, 2, backgroundColor );
								dxDrawRectangle( screenX + 02, screenY + 12, width - 02 * 2, 1, backgroundColor );
								dxDrawRectangle( screenX + 04, screenY + 13, width - 04 * 2, 1, backgroundColor );
							end
							
							dxDrawText( this.Text, screenX, screenY, screenX, screenY, color, 1.0, "default-bold", "center", "top" );
						end
					end
					
					return true;
				end	
			end
			
			return false;
		end
		
		return true;
	end;
};
