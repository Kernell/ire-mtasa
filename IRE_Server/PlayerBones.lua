-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. PlayerBones
{
	PlayerBones		= function( player )
		this.Player = player;
		
		this.Objects = {};
	end;
	
	_PlayerBones	= function()
		this.ReleaseAll();
	end;
	
	AttachObject	= function( boneID, modelID, position, rotation )
		local object = new. Object( modelID, this.Player.GetPosition() );
		
		if object then
			this:Release( boneID );
			
			object.BoneID = boneID;
			
			object.SetParent( this.Player );
			object.SetInterior( this.Player.GetInterior() );
			object.SetDimension( this.Player.GetDimension() );
			object.SetAlpha( this.Player.GetAlpha() );
			object.SetCollisionsEnabled( false );
			
			position = position or Vector3();
			rotation = rotation or Vector3();
			
			this.Objects[ boneID ]		= object;
			
			exports.bone_attach:attachElementToBone( object, this.Player, boneID, position.X, position.Y, position.Z, rotation.X, rotation.Y, rotation.Z );
		end
		
		return object;
	end;
	
	GetObject	= function( boneID )
		return this.IsBusy( boneID ) and this.Objects[ boneID ];
	end;
	
	IsObjectAttached	= function( object )
		return exports.bone_attach:isElementAttachedToBone( object );
	end;
	
	IsBusy = function( boneID )
		if this.Objects[ boneID ] and ( not isElement( this.Objects[ boneID ] ) ) then
			this.Objects[ boneID ] = NULL;
		end
		
		return this.Objects[ boneID ] ~= NULL;
	end;
	
	Release	= function( boneID )		
		if this.IsBusy( boneID ) then
			exports.bone_attach:detachElementFromBone( this.Objects[ boneID ] );
			
			delete ( this.Objects[ boneID ] );
			
			this.Objects[ boneID ] = NULL;
			
			return true;
		end
		
		return false;
	end;
	
	ReleaseAll	= function()
		for boneID in pairs( this.Objects ) do
			this.Release( boneID );
		end
	end;
}
