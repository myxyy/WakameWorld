
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Components;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class Mikoshi : UdonSharpBehaviour
{
    [SerializeField]
    private Rigidbody _rigidBody;
    [SerializeField]
    private MikoshiHandle[] _handleList;
    [SerializeField]
    private float _forceFactor = 100f;

    private bool _isInitialTransformSyncCompleted = false;
    [UdonSynced(UdonSyncMode.None)]
    private Vector3 _positionSync;
    [UdonSynced(UdonSyncMode.None)]
    private Quaternion _rotationSync;
    [SerializeField, Range(0f,1f)]
    private float _transformSyncFactor = 0.1f;

    private void Update()
    {
        for (int i=0; i<_handleList.Length; i++)
        {
            var handle = _handleList[i];
            if (handle.IsHeld)
            {
                var forceVector = handle.PositionSynced - handle.transform.position;
                var forceDir = forceVector.normalized;
                var forceSqrMagnitude = forceVector.sqrMagnitude;
                var force = (forceSqrMagnitude < 1f ? forceDir : forceVector) * _forceFactor;
                _rigidBody.AddForceAtPosition(force, handle.transform.position, ForceMode.Acceleration);
            }
        }
        
        if (Networking.IsOwner(Networking.LocalPlayer, this.gameObject))
        {
            _positionSync = this.transform.position;
            _rotationSync = this.transform.rotation;
            RequestSerialization();
        }
        else
        {
            this.transform.position = Vector3.Lerp(this.transform.position, _positionSync, _transformSyncFactor);
            this.transform.rotation = Quaternion.Lerp(this.transform.rotation, _rotationSync, _transformSyncFactor);
        }
    }

    public override void OnDeserialization()
    {
        base.OnDeserialization();
        if (!_isInitialTransformSyncCompleted)
        {
            if (!Networking.IsOwner(Networking.LocalPlayer, this.gameObject))
            {
                this.transform.position = _positionSync;
                this.transform.rotation = _rotationSync;
            }
        }
    }
}
