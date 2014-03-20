-- Author:      	Kernell
-- Version:     	1.0.0

enum "eBlipSprite"
{
    BLIP_SPRITE_NONE = 0,
    'BLIP_SPRITE_BORDER',
    'BLIP_SPRITE_CENTRE',
    'BLIP_SPRITE_MAP_HERE',
    'BLIP_SPRITE_NORTH',
    'BLIP_SPRITE_AIRYARD',
    'BLIP_SPRITE_GUN',
    'BLIP_SPRITE_BARBERS',
    'BLIP_SPRITE_BIG_SMOKE',
    'BLIP_SPRITE_BOATYARD',
    'BLIP_SPRITE_BURGERSHOT',
    'BLIP_SPRITE_BULLDOZER',
    'BLIP_SPRITE_CAT_PINK',
    'BLIP_SPRITE_CESAR',
    'BLIP_SPRITE_CHICKEN',
    'BLIP_SPRITE_CJ',
    'BLIP_SPRITE_CRASH1',
    'BLIP_SPRITE_DINER',
    'BLIP_SPRITE_EMMETGUN',
    'BLIP_SPRITE_ENEMYATTACK',
    'BLIP_SPRITE_FIRE',
    'BLIP_SPRITE_GIRLFRIEND',
    'BLIP_SPRITE_HOSPITAL',
    'BLIP_SPRITE_LOCO',
    'BLIP_SPRITE_MADDOG',
    'BLIP_SPRITE_MAFIA',
    'BLIP_SPRITE_MCSTRAP',
    'BLIP_SPRITE_MOD_GARAGE',
    'BLIP_SPRITE_OGLOC',
    'BLIP_SPRITE_PIZZA',
    'BLIP_SPRITE_POLICE',
    'BLIP_SPRITE_PROPERTY_GREEN',
    'BLIP_SPRITE_PROPERTY_RED',
    'BLIP_SPRITE_RACE',
    'BLIP_SPRITE_RYDER',
    'BLIP_SPRITE_SAVEHOUSE',
    'BLIP_SPRITE_SCHOOL',
    'BLIP_SPRITE_MYSTERY',
    'BLIP_SPRITE_SWEET',
    'BLIP_SPRITE_TATTOO',
    'BLIP_SPRITE_TRUTH',
    'BLIP_SPRITE_WAYPOINT',
    'BLIP_SPRITE_TORENO_RANCH',
    'BLIP_SPRITE_TRIADS',
    'BLIP_SPRITE_TRIADS_CASINO',
    'BLIP_SPRITE_TSHIRT',
    'BLIP_SPRITE_WOOZIE',
    'BLIP_SPRITE_ZERO',
    'BLIP_SPRITE_DATE_DISCO',
    'BLIP_SPRITE_DATE_DRINK',
    'BLIP_SPRITE_DATE_FOOD',
    'BLIP_SPRITE_TRUCK',
    'BLIP_SPRITE_CASH',
    'BLIP_SPRITE_FLAG',
    'BLIP_SPRITE_GYM',
    'BLIP_SPRITE_IMPOUND',
    'BLIP_SPRITE_RUNWAY_LIGHT',
    'BLIP_SPRITE_RUNWAY',
    'BLIP_SPRITE_GANG_B',
    'BLIP_SPRITE_GANG_P',
    'BLIP_SPRITE_GANG_Y',
    'BLIP_SPRITE_GANG_N',
    'BLIP_SPRITE_GANG_G',
    'BLIP_SPRITE_SPRAY'
};

class "CBlip" ( CElement )

function CBlip:CBlip( vecPosition, ... )
	vecPosition = vecPosition or Vector3();
	
	if classname( vecPosition ) == 'Vector3' then
		self.__instance		= createBlip( vecPosition.X, vecPosition.Y, vecPosition.Z, ... );
	elseif vecPosition:IsElement() then
		self.__instance		= createBlipAttachedTo( vecPosition.__instance, ... );
	else
		error( "Bad argument #1 to 'CBlip.Create (wanted 'Vector3' or 'CElement', got '" + typeof( vecPosition ) + "')'", 2 );
	end
	
	if not self.__instance then error( "failed to create blip", 2 ) end
end

function CBlip:_CBlip()
	self:Destroy();
end

function CBlip:GetColor()
	return getBlipColor( self.__instance );
end

function CBlip:GetIcon()
	return getBlipIcon( self.__instance );
end

function CBlip:GetSize()
	return getBlipSize( self.__instance );
end

function CBlip:SetColor( iRed, iGreen, iBlue, iAlpha )
	local bResult, sError 	= is_type( iRed,	'number', 'iRed' 	);	if not iRed 	then error( sError, 2 ) end
	local bResult, sError 	= is_type( iGreen,	'number', 'iGreen'	);	if not iGreen	then error( sError, 2 ) end
	local bResult, sError 	= is_type( iBlue, 	'number', 'iBlue' 	);	if not iBlue 	then error( sError, 2 ) end
	local bResult, sError 	= is_type( iAlpha,	'number', 'iAlpha' 	);	if not iAlpha 	then error( sError, 2 ) end
	
	return setBlipColor( self.__instance, iRed, iGreen, iBlue, iAlpha );
end

function CBlip:SetIcon( iIcon )
	local bResult, sError 	= is_type( iIcon,	'number', 'iIcon' 	);	if not iIcon 	then error( sError, 2 ) end
	
	return setBlipIcon( self.__instance, iIcon );
end

function CBlip:SetSize( iSize )
	local bResult, sError 	= is_type( iSize,	'number', 'iSize' 	);	if not iSize 	then error( sError, 2 ) end
	
	return setBlipSize( self.__instance, iSize );
end

function CBlip:GetOrdering()
	return getBlipOrdering( self.__instance );
end

function CBlip:SetOrdering( iOrder )
	local bResult, sError 	= is_type( iOrder,	'number', 'iOrder' 	);	if not iOrder 	then error( sError, 2 ) end
	
	return setBlipOrdering( self.__instance, iOrder );
end

function CBlip:GetVisibleDistance()
	return getBlipVisibleDistance( self.__instance );
end

function CBlip:SetVisibleDistance( fDistance )
	local bResult, sError 	= is_type( fDistance,	'number', 'fDistance' 	);	if not fDistance 	then error( sError, 2 ) end
	
	return setBlipVisibleDistance( self.__instance, fDistance );
end