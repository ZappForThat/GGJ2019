using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;

public class GameTimer : MonoBehaviour
{
    [SerializeField]
    private Text text;

    [SerializeField]
    private CanvasGroup canvasGroup;

    private float startTime = 0f;
    private float duration = 0f;
    private bool on = false;

    public System.Action OnTimerCompleted;

    private void Awake()
    {
        UIUtil.SetCanvasGroupShown(canvasGroup, false);
    }

    public void SetShown(bool shown)
    {
        UIUtil.SetCanvasGroupShown(canvasGroup, shown);
    }

    public void StartTimer(float time)
    {
        duration = time;
        startTime = Time.time;
        on = true;
    }

    public void StopTimer()
    {
        on = false;
    }

    private void Update()
    {
        if (!on)
        {
            return;
        }

        float timeLeft = Mathf.Max(duration - (Time.time - startTime), 0f);
        text.text = string.Format("{0:0.0}", timeLeft);

        if (timeLeft <= 0f && on)
        {
            on = false;
            OnTimerCompleted?.Invoke();
        }
    }
}
