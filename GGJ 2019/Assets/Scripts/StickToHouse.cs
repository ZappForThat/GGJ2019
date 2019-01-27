using UnityEngine;
using System.Collections;

public class StickToHouse : MonoBehaviour
{
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.other.CompareTag("House"))
        {
            GetComponent<Rigidbody>().isKinematic = true;
        }
    }
}
