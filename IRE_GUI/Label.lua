-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Label : Control
{
	ActiveBorderColor		= SystemColors.ActiveBorderVS2012;
	BackColor				= Color.Transparent;

	Font			= "clear";
	WordBreak		= false;
	Clip			= true;
	Align			= "left";
	VerticalAlign	= "top";
	FontScale		= 1.0;

	Label	= function()
		this.Control();
	end;
	
	Draw = function( parent, iCurX, iCurY )
		if this.Border then
			local activeBorderColor = this.ActiveBorderColor.ToArgb();

			dxDrawRectangle( this.Left - this.Border, this.Top, this.Border, this.Height, activeBorderColor, this.PostGUI );
			dxDrawRectangle( this.Left + this.Width, this.Top, this.Border, this.Height, activeBorderColor, this.PostGUI );
			
			dxDrawRectangle( this.Left - this.Border, this.Top - this.Border, this.Width + this.Border * 2, this.Border, activeBorderColor, this.PostGUI );
			dxDrawRectangle( this.Left - this.Border, this.Top + this.Height, this.Width + this.Border * 2, this.Border, activeBorderColor, this.PostGUI );
		end

		if this.BackColor then
			dxDrawRectangle( this.Left, this.Top, this.Width, this.Height, this.BackColor.ToArgb(), this.PostGUI );
		end
		
		dxDrawText( this.Text, this.Left, this.Top, this.Left + this.Width, this.Top + this.Height, this.ForeColor.ToArgb(), this.FontScale, this.Font, this.Align, this.VerticalAlign, this.Clip, this.WordBreak, this.PostGUI );
	end;
};