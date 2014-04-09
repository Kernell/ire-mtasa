-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

enum "eItemSlot"
{
	"ITEM_SLOT_NONE";
	"ITEM_SLOT_WEAPON1";
	"ITEM_SLOT_WEAPON2";
	"ITEM_SLOT_WEAPON3";
	"ITEM_SLOT_WEAPON4";
	"ITEM_SLOT_CLIP_AMMO";
	"ITEM_SLOT_SKINS";
};

enum "eItemType"
{
	"ITEM_TYPE_NONE";
	"ITEM_TYPE_WEAPON";
	"ITEM_TYPE_AMMO";
	"ITEM_TYPE_CLIP_AMMO";
	"ITEM_TYPE_SKINS";
	"ITEM_TYPE_FOOD";
	"ITEM_TYPE_DRINK";
};

local INV_BORDER		= 2
local INV_PADDING		= 15
local SLOT_WIDTH		= 48
local SLOT_HEIGHT		= 48
local SLOT_BORDER		= 2

local SlotSize			=
{
	[ 0 ]					= { SLOT_WIDTH, SLOT_HEIGHT };
	[ ITEM_SLOT_NONE ]		= { SLOT_WIDTH, SLOT_HEIGHT };
	[ ITEM_SLOT_WEAPON1 ]	= { SLOT_WIDTH * 4.0, SLOT_HEIGHT * 1.5 };
	[ ITEM_SLOT_WEAPON2 ]	= { SLOT_WIDTH * 2.0, SLOT_HEIGHT * 1.5 };
	[ ITEM_SLOT_WEAPON3 ]	= { SLOT_WIDTH * 2.0, SLOT_HEIGHT * 1.5 };
	[ ITEM_SLOT_WEAPON4 ]	= { SLOT_WIDTH, SLOT_HEIGHT };
	[ ITEM_SLOT_CLIP_AMMO ]	= { SLOT_WIDTH, SLOT_HEIGHT };
	[ ITEM_SLOT_SKINS ]		= { SLOT_WIDTH, SLOT_HEIGHT };
};

local SlotOrder		=
{
	ITEM_SLOT_WEAPON1;
	ITEM_SLOT_WEAPON2;
	ITEM_SLOT_WEAPON3;
	0;
	ITEM_SLOT_CLIP_AMMO;
	ITEM_SLOT_WEAPON4;
	0;
	ITEM_SLOT_NONE;
--	ITEM_SLOT_SKINS;
};

local SlotLimits =
{
	[ ITEM_SLOT_NONE ]		= 30;
	
	[ ITEM_SLOT_WEAPON1 ]	= 1;
	[ ITEM_SLOT_WEAPON2 ]	= 1;
	[ ITEM_SLOT_WEAPON3 ]	= 1;
	[ ITEM_SLOT_WEAPON4 ]	= 3;
	
	[ ITEM_SLOT_CLIP_AMMO ]	= 6;
	
	[ ITEM_SLOT_SKINS ]		= 0;
};

class: CUIInventory
{
	m_bHidden	= true;
};

