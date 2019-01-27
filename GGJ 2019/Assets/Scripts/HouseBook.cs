using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections.Generic;

public class HouseBook : MonoBehaviour
{
    public Image image;
    public TextMeshProUGUI text;
    public VerticalLayoutGroup layout { get; private set; }
    public Text exampleText;
    public Image InstructionsPage;

    private void Awake()
    {
        layout = GetComponent<VerticalLayoutGroup>();
    }

    public void Fill(House house)
    {
        image.sprite = house.image;
        List<Item> items = house.GetItemList();

        items.Add(Item.Log);
        items.Add(Item.Hammer);
        items.Add(Item.Nail);
        items.Add(Item.Plank);
        items.Add(Item.Saw);

        foreach (Item item in items)
        {
            CreateText(item);
        }
    }

    private void CreateText(Item item)
    {
        Text text = Instantiate(exampleText, InstructionsPage.transform);
        switch (item)
        {
            case Item.Log:
                text.text = "Log";
                break;
            case Item.Plank:
                text.text = "Plank";
                break;
            case Item.Nail:
                text.text = "Nail";
                break;
            case Item.Hammer:
                text.text = "Hammer";
                break;
            case Item.Saw:
                text.text = "Saw";
                break;
            default:
                break;
        }
        text.gameObject.SetActive(true);
    }
}
