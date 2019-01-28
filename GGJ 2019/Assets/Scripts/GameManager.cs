using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.SceneManagement;
using System.Collections.Generic;
using System.Collections;
using Cinemachine;

public class GameManager : MonoBehaviour
{
    [System.Serializable]
    public class Order
    {
        public PlayableDirector birdSequence;
        public House house;
        public HouseDisplay houseDisplay;
        public Bird bird;
        public float time = 60.0f;
    }

    [System.Serializable]
    public class Day
    {
        public PlayableDirector dayIntro;
        public PlayableDirector dayOutro;
        public List<Order> orders;
        public List<Item> necessaryItems;
        public bool extraCabinets;
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
    private GameTimer timer;

    [SerializeField]
    private PlayableDirector endCinematic;

    [SerializeField]
    private GameObject extraCabinets;

    private PlayableDirector currentCinematic;
    private int dayIndex = 0;
    private int orderIndex = 0;

    private void Start()
    {
        houseBuildManager.OnHouseCompleted = (x) => OnHouseCompleted(x, false);
        playerInput.enabled = false;

        Debug.Assert(days.Count > 0);
        StartDay();
    }

    private void Update()
    {
        if (currentCinematic != null && currentCinematic.state == PlayState.Playing && Input.GetKeyDown(KeyCode.Escape))
        {
            currentCinematic.time = currentCinematic.duration;
            currentCinematic.Evaluate();
        }
    }

    void StartDay()
    {
        vCamIntro.enabled = true;
        vCamAfter.enabled = false;

        extraCabinets.gameObject.SetActive(days[dayIndex].extraCabinets);

        days[dayIndex].dayIntro.stopped += OnDayIntroComplete;
        days[dayIndex].dayIntro.Play();
        currentCinematic = days[dayIndex].dayIntro;
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

    private static List<Item> jokeItems = new List<Item> { Item.Brick, Item.Egg, Item.Fish, Item.FidgetSpinner };
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
                Item randomJunkItem = jokeItems[(int)Random.Range(0, jokeItems.Count)];
                cabinets[i].SetItem(randomJunkItem);
            }
        }
    }

    void OnDayIntroComplete(PlayableDirector playableDirector)
    {
        days[dayIndex].dayIntro.stopped -= OnDayIntroComplete;
        currentCinematic = null;
        itemFlyIn.DoFlyIn(StartOrder);

        AudioManager.Instance?.BirdChirpPlay();
    }

    void StartOrder()
    {
        Day day = days[dayIndex];
        Order order = day.orders[orderIndex];
        order.birdSequence.stopped += OnBirdSequenceComplete;
        order.birdSequence.Play();
        currentCinematic = order.birdSequence;
    }

    void OnBirdSequenceComplete(PlayableDirector director)
    {
        Day day = days[dayIndex];
        Order order = day.orders[orderIndex];
        order.birdSequence.stopped -= OnBirdSequenceComplete;

        currentCinematic = null;
        houseBuildManager.SpawnNewHouse(order.house);
        playerInput.enabled = true;

        vCamIntro.enabled = false;
        vCamAfter.enabled = true;

        timer.SetShown(true);
        timer.OnTimerCompleted = () => OnHouseCompleted(houseBuildManager.currentHouse, true);
        timer.StartTimer(order.time);
    }

    void OnHouseCompleted(House house, bool timeRanOut)
    {
        StartCoroutine(HouseCompletionCoroutine(house, timeRanOut));
    }

    IEnumerator HouseCompletionCoroutine(House house, bool timeRanOut)
    {
        timer.SetShown(false);
        timer.StopTimer();
        timer.OnTimerCompleted = null;

        playerInput.enabled = false;
        foreach (Rigidbody rigidbody in house.gameObject.GetComponentsInChildren<Rigidbody>())
        {
            rigidbody.isKinematic = true;
        }

        GameObject location = null;
        GameObject prefab = null;
        float result = 0;
        if (!house.IsComplete() || timeRanOut)
        {
            // Timer ran out
            location = badReactionSpawnPoint;
            prefab = badReactionPrefab;
            result = -1f;
        }
        else if (house.mistakes < goodReactionMistakeThreshold)
        {
            location = goodReactionSpawnPoint;
            prefab = goodReactionPrefab;
            result = 1f;
        }
        else if (house.mistakes < mediumReactionMistakeThreshold)
        {
            location = mediumReactionSpawnPoint;
            prefab = mediumReactionPrefab;
            result = 0f;
        }
        else
        {
            location = badReactionSpawnPoint;
            prefab = badReactionPrefab;
            result = -1f;
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

        days[dayIndex].orders[orderIndex].bird.SetReaction(result);
        days[dayIndex].orders[orderIndex].houseDisplay.Fill(house, days[dayIndex].orders[orderIndex].bird);

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
        currentCinematic = days[dayIndex].dayIntro;
        
        AudioManager.Instance?.ShopMusicPlay();
    }

    void OutroFinished(PlayableDirector playableDirector)
    {
        days[dayIndex].dayOutro.stopped -= OutroFinished;
        currentCinematic = null;

        dayIndex++;
        orderIndex = 0;
        if (dayIndex >= days.Count)
        {
            endCinematic.stopped += OnTotallyEnd;
            endCinematic.Play();
            currentCinematic = endCinematic;
        }
        else
        {
            StartDay();
        }
    }

    void OnTotallyEnd(PlayableDirector playableDirector)
    {
        endCinematic.stopped -= OnTotallyEnd;
        currentCinematic = null;
        SceneManager.LoadScene("Credits");
    }
}
