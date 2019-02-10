using UnityEngine;
using System.Collections.Generic;

public class House : MonoBehaviour
{
    [SerializeField]
    public Sprite image = null;

    [SerializeField]
    public GameObject completionParticles;

    private List<HouseStage> stages = new List<HouseStage>();
    private int currentStage = 0;
    private Nail nail;
    public int mistakes { get; private set; }

    private void Awake()
    {
        mistakes = 0;

        List<HouseStage> allStages = new List<HouseStage>();
        GetAllStages(this.transform, allStages);
        foreach (HouseStage stage in allStages)
        {
            int index = stage.transform.GetSiblingIndex();
            while (index >= stages.Count)
            {
                stages.Add(null);
            }

            HouseStage alreadyExisting = stages[index];
            if (alreadyExisting != null)
            {
                Debug.LogError("THIS IS NOT GOOD, PLEASE CHECK FOR GRANDCHILD HOUSESTAGES", this);
            }

            stages[index] = stage;
        }
    }

    private void GetAllStages(Transform transform, List<HouseStage> stages)
    {
        foreach (Transform child in transform)
        {
            HouseStage houseStage = child.GetComponent<HouseStage>();
            if (houseStage != null)
            {
                stages.Add(houseStage);
            }
            GetAllStages(child, stages);
        }
    }

    private void Start()
    {
        foreach (HouseStage stage in stages)
        {
            stage?.SetQuality(HouseStage.Quality.None);
            foreach (Nail nail in stage?.GetNails())
            {
                nail.SetShown(false);
            }
        }
    }

    private int GetLevel(Transform transform, int index)
    {
        Debug.Assert(transform != null);
        if (transform.parent == this.transform)
        {
            return index;
        }

        index++;
        return GetLevel(transform.parent, index);
    }

    public bool IsCorrectItem(Item item)
    {
        if (currentStage < 0 || currentStage >= stages.Count)
        {
            return false;
        }

        return stages[currentStage].requiredItem == item;
    }

    public void WrongItem()
    {
        mistakes++;
    }

    public void StartNail(int index)
    {
        List<Nail> nailLocations = stages[currentStage].GetNails();
        Debug.Assert(nailLocations != null && index < nailLocations.Count);
        nailLocations[index].SetShown(true);
        this.nail = nailLocations[index];
    }

    public void FinishNail(bool good, System.Action OnComplete)
    {
        Debug.Assert(nail != null);
        nail.Finish(good, OnComplete);
    }

    public void StartSaw()
    {
        stages[currentStage].GetTheLog().GetComponent<Nail>().SetShown(true);
    }

    public void DoSaw(bool good, System.Action OnComplete)
    {
        //stages[currentStage].GetTheLog().gameObject.SetActive(false);
        // HELL YEAH IT'S JANK
        stages[currentStage].GetTheLog().GetComponent<Nail>().Finish(good, OnComplete);
    }

    public int GetNailsNumber()
    {
        return stages[currentStage].GetNails().Count;
    }

    public void AdvanceHouse()
    {
        Debug.Assert(currentStage >= 0 && currentStage < stages.Count, currentStage + " " + stages.Count);
        HouseStage stage = stages[currentStage];
        stage?.SetQuality(HouseStage.Quality.Good);
        currentStage++;
        Instantiate(completionParticles, stage.transform.position, stage.transform.rotation, null);
    }

    public bool IsComplete()
    {
        return currentStage >= stages.Count;
    }

    public void CheatHouseComplete()
    {
        currentStage = stages.Count;
    }

    public List<Item> GetItemList()
    {
        List<Item> items = new List<Item>();
        foreach (HouseStage stage in stages)
        {
            items.Add(stage.requiredItem);
        }
        return items;
    }
}
