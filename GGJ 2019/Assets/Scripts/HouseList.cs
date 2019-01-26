using UnityEngine;
using System.Collections.Generic;

[CreateAssetMenu(menuName = "ScriptableObjects/HouseList")]
public class HouseList : ScriptableObject
{
    public List<House> housePrefabs;
}
