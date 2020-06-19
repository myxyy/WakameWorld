
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class PlayAudioSourceOnEnterTrigger : UdonSharpBehaviour
{
    void OnTriggerEnter(Collider collider)
    {
        if (collider.gameObject.layer == 13)
        {
            SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.Owner, "BroadCast");
        }
    }
    public void BroadCast()
    {
        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "ExecuteOnEnterTrigger");
    }
    public void ExecuteOnEnterTrigger()
    {
        GetComponent<AudioSource>().Play();
    }
}