function CUIInventory:CUIInventory( iCols )
	self.m_fScreenX, self.m_fScreenY = guiGetScreenSize();
	
	self.m_iCols		= tonumber( iCols ) or 10;
	
	self.m_fWidth		= ( self.m_iCols * ( SLOT_WIDTH + SLOT_BORDER ) ) + INV_PADDING * 2;
	self.m_fHeight		= INV_PADDING;
	
	self.m_Items		=
	{
		[ ITEM_SLOT_NONE ]		= {};
		
		[ ITEM_SLOT_WEAPON1 ]	= NULL;
		[ ITEM_SLOT_WEAPON2 ]	= NULL;
		[ ITEM_SLOT_WEAPON3 ]	= NULL;
		[ ITEM_SLOT_WEAPON4 ]	= {};
		
		[ ITEM_SLOT_CLIP_AMMO ]	= {};
		
		[ ITEM_SLOT_SKINS ]		= NULL;
	};
	
	self.m_fWidth, self.m_fHeight = self:CalculateSlots();
	
	self.m_iBgColor			= tocolor( 255, 255, 255, 200 );
	self.m_iBorderColor		= tocolor( 0, 0, 0, 200 );
	
	self.m_iSlotBgColor			= tocolor( 100, 70, 45, 127 );
	self.m_iSlotBorderColor		= tocolor( 0, 0, 0, 200 );
	self.m_iSlotHoverBgColor	= tocolor( 105, 100, 60, 127 );
	self.m_iSlotActiveColor		= tocolor( 255, 200, 0, 127 );
	
	self.m_Buttons		=
	{
		Close			=
		{
			Caption 	= "Закрыть";
			X			= self.m_fWidth - INV_PADDING - 90;
			Y			= self.m_fHeight + INV_PADDING;
			Width		= 90;
			Height		= 35;
			Color		= tocolor( 0, 0, 0 );
			BgColor		= tocolor( 227, 162, 26 );
			HoverColor	= tocolor( 0, 0, 0 );
			HoverBgColor= tocolor( 255, 174, 0 );
			Border		= 1;
			BorderColor	= tocolor( 0, 0, 0 );
			Click		= function( this )
				if self.OnClose then
					self:OnClose();
				end
			end;
		};
	};
	
	self.m_iLastMouseClick	= {};
	
	self.m_fHeight		= self.m_fHeight + self.m_Buttons.Close.Height + INV_PADDING * 2;
	self.m_fX			= ( ( self.m_fScreenX - self.m_fWidth ) * .5 );
	self.m_fY			= ( ( self.m_fScreenY - self.m_fHeight ) * .5 );
	
	self.m_pFakeWindow	= CGUI:CreateWindow ""
	{
		X		= self.m_fX;
		Y		= self.m_fY;
		Width	= self.m_fWidth;
		Height	= self.m_fHeight;
		Sizable	= false;
		Movable	= false;
	};
	
	self.m_pFakeWindow:SetAlpha( 0 );
	
	function self._OnRender()
		if not self.m_bHidden then
			self:Draw();
		end
	end;
	
	function self._OnClick( sMouseButton, sState, iCurX, iCurY, fWorldX, fWorldY, fWorldZ, pWorldElement )
		if self.m_bHidden then
			return;
		end
		
		if sState == "down" then
			if self.m_vHover then
				self.m_vHoverPrev = self.m_vHover;
				
				if sMouseButton == "left" and self.m_vHover.m_pItem then
					self.m_vDragDrop	= self.m_vHover;
					self.m_bDisableDrop	= false;
					self.m_iDragDropX	= iCurX;
					self.m_iDragDropY	= iCurY;
				end
			end
		elseif sState == "up" then
			if self.m_vHoverPrev and self.m_vHoverPrev == self.m_vHover then
				if type( self.m_vHover ) == 'table' then
					if self.m_vHover.Click then
						if sMouseButton == "left" then
							self.m_vHover:Click( sMouseButton, sState );
						end
					elseif self.OnClick and self.m_vHover.m_pItem then
						local iTick = getTickCount();
						
						if iTick - ( self.m_iLastMouseClick[ sMouseButton ] or 0 ) < 400 then
							self:OnDoubleClick( self.m_vHover.m_pItem, sMouseButton );
							
							self.m_iLastMouseClick[ sMouseButton ] = 0;
							
						else
							self:OnClick( self.m_vHover.m_pItem, sMouseButton );
							
							self.m_iLastMouseClick[ sMouseButton ] = iTick;
						end						
					end
				end
			end
			
			if self.m_vDragDrop and sMouseButton == "left" then
				if not self:IsInside( iCurX, iCurY, self.m_fX, self.m_fY, self.m_fWidth, self.m_fHeight ) then
					if self.OnDrop then
						self:OnDrop( self.m_vDragDrop.m_pItem, fWorldX, fWorldY, fWorldZ, pWorldElement );
					end
				end
			end
			
			self.m_vDragDrop	= NULL;
			self.m_vHoverPrev	= NULL;
		end
	end;
	
	addEventHandler( "onClientRender", root, self._OnRender );
	addEventHandler( "onClientClick", root, self._OnClick );
