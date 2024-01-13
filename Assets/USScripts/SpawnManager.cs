
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using System;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class SpawnManager : UdonSharpBehaviour
{
    [SerializeField]
    private Transform[] _spawnPointList;

    public override void OnPlayerJoined(VRCPlayerApi player)
    {
        base.OnPlayerJoined(player);
        if (player == Networking.LocalPlayer)
        {
            PlayerTeleportToSpawnPoint(player);
        }
    }

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        base.OnPlayerCollisionEnter(player);
        if (player == Networking.LocalPlayer)
        {
            PlayerTeleportToSpawnPoint(player);
        }
    }

    private void PlayerTeleportToSpawnPoint(VRCPlayerApi player)
    {
        var seed = (int)DateTime.Now.AddHours(-6f).ToOADate();
        var spawnPoint = _spawnPointList[seed % _spawnPointList.Length];
        player.TeleportTo(spawnPoint.position, spawnPoint.rotation);
    }
}
