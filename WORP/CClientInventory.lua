-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CClientInventory ( CUIInventory )
{
	Tooltip	=
	{
		Width		= 250;
		Height		= 10;
		Border		= 1;
		BorderColor	= tocolor( 0, 0, 0 );
		BgColor		= tocolor( 255, 255, 255, 200 );
		BgImage		= "Resources/Textures/UI-Inventory/Background-2.jpg";
		
		Data		=
		{
			-- Title
			{
				X		= 10;
				Y		= 7;
				Width	= 200;
				Height	= 20;
				Color	= tocolor( 255, 127, 0, 255 );
				Font	= DXFont( "Segoe UI", 10, false );
				Field	= "m_sName";
				Type	= "text";
			};
			
			-- Cost caption
			{
				X		= 10;
				Y		= 25;
				Width	= 150;
				Height	= 20;
				Color	= tocolor( 255, 255, 255, 127 );
				Font	= DXFont( "Segoe UI", 10, false );
				Field	= NULL;
				Text	= "$";
				Type	= "text";
			};
			
			-- Cost value
			{
				X		= 20;
				Y		= 25;
				Width	= 150;
				Height	= 20;
				Color	= tocolor( 255, 255, 255, 127 );
				Font	= DXFont( "Segoe UI", 10, false );
				Field	= "m_iCost";
				Type	= "text";
			};
			
			-- Condition caption
			{
				X		= 10;
				Y		= 50;
				Width	= 150;
				Height	= 20;
				Color	= tocolor( 255, 255, 255, 127 );
				Font	= DXFont( "Segoe UI", 10, false );
				Field	= NULL;
				Text	= "Состояние";
				Type	= "text";
			};
			
			-- Condition Value
			{
				X			= 10;
				Y			= 70;
				Width		= 230;
				Height		= 5;
				Color		= tocolor( 0, 0, 128, 127 );
				ColorStart	= tocolor( 100, 0, 0, 255 );
				ColorEnd	= tocolor( 0, 200, 0, 255 );
				Field		= "m_fCondition";
				Type		= "progressbar";
				Percent		= 100;
			};
			
			-- Description
			{
				X		= 10;
				Y		= 85;
				Width	= 230;
				Height	= "Auto";
				Color	= tocolor( 255, 255, 255, 255 );
				Font	= DXFont( "Segoe UI", 8, false );
				Field	= "m_sDescription";
				Type	= "text";
			};
			
			-- Clip Ammo label
			{
				X		= 10;
				Y		= 110;
				Width	= 80;
				Height	= 20;
				Color	= tocolor( 127, 127, 127, 255 );
				Font	= DXFont( "Segoe UI", 8, false );
				Field	= NULL;
				Type	= "text";
				Text	= "Патронов: ";
				Slot	= ITEM_SLOT_CLIP_AMMO;
			};
			
			-- Clip Ammo value
			{
				X		= 90;
				Y		= 110;
				Width	= 50;
				Height	= 20;
				Color	= tocolor( 127, 127, 127, 255 );
				Font	= DXFont( "Segoe UI", 8, false );
				Field	= "m_iValue";
				Type	= "text";
				Slot	= ITEM_SLOT_CLIP_AMMO;
			};
			
			-- Bank card value
			{
				X		= 10;
				Y		= 110;
				Width	= 150;
				Height	= 18;
				Color	= tocolor( 127, 127, 127, 255 );
				Font	= DXFont( "Segoe UI", 8, false );
				Field	= "m_sID";
				Type	= "text";
				-- Item	= "bank_card";
			};
			{
				X		= 90;
				Y		= 110;
				Width	= 150;
				Height	= 18;
				Color	= tocolor( 127, 127, 127, 255 );
				Font	= DXFont( "Segoe UI", 8, false );
				Field	= "m_sExpiryDate";
				Type	= "text";
				Align	= "right";
				-- Item	= "bank_card";
			};
		};
	};
};

function CClientInventory:CClientInventory()
	self.Tooltip		= table.clone( CClientInventory.Tooltip );
	self.m_pContextMenu	= CContextMenu();
end

