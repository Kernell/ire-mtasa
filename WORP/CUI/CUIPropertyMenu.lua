-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

enum "ePropertyField"
{
	FIELD_ID		= "ID";
	FIELD_NAME		= "Название";
	FIELD_TYPE		= "Тип";
	FIELD_PRICE		= "Цена";
	FIELD_OWNER		= "Владелец";
	FIELD_FACTION	= "Организация";
	FIELD_CLOSED	= "Закрыт";
};

class: CUIPropertyMenu ( CGUI )
{
	static
	{		
		Fields					=
		{
			FIELD_ID;
			FIELD_NAME;
			FIELD_TYPE;
			FIELD_PRICE;
			FIELD_OWNER;
			FIELD_FACTION;
			FIELD_CLOSED;
		};
		
		FieldTypes				= 
		{
			[ FIELD_ID ] 		= "input";
			[ FIELD_NAME ]		= "input";
			[ FIELD_TYPE ]		= "select";
			[ FIELD_PRICE ]		= "input";
			[ FIELD_OWNER ]		= "input";
			[ FIELD_FACTION ]	= "input";
			[ FIELD_CLOSED ]	= "radio";
		};
		
		ProtectedFields			= 
		{
			[ FIELD_ID ] 		= true;
			[ FIELD_NAME ]		= true;
			[ FIELD_TYPE ]		= true;
			[ FIELD_PRICE ]		= true;
			[ FIELD_OWNER ]		= true;
			[ FIELD_FACTION ]	= true;
			[ FIELD_CLOSED ]	= false;
		};
		
		select		=
		{
			[ FIELD_TYPE ]		= { eInteriorTypeNames[ INTERIOR_TYPE_NONE ], eInteriorTypeNames[ INTERIOR_TYPE_COMMERCIAL ], eInteriorTypeNames[ INTERIOR_TYPE_HOUSE ] };
		};
		
		radio			=
		{
			[ FIELD_CLOSED ]	= { "Да", "Нет" };
		};
	};
	
	CUIPropertyMenu	= function( this, Data, bForce, bAccess, bAdmin )
		bAccess	= (bool)(bAccess);
		bAdmin	= (bool)(bAdmin);
		
		this.ID		= Data[ "ID" ];
		this.sType	= Data[ "Type" ];
		
		this.Window = this:CreateWindow( Data[ "Name" ] + ( bAdmin and " (Admin)" or "" ) )
		{
			X		= "center";
			Y		= "center";
			Width	= 400;
			Height	= 350;
			Sizable	= false;
		};
		
		this.Tab	= this.Window:CreateTabPanel
		{
			X		= 10;
			Y		= 20;
			Width	= this.Window.Width - 10;
			Height	= this.Window.Height - 70;
		};
		
		this.Tab.Info		= this.Tab:CreateTab( "Информация" );
		this.Tab.Store		= this.Tab:CreateTab( "Склад" );
		
		this.Label	= {};
		this.Edit	= {};
		this.Button	= {};
		this.Radio	= {};
		this.Select	= {};
		
		for i, sFieldName in ipairs( CUIPropertyMenu.Fields ) do
			local fY	= 25 + ( ( i - 1 ) * 25 );
			
			this.Tab.Info:CreateLabel( sFieldName + ':' )
			{
				X		= 25;
				Y		= fY;
				Width	= 80;
				Height	= 25;
				Font	= "default-bold-small";
			};
			
			if CUIPropertyMenu.FieldTypes[ sFieldName ] == 'input' then
				this.Label[ sFieldName ] = this.Tab.Info:CreateLabel( sFieldName + ':' )
				{
					X		= 131;
					Y		= fY;
					Width	= 200;
					Height	= 25;
				}
				
				this.Edit[ sFieldName ] = this.Tab.Info:CreateEdit( "" )
				{
					X		= 131;
					Y		= fY;
					Width	= 200;
					Height	= 21;
				}
				
				this.Edit[ sFieldName ]:SetVisible( false );
			elseif CUIPropertyMenu.FieldTypes[ sFieldName ] == 'select' then
				this.Label[ sFieldName ] = this.Tab.Info:CreateLabel( sFieldName + ':' )
				{
					X		= 131;
					Y		= fY;
					Width	= 200;
					Height	= 25;
				}
				
