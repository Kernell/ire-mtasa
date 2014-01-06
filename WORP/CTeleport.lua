-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CTeleport";

function CTeleport:DrawLabels( vecPlayerPositon )
	local vecPosition = self:GetPosition();
		
	if vecPosition:Distance( vecPlayerPositon ) < 10 then
		local iID, sFaction, iFaction = self:GetData( "CTeleport::ID" ), self:GetData( "CTeleport::FactionName" ), self:GetData( "CTeleport::FactionID" );
		
		if iID and sFaction and iFaction then
			local fX, fY = getScreenFromWorldPosition( vecPosition.X, vecPosition.Y, vecPosition.Z + .5, 0, false );
			
			if fX and fY then
				local sText = ( "ID: %d\nFaction: %s (%d)\n" ):format( iID, sFaction, iFaction );
				
				dxDrawText( sText, fX - 1, fY - 1, fX, fY, COLOR_BLACK, 1.0, "default-bold", "center", "center" );
				dxDrawText( sText, fX + 1, fY + 1, fX, fY, COLOR_BLACK, 1.0, "default-bold", "center", "center" );
				dxDrawText( sText, fX, fY, fX, fY, COLOR_YELLOW, 1.0, "default-bold", "center", "center" );
			end
		end
	end
end

addEventHandler( "onClientRender", root,
	function()
		if CLIENT:GetData( "CTeleport::DrawLabels" ) then
			local vecPlayerPositon = CLIENT:GetPosition();
		
			for i, pMarker in ipairs( getElementsByType( "marker", root, true ) ) do
				if pMarker:GetData( "CTeleport::DrawLabels" ) then
					CTeleport.DrawLabels( pMarker, vecPlayerPositon );
				end
			end
		end
	end
);
