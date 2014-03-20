-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUIGovFactionEdit ( CGUI, CUIAsyncQuery )
{
	X		= "center";
	Y		= "center";
	Width	= 600;
	Height	= 365;
	
	CUIGovFactionEdit	= function( this, iFactionID )
		this.Window = this:CreateWindow( "Управление организацией" )
		{
			X		= this.X;
			Y		= this.Y;
			Width	= this.Width;
			Height	= this.Height;
			Sizable	= false;
		};
		
		this.ButtonClose	= this.Window:CreateButton( "Закрыть" )
		{
			X		= this.Width - 90;
			Y		= this.Height - 35;
			Width	= 80;
			Height	= 25;
			
			Click	= function()
				delete ( this );
			end;
		};
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
		
		Ajax:HideLoader();
	end;
	
	_CUIGovFactionEdit	= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		this:HideCursor();
		
		Ajax:HideLoader();
	end;
};
