using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.SceneManagement;
using System.Collections.Generic;
using System.Collections;
using Cinemachine;

public class GameManager : MonoBehaviour
{
    [System.Serializable]
    public struct Order
    {
        public PlayableDirector birdSequence;
        public House house;
    }

    [System.Serializable]
    public struct Day
    {
        public PlayableDirector dayIntro;
        public PlayableDirector dayOutro;
        public List<Order> orders;
        public List<Item> necessaryItems;
    }

    [SerializeField]
    private PlayerInput playerInput = null;

    [SerializeField]
    private HouseBuildManager houseBuildManager = null;

    [SerializeField]
    private ItemFlyIn itemFlyIn = null;

    [SerializeField]
    private PlayableDirector introPlayableDirector = null;

    [SerializeField]
    private CinemachineVirtualCamera vCamIntro;

    [SerializeField]
    private CinemachineVirtualCamera vCamAfter;

    [SerializeField]
    private int goodReactionMistakeThreshold = 3;

    [SerializeField]
    private int mediumReactionMistakeThreshold = 10;

    [SerializeField]
    private GameObject goodReactionSpawnPoint = null;

    [SerializeField]
    private GameObject mediumReactionSpawnPoint = null;

    [SerializeField]
    private GameObject badReactionSpawnPoint = null;

    [SerializeField]
    private GameObject goodReactionPrefab = null;

    [SerializeField]
    private GameObject mediumReactionPrefab = null;

    [SerializeField]
    private GameObject badReactionPrefab = null;

    [SerializeField]
    private List<Day> days;

    [SerializeField]
    private float timePerOrder;

    [SerializeField]
    private GameTimer timer;

    [SerializeField]
    private PlayableDirector endCinematic;

    private List<House> completedHouses = new List<House>();
    private int dayIndex = 0;
    private int orderIndex = 0;

    private void Start()
    {
        houseBuildManager.OnHouseCompleted = (x) => OnHouseCompleted(x, false);
        playerInput.enabled = false;

        Debug.Assert(days.Count > 0);
        StartDay();
    }

    void StartDay()
    {
        days[dayIndex].dayIntro.stopped += OnDayIntroComplete;
        days[dayIndex].dayIntro.Play();
        RandomizeCabinets();
    }
    
    private static System.Random rng = new System.Random();
    public static void Shuffle<T>(IList<T> list)  
    {  
        int n = list.Count;  
        while (n > 1) {  
            n--;  
            int k = rng.Next(n + 1);  
            T value = list[k];  
            list[k] = list[n];  
            list[n] = value;  
        }  
    }

    void RandomizeCabinets()
    {
        Cabinet[] cabinets = FindObjectsOfType<Cabinet>();
        Shuffle(cabinets);
        for (int i = 0; i < cabinets.Length; i++)
        {
            if (i < days[dayIndex].necessaryItems.Count)
            {
                cabinets[i].SetItem(days[dayIndex].necessaryItems[i]);
            }
            else
            {
                var values = System.Enum.GetValues(typeof(Item));
                Item randomItem = (Item)values.GetValue((int)Random.Range(0, values.Length));
                cabinets[i].SetItem(randomItem);
            }
        }
    }

    void OnDayIntroComplete(PlayableDirector playableDirector)
    {
        itemFlyIn.DoFlyIn(StartOrder);
    }

    void StartOrder()
    {
        Day day = days[dayIndex];
        Order order = day.orders[orderIndex];
        order.birdSequence.stopped += OnBirdSequenceComplete;
        order.birdSequence.Play();
        timer.SetShown(true);
    }

    void OnBirdSequenceComplete(PlayableDirector director)
    {
        Day day = days[dayIndex];
        Order order = day.orders[orderIndex];

        vCamIntro.enabled = false;
        vCamAfter.enabled = true;
        houseBuildManager.SpawnNewHouse(order.house);
        playerInput.enabled = true;

        timer.OnTimerCompleted = () => OnHouseCompleted(order.house, true);
        timer.StartTimer(timePerOrder);
    }

    void OnHouseCompleted(House house, bool timeRanOut)
    {
        StartCoroutine(HouseCompletionCoroutine(house, false));
    }

    IEnumerator HouseCompletionCoroutine(House house, bool timeRanOut)
    {
        timer.StopTimer();
        timer.OnTimerCompleted = null;

        playerInput.enabled = false;
        foreach (Rigidbody rigidbody in house.gameObject.GetComponentsInChildren<Rigidbody>())
        {
            rigidbody.isKinematic = true;
        }

        GameObject location = null;
        GameObject prefab = null;
        if (!house.IsComplete() || timeRanOut)
        {
            // Timer ran out
            location = badReactionSpawnPoint;
            prefab = badReactionPrefab;
        }
        else if (house.mistakes < goodReactionMistakeThreshold)
        {
            location = goodReactionSpawnPoint;
            prefab = goodReactionPrefab;
        }
        else if (house.mistakes < mediumReactionMistakeThreshold)
        {
            location = mediumReactionSpawnPoint;
            prefab = mediumReactionPrefab;
        }
        else
        {
            location = badReactionSpawnPoint;
            prefab = badReactionPrefab;
        }

        Instantiate(prefab, location.transform.position, location.transform.rotation, null);

        yield return new WaitForSeconds(3f);

        float startTime = Time.time;
        float animTime = 1f;
        Vector3 initial = house.transform.position;
        Vector3 target = initial + (-Vector3.right * 10.0f);
        while (Time.time - startTime < animTime)
        {
            house.transform.position = Util.EaseInOut(initial, target, Time.time - startTime, animTime);
            yield return null;
        }

        house.gameObject.SetActive(false);
        completedHouses.Add(house);

        orderIndex++;
        if (orderIndex >= days[dayIndex].orders.Count)
        {
            NextDay();
        }
        else
        {
            StartOrder();
        }
    }

    void NextDay()
    {
        days[dayIndex].dayOutro.stopped += OutroFinished;
        days[dayIndex].dayOutro.Play();
    }

    void OutroFinished(PlayableDirector playableDirector)
    {
        dayIndex++;
        orderIndex = 0;
        if (dayIndex >= days.Count)
        {
            endCinematic.stopped += OnTotallyEnd;
            endCinematic.Play();
        }
        else
        {
            StartDay();
        }
    }

    void OnTotallyEnd(PlayableDirector playableDirector)
    {
        SceneManager.LoadScene("Credits");
    }
}
