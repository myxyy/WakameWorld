
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class SetGameObjectOnEnterTrigger : UdonSharpBehaviour
{
    [SerializeField] private GameObject[] enableOnEnterTrigger;
    [SerializeField] private GameObject[] disableOnEnterTrigger;
    void OnTriggerEnter(Collider collider)
    {
        if(collider.gameObject.layer == 22)
        {
            SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "ExecuteOnPickupUseDown");
        }
    }
    public void ExecuteOnPickupUseDown()
    {
        foreach (var obj in enableOnEnterTrigger) obj.gameObject.SetActive(true);
        foreach (var obj in disableOnEnterTrigger) obj.gameObject.SetActive(false);
    }
}
