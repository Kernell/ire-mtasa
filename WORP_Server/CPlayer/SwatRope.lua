-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local swat_ropes = {};

function CPlayer:AttachToSWATRope( swat_rope )
	if swat_rope then
		if self:IsInVehicle() then
			if self:GetVehicleSeat() == 0 then
				return false;
			end
			
			self:RemoveFromVehicle();
		end
		
		self:SetPosition( swat_rope + Vector3( 0, 0, -1 ) );
		self:SetAnimation( CPlayerAnimation.PRIORITY_SWATROPE, "PED", "abseil", -1, false, true, false, true );
		self:SetGravity( 0.001 );
		self:SetVelocity( Vector3( 0, 0, -.1 ) );
		
		return true;
	end
	
	return false;
end

function CClientRPC:DetachFromSWATRope( is_ground )
	if is_ground then
		self:SetVelocity( Vector3( 0, 0, 0 ) );
		
		self:SetAnimation( CPlayerAnimation.PRIORITY_SWATROPE, "PED", "FALL_land", -1, false, true, false, false );
	else
		self:SetAnimation( CPlayerAnimation.PRIORITY_SWATROPE );
	end

	self:SetGravity( 0.008 );
end

function CClientRPC:SWATRopeResult( fGroundZ )
	local pVehicle = self:GetVehicle();
		
	if pVehicle and pVehicle:GetModel() == 497 then
		if self:GetVehicleSeat() > 0 then
			if pVehicle:IsLocked() then
				self:Hint( "Ошибка", "Двери заблокированы", "error" );
			elseif self:IsCuffed() then
				self:Hint( "Ошибка", "Вы в наручниках", "error" );
			else
				if self.swat_rope and self.swat_rope.time - getTickCount() > 0 then
					return;
				else
					local vecPosition = pVehicle:GetPosition();
					
					local fDistance = Vector3( vecPosition.X, vecPosition.Y, fGroundZ ):Distance( vecPosition );
					
					if fDistance < 10 then
						self:Hint( "Ошибка", "Слишком низко", "error" );
						
						return;
					end
					
					if fDistance > 30 then
						self:Hint( "Ошибка", "Слишком высоко", "error" );
						
						return;
					end
					
					local fSpeed = pVehicle:GetSpeed();
					
					if fSpeed > 5 then
						self:Hint( "Ошибка", "Слишком большая скорость", "error" );
						
						return;
					end
					
					local iTime = math.min( math.floor( fDistance * 250 ), 9000 );
					local iSeat = self:GetVehicleSeat();
					
					pVehicle:SetFrozen( true );
					
					local pos = pVehicle:GetPosition();
					local rot = pVehicle:GetRotation();
					
					local vecRope = pos:Offset( iSeat == 1 and 1.45 or .3, rot.Z + ( iSeat == 1 and 0 or -180 ) ):Offset( 1.3, rot.Z + ( iSeat == 2 and 90 or -90 ) );
					
					table.insert( swat_ropes, vecRope );
					
					vecRope.time	= getTickCount() + iTime;
					
					self.swat_rope	= vecRope;
					
					triggerClientEvent( root, "CreateSWATRope", self.__instance, self.swat_rope.X, self.swat_rope.Y, self.swat_rope.Z, time );
					
					self:SetControlState( 'enter_exit', true );
					
					setTimer(
						function()
							self:SetControlState( 'enter_exit', false );
						end, 500, 1
					);
					
					if not pVehicle.swat_ropes then
						pVehicle.swat_ropes = {};
					end
					
					pVehicle.swat_ropes[ vecRope ] = true;
					
					setTimer( 
						function() 
							pVehicle.swat_ropes[ vecRope ] = NULL;
							
							if sizeof( pVehicle.swat_ropes ) == 0 then							
								pVehicle:SetFrozen( false );
							end
						end, iTime, 1 
					);
				end
			end
		else
			self:Hint( "Ошибка", "Вы должны быть на пассажирском месте", "error" );
		end
	else
		self:Hint( "Ошибка", "Вы должны быть в полицейском вертолёте", "error" );
	end
end

addEventHandler( "onPlayerJoin", root, 
	function()
		for index, swat_rope in ipairs( swat_ropes ) do
			if swat_rope.time - getTickCount() > 0 then
				triggerClientEvent( source, "CreateSWATRope", root, swat_rope.X, swat_rope.Y, swat_rope.Z, swat_rope.time - getTickCount() );
			else
				table.remove( swat_ropes, index );
			end
		end
	end
);