-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "System.Drawing.Forms.Label" ( System.Drawing.Forms.Control )
{
	ActiveBorderColor		= System.Drawing.SystemColors.ActiveBorderVS2012;
	
	Draw = function( this, Parent )
		if this.Border then
			dxDrawRectangle( this.Left - this.Border, this.Top, this.Border, this.Height, this.ActiveBorderColor:ToArgb(), true );
			dxDrawRectangle( this.Left + this.Width, this.Top, this.Border, this.Height, this.ActiveBorderColor:ToArgb(), true );
			
			dxDrawRectangle( this.Left - this.Border, this.Top - this.Border, this.Width + this.Border * 2, this.Border, this.ActiveBorderColor:ToArgb(), true );
			dxDrawRectangle( this.Left - this.Border, this.Top + this.Height, this.Width + this.Border * 2, this.Border, this.ActiveBorderColor:ToArgb(), true );
		end
		
		dxDrawText( this.Text, this.Left, this.Top, this.Left + this.Width, this.Top + this.Height, this.ForeColor:ToArgb(), this.FontScale or 1.0, this.Font or "clear", "left", "center", false, false, true );
	end;
};