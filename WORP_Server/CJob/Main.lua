-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local pPayPickup	= CPickup.Create( Vector3( 360.0, 180.0, 1008.4 ), 3, 1274 );

pPayPickup:SetDimension( 1 );
pPayPickup:SetInterior( 3 );

function pPayPickup:OnHit( pPlayer )
	if pPlayer:IsInGame() then
		local pChar = assert( pPlayer:GetChar(), "invalid character for player " + pPlayer:GetName() );
		
		if pChar:GetPay() > 0 then
			pPlayer:MessageBox( "JobPayDialog", "Ваша зарплата составляет $" + pChar:GetPay() + "\n\nВы действительно хотите снять деньги?", "Зарплата", MessageBoxButtons.YesNo, MessageBoxIcon.Question );
		else
			pPlayer:Hint( "Ошибка", "Вы ещё ничего не заработали!", "error" );
		end
	end
	
	return false;
end

function CClientRPC:JobPayDialog( button )
	if button == 'Да' then
		if self:IsInGame() then
			local pChar = assert( self:GetChar(), "invalid character for player " + self:GetName() );
			local iPay	= pChar:GetPay();
			
			if iPay > 0 then
				pChar:GiveMoney( iPay );
				pChar:SetPay( 0 );
			else
				self:Hint( "Ошибка", "\nВы ещё ничего не заработали!", "error" );
			end
		end
	end
end

function CClientRPC:JobDialodResponse( iJobID )
	if self:IsInGame() then
		local pJob	= assert( CJob.GetByID( iJobID ), "invalid job id '" + (string)( iJobID ) + "'" );
		local pChar	= self:GetChar();
		
		if pChar then
			local pCharJob = pChar:GetJob();
			
			if pCharJob ~= pJob then
				if pJob.CheckRequirements == NULL or pJob:CheckRequirements( self ) then
					pChar:SetJob( pJob );
					pChar:SetJobSkill( 0 );
					
					self:Hint( "Поздравляем", "Вы успешно устроились на работу '" + pJob:GetName() + "'", "ok" );
					
					if pJob.PlayerJoin then
						pJob:PlayerJoin( self );
					end
					
					if pCharJob and pCharJob.PlayerLeave then
						pCharJob:PlayerLeave( self );
					end
				end
			else
				self:Hint( "Ошибка", "Вы уже устроены на эту работу\n\n(Ваш скилл не был обнулён)", "error" );
			end
		end
	end
end