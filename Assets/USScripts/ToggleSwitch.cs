
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class ToggleSwitch : UdonSharpBehaviour
{
    public GameObject[] enableOnEnable;
    public GameObject[] enableOnDisable;
    public bool toggle = false;

    void Start()
    {
        foreach (var obj in enableOnEnable) obj.SetActive(toggle);
        foreach (var obj in enableOnDisable) obj.SetActive(!toggle);
    }

    void Interact()
    {
        toggle = !toggle;
        foreach (var obj in enableOnEnable) obj.SetActive(toggle);
        foreach (var obj in enableOnDisable) obj.SetActive(!toggle);
    }
}
