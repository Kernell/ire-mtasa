float AmbientIntensity 	= 0.1;
float DiffuseIntensity 	= 1.0;
float Shininess 		= 200;
float SpecularIntensity = 1;
float4 SpecularColor 	= float4(1, 1, 1, 1);	

#include "mta-helper.fx"

struct VertexShaderInput
{
    float4 Position : POSITION0;    
    float4 Normal : NORMAL0;   
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float4 Color : COLOR0; 
	float3 Normal : TEXCOORD0;
};

VertexShaderOutput VertexShaderFunction( VertexShaderInput input )
{
    VertexShaderOutput output;

    float4 worldPosition 	= mul( input.Position, gWorld );
    float4 viewPosition 	= mul( worldPosition, gView );
    output.Position 		= mul( viewPosition, gProjection );
    
    float4 normal 			= normalize( mul( input.Normal, gWorldInverseTranspose ) );
    float lightIntensity 	= dot( normal, gLightDiffuse );
    output.Color 			= saturate( gLightDiffuse * DiffuseIntensity * lightIntensity );
		
    output.Normal = normal;
	
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
    float3 light 	= normalize( gLightDiffuse );
    float3 normal 	= normalize( input.Normal );
	
    float3 r = normalize( 2 * dot(light, normal ) * normal - light );
    float3 v = normalize( mul( normalize( gCameraDirection ), gWorld ) );

    float dotProduct 	= dot( r, v );
    float4 specular 	= SpecularIntensity * SpecularColor * max( pow( dotProduct, Shininess ), 0 ) * length( input.Color );
	
    return saturate( input.Color + gLightAmbient * AmbientIntensity + specular );
}

technique Specular
{
    pass Pass1
    {
        VertexShader 	= compile vs_2_0 VertexShaderFunction();
        PixelShader 	= compile ps_2_0 PixelShaderFunction();
    }
}
