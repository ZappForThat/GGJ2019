using UnityEngine;
using System.Collections.Generic;

public class House : MonoBehaviour
{
    [System.Serializable]
    public struct Action
    {
        public Item requiredItem;
        public HouseStage stage;
    }

    [SerializeField]
    [TextArea(4, 10)]
    public string instructions = "";

    [SerializeField]
    public Sprite image = null;

    [SerializeField]
    public List<Action> actions = new List<Action>();

    private int currentAction = 0;

    private void Start()
    {
        foreach (Action action in actions)
        {
            action.stage?.SetQuality(HouseStage.Quality.None);
        }
    }

    public bool IsCorrectItem(Item item)
    {
        Debug.Assert(currentAction >= 0 && currentAction < actions.Count, currentAction + " " + actions.Count);
        return actions[currentAction].requiredItem == item;
    }

    public void AdvanceHouse()
    {
        Debug.Assert(currentAction >= 0 && currentAction < actions.Count, currentAction + " " + actions.Count);
        Action action = actions[currentAction];
        action.stage?.SetQuality(HouseStage.Quality.Good);
        currentAction++;
    }

    public bool IsComplete()
    {
        return currentAction >= actions.Count;
    }
}
