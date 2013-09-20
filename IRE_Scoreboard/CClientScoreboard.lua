-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local iScreenX, iScreenY = guiGetScreenSize();

class: CClientScoreboard
{
	m_iWidth	= 800;
	m_iHeight	= 600;
	m_iX		= ( iScreenX - 800 ) / 2;
	m_iY		= ( iScreenY - 600 ) / 2;
	
	m_bVisible	= false;
	
	m_iFontColor	= tocolor( 222, 182, 67 ); -- 0xFFDEB643
	m_iBorderColor	= tocolor( 222, 182, 67 );
	
	static
	{
		m_Fields	=
		{
			{ "ID", 		.3, false };
			{ "Name", 		.3, false };
			{ "Level", 		.3 };
			{ "Lacency", 	.3 };
		};
	};
	
	CClientScoreboard	= function( this )
		function this.__Draw()
			if this.m_bVisible then
				this:Draw();
			end
		end
		
		addEventHandler( "onClientRender", root, this.__Draw );
	end;
	
	_CClientScoreboard	= function( this )
		removeEventHandler( "onClientRender", root, this.__Draw );
		
		this.__Draw = NULL;
	end;
	
	Show	= function( this )
		this.m_bVisible = true;
	end;
	
	Hide	= function( this )
		this.m_bVisible = false;
	end;
	
	IsVisible	= function( this )
		return this.m_bVisible;
	end;
	
	Draw	= function( this )
		
	end;
};

CClientScoreboard();