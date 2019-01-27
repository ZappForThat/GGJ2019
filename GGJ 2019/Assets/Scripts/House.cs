using UnityEngine;
using System.Collections.Generic;

public class House : MonoBehaviour
{
    [SerializeField]
    [TextArea(4, 10)]
    public string instructions = "";

    [SerializeField]
    public Sprite image = null;

    [SerializeField]
    public GameObject completionParticles;

    private List<HouseStage> stages = null;
    private int currentStage = 0;
    private Nail nail;
    public int mistakes { get; private set; }

    private void Awake()
    {
        mistakes = 0;

        stages = new List<HouseStage>();
        foreach (HouseStage stage in FindObjectsOfType<HouseStage>())
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
        Debug.Assert(currentStage >= 0 && currentStage < stages.Count, currentStage + " " + stages.Count);
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

    public void FinishNail(bool good)
    {
        Debug.Assert(nail != null);
        nail.Finish(good);
    }

    public void StartSaw()
    {
        stages[currentStage].GetTheLog().GetComponent<Nail>().SetShown(true);
    }

    public void DoSaw(bool good)
    {
        //stages[currentStage].GetTheLog().gameObject.SetActive(false);
        // HELL YEAH IT'S JANK
        stages[currentStage].GetTheLog().GetComponent<Nail>().Finish(good);
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
