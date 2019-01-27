using UnityEngine;
using System.Collections;

public class HouseDisplay : MonoBehaviour
{
    [SerializeField]
    private GameObject housePivot;

    [SerializeField]
    private GameObject birdLocation;

    public void Fill(House house, Bird bird)
    {
        house.transform.parent = housePivot.transform;
        house.transform.localPosition = Vector3.zero;
        house.transform.localRotation = Quaternion.identity;

        bird.transform.parent = birdLocation.transform;
        bird.transform.localPosition = Vector3.zero;
        bird.transform.localRotation = Quaternion.identity;
    }
}
