-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

THEME_HOLO_DARK		= 0x00000002;
THEME_HOLO_LIGHT	= 0x00000003;

local Layout	=
{
	Title	=
	{
	};
	Content	=
	{
	};
	Buttons	=
	{
	}
};

class: AlertDialog
{
	m_fWidth		= 290;
	m_fHeight		= 100;
	
	m_pLayout		= Layout;
	m_iTheme		= THEME_HOLO_DARK; --Settings.Android.Theme;
	
	AlertDialog		= function( this )
		this.m_Buttons	= {};
	end;
	
	SetIcon			= function( this, sIconName )
		this.m_pIcon = dxCreateTexture( ":WORP/Resources/Images/holo_light/" + sIconName + ".png" );
	end;
	
	SetTitle		= function( this, sText )
		this.m_sTitle	= sText;
	end;
	
	SetMessage		= function( this, sText )
		this.m_sMessage = sText;
	end;
	
	AddButton		= function( this, sText, vCallback )
		table.insert( this.m_Buttons, { Text = sText, Callback = vCallback } );
	end;
	
	Create			= function( this )
	
	end;
};
