-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "Android.UI.Label" ( Android.UI.Control )
{
	Font		= Android.UI.Font.NORMAL;
	FontScale	= 1.0;
	
	Label		= function( this, pParent )
		this:Control( pParent );
	end;
	
	Draw		= function( this, Parent )
		dxDrawText( this.Text, this.X, this.Y, this.X + this.Width, this.Y + this.Height, this.ForeColor, this.FontScale, this.Font, "left", "center", false, true, this.PostGUI );
	end;
};