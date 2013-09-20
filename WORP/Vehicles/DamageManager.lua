-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local IgnoreModels	=
{
	[432]	= true; -- Rhino
	[601]	= true; -- S.W.A.T.
};

local OnVehicleCollision;

function OnVehicleCollision( pHitElement, fForce )
	if fForce > 300 then
		if getVehicleType( source ) == 'Automobile' and not IgnoreModels[ getElementModel( source ) ] and CLIENT:GetVehicle() == source and not CLIENT:GetData( 'adminduty' ) then
			local fHealth = CLIENT:GetHealth();
			
			if fHealth > 0 then
				CLIENT:SetHealth( math.max( fHealth - ( fForce * .063 ), 0 ) );

				-- Debug( ( "fForce: %.3f, fDamage: %.3f" ):format( fForce, ( fForce * .063 ) ), 0, 128, 0, 255 );
			end
		end		
	end
	
	-- Debug( "OnVehicleCollision: iForce: " + fForce, 0, 255, 255, 0 );
end

addEventHandler( 'onClientVehicleCollision', root, OnVehicleCollision );