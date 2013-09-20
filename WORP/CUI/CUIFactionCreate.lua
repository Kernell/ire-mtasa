-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CUIFactionCreate ( CGUI, CUIAsyncQuery )
{
	X		= "center";
	Y		= "center";
	Width	= 420;
	Height	= 380;
	
	FieldsOrder	=
	{
		"Rule1";
		"Rule2";
		"Rule3";
		"Rule4";
		"Name";
		"Surname";
		"Title";
		"Abbr";
		"Address";
		"Type";
	};
	
	Rules	=
	{
		"Все поля должны быть заполнены без ошибок";
		"Обработка заявки может длиться в течении трёх недель";
		"";
	};
};

function CUIFactionCreate:CUIFactionCreate( sName, sSurname, eFactionType, Interiors )
	local aInteriors = {};
	
	for i, pInt in ipairs( Interiors ) do
		table.insert( aInteriors, pInt.Name );
	end
	
	self.Fields	=
	{
		Name	= { Type = "input";		MaxLength = 32;		Text = "Имя:"; 					ReadOnly = true;  };
		Surname	= { Type = "input";		MaxLength = 32;		Text = "Фамилия:"; 				ReadOnly = true;  };
		Title	= { Type = "input";		MaxLength = 64;		Text = "Название:";				ReadOnly = false; };
		Abbr	= { Type = "input";		MaxLength = 8;		Text = "Аббревиатура:";			ReadOnly = false; };
		Address	= { Type = "select";						Text = "Адрес регистрации:"; 	Items	= aInteriors; };
		Type	= { Type = "select";						Text = "Тип:"; 					Items	= eFactionType; };
	};
	
	self.Window = self:CreateWindow( "Управление организациями" )
	{
		X		= self.X;
		Y		= self.Y;
		Width	= self.Width;
		Height	= self.Height;
		Sizable	= false;
	};
	
	self.Tab		= self.Window:CreateTabPanel
	{
		X			= 0;
		Y			= 20;
		Width		= self.Width;
		Height		= self.Height - 65;
	};
	
	self.Tab.Create		= self.Tab:CreateTab( "Регистрация" );
	self.Tab.Manage		= self.Tab:CreateTab( "Мои организации" );
	
	local Y			= 0;
	local Height 	= 18;
	
	for i, Text in ipairs( self.Rules ) do
		Y = Y + Height;
		
		self.Tab.Create:CreateLabel( Text )
		{
			X		= 10;
			Y		= Y;
			Width	= self.Width;
			Height	= Height;
			Font	= CEGUIFont( "Segoe UI", 9, true );
			Color	= { 255, 128, 0 }
		};
	end
	
	local Height 	= 20;
	
	for i, sField in ipairs( self.FieldsOrder ) do
		local pField = self.Fields[ sField ];
		
		if pField then
			Y = Y + Height + 4;
			
			pField.Label = self.Tab.Create:CreateLabel( pField.Text )
			{
				X		= 10;
				Y		= Y;
				Width	= self.Tab.Width * 0.4;
				Height	= Height;
				Font	= CEGUIFont( "Segoe UI", 9, true );
				Color	= pField.Color;
			};
			
			if pField.Type == "input" then
				pField.Value	= self.Tab.Create:CreateEdit( "" )
				{
					X			= self.Tab.Width * 0.45;
					Y			= Y;
					Width		= self.Tab.Width * 0.45;
					Height		= Height;
					
					ReadOnly	= pField.ReadOnly;
					MaxLength	= pField.MaxLength;
				};
			elseif pField.Type == "text" then
				pField.Value	= self.Tab.Create:CreateMemo( "" )
				{
					X			= self.Tab.Width * 0.45;
					Y			= Y;
					Width		= self.Tab.Width * 0.45;
					Height		= Height * pField.Lines;
					
					ReadOnly	= pField.ReadOnly;
					MaxLength	= pField.MaxLength;
				};
				
				if pField.Lines > 1 then
					Y = Y + ( Height * pField.Lines );
				end
			elseif pField.Type == "select" then
				pField.Value	= self.Tab.Create:CreateComboBox( "Выберите" )
				{
					X			= self.Tab.Width * 0.45;
					Y			= Y;
					Width		= self.Tab.Width * 0.45;
					Height		= Height * 6;
					
					Items		= pField.Items;
				};
			end
		end
	end
	
	self.Fields.Name.Value:SetText		( sName );
	self.Fields.Surname.Value:SetText	( sSurname );
	
	Y = Y + Height + 10;
	
	self.LabelMsg		= self.Tab.Create:CreateLabel( "" )
	{
		X		= 10;
		Y		= Y;
		Width	= self.Width;
		Height	= 25;
		Color	= { 255, 0, 0 };
		Font	= CEGUIFont( "Segoe UI", 9, true );
	};
	
	Y = Y + Height;
	
	self.ButtonSend		= self.Tab.Create:CreateButton( "Отправить" )
	{
		X		= self.Tab.Width - 110;
		Y		= Y;
		Width	= 80;
		Height	= 30;
		
		Click	= function()
			self:Error( NULL );
			
			local sTitle, sAbbr, iInterior, iType;
			
			sTitle		= self.Fields.Title.Value:GetText();
			sAbbr		= self.Fields.Abbr.Value:GetText();
			iInterior	= self.Fields.Address.Value:GetSelected();
			iType		= self.Fields.Type.Value:GetSelected();
			
			if sTitle:len() == 0 then
				return self:Error( "Введите название организации" );
			end
			
			if sAbbr:len() == 0 then
				return self:Error( "Введите аббревиатуру организации" );
			end
			
			if not iInterior or iInterior == -1 or Interiors[ iInterior + 1 ] == NULL then
				return self:Error( "Вы не выбрали адрес регистрации организации" );
			end
			
			if not iType or iType == -1 or eFactionType[ iType + 1 ] == NULL then
				return self:Error( "Вы не выбрали тип организации" );
			end
			
			local function Complete( Data )
				MessageBox:Show( "Ваша заявка на регистрацию организации успешно отправлена", "Создание организации", MessageBoxButtons.OK, MessageBoxIcon.Information );
				
				self.ButtonCancel.Click();
			end
			
			self:AsyncQuery( Complete, "Faction_Create", sTitle, sAbbr, Interiors[ iInterior + 1 ].ID, iType + 1 );
		end;
	};
	
	function self.Tab.Manage.Switched()
		if self.Tab.Manage.List.m_aData then
			return;
		end
		
		local function Complete( Data )
			self.Tab.Manage.List.Fill( Data );
		end
		
		self:AsyncQuery( Complete, "Bank__GetFactions", { "m_iID", "m_sName", "m_iType", "m_sRegistered" } );
	end
	
	self.Tab.Manage.List	= self.Tab.Manage:CreateGridList{ 0, 0, self.Tab.Width - 20, self.Tab.Height - 20 }
	{
		{ "Название", 0.4 };
		{ "Тип", 0.3 };
		{ "Регистрация", 0.24 };
	};
	
	function self.Tab.Manage.List.Fill( Data )
		self.Tab.Manage.List.m_aData = Data;
		
		for i, pFaction in ipairs( Data ) do
			self.Tab.Manage.List.AddItem( pFaction );
		end
	end
	
	function self.Tab.Manage.List.AddItem( pFaction )
		local iRow = self.Tab.Manage.List:AddRow();
		
		self.Tab.Manage.List:SetItemText( iRow, self.Tab.Manage.List[ "Название" ], 	pFaction.m_sName, false, false );
		self.Tab.Manage.List:SetItemText( iRow, self.Tab.Manage.List[ "Тип" ], 			eFactionTypeNames[ pFaction.m_iType ] or "NULL", false, false );
		self.Tab.Manage.List:SetItemText( iRow, self.Tab.Manage.List[ "Регистрация" ], 	pFaction.m_sRegistered or "Не зарегистрирована", false, false );
		
		self.Tab.Manage.List:SetItemData( iRow, self.Tab.Manage.List[ "Название" ],		pFaction.m_iID );
	end
	
	function self.Tab.Manage.List.DoubleClick()
		local iRow = self.Tab.Manage.List:GetSelectedItem();
		
		if iRow and iRow ~= -1 then
			local iFactionID = self.Tab.Manage.List:GetItemData( iRow, self.Tab.Manage.List[ "Название" ] );
			
			if iFactionID then
				local function Complete( Info )
					self:ShowDialog( CUIFaction( (string)(eFactionRight.OWNER), Info ) );
				end
				
				self:AsyncQuery( Complete, "Faction_GetData", "Info", iFactionID );
			end
		end
	end
	
	self.ButtonCancel	= self.Window:CreateButton( "Закрыть" )
	{
		X		= self.Width - 90;
		Y		= self.Height - 40;
		Width	= 80;
		Height	= 30;
		
		Click = function()
			CLIENT.m_pCharacter:HideUI( self );
		end;
	};
	
	self.Window:SetVisible( true );
	self.Window:BringToFront();
	
	self:ShowCursor();
	
	Ajax:HideLoader();
end

function CUIFactionCreate:_CUIFactionCreate()
	self.Window:Delete();
	self.Window = NULL;
	
	self:HideCursor();
	
	Ajax:HideLoader();
end

function CUIFactionCreate:Error( sMessage )
	if self.m_pPulseTimer then
		self.m_pPulseTimer:Kill();
		self.m_pPulseTimer = NULL;
	end
	
	if sMessage then
		local iMax	= 6;
		local i		= 0;
		
		self.m_pPulseTimer = CTimer(
			function()
				i = i + 1;
				
				self.LabelMsg:SetText( i % 2 == 0 and sMessage or "" );
				
				if i == iMax then
					self.m_pPulseTimer = NULL;
				end
			end,
			100, iMax
		);
	else
		self.LabelMsg:SetText( "" );
	end
end
