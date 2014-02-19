-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0
-- http://wat.gamedev.ru/articles/quaternions
-- http://www.gamedev.ru/code/articles/?id=4215

class: Vector4
{
	Vector4	= function( this, fX, fY, fZ, fW )
		if type( fX ) == "table" then
			local Matrix	= fX;
			
			local s		= 0;
			
			local tr	= Matrix[ 0 ][ 0 ] + Matrix[ 1 ][ 1 ] + Matrix[ 2 ][ 2 ];
			
			if tr > 0.0 then
				s = math.sqrt( tr + 1.0 );
				
				fW = s / 2.0;
				
				s	= 0.5 / s;
				
				fX	= ( Matrix[ 1 ][ 2 ] - Matrix[ 2 ][ 1 ] ) * s;
				fY	= ( Matrix[ 2 ][ 0 ] - Matrix[ 0 ][ 2 ] ) * s;
				fZ	= ( Matrix[ 0 ][ 1 ] - Matrix[ 1 ][ 0 ] ) * s;
			else
				local q		= {};
				local nxt	= { 1, 2, 0 };
				
				local i = 0;
				
				if m[ 1 ][ 1 ] > m[ 0 ][ 0 ] then
					i = 1;
				end
				
				if m[ 2 ][ 2 ] > m[ i ][ i ] then
					i = 2;
				end
				
				local j = nxt[ i ];
				local k = nxt[ j ];
				
				s = math.sqrt( ( m[ i ][ i ] - ( m[ j ][ j ] + m[ k ][ k ] ) ) + 1.0 );
				
				q[ i ] = s * 0.5;
				
				if s ~= 0.0 then
					s = 0.5 / s;
				end
				
				q[ 3 ] = ( m[ j ][ k ] - m[ k ][ j ] ) * s;
				q[ j ] = ( m[ i ][ j ] + m[ j ][ i ] ) * s;
				q[ k ] = ( m[ i ][ k ] + m[ k ][ i ] ) * s;
				
				fX = q[ 0 ];
				fY = q[ 1 ];
				fZ = q[ 2 ];
				fW = q[ 3 ];
			end
		end
		
		this.X	= (float)(fX);
		this.Y	= (float)(fY);
		this.Z	= (float)(fZ);
		this.W	= (float)(fW);
	end;

	Mul	= function( this, q2 )
		local A, B, C, D, E, F, G, H;

		A = ( this.W + this.X ) * ( q2.W + q2.X );
		B = ( this.Z - this.Y ) * ( q2.Y - q2.Z );
		C = ( this.X - this.W ) * ( q2.Y + q2.Z );
		D = ( this.Y + this.Z ) * ( q2.X - q2.W );
		E = ( this.X + this.Z ) * ( q2.X + q2.Y );
		F = ( this.X - this.Z ) * ( q2.X - q2.Y );
		G = ( this.W + this.Y ) * ( q2.W - q2.Z );
		H = ( this.W - this.Y ) * ( q2.W + q2.Z );
		
		return Vector4(
			B + (-E - F + G + H ) * 0.5,
			A - ( E + F + G + H ) * 0.5, 
			-C + ( E - F + G - H ) * 0.5,
			-D + ( E - F - G + H ) * 0.5
		);
	end;

	Slerp	= function( this, p, t )
		local p1 = {};
		
		local omega, sinom, scale0, scale1;
		
		local cosom = this.X * p.X + this.Y * p.Y + this.Z * p.Z + this.W * p.W;
		
		if cosom < 0.0 then
			cosom = -cosom;
			
			p1[ 0 ] = -p.X;
			p1[ 1 ] = -p.Y;
			p1[ 2 ] = -p.Z;
			p1[ 3 ] = -p.W;
		else
			p1[ 0 ] = p.X;   
			p1[ 1 ] = p.Y;
			p1[ 2 ] = p.Z;    
			p1[ 3 ] = p.W;
		end
		
		if 1.0 - cosom > DELTA then
			omega	= math.acos( cosom );
			sinom	= math.sin( omega );
			scale0	= math.sin( ( 1.0 - t ) * omega ) / sinom;
			scale1	= math.sin( t * omega ) / sinom;
		else     
			scale0	= 1.0 - t;
			scale1	= t;
		end
		
