#define RADIUS 7
#define KERNEL_SIZE ( RADIUS * 2 + 1 )

float weights[ KERNEL_SIZE ];
float2 offsets[ KERNEL_SIZE ];

texture ScreenTexture;

sampler2D ScreenSampler = sampler_state
{
    Texture		= <ScreenTexture>;
    MipFilter	= Linear;
    MinFilter	= Linear;
    MagFilter	= Linear;
};

float4 PS_GaussianBlur( float2 texCoord : TEXCOORD ) : COLOR0
{
    float4 fColor = 0;
    
    for( int i = 0; i < KERNEL_SIZE; i++ )
        fColor += tex2D( ScreenSampler, texCoord + offsets[ i ] ) * weights[ i ];
        
    return fColor;
}

technique GaussianBlur
{
    pass P0
    {
        PixelShader = compile ps_2_0 PS_GaussianBlur();
    }
}