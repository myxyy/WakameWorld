using UdonSharp;
using UnityEngine;
public class PickupUseToSetGameObject : UdonSharpBehaviour
{
    [SerializeField] private GameObject[] ActiveOnPickupUseDown;
    [SerializeField] private GameObject[] ActiveOnPickupUseUp;
    public override void OnPickupUseDown()
    {
        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "ExecuteOnPickupUseDown");
    }
    public override void OnPickupUseUp()
    {
        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "ExecuteOnPickupUseUp");
    }
    public void ExecuteOnPickupUseDown()
    {
        foreach (var obj in ActiveOnPickupUseDown) obj.SetActive(true);
        foreach (var obj in ActiveOnPickupUseUp) obj.SetActive(false);
    }
    public void ExecuteOnPickupUseUp()
    {
        foreach (var obj in ActiveOnPickupUseDown) obj.SetActive(false);
        foreach (var obj in ActiveOnPickupUseUp) obj.SetActive(true);
    }

}
