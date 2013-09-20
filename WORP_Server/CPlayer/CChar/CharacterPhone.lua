-- Author:      	Kernell
-- Version:     	1.0.0

function CChar:InitPhone( iNumber )
	self.m_iPhone = iNumber;
	
	if not self.m_iPhone then
		self:GeneratePhoneNumber();
	end
end

function CChar:GeneratePhoneNumber()
	for i = 1, 10 do
		if self:SetPhoneNumber( math.random( 100000, 999999 ) ) then
			return true;
		end
	end
	
	return false;
end

function CChar:SetPhoneNumber( iNumber )
	iNumber = tonumber( iNumber );
	
	if iNumber and g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET phone = %d WHERE id = %d", iNumber, self:GetID() ) then
		self.m_iPhone = iNumber;
		
		return true;
	end
	
	return false;
end

function CChar:GetPhoneNumber()
	return self.m_iPhone;
end
