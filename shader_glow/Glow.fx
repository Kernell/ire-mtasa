#include "mta-helper.fx"

bool bFilter		= true;
bool bBlur			= true;
bool bGlow			= true;

float3 fMorphSize	= 0;
float4 fMorphColor	= float4( 1, 1, 1, 0.1 );

sampler ColorSampler  : register( s0 );
sampler ColorSampler2 : register( s1 );

struct VSInput
{
	float3 Position : POSITION0;
	float2 TexCoord : TEXCOORD0;
	float3 Normal	: NORMAL0;
    float4 Diffuse : COLOR0;
};

struct PSInput
{
	float4 Position : POSITION0;
	float2 TexCoord : TEXCOORD0;
    float4 Diffuse : COLOR0;
};

float4 FilterPS( float2 TexCoord : TEXCOORD0 ) : COLOR0
{
	float3 luminance 	= float3( 0.299, 0.587, 0.114 );
	float4 color		= tex2D( ColorSampler, TexCoord );
	float intensity		= dot( color, luminance );
	
	if( intensity < 0.9 )
		return float4( 0, 0, 0, 1 );
	
	return float4( 1, 1, 1, 1 );
}
 
float4 BlurPS( float2 TexCoord : TEXCOORD0 ) : COLOR0
{
	float step		= 2.0;
	
	float2 deltaX	= float2( step / 640, 0 );
	float2 deltaY	= float2( 0, step / 480 );
	
	float4 color	= float4( 0, 0, 0, 1 );
	
	int i = 0;
	
	for( i = -3; i <= 3; i++ )
		color += tex2D( ColorSampler, TexCoord + i * deltaX );
	
	for( i = -3; i <= 3; i++ )
		color += tex2D( ColorSampler, TexCoord + i * deltaY );
	
	color -= tex2D( ColorSampler, TexCoord );
	
	color /= 13;
	
	return color * gMaterialDiffuse;
}
 
float4 GlowPS( float2 TexCoord : TEXCOORD0 ) : COLOR0
{
	float4 color	= tex2D( ColorSampler, TexCoord );
	float4 color2	= tex2D( ColorSampler2, TexCoord );
	
	return color2 + color;
}

float4 MainPS( float2 TexCoord : TEXCOORD0 ) : COLOR0
{
	float4 fColor = 0;
	
	if( bFilter )
		fColor += FilterPS( TexCoord );
	
	if( bBlur )
		fColor += BlurPS( TexCoord );
	
	if( bGlow )
		fColor += GlowPS( TexCoord );
	
	return fColor;
}

PSInput MainVS( VSInput VS )
{
	PSInput PS		= (PSInput)0;
	
	VS.Position		+= VS.Normal * fMorphSize;
	
	PS.Position		= MTACalcScreenPosition( VS.Position );
	
	PS.TexCoord		= VS.TexCoord/*  * ( 1.0 - fMorphSize ) */;
	
	// PS.Diffuse.rgb	= fMorphColor.rgb * fMorphColor.a;
    // PS.Diffuse.a	= 1;
	
	return PS;
}

technique Main
{
	pass P0
	{
		SrcBlend		= SrcColor;
        DestBlend		= One;
		
		PixelShader		= compile ps_2_0 MainPS();
		// VertexShader	= compile vs_2_0 MainVS();
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

// technique Filter
// {
    // pass Pass1
    // {
        // PixelShader = compile ps_2_0 FilterPS();
    // }
// }

// technique Blur
// {
    // pass Pass1
    // {
        // PixelShader		= compile ps_2_0 BlurPS();
    // }
// }

// technique Glow
// {
    // pass Pass1
    // {
        // PixelShader = compile ps_2_0 GlowPS();
    // }
// }