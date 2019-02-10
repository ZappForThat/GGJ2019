using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TitleHandler : MonoBehaviour
{
    private float timer;

    private void Update()
    {
        timer += Time.deltaTime;

        if (timer > 3 && Input.GetMouseButtonDown(0))
        {
            SceneManager.LoadScene("EdScene");
        }
    }
}
