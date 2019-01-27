using UnityEngine;
using System.Collections;

public class StickToHouse : MonoBehaviour
{
    private void OnCollisionEnter(Collision collision)
    {
        if (HasHouseInHierarchy(collision.transform))
        {
            GetComponent<Rigidbody>().isKinematic = true;
        }
    }

    private bool HasHouseInHierarchy(Transform transform)
    {
        return transform.CompareTag("House") || HasHouseInHierarchy(transform.parent);
    }
}
