texture DiffuseTexture;
texture BumpTexture;
texture NormalTexture;

float3 SpecularColor		= ( 1, 1, 1 );
float SpecularPower 		= 1.5;
bool BumpMapping 			= true;

#include "mta-helper.fx"

sampler SamplerTexture 	= sampler_state
{
	Texture = <DiffuseTexture>;
};

sampler SamplerBump 	= sampler_state
{
	Texture = <BumpTexture>;
};

sampler SamplerNormal 	= sampler_state
{
	Texture = <NormalTexture>;
};

struct TVertexShader
{
	float4 Position 	: POSITION0;
	float2 TexCoords 	: TEXCOORD0;
};

TVertexShader VertexShaderFunction( TVertexShader VS )
{
	TVertexShader output;
	
	output.Position 		= mul( mul( VS.Position, gWorld ), gViewProjection );
	output.TexCoords 		= VS.TexCoords;

	return output;
}

float4 PixelShaderFunctionWithTex( TVertexShader VS ) : COLOR0
{
	float4 Tex	 			= tex2D( SamplerTexture, VS.TexCoords );
	float3 Normal 			= normalize( ( 2 * tex2D( SamplerNormal, VS.TexCoords ) ) - 1.0 );
	float4 Bump 			= BumpMapping ? tex2D( SamplerBump, VS.TexCoords ) : float4( 1, 1, 1, 1 );
	
	float specLighting		= pow( Normal, SpecularPower );
	
	return float4( saturate( gLightAmbient + ( Tex.xyz * gMaterialDiffuse * 0.25 * Bump ) + ( SpecularColor * specLighting * Bump ) ), Tex.w );
}

technique NormalBumpMapping
{
	pass Pass1
	{
		VertexShader	= compile vs_2_0 VertexShaderFunction();
		PixelShader		= compile ps_2_0 PixelShaderFunctionWithTex();
	}
} 