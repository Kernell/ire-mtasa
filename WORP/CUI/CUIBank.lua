-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUIBankPayment ( CGUI )
{
	CUIBankPayment		= function( this, iAmmount, Accounts, bCash )
		this.Window		= this:CreateWindow( "Выберите способ оплаты" )
		{
			X		= "center";
			Y		= "center";
			Width	= 400;
			Height	= 250;
		};
		
		this.Window.List	= this.Window:CreateGridList{ 0, 25, this.Window.Width - 20, this.Window.Height - 95 }
		{
			{ "ID", 0.45 };
			{ "Тип", 0.45 };
		};
		
		this.Window.Label = this.Window:CreateLabel( "Сумма к оплате: $" + (int)(iAmmount) )
		{
			X		= 15;
			Y		= this.Window.List.Y + this.Window.List.Height + 5;
			Width	= this.Window.Width - 30;
			Height	= 21;
			Font	= "default-bold-small";
			Color	= { 255, 0, 0 };
		};
		
		this.ButtonCancel	= this.Window:CreateButton( "Отмена" )
		{
			X		= this.Window.Width - 100;
			Y		= this.Window.Label.Y + this.Window.Label.Height + 5;
			Width	= 90;
			Height	= 30;
			
			Click	= function()
				delete ( this );
			end;
		};
		
		this.ButtonPay		= this.Window:CreateButton( "Оплатить" )
		{
			X		= this.ButtonCancel.X - this.ButtonCancel.Width - 10;
			Y		= this.ButtonCancel.Y;
			Width	= this.ButtonCancel.Width;
			Height	= this.ButtonCancel.Height;
			
			Click	= function()
				local iRow = this.Window.List:GetSelectedItem();
				
				if iRow and iRow ~= -1 then
					local sAccountID 	= this.Window.List:GetItemData( iRow, this.Window.List[ "ID" ] );
					local sAccountType	= this.Window.List:GetItemData( iRow, this.Window.List[ "Тип" ] );
					
					if sAccountID then
						if sAccountType == "Банковская карта" then
							local pPinDialog = this:ShowDialog( CUIBankPIN( sAccountID ) );
							
							function pPinDialog:OnAccept( sPIN )
								delete ( this );
								
								if this.OnSelect then
									this:OnSelect( sAccountID, sPIN );
								end
							end
						else
							delete ( this );
							
							if this.OnSelect then
								this:OnSelect( sAccountID );
							end
						end
					end
				end
			end;
		};
		
		this.Window.List.DoubleClick = this.ButtonPay.Click;
		
		this:Fill( Accounts, bCash );
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
	end;
	
	_CUIBankPayment		= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this:HideCursor();
	end;
	
	Fill		= function( this, Accounts, bCash )
		this.Window.List:Clear();
		
		if bCash then
			this:AddItem( "Оплата наличными", "", "" );
		end
		
		for i, pAccount in ipairs( Accounts ) do
			if pAccount.currency_id == "USD" and pAccount.locked == NULL then
				local sName	= "";
				local sType	= "";
				
				if pAccount.type == "none" then
					sName	= "Личный счёт";
					sType	= "Личный счёт";
				elseif pAccount.type == "faction" then
					sName	= pAccount.faction;
					sType	= "Счёт организации";
				elseif CUIBank.Names[ pAccount.type ] then
					sName	= CUIBank.Names[ pAccount.type ];
					sType	= "Банковская карта";
				end
				
				this:AddItem( pAccount.id, sType, sName );
			end
		end
	end;
	
	AddItem		= function( this, sAccountID, sType, sName )
		local iRow = this.Window.List:AddRow();
		
		this.Window.List:SetItemText( iRow, this.Window.List[ "ID" ], 	sAccountID, false, false );
		this.Window.List:SetItemText( iRow, this.Window.List[ "Тип" ], 	sType + " " + sName, false, false );
		
		this.Window.List:SetItemData( iRow, this.Window.List[ "ID" ], sAccountID );
		this.Window.List:SetItemData( iRow, this.Window.List[ "Тип" ], sType );
	end;
};

class: CUIBankPIN ( CGUI )
{
	CUIBankPIN		= function( this, sAccountID )
		this.Window		= this:CreateWindow( "Введите PIN-код" )
		{
			X			= "center";
			Y			= "center";
			Width		= 205;
			Height		= 105;
		};
		
		this.Window.LabelID		= this.Window:CreateLabel( "Номер счёта:" )
		{
			X			= 10;
			Y			= 25;
			Width		= ( this.Window.Width * 0.5 ) - 10;
			Height		= 22;
			Font		= CEGUIFont( "Segoe UI", 9, true );
		};
		
		this.Window.LabelPIN	= this.Window:CreateLabel( "Пин код:" )
		{
			X			= this.Window.LabelID.X;
			Y			= this.Window.LabelID.Y + this.Window.LabelID.Height + 10;
			Width		= this.Window.LabelID.Width;
			Height		= this.Window.LabelID.Height;
			Font		= CEGUIFont( "Segoe UI", 9, true );
		};
		
		this.Window.ID		= this.Window:CreateEdit( "" )
		{
			X			= this.Window.LabelID.X + this.Window.LabelID.Width + 10;
			Y			= this.Window.LabelID.Y;
			Width		= this.Window.LabelID.Width - 20;
			Height		= this.Window.LabelID.Height;
			MaxLength	= 16;
			Enabled		= false;
		};
		
		this.Window.PIN	= this.Window:CreateEdit( "" )
		{
			X			= this.Window.LabelPIN.X + this.Window.LabelPIN.Width + 10;
			Y			= this.Window.LabelPIN.Y;
			Width		= this.Window.LabelPIN.Width - 20;
			Height		= this.Window.LabelPIN.Height;
			MaxLength	= 16;
		};
		
		this.Window.ButtonCancel	= this.Window:CreateButton( "Отмена" )
		{
			X		= 10;
			Y		= this.Window.PIN.Y + 10;
			Width	= 90;
			Height	= 30;
			
			Click	= function()
				delete ( this );
			end;
		};
		
