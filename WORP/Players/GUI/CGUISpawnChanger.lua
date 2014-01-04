-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local pDialog		= NULL;

class "CGUISpawnChanger" ( CGUI )

function CGUISpawnChanger:CGUISpawnChanger( Items, iCurrent )
	if pDialog then
		delete ( pDialog );
	end
	
	pDialog		= self;
	
	self.Window = self:CreateWindow( "Изменение респавна" )
	{
		X		= "center";
		Y		= "center";
		Width	= 230;
		Height	= 270;
		Sizable	= false;
	};
	
	self.Radio	= {};
	
	self.fY		= 30;
	
	if Items then
		for iID, sItem in pairs( Items ) do
			self.Radio[ iID ] = self.Window:CreateRadioButton( sItem )
			{
				X		= 10;
				Y		= self.fY;
				Width	= 150;
				Height	= 15;
			}
			
			self.fY		= self.fY + 20;
		end
		
		self.Radio[ iCurrent ]:SetSelected( true );
	end
	
	self.fY		= self.fY + 20;
	
	self.Label	= self.Window:CreateLabel( "Чтобы вызвать это окно снова, используйте команду 'changespawn'" )
	{
		X		= 15;
		Y		= self.fY;
		Width	= 220;
		Height	= 50;
		Font	= 'default-small';
		HorizontalAlign	= { 'left', true };
	}

	self.fY		= self.fY + 30;
	
	self.ButtonCancel	= self.Window:CreateButton( "Отмена" )
	{
		X		= 60;
		Y		= self.fY;
		Width	= 75;
		Height	= 25;
	}
	
	self.ButtonOk		= self.Window:CreateButton( "ОК" )
	{
		X		= 145;
		Y		= self.fY;
		Width	= 75;
		Height	= 25;
	}
	
	function self.ButtonCancel.Click( this )
		delete ( self );
	end
	
	function self.ButtonOk.Click( this )
		for i in pairs( self.Radio ) do
			if self.Radio[ i ]:GetSelected() then
				SERVER.SetSpawn( i );
				
				break;
			end
		end
		
		delete ( self );
	end
	
	self.Window:SetSize( 230, self.fY + 35, false );
	
	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
end

function CGUISpawnChanger:_CGUISpawnChanger()
	self.Window:Delete();
	self.Window = NULL;
	
	self:HideCursor();
	
	pDialog	= NULL;
end