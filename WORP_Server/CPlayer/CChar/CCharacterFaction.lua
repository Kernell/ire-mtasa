-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CCharacterFaction
{
	m_pFaction			= NULL;
	m_iFactionDept		= 1;
	m_iFactionRank		= 1;
	m_iFactionRights	= 0x0;
	
	CCharacterFaction	= function( this, pClient, pDBField )
		this.m_pFaction			= pDBField.faction_id ~= 0 and g_pGame:GetFactionManager():Get( pDBField.faction_id ) or NULL;
		
		if this.m_pFaction then
			this.m_iFactionDept		= pDBField.faction_dept_id;
			this.m_iFactionRank		= pDBField.faction_rank_id;
			this.m_iFactionRights	= tonumber( pDBField.faction_rights, 16 ) or this.m_iFactionRights;
		end
		
		pClient:SetParent	( this.m_pFaction and this.m_pFaction.m_pElement or g_pNoFaction.m_pElement );
		
		pClient:SetData( "CFaction::ID", (int)(pDBField.faction_id) );
	end;
	
	_CCharacterFaction	= function( this )
		this.m_pClient:SetParent( g_pNoFaction.m_pElement );
	end;
	
	GetFaction			= function( this )
		return this.m_pFaction;
	end;

	GetFactionRank		= function( this )	-- TODO: Deprecated
		Warning( 2, 8106, "CCharacterFaction::GetFactionRank" );
		
		return this.m_iFactionRank;
	end;

	GetFactionRights	= function( this )	-- TODO: Deprecated
		Warning( 2, 8106, "CCharacterFaction::GetFactionRights" );
		
		return this.m_iFactionRights;
	end;
	
	SetFaction			= function( this, pFaction, iDept, iRank, xRights )
		local pOldFaction = this.m_pFaction;
		
		iFactionID	= pFaction and pFaction:GetID() 	or 0;
		iDept		= pFaction and tonumber( iDept ) 	or 1;
		iRank		= pFaction and tonumber( iRank ) 	or 1;
		xRights		= pFaction and tonumber( xRights ) 	or 0x0;
		
		if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET faction_id = %d, faction_dept_id = %d, faction_rank_id = %d, faction_rights = '%X' WHERE id = " + this:GetID(), iFactionID, iDept, iRank, xRights ) then
			this.m_pFaction			= pFaction;
			this.m_iFactionDept		= iDept;
			this.m_iFactionRank		= iRank;
			this.m_iFactionRights	= xRights;
			
			this.m_pClient:SetData( "CFaction::ID", iFactionID );
			
			source:SetParent( pFaction and pFaction.m_pElement or g_pNoFaction.m_pElement );
			
			return true;
		end
		
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end;

	SetFactionRank		= function( this, iRank )
		if this.m_pFaction then
			if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET faction_rank_id = '%d' WHERE id = " + this:GetID(), iRank ) then
				this.m_iFactionRank	= iRank;
				
				return true;
			end
			
			Debug( g_pDB:Error(), 1 );
		end
		
		return false;
	end;

	SetFactionRights	= function( this, iRights )
		if this.m_pFaction then
			if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET faction_rights = '%X' WHERE id = " + this:GetID(), iRights ) then
				this.m_iFactionRights	= iRights;
				
				return true;
			else
				Debug( g_pDB:Error(), 1 );
			end
		end
		
		return false;
	end;
};
