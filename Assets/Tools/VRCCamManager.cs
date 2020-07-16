using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
public class VRCCamManager : MonoBehaviour
{
    [SerializeField]
    private float clippingFar = 1000.0f;
    [SerializeField]
    private bool doesVRCCamTrackSceneCam = true;
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
            #if UNITY_EDITOR
            if (
                Camera.current != null &&
                EditorWindow.focusedWindow != null &&
                EditorWindow.focusedWindow.titleContent.text == "Scene" &&
                doesVRCCamTrackSceneCam
            )
            {
                vrcCam.transform.position = Camera.current.transform.position;
                vrcCam.transform.rotation = Camera.current.transform.rotation;
            }
            #endif
        }
    }
}