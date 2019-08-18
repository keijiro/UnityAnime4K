using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
class Test : MonoBehaviour
{
    [Space]
    [SerializeField] Texture2D _source = null;
    [SerializeField] RenderTexture _output = null;
    [SerializeField, Range(0, 1)] float _push = 1;
    [Space]
    [SerializeField] RawImage _sourceUI = null;
    [SerializeField] RawImage _outputUI = null;

    void Update()
    {
        if (_source == null || _output == null) return;

        Anime4K.ImageFilter.Upscale(_source, _output, _push);

        if (_sourceUI == null || _outputUI == null) return;

        _sourceUI.texture = _source;
        _outputUI.texture = _output;
    }
}
