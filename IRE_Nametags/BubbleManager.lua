-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. BubbleManager
{
	BubbleManager	= function()
		this.__Render = function()
			this.Render();
		end
		
		addEventHandler( "onClientRender", root, this.__Render );
	end;
	
	_BubbleManager	= function()
		removeEventHandler( "onClientRender", root, this.__Render );
	end;

	AddToList	= function( bubble )
		if not bubble.Ped.Bubbles then
			bubble.Ped.Bubbles = {};
		end
		
		table.insert( bubble.Ped.Bubbles, 1, bubble );
	end;

	Render	= function()
		local tick			= getTickCount();
		
		for i, ped in pairs( getElementsByType( "player", root, true ) ) do
			if ped ~= CLIENT then
				if ped.Bubbles then 				
					for ii, bubble in ipairs( ped.Bubbles ) do
						if not bubble.Draw( tick, ii ) then
							table.remove( bubble.Ped.Bubbles, ii );
						end
					end
				end
			end
		end
	end
};
