-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Switch : Control
{
	TextColor				= SystemColors.ButtonFace;
	ForeColor 				= SystemColors.ActiveBorderVS2012;
	MouseOverForeColor		= SystemColors.Highlight;
	MouseDownForeColor		= SystemColors.ActiveBorderVS2012;

	TexturePath		= "Resources/Textures/switch.png";

	Checked			= false;

	Font			= new. Font( "Segoe UI", 12, FontStyle.Regular, GraphicsUnit.Pixel );
	WordBreak		= false;
	Clip			= true;
	Align			= "left";
	VerticalAlign	= "center";
	FontScale		= 1.0;

	Switch		= function()
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

		dxDrawImageSection( this.Left + 2, this.Top + 3, 29, 15, 0, this.Checked and 15 or 0, 29, 15, this.TexturePath, 0, 0, 0, ForeColor.ToArgb(), this.PostGUI );

		if this.Text then
			dxDrawText( this.Text, this.Left + 45, this.Top, this.Left + this.Width, this.Top + this.Height, this.TextColor.ToArgb(), this.FontScale, this.Font, this.Align, this.VerticalAlign, this.Clip, this.WordBreak, this.PostGUI );
		end
	end;

	Toggle		= function()
		this.Checked = not this.Checked;
	end;

	OnClick		= function( sender, button )
		if button == "left" then
			this.Toggle();
		end
	end;
}