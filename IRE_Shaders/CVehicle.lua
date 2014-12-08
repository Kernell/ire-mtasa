-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CVehicle ( CElement )
{
	CVehicle		= function( this, pVehicle )
		pVehicle( this );
		
		Debug( classname( pVehicle ) + " " + pVehicle:GetID() );
		
		if pVehicle:GetData( "RemapBody" ) then -- TODO: Переделать под все автомобили
			this.m_pCarpaint	= new. CVehicleCarpaint;
			
			this.m_pCarpaint.m_pVehicle = pVehicle;
			
			this.m_pCarpaint:LuaBehaviour();
		end
		
		return pVehicle;
	end;
	
	_CVehicle		= function( this )
		Debug( classname( this ) + " " + this:GetID() );
		
		if this.m_pCarpaint then
			this.m_pCarpaint:_LuaBehaviour();
		end
		
		this.m_pCarpaint = NULL;
		
		this:__gc();
	end;
};