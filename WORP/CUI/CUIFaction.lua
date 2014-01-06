-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUIFaction ( CGUI, CUIAsyncQuery )
{
	ID			= 0;
	Caption		= "Ваша организация";
	NoCaption	= "Вы не состоите в организации";
	X			= "center";
	Y			= "center";
	Width		= 600;
	Height		= 400;
	Sizable		= false;
	
	TestRight	= function( this, eRight )
		return ( this.m_iRights '&' ( eRight ) ) ~= 0;
	end
};

function CUIFaction:CUIFaction( sRights, Info )
	self.ID			= Info and Info.ID or 0;
	self.m_iRights	= tonumber( sRights );
	
	self.Window		= self:CreateWindow( Info and self.Caption or self.NoCaption )
	{
		X			= self.X;
		Y			= self.Y;
		Width		= self.Width;
		Height		= self.Height;
		Sizable		= false;
	};
	
	self.Tab		= self.Window:CreateTabPanel
	{
		X			= 0;
		Y			= 25;
		Width		= self.Width;
		Height		= self.Height - 70;
	};
	
	self.Tab.Info		= self.Tab:CreateTab( "Информация", false );
	self.Tab.Staff		= self.Tab:CreateTab( "Сотрудники", false );
	self.Tab.Depts		= self.Tab:CreateTab( "Отделы и должности", false );
	self.Tab.BankAcc	= self.Tab:CreateTab( "Управление счётом", false );
	
	function self.Tab.Staff.Switched()
		if self.Tab.Staff.m_aStaff then
			return;
		end
		
		self:LoadData( "Staff" );
	end
	
	function self.Tab.Depts.Switched()
		if self.Tab.Depts.m_aDepts then
			return;
		end
		
		self:LoadData( "Depts" );
	end
	
	function self.Tab.BankAcc.Switched()
		if self.Tab.BankAcc.m_bBankLoaded then
			return;
		end
		
		self:LoadData( "BankAcc" );
	end
	
	self.ButtonClose	= self.Window:CreateButton( "Закрыть" )
	{
		X		= self.Width - 90;
		Y		= self.Height - 40;
		Width	= 85;
		Height	= 30;
		
		Click	= function()
			delete ( self );
		end;
	};
	
	self:LoadInfoTab	( Info );
	self:LoadStaffTab	();
	self:LoadDeptsTab	();
	self:LoadBankAccTab	();
	
	self.Window:SetVisible( true );
	self.Window:BringToFront();
	self:ShowCursor();
end

function CUIFaction:_CUIFaction()
	Ajax:HideLoader();
	
	self:HideCursor();
	
	self.Window:Delete();
	self.Window = NULL;
	
	self:_CUIAsyncQuery();
end

function CUIFaction:LoadData( sDataName )
	local function Complete( Data )
		self.Tab[ sDataName ]:SetItems( Data );
	end
	
	self:AsyncQuery( Complete, "Faction_GetData", sDataName, self.ID );
end

function CUIFaction:LoadInfoTab( Info )
	local pTab	= self.Tab.Info;
	
	if Info then
		local InfoFields =
		{
			{ Name = "Owner", 			Caption = "Владелец" };
			{ Name = "Name", 			Caption = "Название" };
			{ Name = "Abbr", 			Caption = "Аббревиатура" };
			{ Name = "Type", 			Caption = "Тип организации" };
			{ Name = "Property", 		Caption = "Адрес регистрации" };
			{ Name = "CreatedDate", 	Caption = "Дата создания" };
			{ Name = "RegisterDate", 	Caption = "Дата регистрации" };
			{ Name = "BankAccountID", 	Caption = "Номер счёта" };
		};
		
		for i, Field in ipairs( InfoFields ) do
			pTab:CreateLabel( Field.Caption + ":" )
			{
				X		= 20;
				Y		= 20 + ( 22 * ( i - 1 ) );
				Width	= 200;
				Height	= 22;
				Font	= "default-bold-small";
			};
			
			pTab:CreateLabel( Info[ Field.Name ] or "Неизвестно" )
			{
				X		= 220;
				Y		= 20 + ( 22 * ( i - 1 ) );
				Width	= 200;
				Height	= 22;
			};
		end
		
		pTab:SetEnabled( true );
		pTab.Parent:SetSelected( pTab );
	end
end

