-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUIFactionTaxi ( CGUI, CUIAsyncQuery )
{
	CUIFactionTaxi	= function( this, Calls, iServerTimestamp )
		this.Window	= this:CreateWindow( "Список вызовов" )
		{
			X		= "center";
			Y		= "center";
			Width	= 480;
			Height	= 360;
			Sizable	= false;
		};
		
		this.List	= this.Window:CreateGridList{ 0, 20, this.Window.Width, this.Window.Height - 60 }
		{
			{ "Заказчик", 	0.333 };
			{ "Адрес", 		0.333 };
			{ "Время", 		0.333 };
		};
		
		this.ButtonClose	= this.Window:CreateButton( "Закрыть" )
		{
			X		= this.Width - 90;
			Y		= this.Height - 35;
			Width	= 80;
			Height	= 25;
			
			Click	= function()
				CLIENT.m_pCharacter:HideUI( this );
			end;
		};
		
		this.ButtonAccept	= this.Window:CreateButton( "Принять вызов" )
		{
			X		= this.Width - this.ButtonClose.X - 10;
			Y		= this.Height - 35;
			Width	= 80;
			Height	= 25;
			
			Click	= function()
				local iRow 		= this.List:GetSelectedItem();
				
				if not iRow or iRow == -1 then
					return;
				end
				
				local iPlayerID	= this.List:GetItemData( iRow, this.List[ "Заказчик" ] );
				
				if iPlayerID then
					this:AsyncQuery( NULL, "FactionTaxi__AcceptCall", iPlayerID );
				end
			end;
		};
		
		this.List.DoubleClick = this.ButtonAccept.Click;
		
		this:FillList( Calls, iServerTimestamp );
		
		this.Window:SetVisible( true );
		this:ShowCursor();
	end;
	
	_CUIFactionTaxi	= function( this )
		this:_CUIAsyncQuery();
		
		this.Window:Delete();
		this:HideCursor();
	end;
	
	FillList	= function( this, Calls, iServerTimestamp )
		local aCalls = {};
		
		for iID, pCall in pairs( Calls )
			table.insert( aCalls, pCall );
		end
		
		table.sort( aCalls, function( a, b ) return a.iTimestamp < b.iTimestamp; end );
		
		for i, pCall in ipairs( aCalls ) do
			if iServerTimestamp - pCall.iTimestamp < 86400 then
				this:AddItem( pCall );
			end
		end
	end;
	
	AddItem		= function( this, pCall )
		local iRow	= this.List:AddRow();
		
		local pDate		= CDateTime( pCall.iTimestamp );
		
		local sName		= pCall.sName;
		local sDate		= pDate:Format( "H:i:s" );
		local sLocation	= GetZoneName( pCall.vecPosition );
		
		this.List:SetItemData( iRow, this.List[ "Заказчик" ], pCall.iPlayerID );
		
		this.List:SetItemText( iRow, this.List[ "Заказчик" ], 	sName, 		false, false );
		this.List:SetItemText( iRow, this.List[ "Адрес" ], 		sDate, 		false, false );
		this.List:SetItemText( iRow, this.List[ "Время" ], 		sLocation,	false, false );
	end;
};