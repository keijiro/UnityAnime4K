float4 Fragment(
    float4 position : SV_Position,
    float2 texCoord : TEXCOORD
) : SV_Target
{
    float4 c = tex2D(_MainTex, texCoord);
    return float4(c.rgb, Luminance(c.rgb));
}
