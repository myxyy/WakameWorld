
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class ReverbByHeadHeight : UdonSharpBehaviour
{
    [SerializeField] private AudioReverbFilter filter;
    [SerializeField] private float maxHeight = 0.0f;
    private VRCPlayerApi player;
    void Start()
    {
        player = Networking.LocalPlayer;
    }
    void Update()
    {
        var headData = player.GetTrackingData(VRCPlayerApi.TrackingDataType.Head);
        filter.enabled = headData.position.y < maxHeight;
    }
}
