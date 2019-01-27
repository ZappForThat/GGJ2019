using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreditManager : MonoBehaviour
{
    public Credit[] Credits { get; private set; }
    public float Speed = 20;
    public float Spacing = 80;

    private void Start()
    {
        Credits = GetComponentsInChildren<Credit>();
        OrganizeCredits();
    }

    private void Update()
    {
        transform.Translate(new Vector3(0, Speed * Time.deltaTime));
    }

    private void OrganizeCredits()
    {
        float i = 0;
        foreach (Credit credit in Credits)
        {
            credit.transform.Translate(new Vector3(0, i));
            i -= Spacing;
        }
    }
}
