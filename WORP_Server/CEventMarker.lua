-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CEventMarker
{
	CEventMarker = function( this, pManager, iID, vModel, vecPosition, iInterior, iDimension, fSize, Color, sOnHit, sOnLeave )
		this.m_iID		= iID;
		this.m_sOnHit	= sOnHit;
		this.m_sOnLeave	= sOnLeave;
		
		if type( vModel ) == "string" then
			this.m_pMarker = CMarker.Create( vecPosition, vModel, fSize, Color and unpack( Color ) );
		else
			this.m_pMarker = CPickup.Create( vecPosition, 3, (int)(vModel) );
		end
		
		this.m_pMarker:SetInterior( iInterior );
		this.m_pMarker:SetDimension( iDimension );
		
		this.m_pMarker.m_pEventMarker = this;
		
		this.m_pMarker.OnHit	= CEventMarker.OnHit;
		this.m_pMarker.OnLeave	= CEventMarker.OnLeave;
		
		pManager:AddToList( this );
	end;
	
	_CEventMarker = function( this )
		g_pGame:GetEventMarkerManager():RemoveFromList( this );
		
		delete ( this.m_pMarker );
		
		this.m_pMarker = NULL;
	end;
	
	GetID	= function( this )
		return this.m_iID;
	end;
	
	OnHit	= function( pMarker, ... )
		local this = pMarker.m_pEventMarker;
		
		if this.m_sOnHit then
			CEventMarker[ this.m_sOnHit ]( this, ... );
		end
		
		return false;
	end;
	
	OnLeave	= function( pMarker, ... )
		local this = pMarker.m_pEventMarker;
		
		if this.m_sOnLeave then
			CEventMarker[ this.m_sOnLeave ]( this, ... );
		end
		
		return false;
	end;
};

function CEventMarker:CreateFaction( pClient, bMatching )
	if bMatching and classof( pClient ) == CPlayer and pClient:IsInGame() then
		local pChar = pClient:GetChar();
		
		local FactionTypes = 
		{
		--	[ 0 ] = "Государственная организация";
			[ 1 ] = "Limited liability company (LLC)";
			[ 2 ] = "Corporation";
			[ 3 ] = "Sole proprietorship";
		};
		
		local aInteriors	= {};
		
		for i, pInt in pairs( g_pGame:GetInteriorManager():GetAll() ) do
			if pInt.m_sType == INTERIOR_TYPE_COMMERCIAL and pInt.m_iCharacterID == pChar:GetID() then
				table.insert( aInteriors, { ID = pInt:GetID(); Name = pInt:GetName(); } );
			end
		end		
		
		pClient:GetChar():ShowUI( "CUIFactionCreate", pClient:GetChar().m_sName, pClient:GetChar().m_sSurname, FactionTypes, aInteriors );
	end
	
	return false;
end