				this.Select[ sFieldName ] = this.Tab.Info:CreateComboBox( sFieldName )
				{
					X		= 131;
					Y		= fY;
					Width	= 200;
					Height	= 85;
				}
				
				for k, v in ipairs( CUIPropertyMenu.select[ sFieldName ] ) do
					this.Select[ sFieldName ]:AddItem( v );
				end
				
				this.Select[ sFieldName ]:SetVisible( false );
			elseif CUIPropertyMenu.FieldTypes[ sFieldName ] == 'radio' then
				this.Radio[ sFieldName ] = {};
				
				for k, v in ipairs( CUIPropertyMenu.radio[ sFieldName ] ) do
					this.Radio[ sFieldName ][ v ] = this.Tab.Info:CreateRadioButton( v )
					{
						X		= 131 + ( ( k - 1 ) * 50 );
						Y		= fY;
						Width	= 50;
						Height	= 21;
					}
				end
			end
			
			if ( not CUIPropertyMenu.ProtectedFields[ sFieldName ] or bAdmin ) and CUIPropertyMenu.FieldTypes[ sFieldName ] ~= 'radio' then
				this.Button[ sFieldName ] = this.Tab.Info:CreateButton( ".." )
				{
					X		= 100;
					Y		= fY;
					Width	= 21;
					Height	= 21;
					
					Click = function()
						if CUIPropertyMenu.FieldTypes[ sFieldName ] == "select" then
							if not this.Select[ sFieldName ]:GetVisible() then
								this.Select[ sFieldName ]:SetSelected( this.sType );
								
								this.Select[ sFieldName ]:SetVisible( true );
								this.Label[ sFieldName ]:SetVisible( false );
							else
								this.Select[ sFieldName ]:SetVisible( true );
								this.Label[ sFieldName ]:SetVisible( false );
								
								this:SetData( sFieldName, this.Select[ sFieldName ]:GetText( this.Select[ sFieldName ]:GetSelected() ) );
							end
						elseif CUIPropertyMenu.FieldTypes[ sFieldName ] == "input" then
							if not this.Edit[ sFieldName ]:GetVisible() then
								this.Edit[ sFieldName ]:SetText( this.Label[ sFieldName ]:GetText() );
								
								this.Label[ sFieldName ]:SetVisible( false );
								this.Edit[ sFieldName ]:SetVisible( true );
							else
								this.Label[ sFieldName ]:SetVisible( true );
								this.Edit[ sFieldName ]:SetVisible( false );
							
								this:SetData( sFieldName, this.Edit[ sFieldName ]:GetText() );
							end
						end
					end;
				};
			end
		end
		
