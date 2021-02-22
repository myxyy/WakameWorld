
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using TMPro;

public class ShowDate : UdonSharpBehaviour
{
    [SerializeField] private TextMeshProUGUI dateText;
    private void Update()
    {
        dateText.text = string.Format("{0:yyyy/MM/dd}", System.DateTime.Now);
    }
}
