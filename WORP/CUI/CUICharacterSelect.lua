-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CUICharacterSelect ( CGUI )
{
	CUICharacterSelect	= function( this, Characters, bCanCreate )
		this.Window	= this:CreateWindow( "Выбор персонажа" )
		{
			X		= "center";
			Y		= "center";
			Width	= 550;
			Height	= 260;
			Sizable	= false;
		};
		
		this.List	= this.Window:CreateGridList{ 0, 25, 550, 185 } 
		{
			{ "Имя", .12 }, 
			{ "Фамилия", .12 }, 
			{ "Статус", .18 }, 
			{ "Создан",	.25 }, 
			{ "Последний вход", .25 } 
		};
		
		this.ButtonSelect		= this.Window:CreateButton( "Выбрать" )
		{
			X		= 385;
			Y		= 220;
			Width	= 75;
			Height	= 25;
			
			Click	= function( sButton )
				if sButton == "left" then
					local iRow 			= this.List:GetSelectedItem();
					
					if not iRow or iRow == -1 then
						return;
					end
					
					local sName			= this.List:GetItemText( iRow, this.List[ "Имя" ] );
					local sSurname		= this.List:GetItemText( iRow, this.List[ "Фамилия" ] );
					
					if not sName or not sSurname then
						return;
					end
					
					if this.List:GetItemText( iRow, this.List[ 'Статус' ] ) == "Активен" then
						SERVER.SelectCharacter( sName, sSurname );
						
						delete ( this );
					end
				end
			end;
		};
		
		this.ButtonCreateNew	= this.Window:CreateButton( "Создать новый" )
		{
			X		= 465;
			Y		= 220;
			Width	= 75;
			Height	= 25;
			Enabled	= (bool)(bCanCreate);
			
			Click	= function( sButton )
				if sButton == "left" then
					SERVER.SelectCharacter( "NEW" );
					
					delete ( this );
				end
			end;
		};
		
		this.List.DoubleClick = this.ButtonSelect.Click;
		
		this:FillList( Characters );
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		this:ShowCursor();
	end;
	
	_CUICharacterSelect	= function( this )
		Ajax:HideLoader();
		
		this:HideCursor();
		
		this.Window:Delete();
		this.Window = NULL;
	end;
	
	FillList	= function( this, Characters )
		this.List:Clear();
		
		for i, pChar in ipairs( Characters ) do
			this.List:AddItem( pChar );
		end
	end;
	
	AddItem		= function( this, pChar )
		if not pChar then
			return;
		end
		
		local iRow 	= this:AddRow();
		
		if not iRow then
			return;
		end
		
		this:SetItemText( iRow, this[ "Имя" ], 				pChar.name,		false, false );
		this:SetItemText( iRow, this[ "Фамилия" ], 			pChar.surname,	false, false );
		this:SetItemText( iRow, this[ "Статус" ], 			pChar.status, 	false, false );
		this:SetItemText( iRow, this[ "Создан" ], 			pChar.created,	false, false );
		this:SetItemText( iRow, this[ "Последний вход" ],	pChar.last_login == "00/00/0000 00:00:00" and "Никогда" or pChar.last_login, false, false );
		
		if pChar.status ~= "Активен" then
			this:SetItemColor( iRow, this[ "Имя" ],				127, 127, 127, 255 );
			this:SetItemColor( iRow, this[ "Фамилия" ],			127, 127, 127, 255 );
			this:SetItemColor( iRow, this[ "Статус" ],			127, 127, 127, 255 );
			this:SetItemColor( iRow, this[ "Создан" ],			127, 127, 127, 255 );
			this:SetItemColor( iRow, this[ "Последний вход" ],	127, 127, 127, 255 );
		end
	end;
};