		if Data[ "OwnerID" ] == CLIENT.m_pCharacter.m_iID then
			if Data.Price > 0 then
				this.Window:CreateButton( "Отменить продажу" )
				{
					X		= 5;
					Y		= this.Tab.Height + 25;
					Width	= 88;
					Height	= 32;
					
					Click	= function()					
						this:SetData( FIELD_PRICE, 0 );
					end;
				};
			else
				this.Window:CreateButton( "Выставить на продажу" )
				{
					X		= 5;
					Y		= this.Tab.Height + 25;
					Width	= 88;
					Height	= 32;
					
					Click	= function()					
						local pDialog = this:ShowDialog( CUIInputDialog( "Введите цену" ) );
						
						function pDialog:OnAccept( sValue )
							local iPrice = (int)(sValue);
							
							if iPrice > 0 and iPrice <= 1000000000 then
								this:SetData( FIELD_PRICE, iPrice );
							else
								this:ShowDialog( MessageBox( "Неправильный формат.\nВведите цену от 1 до 1 000 000 000", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
							end
						end
					end;
				};
			end
		elseif Data.Price > 0 then
			this.ButtonBuy = this.Window:CreateButton( "Купить" )
			{
				X		= 5;
				Y		= this.Tab.Height + 25;
				Width	= 88;
				Height	= 32;
				
				Click	= function()
					local iID = this.ID;
					
					local function Complete( Accounts )
						local pPayDialog = this:ShowDialog( CUIBankPayment( Data[ "Price" ], Accounts, true ) );
						
						function pPayDialog:OnSelect( sAccountID, sPIN )
							this.Window:SetEnabled( false );
							
							this:AsyncQuery( this.ButtonClose.Click, "CBankManager", "Buy", "Property", iID, sAccountID, sPIN );
						end
					end
					
					this:AsyncQuery( Complete, "CBankManager", "GetAccounts" );
				end;
			};
		end
		
		this.ButtonClose = this.Window:CreateButton( "Закрыть" )
		{
			X		= this.Window.Width - ( 88 + 5 );
			Y		= this.Tab.Height + 25;
			Width	= 88;
			Height	= 32;
			
			Click	= function()
				CLIENT.m_pCharacter:HideUI( this );
			end;
		};
		
		this.Radio[ FIELD_CLOSED ][ "Да" ][ "Click" ]	= function()
			this:SetData( FIELD_CLOSED, true );
		end
		
		this.Radio[ FIELD_CLOSED ][ "Нет" ][ "Click" ]	= function()
			this:SetData( FIELD_CLOSED, false );
		end
		
		this.Label[ FIELD_ID ]:SetText		( Data[ "Interior" ] );
		this.Label[ FIELD_NAME ]:SetText	( Data[ "Name" ] );
		this.Label[ FIELD_TYPE ]:SetText	( eInteriorTypeNames[ this.sType ] );
		this.Label[ FIELD_PRICE ]:SetText	( Data[ "Price" ] );
		this.Label[ FIELD_OWNER ]:SetText	( Data[ "Owner" ] or "Информация недоступна" );
		this.Label[ FIELD_FACTION ]:SetText	( Data[ "Faction" ] or "Информация недоступна" );
		
		this.Radio[ FIELD_CLOSED ][ Data[ "Locked" ] and "Да" or "Нет" ]:SetSelected( true );
		
		this.Radio[ FIELD_CLOSED ][ "Нет" ]:SetEnabled( true );
		this.Radio[ FIELD_CLOSED ][ "Да" ]:SetEnabled( true );
		
		-- Store
		
		this.Tab.Store.List = this.Tab.Store:CreateGridList{ 0, 0, this.Window.Width, this.Window.Height - 70 }
		{
			{ "Товар", 0.9 };
		};
		
		if Data.Store then
			for i, sItem in ipairs( Data.Store ) do
				local iRow = this.Tab.Store.List:AddRow();
				
				this.Tab.Store.List:SetItemText( iRow, this.Tab.Store.List[ "Товар" ], sItem, false, false );
			end
		else
			this.Tab.Store:SetEnabled( false );
		end
		
		--
		
		Ajax:HideLoader();
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
	end;
	
	_CUIPropertyMenu	= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		this:HideCursor();
		
		Ajax:HideLoader();
		
		if this.m_pTimer then
			this.m_pTimer:Kill();
			this.m_pTimer = NULL;
		end
		
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
	end;
	
	SetData		= function( this, sName, sValue )
		if sName == FIELD_OWNER then
			local sValue = sValue:gsub( "_", " " ):split( " " );
			
			this:AsyncQuery( NULL, "SetInteriorData", this.ID, sName, unpack( sValue ) );
			
			return;
		end
		
		this:AsyncQuery( NULL, "SetInteriorData", this.ID, sName, sValue );
	end;
	
	AsyncQuery	= function( this, Complete, sFunction, ... )
		if this.pAsyncQuery then return false; end
		
		this.Window:SetEnabled( false );
		
		Ajax:ShowLoader( 2 );
		
		this.pAsyncQuery = AsyncQuery( sFunction, ... );
		
		function this.pAsyncQuery.Complete( _self, iStatusCode, Data )
			Ajax:HideLoader();
			
			this.Window:SetEnabled( true );
			
			this.pAsyncQuery = NULL;
			
			if iStatusCode == AsyncQuery.OK then
				if type( Data ) == "string" then
					this:ShowDialog( MessageBox( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
				elseif Complete then
					Complete( Data );
				end
			elseif type( Data ) == "string" then
				this:ShowDialog( MessageBox( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
			end
		end
		
		return true;
	end;
};
