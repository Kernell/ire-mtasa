-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. ItemsManager : Manager
{
	ItemsManager	= function()
		this.Manager();
	end;
	
	_ItemsManager	= function()
	
	end;
	
	Init			= function()
		this.Load( NULL );
		
		return true;
	end;
	
	Load			= function( owner )
		local allFields = "`id`, `value`, `condition`, `class`, `data`, `position`, `rotation`, `interior`, `dimension`";
		
		local ownerString = ( owner and ( "= '" + classname( owner ) + "[" + (int)(owner.GetID()) + "]'" ) or "IS NULL" );
		
		local result = Server.DB.Query( "SELECT " + allFields + " FROM " + Server.DB.Prefix + "items WHERE owner " + ownerString + " ORDER BY id ASC" );
		
		if result then
			local array = result.GetArray();
			
			result.Free();
			
			for i, row in pairs( array ) do
				local itemConfig = this.GetItem( row.class );
				
				if itemConfig then
					local item		= itemConfig:class();
					local Data		= fromJSON( row.data );
					
					if Data then				
						for key, value in pairs( Data ) do
							item.Data[ key ] = tonumber( value ) or value;
						end
					end
					
					item.ID			= (int)(row.id);
					item.Condition	= (float)(row.condition);
					item.Value		= (int)(row.value);
					
					if not owner then
						if row.position and row.rotation then
							item.Spawn( new. Vector3( row.position ), new. Vector3( row.rotation ), (int)(row.interior), (int)(row.dimension) );
						end
					else
						item.Give( owner );
					end
					
					this.AddToList( item );
				end
			end
		else
			Debug( Server.DB.Error(), 1 );
		end
	end;
	
	Create			= function( itemConfig, owner, position, rotation, interior, dimension, value, condition, data )
		return this.Register( itemConfig.class( itemConfig ), owner, position, rotation, interior, dimension, value, condition, data );
	end;
	
	Register		= function( item, owner, position, rotation, interior, dimension, value, condition, data )
		local fields	=
		{
			class		= "'" + item.ClassName + "'";
			owner		= owner and ( classname( owner ) + "[" + (int)(owner.GetID()) + "]" ) or NULL;
			position	= position and position.ToString() or NULL;
			rotation	= rotation and rotation.ToString() or NULL;
			interior	= interior or NULL;
			dimension	= dimension or NULL;
			value		= iValue or NULL;
			condition	= condition or NULL;
			data 		= data and toJSON( data ) or NULL;
		};
		
		local ID	= Server.DB.Insert( Server.DB.Prefix + "items", fields );
		
		if not ID then
			Debug( Server.DB.Error(), 1 );
			
			return NULL;
		end
		
		if owner then
			if not item.Give( owner ) then
				return false;
			end
		end
		
		item.ID			= Server.DB.InsertID();
		item.Owner		= owner;
		item.Position	= position;
		item.Rotation	= rotation;
		item.Interior	= interior;
		item.Dimension	= dimension;
		item.Value		= value or item.Value;
		item.Condition	= condition or item.Condition;
		
		if data then
			for key, value in pairs( data ) do
				item.Data[ key ] = value;
			end
		end
		
		this.AddToList( item );
		
		return item;
	end;
	
	Remove	= function( item )
		if Server.DB.Query( "DELETE FROM " + Server.DB.Prefix + "items WHERE id = " + item.GetID() ) then
			delete ( item );
			
			return true;
		end
		
		Debug( Server.DB.Error(), 1 );
		
		return false;
	end;
	
	GetItem	= function( item )
		local itemClass = ItemsConfig[ item ];
		
		return itemClass and itemClass.IsItem and itemClass or NULL;
	end
};
