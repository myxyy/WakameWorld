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

        var environmentList = environmentManager.Parameters.Select(parameter => parameter.Label).ToList();
        environmentList.Add(string.Empty);
        environmentList.Add("(Unselected)");
        var label = new GUIContent("Environments", "Select one item.");
        var selectedIndex = environmentManager.Index < 0 ? environmentManager.Parameters.Length + 1 : environmentManager.Index;
        var index = environmentManager.Parameters.Length > 0 ? EditorGUILayout.Popup(label, selectedIndex, environmentList.ToArray()) : selectedIndex;

        if (EditorGUI.EndChangeCheck())
        {
            var objectToUndo = environmentManager;
            Undo.RecordObject(environmentManager, "EnvironmentManager");
            var previousIndex = environmentManager.Index;
            environmentManager.Index = index;
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