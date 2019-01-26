using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class UIItem : MonoBehaviour
{
    [SerializeField]
    public RectTransform rectTransform;

    [SerializeField]
    public CanvasGroup canvasGroup;

    [SerializeField]
    private Text text;

    public void Fill(Item item)
    {
        text.text = item.ToString();
    }
}
