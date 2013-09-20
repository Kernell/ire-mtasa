-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

addEvent "onCharacterFactionChanged"

local function OnCharacterLogin()
	local pFaction 		= source:GetChar():GetFaction();
	
	source:SetParent		( pFaction and assert( pFaction.m_pElement, 'pFaction->m_pElement' ) or assert( g_pNoFaction.m_pElement, 'g_pNoFaction->m_pElement' ) );
	
	if pFaction then
		local pResult 	= g_pDB:Query( "SELECT deleted FROM " + DBPREFIX + "factions WHERE id = " + pFaction:GetID() );
		
		if pResult then
			local pRow 		= pResult:FetchRow();
			
			delete ( pResult );
			
			if pRow and pRow.deleted == "Yes" then
				source:SetFaction();
				
				source:GetChat():Send( "Внимание! Ваша организация была удалена!", 255, 64, 0 );
			end
		else
			source:SetFaction();
			
			source:GetChat():Send( "Ваша организация не была загружена! " + TEXT_DB_ERROR, 255, 0, 0 );
			
			Debug( g_pDB:Error(), 1 );
		end
	end
end

local function OnCharacterLogout()
	source:SetParent( g_pNoFaction.m_pElement );
end

local function OnCharacterFactionChanged( iOldFactionID, iFactionID )
	local pFaction 		= g_pGame:GetFactionManager():Get( iFactionID );
	local pOldFaction 	= g_pGame:GetFactionManager():Get( iOldFactionID );
	
	source:SetParent( pFaction and pFaction.m_pElement or g_pNoFaction.m_pElement );
end

addEventHandler( "onCharacterLogin", root, OnCharacterLogin );
addEventHandler( "onCharacterLogout", root, OnCharacterLogout );
addEventHandler( "onCharacterFactionChanged", root, OnCharacterFactionChanged );
