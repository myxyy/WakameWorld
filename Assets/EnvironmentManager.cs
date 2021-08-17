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
        [SerializeField] public Color SkyColor;
    }

    [SerializeField] private EnvironmentParameter[] parameters;
    [SerializeField] private int index;
    public void Refresh()
    {
        skyMaterial.SetColor("_Color2", parameters[index].SkyColor);
    }
#endif
}
