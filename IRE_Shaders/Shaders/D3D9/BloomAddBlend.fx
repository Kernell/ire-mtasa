texture sTexture0 : TEX0;

technique BloomAddBlend
{
    pass P0
    {
        SrcBlend		= SRCALPHA;
        DestBlend		= ONE;
		
        Texture[ 0 ]	= sTexture0;
    }
}
