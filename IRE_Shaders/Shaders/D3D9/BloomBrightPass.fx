#include "/Shaders/mta-helper.fxh"

texture sTex0 	: TEX0;
float sCutoff 	: CUTOFF = 0.2;
float sPower 	: POWER  = 1;

sampler Sampler0 	= sampler_state
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
	
    PS.Diffuse 	= VS.Diffuse;
    PS.TexCoord = VS.TexCoord;

    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 Color = 0;

	float4 texel = tex2D(Sampler0, PS.TexCoord);

    float lum = (texel.r + texel.g + texel.b)/3;

    float adj = saturate( lum - sCutoff );

    adj = adj / (1.01 - sCutoff);
    
    texel = texel * adj;
    texel = pow(texel, sPower);

    Color = texel;

	Color.a = 1;
	return Color;
}

technique BloomBrightPass_D3D9
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
