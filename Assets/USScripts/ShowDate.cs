
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;

public class ShowDate : UdonSharpBehaviour
{
    private void Update()
    {
        GetComponent<Text>().text = string.Format("{0:yyyy/MM/dd}", System.DateTime.Now);
    }
}
