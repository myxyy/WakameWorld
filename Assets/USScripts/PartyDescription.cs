
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using TMPro;
using System;

public class PartyDescription : UdonSharpBehaviour
{
    [SerializeField]
    private TextMeshProUGUI descriptionText;
    [SerializeField]
    private TextMeshProUGUI dateText;
    [SerializeField]
    private TextMeshProUGUI numberText;
    private void Update()
    {
        var datetime = Networking.GetNetworkDateTime();
        // 日本時間
        var japanTime = datetime.AddHours(9);
        bool isPartyTime = japanTime.Hour >= 23 && japanTime.DayOfWeek == DayOfWeek.Monday;
        descriptionText.enabled = !isPartyTime;
        dateText.enabled = isPartyTime;
        numberText.enabled = isPartyTime;
    }
}
