using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using System.Collections;

public class ItemFlyIn : MonoBehaviour
{
    [SerializeField]
    private Canvas canvas = null;

    [SerializeField]
    private RectTransform container = null;

    [SerializeField]
    private UIItem itemPrefab = null;

    [SerializeField]
    private float delayBetween = 0.25f;

    [SerializeField]
    private float fadeInTime = 0.1f;

    [SerializeField]
    private float flyInTime = 0.5f;

    public void DoFlyIn(System.Action onComplete)
    {
        StartCoroutine(FlyInCoroutine(FindObjectsOfType<Cabinet>(), onComplete));
    }

    public struct SingleFlyIn
    {
        public UIItem item;
        public float delay;
        public float fadeInTime;
        public float flyInTime;
        public Vector3 target;

        private Vector3 initialPosition;
        public bool isDone { get; private set; }

        public void Start()
        {
            initialPosition = item.rectTransform.position;
            isDone = false;
        }

        public void Update(float time)
        {
            if (time < delay)
            {
                item.canvasGroup.alpha = 0f;
            }
            else if ((time - delay) < fadeInTime)
            {
                item.canvasGroup.alpha = ((time - delay) - fadeInTime) / fadeInTime;
            }
            else if ((time - delay - fadeInTime) < flyInTime)
            {
                item.canvasGroup.alpha = 1f;
                item.rectTransform.position = Util.EaseInOut(initialPosition, target, time - delay - fadeInTime, flyInTime);
            }
            else
            {
                item.canvasGroup.alpha = 1f;
                item.rectTransform.position = target;
                isDone = true;
            }
        }
    }

    IEnumerator FlyInCoroutine(IList<Cabinet> cabinets, System.Action onComplete)
    {
        List<SingleFlyIn> flyIns = new List<SingleFlyIn>();
        Vector2 spawnPosition = (canvas.transform as RectTransform).rect.center;
        for (int i = 0; i <cabinets.Count; i++)
        {
            UIItem item = Instantiate<UIItem>(itemPrefab, canvas.transform, false);
            item.transform.position = UIUtil.ScreenToCanvas(canvas, new Vector3(Screen.width / 2f, Screen.height/2f, 0f));
            item.Fill(cabinets[i].item);

            SingleFlyIn flyIn = new SingleFlyIn {
                delay = i * delayBetween,
                fadeInTime = fadeInTime,
                flyInTime = flyInTime,
                item = item,
                target = UIUtil.WorldToCanvas(canvas, cabinets[i].transform.position)
            };

            flyIn.Start();
            flyIns.Add(flyIn);
        }

        float startTime = Time.time;
        bool allDone = false;
        while (!allDone)
        {
            allDone = true;
            float time = Time.time - startTime;
            foreach (SingleFlyIn flyIn in flyIns)
            {
                flyIn.Update(time);
                allDone = allDone && flyIn.isDone;
            }
            yield return null;
        }

        while (!Input.anyKeyDown)
        {
            yield return null;
        }

        foreach (SingleFlyIn flyIn in flyIns)
        {
            Destroy(flyIn.item.gameObject);
        }

        onComplete();
    }
}
