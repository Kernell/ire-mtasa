-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CClientCamera ( CElement )
{
	m_bCockpit					= false;
	m_vecCockpit				= NULL;
	m_vecPosition				= NULL;
	m_vecRotation				= NULL;
	m_vecPositionBehind			= NULL;
	m_vecRotationBehind			= NULL;
	m_fCockpitTime				= 0.6;
	m_fCockpitReleaseTime		= 0.3;
	
	CClientCamera	= function( this, pCamera )
		pCamera( this );
		
		this.m_vecCockpit			= Vector3();
		this.m_vecPosition			= Vector3();
		this.m_vecRotation			= Vector3();
		this.m_vecPositionBehind	= Vector3( 0.4, 0.0, 0.7 );
		this.m_vecRotationBehind	= Vector3( 0.0, 0.0, 180.0 );
		
		root:AddEvent( "onClientPreRender", 		this.DoPulse, 				pCamera );
		root:AddEvent( "onClientVehicleEnter", 		this.OnVehicleEnter, 		pCamera );
		root:AddEvent( "onClientVehicleExit", 		this.OnVehicleExit, 		pCamera );
		
		return pCamera;
	end;
	
	_CClientCamera	= function( this )
		root:RemoveEvent( "onClientPreRender",			this.DoPulse );
		root:RemoveEvent( "onClientVehicleEnter", 		this.OnVehicleEnter );
		root:RemoveEvent( "onClientVehicleExit", 		this.OnVehicleExit );
		
		this:Detach();
	end;
	
	OnVehicleEnter	= function( this, pPlayer, iSeat )
		if pPlayer == CLIENT then
			if CCamera.m_iCameraMode == 6 then
				this.m_bCockpit	= false;
				
				CLIENT:SetAlpha( 0 );
			end
		end
	end;
	
	OnVehicleExit	= function( this, pPlayer, iSeat )
		if pPlayer == CLIENT then
			if CCamera.m_iCameraMode == 6 then
				this.m_bCockpit	= false;
				
				CLIENT:SetAlpha( 255 );
				
				this:SetTarget();
			end
		end
	end;
	
	DoPulse		= function( this, iTimeSlice )
		local fDeltaTime = iTimeSlice / 1000;
		
		if CCamera.m_iCameraMode == 6 then
			if this.m_bCockpit then
				if CLIENT:IsInVehicle() then
					local bKeyLookLeft		= getControlState( "vehicle_look_left" );
					local bKeyLookRight		= getControlState( "vehicle_look_right" );
						
					if not getKeyState( "mouse1" ) then
						local fCockpitX = 0.0;
						
						if bKeyLookLeft then
							fCockpitX = fCockpitX - 1.0;
						end
						
						if bKeyLookRight then
							fCockpitX = fCockpitX + 1.0;
						end
						
						if fCockpitX < this.m_vecCockpit.X then
							local fCockpitXSpeed	= 1.0 / ( this.m_vecCockpit.X > 0.0 and this.m_fCockpitReleaseTime or this.m_fCockpitTime );
							
							this.m_vecCockpit.X		= this.m_vecCockpit.X - ( fCockpitXSpeed * fDeltaTime );
							
							if this.m_vecCockpit.X < fCockpitX then
								this.m_vecCockpit.X = fCockpitX;
							end
						elseif fCockpitX > this.m_vecCockpit.X then
							local fCockpitXSpeed	= 1.0 / ( this.m_vecCockpit.X < 0.0 and this.m_fCockpitReleaseTime or this.m_fCockpitTime );
							
							this.m_vecCockpit.X		= this.m_vecCockpit.X + ( fCockpitXSpeed * fDeltaTime );
							
							if this.m_vecCockpit.X > fCockpitX then
								this.m_vecCockpit.X = fCockpitX;
							end
						end
					end
					
					this.m_vecRotation.X	= -this.m_vecCockpit.Z * 30.0;
					this.m_vecRotation.Z	= -this.m_vecCockpit.X * 80.0;
					
					if bKeyLookLeft and bKeyLookRight then
						this:SetAttachedOffsets( this.m_vecPositionBehind, this.m_vecRotationBehind );
					else
						this:SetAttachedOffsets( this.m_vecPosition, this.m_vecRotation );
					end
				else
					this.m_bCockpit = false;
					
					this:SetTarget();
					
					CLIENT:SetAlpha( 255 );
				end
			elseif CLIENT:IsInVehicle() then
				this.m_bCockpit = true;
				
				CLIENT:SetAlpha( 0 );
				
				setAnalogControlState( "vehicle_right", 0.0 );
				setAnalogControlState( "vehicle_left", 0.0 );
				
				this.m_vecPosition	= CLIENT:GetBonePosition( 6 ) - CLIENT:GetPosition();
				
				this.m_vecPosition.Y	= -0.2;
				this.m_vecPosition.X	= 0.0;
				
				this:AttachTo( CLIENT, this.m_vecPosition );
			end
		end
	end;
	
	SetTarget	= function( this, pTarget )
		this:Detach();
		
		setCameraTarget( pTarget or CLIENT );
	end;
};