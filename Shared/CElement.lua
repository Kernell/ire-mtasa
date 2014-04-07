-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

INVALID_ELEMENT_ID			= 0xFFFFFFFF

class: CElement
{
	CElement				= function( this, ... )
		if not ( { ... } )[ 1 ] then
			error( "Bad argument @ 'createElement' [Expected string at argument 1, got none]", 2 );
		end
		
		local pElement	= createElement( ... );
		
		pElement( this );
		
		return pElement;
	end;
	
	_CElement				= destroyElement;
	
	Destroy					= destroyElement;
	
	AddEvent				= function( this, sEvent, vFunction, pObject )
		this[ vFunction ]	= function( ... )
			vFunction( pObject or this, ... );
		end;
		
		addEventHandler( sEvent, this, this[ vFunction ] );
	end;

	RemoveEvent				= function( this, sEvent, vFunction )
		removeEventHandler( sEvent, this, this[ vFunction ] );
		
		this[ vFunction ]	= NULL;
	end;
	
	IsValid					= isElement;
	GetID					= getElementID;
	GetType					= getElementType;
	
	SetID					= setElementID;
	
	GetChild				= getElementChild;
	GetChilds				= getElementChildren;
	GetChildsCount			= getElementChildrenCount;
	GetWithinColShape		= getElementsWithinColShape;
	IsWithinColShape		= isElementWithinColShape;
	
	SetData					= setElementData;
	GetData					= getElementData;
	RemoveData				= removeElementData;
	
	AttachTo				= function( this, vecPosOffset, vecRotOffset )
		vecPosOffset	= vecPosOffset or Vector3();
		vecRotOffset	= vecRotOffset or Vector3();
		
		return attachElements( this, vecPosOffset.X, vecPosOffset.Y, vecPosOffset.Z, vecRotOffset.X, vecRotOffset.Y, vecRotOffset.Z );
	end;
	
	Detach					= detachElements;
	
	SetAttachedOffsets		= function( this, vecPosOffset, vecRotOffset )
		vecPosOffset	= vecPosOffset or Vector3();
		vecRotOffset	= vecRotOffset or Vector3();
		
		return setElementAttachedOffsets( this, vecPosOffset.X, vecPosOffset.Y, vecPosOffset.Z, vecRotOffset.X, vecRotOffset.Y, vecRotOffset.Z );
	end;
	
	IsAttached				= isElementAttached;
	GetAttachedElements		= getAttachedElements;
	GetAttachedOffsets		= getElementAttachedOffsets;
	GetAttachedTo			= getElementAttachedTo;
	
	GetColShape				= getElementColShape;
	GetAlpha				= getElementAlpha;
	GetDimension			= getElementDimension;
	GetHealth				= getElementHealth;
	GetInterior				= getElementInterior;
	GetParent				= getElementParent;
	
	GetPosition				= function( this )
		return Vector3( getElementPosition( this ) );
	end;
	
	GetRotation				= function( this, sOrder )
		return Vector3( getElementRotation( this, sOrder or "default" ) );
	end;
	
	GetVelocity				= function( this )
		return Vector3( getElementVelocity( this ) );
	end;
	
	GetModel				= getElementModel;
	
	IsCollisionsEnabled		= getElementCollisionsEnabled;
	IsDoubleSided			= isElementDoubleSided;
	IsFrozen				= isElementFrozen;
	IsInWater				= isElementInWater;
	IsWithinMarker			= isElementWithinMarker;
	
	SetAlpha				= setElementAlpha;
	SetCollisionsEnabled	= setElementCollisionsEnabled;
	SetDoubleSided			= setElementDoubleSided;
	SetDimension			= setElementDimension;
	SetFrozen				= setElementFrozen;
	SetHealth				= setElementHealth;
	SetInterior				= setElementInterior;
	SetParent				= setElementParent;
	
	SetPosition				= function( this, pVector, bWarp )
		pVector	= pVector or Vector3();
		
		return setElementPosition( this, pVector.X, pVector.Y, pVector.Z, bWarp == NULL or bWarp );
	end;
	
	SetRotation				= function( this, pVector, sOrder, bConformPedRotation )
		pVector	= pVector or Vector3();
		
		return setElementRotation( this, pVector.X, pVector.Y, pVector.Z, sOrder or "default", bConformPedRotation == true );
	end;
	
	SetRotationAt		= function( this, vecPosition )
		vecPosition = vecPosition or Vector3();
		
		local vecRotation	= Vector3();
		
		vecRotation.Z = ( 360.0 - math.deg( math.atan2( vecPosition.X - self:GetPosition().X, vecPosition.Y - self:GetPosition().Y ) ) ) % 360.0;
		
		return self:SetRotation( vecRotation );
	end;
	
