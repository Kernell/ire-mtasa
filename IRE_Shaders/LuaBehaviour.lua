-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: LuaBehaviour
{
	FixedUpdateRate = 50;
	
	LuaBehaviour	= function( this )
		if this.Start then
			this:Start();
		end
		
		if this.OnRenderImage then
			function this.__OnRenderImage()
				this:OnRenderImage();
			end
			
			addEventHandler( "onClientRender", 			root, this.__OnRenderImage );
		end
		
		if this.OnPreRender then
			function this.__OnPreRender( iTimeSlice ) 
				this:OnPreRender( iTimeSlice / 1000 );
			end
			
			addEventHandler( "onClientPreRender", 		root, this.__OnPreRender );
		end
		
		if this.OnRenderObject then
			function this.__OnRenderObject() 
				this:OnRenderObject();
			end
			
			addEventHandler( "onClientHUDRender", 		root, this.__OnRenderObject );
		end
		
		if this.Update then
			function this.__Update( iTimeSlice ) 
				this:Update( iTimeSlice / 1000 );
			end

			addEventHandler( "onClientPreRender", 		root, this.__Update );
		end
		
		if this.FixedUpdate then
			function this.__FixedUpdate() 
				this:FixedUpdate();
			end
			
			this.m_pUpdateTimer = setTimer( this.__FixedUpdate, this.FixedUpdateRate, 0 );
		end
	end;
	
	_LuaBehaviour	= function( this )
		if this.__OnRenderImage then
			removeEventHandler( "onClientRender", 		root, this.__OnRenderImage );
		end
		
		if this.__Update then
			removeEventHandler( "onClientPreRender", 	root, this.__Update );
		end
		
		if this.__OnPreRender then
			removeEventHandler( "onClientPreRender", 	root, this.__OnPreRender );
		end
		
		if this.__OnRenderObject then
			removeEventHandler( "onClientHUDRender", 	root, this.__OnRenderObject );
		end
		
		if this.m_pUpdateTimer then
			killTimer( this.m_pUpdateTimer );
		end
		
		if this.Stop then
			this:Stop();
		end
	end;
};