
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class PickupUseToIncrementRoundrobinAnimationInt : UdonSharpBehaviour
{
    [SerializeField] Animator animator;
    [SerializeField] string animIntName;
    [SerializeField] string animTriggerName;
    [UdonSynced(UdonSyncMode.None)] private int animInt = 0;
    [SerializeField] private int defaultValue = 0;
    [SerializeField] private int modulo = 4;
    void Start()
    {
        animInt = defaultValue % modulo;
    }
    public override void OnPickupUseDown()
    {
        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "ExecuteOnPickupUseDown");
    }
    public void ExecuteOnPickupUseDown()
    {
        animInt = (animInt + 1) % modulo;
        animator.SetInteger(animIntName, animInt);
        animator.SetTrigger(animTriggerName);
    }
}
