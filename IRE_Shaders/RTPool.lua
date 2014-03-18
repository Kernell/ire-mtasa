-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: RTPool
{
	RTPool		= function( this )
		this.List = {};
	end;
	
	_RTPool		= function( this )
		this:Clear();
		
		this.List = NULL;
	end;
	
	Init		= function( this )
		for i, pRT in ipairs( this.List ) do
			pRT.m_bInUse = false;
		end
	end;
	
	Clear		= function( this )
		for i, pRT in ipairs( this.List ) do
			delete ( pRT );
		end
		
		this.List = {};
	end;
	
	GetUnused	= function( this, fSizeX, fSizeY )
		for i, pRT in ipairs( this.List ) do
			if not pRT.m_bInUse and pRT.m_fSizeX == fSizeX and pRT.m_fSizeY == fSizeY then
				pRT.m_bInUse = true;
				
				return pRT;
			end
		end
		
		local pRenderTarget = dxCreateRenderTarget( fSizeX, fSizeY );
		
		if pRenderTarget then
			pRenderTarget.m_bInUse	= true;
			pRenderTarget.m_fSizeX	= fSizeX;
			pRenderTarget.m_fSizeY	= fSizeY;
			
			table.insert( this.List, pRenderTarget );
		end
		
		return pRenderTarget;
	end;
};