function CClientInventory:_CClientInventory()
	self:_CUIInventory();
	
	if self.m_pContextMenu then
		delete ( self.m_pContextMenu );
		self.m_pContextMenu = NULL;
	end
end

function CClientInventory:OnClose()
	self:Hide();
	self.m_pContextMenu:Hide();
end

function CClientInventory:OnClick( pItem, sMouseButton )
	if sMouseButton == "left" then
		
	elseif sMouseButton == "right" then
		self:ContextMenu( pItem );
	end
end

function CClientInventory:OnDoubleClick( pItem, sMouseButton )
	SERVER.UseItem( pItem );
end

function CClientInventory:OnDrop( pItem, fWorldX, fWorldY, fWorldZ, pWorldElement )
	if pWorldElement then
		if pWorldElement:GetPosition():Distance( CLIENT:GetPosition() ) < 3.0 then
			SERVER.TransferItem( pItem, pWorldElement );
			
			self:OnClose();
		else
			Hint( "Невозможно передать предмет", "Игрок слишком далеко", "error" );
		end
	elseif not self.m_bDisableDrop then
		SERVER.DropItem( pItem );
	end
end

function CClientInventory:OnHover( pItem, fCurX, fCurY )
	if self.m_pContextMenu:IsVisible() then
		return;
	end
	
	fCurX, fCurY = fCurX + 10, fCurY + 10;
	
	dxDrawRectangle( fCurX - self.Tooltip.Border, fCurY, self.Tooltip.Border, self.Tooltip.Height, self.Tooltip.BorderColor, true );
	dxDrawRectangle( fCurX + self.Tooltip.Width,  fCurY, self.Tooltip.Border, self.Tooltip.Height, self.Tooltip.BorderColor, true );

	dxDrawRectangle( fCurX - self.Tooltip.Border, fCurY - self.Tooltip.Border, self.Tooltip.Width + self.Tooltip.Border * 2, self.Tooltip.Border, self.Tooltip.BorderColor, true );
	dxDrawRectangle( fCurX - self.Tooltip.Border, fCurY + self.Tooltip.Height, self.Tooltip.Width + self.Tooltip.Border * 2, self.Tooltip.Border, self.Tooltip.BorderColor, true );
	
	dxDrawImageSection( fCurX, fCurY, self.Tooltip.Width, self.Tooltip.Height, fCurX, fCurY, self.Tooltip.Width, self.Tooltip.Height, self.Tooltip.BgImage, 0, 0, 0, self.Tooltip.BgColor, true );
	
	local gl_Height = CClientInventory.Tooltip.Height;
	
	for i, f in ipairs( self.Tooltip.Data ) do
		if ( f.Slot == NULL or pItem.m_iSlot == f.Slot ) and ( f.Item == NULL or f.Item == pItem.m_sClassName ) then
			local fX, fY	= fCurX + f.X, fCurY + f.Y;
			local Height	= f.Height;
			
			if f.Type == "text" then
				local sText			= f.Field and ( pItem[ f.Field ] or pItem.m_Data[ f.Field ] ) or f.Text;
				
				if Height == "Auto" then
					local fWidth	= dxGetTextWidth( sText, 1.0, f.Font );
					local fHeight	= dxGetFontHeight( 1.0, f.Font );
					
					Height = ( fHeight * fWidth ) / f.Width;
				end
				
				if sText then
					dxDrawText( sText, fX, fY, fX + f.Width, fY + Height, f.Color, 1.0, f.Font, f.Align or "left", "center", false, true, true, false, true );
				end
			elseif f.Type == "progressbar" then
				dxDrawRectangle( fX, fY, f.Width, f.Height, f.Color, true );
				dxDrawRectangle( fX, fY, f.Width * ( math.floor( pItem[ f.Field ] ) / f.Percent ), f.Height, Lerp( f.ColorStart, f.ColorEnd, math.floor( pItem[ f.Field ] ) / f.Percent ), true );
			end
			
			gl_Height = f.Y + Height;
		end
	end
	
	self.Tooltip.Height = gl_Height + CClientInventory.Tooltip.Height;
end

