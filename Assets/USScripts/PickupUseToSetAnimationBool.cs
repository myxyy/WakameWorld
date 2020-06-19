
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class PickupUseToSetAnimationBool : UdonSharpBehaviour
{
    [SerializeField] private string animationBoolName;
    private Animator animator;
    private bool test = false;
    void Start()
    {
        animator = GetComponent<Animator>();
    }
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
        animator.SetBool(animationBoolName, true);
    }
    public void ExecuteOnPickupUseUp()
    {
        animator.SetBool(animationBoolName, false);
    }
}
