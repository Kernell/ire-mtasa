-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CNPC ( CPed )
{
	CNPC	= function( this, ... )
		this = this:CPed( ... );
		
		g_pGame:GetNPCManager():AddToList( this );
		
		return this;
	end;
	
	_CNPC	= function( this )
		g_pGame:GetNPCManager():RemoveFromList( this );
		
		this:Destroy();
	end;
	
	GetID	= function( this )
		return this.m_ID;
	end;
	
	DoPulse	= function( this, tReal )
		if this.m_sAnimLib and this.m_iAnimTime > 50 then
			local iTick = getTickCount();
			
			if iTick - (int)(this.m_iAnimStart) > this.m_iAnimTime then
				this:SetAnimation( this.m_sAnimLib, this.m_sAnimName, this.m_iAnimTime, this.m_bAnimLoop, this.m_bAnimUpdatePos, this.m_bAnimInterruptable, this.m_bAnimFreezeLastFrame );
				
				this.m_iAnimStart = iTick;
			end
		end
	end;
};
