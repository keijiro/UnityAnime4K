#include "UnityCG.cginc"

sampler2D _MainTex;

float4 frag(v2f_img i) : SV_Target
{
    float4 c0 = tex2D(_MainTex, i.uv);

	//Quick luminance approximation
	float lum = (c0[0] + c0[0] + c0[1] + c0[1] + c0[1] + c0[2]) / 6;

	//Computes the luminance and saves it in the unused alpha channel
	return float4(c0[0], c0[1], c0[2], lum);
}
