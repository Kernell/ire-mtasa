-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local Init, OnMarkerHit, OnMarkerLeave, OnVehicleEnter, StartSpray, EndSpray;

local list 		= {};
local Garages	=
{
	[8]		= { Vector3( 2065.139, -1831.264, 13.251 ), 270 }; -- Pay 'n' Spray in Idlewood  
	[11]	= { Vector3( 1024.970, -1024.081, 31.807 ), 180 }; -- Pay 'n' Spray in Temple  
	[12]	= { Vector3( 487.8830, -1741.375, 10.849 ), 0 	}; -- Pay 'n' Spray in Santa Maria Beach  
	[19]	= { Vector3( -1904.748, 285.5880, 40.752 ), 180 }; -- Pay 'n' Spray near Wang Cars in Doherty  
	[24]	= { Vector3( -1787.235, 1214.934, 24.830 ), 180 }; -- Michelle's Pay 'n' Spray in Downtown  
	[27]	= { Vector3( -2425.671, 1021.562, 50.102 ), 0 	}; -- Pay 'n' Spray in Juniper Hollow  
--	[32]	= { Vector3() }; -- Pay 'n' Spray near Royal Casino  
	[36]	= { Vector3( 1976.4630, 2161.993, 10.774 ), 90 	}; -- Pay 'n' Spray in Redsands East  
	[40]	= { Vector3( -1420.537, 2584.592, 55.547 ), 0 	}; -- Pay 'n' Spray in El Quebrados  
	[41]	= { Vector3( -99.93800, 1117.610, 19.446 ), 180 }; -- Pay 'n' Spray in Fort Carson  
	[47]	= { Vector3( 720.55300, -456.093, 16.040 ), 180 }; -- Pay 'n' Spray in Dillimore  
}

function Init()
	for iID, pGarage in pairs( Garages ) do
		setGarageOpen( iID, true );
		
		local pMarker = CMarker( pGarage[ 1 ], 'cylinder', 4.0, CColor( 255, 255, 255, 0 ) );
		
		CBlip( pMarker, BLIP_SPRITE_SPRAY, 2, 255, 255, 255, 255, 1, 250.0 ):SetParent( pMarker );
		
		pMarker.m_iID		= iID;
		pMarker.m_fRotation	= pGarage[ 2 ];
		pMarker.OnHit 		= OnMarkerHit;
		pMarker.OnLeave		= OnMarkerLeave;
		
		table.insert( list, pMarker );
	end
	
	return true;
end

function OnVehicleEnter( pPlayer, iSeat )	
	if iSeat == 0 then
		for i, pMarker in ipairs( list ) do
			if source:IsWithinMarker( pMarker ) then
				OnMarkerHit( pMarker, source, pMarker:GetDimension() == source:GetDimension() );
				
				return true;
			end
		end
	end
	
	return true;
end

function OnMarkerHit( this, pElement, bMatching )
	if bMatching and isGarageOpen( this.m_iID ) then
		if classname( pElement ) == 'CPlayer' and pElement:IsInGame() then
			local vecPosition 	= this:GetPosition():Offset( 25, this.m_fRotation );
				
			vecPosition.Z		= vecPosition.Z + 5;
			
			pElement:GetCamera():MoveTo( vecPosition, 2000, 'OutBack', 0.3, 1.0, 1.201 );
			pElement:GetCamera():RotateTo( this:GetPosition() );
		elseif classname( pElement ) == 'CVehicle' then
			local vecPosition 	= this:GetPosition():Offset( 25, this.m_fRotation );
			
			vecPosition.Z		= vecPosition.Z + 5;
				
			for i, p in pairs( pElement:GetOccupants() ) do
				p:GetCamera():MoveTo( vecPosition, 2000, 'OutBack', 0.3, 1.0, 1.201 );
				p:GetCamera():RotateTo( this:GetPosition() );
			end
			
			local pPlayer = pElement:GetDriver();
			
			if pPlayer and classname( pPlayer ) == 'CPlayer' and pPlayer:IsInGame() then
				local fHealth = pElement:GetHealth();
				
				if fHealth < 1000 then
					local iPrice = math.floor( 300 + ( 1000 - fHealth ) );
					
					if iPrice <= pPlayer:GetChar():GetMoney() then
						pPlayer:GetChar():TakeMoney( iPrice );
						
						if pElement.m_pStartSprayTimer then
							pElement.m_pStartSprayTimer:Kill();
							m_pStartSprayTimer = NULL;
						end
						
						setGarageOpen( this.m_iID, false );
						
						pElement:SetFrozen( true );
						pElement.m_pStartSprayTimer = CTimer( StartSpray, 2000, 1, this, pElement );
						
						pPlayer:GetChat():Send( "*Pay 'n' Spray: -$" + iPrice + " за ремонт автомобиля", 255, 100, 100 );
					else
						pPlayer:Hint( "Pay 'n' Spray", "Недостаточно денег.\n\nНеобходимо $" + iPrice + " для ремонта", "error" );
					end
				else
					pPlayer:Hint( "Pay 'n' Spray", "\nЭтому автомобилю не требуется ремонт", "info" );
				end
			end
		end
	end
	
	return true;
end

function StartSpray( this, pVehicle )
	if pVehicle:IsElement() then
		pVehicle:Fix();
		pVehicle.m_pStartSprayTimer = NULL;
		pVehicle.m_pEndSprayTimer	= CTimer( EndSpray, 2000, 1, this, pVehicle );
		
		local pPlayer = pVehicle:GetDriver();
		
		if pPlayer and pPlayer:IsInGame() then
			pPlayer:PlaySoundFrontEnd( 16 );
		end
	else
		setGarageOpen( this.m_iID, true );
	end
end

function EndSpray( this, pVehicle )
	setGarageOpen( this.m_iID, true );
	
	if pVehicle:IsElement() then
		pVehicle.m_pEndSprayTimer = NULL;
		pVehicle:SetFrozen( false );
	end
end

function OnMarkerLeave( this, pElement, bMatching )
	if bMatching then
		if classname( pElement ) == 'CPlayer' and pElement:IsInGame() then
			pElement:GetCamera():SetTarget();
		end
	end
	
	return true;
end

addEventHandler( "onVehicleEnter", resourceRoot, OnVehicleEnter );
addEventHandler( "onResourceStart", resourceRoot, Init );
