-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "System.Drawing.Forms.ComboBox" ( System.Drawing.Forms.Control )
{
	Width						= 137;
	Height						= 21;
	
	BorderColor					= System.Drawing.SystemColors.ActiveBorderVS2012;
	
	ComboBox	= function( this )
		this.Items = {};
		
		function this.Items.AddRange( Items )
			for i, Item in ipairs( Items ) do
				table.insert( this.Items, Item );
			end
		end
		
		function this.Items.Begin()
			local i	= 0;
			local l	= table.getn( this.Items );
			
			function iter()
				i = i + 1;
				
				if i <= l then
					return i, this.Items[ i ];
				end
				
				return NULL;
			end
			
			return iter;
		end
	end;
	
	Draw = function( this )
		if this.Border then
			dxDrawRectangle( this.Left - this.Border, this.Top, this.Border, this.Height, this.BorderColor:ToArgb(), true );
			dxDrawRectangle( this.Left + this.Width, this.Top, this.Border, this.Height, this.BorderColor:ToArgb(), true );
			
			dxDrawRectangle( this.Left - this.Border, this.Top - this.Border, this.Width + this.Border * 2, this.Border, this.BorderColor:ToArgb(), true );
			dxDrawRectangle( this.Left - this.Border, this.Top + this.Height, this.Width + this.Border * 2, this.Border, this.BorderColor:ToArgb(), true );
		end
		
		dxDrawRectangle( this.Left, this.Top, this.Width, this.Height, this.BackColor:ToArgb(), true );
		
		dxDrawRectangle( this.Left + this.Width - 16, this.Top, 16, this.Height, this.BackColor:ToArgb(), true );
		dxDrawImage( this.Left + this.Width - 16, this.Top + 3, 16, 16, "Resources/Textures/dropdown.png", 0, 0, 0, this.ForeColor:ToArgb(), true );
		
		dxDrawText( this.Text, this.Left + 5, this.Top, this.Left + this.Width, this.Top + this.Height, this.ForeColor:ToArgb(), 1.0, this.Font or "default", "left", "center", false, false, true );
	end;
};
