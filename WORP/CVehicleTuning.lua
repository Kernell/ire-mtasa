-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CVehicleTuning" ( CGUI )

local pDialog = NULL;

function CVehicleTuning:CVehicleTuning()
	if pDialog then
		delete ( pDialog );
		
		return;
	end
	
	pDialog	= self;
end

function CVehicleTuning:_CVehicleTuning()
	pDialog	= NULL;
	
	
end