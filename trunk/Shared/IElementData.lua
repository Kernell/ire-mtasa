-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: IElementData
{
	IElementData	= function( this )
		this.m_pData = {};
		
		function this.m_pData.__newindex( self, sName, vValue )
			if vValue == NULL then
				return this:RemoveData( classname( this ) + "::" + sName );
			end
			
			return this:SetData( classname( this ) + "::" + sName, vValue );
		end
		
		function this.m_pData.__index( self, sName )
			return this:GetData( classname( this ) + "::" + sName, vValue );
		end
		
		setmetatable( this.m_pData, this.m_pData );
	end;
};