	SetVelocity				= function( this, pVector )
		pVector	= pVector or Vector3();
		
		return setElementVelocity( pElement, pVector.X, pVector.Y, pVector.Z );
	end;
	
	SetModel				= setElementModel;
	
	-- Client
	
	IsLocal					= isElementLocal;
	IsOnScreen				= isElementOnScreen;
	IsStreamable			= isElementStreamable;
	IsStreamedIn			= isElementStreamedIn;
	IsCollidableWith		= isElementCollidableWith;
	
	GetBoundingBox			= getElementBoundingBox;		-- TODO:
	GetRadius				= getElementRadius;
	GetMatrix				= getElementMatrix;
	
	SetStreamable			= setElementStreamable;
	SetCollidableWith		= setElementCollidableWith;
	
	GetDistanceFromCentreOfMassToBaseOfModel	= getElementDistanceFromCentreOfMassToBaseOfModel;
	
	--
	
	ToString				= tostring;
	
	GetVelocityAngle		= function( this )
		local vecVelocity	= this:GetVelocity();
		local vecRotation	= this:GetRotation();
		
		local fSinZ, fCosZ	= -math.sin( math.rad( vecRotation.Z ) ), math.cos( math.rad( vecRotation.Z ) );
		
		local fLength		= vecVelocity:Length();
		
		local fCosX			= fLength == 0.0 and 0.0 or ( fSinZ * vecVelocity.X + fCosZ * vecVelocity.Y ) / fLength;
		
		return math.deg( math.acos( fCosX ) );
	end;
	
	-- Server
	
	Clone					= function( this, vecPosition, bCloneChildren )
		vecPosition = vecPosition or Vector3();
		
		return cloneElement( this, vecPosition.X, vecPosition.Y, vecPosition.Z, (bool)(bCloneChildren) );
	end;
	
	ClearVisible			= clearElementVisibleTo;
	IsVisibleTo				= isElementVisibleTo;
	SetVisible				= setElementVisibleTo;
	GetSyncer				= getElementSyncer;
	GetAllData				= getAllElementData;
	RemoveData				= removeElementData;
	GetZoneName				= getElementZoneName;
};

--

local UserdataMeta;
local ElementCache	= {};
local Type2Class	=
{
	camera			= "CClientCamera";
	console			= "CConsole";
	player			= "CPlayer";
	ped				= "CPed";
	vehicle			= "CVehicle";
	object			= "CObject";
	pickup			= "CPickup";
	marker			= "CMarker";
	-- colshape		= "CColShape";
	blip			= "CBlip";
	radararea		= "CRadarArea";
	team			= "CTeam";
	shader			= "CShader";
	sound			= "CSound";
	Sound			= not CLIENT and "CSound" or NULL;
	-- teleport		= "CTeleport";
	-- interior		= "CInterior";
	-- faction		= "CFaction";
	texture			= "CTexture";
};

UserdataMeta	=
{
	__new		= function( this )	
		local sClassName	= Type2Class[ getElementType( this ) ];
		
		local pObject = new [ _G[ sClassName ] and sClassName or "CElement" ];
		
		ElementCache[ this ] = pObject;
		
		return pObject;
	end;
	
	__init		= function( this )
		if isElement( this ) then
			ElementCache[ this ] = UserdataMeta.__new( this );
		else
			local pInfo			= debug.getinfo( 2 );
			local sModule 		= pInfo.short_src:match( "\(%w+)\.lua" );
			local sAddress1 	= (string)(pInfo.func) - ( type( pInfo.func ) + ": " );
			local sAddress2		= (string)(this) - ( type( this ) + ": " );
			
			error( "Access violation at address " + sAddress1 + " in module '" + sModule + "'. Read of address " + sAddress2 + " key '" + key + "'", 3 );
		end
	end;
	
	__call		= function( this, pObject )
		if ElementCache[ this ] == NULL then
			ElementCache[ this ] = pObject;
		end
		
		return ElementCache[ this ];
	end;
	
	__finalize	= function( this )
		ElementCache[ this ]	= NULL;
	end;
	
	__gc		= function( this )
		if _DEBUG then
			Debug( "Garbage collector: " + tostring( this ) );
		end
		
		UserdataMeta.__finalize( this );
	end;
	
	__index 	= function( this, key )
		if ElementCache[ this ] == NULL then
			UserdataMeta.__init( this );
		end
		
		return ElementCache[ this ][ key ];
	end;
	
	__newindex = function( this, key, value )
		if ElementCache[ this ] == NULL then
			UserdataMeta.__init( this );
		end
		
		ElementCache[ this ][ key ] = value;
	end;
	
	__tostring	= function( this )
		return "element:" + classname( this );
	end;
};

debug.setmetatable( root, UserdataMeta );