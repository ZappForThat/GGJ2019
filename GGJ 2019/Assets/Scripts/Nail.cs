using UnityEngine;
using System.Collections;

public class Nail : MonoBehaviour
{
    public void SetShown(bool shown)
    {
        this.gameObject.SetActive(shown);
    }

    public void Finish(bool good)
    {
        Debug.Log("Nail " + good);
        Destroy(this.gameObject);
    }
}
