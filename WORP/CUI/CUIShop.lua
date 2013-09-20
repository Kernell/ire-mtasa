-- Author:      	Kernell
-- Version:     	1.0.0

local scrX, scrY = guiGetScreenSize();

local shop_dialog = CGUI();

function shop_dialog:__init()
	if self.Window then
		self:Close();
	end
	
	self.Window = self:CreateWindow( "" )
	{
		X		= ( scrX - 450 ) / 2;
		Y		= ( scrY - 450 ) / 2;
		Width	= 450;
		Height	= 450;
		Sizable	= false;
	}
	
	self.Image 	= self.Window:CreateStaticImage( "Resources/Images/blank.png" )
	{
		X		= 270;
		Y		= 10;
		Width	= 160;
		Height	= 120;
	}
	
	self.Label = self.Window:CreateLabel( "" )
	{
		X		= 15;
		Y		= 25;
		Width	= 200;
		Height	= 80;
		Color	= { 255, 255, 0 };
		Font	= "default-bold-small";
		HorizontalAlign = { 'left', true };
	}
	
	self.List	= self.Window:CreateGridList{ 15, 110, 420, 275 }
	{
		{ "Название", .6 };
		{ "Стоимость", .3 };
	}

	self.List:SetSortingEnabled( false );
	
	self.ButtonBuy = self.Window:CreateButton( "Купить" )
	{
		X		= 15;
		Y		= 395;
		Width	= 100;
		Height	= 30;
	}
	
	self.ButtonExit = self.Window:CreateButton( "Выход" )
	{
		X		= 335;
		Y		= 395;
		Width	= 100;
		Height	= 30;
	}
	
	-- Callbacks
	
	self.ButtonBuy.Click = function()
		local item 			= self.List:GetSelectedItem();
		
		if not item or item == -1 then
			return;
		end
		
		local txt			= self.List:GetItemText( item, self.List[ 'Название' ] );
		
		if not txt then
			return;
		end
		
		if self.List.items[ txt ] then
			SERVER.BuyItem( self.id, self.List.items[ txt ].m_ID );
		end
	end
	
	self.List.DoubleClick = self.ButtonBuy.Click;
	
	self.List.Click = function()
		local item 			= self.List:GetSelectedItem();
		
		if item and item ~= -1 then
			self.Image:LoadImage( "Resources/Images/blank.png" );
		
			local txt		= self.List:GetItemText( item, self.List[ 'Название' ] );
			
			if txt then
				local pItem 	= self.List.items[ txt ];
				
				if pItem and fileExists( "Resources/Images/Items/" + pItem.m_ID + ".png" ) then
					self.Image:LoadImage( "Resources/Images/Items/" + pItem.m_ID + ".png" );
					
					return;
				end
			end
		end
		
		self.Image:LoadImage( "Resources/Images/blank.png" );
	end
	
	self.ButtonExit.Click = function()
		self:Close();
	end
end

function shop_dialog:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
	
	Ajax:HideLoader();
	
	if self.timer then
		killTimer( self.timer );
		self.timer = nil;
	end
end

function shop_dialog:Close()
	self.Window:Delete();
	self.Window = nil;
	
	self:HideCursor();
	
	Ajax:HideLoader();
	
	if self.timer then
		killTimer( self.timer );
		self.timer = nil;
	end
end

function shop_dialog:FillList( items )
	self.List:Clear();
	self.List.items = {};
	
	for i, item in ipairs( items ) do
		self.List:AddItem( item );
	end
end

function shop_dialog:AddItem( pItem )
	if not pItem then
		return;
	end
	
	local gridRow 	= self:AddRow();
	
	if not gridRow then
		return;
	end
	
	self:SetItemText( gridRow, self[ "Название" ], 		pItem.m_sName,	false, false );
	self:SetItemText( gridRow, self[ "Стоимость" ], 	pItem.m_iCost, 	false, false );
	
	self.items[ pItem.m_sName ] = pItem;
end

function OpenShopsDialog( id, name, items )
	shop_dialog:__init();
	
	shop_dialog.id = id;
	shop_dialog.Window:SetText( name );
	shop_dialog:FillList( items );
	
	shop_dialog:Open();
end

function ShopsResult( code, ... )

end