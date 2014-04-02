-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CPlayerAnimation
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
	
	m_pLastAnimation	= NULL;
	
	CPlayerAnimation	= function( this )
		
	end;
	
	_CPlayerAnimation	= function( this )
		this.m_pLastAnimation	= NULL;
	end;
	
	CheckPriority		= function( this, iPriority )
		if type( iPriority ) ~= "number" then
			return false;
		end
		
		if this.m_pLastAnimation and iPriority <= this.m_pLastAnimation.m_iPriority then
			if this.m_pLastAnimation.m_iTime == -1 and iPriority == this.m_pLastAnimation.m_iPriority then
				return true;
			elseif this.m_pLastAnimation.m_iTime == -1 or this.m_pLastAnimation.m_iStart + ( this.m_pLastAnimation.m_iTime / 1000 ) > getRealTime().timestamp then
				return false;
			end
		end
		
		return true;
	end;
	
	SetAnimation		= function( this, iPriority, sBlock, sAnimation, iTime, bLoop, bUpdatePosition, bInterruptable, bFreezeLastFrame )
		if iPriority == NULL then
			this.m_pLastAnimation = NULL;
			
			return setPedAnimation( this );
		end

		iPriority			= (int)(iPriority);
		
		if not this:CheckPriority( iPriority ) then
			return false;
		end
		
		this.m_pLastAnimation	= NULL;
		
		if sBlock == NULL then
			return setPedAnimation( this );
		end
		
		iTime				= tonumber( iTime ) or -1;
		bLoop				= bLoop == NULL or (bool)(bLoop);
		bUpdatePosition		= bUpdatePosition == NULL or (bool)(bUpdatePosition);
		bInterruptable		= bInterruptable == NULL or (bool)(bInterruptable);
		bFreezeLastFrame	= bFreezeLastFrame == NULL or (bool)(bFreezeLastFrame);
		
		if iTime ~= 0 then
			this.m_pLastAnimation	=
			{
				m_iPriority			= iPriority;
				m_iStart			= getRealTime().timestamp;
				m_iTime				= iTime;
			};
		end
		
		return setPedAnimation( this, sBlock, sAnimation, iTime, bLoop, bUpdatePosition, bInterruptable, bFreezeLastFrame );
	end;
};
