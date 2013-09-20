dofile "utils.lua"
dofile "class2.lua"

class: CEntity
{
	CEntity		= function()
		this.m_sTest = "CEntity:" + math.random();
		
		print( "new CEntity; // " + this.m_sTest );
	end;
	
	_CEntity	= function()
		print( this.m_sTest );
	end;
	
	Set			= function( key, value )
		this[ key ] = value;
		
		print( this:Get( key ) );
	end;
	
	Get			= function( key )
		return this[ key ];
	end;
};

pEntity	= CEntity();

pEntity:Set( "m_bFailed", false );

delete ( pEntity );