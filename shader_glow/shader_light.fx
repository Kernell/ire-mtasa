// shader_light.fx
//
// Author: Ren712/AngerMAN

texture discoBall;

float3 rotate=(0,0,0);
float4 light_fade =(150,110,75,55);
float projNormal=0.35;
bool isVeh=false;
bool lightVec=true;
bool isFakeBump=true;
bool isStr=false;
float3 alterPosition=(50,50,50); 
float2 rc = float2(0.0018,0.0015); // fake bump parameter
 
#define GENERATE_NORMALS 
#include "mta-helper.fx"
   
//---------------------------------------------------------------------
//-- Sampler for the main texture (needed for pixel shaders)
//---------------------------------------------------------------------

samplerCUBE envMapSampler1 = sampler_state
{
    Texture = (discoBall);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    MIPMAPLODBIAS = 0.000000;
};

sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

//---------------------------------------------------------------------
//-- Structure of data sent to the vertex shader
//--------------------------------------------------------------------- 
 
struct VSInput
{
   	float4 Position : POSITION; 
    float3 TexCoord : TEXCOORD0;
	float4 Diffuse : COLOR0;
	float4 Normal : NORMAL0;
};

//---------------------------------------------------------------------
//-- Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------

struct PSInput
{
    float4 Position : POSITION;
	float2 TexCoord : TEXCOORD0;	
    float3 SpTexCoord : TEXCOORD1;
	float DistFade : TEXCOORD2;
	float LightFade : TEXCOORD4;
	float LightDirection : TEXCOORD3; 
	float4 Diffuse : COLOR0;	
};

//-----------------------------------------------------------------------------
//-- VertexShader
//-----------------------------------------------------------------------------
PSInput VertexShaderSB(VSInput VS)
{
   PSInput PS = (PSInput)0;
	
   // Make sure normal is valid
   MTAFixUpNormal( VS.Normal.xyz);	
   // The usual stuff
   PS.Position = mul(VS.Position, gWorldViewProjection);
   float4 worldPos = mul(VS.Position, gWorld); 
	
   // Let's change the coordinates (position in tha world)
   worldPos.xyz+=alterPosition;
	 
    if (isStr==true) {
	
	//calculate light vector
	float3 WorldNormal = MTACalcWorldNormal( VS.Normal.xyz );
	float3 h = (gCameraPosition - worldPos.xyz);
	PS.LightDirection = saturate(dot(WorldNormal,h));	
	
   	// compute the eye vector 
   	float4 eyeVector = worldPos - gViewInverse[3]; 
	// Let's normalize it a bit(the lower, the less)
    eyeVector = eyeVector/length(pow(eyeVector,projNormal));
	
	float cosX,sinX;
	float cosY,sinY;
	float cosZ,sinZ;

	sincos(rotate.x * gTime,sinX,cosX);
	sincos(rotate.y * gTime,sinY,cosY);
	sincos(rotate.z * gTime,sinZ,cosZ);

	float3x3 rot = float3x3(
      	cosY * cosZ + sinX * sinY * sinZ, -cosX * sinZ,  sinX * cosY * sinZ - sinY * cosZ,
      	cosY * sinZ - sinX * sinY * cosZ,  cosX * cosZ, -sinY * sinZ - sinX * cosY * cosZ,
      	cosX * sinY,                       sinX,         cosX * cosY
	);
	
   PS.SpTexCoord.xzy = mul(rot, eyeVector);
					}
					else
					{
	PS.LightDirection = 0;
	PS.SpTexCoord.xyz = 0;
					}
   
   PS.TexCoord = VS.TexCoord;
   PS.Diffuse = MTACalcGTABuildingDiffuse( VS.Diffuse );
   
   float DistanceFromLight = MTACalcCameraDistance( gCameraPosition, worldPos);
   float DistanceFromCamera = MTACalcCameraDistance( gCameraPosition, MTACalcWorldPosition(VS.Position));
   PS.DistFade= MTAUnlerp ( light_fade[0], light_fade[1], DistanceFromCamera );
   PS.LightFade = MTAUnlerp ( light_fade[2], light_fade[3], DistanceFromLight );
	
   return PS;
}
 
//-----------------------------------------------------------------------------
//-- PixelShader
//-----------------------------------------------------------------------------
float4 PixelShaderSB(PSInput PS) : COLOR0
{
	if ((saturate(PS.DistFade)>0) && (saturate(PS.LightFade)>0) && (isStr==true)) {
	float4 outPut = texCUBE(envMapSampler1, PS.SpTexCoord);
	float4 texel = tex2D(Sampler0, PS.TexCoord);
	if (isFakeBump==true) {
	texel -= tex2D(Sampler0, PS.TexCoord.xy - rc.xy)*1.5;
	texel += tex2D(Sampler0, PS.TexCoord.xy + rc.xy)*1.5;
						  }
	float texalpha = (texel.r+texel.g+texel.b)/3;
	if (isVeh==false) {
	if (texel.a<0.9) {outPut.a*=texel.a/2;}
						}
						else
						{
	float3 base = (gMaterialAmbient.rgb/3)+0.25;
	texel.a*=saturate((base.r+base.g+base.b)/1.5);
	texalpha=0.5;
						}	
	outPut.rgb*=texalpha;
	if (lightVec==true) {outPut*=PS.LightDirection;}
	outPut*=saturate(PS.LightFade);
	outPut*=saturate(PS.DistFade);
   	return outPut;
						}
						else
						{
	return 0;					
						}
	
}

////////////////////////////////////////////////////////////
//////////////////////////////// TECHNIQUES ////////////////
////////////////////////////////////////////////////////////
technique disco_light_v1
{
    pass P0
    {
	    DepthBias = -0.0003;
	    AlphaBlendEnable = TRUE;
        VertexShader = compile vs_2_0 VertexShaderSB();
        PixelShader = compile ps_2_0 PixelShaderSB();									
    }
}
