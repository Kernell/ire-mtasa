-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Character
{
	Character	= function( player, data )
		this.Player 	= player;
		
		this.ID 			= data.id;
		this.Level			= data.level;
		this.LevelPoints	= data.level_points;
		this.Name			= data.name;
		this.Surname		= data.surname;
		this.DateOfBirdth	= data.date_of_birdth;
		this.PlaceOfBirdth	= data.place_of_birdth;
		this.Nation			= data.nation;
		this.Created		= data.created;
		this.LastLogin		= data.last_login;
		this.Alcohol		= data.alcohol;
		this.Power			= data.power;
		this.SpawnInterior	= data.spawn_id;
		this.Money			= (int)(data.money);
		
		this.SkinID			= data.skin;
		this.Skin			= new. CharacterSkin( this.SkinID );
		
		this.Jailed			= data.jailed;
		this.JailedTime		= data.jailed_time;
		
		this.Player.SetData( "Character::Alcohol", this.Alcohol );
		this.Player.SetData( "Character::Power", this.Power );
	end;
	
	_Character	= function()
		this.Save();
		
		this.Player.Character = NULL;
		
		this.Player = NULL;
		this.Skin	= NULL;
	end;
	
	DoPulse	= function( real )
		if this.Alcohol > 0.0 then
			this.Alcohol = Clamp( 0.0, this.Alcohol - math.random() * 0.4, 100.0 );
			
			this.Player.SetData( "Character::Alcohol", this.Alcohol, true, true );
			
			if this.Alcohol > 30.0 and getTickCount() - ( this.DrinkAnimationTime or 0 ) > 0 then
				this.SetAnimation( PlayerAnimation.PRIORITY_FOOD, "PED", "WALK_drunk", 900, true, true, true, true );
			end
		end
		
		local power = this.Player.GetData( "Character::Power" );

		this.Power = power;
		
		if not this.Player.LowHPAnim and not this.IsCuffed() then
			if power <= 0 then
				this.SetAnimation( PlayerAnimation.PRIORITY_TIRED, "FAT", "IDLE_tired", 10000, true, false, false, false );
			end
		end

		if this.GetArmor() > 0 and not this.Skin.HaveArmor() then
			this.SetArmor( 0 );
		end
		
		if this.IsJailed() then
			if this.IsCuffed() then
				this.SetCuffed();
			end
			
			this.JailedTime = this.JailedTime - 1;
			
			if this.JailedTime > 0 then
				-- local _, j = this.GetNearbyJail( "Inside", this.Jailed );
				
				-- if this.GetPosition().Distance( j ) > 20 then
					-- this.SetJailed( this.Jailed, this.JailedTime );
				-- end
			else
				this.SetJailed();
			end
			
			this.Player.RPC.UpdatePrisonTextDraw( this.JailedTime );
		end
	end;
	
	GetID	= function()
		return this.ID;
	end;
	
	GetName	= function()
		return this.Name + " " + this.Surname;
	end;
	
	SetName	= function( name, surname )
		if name:len() > 0 and surname:len() > 0 then
			if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "characters SET name = %q, surname = %q WHERE id = " + this.GetID(), name, surname ) then
				if this.Player.SetName( ( name + "_" + surname ):gsub( " ", "_" ) ) then
					this.Name		= name;
					this.Surname	= surname;
					
					this.Player.Nametag.Update();
					
					return true, false;
				else
					return false, 1;
				end
			else
				return false, Server.DB.Handler:errno() == 1062 and 2 or 3;
			end
		end
		
		return false, 0;
	end;
	
	Logout	= function( type, reason, responsePlayer )
		if this.Player.Race then
			this.Player.Race.OnPlayerLeave( this.Player, type );
		end
		
		if type == "Quit" or type == "Logout" then
			if this.IsCuffed() and not this.IsJailed() then
				this.Jailed		= "Police";
				this.JailedTime	= 30 * 60;
			end
		end
		
		delete ( this );
	end;
	
	Save	= function()
		local tick			= getTickCount();
		
		local isSpectating	= this.Player.Spectator.GetTarget() ~= NULL;
		
		local position		= isSpectating and this.Player.Spectator.Position or this.GetPosition();
		local interior		= isSpectating and this.Player.Spectator.Interior or this.GetInterior();
		local dimension		= isSpectating and this.Player.Spectator.Dimension or this.GetDimension();
		local rotation		= isSpectating and this.Player.Spectator.Rotation or this.GetRotation();
		
		local health		= this.GetHealth();
		local armor			= this.GetArmor();
		local alcohol		= this.Alcohol;
		local power			= this.Power;
		local jailed		= this.Jailed;
		local jailedTime	= this.JailedTime;
		local levelPoints	= this.LevelPoints;
		
		local query = string.format( 
		"UPDATE " + Server.DB.Prefix + "characters SET \
			position = %q, interior = '%d', dimension = '%d', rotation = %q, \
			health = '%f', armor = '%f', alcohol = '%f', power = '%f', jailed = %q, jailed_time = %d, \
			level_points = %d, last_logout = NOW() WHERE id = %d",
			(string)(position), interior, dimension, (string)(rotation), health, armor, alcohol, power, jailed, jailedTime, levelPoints, this.GetID()
		);
		
		if not Server.DB.Query( query ) then
			Debug( Server.DB.Error(), 1 );
		end
		
		if _DEBUG then
			Debug( "Character '" + this.Name + " " + this.Surname + "' saved (" + ( getTickCount() - tick ) + " ms)" );
		end
	end;
	
	GetMoney	= function()
		return this.Money;
	end;
	
	SetMoney	= function( money )
		if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "characters SET money = '%f' WHERE id = %d", money, this.GetID() ) then		
			this.Money = money;
			
			this.Player.HUD.SetMoney( this.Money );
			
			return true;
		end
		
		Debug( Server.DB.Error(), 1 );
		
		return false;
	end;
	
	GiveMoney	= function( money, reason )
		if reason then
			Server.Log.Money.Write( "[" + this.GetID() + "]" + this.GetName() + " +" + money + " (" + reason + ")" );
		end
		
		return this.SetMoney( this.Money + money );
	end;
	
	TakeMoney	= function( money, reason )
		if this.Money >= money then
			if reason then
				Server.Log.Money.Write( "[" + this.GetID() + "]" + this.GetName() + " -" + money + " (" + reason + ")" );
			end
			
			return this.SetMoney( this.Money - money );
		end
		
		return false;
	end;
	
	IsDead	= function()
		return isPedDead( this.Player );
	end;
	
	GetArmor	= function()
		return getPedArmor( this.Player );
	end;
	
	SetArmor	= function( armor )
		return setPedArmor( this.Player, armor );
	end;
	
	GetHealth	= function()
		return getElementHealth( this.Player );
	end;
	
	SetHealth	= function( health )
		return setElementHealth( this.Player, health );
	end;
	
	GetPosition	= function()
		return new. Vector3( getElementPosition( this.Player ) );
	end;
	
	SetPosition	= function( position )
		return setElementPosition( this.Player, position.X, position.Y, position.Z );
	end;
	
	GetRotation	= function()
		return new. Vector3( getElementRotation( this.Player ) );
	end;
	
	SetRotation	= function( rotation )
		return setElementRotation( this.Player, rotation.X, rotation.Y, rotation.Z );
	end;
	
	GetInterior	= function()
		return getElementInterior( this.Player );
	end;
	
	SetInterior	= function( interior )
		return setElementInterior( this.Player, (int)(interior) );
	end;
	
	GetDimension	= function()
		return getElementDimension( this.Player );
	end;
	
	SetDimension	= function( dimension )
		return setElementDimension( this.Player, (int)(dimension) );
	end;
	
	Spawn			= function( position, rotation, interior, dimension )
		return this.Player.Spawn( position, rotation, this.SkinID, interior, dimension, Server.Game.PlayerManager.TeamLoggedIn );
	end;
	
	SetLevel	= function( level, resetPoints )
		if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "characters SET level = %d, level_points = %d WHERE id = %d", level, resetPoints and 0 or this.LevelPoints, this.ID ) then
			this.Level = level;
			
			if resetPoints then
				this.LevelPoints = 0;
			end
			
			this.Player.SetData( "Player::Level", this.Level );
			
			return true;
		else
			Debug( Server.DB.Error(), 1 );
		end
		
		return false;
	end;
	
	GetSkin	= function()
		return this.Player.GetSkin();
	end;
	
	SetSkin	= function( skin )
		if skin.IsValid() or skin.IsSpecial() then
			if not Server.DB.Query( "UPDATE " + Server.DB.Prefix + "characters SET skin = %d WHERE id = %d", skin.GetID(), this.ID ) then
				Debug( Server.DB.Error(), 1 );
				
				return false;
			end
			
			this.SkinID = skin.GetID();
			this.Skin	= new. CharacterSkin( this.SkinID );
			
			this.Player.SetModel( this.SkinID );
			
			return true;
		end
		
		return false;
	end;
	
	SetSpawn	= function( interiorID )
		this.SpawnInterior = tonumber( interiorID ) or 0;
		
		if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "characters SET spawn_id = " + this.SpawnInterior + " WHERE id = " + this.ID ) then
			return true;
		end
		
		Debug( Server.DB.Error(), 1 );
		
		return false;
	end;
	
	SetPower	= function( power )
		this.Power = Clamp( 0.0, (float)(power), 100.0 );
		
		if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "characters SET power = %.2f WHERE id = " + this.ID, this.Power ) then
			this.Player.SetData( "Character::Power", this.Power );
			
			return true;
		end
		
		Debug( Server.DB.Error(), 1 );
		
		return false;
	end;
	
	SetAlcohol	= function( alcohol )
		this.Alcohol = Clamp( 0.0, (float)(alcohol), 100.0 );
		
		if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET alcohol = %.2f WHERE id = " + this.ID, this.Alcohol ) then
			this.Player.SetData( "Character::Alcohol", this.Alcohol, true, true );
			
			return true;
		end
		
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end;
	
	SetAnimation	= function( ... )
		return this.Player.SetAnimation( ... );
	end;
	
	IsTied	= function()
		return this.Tied ~= NULL;
	end;
	
	IsCuffed	= function()
		return this.Cuffed ~= NULL;
	end;
	
	SetCuffed	= function( cuffed, character )
		this.Cuffed			= cuffed and character or NULL;
		this.CuffedTo		= character or NULL;
		
		if this.Cuffed then
			this.Player.RPC.UpdateCuffed( this.CuffedTo and this.CuffedTo.Player ); -- TODO:
			
			if not this.Player.IsInVehicle() and not this.Player.LowHPAnim then
				this.SetAnimation( CPlayerAnimation.PRIORITY_CUFFS, "PED", "IDLE_stance" );
			end
		elseif not this.Player.LowHPAnim then
			this.SetAnimation( PlayerAnimation.PRIORITY_CUFFS );
			this.Player.RPC.UpdateCuffed(); -- TODO:
		end
		
		return true;
	end;
	
	SetJailed	= function( type, seconds )
		seconds = (int)(seconds);
		
		local position;
		
		if seconds > 0 then
			type, position = this.GetNearbyJail( "Inside", type );
			
			this.Spawn( position, 0.0, JAILS[ type ].Int, JAILS[ type ].Dim );
		else
			if JAILS[ this.Jailed ].Outside then
				_, position = this.GetNearbyJail( "Outside", this.Jailed );
				
				thisSpawn( position, 270, JAILS[ this.Jailed ].Int, JAILS[ this.Jailed ].Dim );
			else
				this.Player.GetCamera().Fade( false );
			
				setTimer( function() this.Player.PreSpawn(); end, 1100, 1 );
			end
			
			type = "No";
		end
		
		this.Jailed		= type;
		this.JailedTime	= seconds;
		
		if not Server.DB.Query( "UPDATE " + Server.DB.Prefix + "characters SET jailed = %q, jailed_time = %d WHERE id = %d", this.Jailed, this.JailedTime, this.ID ) then
			Debug( g_pDB:Error(), 1 );
			
			return false;
		end
		
		return true;
	end;
	
	IsJailed		= function()
		return this.Jailed ~= "No";
	end;
	
	GetNearbyJail	= function( Side, type )
		local type 		= type and JAILS[ type ] and type or false;
		local side		= JAILS[ type or 'Police' ][ Side ][ 1 ];
		local int		= JAILS[ type or 'Police' ][ 'Int' ];
		local dim		= JAILS[ type or 'Police' ][ 'Dim' ];
		
		local dist 	= 9999;
		local p_pos = this.GetPosition();
		
		if not type then
			for j, jail in pairs( JAILS ) do
				if jail[ Side ] then
					for i, pos in ipairs( jail[ Side ] ) do
						if p_pos:Distance( pos ) < dist then
							dist		= p_pos:Distance( pos );
							type		= j;
							side		= pos;
						end
					end
				end
			end
		else
			for i, pos in ipairs( JAILS[ type ][ Side ] ) do
				if p_pos:Distance( pos ) < dist then
					dist		= p_pos:Distance( pos );
					side		= pos;
				end
			end
		end
		
		return type or "Police", side, int, dim;
	end;
};
