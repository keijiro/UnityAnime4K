#include "UnityCG.cginc"

sampler2D _MainTex;
float4 _MainTex_TexelSize;

#define strength 0.3

float min3(float4 a, float4 b, float4 c) {
	return min(min(a[3], b[3]), c[3]);
}
float max3(float4 a, float4 b, float4 c) {
	return max(max(a[3], b[3]), c[3]);
}

float4 getLargest(float4 cc, float4 lightestColor, float4 a, float4 b, float4 c) {
	float4 newColor = cc * (1 - strength) + ((a + b + c) / 3) * strength;
	if (newColor[3] > lightestColor[3]) {
		return newColor;
	}
	return lightestColor;
}

float4 frag(v2f_img i) : SV_Target
{
    const float dx = _MainTex_TexelSize.x;
    const float dy = _MainTex_TexelSize.y;

	float4 cc = tex2D(_MainTex, i.uv); //Current Color

	float4 t = tex2D(_MainTex, i.uv + float2(0, -dy));
	float4 tl = tex2D(_MainTex, i.uv + float2(-dx, -dy));
	float4 tr = tex2D(_MainTex, i.uv + float2(dx, -dy));

	float4 l = tex2D(_MainTex, i.uv + float2(-dx, 0));
	float4 r = tex2D(_MainTex, i.uv + float2(dx, 0));

	float4 b = tex2D(_MainTex, i.uv + float2(0, dy));
	float4 bl = tex2D(_MainTex, i.uv + float2(-dx, dy));
	float4 br = tex2D(_MainTex, i.uv + float2(dx, dy));


	float4 lightestColor = cc;

	//Kernel 0 and 4
	float maxDark = max3(br, b, bl);
	float minLight = min3(tl, t, tr);

	if (minLight > cc[3] && minLight > maxDark) {
		lightestColor = getLargest(cc, lightestColor, tl, t, tr);
	} else {
		maxDark = max3(tl, t, tr);
		minLight = min3(br, b, bl);
		if (minLight > cc[3] && minLight > maxDark) {
			lightestColor = getLargest(cc, lightestColor, br, b, bl);
		}
	}

	//Kernel 1 and 5
	maxDark = max3(cc, l, b);
	minLight = min3(r, t, tr);

	if (minLight > maxDark) {
		lightestColor = getLargest(cc, lightestColor, r, t, tr);
	} else {
		maxDark = max3(cc, r, t);
		minLight = min3(bl, l, b);
		if (minLight > maxDark) {
			lightestColor = getLargest(cc, lightestColor, bl, l, b);
		}
	}

	//Kernel 2 and 6
	maxDark = max3(l, tl, bl);
	minLight = min3(r, br, tr);

	if (minLight > cc[3] && minLight > maxDark) {
		lightestColor = getLargest(cc, lightestColor, r, br, tr);
	} else {
		maxDark = max3(r, br, tr);
		minLight = min3(l, tl, bl);
		if (minLight > cc[3] && minLight > maxDark) {
			lightestColor = getLargest(cc, lightestColor, l, tl, bl);
		}
	}

	//Kernel 3 and 7
	maxDark = max3(cc, l, t);
	minLight = min3(r, br, b);

	if (minLight > maxDark) {
		lightestColor = getLargest(cc, lightestColor, r, br, b);
	} else {
		maxDark = max3(cc, r, b);
		minLight = min3(t, l, tl);
		if (minLight > maxDark) {
			lightestColor = getLargest(cc, lightestColor, t, l, tl);
		}
	}

	return lightestColor;
}
