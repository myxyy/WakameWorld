
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
public class InteractToResetPosition : UdonSharpBehaviour
{
    [SerializeField] private Transform targetObject;
    [SerializeField] private Transform defaultTransform;
    [SerializeField] private bool masterOnly;
    public override void Interact()
    {
        if (!masterOnly || Networking.IsMaster)
        {
            targetObject.SetPositionAndRotation(defaultTransform.position, defaultTransform.rotation);
        }
    }
}