function CUIFaction:LoadStaffTab()
	local pTab	= self.Tab.Staff;
	
	local bStaff = pTab:TestRight( eFactionRight.STAFF_LIST );
	
	pTab.List = pTab:CreateGridList{ 0, 0, pTab.Parent.Width, pTab.Parent.Height - 80 }
	{
		{ "Имя", 		.13 };
		{ "Фамилия",	.13 };
		{ "Отдел", 		.2	};
		{ "Должность", 	.2	};
		{ "Телефон", 	.15 };
		{ "Статус", 	.15	};
	};
	
	function pTab.List.GetSelectedItemID()
		local iItem = pTab.List:GetSelectedItem();
		
		if not iItem or iItem == -1 then
			return 0;
		end
		
		return (int)(pTab.List:GetItemData( iItem, pTab.List[ "Имя" ] ) );
	end
	
	pTab.ButtonAdd		= pTab:CreateButton( "Добавить" )
	{
		X		= 10;
		Y		= pTab.Parent.Height - 70;
		Width	= 90;
		Height	= 30;
		
		Click	= function()
			local pDialog		= self:ShowDialog( CUIFactionStaffCard( -1 ) );
		end;
	};
	
	pTab.ButtonEdit		= pTab:CreateButton( "Изменить" )
	{
		X		= 100;
		Y		= pTab.Parent.Height - 70;
		Width	= 80;
		Height	= 30;
		
		Click	= function()
			local iMemberID		= pTab.List.GetSelectedItemID();
			
			if iMemberID ~= 0 then
				local pDialog	= self:ShowDialog( CUIFactionStaffCard( iMemberID ) );
			end
		end;
	};
	
	pTab.ButtonRemove	= pTab:CreateButton( "Уволить" )
	{
		X		= 180;
		Y		= pTab.Parent.Height - 70;
		Width	= 90;
		Height	= 30;
		
		Click	= function()
		-- //	local pDialog		= self:ShowDialog( CUIFactionStaffCard( NULL ) );
		end;
	};
	
	pTab:SetEnabled( bStaff );
	
	function pTab.SetItems( this, Staff )
		if not bStaff then
			return false;
		end
		
		pTab.m_aStaff = Staff;
		
		for i, pRow in ipairs( Staff ) do
			local iRow = pTab.List:AddRow();
			
			if iRow then
				pTab.List:SetItemData( iRow, pTab.List[ "Имя" ],		pRow.name );
				
				pTab.List:SetItemText( iRow, pTab.List[ "Имя" ],		pRow.name,		false, false );
				pTab.List:SetItemText( iRow, pTab.List[ "Фамилия" ],	pRow.surname,	false, false );
				pTab.List:SetItemText( iRow, pTab.List[ "Отдел" ],		pRow.dept	,	false, false );
				pTab.List:SetItemText( iRow, pTab.List[ "Должность" ],	pRow.rank,		false, false );
				pTab.List:SetItemText( iRow, pTab.List[ "Телефон" ],	pRow.phone,		false, false );
				pTab.List:SetItemText( iRow, pTab.List[ "Статус" ],		pRow.online_status == -1 and "Online" or 
																		pRow.online_status == 0 and "Сегодня" or 
																		( pRow.online_status + math.decl( aItem.online_status, " день", " дня", " дней" ) + " назад" ),
					false, false 
				);
				
				if pRow.online_status == -1 then
					pTab.List:SetItemColor( iRow, pTab.List[ "Статус" ],	0, 255, 0, 255 );
				end
				
				if pRow.status ~= "Активен" then
					pTab.List:SetItemColor( iRow, pTab.List[ "Имя" ],		127, 127, 127, 255 );
					pTab.List:SetItemColor( iRow, pTab.List[ "Фамилия" ],	127, 127, 127, 255 );
					pTab.List:SetItemColor( iRow, pTab.List[ "Отдел" ],		127, 127, 127, 255 );
					pTab.List:SetItemColor( iRow, pTab.List[ "Должность" ],	127, 127, 127, 255 );
					pTab.List:SetItemColor( iRow, pTab.List[ "Телефон" ],	127, 127, 127, 255 );
					pTab.List:SetItemColor( iRow, pTab.List[ "Статус" ],	200, 0, 0, 255 );
					
					pTab.List:SetItemText( iRow, pTab.List[ "Статус" ], 	pRow.status, false, false );
				end
			end
		end
	end
end