		this.Window.ButtonOk		= this.Window:CreateButton( "OK" )
		{
			X		= this.Window.ButtonCancel.X - this.Window.ButtonCancel.Width - 10;
			Y		= this.Window.ButtonCancel.Y;
			Width	= this.Window.ButtonCancel.Width;
			Height	= this.Window.ButtonCancel.Height;
		
			Click	= function()
				if this.pAsyncQuery == NULL then
					this.Window:SetEnabled( false );
					
					this.pAsyncQuery = AsyncQuery( "Bank__OpenCard", sAccountID, this.Window.PIN:GetText() );
					
					function this.pAsyncQuery:Complete( iStatusCode, Data )
						if iStatusCode == AsyncQuery.OK then
							if type( Data ) == "string" then
								MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
							else
								if this.OnAccept then
									this:OnAccept( Data );
								end
							end
						elseif type( Data ) == "string" then
							MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
						end
						
						this.Window.ButtonCancel.Click();
					end
				end
			end;
		};
		
		this.Window.PIN.Accept = this.Window.ButtonOk.Click;
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
	end;
	
	_CUIBankPIN		= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this:HideCursor();
	end;
};

class: CUIBankATM ( CGUI )
{
	static
	{
		CardInfoFields =
		{
			{ Name	= "id", 		Caption = "ID",					Default = "0000 0000 0000 0000"		};
			{ Name	= "owner",		Caption = "Владелец",			Default = "Неизвестно"				};
			{ Name	= "faction",	Caption = "Организация",		Default = "Неизвестно"				};
			{ Name	= "created",	Caption = "Дата создания",		Default = "Неизвестно"				};
			{ Name	= "expiry",		Caption = "Дата окончания",		Default = "Отсутствует"				};
			{ Name	= "locked",		Caption = "Дата блокировки",	Default = "Отсутствует"				};
			{ Name	= "currency",	Caption = "Валюта",				Default = "United States Dollar"	};
		};
	};
	
	m_fWidth	= 600.0;
	m_fHeight	= 400.0;

	CUIBankATM	= function( this, Cards )
		this.Window	= this:CreateWindow( "Банкомат" )
		{
			X		= "center";
			Y		= "center";
			Width	= this.m_fWidth;
			Height	= this.m_fHeight;
			Sizable	= false;
		};
		
		this.Window.CardList	= this.Window:CreateGridList{ 10, 25, 180, this.m_fHeight }
		{
			{ "ID",	.9 };
		};
		
		this.Window.CardInfo	= this.Window:CreateButton( "" )
		{
			X		= this.Window.CardList.X + this.Window.CardList.Width + 10;
			Y		= 25;
			Width	= this.Window.Width - this.Window.CardList.X - this.Window.CardList.Width - 10;
			Height	= this.Window.Height - 80;
		};
		
		this.Window.CardInfo:SetEnabled( false );
		
		local fY = 10;
		
		for i, pField in ipairs( CUIBankATM.CardInfoFields ) do
			this.Window.CardInfo:CreateLabel( pField.Caption + ":" )
			{
				X		= 15;
				Y		= fY;
				Width	= this.Window.CardInfo.Width * 0.4;
				Height	= 25;
				Font	= "default-bold-small";
			};
			
			this.Window.CardInfo[ pField.Name ]	= this.Window.CardInfo:CreateLabel( "N/A" )
			{
				X		= ( this.Window.CardInfo.Width * 0.4 ) + 15;
				Y		= fY;
				Width	= this.Window.CardInfo.Width * 0.6;
				Height	= 25;
			};
			
			fY = fY + 25;
		end
		
		this.Window.CardInfo[ "amount" ]	= this.Window.CardInfo:CreateLabel( "Карта не выбрана" )
		{
			X				= 15;
			Y				= fY;
			Width			= this.Window.CardInfo.Width;
			Height			= 30;
			Font			= CEGUIFont( "Segoe UI", 14, true );
			Color			= { 200, 200, 200 };
			HorizontalAlign	= { "center", false };
		};
		
		this.Window.ButtonWithdraw	= this.Window:CreateButton( "Снять деньги" )
		{
			X		= this.Window.CardInfo.X;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				if this.m_pSelectedAccount then
					this:ShowDialog( CUIBankATMWithdraw( this.m_pSelectedAccount ) );
				end
			end;
		};
		
		this.Window.ButtonClose	= this.Window:CreateButton( "Закрыть" )
		{
			X		= this.Window.Width - 90;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				CLIENT.m_pCharacter:HideUI( this );
			end;
		};
		
		function this.Window.CardInfo.SetData( Data )
			if Data.currency_id then
				for i, pField in ipairs( CUIBankATM.CardInfoFields ) do
					this.Window.CardInfo[ pField.Name ]:SetText( Data[ pField.Name ] or pField.Default );
				end
				
				local fAmount = (int)(Data[ "amount" ]);
				
				this.Window.CardInfo[ "amount" ]:SetText( ( "%.3f %s" ):format( fAmount, Data.currency_id ) );
				
				if fAmount > 0 then
					this.Window.CardInfo[ "amount" ]:SetColor( 0, 200, 0 );
				elseif fAmount < 0 then
					this.Window.CardInfo[ "amount" ]:SetColor( 200, 0, 0 );
				else
					this.Window.CardInfo[ "amount" ]:SetColor( 200, 200, 200 );
				end
			end
			
			this.m_pSelectedAccount = Data;
			
			this.Window.CardInfo:SetEnabled( (bool)(Data.currency_id) );
		end
		
		function this.Window.CardList.DoubleClick()
			local iItem = this.Window.CardList:GetSelectedItem();
			
			if not iItem or iItem == -1 then
				return;
			end
			
			local sID = this.Window.CardList:GetItemText( iItem, this.Window.CardList[ "ID" ] );
			
			if sID then
				this:OpenCard( sID );
			end
		end
		
		this.PinDialog = this:CreateWindow( "Введите PIN-код" )
		{
			X		= "center";
			Y		= "center";
			Width	= 205;
			Height	= 105;
		};
		
