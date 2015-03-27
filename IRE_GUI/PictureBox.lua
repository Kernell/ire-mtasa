-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. PictureBox : Control
{
	ActiveBorderColor		= SystemColors.ActiveBorderVS2012;

	PictureBox	= function()
		this.Control();
	end;
	
	Draw = function()
		if this.Border then
			dxDrawRectangle( this.Left - this.Border, this.Top, this.Border, this.Height, this.ActiveBorderColor.ToArgb(), true );
			dxDrawRectangle( this.Left + this.Width, this.Top, this.Border, this.Height, this.ActiveBorderColor.ToArgb(), true );
			
			dxDrawRectangle( this.Left - this.Border, this.Top - this.Border, this.Width + this.Border * 2, this.Border, this.ActiveBorderColor.ToArgb(), true );
			dxDrawRectangle( this.Left - this.Border, this.Top + this.Height, this.Width + this.Border * 2, this.Border, this.ActiveBorderColor.ToArgb(), true );
		end
		
		dxDrawImage( this.Left, this.Top, this.Width, this.Height, this.Image.material, 0, 0, 0, -1, true );
	end;
};
