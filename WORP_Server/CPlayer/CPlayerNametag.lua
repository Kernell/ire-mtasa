-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CPlayerNametag"

function CPlayerNametag:CPlayerNametag( pPlayer )
	self.m_pPlayer = pPlayer;
end

function CPlayerNametag:_CPlayerNametag()
	
end

function CPlayerNametag:SetColor( ... )
	return setPlayerNametagColor( self.m_pPlayer, ... );
end

function CPlayerNametag:GetColor()
	return getPlayerNametagColor( self.m_pPlayer );
end

function CPlayerNametag:GetText()
	return self.m_pPlayer:GetData( "Nametag:Text" );
end

function CPlayerNametag:SetText( sText )
	return self.m_pPlayer:SetData( "Nametag:Text", sText );
end

function CPlayerNametag:IsShowing()
	return isPlayerNametagShowing( self.m_pPlayer );
end

function CPlayerNametag:Show()
	return self.m_pPlayer:SetData( "Nametag:Showing", true );
end

function CPlayerNametag:Hide()
	return self.m_pPlayer:SetData( "Nametag:Showing", false );
end

function CPlayerNametag:Update()
	local sText	= self.m_pPlayer:GetVisibleName();
	local Color	= { 120, 120, 120 };
	
	if self.m_pPlayer:IsInGame() then
		Color	= { 255, 255, 255 };
	end
	
	if not self.m_pPlayer:IsAdmin() then
		sText	= ( "%s (%d)" ):format( sText, self.m_pPlayer:GetID() );
	end
	
	self:SetText( sText );
	self:SetColor( unpack( Color ) );
end