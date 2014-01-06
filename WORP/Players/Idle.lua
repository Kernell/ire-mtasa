-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local idle_timestamp = 0;
local idle_timer;
local Anims = { "shift", "shldr", "stretch", "strleg", "time" };

local function IdleUpdate()
	if CLIENT.m_pCharacter then
		local timestamp = getRealTime().timestamp;
		
		if timestamp - idle_timestamp > 120 and not getPedAnimation( localPlayer ) and not isPedInVehicle( localPlayer ) then
			local animation = Anims[ math.random( 1, table.getn( Anims ) ) ];
			
			SERVER.SetAnimation( "playidles", animation, -1, false, false, false, false );
		end
		
		idle_timer = CTimer( IdleUpdate, math.random( 20000, 90000 ), 1 );
	end
end

idle_timer = CTimer( IdleUpdate, 20000, 1 );

addEventHandler( 'onClientKey', root, 
	function()
		idle_timestamp = getRealTime().timestamp;
		
		if getPedAnimation( localPlayer ) == "playidles" then
			SERVER.SetAnimation();
		end
	end
);