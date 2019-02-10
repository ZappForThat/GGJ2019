using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIUtil
{
    public static void SetCanvasGroupShown(CanvasGroup canvasGroup, bool shown)
    {
        if (canvasGroup == null)
        {
            return;
        }

        canvasGroup.alpha = shown ? 1.0f : 0.0f;
        canvasGroup.interactable = shown;
        canvasGroup.blocksRaycasts = shown;
    }

    public static List<Dropdown.OptionData> ToOptionData<T>(IList<T> things)
    {
        List<Dropdown.OptionData> options = new List<Dropdown.OptionData>(things.Count);
        for (int i = 0; i < things.Count; i++)
        {
            Dropdown.OptionData option = new Dropdown.OptionData(things[i].ToString());
            options.Add(option);
        }
        return options;
    }

    public static Vector3 WorldToCanvas(Canvas canvas, Vector3 worldPosition)
    {
        Vector2 screenPosition = Camera.main.WorldToScreenPoint(worldPosition);
        return ScreenToCanvas(canvas, screenPosition);
    }

    public static Vector3 ScreenToCanvas(Canvas canvas, Vector3 screenPosition)
    {
        RectTransform canvasRectTransform = canvas.transform as RectTransform;
        Vector2 normalizedScreenPosition = screenPosition / new Vector2(Screen.width, Screen.height);
        Vector2 proportionalPosition = new Vector2(normalizedScreenPosition.x * canvasRectTransform.sizeDelta.x * canvas.scaleFactor,
            normalizedScreenPosition.y * canvasRectTransform.sizeDelta.y * canvas.scaleFactor);
        return proportionalPosition;
    }
}
