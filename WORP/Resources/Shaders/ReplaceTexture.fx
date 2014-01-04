texture Tex0;

technique ReplaceTexture
{
    pass P0
    {
        Texture[ 0 ] = Tex0;
    }
}