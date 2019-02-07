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

    public InstructionLine instructionPrefab;

    private Dictionary<Item, string> itemToInstructionTextMap = new Dictionary<Item, string>
    {
        {Item.Log, "Add a Log!" },
        {Item.Plank, "Plank of Wood!" },
        {Item.Nail, "Nails!" },
        {Item.Hammer, "Hammer Time!" },
        {Item.Saw, "Use a Saw!" },
    };

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
            InstructionLine line = CreateText(i, item, page);
            i++;
        }
    }

    private InstructionLine CreateText(int step, Item item, Image page)
    {
        InstructionLine instructionLine = Instantiate<InstructionLine>(instructionPrefab, page.transform);
        instructionLine.image.sprite = ItemImageMapper.Instance.Map(item);
        instructionLine.text.text =  "<b>" + step + ". </b>" + itemToInstructionTextMap[item];
        instructionLine.gameObject.SetActive(true);
        return instructionLine;
    }
}
