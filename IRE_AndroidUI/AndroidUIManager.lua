-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

g_iScreenX, g_iScreenY = guiGetScreenSize();

class: AndroidUIManager
{
	m_bEnabled	= true;
	List		= {};
		
	AndroidUIManager	= function( this )
		function this.__Draw()
			if this.m_bEnabled then
				local iCurX, iCurY = getCursorPosition();
				
				iCurX, iCurY = ( iCurX or 0 ) * g_iScreenX, ( iCurY or 0 ) * g_iScreenY;
				
				this:Draw( iCurX, iCurY );
			end
		end
		
		function this.__Click( sMouseButton, sState, iCurX, iCurY )
			if sState == "down" then
				if this.MouseOverControl then
					this.MouseDownControl = this.MouseOverControl;
					
					if sMouseButton == "left" then
						-- this.DragDropOffset	= System.Drawing.Point( iCurX - this.Location.X, iCurY - this.Location.Y );
					end
				end
			elseif sState == "up" then
				if this.MouseDownControl and this.MouseOverControl and this.MouseOverControl == this.MouseDownControl then
					-- this.MouseDownControl.Click:Call();
				end
				
				this.MouseDownControl = NULL;
			end
		end
		
		addEventHandler( "onClientRender", root, this.__Draw );
		addEventHandler( "onClientClick", root, this.__Click );
	end;
	
	_AndroidUIManager	= function( this )
		removeEventHandler( "onClientRender", root, this.__Draw );
		removeEventHandler( "onClientClick", root, this.__Click );
		
		this.__Draw 	= NULL;
		this.__Click	= NULL;
	end;
	
	Add		= function( this, pAndroidUI )
		table.insert( this.List, pAndroidUI );
	end;
	
	Remove	= function( this, pAndroidUI )
		for i = table.getn( this.List ), 1 do
			if this.List[ i ] and this.List[ i ] == pAndroidUI then
				table.remove( this.List, i );
			end
		end
	end;
	
	Draw	= function( this, iCurX, iCurY )
		for i, pUI in ipairs( this.List ) do
			if pUI.m_bVisible then
				pUI:Draw( iCurX, iCurY );
			end
		end
	end;
};

AndroidUIManager();