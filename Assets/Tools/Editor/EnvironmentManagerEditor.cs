using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(EnvironmentManager))]
public class EnvironmentManagerEditor : Editor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        if (GUILayout.Button("Refresh"))
        {
            (target as EnvironmentManager).Refresh();
        }
    }
}