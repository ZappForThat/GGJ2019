using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleExpires : MonoBehaviour
{
    private ParticleSystem particleSystem;
    public float expiryTime;

    void Start()
    {
        particleSystem = GetComponent<ParticleSystem>();
        StartCoroutine(ExpireCoroutine());
    }

    public void Play()
    {
        particleSystem.Play();
        StartCoroutine(ExpireCoroutine());
    }

    IEnumerator ExpireCoroutine()
    {
        yield return new WaitForSeconds(expiryTime);
        var emission = particleSystem.emission;
        emission.enabled = false;
        particleSystem.Stop();
    }
}
