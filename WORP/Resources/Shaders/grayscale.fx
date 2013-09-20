texture TargetTexture;

float fScale		= 1.0;
float fBrightness	= 0.5;

sampler TextureSampler = sampler_state
{
    Texture = <TargetTexture>;
};
 
float4 PSMain( float2 TexCoords : TEXCOORD0 ) : COLOR0
{
	float4 fColor = tex2D( TextureSampler, TexCoords );
	
    float4 fNewColor = fColor;
	
	fNewColor.r = ( fColor.r * 1.0 ) + ( fColor.g * fScale ) + ( fColor.b * fScale );
    fNewColor.g = ( fColor.r * fScale ) + ( fColor.g * 1.0 ) + ( fColor.b * fScale );
    fNewColor.b = ( fColor.r * fScale ) + ( fColor.g * fScale ) + ( fColor.b * 1.0 );
	
	fNewColor.r *= fBrightness;
	fNewColor.g *= fBrightness;
	fNewColor.b *= fBrightness;
	
    return fNewColor;
}
 
technique GrayScale
{
    pass P0
    {
        PixelShader = compile ps_2_0 PSMain();
    }
}