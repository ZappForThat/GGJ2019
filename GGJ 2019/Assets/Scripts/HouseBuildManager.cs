using UnityEngine;
using System.Collections.Generic;

public class HouseBuildManager : MonoBehaviour
{
    [SerializeField]
    private HouseList houseList = null;

    [SerializeField]
    private GameObject spawnTarget = null;

    [SerializeField]
    private List<GameObject> throwOrigins = null;

    [SerializeField]
    private float minThrowForce = 4.0f;

    [SerializeField]
    private float maxThrowForce = 8.0f;

    [SerializeField]
    private HouseBook houseBook = null;

    private House currentHouse = null;
    private List<GameObject> applyOnNextUpdate = new List<GameObject>();

    public System.Action<House> OnHouseCompleted;

    private void Start()
    {
    }

    private void FixedUpdate()
    {
        foreach (GameObject go in applyOnNextUpdate)
        {
            Vector3 relative = spawnTarget.transform.position - go.transform.position;
            foreach (Rigidbody rigidbody in go.GetComponentsInChildren<Rigidbody>())
            {
                rigidbody.AddForce(relative * Random.Range(minThrowForce, maxThrowForce), ForceMode.VelocityChange);
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
                OnHouseCompleted(currentHouse);
            }
        }
        else
        {
            ThrowItem(item);
        }
    }

    public void SpawnNewRandomHouse()
    {
        SpawnNewHouse(houseList.housePrefabs[(int)Random.Range(0, houseList.housePrefabs.Count)]);
    }

    public void SpawnNewHouse(House housePrefab)
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
