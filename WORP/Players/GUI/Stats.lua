-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local Stats = CGUI();

Stats.ListSort	=
{
	{
		'sName';
		'sMarried';
		'tInGameTime';
		'iLevel';
		'sLevelPoints';
		'iMoney';
		'iPhone';
		'sFactionName';
--		'sFactionRights';
--		'sFactionRank';
		'tCreated';
		'tLastLogin';
		'tDateOfBirdth';
		'tPlaceOfBirdth';
		'sNation';
	};
	{
		'iID';
		'sName';
		'iPrice';
		'sPlate';
		'fHealth';
	};
	{
		'iID';
		'iPrice';
		'sType';
		'sName';
		'sZone';
	};
}

Stats.ListNames			=
{
	{
		sName			= "Имя";
		sMarried		= "Семейное положение";
		tInGameTime		= "Времени в игре";
		iLevel			= "Уровень";
		sLevelPoints	= "Очков за уровень";
		iMoney			= "Деньги";
		iPhone			= "Номер телефона";
		sFactionName	= "Работы";
--		sFactionRights	= "Уровень прав";
--		sFactionRank	= "Ранг";
		tCreated		= "Дата создания";
		tLastLogin		= "Последний вход";
		tDateOfBirdth	= "Дата рождения";
		tPlaceOfBirdth	= "Место рождения";
		sNation			= "Национальность";
	};
	{
		iID				= "ID";
		sName			= "Название";
		iPrice			= "Цена";
		sPlate			= "Номер";
		fHealth			= "Состояние";
	};
	{
		iID				= "ID";
		sType			= "Тип";
		sName			= "Название";
		iPrice			= "Цена";
		sZone			= "Локация";
	};
}

function Stats:Init()
	if self.Window then
		self:Close();
	end
	
	self.Window		= self:CreateWindow( "Статистика" )
	{
		X			= 'center';
		Y			= 'center';
		Width		= 640;
		Height		= 480;
		Sizable		= false;
	};
	
	self.Tab		= self.Window:CreateTabPanel
	{
		X			= 0;
		Y			= 20;
		Width		= 640;
		Height		= 420;
	};
	
	self.Tab[ 1 ]	= self.Tab:CreateTab( "Персонаж" );
	self.Tab[ 2 ]	= self.Tab:CreateTab( "Транспорт" );
	self.Tab[ 3 ]	= self.Tab:CreateTab( "Недвижимость" );
	
	self.Tab[ 1 ].List		= self.Tab[ 1 ];

	local x		= -280;
	
	for i, key in ipairs( self.ListSort[ 1 ] ) do
		local d = ( i - 1 ) % math.ceil( #self.ListSort[ 1 ] * .5 );
		
		if d == 0 then
			x = x + 290;
		end
		
		self.Tab[ 1 ]:CreateLabel( self.ListNames[ 1 ][ key ] .. ":" )
		{
			X		= x;
			Y		= 10 + ( 20 * d );
			Width	= 150;
			Height	= 20;
			Font	= "default-bold-small";
		}
		
		self.Tab[ 1 ].List[ key ] = self.Tab[ 1 ]:CreateLabel( "NULL" )
		{
			X		= x + 135;
			Y		= 10 + ( 20 * d );
			Width	= 200;
			Height	= 20;
			Font	= "default-small";
		};
	end

	self.Tab[ 2 ].List		= self.Tab[ 2 ]:CreateGridList{ 5, 5, 590, 350 }{}
	
	for i, key in ipairs( self.ListSort[ 2 ] ) do
		self.Tab[ 2 ].List:AddColumn( self.ListNames[ 2 ][ key ], .95 / #self.ListSort[ 2 ] );
	end
	
	self.Tab[ 3 ].List		= self.Tab[ 3 ]:CreateGridList{ 5, 5, 590, 350 }{}
	
	for i, key in ipairs( self.ListSort[ 3 ] ) do
		self.Tab[ 3 ].List:AddColumn( self.ListNames[ 3 ][ key ], .95 / #self.ListSort[ 3 ] );
	end
	
	self.btnClose	= self.Window:CreateButton( "Закрыть" )
	{
		X			= 545;
		Y			= 445;
		Width		= 75;
		Height		= 25;
		
		Click	= function()
			self:Close();
		end;
	};
end

function Stats:Fill( aData )
	if self == Stats.Tab[ 1 ].List then
		for key, value in pairs( aData ) do
			self[ key ]:SetText( value );
		end
	elseif self == Stats.Tab[ 2 ].List then
		for i, veh in ipairs( aData ) do
			local iRow		= self:AddRow();
			
			if iRow and iRow ~= -1 then
				for key, value in pairs( Stats.ListNames[ 2 ] ) do
					self:SetItemText( iRow, self[ value ], veh[ key ], false, false );
				end
			end
		end
	elseif self == Stats.Tab[ 3 ].List then
		for i, veh in ipairs( aData ) do
			local iRow		= self:AddRow();
			
			if iRow and iRow ~= -1 then
				for key, value in pairs( Stats.ListNames[ 3 ] ) do
					self:SetItemText( iRow, self[ value ], veh[ key ], false, false );
				end
			end
		end
	end
end

function Stats:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();
	
	self:ShowCursor();
	
	Ajax:HideLoader();
end

function Stats:Close()
	if self.Window then
		self.Window:Delete();
		self.Window = nil;
	end
	
	self:HideCursor();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
	
	Ajax:HideLoader();
end

function StatsDialog( aStats, aVehicles, aInteriors )
	if Stats.Window then
		Stats:Close();
		
		return;
	end
	
	Stats:Init();
	Stats.Tab[ 1 ].List:Fill( aStats );
	Stats.Tab[ 2 ].List:Fill( aVehicles );
	Stats.Tab[ 3 ].List:Fill( aInteriors );
	Stats:Open();
end