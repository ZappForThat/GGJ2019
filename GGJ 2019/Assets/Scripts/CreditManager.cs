using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CreditManager : MonoBehaviour
{
    public float Speed = 20;
    public float CreditsSize = 250.0f;

    private Vector2 initialPos;
    private RectTransform rectTransform;

    private void Start()
    {
        rectTransform = transform as RectTransform;
        initialPos = rectTransform.anchoredPosition;
    }

    private void Update()
    {
        Vector2 pos = rectTransform.anchoredPosition;
        pos.y += Speed * Time.deltaTime;
        rectTransform.anchoredPosition = pos;

        if (pos.y - initialPos.y > CreditsSize)
        {
            SceneManager.LoadScene("Title");
        }

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            SceneManager.LoadScene("Title");
        }
    }
}
