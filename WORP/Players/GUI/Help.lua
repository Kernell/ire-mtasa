-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local pHelpDialog = NULL;

class "CHelpDialog" ( CGUI )

function CHelpDialog:CHelpDialog( aContent, aContentSort )
	if pHelpDialog then
		delete( pHelpDialog );
		pHelpDialog = NULL;
		
		return;
	end
	
	pHelpDialog		= self;
	
	self.Window		= self:CreateWindow( "Справка" )
	{
		X			= 'center';
		Y			= 'center';
		Width		= 640;
		Height		= 470;
		Sizable		= false;
		Visible		= true;
	}
	
	self.Grid		= self.Window:CreateGridList{ 10, 25, 140, 400 }{}
	
	self.Grid:SetEnabled( false );
	
	self.Button		= {};
	
	for i, page_name in ipairs( aContentSort ) do
		local page_text = aContent[ page_name ];
		
		if page_text then
			self.Button[ page_name ]	= self.Window:CreateButton( page_name )
			{
				X		= 20;
				Y		= ( i * 35 );
				Width	= 120;
				Height	= 35;
			}
			
			self.Button[ page_name ].Page	= self.Window:CreateMemo( page_text )
			{
				X			= 155;
				Y			= 25;
				Width		= 500;
				Height		= 400;
				ReadOnly 	= true;
			}
			
			self.Button[ page_name ].Page:SetVisible( false );
			
			self.Button[ page_name ].Click = function() self:Select( page_name ) end
		end
	end
	
	self.bntSupport	= self.Window:CreateButton( "Support" )
	{
		X			= 10;
		Y			= 435;
		Width		= 75;
		Height		= 25;
	}
	
	self.bntSupport:SetEnabled( false );
	
	self.bntClose	= self.Window:CreateButton( "Закрыть" )
	{
		X			= 560;
		Y			= 435;
		Width		= 75;
		Height		= 25;
	}
	
	self.bntSupport.Click = function()
	
	end
	
	self.bntClose.Click = function() 
		delete( pHelpDialog );
		pHelpDialog = NULL;
	end
	
	self:Select( aContentSort[ 1 ] );
	self.Window:BringToFront();
	self:ShowCursor();
end

function CHelpDialog:_CHelpDialog()
	self.Window:Delete();
	self:HideCursor();
end

function CHelpDialog:Select( page_name )
	for key, value in pairs( self.Button ) do
		value:SetEnabled( true );
		value.Page:SetVisible( false );
	end
	
	self.Button[ page_name ]:SetEnabled( false );
	self.Button[ page_name ].Page:SetVisible( true );
	
	playSoundFrontEnd( 42 );
end