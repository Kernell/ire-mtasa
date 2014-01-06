-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local pCurrentContextMenu = NULL;

class: CContextMenu
{
	m_Items			= NULL;
	m_bPostGUI		= true;
	m_iColor		= tocolor( 255, 255, 255 );
	m_iHoverColor	= tocolor( 0, 200, 255 );
	m_iActiveColor	= tocolor( 0, 150, 200 );
	m_iBgHoverColor	= tocolor( 128, 128, 128, 128 );
	m_iBorderColor	= tocolor( 0, 0, 0, 200 );
	m_iBgColor		= tocolor( 64, 64, 64, 200 );
};

function CContextMenu:CContextMenu( Items )
	self.m_Items	= Items;
end

function CContextMenu:_CContextMenu()
	if pCurrentContextMenu == self then
		self:Hide();
	end
	
	self.m_Items = NULL;
end

function CContextMenu:SetItems( Items )
	self.m_Items = Items;
end

function CContextMenu:IsVisible()
	return pCurrentContextMenu == self;
end

function CContextMenu:Show()
	self:Hide();
	
	self.m_fX, self.m_fY = getCursorPosition();
	self.m_fX, self.m_fY = self.m_fX * g_iScreenX, self.m_fY * g_iScreenY;
	
	self.m_fHeight	= 0;
	self.m_fWidth	= 0;
	
	for i, pRow in ipairs( self.m_Items ) do
		self.m_fHeight	= self.m_fHeight + 22;
		
		local l = dxGetTextWidth( pRow[ 1 ], 1.0, "default" ) + 20;
		
		if l > self.m_fWidth then
			self.m_fWidth = l;
		end
	end
	
	self.m_fHeight	= self.m_fHeight + 5;
	
	self.CEGUI = guiCreateButton( self.m_fX, self.m_fY, self.m_fWidth, self.m_fHeight, "", false );
	
	guiSetAlpha( self.CEGUI, 0 );
	
	pCurrentContextMenu = self;
end

function CContextMenu:Hide()
	if pCurrentContextMenu == self then
		pCurrentContextMenu = NULL;
	end
	
	if self.CEGUI then
		destroyElement( self.CEGUI );
		self.CEGUI = NULL;
	end
end

function CContextMenu:Draw()
	local fCurX, fCurY = getCursorPosition();
	
	fCurX, fCurY	= ( fCurX or 0 ) * g_iScreenX, ( fCurY or 0 ) * g_iScreenY;
	
	local bClicked	= getKeyState( 'mouse1' ) or getKeyState( 'mouse2' );
	local iHover	= 0;
	
	dxDrawRectangle( self.m_fX - 1, self.m_fY, 1, self.m_fHeight, self.m_iBorderColor, self.m_bPostGUI );
	dxDrawRectangle( self.m_fX + self.m_fWidth, self.m_fY, 1, self.m_fHeight, self.m_iBorderColor, self.m_bPostGUI );
	
	dxDrawRectangle( self.m_fX - 1, self.m_fY - 1, self.m_fWidth + 2, 1, self.m_iBorderColor, self.m_bPostGUI );
	dxDrawRectangle( self.m_fX - 1, self.m_fY + self.m_fHeight, self.m_fWidth + 2, 1, self.m_iBorderColor, self.m_bPostGUI );
	
	dxDrawRectangle( self.m_fX, self.m_fY, self.m_fWidth, self.m_fHeight, self.m_iBgColor, self.m_bPostGUI );
	
	local fX, fY = self.m_fX + 10, self.m_fY + 5;
	
	for i, pRow in pairs( self.m_Items ) do
		local iColor	= self.m_iColor;
		local fX, fY	= fX, fY + ( 22 * ( i - 1 ) );
		
		if fCurX >= fX - 5 and fCurX <= fX + ( self.m_fWidth - 15 ) and fCurY > fY - 2 and fCurY < fY + 18 then
			iColor	= self.m_iHoverColor;
			
			dxDrawRectangle( fX - 5, fY - 2, self.m_fWidth - 10, 18, self.m_iBgHoverColor, self.m_bPostGUI );
			
			iHover = i;
			
			if bClicked then
				iColor	= self.m_iActiveColor;
			end
		end
		
		dxDrawText( pRow[ 1 ], fX + 1, fY + 1, fX, fY, 4278190080, 1.0, "default", "left", "top", false, false, self.m_bPostGUI );
		dxDrawText( pRow[ 1 ], fX, fY, fX, fY, iColor, 1.0, "default", "left", "top", false, false, self.m_bPostGUI );
	end
	
	if bClicked then
		self.m_bClicked = true;
	elseif self.m_bClicked then
		self.m_bClicked = false;
		
		if fCurX >= self.m_fX and fCurX <= self.m_fX + self.m_fWidth and fCurY > self.m_fY and fCurY < self.m_fY + self.m_fHeight then
			if self.m_Items[ iHover ] then
				self:Hide();
				
				self.m_Items[ iHover ][ 2 ]( self );
			end
		else
			self:Hide();		
		end
	end
end

addEventHandler( "onClientRender", root, 
	function()
		if pCurrentContextMenu then
			pCurrentContextMenu:Draw();
		end
	end,
	false,
	"low"
);