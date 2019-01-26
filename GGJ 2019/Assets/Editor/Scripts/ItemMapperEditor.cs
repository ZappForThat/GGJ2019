using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(ItemMapper))]
class ItemMapperEditor : EnumMapperEditor
{
    public override void OnInspectorGUI()
    {
        OnInspectorGUI<ItemMapper, GameObject, Item>("map");
    }
}

