-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local UpdateGhost;

function UpdateGhost()
	local bGhost = CLIENT:GetData( 'ghost_enabled' );
	
	for i, pPlayer in ipairs( getElementsByType( "player" ) ) do
		pPlayer:SetCollisionsEnabled( true );
		
		if pPlayer:IsStreamedIn() then
			local bPlayerGhost = pPlayer:GetData( 'ghost_enabled' );
			
			if bGhost then
				bPlayerGhost = bGhost;
			end
			
			if pPlayer ~= CLIENT then
				pPlayer:SetCollisionsEnabled( not bPlayerGhost );
			end
		end
	end
end

-- setTimer( UpdateGhost, 1000, 0 );