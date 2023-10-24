
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class PickupUseToStartParticle : UdonSharpBehaviour
{
    [SerializeField] private ParticleSystem[] particles;
    public override void OnPickupUseDown()
    {
        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "ExecuteOnPickupUseDown");
    }
    public void ExecuteOnPickupUseDown()
    {
        foreach (var particle in particles) particle.Play();
    }

}
