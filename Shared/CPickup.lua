-- Author:      	Kernell
-- Version:     	1.0.0

class: CPickup ( CElement )
{
	CPickup		= function( this, vecPosition, ... )
		vecPosition = vecPosition or Vector3();
		
		local pElement = createPickup( vecPosition.X, vecPosition.Y, vecPosition.Z, ... );
		
		pElement( this );
		
		if CLIENT == NULL then -- TODO: Deprecated
			addEventHandler( 'onPickupSpawn', pElement,
				function()
					if pElement.OnSpawn then return pElement:OnSpawn() or cancelEvent() end;
				end
			);
			
			addEventHandler( 'onPickupHit', pElement,
				function( player )
					if pElement.OnHit then return pElement:OnHit( player ) or cancelEvent() end;
				end
			);
			
			addEventHandler( 'onPickupUse', pElement,
				function( player )
					if pElement.OnUse then return pElement:OnUse( player ) or cancelEvent() end;
				end
			);
		end
		
		return pElement;
	end;
	
	_CPickup	= destroyElement;
};