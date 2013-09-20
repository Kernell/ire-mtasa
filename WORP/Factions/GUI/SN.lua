-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local SN = CGUI();

function SN:Init()
	if self.Window then
		self:Close();
	end
	
	self.Window = self:CreateWindow( "Управление объявлениями" )
	{
		X		= 'center';
		Y		= 'center';
		Width	= 450;
		Height	= 350;
		Sizable	= false;
	}
	
	self.List	= self.Window:CreateGridList{ 5, 20, 440, 290 }
	{
		{ "#", .1 };
		{ "Отправитель", .2 };
		{ "Текст", .65 };
	}
	
	self.btnEdit	= self.Window:CreateButton( "Редактировать" )
	{
		X		= 5;
		Y		= 315;
		Width	= 85;
		Height	= 25;
	}
	
	self.btnClose	= self.Window:CreateButton( "Закрыть" )
	{
		X		= 360;
		Y		= 315;
		Width	= 85;
		Height	= 25;
	}
	
	self.btnEdit.Click = function()
		local iItem = self.List:GetSelectedItem();
		
		if iItem and iItem ~= -1 then
			local sID = tonumber( self.List:GetItemText( iItem, self.List[ '#' ] ) );
		
			if sID then
				local pAdvert = self.List.m_aAdverts[ sID ];
				
				if pAdvert then
					local Window = self:CreateWindow( "" )
					{
						X		= 'center';
						Y		= 'center';
						Width	= 300;
						Height	= 250;
						Sizable = false;
					}
					
					setElementParent( Window.__instance, self.Window.__instance );
					
					Window:CreateLabel( "Отправитель: \t" .. pAdvert.m_sName )
					{
						X		= 10;
						Y		= 20 ;
						Width	= 290;
						Height	= 20;
					}
					
					local Memo	= Window:CreateMemo( pAdvert.m_sText )
					{
						X		= 5;
						Y		= 50;
						Width	= 290;
						Height	= 165;
					}
					
					local btnSend	= Window:CreateButton( "Отправить" )
					{
						X		= 5;
						Y		= 220;
						Width	= 75;
						Height	= 25;
					}
					
					local btnCancel	= Window:CreateButton( "Отмена" )
					{
						X		= 220;
						Y		= 220;
						Width	= 75;
						Height	= 25;
					}
					
					btnSend.Click	= function()
						if Memo:GetText():len() > 86 then
							MessageBox:Show( "Текст рекламы слишком длинный", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
							
							return;
						end
						
						SERVER.AcceptAdvert( sID, Memo:GetText(), pAdvert.m_iCharID );
						
						Window:Delete();
					end
					
					btnCancel.Click = function()
						Window:Delete();
					end
					
					Window:SetVisible( true );
				end
			end
		end
	end
	
	self.List.DoubleClick = self.btnEdit.Click;
	
	self.btnClose.Click = function()
		self:Close();
	end
end

function SN:Fill( aAdverts )
	self:Clear();
	self.m_aAdverts = aAdverts;
	
	for i, row in ipairs( aAdverts ) do
		self:AddItem( i, row );
	end
end

function SN:AddItem( i, row )
	local gridRow		= self:AddRow();
	
	self:SetItemText	( gridRow, self[ '#' ],				i,		false, false );
	self:SetItemText	( gridRow, self[ 'Отправитель' ],	row.m_sName,		false, false );
	self:SetItemText	( gridRow, self[ 'Текст' ],			row.m_sText,		false, false );
end

function SN:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function SN:Close()
	self.Window:Delete();
	self.Window = nil;
	
	self:HideCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function FMenuSN( aAdverts, bForce, bUptate )
	if SN.Window then
		if bUptate then
			SN.List:Fill( aAdverts );
			
			return;
		end
		
		if not bForce then
			SN:Close();
			
			return;
		end
	elseif bUptate then
		return;
	end
	
	
	SN:Init();
	SN.List:Fill( aAdverts );
	SN:Open();
end