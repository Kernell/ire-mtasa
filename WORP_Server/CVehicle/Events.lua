-- Author:      	Kernell
-- Version:     	1.0.0

local events =
{
	onTrailerAttach		= 'OnTrailerAttach';
	onTrailerDetach		= 'OnTrailerDetach';
	onVehicleDamage 	= 'OnDamage';
	onVehicleRespawn 	= 'OnRespawn';
	onVehicleStartEnter = 'OnStartEnter';
	onVehicleStartExit 	= 'OnStartExit';
	onVehicleEnter 		= 'OnEnter';
	onVehicleExit 		= 'OnExit';
	onVehicleExplode	= 'OnExplode';
	onElementDestroy	= 'OnDestroy';
};

for event, method in pairs( events ) do
	addEventHandler( event, resourceRoot, 
		function( ... )
			if getElementType( source ) ~= 'vehicle' then return end
			
			if CVehicle[ method ] then
				return (bool)(CVehicle[ method ]( source, ... )) or cancelEvent();
			end
		end,
		true,
		"high"
	);
end