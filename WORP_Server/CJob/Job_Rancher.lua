-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

--[[ -1062.1 -1631.7 75.3
-1052.3 -1631.7 75.3
-1042.4 -1631.7 75.3
-1032.6 -1631.7 75.3
-1023.1 -1631.7 75.3
-1062.1 -1622.2 75.3
-1052.3 -1622.2 75.3
-1042.4 -1622.2 75.3
-1032.6 -1622.2 75.3
-1023.1 -1622.2 75.3
-991.92 -1703.1 75.3
-982.38 -1703.1 75.3
-991.92 -1693.6 75.3
-982.38 -1693.6 75.3
-991.92 -1684.1 75.3
-982.38 -1684.1 75.3
-1011.8 -1667.6 75.3
-1011.8 -1658.1 75.3
-1011.8 -1648.7 75.3
-1000.7 -1667.6 75.3
-1000.7 -1658.1 75.3
-1000.7 -1648.7 75.3
-1011.8 -1672.3 75.3
-991.92 -1688.8 75.3
-982.38 -1688.8 75.3
-982.38 -1698.2 75.3
-991.92 -1698.2 75.3
-982.38 -1707.7 75.3
-1011.8 -1662.8 75.3
-1000.7 -1672.3 75.3
-1011.8 -1653.4 75.3
-1032.6 -1636.3 75.3
-1052.3 -1636.3 75.3
-1042.4 -1636.3 75.3
-1062.1 -1626.8 75.3
-991.92 -1707.7 75.3
-1023.1 -1626.8 75.3
-1000.7 -1662.8 75.3
-1000.7 -1653.4 75.3
-1032.6 -1626.8 75.3
-1042.4 -1626.8 75.3
-1052.3 -1626.8 75.3
-1062.1 -1636.3 75.3
-1023.1 -1636.3 75.3 ]]

-- KMB_MARIJUANA	2901
-- GRASSPLANT		3409

local OnWaltonUnload, OnColShapeHit, OnRickPickup, FailRick;

local WALTON_MARKER_LOAD_OFFSETS	= Vector3( 0, -4, -1 );
local WALTON_UNLOADING_POSITION		= Vector3( -1423.67, -1502.45, 101.56 );
local COLSHAPE_POSITION				= Vector3( -1195.25, -1060.0, 128.00 );
local TJobRancher	= CJob( 'rancher', 107, 'Фермер', 'фермером', Vector3( -1060.885, -1205.388, 129.5 ) );
local aRickOffsets	=
{
	{ Vector3( .8, -1, .2 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .4, -1, .2 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .0, -1, .2 ), Vector3( 0, 0, 90 ) };
	{ Vector3(-.4, -1, .2 ), Vector3( 0, 0, 90 ) };
	{ Vector3(-.8, -1, .2 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .8, -1, .6 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .4, -1, .6 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .0, -1, .6 ), Vector3( 0, 0, 90 ) };
	{ Vector3(-.4, -1, .6 ), Vector3( 0, 0, 90 ) };
	{ Vector3(-.8, -1, .6 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .8, -2.25, .2 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .4, -2.25, .2 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .0, -2.25, .2 ), Vector3( 0, 0, 90 ) };
	{ Vector3(-.4, -2.25, .2 ), Vector3( 0, 0, 90 ) };
	{ Vector3(-.8, -2.25, .2 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .8, -2.25, .6 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .4, -2.25, .6 ), Vector3( 0, 0, 90 ) };
	{ Vector3( .0, -2.25, .6 ), Vector3( 0, 0, 90 ) };
	{ Vector3(-.4, -2.25, .6 ), Vector3( 0, 0, 90 ) };
	{ Vector3(-.8, -2.25, .6 ), Vector3( 0, 0, 90 ) };
};

local ResetGrassplant;
local pGrassplantTimer	= NULL;
local aObjects	 		= {};

function TJobRancher:PlayerJoin( pPlayer )
end

function TJobRancher:PlayerLeave( pPlayer )
	if pPlayer.m_pJob then
		pPlayer.m_pJob:Destroy();
	end
end

