-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CPed ( CElement )
{
	CPed		= function( this, iModel, vecPosition, ... )
		vecPosition = vecPosition or Vector3();
		
		local pPed = createPed( iModel, vecPosition.X, vecPosition.Y, vecPosition.Z, ... );
		
		pPed( this );
		
		return pPed;
	end;
	
	_CPed					= destroyElement;
	
	WarpIntoVehicle			= warpPedIntoVehicle;
	RemoveFromVehicle		= removePedFromVehicle;
	AddClothes				= addPedClothes;
	GetClothes				= getPedClothes;
	RemoveClothes			= removePedClothes;
	HaveJetPack				= doesPedHaveJetPack;
	GetWeapon				= getPedWeapon;
	SetWeaponSlot			= setPedWeaponSlot;
	GetWeaponSlot			= getPedWeaponSlot;
	GetAmmoInClip			= getPedAmmoInClip;
	GetTotalAmmo			= getPedTotalAmmo;
	GetArmor				= getPedArmor;
	GetContactElement		= getPedContactElement;
	GetVehicle				= getPedOccupiedVehicle;
	GetStat					= getPedStat;
	GetTarget				= getPedTarget;
	IsChoking				= isPedChoking;
	SetDoingDriveby			= setPedDoingGangDriveby;
	IsDoingDriveby			= isPedDoingGangDriveby;
	IsDucked				= isPedDucked;
	IsHeadless				= isPedHeadless;
	IsInVehicle				= isPedInVehicle;
	IsOnFire				= isPedOnFire;
	IsOnGround				= isPedOnGround;
	SetAnimation			= setPedAnimation;
	SetAnimationProgress	= setPedAnimationProgress;
	SetHeadless				= setPedHeadless;
	SetOnFire				= setPedOnFire;
	SetWalkingStyle			= setPedWalkingStyle;
	
	-- Client
	
	GetBonePosition			= function( this, iBone )
		return Vector3( getPedBonePosition( this, iBone ) );
	end;
	
	GetAnimation			= getPedAnimation;
	GetAnimationData		= getPedAnimationData;
	GetMoveState			= getPedMoveState;
	GetTask					= getPedTask;
	IsDoingTask				= isPedDoingTask;
	GetSimplestTask			= getPedSimplestTask;
	SetCanBeKnockedOffBike	= setPedCanBeKnockedOffBike;
	CanBeKnockedOffBike		= canPedBeKnockedOffBike;
	GetTargetRange			= getPedTargetRange;
	
	GetTargetCollision		= function( this )
		return Vector3( getPedTargetCollision( this ) );
	end;

	GetTargetStart			= function( this )
		return Vector3( getPedTargetStart( this ) );
	end;

	GetTargetEnd			= function( this )
		return Vector3( getPedTargetEnd( this ) );
	end;

	SetVoice				= setPedVoice;
	GetVoice				= getPedVoice;

	GetWeaponMuzzlePosition	= function( this )
		return Vector3( getPedWeaponMuzzlePosition( this ) );
	end;

	SetAimTarget			= function( this, pVector )
		pVector = pVector or Vector3();
		
		return setPedAimTarget( this, pVector.X, pVector.Y, pVector.Z );
	end;

	SetCameraRotation		= setPedCameraRotation;
	SetControlState			= setPedControlState;
	GetControlState			= getPedControlState;

	SetLookAt				= function( this, pVector, ... )
		pVector = pVector or Vector3();
		
		return setPedLookAt( this, pVector.X, pVector.Y, pVector.Z, ... );
	end;
};