using UnityEngine;
using System.Collections.Generic;

public class HouseStage : MonoBehaviour
{
    [SerializeField]
    public Item requiredItem;

    [SerializeField]
    private List<Nail> nails = new List<Nail>();

    [SerializeField]
    private GameObject sawLog = null;

    public enum Quality
    {
        None,
        Poor,
        Fine,
        Good
    }

    public void SetQuality(Quality quality)
    {
        if (quality == Quality.None)
        {
            gameObject.SetActive(false);
        }
        else
        {
            gameObject.SetActive(true);
        }
    }

    public List<Nail> GetNails()
    {
        return nails;
    }

    public GameObject GetTheLog()
    {
        return sawLog;
    }
}
