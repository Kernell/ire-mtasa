-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version
	
class "Android.UI.Window.AlertDialog" ( Android.UI.Window )
{
	BUTTON_POSITIVE		= -1;
	BUTTON_NEGATIVE		= -2;
	BUTTON_NEUTRAL		= -3;
	
	OnWindowCreate		= function( this )
		if this.OnCreate then
			this:OnCreate();
		end
	end;
	
	SetIcon				= function( this, sIconName )
		
	end;
	
	SetMessage			= function( this, sText )
		
	end;
	
	SetItems			= function( this, aItems, vHandler )
		
	end;
	
	SetNegativeButton	= function( this, sText, vHandler )
		
	end;
	
	SetPositiveButton	= function( this, sText, vHandler )
		
	end;
	
	SetNeutralButton	= function( this, sText, vHandler )
		
	end;
};