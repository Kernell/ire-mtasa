-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local TJobCarrier	= CJob( 'carrier', 101, 'Дальнобойщик', 'дальнобойщиком', Vector3( 2179.52, -2263.52, 14.77 ) );

local OnMarkerHit;

function TJobCarrier:Init( pPlayer )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		if pChar:GetLicense( 'vehicle' ) then
			local pVehicle = pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
			
			if pVehicle then
				local pResult	= g_pDB:Query( "SELECT name, dropoff_x, dropoff_y, dropoff_z FROM " + DBPREFIX + "interiors WHERE dropoff_x != 0 AND dropoff_y != 0 ORDER BY RAND() LIMIT 1" );
				
				if not pResult then
					Debug( g_pDB:Error(), 1 );
					
					return;
				end
				
				local pRow	= pResult:FetchRow();
				
				delete ( pResult );
				
				if pRow then
					local vecPosition	= Vector3( pRow.dropoff_x, pRow.dropoff_y, pRow.dropoff_z );
					local pMarker		= CMarker.Create( vecPosition, "checkpoint", 3.0, 0, 255, 255, 255, pPlayer.__instance );
					local pBlip			= CBlip( pMarker, 0, 2.0, 0, 255, 255, 255, 0, 9999.0, pPlayer.__instance );
					local pColShape		= CColShape( "Tube",  vecPosition.X, vecPosition.Y, vecPosition.Z - 10.0, 9.0, 20.0 );
					
					pPlayer:Hint( "Работа: " + self:GetName(), "Следующее место выгрузки: " + pRow.name + " (" + GetZoneName( vecPosition ) + ")", "ok" );
					
					pBlip:SetParent( pMarker );
					pColShape:SetParent( pMarker );
					
					pMarker.m_pColShape = pColShape;
					pColShape.m_pMarker = pMarker;
					
					pPlayer.m_pJob = pMarker;
					
					pColShape.OnHit = OnMarkerHit;
				else
					Debug( "cannot find any drop-off", 2 );
				end
			else
				if _DEBUG then Debug( "DEBUG: " + pPlayer:GetName() + " not driving any vehicle", 0, 0, 128, 255 ) end
			end
		else
			pPlayer:Hint( "Работа: " + self:GetName(), "\nУ Вас нет водительских прав чтобы работать " + self:GetName2(), "error" );
		end
	end
end

function TJobCarrier:CheckRequirements( pPlayer )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		if pChar:GetLicense( 'vehicle' ) then
			return true;
		else
			pPlayer:Hint( "Работа: " + self:GetName(), "\nУ Вас нет водительских прав чтобы работать " + self:GetName2(), "error" );
		end
	end
	
	return false;
end

function OnMarkerHit( pMarker, pPlayer, bMatching )
	if bMatching and classname( pPlayer ) == "CPlayer" then
		local pChar = pPlayer:GetChar();
		
		if not pChar then
			pPlayer:EndCurrentJob();
			
			return;
		end
		
		if pChar:GetJob() ~= TJobCarrier then
			return;
		end
		
		local pVehicle = pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
		
		if not pVehicle or pVehicle:GetJob() ~= TJobCarrier then
			pPlayer:EndCurrentJob();
			
			return;
		end
		
		pPlayer:Client().JobWaitTimer( pMarker.__instance, 30000 - ( pChar:GetJobSkill() * 20 ), 'TJobCarrierComplete' );
	end
end

function CClientRPC:TJobCarrierComplete()
	if self:IsInGame() then
		local pChar = self:GetChar();
		
		if pChar then
			local pVehicle = self:GetVehicle();
			
			if pVehicle:type() == 'vehicle' and pVehicle:GetJob() == TJobCarrier then
				pChar:SetJobSkill( math.min( 1000, pChar:GetJobSkill() + 1 ) );
				pChar:GivePay( 70 );
				
				self.m_pJob:Destroy();
				self.m_pJob = nil;
				
				self:Hint( "Работа: " + TJobCarrier:GetName(), "Разгрузка грузовика завершена\n\nВаш навык работы: " + pChar:GetJobSkill(), "ok" );
				self:PlaySoundFrontEnd( 10 );
				
				setTimer(
					function()
						local pChar = self:GetChar();
						
						if pChar then
							self:InitJob( pChar:GetJob() );
						end
					end,
					5000, 1
				);
			end
		else
			if _DEBUG then Debug( "DEBUG: " + self:GetName() + " invalid character", 0, 0, 128, 255 ) end
		end
	else
		if _DEBUG then Debug( "DEBUG: " + self:GetName() + " not in game", 0, 0, 128, 255 ) end
	end
end