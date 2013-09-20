-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function CPlayer:InitJob()
	if self:IsInGame() then
		self:EndCurrentJob();
		
		local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
		
		if pVehicle then
			local pJob = pVehicle:GetJob();
			
			if pJob then
				if pJob == self:GetChar():GetJob() then
					pJob:Init( self );
					
					return true;
				end
				
				self:Hint( "Вы не работаете " + pJob:GetName2(), "Устройтесь на работу " + pJob:GetName2() + ", чтобы управлять этим транспортным средством", "warning" );
			else
				if _DEBUG then Debug( "DEBUG: '" + pVehicle:GetName() + "' (ID: " + pVehicle:GetID() + ") not job vehicle ", 0, 0, 128, 255 ) end
			end
		else
			if _DEBUG then Debug( "DEBUG: " + self:GetName() + " not driving vehicle", 0, 0, 128, 255 ) end
		end
	else
		if _DEBUG then Debug( "DEBUG: " + self:GetName() + " not in game", 0, 0, 128, 255 ) end
	end
	
	return false;
end

function CPlayer:EndCurrentJob()
	if _DEBUG then Debug( "DEBUG: " + self:GetName() + ":EndCurrentJob()", 0, 0, 128, 255 ) end
	
	if self:IsInGame() then
		local pJob = self:GetChar():GetJob();
		
		if pJob then
			if self.m_pJob then
				if pJob.Finalize then
					pJob:Finalize( self );
				
					if _DEBUG then Debug( "DEBUG: " + pJob:GetID() + ":Finalize( " + self:GetName() + " )", 0, 0, 128, 255 ) end
				end
				
				if self.m_pJob.Destroy then
					self.m_pJob:Destroy();
				end
				
				-- self:Hint( "Работа: " + pJob:GetName(), "Ваша зарплата составляет: $" + self:GetChar():GetPay() + "\nВы можете забрать её в администрации штата", "info" );
			
				self.m_pJob = NULL;
			else
				if _DEBUG then Debug( "DEBUG: " + self:GetName() + "->m_pJob is NULL", 0, 0, 128, 255 ) end
			end
		else
			if _DEBUG then Debug( "DEBUG: " + self:GetName() + " not working on any job", 0, 0, 128, 255 ) end
		end
		
		return true;
	else
		if _DEBUG then Debug( "DEBUG: " + self:GetName() + " not in game", 0, 0, 128, 255 ) end
	end
	
	return false;
end