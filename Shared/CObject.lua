-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CObject ( CElement )
{
	CObject			= function( this, iModel, vecPosition, vecRotation )
		vecPosition = vecPosition or Vector3();
		vecRotation = vecRotation or Vector3();
		
		local pElement = createObject( iModel, vecPosition.X, vecPosition.Y, vecPosition.Z, vecRotation.X, vecRotation.Y, vecRotation.Z );
		
		pElement( this );
		
		return pElement;
	end;
	
	_CObject		= destroyElement;
	
	Move			= function( this, iTime, vecPosition, vecRotation, ... )
		vecPosition = vecPosition or Vector3();
		vecRotation = vecRotation or Vector3();
		
		return moveObject( this, iTime, vecPosition.X, vecPosition.Y, vecPosition.Z, vecRotation.X, vecRotation.Y, vecRotation.Z, ... );
	end;
	
	Stop			= stopObject;
	SetScale		= setObjectScale;
	GetScale		= getObjectScale;
	SetBreakable	= setObjectBreakable;
	IsBreakable		= isObjectBreakable;
};
