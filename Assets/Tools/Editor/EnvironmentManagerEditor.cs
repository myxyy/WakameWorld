using UnityEngine;
using UnityEditor;
using System.Linq;

[CustomEditor(typeof(EnvironmentManager))]
public class EnvironmentManagerEditor : Editor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        var environmentManager = target as EnvironmentManager;

        EditorGUI.BeginChangeCheck();

        var environmentList = environmentManager.parameters.Select(parameter => parameter.label).ToList();
        environmentList.Add(string.Empty);
        environmentList.Add("(Unselected)");
        var label = new GUIContent("Environments", "Select one item.");
        var selectedIndex = environmentManager.index < 0 ? environmentManager.parameters.Length + 1 : environmentManager.index;
        var index = environmentManager.parameters.Length > 0 ? EditorGUILayout.Popup(label, selectedIndex, environmentList.ToArray()) : selectedIndex;

        if (EditorGUI.EndChangeCheck())
        {
            var objectToUndo = environmentManager;
            Undo.RecordObject(environmentManager, "EnvironmentManager");
            var previousIndex = environmentManager.index;
            environmentManager.index = index;
            if (previousIndex != index)
            {
                environmentManager.Refresh();
            }
        }

        if (GUILayout.Button("Refresh"))
        {
            environmentManager.Refresh();
        }
    }
}