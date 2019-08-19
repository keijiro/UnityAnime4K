#include "UnityCG.cginc"

sampler2D _MainTex;
float4 _MainTex_TexelSize;
float _Strength;

float MinA(float4 a, float4 b, float4 c)
{
    return min(min(a.a, b.a), c.a);
}

float MaxA(float4 a, float4 b, float4 c)
{
    return max(max(a.a, b.a), c.a);
}

float MinA(float4 a, float4 b, float4 c, float4 d)
{
    return min(min(min(a.a, b.a), c.a), d.a);
}

float MaxA(float4 a, float4 b, float4 c, float4 d)
{
    return max(max(max(a.a, b.a), c.a), d.a);
}

void Vertex(
    float4 position : POSITION,
    float2 texCoord : TEXCOORD,
    out float4 outPosition : SV_Position,
    out float2 outTexCoord : TEXCOORD
)
{
    outPosition = UnityObjectToClipPos(position);
    outTexCoord = texCoord;
}