end

function CUIInventory:_CUIInventory()
	self.m_pFakeWindow:HideCursor();
	self.m_pFakeWindow:Delete();
	self.m_pFakeWindow = NULL;
	
	removeEventHandler( "onClientRender", root, self._OnRender );
	removeEventHandler( "onClientClick", root, self._OnClick );
end

function CUIInventory:Show()
	self.m_pFakeWindow:ShowCursor();
	self.m_pFakeWindow:SetVisible( true );
	self.m_pFakeWindow:BringToFront();

	self.m_bHidden = false;
end

function CUIInventory:Hide()
	self.m_pFakeWindow:HideCursor();
	self.m_pFakeWindow:SetVisible( false );
	
	self.m_bHidden = true;
end

function CUIInventory:IsVisible()
	return self.m_bHidden == false;
end

function CUIInventory:CalculateSlots()
	self.m_Slots = {};
	
	local fX	= INV_PADDING;
	local fY	= INV_PADDING;
	
	local i		= 1;
	
	for z, iSlot in ipairs( SlotOrder ) do
		local Slot		= SlotSize[ iSlot ];
		local iSlots	= SlotLimits[ iSlot ];
		
		if iSlot ~= 0 then
			if iSlots > 1 then
				if not self.m_Slots[ iSlot ] then
					self.m_Slots[ iSlot ] = {};
				end
				
				for x = 1, iSlots do
					self.m_Slots[ iSlot ][ x ] = self:CalculateSlot( fX, fY, iSlot, self.m_Items[ iSlot ] and self.m_Items[ iSlot ][ x ] or NULL );
					
					fX	= fX + Slot[ 1 ] + SLOT_BORDER;
		
					if iSlot == ITEM_SLOT_NONE then
						if i % self.m_iCols == 0 then
							fX	= INV_PADDING;
							fY	= fY + Slot[ 2 ] + SLOT_BORDER;
						end
						
						i = i + 1;
					end
				end
			elseif iSlots == 1 then
				self.m_Slots[ iSlot ] = self:CalculateSlot( fX, fY, iSlot, self.m_Items[ iSlot ] );
			end
			
			fX	= fX + Slot[ 1 ] + SLOT_BORDER + ( iSlots == 1 and INV_PADDING or 0 );
		else
			fX	= INV_PADDING;
			fY	= fY + SlotSize[ SlotOrder[ z - 1 ] or iSlot ][ 2 ] + SLOT_BORDER + INV_PADDING;
		end
	end
	
	return self.m_fWidth, fY + INV_PADDING;
end

