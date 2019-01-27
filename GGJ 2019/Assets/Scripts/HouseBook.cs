using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections.Generic;

public class HouseBook : MonoBehaviour
{
    public Image image;
    public TextMeshProUGUI text;
    public VerticalLayoutGroup layout { get; private set; }
    public Image InstructionsPage;

    public Image ExampleLogImage;
    public Image ExampleSawImage;
    public Image ExampleNailImage;
    public Image ExamplePlankImage;
    public Image ExampleHammerImage;

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
        Image img;
        switch (item)
        {
            case Item.Log:
                img = Instantiate(ExampleLogImage, InstructionsPage.transform);
                break;
            case Item.Plank:
                img = Instantiate(ExamplePlankImage, InstructionsPage.transform);
                break;
            case Item.Nail:
                img = Instantiate(ExampleNailImage, InstructionsPage.transform);
                break;
            case Item.Hammer:
                img = Instantiate(ExampleHammerImage, InstructionsPage.transform);
                break;
            case Item.Saw:
                img = Instantiate(ExampleSawImage, InstructionsPage.transform);
                break;
            default:
                img = Instantiate(ExampleLogImage);
                break;
        }
        img.gameObject.SetActive(true);
    }
}
