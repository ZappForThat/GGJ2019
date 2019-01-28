using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FadeIn : MonoBehaviour
{
    public Image Image;
    public Text Text;
    public float Duration = 3;
    public float Offset = 0;
    private float timer = 0;

    void Start()
    {
        timer = -Offset;
        if (Image)
        {
            Image.color = new Color(Image.color.r, Image.color.g, Image.color.b, 0);
        }
        if (Text)
        {
            Text.color = new Color(Text.color.r, Text.color.g, Text.color.b, 0);
        }
    }
    
    void Update()
    {
        timer += Time.deltaTime;
        float thing = timer > 0 ? timer : 0;
        if (Image)
        {
            Image.color = new Color(Image.color.r, Image.color.g, Image.color.b, thing / Duration);
        }
        if (Text)
        {
            Text.color = new Color(Text.color.r, Text.color.g, Text.color.b, thing/Duration);
        }
    }
}
