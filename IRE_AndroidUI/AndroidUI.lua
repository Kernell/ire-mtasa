-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

THEME_HOLO_DARK		= 0x00000002;
THEME_HOLO_LIGHT	= 0x00000003;

class: AndroidUI
{
	FONT_DIALOG_TITLE	= dxCreateFont( "Resources/fonts/Roboto-Regular.ttf", 11.0, false );
	FONT_REGULAR		= dxCreateFont( "Resources/fonts/DroidSans.ttf", 9.0, false );
	
	ICON_EXT		= ".png";
	IMAGES_PATH		= "Resources/icons/";
	m_iTheme		= THEME_HOLO_DARK; -- Settings.Android.Theme;
	m_bVisible		= true;
	
	GetIconsPath	= function( this )
		return this.IMAGES_PATH + ( this.m_iTheme == THEME_HOLO_LIGHT and "holo_light/" or "holo_dark/" );
	end;
	
	Create	= function( this )
		AndroidUIManager:Add( this );
	end;
	
	Close	= function( this )
		AndroidUIManager:Remove( this );
	end;
	
	IsVisible	= function( this )
		return this.m_bVisible;
	end;
	
	Show	= function( this )
		this.m_bVisible = true;
	end;
	
	Hide	= function( this )
		this.m_bVisible = false;
	end;
};