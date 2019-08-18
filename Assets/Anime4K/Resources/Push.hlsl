#define strength 0.3

float4 GetLargest(float4 cc, float4 lightestColor, float4 a, float4 b, float4 c)
{
	float4 newColor = cc * (1 - strength) + ((a + b + c) / 3) * strength;
	if (newColor.a > lightestColor.a) return newColor;
	return lightestColor;
}

float4 Fragment(
    float4 position : SV_Position,
    float2 texCoord : TEXCOORD
) : SV_Target
{
    const float dx = _MainTex_TexelSize.x;
    const float dy = _MainTex_TexelSize.y;

	float4 cc = tex2D(_MainTex, texCoord); //Current Color

	float4 t  = tex2D(_MainTex, texCoord + float2(  0, -dy));
	float4 tl = tex2D(_MainTex, texCoord + float2(-dx, -dy));
	float4 tr = tex2D(_MainTex, texCoord + float2( dx, -dy));

	float4 l  = tex2D(_MainTex, texCoord + float2(-dx,   0));
	float4 r  = tex2D(_MainTex, texCoord + float2( dx,   0));

	float4 b  = tex2D(_MainTex, texCoord + float2(  0,  dy));
	float4 bl = tex2D(_MainTex, texCoord + float2(-dx,  dy));
	float4 br = tex2D(_MainTex, texCoord + float2( dx,  dy));

	float4 lightestColor = cc;

	//Kernel 0 and 4
	float maxDark = Max3(br.a, b.a, bl.a);
	float minLight = Min3(tl.a, t.a, tr.a);

	if (minLight > cc.a && minLight > maxDark)
    {
		lightestColor = GetLargest(cc, lightestColor, tl, t, tr);
	}
    else
    {
		maxDark = Max3(tl.a, t.a, tr.a);
		minLight = Min3(br.a, b.a, bl.a);
		if (minLight > cc.a && minLight > maxDark)
			lightestColor = GetLargest(cc, lightestColor, br, b, bl);
	}

	//Kernel 1 and 5
	maxDark = Max3(cc.a, l.a, b.a);
	minLight = Min3(r.a, t.a, tr.a);

	if (minLight > maxDark)
    {
		lightestColor = GetLargest(cc, lightestColor, r, t, tr);
	}
    else
    {
		maxDark = Max3(cc.a, r.a, t.a);
		minLight = Min3(bl.a, l.a, b.a);
		if (minLight > maxDark)
			lightestColor = GetLargest(cc, lightestColor, bl, l, b);
	}

	//Kernel 2 and 6
	maxDark = Max3(l.a, tl.a, bl.a);
	minLight = Min3(r.a, br.a, tr.a);

	if (minLight > cc.a && minLight > maxDark)
    {
		lightestColor = GetLargest(cc, lightestColor, r, br, tr);
	}
    else
    {
		maxDark = Max3(r.a, br.a, tr.a);
		minLight = Min3(l.a, tl.a, bl.a);
		if (minLight > cc.a && minLight > maxDark)
			lightestColor = GetLargest(cc, lightestColor, l, tl, bl);
	}

	//Kernel 3 and 7
	maxDark = Max3(cc.a, l.a, t.a);
	minLight = Min3(r.a, br.a, b.a);

	if (minLight > maxDark)
    {
		lightestColor = GetLargest(cc, lightestColor, r, br, b);
	}
    else
    {
		maxDark = Max3(cc.a, r.a, b.a);
		minLight = Min3(t.a, l.a, tl.a);
		if (minLight > maxDark)
			lightestColor = GetLargest(cc, lightestColor, t, l, tl);
	}

	return lightestColor;
}
