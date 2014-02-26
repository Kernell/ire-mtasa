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
		this:CElement( pCamera );
		
		this.m_vecCockpit			= Vector3();
		this.m_vecPosition			= Vector3();
		this.m_vecRotation			= Vector3();
		this.m_vecPositionBehind	= Vector3( 0.4, 0.0, 0.7 );
		this.m_vecRotationBehind	= Vector3( 0.0, 0.0, 180.0 );
		
		function this.__DoPulse( iTimeSlice )
			this:DoPulse( iTimeSlice / 1000 );
		end
		
		addEventHandler( "onClientPreRender", root, this.__DoPulse );
	end;
	
	_CClientCamera	= function( this )
		removeEventHandler( "onClientPreRender", root, this.__DoPulse );
		
		this.__DoPulse	= NULL;
		
		this:Detach();
	end;
	
	DoPulse		= function( this, fDeltaTime )
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
				end
			elseif CLIENT:IsInVehicle() then
				this.m_bCockpit = true;
				
				local pVehicle = CLIENT:GetVehicle();
				
				if pVehicle and getVehicleType( pVehicle ) == "Automobile" and pVehicle:GetDriver() == CLIENT then
					CLIENT:SetAnimation( "PED", "car_sit", -1 );
				end
			end
		end
	end;
	
	SetTarget	= function( this, pTarget )
		this:Detach();
		
		setCameraTarget( pTarget or CLIENT );
	end;
};