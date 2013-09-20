-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

do return end

local SpeedoRender	= ID3DDevice();

local s_mSpeedoTexture		= IDirect3DTexture9( "Resources/Images/Speedo/speedo.png" );
local s_mNeedleTexture		= IDirect3DTexture9( "Resources/Images/Speedo/needle.png" );
local s_mNeedleFuelTexture	= IDirect3DTexture9( "Resources/Images/Speedo/needle_fuel.png" );
local s_mHandbrakeTexture	= IDirect3DTexture9( "Resources/Images/Speedo/handbrake.png" );
local s_mLeftTexture		= IDirect3DTexture9( "Resources/Images/Speedo/left.png" );
local s_mRightTexture		= IDirect3DTexture9( "Resources/Images/Speedo/right.png" );
local s_mLightsTexture		= IDirect3DTexture9( "Resources/Images/Speedo/lights.png" );
local s_mEngineTexture		= IDirect3DTexture9( "Resources/Images/Speedo/engine.png" );

local s_mSpeedo			= ID3DXTexture();
local s_mNeedle			= ID3DXTexture();
local s_mNeedleFuel		= ID3DXTexture();
local s_mHandbrake		= ID3DXTexture();
local s_mLeft			= ID3DXTexture();
local s_mRight			= ID3DXTexture();
local s_mLights			= ID3DXTexture();
local s_mEngine			= ID3DXTexture();

local s_pCenter			= D3DXVECTOR3();
local s_pFuelCenter		= D3DXVECTOR3();

function SpeedoRender:SpeedoRender()
	self.m_bEnabled			= true;
	
	local SpeedoMatrix 		= D3DXMATRIX();
	
	SpeedoMatrix.m[3][0]	= ( self.BufferWidth - 150 ) * 0.869375;
	SpeedoMatrix.m[3][1]	= ( self.BufferHeight - 150 ) * 0.830;
	
	SpeedoMatrix.m[0][0]	= 300 / ( 1024 / self.BufferHeight );
	SpeedoMatrix.m[1][1]	= 300 / ( 1024 / self.BufferHeight );
	
	s_mSpeedo:SetTransform		( SpeedoMatrix );
	s_mHandbrake:SetTransform	( SpeedoMatrix );
	s_mNeedleFuel:SetTransform	( SpeedoMatrix );
	s_mNeedle:SetTransform		( SpeedoMatrix );
	s_mLeft:SetTransform		( SpeedoMatrix );
	s_mRight:SetTransform		( SpeedoMatrix );
	s_mLights:SetTransform		( SpeedoMatrix );
	s_mEngine:SetTransform		( SpeedoMatrix );
	
	self:AddRef();
end

function SpeedoRender:OnRender()
	local pVehicle		= self.m_bEnabled and not isPlayerMapVisible() and CLIENT:GetVehicle();
	
	if pVehicle then
		local hDriver		= getVehicleOccupant( pVehicle, 0 );

		s_pCenter.z 		= pVehicle:GetSpeed() * .8;
		s_pFuelCenter.z		= s_pFuelCenter.z + ( ( ( (float)(pVehicle:GetData( "fuel" )) - 43 ) * .7 ) - s_pFuelCenter.z ) * .01;
		
		s_mSpeedo:Draw		( s_mSpeedoTexture );
		
		if hDriver and getPedControlState( hDriver, "handbrake" ) then
			s_mHandbrake:Draw	( s_mHandbrakeTexture );
		end
		
		if pVehicle.m_pIndicators then
			if pVehicle.m_pIndicators.m_pLeft then
				local _, _, _, iAlpha = pVehicle.m_pIndicators.m_pLeft:GetColor();
				
				s_mLeft:Draw	( s_mLeftTexture, NULL, NULL, tocolor( 255, 255, 255, iAlpha ) );
			end
			
			if pVehicle.m_pIndicators.m_pRight then
				local _, _, _, iAlpha = pVehicle.m_pIndicators.m_pRight:GetColor();
				
				s_mRight:Draw	( s_mRightTexture, NULL, NULL, tocolor( 255, 255, 255, iAlpha ) );
			end
		end
		
		if getVehicleOverrideLights( pVehicle ) == 2 then
			s_mLights:Draw	( s_mLightsTexture );
		end
		
		if getElementHealth( pVehicle ) < 400 then
			s_mEngine:Draw	( s_mEngineTexture );
		end
		
		s_pCenter.z			= s_pCenter.z - 27;
		
		s_mNeedleFuel:Draw	( s_mNeedleFuelTexture, s_pFuelCenter );
		s_mNeedle:Draw		( s_mNeedleTexture, s_pCenter );
	end
end

addCommandHandler( "speedo",
	function()
		SpeedoRender.m_bEnabled = not SpeedoRender.m_bEnabled;
	end
);

addEventHandler( 'onClientResourceStart', resourceRoot,
	function()
		SpeedoRender:SpeedoRender();
	end
);