function TJobRancher:Init( pPlayer )
	local pVehicle = pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
	
	if pVehicle then
		if pPlayer.m_pJob then
			pPlayer.m_pJob:Destroy();
			pPlayer.m_pJob = nil;
		end
		
		if pVehicle:GetModel() == 532 then -- Combine Harvester
		
		elseif pVehicle:GetModel() == 478 then -- Walton
			if not pVehicle.m_TJobRancher then
				pVehicle.m_TJobRancher = {};
			end
			
			if not pVehicle.m_TJobRancher.m_aRicks then
				pVehicle.m_TJobRancher.m_aRicks = {};
			end
			
			if #pVehicle.m_TJobRancher.m_aRicks > 0 then
				pPlayer.m_pJob = CMarker.Create( WALTON_UNLOADING_POSITION, 'cylinder', 4.0, 255, 0, 64, 128, pPlayer.__instance );
				
				CBlip( pPlayer.m_pJob, 0, 2.0, 255, 0, 64, 255, 10, 9999.0, pPlayer.__instance ):SetParent( pPlayer.m_pJob );
				
				pPlayer.m_pJob.OnHit = OnWaltonUnload;
				
				pPlayer:Hint( "Работа: " + self:GetName(), "Чтобы разгрузить грузовик, отправляйтесь к месту которое отмечено на карте", "info" );
			end
		end
	end
end

function TJobRancher:Finalize( pPlayer )
	local pRick = pPlayer.m_pJob and pPlayer.m_pJob.m_pRick;
	
	if pRick then
		pPlayer:DetachFromBone( pRick );
				
		pPlayer.m_pJob:Destroy();
		pPlayer.m_pJob = NULL;
		
		local vecPosition = pPlayer:GetPosition();
		vecPosition.Z = vecPosition.Z - .65
		local fRotation = pPlayer:GetRotation();
		
		pRick:SetPosition( vecPosition );
		pRick:SetRotation( Vector3( 0, 0, fRotation ) );
		pRick:SetCollisionsEnabled( false );
	end
	
	TJobRancher:UnbindFailKeys( pPlayer );
end

function TJobRancher:BindFailKeys( pPlayer )
	pPlayer:BindKey( "sprint",			"down", FailRick );
	pPlayer:BindKey( "jump", 			"down", FailRick );
	pPlayer:BindKey( "crouch",			"down", FailRick );
	pPlayer:BindKey( "fire",			"down", FailRick );
	pPlayer:BindKey( "aim_weapon",		"down", FailRick );
	pPlayer:BindKey( "enter_exit",		"down", FailRick );
	pPlayer:BindKey( "enter_passenger",	"down", FailRick );
end

function TJobRancher:UnbindFailKeys( pPlayer )
	pPlayer:UnbindKey( "sprint",			"down", FailRick );
	pPlayer:UnbindKey( "jump", 				"down", FailRick );
	pPlayer:UnbindKey( "crouch",			"down", FailRick );
	pPlayer:UnbindKey( "fire",				"down", FailRick );
	pPlayer:UnbindKey( "aim_weapon",		"down", FailRick );
	pPlayer:UnbindKey( "enter_exit",		"down", FailRick );
	pPlayer:UnbindKey( "enter_passenger",	"down", FailRick );
end

