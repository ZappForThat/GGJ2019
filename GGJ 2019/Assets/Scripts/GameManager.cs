using UnityEngine;
using System.Collections.Generic;

public class GameManager : MonoBehaviour
{
    [SerializeField]
    private HouseList houseList = null;

    [SerializeField]
    private GameObject spawnTarget = null;

    [SerializeField]
    private List<GameObject> throwOrigins = null;

    [SerializeField]
    private float throwForce = 5.0f;

    [SerializeField]
    private HouseBook houseBook = null;

    private House currentHouse = null;
    private List<GameObject> applyOnNextUpdate = new List<GameObject>();

    private void Start()
    {
        SpawnNewRandomHouse();
    }

    private void FixedUpdate()
    {
        foreach (GameObject go in applyOnNextUpdate)
        {
            Vector3 relative = spawnTarget.transform.position - go.transform.position;
            foreach (Rigidbody rigidbody in go.GetComponentsInChildren<Rigidbody>())
            {
                rigidbody.AddForce(relative * throwForce, ForceMode.VelocityChange);
                rigidbody.AddRelativeTorque(Random.rotationUniform *  Vector3.right * 10.0f, ForceMode.VelocityChange);
            }
        }

        applyOnNextUpdate.Clear();
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
        houseBook.Fill(currentHouse);
    }

    private void ThrowItem(Item item)
    {
        GameObject throwOrigin = throwOrigins[(int)Random.Range(0, throwOrigins.Count)];
        GameObject itemPrefab = ItemMapper.Instance.Map(item);
        GameObject newItem = Instantiate(itemPrefab, throwOrigin.transform.position, throwOrigin.transform.rotation, currentHouse.transform);
        applyOnNextUpdate.Add(newItem);
    }
}
