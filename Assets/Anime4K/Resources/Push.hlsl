float4 Largest(float4 mc, float4 lightest, float4 a, float4 b, float4 c)
{
    float4 abc = lerp(mc, (a + b + c) / 3, 0.3);
    return abc.a > lightest.a ? abc : lightest;
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

    float4 lightest = mc;

    // Kernel 0 and 4
    if (MinA(tl, tc, tr) > MaxA(mc, br, bc, bl))
        lightest = Largest(mc, lightest, tl, tc, tr);
    else if (MinA(br, bc, bl) > MaxA(mc, tl, tc, tr))
        lightest = Largest(mc, lightest, br, bc, bl);

    // Kernel 1 and 5
    if (MinA(mr, tc, tr) > MaxA(mc, ml, bc))
        lightest = Largest(mc, lightest, mr, tc, tr);
    else if (MinA(bl, ml, bc) > MaxA(mc, mr, tc))
        lightest = Largest(mc, lightest, bl, ml, bc);

    // Kernel 2 and 6
    if (MinA(mr, br, tr) > MaxA(mc, ml, tl, bl))
        lightest = Largest(mc, lightest, mr, br, tr);
    else if (MinA(ml, tl, bl) > MaxA(mc, mr, br, tr))
        lightest = Largest(mc, lightest, ml, tl, bl);

    //Kernel 3 and 7
    if (MinA(mr, br, bc) > MaxA(mc, ml, tc))
        lightest = Largest(mc, lightest, mr, br, bc);
    else if (MinA(tc, ml, tl) > MaxA(mc, mr, bc))
        lightest = Largest(mc, lightest, tc, ml, tl);

    return lightest;
}
