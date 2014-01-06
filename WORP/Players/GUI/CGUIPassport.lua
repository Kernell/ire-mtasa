-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local pDialog		= NULL;

class "CGUIPassport" ( CGUI )

function CGUIPassport:CGUIPassport( Data )
	if pDialog then
		delete ( pDialog );
	end
	
	pDialog		= self;
	
	self.Window = self:CreateWindow( "Паспорт" )
	{
		X		= "center";
		Y		= "center";
		Width	= 300;
		Height	= 400;
		Sizable	= false;
	};
	
	self.Label	= {};
	
	for i, pField in ipairs( Data ) do
		self.Label[ i ]		= self.Window:CreateLabel( pField.Name and ( pField.Name + ":" ) or '' )
		{
			X				= .1;
			Y				= .1 + ( .05 * ( i - 1 ) );
			Width			= .4;
			Height			= .15;
			Font			= 'default-bold-small';
			HorizontalAlign	= { 'left', true };
		}
		
		self.Label[ i ].Value	= self.Window:CreateLabel( pField.Value and pField.Value or '' )
		{
			X				= .5;
			Y				= .1 + ( .05 * ( i - 1 ) );
			Width			= .4;
			Height			= .15;
			Font			= 'default';
			HorizontalAlign	= { 'left', true };
		}
	end
	
	self.Button	=
	{
		Close	= self.Window:CreateButton( "Закрыть" )
		{
			X		= .65;
			Y		= .9;
			Width	= .3;
			Height	= .15;
		};
	};
	
	function self.Button.Close.Click( this )
		delete ( self );
	end
	
	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
end

function CGUIPassport:_CGUIPassport()
	self.Window:Delete();
	self.Window = NULL;
	
	self:HideCursor();
	
	pDialog	= NULL;
end