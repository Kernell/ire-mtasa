-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local Sirens =
{
	[ 490 ]		= -- Police SUV
	{
		{ X	= 0.200,	Y = 2.800,		Z = -0.300,		Red = 255, Green = 0,		Blue = 0,	Alpha = 255, MinAlpha = 255 };
		{ X	= -0.200,	Y = 2.800,		Z = -0.300,		Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= 0.654,	Y = -2.556,		Z = -0.270, 	Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= -0.655,	Y = -2.547,		Z = -0.200, 	Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X	= 0.677,	Y = -0.347,		Z = 1.000, 		Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= -0.635,	Y = -0.342,		Z = 1.000, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X	= 0.234,	Y = -0.136,		Z = 1.000, 		Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= -0.100,	Y = -0.300,		Z = 1.000, 		Red = 255, Green = 0, 		Blue = 0,	Alpha = 255, MinAlpha = 255 };
	};
	[ 416 ]		= -- Ambulance
	{
		{ X = -0.400,	Y = 0.900, 		Z = 1.200, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha =255, MinAlpha = 255 };
		{ X = 1.0, 		Y = -3.500, 	Z = 1.450, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha =255, MinAlpha = 255 };
		{ X = 0.400, 	Y = 0.900, 		Z = 1.200, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha =255, MinAlpha = 255 };
		{ X = -1.0, 	Y = -3.500, 	Z = 1.450, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha =255, MinAlpha = 255 };
		{ X = 0.100, 	Y = 0.900, 		Z = 1.200, 		Red = 255, Green = 255, 	Blue = 255, Alpha =255, MinAlpha = 255 };
		{ X = -0.100, 	Y = 0.900,		Z = 1.200, 		Red = 255, Green = 255, 	Blue = 255, Alpha =255, MinAlpha = 255 };
	};
};

function CVehicle:InitSirens( sSirenType, bEnabled )
	
	if sSirenType ~= NULL then
		if sSirenType == 'Custom' then
			self.m_iSirenType = 1;
		elseif sSirenType == 'MTA' then
			self.m_iSirenType = 2;
		else
			self.m_iSirenType = 0;
		end
	end

	if self.m_iSirenType == 2 then
		local pSiren = Sirens[ self:GetModel() ];
		
		if type( pSiren ) == 'table' then
			if type( pSiren.variants ) == 'table' and table.getn( pSiren.variants ) > 0 then
				local iVariant1, iVariant2 = self:GetVariant();
				
				pSiren = pSiren.variants[ iVariant1 ];
			end
			
			if type( pSiren ) == 'table' and table.getn( pSiren ) > 0 then
				removeVehicleSirens( self );
				addVehicleSirens( self, table.getn( pSiren ), 3, true, false, true, true );
				
				for i, pData in ipairs( pSiren ) do
					setVehicleSirens( self, i, pData.X, pData.Y, pData.Z, pData.Red, pData.Green, pData.Blue, pData.Alpha, pData.MinAlpha );
				end
				
				self:SetSirensOn( bEnabled );
			end
		end
	end
end

local aWhelenStates =
{
	type1 	= 'type2';
	type2 	= 'type3';
	type3 	= 'type4';
	type4 	= 'type5';
	type5 	= 'type1';
}

local aSirenStates =
{
	police_siren_1	= 'police_siren_2';
	police_siren_2	= 'police_siren_3';
	police_siren_3	= 'police_siren_1';
}

function CPlayer:Siren_Init()
	local pVehicle	= self:GetVehicleSeat() == 0 and self:GetVehicle();
	
	if pVehicle then
		self:DisableControls( "horn" );
		
		self:BindKey	( "n", 		"up", 		CPlayer.ToggleWhelen 		);
		self:BindKey	( "h", 		"up", 		CPlayer.ChangeWhelenMode 	);
		self:BindKey	( "z", 		"up", 		CPlayer.ToggleSiren			);
		self:BindKey	( "x", 		"up", 		CPlayer.ChangeSirenMode		);
		self:BindKey	( "horn", 	"both", 	CPlayer.HornPolice 			);
		
		return true;
	end
	
	self:Siren_Finalize();
	
	return false;
end

