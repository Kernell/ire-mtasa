-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CVehicle ( CElement, LuaBehaviour )
{
	CVehicle		= function( this, pVehicle )
		CElement.AddToList( this, pVehicle );
		
		if pVehicle:GetData( "RemapBody" ) then -- TODO: Переделать под все автомобили
			this.m_pCarpaint	= new. CVehicleCarpaint;
			
			this.m_pCarpaint.m_pVehicle 			= pVehicle;
			
			this.m_pCarpaint:LuaBehaviour();
		end
	end;
	
	_CVehicle		= function( this )
		if this.m_pCarpaint then
			this.m_pCarpaint:_LuaBehaviour();
		end
		
		this.m_pCarpaint = NULL;
	end;
};