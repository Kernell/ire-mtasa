-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CObject" ( CElement );

function CObject:CObject( instance )
	if instance and isElement( instance ) and getElementType( instance ) == 'object' then
		self.__instance = instance;
	end
end

function CObject:_CObject()
	self:Destroy();
end

function CObject.Create( iModel, vecPosition, vecRotation )
	vecPosition = vecPosition or Vector3();
	vecRotation = vecRotation or Vector3();
	
	local pObject = createObject( iModel, vecPosition.X, vecPosition.Y, vecPosition.Z, vecRotation.X, vecRotation.Y, vecRotation.Z );
	
	if not pObject then
		Debug( "failed to create object", 1 );
		
		return NULL;
	end
	
	return pObject;
end

function CObject:Move( time, target, target_rot, ... )
	target_rot = target_rot or Vector3();
	
	return moveObject( self.__instance, time, target.X, target.Y, target.Z, target_rot.X, target_rot.Y, target_rot.Z, ... );
end

function CObject:Stop()
	return stopObject( self.__instance );
end

function CObject:SetScale( scale )
	return setObjectScale( self.__instance, scale or 1.0 );
end

function CObject:GetScale()
	return getObjectScale( self.__instance );
end

function CObject:SetBreakable( bBreakable )
	return setObjectBreakable( self.__instance, bBreakable );
end

function CObject:IsBreakable()
	return isObjectBreakable( self.__instance );
end