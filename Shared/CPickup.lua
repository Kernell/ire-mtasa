-- Author:      	Kernell
-- Version:     	1.0.0

class "CPickup" ( CElement )

CPickup.__instance = createElement( 'CPickup' .. ( getLocalPlayer and '_C' or '' ) );

function CPickup:CPickup( instance )
	if instance and isElement( instance ) and getElementType( instance ) == 'pickup' then
		self.__instance = instance;
	end
end

function CPickup:_CPickup()
	self:Destroy();
end

function CPickup.Create( pos, ... )
	pos = pos or Vector3();
	
	local pickup = createPickup( pos.X, pos.Y, pos.Z, ... );
	
	assert( pickup, "failed to create pickup" );
	
	pickup = CPickup( pickup );
	
	pickup:SetParent( CPickup );
	
	if getLocalPlayer then
	
	else
		addEventHandler( 'onPickupSpawn', pickup.__instance,
			function()
				if pickup.OnSpawn then return pickup:OnSpawn() or cancelEvent() end;
			end
		);
		
		addEventHandler( 'onPickupHit', pickup.__instance,
			function( player )
				if pickup.OnHit then return pickup:OnHit( player ) or cancelEvent() end;
			end
		);
		
		addEventHandler( 'onPickupUse', pickup.__instance,
			function( player )
				if pickup.OnUse then return pickup:OnUse( player ) or cancelEvent() end;
			end
		);
	end
	
	return pickup;
end