-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CPropertyUpgrade
{
	CPropertyUpgrade	= function( this, pUpgrades, sUpgrade, Data )
		this.m_sID 			= sUpgrade;
		this.m_pUpgrades 	= pUpgrades;
		this.m_Data			= Data;
		
		if this.m_sID == "FACTION_MARKER" then
			if this.m_pUpgrades.m_pProperty:GetFaction() then
				local fX, fY, fZ, iInterior, iDimension = unpack( Data );
				
				this.m_pMarker = CreateMarker( fX, fY, fZ, "cylinder", 1.0, 0, 0, 255, 128 );
				
				this.m_pMarker:SetInterior( iInterior );
				this.m_pMarker:SetDimension( iDimension );
				
				function OnHit( pClient, bMatching )
					if bMatching and classof( pClient ) == CPlayer and pClient:IsInGame() then
						local pFaction = this.m_pUpgrades.m_pProperty:GetFaction();
						
						if pFaction and pClient:GetChar():GetFaction() == pFaction then
							pFaction:Show( pClient );
						end
					end
				end
				
				function OnLeave( pClient, bMatching )
					if bMatching and classof( pClient ) == CPlayer and pClient:IsInGame() then
						pClient:GetChar():HideUI( "CUIFaction" );
					end
				end
				
				addEventHandler( "onMarkerHit", this.m_pMarker, OnHit );
				addEventHandler( "onMarkerLeave", this.m_pMarker, OnLeave );
			end
		elseif this.m_sID == "BLIP" then
			local iBlip = unpack( Data );
			
			this.m_pBlip = CBlip( this.m_pUpgrades.m_pProperty.m_pOutsideMarker:GetPosition(), iBlip, 2.0, 255, 255, 255, 255, 0, 250.0 );
		end
	end;
	
	_CPropertyUpgrade	= function( this )
		if this.m_sID == "FACTION_MARKER" then
			if this.m_pMarker then			
				delete ( this.m_pMarker );
				this.m_pMarker = NULL;
			end
		elseif this.m_sID == "BLIP" then
			delete ( this.m_pBlip );
			this.m_pBlip = NULL;
		end
	end;
};

class: CPropertyUpgrades
{
	CPropertyUpgrades	= function( this, pProperty, Upgrades )
		this.m_pProperty 	= pProperty;
		this.m_Upgrades		= {};
		
		if Upgrades then
			for sUpgrade, Data in pairs( Upgrades ) do
				this:Add( sUpgrade, Data );
			end
		end
	end;
	
	_CPropertyUpgrades	= function( this )
		for key, value in pairs( this.m_Upgrades ) do
			if typeof( value ) == "object" then
				delete ( value );
			end
		end
	end;
	
	__tostring	= function( this )
		local Upgrades = {};
		
		for sID, pUpgrade in pairs( this.m_Upgrades ) do
			Upgrades[ sID ] = pUpgrade.m_Data;
		end
		
		return toJSON( Upgrades );
	end;
	
	Add		= function( this, sUpgrade, Data )
		if this:Have( sUpgrade ) then
			this:Remove( sUpgrade );
		end
		
		this.m_Upgrades[ sUpgrade ] = CPropertyUpgrade( this, sUpgrade, Data );
	end;
	
	Have	= function( this, sUpgrade )
		return this.m_Upgrades[ sUpgrade ] ~= NULL;
	end;
	
	Remove	= function( this, sUpgrade )
		delete ( this.m_Upgrades[ sUpgrade ] );
		this.m_Upgrades[ sUpgrade ] = NULL;
	end;
};
