-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Item
{
	ID			= 1;
	Value		= 0;
	Condition	= 100.0;

	Item		= function( config )
		for k, v in pairs( config ) do
			this[ k ] = v;
		end
	end;

	_Item		= function()
		this.Take();

		Server.Game.ItemsManager.RemoveFromList( this );
	end;

	GetID		= function()
		return this.ID;
	end;

	Use			= function()
		return false;
	end;

	Give		= function( owner )
		if owner.Inventory.Items == NULL then
			error( "owner.Inventory.Items == NULL", 2 );
		end
		
		this.Take();
		
		if classof( owner ) == Character then
			if this.slot == NULL then
				return false;
			else
				if owner.Inventory.Items[ this.slot ].Length() >= owner.Inventory.SlotSize[ this.slot ] then
					return false;
				end
				
				owner.Inventory.Items[ this.slot ].Insert( this );
			end

			local bone = this.model and CharacterInventory.GetBoneSlot( this.slot );	
			
			if bone then
				local model = type( this.model ) == "number" and this.model or exports.IRE_Models:GetInfo( this.model ).ID;

				if model then
					local bonePosition = new. Vector3( this.bone_position[ 1 ], this.bone_position[ 2 ], this.bone_position[ 3 ] );
					local boneRotation = new. Vector3( this.bone_rotation[ 1 ], this.bone_rotation[ 2 ], this.bone_rotation[ 3 ] );
					
					this.Entity = owner.Player.Bones.AttachObject( bone, model, bonePosition, boneRotation );
				else
					Debug( "invalid model '" + this.model + "' for item [" + this.SectionName + "]", 1 );
				end
			end
		else
			owner.Inventory.Items.Insert( this );
		end
		
		this.Owner = owner;
		
		return true;
	end;

	Take		= function()
		if this.Entity then
			delete ( this.Entity );
			this.Entity = NULL;
		end
		
		if this.Owner then
			local count = 0;
			
			for i = this.Owner.Inventory.Items[ this.slot ].Length(), 1, -1 do
				if this.Owner.Inventory.Items[ this.slot ][ i ] == this then
					this.Owner.Inventory.Items[ this.slot ].Remove( i );
					
					count = count + 1;
				end
			end
			
			this.Owner = NULL;
			
			return count;
		end
		
		return 0;
	end;

	Drop		= function()
		if this.Owner then
			local position	= this.Owner.GetPosition();
			local rotation	= this.Owner.GetRotation();
			local interior	= this.Owner.GetInterior();
			local dimension	= this.Owner.GetDimension();
			
			this.Take();
			
			return this.Spawn( position, rotation, interior, dimension );
		end
		
		return false;
	end;

	Spawn		= function( position, rotation, interior, dimension )
		this.Owner	= NULL;
		
		if this.model then
			this.Position		= position;
			this.Rotation		= rotation;

			local spawnPosition	= new. Vector3( this.spawn_position[ 1 ], this.spawn_position[ 2 ], this.spawn_position[ 3 ] );
			local spawnRotation	= new. Vector3( this.spawn_rotation[ 1 ], this.spawn_rotation[ 2 ], this.spawn_rotation[ 3 ] );
			
			local position		= this.Position + spawnPosition;
			local rotation		= this.Rotation + spawnRotation;
			
			this.Entity 		= new. Object( this.model, position, rotation );
			
			this.Entity.SetInterior		( interior );
			this.Entity.SetDimension	( dimension );
			this.Entity.SetParent		( Server.Game.ItemsManager.Root );
			
			this.Entity.ColShape		= new. ColShape( "Sphere", position.X, position.Y, position.Z + 0.5, 1.0 );
			
			this.Entity.ColShape.SetData		( "Item::ID", this.ID );
			this.Entity.ColShape.SetData		( "Item::Section", this.SectionName );
			this.Entity.ColShape.SetInterior	( interior );
			this.Entity.ColShape.SetDimension	( dimension );
			this.Entity.ColShape.SetParent		( this.Entity );
			
			return this.Entity;
		end
		
		return NULL;
	end;

	Save		= function()
		local itemManager	= Server.Game.ItemsManager;
		local dataCount		= 0;
		local data			= new {};

		for key, value in pairs( this ) do
			if itemManager.Config[ this.SectionName ][ key ] ~= NULL and itemManager.Config[ this.SectionName ][ key ] ~= value then
				data[ key ] = value;

				dataCount = dataCount + 1;
			end
		end
		
		local saveData	= new
		{
			"`owner`		= " + ( this.Owner and ( "'" + classname( this.Owner ) + "[" + (int)(this.Owner.GetID()) + "]'" ) or "NULL" );
			"`position` 	= " + ( this.Position and ( "'" + this.Position.ToString() + "'" ) or "NULL" );
			"`rotation` 	= " + ( this.Rotation and ( "'" + this.Rotation.ToString() + "'" ) or "NULL" );
			"`interior` 	= " + ( this.Entity and this.Entity.GetInterior() or "NULL" );
			"`dimension` 	= " + ( this.Entity and this.Entity.GetDimension() or "NULL" );
			"`value`		= '" + this.Value + "'";
			"`condition`	= '" + this.Condition + "'";
			"`data`			= " + ( dataCount > 0 and ( "'" + data.ToJSON() + "'" ) or "NULL" );
		};
		
		if not Server.DB.Query( "UPDATE " + Server.DB.Prefix + "items SET " + saveData.Join( ', ' ) + "  WHERE id = " + this.GetID() ) then
			Debug( Server.DB.Error(), 1 );

			return false;
		end

		return true;
	end;
}