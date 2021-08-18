using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class EnvironmentManager : MonoBehaviour
{
#if UNITY_EDITOR
    [SerializeField] private Material skyMaterial;
    [SerializeField] private Material seaMaterial;
    [SerializeField] private Material underwaterMaterial;
    [SerializeField] private Light bakedDirectionalLight;
    [SerializeField] private Light realtimeDirectionalLight;
    [SerializeField] private Light realtimeDirectionalLightForWater;

    [Serializable]
    public class EnvironmentParameter
    {
        [SerializeField] public string Label;
        [SerializeField] public Color SkyColor;
        [SerializeField] public Color HorizonColor;
        [SerializeField] public Color SunColor;
        [SerializeField] public float AmbientIntensity;
        [SerializeField] public Color WaterDeepColor;
        [SerializeField] public Color WaterShallowColor;
        [SerializeField] public float directionalLightIntensity;
        [SerializeField] public Vector3 directionalLightEulerAngle;
    }

    [SerializeField] public EnvironmentParameter[] Parameters;
    [HideInInspector] public int Index = -1;
    public void Refresh()
    {
        var parameter = Parameters[Index];
        skyMaterial.SetColor("_Color2", parameter.SkyColor);
        skyMaterial.SetColor("_Color0", parameter.HorizonColor);
        skyMaterial.SetColor("_Color3", parameter.SunColor);
        skyMaterial.SetFloat("_Ex3", parameter.AmbientIntensity);
        seaMaterial.SetColor("_Color", parameter.WaterDeepColor);
        seaMaterial.SetColor("_ColorShallow", parameter.WaterShallowColor);
        underwaterMaterial.SetColor("_SC", parameter.WaterDeepColor);
        underwaterMaterial.SetColor("_Color", parameter.WaterShallowColor);
        bakedDirectionalLight.intensity = parameter.directionalLightIntensity * 0.5f;
        realtimeDirectionalLight.intensity = parameter.directionalLightIntensity * 0.5f;
        realtimeDirectionalLightForWater.intensity = parameter.directionalLightIntensity;
        bakedDirectionalLight.transform.localEulerAngles = parameter.directionalLightEulerAngle;
        realtimeDirectionalLight.transform.localEulerAngles = parameter.directionalLightEulerAngle;
        realtimeDirectionalLightForWater.transform.localEulerAngles = parameter.directionalLightEulerAngle;
    }
#endif
}
