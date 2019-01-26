using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

// This maps the PlayerInfo.Side enum to colors that will be displayed when hovering a unit.
[CreateAssetMenu(menuName = "ScriptableObjects/ItemMapper")]
public class ItemMapper: ScriptableObject, EnumMapper<GameObject>
{
    public List<GameObject> map = new List<GameObject>();

    public GameObject Map(Item item)
    {
        if (map.Count < (int)item) {
            return null;
        }

        return map[(int)item];
    }

    static ItemMapper _instance = null;
    public static ItemMapper Instance
    {
        get {
            if (!_instance) {
                ItemMapper[] mappers = Resources.FindObjectsOfTypeAll<ItemMapper>();
                if (mappers.Length <= 0) {
                    Debug.LogError("No PlayerSideColorMapper instances found, make one!");
                    return null;
                }

                _instance = mappers[0];
            }

            return _instance;
        }
    }

    public List<GameObject> GetMap()
    {
        return map;
    }
}
