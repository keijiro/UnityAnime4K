#include "UnityCG.cginc"

sampler2D _MainTex;
float4 _MainTex_TexelSize;

float4 frag(v2f_img i) : SV_Target
{
    const float dx = _MainTex_TexelSize.x;
    const float dy = _MainTex_TexelSize.y;

	float4 c0 = tex2D(_MainTex, i.uv);

	//[tl  t tr]
	//[ l     r]
	//[bl  b br]
	float t  = tex2D(_MainTex, i.uv + float2(  0, -dy))[3];
	float tl = tex2D(_MainTex, i.uv + float2(-dx, -dy))[3];
	float tr = tex2D(_MainTex, i.uv + float2( dx, -dy))[3];

	float l  = tex2D(_MainTex, i.uv + float2(-dx,   0))[3];
	float r  = tex2D(_MainTex, i.uv + float2( dx,   0))[3];

	float b  = tex2D(_MainTex, i.uv + float2(  0,  dy))[3];
	float bl = tex2D(_MainTex, i.uv + float2(-dx,  dy))[3];
	float br = tex2D(_MainTex, i.uv + float2( dx,  dy))[3];

	//Horizontal Gradient
	//[-1  0  1]
	//[-2  0  2]
	//[-1  0  1]
	float xgrad = (-tl + tr - l - l + r + r - bl + br);

	//Vertical Gradient
	//[-1 -2 -1]
	//[ 0  0  0]
	//[ 1  2  1]
	float ygrad = (-tl - t - t - tr + bl + b + b + br);

	//Computes the luminance's gradient and saves it in the unused alpha channel
	return float4(c0[0], c0[1], c0[2], 1 - clamp(sqrt(xgrad * xgrad + ygrad * ygrad), 0, 1));
}

