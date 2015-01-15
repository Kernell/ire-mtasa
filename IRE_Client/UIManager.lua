-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. UIManager
{
	Cursor		= NULL;
	
	UIManager	= function()
		this.UIList	= {};
		
		this.UI	=
		{
			__index = function( self, key )
				if not this.UIList[ key ] then
					local ui = NULL;
					
					if _G[ key ] then
						ui = new[ key ]( key );
					else
						ui = new. UIDialog( key );
					end
					
					if ui.IsValid() then					 
						this.UIList[ key ] = ui;
					else
						Debug( "failed to load '" + key + "'", 1 );
					end
				end
				
				return this.UIList[ key ];
			end;
		};
		
		setmetatable( this.UI, this.UI );
		
		this.UIList.Font		= new. UIFont();
		this.UIList.Cursor		= new. UICursor();
		this.UIList.RadialMenu	= new. UIRadialMenu();
	end;
	
	_UIManager	= function()
		for i, ui in pairs( this.UIList ) do
			local className = classname( ui );
			
			if className ~= "UIFont" and className ~= "UICursor" and className ~= "UIRadialMenu" then
				delete ( ui );
			end
		end
		
		delete ( this.UIList.UIRadialMenu );
		delete ( this.UIList.UICursor );
		delete ( this.UIList.UIFont );
		
		this.UIList = NULL;
	end;
};
