-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

INVENTORY_SLOT =
{
	NONE	= 0;
	HEAD	= 10;
	EYES	= 20;
	SPINE	= 30;
	CHEST	= 40;
	BELT	= 50;
	HIDDEN	= 60;
};

class. CharacterInventory
{
	static
	{
		GetBoneSlot	= function( slot )
			local slot2bone =
			{
				[ INVENTORY_SLOT.NONE ] 	= NULL;
				[ INVENTORY_SLOT.HEAD ] 	= 1;
				[ INVENTORY_SLOT.EYES ] 	= 1;
				[ INVENTORY_SLOT.SPINE ] 	= 3;
				[ INVENTORY_SLOT.CHEST ] 	= 3;
				[ INVENTORY_SLOT.BELT ] 	= 4;
				[ INVENTORY_SLOT.HIDDEN ] 	= NULL;
			};

			return slot2bone[ slot ];
		end
	};

	CharacterInventory	= function( character )
		this.Character = character;

		this.Items	= new
		{
			[ INVENTORY_SLOT.NONE ] 	= new {};
			[ INVENTORY_SLOT.HEAD ] 	= new {};
			[ INVENTORY_SLOT.EYES ] 	= new {};
			[ INVENTORY_SLOT.SPINE ] 	= new {};
			[ INVENTORY_SLOT.CHEST ] 	= new {};
			[ INVENTORY_SLOT.BELT ] 	= new {};
			[ INVENTORY_SLOT.HIDDEN ] 	= new {};
		};

		this.SlotSize	=
		{
			[ INVENTORY_SLOT.NONE ] 	= 10;
			[ INVENTORY_SLOT.HEAD ] 	= 1;
			[ INVENTORY_SLOT.EYES ] 	= 1;
			[ INVENTORY_SLOT.SPINE ] 	= 1;
			[ INVENTORY_SLOT.CHEST ] 	= 1;
			[ INVENTORY_SLOT.BELT ] 	= 1;
			[ INVENTORY_SLOT.HIDDEN ] 	= 1;
		};
	end;

	_CharacterInventory	= function()
		for x, slot in pairs( this.Items ) do
			for i = slot.Length(), 1, -1 do
				slot[ i ].Owner = NULL;
				
				delete ( slot[ i ] );
				
				slot.Remove( i );
			end
		end
		
		this.Items		= NULL;
		this.SlotSize	= NULL;
	end;

	Save	= function()
		for x, slot in pairs( this.Items ) do
			for i = slot.Length(), 1, -1 do
				slot[ i ].Save();
			end
		end
	end;

	Sync	= function()

	end;

	Show	= function()

	end;

	GiveItem	= function( item, value, condition, data )
		if typeof( item ) == "string" then
			local item = Server.Game.ItemsManager.Create( item );

			item.Value 		= tonumber( value ) or 1;
			item.Condition 	= tonumber( condition ) or 1.0;

			if data then
				for key, value in pairs( data ) do 
					item[ key ] = value;
				end
			end

			if item.Give( this.Character ) then
				Server.Game.ItemsManager.Register( item );

				return item;
			end

			delete ( item );

			return false;
		elseif typeof( item ) == "object" then
			if item.Give( this ) then
				if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "items SET owner = 'Character[" + this.GetID() + "]' WHERE id = " + item.GetID() ) then
					this.Sync();

					return item;
				end
			end
		end
		
		return NULL;
	end;

	TakeItem	= function( item, limit )
		if not limit then
			limit = 1;
		end
		
		if typeof( item ) == "string" then
			local count			= 0;
			local removedItems	= new {};
			local itemConf		= Server.Game.ItemsManager.Config[ item ];
			local items			= this.Items[ itemConf.slot ];
			
			for i = items.Length(), 1, -1 do
				if count < limit then
					local _item = items[ i ];

					if _item and _item.SectionName == item then
						removedItems.Insert( _item.GetID() );
						
						items.Remove( i );

						_item.Owner = NULL;

						delete ( _item );
						
						count = count + 1;
					end
				else
					break;
				end
			end
			
			if Server.DB.Query( "DELETE FROM " + Server.DB.Prefix + "items WHERE id IN( " + removedItems.Join( ", " ) + " )" ) then
				this.Sync();
				
				return count;
			end

			Debug( Server.DB.Error(), 1 );
		elseif typeof( item ) == "object" then
			if Server.DB.Query( "DELETE FROM " + Server.DB.Prefix + "items WHERE id = " + item.GetID() ) then
				delete ( item );
				
				this.Sync();
				
				return 1;
			end
			
			Debug( Server.DB.Error(), 1 );
		end
		
		return 0;
	end;

	DropItem	= function( item )
		if item.Owner == this then
			local object = item.Drop();
			
			if object then
				this.Sync();
				
				return item.Save() and object;
			else
				Server.Game.ItemsManager.Remove( item );
				
				this.Sync();
			end
		end
		
		return NULL;
	end;

	HaveItem	= function( item )
		if typeof( item ) == "string" then
			for i, itm in pairs( this.Items[ item.slot ] ) do
				if itm.SectionName == item then
					return true;
				end
			end
		elseif typeof( item ) == "object" then
			return item.Owner == this;
		end
		
		return false;
	end;
}