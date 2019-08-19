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

float Luma(float3 rgb)
{
#ifdef UNITY_COLORSPACE_GAMMA
    return dot(rgb, float3(0.22, 0.707, 0.071));
#else
    return dot(rgb, float3(0.0396819152, 0.458021790, 0.00609653955));
#endif
}

void Vertex(
    uint vertexID : SV_VertexID,
    out float4 position : SV_Position,
    out float2 texCoord : TEXCOORD
)
{
    float2 uv;

    if (vertexID < 2)
        uv = float2(vertexID & 1, 0);
    else
        uv = float2(1 - (vertexID & 1), 1);

    position = float4(2 * uv - 1, 1, 1);
    texCoord = float2(uv.x, 1 - uv.y);
}
