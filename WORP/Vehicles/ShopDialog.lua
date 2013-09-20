-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local scrX, scrY	= guiGetScreenSize();
local ShopDialog 	= CGUI();

local aVehicleInfo	= { "Название:", "Цена:", "Вес:", "Макс. скорость:", "Мощность:", "Привод:", "Тип двигателя:", "Коробка передач:", "ABS:", "Тормоза (Перед-Зад):" };

function ShopDialog:__init( shop_id, bRentable )
	if self.Window then
		self:Close();
	end
	
	self.Window = self:CreateWindow( "Покупка автомобиля" )
	{
		X		= scrX - 300;
		Y		= ( scrY - 350 ) / 2;
		Width	= 280;
		Height	= 350;
		Sizable = false;
	};
	
	self.ButtonBuy = self.Window:CreateButton( "Купить" )
	{
		X		= 9;
		Y		= 311;
		Width	= 90;
		Height	= 30;
	};
	
	self.ButtonClose = self.Window:CreateButton( "Закрыть" )
	{
		X		= 181;
		Y		= 311;
		Width	= 90;
		Height	= 30;
	};
	
	self.Label = {};
	
	for i, value in ipairs( aVehicleInfo ) do
		self.Label[ i ] = self.Window:CreateLabel( value )
		{
			X		= 20;
			Y		= 35 + ( ( i - 1 ) * 20 );
			Width	= 125;
			Height	= 20;
			Font	= "default-bold-small";
		};
		
		self.Label[ i ].Value = self.Window:CreateLabel( "Неизвестно" )
		{
			X		= 145;
			Y		= 35 + ( ( i - 1 ) * 20 );
			Width	= 125;
			Height	= 20;
			Font	= "default-bold-small";
		};
	end
	
	-- Callbacks
	
	self.ButtonBuy.Click = function()
		self:Close();
		
		SERVER.VehicleBuy( shop_id, bRentable );
	end
	
	self.ButtonClose.Click = function()
		self:Close();
	end
end

function ShopDialog:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();
	
	self:ShowCursor();
	
	Ajax:HideLoader();
end

function ShopDialog:Close()
	if self.Window then
		self.Window:Delete();
		self.Window = nil;
	end
	
	self:HideCursor();
	Ajax:HideLoader();
end

function ShopDialog:FillData( info )
	for i in ipairs( aVehicleInfo ) do
		self.Label[ i ].Value:SetText( info[ i ] );
	end
end

function VehicleBuyDialog( shop_id, info )
	ShopDialog:__init( shop_id, info.bRentable );
	ShopDialog:FillData( info );
	ShopDialog.Window:SetText( info.bRentable and "Аренда автомобиля" or "Покупка автомобиля" );
	ShopDialog.ButtonBuy:SetText( info.bRentable and 'Арендовать' or 'Купить' );
	
	if info.bRentable then
		
	end
	
	ShopDialog:Open();
end