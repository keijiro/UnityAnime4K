#define _strength 1

float4 Average(float4 cc, float4 a, float4 b, float4 c)
{
	return float4((cc * (1 - _strength) + ((a + b + c) / 3) * _strength).rgb, 1);
}

float4 Fragment(
    float4 position : SV_Position,
    float2 texCoord : TEXCOORD
) : SV_Target
{
    float4 duv = _MainTex_TexelSize.xyxy * float4(1, 1, -1, 0);

    // Center sample
	float4 cc = tex2D(_MainTex, texCoord);

	// [tl  t tr]
	// [ l     r]
	// [bl  b br]

	float4 tl = tex2D(_MainTex, texCoord - duv.xy);
	float4 t  = tex2D(_MainTex, texCoord - duv.wy);
	float4 tr = tex2D(_MainTex, texCoord - duv.zy);

	float4 l  = tex2D(_MainTex, texCoord - duv.xw);
	float4 r  = tex2D(_MainTex, texCoord + duv.xw);

	float4 bl = tex2D(_MainTex, texCoord + duv.zy);
	float4 b  = tex2D(_MainTex, texCoord + duv.wy);
	float4 br = tex2D(_MainTex, texCoord + duv.xy);

	float4 lightestColor = cc;

	// Kernel 0 and 4
	float maxDark = Max3(br.a, b.a, bl.a);
	float minLight = Min3(tl.a, t.a, tr.a);

	if (minLight > cc.a && minLight > maxDark)
    {
		return Average(cc, tl, t, tr);
	}
    else
    {
		maxDark = Max3(tl.a, t.a, tr.a);
		minLight = Min3(br.a, b.a, bl.a);
		if (minLight > cc.a && minLight > maxDark)
			return Average(cc, br, b, bl);
	}

	// Kernel 1 and 5
	maxDark = Max3(cc.a, l.a, b.a);
	minLight = Min3(r.a, t.a, tr.a);

	if (minLight > maxDark)
    {
		return Average(cc, r, t, tr);
	}
    else
    {
		maxDark = Max3(cc.a, r.a, t.a);
		minLight = Min3(bl.a, l.a, b.a);
		if (minLight > maxDark)
			return Average(cc, bl, l, b);
	}

	// Kernel 2 and 6
	maxDark = Max3(l.a, tl.a, bl.a);
	minLight = Min3(r.a, br.a, tr.a);

	if (minLight > cc.a && minLight > maxDark)
    {
		return Average(cc, r, br, tr);
	}
    else
    {
		maxDark = Max3(r.a, br.a, tr.a);
		minLight = Min3(l.a, tl.a, bl.a);
		if (minLight > cc.a && minLight > maxDark)
			return Average(cc, l, tl, bl);
	}

	// Kernel 3 and 7
	maxDark = Max3(cc.a, l.a, t.a);
	minLight = Min3(r.a, br.a, b.a);

	if (minLight > maxDark)
    {
		return Average(cc, r, br, b);
	}
    else
    {
		maxDark = Max3(cc.a, r.a, b.a);
		minLight = Min3(t.a, l.a, tl.a);
		if (minLight > maxDark)
			return Average(cc, t, l, tl);
	}

	return float4(cc.rgb, 1);
}
