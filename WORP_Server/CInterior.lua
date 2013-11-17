-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CInterior
{
	m_iID				= NULL;
	m_sInteriorID		= NULL;
	m_iCharacterID		= 0;
	m_iFactionID		= 0;
	m_iPrice			= 0;
	m_sName				= '';
	m_sType				= INTERIOR_TYPE_NONE;
	m_bLocked			= true;
	m_pBlip				= NULL;
	m_pOutsideMarker	= NULL;
	m_pInsideMarker		= NULL;
	m_p3DText			= NULL;
	m_pColShape			= NULL;
};

function CInterior:CInterior( iID, sInteriorID, iCharacterID, sName, sType, iPrice, bLocked, iFactionID, vecOutsidePosition, fOutsideRotation, Store )
	local pInt = g_pGame:GetInteriorManager():GetInterior( sInteriorID )
	
	if pInt then
		self.m_iID					= iID;
		self.m_sInteriorID			= sInteriorID;
		self.m_iCharacterID			= iCharacterID;
		self.m_sName				= sName;
		self.m_sType				= sType;
		self.m_iPrice				= iPrice;
		self.m_bLocked				= bLocked;
		self.m_iFactionID			= iFactionID;
		self.m_p3DText				= C3DText();
		self.m_pColShape			= pInt.BoundingBox and CColShape( "Cuboid", unpack( pInt.BoundingBox ) ) or NULL;
		self.m_Store				= pInt.Store and Store or NULL;
		
		if self.m_pColShape then
			self.m_pColShape:SetID( "interior:" + self:GetID() );
			self.m_pColShape:SetInterior( pInt.Interior );
			
			if pInt.Position ~= NULL then
				self.m_pColShape:SetDimension( self:GetID() );
			end
			
			self.m_pColShape.m_pInterior = self;
			
			self.m_pColShape.OnHit		= CInterior.OnColShapeHit;
			self.m_pColShape.OnLeave	= CInterior.OnColShapeLeave;
		end
		
		self.m_vecOutsidePosition	= vecOutsidePosition;
		self.m_fOutsideRotation		= fOutsideRotation;
		
		self:UpdateMarker();
		self:Update3DText();
		self:UpdateBlip();
		
		g_pGame:GetInteriorManager():AddToList( self );
	else
		Debug( "Bad interior '" + (string)(sInteriorID) + "'", 2 );
	end
end

function CInterior:_CInterior()
	g_pGame:GetInteriorManager():RemoveFromList( self );
	
	delete ( self.m_p3DText );
	delete ( self.m_pOutsideMarker );
	delete ( self.m_pInsideMarker );
	
	self.m_p3DText			= NULL;
	self.m_pOutsideMarker	= NULL;
	self.m_pInsideMarker	= NULL;
	
	if self.m_pColShape then
		self.m_pColShape:Destroy();
		self.m_pColShape = NULL;
	end
	
	self.m_Store	= NULL;
end

function CInterior:OnColShapeHit( pClient, bMatching )
	if classof( pClient ) == CPlayer and bMatching then
		pClient:SetData( "CInterior::m_pColShape", self );
	end
end

function CInterior:OnColShapeLeave( pClient, bMatching )
	if classof( pClient ) == CPlayer and bMatching then
		pClient:RemoveData( "CInterior::m_pColShape" );
	end
end

function CInterior:GetID()
	return self.m_iID;
end

function CInterior:GetInt()
	return g_pGame:GetInteriorManager():GetInterior( self.m_sInteriorID );
end

function CInterior:GetFaction()
	return g_pGame:GetFactionManager():Get( self.m_iFactionID ) or NULL;
end

function CInterior:GetName()
	return self.m_sName;
end

function CInterior:GetOwner()
	return self.m_iCharacterID;
end

function CInterior:GetType()
	return self.m_sType;
end

function CInterior:GetPrice()
	return self.m_iPrice;
end

function CInterior:IsLocked()
	return self.m_bLocked;
end

