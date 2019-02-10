using UnityEngine;
using System.Collections.Generic;

public class HouseBuildManager : MonoBehaviour
{
    [SerializeField]
    private HouseList houseList = null;

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
    private float hammerRange = 0.15f;

    [SerializeField]
    private float sawRange = 0.05f;

    public House currentHouse { get; private set; }
    private List<GameObject> applyOnNextUpdate = new List<GameObject>();

    public System.Action<House> OnHouseCompleted;
    public System.Action OnItemComplete;

    private void Awake()
    {
        currentHouse = null;
    }

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

    public bool ApplyItem(Item item, System.Action onItemComplete)
    {
        AudioManager.Instance?.ItemSoundPlay(item);
        if (currentHouse.IsCorrectItem(item))
        {
            if (item == Item.Hammer)
            {
                StartHammer();
                this.OnItemComplete = onItemComplete;
                return true;
            }
            else if (item == Item.Saw)
            {
                StartSaw();
                this.OnItemComplete = onItemComplete;
                return true;
            }
            else
            {
                AdvanceHouse();
                return false;
            }
        }
        else
        {
            ThrowItem(item);
            currentHouse.WrongItem();
            return false;
        }
    }

    public void SpawnNewRandomHouse()
    {
        SpawnNewHouse(houseList.housePrefabs[(int)Random.Range(0, houseList.housePrefabs.Count)]);
    }

    public void SpawnNewHouse(House housePrefab)
    {
        currentHouse = Instantiate<House>(housePrefab, spawnTarget.transform.position, Quaternion.identity, null);
    }

    private void ThrowItem(Item item)
    {
        GameObject throwOrigin = throwOrigins[(int)Random.Range(0, throwOrigins.Count)];
        GameObject itemPrefab = ItemMapper.Instance.Map(item);
        GameObject newItem = Instantiate(itemPrefab, throwOrigin.transform.position - Vector3.forward * 1.5f, Random.rotationUniform, currentHouse.transform);

        // Can't assign global scale, so we have to kind of calculate it
        newItem.transform.localScale = Vector3.one;
        newItem.transform.localScale = new Vector3(1f / newItem.transform.lossyScale.x, 1f / newItem.transform.lossyScale.y, 1f / newItem.transform.lossyScale.z);

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

    public void CheatHouseComplete(bool win)
    {
        if (win)
        {
            currentHouse.CheatHouseComplete();
        }

        OnHouseCompleted(currentHouse);
    }

    private void StartHammer()
    {
        minigameManager.minigameResultCallback = OnHammerResult;
        minigameManager.minigameEndCallback = StopHammer;
        minigameManager.StartMinigame(hammerRange, currentHouse.GetNailsNumber());

        currentHouse.StartNail(0);
    }

    public void Cancel()
    {
        minigameManager.Cancel();
    }

    private void OnHammerResult(int iteration, bool result)
    {
        currentHouse.FinishNail(result);
        if (iteration + 1 < currentHouse.GetNailsNumber())
        {
            currentHouse.StartNail(iteration + 1);
        }
        AudioManager.Instance?.HammerImpactPlay();
    }

    private void StopHammer()
    {
        OnItemComplete?.Invoke();
        OnItemComplete = null;
        AdvanceHouse();
    }

    private void StartSaw()
    {
        minigameManager.minigameResultCallback = OnSawResult;
        minigameManager.minigameEndCallback = StopSaw;
        minigameManager.StartMinigame(sawRange, 1);

        currentHouse.StartSaw();
    }

    private void OnSawResult(int iteration, bool result)
    {
        Debug.Assert(iteration == 0);
        currentHouse.DoSaw(result);
        AudioManager.Instance?.SawCutPlay();
    }

    private void StopSaw()
    {
        OnItemComplete?.Invoke();
        OnItemComplete = null;
        AdvanceHouse();
    }
}
