
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class YClock : UdonSharpBehaviour
{
    void Start()
    {
        var material = GetComponent<MeshRenderer>().material;
        var now = System.DateTime.Now;
        material.SetFloat("_year", now.Year);
        material.SetFloat("_month", now.Month);
        material.SetFloat("_day", now.Day);
        material.SetFloat("_hour", now.Hour);
        material.SetFloat("_min", now.Minute);
        material.SetFloat("_sec", now.Second);
        material.SetFloat("_msec", now.Millisecond);
        material.SetFloat("_dow", ((int)(now.ToOADate()) - 1) % 7);
    }
}
