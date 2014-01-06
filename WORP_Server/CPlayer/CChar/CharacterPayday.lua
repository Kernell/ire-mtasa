-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

function CPlayer:PayDay()
	local pChar = self:GetChar();
	
	if pChar then
		pChar.m_iLevelPoints = pChar.m_iLevelPoints + 50;
		
		if pChar:GetLevelPoints() > pChar:GetLevel() * 250 then
			pChar:SetLevel( pChar:GetLevel() + 1, true );
			
			self:Popup( "info", "Поздравляем!", "Ваш уровень повышен до " + pChar:GetLevel() );
		end
	end
end

function CChar:InitPay( iPay )
	self.m_iPay = iPay;
end

function CChar:SetPay( iValue )
	local bValid, sError = is_type( iValue, 'number', 'iValue' );
	
	if not bValid then error( sError, 2 ); end
	
	self.m_iPay = iValue;
	
	return g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET pay = " + self.m_iPay + " WHERE id = " + self:GetID() ) or not Debug( g_pDB:Error(), 1 );
end

function CChar:GivePay( iValue )
	local bValid, sError = is_type( iValue, 'number', 'iValue' );
	
	if not bValid then error( sError, 2 ); end
	
	return self:SetPay( self.m_iPay + iValue );
end

function CChar:GetPay()
	return self.m_iPay;
end