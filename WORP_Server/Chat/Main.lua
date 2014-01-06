-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

function CancelEvent()
	return cancelEvent();
end

addEventHandler( "onPlayerPrivateMessage", root, CancelEvent );

local function OnPlayerChat( sMessage, iType )
	cancelEvent();
	
	if sMessage:gsub( ' ', '' ):len() == 0 then
		return false;
	end
	
	if source:IsMuted() then
		source:GetChat():Send( 'У Вас молчанка, Вы не можете говорить', 255, 128, 0 );

		return false;
	end
	
	if source:IsDead() then
		return false;
	end

	if iType == 0 then
		source:LocalizedMessage( sMessage );
		
		return true;
	elseif iType == 1 then
		source:Me( sMessage, NULL, true, true );
		
		return true;
	elseif iType == 2 then
		do
			return false;
		end
		
		local pChar 	= source:GetChar();
		
		if pChar then
			local pFaction = pChar:GetFaction();
			
			if not pFaction then
				source:Hint( 'Ошибка', 'Вы не состоите во фракции', 'error' );
			
				return false;
			end
			
			source:Me( source:Gender( 'сказал', 'сказала' ) + " что-то по рации", NULL, false, true );
			
			pFaction:SendMessage( ( "» %s %s: %s" ):format( source:IsAdmin() and '' or pFaction:GetRankName( pChar:GetFactionRank() ), source:GetVisibleName(), sMessage:gsub( '%%', '%%%%' ) ), 0, 255, 255 );
			
			return true;
		end
		
		return false;
	end
end

addEventHandler( "onPlayerChat", root, OnPlayerChat );
