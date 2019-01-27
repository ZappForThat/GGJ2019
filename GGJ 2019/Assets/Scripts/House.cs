using UnityEngine;
using System.Collections.Generic;

public class House : MonoBehaviour
{
    [SerializeField]
    [TextArea(4, 10)]
    public string instructions = "";

    [SerializeField]
    public Sprite image = null;

    private List<HouseStage> stages = new List<HouseStage>();
    private int currentStage = 0;
    private Nail nail;

    private void Start()
    {
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
                Debug.LogError("THIS IS NOT GOOD, PLEASE CHECK FOR GRANDCHILD HOUSESTAGES", alreadyExisting);
            }

            stages[index] = stage;
        }

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

    public void DoSaw(bool good)
    {
        if (good)
        {
            stages[currentStage].GetTheLog().gameObject.SetActive(false);
        }
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
    }

    public bool IsComplete()
    {
        return currentStage >= stages.Count;
    }
}
