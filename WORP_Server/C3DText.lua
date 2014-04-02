-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "C3DText"

function C3DText:C3DText( vecPosition, sText, iRed, iGreen, iBlue, iAlpha )	
	self.m_pElement		= CElement( '3DText' );
	
	self:SetText		( sText );
	self:SetColor		( iRed, iGreen, iBlue, iAlpha );
	
	if vecPosition then
		self:SetPosition( vecPosition );
	end
end

function C3DText:_C3DText()
	self:Destroy();
end

function C3DText:SetText( sText )
	self.m_pElement:SetData( 'Text', sText );
end

function C3DText:SetColor( iRed, iGreen, iBlue, iAlpha )
	self.m_pElement:SetData( 'Color', tonumber( ( "0x%02x%02x%02x%02x" ):format( iAlpha or 255, iRed or 0, iGreen or 0, iBlue or 0 ) ) - 4294967296 );
end

function C3DText:SetPosition( vecPosition )
	self.m_pElement:SetPosition( vecPosition );
end

function C3DText:GetText()
	return self.m_pElement:GetData( 'Text' );
end

function C3DText:GetColor()
	return self.m_pElement:GetData( 'Color' );
end

function C3DText:GetPosition()
	return self.m_pElement:GetPosition();
end

function C3DText:Destroy()
	self.m_pElement:Destroy();
end