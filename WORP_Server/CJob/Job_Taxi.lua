-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local TJobTaxi		= CJob( 'taxi', 106, 'Таксист', 'таксистом', Vector3( 1541.52, -2322.67, 13.55 ) );

TJobTaxi.CPlayer	= {};
TJobTaxi.m_pCall	= NULL;

function TJobTaxi:Init( pPlayer )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		if pChar:GetLicense( 'vehicle' ) then
			local pVehicle	= pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
			
			if pVehicle then
				pVehicle:SetTaxiLightOn( true );
				
				pPlayer:BindKey	( "lalt", 		"up", TJobTaxi.CPlayer.AcceptCall );
				pPlayer:BindKey	( "ralt", 		"up", TJobTaxi.CPlayer.AcceptCall );
				pPlayer:BindKey	( "backspace", 	"up", TJobTaxi.CPlayer.ToggleTaxiLight );
				
				pPlayer:Hint( "Работа: " + self:GetName(), "Backspace - что бы включить/выключить счётчик", "info" );
			end
		else
			pPlayer:Hint( "Работа: " + self:GetName(), "\nУ Вас нет водительских прав чтобы работать " + self:GetName2(), "error" );
		end
	end
end

function TJobTaxi:Finalize( pPlayer )
	pPlayer:UnbindKey	( "lalt", 		"up", TJobTaxi.CPlayer.AcceptCall );
	pPlayer:UnbindKey	( "ralt", 		"up", TJobTaxi.CPlayer.AcceptCall );
	pPlayer:UnbindKey	( "backspace", 	"up", TJobTaxi.CPlayer.ToggleTaxiLight );
	
	pPlayer:Client().TJobTaxi_SetMeter( NULL );
end

function TJobTaxi:CheckRequirements( pPlayer )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		if pChar:GetLicense( 'vehicle' ) then
			return true;
		else
			pPlayer:Hint( "Работа: " + self:GetName(), "\nУ Вас нет водительских прав чтобы работать " + self:GetName2(), "error" );
		end
	end
	
	return false;
end

function TJobTaxi:SendMessage( sText, pIgnorePlayer )
	for _, p in pairs( g_pGame:GetPlayerManager():GetAll() ) do
		if p ~= pIgnorePlayer then
			if p:IsInGame() and p:GetChar():GetJob() == TJobTaxi then
				local pVeh = p:GetVehicleSeat() == 0 and p:GetVehicle();
				
				if pVeh and pVeh:GetJob() == TJobTaxi then
					p:GetChat():Send( "Диспетчер такси: " + sText, 215, 142, 16 );
				end
			end
		end
	end
end

function TJobTaxi:GetDrivers()
	local Drivers = {};
	
	for _, p in pairs( g_pGame:GetPlayerManager():GetAll() ) do
		if p:IsInGame() and p:GetChar():GetJob() == TJobTaxi then
			table.insert( Drivers, p );
		end
	end
	
	return Drivers;
end

function TJobTaxi:RegisterCall( pPlayer )
	if pPlayer:IsInGame() then
		self.m_pCall	=
		{
			vecPosition 	= pPlayer:GetPosition();
			sName			= pPlayer:GetName();
			pCaller			= pPlayer;
		};
		
		self:SendMessage( "новый вызов, " + self.m_pCall.sName + ", улица " + GetZoneName( self.m_pCall.vecPosition ) + " (Нажмите Alt для принятия)", pPlayer );
		
		return true;
	end
	
	return false;
end

function TJobTaxi.CPlayer:AcceptCall()
	if self:IsInGame() then
		local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
		
		if pVehicle and pVehicle:GetJob() == TJobTaxi and self:GetChar():GetJob() == TJobTaxi then
			local pCall = TJobTaxi.m_pCall;
			
			if pCall and pCall.pCaller ~= self then
				if not self.m_pJob then 
					self.m_pJob = CMarker.Create( pCall.vecPosition, 'checkpoint', 10.0, 255, 255, 0, 96, self.__instance );
					
					CBlip( self.m_pJob, 0, 2.0, 255, 255, 0, 255, 10, 9999.0, self.__instance ):SetParent( self.m_pJob );
					
					self.m_pJob.OnHit = TJobTaxi.CPlayer.OnTaxiMarkerHit;
					
					TJobTaxi:SendMessage( self:GetName() + " принял вызов от " + pCall.sName );
				else
					self:Hint( "Работа: " + TJobTaxi:GetName(), "Вы уже приняли вызов", "error" );
				end
			else
				self:Hint( "Работа: " + TJobTaxi:GetName(), "Никаких вызовов не поступало", "error" );
			end
			
			return;
		end
	end
	
	self:EndCurrentJob();
end

function TJobTaxi.CPlayer:ToggleTaxiLight()
	if self:IsInGame() then
		local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
		
		if pVehicle and pVehicle:GetJob() == TJobTaxi and self:GetChar():GetJob() == TJobTaxi then
			pVehicle:SetTaxiLightOn( not pVehicle:IsTaxiLightOn() );
			
			local vDistance = not pVehicle:IsTaxiLightOn() and 0;
			
			for i, p in pairs( pVehicle:GetOccupants() ) do
				if p:IsInGame() then
					p:Client().TJobTaxi_SetMeter( vDistance, pVehicle.__instance );
				end
			end
			
			return;
		end
	end
	
	self:EndCurrentJob();
end

function TJobTaxi.CPlayer.OnTaxiMarkerHit( pMarker, pPlayer, bMatching )
	if bMatching and pPlayer:type() == 'player' and pMarker == pPlayer.m_pJob then
		local pVehicle = pPlayer:IsInGame() and pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
		
		if pVehicle and pVehicle:GetJob() == TJobTaxi and pPlayer:GetChar():GetJob() == TJobTaxi then
			pPlayer.m_pJob:Destroy();
			
			pPlayer.m_pJob		= NULL;
			TJobTaxi.m_pCall	= NULL;
			
			return;
		end
		
		pPlayer:EndCurrentJob();
	end
end

function CClientRPC:TJobTaxi_Update( fDistance )
	if self:IsInGame() then
		local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
		
		if pVehicle and pVehicle:GetJob() == TJobTaxi and self:GetChar():GetJob() == TJobTaxi then
			for i, p in pairs( pVehicle:GetOccupants() ) do
				if p:IsInGame() then
					p:Client().TJobTaxi_SetMeter( fDistance, pVehicle.__instance );
				end
			end
			
			return;
		end
	end
	
	self:EndCurrentJob();
end