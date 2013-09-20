-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function CPed:CPed( ... )
	local arg = { ... };
	
	if type( arg[ 1 ] ) == 'number' then
		local vecPosition	= arg[ 2 ] or Vector3();
		local bSynced		= arg[ 4 ] == NULL or (bool)(arg[ 4 ]);
	
		self.__instance = createPed( (int)(arg[ 1 ]), vecPosition.X, vecPosition.Y, vecPosition.Z, (float)(arg[ 3 ]), bSynced );
		
		CElement.SetRotation( self.__instance, Vector3( 0, 0, (float)(arg[ 3 ]) ) );
		
		if not self.__instance then
			Debug( "failed to create ped", 1 );
			
			self.m_ID = INVALID_ELEMENT_ID;
		end
		
		self:CElement( self.__instance );
		self.CElement = NULL;
	elseif arg[ 1 ] and isElement( arg[ 1 ] ) then
		self.__instance = arg[ 1 ];
	end
end

function CPed:_CPed()
	destroyElement( self.__instance );
	
	g_pGame:GetPedManager():RemoveFromList( self );
	
	CElement.RemoveFromList( self );
end

function CPed:DoPulse( tReal )
	local iTick = getTickCount();
	
	if self.m_sAnimLib and self.m_iAnimTime > 50 then
		if iTick - (int)(self.m_iAnimStart) > self.m_iAnimTime then
			self:SetAnimation( self.m_sAnimLib, self.m_sAnimName, self.m_iAnimTime, self.m_bAnimLoop, self.m_bAnimUpdatePos, self.m_bAnimInterruptable, self.m_bAnimFreezeLastFrame );
			
			self.m_iAnimStart = iTick;
		end
	end
end

function CPed:GetFightingStyle()
	return getPedFightingStyle( self.__instance );
end

function CPed:SetFightingStyle( iStyle )
	return setPedFightingStyle( self.__instance, iStyle );
end

function CPed:GetGravity()
	return getPedGravity( self.__instance );
end

function CPed:SetGravity( fGravity )
	return setPedGravity( self.__instance, fGravity );
end

function CPed:GetVehicleSeat()
	return getPedOccupiedVehicleSeat( self.__instance );
end

function CPed:GiveJetPack()
	return givePedJetPack( self.__instance );
end

function CPed:RemoveJetPack()
	return removePedJetPack( self.__instance );
end

function CPed:IsDead()
	return isPedDead( self.__instance );
end

function CPed:Kill( pKiller, iWeapon, iBodyPart, bStealth )
	return killPed( self.__instance, pKiller ~= NULL and pKiller.__instance, tonumber( iWeapon ) or 255, tonumber( iBodyPart ) or 255, (bool)(bStealth) );
end

function CPed:ReloadWeapon()
	return reloadPedWeapon( self.__instance );
end

function CPed:RemoveFromVehicle()
	return removePedFromVehicle( self.__instance );
end

function CPed:SetArmor( fArmor )
	return setPedArmor( self.__instance, fArmor );
end

function CPed:SetChoking( bChoking )
	return setPedChoking( self.__instance, (bool)(bChoking) );
end

function CPed:SetStat( stat, value )
	return setPedStat( self.__instance, stat, value );
end

function CPed:WarpInVehicle( pVehicle, iSeat )
	return warpPedIntoVehicle( self.__instance, pVehicle ~= NULL and pVehicle.__instance, (int)(iSeat) );
end

function CPed:GiveWeapon( iWeapon, iAmmo, bCurrent )
	return giveWeapon( self.__instance, iWeapon, tonumber( iAmmo ) or 30, (bool)(bCurrent) )
end

function CPed:SetWeaponAmmo( ... )
	return setWeaponAmmo( self.__instance, ... );
end

function CPed:TakeAllWeapons()
	return takeAllWeapons( self.__instance );
end