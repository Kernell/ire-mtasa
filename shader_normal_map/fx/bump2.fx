/*********************************************************************NVMH3****
$Revision$

Copyright NVIDIA Corporation 2007
TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THIS SOFTWARE IS PROVIDED
*AS IS* AND NVIDIA AND ITS SUPPLIERS DISCLAIM ALL WARRANTIES, EITHER EXPRESS
OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL NVIDIA OR ITS SUPPLIERS
BE LIABLE FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES
WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR ANY OTHER PECUNIARY
LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THIS SOFTWARE, EVEN IF
NVIDIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.


To learn more about shading, shaders, and to bounce ideas off other shader
    authors and users, visit the NVIDIA Shader Library Forums at:

    http://developer.nvidia.com/forums/

******************************************************************************/

#include "mta-helper.fx"

float Script : STANDARDSGLOBAL <
    string UIWidget = "none";
    string ScriptClass = "object";
    string ScriptOrder = "standard";
    string ScriptOutput = "color";
    string Script = "Technique=Color?Main;";
> = 0.8;

//// UN-TWEAKABLES - AUTOMATICALLY-TRACKED TRANSFORMS ////////////////

float4x4 WorldITXf : WorldInverseTranspose < string UIWidget="None"; >;
float4x4 WvpXf : WorldViewProjection < string UIWidget="None"; >;
float4x4 WorldXf : World < string UIWidget="None"; >;
float4x4 ViewIXf : ViewInverse < string UIWidget="None"; >;

//// TWEAKABLE PARAMETERS ////////////////////

float2 SpriteGrid <
    string UIName =  "Sprite Grid";
    string UIWidget = "float2";
> = {8, 8};

float2 SpriteA <
    string UIName =  "Sprite A";
    string UIWidget = "float2";
> = {0, 0};

float2 SpriteB <
    string UIName =  "Sprite B";
    string UIWidget = "float2";
> = {0, 0};

float BlendFactor <
    string UIWidget = "slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.05;
    string UIName =  "Blend Factor";
> = 0;

bool EnableLight0 <
    string UIName =  "Enable Light 0";
    string UIWidget = "Bool";
> = true;

bool EnableLight1 <
    string UIName =  "Enable Light 1";
    string UIWidget = "Bool";
> = true;

bool EnableDiffuseMap <
    string UIName =  "Enable Diffuse Map";
    string UIWidget = "Bool";
> = true;

bool EnableNormalMap <
    string UIName =  "Enable Normal Map";
    string UIWidget = "Bool";
> = true;

bool EnableSpecularMap <
    string UIName =  "Enable Specular Map";
    string UIWidget = "Bool";
> = false;

float4 TintColor <
    string UIName =  "Tint Color";
    string UIWidget = "Color";
> = {1.0f,1.0f,1.0f,1.0f};

/// Point Lamp 0 ////////////
float4 Lamp0Pos : POSITION <
    string Object = "PointLight0";
    string UIName =  "Lamp 0 Position";
    string Space = "World";
> = {-0.5f,2.0f,1.25f,1.0f};

float Bump <
    string UIWidget = "slider";
    float UIMin = 0.0;
    float UIMax = 10.0;
    float UIStep = 0.01;
    string UIName =  "Bumpiness";
> = 1.0; 

float3 Lamp0Diffuse : DIFFUSE <
    string UIName =  "Lamp 0";
    string Object = "Pointlight0";
    string UIWidget = "Color";
> = {1.0f,1.0f,1.0f};

float3 Lamp0Specular : SPECULAR <
    string UIName =  "Lamp 0";
    string Object = "Pointlight0";
    string UIWidget = "Color";
> = {1.0f,1.0f,1.0f};

float4 Lamp1Pos : POSITION <
    string Object = "PointLight1";
    string UIName =  "Lamp 1 Position";
    string Space = "World";
> = {-0.5f,2.0f,1.25f,1.0f};

float3 Lamp1Diffuse : DIFFUSE <
    string UIName =  "Lamp 1";
    string Object = "Pointlight1";
    string UIWidget = "Color";
> = {1.0f,1.0f,1.0f};

float3 Lamp1Specular : SPECULAR <
    string UIName =  "Lamp 1";
    string Object = "Pointlight1";
    string UIWidget = "Color";
