-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CFactionPolice ( CFaction );

function CFactionPolice:CFactionPolice( ... )
	self:CFaction( ... );
	self.CFaction = NULL;
	
	
end

function CFactionPolice:ShowMenu( pPlayer, bForce )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		if pChar:GetFaction() == self then
			local pVehicle = pPlayer:GetVehicle();
			
			if pVehicle and pVehicle:GetFaction() == self then
				pPlayer:Client().CGUISAPD( pChar.m_PoliceStats );
			
				return true;
			end
		end
	end
	
	return false;
end

function CClientRPC:SAPD_RequestBackup()
	local pChar = self:GetChar();
	
	if pChar then
		local pFaction = pChar:GetFaction();
		
		if pFaction and pFaction:GetTag() == 'SAPD' then
			local pVehicle = self:GetVehicle();
			
			if pVehicle and pVehicle:GetFaction() == pFaction then
				if pVehicle.m_pBlip then
					delete ( pVehicle.m_pBlip );
				end
				
				pVehicle.m_pBlip = CBlip( pVehicle, 0, 1, 255, 0, 0, 255, 100, 99999.9, pFaction.m_pElement.__instance );
				pVehicle.m_pBlip:SetParent( pVehicle );
				
				self:OnChat( pVehicle:GetRegPlate() + " запрашивает подкрепление на " + pVehicle:GetZoneName(), 2 );
				
				pChar.m_PoliceStats.backup_calls = pChar.m_PoliceStats.backup_calls + 1;
			end
		end
	end
end