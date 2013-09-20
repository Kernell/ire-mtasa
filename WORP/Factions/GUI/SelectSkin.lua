-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local skin_dialog 	= CGUI();
local scrX, scrY	= guiGetScreenSize();

function skin_dialog:__init( old_skin )
	if self.Window then
		self:Close();
	end
	
	self.Window	= self:CreateWindow( "Выбор одежды" )
	{
		X		= ( scrX - 200 );
		Y		= ( scrY - 350 ) / 2;
		Width	= 200;
		Height	= 350;
		Sizable	= false;
	}
	
	self.list	= self.Window:CreateGridList{ 0, 25, 180, 285 } 
	{ 
		{ "#", .2 }; 
		{ " ", .7 }; 
	}

	self.btnSelect		= self.Window:CreateButton( "Выбрать" )
	{
		X		= 5;
		Y		= 315;
		Width	= 75;
		Height	= 25;
	}
	
	self.btnCancel		= self.Window:CreateButton( "Отмена" )
	{
		X		= 115;
		Y		= 315;
		Width	= 75;
		Height	= 25;
	}
	
	self.Window:SetVisible( false );

	function self.btnSelect.Click( button, state )
		if button == "left" and state == "up" then
			local item 			= self.list:GetSelectedItem();
			
			if not item or item == -1 then
				return;
			end
			
			local skin_id			= self.list:GetItemText( item, self.list[ '#' ] );
			
			if not skin_id then
				return;
			end
			
			self:Close();
			
			setElementModel( localPlayer, old_skin );
			
			SERVER.SelectFactionSkin( skin_id );
		end
	end
	
	self.list.DoubleClick = self.btnSelect.Click;
	
	function self.list.Click()
		local item 			= self.list:GetSelectedItem();
			
		if not item or item == -1 then
			return;
		end
		
		local skin_id			= self.list:GetItemText( item, self.list[ '#' ] );
		
		if not skin_id then
			return;
		end
		
		setElementModel( localPlayer, skin_id );
	end

	function self.btnCancel.Click( button, state )
		if button == "left" and state == "up" then
			setElementModel( localPlayer, old_skin );
			
			self:Close();
		end
	end
end

function skin_dialog:Fill( skins )
	self:Clear();
	
	for key, value in ipairs( skins ) do
		self:AddItem( value );
	end
end

function skin_dialog:AddItem( skin )
	if not skin then
		return;
	end

	local skin = CPed.GetSkin( skin );
	
	if not skin.IsValid() or skin.GetGender() ~= CPed.GetSkin( getElementModel( localPlayer ) ).GetGender() then
		return;
	end
	
	local gridRow 	= self:AddRow();
	
	if not gridRow then
		return;
	end
	
	self:SetItemText( gridRow, self[ "#" ], skin.GetID(),	false, false );
	self:SetItemText( gridRow, self[ " " ], skin.GetName(), false, false );
	
end

function skin_dialog:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();
	
	self:ShowCursor();
end

function skin_dialog:Close()
	if self.Window then
		self.Window:Delete();
		self.Window = nil;
	end
	
	self:HideCursor();
end 

function FactionSkinDialog( old_skin, skins )
	if skins and #skins > 0 then
		skin_dialog:__init( old_skin );
		skin_dialog.list:Fill( skins );
		skin_dialog:Open();
	end
end