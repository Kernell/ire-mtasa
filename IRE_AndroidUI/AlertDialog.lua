-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: AlertDialog ( AndroidUI )
{
	Width		= 290;
	Height		= 0;
	
	BackColor	= tocolor( 40, 40, 40, 255 );
	
	AlertDialog		= function( this, iTheme )
		this.m_iTheme	= iTheme or AndroidUI.m_iTheme;
		this.m_Buttons	= {};
	end;
	
	Create			= function( this )
		local iY = 0;
		
		this.m_Layout	= {};
		
		if this.m_pIcon then
			table.insert( this.m_Layout, { Type = "Image",	Value = this.m_pIcon, 			X = 10, Y = 10, Width = 24, Height = 24 } );
			table.insert( this.m_Layout, { Type = "Text",	Value = (string)(this.m_sTitle), X = 42, Y = 0, Width = this.Width - 48, Height = 48, Color = tocolor( 51, 181, 229, 255 ), Font = AndroidUI.FONT_DIALOG_TITLE } );
			
			iY = iY + 48;
			
			table.insert( this.m_Layout, { Type = "Rectangle",	Color = tocolor( 51, 181, 229, 255 ), 	X = 0,  Y = iY, Width = this.Width, Height = 2 } );
			
			iY = iY + 2;
			
			this.Height = this.Height + 50;
		end
		
		if this.m_sText then
			iY = iY + 10;

			local sText		= (string)(this.m_sText);
			
			local fFontHeight	= dxGetFontHeight( 1.0, this.Font or AndroidUI.FONT_REGULAR ) + 4;
			local fTextWidth	= dxGetTextWidth( sText, 1.0, this.Font or AndroidUI.FONT_REGULAR );
			
			local fHeight	= ( fTextWidth / this.Width ) * fFontHeight;
			
			table.insert( this.m_Layout, { Type = "Text",	Value = sText, X = 20, Y = iY, Width = this.Width - 40, Height = fHeight, Color = tocolor( 255, 255, 255, 255 ) } );
			
			this.Height = this.Height + fHeight + 20;

			iY = iY + fHeight + 10;
		end
		
		local iItems = this.m_aItems and table.getn( this.m_aItems ) or 0;
		
		if iItems > 0 then
			for i, sItem in ipairs( this.m_aItems ) do
				table.insert( this.m_Layout, { Type = "MenuItem", Value = sItem, X = 0, Y = iY, Width = this.Width, Height = 48, Index = i } );
				
				iY = iY + 48;
			end
			
			this.Height = this.Height + ( iItems * 48 );
		end
		
		local iButtons = this.m_Buttons and table.getn( this.m_Buttons ) or 0;
		
		if iButtons > 0 then
			local iWidth = this.Width / iButtons;
			local fX = 0;
			
			for i, pBtn in ipairs( this.m_Buttons ) do
				table.insert( this.m_Layout, { Type = "Button", Value = pBtn.Text, X = fX, Y = iY, Width = iWidth, Height = 48, Index = i } );
				
				fX = fX + iWidth;
			end
			
			this.Height = this.Height + 48;
		end
		
		local fScreenX, fScreenY = guiGetScreenSize();
		
		this.X = ( fScreenX - this.Width ) / 2;
		this.Y = ( fScreenY - this.Height ) / 2;
		
		AndroidUI.Create( this );
	end;
	
	SetIcon			= function( this, sIconName )
		this.m_pIcon = dxCreateTexture( this:GetIconsPath() + sIconName + AndroidUI.ICON_EXT, "argb", false );
	end;
	
	SetTitle		= function( this, sText )
		this.m_sTitle = sText;
	end;
	
	SetMessage		= function( this, sText )
		this.m_sText = sText;
	end;
	
	SetItems		= function( this, aItems )
		this.m_aItems = aItems;
	end;
	
	AddButton		= function( this, sText, vCallback )
		table.insert( this.m_Buttons, { Text = sText, Callback = vCallback } );
	end;
	
	Draw	= function( this, iCurX, iCurY )
		dxDrawRectangle( this.X + 1, 	this.Y, 		this.Width - 2, 1, 	tocolor( 40, 40, 40, 200 ), false );
		dxDrawRectangle( this.X, 		this.Y + 1, 	this.Width, 1, 		tocolor( 40, 40, 40, 200 ), false );
		dxDrawRectangle( this.X, 		this.Y, 		this.Width, 1, 		tocolor( 40, 40, 40, 42 ), false );
		
		dxDrawRectangle( this.X + 1, 	this.Y + this.Height - 1, 		this.Width - 2, 1, tocolor( 40, 40, 40, 200 ), false );
		dxDrawRectangle( this.X, 		this.Y + this.Height - 2, 		this.Width, 1, tocolor( 40, 40, 40, 200 ), false );
		dxDrawRectangle( this.X, 		this.Y + this.Height - 1, 		this.Width, 1, tocolor( 40, 40, 40, 42 ), false );
		
		dxDrawRectangle( this.X + 2, 	this.Y, 		this.Width - 4, 1, 	tocolor( 40, 40, 40, 255 ), false ); -- top
		dxDrawRectangle( this.X, 		this.Y + 2, 1, 	this.Height - 4, 	tocolor( 40, 40, 40, 255 ), false ); -- left
		
		dxDrawRectangle( this.X + 2, this.Y + this.Height - 1, this.Width - 4, 1, tocolor( 40, 40, 40, 100 ), false ); -- bottom
		dxDrawRectangle( this.X + this.Width - 1, this.Y + 2, 1, this.Height - 4, tocolor( 40, 40, 40, 240 ), false ); -- right
		
		dxDrawRectangle( this.X + 1, this.Y + 1, this.Width - 2, this.Height - 2, tocolor( 40, 40, 40, 255 ), false );
		
		local iCurX, iCurY = getCursorPosition();
		
		iCurX, iCurY = ( iCurX or 0 ) * g_iScreenX, ( iCurY or 0 ) * g_iScreenY;
		
		for i = table.getn( this.m_Layout ), 1, -1 do
			local pItem		= this.m_Layout[ i ];
			
			local bHover	= false;
			local fX		= this.X + pItem.X;
			local fY		= this.Y + pItem.Y;
			local fWidth	= pItem.Width;
			local fHeight	= pItem.Height;
			local vValue	= pItem.Value;
			local iColor	= pItem.Color;
			
			if not bHover then
				if iCurX > fX and iCurX < fX + fWidth and iCurY > fY and iCurY < fY + fHeight then
					bHover = true;
				end
			end
			
			if pItem.Type == "Text" then
				dxDrawText( vValue, fX, fY, fX + fWidth, fY + fHeight, iColor, 1.0, pItem.Font or AndroidUI.FONT_REGULAR, "left", "center", false, true, false );
			elseif pItem.Type == "Image" then
				dxDrawImage( fX, fY, fWidth, fHeight, vValue );
			elseif pItem.Type == "Rectangle" then
				dxDrawRectangle( fX, fY, fWidth, fHeight, iColor, false );
			elseif pItem.Type == "MenuItem" then
				if pItem.Index ~= 1 then
					dxDrawRectangle( fX, fY, fWidth, 1, tocolor( 255, 255, 255, 25 ), false );
				end
				
				if bHover then
					dxDrawRectangle( fX, fY, fWidth, fHeight, tocolor( 51, 181, 229, 64 ), false );
				end
				
				if bPressed then
					dxDrawRectangle( fX, fY, fWidth, fHeight, tocolor( 51, 181, 229, 153 ), false );
				end
				
				dxDrawText( vValue, fX + 25, fY, fX + fWidth - 50, fY + fHeight, -1, 1.0, AndroidUI.FONT_DIALOG_TITLE, "left", "center", false, true, false );
			elseif pItem.Type == "Button" then
				dxDrawRectangle( fX, fY, fWidth, 1, tocolor( 255, 255, 255, 25 ), false );
				
				dxDrawText( vValue, fX, fY, fX + fWidth, fY + fHeight, -1, 1.0, AndroidUI.FONT_REGULAR, "center", "center", false, true, false );
				
				if pItem.Index ~= 1 then
					dxDrawRectangle( fX, fY, 1, fHeight, tocolor( 255, 255, 255, 25 ), false );
				end
			end
		end
	end;
};
