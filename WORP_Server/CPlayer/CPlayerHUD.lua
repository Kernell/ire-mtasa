-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

PLAYER_HUD		=
{
	EXP			= 1;
	LEVEL		= 2;
	MONEY		= 3;
	WEAPON		= 4;
	HEALTH		= 5;
	ARMOR		= 6;
	POWER		= 7;
};

class "CPlayerHUD";

function CPlayerHUD:CPlayerHUD( pPlayer )
	self.m_pPlayer = pPlayer;
end

function CPlayerHUD:_CPlayerHUD()
	self.m_pPlayer:Client()._CClientHUD();
end

function CPlayerHUD:Show()
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	self.m_pPlayer:Client().CClientHUD();
	
	if self.m_pPlayer:IsInGame() then
--		self:SetInfo( PLAYER_HUD.EXP, 		self.m_pPlayer:GetChar():GetLevelPoints() );
		self:SetInfo( PLAYER_HUD.LEVEL, 	self.m_pPlayer:GetChar():GetLevel() );
		self:SetInfo( PLAYER_HUD.MONEY, 	self.m_pPlayer:GetChar():GetMoney() );
--		self:SetInfo( PLAYER_HUD.POWER,		self.m_pPlayer:GetChar():GetPower() );
	end
end

function CPlayerHUD:Hide()
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	self.m_pPlayer:Client()._CClientHUD();
end

function CPlayerHUD:SetInfo( ePlayerHUD, vInfo )
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	self.m_pPlayer:Client().SetHUDInfo( ePlayerHUD, vInfo );
end

function CPlayerHUD:SetComponentVisible( ePlayerHUD, bVisible )
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	self.m_pPlayer:Client().SetHUDComponentVisible( ePlayerHUD, bVisible );
end

function CPlayerHUD:ShowMap()
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	return forcePlayerMap( self.m_pPlayer, true );
end

function CPlayerHUD:HideMap()
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	return forcePlayerMap( self.m_pPlayer, false );
end

function CPlayerHUD:IsMapShowing()
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	return isPlayerMapForced( self.m_pPlayer );
end

function CPlayerHUD:SetMoney( iValue )
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	return self:SetInfo( PLAYER_HUD.MONEY, (int)(iValue) );
end

function CPlayerHUD:ShowComponents( ... )
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	for _, component in ipairs( { ... } ) do
		showPlayerHudComponent( self.m_pPlayer, component, true );
	end
end

function CPlayerHUD:HideComponents( ... )
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	for _, component in ipairs( { ... } ) do
		showPlayerHudComponent( self.m_pPlayer, component, false );
	end
end

function CPlayerHUD:ShowCursor( bToggleControls )
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	return showCursor( self.m_pPlayer, true, bToggleControls == NULL and true or bToggleControls );
end

function CPlayerHUD:HideCursor( bToggleControls )
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	return showCursor( self.m_pPlayer, false, bToggleControls == NULL and true or bToggleControls );
end

function CPlayerHUD:IsCursorShowing()
	if classname( self ) ~= 'CPlayerHUD' then error( TEXT_E2288, 2 ) end
	
	return isCursorShowing( self.m_pPlayer );
end