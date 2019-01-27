using UnityEngine;
using UnityEditor;
using System.Collections;

[CustomEditor(typeof(HouseStage))]
public class HouseStageEditor : Editor
{
    SerializedProperty requiredItemProperty;
    SerializedProperty nailsProperty;
    SerializedProperty sawLogProperty;

    private void OnEnable()
    {
        requiredItemProperty = serializedObject.FindProperty("requiredItem");
        nailsProperty = serializedObject.FindProperty("nails");
        sawLogProperty = serializedObject.FindProperty("sawLog");
    }

    public override void OnInspectorGUI()
    {
        HouseStage houseStage = (HouseStage)target;
        serializedObject.Update();

        EditorGUILayout.PropertyField(requiredItemProperty);

        if (houseStage.requiredItem == Item.Hammer)
        {
            EditorGUILayout.PropertyField(nailsProperty, true);
        }
        else if (houseStage.requiredItem == Item.Saw)
        {
            EditorGUILayout.PropertyField(sawLogProperty);
        }

        serializedObject.ApplyModifiedProperties();
    }
}
