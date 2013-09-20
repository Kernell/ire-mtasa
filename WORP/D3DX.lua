-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "ID3DDevice"
{
	ID3DDevice	= function( self, sizeX, sizeY )
		if not sizeX then
			sizeX, sizeY = guiGetScreenSize();
		end
		
		self._OnRender	= function() self:OnRender() end;
		
		self.BufferWidth, self.BufferHeight = sizeX, sizeY;
	end;
	
	AddRef		= function( self ) addEventHandler( 'onClientRender', root, self._OnRender ) end;
	Release		= function( self ) removeEventHandler( 'onClientRender', root, self._OnRender ) end;
	OnRender	= function( self ) end;
};

class "IDirect3DTexture9"
{
	IDirect3DTexture9 = function( this, pTexture )
		this.t = dxCreateTexture( pTexture );
	end;
	
	Release = function( this )
		if destroyElement( this.t ) then
			this.t = nil;
			this = nil;
			
			return true;
		end
		
		return false;
	end;
};

function D3DXVECTOR3( float_fx, float_fy, float_fz )
	return { x = (float)(float_fx), y = (float)(float_fy), z =(float)(float_fz) };
end

function D3DXMATRIX()
	return 
	{ 
		m = 
		{
			[0] = { [0] = 0; [1] = 0 };
			[1] = { [0] = 0; [1] = 0 };
			[2] = { [0] = 0; [1] = 0 };
			[3] = { [0] = 0; [1] = 0 };
		};
	};
end

function D3DXMatrixIdentity( D3DXMATRIX_pOut )
	if not D3DXMATRIX_pOut then
		return;
	end
	
	D3DXMATRIX_pOut.m[0][0] = 1.0; D3DXMATRIX_pOut.m[0][1] = 0.0; D3DXMATRIX_pOut.m[0][2] = 0.0; D3DXMATRIX_pOut.m[0][3] = 0.0;
	D3DXMATRIX_pOut.m[1][0] = 0.0; D3DXMATRIX_pOut.m[1][1] = 1.0; D3DXMATRIX_pOut.m[1][2] = 0.0; D3DXMATRIX_pOut.m[1][3] = 0.0;
	D3DXMATRIX_pOut.m[2][0] = 0.0; D3DXMATRIX_pOut.m[2][1] = 0.0; D3DXMATRIX_pOut.m[2][2] = 1.0; D3DXMATRIX_pOut.m[2][3] = 0.0;
	D3DXMATRIX_pOut.m[3][0] = 0.0; D3DXMATRIX_pOut.m[3][1] = 0.0; D3DXMATRIX_pOut.m[3][2] = 0.0; D3DXMATRIX_pOut.m[3][3] = 1.0;
end

class "ID3DXTexture"
{
	ID3DXTexture = function( this )
		this.D3DXMATRIX = D3DXMATRIX();
	end;
	
	SetTransform = function( this, D3DXMATRIX_pTransform )
		this.D3DXMATRIX.m = 
		{
			[0] = { [0] = D3DXMATRIX_pTransform.m[0][0]; [1] = D3DXMATRIX_pTransform.m[0][1] };
			[1] = { [0] = D3DXMATRIX_pTransform.m[1][0]; [1] = D3DXMATRIX_pTransform.m[1][1] };
			[2] = { [0] = D3DXMATRIX_pTransform.m[2][0]; [1] = D3DXMATRIX_pTransform.m[2][1] };
			[3] = { [0] = D3DXMATRIX_pTransform.m[3][0]; [1] = D3DXMATRIX_pTransform.m[3][1] };
		};
	end;
	
	GetTransform = function( this )
		return this.D3DXMATRIX;
	end;
	
	Draw = function( this, IDirect3DTexture9_pTexture, D3DXVECTOR3_pCenter, D3DXVECTOR3_pPosition, D3DCOLOR_Color )
		return dxDrawImage(
			type( D3DXVECTOR3_pPosition ) == 'table' and D3DXVECTOR3_pPosition.x or this.D3DXMATRIX.m[3][0], 
			type( D3DXVECTOR3_pPosition ) == 'table' and D3DXVECTOR3_pPosition.y or this.D3DXMATRIX.m[3][1],
			this.D3DXMATRIX.m[0][0],
			this.D3DXMATRIX.m[1][1],
			IDirect3DTexture9_pTexture.t,
			type( D3DXVECTOR3_pCenter ) == 'table' and D3DXVECTOR3_pCenter.z or 0,
			type( D3DXVECTOR3_pCenter ) == 'table' and D3DXVECTOR3_pCenter.x or 0,
			type( D3DXVECTOR3_pCenter ) == 'table' and D3DXVECTOR3_pCenter.y or 0,
			D3DCOLOR_Color or -1,
			false
		);
	end;
};

class "ID3DXLine"
{
	
};

class "ID3DXText"
{
	
};