using UnityEngine;
using UnityEngine.Playables;
using System.Collections.Generic;
using System.Collections;
using Cinemachine;

public class GameManager : MonoBehaviour
{
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
    private GameObject reactionSpawnLocation;

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

    private List<House> completedHouses = new List<House>();

    private void Start()
    {
        itemFlyIn.DoFlyIn(OnItemFlyInComplete);
        houseBuildManager.OnHouseCompleted = OnHouseCompleted;
        playerInput.enabled = false;
    }

    void OnItemFlyInComplete()
    {
        vCamIntro.enabled = false;
        vCamAfter.enabled = true;
        introPlayableDirector.stopped += OnIntroPlayableComplete;
        introPlayableDirector.Play();

        AudioManager.Instance?.BuildingMusicPlay();
    }

    void OnIntroPlayableComplete(PlayableDirector director)
    {
        houseBuildManager.SpawnNewRandomHouse();
        playerInput.enabled = true;
    }

    void OnHouseCompleted(House house)
    {
        StartCoroutine(HouseCompletionCoroutine(house));
    }

    IEnumerator HouseCompletionCoroutine(House house)
    {
        playerInput.enabled = false;
        foreach (Rigidbody rigidbody in house.gameObject.GetComponentsInChildren<Rigidbody>())
        {
            rigidbody.isKinematic = true;
        }

        GameObject location = null;
        GameObject prefab = null;
        if (house.mistakes < goodReactionMistakeThreshold)
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

        playerInput.enabled = true;
        house.gameObject.SetActive(false);
        completedHouses.Add(house);

        houseBuildManager.SpawnNewRandomHouse();
    }
}
