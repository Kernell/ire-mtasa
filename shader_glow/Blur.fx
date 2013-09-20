#include "mta-helper.fx"

sampler  ColorSampler  : register( s0 );

float4 BlurPS( float2 TexCoords : TEXCOORD0 ) : COLOR0
{
	float step		= 2.0;
	float2 deltaX	= float2( step / 640, 0 );
	float2 deltaY	= float2( 0, step / 480 );

	float4 color = float4( 0, 0, 0, 1 );
	
	for( int i = -3; i <= 3; i++ )
		color += tex2D( ColorSampler, TexCoords + i * deltaX );
			
	for( int i = -3; i <= 3; i++ )
		color += tex2D( ColorSampler, TexCoords + i * deltaY );
			
	color -= tex2D( ColorSampler, TexCoords );

	color /= 13;

	return color * ( gMaterialDiffuse * 10 );
}
 

technique Blur
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 BlurPS();
    }
}
