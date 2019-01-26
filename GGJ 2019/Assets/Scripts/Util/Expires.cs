using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Expires : MonoBehaviour
{
    public float expiryTime;

    void Start()
    {
        StartCoroutine(ExpireCoroutine());
    }

    IEnumerator ExpireCoroutine()
    {
        yield return new WaitForSeconds(expiryTime);
        Destroy(gameObject);
    }
}
