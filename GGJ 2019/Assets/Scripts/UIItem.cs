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

    [SerializeField]
    private Image image;

    public void Fill(Item item)
    {
        if (text != null)
        {
            text.text = item.ToString();
        }

        if (image != null)
        {
            image.sprite = ItemImageMapper.Instance.Map(item);
        }
    }
}
