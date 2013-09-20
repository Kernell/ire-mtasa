-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0
-- http://wat.gamedev.ru/articles/quaternions
-- http://www.gamedev.ru/code/articles/?id=4215

class "Vector4";

function Vector4:Vector4( fX, fY, fZ, fW )
	if type( fX ) == 'table' then -- Преобразование матрицы в кватернион
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
	
	self.X	= (float)(fX);
	self.Y	= (float)(fY);
	self.Z	= (float)(fZ);
	self.W	= (float)(fW);
end

function Vector4:Mul( q2 )
	local A, B, C, D, E, F, G, H;

	A = ( self.W + self.X ) * ( q2.W + q2.X );
	B = ( self.Z - self.Y ) * ( q2.Y - q2.Z );
	C = ( self.X - self.W ) * ( q2.Y + q2.Z );
	D = ( self.Y + self.Z ) * ( q2.X - q2.W );
	E = ( self.X + self.Z ) * ( q2.X + q2.Y );
	F = ( self.X - self.Z ) * ( q2.X - q2.Y );
	G = ( self.W + self.Y ) * ( q2.W - q2.Z );
	H = ( self.W - self.Y ) * ( q2.W + q2.Z );
	
	return Vector4(
		B + (-E - F + G + H ) * 0.5,
		A - ( E + F + G + H ) * 0.5, 
		-C + ( E - F + G - H ) * 0.5,
		-D + ( E - F - G + H ) * 0.5
	);
end

function Vector4:Slerp( p, t )
	local p1 = {};
	
	local omega, sinom, scale0, scale1;
	
	local cosom = self.X * p.X + self.Y * p.Y + self.Z * p.Z + self.W * p.W;
	
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
end