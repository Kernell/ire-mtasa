-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUISideBar
{
	ANIMATION_SPEED	= 0.5;
	
	m_fX		= g_iScreenX;
	m_fY		= 0;
	m_fWidth	= 300;
	m_fHeight	= g_iScreenY;
	
	m_fTargetX	= g_iScreenX;
	
	m_iBgColor	= tocolor( 0, 0, 0, 220 );
	
	CUISideBar	= function( this )
		this.m_fHeight = gl_iScreenY;
		
		function this.__Update()
			this:Update();
		end
		
		function this.__OnClick( ... )
			this:OnClick( ... );
		end
		
		addEventHandler( "onClientRender", 	root, this.__Update );
		addEventHandler( "onClientClick", 	root, this.__OnClick );
	end;
	
	_CUISideBar	= function( this )
		removeEventHandler( "onClientRender", 	root, this.__Update );
		removeEventHandler( "onClientClick", 	root, this.__OnClick );
		
		this.__Update	= NULL;
		this.__OnClick	= NULL;
	end;
	
	Open		= function( this )
		if this:IsClosed() then
			this.m_iOpenTickEnd		= getTickCount() + ( this.ANIMATION_SPEED * 1000 );
			
			this.m_fStartX			= this.m_fX;
			this.m_fTargetX			= g_iScreenX - this.m_fWidth;
			this.m_sOpenFunction	= "OutQuad";
		end
	end;
	
	Close		= function( this )
		if not this:IsClosed() then
			this.m_iOpenTickEnd		= getTickCount() + ( this.ANIMATION_SPEED * 1000 );
			
			this.m_fStartX			= this.m_fX;
			this.m_fTargetX			= g_iScreenX;
			this.m_sOpenFunction	= "OutQuad";
		end
	end;
	
	IsClosed	= function( this )
		return this.m_fX == g_iScreenX;
	end;
	
	Update		= function( this )
		local iTick = getTickCount();
		
		if this.m_iOpenTickEnd then
			local fProgress		= 1.0 - ( this.m_iOpenTickEnd - iTick ) / ( this.ANIMATION_SPEED * 1000 );
			
			if fProgress > 1.0 then
				this.m_iOpenTickEnd = NULL;
			else
				this.m_fX = math.ceil( Lerp( this.m_fStartX, this.m_fTargetX, getEasingValue( fProgress, this.m_sOpenFunction ) ) );
			end
		end
		
		if this:IsClosed() then
			return;
		end
		
		local iCurX, iCurY = getCursorPosition();
		
		iCurX = ( iCurX or 0 ) * g_iScreenX;
		iCurY = ( iCurY or 0 ) * g_iScreenY;
		
		this:Draw();
	end;
	
	Draw		= function( this )
		local fX = this.m_fX;
		local fY = this.m_fY;
		
		dxDrawRectangle( fX, fY, this.m_fWidth, this.m_fHeight, this.m_iBgColor, true );
	end;
	
	OnClick		= function( this, sMouseButton, sState, iCurX, iCurY )
		if this:IsClosed() then
			if sState == "up" then
				if iCurX >= g_iScreenX - 5 then
					this:Open();
				end
			end
			
			return;
		end
		
		if sState == "down" then
			if this.m_pHover then
				this.m_pHoverPrev = this.m_pHover;
			end
		elseif sState == "up" then
			if this.m_pHoverPrev and this.m_pHoverPrev == this.m_pHover then
				if this.m_pHover.OnClick and sMouseButton == "left" then
					this.m_pHover:OnClick();				
				end
			elseif iCurX < g_iScreenX - this.m_fWidth then
				this:Close();
			end
			
			this.m_pHoverPrev	= NULL;
		end
	end;
};
