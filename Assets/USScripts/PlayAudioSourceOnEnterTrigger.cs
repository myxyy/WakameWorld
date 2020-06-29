
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class PlayAudioSourceOnEnterTrigger : UdonSharpBehaviour
{
    private AudioSource audioSource;
    
    void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }
    void OnTriggerEnter(Collider collider)
    {
        //this.gameObject.transform.Rotate(0.0f,30.0f,0.0f, Space.World);
        //Debug.Log("Collision");
        if (collider != null)
        {
            if (collider.gameObject.layer == 13)
            {
                SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.Owner, "BroadCast");
            }
        }
    }
    public void BroadCast()
    {
        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "SoundPlay");
    }
    public void SoundPlay()
    {
        audioSource.Play();
    }
}
