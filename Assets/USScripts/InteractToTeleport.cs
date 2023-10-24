
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class InteractToTeleport : UdonSharpBehaviour
{
    [SerializeField] private Transform dest;
    public override void Interact()
    {
        var player = Networking.LocalPlayer;
        player.TeleportTo(dest.position, dest.rotation);
    }
}
