-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CShaderRadialBlur ( LuaBehaviour )
{
	m_bSuspendSpeedEffectOnLowFPS	= false;
	m_bSuspendRotateEffectOnLowFPS	= false;
	
	m_vecPrevOrbit			= NULL;
	m_vecPrevVelocity		= NULL;
	
	m_fPrevVelocity			= 0.0;
	m_fLengthScale			= 0.0;
	m_fAmount				= 0.0;
	
	CShaderRadialBlur		= function( this, pShaderManager )
		this.m_pShaderManager	= pShaderManager;
		
		this.m_fScreenX			= pShaderManager.m_fScreenX;
		this.m_fScreenY			= pShaderManager.m_fScreenY;
		
		this.m_pScreen			= dxCreateScreenSource( this.m_fScreenX / 2, this.m_fScreenY / 2 );
		this.m_pTexture 		= pShaderManager.Textures[ "radial_mask" ];
		this.m_pShader			= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/RadialBlur.fx" );
		
		this.m_pShader:SetValue( "sSceneTexture", this.m_pScreen )
		this.m_pShader:SetValue( "sRadialMaskTexture", this.m_pTexture )
		
		this.m_vecPrevOrbit		= Vector3();
		this.m_vecPrevVelocity	= Vector3();
		this.m_vecVelDirForCam	= Vector3();
		
		this.m_pCameraMatrix	= matrix( 
			{
				{ 0, 0, 0, 0 };
				{ 0, 0, 0, 0 };
				{ 0, 0, 0, 0 };
				{ 0, 0, 0, 1 };
			}
		);
		
		this.m_pMaskScale		= { 1.0, 1.0 };
		this.m_pMaskOffset		= { 0.0, 0.0 };
		
		this:LuaBehaviour();
	end;
	
	_CShaderRadialBlur		= function( this )
		this:_LuaBehaviour();
		
		delete ( this.m_pShader );
		
		delete ( this.m_pScreen );
		
		this.m_pShaderManager	= NULL;
	end;
	
	OnRenderObject			= function( this )
		this.m_iFPS		= this.m_pShaderManager.m_iFPS;
		
		this:UpdateBlur();
		
		dxUpdateScreenSource( this.m_pScreen );

		this.m_pShader:SetValue( "sLengthScale", this.m_fLengthScale );
		this.m_pShader:SetValue( "sMaskScale", this.m_pMaskScale );
		this.m_pShader:SetValue( "sMaskOffset", this.m_pMaskOffset );
		this.m_pShader:SetValue( "sVelZoom", this.m_vecVelDirForCam.Y );
		this.m_pShader:SetValue( "sVelDir", this.m_vecVelDirForCam.X / 2, -this.m_vecVelDirForCam.Z / 2 );
		this.m_pShader:SetValue( "sAmount", this.m_fAmount );
		
		this.m_pShader:Draw( 0, 0, this.m_fScreenX, this.m_fScreenY );
	end;
	
	UpdateBlur				= function( this )
		this.m_fAmount		= 0.0;
		
		this.m_pCamTarget	= getCameraTarget();
		
		if not this.m_pCamTarget then
			return;
		end
		
		this:UpdateSpeedBlur();
		this:UpdateCameraRotateBlur();
	end;
	
	UpdateSpeedBlur			= function( this )
		local vecVelocity	= this.m_pCamTarget:GetVelocity();
		local fSpeed		= Vector3.Zero:Distance( vecVelocity );
		local fAmount 		= UnlerpClamped( 0.025, fSpeed, 1.22 );

		if this.m_bSuspendSpeedEffectOnLowFPS then
			fAmount = fAmount * this.m_iFPS;
		end

		if fAmount < 0.001 then
			return false;
		end
		
		this:UpdateCameraMatrix();
		
		local pCameraInv		= matrix.invert( this.m_pCameraMatrix );
		
		vecVelocity:Normalize();
		
		this.m_fLengthScale		= 1.0;
		this.m_pMaskScale		= { 1.0, 1.25 };
		this.m_pMaskOffset		= { 0.0, 0.10 };
		this.m_vecVelDirForCam	= this:MatTransformNormal( pCameraInv, vecVelocity );
		this.m_fAmount			= fAmount;
	end;
	
	UpdateCameraRotateBlur	= function( this )
		local vecOrbitVelocity	= this:GetCameraOrbitVelocity();
		local fSpeed			= Vector3.Zero:Distance( vecOrbitVelocity );
		local fAmount			= UnlerpClamped( 4.20, fSpeed, 8.52 );
		
		if getElementType( this.m_pCamTarget ) == "vehicle" then
			fAmount		= UnlerpClamped( 8.20, fSpeed, 16.52 );
		end

		if this.m_bSuspendRotateEffectOnLowFPS then
			fAmount		= fAmount * this.m_iFPS;
		end

		if fAmount < 0.001 then
			return;
		end

		vecOrbitVelocity.X, vecOrbitVelocity.Y, vecOrbitVelocity.Z = -vecOrbitVelocity.Z, vecOrbitVelocity.Y, -vecOrbitVelocity.X;
		
		vecOrbitVelocity:Normalize();
		
		vecOrbitVelocity.Z		= vecOrbitVelocity.Z * 2.0;
		
		this.m_fLengthScale		= 0.8;
		this.m_pMaskScale		= { 3, 1.25 };
		this.m_pMaskOffset		= { 0, -0.15 };
		this.m_vecVelDirForCam	= vecOrbitVelocity;
		this.m_fAmount			= fAmount;
	end;
	
	GetCameraOrbitVelocity	= function( this )
		local vecCameraOrbit	= this:GetCameraOrbitRotation();
		
		local vecVelocity		= vecCameraOrbit - this.m_vecPrevOrbit;
		
		this.m_vecPrevOrbit		= vecCameraOrbit;
		
		vecVelocity.Z = vecVelocity.Z % 360.0;
		
		if vecVelocity.Z > 180.0 then
			vecVelocity.Z = vecVelocity.Z - 360.0;
		end
		
		local fDistance	= Vector3.Zero:Distance( vecVelocity );
		
		if this.m_fPrevVelocity < 0.01 then
			vecVelocity = Vector3();
		end
		
		this.m_fPrevVelocity	= fDistance;
		
		local vecAvg = ( this.m_vecPrevVelocity + vecVelocity ) * 0.5;
		
		this.m_vecPrevVelocity	= vecVelocity;
		
		return vecAvg;
	end;
	
	GetCameraOrbitRotation	= function( this )
		local vecDirection = this.m_pCamTarget:GetPosition() - Vector3( getCameraMatrix() );
		
		local fRotZ	= 6.2831853071796 - math.atan2( vecDirection.X, vecDirection.Y ) % 6.2831853071796;
		
		local fRotX	= math.atan2( vecDirection.Z, getDistanceBetweenPoints2D( 0, 0, vecDirection.X, vecDirection.Y ) );
		
		vecDirection.X = math.deg( fRotX );
		vecDirection.Y = 180.0;
		vecDirection.Z = -math.deg( fRotZ );
		
		return vecDirection;
	end;
	
	UpdateCameraMatrix			= function( this )
		local fX, fY, fZ, fLX, fLY, fLZ = getCameraMatrix();
		
		local vecForward	= Vector3( fLX - fX, fLY - fY, fLZ - fZ );
		
		vecForward:Normalize();
		
		local vecUp = Vector3.Up + vecForward:Mul( -vecForward:Dot( Vector3.Up ) );
		
		vecUp:Normalize();
		
		local vecRight = vecForward:Cross( vecUp );
		
		this.m_pCameraMatrix[ 1 ][ 1 ] = vecRight.X;
		this.m_pCameraMatrix[ 1 ][ 2 ] = vecRight.Y;
		this.m_pCameraMatrix[ 1 ][ 3 ] = vecRight.Z;
		
		this.m_pCameraMatrix[ 2 ][ 1 ] = vecForward.X;
		this.m_pCameraMatrix[ 2 ][ 2 ] = vecForward.Y;
		this.m_pCameraMatrix[ 2 ][ 3 ] = vecForward.Z;
		
		this.m_pCameraMatrix[ 3 ][ 1 ] = vecUp.X;
		this.m_pCameraMatrix[ 3 ][ 2 ] = vecUp.Y;
		this.m_pCameraMatrix[ 3 ][ 3 ] = vecUp.Z;
		
		this.m_pCameraMatrix[ 4 ][ 1 ] = fX;
		this.m_pCameraMatrix[ 4 ][ 2 ] = fY;
		this.m_pCameraMatrix[ 4 ][ 3 ] = fZ;
	end;
	
	MatTransformNormal		= function( this, pMatrix, pVector )
		local fOffsetX = pVector.X * pMatrix[ 1 ][ 1 ] + pVector.Y * pMatrix[ 2 ][ 1 ] + pVector.Z * pMatrix[ 3 ][ 1 ];
		local fOffsetY = pVector.X * pMatrix[ 1 ][ 2 ] + pVector.Y * pMatrix[ 2 ][ 2 ] + pVector.Z * pMatrix[ 3 ][ 2 ];
		local fOffsetZ = pVector.X * pMatrix[ 1 ][ 3 ] + pVector.Y * pMatrix[ 2 ][ 3 ] + pVector.Z * pMatrix[ 3 ][ 3 ];
		
		return Vector3( fOffsetX, fOffsetY, fOffsetZ );
	end;
};