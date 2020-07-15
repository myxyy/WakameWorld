using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;
public class VRCCamManager : MonoBehaviour
{
    [SerializeField]
    private float clippingFar = 1000.0f;
    private Scene scene;
    private Camera vrcCam;
    void OnRenderObject()
    {
        scene = SceneManager.GetSceneByBuildIndex(0);
        var vrcCamObject = scene.GetRootGameObjects()
            .Where(obj => obj.name == "VRCCam")
            .FirstOrDefault();
        if (vrcCamObject != null)
        {
            vrcCam = vrcCamObject.GetComponent<Camera>();
        }
        if (vrcCam != null)
        {
            vrcCam.depthTextureMode = DepthTextureMode.Depth;
            vrcCam.farClipPlane = clippingFar;
        }
    }
}