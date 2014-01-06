-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0
	
class "Android.UI.Window.AlertDialog" ( Android.UI.Window )
{
	BUTTON_POSITIVE		= -1;
	BUTTON_NEGATIVE		= -2;
	BUTTON_NEUTRAL		= -3;
	
	OnCreate			= function( this )
		if this.OnDialogCreate then
			this:OnDialogCreate();
		end
		
		local iY = 0;
		
		if this.m_sIconName or this.m_sTitle then
			if this.m_sIconName then
				this.TitleBarIcon				= Android.UI.Image( this );
				
				this.TitleBarIcon:Load( this:GetIconsPath() + this.m_sIconName + Android.UI.ICON_EXT, "argb", false );
				this.TitleBarIcon.Location				= Android.UI.Point( 10, 10 );
				this.TitleBarIcon.Size					= Android.UI.Size( 24, 24 );
				this.TitleBarIcon.Name					= "TitleBarIcon";
			end
			
			if this.m_sTitle then
				this.TitleBarCaption			= Android.UI.Label( this );
				
				this.TitleBarCaption.Font				= Android.UI.Font.DIALOG_TITLE;
				this.TitleBarCaption.Location			= Android.UI.Point( this.TitleBarIcon and 42 or 0, 0 );
				this.TitleBarCaption.Size				= Android.UI.Size( this.Size.X - 48 - this.TitleBarCaption.Location.X, 48 );
				this.TitleBarCaption.Name				= "TitleBarCaption";
				this.TitleBarCaption.Text				= this.m_sTitle;
				this.TitleBarCaption.ForeColor			= Android.UI.SystemColors.ActiveCaptionText;
			end

			iY = iY + 48;
			
			this.TitleBarRectangle				= Android.UI.Rectangle( this );
			
			this.TitleBarRectangle.Location				= Android.UI.Point( 0, iY );
			this.TitleBarRectangle.Size					= Android.UI.Size( this.Size.X, 2 );
			this.TitleBarRectangle.ForeColor			= Android.UI.SystemColors.ActiveCaptionText;
			
			iY = iY + 2;
			
			this.Size.Y = this.Size.Y + iY;
		end
		
		if this.m_sText then
			iY = iY + 10;
			
			local fFontHeight	= dxGetFontHeight( 1.0, Android.UI.Font.NORMAL ) + 4;
			local fTextWidth	= dxGetTextWidth( this.m_sText, 1.0, Android.UI.Font.NORMAL );
			local fHeight		= ( fTextWidth / this.Size.X ) * fFontHeight;
			
			this.Text			= Android.UI.Label( this );
			
			this.Text.Font				= Android.UI.Font.NORMAL;
			this.Text.Location			= Android.UI.Point( 10, iY );
			this.Text.Size				= Android.UI.Size( this.Size.X - 10 - this.Text.Location.X, fHeight );
			this.Text.Name				= "Text";
			this.Text.Text				= this.m_sText;
			this.Text.ForeColor			= Android.UI.SystemColors.ActiveCaptionText;
			
			this.Size.Y = this.Size.Y + fHeight + 20;
			
			iY = iY + fHeight + 10;
		end
		
		local iItems = this.m_aItems and table.getn( this.m_aItems ) or 0;
		
		if iItems > 0 then
			local fHeight	= iItems * 48;
			
			this.Items			= Android.UI.ItemMenu( this );
			
			function this.Items.OnClick( pSender, ... )
				local iIndex = 0;
				
				if this.m_vItemsHandler then
					this:m_vItemsHandler( iIndex );
				end
			end
			
			this.Items.Location 		= Android.UI.Point( 0, iY );
			this.Items.Size 			= Android.UI.Size( this.Size.X, fHeight );
			this.Items.Click:Add	( this.Items.OnClick );
			this.Items.AddRange		( this.m_aItems );
			
			this.Size.Y = this.Size.Y + fHeight;
		end
		
		local iButtons	= 0;
		local fHeight	= 48;
		
		if this.m_sNegativeButton then
			iButtons	= iButtons + 1;
			
			this.NegativeButton	= Android.UI.Button( this );
			
			this.NegativeButton.Text	= this.m_sNegativeButton;
			
			function this.NegativeButton.OnClick( pSender, ... )
				if this.m_vNegativeButtonHandler then
					this:m_vNegativeButtonHandler( this.BUTTON_NEGATIVE );
				end
			end
		end
		
		if this.m_sPositiveButton then
			iButtons	= iButtons + 1;
			
			this.PositiveButton	= Android.UI.Button( this );
			
			this.PositiveButton.Text	= this.m_sPositiveButton;
			
			function this.PositiveButton.OnClick( pSender, ... )
				if this.m_vPositiveButtonHandler then
					this:m_vPositiveButtonHandler( this.BUTTON_POSITIVE );
				end
			end
		end
		
		if this.m_sNeutralButton then
			iButtons	= iButtons + 1;
			
			this.NeutralButton	= Android.UI.Button( this );
			
			this.NeutralButton.Text	= this.m_sNeutralButton;
			
			function this.NeutralButton.OnClick( pSender, ... )
				if this.m_vNeutralButtonHandler then
					this:m_vNeutralButtonHandler( this.BUTTON_NEUTRAL );
				end
			end
		end
		
		local fWidth	= this.Size.X / iButtons;
		local fX		= 0;
		
		if this.PositiveButton then
			this.PositiveButton.Size		= Android.UI.Size( fWidth, fHeight );
			this.PositiveButton.Location	= Android.UI.Point( fX, iY );
			
			fX = fX + iWidth;
		end
		
		if this.NeutralButton then
			this.NeutralButton.Size			= Android.UI.Size( fWidth, fHeight );
			this.NeutralButton.Location		= Android.UI.Point( fX, iY );
			
			fX = fX + iWidth;
		end
		
		if this.NegativeButton then
			this.NegativeButton.Size		= Android.UI.Size( fWidth, fHeight );
			this.NegativeButton.Location	= Android.UI.Point( fX, iY );
		end
		
		if iButtons > 0 then
			this.Size.Y = this.Size.Y + fHeight;
		end
		
		this.Location.X = ( g_iScreenX - this.Size.X ) * 0.5;
		this.Location.Y = ( g_iScreenY - this.Size.Y ) * 0.5;
	end;
	
	SetIcon				= function( this, sIconName )
		this.m_sIconName	= sIconName;
	end;
	
	SetTitle			= function( this, sTitle )
		this.m_sTitle	= sTitle;
	end;
	
	SetMessage			= function( this, sText )
		this.m_sText	= sText;
	end;
	
	SetItems			= function( this, aItems, vHandler )
		this.m_aItems			= aItems;
		this.m_vItemsHandler	= vHandler;
	end;
	
	SetNegativeButton	= function( this, sText, vHandler )
		this.m_sNegativeButton			= sText, vHandler;
		this.m_vNegativeButtonHandler	= vHandler;
	end;
	
	SetPositiveButton	= function( this, sText, vHandler )
		this.m_sPositiveButton			= sText;
		this.m_vPositiveButtonHandler	= vHandler;
	end;
	
	SetNeutralButton	= function( this, sText, vHandler )
		this.m_sNeutralButton			= sText;
		this.m_vNeutralButtonHandler	= vHandler;
	end;
};