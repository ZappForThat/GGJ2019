using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(ItemImageMapper))]
class ItemImageMapperEditor : EnumMapperEditor
{
    public override void OnInspectorGUI()
    {
        OnInspectorGUI<ItemImageMapper, Sprite, Item>("map");
    }
}

