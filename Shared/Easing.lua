-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

Easing =
{
	Linear	= function( this, f )
		return f;
	end;
	
	Swing 	= function( this, f, a, h, g )
		-- return Easing:OutQuad( f, a, h, g );
		return Easing:InOutQuad( f, a, h, g );
	end;

	InQuad	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g;
		
		return h * f * f + a;
	end;
	
	OutQuad		= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g;
		
		return -h * f * ( f - 2 ) + a;
	end;
	
	InOutQuad	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 0.25;
		
		f = f / g / 2;
		
		if f < 1 then
			return h / 2 * f * f + a;
		end
		
		f = f - 1;
		
		return -h / 2 * ( f * ( f - 2 ) - 1 ) + a;
	end;

	InCubic		= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g;
		
		return h * f * f * f + a;
	end;
	
	OutCubic	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g - 1;
		
		return h * ( f * f * f + 1 ) + a;
	end;
	
	InOutCubic	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 0.25;
		
		f = f / g / 2;
		
		if f < 1 then
			return h / 2 * f * f * f + a;
		end
		
		f = f - 2;
		
		return h / 2 * ( f * f * f + 2 ) + a;
	end;
	
	InQuart		= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g;
		
		return h * f * f * f * f + a;
	end;
	
	OutQuart	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g - 1;
		
		return -h * ( f * f * f * f - 1 ) + a;
	end;
	
	InOutQuart	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 0.25;
		
		f = f / g / 2;
		
		if f < 1 then
			return h / 2 * f * f * f * f + a;
		end
		
		f = f - 2;
		
		return -h / 2 * ( f * f * f * f - 2 ) + a;
	end;
	
	InQuint		= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g;
		
		return h * f * f * f * f * f + a;
	end;
	
	OutQuint	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g - 1;
		
		return h * ( f * f * f * f * f + 1 ) + a;
	end;
	
	InSine		= function( this, f, a, h, g)
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		return -h * math.cos( f / g * ( math.pi / 2 ) ) + h + a;
	end;
	
	OutSine		= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		return h * math.sin( f / g * ( math.pi / 2 ) ) + a;
	end;
	
	InOutSine	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		return -h / 2 * ( math.cos( math.pi * f / g ) - 1 ) + a;
	end;
	
	InExpo 		= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		return ( f == 0 ) and a or h * math.pow( 2, 10 * ( f / g - 1 ) ) + a;
	end;
	
	OutExpo		= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		return ( f == g ) and a + h or h * ( -math.pow( 2, -10 * f / g ) + 1 ) + a;
	end;
	
	InOutExpo	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 0.25;
		
		if f == 0 then
			return a
		end
		
		if f == g then
			return a + h;
		end
		
		f = f / g / 2;
		
		if f < 1 then
			return h / 2 * math.pow( 2, 10 * ( f - 1 ) ) + a;
		end
		
		return h / 2 * ( -math.pow( 2, -10 * ( f - 1 ) ) + 2 ) + a;
	end;
	
	InCirc		= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g;
		
		return -h * ( math.sqrt( 1 - f * f ) - 1 ) + a;
	end;
	
	OutCirc		= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g - 1;
		
		return h * math.sqrt( 1 - f * f ) + a;
	end;
	
	InOutCirc	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 0.25;
		
		f = f / g / 2;
		
		if f < 1 then
			return -h / 2 * ( math.sqrt( 1 - f * f ) - 1 ) + a;
		end
		
		f = f - 2;
		
		return h / 2 * ( math.sqrt( 1 - f * f ) + 1 ) + a;
	end;
	
	InElastic	= function( this, h, e, l, k )
		e = e or 0.0;
		l = l or 1.0;
		k = k or 0.5;
		
		local i = 1.70158;
		local j = 0;
		local g = l;
		
		if h == 0 then
			return e;
		end
		
		h = h / k;
		
		if k == 1 then
			return e + l;
		end
		
		if j == 0 then
			j = k * 0.3;
		end
		
		if g < math.abs( l ) then
			g = l;
			
			i = j / 4
		else
			i = j / ( 2 * math.pi ) * math.asin( l / g );
		end
		
		h = h - 1;
		
		return -( g * math.pow( 2, 10 * h ) * math.sin( ( h * k - i ) * ( 2 * math.pi ) / j ) ) + e;
	end;

	OutElastic	= function( this, h, e, l, k )
		e = e or 0.0;
		l = l or 1.0;
		k = k or 1.0;
		
		local i = 1.70158;
		local j = 0;
		local g = l;
		
		if h == 0 then
			return e;
		end
		
		h = h / k;
		
		if h == 1 then
			return e + l
		end
		
		if j == 0 then
			j = k * 0.3;
		end
		
		if g < math.abs( l ) then
			g = l;
			i = j / 4;
		else
			i = j / ( 2 * math.pi ) * math.asin( l / g );
		end
		
		return g * math.pow( 2, -10 * h ) * math.sin( ( h * k - i ) * ( 2 * math.pi ) / j ) + l + e;
	end;
	
	InOutElastic	= function( this, h, e, l, k )
		e = e or 0.0;
		l = l or 1.0;
		k = k or 0.25;
		
		local fOvershoot = 1.70158;
		local j = 0;
		local g = l;
		
		if h == 0 then
			return e;
		end
		
		h = h / k / 2;
		
		if h == 2 then
			return e + l;
		end
		
		if j == 0 then
			j = k * ( 0.3 * 1.5 );
		end
		
		if g < math.abs( l ) then
			g = l;
			fOvershoot = j / 4;
		else
			fOvershoot = j / ( 2 * math.pi ) * math.asin( l / g );
		end
		
		if h < 1 then
			h = h - 1;
			
			return -0.5 * ( g * math.pow( 2, 10 * h ) * math.sin( ( h * k - fOvershoot ) * ( 2 * math.pi ) / j ) ) + e;
		end
		
		h = h - 1;
		
		return g * math.pow( 2, -10 * h ) * math.sin( ( h * k - fOvershoot ) * ( 2 * math.pi ) / j ) * 0.5 + l + e;
	end;
	
	InBack		= function( this, f, a, i, h, fOvershoot )
		a = a or 0.0;
		i = i or 1.0;
		h = h or 1.0;
		
		if fOvershoot == NULL then
			fOvershoot = 1.70158;
		end
		
		f = f / h;
		
		return i * f * f * ( ( fOvershoot + 1 ) * f - fOvershoot ) + a;
	end;
	
	OutBack		= function( this, f, a, i, h, fOvershoot )
		a = a or 0.0;
		i = i or 1.0;
		h = h or 1.0;
		
		if fOvershoot == NULL then
			fOvershoot = 1.70158;
		end
		
		f = f / h - 1;
		
		return i * ( f * f * ( ( fOvershoot + 1 ) * f + fOvershoot ) + 1 ) + a;
	end;
	
	InOutBack	= function( this, f, a, i, h, fOvershoot )
		a = a or 0.0;
		i = i or 1.0;
		h = h or 0.25;
		
		if fOvershoot == NULL then
			fOvershoot = 1.70158
		end
		
		f = f / h / 2;
		
		fOvershoot = fOvershoot * 1.525 ;
		
		if f < 1 then
			return i / 2 * ( f * f * ( ( fOvershoot + 1 ) * f - fOvershoot ) ) + a;
		end
		
		f = f - 2;
		
		return i / 2 *  ( f * f * ( ( fOvershoot + 1 ) * f + fOvershoot ) + 2 ) + a;
	end;
	
	InBounce	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		return h - Easing:OutBounce( g - f, 0, h, g ) + a;
	end;
	
	OutBounce	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		f = f / g;
		
		if f < ( 1 / 2.75 ) then
			return h * ( 7.5625 * f * f ) + a;
		else
			if f < ( 2 / 2.75 ) then
				f = f - ( 1.5 / 2.75 );
				
				return h * ( 7.5625 * f * f + 0.75 ) + a;
			else
				if f < ( 2.5 / 2.75 ) then
					f = f - ( 2.25 / 2.75 );
					
					return h * ( 7.5625 * f * f + 0.9375 ) + a;
				else
					f = f - ( 2.625 / 2.75 );
					
					return h * ( 7.5625 * f * f + 0.984375 ) + a;
				end
			end
		end
	end;
	
	InOutBounce	= function( this, f, a, h, g )
		a = a or 0.0;
		h = h or 1.0;
		g = g or 1.0;
		
		if f < g / 2 then
			return Easing:InBounce( f * 2, 0, h, g ) * 0.5 + a;
		end
		
		return Easing:OutBounce( f * 2 - g, 0, h, g ) * 0.5 + h * 0.5 + a;
	end;
};