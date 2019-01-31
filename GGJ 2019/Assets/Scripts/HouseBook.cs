using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections.Generic;

public class HouseBook : MonoBehaviour
{
    public Image image;
    public TextMeshProUGUI text;
    public VerticalLayoutGroup layout { get; private set; }
    public Image InstructionsPage1;
    public Image InstructionsPage2;

    public InstructionLine ExampleLogImage;
    public InstructionLine ExampleSawImage;
    public InstructionLine ExampleNailImage;
    public InstructionLine ExamplePlankImage;
    public InstructionLine ExampleHammerImage;

    private void Awake()
    {
        layout = GetComponent<VerticalLayoutGroup>();
    }

    public void Clear()
    {
        foreach (InstructionLine line in InstructionsPage1.GetComponentsInChildren<InstructionLine>())
        {
            Destroy(line.gameObject);
        }
        foreach (InstructionLine line in InstructionsPage2.GetComponentsInChildren<InstructionLine>())
        {
            Destroy(line.gameObject);
        }

        image.sprite = null;
    }

    public void Fill(House house)
    {
        Clear();
        image.sprite = house.image;
        List<Item> items = house.GetItemList();

        bool useSecondPage = items.Count > 8;

        int i = 0;
        foreach (Item item in items)
        {
            int half = items.Count / 2;
            Image page = useSecondPage && i > half ? InstructionsPage2 : InstructionsPage1;
            InstructionLine line = CreateText(item, page);
            i++;
        }
    }

    private InstructionLine CreateText(Item item, Image page)
    {
        InstructionLine img;
        switch (item)
        {
            case Item.Log:
                img = Instantiate(ExampleLogImage, page.transform);
                break;
            case Item.Plank:
                img = Instantiate(ExamplePlankImage, page.transform);
                break;
            case Item.Nail:
                img = Instantiate(ExampleNailImage, page.transform);
                break;
            case Item.Hammer:
                img = Instantiate(ExampleHammerImage, page.transform);
                break;
            case Item.Saw:
                img = Instantiate(ExampleSawImage, page.transform);
                break;
            default:
                Debug.Assert(false);
                img = Instantiate(ExampleLogImage);
                break;
        }
        img.gameObject.SetActive(true);
        return img;
    }
}
