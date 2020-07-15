using UnityEngine;
[ExecuteInEditMode]
public class EnableDepthTexture : MonoBehaviour
{
    void OnRenderObject()
    {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
        this.GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }
}