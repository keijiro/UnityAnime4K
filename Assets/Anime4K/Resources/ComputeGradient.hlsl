float4 Fragment(
    float4 position : SV_Position,
    float2 texCoord : TEXCOORD
) : SV_Target
{
    float4 duv = _MainTex_TexelSize.xyxy * float4(1, 1, -1, 0);

    // Center sample
	float4 c0 = tex2D(_MainTex, texCoord);

	// [tl  t tr]
	// [ l     r]
	// [bl  b br]

	float tl = tex2D(_MainTex, texCoord - duv.xy).a;
	float t  = tex2D(_MainTex, texCoord - duv.wy).a;
	float tr = tex2D(_MainTex, texCoord - duv.zy).a;

	float l  = tex2D(_MainTex, texCoord - duv.xw).a;
	float r  = tex2D(_MainTex, texCoord + duv.xw).a;

	float bl = tex2D(_MainTex, texCoord + duv.zy).a;
	float b  = tex2D(_MainTex, texCoord + duv.wy).a;
	float br = tex2D(_MainTex, texCoord + duv.xy).a;

	// Horizontal gradient
	// [-1  0  1]
	// [-2  0  2]
	// [-1  0  1]

	// Vertical gradient
	// [-1 -2 -1]
	// [ 0  0  0]
	// [ 1  2  1]

	float x = tr + r * 2 + br - (tl + l * 2 + bl);
	float y = bl + b * 2 + br - (tl + t * 2 + tr);

	// Computes the luminance's gradient and saves it in the unused alpha channel
	return float4(c0.rgb, 1 - saturate(length(float2(x, y))));
}

