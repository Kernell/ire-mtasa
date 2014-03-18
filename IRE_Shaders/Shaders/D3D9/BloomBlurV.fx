#include "/Shaders/mta-helper.fxh"

float sBloom 		: BLOOM = 1;
texture sTex0 		: TEX0;
float2 sTex0Size 	: TEX0SIZE;

static const float Kernel[ 13 ]		= { -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6 };
static const float Weights[ 13 ]	= { 0.002216, 0.008764, 0.026995, 0.064759, 0.120985, 0.176033, 0.199471, 0.176033, 0.120985, 0.064759, 0.026995, 0.008764, 0.002216 };

sampler Sampler0	= sampler_state
{
    Texture         = (sTex0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

struct VSInput
{
    float3 Position : POSITION0;
    float4 Diffuse 	: COLOR0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse 	: COLOR0;
    float2 TexCoord	: TEXCOORD0;
};

PSInput VertexShaderFunction( VSInput VS )
{
    PSInput PS = (PSInput)0;
	
    PS.Position = MTACalcScreenPosition ( VS.Position );
	
    PS.Diffuse	= VS.Diffuse;
    PS.TexCoord = VS.TexCoord;

    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 fColor = 0;

    float2 fCoord;
	
    fCoord.x = PS.TexCoord.x;

    for( int i = 0; i < 13; ++i )
    {
        fCoord.y = PS.TexCoord.y + Kernel[ i ] / sTex0Size.y;
		
        fColor += tex2D( Sampler0, fCoord.xy ) * Weights[ i ] * sBloom;
    }

    fColor = fColor * PS.Diffuse;
    fColor.a = 1;
	
    return fColor;  
}

technique BloomBlurV_D3D9
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
        // Just draw normally
    }
}
