using UnityEngine;
using System.Collections;

public class HouseStage : MonoBehaviour
{
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

    //public GameObject GetNailLocations()
    //{
    //}
}
