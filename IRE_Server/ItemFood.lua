-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. ItemFood : Item
{
	ItemFood	= function( config )
		this.Item( config );


	end;

	_ItemFood	= function()
		this._Item();
	end;

	Use			= function()
		local playerBones = this.Owner.Player.Bones;
		
		if playerBones.IsBusy( this.bone_use ) then
			this.Owner.Player.Hint( "Ошибка", "Ваши руки заняты", "error" );
			
			return false;
		end
		
		if this.Owner.Player.SetAnimation( PlayerAnimation.PRIORITY_FOOD, this.animation[ 1 ], this.animation[ 2 ], 0, false, false, false, true ) then
			if this.health then
				this.Owner.SetHealth	( this.Owner.GetHealth() + this.health );
			end

			if this.alcohol then
				this.Owner.SetAlcohol	( this.Owner.GetAlcohol() + this.alcohol );
			end

			if this.satiety then
				this.Owner.SetSatiety	( this.Owner.GetSatiety() + this.satiety );
			end

			if this.power then
				this.Owner.SetPower		( this.Owner.GetPower() + this.power );
			end

			this.Owner.Player.Chat.Me( this.Owner.Player.Gender( "съел ", "съела " ) + this.name2 );

			local bonePosition = new. Vector3( this.bone_use_position[ 1 ], this.bone_use_position[ 2 ], this.bone_use_position[ 3 ] );
			local boneRotation = new. Vector3( this.bone_use_rotation[ 1 ], this.bone_use_rotation[ 2 ], this.bone_use_rotation[ 3 ] );
			
			local boneObject = this.model and playerBones.AttachObject( this.bone_use, this.model, bonePosition, boneRotation );
			
			local player = this.Owner.Player;
			
			setTimer(
				function()
					if player.IsInGame() then
						player.SetAnimation( PlayerAnimation.PRIORITY_FOOD, "PED", "facanger", 0, false, false, false, false );
					end
					
					if boneObject then
						delete ( boneObject );
						boneObject = NULL;
					end
				end, this.animation[ 3 ], 1
			);
			
			delete ( this );
			
			return true;
		end
		
		this.Owner.Player.Hint( "Ошибка", "Операция недоступна в данный момент", "error" );
		
		return false;
	end;
}