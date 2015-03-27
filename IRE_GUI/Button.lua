-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Button : Control
{
	BorderSize				= 1;

	Button			= function()
		this.Control();
	end;
	
	Draw = function()
		local BackColor		= this.BackColor;
		local BorderColor	= this.BorderColor;
		local ForeColor		= this.ForeColor;
		
		if this.MouseDown then
			BackColor 		= this.CheckedBackColor;
		end
		
		if this.MouseOver then
			BackColor 		= this.MouseOverBackColor;
			BorderColor		= this.MouseOverBorderColor;
			ForeColor		= this.MouseOverForeColor;
			
			if this.MouseDown then
				BackColor 	= this.MouseDownBackColor;
				ForeColor	= this.MouseDownForeColor;
			end
		end
		
		local borderSize = this.BorderSize;
		
		if borderSize > 0 then
			local borderColor	= BorderColor.ToArgb();

			dxDrawRectangle( this.Left - borderSize, this.Top, borderSize, this.Height, borderColor, true );
			dxDrawRectangle( this.Left + this.Width, this.Top, borderSize, this.Height, borderColor, true );
			
			dxDrawRectangle( this.Left - borderSize, this.Top - borderSize, this.Width + borderSize * 2, borderSize, borderColor, true );
			dxDrawRectangle( this.Left - borderSize, this.Top + this.Height, this.Width + borderSize * 2, borderSize, borderColor, true );
		end
		
		dxDrawRectangle( this.Left, this.Top, this.Width, this.Height, BackColor.ToArgb(), true );
		
		if this.Image then
			dxDrawImageSection( this.Left, this.Top, this.Width, this.Height, 0, 2, this.Width, this.Height, this.Image.material, 0, 0, 0, ForeColor.ToArgb(), true );
		end
		
		dxDrawText( this.Text, this.Left, this.Top, this.Left + this.Width, this.Top + this.Height, ForeColor.ToArgb(), 1.0, this.Font or "default", "center", "center", false, false, true );
	end;
};
