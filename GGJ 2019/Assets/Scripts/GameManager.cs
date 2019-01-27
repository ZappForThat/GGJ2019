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
    private ParticleExpires goodReaction = null;

    [SerializeField]
    private ParticleExpires mediumReaction = null;

    [SerializeField]
    private ParticleExpires badReaction = null;

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

        if (house.mistakes < goodReactionMistakeThreshold)
        {
            goodReaction.Play();
        }
        else if (house.mistakes < mediumReactionMistakeThreshold)
        {
            mediumReaction.Play();
        }
        else
        {
            badReaction.Play();
        }

        yield return new WaitForSeconds(1.0f);
    }
}