		return Vector4(
			scale0 * q.X + scale1 * p1[ 0 ],
			scale0 * q.Y + scale1 * p1[ 1 ],
			scale0 * q.Z + scale1 * p1[ 2 ],
			scale0 * q.W + scale1 * p1[ 3 ]
		);
	end;
	
	FromVector3	= function( yaw, pitch, roll )
		yaw		= yaw * math.Deg2Rad;
		pitch 	= pitch * math.Deg2Rad;
		roll	= roll * math.Deg2Rad;
		
		local rollOver2 = roll * 0.5;
		
		local sinRollOver2 = math.sin( rollOver2 );
		local cosRollOver2 = math.cos( rollOver2 );
		
		local pitchOver2 = pitch * 0.5;
		
		local sinPitchOver2 = math.sin( pitchOver2 );
		local cosPitchOver2 = math.cos( pitchOver2 );
		local yawOver2 = yaw * 0.5;
		
		local sinYawOver2 = math.sin( yawOver2 );
		local cosYawOver2 = math.cos( yawOver2 );
		
		local vecResult = new. Vector4;
		
		vecResult.X = cosYawOver2 * sinPitchOver2 * cosRollOver2 + sinYawOver2 * cosPitchOver2 * sinRollOver2;
		vecResult.Y = sinYawOver2 * cosPitchOver2 * cosRollOver2 - cosYawOver2 * sinPitchOver2 * sinRollOver2;
		vecResult.Z = cosYawOver2 * cosPitchOver2 * sinRollOver2 - sinYawOver2 * sinPitchOver2 * cosRollOver2;
		vecResult.W = cosYawOver2 * cosPitchOver2 * cosRollOver2 + sinYawOver2 * sinPitchOver2 * sinRollOver2;
		
		return vecResult;
	end;
	
	FromQ2	= function( q1 )
		local sqx = q1.X * q1.X;
		local sqy = q1.Y * q1.Y;
		local sqz = q1.Z * q1.Z;
		local sqw = q1.W * q1.W;
		
		local unit = sqx + sqy + sqz + sqw; -- if normalised is one, otherwise is correction factor
		
		local test = q1.X * q1.W - q1.Y * q1.Z;
		
		local v = Vector3();
		
		if test > 0.4995 * unit then -- singularity at north pole
			v.Y = 2 * math.atan2( q1.Y, q1.X );
			v.X = math.pi / 2.0;
			v.Z = 0;
			
			return NormalizeAngles( v * math.Rad2Deg );
		end
		
		if test < -0.4995 * unit then -- singularity at south pole
			v.Y = -2 * math.atan2( q1.Y, q1.X );
			v.X = -math.pi / 2;
			v.Z = 0;
			
			return NormalizeAngles( v * math.Rad2Deg );
		end
		
		local q = Vector4( q1.W, q1.Z, q1.X, q1.Y );
		
		v.Y = math.atan2( 2 * q.X * q.W + 2 * q.Y * q.Z, 1 - 2 * ( q.Z * q.Z + q.W * q.W ) );   -- Yaw
		v.X = math.asin( 2 * ( q.X * q.Z - q.W * q.Y ) );                             			-- Pitch
		v.Z = math.atan2( 2 * q.X * q.y + 2 * q.Z * q.w, 1 - 2 * ( q.Y * q.Y + q.Z * q.Z ) );   -- Roll
		
		return NormalizeAngles( v * math.Rad2Deg );
	end;
	
	NormalizeAngles	= function( vecAngles )
		vecAngles.X = NormalizeAngle( vecAngles.X );
		vecAngles.Y = NormalizeAngle( vecAngles.Y );
		vecAngles.Z = NormalizeAngle( vecAngles.Z );
		
		return vecAngles;
	end;
	
	NormalizeAngle	= function( fAngle )
		while fAngle > 360.0 do
			fAngle = fAngle - 360.0;
		end
		
		while fAngle < 0.0 do
			fAngle = fAngle + 360.0;
		end
		
		return fAngle;
	end;
};