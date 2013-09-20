//////////////////////////////////////////////
// Glow Shader:
// Glows are rendered as a separate pass
// to the rest of the scene.  Glowing objects
// get rendered to a texture, the texture is
// blurred, then the texture is overlaid onto 
// the main scene.
//////////////////////////////////////////////

#include "mta-helper.fx"

texture glowTexture;
// texTrans is a transform used to map a 1x1 quad
// to fill the screen.
float4x4 texTrans : WorldProjection;
// pSize is the pixel size of the texture,
// equivalent to the inverse of the texture width.
float pSize = 10;

sampler GlowSampler = sampler_state
{
    Texture   = (glowTexture);
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

//Passed to the vertex shader from the pipeline
struct GLOW_INPUT
{
	float4 pos : POSITION;
	float2 texCoord : TEXCOORD;
};

//VS output / PS input:
struct GLOW_OUTPUT
{
    float4 pos : POSITION;
    float2 texCoord0 : TEXCOORD0;
    float2 texCoord1 : TEXCOORD1;
    float2 texCoord2 : TEXCOORD2;
    float2 texCoord3 : TEXCOORD3;
};

struct TEXTURE_OUTPUT
{
    float4 pos : POSITION;
    float2 texCoord0 : TEXCOORD0;
};
//PS output:
struct pixel
{
	float4 color : COLOR;
};

//////////////////////////
//  Vertex Shaders:
//////////////////////////
// These glow vertex shaders blur the texture in 
// specific direction - up, down, left, and right.
// They are used one after the other to obtain a full blur.
// VS1.3 hardware could do this in 2 passes rather than 4,
// but I only have a lowly Geforce4...
// They work by offsetting the texture coordinates into 
// 4 texCoord streams.  The pixel shader then reads the
// texture color at each of these texcoords and averages them
// together, effectively sampling a cluster of pixels.

GLOW_OUTPUT glowVSHorizontal1(GLOW_INPUT IN)
{
	GLOW_OUTPUT OUT;
	
	OUT.pos =  mul(IN.pos, texTrans);
	OUT.texCoord0 = IN.texCoord + float2(-pSize*3, 0); 
	OUT.texCoord1 = IN.texCoord + float2(-pSize*2, 0); 
	OUT.texCoord2 = IN.texCoord + float2(-pSize*1, 0); 
	OUT.texCoord3 = IN.texCoord + float2(0, 0 ); 
	
	return OUT;
}
GLOW_OUTPUT glowVSHorizontal2(GLOW_INPUT IN)
{
	GLOW_OUTPUT OUT;
	
	OUT.pos =  mul(IN.pos, texTrans);
	OUT.texCoord0 = IN.texCoord + float2(pSize*3,0); 
	OUT.texCoord1 = IN.texCoord + float2(pSize*2, 0); 
	OUT.texCoord2 = IN.texCoord + float2(pSize*1, 0); 
	OUT.texCoord3 = IN.texCoord + float2(0, 0 ); 
	
	return OUT;
}
GLOW_OUTPUT glowVSVertical1(GLOW_INPUT IN)
{
	GLOW_OUTPUT OUT;
	
	OUT.pos =  mul(IN.pos, texTrans);
	OUT.texCoord0 = IN.texCoord + float2(0,-pSize*3); 
	OUT.texCoord1 = IN.texCoord + float2(0,-pSize*2); 
	OUT.texCoord2 = IN.texCoord + float2(0,-pSize*1); 
	OUT.texCoord3 = IN.texCoord + float2(0,0); 
	
	return OUT;
}
GLOW_OUTPUT glowVSVertical2(GLOW_INPUT IN)
{
	GLOW_OUTPUT OUT;
	
	OUT.pos =  mul(IN.pos, texTrans);
	OUT.texCoord0 = IN.texCoord + float2(0,pSize*3); 
	OUT.texCoord1 = IN.texCoord + float2(0,pSize*2);  
	OUT.texCoord2 = IN.texCoord + float2(0,pSize*1); 
	OUT.texCoord3 = IN.texCoord + float2(0,0);  
	
	return OUT;
}


// This is the plain vertex shader used to overlay the 
// final glow texture over the rest of the scene.
TEXTURE_OUTPUT outputGlowVS(GLOW_INPUT IN)
{
	TEXTURE_OUTPUT OUT;
	OUT.pos =  mul(IN.pos, texTrans);
	OUT.texCoord0 = IN.texCoord;
	
	return OUT;
}



//////////////////////////
//  Pixel Shaders:
//////////////////////////

// Add the texture values at each of the supplied texCoords
// together, weighted by some arbitary function that gives 
// a reasonable appearance.
// These weights are critical to the glow behaviour,
// and tiny changes in the values can suddenly make the glow
// invisible or overpowering.  If anyone knows how to make this 
// better, please let me know...
pixel glowPS(GLOW_OUTPUT IN)
{
	pixel OUT;
	float4 color = tex2D( GlowSampler, IN.texCoord0 ) * 0.1;
	color += tex2D( GlowSampler, IN.texCoord1 ) * 0.3;
	color += tex2D( GlowSampler, IN.texCoord2 ) * 0.4;
	color += tex2D( GlowSampler, IN.texCoord3 ) * 0.25;
	
	OUT.color = color;
	OUT.color.a = 1.0f;
	
	return OUT;
}

// This is the pixel shader used to overlay the final glow image
// onto the rest of the scene.
pixel outputGlowPS(TEXTURE_OUTPUT IN)
{
	pixel OUT;
	OUT.color =  tex2D( GlowSampler, IN.texCoord0 );	
	return OUT;
}


//////////////////////////
//  Techniques:
//////////////////////////

// Four passes blur the texture in different directions.
// The final one overlays the texture onto the rest of 
// the scene.
// Annotations are used so my application can automatically
// sort these passes into the appropriate rendering stage.

technique T0
{
	pass P0 <string renderStage="texture";>
	{
		Sampler[0] = (GlowSampler);
		vertexshader = compile vs_2_0 glowVSHorizontal1();
		pixelshader  = compile ps_2_0 glowPS();
		fvf = XYZ | Tex1;
	}
	pass P1 <string renderStage="texture";>
	{
		Sampler[0] = (GlowSampler);
		vertexshader = compile vs_2_0 glowVSVertical1();
		pixelshader  = compile ps_2_0 glowPS();
		fvf = XYZ | Tex1;
	}
	pass P2 <string renderStage="texture";>
	{
		Sampler[0] = (GlowSampler);
		vertexshader = compile vs_2_0 glowVSHorizontal2();
		pixelshader  = compile ps_2_0 glowPS();
		fvf = XYZ | Tex1;
	}
	pass P3 <string renderStage="texture";>
	{
		Sampler[0] = (GlowSampler);
		vertexshader = compile vs_2_0 glowVSVertical2();
		pixelshader  = compile ps_2_0 glowPS();
		fvf = XYZ | Tex1;
	}

	pass P4 <string renderStage="post";>
	{
		Sampler[0] = (GlowSampler);
		vertexshader = compile vs_2_0 outputGlowVS();
		pixelshader  = compile ps_2_0 outputGlowPS();
		fvf = XYZ | Tex1;
		
		AlphaBlendEnable = true;
		BlendOp = Min;
		SrcBlend = One;
		DestBlend = One;
	}	
}