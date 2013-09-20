-- Author:      	CoolDark (Design), Kernell (Code)
-- Version:     	1.0.0

local aStats	=
{
	{ name = 'tickets', 			caption = "Количество выписаных штрафов:" };
	{ name = 'arrests', 			caption = "Количество выписаных арестов:" };
	{ name = 'unauthorized_kills', 	caption = "Количество неавторизированных убийств:" };
	{ name = 'authorized_kills', 	caption = "Количество авторизированных убийств:" };
	{ name = 'on_duty_death', 		caption = "Количество смертей на службе:" };
	{ name = 'backup_calls', 		caption = "Количество вызовов подкреплений:" };
};

local pDialog	= NULL;

class "CGUISAPD" ( CGUI )

function CGUISAPD:CGUISAPD( PoliceStats )
	if pDialog then
		delete( pDialog );
		pDialog = NULL;
		
		return;
	end
	
	pDialog			= self;
	
	self.Window		= self:CreateWindow( "San Andreas Police Department" )
	{
		X			= 'center';
		Y			= 'center';
		Width		= 600;
		Height		= 400;
		Sizable		= false;
		Visible		= true;
	}
	
	self.Tab		= self.Window:CreateTabPanel
	{
		X			= 0;
		Y			= 20;
		Width		= 800;
		Height		= 230;
	}
	
	self.Tab.Vehicles	= self.Tab:CreateTab( "Автомобили" );
	self.Tab.Players	= self.Tab:CreateTab( "Граждане" );
	
	-- Tab: Vehicles
	
	self.Tab.Vehicles.List	= self.Tab.Vehicles:CreateGridList{ 5, 5, 573, 150 }
	{
		{ "Номер авто",	.12 };
		{ "Марка", 		.10 };
		{ "Владелец",	.13 };
		{ "Цвет", 		.10 };
		{ "Розыск",		.20 };
		{ "Инициатор",	.13 };
		{ "Дата",		.15 };
	}
	
	
	self.Tab.Vehicles.btn1 = self.Tab.Vehicles:CreateButton( "Поиск" )
	{
		X			= 100;
		Y			= 160;
		Width		= 100;
		Height		= 30;
	}
	
	-- Tab: Players
	
	
	self.Tab.Players.List	= self.Tab.Players:CreateGridList{ 5, 5, 573, 150 }
	{
		{ "Имя", 			.10 };
		{ "Фамилия",		.10 };
		{ "Дата рождения",	.16 };
		{ "Место рождения", .16 };
		{ "Пол", 			.10 };
		{ "Номер телефона", .15 };
		{ "Национальность", .16 };
	}
	
	self.Tab.Players.btn1 	= self.Tab.Players:CreateButton( "Поиск" )
	{
		X			= 100;
		Y			= 160;
		Width		= 100;
		Height		= 30;
	}
	
	-- The cop statistics
	
	self.Stats = {};
	
	for i, data in ipairs( aStats ) do
		if PoliceStats[ data.name ] then
			self.Stats[ i ] = self.Window:CreateLabel( data.caption + " " + PoliceStats[ data.name ] )
			{
				X			= 15;
				Y			= 270 + ( ( i - 1 ) * 20 );
				Width		= 270;
				Height		= 80;
				Font		= "default-bold-small";
			}
		end
	end
	
	--
	
	self.btnBackup	 	= self.Window:CreateButton( "Вызвать подкрепление" )
	{
		X				= 465;
		Y				= 280;
		Width			= 100;
		Height			= 30;
	}
	
	self.btnClose		= self.Window:CreateButton( "Закрыть" )
	{
		X				= 465;
		Y				= 345;
		Width			= 100;
		Height			= 30;
	}
	
	-- Events
	
	self.btnBackup.Click	= function() 
		SERVER.SAPD_RequestBackup();
	end
	
	self.btnClose.Click		= function() 
		delete( pDialog );
		pDialog = NULL;
	end
	
	--
	
	self.Window:BringToFront();
	self:ShowCursor();
end

function CGUISAPD:_CGUISAPD()
	self.Window:Delete();
	self:HideCursor();
end