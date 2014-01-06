-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CBubbleManager";

function CBubbleManager:CBubbleManager()
	self._RenderAll = function()
		self:RenderAll();
	end
	
	addEventHandler( 'onClientRender', root, self._RenderAll );
end

function CBubbleManager:_CBubbleManager()
	removeEventHandler( 'onClientRender', root, self._RenderAll );
end

function CBubbleManager:AddToList( pBubble )
	if not pBubble.m_pPed.Bubbles then
		pBubble.m_pPed.Bubbles = {};
	end
	
	table.insert( pBubble.m_pPed.Bubbles, 1, pBubble );
end

function CBubbleManager:RenderAll()
	local iTick			= getTickCount();
	
	for i, pPed in pairs( getElementsByType( "player" ) ) do
		if pPed ~= CLIENT then
			if pPed.Bubbles then 				
				for ii, pBubble in ipairs( pPed.Bubbles ) do
					if not pBubble:Draw( iTick, ii ) then
						table.remove( pBubble.m_pPed.Bubbles, ii );
					end
				end
			end
		end
	end
end