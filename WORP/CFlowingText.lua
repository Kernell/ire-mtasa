-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CFlowingText
{
	m_iStart	= NULL;
	m_iDuration	= NULL;
	m_sText		= NULL;
	
	CFlowingText = function( self, sText )
		function self.__Render()
			self:Render();
		end
		
		if not self.m_sText then
			addEventHandler( "onClientRender", root, self.__Render );
		end
		
		self.m_iStart		= getTickCount();
		self.m_iDuration	= 1000;
		self.m_sText		= sText;
	end;
	
	_CFlowingText = function( self )
		self.m_iStart		= NULL;
		self.m_iDuration	= NULL;
		self.m_sText		= NULL;
		
		removeEventHandler( "onClientRender", root, self.__Render );
	end;
	
	Render	= function( self )
		if self.m_iStart and self.m_iDuration then
			local iTick = getTickCount();
			
			if iTick > self.m_iStart + self.m_iDuration then
				delete ( self );
			else
				local fAlpha = .9;
				
				if self.m_iStart + self.m_iDuration / 2 < iTick then
					fAlpha	= ( self.m_iStart + self.m_iDuration - iTick ) / self.m_iDuration * 2;
				end
				
				dxDrawText( self.m_sText, 2, 102, g_iScreenX, g_iScreenY, tocolor( 0, 0, 0, 255 * fAlpha ), 2, "diploma", "center", "top", true, false, true );
				dxDrawText( self.m_sText, 0, 100, g_iScreenX, g_iScreenY, tocolor( 255, 168, 0, 255 * fAlpha ), 2, "diploma", "center", "top", true, false, true );
			end
		end
	end;
};
