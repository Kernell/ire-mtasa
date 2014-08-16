-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: Rectangle
{
	X		= NULL; 
	Y		= NULL;
	Width	= NULL; 
	Height	= NULL;
	
	Rectangle	= function( this, ... )
		if table.getn( { ... } ) == 2 then
			return this:FromPS( ... );
		elseif table.getn( { ... } ) == 4 then
			return this:FromXYWH( ... );
		end
	end;
	
	FromXYWH	= function( this, X, Y, Width, Height )
		this.X		= X;
		this.Y		= Y;
		this.Width	= Width; 
		this.Height	= Height;
	end;

	FromPS		= function( this, Point, Size )
		this.x		= Point.X;
		this.y		= Point.Y;
		this.width	= Size.Width; 
		this.height	= Size.Height;
	end;

	FromLTRB	= function( this, left, top, right, bottom )
		return Rectangle( left, top, right - left, bottom - top );
	end;
	
	property: Left
	{
		get	= function( this )
			return this.X;
		end;
	};
	
	property: Top
	{
		get	= function( this )
			return this.Y;
		end;
	};
	
	property: Right
	{
		get	= function( this )
			return this.X + this.Width;
		end;
	};
	
	property: Bottom
	{
		get	= function( this )
			return this.Y + this.Height;
		end;
	};
	
	property: IsEmpty
	{
		get	= function( this )
			return this.Height == 0 and this.Width == 0 and this.X == 0 and this.Y == 0; 
		end;
	};
	
	Equals	= function( this, obj )
		if classof( obj ) ~= Rectangle then
			return false; 
		end
		
		return obj.X == this.X and obj.Y == this.Y and obj.Width == this.Width and obj.Height == this.Height; 
	end;
	
	static
	{
		Ceiling 	= function( value )
			return Rectangle( math.ceil( value.X ), math.ceil( value.Y ), math.ceil( value.Width ), math.ceil( value.Height ) );
		end;
		
		Truncate	= function( value )
			return Rectangle( (int)(value.X), (int)(value.Y), (int)(value.Width), (int)(value.Height) );
		end;
		
		Round		= function( value )
			return Rectangle( math.Round( value.X ), math.Round( value.Y ), math.Round( value.Width ), math.Round( value.Height ) );
		end;
	
		Union		= function( a, b )
			local x1 = math.min( a.X, b.X );
			local x2 = math.max( a.X + a.Width, b.X + b.Width );
			local y1 = math.min( a.Y, b.Y );
			local y2 = math.max( a.Y + a.Height, b.Y + b.Height );
			
			return Rectangle( x1, y1, x2 - x1, y2 - y1 );
		end;
	};
	
	Contains	= function( this, arg1, arg2 )
		if type( arg1 ) == "number" and type( arg2 ) == "number" then
			return this:Contains_XY( arg1, arg2 );
		elseif classof( arg1 ) == Point then
			return this:Contains_Point( arg1 );
		elseif classof( arg1 ) == Rectangle then
			return this:Contains_Rectangle( arg1 );
		end
		
		return false;
	end;
	
	Contains_XY	= function( this, X, Y )
		return this.X <= X and X < this.X + this.Width and this.Y <= Y and Y < this.Y + this.Height; 
	end;
	
	Contains_Point	= function( this, pt )
		return this:ContainsXY( pt.X, pt.Y ); 
	end;
	
	Contains_Rectangle	= function( this, rect )
		return ( this.X <= rect.X ) and ( ( rect.X + rect.Width ) <= ( this.X + this.Width ) ) and ( this.Y <= rect.Y ) and ( ( rect.Y + rect.Height ) <= ( this.Y + this.Height ) ); 
	end;
	
	Inflate			= function( this, arg1, arg2, arg3 )
		if type( arg1 ) == "number" and type( arg2 ) == "number" then
			this:Inflate_WH( arg1, arg2 );
		elseif classof( arg1 ) == Size then
			this:Inflate_Size( arg1 );
		elseif classof( arg1 ) == Rectangle then
			this:Inflate_Rectangle( arg1, arg2, arg3 );
		end
	end;
	
	Inflate_WH		= function( this, width, height )
		this.X 		= this.X - width;
		this.Y 		= this.Y - height;
		this.Width 	= this.Width + 2 * width; 
		this.Height = this.Height + 2 * height;
	end;
	
	Inflate_Size	= function( this, size )
		this:Inflate_WH( size.Width, size.Height );
	end;
	
	Inflate_Rectangle	= function( this, rect, x, y )
		local r = rect;
		
		r:Inflate( x, y ); 
		
		return r;
	end;
	
	Intersect		= function( this, rect )
		local result = Rectangle.Intersect2( rect, this );

		this.X		= result.X;
		this.Y		= result.Y;
		this.Width	= result.Width;
		this.Height	= result.Height; 
	end;
	
	Intersect2		= function( a, b )
		local x1	= math.max( a.X, b.X );
		local x2	= math.min( a.X + a.Width, b.X + b.Width );
		local y1	= math.max( a.Y, b.Y );
		local y2	= math.min( a.Y + a.Height, b.Y + b.Height );

		if x2 >= x1 and y2 >= y1 then
			return Rectangle( x1, y1, x2 - x1, y2 - y1 );
		end
		
		return Rectangle.Empty;
	end;
	
	IntersectsWith	= function( this, rect )
		return ( rect.X < this.X + this.Width ) and ( this.X < ( rect.X + rect.Width ) ) and ( rect.Y < this.Y + this.Height ) and ( this.Y < rect.Y + rect.Height ); 
	end;
	
	Offset			= function( this, arg1, arg2 )
		if type( arg1 ) == "number" and type( arg2 ) == "number" then
			this:Offset_XY( arg1, arg2 );
		elseif classof( arg1 ) == Point then
			this:Offset_Point( arg1 );
		end
	end;
	
	Offset_Point	= function( this, pos )
		this:Offset( pos.X, pos.Y );
	end;
	
	Offset_XY		= function( this, x, y )
		this.X = this.X + x; 
		this.Y = this.Y + y;
	end;
	
	ToString	= function( this )
		return "{X=" + this.X + ",Y=" + this.Y + ",Width=" + this.Width + ",Height=" + this.Height + "}"; 
	end;
};

Rectangle.__eq		= Rectangle.Equals;