function CUIInventory:CalculateSlot( fX, fY, iSlot, pItem )
	local SlotSize		= SlotSize[ iSlot ];
	
	local Slot	=
	{
		Border	=
		{
			{ fX - SLOT_BORDER,		fY, SLOT_BORDER, 	SlotSize[ 2 ] };
			{ fX + SlotSize[ 1 ],	fY, SLOT_BORDER, 	SlotSize[ 2 ] };
			{ fX - SLOT_BORDER,		fY - SLOT_BORDER, 	SlotSize[ 1 ] + SLOT_BORDER * 2, SLOT_BORDER };
			{ fX - SLOT_BORDER,		fY + SlotSize[ 2 ],	SlotSize[ 1 ] + SLOT_BORDER * 2, SLOT_BORDER };
		};
		fX, fY, SlotSize[ 1 ], SlotSize[ 2 ];
	};
	
	if pItem then
		Slot.m_pItem = pItem;
		
		pItem.m_pTexture = self:CreateTexture( pItem.m_sClassName );
		
		if iSlot == ITEM_SLOT_WEAPON1 then
			Slot.m_pItem[ 1 ] = Slot[ 1 ] - ( ( 256 - SlotSize[ 1 ] ) / 2 );
			Slot.m_pItem[ 2 ] = Slot[ 2 ] - ( ( 128 - SlotSize[ 2 ] ) / 2 );
			Slot.m_pItem[ 3 ] = 256;
			Slot.m_pItem[ 4 ] = 128;
		elseif iSlot == ITEM_SLOT_WEAPON2 then
			Slot.m_pItem[ 1 ] = Slot[ 1 ] - ( ( 128 - SlotSize[ 1 ] ) / 2 );
			Slot.m_pItem[ 2 ] = Slot[ 2 ] - ( ( 128 - SlotSize[ 2 ] ) / 2 );
			Slot.m_pItem[ 3 ] = 128;
			Slot.m_pItem[ 4 ] = 128;
		elseif iSlot == ITEM_SLOT_WEAPON3 then
			Slot.m_pItem[ 1 ] = Slot[ 1 ] - ( ( 128 - SlotSize[ 1 ] ) / 2 );
			Slot.m_pItem[ 2 ] = Slot[ 2 ] - ( ( 128 - SlotSize[ 2 ] ) / 2 );
			Slot.m_pItem[ 3 ] = 128;
			Slot.m_pItem[ 4 ] = 128;
		else
			Slot.m_pItem[ 1 ] = Slot[ 1 ];
			Slot.m_pItem[ 2 ] = Slot[ 2 ];
			Slot.m_pItem[ 3 ] = Slot[ 3 ];
			Slot.m_pItem[ 4 ] = Slot[ 4 ];
		end
	end
	
	return Slot;
end

function CUIInventory:CreateTexture( sClassName )
	local sPath		= "Resources/Images/Items/" + sClassName + ".png";
	local pTexture	= fileExists( sPath ) and dxCreateTexture( sPath, "argb", false, "wrap" );
	
	if not pTexture then
		pTexture	= dxCreateTexture( "Resources/Images/BrokenImage.png", "argb", false, "wrap" );
		
		ASSERT( pTexture, [[I3DDevice->CreateSprite( "Resources/Images/BrokenImage.png" );]] );
	end
	
	return pTexture;
end

function CUIInventory:IsInside( fCurX, fCurY, fX, fY, fWidth, fHeight )
	return fCurX > fX and fCurX < fX + fWidth and fCurY > fY and fCurY < fY + fHeight;
end

function CUIInventory:DrawSlot( pSlot, iCurX, iCurY )
	local iSlotX	= self.m_fX + pSlot[ 1 ];
	local iSlotY	= self.m_fY + pSlot[ 2 ];
	local iColor	= self.m_iSlotBgColor;
	
	if self:IsInside( iCurX, iCurY, iSlotX, iSlotY, pSlot[ 3 ], pSlot[ 4 ] ) then
		iColor	= self.m_iSlotHoverBgColor;
		
		self.m_vHover = pSlot;
		
		if self.m_vHoverPrev == pSlot then
			iColor	= self.m_iSlotActiveColor;
		else
			self.m_pHoverItem = pSlot.m_pItem;
		end
	end
	
	for _, Border in ipairs( pSlot.Border ) do
		dxDrawRectangle( self.m_fX + Border[ 1 ], self.m_fY + Border[ 2 ], Border[ 3 ], Border[ 4 ], self.m_iSlotBorderColor, true );
	end
	
	dxDrawRectangle( iSlotX, iSlotY, pSlot[ 3 ], pSlot[ 4 ], iColor, true );
	
	if pSlot.m_pItem then
		local iItemX	= self.m_fX + pSlot.m_pItem[ 1 ];
		local iItemY	= self.m_fY + pSlot.m_pItem[ 2 ];
		
		if self.m_vDragDrop ~= pSlot then
			if pSlot.m_pItem.m_pTexture then
				dxDrawImage( iItemX, iItemY, pSlot.m_pItem[ 3 ], pSlot.m_pItem[ 4 ], pSlot.m_pItem.m_pTexture, 0, 0, 0, -1, true );
			end
		else
			local fX = ( iCurX - self.m_iDragDropX ) + self.m_fX + pSlot.m_pItem[ 1 ];
			local fY = ( iCurY - self.m_iDragDropY ) + self.m_fY + pSlot.m_pItem[ 2 ];
			
			dxDrawImage( fX, fY, pSlot.m_pItem[ 3 ], pSlot.m_pItem[ 4 ], pSlot.m_pItem.m_pTexture, 0, 0, 0, -1, true );
		end
	end
