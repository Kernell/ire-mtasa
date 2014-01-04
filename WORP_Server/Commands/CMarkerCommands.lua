-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CMarkerCommands";

function CMarkerCommands:Create( pClient, sCmd, sOption, ... )
	if not pClient:IsInGame() then
		return true;
	end
	
	if not ( ... ) then
		return false;
	end
	
	local Data =
	{
		size	= 1.0;
		color	= "255,128,0,128";
	};
	
	for Param, Value in CCommand:ReadParams( ... ) do
		if Param == "model" then
			
		elseif Param == "size" then
			
		elseif Param == "color" then
			local Color = Value:split( ',' );
			
			if not Color then
				return false;
			end
			
			if table.getn( Color ) ~= 4 then
				return false
			end
			
			Color[ 1 ] = (int)(Color[ 1 ]) % 255;
			Color[ 2 ] = (int)(Color[ 2 ]) % 255;
			Color[ 3 ] = (int)(Color[ 3 ]) % 255;
			Color[ 4 ] = (int)(Color[ 4 ]) % 255;
			
			Value = table.concat( Color, ',' );
		elseif Param == "onhit" then
			
		elseif Param == "onleave" then
			
		else
			return sCmd + " " + sOption + ": unknown option -- " + Param, 255, 0, 0;
		end
		
		Data[ Param ] = Value;
	end
	
	if Data[ "model" ] then
		local vecPosition	= pClient:GetPosition();
		
		if not Data[ "model" ]:ToNumber() then
			vecPosition.Z	= vecPosition.Z - 0.9;
		end
		
		Data[ "position" ] 	= vecPosition:ToString();
		Data[ "interior" ] 	= pClient:GetInterior();
		Data[ "dimension" ]	= pClient:GetDimension();
		
		local pMarker = g_pGame:GetEventMarkerManager():Create( Data );
		
		if pMarker then
			return "Маркер успешно создан (ID: " + pMarker:GetID() + ")", 0, 255, 0;
		end
		
		return TEXT_DB_ERROR, 255, 0, 0;
	end
	
	return false;
end

function CMarkerCommands:Remove( pClient, sCmd, sOption, sID )
	local iID = tonumber( sID );
	
	if iID then
		local pMarker = g_pGame:GetEventMarkerManager():Get( iID );
		
		if pMarker then
			if g_pGame:GetEventMarkerManager():Remove( pMarker ) then
				return "Маркер ID: " + iID + " успешно удалён", 0, 255, 0;
			end
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return "Маркер с таким ID не найден", 255, 0, 0;
	end
	
	return false;
end

function CMarkerCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end