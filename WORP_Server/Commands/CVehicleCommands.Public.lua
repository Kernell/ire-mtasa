-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

function CVehicleCommands:SetCruise( pClient, sCommand, sOption, sSpeed )
	local pVehicle = pClient:GetVehicle();
	
	if pVehicle and pVehicle == pClient.m_pVehicle and pClient:GetVehicleSeat() == 0 then
		local fSpeed = Clamp( 0.0, (float)(sSpeed), 120.0 );
		
		pClient:Client().SetCruise( fSpeed );
	end
	
	return true;
end

function CVehicleCommands:LoopWhiperState( pClient )
	local pVehicle = pClient:GetVehicle();
	
	if pVehicle and pVehicle == pClient.m_pVehicle and pClient:GetVehicleSeat() == 0 then
		local iWiperState = ( (int)(pVehicle:GetData( "m_iWiperState" )) + 1 ) % 3;
		
		pVehicle:SetData( "m_iWiperState", iWiperState );
	end
	
	return true;
end

function CVehicleCommands:LoopWhelenState( pClient )
	local pVehicle = pClient:GetVehicle();
		
	if pVehicle and pVehicle == pClient.m_pVehicle and pClient:GetVehicleSeat() <= 1 then
		local iNextState	= ( pVehicle.m_pSiren.m_iWhelenState ~= 0 and pVehicle.m_pSiren.m_iWhelenState or pVehicle.m_pSiren.m_iWhelenStateLast ) + 1;
		
		local iState = math.max( 1, iNextState % ( pVehicle.m_pSiren.m_iMaxWhelenState + 1 ) );
		
		pVehicle.m_pSiren.m_iWhelenStateLast	= pVehicle.m_pSiren.m_iWhelenState;
		
		pVehicle.m_pSiren:SetState( pVehicle.m_pSiren.m_iSirenState, iState );
	end
	
	return true;
end

function CVehicleCommands:LoopSirenState( pClient )
	local pVehicle = pClient:GetVehicle();
		
	if pVehicle and pVehicle == pClient.m_pVehicle and pClient:GetVehicleSeat() <= 1 then
		local iNextState	= ( pVehicle.m_pSiren.m_iSirenState ~= 0 and pVehicle.m_pSiren.m_iSirenState or pVehicle.m_pSiren.m_iSirenStateLast ) + 1;
		
		local iState = math.max( 1, iNextState % ( pVehicle.m_pSiren.m_iMaxSirenState + 1 ) );
		
		if pVehicle.m_pSiren.m_iWhelenState == 0 then
			pVehicle.m_pSiren.m_iWhelenState = math.max( 1, pVehicle.m_pSiren.m_iWhelenStateLast );
		end

		pVehicle.m_pSiren.m_iSirenStateLast	= pVehicle.m_pSiren.m_iSirenState;
		
		pVehicle.m_pSiren:SetState( iState, pVehicle.m_pSiren.m_iWhelenState );
	end
	
	return true;
end

function CVehicleCommands:SetWhelenState( pClient, sCmd, sOption, iState )
	if iState then
		iState = (int)(iState);
		
		local pVehicle = pClient:GetVehicle();
		
		if pVehicle and pVehicle == pClient.m_pVehicle and pClient:GetVehicleSeat() <= 1 then
			pVehicle.m_pSiren.m_iWhelenStateLast	= pVehicle.m_pSiren.m_iWhelenState;
			
			pVehicle.m_pSiren:SetState( iState == 0 and 0 or pVehicle.m_pSiren.m_iSirenState, iState );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:SetSirenState( pClient, sCmd, sOption, iState )
	if iState then
		local pVehicle = pClient:GetVehicle();
		
		if pVehicle and pVehicle == pClient.m_pVehicle and pClient:GetVehicleSeat() <= 1 then
			if pVehicle.m_pSiren.m_iWhelenState == 0 then
				pVehicle.m_pSiren.m_iWhelenState = math.max( 1, pVehicle.m_pSiren.m_iWhelenStateLast );
			end
			
			pVehicle.m_pSiren.m_iSirenStateLast	= pVehicle.m_pSiren.m_iSirenState;
			
			pVehicle.m_pSiren:SetState( (int)(iState), pVehicle.m_pSiren.m_iWhelenState );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:ToggleWhelen( pClient, sCmd, sOption )
	local pVehicle = pClient:GetVehicle();
		
	if pVehicle and pVehicle == pClient.m_pVehicle and pClient:GetVehicleSeat() <= 1 then
		local iState = pVehicle.m_pSiren.m_iWhelenState == 0 and math.max( 1, pVehicle.m_pSiren.m_iWhelenStateLast ) or 0;
		
		CVehicleCommands:SetWhelenState( pClient, sCmd, sOption, iState );
	end
	
	return true;
