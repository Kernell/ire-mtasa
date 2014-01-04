-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CUIGovFactionList ( CGUI )
{
	X		= "center";
	Y		= "center";
	Width	= 600;
	Height	= 365;
	
	Types	=
	{
		[ 0 ] = "Гос.";
		[ 1 ] = "LLC";
		[ 2 ] = "Corp.";
		[ 3 ] = "Sole";
	};
	
	CUIGovFactionList	= function( this, Factions )
		this.Window = this:CreateWindow( "Список организаций" )
		{
			X		= this.X;
			Y		= this.Y;
			Width	= this.Width;
			Height	= this.Height;
			Sizable	= false;
		};
		
		this.List	= this.Window:CreateGridList{ 0, 25, this.Width, 300 }
		{
			{ "ID", 				0.07 };
			{ "Тип", 				0.06 };
			{ "Название",			0.40 };
			{ "Владелец",			0.15 };
			{ "Дата создания", 		0.15 };
			{ "Дата регистрации", 	0.15 };
		};
		
		this:FillList( Factions );
		
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
		
		function this.List.DoubleClick( sButton )
			if sButton == "left" then
				local iRow 	= this.List:GetSelectedItem();
				
				if not iRow or iRow == -1 then
					return;
				end
				
				local iID	= (int)(this.List:GetItemData( iRow, this.List[ "ID" ] ));
				
				if iID == 0 then
					return;
				end
				
				local pDialog = this:ShowDialog( CUIGovFactionEdit( iID ) );
			end
		end
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
		
		Ajax:HideLoader();
	end;

	_CUIGovFactionList	= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		this:HideCursor();
		
		Ajax:HideLoader();
	end;

	FillList	= function( this, Factions )
		this.List:Clear();
		
		if not Factions then return; end
		
		for i, pRow in ipairs( Factions ) do
			this.List:AddItem( pRow );
		end
	end;

	AddItem		= function( this, pRow )
		if not pRow then return; end
		
		local iRow = this:AddRow();
		
		this:SetItemText( iRow,	this[ "ID" ],				pRow.id,						false, true );
		this:SetItemText( iRow,	this[ "Тип" ],				this.Types[ pRow.type ],		false, false );
		this:SetItemText( iRow,	this[ "Организация" ],		(string)(pRow.name),			false, false );
		this:SetItemText( iRow,	this[ "Владелец" ],			(string)(pRow.owner),			false, false );
		this:SetItemText( iRow,	this[ "Дата создания" ],	(string)(pRow.created),			false, false );
		this:SetItemText( iRow,	this[ "Дата регистрации" ],	(string)(pRow.registered),		false, false );
		
		this:SetItemData( iRow,	this[ "ID" ], pRow.id );
	end;
};
