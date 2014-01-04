#include "mta-helper.fx"

#define MAXLIGHTS 30

bool xLightsEnabled = true;
int xLightCount = 1;
float3 xLights[ MAXLIGHTS ];

// float4x4 World; // gWorld
// float4x4 View; // gView
// float4x4 Projection; // gProjection

float4 Color; // gMaterialDiffuse
 
struct VertexShaderInput
{
    float4 Position : POSITION0;
    float3 Normal : NORMAL0;
};
 
struct VertexShaderOutput
{
	float4 Position : POSITION0;
	float3 WorldPosition : TEXCOORD1;
};
 
VertexShaderOutput VertexShaderFunction( VertexShaderInput input )
{
    VertexShaderOutput output;
 
    float4 worldPosition	= mul( input.Position, gWorld );
    float4 viewPosition		= mul( worldPosition, gView );
	
    output.Position			= mul( viewPosition, gProjection );
	
	output.WorldPosition	= worldPosition;
	
    return output;
}
 
float4 PixelShaderFunction( VertexShaderOutput input ) : COLOR0
{
    float4 color = Color;
	float3 light = float3( 0.1, 0.1, 0.1 );
 
    if( xLightsEnabled )
		for( int i = 0; i < xLightCount; i++ )
			light += ( 1 - saturate( distance( xLights[ i ], input.WorldPosition ) * 1.5 ) );
	
	color.rgb *= light;
	
    return color;
}
 
technique Technique1
{
    pass Pass1
    {
        VertexShader	= compile vs_3_0 VertexShaderFunction();
        PixelShader		= compile ps_3_0 PixelShaderFunction();
    }
}