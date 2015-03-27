-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. ComboBox : Control
{
	Width		= 137;
	Height		= 21;
	Border		= 1;
	Font		= "default";
	HaveFocus	= false;
	
	ComboBox	= function()
		this.Control();
		
		this.Items = new {};
		
		function this.Items.AddRange( items )
			for i = 1, items.Length() do
				this.Items.Insert( items[ i ] );
			end
		end
		
		function this.Items.Begin()
			local i	= 0;
			local l	= this.Items.Length();
			
			function iter()
				i = i + 1;
				
				if i <= l then
					return i, this.Items[ i ];
				end
				
				return NULL;
			end
			
			return iter;
		end

		this.Click.Add	( function( ... ) this.OnClick( ... ); end );
		this.Focus.Add	( function( ... ) this.OnFocus( ... ); end );
		this.Blur.Add	( function( ... ) this.OnBlur( ... ); end );
	end;
	
	Draw = function()
		local width		= this.Width;
		local height	= this.Height;

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

		if this.HaveFocus then
			-- BackColor 		= this.CheckedBackColor;
			BackColor 		= Color.FromArgb( 255, 230, 230, 230 );
			BorderColor		= this.MouseOverBorderColor;
			ForeColor		= this.MouseOverForeColor;

			height	= this.Height * ( this.Items.Length() + 1 );
		end

		if this.Border then
			local borderColor = BorderColor.ToArgb();

			dxDrawRectangle( this.Left - this.Border, this.Top, this.Border, height, borderColor, true );
			dxDrawRectangle( this.Left + width, this.Top, this.Border, height, borderColor, true );
			
			dxDrawRectangle( this.Left - this.Border, this.Top - this.Border, width + this.Border * 2, this.Border, borderColor, true );
			dxDrawRectangle( this.Left - this.Border, this.Top + height, width + this.Border * 2, this.Border, borderColor, true );
		end
		
		dxDrawRectangle( this.Left, this.Top, width, height, BackColor.ToArgb(), true );
		
		dxDrawRectangle( this.Left + width - 16, this.Top, 16, height, BorderColor.ToArgb(), true );
		dxDrawImage( this.Left + width - 16, this.Top + 3, 16, 16, "Resources/Textures/dropdown.png", 0, 0, 0, ForeColor.ToArgb(), true );
		
		dxDrawText( this.Text, this.Left + 5, this.Top, this.Left + ( width - 20 ), this.Top + this.Height, ForeColor.ToArgb(), 1.0, this.Font, "left", "center", true, false, true );
	
		if this.HaveFocus then
			for i = 1, this.Items.Length() do
				local item = this.Items[ i ];

				local top = this.Top + ( i * this.Height );

				dxDrawText( item, this.Left + 5, top, this.Left + ( width - 20 ), top + this.Height, ForeColor.ToArgb(), 1.0, this.Font, "left", "center", true, false, true );
			end
		end
	end;

	OnClick		= function( sender, mouseButton, curX, curY )
		if mouseButton == "left" then
			-- this.HaveFocus = false;
		end
	end;

	OnFocus		= function( sender )
		this.HaveFocus = true;
	end;

	OnBlur		= function( sender )
		this.HaveFocus = false;
	end;
};