function TJobRancher.OnMarkerHit( pMarker, pPlayer, bMatching )
	-- Debug( "TJobRancher.OnMarkerHit -> " + classname( pPlayer ) );
	
	if bMatching and pPlayer:type() == 'player' and not pPlayer:IsInVehicle() then
		local pChar = pPlayer:GetChar();
		
		if pChar then
			if pChar:GetJob() == TJobRancher then			
				local pRick = pPlayer.m_pJob and pPlayer.m_pJob.m_pRick;
				
				if pRick then
					local pVehicle = pMarker.m_pVehicle;
					
					assert( pVehicle, "pMarker->m_pVehicle (is NULL)" );
					
					if pVehicle then
						pVehicle:SetDoorOpenRatio( 1, 1.0 );
						
						if not pVehicle.m_TJobRancher then
							pVehicle.m_TJobRancher = {};
						end
						
						if not pVehicle.m_TJobRancher.m_aRicks then
							pVehicle.m_TJobRancher.m_aRicks = {};
						end
						
						local aRicks = pVehicle.m_TJobRancher.m_aRicks;
						
						if #aRicks < #aRickOffsets then
							TJobRancher:UnbindFailKeys( pPlayer );
							
							pPlayer:SetAnimation( "CARRY", "putdwn105", -1, false, false, false, false );
							pPlayer:DetachFromBone( pRick );
							pPlayer:PlaySoundFrontEnd( 10 );
							
							pRick:AttachTo( pVehicle, unpack( aRickOffsets[ #aRicks + 1 ] ) );
							pRick:SetAttachedOffsets( unpack( aRickOffsets[ #aRicks + 1 ] ) );
							pRick:SetCollisionsEnabled( false );
							
							table.insert( aRicks, pRick );
							
							pPlayer.m_pJob:Destroy();
							pPlayer.m_pJob = nil;
							
							pChar:GivePay( 10 );
							pChar:SetJobSkill( math.min( 1000, pChar:GetJobSkill() + 1 ) );
						else
							pPlayer:Hint( "Работа: " + TJobRancher:GetName(), "Грузовик заполнен!", "error" );
						end
						
						return;
					end
				end
			else
				pPlayer:Hint( "Ошибка", "Вы не работаете " + TJobRancher:GetName2() + "!", "error" );
			end
		else
			if _DEBUG then Debug( "DEBUG: " + pPlayer:GetName() + " not in game", 0, 0, 128, 255 ) end
		end
		
		pPlayer:EndCurrentJob();
	end
end

function ResetGrassplant()
	for i, pObj in ipairs( aObjects ) do
		if not pObj.m_pMainCol.OnHit then
			pObj.m_pMainCol.OnHit = OnColShapeHit;
			pObj.m_pMainCol.m_pGRASSPLANT:SetAlpha( 255 );
		end
	end
	
	pGrassplantTimer = NULL;
end

function OnWaltonUnload( pMarker, pPlayer, bMatching )
	if bMatching and pPlayer:type() == 'player' then
		local pChar = pPlayer:GetChar();
		
		if pChar then
			local pVehicle = pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
			
			if pVehicle then
				if pChar:GetJob() == pVehicle:GetJob() then
					if pVehicle.m_TJobRancher and table.getn( pVehicle.m_TJobRancher.m_aRicks ) > 0 then
						-- local iMoneys = #pVehicle.m_TJobRancher.m_aRicks * 10;
						
						for i, o in ipairs( pVehicle.m_TJobRancher.m_aRicks ) do
							o:Detach();
							o:SetDimension( 255 );
						end
						
						pVehicle.m_TJobRancher.m_aRicks = {};
						
						-- pChar:GivePay( iMoneys );
						-- pChar:SetJobSkill( math.min( 1000, pChar:GetJobSkill() + 1 ) );
						
						pPlayer:PlaySoundFrontEnd( 10 );
						-- pPlayer:Hint( "Работа: " + TJobRancher:GetName(), "Вы заработали $" + iMoneys + " (добавлено к зарплате)", "ok" );
						pPlayer:Hint( "Работа: " + TJobRancher:GetName(), "Грузовик разгружен\n\nВозвращайтесь на ферму", "ok" );
						
						pPlayer.m_pJob:Destroy();
						pPlayer.m_pJob = NULL;
						
						if pGrassplantTimer then
							delete ( pGrassplantTimer );
							pGrassplantTimer = NULL;
						end
						
						pGrassplantTimer = CTimer( ResetGrassplant, 10000, 1 );
					end
					
					return;
				else
					pPlayer:Hint( "Ошибка", "Вы не работаете " + TJobRancher:GetName2() + "!", "error" );
				end
			else
				if _DEBUG then Debug( "DEBUG: Player '" + pPlayer:GetName() + "' (ID: " + pPlayer:GetID() + ") entered in the marker without vehicle", 0, 0, 128, 255 ) end
			end
		else
			if _DEBUG then Debug( "DEBUG: " + pPlayer:GetName() + " invalid character", 0, 0, 128, 255 ) end
		end
		
		pPlayer:EndCurrentJob();
	end
end

function OnColShapeHit( this, pVehicle, bMatching )
	if bMatching and pVehicle:type() == 'vehicle' and pVehicle:GetJob() == TJobRancher and pVehicle:GetModel() == 532 then
		local pPlayer = pVehicle:GetDriver();
		
		if pPlayer and pPlayer:IsInGame() and pPlayer:GetChar():GetJob() == TJobRancher then
			local fSpeed	= pVehicle:GetSpeed();
			
			if fSpeed < 20 then
				local vecPosition 		= pVehicle:GetPosition();
				local vecRotation		= pVehicle:GetRotation();
				
				vecPosition.Z			= vecPosition.Z + 1.4;
				vecPosition				= vecPosition:Offset( 2.5, vecRotation.Z + 154 );
				
				this.m_pRick:SetPosition( vecPosition );
				
				vecRotation.Z			= vecRotation.Z + 90;
				
				this.m_pRick:SetRotation( vecRotation );
				
				vecPosition.Z			= vecPosition.Z - 3.0;
				
				this.m_pRick:SetDimension( pVehicle:GetDimension() );
				this.m_pRick:Move		( 500, vecPosition );
				
				this.m_pRick.m_pCol:AttachTo( this.m_pRick );
				
				this.OnHit = NULL;
				
				this.m_pGRASSPLANT:SetAlpha( 0 );
			else
				pPlayer:Hint( "Работа: " + TJobRancher:GetName(), "Слишком быстро!\n\nСкорость должна быть не более 20 км\ч", "error" );
			end
		end
	end
end

function OnRickPickup( this, pPlayer, bMatching )
	if bMatching and pPlayer:type() == 'player' and pPlayer:IsInGame() and pPlayer:GetChar():GetJob() == TJobRancher then
		if not pPlayer:IsInVehicle() and not pPlayer.m_pJob and not pPlayer.m_bLowHPAnim and not pPlayer:IsCuffed() and not pPlayer:GetControlState( 'sprint' ) then
			if not pPlayer:GetBones():IsObjectAttached( this.m_pRick ) and not this.m_pRick:IsAttached() and this.m_pRick:GetDimension() ~= 255 then
				pPlayer.m_pJob 			= CElement.Create( 'TJobRancher', 'TJobRancher:' + pPlayer:GetID() );
				pPlayer.m_pJob.m_pRick 	= this.m_pRick;
				
				pPlayer:SetAnimation( "CARRY", "liftup", -1, false );
				
				setTimer(
					function()
						if pPlayer:IsInGame() and pPlayer:GetChar():GetJob() == TJobRancher and not pPlayer:IsInVehicle() and not pPlayer.m_bLowHPAnim and not pPlayer:IsCuffed() then
							if not pPlayer:GetControlState( 'sprint' )  then
								pPlayer:AttachToBone( this.m_pRick, 11, NULL, NULL );
								-- pPlayer:Client().TJobRancher_CreateMarkers( pPlayer.m_pJob.__instance );
								
								for i, pVeh in pairs( g_pGame:GetVehicleManager():GetAll() ) do
									if pVeh:GetModel() == 478 and pVeh:GetJob() == TJobRancher then
										local vecPosition = pVeh:GetPosition():Offset( WALTON_MARKER_LOAD_OFFSETS.Y, pVeh:GetRotation().Z );
										
										vecPosition.Z = vecPosition.Z + WALTON_MARKER_LOAD_OFFSETS.Z;
										
										local pMarker = CMarker.Create( vecPosition, 'cylinder', 1.5, 255, 128, 64, 128, pPlayer.__instance );
										-- local pMarker = CMarker.Create( pVeh:GetPosition(), 'cylinder', 1.5, 255, 128, 64, 128, pPlayer.__instance );
										
										-- pMarker:AttachTo( pVeh, WALTON_MARKER_LOAD_OFFSETS );
										-- pMarker:GetColShape():AttachTo( pVeh, WALTON_MARKER_LOAD_OFFSETS );
										pMarker:SetParent( pPlayer.m_pJob );
										
										pMarker.m_pVehicle	= pVeh;
										pMarker.OnHit		= TJobRancher.OnMarkerHit;
									end
								end
								
								TJobRancher:BindFailKeys( pPlayer );
								
								setTimer(
									function()
										if pPlayer:IsInGame() and pPlayer:GetChar():GetJob() == TJobRancher and not pPlayer:IsInVehicle() and not pPlayer.m_bLowHPAnim and not pPlayer:IsCuffed() then
											pPlayer:SetAnimation( "CARRY", "crry_prtial", 0, false );
										end
									end,
									500, 1
								);
							else
								pPlayer:SetAnimation( NULL );
								pPlayer.m_pJob:Destroy();
								pPlayer.m_pJob = nil;
							end
						end
					end,
					900, 1
				);
			end
		end
	end
end

function FailRick( this, key, state )
	local pRick = this.m_pJob and this.m_pJob.m_pRick;
	
	if pRick then
		if ( key == 'sprint' or key == 'jump' ) and not this.m_bLowHPAnim and not this:IsCuffed() then
			this:SetAnimation( "PED", "KO_SKID_BACK", -1, false, true, false, true );
			
			setTimer(
				function()
					if this:IsInGame() and this:GetChar():GetJob() == TJobRancher and not this:IsInVehicle() and not this.m_bLowHPAnim and not this:IsCuffed() then
						this:SetAnimation( "PED", "getup_front", -1, false, true, false, false );
					end
				end,
				2000, 1
			);
		end
		
		this:DetachFromBone( pRick );
				
		this.m_pJob:Destroy();
		this.m_pJob = nil;
		
		local vecPosition = this:GetPosition();
		vecPosition.Z = vecPosition.Z - .65
		local fRotation = this:GetRotation();
		
		pRick:SetPosition( vecPosition );
		pRick:SetRotation( Vector3( 0, 0, fRotation ) );
		pRick:SetCollisionsEnabled( false );
	end
	
	TJobRancher:UnbindFailKeys( this );
end

for x = 0, 18 do
	for y = 0, 14 do
		local vecPosition	= Vector3( COLSHAPE_POSITION.X + ( 10 * x ), COLSHAPE_POSITION.Y + ( 10 * y ), COLSHAPE_POSITION.Z );
		
		local pObj			= CObject.Create( 2901, vecPosition );
		
		pObj.m_pCol		 	= CColShape( 'Sphere', vecPosition.X, vecPosition.Y, vecPosition.Z, 4.0 );
		pObj.m_pCol.m_pRick	= pObj;
		pObj.m_pCol.OnHit	= OnRickPickup;
		
		pObj:SetCollisionsEnabled( false );
		pObj:SetDimension		( 255 );
		pObj.m_pCol:SetParent	( pObj );
		pObj.m_pCol:AttachTo	( pObj );
		
		local pCol		= CColShape( 'Cuboid', vecPosition.X - 2.0, vecPosition.Y - 2.0, vecPosition.Z, 4.0, 4.0, 4.0 );
		
		pCol.OnHit		= OnColShapeHit;
		pCol.m_pRick	= pObj;
		
		pCol.m_pGRASSPLANT	= CObject.Create( 3409, vecPosition );
		pCol.m_pGRASSPLANT:SetScale( 2 );
		
		pObj.m_pMainCol	= pCol;
		
		table.insert( aObjects, pObj );
	end
end

local function OnVehicleReset()
	if getElementType( source ) == 'vehicle' then
		if source:GetJob() == TJobRancher then
			if source.m_TJobRancher and source.m_TJobRancher.m_aRicks then
				for i, o in ipairs( source.m_TJobRancher.m_aRicks ) do
					o:Detach();
					o:SetDimension( 255 );
				end
				
				source.m_TJobRancher.m_aRicks = {};
			end
		end
	end
end

pGrassplantTimer	= CTimer( ResetGrassplant, 1200000, 1 );

addEventHandler( "onVehicleRespawn", resourceRoot, OnVehicleReset );
addEventHandler( "onElementDestroy", resourceRoot, OnVehicleReset );
