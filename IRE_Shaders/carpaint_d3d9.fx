#include "mta-helper.fxh"

float brightnessFactor		= 0.20;
float dirtTex 				= 1;
float bumpSize 				= 0.02;
float sNormZ 				= 3;
float sRefFl 				= 1;
float sRefFlan 				= 0.2;
float sAdd					= 0.1;  
float sMul					= 1.1; 
float sCutoff				= 0.16;
float sPower	 			= 2;
float sNorFac				= 1;
float sProjectedXsize		= 0.45;
float sProjectedXvecMul		= 0.6;
float sProjectedXoffset		= -0.021;
float sProjectedYsize		= 0.4;
float sProjectedYvecMul		= 0.6;
float sProjectedYoffset		= 0.22;

bool bColorTextureLoaded	= false;

texture sColorTexture;
texture sReflectionTexture;
texture sRandomTexture;

sampler Sampler0	= sampler_state
{
    Texture         = ( gTexture0 );
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

sampler ColorSampler	= sampler_state
{
    Texture         = ( sColorTexture );
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

sampler3D RandomSampler	= sampler_state
{
   Texture 			= ( sRandomTexture ); 
   MAGFILTER 		= LINEAR;
   MINFILTER 		= LINEAR;
   MIPFILTER 		= POINT;
   MIPMAPLODBIAS	= 0.000000;
};

sampler2D ReflectionSampler = sampler_state
{
   Texture 			= ( sReflectionTexture );	
   AddressU 		= Mirror;
   AddressV 		= Mirror;
   MinFilter 		= Linear;
   MagFilter 		= Linear;
   MipFilter 		= Linear;
};

struct VSInput
{
    float4 Position 		: POSITION; 
    float3 Normal 			: NORMAL0;
    float4 Diffuse 			: COLOR0;
    float2 TexCoord 		: TEXCOORD0;
	float3 View 			: TEXCOORD1;
};

struct PSInput
{
    float4 Position 		: POSITION;
    float4 Diffuse 			: COLOR0;
	float4 Specular 		: COLOR1;   
    float2 TexCoord 		: TEXCOORD0;
    float3 Tangent 			: TEXCOORD1;
    float3 Binormal 		: TEXCOORD2;
    float3 Normal 			: TEXCOORD3;
    float3 View 			: TEXCOORD4;
    float3 SparkleTex 		: TEXCOORD5;
	float2 TexCoord_dust 	: TEXCOORD6;

};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
	
	float4 worldPosition 	= mul( VS.Position, gWorld );
	float4 viewPosition  	= mul( worldPosition, gView );
	float4 position 		= mul( viewPosition, gProjection );
	
	PS.Position  = position;
	
	float3 viewDirection 	= normalize( gCameraPosition - worldPosition );
	
    float3 Tangent = VS.Normal.yxz;
	
    Tangent.xz = VS.TexCoord.xy;
	
    float3 Binormal = normalize( cross( Tangent, VS.Normal ) );
	
    Tangent = normalize( cross( Binormal, VS.Normal ) );
	
    PS.Normal 		= normalize( mul( VS.Normal, (float3x3)gWorldInverseTranspose ).xyz );
	PS.Tangent 		= normalize( mul( Tangent, (float3x3)gWorldInverseTranspose ).xyz);
	PS.Binormal 	= normalize( mul( Binormal, (float3x3)gWorldInverseTranspose ).xyz );
	
    PS.View = normalize(viewDirection); 
	
	PS.TexCoord_dust = VS.TexCoord;
	
    PS.SparkleTex.x 	= fmod( VS.Position.x, 10 ) * 4.0;
    PS.SparkleTex.y 	= fmod( VS.Position.y, 10 ) * 4.0;
    PS.SparkleTex.z 	= fmod( VS.Position.z, 10 ) * 4.0;

	float4 eyeVector	= mul( -VS.Position, gWorldViewProjection );
	
	float projectedX 	=( ( ( eyeVector.x ) / eyeVector.z * sProjectedXvecMul ) * sProjectedXsize + 0.5 ) + sProjectedXoffset;
	float projectedY 	=( ( ( eyeVector.y ) / eyeVector.z * sProjectedYvecMul ) * sProjectedYsize + 0.5 ) + sProjectedYoffset;
	
	if( ( gCameraDirection.z > sRefFlan ) && sRefFl == 1 )
	{
		eyeVector	= mul( VS.Position, gWorldViewProjection );
		projectedY	= ( ( ( -eyeVector.y ) /eyeVector.z * sProjectedYvecMul) * sProjectedYsize + 0.5 ) - sProjectedYoffset;
	}
	
	float3 Nn 	= VS.Normal / ( length( VS.Normal ) * sNorFac );
    float3 Vn 	= float3( projectedX, projectedY, 0 );
	
    float2 vReflection	= reflect( Vn.xy, Nn.xy );
	
    PS.TexCoord 	= vReflection.xy;
	
    PS.Diffuse 		= MTACalcGTAVehicleDiffuse( PS.Normal, VS.Diffuse );
    PS.Specular.a 	= pow( VS.Normal.z, sNormZ );
	
    return PS;
}

float4 PixelShaderFunction( PSInput PS ) : COLOR0
{
    float microflakePerturbation 	= 1.00;
    float normalPerturbation 		= 1.00;
    float microflakePerturbationA 	= 0.10;
	
    float4 base 	= gMaterialAmbient;
	
    float4 paintColorMid;
    float4 paintColor2;
    float4 paintColor0;
    float4 flakeLayerColor;

    paintColorMid 	= base;
    paintColor2.r 	= base.g / 2 + base.b / 2;
    paintColor2.g 	= ( base.r / 2 + base.b / 2 );
    paintColor2.b 	= base.r / 2 + base.g / 2;

    paintColor0.r 	= base.r / 2 + base.g / 2;
    paintColor0.g 	= ( base.g / 2 + base.b / 2 );
    paintColor0.b 	= base.b / 2 + base.r / 2;

    flakeLayerColor.r 	= base.r / 2 + base.b / 2;
    flakeLayerColor.g 	= ( base.g / 2 + base.r / 2 );
    flakeLayerColor.b 	= base.b / 2 + base.g / 2;
	
    float3 vNormal 	= PS.Normal;
	
    float3 vFlakesNormal 	= tex3D( RandomSampler, PS.SparkleTex ).rgb;
	
    vFlakesNormal = 2 * vFlakesNormal - 1.0;
	
    float3 vNp1 	= microflakePerturbationA * vFlakesNormal + normalPerturbation * vNormal;
    float3 vNp2 	= microflakePerturbation * ( vFlakesNormal + vNormal ) ;
	
	float3 vView 				= PS.View;
	float3x3 mTangentToWorld 	= transpose( float3x3( PS.Tangent,PS.Binormal, PS.Normal ) );
	float3 vNormalWorld 		= normalize( mul( mTangentToWorld, vNormal ) );
	float fNdotV 				= saturate( dot( vNormalWorld, vView ) );

	float2 vReflection 			= PS.TexCoord;
	
	vReflection.xy += vNp2.xy * bumpSize;	

	float4 envMap 	= tex2D( ReflectionSampler, vReflection );
	
	float lum 	= ( envMap.r + envMap.g + envMap.b ) / 3;
	float adj 	= saturate( lum - sCutoff );
	
	adj 	= adj / ( 1.01 - sCutoff );
	
	envMap	+=sAdd;
	envMap 	= ( envMap * adj );
	envMap 	= pow( envMap, sPower );
	envMap	*= sMul;
	
    if( gCameraDirection.z < -0.5 )
		envMap.rgb	*= ( 2 * ( 1 + gCameraDirection.z ) );
		
    envMap.rgb 	*= brightnessFactor;
    envMap.rgb 	*= PS.Specular.a;
	
    float3 vNp1World 	= normalize( mul( mTangentToWorld, vNp1 ) );
    float fFresnel1 	= saturate( dot( vNp1World, vView ) );
	
    float3 vNp2World 	= normalize( mul( mTangentToWorld, vNp2 ) );
    float fFresnel2 	= saturate( dot( vNp2World, vView ) );
    float fFresnel3 	= saturate( dot( vNormal, vView ) );
	
	float fFresnel1Sq 	= fFresnel1 * fFresnel1;
	
	float4 paintColor 	= fFresnel1 * paintColor0 + fFresnel1Sq * paintColorMid + fFresnel1Sq * fFresnel1Sq * paintColor2 + pow( fFresnel2, 32 ) * flakeLayerColor;
	
	float fEnvContribution 	= 1.0 - 0.5 * fNdotV;
	
	float4 finalColor	= paintColor;
	
    finalColor	+= ( ( envMap ) * ( fEnvContribution ) );
	
    finalColor.a = 1.0;
    
	float4 Color	= finalColor / 1 + PS.Diffuse * 0.5;
	
    Color 	+= finalColor * PS.Diffuse * 1.5;
	
	if( bColorTextureLoaded )
		Color 	*= tex2D( ColorSampler, PS.TexCoord_dust.xy );
	else
		Color 	*= tex2D( Sampler0, PS.TexCoord_dust.xy );
	
    Color.a	= PS.Diffuse.a;
    
	return Color;
}

technique carpaint_d3d9
{
    pass P0
    {
		AlphaBlendEnable	= TRUE;
		SrcBlend			= SRCALPHA;
		DestBlend			= INVSRCALPHA;
		
        VertexShader 		= compile vs_2_0 VertexShaderFunction();
        PixelShader  		= compile ps_2_0 PixelShaderFunction();
    }
}

technique fallback
{
    pass P0
    {
		Texture[ 0 ] = sColorTexture;
    }
}
