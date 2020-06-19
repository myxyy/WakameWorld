using UnityEngine;
[ExecuteInEditMode]
public class EnableDepthTexture : MonoBehaviour
{
    void OnEnable()
    {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
    }
}