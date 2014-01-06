-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

FLOAT_EPSILON = 0.0001

class "Vector3"

function Vector3:Vector3( fX, fY, fZ )
	if type( fX ) == 'string' and fX[ 1 ] == '(' and fX[ fX:len() ] == ')' then
		local Vector = fX:gsub( ' ', '' ):gsub( '%(', '' ):gsub( '%)', '' ):split( ',' );
		
		if Vector and table.getn( Vector ) == 3 then
			self.X = (float)(Vector[ 1 ]);
			self.Y = (float)(Vector[ 2 ]);
			self.Z = (float)(Vector[ 3 ]);
			
			return;
		end
	end
	
	self.X = (float)(fX);
	self.Y = (float)(fY);
	self.Z = (float)(fZ);
end

function Vector3:Normalize()
	local fLength = self:Length();
	
	if fLength > FLOAT_EPSILON then
		self.X = self.X / fLength;
		self.Y = self.Y / fLength;
		self.Z = self.Z / fLength;
		
		return fLength;
	end
	
	return 0;
end

function Vector3:Length()
    return math.sqrt( self:LengthSquared() );
end

function Vector3:LengthSquared()
    return self.X * self.X + self.Y * self.Y + self.Z * self.Z;
end

function Vector3:DotProduct( vecParam )
	return self.X * vecParam.X + self.Y * vecParam.Y + self.Z * vecParam.Z;
end

function Vector3:Cross( vecParam )
	return Vector3(
		self.Y * vecParam.Z - self.Z * vecParam.Y,
		self.Z * vecParam.X - self.X * vecParam.Z,
		self.X * vecParam.Y - self.Y * vecParam.X
	);
end

function Vector3:CrossProduct( vecParam ) 
	local fX, fY, fZ = self.X, self.Y, self.Z;
	
	self.X = fY * vecParam.Z - vecParam.Y * fZ;
	self.Y = fZ * vecParam.X - vecParam.Z * fX;
	self.Z = fX * vecParam.Y - vecParam.X * fY;
end

function Vector3:GetTriangleNormal( vec1, vec2 )
	return ( vec1 - self ):Cross( vec2 - self );
end

function Vector3:GetRotation( vecTarget )
	local fX = 0;
	local fY = 0;
	local fZ = ( 360 - math.deg( math.atan2( vecTarget.X - self.X, vecTarget.Y - self.Y ) ) ) % 360;
	
	return Vector3( fX, fY, fZ );
end

function Vector3:Rotate( fAngle )
	fAngle	= math.rad( fAngle );
	
	return Vector3(
		self.X * math.cos( fAngle ) - self.Y * math.sin( fAngle ), 
		self.X * math.sin( fAngle ) + self.Y * math.cos( fAngle ), 
		self.Z 
	);
end

function Vector3:Distance( vecPosition )
	local fDistanceX = vecPosition.X - self.X;
	local fDistanceY = vecPosition.Y - self.Y;
	local fDistanceZ = vecPosition.Z - self.Z;

	return math.sqrt( fDistanceX * fDistanceX + fDistanceY * fDistanceY + fDistanceZ * fDistanceZ );
end

function Vector3:Dot( vecPosition )
	return self.X * vecPosition.X + self.Y * vecPosition.Y + self.Z * vecPosition.Z;
end

function Vector3:Offset( fDistance, fRotation )
	fDistance	= (float)(fDistance);
	fRotation	= (float)(fRotation);
	
	return Vector3( 
		self.X + ( ( math.cos( math.rad( fRotation + 90 ) ) ) * fDistance ), 
		self.Y + ( ( math.sin( math.rad( fRotation + 90 ) ) ) * fDistance ), 
		self.Z
	);
end

function Vector3:IsLineOfSightClear( vecEnd, bCheckBuildings, bCheckVehicles, bCheckPeds, bCheckObjects, bCheckDummies, bSeeThroughStuff, bIgnoreSomeObjectsForCamera, pIgnoredElement )
	return isLineOfSightClear( self.X, self.Y, self.Z, vecEnd.X, vecEnd.Y, vecEnd.Z,
		bCheckBuildings		== NULL or bCheckBuildings,
		bCheckVehicles		== NULL or bCheckVehicles,
		bCheckPeds			== NULL or bCheckPeds,
		bCheckObjects		== NULL or bCheckObjects,
		bCheckDummies		== NULL or bCheckDummies, 
		(bool)(bSeeThroughStuff), (bool)(bIgnoreSomeObjectsForCamera), pIgnoredElement
	);
