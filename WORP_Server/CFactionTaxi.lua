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
			
			pPlayer:Hint( "Таксист", "Нажмите F5 чтобы открыть меню", "info" );
		end
	end;
	
	OnVehicleExit		= function( this, pVehicle, pPlayer, iSeat, pJacker )
		if iSeat == 0 then
			pVehicle:SetTaxiLightOn( false );
			
			pPlayer:Client().TJobTaxi_SetMeter( NULL );
		end
	end;
	
	OnTaxiMarkerHit		= function( this, pMarker, pPlayer, bMatching )
		if bMatching and pPlayer:type() == "player" and pMarker == pPlayer.m_pJob then
			local pChar	= pPlayer:GetFaction();
			
			local pVehicle = pChar and pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
			
			if pVehicle and pVehicle:GetFaction() == this and pChar:GetFaction() == this then
				pPlayer.m_pJob:Destroy();
				
				pPlayer.m_pJob	= NULL;
				this.m_pCall	= NULL;
				
				return;
			end
			
			pPlayer:EndCurrentJob();
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