function CInterior:SetOwner( pChar )
	local iCharacterID = pChar and pChar:GetID() or 0;
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET character_id = '" + iCharacterID + "' WHERE id = " + self:GetID() ) then
		self.m_iCharacterID = iCharacterID;
		
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CInterior:SetName( sName )
	if g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET name = '" + sName + "' WHERE id = " + self:GetID() ) then
		self.m_sName = sName;
		
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CInterior:SetType( sType )
	if g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET type = '" + sType + "' WHERE id = " + self:GetID() ) then
		self.m_sType = sType;
		
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CInterior:SetLocked( bLocked )
	bLocked = (bool)(bLocked);
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET locked = '" + ( bLocked and 'Yes' or 'No' ) + "' WHERE id = " + self:GetID() ) then
		self.m_bLocked = bLocked;
		
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CInterior:SetFaction( iFactionID )
	if g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET faction_id = " + ( iFactionID or 'NULL' ) + " WHERE id = " + self:GetID() ) then
		self.m_iFactionID = (int)(iFactionID);
		
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CInterior:SetPrice( iPrice )
	if g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET price = " + iPrice + " WHERE id = " + self:GetID() ) then
		self.m_iPrice = iPrice;
		
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CInterior:GetMoney()
	Warning( 2, 8106, "CInterior::GetMoney" );
	
	return 0;
end

function CInterior:SetMoney()
	Warning( 2, 8106, "CInterior::SetMoney" );
	
	return false;
end

function CInterior:GiveMoney()
	Warning( 2, 8106, "CInterior::GiveMoney" );
	
	return false;
end

function CInterior:TakeMoney()
	Warning( 2, 8106, "CInterior::TakeMoney" );
	
	return false;
end

function CInterior:GetSpawn()
	local pInt = self:GetInt();
	
	if pInt then
		return pInt.SpawnPosition, pInt.SpawnRotation;
	end
	
	return NULL;
end

function CInterior:OnHit( pClient, bMatching )
	if classof( pClient ) == CPlayer and pClient.m_pTeleportMarker == NULL then
		if classof( self ) == CPickup then
			if self.m_pInterior:GetOwner() == 0 and self.m_pInterior:GetPrice() > 0 and not pClient:IsInVehicle() then
				self.m_pInterior:OpenMenu( pClient, true );
			end
		elseif bMatching and self.m_pTarget then
			if self.m_pInterior:CanUse( pClient ) then
				pClient:Hint( "Подсказка", self.m_pTarget == self.m_pInterior.m_pInsideMarker and "Нажмите F чтобы войти" or "Нажмите F чтобы выйти", "info" );
			end
			
			pClient.m_pTeleportMarker = self;
		end
	end
	
	return false;
end

function CInterior:OnLeave( pClient, bMatching )
	pClient.m_pTeleportMarker = NULL;
end

function CInterior:CanUse( pClient, sMessageType )
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
	
	if self:IsLocked() then
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
end

function CInterior:Use( pClient, bForce )
	local pTarget = pClient.m_pTeleportMarker.m_pTarget;
	
	if pClient:IsInGame() and ( bForce or self:CanUse( pClient, "hint" ) ) then
		self:Enter( pTarget, pClient );
	end
end

function CInterior:Enter( pTarget, pPlayer )
	local vecNewPosition	= pTarget:GetPosition():Offset( 1.2, pTarget.Rotation );
	local iNewInterior		= pTarget:GetInterior();
	local iNewDimension		= pTarget:GetDimension();
	local vecNewRotation	= Vector3( 0, 0, pTarget.Rotation );
	
	pPlayer:SetCollisionsEnabled( false );
	pPlayer:GetCamera():Fade( false );
	
	setTimer(
		function()
			if pPlayer:IsInGame() then
				pPlayer:SetInterior( iNewInterior );
				pPlayer:SetDimension( iNewDimension );
				pPlayer:SetPosition( vecNewPosition );
				
				CElement.SetRotation( pPlayer, vecNewRotation );
				
				pPlayer:SetCollisionsEnabled( true );
				
				setTimer(
					function()
						pPlayer:GetCamera():SetTarget();
						pPlayer:GetCamera():Fade( true );
					end, 500, 1
				);
			end
		end, 1000, 1
	);
end

function CInterior:Update3DText()
	if self.m_p3DText then
		local Color 	= g_pGame:GetInteriorManager():GetColor( self );
		local sText		= self:GetName() + '\n' + ( self:GetOwner() == 0 and self:GetType() ~= 'interior' and self:GetPrice() > 0 and ( '$' + self:GetPrice() ) or '' );
		
		self.m_p3DText:SetColor( Color[ 1 ], Color[ 2 ], Color[ 3 ] );
		self.m_p3DText:SetText( sText );
		self.m_p3DText:SetPosition( self.m_pOutsideMarker:GetPosition() );
	end
end

