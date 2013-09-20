#include "mta-helper.fx"

Texture2D ModelTexture;
Texture2D NormalMap;

float4 diffuseColor;
// float3 lightDirection;

SamplerState SampleType
{
    Filter 		= MIN_MAG_MIP_LINEAR;
    AddressU 	= Wrap;
    AddressV 	= Wrap;
};

struct VSInput
{
    // float4 position : POSITION;
    // float2 tex : TEXCOORD0;
	// float3 normal : NORMAL;
	// float3 tangent : TANGENT;
	// float3 binormal : BINORMAL;
	
	float4 Position : POSITION0;
    float3 Tangent 	: TEXCOORD1;
    float3 Normal 	: NORMAL0;
    float3 Binormal	: TEXCOORD2;
    float4 Diffuse	: COLOR0;
    float2 TexCoord	: TEXCOORD0;
};

struct PSInput
{
    // float4 position : SV_POSITION;
    // float2 tex : TEXCOORD0;
   	// float3 normal : NORMAL;
   	// float3 tangent : TANGENT;
    // float3 binormal : BINORMAL;
	
	float4 Position : POSITION0;
    float4 Diffuse 	: COLOR0;
    float2 TexCoord : TEXCOORD0;
    float3 Tangent 	: TEXCOORD1;
    float3 Binormal : TEXCOORD2;
    float3 Normal 	: TEXCOORD3;
    // float3 NormalSurf : TEXCOORD4;
    // float3 View : TEXCOORD5;
    // float3 SparkleTex : TEXCOORD6;
};

PSInput VertexShaderFunction( VSInput VS )
{
	PSInput PS		= (PSInput)0;
    
    VS.Position.w	= 1.0f;
	
    PS.Position 	= mul( VS.Position, gWorld );
    PS.Position 	= mul( PS.Position, gView );
    PS.Position 	= mul( PS.Position, gProjection );
    
    PS.TexCoord 	= VS.TexCoord;
    	
	PS.Normal 		= normalize( mul( VS.Normal, (float3x3)gWorld ) );
	
	PS.Tangent 		= mul( VS.Tangent, (float3x3)gWorld );
	PS.Tangent 		= normalize( PS.Tangent );
	
    PS.Binormal 	= mul( VS.Binormal, (float3x3)gWorld );
	PS.Binormal 	= normalize( PS.Binormal );
	
	PS.Diffuse		= MTACalcGTAVehicleDiffuse( PS.Normal, VS.Diffuse );

	return PS;
}

float4 PixelShaderFunction( PSInput PS ) : SV_Target
{
	float4 textureColor;
    float4 bumpMap;
    float3 bumpNormal;
	float3 lightDir;
	float lightIntensity;
	float4 color;
	
	textureColor = ModelTexture.Sample( SampleType, PS.TexCoord );
	
    bumpMap = NormalMap.Sample( SampleType, PS.TexCoord );
    bumpMap = ( bumpMap * 2.0f ) - 1.0f;
	
    bumpNormal = PS.Normal + bumpMap.x * PS.Tangent + bumpMap.y * PS.Binormal;
	
    bumpNormal = normalize( bumpNormal );
	
	lightDir = -gCameraDirection;
	
	lightIntensity = saturate( dot( bumpNormal, lightDir ) );
	
	color = saturate( PS.Diffuse * lightIntensity ) * textureColor;
	
	return color;
}

technique BumpMapTechnique
{
    pass pass0
    {
		VertexShader	= compile vs_3_0 VertexShaderFunction();
        PixelShader		= compile ps_3_0 PixelShaderFunction();
		
        // SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction() ) );
        // SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction() ) );
        // SetGeometryShader( NULL );
    }
}
