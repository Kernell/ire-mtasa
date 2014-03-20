-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local Render;

function Render()
	local vecPlayerPositon = CLIENT:GetPosition();
	
	for i, p3DText in ipairs( getElementsByType( "3DText", root, true ) ) do
		local vecPosition = p3DText:GetPosition();
		
		if vecPosition:Distance( vecPlayerPositon ) < 7 then
			local sText 	= p3DText:GetData( 'Text' );
			local iColor	= p3DText:GetData( 'Color' );
			
			if sText and iColor then
				local fX, fY = getScreenFromWorldPosition( vecPosition.X, vecPosition.Y, vecPosition.Z + .5, 0, false );
				
				if fX and fY then
					dxDrawText( sText, fX - 1, fY - 1, fX, fY, 0xFF000000, 1.0, "default-bold", "center", "center" );
					dxDrawText( sText, fX + 1, fY + 1, fX, fY, 0xFF000000, 1.0, "default-bold", "center", "center" );
					dxDrawText( sText, fX, fY, fX, fY, iColor, 1.0, "default-bold", "center", "center" );
				end
			end
		end
	end
end

addEventHandler( "onClientRender", root, Render );
