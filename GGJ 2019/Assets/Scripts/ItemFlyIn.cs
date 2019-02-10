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

    private Coroutine coroutine = null;
    private List<SingleFlyIn> flyIns = new List<SingleFlyIn>();
    private System.Action onComplete;

    public void DoFlyIn(System.Action onComplete)
    {
        if (coroutine != null)
        {
            Debug.LogWarning("Replacing currently fly-in", this);
        }

        coroutine = StartCoroutine(FlyInCoroutine(FindObjectsOfType<Cabinet>(), onComplete));
    }

    public void CancelFlyIn()
    {
        if (!IsInProgress())
        {
            Debug.LogError("Tried to cancel not-in-progress flyin", this);
            return;
        }

        StopCoroutine(coroutine);
        FlyInComplete();
    }

    public bool IsInProgress()
    {
        return coroutine != null;
    }

    public class SingleFlyIn
    {
        public UIItem item;
        public float delay;
        public float fadeInTime;
        public float flyInTime;
        public Vector3 target;
        public GameObject targetObj;

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
        flyIns.Clear();
        this.onComplete = onComplete;

        Vector2 spawnPosition = (canvas.transform as RectTransform).rect.center;
        foreach (Cabinet cabinet in cabinets)
        {
            UIItem item = Instantiate<UIItem>(itemPrefab, canvas.transform, false);
            item.transform.position = UIUtil.ScreenToCanvas(canvas, new Vector3(Screen.width * 0.75f, Screen.height * 0.5f, 0f));
            item.Fill(cabinet.GetItem());
            SingleFlyIn flyIn = new SingleFlyIn {
                //delay = i * delayBetween,
                fadeInTime = fadeInTime,
                flyInTime = flyInTime,
                item = item,
                target = UIUtil.WorldToCanvas(canvas, cabinet.transform.position),
                targetObj = cabinet.gameObject
            };
            flyIns.Add(flyIn);
        }

        flyIns.Sort((x, y) =>
        {
            if (x.targetObj.transform.position.y == y.targetObj.transform.position.y)
            {
                return x.targetObj.transform.position.x.CompareTo(y.targetObj.transform.position.x);
            }
            return y.targetObj.transform.position.y.CompareTo(x.targetObj.transform.position.y);
        });

        for (int i = 0; i < flyIns.Count; i++)
        {
            flyIns[i].delay = i * delayBetween;
            flyIns[i].Start();
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

        FlyInComplete();
    }

    private void FlyInComplete()
    {
        foreach (SingleFlyIn flyIn in flyIns)
        {
            Destroy(flyIn.item.gameObject);
        }

        onComplete?.Invoke();

        coroutine = null;
        onComplete = null;
    }
}
