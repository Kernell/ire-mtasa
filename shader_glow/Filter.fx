#include "mta-helper.fx"

sampler ColorSampler : register( s0 );
 
float4 FilterPS( float2 TexCoords : TEXCOORD0 ) : COLOR0
{
	float3 luminance 	= float3( 0.299, 0.587, 0.114 );
	float4 color		= tex2D( ColorSampler, TexCoords );
	float intensity		= dot( color, luminance );
	
	if( intensity < 0.9 )
		return float4( 0, 0, 0, 1 ); // gMaterialDiffuse
	
	return float4( 1, 1, 1, 1 );
}
 
technique Filter
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 FilterPS();
    }
}