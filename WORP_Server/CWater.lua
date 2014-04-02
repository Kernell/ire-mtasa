-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CWater ( CElement )
{
	CWater		= function( this, vecPosition1, vecPosition2, vecPosition3, vecPosition4, bShallow )
		local pElement = createWater(
			vecPosition1.X, vecPosition1.Y, vecPosition1.Z,
			vecPosition2.X, vecPosition2.Y, vecPosition2.Z,
			vecPosition3.X, vecPosition3.Y, vecPosition3.Z,
			vecPosition4.X, vecPosition4.Y, vecPosition4.Z,
			(bool)(bShallow)
		);
		
		pElement( this );
		
		return pElement;
	end;
	
	_CWater		= destroyElement;
	
	SetVertex	= function( this, iVertex, pVector )
		setWaterVertexPosition( this, vecPosition.X, vecPosition.Y, vecPosition.Z );
	end;
	
	GetVertex	= function( this, iVertex )
		return Vector3( getWaterVertexPosition( this ) );
	end;
};