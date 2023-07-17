
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Components;
using VRC.SDKBase;
using VRC.Udon;

public class Mikoshi : UdonSharpBehaviour
{
    [SerializeField]
    private Rigidbody _rigidBody;
    [SerializeField]
    private MikoshiHandle[] _handleList;
    [SerializeField]
    private float _forceFactor = 100f;

    private void Update()
    {
        for (int i=0; i<_handleList.Length; i++)
        {
            var handle = _handleList[i];
            if (handle.IsHeld)
            {
                var force = (handle.PositionSynced - handle.transform.position).normalized;
                force *= _forceFactor;
                _rigidBody.AddForceAtPosition(force, handle.transform.position, ForceMode.Acceleration);
            }
        }
    }
}