function CClientInventory:ContextMenu( pItem )
	local Items	= {};

	if pItem.m_iType == ITEM_TYPE_FOOD or pItem.m_iType == ITEM_TYPE_DRINK then
		table.insert( Items,
			{
				"Использовать",
				function( this )
					SERVER.UseItem( pItem );
				end
			}
		);
	end
	
	if pItem.m_pClip then
		table.insert( Items,
			{
				"Разрядить",
				function( this )
					SERVER.ReleaseClip( pItem );
				end
			}
		);
	end
	
	if pItem.m_bCanDrop ~= false then
		table.insert( Items,
			{
				"Передать",
				function( this )
					self.m_iDragDropX, self.m_iDragDropY = getCursorPosition();
					
					self.m_vDragDrop	= self.m_vHover;
					self.m_bDisableDrop = true;
					
					self:Hide();
					self.m_pFakeWindow:ShowCursor();
					
					Hint( "Info", "Кликните левой кнопкой мыши по игроку или автомобилю\n\nДля отмены кликните в пустое место", "info" );
				end
			}
		);
		
		table.insert( Items,
			{
				"Выбросить",
				function( this )
					SERVER.DropItem( pItem, true );
				end
			}
		);
	end

	self.m_pContextMenu:SetItems( Items );
	self.m_pContextMenu:Show();
end

function CClientInventory:SetItems( Items )
	self.m_Items = Items;
	self:CalculateSlots();
end



local iImageW, iImageH		= 240, 90;

local pItemColShape			= NULL;
local itemRoot				= getElementByID( 'itemRoot' );

assert( itemRoot and itemRoot:GetType() == 'itemRoot', "getElementByID( 'itemRoot' )->GetType() == 'itemRoot'" );

local function Draw()
	if pItemColShape and isElement( pItemColShape ) then
		local vecClient = CLIENT:GetPosition();
		local vecItem	= pItemColShape:GetPosition();
		
		if not vecClient:IsLineOfSightClear( vecItem, true, true, true, true, true, false, false, CLIENT ) then
			return;
		end
		
		local ID		= pItemColShape:GetData( "object_id" );
		local sItem		= pItemColShape:GetData( "item" );
		local sItemName = pItemColShape:GetData( "item_name" );
		
		if ID and sItem and sItemName then
			if pItemColShape.m_sPath == NULL then
				pItemColShape.m_sPath = "Resources/Images/Items/" + sItem + ".png";
				
				if not fileExists( pItemColShape.m_sPath ) then
					pItemColShape.m_sPath = false;
				end
			end
			
			if pItemColShape.m_sPath then
				dxDrawImage( ( g_iScreenX - iImageW ) * .5, ( g_iScreenY * .5 ) + 20, iImageW, iImageH, pItemColShape.m_sPath );
			end
			
			dxDrawText( "#000000Нажмите 'E' чтобы подобрать " + sItemName, 0, 0, g_iScreenX, g_iScreenY, -1, 1.0, DXFont( 'consola', 12, true ), 'center', 'center', false, false, false, true, false );
			dxDrawText( "#000000Нажмите 'E' чтобы подобрать " + sItemName, 2, 2, g_iScreenX, g_iScreenY, -1, 1.0, DXFont( 'consola', 12, true ), 'center', 'center', false, false, false, true, false );
			dxDrawText( "#FFFFFFНажмите #FFFF00'E' #FFFFFFчтобы подобрать " + sItemName, 1, 1, g_iScreenX, g_iScreenY, -1, 1.0, DXFont( 'consola', 12, true ), 'center', 'center', false, false, false, true, false );
			
			if getKeyState( "e" ) then
				SERVER.PickUp( ID );
				
				pItemColShape = NULL;
			end
		end
	end
end

function itemRoot:OnHit( bMatchingDimension )
	if bMatchingDimension and self == CLIENT and not CLIENT:IsInVehicle() then
		pItemColShape = source;
	end
end

function itemRoot:OnLeave( bMatchingDimension )
	if bMatchingDimension and self == CLIENT and pItemColShape == source then
		pItemColShape = NULL;
	end
end

addEventHandler( "onClientColShapeHit", itemRoot, itemRoot.OnHit );
addEventHandler( "onClientColShapeLeave", itemRoot, itemRoot.OnLeave );
addEventHandler( "onClientRender", root, Draw );
