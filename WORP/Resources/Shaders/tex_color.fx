#include "mta-helper.fx"

float4 Color	= float4( 2, 2, 2, 1 );

sampler Sampler0 = sampler_state
{
    Texture = ( gTexture0 );
};

struct PSInput
{
	float4 Position : POSITION0;
	float2 TexCoord : TEXCOORD0;
};

float4 PixelShaderFunction( PSInput PS ) : COLOR0
{
	float4 Tex = tex2D( Sampler0, PS.TexCoord );
	
    return float4( Tex.rgb, 1 ) * float4( Color.rgb, 1 );
}

technique tex_color
{
    pass P0
    {
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}