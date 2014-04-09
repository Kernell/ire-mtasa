-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CNPC ( CPed )
{
	m_iAnimIndex	= 0;
	m_iAnimTimeEnd	= 0;
	
	CNPC	= function( this, iID, ... )
		this = this:CPed( ... );
		
		this.m_ID	= iID;
		
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
		if this.m_aAnimationCycle and this.m_iAnimTimeEnd ~= -1 then
			if this.m_iAnimTimeEnd - tReal.timestamp <= 0 then
				this.m_iAnimIndex = ( ( this.m_iAnimIndex + 1 ) % table.getn( this.m_aAnimationCycle ) ) + 1;
				
				local pAnimation = this.m_aAnimationCycle[ this.m_iAnimIndex ];
				
				ASSERT( pAnimation );
				
				this.m_iAnimTimeEnd		= tReal.timestamp + pAnimation[ PED_ANIMATION_TIME ];
				
				if this.m_iAnimTimeEnd == 0 then
					this.m_iAnimTimeEnd = -1;
				end
				
				local sLib				= pAnimation[ PED_ANIMATION_LIB ];
				local sName				= pAnimation[ PED_ANIMATION_NAME ];
				local iTime				= pAnimation[ PED_ANIMATION_TIME ];
				local bLoop				= pAnimation[ PED_ANIMATION_LOOP ];
				local bUpdatePosition	= pAnimation[ PED_ANIMATION_UPDATE_POS ];
				local bInterruptable	= pAnimation[ PED_ANIMATION_INTERRUPTABLE ];
				local bFreezeLastFrame	= pAnimation[ PED_ANIMATION_FREEZE_LAST_FRAME ];
				
				this:SetAnimation( sLib, sName, iTime * 1000, bLoop, bUpdatePosition, bInterruptable, bFreezeLastFrame );
			end
		end
	end;
};
