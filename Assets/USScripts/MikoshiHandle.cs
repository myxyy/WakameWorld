
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class MikoshiHandle : UdonSharpBehaviour
{
    [SerializeField]
    private Rigidbody _rigidBody;
    [SerializeField]
    private Transform[] _handleDefaultTransformList;
    [SerializeField]
    private VRC.SDK3.Components.VRCPickup[] _handleList;
    [SerializeField]
    private float _forceFactor = 100f;
    private void Update()
    {
        for (int i=0; i<_handleDefaultTransformList.Length; i++)
        {
            if (
                Networking.IsOwner(Networking.LocalPlayer, _handleList[i].gameObject) &&
                !_handleList[i].IsHeld
            )
            {
                _handleList[i].transform.position = _handleDefaultTransformList[i].position;
                _handleList[i].transform.rotation = _handleDefaultTransformList[i].rotation;
            }
            if (_handleList[i].IsHeld)
            {
                var force = _handleList[i].transform.position - _handleDefaultTransformList[i].position;
                force *= _forceFactor;
                _rigidBody.AddForceAtPosition(force, _handleDefaultTransformList[i].position, ForceMode.Acceleration);
            }
        }
    }
}
