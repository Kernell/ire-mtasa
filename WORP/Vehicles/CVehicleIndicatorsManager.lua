-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CVehicleIndicatorsManager
{
	CVehicleIndicatorsManager	= function( this )
		this.m_List		= {};
		
		for i, pVeh in ipairs( getElementsByType( "vehicle", root, true ) ) do
			local bLeft		= pVeh:GetData( "i:left" );
			local bRight	= pVeh:GetData( "i:right" );
			
			if bLeft or bRight then
				this:PerformChecks( pVeh );
			end
		end
		
		function this._Process( iTimeSlice )
			this:Process( iTimeSlice );
		end
		
		function this._PerformChecks()
			if getElementType( source ) == "vehicle" then
				this:PerformChecks( source );
			end
		end
		
		function this._Remove()
			if getElementType( source ) == "vehicle" and source.m_pIndicators then
				delete ( source.m_pIndicators );
			end
		end
		
		addEventHandler( "onClientElementDataChange", root,
			function( dataName, oldValue )
				if dataName == "i:left" or dataName == "i:right" then
					if getElementType( source ) == "vehicle" then
						this:PerformChecks( source );
					end
				end
			end
		);
		
		addEventHandler( "onClientVehicleRespawn", 		root,	this._PerformChecks );
		addEventHandler( "onClientElementStreamIn", 	root,	this._PerformChecks );
		
		addEventHandler( "onClientElementStreamOut", 	root, 	this._Remove );
		addEventHandler( "onClientElementDestroy", 		root, 	this._Remove );
		
		addEventHandler( "onClientPreRender", 			root, 	this._Process );
	end;
	
	Process	= function( this, iTimeSlice )
		for pIndicators in pairs( this.m_List ) do		
			pIndicators.m_iTimeElapsed = pIndicators.m_iTimeElapsed + iTimeSlice;
			
			pIndicators:Process();
		end
	end;
	
	PerformChecks = function( this, pVehicle )
		local bLeft		= pVehicle:GetData( "i:left" );
		local bRight	= pVehicle:GetData( "i:right" );
		
		if bLeft or bRight then
			if not pVehicle.m_pIndicators then
				CVehicleIndicators( this, pVehicle );
			end
			
			pVehicle.m_pIndicators.m_bLeft	= bLeft;
			pVehicle.m_pIndicators.m_bRight	= bRight;
			
			pVehicle.m_pIndicators:Update();
		elseif pVehicle.m_pIndicators then
			delete ( pVehicle.m_pIndicators );
		end
	end;
	
	AddToList		= function( this, pIndicators )
		this.m_List[ pIndicators ] = true;
	end;
	
	RemoveFromList	= function( this, pIndicators )
		this.m_List[ pIndicators ] = NULL;
	end;
	
	m_List	= NULL;
};

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		CVehicleIndicatorsManager();
	end,
	false
);

local function ToggleIndicatorState( sCmd, sIndicator )
	if sIndicator == "left" or sIndicator == "right" then
		local pVehicle = CLIENT:GetHealth() > 0 and CLIENT:GetVehicle();
		
		if pVehicle and pVehicle:GetDriver() == CLIENT then
			if pVehicle:GetType() == "Automobile" or pVehicle:GetType() == "Bike" or pVehicle:GetType() == "Quad" then
				local sDataName = "i:" + sIndicator;
				local bEnabled	= (bool)(pVehicle:GetData( sDataName ));
				
				pVehicle:SetData( sDataName, not bEnabled );
			end
		end
	end
end

addCommandHandler( "indicator", ToggleIndicatorState, false );
