float4 Average(float4 mc, float4 a, float4 b, float4 c)
{
    return float4(lerp(mc, (a + b + c) / 3, _Strength).rgb, 1);
}

float4 Fragment(
    float4 position : SV_Position,
    float2 texCoord : TEXCOORD
) : SV_Target
{
    // [tl tc tr]
    // [ml mc mr]
    // [bl bc br]

    float4 duv = _MainTex_TexelSize.xyxy * float4(1, 1, -1, 0);

    float4 tl = tex2D(_MainTex, texCoord - duv.xy);
    float4 tc = tex2D(_MainTex, texCoord - duv.wy);
    float4 tr = tex2D(_MainTex, texCoord - duv.zy);

    float4 ml = tex2D(_MainTex, texCoord - duv.xw);
    float4 mc = tex2D(_MainTex, texCoord);
    float4 mr = tex2D(_MainTex, texCoord + duv.xw);

    float4 bl = tex2D(_MainTex, texCoord + duv.zy);
    float4 bc = tex2D(_MainTex, texCoord + duv.wy);
    float4 br = tex2D(_MainTex, texCoord + duv.xy);

    // Kernel 0 and 4
    if (MinA(tl, tc, tr) > MaxA(mc, br, bc, bl)) return Average(mc, tl, tc, tr);
    if (MinA(br, bc, bl) > MaxA(mc, tl, tc, tr)) return Average(mc, br, bc, bl);

    // Kernel 1 and 5
    if (MinA(mr, tc, tr) > MaxA(mc, ml, bc    )) return Average(mc, mr, tc, tr);
    if (MinA(bl, ml, bc) > MaxA(mc, mr, tc    )) return Average(mc, bl, ml, bc);

    // Kernel 2 and 6
    if (MinA(mr, br, tr) > MaxA(mc, ml, tl, bl)) return Average(mc, mr, br, tr);
    if (MinA(ml, tl, bl) > MaxA(mc, mr, br, tr)) return Average(mc, ml, tl, bl);

    // Kernel 3 and 7
    if (MinA(mr, br, bc) > MaxA(mc, ml, tc    )) return Average(mc, mr, br, bc);
    if (MinA(tc, ml, tl) > MaxA(mc, mr, bc    )) return Average(mc, tc, ml, tl);

    return float4(mc.rgb, 1);
}
