using UnityEngine;

namespace Anime4K
{
    public static class ImageFilter
    {
        public static void Upscale(Texture2D source, RenderTexture destination)
        {
            var material = new Material(Shader.Find("Hidden/Anime4K"));

            var tempRT1 = RenderTexture.GetTemporary(destination.width, destination.height);
            var tempRT2 = RenderTexture.GetTemporary(destination.width, destination.height);

            Graphics.Blit(source, tempRT1, material, 0);
            Graphics.Blit(tempRT1, tempRT2, material, 1);
            Graphics.Blit(tempRT2, tempRT1, material, 2);
            Graphics.Blit(tempRT1, destination, material, 3);

            RenderTexture.ReleaseTemporary(tempRT1);
            RenderTexture.ReleaseTemporary(tempRT2);
        }
    }
}