		this.PinDialog.Password	= this.PinDialog:CreateEdit( "" )
		{
			X			= 10;
			Y			= 25;
			Width		= this.PinDialog.Width - 20;
			Height		= this.PinDialog.Height - 80;
			MaxLength	= 16;
		};
		
		this.PinDialog.ButtonCancel	= this.PinDialog:CreateButton( "Отмена" )
		{
			X		= 10;
			Y		= this.PinDialog.Height - 45;
			Width	= 90;
			Height	= 30;
		};
		
		this.PinDialog.ButtonOk		= this.PinDialog:CreateButton( "OK" )
		{
			X		= this.PinDialog.Width - 100;
			Y		= this.PinDialog.Height - 45;
			Width	= 90;
			Height	= 30;
		};
		
		function this.PinDialog.ButtonCancel.Click()
			this.PinDialog:SetVisible( false );
			this.Window:SetEnabled( true );
			this.Window:BringToFront();
		end
		
		function this.PinDialog.ButtonOk.Click()
			local iItem = this.Window.CardList:GetSelectedItem();
			
			if not iItem or iItem == -1 then
				return;
			end
			
			local sID = this.Window.CardList:GetItemText( iItem, this.Window.CardList[ "ID" ] );
			
			if sID then
				if this.pAsyncQuery == NULL then
					this.PinDialog:SetEnabled( false );
					
					this.pAsyncQuery = AsyncQuery( "Bank__OpenCard", sID, this.PinDialog.Password:GetText() );
					
					function this.pAsyncQuery:Complete( iStatusCode, Data )
						this.pAsyncQuery = NULL;
						
						this.PinDialog.ButtonCancel.Click();
						
						if iStatusCode == AsyncQuery.OK then
							if type( Data ) == "string" then
								MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
							else
								this.Window.CardInfo.SetData( Data );
							end
						elseif type( Data ) == "string" then
							MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
						end
					end
				end
			end
		end
		
		this.PinDialog.Password.Accept = this.PinDialog.ButtonOk.Click;
		
		this:FillList( Cards );
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
	end;

	_CUIBankATM	= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this.PinDialog:Delete();
		this.PinDialog	= NULL;
		
		this:HideCursor();
	end;

	FillList	= function( this, Cards )
		this.Window.CardList:Clear();
		
		if not Cards then return; end
		
		for i, sID in ipairs( Cards ) do
			this:AddItem( sID );
		end
	end;
	
	AddItem		= function( this, sID )
		if not sID then return end
		
		local Row = this.Window.CardList:AddRow();
		
		if not Row then return; end
		
		this.Window.CardList:SetItemText( Row,	this.Window.CardList[ "ID" ],	sID,	false, false );
	end;
	
	OpenCard	= function( this, sID )
		if sID then
			this.Window:SetEnabled( false );
			
			this.PinDialog.Password:SetText( "" );
			this.PinDialog:SetEnabled( true );
			this.PinDialog:SetVisible( true );
			this.PinDialog:BringToFront();
		end
	end;
};

class: CUIBankATMWithdraw( CGUI )
{
	CUIBankATMWithdraw		= function( this, pAccount )
		this.Window		= this:CreateWindow( "Снятие средств со счёта" )
		{
			X		= "center";
			Y		= "center";
			Width	= 250;
			Height	= 110;
			Sizable	= false;
		};
		
		this.Window.EditValue		= this.Window:CreateEdit( "" )
		{
			X		= 10;
			Y		= 30;
			Width	= this.Window.Width - 20;
			Height	= 25;
		};
		
		this.Window.ButtonOk		= this.Window:CreateButton( "ОК" )
		{
			X		= this.Window.Width - 185;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				if this.pAsyncQuery then return; end
				
				this.Window:SetEnabled( false );
				
				Ajax:ShowLoader( 2 );
				
				this.pAsyncQuery = AsyncQuery( "Bank__Withdraw", this.Window.EditValue:GetText(), pAccount.id, NULL );
				
				function this.pAsyncQuery:Complete( iStatusCode, Data )
					Ajax:HideLoader();
					
					this.Window:SetEnabled( true );
					
					this.pAsyncQuery = NULL;
					
					if iStatusCode == AsyncQuery.OK then
						if type( Data ) == "string" then
							MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
						else
							if this.Parent then
								this.Parent.Window.CardInfo.SetData( Data );
							end
						end
					elseif type( Data ) == "string" then
						MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
					end
					
					delete ( this );
				end
			end;
		};
		
		this.Window.ButtonCancel	= this.Window:CreateButton( "Отмена" )
		{
			X		= this.Window.Width - 90;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				delete ( this );
			end;
		};
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		this:ShowCursor();
	end;
	
	_CUIBankATMWithdraw		= function( this )
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this.Window:Delete();
		this.Window = NULL;
		this:HideCursor();
	end;
};

class: CUIBank ( CGUI )
{
	Width		= 600;
	Height		= 340;
	
	static
	{
		Icons	=
		{
			none				= "Resources/Images/Money.png";
			faction				= "Resources/Images/Money.png";
			mastercard			= "Resources/Images/Items/bank_card_mastercard.png";
			visa				= "Resources/Images/Items/bank_card_visa.png";
			americanexpress		= "Resources/Images/Items/bank_card_americanexpress.png";
		};
		
		Names	=
		{
			mastercard			= "MasterCard";
			visa				= "Visa Gold";
			americanexpress		= "American Express";
		};
	};	
	
	CUIBank		= function( this, Accounts )
		this.Window = this:CreateWindow( "Банк" )
		{
			X		= "center";
			Y		= "center";
			Width	= this.Width;
			Height	= this.Height;
			Sizable	= false;
		};
		
		this.Window.ScrollPane	= this.Window:CreateScrollPane( 13, 25, this.Width, this.Height - 76 );
		
		local pScrollPane	= this.Window.ScrollPane;
		
		pScrollPane:SetScrollBars( false, true );
		
		function pScrollPane.MouseWheel( iWheel )
			pScrollPane:SetVerticalScrollPosition( pScrollPane:GetVerticalScrollPosition() - ( iWheel * 3 ) );
		end
		
