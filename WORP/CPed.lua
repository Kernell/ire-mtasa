-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

function CPed:GetAnimation()
	return getPedAnimation( self.__instance );
end

function CPed:GetAnimationData()
	return getPedAnimationData( self.__instance );
end

function CPed:GetMoveState()
	return getPedMoveState( self.__instance );
end

function CPed:GetTask( priority, taskType )
	return getPedTask( self.__instance, priority, taskType );
end

function CPed:IsDoingTask( taskName )
	return isPedDoingTask( self.__instance, taskName );
end

function CPed:GetSimplestTask()
	return getPedSimplestTask( self.__instance );
end

function CPed:SetCanBeKnockedOffBike( bool )
	return setPedCanBeKnockedOffBike( self.__instance, tobool( bool ) );
end

function CPed:CanBeKnockedOffBike()
	return canPedBeKnockedOffBike( self.__instance );
end

function CPed:GetBonePosition( bone )
	return Vector3( getPedBonePosition( self.__instance, bone ) );
end

function CPed:GetTargetRange()
	return getPedTargetRange( self.__instance );
end

function CPed:GetTargetCollision()
	return Vector3( getPedTargetCollision( self.__instance ) );
end

function CPed:GetTargetStart()
	return Vector3( getPedTargetStart( self.__instance ) );
end

function CPed:GetTargetEnd()
	return Vector3( getPedTargetEnd( self.__instance ) );
end

function CPed:SetVoie( type, name )
	return setPedVoice( self.__instance, type, name );
end

function CPed:GetVoice()
	return getPedVoice( self.__instance );
end

function CPed:GetWeaponMuzzlePosition()
	return Vector3( getPedWeaponMuzzlePosition( self.__instance ) );
end

function CPed:SetAimTarget( pos )
	pos = pos or Vector3();
	
	return setPedAimTarget( self.__instance, pos.X, pos.Y, pos.Z );
end

function CPed:SetCameraRotation( rotation )
	return setPedCameraRotation( self.__instance, rotation or 0 );
end

function CPed:SetControlState( sControl, bState )
	return setPedControlState( self.__instance, sControl, (bool)(bState) ) or error( "Bad argument @ 'setPedControlState' ( " + (string)(sControl) + ", " + (string)(bState) + " )", 2 );
end

function CPed:GetControlState( sControl )
	return getPedControlState( self.__instance, sControl );
end

function CPed:SetLookAt( pos, ... )
	pos = pos or Vector3();
	
	return setPedLookAt( self.__instance, pos.X, pos.Y, pos.Z, ... );
end