function CUIFaction:LoadDeptsTab()
	local pTab		= self.Tab.Depts;
	local bDepts 	= self:TestRight( eFactionRight.STAFF_LIST );
	
	if bDepts then
		pTab.DeptList	= pTab:CreateGridList{ 0, 0, ( pTab.Parent.Width * 0.5 ) - 15, pTab.Parent.Height - 80 }
		{
			{ "#", 0.15 };
			{ " ", 0.75 };
		};
		
		function pTab.DeptList.GetSelectedItemID()
			local iItem = pTab.DeptList:GetSelectedItem();
			
			if not iItem or iItem == -1 then
				return 0;
			end
			
			return (int)(pTab.DeptList:GetItemText( iItem, pTab.DeptList[ "#" ] ) );
		end
		
		pTab.DeptAdd	= pTab:CreateButton( "Добавить" )
		{
			X		= 10;
			Y		= pTab.Parent.Height - 70;
			Width	= 90;
			Height	= 30;
			Enabled	= true;
			
			Complete	= function( Data )
				pTab:SetItems( Data );
			end;
			
			Click		= function()
				local pInputDialog		= self:ShowDialog( CUIInputDialog( "Введите название отдела", 64 ) );
				
				function pInputDialog.OnAccept( _self, sValue )
					if sValue then
						self:AsyncQuery( pTab.DeptAdd.Complete, "Faction_AddDept", sValue, self.ID );
					end
				end
			end;
		};
		
		pTab.DeptEdit	= pTab:CreateButton( "Изменить" )
		{
			X		= 100;
			Y		= pTab.Parent.Height - 70;
			Width	= 80;
			Height	= 30;
			Enabled	= false;
			
			Complete	= function( Data )
				pTab:SetItems( Data );
			end;
			
			Click		= function()
				local iID = pTab.DeptList.GetSelectedItemID();
				
				if iID ~= 0 then
					local pInputDialog		= self:ShowDialog( CUIInputDialog( "Введите название отдела", 64 ) );
					
					function pInputDialog.OnAccept( _self, sValue )
						if sValue then
							self:AsyncQuery( pTab.DeptEdit.Complete, "Faction_EditDept", sValue, iID, self.ID );
						end
					end
				end
			end;
		};
		
		pTab.DeptRemove	= pTab:CreateButton( "Удалить" )
		{
			X		= 180;
			Y		= pTab.Parent.Height - 70;
			Width	= 90;
			Height	= 30;
			Enabled	= false;
			
			Complete	= function( Data )
				pTab:SetItems( Data );
			end;
			
			Click		= function()
				local iID = pTab.DeptList.GetSelectedItemID();
				
				if iID ~= 0 then
					self:AsyncQuery( pTab.DeptRemove.Complete, "Faction_RemoveDept", iID, self.ID );
				end
			end;
		};
		
		pTab.RankList	= pTab:CreateGridList{ pTab.Parent.Width * 0.5, 0, pTab.Parent.Width * 0.5, pTab.Parent.Height - 80 }
		{
			{ "#", 0.15 };
			{ " ", 0.75 };
		};
		
		function pTab.RankList.GetSelectedItemID()
			local iItem = pTab.RankList:GetSelectedItem();
			
			if not iItem or iItem == -1 then
				return 0;
			end
			
			local iID = (int)(pTab.RankList:GetItemText( iItem, pTab.RankList[ "#" ] ) );
			
			if iID == 0 then
				return 0;
			end
			
			return iID;
		end
		
		pTab.RankAdd	= pTab:CreateButton( "Добавить" )
		{
			X		= ( pTab.Parent.Width * 0.5 ) + 10;
			Y		= pTab.Parent.Height - 70;
			Width	= 90;
			Height	= 30;
			Enabled	= true;
			
			Complete	= function( Data )
				pTab.m_aDepts[ DEPT_ID ].Ranks = Data;
			
				pTab.DeptList.Click();
			end;
			
			Click		= function()
				local iDeptID = pTab.DeptList.GetSelectedItemID();
				
				if iDeptID ~= 0 then
					local pInputDialog		= self:ShowDialog( CUIInputDialog( "Введите название должности", 64 ) );
					
					function pInputDialog.OnAccept( _self, sValue )
						if sValue then
							self:AsyncQuery( pTab.DeptEdit.Complete, "Faction_AddRank", sValue, iDeptID, self.ID );
						end
					end
				end
			end;
		};
		
		pTab.RankEdit	= pTab:CreateButton( "Изменить" )
		{
			X		= ( pTab.Parent.Width * 0.5 ) + 100;
			Y		= pTab.Parent.Height - 70;
			Width	= 80;
			Height	= 30;
			Enabled	= false;
			
			Click		= function()
				local iDeptID = pTab.DeptList.GetSelectedItemID();
				
				if iDeptID ~= 0 then
					local iRankID = pTab.RankList.GetSelectedItemID();
					
					if iRankID ~= 0 then
						local pInputDialog		= self:ShowDialog( CUIInputDialog( "Введите название должности", 64 ) );
						
						function pInputDialog.OnAccept( _self, sValue )
							if sValue then
								self:AsyncQuery( pTab.DeptEdit.Complete, "Faction_EditRank", sValue, iRankID, iDeptID, self.ID );
							end
						end
					end
				end
			end;
		};
		
		pTab.RankRemove	= pTab:CreateButton( "Удалить" )
		{
			X		= ( pTab.Parent.Width * 0.5 ) + 180;
			Y		= pTab.Parent.Height - 70;
			Width	= 90;
			Height	= 30;
			Enabled	= false;
			
			Click		= function()
				local iDeptID = pTab.DeptList.GetSelectedItemID();
				
				if iDeptID ~= 0 then
					local iRankID = pTab.RankList.GetSelectedItemID();
					
					if iRankID ~= 0 then
						self:AsyncQuery( pTab.RankAdd.Complete, "Faction_RemoveRank", iRankID, iDeptID, self.ID );
					end
				end
			end;
		};
		
		local bCanEdit	= self:TestRight( eFactionRight.EDIT_DEPTS );
		
		function pTab.DeptList.Click()
			pTab.DeptEdit:SetEnabled	( false );
			pTab.DeptRemove:SetEnabled	( false );
			
			pTab.RankEdit:SetEnabled	( false );
			pTab.RankRemove:SetEnabled	( false );
			
			pTab.RankList:Clear();
			
			local iRow = pTab.DeptList:GetSelectedItem();
			
			if not iRow or iRow == -1 then
				return;
			end
			
			local iID = (int)(pTab.DeptList:GetItemText( iRow, pTab.DeptList[ "#" ] ));
			
			if pTab.m_aDepts[ iID ] then
				pTab.DeptAdd:SetEnabled		( bCanEdit );
				pTab.DeptEdit:SetEnabled	( bCanEdit );
				pTab.DeptRemove:SetEnabled	( bCanEdit );
				
				for i, Rank in ipairs( pTab.m_aDepts[ iID ].Ranks ) do
					local iRow = pTab.RankList:AddRow();
					
					if iRow then
						pTab.RankList:SetItemText( iRow, pTab.RankList[ "#" ], Rank.ID,		false, false );
						pTab.RankList:SetItemText( iRow, pTab.RankList[ " " ], Rank.Name,	false, false );
					end
				end
			end
		end
		
		function pTab.RankList.Click()
			pTab.RankEdit:SetEnabled	( false );
			pTab.RankRemove:SetEnabled	( false );
			
			local iRow = pTab.DeptList:GetSelectedItem();
			
			if not iRow or iRow == -1 then
				return;
			end
			
			local iDeptID = (int)(pTab.DeptList:GetItemText( iRow, pTab.DeptList[ "#" ] ));
			
			local iRow = pTab.RankList:GetSelectedItem();
			
			if not iRow or iRow == -1 then
				return;
			end
			
			local iRankID = (int)(pTab.RankList:GetItemText( iRow, pTab.RankList[ "#" ] ));
			
			if pTab.m_aDepts[ iDeptID ].Ranks[ iRankID ] then
				pTab.RankAdd:SetEnabled		( bCanEdit );
				pTab.RankEdit:SetEnabled	( bCanEdit );
				pTab.RankRemove:SetEnabled	( bCanEdit );
			end
		end
		
		pTab:SetEnabled( true );
	end
	
	function pTab.SetItems( this, Depts )
		if not bDepts then
			return false;
		end
		
		pTab.m_aDepts = Depts;
		
		pTab.DeptList:Clear();
		pTab.RankList:Clear();
		
		for i, Dept in ipairs( pTab.m_aDepts ) do
			local iRow = pTab.DeptList:AddRow();
			
			if iRow then
				pTab.DeptList:SetItemText( iRow, pTab.DeptList[ "#" ], Dept.ID,		false, false );
				pTab.DeptList:SetItemText( iRow, pTab.DeptList[ " " ], Dept.Name,	false, false );
				
				pTab.DeptList:SetItemData( iRow, pTab.DeptList[ "#" ], Dept.ID );
			end
		end
		
		return true;
	end
end

function CUIFaction:LoadBankAccTab()
	local pTab		= self.Tab.BankAcc;
end
