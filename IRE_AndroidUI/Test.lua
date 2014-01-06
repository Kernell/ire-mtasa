-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: TestDialog ( Android.UI.Window.AlertDialog )
{
	OnDialogCreate	= function( this )
		this:SetIcon( "10-device-access-brightness-medium" );
		this:SetTitle( "Brightness" );
		
	--	this:SetMessage( "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." );
		this:SetItems( { "Menu item 1", "Menu item 2", "Menu item 3", "Menu item 4", "Menu item 5" }, this.OnSelect );
		
		this:SetNegativeButton	( "Отмена",	this.OnClick );
		this:SetPositiveButton	( "ОК", 	this.OnClick );
		this:SetNeutralButton	( "Whut?", 	this.OnClick );
	end;
	
	OnSelect	= function( this, iIndex )
		Debug( "OnSelect->" + (string)(iIndex) );
	end;
	
	OnClick		= function( this, iButton )
		if iButton == this.BUTTON_POSITIVE then
			Debug( "OnClick->BUTTON_POSITIVE" );
		elseif iButton == this.BUTTON_NEGATIVE then
			Debug( "OnClick->BUTTON_NEGATIVE" );
		elseif iButton == this.BUTTON_NEUTRAL then
			Debug( "OnClick->BUTTON_NEUTRAL" );
		end
	end;
	
	OnCancel		= function( this )
		
	end;
	
	OnDismiss		= function( this )
		
	end;
};

TestDialog();
