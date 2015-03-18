-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. ItemWeapon : Item
{
	ItemWeapon	= function( config )
		this.Item( config );

		this.AmmoItemConfig	= Server.Game.ItemsManager.Config[ this.ammo_class ];
	end;

	_ItemWeapon	= function()
		this._Item();
	end;

	GetCompatibleMagazines	= function( items )
		local magazines = new {};
		
		local slot = items[ INVENTORY_SLOT.NONE ];

		for i = 1, slot.Length() do
			local mag = slot[ i ];

			if this.AmmoItemConfig == mag.AmmoItemConfig then
				magazines.Insert( mag );
			end
		end
		
		return magazines;
	end;

	Take	= function()
		local owner = this.Owner;
		
		if base.Take() > 0 then
			if classof( owner ) == Character then
				owner.Player.TakeAllWeapons();
			end
		end
	end;

	Use		= function()
		local playerBones = this.Owner.Player.Bones;
		
		if playerBones.IsBusy( this.bone_use ) then
			this.Owner.Player.Hint( "Ошибка", "Ваши руки заняты", "error" );
			
			return false;
		end
		
		return false;
	end;
}