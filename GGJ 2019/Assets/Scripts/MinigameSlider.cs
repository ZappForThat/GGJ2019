using UnityEngine;
using UnityEngine.UI;

public class MinigameSlider : MonoBehaviour
{
    public float speed = 1.0f;
    public RectTransform sweetSpot;
    public CanvasGroup canvasGroup;
    public Animator animator;
    private Slider slider;

    private float sweetSpotCenter = 0f;
    private float sweetSpotRange = 0f;

    private bool go;

    private void Awake()
    {
        slider = GetComponent<Slider>();
    }

    public void SetShown(bool shown)
    {
        UIUtil.SetCanvasGroupShown(canvasGroup, shown);
    }

    public void Restart()
    {
        go = true;
        slider.value = 0f;
    }

    private void Update()
    {
        if (!go)
        {
            return;
        }

        slider.value += Time.deltaTime * speed;
        if (slider.value >= slider.maxValue)
        {
            slider.value = slider.value - slider.maxValue;
        }
    }

    public void ConfigureSweetSpot(float center, float range)
    {
        this.sweetSpotRange = range;
        this.sweetSpotCenter = center;

        // 1.9 to give it a tiny bit of fudge, 2.0 would actually be accurate
        float size = (slider.transform as RectTransform).sizeDelta.x * range * 1.9f;
        sweetSpot.anchoredPosition = new Vector2((slider.transform as RectTransform).sizeDelta.x * center, 0f);
        sweetSpot.sizeDelta = new Vector2(size, sweetSpot.sizeDelta.y);
    }

    public bool IsInSweetSpot()
    {
        return slider.value >= sweetSpotCenter - sweetSpotRange && slider.value <= sweetSpotCenter + sweetSpotRange;
    }

    public void DoWinOrLose(bool win)
    {
        go = false;
        animator.SetBool("Win", win);
        animator.SetBool("Lose", !win);
        Util.ExecuteAfter(0.5f, this, () =>
        {
            animator.SetBool("Win", false);
            animator.SetBool("Lose", false);
        });
    }
}
