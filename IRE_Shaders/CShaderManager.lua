-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CShaderManager ( LuaBehaviour )
{
	m_pScreen			= NULL;
	
	m_Textures			=
	{
		"smallnoise3d";
	};
	
	CShaderManager		= function( this )
		this.m_pScreen	= dxCreateScreenSource( guiGetScreenSize() );
		
		this.m_Textures = {};
		
		for i, sTex in ipairs( CShaderManager.m_Textures ) do
			this.m_Textures[ sTex ] = dxCreateTexture( "Textures/" + sTex + ".dds" );
		end
		
		this:LuaBehaviour();
	end;
	
	_CShaderManager		= function( this )
		this:_LuaBehaviour();
		
		delete ( this.m_pScreen );
	end;
	
	OnRenderObject		= function( this )
		dxUpdateScreenSource( this.m_pScreen );
	end;
};