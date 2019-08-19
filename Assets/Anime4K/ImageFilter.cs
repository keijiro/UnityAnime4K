using UnityEngine;

namespace Anime4K
{
    public static class ImageFilter
    {
        static Material _material;

        public static void Upscale(Texture2D source, RenderTexture destination, float push = 1)
        {
            if (_material == null)
                _material = new Material(Shader.Find("Hidden/Anime4K"));

            _material.SetFloat("_Strength", push);

            var tempRT1 = RenderTexture.GetTemporary(destination.width, destination.height);
            var tempRT2 = RenderTexture.GetTemporary(destination.width, destination.height);

            Graphics.Blit(source, tempRT1, _material, 0);
            Graphics.Blit(tempRT1, tempRT2, _material, 1);
            Graphics.Blit(tempRT2, tempRT1, _material, 2);
            Graphics.Blit(tempRT1, destination, _material, 3);

            RenderTexture.ReleaseTemporary(tempRT1);
            RenderTexture.ReleaseTemporary(tempRT2);
        }
    }
}
