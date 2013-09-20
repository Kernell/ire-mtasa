-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CPlayerChat"

function CPlayerChat:CPlayerChat( pPlayer )
	self.m_pPlayer = pPlayer;
end

function CPlayerChat:_CPlayerChat()
	self.m_pPlayer = NULL;
end

function CPlayerChat:Send( sMessage, iRed, iGreen, iBlue, bColorCoded )
	if classname( self ) ~= 'CPlayerChat' then error( TEXT_E2288, 2 ) end
	
	return outputChatBox( sMessage, self.m_pPlayer, tonumber( iRed ) or 255, tonumber( iGreen ) or 164, tonumber( iBlue ) or 0, bColorCoded == NULL and true or (bool)(bColorCoded) );
end

function CPlayerChat:Show()
	if classname( self ) ~= 'CPlayerChat' then error( TEXT_E2288, 2 ) end
	
	return showChat( self.m_pPlayer, true );
end

function CPlayerChat:Hide()
	if classname( self ) ~= 'CPlayerChat' then error( TEXT_E2288, 2 ) end
	
	return showChat( self.m_pPlayer.__instance, false );
end

function CPlayerChat:Error( sText, ... )
	if classname( self ) ~= 'CPlayerChat' then error( TEXT_E2288, 2 ) end
	
	return self:Send( "Error: " + ( ( ... ) and sText:format( ... ) or sText ), 255, 0, 0, true );
end

function CPlayerChat:Warning( sText, ... )
	if classname( self ) ~= 'CPlayerChat' then error( TEXT_E2288, 2 ) end
	
	return self:Send( "Warning: " + ( ( ... ) and sText:format( ... ) or sText ), 255, 128, 0, true );
end
