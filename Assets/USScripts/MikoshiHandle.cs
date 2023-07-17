
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Components;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class MikoshiHandle : UdonSharpBehaviour
{
    [SerializeField]
    private VRCPickup _pickup;
    [UdonSynced(UdonSyncMode.None)]
    private bool _isHeld;
    public bool IsHeld => _isHeld;
    [UdonSynced(UdonSyncMode.None)]
    private Vector3 _positionSynced;
    public Vector3 PositionSynced => _positionSynced;

    private void Update()
    {
        //var color = new Color(_isHeld?1f:0f, _pickup.IsHeld?1f:0f, 0f, 1f);
        //_pickup.GetComponent<MeshRenderer>().material.SetColor("_Color", color);
        if (_pickup.IsHeld)
        {
            Networking.SetOwner(Networking.LocalPlayer, this.gameObject);
        }

        if (Networking.IsOwner(this.gameObject))
        {
            _isHeld = _pickup.IsHeld;
            _positionSynced = _pickup.transform.position;
            RequestSerialization();
        }

        if (!_isHeld)
        {
            _pickup.transform.position = this.transform.position;
            _pickup.transform.rotation = this.transform.rotation;
        }

    }
}
