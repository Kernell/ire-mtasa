-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CBankCommands"

function CBankCommands:Create( pPlayer, sCmd, sOption, siModel )
	local iModel		= tonumber( siModel );
	
	local vecPosition	= pPlayer:GetPosition();
	local vecRotation	= Vector3( 0, 0, pPlayer:GetRotation() );
	local iDimension	= pPlayer:GetDimension();
	local iInterior		= pPlayer:GetInterior();
	
	local iInsertID		= g_pDB:Insert( DBPREFIX + "banks",
		{
			model		= iModel or NULL; 
			position	= (string)(vecPosition);
			rotation	= (string)(vecRotation);
			interior	= iInterior;
			dimension	= iDimension;
		}
	);
	
	if iInsertID then
		local pBank = CBank( iInsertID, vecPosition, vecRotation, iInterior, iDimension, iModel );
		
		return "Банк добавлен, ID: " + pBank:GetID(), 0, 255, 128;
	else
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR, 255, 0, 0;
	end
	
	return true;	
end

function CBankCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end