		this.Window:AddCallBack( "onClientMouseWheel", pScrollPane.MouseWheel, true );
		
		this.Window.ButtonCreateAccount	= this.Window:CreateButton( "Создать счёт" )
		{
			X		= 15;
			Y		= this.Window.Height - 40;
			Width	= 90;
			Height	= 30;
			Enabled	= false;
			
			Click	= function()
				this:ShowDialog( CUIBankCreateAccount() );
			end;
		};
		
		this.Window.ButtonCurrencies	= this.Window:CreateButton( "Курсы валют" )
		{
			X		= 5 + this.Window.ButtonCreateAccount.X + this.Window.ButtonCreateAccount.Width;
			Y		= this.Window.Height - 40;
			Width	= 90;
			Height	= 30;
			
			Click	= function()
				this:ShowDialog( CUIBankCurrencies() );
			end;
		};
		
		this.Window.ButtonClose		= this.Window:CreateButton( "Закрыть" )
		{
			X		= this.Window.Width - 90;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				CLIENT.m_pCharacter:HideUI( this );
			end
		};
		
		this:FillList( Accounts );
		
		this.m_pContextMenu	= CContextMenu();
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
		
		Ajax:HideLoader();
	end;
	
	_CUIBank	= function( this )
		if this.m_pContextMenu then
			delete ( this.m_pContextMenu );
			this.m_pContextMenu = NULL;
		end
		
		if this.m_Dialogs then
			for i, pDialog in ipairs( this.m_Dialogs ) do
				delete ( pDialog );
			end
			
			this.m_Dialogs = NULL;
		end
		
		this.Window:Delete();
		this.Window = NULL;
		
		this:HideCursor();
		
		Ajax:HideLoader();
	end;
	
	Clear		= function( this )
		if this.m_Items then
			for sID, pItem in pairs( this.m_Items ) do
				pItem:Delete();
				pItem = NULL;
			end
		end
		
		this.m_Items = {};
	end;
	
	FillList	= function( this, Accounts )
		local iCount	= 0;
		
		this:Clear();
		
		for i, pAccount in ipairs( Accounts ) do
			this:AddItem( pAccount, i );
			
			if pAccount.type ~= "faction" then
				iCount = iCount + 1;
			end
		end
		
		this.Window.ButtonCreateAccount:SetEnabled( iCount <= 7 );
	end;
	
	AddItem		= function( this, pAccount, i )
		local pItem = this.Window.ScrollPane:CreateButton( "" )
		{
			X		= 25;
			Y		= 0 + ( 66 * ( i - 1 ) );
			Width	= this.Window.Width - 50;
			Height	= 64;
		};
		
		pItem:CreateLabel( "" )
		{
			X		= 0;
			Y		= 0;
			Width	= 1;
			Height	= 1;
		};
		
		pItem.Icon	= pItem:CreateStaticImage( CUIBank.Icons[ pAccount.type ] )
		{
			X		= 10;
			Y		= 0;
			Width	= 64;
			Height	= 64;
		};
		
		local Name	= "Unnamed";
		local Type	= "Неизвестно";
		
		if pAccount.type == "none" then
			Name	= "Личный счёт";
			Type	= "Личный счёт";
		elseif pAccount.type == "faction" then
			Name	= pAccount.faction;
			Type	= "Счёт организации";
		elseif CUIBank.Names[ pAccount.type ] then
			Name = CUIBank.Names[ pAccount.type ];
			Type	= "Банковская карта";
		end
		
		pItem.LabelName	= pItem:CreateLabel( Name )
		{
			X		= 80;
			Y		= 5;
			Width	= pItem.Width;
			Height	= 21;
			Font	= "default-bold-small";
		};
		
		pItem.LabelType	= pItem:CreateLabel( "Тип: " + Type )
		{
			X		= 80;
			Y		= 22;
			Width	= 110;
			Height	= 16;
			Font	= "default-small";
		};
		
		pItem.LabelID	= pItem:CreateLabel( pAccount.id )
		{
			X		= 80;
			Y		= 35;
			Width	= 125;
			Height	= 16;
			Font	= "default";
		};
		
		pItem.LabelAmount	= pItem:CreateLabel( "" )
		{
			X		= 250;
			Y		= 24;
			Width	= pItem.Width - 350;
			Height	= 30;
			Font	= CEGUIFont( "Segoe UI", 13, true );
			
			SetValue	= function( this, fAmount, sCurrencyID )
				this:SetText( ( "%.3f %s" ):format( fAmount, sCurrencyID or pAccount.currency_id ) );
				
				if fAmount > 0 then
					this:SetColor( 0, 200, 0 );
				elseif fAmount < 0 then
					this:SetColor( 2200, 0, 0 );
				else
					this:SetColor( 200, 200, 200 );
				end
			end;
		};
		
		pItem.LabelAmount:SetValue( pAccount.amount, pAccount.currency_id );
		
		pItem.ButtonOp	= pItem:CreateButton( "Операции" )
		{
			X		= pItem.Width - 90;
			Y		= ( pItem.Height - 30 ) / 2;
			Width	= 80;
			Height	= 30;
		};
		
		function pItem:SetLocked( bLocked )
			this.m_bLocked = bLocked;
			
			pItem.LabelName:SetText( Name + ( this.m_bLocked and " (ЗАБЛОКИРОВАН)" or "" ) );
		end
		
		function pItem.ButtonOp.Click()
			this:ContextMenu( pAccount );
		end
		
		pItem:SetLocked( pAccount.locked ~= NULL );
		
		this.m_Items[ pAccount.id ] = pItem;
	end;
	
	ContextMenu	= function( this, pAccount )
		if pAccount ~= NULL and pAccount.id then
			local Items	= {};
			
			table.insert( Items,
				{
					"История",
					function()
						this:ShowDialog( CUIBankLog( pAccount ) );
					end
				}
			);
			
			if not this.m_bLocked then
				table.insert( Items,
					{
						"Пополнить",
						function()
							this:ShowDialog( CUIBankDeposit( pAccount ) );
						end
					}
				);
				
