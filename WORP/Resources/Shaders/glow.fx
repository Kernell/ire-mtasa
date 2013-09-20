float blurSizeX = 1.0;
float blurSizeY = 1.0;

sampler2D Sampler : register(S0);

float4 PS_BlurHorizontal( float2 Tex : TEXCOORD0 ) : COLOR0
{
    float Color = 0.0f;

    Color += tex2D( Sampler, float2( Tex.x - 3.0 * blurSizeX, Tex.y ) ) * 0.09f;
    Color += tex2D( Sampler, float2( Tex.x - 2.0 * blurSizeX, Tex.y ) ) * 0.11f;
    Color += tex2D( Sampler, float2( Tex.x - blurSizeX, Tex.y ) ) * 0.18f;
    Color += tex2D( Sampler, Tex ) * 0.24f;
    Color += tex2D( Sampler, float2( Tex.x + blurSizeX, Tex.y ) ) * 0.18f;
    Color += tex2D( Sampler, float2( Tex.x + 2.0 * blurSizeX, Tex.y ) ) * 0.11f;
    Color += tex2D( Sampler, float2( Tex.x + 3.0 * blurSizeX, Tex.y ) ) * 0.09f;

    return Color;
}

float4 PS_BlurVertical( float2 Tex : TEXCOORD0 ) : COLOR0
{
    float Color = 0.0f;

    Color += tex2D( Sampler, float2( Tex.x, Tex.y - 3.0 * blurSizeY ) ) * 0.09f;
    Color += tex2D( Sampler, float2( Tex.x, Tex.y - 2.0 * blurSizeY ) ) * 0.11f;
    Color += tex2D( Sampler, float2( Tex.x, Tex.y - blurSizeY ) ) * 0.18f;
    Color += tex2D( Sampler, Tex ) * 0.24f;
    Color += tex2D( Sampler, float2( Tex.x, Tex.y + blurSizeY ) ) * 0.18f;
    Color += tex2D( Sampler, float2( Tex.x, Tex.y + 2.0 * blurSizeY ) ) * 0.11f;
    Color += tex2D( Sampler, float2( Tex.x, Tex.y + 3.0 * blurSizeY ) ) * 0.09f;

    return Color;
}
// weights: 0.09 + 0.11 + 0.18 + 0.24 + 0.18 + 0.11 + 0.9 = 1
// By default, weigths are symmetrical and sum up to 1,
// but they don't necessarily have to.
// You can change the weights to create more fancy results.

technique glow
{
    pass P0
    {
        PixelShader = compile ps_2_0 PS_BlurHorizontal();
        PixelShader = compile ps_2_0 PS_BlurVertical();
    }
}