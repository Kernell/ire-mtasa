-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "Android.UI.Rectangle" ( Android.UI.Control )
{
	Rectangle		= function( this, pParent )
		this:Control( pParent );
	end;
	
	Draw		= function( this, Parent )
		dxDrawRectangle( this.X, this.Y, this.Width, this.Height, this.ForeColor, this.PostGUI );
	end;
};