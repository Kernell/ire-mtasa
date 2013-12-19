-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local Protected	=
{
	__type		= true;
	__name		= true;
	__bases		= true;
	__class 	= true;
	__index 	= true;
	__fenv		= true;
	__static	= true;
};

local ClassMeta	=
{
	__NewObject	= function( this )
		local pObject		=
		{
			__type			= "object";
		};
		
		setmetatable( pObject, this );
		
		for i, CClass in ipairs( this.__bases ) do
			rawset( pObject, CClass.__name, CClass[ CClass.__name ] );
		end
		
		return pObject;
	end;
	
	__call		= function( this, ... )
		local pObject = this:__NewObject();
		
		local vResult = NULL;
		
		if this[ this.__name ] then
			vResult = this[ this.__name ]( pObject, ... );
		end
		
		return vResult == NULL and pObject or vResult;
	end;
	
	__tostring	= function( this )
		return typeof( this ) + ": " + classname( this );
	end;
};

ClassMeta.__index	= ClassMeta;

class			= 
{
	__newindex	= function( this )
		return NULL;
	end;
	
	__index		= function( this, sName )
		local Space			= _G;
		local Names			= sName:split( "." );
		local sClassName	= Names[ table.getn( Names ) ];
		
		table.remove( Names );
		
		for i, sNamespace in ipairs( Names ) do
			if type( Space[ sNamespace ] ) == "table" then
				Space = Space[ sNamespace ];
			else
				error( "attempt to index '" + sNamespace + "' in " + sName, 2 );
			end
		end
		
		local TClass	= this:Create( sClassName, true );
		
		Space[ sClassName ] = TClass;
		
		return function( this, ... )
			local Args1	= { ... };
			
			if typeof( Args1[ 1 ] ) == "class" then
				this:SetBases( TClass, Args1 );
				
				return function( ... )
					this:SetValues( TClass, ... );
				end;
			end
			
			this:SetValues( TClass, ... );
		end;
	end;
	
	__call		= function( this, sName )
		local Space			= _G;
		local Names			= sName:split( "." );
		local sClassName	= Names[ table.getn( Names ) ];
		
		table.remove( Names );
		
		for i, sNamespace in ipairs( Names ) do
			if type( Space[ sNamespace ] ) == "table" then
				Space = Space[ sNamespace ];
			else
				error( "attempt to index '" + sNamespace + "' in " + sName, 2 );
			end
		end
		
		local TClass	= this:Create( sClassName, true );
		
		Space[ sClassName ] = TClass;
		
		return function( ... )
			local Args1	= { ... };
			
			if typeof( Args1[ 1 ] ) == "class" then
				this:SetBases( TClass, Args1 );
				
				return function( ... )
					this:SetValues( TClass, ... );
				end;
			end
			
			this:SetValues( TClass, ... );
		end;
	end;
	
	Create		= function( this, sName )
		local CClass	=
		{
			__type		= "class";
			__name		= sName;
			__bases		= {};
		};
		
		CClass.__class 	= CClass;
		CClass.__index 	= CClass;
		
		setmetatable( CClass, ClassMeta );
		
		return CClass;
	end;
	
	SetBases	= function( this, CClass, Bases )
		CClass.__bases = Bases;
		
		for i, _CClass in ipairs( CClass.__bases ) do
			for key, value in pairs( _CClass ) do
				if not Protected[ key ] then
					if type( value ) == 'function' and ( not CClass.__static or not CClass.__static[ key ] ) then						
						CClass[ key ]	= function( ... )
							return _CClass[ key ]( ... );
						end
					else
						CClass[ key ]	= value;
					end
				end
			end
		end
	end;
	
	SetValues	= function( this, CClass, Values )
		for key, value in pairs( Values ) do
			if not Protected[ key ] then
				if tonumber( key ) and type( value ) == "table" and value.__static then
					if not CClass.__static then
						CClass.__static = {};
					end
					
					for k, v in pairs( value ) do
						if not Protected[ k ] then
							CClass.__static[ k ] = true;
							CClass[ k ] = v;
						end
					end
				else
					CClass[ key ] = value;
				end
			end
		end
		
		if not CClass[ CClass.__name ] then
			CClass[ CClass.__name ]	= function( self )
				
			end
		end
	end;
};

setmetatable( class, class );

new		=
{
	__index		= function( this, sName )
		local pClass	= _G[ sName ];
		
		return pClass and pClass:__NewObject();
	end;
}

setmetatable( new, new );

function static( Values )
	Values.__static = true;
	
	return Values;
end

function virtual( CClass )
	return typeof( CClass ) == "class" and { __type = "virtual_class", __class = CClass } or error( "Argument is not a class", 2 );
end

function typeof( void )
	return void and void.__type or type( void ); 
end

function classof( void )
	if type( void ) == "table" or type( void ) == "userdata" then
		return void.__class;
	end
	
	return NULL;
end

function classname( void )
	if type( void ) == "table" or type( void ) == "userdata" then
		return void.__name;
	end
	
	return NULL;
end

function delete( pObject )
	if classof( pObject ) then
		if pObject[ '_' .. pObject.__name ] then
			pObject[ '_' .. pObject.__name ]( pObject );
		end
		
		if CElement and pObject.__instance then
			CElement.RemoveFromList( pObject );
		end		
		
		if type( pObject ) == 'table' then
			setmetatable( pObject, NULL );
			
			-- for i, v in pairs( pObject ) do
				-- pObject[ i ] = NULL;
			-- end
		end
		
		collectgarbage( "collect" );
	end
	
	return true;
end