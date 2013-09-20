-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CPlayerNametag"

function CPlayerNametag:CPlayerNametag( pPlayer )
	self.m_pPlayer = pPlayer;
end

function CPlayerNametag:_CPlayerNametag()
	
end

function CPlayerNametag:SetColor( ... )
	return setPlayerNametagColor( self.m_pPlayer.__instance, ... );
end

function CPlayerNametag:GetColor()
	return getPlayerNametagColor( self.m_pPlayer.__instance );
end

function CPlayerNametag:GetText()
	return self.m_pPlayer:GetData( "Nametag:Text" );
--	return getPlayerNametagText( self.m_pPlayer.__instance );
end

function CPlayerNametag:SetText( sText )
	return self.m_pPlayer:SetData( "Nametag:Text", sText );
--	return setPlayerNametagText( self.m_pPlayer.__instance, sText );
end

function CPlayerNametag:IsShowing()
	return isPlayerNametagShowing( self.m_pPlayer.__instance );
end

function CPlayerNametag:Show()
	return self.m_pPlayer:SetData( "Nametag:Showing", true );
--	return setPlayerNametagShowing( self.m_pPlayer.__instance, true );
end

function CPlayerNametag:Hide()
	return self.m_pPlayer:SetData( "Nametag:Showing", false );
--	return setPlayerNametagShowing( self.m_pPlayer.__instance, false );
end

function CPlayerNametag:Update()
	local sText	= ( "%s (%d)" ):format( self.m_pPlayer:GetName(), self.m_pPlayer:GetID() );
	local Color	= { 120, 120, 120 };
	
	if self.m_pPlayer:IsInGame() then
		Color	= { 255, 255, 255 };
	end
	
	if self.m_pPlayer:IsAdmin() then
		sText	= self.m_pPlayer:GetGroups()[ 1 ]:GetCaption() + LF + self.m_pPlayer:GetUserName();
	end
	
	self:SetText( sText );
	self:SetColor( unpack( Color ) );
end