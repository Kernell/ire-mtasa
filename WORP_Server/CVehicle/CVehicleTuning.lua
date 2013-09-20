-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

do
	return;
end

local OUTSIDE	=
{
	POSITION	= Vector3( 1643.511, -1516.396, 12.4 );
	ROTATION	= Vector3();
	INTERIOR	= 0;
};

local INSIDE	=
{
	POSITION	= Vector3( 616.013, -11.272, 1001.55 );
	ROTATION	= Vector3( 0, 0, 90 );
	INTERIOR	= 1;
};

local MAP_FIXES	=
{
	{ Model = 1256; Position = Vector3( 617.45721435547, -12.14316368103, 1000.471862793 ); Rotation = Vector3( 0, 270, 90 ); };
	{ Model = 1256; Position = Vector3( 617.45721435547, -10.34316444397, 1000.471862793 ); Rotation = Vector3( 0, 270, 90 ); };
	{ Model = 1256; Position = Vector3( 614.95721435547, -12.14316368103, 1000.471862793 ); Rotation = Vector3( 0, 270, 90 ); };
	{ Model = 1256; Position = Vector3( 614.95721435547, -10.34316444397, 1000.471862793 ); Rotation = Vector3( 0, 270, 90 ); };
	{ Model = 1256; Position = Vector3( 612.45721435547, -10.34316444397, 1000.071899414 ); Rotation = Vector3( 339.5, 270, 90 ); };
	{ Model = 1256; Position = Vector3( 612.45721435547, -12.34316444397, 1000.071899414 ); Rotation = Vector3( 339.0, 270, 90 ); };
};

local OUTSIDE_MARKER = CMarker.Create( OUTSIDE.POSITION, "cylinder", 4.0, 190, 255, 0, 100 ); OUTSIDE_MARKER:SetInterior( OUTSIDE.INTERIOR );

class: CVehicleTuning
{
	CVehicleTuning = function ( self, pVehicle, pPlayer )
		self.m_pVehicle	= pVehicle;
		self.m_pPlayer	= pPlayer;
		
		self.m_MapFixeObjects = {};
		
		self.m_iDimension = pPlayer:GetID();
		
		for i, data in ipairs( MAP_FIXES ) do
			local pObject = CObject.Create( data.Model, data.Position, data.Rotation );
			
			pObject:SetInterior( INSIDE.INTERIOR );
			pObject:SetDimension( self.m_iDimension );
			pObject:SetAlpha( 0 );
			
			table.insert( self.m_MapFixeObjects, pObject );
		end
		
		pVehicle:SetFrozen( true );
		pVehicle:SetCollisionsEnabled( false );
		
		for iSeat, pPlr in pairs( self.m_pVehicle:GetOccupants() ) do
			pPlr:GetCamera():Fade( false );
		end
		
		setTimer( 
			function ()
				self:WarpInside();
			end,
			1100, 1
		);
	end;
	
	WarpInside = function ( self )
		if self.m_pPlayer:IsElement() and self.m_pPlayer:IsInGame() and not self.m_pPlayer:IsDead() then
			if self.m_pVehicle:IsElement() and self.m_pVehicle:GetHealth() > 200 then
				local pVehicle = self.m_pPlayer:GetVehicle();
				
				if self.m_pPlayer:GetVehicleSeat() == 0 and pVehicle and pVehicle:GetID() == self.m_pVehicle:GetID() then
					self.m_pVehicle:SetPosition( INSIDE.POSITION );
					self.m_pVehicle:SetRotation( INSIDE.ROTATION );
					self.m_pVehicle:SetInterior( INSIDE.INTERIOR );
					self.m_pVehicle:SetDimension( self.m_iDimension );
					self.m_pVehicle:SetCollisionsEnabled( true );
			
					for iSeat, pPlr in pairs( self.m_pVehicle:GetOccupants() ) do
						pPlr:SetInterior( INSIDE.INTERIOR );
						pPlr:SetDimension( self.m_iDimension );
						pPlr:GetCamera():Fade( true );
					end
					
					self.m_pPlayer:Client().CVehicleTuning();
					
					return;
				end
			end
		end
		
		delete ( self );
	end;
	
	WarpOutside = function ( self )
		if self.m_pVehicle:IsElement() and self.m_pVehicle:GetHealth() > 0 then
			local Passengers = self.m_pVehicle:GetOccupants();
			
			if #Passengers > 0 then
				self.m_pVehicle:SetPosition( OUTSIDE.POSITION );
				self.m_pVehicle:SetRotation( OUTSIDE.ROTATION );
			else
				self.m_pVehicle:SetPosition( OUTSIDE.POSITION - Vector3( 0, 0, 50 ) )
			end
			
			self.m_pVehicle:SetInterior( 0 );
			self.m_pVehicle:SetDimension( 0 );
			self.m_pVehicle:SetFrozen( false );
			
			for iSeat, pPlr in pairs( Passengers ) do
				pPlr:SetInterior( 0 );
				pPlr:SetDimension( 0 );
				pPlr:GetCamera():Fade( true );
			end
		elseif self.m_pPlayer:IsElement() and self.m_pPlayer:IsInGame() then
			self.m_pPlayer:RemoveFromVehicle();
			self.m_pPlayer:SetPosition( OUTSIDE.POSITION );
			self.m_pPlayer:SetInterior( 0 );
			self.m_pPlayer:SetDimension( 0 );
		end
	end;
	
	_CVehicleTuning = function ( self )
		self:WarpOutside();
		
		self.m_pVehicle.m_pTuning = NULL;
		
		for i, pObj in ipairs( self.m_MapFixeObjects ) do
			pObj:Destroy();
		end
		
		self.m_MapFixeObjects = NULL;
	end;
	
	DoPulse = function ( self )
		if self.m_pPlayer:IsElement() and self.m_pPlayer:IsInGame() and not self.m_pPlayer:IsDead() then
			if self.m_pVehicle:IsElement() and self.m_pVehicle:GetHealth() > 200 then
				local pVehicle = self.m_pPlayer:GetVehicle();
				
				if self.m_pPlayer:GetVehicleSeat() == 0 and pVehicle and pVehicle:GetID() == self.m_pVehicle:GetID() then
					return;
				end
			end
		end
		
		delete ( self );
	end;
}

function OUTSIDE_MARKER:OnHit( pVehicle, bMatching )
	if bMatching and pVehicle:type() == 'vehicle' then
		local pPlayer = pVehicle:GetDriver();
		
		if _DEBUG then
			assert( pPlayer, "Assertion failed in pVehicle->GetDriver()" );
			assert( pPlayer:IsInGame(), "Assertion failed in pPlayer->IsInGame()" );
		end
		
		if pPlayer and pPlayer:IsInGame() and _DEBUG then
			if pVehicle:GetID() ~= INVALID_ELEMENT_ID and pVehicle:GetType() == 'Automobile' and pVehicle:GetOwner() > 0 and pVehicle:GetID() > 0 then
				if not pVehicle.m_pTuning then
					pVehicle.m_pTuning = CVehicleTuning( pVehicle, pPlayer );
				end
			else
				pPlayer:Hint( "Ошибка", "Этот транспорт не подлежит тюнингу", "error" );
			end
		end
	end
end