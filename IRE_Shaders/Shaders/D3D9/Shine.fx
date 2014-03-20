#include "/Shaders/mta-helper.fxh"

float3 sLightDir			= float3( 0.507, -0.507, -0.2 );
float sSpecularPower		= 4;
float sSpecularBrightness	= 1;
float sStrength				= 1;
float sVisibility			= 1;
float sFadeStart			= 10;
float sFadeEnd				= 80;

sampler Sampler0 = sampler_state
{
	Texture = (gTexture0);
};

struct VSInput
{
	float3 Position		: POSITION0;
	float3 Normal		: NORMAL0;
	float4 Diffuse		: COLOR0;
	float2 TexCoord		: TEXCOORD0;
};

struct PSInput
{
	float4 Position		: POSITION0;
	float4 Diffuse		: COLOR0;
	float2 TexCoord		: TEXCOORD0;
	float3 WorldNormal	: TEXCOORD1;
	float3 WorldPos		: TEXCOORD2;
	float DistFade		: TEXCOORD3;
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
	
    MTAFixUpNormal( VS.Normal );
	
    PS.Position = MTACalcScreenPosition ( VS.Position );
	
    PS.TexCoord = VS.TexCoord;
	
    PS.Diffuse = MTACalcGTABuildingDiffuse( VS.Diffuse );
	
    PS.WorldNormal = MTACalcWorldNormal( VS.Normal );
    PS.WorldPos = MTACalcWorldPosition( VS.Position );
	
    float DistanceFromCamera = MTACalcCameraDistance( gCameraPosition, MTACalcWorldPosition( VS.Position ) );
	
    PS.DistFade = MTAUnlerp ( sFadeEnd, sFadeStart, DistanceFromCamera );

    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 texel		= tex2D( Sampler0, PS.TexCoord );
    float greyScale		= dot( texel.rgb, float3( 0.3f, 0.59f, 0.11f ) );
    float redExtra		= abs( texel.r - greyScale );
    float greenExtra	= abs( texel.g - greyScale );
    float blueExtra		= abs( texel.b - greyScale );
    float colorness		= redExtra * 0.3f + greenExtra * 0.59f + blueExtra * 0.11f;
	
    colorness	= colorness * 20 * greyScale;
    colorness	= colorness - 0.1;
	
    float greyness = 1 - saturate( colorness );
	
    float3 lightDir = normalize( sLightDir );
	
    float3 h 	= normalize( normalize( gCameraPosition - PS.WorldPos ) - lightDir );
	
    float specLighting = pow( saturate( dot( h, PS.WorldNormal ) ), sSpecularPower );
	
    float lightAwayDot = -dot( lightDir, PS.WorldNormal );
	
    if( lightAwayDot < 0 )
        specLighting = 0;
		
    specLighting *= texel.g;
	
    float4 finalColor = texel * PS.Diffuse;
	
    finalColor.rgb += texel.rgb * specLighting * ( greyness ) * sSpecularBrightness * saturate( PS.DistFade ) * sStrength * sVisibility;
	
    return finalColor;
}

technique Shine
{
    pass P0
    {
        VertexShader	= compile vs_2_0 VertexShaderFunction();
        PixelShader		= compile ps_2_0 PixelShaderFunction();
    }
}

technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
