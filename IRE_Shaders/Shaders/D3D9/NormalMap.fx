#include "/Shaders/mta-helper.fxh"

bool BumpMapping = true;

sampler SamplerTexture 	= sampler_state
{
	Texture = <gTexture0>;
};

sampler SamplerBump 	= sampler_state
{
	Texture = <gTexture1>;
};

sampler SamplerNormal 	= sampler_state
{
	Texture = <gTexture2>;
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

float4 PixelShaderFunction( TVertexShader VS ) : COLOR0
{
	float4 Tex	 			= tex2D( SamplerTexture, VS.TexCoords );
	float3 Normal 			= normalize( ( 2 * tex2D( SamplerNormal, VS.TexCoords ) ) - 1.0 );
	float4 Bump 			= BumpMapping ? tex2D( SamplerBump, VS.TexCoords ) : float4( 1.0, 1.0, 1.0, 1.0 );
	
	float fSpecLighting		= pow( Normal, gMaterialSpecPower );
	
	return float4( saturate( gLightAmbient + ( Tex.xyz * gMaterialDiffuse * 0.25 * Bump ) + ( gMaterialSpecular * fSpecLighting * Bump ) ), Tex.w );
}

technique NormalBumpMapping
{
	pass Pass1
	{
		VertexShader	= compile vs_2_0 VertexShaderFunction();
		PixelShader		= compile ps_2_0 PixelShaderFunction();
	}
}

technique Fallback
{
	pass P0
	{
		Texture[ 0 ] = gTexture0;
	}
}