#define RADIUS 7
#define KERNEL_SIZE ( RADIUS * 2 + 1 )

bool offsets = false;

float weights[ KERNEL_SIZE ];
float offsetsH[ KERNEL_SIZE ];
float offsetsV[ KERNEL_SIZE ];

texture ScreenTexture;

sampler2D ScreenSampler = sampler_state
{
    Texture		= <ScreenTexture>;
};

float4 PS_GaussianBlur( float2 texCoord : TEXCOORD ) : COLOR0
{
    float4 fColor = 0;
	
    for( int i = 0; i < KERNEL_SIZE; i++ )
	{
		float2 fOffset = ( offsets ? float2( offsetsH[ i ], 0 ) : float2( 0, offsetsV[ i ] ) );
        
		fColor += tex2D( ScreenSampler, texCoord.xy + fOffset ) * weights[ i ];
    }
	
	fColor *= 1.1;
	fColor.a = 1.0;
	
    return fColor;
}

technique GaussianBlur
{
    pass P0
    {
        //SrcBlend        = SRCALPHA;
        //DestBlend       = ONE;
        //SrcBlend            = SrcAlpha;
        //DestBlend           = SrcColor;
        PixelShader 	= compile ps_2_0 PS_GaussianBlur();
    }
}