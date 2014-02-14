-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUIFactions ( CGUI, CUIAsyncQuery )
{
	X		= "center";
	Y		= "center";
	Width	= 650;
	Height	= 450;
	
	CUIFactions		= function( this, sFirstName, sLastName )
		this.Window = this:CreateWindow( "Организации" )
		{
			X		= this.X;
			Y		= this.Y;
			Width	= this.Width;
			Height	= this.Height;
			Sizable	= false;
		};
		
		this.Window.Tab		= this.Window:CreateTabPanel
		{
			X			= 0;
			Y			= 20;
			Width		= this.Width;
			Height		= this.Height - 65;
		};
		
		this.Window.Tab.List		= this.Window.Tab:CreateTab( "Список" );
		this.Window.Tab.Manage		= this.Window.Tab:CreateTab( "Мои организации" );
		this.Window.Tab.Create		= this.Window.Tab:CreateTab( "Регистрация" );
		
		do
			local pTab	= this.Window.Tab.List;
			
			function pTab.Switched()
				if pTab.List.m_aData then
					return;
				end
				
				this:AsyncQuery( pTab.List.Fill, "CFactionManager", "GetPublicFactions" );
			end
			
			pTab.List	= pTab:CreateGridList{ 0, 0, this.Window.Tab.Width - 20, this.Window.Tab.Height - 20 }
			{
				{ "Название", 0.4 };
				{ "Тип", 0.4 };
				{ "Владелец", 0.15 };
			};
			
			function pTab.List.Fill( Data )
				pTab.List.m_aData = Data;
				
				for i, pFaction in ipairs( Data ) do
					pTab.List.AddItem( pFaction );
				end
			end
			
			function pTab.List.AddItem( pFaction )
				local iRow = pTab.List:AddRow();
				
				pTab.List:SetItemText( iRow, pTab.List[ "Название" ], 		pFaction.name, false, false );
				pTab.List:SetItemText( iRow, pTab.List[ "Тип" ], 			eFactionTypeNames[ pFaction.type ] or "NULL", false, false );
				pTab.List:SetItemText( iRow, pTab.List[ "Владелец" ], 		pFaction.owner or "Неизвестно", false, false );
				
				pTab.List:SetItemData( iRow, pTab.List[ "Название" ],		pFaction.id );
			end
			
			function pTab.List.DoubleClick()
				local iRow = pTab.List:GetSelectedItem();
				
				if iRow and iRow ~= -1 then
					local iFactionID = pTab.List:GetItemData( iRow, pTab.List[ "Название" ] );
					
					if iFactionID then
						local function Complete( Info )
							this:ShowDialog( CUIFaction( (string)(eFactionRight.OWNER), Info ) );
						end
						
						this:AsyncQuery( Complete, "CFactionManager", "GetData", "Info", iFactionID );
					end
				end
			end
		end
		
		do
			local pTab	= this.Window.Tab.Manage;
			
			function pTab.Switched()
				if pTab.List.m_aData then
					return;
				end
				
				this:AsyncQuery( pTab.List.Fill, "Bank__GetFactions", { "m_iID", "m_sName", "m_iType", "m_sRegistered" } );
			end
			
			pTab.List	= pTab:CreateGridList{ 0, 0, this.Window.Tab.Width - 20, this.Window.Tab.Height - 20 }
			{
				{ "Название", 0.4 };
				{ "Тип", 0.4 };
				{ "Регистрация", 0.15 };
			};
			
			function pTab.List.Fill( Data )
				pTab.List.m_aData = Data;
				
				for i, pFaction in ipairs( Data ) do
					pTab.List.AddItem( pFaction );
				end
			end
			
			function pTab.List.AddItem( pFaction )
				local iRow = pTab.List:AddRow();
				
				pTab.List:SetItemText( iRow, pTab.List[ "Название" ], 		pFaction.m_sName, false, false );
				pTab.List:SetItemText( iRow, pTab.List[ "Тип" ], 			eFactionTypeNames[ pFaction.m_iType ] or "NULL", false, false );
				pTab.List:SetItemText( iRow, pTab.List[ "Регистрация" ], 	pFaction.m_sRegistered or "Не зарегистрирована", false, false );
				
				pTab.List:SetItemData( iRow, pTab.List[ "Название" ],		pFaction.m_iID );
			end
			
			function pTab.List.DoubleClick()
				local iRow = pTab.List:GetSelectedItem();
				
				if iRow and iRow ~= -1 then
					local iFactionID = pTab.List:GetItemData( iRow, pTab.List[ "Название" ] );
					
					if iFactionID then
						local function Complete( Info )
							this:ShowDialog( CUIFaction( (string)(eFactionRight.OWNER), Info ) );
						end
						
						this:AsyncQuery( Complete, "CFactionManager", "GetData", "Info", iFactionID );
					end
				end
			end
		end
		
		do
			local pTab	= this.Window.Tab.Create;
			
			function pTab.Switched()
				if pTab.List.m_aData then
					return;
				end
				
				local function Complete( Data )
					pTab.List.m_aData = Data;
					
					for i, pInt in ipairs( Data ) do
						pTab.Interior.Value:AddItem( pInt.Name );
					end
				end
				
				this:AsyncQuery( Complete, "CFactionManager", "CreationUIData" );
			end
			
			pTab:CreateLabel( "Все поля должны быть заполнены без ошибок" )
			{
				X				= 10;
				Y				= 10;
				Width			= this.Width - 20;
				Height			= 20;
				Font			= CEGUIFont( "Segoe UI", 9, true );
				Color			= { 255, 128, 0 };
				VerticalAlign	= "center";
			};
			
			pTab:CreateLabel( "Обработка заявки может длиться в течении трёх недель" )
			{
				X				= 10;
				Y				= 30;
				Width			= this.Width - 20;
				Height			= 20;
				Font			= CEGUIFont( "Segoe UI", 9, true );
				Color			= { 255, 128, 0 };
				VerticalAlign	= "center";
			};
			
			local iWidth = this.Window.Tab.Width * 0.5 - 20;
			
			pTab.FirstName	= pTab:CreateLabel( "Имя и фамилия:" )
			{
				X				= 10;
				Y				= 60;
				Width			= iWidth;
				Height			= 25;
				Font			= CEGUIFont( "Segoe UI", 9, true );
				VerticalAlign	= "center";
			};
			
			pTab.Title		= pTab:CreateLabel( "Название:" )
			{
				X				= 10;
				Y				= pTab.FirstName.Y + pTab.FirstName.Height;
				Width			= iWidth;
				Height			= 25;
				Font			= CEGUIFont( "Segoe UI", 9, true );
				VerticalAlign	= "center";
			};
			
			pTab.Abbr		= pTab:CreateLabel( "Аббревиатура:" )
			{
				X				= 10;
				Y				= pTab.Title.Y + pTab.Title.Height;
				Width			= iWidth;
				Height			= 25;
				Font			= CEGUIFont( "Segoe UI", 9, true );
				VerticalAlign	= "center";
			};
			
			pTab.Interior	= pTab:CreateLabel( "Адрес регистрации:" )
			{
				X				= 10;
				Y				= pTab.Abbr.Y + pTab.Abbr.Height;
				Width			= iWidth;
				Height			= 25;
				Font			= CEGUIFont( "Segoe UI", 9, true );
				VerticalAlign	= "center";
			};
			
			pTab.Type		= pTab:CreateLabel( "" )
			{
				X				= 10;
				Y				= pTab.Interior.Y + pTab.Interior.Height;
				Width			= iWidth;
				Height			= 25;
				Font			= CEGUIFont( "Segoe UI", 9, true );
				VerticalAlign	= "center";
			};
			
			pTab:CreateEdit( sFirstName + " " + sLastName )
			{
				X			= pTab.FirstName.Width + 10;
				Y			= pTab.FirstName.Y;
				Width		= pTab.FirstName.Width;
				Height		= pTab.FirstName.Height - 5;
				
				ReadOnly	= true;
				MaxLength	= 64;
			};
			
			pTab.Title.Value	= pTab:CreateEdit( "" )
			{
				X			= pTab.Title.Width + 10;
				Y			= pTab.Title.Y;
				Width		= pTab.Title.Width;
				Height		= pTab.Title.Height - 5;
				
				ReadOnly	= false;
				MaxLength	= 64;
			};
			
			pTab.Abbr.Value		= pTab:CreateEdit( "" )
			{
				X			= pTab.Abbr.Width + 10;
				Y			= pTab.Abbr.Y;
				Width		= pTab.Abbr.Width;
				Height		= pTab.Abbr.Height - 5;
				
				ReadOnly	= false;
				MaxLength	= 8;
			};
			
			pTab.Interior.Value		= pTab:CreateComboBox( "Выберите" )
			{
				X			= pTab.Interior.Width + 10;
				Y			= pTab.Interior.Y;
				Width		= pTab.Interior.Width;
				Height		= 180;
			};
			
			for i, sType in ipairs( eFactionTypeNames ) do
				pTab.Type[ i ]	= pTab:CreateRadioButton( sType )
				{
					X		= 10 + ( 200 * ( i - 1 ) );
					Y		= pTab.Type.Y + 25;
					Width	= 200;
					Height	= 20;
					Font	= CEGUIFont( "Segoe UI", 9, true );
				};
				
				local pLabel = pTab:CreateLabel( "Стоимость:" )
				{
					X		= pTab.Type[ i ].X + 20;
					Y		= pTab.Type[ i ].Y + 25;
					Width	= pTab.Type.Width * 0.21;
					Height	= 20;
					Font	= CEGUIFont( "Segoe UI", 8, true );
					Color	= { 196, 196, 196 };
				};
				
				local pValue1 = NULL;
				
				if eFactionTypePrice[ i ] > 0 then
					pValue1 = pTab:CreateLabel( "$" + eFactionTypePrice[ i ] )
					{
						X		= pLabel.X + pLabel.Width + 10;
						Y		= pLabel.Y;
						Width	= "auto";
						Height	= pLabel.Height;
						Font	= CEGUIFont( "Segoe UI", 8, false );
						Color	= { 196, 196, 196 };
					};
				end
				
				if eFactionTypePriceGP[ i ] > 0 then
					pTab:CreateLabel( ( eFactionTypePrice[ i ] > 0 and " + " or "" ) + eFactionTypePriceGP[ i ] + " GP" )
					{
						X		= pLabel.X + pLabel.Width + 10 + ( pValue1 and pValue1.Width or 0 );
						Y		= pLabel.Y;
						Width	= "auto";
						Height	= pLabel.Height;
						Color	= { 255, 196, 0 };
						Font	= CEGUIFont( "Segoe UI", 8, true );
					};
				end
				
				local pLabel2 = pTab:CreateLabel( "Размер:" )
				{
					X		= pLabel.X;
					Y		= pLabel.Y + 25;
					Width	= pTab.Type.Width * 0.21;
					Height	= 20;
					Font	= CEGUIFont( "Segoe UI", 8, true );
					Color	= { 196, 196, 196 };
				};
				
				pTab:CreateLabel( eFactionMaxMembers[ i ] + " человек" )
				{
					X		= pLabel2.X + pLabel2.Width + 10;
					Y		= pLabel2.Y;
					Width	= "auto";
					Height	= pLabel2.Height;
					Font	= CEGUIFont( "Segoe UI", 8, false );
					Color	= { 196, 196, 196 };
				};
				
				local pLabel3 = pTab:CreateLabel( "Налог:" )
				{
					X		= pLabel2.X;
					Y		= pLabel2.Y + 25;
					Width	= pTab.Type.Width * 0.21;
					Height	= 20;
					Font	= CEGUIFont( "Segoe UI", 8, true );
					Color	= { 196, 196, 196 };
				};
				
				pTab:CreateLabel( ( eFactionTax[ i ] * 100 ) + "% от дохода" )
				{
					X		= pLabel3.X + pLabel3.Width + 10;
					Y		= pLabel3.Y;
					Width	= "auto";
					Height	= pLabel3.Height;
					Font	= CEGUIFont( "Segoe UI", 8, false );
					Color	= { 196, 196, 196 };
				};
			end
			
			pTab.ButtonSend		= pTab:CreateButton( "Создать" )
			{
				X		= this.Window.Tab.Width - 110;
				Y		= this.Window.Tab.Height - 70;
				Width	= 80;
				Height	= 30;
				
				Click	= function()
					local sTitle	= pTab.Title.Value:GetText();
					local sAbbr		= pTab.Abbr.Value:GetText();
					local iInterior	= pTab.Interior.Value:GetSelected();
					local iType		= NULL;
					
					for i in ipairs( eFactionTypeNames ) do
						if pTab.Type[ i ]:GetSelected() then
							iType = i;
							
							break;
						end
					end
					
					if sTitle:len() == 0 then
						this:ShowDialog( MessageBox( "Введите название организации", "Создание организации", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
						
						return false;
					end
					
					if sAbbr:len() == 0 then
						this:ShowDialog( MessageBox( "Введите аббревиатуру организации", "Создание организации", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
						
						return false;
					end
					
					if not iInterior or iInterior == -1 or pTab.List.m_aData[ iInterior + 1 ] == NULL then
						this:ShowDialog( MessageBox( "Вы не выбрали адрес регистрации организации", "Создание организации", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
						
						return false;
					end
					
					if eFactionType[ iType ] == NULL then
						this:ShowDialog( MessageBox( "Вы не выбрали тип организации", "Создание организации", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
						
						return false;
					end
					
					local pMsgBox = this:ShowDialog( MessageBox( "Вы действительно хотите создать организацию?", "Создание организации", MessageBoxButtons.YesNo, MessageBoxIcon.Question ) );
					
					pMsgBox.Button[ "Да" ].OnClick = function()
						local function Complete( Data )
							this.ButtonClose.Click();
						end
						
						this:AsyncQuery( Complete, "CFactionManager", "Create", sTitle, sAbbr, pTab.List.m_aData[ iInterior + 1 ].ID, iType );
					end
				end;
			};
		end
		
		this.ButtonClose = this.Window:CreateButton( "Закрыть" )
		{
			X		= this.Width - 90;
			Y		= this.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				CLIENT.m_pCharacter:HideUI( this );
			end;
		};
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
		
		Ajax:HideLoader();
		
		this.Window.Tab.List.Switched();
	end;
	
	_CUIFactions	= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		this:HideCursor();
		
		Ajax:HideLoader();
	end;
};