function CPlayer:Siren_Finalize()
	self:EnableControls( "horn" );
	
	self:UnbindKey	( "n", 		"up", 		CPlayer.ToggleWhelen			);
	self:UnbindKey	( "h", 		"up", 		CPlayer.ChangeWhelenMode		);
	self:UnbindKey	( "z", 		"up", 		CPlayer.ToggleSiren				);
	self:UnbindKey	( "x", 		"up", 		CPlayer.ChangeSirenMode			);
	self:UnbindKey	( "horn",	"both", 	CPlayer.HornPolice				);
end

function CClientRPC:ChangeSirenState( pVehicle, sState )
	if pVehicle.m_iSirenType == 1 then
		pVehicle:SetData( "siren:state", sState );
		
		return;
	end
	
	self:Siren_Finalize();
end

function CPlayer:ToggleWhelen()
	local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
	
	if pVehicle then
		if pVehicle.m_iSirenType == 1 and pVehicle:GetData( "siren:state" ) == "off" then
			pVehicle:SetData( "siren:state", "on" );
			pVehicle:SetHeadLightColor( 0, 0, 0 );
			
			return;
		elseif pVehicle.m_iSirenType == 2 then
			pVehicle:SetSirensOn( not pVehicle:IsSirenEnabled() );
			
			if pVehicle:GetData( "siren:state" ) == "off" and pVehicle:IsSirenEnabled() then return end
		end
		
		pVehicle:SetData( "siren:state", "off" );
		pVehicle:SetData( "siren:sound", "none" );
		pVehicle:SetLightState( 0, 0 );
		pVehicle:SetLightState( 1, 0 );
		pVehicle:SetHeadLightColor( 255, 255, 255 );
		
		if pVehicle.m_iSirenType > 0 then return end
	end
	
	self:Siren_Finalize();
end

function CPlayer:ChangeWhelenMode()
	local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
	
	if pVehicle and pVehicle.m_iSirenType > 0 then
		if pVehicle.m_iSirenType == 1 and pVehicle:GetData( "siren:state" ) == "on" then
			pVehicle:SetData( "siren:mode", aWhelenStates[ pVehicle:GetData( "siren:mode" ) or "type1" ] or "type1" );
		end
		
		return;
	end
	
	self:Siren_Finalize();
end

function CPlayer:ToggleSiren()
	local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
	
	if pVehicle then
		if pVehicle.m_iSirenType > 0 then
			if pVehicle:GetData( "siren:sound" ) == "none" then
				if pVehicle.m_iSirenType == 1 then
					pVehicle:SetData( "siren:state", "on" );
				elseif pVehicle.m_iSirenType == 2 then
					pVehicle:SetSirensOn( true );
				end
				
				pVehicle:SetData( "siren:sound", pVehicle.m_sSiren or "police_siren_1" );
			else
				pVehicle.m_sSiren = pVehicle:GetData( "siren:sound" );
				
				pVehicle:SetData( "siren:sound", "none" );
			end
			
			return;
		end
		
		pVehicle:SetData( "siren:sound", "none" );
	end
	
	self:Siren_Finalize();
end

function CPlayer:ChangeSirenMode()
	local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
	
	if pVehicle and pVehicle.m_iSirenType > 0 then
		if pVehicle:GetData( "siren:state" ) == "on" or pVehicle:IsSirenEnabled() then
			local sSiren = pVehicle:GetData( "siren:sound" ) or "none";
			
			pVehicle:SetData( "siren:sound", aSirenStates[ sSiren ] or aSirenStates[ pVehicle.m_sSiren ] or "police_siren_1" );
		end
		
		return;
	end
	
	self:Siren_Finalize();
end

function CPlayer:HornPolice( key, state )
	local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
	
	if pVehicle then
		if pVehicle == self.m_pVehicle and pVehicle.m_iSirenType > 0 then
			if state == "down" then
				pVehicle.m_sOldSiren = pVehicle:GetData( "siren:sound" ) or "none";
				
				pVehicle:SetData( "siren:sound", "police_horn" );
			else
				pVehicle:SetData( "siren:sound", pVehicle.m_sOldSiren );
			end

			return;
		end

		pVehicle:SetData( "siren:sound", "none" );
	end
	
	self:Siren_Finalize();
end