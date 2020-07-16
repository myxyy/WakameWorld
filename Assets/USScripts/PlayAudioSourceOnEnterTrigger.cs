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
        if (collider != null)
        {
            if (collider.gameObject.layer == 13)
            {
                audioSource.Play();
            }
        }
    }
}