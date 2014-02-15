local fScreenX, fScreenY = guiGetScreenSize();

Settings =
{
	blurFactor			= 0.0022;
	blurDiv				= 5.2;
	depthFactor			= 0.002;
	Enabled				= false;
};

function SetEnabled( bEnabled )
	if bEnabled then
		StartShader();
	else
		StopShader();
	end
end

function InitShader()
	SetEnabled( getElementData( localPlayer, "Settings.Graphics.Shaders.DepthOfField" ) );
end

function StartShader()
	if Settings.Enabled then
		return;
	end
	
	Settings.Enabled	= true;
	
	if getVersion().sortable >= "1.1.0" then
		g_pScreen		= dxCreateScreenSource( fScreenX, fScreenY );
		
		g_pBlurHShader			= dxCreateShader( "blurH.fx" );
		g_pBlurVShader			= dxCreateShader( "blurV.fx" );
	end
	
	assert( g_pScreen and g_pBlurHShader and g_pBlurVShader, "Could not initialize shader \"DepthOfField\"" );
	
	addEventHandler( "onClientHUDRender", root, RenderShader, true, "high" );
end

function StopShader()
	if not Settings.Enabled then
		return;
	end
	
	Settings.Enabled	= false;
	
	removeEventHandler( "onClientHUDRender", root, RenderShader );
	
	if g_pScreen then destroyElement( g_pScreen ); end
	
	if g_pBlurHShader 		then destroyElement( g_pBlurHShader ); end
	if g_pBlurVShader 		then destroyElement( g_pBlurVShader ); end
	
	g_pScreen		= NULL;
	
	g_pBlurHShader			= NULL;
	g_pBlurVShader			= NULL;
end

function RenderShader()
	RTPool();
	
	dxUpdateScreenSource( g_pScreen );
	
	local pCurrentScreen = g_pScreen;
	
	pCurrentScreen = ApplyBlurH( pCurrentScreen, Settings.blurDiv, Settings.blurFactor, Settings.depthFactor );
	pCurrentScreen = ApplyBlurV( pCurrentScreen, Settings.blurDiv, Settings.blurFactor, Settings.depthFactor );
	
	dxSetRenderTarget()
	
	if pCurrentScreen then
		dxDrawImage( 0, 0, fScreenX, fScreenY, pCurrentScreen, 0, 0, 0, -1 );
	end
end

function ApplyBlurH( pScreen, blurDiv, blur, depthFactor )
	if not pScreen then
		return;
	end
	
	local fSizeX, fSizeY	= dxGetMaterialSize( pScreen );
	local pRenderTarget		= RTPool:GetUnused( fSizeX, fSizeY );
	
	if not pRenderTarget then
		return;
	end
	
	dxSetRenderTarget( pRenderTarget, true );
	
	dxSetShaderValue( g_pBlurHShader, "TEX0", pScreen );
	dxSetShaderValue( g_pBlurVShader, "gblurFactor", blur );
	dxSetShaderValue( g_pBlurVShader, "gDepthFactor", depthFactor );
	dxSetShaderValue( g_pBlurHShader, "blurDiv", blurDiv );
	
	dxDrawImage( 0, 0, fSizeX, fSizeY, g_pBlurHShader );
	
	return pRenderTarget;
end

function ApplyBlurV( pScreen, blurDiv, blur, depthFactor )
	if not pScreen then
		return;
	end
	
	local fSizeX, fSizeY	= dxGetMaterialSize( pScreen );
	local pRenderTarget		= RTPool:GetUnused( fSizeX, fSizeY );
	
	if not pRenderTarget then
		return;
	end
	
	dxSetRenderTarget( pRenderTarget, true );
	
	dxSetShaderValue( g_pBlurVShader, "TEX0", pScreen );
	dxSetShaderValue( g_pBlurVShader, "gblurFactor", blur);
	dxSetShaderValue( g_pBlurVShader, "gDepthFactor", depthFactor );
	dxSetShaderValue( g_pBlurVShader, "blurDiv", blurDiv );
	
	dxDrawImage( 0, 0, fSizeX, fSizeY, g_pBlurHShader );
	
	return pRenderTarget;
end

RTPool =
{
	List = {};
	
	__call	= function( this )
		for i, pData in ipairs( this.List ) do
			pData.bInUse = false;
		end
	end;
	
	GetUnused	= function( this, fSizeX, fSizeY )
		for i, pData in ipairs( this.List ) do
			if not pData.bInUse and pData.fSizeX == fSizeX and pData.fSizeY == fSizeY then
				pData.bInUse = true;
				
				return pData.pRenderTarget;
			end
		end
		
		local pRenderTarget = dxCreateRenderTarget( fSizeX, fSizeY );
		
		if pRenderTarget then
			table.insert( this.List,
				{
					bInUse			= true;
					fSizeX			= fSizeX;
					fSizeY			= fSizeY;
					pRenderTarget	= pRenderTarget;
				}
			);
		end
		
		return pRenderTarget;
	end;
};

setmetatable( RTPool, RTPool );

addEventHandler( "onClientResourceStart", resourceRoot, InitShader );