end

-- // Operators

function Vector3.Add( vLeft, vRight )
	local bVector = classname( vLeft ) == 'Vector3';
	
    return Vector3( ( bVector and vLeft.X or vLeft ) + ( bVector and vRight.X or vRight ), ( bVector and vLeft.Y or vLeft ) + ( bVector and vRight.Y or vRight ), ( bVector and vLeft.Z or vLeft ) + ( bVector and vRight.Z or vRight ) );
end

function Vector3.Sub( vLeft, vRight )
    return Vector3(
		( classname( vLeft ) == 'Vector3' and vLeft.X or vLeft ) - ( classname( vRight ) == 'Vector3' and vRight.X or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Y or vLeft ) - ( classname( vRight ) == 'Vector3' and vRight.Y or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Z or vLeft ) - ( classname( vRight ) == 'Vector3' and vRight.Z or vRight ) 
	);
end

function Vector3.Mul( vLeft, vRight )
    return Vector3(
		( classname( vLeft ) == 'Vector3' and vLeft.X or vLeft ) * ( classname( vRight ) == 'Vector3' and vRight.X or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Y or vLeft ) * ( classname( vRight ) == 'Vector3' and vRight.Y or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Z or vLeft ) * ( classname( vRight ) == 'Vector3' and vRight.Z or vRight ) 
	);
end

function Vector3.Div( vLeft, vRight )
    return Vector3(
		( classname( vLeft ) == 'Vector3' and vLeft.X or vLeft ) / ( classname( vRight ) == 'Vector3' and vRight.X or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Y or vLeft ) / ( classname( vRight ) == 'Vector3' and vRight.Y or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Z or vLeft ) / ( classname( vRight ) == 'Vector3' and vRight.Z or vRight ) 
	);
end

function Vector3.Pow( vLeft, vRight )
	return Vector3(
		( classname( vLeft ) == 'Vector3' and vLeft.X or vLeft ) ^ ( classname( vRight ) == 'Vector3' and vRight.X or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Y or vLeft ) ^ ( classname( vRight ) == 'Vector3' and vRight.Y or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Z or vLeft ) ^ ( classname( vRight ) == 'Vector3' and vRight.Z or vRight ) 
	);
end

function Vector3.Mod( vLeft, vRight )
    return Vector3(
		( classname( vLeft ) == 'Vector3' and vLeft.X or vLeft ) % ( classname( vRight ) == 'Vector3' and vRight.X or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Y or vLeft ) % ( classname( vRight ) == 'Vector3' and vRight.Y or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Z or vLeft ) % ( classname( vRight ) == 'Vector3' and vRight.Z or vRight ) 
	);
end

function Vector3.Equality( vLeft, vRight )
	return Vector3(
		( classname( vLeft ) == 'Vector3' and vLeft.X or vLeft ) == ( classname( vRight ) == 'Vector3' and vRight.X or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Y or vLeft ) == ( classname( vRight ) == 'Vector3' and vRight.Y or vRight ),
		( classname( vLeft ) == 'Vector3' and vLeft.Z or vLeft ) == ( classname( vRight ) == 'Vector3' and vRight.Z or vRight ) 
	);
end

function Vector3:ToString()
	return '(' + self.X + ',' + self.Y + ',' + self.Z + ')';
end

function Vector3:Concat( void )
	return (string)(self) + (string)(void);
end

Vector3.DistanceTo	= Vector3.Distance;
Vector3.__add		= Vector3.Add;
Vector3.__sub		= Vector3.Sub;
Vector3.__mul		= Vector3.Mul;
Vector3.__div		= Vector3.Div;
Vector3.__pow		= Vector3.Pow;
Vector3.__mod		= Vector3.Mod;
Vector3.__eq		= Vector3.Equality;
Vector3.__len		= Vector3.Length;
Vector3.__tostring	= Vector3.ToString;
Vector3.__concat	= Vector3.Concat;