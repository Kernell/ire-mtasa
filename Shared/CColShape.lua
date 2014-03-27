-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local aTypes =
{
	Circle		= true;
	Cuboid		= true;
	Rectangle	= true;
	Sphere		= true;
	Tube		= true;
	Polygon		= true;
};

class: CColShape ( CElement )
{
	CColShape		= function( this, sType, ... )
		local pElement = _G[ "createCol" + sType ]( ... );
		
		pElement( this );
		
		if CLIENT == NULL then -- TODO: Deprecated
			addEventHandler( "onColShapeHit", pElement,
				function( pElement, bMatching )
					if pElement.OnHit then pElement:OnHit( pElement, bMatching ); end
				end
			);
			
			addEventHandler( "onColShapeLeave", pElement,
				function( pElement, bMatching )
					if pElement.OnLeave then pElement:OnLeave( pElement, bMatching ); end
				end
			);
		end
		
		return pElement;
	end;
	
	_CColShape		= destroyElement;
};