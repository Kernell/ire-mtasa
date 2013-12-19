-- Author:      	Kernell
-- Version:     	1.0.0

local SyncControls	=
{
-- ON FOOT
	'fire'; 					-- Fire a player's weapon 
	'next_weapon'; 				-- Switch to the next weapon 
	'previous_weapon'; 			-- Switch to the previous weapon 
	'forwards'; 				-- Move forwards 
	'backwards'; 				-- Move backwards 
	'left'; 					-- Move left 
	'right'; 					-- Move right 
--	'zoom_in'; 					-- Zoom targeted weapon in (sniper/rocket launcher/camera etc) 
--	'zoom_out'; 				-- Zoom targeted weapon out 
--	'change_camera'; 			-- Change camera mode 
	'jump'; 					-- Make the player jump 
	'sprint'; 					-- Make the player sprint 
--	'look_behind'; 				-- Make the player look behind (and allow the player to see behind them) 
	'crouch'; 					-- Make the player crouch/duck 
	'action'; 					-- Show the stats menu 
	'walk'; 					-- Make the player move slowly/quietly 
	'aim_weapon'; 				-- Aim the player's current weapon (if possible) 
--	'conversation_yes'; 		-- Answer yes to a question 
--	'conversation_no'; 			-- Answer no to a question 
--	'group_control_forwards';	-- Make the group you are controlling move forwards 
--	'group_control_back'; 		-- Make the group you are controlling move backwards 
--	'enter_exit'; 				-- Make the player enter a vehicle. Also used for alternative fighting styles. 

-- IN VEHICLE
	'vehicle_fire'; 			-- Fire the player's vehicle's primary weapon (e.g. hunter's missiles) or shoot with driveby 
	'vehicle_secondary_fire'; 	-- Fire the player's vehicle's secondary weapon (e.g. hunter's minigun) 
	'vehicle_left'; 			-- Make the player's vehicle turn left 
	'vehicle_right'; 			-- Make the player's vehicle turn right 
	'steer_forward'; 			-- Make the player's vehicle turn down (lean forwards for helicopters/planes) 
	'steer_back'; 				-- Make the player's vehicle turn up (lean backwards for helicopters/planes) 
	'accelerate'; 				-- Make the player's vehicle accelerate 
	'brake_reverse'; 			-- Make the player's brake (slow down) and if stationary reverse 
--	'radio_next'; 				-- Change to the next radio station 
--	'radio_previous'; 			-- Change to the previous radio station 
--	'radio_user_track_skip';	-- Skip the current track being played on the custom radio station 
	'horn';						-- Play the horn of the player's vehicle (if the vehicle has a horn) and can trigger the siren on emergency vehicles 
	'sub_mission'; 				-- Start a submission if one is avaliable (e.g. taxi missions) 
	'handbrake'; 				-- Apply the handbrake on the player's vehicle 
	'vehicle_look_left'; 		-- Look to the left 
	'vehicle_look_right'; 		-- Look to the right 
--	'vehicle_look_behind'; 		-- Look behind 
--	'vehicle_mouse_look'; 		-- 
	'special_control_left'; 	-- Move the some special vehicle component left (e.g. tank's turret) 
	'special_control_right'; 	-- Move the some special vehicle component right (e.g. tank's turret) 
	'special_control_down'; 	-- Move the some special vehicle component down (e.g. tank's turret) 
	'special_control_up'; 		-- Move the some special vehicle component up (e.g. tank's turret) 
--	'enter_exit'; 				-- Make the player exit a vehicle 
};

class "CCutScene";

function CCutScene:CCutScene( pCutScene, ID )
	if type( pCutScene ) == 'table' then
		self.m_ID 		= ID;
		self.m_Records	= {};
		
		setTimer(
			function()
				for i, pRecord in ipairs( pCutScene ) do
					self.m_Records[ i ]					= {};
					
					self.m_Records[ i ].m_Frames 		= pRecord.Frames;
					self.m_Records[ i ].m_vecTargetP	= Vector3( pRecord.Frames[ 1 ][ 1 ], pRecord.Frames[ 1 ][ 2 ], pRecord.Frames[ 1 ][ 3 ] );
					self.m_Records[ i ].m_vecTargetR	= Vector3( pRecord.Frames[ 1 ][ 4 ], pRecord.Frames[ 1 ][ 5 ], pRecord.Frames[ 1 ][ 6 ] );
					self.m_Records[ i ].m_pPed			= CPed.Create( pRecord.Ped or CLIENT:GetModel(), self.m_Records[ i ].m_vecTargetP, self.m_Records[ i ].m_vecTargetR );
					
					if pRecord.Vehicle then
						local pVehicle = createVehicle( pRecord.Vehicle,
							self.m_Records[ i ].m_vecTargetP.X, self.m_Records[ i ].m_vecTargetP.Y, self.m_Records[ i ].m_vecTargetP.Z,
							self.m_Records[ i ].m_vecTargetR.X, self.m_Records[ i ].m_vecTargetR.Y, self.m_Records[ i ].m_vecTargetR.Z
						);
						
						if pVehicle then
							self.m_Records[ i ].m_pPed:WarpIntoVehicle( pVehicle, pRecord.VehicleSeat );
							
							pVehicle:SetParent( self.m_Records[ i ].m_pPed );
						end
					end
				end
				
				self.m_iFrame	= 1;
				self.m_pCam		= pCutScene.Camera;
					
				if self.m_pCam and self.m_pCam[ 1 ] then
					if self.m_pCam[ 1 ][ 1 ] then
						setCameraMatrix( unpack( self.m_pCam[ 1 ][ 1 ] ) );
					end
					
					if self.m_pCam[ 1 ][ 2 ] then
						MoveCamera( unpack( self.m_pCam[ 1 ][ 2 ] ) );
					end
					
					if self.m_pCam[ 1 ][ 3 ] then
						RotateCamera( unpack( self.m_pCam[ 1 ][ 3 ] ) );
					end
				end
				
				self.m_pDoPulseTimer	= setTimer(
					function()
						CCutScene.DoPulse( self );
					end,
					50, 0
				);
				
				self.Render	= function( timeSlice )
					for _, pRecord in pairs( self.m_Records ) do
						local pVehicle = pRecord.m_pPed and pRecord.m_pPed:GetVehicle();
				
						if pVehicle and pVehicle:GetHealth() > 50 then
							local fX, fY, fZ 		= getElementPosition( pVehicle );
							local fRX, fRY, fRZ 	= getElementRotation( pVehicle );
							
							fX		= fX + ( pRecord.m_vecTargetP.X - fX ) * .1;
							fY		= fY + ( pRecord.m_vecTargetP.Y - fY ) * .1;
							fZ		= fZ + ( pRecord.m_vecTargetP.Z - fZ ) * .1;
							
							fRX		= fRX + math.sin( math.rad( pRecord.m_vecTargetR.X - fRX ) ) * ( timeSlice * .5 );
							fRY		= fRY + math.sin( math.rad( pRecord.m_vecTargetR.Y - fRY ) ) * ( timeSlice * .5 );
							fRZ		= fRZ + math.sin( math.rad( pRecord.m_vecTargetR.Z - fRZ ) ) * ( timeSlice * .5 );
							
							setElementPosition( pVehicle, fX, fY, fZ );
							setElementRotation( pVehicle, fRX, fRY, fRZ );
						end
					end
				end
				
				addEventHandler( 'onClientPreRender', root, self.Render );
				
				fadeCamera( true );
			end,
			1100, 1
		);
	else
		delete ( self );
	end
end

function CCutScene:_CCutScene()
	removeEventHandler( 'onClientPreRender', root, self.Render );
	
	delete ( self.m_pDoPulseTimer );
	
	for i, pRec in pairs( self.m_Records ) do
		delete ( pRec.m_pPed );
		pRec.m_pPed = NULL;
	end
	
	SERVER._CCutScene( self.m_ID );
end

function CCutScene:DoPulse()
	local End = true;
	
	self.m_iFrame = self.m_iFrame + 1;
			
	if self.m_pCam and self.m_pCam[ self.m_iFrame ] then
		if self.m_pCam[ self.m_iFrame ][ 1 ] then
			setCameraMatrix( unpack( self.m_pCam[ self.m_iFrame ][ 1 ] ) );
		end
		
		if self.m_pCam[ self.m_iFrame ][ 2 ] then
			MoveCamera( unpack( self.m_pCam[ self.m_iFrame ][ 2 ] ) );
		end
		
		if self.m_pCam[ self.m_iFrame ][ 3 ] then
			RotateCamera( unpack( self.m_pCam[ self.m_iFrame ][ 3 ] ) );
		end
	end
	
	for i, pRecord in ipairs( self.m_Records ) do
		local Frame		= pRecord.m_Frames[ self.m_iFrame ];
		
		if Frame then
			End = false;
			
			if pRecord.m_pPed:GetHealth() > 0 then
				pRecord.m_vecTargetP.X	= Frame[ 1 ];
				pRecord.m_vecTargetP.Y	= Frame[ 2 ];
				pRecord.m_vecTargetP.Z	= Frame[ 3 ];
				
				pRecord.m_vecTargetR.X	= Frame[ 4 ];
				pRecord.m_vecTargetR.Y	= Frame[ 5 ];
				pRecord.m_vecTargetR.Z	= Frame[ 6 ];
				
				local pVehicle = pRecord.m_pPed:GetVehicle();
				
				if pVehicle and pVehicle:GetHealth() > 50 then
					if (bool)(Frame[ 7 ]) ~= getVehicleLandingGearDown( pVehicle ) then
						setVehicleLandingGearDown( pVehicle, (bool)(Frame[ 7 ]) );
					end
				end
				
				-- ( pVehicle or pRecord.m_pPed ):SetPosition( pRecord.m_vecTargetP );
				-- ( pVehicle or pRecord.m_pPed ):SetRotation( pRecord.m_vecTargetR );
					
				for i, sControl in ipairs( SyncControls ) do
					pRecord.m_pPed:SetControlState( sControl, Frame[ i + 7 ] );
				end
			end
		end
	end
	
	if End then
		delete ( self );
	end
end