> = {1.0f,1.0f,1.0f};

// Ambient Light
float3 AmbiColor : AMBIENT <
    string UIName =  "Ambient Light";
    string UIWidget = "Color";
> = {0.07f,0.07f,0.07f};

float Ks <
    string UIWidget = "slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.05;
    string UIName =  "Specular Strength";
> = 0.4;

float SpecExpon : SPECULARPOWER <
    string UIWidget = "slider";
    float UIMin = 1.0;
    float UIMax = 128.0;
    float UIStep = 1.0;
    string UIName =  "Specular Power";
> = 55.0;
 

//////// COLOR & TEXTURE /////////////////////

texture ColorTexture : DIFFUSEMAP <
    string ResourceName = "default_color.dds";
    string UIName =  "Diffuse Texture";
    string ResourceType = "2D";
>;

sampler2D ColorSampler = sampler_state {
    Texture = <ColorTexture>;
    MinFilter = Linear;
    MipFilter = Linear;
    MagFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
};  

texture NormalTexture : NORMALMAP  <
    string ResourceName = "default_bump_normal.dds";
    string UIName =  "Normal-Map Texture";
    string ResourceType = "2D";
>;

sampler2D NormalSampler = sampler_state {
    Texture = <NormalTexture>;
    MinFilter = Linear;
    MipFilter = Linear;
    MagFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
}; 

texture SpecularTexture : SPECULARMAP  <
    string ResourceName = "default_gloss.dds";
    string UIName =  "Specular-Map Texture";
    string ResourceType = "2D";
>;

sampler2D SpecularSampler = sampler_state {
    Texture = <SpecularTexture>;
    MinFilter = Linear;
    MipFilter = Linear;
    MagFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
}; 


//////// CONNECTOR DATA STRUCTURES ///////////

/* data from application vertex buffer */
struct appdata {
    float3 Position	: POSITION;
    float4 UV		: TEXCOORD0;
    float4 Normal	: NORMAL0;
    float4 Tangent	: TANGENT0;
    float4 Binormal	: BINORMAL0;
};

/* data passed from vertex shader to pixel shader */
struct vertexOutput {
    float4 HPosition	: POSITION;
    float2 UV0		: TEXCOORD0;
    float2 UV1		: TEXCOORD1;
    // The following values are passed in "World" coordinates since
    //   it tends to be the most flexible and easy for handling
    //   reflections, sky lighting, and other "global" effects.
    float3 LightVec0	: TEXCOORD2;
    float3 LightVec1	: TEXCOORD3;
    float3 WorldNormal	: TEXCOORD4;
    float3 WorldTangent	: TEXCOORD5;
    float3 WorldBinormal : TEXCOORD6;
    float3 WorldView	: TEXCOORD7;
};
 
///////// VERTEX SHADING /////////////////////

/*********** Generic Vertex Shader ******/

vertexOutput std_VS(appdata IN) {
    vertexOutput OUT = (vertexOutput)0;
	
	OUT.WorldNormal = mul(IN.Normal,WorldITXf).xyz;
	if (EnableNormalMap)
	{
		OUT.WorldTangent = mul(IN.Tangent,WorldITXf).xyz;
		OUT.WorldBinormal = mul(IN.Binormal,WorldITXf).xyz;
	}
	
    float4 Po = float4(IN.Position.xyz,1);
    float3 Pw = mul(Po,WorldXf).xyz;
	
	if (EnableLight0)
	{
		if (Lamp0Pos.w == 0)
		{
			OUT.LightVec0 = -normalize(Lamp0Pos);
		}
    	else 
		{
			OUT.LightVec0 = (Lamp0Pos - Pw);
		}
	}
	
	if (EnableLight1)
	{
		if (Lamp0Pos.w == 0)
		{
			OUT.LightVec1 = normalize(Lamp1Pos);
		}
    	else 
		{
			OUT.LightVec1 = (Lamp1Pos - Pw);
		}
	}

	float2 spacing = float2(1,1) / SpriteGrid.xy;
	float2 offsetA = SpriteA.xy * spacing.xy;
	float2 offsetB = SpriteB.xy * spacing.xy;
	float2 width = IN.UV.xy * spacing.xy;
	
    OUT.UV0 = float2(offsetA.x + width.x, offsetA.y + width.y);
    OUT.UV1 = float2(offsetB.x + width.x, offsetB.y + width.y);

    OUT.WorldView = normalize(ViewIXf[3].xyz - Pw);
    OUT.HPosition = mul(Po,WvpXf);
	
    return OUT;
}

