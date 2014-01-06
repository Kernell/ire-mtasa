-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

function CPlayer:ShowStats( pPlayer )
	local pChar = pPlayer:GetChar();

	if pChar then
		local pFaction				= pChar:GetFaction();
		local sMarried				= pChar:GetMarried();
		
		local Stats				=
		{
			tInGameTime				= ( "%d:%02d:%02d" ):format( pPlayer.m_iInGameCount / 3600, ( pPlayer.m_iInGameCount % 3600 ) / 60, pPlayer.m_iInGameCount % 60 );
			iLevel					= pChar:GetLevel();
			sLevelPoints			= pChar:GetLevelPoints() + " / " + ( pChar:GetLevel() * 250 );
			sName					= pChar:GetName();
			tCreated				= pChar.m_sCreated;
			tLastLogin				= pChar.m_sLastLogin;
			tDateOfBirdth			= pChar.m_sDateOfBirdth;
			tPlaceOfBirdth			= pChar.m_sPlaceOfBirdth;
			sNation					= pChar:GetNation();
			iMoney					= pChar:GetMoney();
			sMarried				= sMarried == '' and pPlayer:Gender( 'Не женат', 'Не замужем' ) or pPlayer:Gender( 'Женат на ', 'Замужем за ' ) + sMarried;
			sFactionName			= pFaction and pFaction:GetName() or "Нет";
			iPhone					= pChar:GetPhoneNumber();
		};
		
		local Vehicles				= {};
		
		for key, pVehicle in pairs( g_pGame:GetVehicleManager():GetAll() ) do
			if pVehicle:GetOwner() == pChar:GetID() then
				local iRentTime		= pVehicle:GetRentTime();
				
				table.insert( Vehicles,
					{
						iID			= pVehicle:GetID();
						sName		= pVehicle:GetName() + ( pVehicle:IsRentable() and " (Аренда)" or "" );
						iPrice		= pVehicle:IsRentable() and ( "%i:%02i:%02i" ):format( iRentTime / 3600, ( iRentTime % 3600 ) / 60, iRentTime % 60 ) or pVehicle:GetPrice();
						sPlate		= pVehicle:GetRegPlate();
						fHealth		= ( '%.1f%%' ):format( pVehicle:GetHealth() / 10 );
					}
				);
			end
		end
		
		local Interiors			= {};
		
		for key, interior in pairs( g_pGame:GetInteriorManager():GetAll() ) do
			if interior:GetOwner() == pChar:GetID() then
				table.insert( Interiors,
					{
						iID			= interior.m_sInteriorID;
						sType		= interior:GetType();
						sName		= interior:GetName();
						iPrice		= interior:GetPrice();
						sZone		= GetZoneName( interior.m_pOutsideMarker:GetPosition() );
					}
				);
			end
		end
		
		self:Client().StatsDialog( Stats, Vehicles, Interiors );
	end
end