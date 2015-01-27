-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. VehicleManager
{
	static
	{
		Root = getElementByID( "Vehicle" );
	};
	
	DEBUG_DISTANCE	= 30;
	
	VehicleManager	= function()
		this.List	= {};
		
		function this.__OnCollision( hitElement, force )
			if not this.List[ source ] then
				this.List[ source ] = new. Vehicle( source );
			end
			
			source.OnCollision( hitElement, force );
		end
		
		function this.__OnRespawn()
			if getElementType( source ) == "vehicle" then
				if not this.List[ source ] then
					this.List[ source ] = new. Vehicle( source );
				end
				
				source.OnRespawn();
			end
		end
		
		function this.__OnDestroy()
			if getElementType( source ) == "vehicle" then
				if this.List[ source ] then
					source.OnDestroy();
					
					this.List[ source ] = NULL;
					
					delete ( source );
				end
			end
		end
		
		function this.__OnStreamIn()
			if getElementType( source ) == "vehicle" then
				if not this.List[ source ] then
					this.List[ source ] = new. Vehicle( source );
				end
				
				source.OnStreamIn();
			end
		end
		
		function this.__OnStreamOut()
			if getElementType( source ) == "vehicle" then
				if this.List[ source ] then
					source.OnStreamOut();
					
					this.List[ source ] = NULL;
					
					delete ( source );
				end
			end
		end
		
		function this.__OnDataChange( name, oldValue )
			if getElementType( source ) == "vehicle" then
				if not this.List[ source ] then
					this.List[ source ] = new. Vehicle( source );
				end
				
				source.OnDataChange( name, oldValue );
			end
		end
		
		function this.__OnPreRender( deltaTime )
			if isElement( VehicleManager.Root ) then	
				local vehicles = getElementsByType( "vehicle", VehicleManager.Root, true );
				
				for i = 1, table.getn( vehicles ) do
					local vehicle = vehicles[ i ];
					
					if not this.List[ vehicle ] then
						vehicle = new. Vehicle( source );
						
						this.List[ vehicle ] = vehicle;
					end
					
					vehicle.DoPulse( deltaTime );
				end
			end
		end
		
		function this.__OnDebugRender()
			this.OnDebugRender();
		end
		
		addEventHandler( "onClientVehicleCollision", 	VehicleManager.Root, this.__OnCollision );
		addEventHandler( "onClientVehicleRespawn", 		VehicleManager.Root, this.__OnRespawn );
		addEventHandler( "onClientElementDestroy", 		VehicleManager.Root, this.__OnDestroy );
		addEventHandler( "onClientElementStreamIn", 	VehicleManager.Root, this.__OnStreamIn );
		addEventHandler( "onClientElementStreamOut", 	VehicleManager.Root, this.__OnStreamOut );
		addEventHandler( "onClientElementDataChange", 	VehicleManager.Root, this.__OnDataChange );
		addEventHandler( "onClientPreRender", 			root, this.__OnPreRender );
	end;
	
	_VehicleManager	= function()
		if isElement( VehicleManager.Root ) then		
			removeEventHandler( "onClientVehicleCollision", 	VehicleManager.Root, this.__OnCollision );
			removeEventHandler( "onClientVehicleRespawn", 		VehicleManager.Root, this.__OnRespawn );
			removeEventHandler( "onClientElementDestroy", 		VehicleManager.Root, this.__OnDestroy );
			removeEventHandler( "onClientElementStreamIn", 		VehicleManager.Root, this.__OnStreamIn );
			removeEventHandler( "onClientElementStreamOut", 	VehicleManager.Root, this.__OnStreamOut );
			removeEventHandler( "onClientElementDataChange", 	VehicleManager.Root, this.__OnDataChange );
		end
		
		removeEventHandler( "onClientPreRender", root, this.__OnPreRender );
		
		for vehicle in pairs( this.List ) do
			this.List[ vehicle ] = NULL;
			
			delete ( vehicle );
		end
	end;
	
	UpdateDebug		= function()
		for i, vehicle in ipairs( getElementsByType( "vehicle", VehicleManager.Root, true ) ) do
			if this.List[ vehicle ] then
				local lastTime	= vehicle.GetData( "Vehicle::LastTime" );
				
				if lastTime then
					local t		= getRealTime( lastTime );
					
					if not vehicle.Debug then
						vehicle.Debug = {};
					end
					
					vehicle.Debug.Name			= vehicle.GetName();
					vehicle.Debug.LastTime 		= ( "%02d/%02d/%04d %d:%02d:%02d" ):format( t.monthday, t.month + 1, t.year + 1900, t.hour, t.minute, t.second );
					vehicle.Debug.LastDriver	= vehicle.GetData( "Vehicle::LastDriver" ) or "None";
				end
			end
		end
	end;
	
	OnDebugRender	= function()
		local clientPosition	= CLIENT.GetPosition();
		
		for vehicle in pairs( this.List ) do
			if vehicle.IsOnScreen() then
				local position 	= vehicle.GetPosition();
				local distance	= position.Distance( clientPosition );
				
				if distance < this.DEBUG_DISTANCE then
					local sx, sy = getScreenFromWorldPosition( position.X, position.Y, position.Z );
					
					if sx and sy then
						local ID			= vehicle.ID;
						local health		= vehicle.GetHealth();
						local lastTime		= vehicle.Debug.LastTime;
						local lastDriver	= vehicle.Debug.LastDriver;
						
						local text = string.format( "%.3f\nID:%d (%d)\nHealth: %.2f\nLast time: %s\nLast driver: %s", distance, ID, vehicle.GetModel(), health, lastTime, lastDriver );
						
						local alpha	= Lerp( 255, 0, distance / this.DEBUG_DISTANCE );
						
						dxDrawText( text, sx + 1, sy + 1, sx + 1, sy + 1, tocolor( 0, 0, 0, alpha ), 1.0, 'default-bold', 'center', 'bottom' );
						dxDrawText( text, sx - 1, sy - 1, sx - 1, sy - 1, tocolor( 0, 0, 0, alpha ), 1.0, 'default-bold', 'center', 'bottom' );
						dxDrawText( text, sx + 1, sy - 1, sx + 1, sy - 1, tocolor( 0, 0, 0, alpha ), 1.0, 'default-bold', 'center', 'bottom' );
						dxDrawText( text, sx - 1, sy + 1, sx - 1, sy + 1, tocolor( 0, 0, 0, alpha ), 1.0, 'default-bold', 'center', 'bottom' );
						dxDrawText( text, sx, sy, sx, sy, tocolor( 0, 196, 255, alpha ), 1.0, 'default-bold', 'center', 'bottom' );
					end
				end
			end
		end
	end;
	
	static
	{
		SetDebug	= function( enabled, distance )
			local this = resourceRoot.VehicleManager;
			
			this.DEBUG_DISTANCE = tonumber( distance ) or this.DEBUG_DISTANCE;
			
			if enabled then
				this.UpdateDebug();
				
				if not this.DebugTimer then
					this.DebugTimer = setTimer(
						function()
							this.UpdateDebug();
						end,
						1000,
						0
					);
					
					addEventHandler( "onClientRender", root, this.__OnDebugRender );				
				end
			elseif this.DebugTimer then
				killTimer( this.DebugTimer );
				
				this.DebugTimer = NULL;
				
				removeEventHandler( "onClientRender", root, this.__OnDebugRender );
			end
		end;
	};
};
