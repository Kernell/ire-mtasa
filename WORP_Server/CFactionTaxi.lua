-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CFactionTaxi ( CFaction )
{
	CFactionTaxi		= function( this, ... )
		this:CFaction( ... );
		
		this.m_Calls	= {};
	end;
	
	OnVehicleEnter		= function( this, pVehicle, pPlayer, iSeat, pJacker )
		if iSeat == 0 then
			pVehicle:SetTaxiLightOn( true );
			
			if pPlayer.m_pLastJob then
				this:SetPlayerJob( pPlayer, pPlayer.m_pLastJob );
				
				pPlayer.m_pLastJob = NULL;
			else
				pPlayer:Hint( "Таксист", "Нажмите F5 чтобы открыть список вызовов", "info" );
			end
		end
	end;
	
	OnVehicleExit		= function( this, pVehicle, pPlayer, iSeat, pJacker )
		if iSeat == 0 then
			pVehicle:SetTaxiLightOn( false );
			
			pPlayer:Client().TJobTaxi_SetMeter( NULL );
			
			if pPlayer.m_pJob then
				pPlayer.m_pLastJob = pPlayer.m_pJob:GetPosition();
				
				this:SetPlayerJob( pPlayer );
			end
		end
	end;
	
	ClientHandle		= function( this, pClient, sCommand, ... )
		local pChar = pClient:GetChar();
		
		if not pChar then
			return AsyncQuery.UNAUTHORIZED;
		end
	
		if sCommand == "AcceptCall" then
			local iPlayerID = tonumber( ( { ... } )[ 1 ] );
			
			if iPlayerID then
				local pVehicle = pClient:GetVehicleSeat() == 0 and pClient:GetVehicle();
	
				if pVehicle and pVehicle:GetFaction() == this then
					local pCall = this.m_Calls[ iPlayerID ];
					
					if pCall then
						if pCall.pCaller:GetID() ~= pCall.iPlayerID then
							this:RemoveCall( pCall.iPlayerID );
							
							return "Ошибка, игрок не в сети", 255, 0, 0;
						end
						
						if not pClient.m_pJob then
							this:SetPlayerJob( pCall.vecPosition );
							
							this:SendMessage( pClient:GetName() + " принял вызов от " + pCall.sName );
							this:RemoveCall( pCall.iPlayerID );
							this:ShowMenu( pClient );
							
							return true;
						end
						
						return "Вы уже приняли вызов", 255, 0, 0;
					end
					
					return "Никаких вызовов не поступало", 255, 0, 0;
				end
				
				return true;
			end
		end
		
		return AsyncQuery.BAD_REQUEST;
	end;
	
	SetPlayerJob		= function( this, pPlayer, vecPosition )
		if vecPosition then
			pPlayer.m_pJob = CMarker.Create( vecPosition, "checkpoint", 10.0, 255, 255, 0, 96, pClient.__instance );
			
			CBlip( pPlayer.m_pJob, 0, 2.0, 255, 0, 0, 255, 10, 9999.0, pPlayer.__instance ):SetParent( pPlayer.m_pJob );
			
			function pPlayer.m_pJob.OnHit( ... )
				this:OnTaxiMarkerHit( ... );
			end
		elseif pPlayer.m_pJob then
			pPlayer.m_pJob:Destroy();
			pPlayer.m_pJob = NULL;
		end
	end;
	
	OnTaxiMarkerHit		= function( this, pMarker, pPlayer, bMatching )
		if bMatching and pPlayer:type() == "player" and pMarker == pPlayer.m_pJob then
			local pChar	= pPlayer:GetChar();
			
			local pVehicle = pChar and pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
			
			if pVehicle and pVehicle:GetFaction() == this and pChar:GetFaction() == this then
				this:SetPlayerJob( pPlayer );
				
				return;
			end
		end
	end;
	
	SendMessage			= function( this, sText, pIgnorePlayer )
		for iID, pPlr in pairs( this:GetAlivePlayers() ) do
			if pPlr ~= pIgnorePlayer and pPlr:IsInGame() then
				local pVeh = pPlr:GetVehicleSeat() == 0 and pPlr:GetVehicle();
				
				if pVeh and pVeh:GetFaction() == this then
					pPlr:GetChat():Send( "Диспетчер такси: " + sText, 215, 142, 16 );
				end
			end
		end
	end;
	
	AddCall				= function( this, pPlayer )
		if pPlayer:IsInGame() then
			local pCall	=
			{
				vecPosition 	= pPlayer:GetPosition();
				iPlayerID		= pPlayer:GetID();
				sName			= pPlayer:GetName();
				pCaller			= pPlayer;
				iTimestamp		= getRealTime().timestamp;
			};
			
			this:SendMessage( "новый вызов: " + pCall.sName + ", адрес: " + GetZoneName( pCall.vecPosition ) );
			
			this.m_Calls[ pPlayer:GetID() ] = pCall;
			
			return true;
		end
		
		return false;
	end;
	
	RemoveCall			= function( this, iPlayerID )
		this.m_Calls[ iPlayerID ] = NULL;
	end;
	
	ShowMenu		= function( this, pPlayer )
		local pChar = pPlayer:GetChar();
	
		if pChar then
			if pChar:GetFaction() == this then
				pChar:ShowUI( "CUIFactionTaxi", this.m_Calls, getRealTime().timestamp );
				
				return true;
			end
		end
		
		return false;
	end;
};