				table.insert( Items,
					{
						"Снять",
						function()
							this:ShowDialog( CUIBankWithdraw( pAccount ) );
						end
					}
				);
				
				table.insert( Items,
					{
						"Перевести",
						function()
							this:ShowDialog( CUIBankTransfer( pAccount ) );
						end
					}
				);
				
				if pAccount.type ~= "none" and pAccount.type ~= "faction" then
					table.insert( Items,
						{
							"Заблокировать",
							function()
								this:ShowDialog( CUIBankLock( pAccount ) );
							end
						}
					);
				end
				
				if pAccount.type == "none" or pAccount.type == "faction" then
					table.insert( Items,
						{
							"Закрыть счёт",
							function()
								this:ShowDialog( CUIBankLock( pAccount, true ) );
							end
						}
					);
				end
			end
			
			this.m_pContextMenu:SetItems( Items );
			this.m_pContextMenu:Show();
		end
	end;
};

class: CUIBankCreateAccount ( CGUI )
{
	CUIBankCreateAccount	= function( this )
		this.Window		= this:CreateWindow( "Создание счёта" )
		{
			X		= "center";
			Y		= "center";
			Width	= 400;
			Height	= 210;
			Sizable	= false;
		};
		
		this.Window:CreateLabel( "Тип:" )
		{
			X		= 25;
			Y		= 30;
			Width	= 100;
			Height	= 21;
			Font	= "default-bold-small";
		};
		
		this.Window:CreateLabel( "Валюта:" )
		{
			X		= 25;
			Y		= 60;
			Width	= 100;
			Height	= 21;
			Font	= "default-bold-small";
		};
		
		this.Window:CreateLabel( "Организация:" )
		{
			X		= 25;
			Y		= 90;
			Width	= 100;
			Height	= 21;
			Font	= "default-bold-small";
		};
		
		this.Window:CreateLabel( "Карта:" )
		{
			X		= 25;
			Y		= 120;
			Width	= 100;
			Height	= 21;
			Font	= "default-bold-small";
		};
		
		this.Window.Type		= this.Window:CreateComboBox( "Выберите" )
		{
			X		= 150;
			Y		= 30;
			Width	= 300;
			Height	= 80;
			Items	=
			{
				"Личный счёт", "Счёт организации", "Банковская карта"
			};
			
			Accept	= function( this )
				this.Window.Currency:Lock();
				this.Window.Faction:Lock();
				this.Window.Card:Lock();
				
				local iItem = this:GetSelected() + 1;
				
				if iItem == 1 then
					this.Window.Currency:UnLock();
				elseif iItem == 2 then
					this.Window.Currency:UnLock();
					this.Window.Faction:UnLock();
				elseif iItem == 3 then
					this.Window.Currency:SetSelected( -1 );
					this.Window.Card:UnLock();
				end
			end;
		};
		
		this.Window.Currency	= this.Window:CreateComboBox( "Выберите" )
		{
			X		= 150;
			Y		= 60;
			Width	= 300;
			Height	= 230;
			
			Lock	= function( this )
				this:SetEnabled( false );
				this:SetAlpha( 0.5 );
			end;
			
			UnLock	= function( this )
				this:SetEnabled( true );
				this:SetAlpha( 1.0 );
			end;
		};
		
		this.Window.Faction		= this.Window:CreateComboBox( "Выберите" )
		{
			X		= 150;
			Y		= 90;
			Width	= 300;
			Height	= 100;
			
			Lock	= function( this )
				this:SetEnabled( false );
				this:SetAlpha( 0.5 );
			end;
			
			UnLock	= function( this )
				this:SetEnabled( true );
				this:SetAlpha( 1.0 );
				this:Clear();
				this:AddItem( "Загрузка ..." );
				this.m_Factions = {};
				
				AsyncQuery( "Bank__GetFactions" ).Complete = function( _self, iStatusCode, Data )
					this:Clear();
					
					if iStatusCode == AsyncQuery.OK and Data then
						local iHeight = 25;
						
						for i, pFaction in ipairs( Data ) do
							this:AddItem( pFaction.m_sName );
							this.m_Factions[ i ] = pFaction;
							
							iHeight = iHeight + 25;
						end
						
						this:SetSize( 300, iHeight, false );
					end
				end
			end;
		};
		
		this.Window.Card		= this.Window:CreateComboBox( "Выберите" )
		{
			X		= 150;
			Y		= 120;
			Width	= 300;
			Height	= 100;
			Items	=
			{
				"Visa Gold", "MasterCard", "American Express"
			};
			
			Lock	= function( this )
				this:SetEnabled( false );
				this:SetAlpha( 0.5 );
			end;
			
			UnLock	= function( this )
				this:SetEnabled( true );
				this:SetAlpha( 1.0 );
			end;
		};		
		
		this.Window.Currency:Lock();
		this.Window.Faction:Lock();
		this.Window.Card:Lock();
		
		this.pAsyncQuery = AsyncQuery( "Bank__GetCurrencies" );
		
		this.pAsyncQuery.Complete = function( _self, iStatusCode, Data )
			if iStatusCode == AsyncQuery.OK and Data then
				this.Window.Currency.m_Currencies = {};
				
				for i, pRow in ipairs( Data ) do
					this.Window.Currency:AddItem( pRow.id + " (" + pRow.name + ")" );
					this.Window.Currency.m_Currencies[ i ] = pRow;
				end
			end
			
			this.pAsyncQuery = NULL;
		end
		
