-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local scrX, scrY = guiGetScreenSize();

local Menu = CGUI();

function Menu:__init( shop_id, name )
	if self.Window then
		self:Close();
	end
	
	self.Window = self:CreateWindow( name )
	{
		X		= scrX - 320;
		Y		= ( scrY - 440 ) / 2;
		Width	= 300;
		Height	= 440;
		Sizable	= false;
	}
	
	self.List	= self.Window:CreateGridList{ 10, 25, 420, 365 }
	{
		{ "ID", .15 };
		{ "Название", .5 };
		{ "Стоимость", .2 };
	}

	self.List:SetSortingEnabled( false );
	
	self.ButtonBuy = self.Window:CreateButton( "Купить" )
	{
		X		= 10;
		Y		= 395;
		Width	= 100;
		Height	= 30;
	}
	
	self.ButtonExit = self.Window:CreateButton( "Выход" )
	{
		X		= 190;
		Y		= 395;
		Width	= 100;
		Height	= 30;
	}
	
	-- Callbacks
	
	self.ButtonBuy.Click = function()
		local item 	= self.List:GetSelectedItem();
		
		if not item or item == -1 then
			return;
		end
		
		local iSkin	= tonumber( self.List:GetItemText( item, self.List[ 'ID' ] ) );
		
		if not iSkin then
			return;
		end
		
		local pItem = self.List.m_Items[ iSkin ];
		
		if pItem then
			SERVER.BuySkin( shop_id, pItem.m_ID );
		end
	end
	
	self.List.DoubleClick = self.ButtonBuy.Click;
	
	self.List.Click = function()
		local item 	= self.List:GetSelectedItem();
		
		if not item or item == -1 then
			return;
		end
		
		local iSkin	= tonumber( self.List:GetItemText( item, self.List[ 'ID' ] ) );
		
		if not iSkin then
			return;
		end
		
		setElementModel( localPlayer, iSkin );
	end
	
	self.ButtonExit.Click = function()
		SERVER.RestoreSkin();
		
		self:Close();
	end
end

function Menu:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
	
	Ajax:HideLoader();
	
	if self.timer then
		killTimer( self.timer );
		self.timer = nil;
	end
end

function Menu:Close()
	self.Window:Delete();
	self.Window = nil;
	
	self:HideCursor();
	
	Ajax:HideLoader();
	
	if self.timer then
		killTimer( self.timer );
		self.timer = nil;
	end
end

function Menu:FillList( skins )
	self.List:Clear();
	
	self.List.m_Items = {};
	
	for i, skin in ipairs( skins ) do
		self.List:AddItem( skin );
	end
end

function Menu:AddItem( pItem )
	if not pItem then
		return;
	end
	
	local gridRow 	= self:AddRow();
	
	if not gridRow then
		return;
	end
	
	self:SetItemText( gridRow, self[ "ID" ], 			pItem.m_pItem.m_iModel,	false, false );
	self:SetItemText( gridRow, self[ "Название" ], 		pItem.m_sName,			false, false );
	self:SetItemText( gridRow, self[ "Стоимость" ], 	pItem.m_iCost, 			false, false );
	
	self.List.m_Items[ pItem.m_pItem.m_iModel ] = pItem;
end

function SkinSelection( shop_id, name, skins )
	Menu:__init( shop_id, name );
	Menu:FillList( skins );
	Menu:Open();
end