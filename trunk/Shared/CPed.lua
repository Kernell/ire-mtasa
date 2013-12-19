-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CPed" ( CElement )

function CPed:CPed( instance )
	if instance and isElement( instance ) then
		self.__instance = instance;
	end
end

function CPed:_CPed()
	destroyElement( self.__instance );
	
	CElement.RemoveFromList( self );
end

function CPed.Create( modelid, vecPosition, ... )
	vecPosition = vecPosition or Vector3();
	
	local pPed = createPed( modelid, vecPosition.X, vecPosition.Y, vecPosition.Z, ... );
	
	assert( pPed, "failed to create ped" );
	
	return CPed( pPed );
end

function CPed:WarpIntoVehicle( pVehicle, iSeat )
	return warpPedIntoVehicle( self.__instance, pVehicle, (int)(iSeat) );
end

function CPed:RemoveFromVehicle()
	return removePedFromVehicle( self.__instance );
end

function CPed:AddClothes( ... )
	return addPedClothes( self.__instance, ... );
end

function CPed:GetClothes( clothesType )
	return getPedClothes( self.__instance, clothesType );
end

function CPed:RemoveClothes( ... )
	return removePedClothes( self.__instance, ... );
end

function CPed:HaveJetPack()
	return doesPedHaveJetPack( self.__instance );
end

function CPed:GetWeapon( ... )
	return getPedWeapon( self.__instance, ... );
end

function CPed:SetWeaponSlot( weaponSlot )
	return setPedWeaponSlot( self.__instance, weaponSlot );
end

function CPed:GetWeaponSlot()
	return getPedWeaponSlot( self.__instance );
end

function CPed:GetAmmoInClip( ... )
	return getPedAmmoInClip( self.__instance, ... );
end

function CPed:GetTotalAmmo( ... )
	return getPedTotalAmmo( self.__instance, ... );
end

function CPed:GetArmor()
	return getPedArmor( self.__instance );
end

function CPed:GetContactElement()
	return getPedContactElement( self.__instance );
end

function CPed:GetVehicle()
	return getPedOccupiedVehicle( self.__instance );
end

function CPed:SetRotation( vRotation )
	if classname( vRotation ) == 'Vector3' then
		return setElementRotation( self.__instance, vRotation.X, vRotation.Y, vRotation.Z );
	end
	
	return setPedRotation( self.__instance, (float)(vRotation) );
end

function CPed:SetRotationAt( v_pos )
	v_pos = v_pos or Vector();
	
	return self:SetRotation( ( 360 - math.deg( math.atan2( v_pos.X - self:GetPosition().X, v_pos.Y - self:GetPosition().Y ) ) ) % 360 );
end

function CPed:GetRotation()
	return getPedRotation( self.__instance );
end

function CPed:SetSkin( skin )
	return setElementModel( self.__instance, type( skin ) == 'table' and skin:GetID() or skin );
end

function CPed:GetSkin()
	return getElementModel( self.__instance );
end

function CPed:GetStat( stat )
	return getPedStat( self.__instance, stat );
end

function CPed:GetTarget()
	return getPedTarget( self.__instance );
end

function CPed:IsChoking()
	return isPedChoking( self.__instance );
end

function CPed:SetDoingDriveby( state )
	return setPedDoingGangDriveby( self.__instance, tobool( state ) );
end

function CPed:IsDoingDriveby()
	return isPedDoingGangDriveby( self.__instance );
end

function CPed:IsDucked()
	return isPedDucked( self.__instance );
end

function CPed:IsHeadless()
	return isPedHeadless( self.__instance );
end

function CPed:IsInVehicle()
	return isPedInVehicle( self.__instance );
end

function CPed:IsOnFire()
	return isPedOnFire( self.__instance );
end

function CPed:IsOnGround()
	return isPedOnGround( self.__instance );
end

function CPed:SetAnimation( ... )
	return setPedAnimation( self.__instance, ... );
end

function CPed:SetAnimationProgress( anim, progress )
	return setPedAnimationProgress( self.__instance, anim, progress );
end

function CPed:SetHeadless( bState )
	return setPedHeadless( self.__instance, (bool)(bState) );
end

function CPed:SetOnFire( bFire )
	return setPedOnFire( self.__instance, (bool)(bFire) );
end

function CPed:SetWalkingStyle( iStyle )
	return setPedWalkingStyle( self.__instance, iStyle );
end

-- Client

function CPed:GetBonePosition( iBone )
	local fX, fY, fZ = getPedBonePosition( self.__instance, iBone );
	
	return fX and Vector3( fX, fY, fZ );
end