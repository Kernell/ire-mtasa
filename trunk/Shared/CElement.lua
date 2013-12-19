-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

INVALID_ELEMENT_ID	= 0xFFFFFFFF

local list = {};

local function new_Element( this )
	local sType		= getElementType( this );
	
	-- Debug( classname( this ) );
	
	local Classes	=
	{
		console		= CConsole;
		player		= CPlayer;
		ped			= CPed;
		vehicle		= CVehicle;
		object		= CObject;
		pickup		= CPickup;
		marker		= CMarker;
--		colshape	= CColShape;
		blip		= CBlip;
		radararea	= CRadarArea;
		team		= CTeam;
		shader		= CShader;
		sound		= CSound;
		Sound		= not CLIENT and CSound or NULL;
--		teleport	= CTeleport;
--		interior	= CInerior;
--		faction		= CFaction;
	};
	
	if  Classes[ sType ] then
		return Classes[ sType ]( this );
	else
		return CElement( this );
	end
end

debug.setmetatable( root, 
	{
		__index = function( self, key )
			if not list[ self ] then
				if isElement( self ) then
					local bool, result = pcall( new_Element, self );
					
					if not bool then
						error( result, 2 );
					end
					
					list[ self ] = result;
				-- else
					-- local d			= debug.getinfo( 2 );
					-- local sModule 	= d.short_src:match( "\(%w+)\.lua" );
					-- local sAddress1 = (string)(d.func) - ( type( d.func ) + ": " );
					-- local sAddress2	= (string)(self) - ( type( self ) + ": " );
					
					-- error( "Access violation at address " + sAddress1 + " in module '" + sModule + "'. Read of address " + sAddress2 + " key '" + key + "'", 2 );
				end
			end
			
			return list[ self ] and list[ self ][ key ];
		end;
		
		__newindex = function( self, key, value )
			if not list[ self ] then
				if isElement( self ) then
					local bool, result = pcall( new_Element, self );
					
					if not bool then
						error( result, 2 );
					end
					
					list[ self ] = result;
				else
					local pDebug	= debug.getinfo( 2 );
					local sModule 	= pDebug.short_src:match( "\(%w+)\.lua" );
					local sAddress1 = (string)(pDebug.func) - ( type( pDebug.func ) + ": " );
					local sAddress2	= (string)(self) - ( type( self ) + ": " );
					
					error( "Access violation at address " + sAddress1 + " in module '" + sModule + "'. Read of address " + sAddress2 + " key '" + key + "'", 2 );
				end
			end
			
			list[ self ][ key ] = value;
		end;
	}
);

class: CElement ( IElementData )
{
	IsWithinColShape	= isElementWithinColShape;
	GetColShape			= getElementColShape;
	
	CElement			= function( this, hInstance )
		this:IElementData();
		
		if hInstance and isElement( hInstance ) then
			this.__instance = hInstance;
		end
	end;
};

function CElement.Create( ... )
	local Element = createElement( ... );
	
	if not Element then
		error( "failed to create element", 2 );
	end
	
	return CElement( Element );
end

function CElement:AddToList( pElement )
	list[ pElement or self.__instance ] = self;
end

function CElement:RemoveFromList()
	list[ self.__instance ] = NULL;
end

function CElement.GetFromList( hElement )
	return list[ hElement ];
end

function CElement.GetByID( id )
	return getElementByID( id );
end

function CElement.GetByType( type )
	return getElementsByType( type );
end

function CElement:Destroy()
	if destroyElement( self.__instance ) then
		return true;
	end
	
	return false;
end

function CElement:IsElement()
	return isElement( self.__instance );
end

function CElement:ToString()
	return (string)( self.__instance );
end

CElement.ToString = CElement.tostring;

function CElement:type()
	return getElementType( self.__instance );
end

function CElement:SetData( ... )
	return setElementData( self.__instance, ... );
end

function CElement:GetData( ... )
	return getElementData( self.__instance, ... );
end

function CElement:RemoveData( ... )
	return removeElementData( self.__instance, ... );
end

function CElement:GetAttachedElements()
	return getAttachedElements( self.__instance );
end

function CElement:GetAlpha()
	return getElementAlpha( self.__instance );
end

function CElement:GetAttachedOffsets()
	return getElementAttachedOffsets( self.__instance );
end

function CElement:IsCollisionsEnabled()
	return getElementCollisionsEnabled( self.__instance );
end

function CElement:GetAttachedTo()
	return getElementAttachedTo( self.__instance );
end

function CElement:GetChild( index )
	return getElementChild( self.__instance, index );
end

function CElement:GetChilds( sType )
	return getElementChildren( self.__instance, sType );
end

function CElement:GetChildrenCount()
	return getElementChildrenCount( self.__instance );
end

function CElement:GetDimension()
	return getElementDimension( self.__instance );
end

function CElement:GetHealth()
	return getElementHealth( self.__instance );
end

function CElement:GetID()
	return getElementID( self.__instance );
end

function CElement:GetInterior()
	return getElementInterior( self.__instance );
