-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

ePropertyType =
{
	COMMERCIAL		= 0;
	HOUSE			= 1;
};

ePropertyOwner =
{
	CHARACTER		= 0;
	FACTION			= 1;
};

class: CProperty
{
	m_iID				= 0;
	m_pInterior			= NULL;
	m_iOwnerID			= 0;
	m_iOwnerType		= ePropertyOwner.CHARACTER;
	m_iType				= ePropertyType.COMMERCIAL;
	m_iPrice			= 0;
	m_sName				= "NULL";
	m_bLocked			= false;
	m_vecDropPosition	= NULL;
	m_vecPosition		= NULL;
	m_fRotation			= NULL;
	m_iInterior			= NULL;
	m_iDimension		= NULL;
	m_Store				= NULL;
	
	CProperty		= function( this, iID )
		this.m_iID				= iID;
		
		this.m_p3DText			= C3DText();
	end;
	
	_CProperty		= function( this )
		g_pGame:GetPropertyManager():RemoveFromList( this );
		
		delete ( this.m_p3DText );
		delete ( this.m_pMarker );
		delete ( this.m_pInsideMarker );
		
		this.m_p3DText			= NULL;
		this.m_pMarker	= NULL;
		this.m_pInsideMarker	= NULL;
	end;
	
	GetID		= function( this )
		return this.m_iID;
	end;
	
	Update		= function( this )
		this:Update3DText();
		this:UpdateMarker();
		this:UpdateBlip();
	end;
	
	Update3DText	= function( this )
		local Color 	= CPropertyManager:GetColor( this );
		local sText		= this.m_sName + ( this.m_iPrice > 0 and ( "\n$" + this.m_iPrice ) or "" );
		
		this.m_p3DText:SetColor( Color[ 1 ], Color[ 2 ], Color[ 3 ] );
		this.m_p3DText:SetText( sText );
		this.m_p3DText:SetPosition( this.m_vecPosition );
--		this.m_p3DText:SetInterior( this.m_iInterior );
--		this.m_p3DText:SetDimension( this.m_iDimension );
	end;
	
	UpdateMarker	= function( this )
		if this.m_pMarker then
			delete ( this.m_pMarker );
			this.m_pMarker = NULL;
		end
		
		if this.m_pInsideMarker then
			delete ( this.m_pInsideMarker );
			this.m_pInsideMarker = NULL;
		end
		
		if this.m_iPrice > 0 then
			this.m_pMarker	= CPickup.Create( this.m_vecPosition, 3, this.m_iType == ePropertyType.COMMERCIAL and 1272 or 1273 );
		else
			this.m_pMarker	= CMarker.Create( this.m_vecPosition + Vector3( 0, 0, .54 ), "arrow", 1, unpack( Color ) );
		end
		
		this.m_pMarker:SetInterior( this.m_iInterior );
		this.m_pMarker:SetDimension( this.m_iDimension );
		
		this.m_pMarker.Rotation		= this.m_fRotation;
		
		if this.m_pInterior then
			this.m_pInsideMarker		= CMarker.Create( this.m_pInterior.Position + Vector3( 0, 0, .54 ), "arrow", 1, unpack( Color ) );
			
			this.m_pInsideMarker.Rotation		= this.m_pInterior.Rotation;
			
			this.m_pInsideMarker:SetInterior	( this.m_pInterior.Interior );
			this.m_pInsideMarker:SetDimension	( this:GetID() );
			
			this.m_pMarker.m_pTarget			= this.m_pInsideMarker;
			this.m_pInsideMarker.m_pTarget		= this.m_pMarker;
			
			this.m_pMarker.m_pProperty			= this;
			this.m_pInsideMarker.m_pProperty	= this;
			
			this.m_pMarker.OnHit				= CProperty.OnHit;
			this.m_pInsideMarker.OnHit			= CProperty.OnHit;
			
			this.m_pMarker.OnLeave				= CProperty.OnLeave;
			this.m_pInsideMarker.OnLeave		= CProperty.OnLeave;
		end
	end;
	
	UpdateBlip	= function( this )
		if this.m_pBlip then
			delete ( this.m_pBlip );
			this.m_pBlip = NULL;
		end
		
		if this.m_pInterior and this.m_pInterior.Blip and this.m_iType == ePropertyType.COMMERCIAL and this.m_iOwnerID ~= 0 then
			this.m_pBlip = CBlip( this.m_vecPosition, this.m_pInterior.Blip, 2, 255, 255, 255, 255, 0, 250.0 );
			
			this.m_pBlip:SetInterior( this.m_iInterior );
			this.m_pBlip:SetDimension( this.m_iDimension );
		end
	end;
	
	OnHit	= function( pMarker, pClient )
		if classof( pClient ) == CPlayer and pClient.m_pTeleportMarker == NULL then
			local this = pMarker.m_pProperty;
			
			if pClient:GetInterior() ~= pMarker:GetInterior() or pClient:GetDimension() ~= pMarker:GetDimension() then
				return false;
			end
			