end

function CVehicleCommands:ToggleSiren( pClient, sCmd, sOption )
	local pVehicle = pClient:GetVehicle();
		
	if pVehicle and pVehicle == pClient.m_pVehicle and pClient:GetVehicleSeat() <= 1 then
		local iState = pVehicle.m_pSiren.m_iSirenState == 0 and math.max( 1, pVehicle.m_pSiren.m_iSirenStateLast ) or 0;
		
		CVehicleCommands:SetSirenState( pClient, sCmd, sOption, iState );
	end
	
	return true;
end

function CVehicleCommands:ToggleEngine( pPlayer, sCmd, sOption, ... )
	if pPlayer:GetVehicleSeat() == 0 then
		local pVehicle = pPlayer:GetVehicle();
		
		if pVehicle and pVehicle == pPlayer.m_pVehicle then
			if not pVehicle:GetEngineState() then
				if pPlayer:HasKey( pVehicle ) then
					if pVehicle.m_pEngineStartTimer then
						pVehicle.m_pEngineStartTimer:Kill();
						pVehicle.m_pEngineStartTimer = NULL;
					end
					
					if not pVehicle:HaveFuel() then
						pVehicle:SetEngineState( true );
						
						return true;
					end
					
					pPlayer:PlaySound3D( "Resources/Sounds/EngineAmbient/engine_start.wav", .2 );
					
					pVehicle.m_pEngineStartTimer = CTimer(
						function()
							local bEngine = false;
							
							if not pVehicle:HaveFuel() or pVehicle:GetFuel() > 0.0 then
								if pVehicle:GetHealth() > 250 then
									bEngine = math.random() < pVehicle:GetHealth() * .001;
								end
							else
								pPlayer:Hint( "Ошибка", "Автомобиль необходимо заправить", "error" );
							end
							
							pPlayer:PlaySound3D( "Resources/Sounds/EngineAmbient/engine_end.wav", .2 );
							
							pVehicle:SetEngineState( bEngine );
							pVehicle.m_pEngineStartTimer = NULL;
						end, 600, 1
					);
				else
					pPlayer:Hint( "Ошибка", "У Вас нет ключа от этого автомобиля", "error" );
				end
			end
			
			pVehicle:SetEngineState( false );
		end
	end
	
	return true;
end

