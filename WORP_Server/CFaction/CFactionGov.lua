-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CFactionGov ( CFaction );

function CFactionGov:CFactionGov( ... )
	self:CFaction( ... );
	self.CFaction = NULL;
	
	
end

function CFactionGov:ShowMenu( pClient, bForce )
	local pChar = pClient:GetChar();
	
	if pChar then
		if pChar:GetFaction() == self then
			local sQuery = " \
SELECT f.id, CONCAT( c.name, ' ', c.surname ) AS owner, f.name, f.tag, i.name AS address, f.type, \
DATE_FORMAT( f.created, '%d-%m-%Y' ) AS created, \
DATE_FORMAT( registered, '%d-%m-%Y' ) AS registered \
FROM " + DBPREFIX + "factions f \
LEFT JOIN " + DBPREFIX + "characters c ON c.id = f.owner_id \
LEFT JOIN " + DBPREFIX + "interiors i ON i.id = f.property_id \
ORDER BY f.id \
LIMIT 0, 30";
			
			local pResult = g_pDB:Query( sQuery );
			
			if pResult then
				pChar:ShowUI( "CUIGovFactionList", pResult:GetArray(), bForce );
			
				delete ( pResult );
			else
				Debug( g_pDB:Error(), 1 );
			end
			
			return true;
		end
	end
	
	return false;
end

function CClientRPC:RegisterFaction( iFactionID )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED; 
	end
	
	local pFaction = pChar:GetFaction();
	
	if not pFaction or classof( pFaction ) ~= CFactionGov then
		return TEXT_ACCESS_DENIED;
	end
	
	local pFaction = g_pGame:GetFactionManager():Get( iFactionID );
	
	if not pFaction then
		return TEXT_FACTIONS_INVALID_ID;
	end
	
	local pProperty = g_pGame:GetInteriorManager():Get( pFaction.m_iPropertyID );
	
	if not pProperty then
		return "Не верный адрес регистрации (не существует)";
	end
	
	if pProperty.m_sType ~= INTERIOR_TYPE_COMMERCIAL then
		return "Только коммерческую недвижимость можно оформить на предприятие";
	end
	
	local pResult = g_pDB:Query( "SELECT character_id FROM " + DBPREFIX + "interiors WHERE id = " + pProperty:GetID() + " LIMIT 1" );
	
	if not pResult then
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR;
	end
	
	local pRow = pResult:FetchRow();
	
	delete ( pResult );
	
	if not pRow or not pRow.character_id or pProperty.m_iCharacterID ~= pRow.character_id then
		return "Эта недвижимость не принадлежит владельцу организации";
	end
	
	if pProperty.m_iFactionID ~= 0 then
		return "Недвижимость предлагаемая для регистрации уже оформлена на другую организацию";
	end
	
	pProperty:SetFaction( pFaction );
	
	g_pGame:GetFactionManager():Register( pFaction );
	
	return true;
end