			local aHint = {};
			
			if this:CanUse( pClient ) then
				table.insert( aHint, "F - Войти" );
				
				if this.m_iPrice > 0 then
					table.insert( aHint, "Эта собственность продаётся" );
				end
				
				if this.m_iType == ePropertyType.COMMERCIAL or this.m_iPrice > 0 or ( this.m_iOwnerID == pClient:GetChar():GetID() and this.m_iOwnerType == ePropertyOwner.CHARACTER ) then
					table.insert( aHint, "X - Информация" );
				end
			end
			
			if table.getn( aHint ) > 0 then
				pClient:Hint( "Подсказка", table.concat( aHint, '\n' ), "info" );
			end
			
			pClient.m_pTeleportMarker = this;
		end
		
		return false;
	end;
	
	OnLeave		= function( pMarker, pClient, bMatching )
		pClient.m_pTeleportMarker = NULL;
	end;
	
	CanUse		= function( this, pClient, sMessageType )
		pClient.m_pTeleportMarker = NULL;
		
		local pChar = pClient:GetChar();
		
		if not pChar then
			return false;
		end
		
		local sError = NULL;
		
		if pClient.m_bLowHPAnim then
			sError = "Вы не в состоянии передвигаться";
		end
		
		if pClient:IsCuffed() then
			sError = "Вы не можете перемещаться по зданиям в наручниках";
		end
		
		if this:IsLocked() then
			sError = "Закрыто";
		end
		
		if pClient:IsInVehicle() then
			sError = "Вы не можете войти туда в автомобиле";
		end
		
		if sError then
			if sMessageType == "hint" then
				pClient:Hint( "Ошибка", sError, "error" );
			elseif sMessageType == "chat" then
				pClient:GetChar():Send( sError, 255, 0, 0 );
			end
			
			return false;
		end
		
		return true;
	end;
	
	Use		= function( this, pClient, bForce )
		local pTarget = pClient.m_pTeleportMarker.m_pTarget;
		
		if bForce or this:CanUse( pClient, "hint" ) then
			this:Enter( pTarget, pClient );
		end
	end;
	
	Enter	= function( this, pTarget, pClient )
		if pClient.m_pTeleportTimer then
			return false;
		end
		
		local vecNewPosition	= pTarget:GetPosition():Offset( 1.2, pTarget.Rotation );
		local iNewInterior		= pTarget:GetInterior();
		local iNewDimension		= pTarget:GetDimension();
		local vecNewRotation	= Vector3( 0, 0, pTarget.Rotation );
		
		pClient:SetCollisionsEnabled( false );
		pClient:GetCamera():Fade( false );
		
		pClient.m_pTeleportTimer	= CTimer(
			function()
				if pClient:IsInGame() then
					pClient:SetPosition( vecNewPosition );
					pClient:SetInterior( iNewInterior );
					pClient:SetDimension( iNewDimension );
					
					CElement.SetRotation( pClient, vecNewRotation );
					
					pClient:SetCollisionsEnabled( true );
					
					pClient:GetCamera():SetTarget();
					pClient:GetCamera():Fade( true );
				end
				
				pClient.m_pTeleportTimer = NULL;
			end, 1000, 1
		);
		
		return true;
	end;
	
	OpenMenu	= function( this, pClient, bForce )
		local pChar = pClient and pClient:GetChar() or NULL;
		
		if pChar then
			local bAdmin	= pClient:HaveAccess( "command.interior:edit" );
			local bAccess	= bAdmin or this.m_iOwnerID == pChar:GetID();
			
			local Data		=
			{
				ID			= this.m_iID;
				Interior	= NULL;
				Name		= this.m_sName;
				Type		= this.m_iType;
				Price		= this.m_iPrice;
				Locked		= this.m_bLocked;
				Owner		= NULL;
			};
			
			if this.m_iOwnerID ~= 0 then
				local pResult = NULL;
				
				if this.m_iOwnerType == ePropertyOwner.CHARACTER then
					if pChar:GetID() == this.m_iOwnerID or bAdmin or this.m_iPrice > 0 then
						pResult = g_pDB:Query( "SELECT CONCAT( `name`, ' ', `surname` ) AS `owner` FROM " + DBPREFIX + "characters WHERE `id` = " + this.m_iOwnerID );
						
						if not pResult then
							Debug( g_pDB:Error(), 1 );
						end
						
						local pRow	= pResult:FetchRow();
						
						delete ( pResult );
						
						Data.Owner = pRow.owner;
					end
				elseif this.m_iOwnerType == ePropertyOwner.FACTION then
					local pFaction	= g_pGame:GetFactionManager():Get( this.m_iOwnerID );
					
					if pFaction then
						Data.Owner = pFaction:GetName();
					end
				end
			end
			
			pClient:ShowUI( "CUIPropertyMenu", Data, bForce, bAccess, bAdmin );
			
			return true;
		end
		
		return false;
	end;
};