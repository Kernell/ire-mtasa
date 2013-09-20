#include "mta-helper.fx"

sampler ColorSampler  : register( s0 );
sampler ColorSampler2 : register( s1 );
 
float4 GlowPS(float2 TexCoords : TEXCOORD0) : COLOR0
{
	float4 color	= tex2D( ColorSampler, TexCoords );
	float4 color2	= tex2D( ColorSampler2, TexCoords );
	
	return color2 + color;
}

technique Glow
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 GlowPS();
    }
}