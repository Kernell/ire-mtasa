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
};

function CUIGovFactionList:CUIGovFactionList( Factions )
	self.Window = self:CreateWindow( "Список организаций" )
	{
		X		= self.X;
		Y		= self.Y;
		Width	= self.Width;
		Height	= self.Height;
		Sizable	= false;
	};
	
	self.List	= self.Window:CreateGridList{ 0, 25, self.Width, 300 }
	{
		{ "ID", 				.07	};
		{ "Тип", 				.07	};
		{ "Организация",		.35	};
		{ "Владелец",			.15 };
		{ "Дата создания", 		.15	};
		{ "Дата регистрации", 	.15	};
	};
	
	self:FillList( Factions );
	
	self.ButtonClose	= self.Window:CreateButton( "Закрыть" )
	{
		X		= self.Width - 90;
		Y		= self.Height - 35;
		Width	= 80;
		Height	= 25;
	};
	
	self.Window:SetVisible( true );
	self.Window:BringToFront();
	
	self:ShowCursor();
	
	Ajax:HideLoader();
end

function CUIGovFactionList:_CUIGovFactionList()
	self.Window:Delete();
	self.Window = NULL;
	
	self:HideCursor();
	
	Ajax:HideLoader();
end

function CUIGovFactionList:FillList( Factions )
	self.List:Clear();
	
	if not Factions then return; end
	
	for i, pRow in ipairs( Factions ) do
		self.List:AddItem( pRow );
	end
end

function CUIGovFactionList:AddItem( pRow )
	if not pRow then return end
	
	local Row = self:AddRow();
	
	if not Row then return; end
	
	self:SetItemText( Row,	self[ "ID" ],				pRow.id,								false, true );
	self:SetItemText( Row,	self[ "Тип" ],				CUIGovFactionList.Types[ pRow.type ],	false, false );
	self:SetItemText( Row,	self[ "Организация" ],		(string)(pRow.name),					false, false );
	self:SetItemText( Row,	self[ "Владелец" ],			(string)(pRow.owner),					false, false );
	self:SetItemText( Row,	self[ "Дата создания" ],	(string)(pRow.created),					false, false );
	self:SetItemText( Row,	self[ "Дата регистрации" ],	(string)(pRow.registered),				false, false );
end
