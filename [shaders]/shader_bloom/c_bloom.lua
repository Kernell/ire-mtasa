local fScreenX, fScreenY = guiGetScreenSize();

Settings =
{
	cutoff	= 0.08;
	power	= 1.88;
	bloom	= 2.0;
	Color	= tocolor( 204, 153, 130, 140 );
	Enabled	= getElementData( localPlayer, "Settings.Graphics.Shaders.Bloom" );
};

function SetEnabled( bEnabled )
	if bEnabled then
		StartShader();
	else
		StopShader();
	end
end

function InitShader()
	SetEnabled( getElementData( localPlayer, "Settings.Graphics.Shaders.Bloom" ) );
end

function StartShader()
	if Settings.Enabled then
		return;
	end
	
	Settings.Enabled	= true;
	
	if getVersion().sortable >= "1.1.0" then
		g_pScreen		= dxCreateScreenSource( fScreenX * 0.5, fScreenY * 0.5 );
		
		g_pBlurHShader			= dxCreateShader( "blurH.fx" );
		g_pBlurVShader			= dxCreateShader( "blurV.fx" );
		g_pBrightPassShader		= dxCreateShader( "brightPass.fx" );
		g_pAddBlendShader		= dxCreateShader( "addBlend.fx" );
	end
	
	assert( g_pScreen and g_pBlurHShader and g_pBlurVShader and g_pBrightPassShader and g_pAddBlendShader, "Could not initialize shader \"Bloom\"" );
	
	addEventHandler( "onClientHUDRender", root, RenderShader );
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
	if g_pBrightPassShader 	then destroyElement( g_pBrightPassShader ); end
	if g_pAddBlendShader 	then destroyElement( g_pAddBlendShader ); end
	
	g_pScreen		= NULL;
	
	g_pBlurHShader			= NULL;
	g_pBlurVShader			= NULL;
	g_pBrightPassShader		= NULL;
	g_pAddBlendShader		= NULL;
end

function RenderShader()
	RTPool();
	
	dxUpdateScreenSource( g_pScreen );
	
	local pCurrentScreen = g_pScreen;
	
	pCurrentScreen	= ApplyBrightPass( pCurrentScreen, Settings.cutoff, Settings.power );
	pCurrentScreen	= ApplyDownsample( pCurrentScreen );
	pCurrentScreen	= ApplyDownsample( pCurrentScreen );
	pCurrentScreen	= ApplyGBlurH( pCurrentScreen, Settings.bloom );
	pCurrentScreen	= ApplyGBlurV( pCurrentScreen, Settings.bloom );
	
	dxSetRenderTarget()
	
	if pCurrentScreen then
		dxSetShaderValue( g_pAddBlendShader, "TEX0", pCurrentScreen );
		
		dxDrawImage( 0, 0, fScreenX, fScreenY, g_pAddBlendShader, 0, 0, 0, Settings.Color );
	end
end

function ApplyDownsample( pScreen, iAmount )
	assert( pScreen );
	
	if not pScreen then
		return;
	end
	
	iAmount = iAmount or 2;
	
	local fSizeX, fSizeY = dxGetMaterialSize( pScreen );
	
	fSizeX = fSizeX / iAmount;
	fSizeY = fSizeY / iAmount;
	
	local pRenderTarget = RTPool:GetUnused( fSizeX , fSizeY );
	
	assert( pRenderTarget );
	
	if not pRenderTarget then
		return;
	end
	
	dxSetRenderTarget( pRenderTarget );
	
	dxDrawImage( 0, 0, fSizeX, fSizeY, pScreen );
	
	return pRenderTarget;
end

function ApplyGBlurH( pScreen, fBloom )
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
	dxSetShaderValue( g_pBlurHShader, "TEX0SIZE", fSizeX, fSizeY );
	dxSetShaderValue( g_pBlurHShader, "BLOOM", fBloom );
	
	dxDrawImage( 0, 0, fSizeX, fSizeY, g_pBlurHShader );
	
	return pRenderTarget;
end

function ApplyGBlurV( pScreen, fBloom )
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
	dxSetShaderValue( g_pBlurVShader, "TEX0SIZE", fSizeX, fSizeY );
	dxSetShaderValue( g_pBlurVShader, "BLOOM", fBloom );
	
	dxDrawImage( 0, 0, fSizeX, fSizeY, g_pBlurVShader );
	
	return pRenderTarget;
end

function ApplyBrightPass( pScreen, fCutoff, fPower )
	if not pScreen then
		return;
	end
	
	local fSizeX, fSizeY	= dxGetMaterialSize( pScreen );
	
	local pRenderTarget		= RTPool:GetUnused( fSizeX, fSizeY );
	
	if not pRenderTarget then
		return;
	end
	
	dxSetRenderTarget( pRenderTarget, true );
	
	dxSetShaderValue( g_pBrightPassShader, "TEX0", pScreen );
	dxSetShaderValue( g_pBrightPassShader, "CUTOFF", fCutoff );
	dxSetShaderValue( g_pBrightPassShader, "POWER", fPower );
	
	dxDrawImage( 0, 0, fSizeX, fSizeY, g_pBrightPassShader );
	
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