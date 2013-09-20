-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0 

local HOSPITAL_RESPAWN		= Vector3( 2035.4779052734, -1413.8355712891, 16.99 );
local ARMY_RESPAWN			= Vector3( -1291.690, 490.630, 11.195 );
local PRISON_RESPAWN		= Vector3( 2521.7, -6313.47, 17.44 );

function CClientRPC:Respawn()
	if self:IsDead() then
		self:GetCamera():Fade( false );
		
		setTimer( CPlayer.PreSpawn, 1000, 1, self );
	end
end

function CPlayer:GetSpawnCoords()
	local pChar = self:GetChar();
	
	if pChar then
		local sJail = pChar:GetJailed();
		
		if sJail ~= "No" then
			local vecPositon, iInterior, iDimension = self:GetNearbyJail( 'Inside', sJail );
			
			return vecPosition, 0, iInterior, iDimension;
		end
		
		if self:GetPosition():Distance( PRISON_RESPAWN ) < 2000.0 then
			return PRISON_RESPAWN, 0, 0;
		end
		
		local pFaction = pChar:GetFaction();
		
		if pChar.m_iSpawnInterior and pChar.m_iSpawnInterior ~= 0 then
			local pInterior = g_pGame:GetInteriorManager():Get( pChar.m_iSpawnInterior );
			
			if pInterior and pInterior.m_pInsideMarker then
				if pInterior:GetOwner() == pChar:GetID() or ( pFaction and pInterior:GetFaction() == pFaction ) then
					local vecPosition, fRotation = pInterior:GetSpawn();
					
					if vecPosition then
						return vecPosition, fRotation, pInterior.m_pInsideMarker:GetInterior(), pInterior.m_pInsideMarker:GetDimension();
					end
				end
			end
			
			pChar:SetSpawn( NULL );
		end
	end
	
	return HOSPITAL_RESPAWN, 130, 0, 0;
end

function CPlayer:PreSpawn()
	local pChar = self:GetChar();
	
	if pChar then
		local sJail, iTime = pChar:GetJailed();
		
		if sJail ~= 'No' then
			pChar:SetJailed( sJail, iTime );
		else
			local bSpawned = false;
			
			if self:GetPosition():Distance( PRISON_RESPAWN ) < 2000.0 then
				self:Spawn( PRISON_RESPAWN, 0, self:GetModel(), 0, 0, t_logged_in );
				
				bSpawned = true;
			end
			
			local pFaction = pChar:GetFaction();
			
			if not bSpawned and pChar.m_iSpawnInterior and pChar.m_iSpawnInterior ~= 0 then
				local pInterior = g_pGame:GetInteriorManager():Get( pChar.m_iSpawnInterior );
				
				if pInterior and pInterior.m_pInsideMarker then
					if pInterior:GetOwner() == pChar:GetID() or ( pFaction and pInterior:GetFaction() == pFaction ) then
						local vecPosition, fRotation = pInterior:GetSpawn()
						
						if vecPosition then
							self:Spawn( vecPosition, fRotation, self:GetModel(), pInterior.m_pInsideMarker:GetInterior(), pInterior.m_pInsideMarker:GetDimension(), t_logged_in );
							
							bSpawned = true;
						end
					end
				end
				
				if not bSpawned then
					pChar:SetSpawn( NULL );
				end
			end
			
			if not bSpawned then
				self:Spawn( HOSPITAL_RESPAWN, 130, self:GetModel(), 0, 0, t_logged_in );
			end
		end
		
		if pChar:GetAlcohol() > 0 then
			pChar:SetAlcohol();
			
			CCommands:DropDrink( self );
		end
		
		if pChar.m_iSpawnInterior == NULL then
			CCommands:ChangeSpawn( self );
		end
	end
end

function CPlayer:OnSpawn( fX, fY, fZ, fRotation, pTeam, iSkin, iInterior, iDimension )
	self:TakeAllWeapons();
	
	if self:IsInGame() then
		self:SetControlState( 'walk', true );
		
		self:SetAnimation();
		self:GetCamera():SetTarget();
		self:GetCamera():Fade( true );
		
		self.m_pCharacter:SetPower( 100 );
		self:SetCuffed();
	end
	
	self:SetWalkingStyle( 0 );
	self:SetWalkingStyle( (int)(self:GetSkin().GetWalkingStyle()) );
end

function CPlayer:OnWasted( iTotalAmmo, pKiller, iKillerWeapon, iBodypart, bStealth )
	local pChar = self:GetChar();
	
	if pChar then
		g_pGame:GetEventManager():Call( EVENT_TYPE_DEATH, self );
		
		pChar:SelectWeaponSlot( pChar.m_iCurrentWeapon, true );
		
		CCommands:PhoneHangup( self );
		
		self.m_bLowHPAnim = false;
		
		self:EndCurrentJob();
		
		self:Client().OnClientWasted( iTotalAmmo, pKiller, iKillerWeapon, iBodypart, bStealth );
		
		if self.m_pVehicle then
			self.m_pVehicle:OnExit( self, self:GetVehicleSeat() );
		end
	end
end

addEventHandler( "onPlayerWasted", root, function( ... ) CPlayer.OnWasted( source, ... ); end );
addEventHandler( "onPlayerSpawn", root, function( ... ) CPlayer.OnSpawn( source, ... ); end );
