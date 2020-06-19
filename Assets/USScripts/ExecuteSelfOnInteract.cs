
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class ExecuteSelfOnInteract : UdonSharpBehaviour
{
    public override void Interact()
    {
        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "ExecuteOnPickupUseDown");
    }
    public void ExecuteOnPickupUseDown()
    {
        this.gameObject.SetActive(false);
    }
}
