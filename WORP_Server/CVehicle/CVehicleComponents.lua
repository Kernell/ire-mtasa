-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local gl_aComponents	= 
{
--	"caliper_rf";
--	"caliper_lf";
--	"caliper_rb";
--	"caliper_lb";
	
	"stwheel_ok";
	
	"speedo_needle_ok";
	
	"indicator_left";
	"indicator_right";
	
	"WHELEN_A";
	"WHELEN_A_1";
	"WHELEN_A_2";
	"WHELEN_A_3";
	"WHELEN_A_4";
	"WHELEN_A_5";
	"WHELEN_A_6";
	"WHELEN_A_7";
	"WHELEN_A_8";
	"WHELEN_A_EXT";
	
	"WHELEN_B";
	"WHELEN_B_1";
	"WHELEN_B_2";
	"WHELEN_B_3";
	"WHELEN_B_4";
	"WHELEN_B_5";
	"WHELEN_B_6";
	"WHELEN_B_7";
	"WHELEN_B_8";
	"WHELEN_B_EXT";
	
	"WHELEN_C";
	"WHELEN_C_1";
	"WHELEN_C_2";
	"WHELEN_C_3";
	"WHELEN_C_4";
	"WHELEN_C_5";
	"WHELEN_C_6";
	"WHELEN_C_7";
	"WHELEN_C_8";
	"WHELEN_C_EXT";
	
	"SPOILER_0";
	"SPOILER_1";
	"SPOILER_2";
	"SPOILER_3";
	"SPOILER_4";
	"SPOILER_5";
	"SPOILER_6";
	"SPOILER_7";
	"SPOILER_8";
	"SPOILER_9";
	"SPOILER_10";
	
	"SSKIRT_0";
	"SSKIRT_1";
	"SSKIRT_2";
	"SSKIRT_3";
	"SSKIRT_4";
	"SSKIRT_5";
	"SSKIRT_6";
	"SSKIRT_7";
	"SSKIRT_8";
	"SSKIRT_9";
	"SSKIRT_10";
	
	"bump_front_dummy";
	"FBUMP_1";
	"FBUMP_2";
	"FBUMP_3";
	"FBUMP_4";
	"FBUMP_5";
	"FBUMP_6";
	"FBUMP_7";
	"FBUMP_8";
	"FBUMP_9";
	"FBUMP_10";
	
	"bump_rear_dummy";
	"RBUMP_1";
	"RBUMP_2";
	"RBUMP_3";
	"RBUMP_4";
	"RBUMP_5";
	"RBUMP_6";
	"RBUMP_7";
	"RBUMP_8";
	"RBUMP_9";
	"RBUMP_10";
	
	"bonnet_dummy";
	"BONNET_1";
	"BONNET_2";
	"BONNET_3";
	"BONNET_4";
};

class "CVehicleComponents"

function CVehicleComponents:CVehicleComponents( pVehicle )
	self.m_pVehicle = pVehicle;
	
	self.m_Components = {};
	
	for i, sComponent in ipairs( gl_aComponents ) do
		self.m_Components[ sComponent ] = {};
	end
end

function CVehicleComponents:_CVehicleComponents()

end

function CVehicleComponents:SetVisible( sComponent, bVisible )
	if classof( self ) ~= CVehicleComponents then error( TEXT_E2288, 2 ) end
	
	if self.m_Components[ sComponent ] then
		self.m_Components[ sComponent ].m_bVisible = (bool)(bVisible);
		
		self.m_pVehicle:SetData( "CVehicleComponents->" + sComponent, self.m_Components[ sComponent ] );
		
		return true;
	end
	
	return false;
end

function CVehicleComponents:SetPosition( sComponent, vecPosition )
	if classof( self ) ~= CVehicleComponents then error( TEXT_E2288, 2 ) end
	
	if self.m_Components[ sComponent ] then
		self.m_Components[ sComponent ].m_vecPosition = vecPosition;
		
		self.m_pVehicle:SetData( "CVehicleComponents->" + sComponent, self.m_Components[ sComponent ] );
		
		return true;
	end
	
	return false;
end

function CVehicleComponents:SetRotation( sComponent, vecRotation )
	if classof( self ) ~= CVehicleComponents then error( TEXT_E2288, 2 ) end
	
	if self.m_Components[ sComponent ] then
		self.m_Components[ sComponent ].m_vecRotation = vecRotation;
		
		self.m_pVehicle:SetData( "CVehicleComponents->" + sComponent, self.m_Components[ sComponent ] );
		
		return true;
	end
	
	return false;
end
