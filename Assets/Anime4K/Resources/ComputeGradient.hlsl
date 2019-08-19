float4 Fragment(
    float4 position : SV_Position,
    float2 texCoord : TEXCOORD
) : SV_Target
{
    float4 c0 = tex2D(_MainTex, texCoord);

    // [tl tc tr]
    // [ml    mr]
    // [bl bc br]

    float4 duv = _MainTex_TexelSize.xyxy * float4(1, 1, -1, 0);

    float tl = tex2D(_MainTex, texCoord - duv.xy).a;
    float tc = tex2D(_MainTex, texCoord - duv.wy).a;
    float tr = tex2D(_MainTex, texCoord - duv.zy).a;

    float ml = tex2D(_MainTex, texCoord - duv.xw).a;
    float mr = tex2D(_MainTex, texCoord + duv.xw).a;

    float bl = tex2D(_MainTex, texCoord + duv.zy).a;
    float bc = tex2D(_MainTex, texCoord + duv.wy).a;
    float br = tex2D(_MainTex, texCoord + duv.xy).a;

    // Horizontal gradient
    // [-1  0  1]
    // [-2  0  2]
    // [-1  0  1]

    // Vertical gradient
    // [-1 -2 -1]
    // [ 0  0  0]
    // [ 1  2  1]

    float2 grad = float2(tr + mr * 2 + br - (tl + ml * 2 + bl),
                         bl + bc * 2 + br - (tl + tc * 2 + tr));

    // Computes the luminance's gradient and saves it in the unused alpha channel
    return float4(c0.rgb, 1 - saturate(length(grad)));
}

