sampler2D _MainTex;
float4 _MainTex_TexelSize;

float Min3(float a, float b, float c)
{
	return min(min(a, b), c);
}

float Max3(float a, float b, float c)
{
	return max(max(a, b), c);
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
