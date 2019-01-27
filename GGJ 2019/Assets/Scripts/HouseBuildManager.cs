using UnityEngine;
using System.Collections.Generic;

public class HouseBuildManager : MonoBehaviour
{
    [SerializeField]
    private HouseList houseList = null;

    [SerializeField]
    private PlayerInput playerInput = null;

    [SerializeField]
    private MinigameManager minigameManager = null;

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

    [SerializeField]
    private float hammerRange = 0.15f;

    [SerializeField]
    private float sawRange = 0.05f;

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
            if (item == Item.Hammer)
            {
                StartHammer();
            }
            else if (item == Item.Saw)
            {
                StartSaw();
            }
            else
            {
                AdvanceHouse();
            }
        }
        else
        {
            ThrowItem(item);
            currentHouse.WrongItem();
        }
    }

    public void SpawnNewRandomHouse()
    {
        SpawnNewHouse(houseList.housePrefabs[(int)Random.Range(0, houseList.housePrefabs.Count)]);
    }

    public void SpawnNewHouse(House housePrefab)
    {
        currentHouse = Instantiate<House>(housePrefab, spawnTarget.transform.position, Quaternion.identity, null);
        houseBook.Fill(currentHouse);
    }

    private void ThrowItem(Item item)
    {
        GameObject throwOrigin = throwOrigins[(int)Random.Range(0, throwOrigins.Count)];
        GameObject itemPrefab = ItemMapper.Instance.Map(item);
        GameObject newItem = Instantiate(itemPrefab, throwOrigin.transform.position - Vector3.forward * 1.5f, Random.rotationUniform, currentHouse.transform);
        applyOnNextUpdate.Add(newItem);
    }

    private void AdvanceHouse()
    {
        currentHouse.AdvanceHouse();
        if (currentHouse.IsComplete())
        {
            OnHouseCompleted(currentHouse);
        }
    }

    public void CheatHouseComplete()
    {
        OnHouseCompleted(currentHouse);
    }

    private void StartHammer()
    {
        playerInput.enabled = false;
        minigameManager.minigameResultCallback = OnHammerResult;
        minigameManager.minigameEndCallback = StopHammer;
        minigameManager.StartMinigame(hammerRange, currentHouse.GetNailsNumber());

        currentHouse.StartNail(0);
    }

    private void OnHammerResult(int iteration, bool result)
    {
        currentHouse.FinishNail(result);
        if (iteration + 1 < currentHouse.GetNailsNumber())
        {
            currentHouse.StartNail(iteration + 1);
        }
    }

    private void StopHammer()
    {
        playerInput.enabled = true;
        AdvanceHouse();
    }

    private void StartSaw()
    {
        playerInput.enabled = false;
        minigameManager.minigameResultCallback = OnSawResult;
        minigameManager.minigameEndCallback = StopSaw;
        minigameManager.StartMinigame(sawRange, 1);
    }

    private void OnSawResult(int iteration, bool result)
    {
        Debug.Assert(iteration == 0);
        currentHouse.DoSaw(result);
    }

    private void StopSaw()
    {
        playerInput.enabled = true;
        AdvanceHouse();
    }
}
