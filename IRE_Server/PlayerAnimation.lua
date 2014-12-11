-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. PlayerAnimation
{
	static
	{
		PRIORITY_ALL		= 0;
		PRIORITY_FOOD		= 5;
		PRIORITY_OFFERS		= 5;
		PRIORITY_PHONE		= 5;
		PRIORITY_WEAPON		= 5;
		PRIORITY_SWATROPE	= 15;
		PRIORITY_JOB		= 20;
		PRIORITY_CUFFS		= 50;
		PRIORITY_TIRED		= 90;
		PRIORITY_LOWHP		= 100;
	};
	
	LastAnimation	= NULL;
	
	PlayerAnimation	= function( player )
		this.Player = player;
	end;
	
	_PlayerAnimation	= function()
		this.LastAnimation	= NULL;
	end;
	
	CheckPriority		= function( priority )
		if type( priority ) ~= "number" then
			return false;
		end
		
		if this.LastAnimation and priority <= this.LastAnimation.Priority then
			if this.LastAnimation.Time == -1 and priority == this.LastAnimation.Priority then
				return true;
			elseif this.LastAnimation.Time == -1 or this.LastAnimation.Start + ( this.LastAnimation.Time / 1000 ) > getRealTime().timestamp then
				return false;
			end
		end
		
		return true;
	end;
	
	SetAnimation		= function( priority, block, animation, time, loop, updatePosition, interruptable, freezeLastFrame )
		if priority == NULL then
			this.LastAnimation = NULL;
			
			return setPedAnimation( this.Player );
		end

		priority			= (int)(priority);
		
		if not this.CheckPriority( priority ) then
			return false;
		end
		
		this.LastAnimation	= NULL;
		
		if block == NULL then
			return setPedAnimation( this.Player );
		end
		
		time				= tonumber( time ) or -1;
		loop				= loop == NULL or (bool)(loop);
		updatePosition		= updatePosition == NULL or (bool)(updatePosition);
		interruptable		= interruptable == NULL or (bool)(interruptable);
		freezeLastFrame		= freezeLastFrame == NULL or (bool)(freezeLastFrame);
		
		if time ~= 0 then
			this.LastAnimation	=
			{
				Priority	= priority;
				Start		= getRealTime().timestamp;
				Time		= time;
			};
		end
		
		return setPedAnimation( this.Player, block, animation, time, loop, updatePosition, interruptable, freezeLastFrame );
	end;
};
