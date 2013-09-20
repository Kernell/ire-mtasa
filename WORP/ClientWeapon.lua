-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local OnPlayerFire, OnClientPreFire, OnClientFire, OnDataChange;

local DisableSounds	=
{
	[2]		= true;
	[3]		= true;
	[4]		= true;
	[5]		= true;
	[6]		= true;
	[7]		= true;
	[8]		= true;
	[17]	= true;
	[18]	= true;
	[19]	= true;
	[21]	= true;
	[22]	= true;
	[23]	= true;
	[24]	= true;
	[29]	= true;
	[26]	= true;
	[27]	= true;
	[30]	= true;
	[33]	= true;
	[52]	= true;
	[53]	= true;
	[72]	= true;
	[73]	= true;
	[74]	= true;
	[76]	= true;
	[77]	= true;
};

for iIndex, bDisabled in pairs( DisableSounds ) do
	setWorldSoundEnabled( 5, iIndex, not bDisabled );
end

CLIENT.m_pWeapon		= NULL;
CLIENT.m_iShootsCount	= 0;

function CPlayer:PlayWeaponSound( SoundID )
	local pWeapon = self:GetData( "m_pWeapon" );
	
	if pWeapon then
		local Sound = pWeapon[ "m_Sound" + SoundID ];
		
		if Sound then
			local pSound = playSound3D( "Resources/Sounds/Weapons/" + Sound[ 1 ], getElementPosition( self ) );
			
			if pSound then
				setSoundVolume		( pSound, Sound[ 2 ] );
				setSoundMinDistance	( pSound, 5.0 );
				setSoundMaxDistance	( pSound, Sound[ 3 ] );
				setElementDimension	( pSound, self:GetDimension() );
				setElementInterior	( pSound, self:GetInterior() );
			end
		end
	end
end

CPed.PlayWeaponSound = CPlayer.PlayWeaponSound;

function OnPlayerFire( iWeaponID )
	if iWeaponID > 0 then
		source:PlayWeaponSound( "Shoot" );
	end
end

function OnDataChange( sDataName, vPrevValue )
	if sDataName == "Weapon::SoundEmptyPlay" then
		source:PlayWeaponSound( "Empty" );
	elseif sDataName == "m_pWeapon" and source == CLIENT then
		CLIENT.m_pWeapon	= CLIENT:GetData( sDataName ) or NULL;
		
		setControlState( 'fire', false );
	end
end

function OnClientPreStopFire()
	if CLIENT.m_pWeapon then
		local FireMode	= CLIENT.m_pWeapon.m_FireModes and CLIENT.m_pWeapon.m_FireModes[ CLIENT.m_pWeapon.m_Data.m_iFireMode or 1 ];
		
		if FireMode and FireMode > 0 then
			if CLIENT.m_iShootsCount < FireMode then
				-- setControlState( 'fire', true );
				
				return;
			end
		end	
	end
	
	CLIENT.m_iShootsCount = 0;
	
	setControlState( 'fire', false );
end

local iTickLast = 0;

function OnClientPreFire()
	if getPedWeapon( CLIENT ) ~= 0 and CLIENT.m_pWeapon then
		if CLIENT.m_pWeapon.m_iValue > 0 and
			not CLIENT.m_pWeapon.m_bFail and
			math.random( 0, 100 ) / 100 <= CLIENT.m_pWeapon.m_fMisfireProbability / CLIENT.m_pWeapon.m_fCondition 
		then
			CLIENT.m_pWeapon.m_bFail = true;
		end
		
		if CLIENT.m_pWeapon.m_bFail or CLIENT.m_pWeapon.m_iValue == 0 then
			local iTick = getTickCount();
			
			if iTick - iTickLast > 400 then
				CLIENT:SetData( "Weapon::SoundEmptyPlay", iTick );
				
				iTickLast = iTick;
			end
			
			CLIENT.m_iShootsCount = 0;
			
			setControlState( 'fire', false );
			
			if CLIENT.m_pWeapon.m_bFail then
				Hint( "Info", "Оружие заклинило, нажмите R для перезарядки", "info" );
			end
			
			return;
		end
	end
	
	setControlState( 'fire', true );
end

function OnClientFire( iWeaponID )
	if iWeaponID > 0 and CLIENT.m_pWeapon then
		CLIENT.m_iShootsCount = CLIENT.m_iShootsCount + 1;
		
		if CLIENT.m_pWeapon.m_iValue > 0 then
			CLIENT.m_pWeapon.m_iValue = CLIENT.m_pWeapon.m_iValue - 1;
		end
		
		if math.random( 0, 100 ) / 100 <= CLIENT.m_pWeapon.m_fMisfireProbability / CLIENT.m_pWeapon.m_fCondition then
			CLIENT.m_pWeapon.m_bFail = true;
		end
		
		if CLIENT.m_pWeapon.m_bFail or CLIENT.m_pWeapon.m_iValue == 0 then
			CLIENT:SetData( "Weapon::SoundEmptyPlay", getTickCount() );
			
			CLIENT.m_iShootsCount = 0;
			
			setControlState( 'fire', false );
			
			if CLIENT.m_pWeapon.m_bFail then
				Hint( "Info", "Оружие заклинило, нажмите R для перезарядки", "info" );
			end
		end
		
		local FireMode	= CLIENT.m_pWeapon.m_FireModes[ CLIENT.m_pWeapon.m_Data.m_iFireMode or 1 ];
		
		if FireMode and FireMode > 0 then
			if CLIENT.m_iShootsCount >= FireMode then
				CLIENT.m_iShootsCount = 0;
				
				setControlState( 'fire', false );
			end
		end
		
		CLIENT.m_pWeapon.m_fCondition = Clamp( 0.0, CLIENT.m_pWeapon.m_fCondition - CLIENT.m_pWeapon.m_fConditionShotDec, 100.0 );
		
		triggerLatentServerEvent( "onPlayerWeaponFire", 128000, false, source, CLIENT.m_pWeapon.m_iValue, CLIENT.m_pWeapon.m_fCondition );
	end
end

addEventHandler( "onClientPlayerWeaponFire", 	CLIENT, OnClientFire );
addEventHandler( "onClientPlayerWeaponFire", 	root, 	OnPlayerFire );
addEventHandler( "onClientPedWeaponFire", 		root, 	OnPlayerFire );
addEventHandler( "onClientElementDataChange", 	root, 	OnDataChange );

toggleControl( "fire", false );

bindKey( "fire", "up", OnClientPreStopFire );
bindKey( "fire", "down", OnClientPreFire );