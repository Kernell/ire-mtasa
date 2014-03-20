-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "Android.UI.Button" ( Android.UI.Control )
{
	Font					= Android.UI.Font.NORMAL;
	BorderSize				= 1;
	BorderColor 			= System.Drawing.SystemColors.ButtonBorder;
	CheckedBackColor		= System.Drawing.SystemColors.ButtonFace;
	MouseDownBackColor		= System.Drawing.SystemColors.ButtonFace;
	MouseOverBackColor		= System.Drawing.SystemColors.ButtonHighlightVS2012;
	MouseOverBorderColor	= System.Drawing.SystemColors.ButtonBorderHighlight;
	MouseOverForeColor		= System.Drawing.SystemColors.ButtonFace;
	MouseDownForeColor		= System.Drawing.SystemColors.ForeColor;
	
	Button			= function( this, pParent )
		this:Control( pParent );
	end;
	
	Draw = function( this )
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
				BackColor 		= this.MouseDownBackColor;
				ForeColor		= this.MouseDownForeColor;
			end
		end
		
		local BorderSize = this.BorderSize;
		
		if BorderSize > 0 then
			dxDrawRectangle( this.X - BorderSize, this.Y, BorderSize, this.Height, BorderColor, this.PostGUI );
			dxDrawRectangle( this.X + this.Width, this.Y, BorderSize, this.Height, BorderColor, this.PostGUI );
			
			dxDrawRectangle( this.X - BorderSize, this.Y - BorderSize, this.Width + BorderSize * 2, BorderSize, BorderColor, this.PostGUI );
			dxDrawRectangle( this.X - BorderSize, this.Y + this.Height, this.Width + BorderSize * 2, BorderSize, BorderColor, this.PostGUI );
		end
		
		dxDrawRectangle( this.X, this.Y, this.Width, this.Height, BackColor, this.PostGUI );
		
		dxDrawText( this.Text, this.X, this.Y, this.X + this.Width, this.Y + this.Height, this.ForeColor, 1.0, this.Font, "center", "center", false, false, this.PostGUI );
	end;
};
