-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local JAILS =
{
	Police =
	{
		Inside =
		{
			Vector3( 264.538, 77.413, 1001.039 );
		};
		Outside =
		{
			Vector3( 267.962, 77.798, 1001.039 );
		};
		Int = 6;
		Dim = 2;
	};
	FBI =
	{
		Inside =
		{
			Vector3( 198.1, 174.73, 1003.1 );
			Vector3( 193.9, 174.94, 1003.1 );
			Vector3( 198.1, 161.88, 1003.1 );
		};
		Outside =
		{
			Vector3( 198.1, 179.37, 1003.1 );
			Vector3( 193.9, 179.41, 1003.1 );
			Vector3( 198.1, 158.14, 1003.1 );
		};
		Int = 3;
		Dim = 3;
	};
	Prison	=
	{
		Inside =
		{
			Vector3( 2481.39, -6308.31, 16.35 );
		};
		Outside =
		{
			Vector3( 2521.7, -6313.47, 17.44 );
		};
		Int = 0;
		Dim = 0;
	};
	Admin	=
	{
		Inside	=
		{
			Vector3( -1319.555, -2291.340, 327.533 );
		};
		Outside = NULL;
		Int = 0;
		Dim = 255;
	};
};

function CPlayer:GetNearbyJail( Side, type )
	local type 		= type and JAILS[ type ] and type or false;
	local side		= JAILS[ type or 'Police' ][ Side ][ 1 ];
	local int		= JAILS[ type or 'Police' ][ 'Int' ];
	local dim		= JAILS[ type or 'Police' ][ 'Dim' ];
	
	local dist 	= 9999;
	local p_pos = self:GetPosition();
	
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
end

function CPlayer:UpdateJail()
	if self:GetChar():IsJailed() then
		if self:IsCuffed() then
			self:SetCuffed();
		end
		
		self.m_pCharacter.m_iJailedTime = self.m_pCharacter.m_iJailedTime - 1;
		
		self:Client().UpdatePrisonTextDraw( self.m_pCharacter.m_iJailedTime );

		if self.m_pCharacter.m_iJailedTime > 0 then
			
			local _, j = self:GetNearbyJail( 'Inside', self.m_pCharacter.m_sJailed );
			
			if self:GetPosition():Distance( j ) > 20 then
				self:GetChar():SetJailed( self.m_pCharacter.m_sJailed, self.m_pCharacter.m_iJailedTime );
			end
		else
			self:GetChar():SetJailed();
		end
	end
end

function CChar:SetJailed( type, iSeconds )
	iSeconds = (int)(iSeconds);
	
	local pos;
	
	if iSeconds > 0 then
		type, pos = self.m_pPlayer:GetNearbyJail( "Inside", type );
		
		self.m_pPlayer:Spawn( pos, 0, self.m_pPlayer:GetModel(), JAILS[ type ].Int, JAILS[ type ].Dim, t_logged_in );
	else
		if JAILS[ self.m_sJailed ].Outside then
			_, pos = self.m_pPlayer:GetNearbyJail( "Outside", self.m_sJailed );
			
			self.m_pPlayer:Spawn( pos, 270, self.m_pPlayer:GetModel(), JAILS[ self.m_sJailed ].Int, JAILS[ self.m_sJailed ].Dim, t_logged_in );
		else
			self.m_pPlayer:GetCamera():Fade( false );
		
			setTimer( CPlayer.PreSpawn, 1100, 1, self.m_pPlayer );
		end
		
		type = 'No';
	end
	
	self.m_sJailed		= type;
	self.m_iJailedTime	= iSeconds;
	
	return g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET jailed = %q, jailed_time = %d WHERE id = %d", self.m_sJailed, self.m_iJailedTime, self:GetID() ) or not Debug( g_pDB:Error(), 1 );
end

function CChar:IsJailed()
	return self.m_sJailed ~= 'No';
end

function CPlayer:IsJailed()	
	return self:IsInGame() and self:GetChar():IsJailed();
end

function CChar:GetJailed()
	return self.m_sJailed, self.m_iJailedTime;
end

function CChar:GetJailedTime()
	return self.m_iJailedTime;
end