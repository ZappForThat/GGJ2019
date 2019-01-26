using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class EnumMapperEditor : Editor
{
    public void OnInspectorGUI<MapperType, MappedType, EnumType>(string propertyName)
        where MapperType: UnityEngine.Object, EnumMapper<MappedType>
        where EnumType: struct, IConvertible
    {
        MapperType mapper = (MapperType)target;
        EnumType[] enumValues = (EnumType[])Enum.GetValues(typeof(EnumType));

        while (mapper.GetMap().Count < enumValues.Length) {
            // If enum values were added since the last time, extend the list
            mapper.GetMap().Add(default(MappedType));
        }

        SerializedObject serializedObject = new SerializedObject(mapper);
        SerializedProperty serializedMap = serializedObject.FindProperty(propertyName);

        serializedObject.Update();

        foreach (EnumType enumValue in enumValues)
        {
            object val = Convert.ChangeType(enumValue, enumValue.GetTypeCode());
            SerializedProperty spawnableObject = serializedMap.GetArrayElementAtIndex((int)val);
            EditorGUILayout.PropertyField(spawnableObject, new GUIContent(enumValue.ToString()), true, null);
        }

        serializedObject.ApplyModifiedProperties();
    }
}