end

function CUIInventory:Draw()
	local fCurX, fCurY = getCursorPosition();
	
	fCurX, fCurY = ( fCurX or 0 ) * self.m_fScreenX, ( fCurY or 0 ) * self.m_fScreenY;
	
	self.m_vHover	= NULL;
	
	dxDrawRectangle( self.m_fX - INV_BORDER, self.m_fY, INV_BORDER, self.m_fHeight, self.m_iBorderColor, true );
	dxDrawRectangle( self.m_fX + self.m_fWidth, self.m_fY, INV_BORDER, self.m_fHeight, self.m_iBorderColor, true );
	
	dxDrawRectangle( self.m_fX - INV_BORDER, self.m_fY - INV_BORDER, self.m_fWidth + INV_BORDER * 2, INV_BORDER, self.m_iBorderColor, true );
	dxDrawRectangle( self.m_fX - INV_BORDER, self.m_fY + self.m_fHeight, self.m_fWidth + INV_BORDER * 2, INV_BORDER, self.m_iBorderColor, true );
	
	dxDrawImage( self.m_fX, self.m_fY, self.m_fWidth, self.m_fHeight, "Resources/Textures/UI-Inventory/Background.jpg", 0, 0, 0, self.m_iBgColor, true );
	
	-- Draw the slots
	
	self.m_pHoverItem = NULL;
	
	for i, iSlot in ipairs( SlotOrder ) do
		local pSlot		= self.m_Slots[ iSlot ];
		local iSlots	= SlotLimits[ iSlot ];
		
		if pSlot then
			if iSlots == 1 then
				self:DrawSlot( pSlot, fCurX, fCurY );
			elseif iSlots > 1 then
				for x = 1, iSlots do
					self:DrawSlot( pSlot[ x ], fCurX, fCurY );
				end
			end
		end
	end
	
	for id, Button in pairs( self.m_Buttons ) do
		local fX = self.m_fX + Button.X;
		local fY = self.m_fY + Button.Y;
		
		local Color		= Button.Color;
		local BgColor	= Button.BgColor;
		
		if self:IsInside( fCurX, fCurY, fX, fY, Button.Width, Button.Height ) then
			Color	= Button.HoverColor;
			BgColor	= Button.HoverBgColor;
			
			self.m_vHover = Button;
			
			if self.m_vHoverPrev == Button then		
				if Button.Border and Button.Border > 0 then
					dxDrawRectangle( fX - Button.Border, fY, Button.Border, Button.Height, Button.BorderColor, true );
					dxDrawRectangle( fX + Button.Width,  fY, Button.Border, Button.Height, Button.BorderColor, true );
					
					dxDrawRectangle( fX - Button.Border, fY - Button.Border, Button.Width + Button.Border * 2, Button.Border, Button.BorderColor, true );
					dxDrawRectangle( fX - Button.Border, fY + Button.Height, Button.Width + Button.Border * 2, Button.Border, Button.BorderColor, true );
				end
			end
		end
		
		dxDrawRectangle( fX, fY, Button.Width, Button.Height, BgColor, true );
		dxDrawText( Button.Caption, fX, fY, fX + Button.Width, fY + Button.Height, Color, 1.0, DXFont( "Segoe UI" ), "center", "center", false, false, true );
	end
	
	if self.m_pHoverItem and self.OnHover then
		self:OnHover( self.m_pHoverItem, fCurX, fCurY );
	end
end
