-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: Vector3
{
	static
	{
		FLOAT_EPSILON = 0.0001;
	};
	
	Vector3				= function( this, fX, fY, fZ )
		if type( fX ) == "string" and fX[ 1 ] == '(' and fX[ -1 ] == ')' then
			local pVector = fX:gsub( ' ', '' ):gsub( '%(', '' ):gsub( '%)', '' ):split( ',' );
			
			if pVector and table.getn( pVector ) == 3 then
				this:Set( (float)(pVector[ 1 ]), (float)(pVector[ 2 ]), (float)(pVector[ 3 ]) );
				
				return;
			end
		end
		
		this:Set( fX, fY, fZ );
	end;
	
	Set					= function( this, fX, fY, fZ )
		this.X 	= (float)(fX);
		this.Y 	= (float)(fY);
		this.Z 	= (float)(fZ);
	end;
	
	Lerp				= function( this, pVector3, fProgress )
		return this + ( pVector3 - this ) * Clamp( 0.0, fProgress, 1.0 );
	end;
	
	Normalize			= function( this )
		local fLength = this:Length();
		
		if fLength > Vector3.FLOAT_EPSILON then
			this.X = this.X / fLength;
			this.Y = this.Y / fLength;
			this.Z = this.Z / fLength;
			
			return fLength;
		end
		
		return 0;
	end;
	
	Length				= function( this )
		return math.sqrt( this:LengthSquared() );
	end;
	
	LengthSquared		= function( this )
		return this.X * this.X + this.Y * this.Y + this.Z * this.Z;
	end;
	
	DotProduct			= function( this, pVector )
		return this.X * pVector.X + this.Y * pVector.Y + this.Z * pVector.Z;
	end;
	
	Cross				= function( this, pVector )
		return Vector3(
			this.Y * pVector.Z - this.Z * pVector.Y,
			this.Z * pVector.X - this.X * pVector.Z,
			this.X * pVector.Y - this.Y * pVector.X
		);
	end;
	
	CrossProduct		= function( this, pVector )
		local fX, fY, fZ = this.X, this.Y, this.Z;
		
		this.X	= fY * pVector.Z - pVector.Y * fZ;
		this.Y	= fZ * pVector.X - pVector.Z * fX;
		this.Z	= fX * pVector.Y - pVector.X * fY;
	end;
	
	GetTriangleNormal	= function( this, pVector1, pVector2 )
		return ( pVector1 - this ):Cross( pVector2 - this );
	end;
	
	GetRotation			= function( this, pVector )
		local fX	= 0.0;
		local fY	= 0.0;
		local fZ	= ( 360.0 - math.deg( math.atan2( pVector.X - this.X, pVector.Y - this.Y ) ) ) % 360.0;
		
		return Vector3( fX, fY, fZ );
	end;
	
	Rotate				= function( this, fAngle )
		fAngle	= math.rad( fAngle );
		
		return Vector3(
			this.X * math.cos( fAngle ) - this.Y * math.sin( fAngle ), 
			this.X * math.sin( fAngle ) + this.Y * math.cos( fAngle ), 
			this.Z 
		);
	end;

	Distance			= function( this, pVector )
		return ( pVector - this ):Length();
	end;

	Dot					= function( this, pVector )
		return this.X * pVector.X + this.Y * pVector.Y + this.Z * pVector.Z;
	end;

	Offset				= function( this, fDistance, fRotation )
		fDistance	= (float)(fDistance);
		fRotation	= (float)(fRotation);
		
		return Vector3( 
			this.X + ( ( math.cos( math.rad( fRotation + 90.0 ) ) ) * fDistance ), 
			this.Y + ( ( math.sin( math.rad( fRotation + 90.0 ) ) ) * fDistance ), 
			this.Z
		);
	end;

	IsLineOfSightClear	= function( this, pVector, ... )
		return isLineOfSightClear( this.X, this.Y, this.Z, pVector.X, pVector.Y, pVector.Z, ... );
	end;
	
	Add					= function( this, pVector )
		if classname( this ) ~= "Vector3" then Error( 2, 2288 ); end
		
		local fX, fY, fZ = this.X, this.Y, this.Z;
		
		if classname( pVector ) == "Vector3" then
			fX = fX + pVector.X;
			fY = fY + pVector.Y;
			fZ = fZ + pVector.Z;
		else
			fX = fX + pVector;
			fY = fY + pVector;
			fZ = fZ + pVector;
		end
		
		return Vector3( fX, fY, fZ );
	end;

	Sub					= function( this, pVector )
		if classname( this ) ~= "Vector3" then Error( 2, 2288 ); end
		
		local fX, fY, fZ = this.X, this.Y, this.Z;
		
		if classname( pVector ) == "Vector3" then
			fX = fX - pVector.X;
			fY = fY - pVector.Y;
			fZ = fZ - pVector.Z;
		else
			fX = fX - pVector;
			fY = fY - pVector;
			fZ = fZ - pVector;
		end
		
		return Vector3( fX, fY, fZ );
	end;
	
	Mul					= function( this, pVector )
		if classname( this ) ~= "Vector3" then Error( 2, 2288 ); end
		
		local fX, fY, fZ = this.X, this.Y, this.Z;
		
		if classname( pVector ) == "Vector3" then
			fX = fX * pVector.X;
			fY = fY * pVector.Y;
			fZ = fZ * pVector.Z;
		else
			fX = fX * pVector;
			fY = fY * pVector;
			fZ = fZ * pVector;
		end
		
		return Vector3( fX, fY, fZ );
	end;
	
	Div					= function( this, pVector )
		if classname( this ) ~= "Vector3" then Error( 2, 2288 ); end
		
		local fX, fY, fZ = this.X, this.Y, this.Z;
		
		if classname( pVector ) == "Vector3" then
			fX = fX / pVector.X;
			fY = fY / pVector.Y;
			fZ = fZ / pVector.Z;
		else
			fX = fX / pVector;
			fY = fY / pVector;
			fZ = fZ / pVector;
		end
		
		return Vector3( fX, fY, fZ );
	end;
	
	Pow					= function( this, pVector )
		if classname( this ) ~= "Vector3" then Error( 2, 2288 ); end
		
		local fX, fY, fZ = this.X, this.Y, this.Z;
		
		if classname( pVector ) == "Vector3" then
			fX = fX ^ pVector.X;
			fY = fY ^ pVector.Y;
			fZ = fZ ^ pVector.Z;
		else
			fX = fX ^ pVector;
			fY = fY ^ pVector;
			fZ = fZ ^ pVector;
		end
		
		return Vector3( fX, fY, fZ );
	end;
	
	Mod					= function( this, pVector )
		if classname( this ) ~= "Vector3" then Error( 2, 2288 ); end
		
		local fX, fY, fZ = this.X, this.Y, this.Z;
		
		if classname( pVector ) == "Vector3" then
			fX = fX % pVector.X;
			fY = fY % pVector.Y;
			fZ = fZ % pVector.Z;
		else
			fX = fX % pVector;
			fY = fY % pVector;
			fZ = fZ % pVector;
		end
		
		return Vector3( fX, fY, fZ );
	end;
	
	Equality			= function( this, pVector )
		if classname( pVector ) == "Vector3" then
			return this.X == pVector.X and this.Y == pVector.Y and this.Z == pVector.Z;
		end
		
		return this.X == pVector and this.Y == pVector and this.Z == pVector;
	end;
	
	ToString			= function( this )
		return '(' + this.X + ',' + this.Y + ',' + this.Z + ')';
	end;
	
	Concat				= function( this, void )
		return (string)(this) + (string)(void);
	end;
	
	property: Back
	{
		get		= function( this )
			return Vector3( 0.0, -1.0, 0.0 );
		end;
	};
	
	property: Down
	{
		get		= function( this )
			return Vector3( 0.0, 0.0, -1.0 );
		end;
	};
	
	property: Forward
	{
		get		= function( this )
			return Vector3( 0.0, 1.0, 0.0 );
		end;
	};
	
	property: Left
	{
		get		= function( this )
			return Vector3( -1.0, 0.0, 0.0 );
		end;
	};
	
	property: One
	{
		get		= function( this )
			return Vector3( 1.0, 1.0, 1.0 );
		end;
	};
	
	property: Right
	{
		get		= function( this )
			return Vector3( 1.0, 0.0, 0.0 );
		end;
	};
	
	property: Up
	{
		get		= function( this )
			return Vector3( 0.0, 0.0, 1.0 );
		end;
	};
	
	property: Zero
	{
		get		= function( this )
			return Vector3( 0.0, 0.0, 0.0 );
		end;
	};
	
	property: Magnitude
	{
		get		= function( this )
			return this:LengthSquared();
		end;
	};
	
	property: SqrMagnitude
	{
		get		= function( this )
			return this:Length();
		end;
	};
	
	property: Normalized
	{
		get		= function( this )
			local fLength = this:Length();
			
			if fLength > Vector3.FLOAT_EPSILON then
				return fLength;
			end
			
			return 0;
		end;
	};
};

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