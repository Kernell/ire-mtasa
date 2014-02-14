#include "mta-helper.fx"

float3 fLuminance 	= float3( 0.299, 0.587, 0.114 );

sampler ColorSampler  : register( s0 );

float4 MainPS( float2 TexCoord : TEXCOORD0 ) : COLOR0
{
	float4 fColor 		= tex2D( ColorSampler, TexCoord );
	float fIntensity	= dot( fColor, fLuminance );
	
	fColor.a = 1.0f;
	
	return ( fColor * gMaterialDiffuse ) + fIntensity;
}

technique Main
{
	pass P0
	{
		SrcBlend		= SrcColor;
        DestBlend		= One;
		
		PixelShader		= compile ps_2_0 MainPS();
	}
}

technique fallback
{
    pass P0
    {
        SrcBlend	= Zero;
        DestBlend	= One;
    }
}