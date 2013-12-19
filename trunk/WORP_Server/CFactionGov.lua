-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CFactionGov ( CFaction );

function CFactionGov:CFactionGov( ... )
	self:CFaction( ... );
	
	
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
