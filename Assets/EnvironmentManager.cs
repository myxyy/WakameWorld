using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class EnvironmentManager : MonoBehaviour
{
#if UNITY_EDITOR
    [SerializeField] private Material skyMaterial;
    [Serializable]
    public class EnvironmentParameter
    {
        [SerializeField] public string label;
        [SerializeField] public Color SkyColor;
    }

    [SerializeField] public EnvironmentParameter[] parameters;
    [HideInInspector] public int index = -1;
    public void Refresh()
    {
        skyMaterial.SetColor("_Color2", parameters[index].SkyColor);
    }
#endif
}
