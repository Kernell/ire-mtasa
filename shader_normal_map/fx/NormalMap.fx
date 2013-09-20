texture ModelTexture;
texture NormalMap;

float AmbientIntensity 	= 0.1;
float DiffuseIntensity 	= 1.0;
float Shininess 		= 200;
float SpecularIntensity	= 1;
float4 SpecularColor	= float4(1, 1, 1, 1);	

#include "mta-helper.fx"

sampler2D textureSampler = sampler_state
{
    Texture 	= (ModelTexture);
    MinFilter 	= Linear;
    MagFilter 	= Linear;
    AddressU	= Clamp;
    AddressV	= Clamp;
};

sampler2D bumpSampler = sampler_state
{
	Texture 	= (NormalMap);
	MinFilter 	= Linear;
	MagFilter 	= Linear;
	AddressU 	= Wrap;
	AddressV 	= Wrap;
};

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float3 Normal : NORMAL0;
    float3 Tangent : TANGENT0;
    float3 Binormal : BINORMAL0;
    float2 TextureCoordinate : TEXCOORD0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float2 TextureCoordinate : TEXCOORD0;
    float3 Normal : TEXCOORD1;
    float3 Tangent : TEXCOORD2;
    float3 Binormal : TEXCOORD3;
};

VertexShaderOutput VertexShaderFunction( VertexShaderInput input )
{
    VertexShaderOutput output;

    float4 worldPosition 	= mul( input.Position, gWorld );
    float4 viewPosition 	= mul( worldPosition, gView );
	
    output.Position 		= mul( viewPosition, gProjection );
	
    output.Normal 			= normalize( mul( input.Normal, gWorldInverseTranspose ) );
    output.Tangent 			= normalize( mul( input.Tangent, gWorldInverseTranspose ) );
    output.Binormal			= normalize( mul( input.Binormal, gWorldInverseTranspose ) );
	
    output.TextureCoordinate = input.TextureCoordinate;
	
    return output;
}

float4 PixelShaderFunction( VertexShaderOutput input ) : COLOR0
{
    float3 bump 		= tex2D( bumpSampler, input.TextureCoordinate ) - ( 0.5, 0.5, 0.5 );
    float3 bumpNormal 	= input.Normal + ( bump.x * input.Tangent + bump.y * input.Binormal );
	
    bumpNormal = normalize( bumpNormal );
    
    float diffuseIntensity = dot( normalize( gLightDirection ), bumpNormal );
	
    if( diffuseIntensity < 0 )
        diffuseIntensity = 0;
	
    float3 light 		= normalize( gLightDirection );
    float3 r 			= normalize( 2 * dot( light, bumpNormal ) * bumpNormal - light );
    float3 v 			= normalize( mul( normalize( gCameraDirection ), gWorld));
    float4 specular 	= SpecularIntensity * SpecularColor * max( pow( dot( r, v ), Shininess ), 0 ) * diffuseIntensity;
    float4 textureColor = tex2D( textureSampler, input.TextureCoordinate );
	
    textureColor.a = 1;
	
    return saturate( textureColor * ( diffuseIntensity ) + gLightAmbient * AmbientIntensity + specular );
}

technique BumpMapped
{
    pass Pass1
    {
        VertexShader	= compile vs_2_0 VertexShaderFunction();
        PixelShader		= compile ps_2_0 PixelShaderFunction();
    }
}
