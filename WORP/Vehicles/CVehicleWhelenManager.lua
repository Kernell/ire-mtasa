-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CVehicleWhelenManager
{
	static
	{
		Whelens	=
		{
			"A", "B", "C";
		};
	};
	
	CVehicleWhelenManager	= function( this )
		this.m_List		= {};
		
		for i, pVeh in ipairs( getElementsByType( "vehicle", root, true ) ) do
			this:PerformChecks( pVeh );
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
			if getElementType( source ) == "vehicle" then
				for i, Index in ipairs( CVehicleWhelenManager.Whelens ) do
					if source[ "m_pWhelen" + Index ] then
						delete ( source[ "m_pWhelen" + Index ] );
						source[ "m_pWhelen" + Index ] = NULL;
					end
				end
			end
		end
		
		addEventHandler( "onClientElementDataChange", root,
			function( sDataName, vOldValue )
				if sDataName == "WHELEN_A" or sDataName == "WHELEN_B" or sDataName == "WHELEN_C" then
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
		for pWhelen in pairs( this.m_List ) do	
			if pWhelen.m_pWhelenData then
				pWhelen.m_iTimeElapsed = pWhelen.m_iTimeElapsed + iTimeSlice;
				
				if pWhelen.m_pWhelenData.m_iDelay <= pWhelen.m_iTimeElapsed then
					pWhelen.m_iTimeElapsed = 0;
					
					pWhelen:Process();
				end
			else
				delete ( pWhelen );
			end
		end
	end;
	
	PerformChecks = function( this, pVehicle )
		for i, Index in ipairs( CVehicleWhelenManager.Whelens ) do
			local sVehicleWhelen	= "m_pWhelen" + Index;
			local sWhelen 			= "WHELEN_" + Index;
			local iWhelen 			= pVehicle:GetData( sWhelen );
			
			if iWhelen and iWhelen ~= 0 then
				if not pVehicle[ sVehicleWhelen ] then
					if pVehicle:GetComponentVisible( sWhelen ) then
						pVehicle[ sVehicleWhelen ] = CVehicleWhelen( this, pVehicle, sWhelen );
					end
				end
				
				if pVehicle[ sVehicleWhelen ] then
					pVehicle[ sVehicleWhelen ]:Update( iWhelen );
				end
			elseif pVehicle[ sVehicleWhelen ] then
				delete ( pVehicle[ sVehicleWhelen ] );
				pVehicle[ sVehicleWhelen ] = NULL;
			end
		end
	end;
	
	AddToList		= function( this, pWhelen )
		this.m_List[ pWhelen ] = true;
	end;
	
	RemoveFromList	= function( this, pWhelen )
		this.m_List[ pWhelen ] = NULL;
	end;
	
	m_List	= NULL;
};

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		CVehicleWhelenManager();
	end,
	false
);
