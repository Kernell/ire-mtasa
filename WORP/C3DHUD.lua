-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: C3DHUD
{
	m_bEnabled	= true;
	m_fX		= 1;
	m_fY		= 1;
	m_fWidth	= 70;
	m_fHeight	= 1;
	m_iColor	= tocolor( 255, 255, 255, 255 );
	m_iBgColor	= tocolor( 0, 0, 0, 255 );
	m_pFont		= DXFont( "Segoe UI", 32, true );
	m_fScale	= 1.0;
	
	m_fStartX	= 0;
	m_fStartY	= 0;
	m_fStartZ	= 0;
	
	m_fEndX		= 0;
	m_fEndY		= 0;
	m_fEndZ		= 0;
	
	m_fTowardX	= 0;
	m_fTowardY	= 0;
	m_fTowardZ	= 0;
	
	C3DHUD		= function( this )
		function this.__Render()
			if this.m_bEnabled then
				if this.Update then
					this:Update();
				end
				
				this:Render();
			end
		end
		
		this.m_pRender = dxCreateRenderTarget( 200, 100, true );
		
        addEventHandler( "onClientPreRender", root, this.__Render );
	end;
	
	_C3DHUD		= function( this )
		removeEventHandler( "onClientPreRender", root, this.__Render );
		
		destroyElement( this.m_pRender );
		
		this.m_pRender	= NULL;
		this.__Render	= NULL;
	end;
	
	SetText		= function( this, sText )
		dxSetRenderTarget( this.m_pRender, true );		
			
		if sText then
			this:DrawText( sText, this.m_fX, this.m_fY, this.m_fWidth, this.m_fHeight, this.m_iColor );
		end
			
		dxSetRenderTarget();
	end;
	
	DrawText	= function( this, sText, fX, fY, fWidth, fHeight, iColor )
		dxDrawText( sText, fX, 0, fWidth, 0, iColor, 1.0, this.m_pFont );
	end;
	
	Render		= function( this )
		if this.m_pRender then
			dxDrawMaterialLine3D( this.m_fStartX, this.m_fStartY, this.m_fStartZ, this.m_fEndX, this.m_fEndY, this.m_fEndZ, this.m_pRender, this.m_fScale, -1, this.m_fTowardX, this.m_fTowardY, this.m_fTowardZ );
		end
	end;
};