function CInterior:UpdateMarker()
	local InteriorData		= g_pGame:GetInteriorManager():GetInterior( self.m_sInteriorID );
	
	if InteriorData then
		local Color 			= g_pGame:GetInteriorManager():GetColor( self );
		
		assert( Color, eInteriorType[ self:GetType() ] );
		
		if self.m_pOutsideMarker then
			delete ( self.m_pOutsideMarker );
			self.m_pOutsideMarker = NULL;
		end
		
		if self.m_pInsideMarker then
			delete ( self.m_pInsideMarker );
			self.m_pInsideMarker = NULL;
		end
		
		if InteriorData.Position == NULL or ( self:GetOwner() == 0 and self:GetType() ~= INTERIOR_TYPE_NONE and self:GetPrice() > 0 ) then
			self.m_pOutsideMarker	= CPickup.Create( self.m_vecOutsidePosition, 3, self:GetType() == INTERIOR_TYPE_COMMERCIAL and 1272 or 1273 );
		else
			self.m_pOutsideMarker	= CMarker.Create( self.m_vecOutsidePosition + Vector3( 0, 0, .54 ), 'arrow', 1, unpack( Color ) );
		end
		
		if InteriorData.Position then
			self.m_pInsideMarker		= CMarker.Create( InteriorData.Position + Vector3( 0, 0, .54 ), 'arrow', 1, unpack( Color ) );
			
			
			self.m_pInsideMarker.Rotation		= InteriorData.Rotation;
			self.m_pInsideMarker:SetInterior	( InteriorData.Interior );
			self.m_pInsideMarker:SetDimension	( InteriorData.Dimension or self:GetID() );
			self.m_pInsideMarker.m_pTarget		= self.m_pOutsideMarker;
			self.m_pInsideMarker.m_pInterior	= self;
			self.m_pInsideMarker.OnHit			= CInterior.OnHit;
			self.m_pInsideMarker.OnLeave		= CInterior.OnLeave;
		end
		
		self.m_pOutsideMarker.Rotation		= self.m_fOutsideRotation;		
		self.m_pOutsideMarker.m_pTarget		= self.m_pInsideMarker;
		self.m_pOutsideMarker.m_pInterior	= self;
		self.m_pOutsideMarker.OnHit			= CInterior.OnHit;
		self.m_pOutsideMarker.OnLeave		= CInterior.OnLeave;
	else
		Debug( "Invalid interior '" + (string)( self.m_sInteriorID ) + "'", 2 );
	end
end

function CInterior:UpdateBlip()
	local InteriorData		= g_pGame:GetInteriorManager():GetInterior( self.m_sInteriorID );
	
	if InteriorData then
		if InteriorData.Blip and ( self:GetPrice() == 0 or self:GetOwner() ~= 0 or self:GetType() == 'interior' ) then
			if self.m_pBlip then
				delete ( self.m_pBlip );
				self.m_pBlip = NULL;
			end
			
			self.m_pBlip = CBlip( self.m_pOutsideMarker:GetPosition(), InteriorData.Blip, 2, 255, 255, 255, 255, 0, 250.0 );
			
			self.m_pBlip:SetParent( self.m_pOutsideMarker );
		end
	else
		Debug( "Invalid interior '" + (string)(self.m_sInteriorID) + "'", 2 );
	end
end

function CInterior:OpenMenu( pPlayer, bForce )
	if pPlayer and pPlayer:IsInGame() then
		local pResult = g_pDB:Query( "SELECT name, surname FROM " + DBPREFIX + "characters WHERE id = " + self:GetOwner() );
		
		if pResult then
			local pFaction	= g_pGame:GetFactionManager():Get( self.m_iFactionID );
			local bAdmin	= pPlayer:HaveAccess( "command.interior:edit" );
			local bAccess	= bAdmin or self:GetOwner() == pPlayer:GetChar():GetID();
			local pRow		= pResult:FetchRow();

			delete ( pResult );
			
			local Data		=
			{
				ID			= self:GetID();
				Interior	= self.m_sInteriorID;
				Name		= self:GetName();
				Type		= self:GetType();
				Price		= self:GetPrice();
				Locked		= self:IsLocked();
				Owner		= ( bAccess or self:GetType() ~= "house" ) and ( pRow and ( pRow.name + " " + pRow.surname ) or "N/A" ) or NULL;
				OwnerID		= self.m_iCharacterID;
				Faction		= pFaction and pFaction:GetName() or "N/A";
				FactionID	= pFaction and pFaction:GetID() or 0;
				Store		= bAccess and self.m_Store;
			};			
			
			pPlayer:GetChar():ShowUI( "CUIPropertyMenu", Data, bForce, bAccess, bAdmin );
			
			return true;
		end
		
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end

function CInterior:IsElementInside( pElement )
	return self.m_pColShape and pElement:IsWithinColShape( self.m_pColShape );
end
