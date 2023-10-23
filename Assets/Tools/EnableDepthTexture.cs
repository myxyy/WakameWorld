using UnityEngine;
[ExecuteInEditMode]
public class EnableDepthTexture : MonoBehaviour
{
    void OnRenderObject()
    {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
        Camera.main.nearClipPlane = 0.2f;
        this.GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }
}