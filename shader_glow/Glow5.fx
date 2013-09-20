#include "mta-helper.fx"

float opacity		= 1.0;
float blur			= 10.0;
float glowSize		= 2.0;
float3 glowColor	= ( 1, 1, 1 );

texture pTexture0;

sampler2D foreground = sampler_state
{
    Texture = (pTexture0);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    // MIPMAPLODBIAS = 0.000000;
};

sampler2D secondForeground = sampler_state
{
    Texture = (pTexture0);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    // MIPMAPLODBIAS = 0.000000;
};

// sampler foreground : register( s0 );
// sampler secondForeground : register( s1 );

float4 PS_Scale( float2 TexCoords : TEXCOORD0 ) : COLOR0
{
    float2 scaleCenter = float2( 0.5, 0.5 );
    float2 scaleTex = ( TexCoords - scaleCenter ) * glowSize + scaleCenter;
    return tex2D( foreground, scaleTex );
}

float4 PS_GlowH( float2 TexCoords : TEXCOORD0 ) : COLOR0
{
    float2 Tex = TexCoords;

    float4 sum = float4(0.0, 0.0, 0.0, 0.0);
	
    sum += tex2D( secondForeground, float2(Tex.x - 4.0*blur, Tex.y))*0.05;
    sum += tex2D( secondForeground, float2(Tex.x - 3.0*blur, Tex.y))*0.09;
    sum += tex2D( secondForeground, float2(Tex.x - 2.0*blur, Tex.y))*0.12;
    sum += tex2D( secondForeground, float2(Tex.x - blur, Tex.y))*0.15;
    sum += tex2D( secondForeground, float2(Tex.x, Tex.y))*0.16;
    sum += tex2D( secondForeground, float2(Tex.x + blur, Tex.y))*0.15;
    sum += tex2D( secondForeground, float2(Tex.x + 2.0*blur, Tex.y))*0.12;
    sum += tex2D( secondForeground, float2(Tex.x + 3.0*blur, Tex.y))*0.09;
    sum += tex2D( secondForeground, float2(Tex.x + 4.0*blur, Tex.y))*0.05;

    return sum;
}

float4 PS_GlowV( float2 TexCoords : TEXCOORD0 ) : COLOR0
{
    float2 Tex = TexCoords;

    float4 sum = float4(0.0, 0.0, 0.0, 0.0);
	
    sum += tex2D( secondForeground, float2(Tex.x, Tex.y - 4.0*blur))*0.05;
    sum += tex2D( secondForeground, float2(Tex.x, Tex.y - 3.0*blur))*0.09;
    sum += tex2D( secondForeground, float2(Tex.x, Tex.y - 2.0*blur))*0.12;
    sum += tex2D( secondForeground, float2(Tex.x, Tex.y - blur))*0.15;
    sum += tex2D( secondForeground, float2(Tex.x, Tex.y))*0.16;
    sum += tex2D( secondForeground, float2(Tex.x, Tex.y + blur))*0.15;
    sum += tex2D( secondForeground, float2(Tex.x, Tex.y + 2.0*blur))*0.12;
    sum += tex2D( secondForeground, float2(Tex.x, Tex.y + 3.0*blur))*0.09;
    sum += tex2D( secondForeground, float2(Tex.x, Tex.y + 4.0*blur))*0.05;

    float4 result = sum * opacity;
	
    result.rgb = float3( glowColor.r, glowColor.g, glowColor.b ) / 255.0;

    float4 src = tex2D(foreground, TexCoords.xy);
    return result * (1-src.a) + src;
}

float4 MainPS( float2 TexCoords : TEXCOORD0 ) : COLOR0
{
	return PS_Scale( TexCoords ) + PS_GlowH( TexCoords ) + PS_GlowV( TexCoords );
}

technique Main
{
	pass Pass0
	{
		PixelShader = compile ps_2_0 MainPS();
	}
}