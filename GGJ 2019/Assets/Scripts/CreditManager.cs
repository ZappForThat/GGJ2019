using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CreditManager : MonoBehaviour
{
    public float Speed = 20;
    public float CreditsSize = 250.0f;

    private float pos;

    private void Start()
    {
    }

    private void Update()
    {
        pos += Speed * Time.deltaTime;
        transform.Translate(new Vector3(0, Speed * Time.deltaTime));

        if (pos > CreditsSize)
        {
            SceneManager.LoadScene("Title");
        }

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            SceneManager.LoadScene("Title");
        }
    }
}
