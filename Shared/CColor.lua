-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CColor
{
	R			= 255;
	G			= 255;
	B			= 255;
	A			= 255;
	
	CColor		= function( this, ... )
		if this:FromRGBA( ... ) or this:FromRGB( ... ) or this:FromHEX( ... ) or this:FromString( ... ) then
			-- TODO: Nothing
		end
	end;
	
	_CColor		= function( this )
		this.R		= NULL;
		this.G		= NULL;
		this.B		= NULL;
		this.A		= NULL;
	end;
	
	FromString	= function( this, sColor )
		if type( sColor ) == "string" then
			return this:FromHEX( tonumber( sColor:match( "%x%x%x%x%x%x" ), 16 ) );
		end
		
		return false;
	end;
	
	FromHEX		= function( this, iColor )
		if type( iColor ) == "number" then
			local iA	= 255;
		--	local iA	= bitExtract( iColor, 24, 8 );
			local iR	= bitExtract( iColor, 16, 8 );
			local iG	= bitExtract( iColor, 8, 8 );
			local iB	= bitExtract( iColor, 0, 8 );
			
			return this:FromRGBA( iR, iG, iB, iA );
		end
		
		return false;
	end;
	
	FromRGB		= function( this, iR, iG, iB )
		return this:FromRGBA( iR, iG, iB, 255 );
	end;
	
	FromRGBA	= function( this, iR, iG, iB, iA )
		if iR and iG and iB and iA then
			this.R	= (byte)(iR);
			this.G	= (byte)(iG);
			this.B	= (byte)(iB);
			this.A	= (byte)(iA);
			
			return true;
		end
		
		return false;
	end;
	
	ToNumber	= function( this )
		return tocolor and tocolor( this.R, this.G, this.B, this.A ) or tonumber( ( "%x%x%x%x%x%x" ):format( this.R, this.G, this.B ), 16 );
	end;
};