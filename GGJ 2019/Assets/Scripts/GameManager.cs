using UnityEngine;
using System.Collections;

public class GameManager : MonoBehaviour
{
    [SerializeField]
    private HouseList houseList = null;

    [SerializeField]
    private GameObject spawnTarget = null;

    [SerializeField]
    private GameObject throwOrigin = null;

    private House currentHouse = null;

    private void Start()
    {
        SpawnNewRandomHouse();
    }

    public void ApplyItem(Item item)
    {
        if (currentHouse.IsCorrectItem(item))
        {
            currentHouse.AdvanceHouse();
            if (currentHouse.IsComplete())
            {
                Destroy(currentHouse.gameObject);
                SpawnNewRandomHouse();
            }
        }
        else
        {
            ThrowItem(item);
        }
    }

    private void SpawnNewRandomHouse()
    {
        SpawnNewHouse(houseList.housePrefabs[(int)Random.Range(0, houseList.housePrefabs.Count)]);
    }

    private void SpawnNewHouse(House housePrefab)
    {
        currentHouse = Instantiate<House>(housePrefab, spawnTarget.transform.position, spawnTarget.transform.rotation, this.transform);
    }

    private void ThrowItem(Item item)
    {
        GameObject itemPrefab = ItemMapper.Instance.Map(item);
        GameObject newItem = Instantiate(itemPrefab, throwOrigin.transform.position, throwOrigin.transform.rotation, null);
        //foreach (Rigidbody
    }
}