		this.Window.ButtonOk		= this.Window:CreateButton( "Создать" )
		{
			X		= this.Window.Width - 185;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				if this.pAsyncQuery then return; end
				
				local sType, sCurrencyID, iFactionID, sCard = "none", "USD", 0, NULL;
				
				local iItemType			= this.Window.Type:GetSelected() + 1;
				local iItemCurrency		= this.Window.Currency:GetSelected() + 1;
				local iItemFaction		= this.Window.Faction:GetSelected() + 1;
				local iItemCard			= this.Window.Card:GetSelected() + 1;
				
				if iItemType == 1 then
					sType = "none";
				elseif iItemType == 2 then
					sType = "faction";
					
					local pFaction = this.Window.Faction.m_Factions[ iItemFaction ];
					
					if pFaction then
						iFactionID = pFaction.m_iID;
					else
						MessageBox:Show( "Выберите организацию", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
						
						return;
					end
				elseif iItemType == 3 then
					sType = "card";
					
					if iItemCard == 1 then
						sCard = "visa";
					elseif iItemCard == 2 then
						sCard = "mastercard";
					elseif iItemCard == 3 then
						sCard = "americanexpress";
					else
						MessageBox:Show( "Выберите тип карты", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
						
						return;
					end
				else
					MessageBox:Show( "Выберите тип счёта", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
					
					return;
				end
				
				local pCurrency = this.Window.Currency.m_Currencies[ iItemCurrency ];
				
				if pCurrency then
					sCurrencyID = pCurrency.id;
				elseif iItemType ~= 3 then
					MessageBox:Show( "Выберите валюту", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
					
					return;
				end
				
				this.Window:SetEnabled( false );
				
				Ajax:ShowLoader( 2 );
				
				this.pAsyncQuery = AsyncQuery( "Bank__CreateAccount", sType, sCurrencyID, iFactionID, sCard );
				
				function this.pAsyncQuery:Complete( iStatusCode, Data )
					Ajax:HideLoader();
					
					this.Window:SetEnabled( true );
					
					this.pAsyncQuery = NULL;
					
					if iStatusCode == AsyncQuery.OK then
						if type( Data ) == "table" then
							this.Parent:FillList( Data );
							
							delete ( this );
						elseif type( Data ) == "string" then
							MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
						end
					else
						MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
					end
				end
			end;
		};
		
		this.Window.ButtonCancel	= this.Window:CreateButton( "Отмена" )
		{
			X		= this.Window.Width - 90;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				delete ( this );
			end;
		};
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		this:ShowCursor();
	end;
	
	_CUIBankCreateAccount	= function( this )
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this.Window:Delete();
		this.Window = NULL;
		this:HideCursor();
	end;
};

class: CUIBankDeposit ( CGUI )
{
	CUIBankDeposit	= function( this, pAccount )
		this.Window		= this:CreateWindow( "Пополнение средств счёта" )
		{
			X		= "center";
			Y		= "center";
			Width	= 250;
			Height	= 105;
			Sizable	= false;
		};
		
		this.Window.EditValue		= this.Window:CreateEdit( "" )
		{
			X		= 10;
			Y		= 30;
			Width	= this.Window.Width - 20;
			Height	= 25;
		};
		
		this.Window.ButtonOk		= this.Window:CreateButton( "ОК" )
		{
			X		= this.Window.Width - 185;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				if this.pAsyncQuery then return; end
				
				this.Window:SetEnabled( false );
				
				Ajax:ShowLoader( 2 );
				
				this.pAsyncQuery = AsyncQuery( "Bank__Deposit", this.Window.EditValue:GetText(), pAccount.id );
				
				function this.pAsyncQuery:Complete( iStatusCode, Data )
					Ajax:HideLoader();
					
					this.Window:SetEnabled( true );
					
					this.pAsyncQuery = NULL;
					
					if iStatusCode == AsyncQuery.OK then
						if type( Data ) == "table" then
							if this.Parent and this.Parent.m_Items[ Data.id ] then
								this.Parent.m_Items[ Data.id ].LabelAmount:SetValue( Data.amount, Data.currency_id );
							end
						elseif type( Data ) == "string" then
							return MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
						end
					else
						return MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
					end
					
					delete ( this );
				end
			end;
		};
		
		this.Window.ButtonCancel	= this.Window:CreateButton( "Отмена" )
		{
			X		= this.Window.Width - 90;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				delete ( this );
			end;
		};
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		this:ShowCursor();
	end;
	
	_CUIBankDeposit	= function( this )
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this.Window:Delete();
		this.Window = NULL;
		this:HideCursor();
	end;
};

class: CUIBankWithdraw ( CGUI )
{
	CUIBankWithdraw 	= function( this, pAccount )
		this.Window		= this:CreateWindow( "Снятие средств со счёта" )
		{
			X		= "center";
			Y		= "center";
			Width	= 250;
			Height	= 190;
			Sizable	= false;
		};
		
		this.Window.EditValue		= this.Window:CreateEdit( "" )
		{
			X		= 10;
			Y		= 30;
			Width	= this.Window.Width - 20;
			Height	= 25;
		};
		
		this.Window:CreateLabel( "Причина " + ( pAccount.faction and "(проверяется налоговыми службами)" or "(не обязательно)" ) )
		{
			X		= 10;
			Y		= this.Window.EditValue.Y + this.Window.EditValue.Height + 5;
			Width	= this.Window.Width - 20;
			Height	= 20;
			Font	= "default-bold-small";
		};
		
		this.Window.MemoReason		= this.Window:CreateMemo( "" )
		{
			X		= 10;
			Y		= this.Window.EditValue.Y + this.Window.EditValue.Height + 25;
			Width	= this.Window.Width - 20;
			Height	= 60;
		};
		
		this.Window.ButtonOk		= this.Window:CreateButton( "ОК" )
		{
			X		= this.Window.Width - 185;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				if this.pAsyncQuery then return; end
				
				this.Window:SetEnabled( false );
				
				Ajax:ShowLoader( 2 );
				
				this.pAsyncQuery = AsyncQuery( "Bank__Withdraw", this.Window.EditValue:GetText(), pAccount.id, this.Window.MemoReason:GetText() );
				
				function this.pAsyncQuery:Complete( iStatusCode, Data )
					Ajax:HideLoader();
					
					this.Window:SetEnabled( true );
					
					this.pAsyncQuery = NULL;
					
					if iStatusCode == AsyncQuery.OK then
						if type( Data ) == "table" then
							if this.Parent and this.Parent.m_Items[ Data.id ] then
								this.Parent.m_Items[ Data.id ].LabelAmount:SetValue( Data.amount, Data.currency_id );
							end
						elseif type( Data ) == "string" then
							return MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
						end
					else
						return MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
					end
					
					delete ( this );
				end
			end;
		};
		
		this.Window.ButtonCancel	= this.Window:CreateButton( "Отмена" )
		{
			X		= this.Window.Width - 90;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				delete ( this );
			end;
		};
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		this:ShowCursor();
	end;
	
	_CUIBankWithdraw	= function( this )
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this.Window:Delete();
		this.Window = NULL;
		this:HideCursor();
	end;
};

class: CUIBankTransfer ( CGUI )
{
	CUIBankTransfer		= function( this, pAccount )
		this.Window		= this:CreateWindow( "Перевод средств на другой счёт" )
		{
			X		= "center";
			Y		= "center";
			Width	= 250;
			Height	= 280;
			Sizable	= false;
		};
		
		this.Window:CreateLabel( "Сумма" )
		{
			X		= 10;
			Y		= 30;
			Width	= this.Window.Width - 20;
			Height	= 20;
			Font	= "default-bold-small";
		};
		
		this.Window.EditValue		= this.Window:CreateEdit( "" )
		{
			X		= 10;
			Y		= 50;
			Width	= this.Window.Width - 20;
			Height	= 25;
		};
		
		this.Window:CreateLabel( "Номер счёта" )
		{
			X		= 10;
			Y		= 90;
			Width	= this.Window.Width - 20;
			Height	= 20;
			Font	= "default-bold-small";
		};
		
		local iEditIDWidth	= ( this.Window.Width - 20 ) / 4;
		
		this.Window.EditID			= {};
		
		for i = 0, 3 do
			this.Window.EditID[ i + 1 ] = this.Window:CreateEdit( "" )
			{
				X			= 10 + ( ( iEditIDWidth + 1 ) * i );
				Y			= 110;
				Width		= iEditIDWidth;
				Height		= 25;
				MaxLength	= 4;
			};
		end
		
		this.Window:CreateLabel( "Описание " + ( pAccount.faction and "(проверяется налоговыми службами)" or "(не обязательно)" ) )
		{
			X		= 10;
			Y		= 140;
			Width	= this.Window.Width - 20;
			Height	= 20;
			Font	= "default-bold-small";
		};
		
		this.Window.MemoReason		= this.Window:CreateMemo( "" )
		{
			X		= 10;
			Y		= 160;
			Width	= this.Window.Width - 20;
			Height	= 60;
		};
		
		this.Window.ButtonOk		= this.Window:CreateButton( "ОК" )
		{
			X		= this.Window.Width - 185;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				if this.pAsyncQuery then return; end
				
				this.Window:SetEnabled( false );
				
				Ajax:ShowLoader( 2 );
				
				local aTargetAcc = {};
				
				for i = 1, 4 do
					table.insert( aTargetAcc, this.Window.EditID[ i ]:GetText() );
				end
				
				this.pAsyncQuery = AsyncQuery( "Bank__Transfer", this.Window.EditValue:GetText(), pAccount.id, table.concat( aTargetAcc, " " ), this.Window.MemoReason:GetText() );
				
				function this.pAsyncQuery:Complete( iStatusCode, Data )
					Ajax:HideLoader();
					
					this.Window:SetEnabled( true );
					
					this.pAsyncQuery = NULL;
					
					if iStatusCode == AsyncQuery.OK then
						if type( Data ) == "table" then
							if this.Parent and this.Parent.m_Items[ Data.id ] then
								this.Parent.m_Items[ Data.id ].LabelAmount:SetValue( Data.amount, Data.currency_id );
							end
						elseif type( Data ) == "string" then
							return MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
						end
					else
						return MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
					end
					
					delete ( this );
				end
			end;
		};
		
		this.Window.ButtonCancel	= this.Window:CreateButton( "Отмена" )
		{
			X		= this.Window.Width - 90;
			Y		= this.Window.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				delete ( this );
			end;
		};
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		this:ShowCursor();
	end;
	
	_CUIBankTransfer	= function( this )
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this.Window:Delete();
		this.Window = NULL;
		this:HideCursor();
	end;
};

class: CUIBankLock ( CGUI )
{
	CUIBankLock		= function( this, pAccount, bClose )
		this.Window		= this:CreateWindow( ( bClose and "Закрытие" or "Блокировка" ) + " счёта" )
		{
			X			= "center";
			Y			= "center";
			Width		= 250;
			Height		= 200;
			Sizable		= false;
		};
		
		this.Window:CreateLabel( "Укажите причину " + ( bRemove and "закрытия" or "блокировки" ) )
		{
			X			= 15;
			Y			= 25;
			Width		= 250;
			Height		= 20;
			Font		= "default-bold-small";
		};
		
		this.Window.Reason		= this.Window:CreateMemo( "" )
		{
			X			= 15;
			Y			= 45;
			Width		= this.Window.Width - 30;
			Height		= this.Window.Height - 130;
		};
		
		this.Window:CreateLabel( "Внимание! Операция не сможет быть отменена!" )
		{
			X			= 15;
			Y			= this.Window.Y + this.Window.Height + 5;
			Width		= 250;
			Height		= 20;
			Color		= { 255, 0, 0 };
			Font		= "default-bold-small";
		};
		
		this.Window.ButtonOk		= this.Window:CreateButton( bClose and "Закрыть счёт" or "Заблокировать" )
		{
			X			= this.Window.Width - 185;
			Y			= this.Window.Height - 40;
			Width		= 90;
			Height		= 30;
			
			Click		= function()
				if this.pAsyncQuery then return; end
				
				this.Window:SetEnabled( false );
				
				Ajax:ShowLoader( 2 );
				
				this.pAsyncQuery = AsyncQuery( "Bank__LockAccount", pAccount.id, this.Window.Reason:GetText(), bClose );
				
				function this.pAsyncQuery:Complete( iStatusCode, Data )
					Ajax:HideLoader();
					
					this.Window:SetEnabled( true );
					
					this.pAsyncQuery = NULL;
					
					if iStatusCode == AsyncQuery.OK then
						if Data == true then
							if this.Parent and this.Parent.m_Items[ Data.id ] then
								if bClose then
									this.Parent.m_Items[ Data.id ]:SetEnabled( false );
								else
									this.Parent.m_Items[ Data.id ]:SetLocked( true );
								end
							end
						elseif type( Data ) == "string" then
							return MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
						end
					else
						return MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
					end
					
					delete ( this );
				end
			end;
		};
		
		this.Window.ButtonCancel	= this.Window:CreateButton( "Отмена" )
		{
			X			= this.Window.Width - 90;
			Y			= this.Window.Height - 40;
			Width		= 80;
			Height		= 30;
			
			Click		= function()
				delete ( this );
			end;
		};
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		this:ShowCursor();
	end;
	
	_CUIBankLock	= function( this )
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this.Window:Delete();
		this.Window = NULL;
		this:HideCursor();
	end;
};

class: CUIBankCurrencies ( CGUI )
{
	CUIBankCurrencies	= function( this )
		this.Window		= this:CreateWindow( "Курсы валют" )
		{
			X			= "center";
			Y			= "center";
			Width		= 500;
			Height		= 350;
			Sizable		= false;
		};
		
		this.Window:CreateLabel( "Основной валютой является: USD (United States Dollar)\nКурсы указаны относительно этой валюты" )
		{
			X		= 10;
			Y		= 25;
			Width	= this.Window.Width - 20;
			Height	= 40;
			Font	= "default-bold-small";
		};
		
		this.Window.List	= this.Window:CreateGridList{ 10, 60, this.Window.Width - 20, this.Window.Height - 110 }
		{
			{ "Код", 		0.2 };
			{ "Название", 	0.3 };
			{ "Покупка",	0.2 };
			{ "Продажа",	0.2 };
		};
		
		this.Window.ButtonClose	= this.Window:CreateButton( "Закрыть" )
		{
			X			= this.Window.Width - 90;
			Y			= this.Window.Height - 40;
			Width		= 80;
			Height		= 30;
			
			Click		= function()
				delete ( this );
			end;
		};
		
		this.pAsyncQuery = AsyncQuery( "Bank__GetCurrencies" );
		
		this.pAsyncQuery.Complete = function( _self, iStatusCode, Data )
			if iStatusCode == AsyncQuery.OK and Data then
				for i, pRow in ipairs( Data ) do
					local iRow = this.Window.List:AddRow();
			
					if iRow then
						this.Window.List:SetItemText( iRow, this.Window.List[ "Код" ],		pRow.id,		false, false );
						this.Window.List:SetItemText( iRow, this.Window.List[ "Название" ],	pRow.name,		false, false );
						this.Window.List:SetItemText( iRow, this.Window.List[ "Покупка" ],	( "%.3f" ):format( pRow.rate ),			false, false );
						this.Window.List:SetItemText( iRow, this.Window.List[ "Продажа" ],	( "%.3f" ):format( pRow.rate + 1.0 ),	false, false );
					end
				end
			end
		end
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		this:ShowCursor();
	end;
	
	_CUIBankCurrencies	= function( this )
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this.Window:Delete();
		this.Window = NULL;
		this:HideCursor();
	end;
};

class: CUIBankLog ( CGUI )
{
	CUIBankLog	 	= function( this, pAccount	)
		this.Window		= this:CreateWindow( "История операций" )
		{
			X			= "center";
			Y			= "center";
			Width		= 650;
			Height		= 350;
			Sizable		= false;
		};
		
		this.Window:CreateLabel( "Показаны 30 последних операций" )
		{
			X		= 10;
			Y		= 25;
			Width	= this.Window.Width - 20;
			Height	= 40;
			Font	= "default-bold-small";
		};
		
		this.Window.List	= this.Window:CreateGridList{ 10, 60, this.Window.Width - 20, this.Window.Height - 110 }
		{
			{ "Номер", 			0.10 };
			{ "Тип операции", 	0.40 };
			{ "Дата",			0.20 };
			{ "Сумма", 			0.25 };
		};
		
		this.Window.ButtonClose	= this.Window:CreateButton( "Закрыть" )
		{
			X			= this.Window.Width - 90;
			Y			= this.Window.Height - 40;
			Width		= 80;
			Height		= 30;
			
			Click		= function()
				delete ( this );
			end;
		};
		
		this.pAsyncQuery = AsyncQuery( "Bank__GetLog", pAccount.id );
		
		this.pAsyncQuery.Complete = function( _self, iStatusCode, Data )
			if iStatusCode == AsyncQuery.OK then
				if type( Data ) == "table" then
					for i, pRow in ipairs( Data ) do
						local iRow = this.Window.List:AddRow();
						
						if iRow then
							this.Window.List:SetItemText( iRow, this.Window.List[ "Номер" ],			(int)(pRow.id),			false, false );
							this.Window.List:SetItemText( iRow, this.Window.List[ "Тип операции" ],		(string)(pRow.text),	false, false );
							this.Window.List:SetItemText( iRow, this.Window.List[ "Дата" ],				pRow.date,				false, false );
							
							if pRow.amount then
								this.Window.List:SetItemText( iRow, this.Window.List[ "Сумма" ], ( "%.3f" ):format( pRow.amount ),	false, false );
								
								if pRow.amount < 0.0 then
									this.Window.List:SetItemColor( iRow, this.Window.List[ "Сумма" ],	200, 0, 0 );
								elseif pRow.amount > 0.0 then
									this.Window.List:SetItemColor( iRow, this.Window.List[ "Сумма" ],	0, 200, 0 );
								else
									this.Window.List:SetItemColor( iRow, this.Window.List[ "Сумма" ],	200, 200, 200 );
								end
							end
						end
					end
				elseif type( Data ) == "string" then
					return MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
				end
			end
		end
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		this:ShowCursor();
	end;
	
	_CUIBankLog		= function( this )
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this.Window:Delete();
		this.Window = NULL;
		this:HideCursor();
	end;
};
