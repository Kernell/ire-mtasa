-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

enum "ePedAnimation"
{
	"PED_ANIMATION_LIB";
	"PED_ANIMATION_NAME";
	"PED_ANIMATION_TIME";
	"PED_ANIMATION_LOOP";
	"PED_ANIMATION_UPDATE_POS";
	"PED_ANIMATION_INTERRUPTABLE";
	"PED_ANIMATION_FREEZE_LAST_FRAME";
};

class: CPed ( CElement )
{
	property: Vehicle
	{
		get	= getPedOccupiedVehicle;
		
		set	= function( this, pVehicle )
			if pVehicle then
				if getElementType( pVehicle ) == "vehicle" then
					this:WarpIntoVehicle( pVehicle, 0 );
				elseif type( pVehicle ) == "table" then
					if getElementType( pVehicle ) ~= "vehicle" then
						Error( 3, 2342, "Vehicle", "element:vehicle", tostring( pVehicle ) );
					end
					
					this:WarpIntoVehicle( pVehicle[ 1 ], pVehicle[ 2 ] );
				else
					Error( 3, 2342, "Vehicle", "element:vehicle' or 'table", tostring( pVehicle ) );
				end
			else
				this:RemoveFromVehicle();
			end
		end;
	};
	
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
	
	-- Server
	
	GetFightingStyle		= getPedFightingStyle;
	SetFightingStyle		= setPedFightingStyle;
	GetGravity				= getPedGravity;
	SetGravity				= setPedGravity;
	GetVehicleSeat			= getPedOccupiedVehicleSeat;
	GiveJetPack				= givePedJetPack;
	RemoveJetPack			= removePedJetPack;
	IsDead					= isPedDead;
	Kill					= killPed;
	ReloadWeapon			= reloadPedWeapon;
	RemoveFromVehicle		= removePedFromVehicle;
	SetArmor				= setPedArmor;
	SetChoking				= setPedChoking;
	SetStat					= setPedStat;
	WarpInVehicle			= warpPedIntoVehicle;
	GiveWeapon				= giveWeapon;
	SetWeaponAmmo			= setWeaponAmmo;
	TakeAllWeapons			= takeAllWeapons;
};