-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. RadioButton : Control
{
	TextColor				= SystemColors.ButtonFace;
	ForeColor 				= SystemColors.ActiveBorderVS2012;
	MouseOverForeColor		= SystemColors.Highlight;
	MouseDownForeColor		= SystemColors.ActiveBorderVS2012;

	TexturePath		= "Resources/Textures/radio.png";

	Selected		= false;

	Font			= new. Font( "Segoe UI", 12, FontStyle.Regular, GraphicsUnit.Pixel );
	WordBreak		= false;
	Clip			= true;
	Align			= "left";
	VerticalAlign	= "center";
	FontScale		= 1.0;

	RadioButton	= function()
		this.Control();

		this.Click.Add( function( ... ) this.OnClick( ... ); end );
	end;

	Draw		= function()
		local ForeColor		= this.ForeColor;
		
		if this.MouseDown then
			BackColor 		= this.CheckedBackColor;
		end
		
		if this.MouseOver then
			ForeColor		= this.MouseOverForeColor;
			
			if this.MouseDown then
				ForeColor	= this.MouseDownForeColor;
			end
		end

		dxDrawImageSection( this.Left, this.Top, 20, 20, this.Selected and 21 or 0, 0, 20, 20, this.TexturePath, 0, 0, 0, ForeColor.ToArgb(), this.PostGUI );

		if this.Text then
			dxDrawText( this.Text, this.Left + 30, this.Top, this.Left + this.Width, this.Top + this.Height, this.TextColor.ToArgb(), this.FontScale, this.Font, this.Align, this.VerticalAlign, this.Clip, this.WordBreak, this.PostGUI );
		end
	end;

	OnClick	= function( sender, button )
		if button == "left" then
			for i, control in this.Owner.Controls.Begin() do
				if classof( control ) == RadioButton then
					control.Selected = false;
				end
			end

			this.Selected = true;
		end
	end;
}