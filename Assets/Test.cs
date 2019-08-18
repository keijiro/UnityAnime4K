using UnityEngine;

class Test : MonoBehaviour
{
    [SerializeField] Texture2D _source = null;
    [SerializeField] RenderTexture _output = null;

    void Start()
    {
        Anime4K.ImageFilter.Upscale(_source, _output);
    }
}
