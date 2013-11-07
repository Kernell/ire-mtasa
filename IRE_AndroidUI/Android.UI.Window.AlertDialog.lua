-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
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
	end;
	
	SetIcon				= function( this, sIconName )
		this.m_sIconName	= sIconName;
	end;
	
	SetMessage			= function( this, sText )
		this.m_sText	= sText;
	end;
	
	SetItems			= function( this, aItems, vHandler )
		this.m_pItems	= { aItems, vHandler };
	end;
	
	SetNegativeButton	= function( this, sText, vHandler )
		this.m_pNegativeButton	= { sText, vHandler );
	end;
	
	SetPositiveButton	= function( this, sText, vHandler )
		this.m_pPositiveButton	= { sText, vHandler );
	end;
	
	SetNeutralButton	= function( this, sText, vHandler )
		this.m_pNeutralButton	= { sText, vHandler );
	end;
};