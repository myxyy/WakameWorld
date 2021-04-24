
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class ResetFarObjectToDefaultPosition : UdonSharpBehaviour
{
    [UdonSynced(UdonSyncMode.None)]
    private Vector3 defaultPosition = new Vector3(100000,0,0);
    [UdonSynced(UdonSyncMode.None)]
    private Quaternion defaultRotation;
    [SerializeField]
    private float heightOfDownwardRayOriginFromPosition;
    [SerializeField]
    private float lengthOfDownwardRay;
    void Start()
    {
        if (Networking.LocalPlayer.isMaster)
        {
            if (defaultPosition.x > 99999)
            {
                defaultPosition = this.transform.position;
                defaultRotation = this.transform.rotation;
            }
        }
    }

    void Update()
    {
        if (Networking.LocalPlayer.isMaster)
        {
            if (
                !Physics.Raycast(
                    this.transform.position + new Vector3(0, heightOfDownwardRayOriginFromPosition, 0),
                    new Vector3(0,-1.0f,0),
                    lengthOfDownwardRay,
                    ~0
                )
            )
            {
                SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "ResetToDefaultPosition");
            }
        }
    }

    public void ResetToDefaultPosition()
    {
        this.transform.position = defaultPosition;
        this.transform.rotation = defaultRotation;
        var rigidbody = this.GetComponent<Rigidbody>();
        rigidbody.velocity = new Vector3(0,0,0);
        rigidbody.angularVelocity = new Vector3(0,0,0);
    }
}
