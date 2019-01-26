using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class HouseBook : MonoBehaviour
{
    public Image image;
    public TextMeshProUGUI text;

    public void Fill(House house)
    {
        image.sprite = house.image;
        text.text = house.instructions;
    }
}