end

function CElement:GetParent()
	return getElementParent( self.__instance );
end

function CElement:GetPosition()
	return Vector3( getElementPosition( self.__instance ) );
end

function CElement:GetRotation( order )
	return Vector3( getElementRotation( self.__instance, order or 'default' ) );
end

function CElement:GetWithinColShape( sElementType )
	return getElementsWithinColShape( self.__instance, sElementType );
end

function CElement:GetType()
	return getElementType( self.__instance );
end

function CElement:GetVelocity()
	return Vector3( getElementVelocity( self.__instance ) );
end

function CElement:IsAttached()
	return isElementAttached( self.__instance );
end

function CElement:IsDoubleSided()
	return isElementDoubleSided( self.__instance );
end

function CElement:IsFrozen()
	return isElementFrozen( self.__instance );
end

function CElement:SetAlpha( iAlpha )
	if typeof( self ) ~= 'object' then error( TEXT_E2288, 2 ) end
	
	return setElementAlpha( self.__instance, tonumber( iAlpha ) or 255 );
end

function CElement:SetCollisionsEnabled( bEnabled )
	return setElementCollisionsEnabled( self.__instance, (bool)(bEnabled) );
end

function CElement:SetDoubleSided( bDSided )
	return setElementDoubleSided( self.__instance, (bool)(bDSided) );
end

function CElement:SetDimension( iDimension )
	return setElementDimension( self.__instance, (int)(iDimension) );
end

function CElement:SetFrozen( bFrozen )
	return setElementFrozen( self.__instance, (bool)(bFrozen) );
end

function CElement:SetHealth( fHealth )
	return setElementHealth( self.__instance, (float)(fHealth) );
end

function CElement:SetID( sID )
	return setElementID( self.__instance, (string)(sID) );
end

function CElement:SetInterior( iInterior )
	return setElementInterior( self.__instance, (int)(iInterior) );
end

function CElement:SetParent( pElement )
	if not pElement then error( "attempt to index local 'pElement' (is NULL)", 2 ); end
	
	return setElementParent( self.__instance, pElement.__instance or pElement );
end

function CElement:SetPosition( vecPosition, bWarp )
	vecPosition 	= vecPosition or Vector3();
	bWarp 			= bWarp == nil and true or (bool)(bWarp);
	
	if not isElement( self.__instance ) then error( "Bad argument 'self' @ 'SetPosition'", 2 ) end
	
	return setElementPosition( self.__instance, vecPosition.X, vecPosition.Y, vecPosition.Z, bWarp ) or error( "Bad argument @ 'SetPosition'", 2 );
end

function CElement:SetRotation( vecRotation, sOrder, bPedAirRotation )
	vecRotation = vecRotation or Vector3();
	
	return setElementRotation( self.__instance, vecRotation.X, vecRotation.Y, vecRotation.Z, sOrder or "default", (bool)(bPedAirRotation) );
end

function CElement:SetVelocity( vecVelocity )
	return setElementVelocity( self.__instance, vecVelocity and vecVelocity.X or 0.0, vecVelocity and vecVelocity.Y or 0.0, vecVelocity and vecVelocity.Z or 0.0 );
end

function CElement:AttachTo( pElement, pOff, rOff )
	pOff = pOff or Vector3();
	rOff = rOff or Vector3();

	return attachElements( self.__instance, pElement.__instance, pOff.X, pOff.Y, pOff.Z, rOff.X, rOff.Y, rOff.Z );
end

function CElement:SetAttachedOffsets( pOff, rOff )
	pOff = pOff or Vector3();
	rOff = rOff or Vector3();
	
	return setElementAttachedOffsets( self.__instance, pOff.X, pOff.Y, pOff.Z, rOff.X, rOff.Y, rOff.Z );
end

function CElement:Detach( element )
	return element and detachElements( self.__instance, type( element ) == 'table' and element.__instance or element ) or detachElements( self.__instance );
end

function CElement:GetModel()
	return getElementModel( self.__instance );
end

function CElement:SetModel( model )
	return setElementModel( self.__instance, tonumber( model ) or 0 );
end

function CElement:IsInWater()
	return isElementInWater( self.__instance );
end

function CElement:IsWithinMarker( pMarker )
	return isElementWithinMarker( self.__instance, pMarker );
end

function CElement:GetVelocityAngle()
	local vecVelocity	= self:GetVelocity();
	local vecRotation	= self:GetRotation();
	
	local fSinZ, fCosZ = -math.sin( math.rad( vecRotation.Z ) ), math.cos( math.rad( vecRotation.Z ) );
	
	local fCosX = ( fSinZ * vecVelocity.X + fCosZ * vecVelocity.Y ) / vecVelocity:Length();
	
	return math.deg( math.acos( fCosX == math.huge and 0.0 or fCosX ) );
end

-- Client Only
if isElementOnScreen then
	function CElement:IsOnScreen()
		return isElementOnScreen( self.__instance );
	end
end

CElement( root );
CElement( resourceRoot );
