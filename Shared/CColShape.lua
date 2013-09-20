-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
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

class "CColShape" ( CElement );

function CColShape:CColShape( sType, ... )
	if type( sType ) == 'string' then
		if not aTypes[ sType ] then error( "invalid colshape type '" + (string)( sType ) + "'", 2 ) end
		
		self.__instance = _G[ 'createCol' .. sType ]( ... );
		
		if not self.__instance then error( "failed to create colshape", 2 ) end
		
		if getLocalPlayer then
			-- // TODO:
		else
			addEventHandler( 'onColShapeHit', self.__instance,
				function( pElement, bMatching )
					if self.__instance.OnHit then self.__instance:OnHit( pElement, bMatching ) end
				end
			);
			
			addEventHandler( 'onColShapeLeave', self.__instance,
				function( pElement, bMatching )
					if self.__instance.OnLeave then self.__instance:OnLeave( pElement, bMatching ) end
				end
			);
		end
		
		self:CElement( self.__instance );
		self.CElement = NULL;
		
		return self.__instance;
	end
end

function CColShape:_CColShape()
	self:Destroy();
end
