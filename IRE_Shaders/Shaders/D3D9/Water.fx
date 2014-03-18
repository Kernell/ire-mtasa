// #define GENERATE_NORMALS

#include "/Shaders/mta-helper.fxh"

texture sReflectionTexture;
texture sRandomTexture;

float4 sWaterColor	= float4( 0.45, 0.54, 0.53, 0.9 );

sampler3D RandomSampler = sampler_state
{
   Texture 			= (sRandomTexture);
   MAGFILTER 		= LINEAR;
   MINFILTER 		= LINEAR;
   MIPFILTER 		= LINEAR;
   MIPMAPLODBIAS 	= 0.000000;
};

samplerCUBE ReflectionSampler = sampler_state
{
   Texture 			= (sReflectionTexture);
   MAGFILTER		= LINEAR;
   MINFILTER 		= LINEAR;
   MIPFILTER 		= LINEAR;
   MIPMAPLODBIAS 	= 0.000000;
};

struct VSInput
{
    float3 Position 	: POSITION0;
    float4 Diffuse 		: COLOR0;
    float2 TexCoord 	: TEXCOORD0;
};

struct PSInput
{
    float4 Position 	: POSITION0;
    float4 Diffuse 		: COLOR0;
    float3 WorldPos 	: TEXCOORD0;
    float4 SparkleTex 	: TEXCOORD1;
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
	
    PS.Position = MTACalcScreenPosition ( VS.Position );
	
    float4 waterColorBase = float4( 90 / 255.0, 170 / 255.0, 170 / 255.0, 240 / 255.0 );
    float4 conv           = float4( 30 / 255.0,  58 / 255.0,  58 / 255.0, 200 / 255.0 );
	
    PS.Diffuse 	= saturate( sWaterColor * conv / waterColorBase );
	
    PS.WorldPos = MTACalcWorldPosition( VS.Position );
	
    float2 uvpos1 = 0;
    float2 uvpos2 = 0;

    uvpos1.x = sin( gTime / 40 );
    uvpos1.y = fmod( gTime / 50, 1 );

    uvpos2.x = fmod( gTime / 10, 1 );
    uvpos2.y = sin( gTime / 12 );

    PS.SparkleTex.x = PS.WorldPos.x / 6 + uvpos1.x;
    PS.SparkleTex.y = PS.WorldPos.y / 6 + uvpos1.y;
    PS.SparkleTex.z = PS.WorldPos.x / 10 + uvpos2.x;
    PS.SparkleTex.w = PS.WorldPos.y / 10 + uvpos2.y;

    return PS;
}

float4 PixelShaderFunction( PSInput PS ) : COLOR0
{
    float brightnessFactor	= 0.2;
	
    float3 vNormal 			= float3( 0, 0, 1 );
	
    float3 vFlakesNormal 	= tex3D( RandomSampler, float3( PS.SparkleTex.xy, 1 ) ).rgb;
    float3 vFlakesNormal2 	= tex3D( RandomSampler, float3( PS.SparkleTex.zw, 2 ) ).rgb;

    vFlakesNormal 	= ( vFlakesNormal + vFlakesNormal2 ) / 2;
	
    vFlakesNormal 	= 2 * vFlakesNormal - 1.0;
	
    float3 vNp2 	= ( vFlakesNormal + vNormal ) ;
	
    float3 vView 	= normalize( gCameraPosition - PS.WorldPos );
	
    float3 vNormalWorld 	= float3( 0, 0, 1 );
	
    float fNdotV 			= saturate( dot( vNormalWorld, vView ) );
    float3 vReflection 		= 2 * vNormalWorld * fNdotV - vView;
	
    vReflection += vNp2;
	
    float4 envMap = texCUBE( ReflectionSampler, vReflection );
	
    envMap.rgb	= envMap.rgb * envMap.a;
	
    envMap.rgb *= brightnessFactor;
	
    float4 finalColor	= envMap + PS.Diffuse * 0.5;
	
    finalColor += envMap * PS.Diffuse;
    finalColor.a = PS.Diffuse.a;

    return finalColor;
}

technique Water
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

technique fallback
{
    pass P0
    {
		
    }
}