///////// PIXEL SHADING //////////////////////

// Utility function for phong shading
void phong_shading(vertexOutput IN,
		    float3 DiffuseColor,
		    float3 SpecularColor,
		    float3 Nn,
		    float3 Ln,
		    float3 Vn,
		    out float3 DiffuseContrib,
		    out float3 SpecularContrib)
{
    float3 Hn = normalize(Vn + Ln);
    float4 litV = lit(dot(Ln,Nn),dot(Hn,Nn),SpecExpon);
    DiffuseContrib = litV.y * DiffuseColor;
    SpecularContrib = litV.y * litV.z * Ks * SpecularColor;	
}

float4 std_PS(vertexOutput IN) : COLOR {
    float3 diffContrib0;
    float3 diffContrib1;
    float3 specContrib0;
    float3 specContrib1;
	
    float3 Vn = normalize(IN.WorldView);
    float3 Nn = normalize(IN.WorldNormal);
	
	float4 diffuseColor = float4(TintColor.rgb, 1);
	float3 result = AmbiColor;
	
	if (EnableDiffuseMap)
	{
		diffuseColor *= BlendFactor * tex2D(ColorSampler,IN.UV1).rgba + 
			(1 - BlendFactor) * tex2D(ColorSampler,IN.UV0).rgba;
	}
	
	if (EnableNormalMap)
	{
		float3 Tn = normalize(IN.WorldTangent);
		float3 Bn = normalize(IN.WorldBinormal);
		float3 normalColor = BlendFactor * tex2D(NormalSampler,IN.UV1).rgb +
			(1 - BlendFactor) * tex2D(NormalSampler,IN.UV0).rgb;
		float3 bump = Bump * (normalColor - float3(0.5,0.5,0.5));
		Nn = Nn + bump.x*Tn + bump.y*Bn;
		Nn = normalize(Nn);
	}
	
	if (EnableLight0)
	{
		float3 Ln0 = normalize(IN.LightVec0);
		phong_shading(IN,Lamp0Diffuse,Lamp0Specular,Nn,Ln0,Vn,diffContrib0,specContrib0);		

		if (EnableSpecularMap)
		{
			float3 specularColor = BlendFactor * tex2D(SpecularSampler,IN.UV1).rgb + 
				(1 - BlendFactor) * tex2D(SpecularSampler,IN.UV0).rgb;
			specContrib0 *= specularColor;
		}

		result += specContrib0 + diffuseColor*diffContrib0;
	}

	if (EnableLight1)
	{
		float3 Ln1 = normalize(IN.LightVec1);
		phong_shading(IN,Lamp1Diffuse,Lamp1Specular,Nn,Ln1,Vn,diffContrib1,specContrib1);

		if (EnableSpecularMap)
		{
			float3 specularColor = BlendFactor * tex2D(SpecularSampler,IN.UV1).rgb + 
				(1 - BlendFactor) * tex2D(SpecularSampler,IN.UV0).rgb;
			specContrib1 *= specularColor;
		}

		result += specContrib1 + diffuseColor*diffContrib1;
	}
	
	if (!EnableLight0 && !EnableLight1)
	{
		result += diffuseColor;
	}

    // return as float4
    return float4(result,diffuseColor.a);
}

///// TECHNIQUES /////////////////////////////

technique Main <
	string Script = "Pass=p0;";
> {
    pass p0 <
	string Script = "Draw=geometry;";
    > {
        VertexShader = compile vs_2_0 std_VS();
		ZEnable = true;
		ZWriteEnable = true;
		ZFunc = LessEqual;
        AlphaBlendEnable = true;
        SrcBlend = SrcAlpha;
        DestBlend = InvSrcAlpha;
        PixelShader = compile ps_2_a std_PS();
    }
}

/////////////////////////////////////// eof //