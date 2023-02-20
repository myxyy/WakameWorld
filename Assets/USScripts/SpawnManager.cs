
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class SpawnManager : UdonSharpBehaviour
{
    [SerializeField]
    private Transform[] _spawnPointList;
    [UdonSynced(UdonSyncMode.None), FieldChangeCallback(nameof(SpawnPointIndex))]
    private int _spawnPointIndex = -1;
    public int SpawnPointIndex
    {
        get => _spawnPointIndex;
        set
        {
            _spawnPointIndex = value;
            if (!_isSpawnCompleted)
            {
                _spawnPoint = _spawnPointList[_spawnPointIndex];
                Networking.LocalPlayer.TeleportTo(_spawnPoint.position, _spawnPoint.rotation);
                _isSpawnCompleted = true;
            }
        }
    }
    private bool _isSpawnCompleted = false;
    private Transform _spawnPoint;

    public override void OnPlayerJoined(VRCPlayerApi player)
    {
        base.OnPlayerJoined(player);
        if (Networking.IsOwner(Networking.LocalPlayer, gameObject))
        {
            SpawnPointIndex = UnityEngine.Random.Range(0, _spawnPointList.Length);
        }
        RequestSerialization();
    }
}
