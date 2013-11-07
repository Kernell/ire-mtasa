-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "Android.UI.Window" ( Android.UI.Control )
{
	Draw	= function( this, iCurX, iCurY )
		dxDrawRectangle( this.X + 1, 	this.Y, 	this.Width - 2, 1,  this.BackColor1, false );
		dxDrawRectangle( this.X, 		this.Y + 1, this.Width, 1, 		this.BackColor1, false );
		dxDrawRectangle( this.X, 		this.Y, 	this.Width, 1, 		this.BackColor4, false );
		
		dxDrawRectangle( this.X + 1, 	this.Y + this.Height - 1, 	this.Width - 2, 1, 	this.BackColor1, false );
		dxDrawRectangle( this.X, 		this.Y + this.Height - 2, 	this.Width, 1, 		this.BackColor1, false );
		dxDrawRectangle( this.X, 		this.Y + this.Height - 1, 	this.Width, 1, 		this.BackColor4, false );
		
		dxDrawRectangle( this.X + 2,	this.Y, 		this.Width - 4, 1, 	this.BackColor, false ); -- top
		dxDrawRectangle( this.X, 		this.Y + 2, 1, 	this.Height - 4, 	this.BackColor, false ); -- left
		
		dxDrawRectangle( this.X + 2, this.Y + this.Height - 1, this.Width - 4, 1, this.BackColor3, false ); -- bottom
		dxDrawRectangle( this.X + this.Width - 1, this.Y + 2, 1, this.Height - 4, this.BackColor2, false ); -- right
		
		dxDrawRectangle( this.X + 1, this.Y + 1, this.Width - 2, this.Height - 2, this.BackColor, false );
	end;
};
