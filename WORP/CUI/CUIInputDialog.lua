-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUIInputDialog ( CGUI )
{
	CUIInputDialog		= function( this, sTitle, iMaxLength )
		this.Window		= this:CreateWindow( sTitle )
		{
			X			= "center";
			Y			= "center";
			Width		= 200;
			Height		= 100;
		};
		
		this.Window.Input	= this.Window:CreateEdit( "" )
		{
			X			= 10;
			Y			= 25;
			Width		= this.Window.Width - 20;
			Height		= 25;
			MaxLength	= iMaxLength or 16;
			Enabled		= false;
		};
		
		this.Window.ButtonCancel	= this.Window:CreateButton( "Отмена" )
		{
			X		= this.Window.Width - 100;
			Y		= this.Window.Input.Y + this.Window.Input.Height + 10;
			Width	= 90;
			Height	= 30;
			
			Click	= function()
				delete ( this );
			end;
		};
		
		this.Window.ButtonOk		= this.Window:CreateButton( "OK" )
		{
			X		= this.Window.ButtonCancel.X - this.Window.ButtonCancel.Width - 10;
			Y		= this.Window.ButtonCancel.Y;
			Width	= this.Window.ButtonCancel.Width;
			Height	= this.Window.ButtonCancel.Height;
		
			Click	= function()
				local sValue = this.Window.Input:GetText();
				
				this.Window.ButtonCancel.Click();
				
				if this.OnAccept then
					this:OnAccept( sValue );
				end
			end;
		};
		
		this.Window.Input.Accept = this.Window.ButtonOk.Click;
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
	end;
	
	_CUIInputDialog		= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		this:HideCursor();
	end;
};
