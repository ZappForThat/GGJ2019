using UnityEngine;
using UnityEngine.Playables;
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

    private void Start()
    {
        itemFlyIn.DoFlyIn(OnItemFlyInComplete);
        houseBuildManager.OnHouseCompleted = OnHouseCompleted;
        playerInput.enabled = false;
    }

    void OnItemFlyInComplete()
    {
        introPlayableDirector.paused += OnIntroPlayableComplete;
        introPlayableDirector.Play();
    }

    void OnIntroPlayableComplete(PlayableDirector director)
    {
        houseBuildManager.SpawnNewRandomHouse();
        playerInput.enabled = true;
    }

    void OnHouseCompleted(House house)
    {
        Destroy(house.gameObject);
        houseBuildManager.SpawnNewRandomHouse();
    }
}
