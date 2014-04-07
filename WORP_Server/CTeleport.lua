-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CTeleport";

function CTeleport:CTeleport( ID, vecPosition1, vecRotation1, iInterior1, iDimension1, vecPosition2, vecRotation2, iInterior2, iDimension2, iFactionID )
	self.m_ID	= ID;
	
	self.m_pMarker1 				= CMarker( vecPosition1 + Vector3( 0, 0, .54 ), "arrow", 1, 255, 255, 0, 128 );
	self.m_pMarker2 				= CMarker( vecPosition2 + Vector3( 0, 0, .54 ), "arrow", 1, 255, 255, 0, 128 );
	
	self.m_pMarker1.m_pTeleport				= self;
	self.m_pMarker1.m_pTarget				= self.m_pMarker2;
	self.m_pMarker1.m_pTarget.m_vecPosition	= vecPosition2:Offset( 1.2, vecRotation2.Z );
	self.m_pMarker1.m_pTarget.m_vecRotation	= vecRotation2;
	self.m_pMarker1.m_pTarget.m_iInterior	= iInterior2;
	self.m_pMarker1.m_pTarget.m_iDimension	= iDimension2;
	
	self.m_pMarker2.m_pTeleport				= self;
	self.m_pMarker2.m_pTarget				= self.m_pMarker1;
	self.m_pMarker2.m_pTarget.m_vecPosition	= vecPosition1:Offset( 1.2, vecRotation1.Z );
	self.m_pMarker2.m_pTarget.m_vecRotation	= vecRotation1;
	self.m_pMarker2.m_pTarget.m_iInterior	= iInterior1;
	self.m_pMarker2.m_pTarget.m_iDimension	= iDimension1;
	
	self.m_iFactionID				= iFactionID;
	
	g_pGame:GetTeleportManager():AddToList( self );
	
	local pFaction			= g_pGame:GetFactionManager():Get( iFactionID );
	
	self.m_pMarker1:SetData			( "CTeleport::DrawLabels", true );
	self.m_pMarker2:SetData			( "CTeleport::DrawLabels", true );
	
	self.m_pMarker1:SetData			( "CTeleport::ID", self:GetID() );
	self.m_pMarker2:SetData			( "CTeleport::ID", self:GetID() );
	
	self.m_pMarker1:SetData			( "CTeleport::FactionName", pFaction and pFaction:GetName() or "NULL" );
	self.m_pMarker2:SetData			( "CTeleport::FactionName", pFaction and pFaction:GetName() or "NULL" );
	
	self.m_pMarker1:SetData			( "CTeleport::FactionID", pFaction and (int)(pFaction:GetID()) or 0 );
	self.m_pMarker2:SetData			( "CTeleport::FactionID", pFaction and (int)(pFaction:GetID()) or 0 );
	
	self.m_pMarker1:SetInterior		( self.m_pMarker2.m_pTarget.m_iInterior );
	self.m_pMarker1:SetDimension	( self.m_pMarker2.m_pTarget.m_iDimension );
	
	self.m_pMarker2:SetInterior		( self.m_pMarker1.m_pTarget.m_iInterior );
	self.m_pMarker2:SetDimension	( self.m_pMarker1.m_pTarget.m_iDimension );
	
	self.m_pMarker1.OnHit	= CTeleport.OnHit;
	self.m_pMarker2.OnHit	= CTeleport.OnHit;
	
	self.m_pMarker1.OnLeave	= CTeleport.OnLeave;
	self.m_pMarker2.OnLeave	= CTeleport.OnLeave;
end

function CTeleport:_CTeleport()
	g_pGame:GetTeleportManager():RemoveFromList( self );
	
	delete ( self.m_pMarker1 );
	delete ( self.m_pMarker2 );
end

function CTeleport:GetID()
	return self.m_ID;
end

function CTeleport:OnHit( pElement, bMatching )
	local this = self.m_pTeleport;
	
	if bMatching and this and getElemenType( pElement ) == "player" and pElement.m_pTeleportMarker == NULL and this:CanUse( pElement ) then
		pElement.m_pTeleportMarker = self;
		
		pElement:Hint( "Подсказка", "F - Войти", "info" );
	end
end

function CTeleport:OnLeave( pElement, bMatching )
	pElement.m_pTeleportMarker = NULL;
end

function CTeleport:CanUse( pClient, sMessageType )
	pClient.m_pTeleportMarker = NULL;
	
	local pChar = pClient:GetChar();
	
	if not pChar then
		return false;
	end
	
	local sError = NULL;
	
	if self.m_iFactionID ~= 0 and not ( pChar:GetFaction() and pChar:GetFaction():GetID() == self.m_iFactionID ) then
		sError = "Вход только для членов организации";
	end
	
	if pClient.m_bLowHPAnim then
		sError = "Вы не в состоянии передвигаться";
	end
	
	if pClient:IsCuffed() then
		sError = "Вы не можете перемещаться по зданиям в наручниках";
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

function CTeleport:Use( pClient, bForce )
	local pTarget = pClient.m_pTeleportMarker.m_pTarget;
	
	if pClient:IsInGame() and ( bForce or self:CanUse( pClient, "hint" ) ) then
		self:Enter( pTarget, pClient );
	end
end

function CTeleport:Enter( pTarget, pPlayer )
	local vecPosition	= pTarget.m_vecPosition;
	local vecRotation	= pTarget.m_vecRotation;
	local iInterior		= pTarget.m_iInterior;
	local iDimension	= pTarget.m_iDimension;
	
	-- pPlayer:ToggleControls( false, true, false );
	pPlayer:SetCollisionsEnabled( false );
	pPlayer:GetCamera():Fade( false );
	pPlayer.m_pTeleportMarker = NULL;
	
	setTimer(
		function()
			pPlayer:SetPosition( vecPosition );
			pPlayer:SetInterior( iInterior );
			pPlayer:SetDimension( iDimension );
			
			CElement.SetRotation( pPlayer, vecRotation );
			
			pPlayer:SetCollisionsEnabled( true );
			-- pPlayer:ToggleControls( true );
			
			setTimer(
				function()
					pPlayer:GetCamera():SetTarget();
					pPlayer:GetCamera():Fade( true );
				end, 500, 1
			);
		end, 1200, 1
	);
end
