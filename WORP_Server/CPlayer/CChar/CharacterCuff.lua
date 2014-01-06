-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

function CPlayer:UpdateCuff()
	if self:IsCuffed() and not self.m_bLowHPAnim then
		local pPlayer = self:GetCuffedTo();
		
		if pPlayer and pPlayer:IsInGame() then
			if pPlayer:IsDead() then
				self:SetCuffed();
				
				return true;
			end
			
			local fDistance = self:GetPosition():Distance( pPlayer:GetPosition() );
			
			local bPlayerMoved = pPlayer:GetControlState( 'forwards' ) or pPlayer:GetControlState( 'backwards' ) or pPlayer:GetControlState( 'left' ) or pPlayer:GetControlState( 'right' );
			
			if fDistance > 30 then
				if self:IsInVehicle() then
					self:RemoveFromVehicle();
				end
				
				self:SetPosition( pPlayer:GetPosition():Offset( 1.4, pPlayer:GetRotation() ) );
				self:SetRotation( pPlayer:GetRotation() );
				self:SetInterior( pPlayer:GetInterior() );
				self:SetDimension( pPlayer:GetDimension() );
			end
			
			if not pPlayer:IsInVehicle() and self:IsInVehicle() then
				self.m_bForceExitVehicle	= true;
				self:SetControlState( 'enter_exit', true );
			end
			
			if self:GetControlState( 'enter_exit' ) then
				self:SetControlState( 'enter_exit', false );
				self.m_bForceExitVehicle	= false;
			end
			
			if pPlayer:IsInVehicle() and self:GetVehicle() ~= pPlayer:GetVehicle() then
				local pVehicle = pPlayer:GetVehicle();
				
				if pVehicle and not pVehicle:IsLocked() then
					fDistance = pVehicle:GetPosition():Distance( self:GetPosition() );
					
					if fDistance < 4 then
						for iSeat = pVehicle:GetMaxPassengers(), 1, -1 do
							if not pVehicle:GetOccupant( iSeat ) then
								self:WarpInVehicle( pVehicle, iSeat );
								
								break;
							end
						end
					end
				end
			end
			
			if not self:IsInVehicle() then
				if fDistance > 7 or ( bPlayerMoved and pPlayer:GetControlState( 'sprint' ) ) then
					self:SetAnimation( CPlayerAnimation.PRIORITY_CUFFS, "PED", "SPRINT_civi" );
				elseif fDistance > 4 or ( bPlayerMoved and not pPlayer:GetControlState( 'walk' ) ) then
					self:SetAnimation( CPlayerAnimation.PRIORITY_CUFFS, "PED", "RUN_player" );
				elseif fDistance > 1 or ( bPlayerMoved ) then
					self:SetAnimation( CPlayerAnimation.PRIORITY_CUFFS, "PED", "WALK_player" );
				else
					self:SetAnimation( CPlayerAnimation.PRIORITY_CUFFS, "PED", "IDLE_stance" );
				end
			end
		elseif not self:IsInVehicle() then
			self:SetAnimation( CPlayerAnimation.PRIORITY_CUFFS, "PED", "IDLE_stance" );
		end
	end
end

function CPlayer:IsTied()
	return (bool)(self.m_bTied);
end

function CPlayer:IsCuffed()
	return (bool)(self.m_bCuffed);
end

function CPlayer:SetCuffed( bCuffed, pPlayer )
	if self:IsInGame() then
		self.m_bCuffed			= (bool)(bCuffed);
		self.m_pCuffedTo		= pPlayer and pPlayer:IsInGame() and pPlayer or NULL;
		
		if self.m_bCuffed then
			self:Client().UpdateCuffed( self.m_pCuffedTo and self.m_pCuffedTo.__instance );
			
			if not self:IsInVehicle() and not self.m_bLowHPAnim then
				self:SetAnimation( CPlayerAnimation.PRIORITY_CUFFS, "PED", "IDLE_stance" );
			end
		elseif not self.m_bLowHPAnim then
			self:SetAnimation( CPlayerAnimation.PRIORITY_CUFFS );
			self:Client().UpdateCuffed();
		end
		
		return true;
	end
	
	return false;
end

function CPlayer:GetCuffed()
	return (bool)(self.m_bCuffed), self.m_pCuffedTo;
end

function CPlayer:GetCuffedTo()
	return self.m_pCuffedTo;
end