function CVehicleCommands:ToogleLocked( pPlayer, sCmd, sOption, ... )
	local pVehicle;
	
	if ( pPlayer:GetVehicleSeat() or 2 ) <= 1 then
		local pVeh = pPlayer:GetVehicle();
		
		if pVeh and pVeh == pPlayer.m_pVehicle and pVeh:IsLockable() and pVeh:GetHealth() > 10 then
			pVehicle = pVeh;
		end
	elseif not pPlayer:IsInVehicle() then
		local vecPosition	= pPlayer:GetPosition();
		local iDimension	= pPlayer:GetDimension();
		local iInterior		= pPlayer:GetInterior();
		
		local fDistanceMin = 3;
		
		for id, pVeh in pairs( g_pGame:GetVehicleManager():GetAll() ) do
			local fDistance = vecPosition:DistanceTo( pVeh:GetPosition() );
			
			if fDistance < fDistanceMin and iDimension == pVeh:GetDimension() and iInterior == pVeh:GetInterior() and pVeh:IsLockable() and pVeh:GetHealth() > 10 and pPlayer:HasKey( pVeh ) then
				fDistanceMin	= fDistance;
				pVehicle		= pVeh;
			end
		end
	end
	
	if pVehicle then
		pVehicle:SetLocked( not pVehicle:IsLocked() );
		
		pPlayer:Me( ( pVehicle:IsLocked() and pPlayer:Gender( 'закрыл', 'закрыла', 'закрыл(а)' ) or pPlayer:Gender( 'открыл', 'открыла', 'открыл(а)' ) ) + " авто", NULL, false, true );
		
		return 1;
	end
	
	return 0;
end

function CVehicleCommands:ToggleLights( pPlayer, sCmd, sOption, ... )
	if pPlayer:GetVehicleSeat() == 0 then
		local pVehicle = pPlayer:GetVehicle();
		
		if pVehicle and pVehicle == pPlayer.m_pVehicle and pVehicle:GetHealth() > 10 then
			pVehicle:SetLights( not pVehicle:GetLights() );
		end
	end
	
	return true;
end

function CVehicleCommands:SwatRope( pPlayer, sCmd, sOption, ... )
	if pPlayer:IsInGame() then
		local pVehicle = pPlayer:GetVehicle();
		
		if pVehicle and pVehicle:GetModel() == 497 then
			if pPlayer:GetVehicleSeat() > 0 then
				if pVehicle:IsLocked() then
					pPlayer:Hint( "Ошибка", "Двери заблокированы", "error" );
				elseif pPlayer:IsCuffed() then
					pPlayer:Hint( "Ошибка", "Вы в наручниках", "error" );
				else
					pPlayer:Client().GetGroundPosition( 'SWATRopeResult' );
				end
			else
				pPlayer:Hint( "Ошибка", "Вы должны быть на пассажирском месте", "error" );
			end
		else
			pPlayer:Hint( "Ошибка", "Вы должны быть в полицейском вертолёте", "error" );
		end
	end
	
	return true;
end

function CVehicleCommands:Sell( pPlayer, sCmd, sOption, siID, siPrice )
	if pPlayer:IsInGame() then
		local iID		= tonumber( siID );
		local iPrice	= tonumber( siPrice );
		
		if iID and iPrice then
			iPrice = Clamp( 0, iPrice, 9999999 );
			
			local pTargetPlayer = g_pGame:GetPlayerManager():Get( iID );
			
			if pTargetPlayer and pTargetPlayer:IsInGame() then
				local pVehicle = pPlayer:GetVehicle();
				
				if pVehicle then
					if not pVehicle:IsRentable() and pVehicle:GetOwner() == pPlayer:GetChar():GetID() then
						pTargetPlayer:MessageBox( 'VehicleSellTo', pPlayer:GetVisibleName() + " предлагает вам купить автомобиль " + pVehicle:GetName() + " (ID: " + pVehicle:GetID() + ") за $" + iPrice, "Предложение о покупке", MessageBoxButtons.YesNo, MessageBoxIcon.Question, pVehicle:GetID(), iPrice, pPlayer );
						
						return "Вы предложили " + pTargetPlayer:GetName() + " купить автомобиль " + pVehicle:GetName() + " (ID: " + pVehicle:GetID() + ") за $" + iPrice, 0, 255, 255;
					end
					
					return "Этот автомобиль не ваш!", 255, 0, 0;
				end
				
				return "Вы должны быть в автомобиле", 255, 0, 0;
			end
			
			return "Игрок не найден", 255, 0, 0;
		end
		
		return false;
	end
	
	return true;
end

function CVehicleCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end