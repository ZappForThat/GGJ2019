using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

// This maps the PlayerInfo.Side enum to colors that will be displayed when hovering a unit.
[CreateAssetMenu(menuName = "ScriptableObjects/ItemImageMapper")]
public class ItemImageMapper: ScriptableObject, EnumMapper<Sprite>
{
    public List<Sprite> map = new List<Sprite>();

    public Sprite Map(Item item)
    {
        if (map.Count < (int)item) {
            return null;
        }

        return map[(int)item];
    }

    static ItemImageMapper _instance = null;
    public static ItemImageMapper Instance
    {
        get {
            if (!_instance) {
                ItemImageMapper[] mappers = Resources.FindObjectsOfTypeAll<ItemImageMapper>();
                if (mappers.Length <= 0) {
                    Debug.LogError("No PlayerSideColorMapper instances found, make one!");
                    return null;
                }

                _instance = mappers[0];
            }

            return _instance;
        }
    }

    public List<Sprite> GetMap()
    {
        return map;
    }
}
