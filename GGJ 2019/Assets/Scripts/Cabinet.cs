using UnityEngine;
using System.Collections;

public class Cabinet : MonoBehaviour
{
    [SerializeField]
    private Item item;

    [SerializeField]
    private Animator animator;

    [SerializeField]
    private GameObject hammers;

    [SerializeField]
    private GameObject saws;

    [SerializeField]
    private GameObject nails;

    [SerializeField]
    private GameObject planks;

    [SerializeField]
    private GameObject logs;

    private void Awake()
    {
        SetItem(this.item);
    }

    public void SetHover(bool hover)
    {
        if (animator != null)
        {
            animator.SetBool("IsHovered", hover);
        }
    }

    public void DoOpen()
    {
        if (animator != null)
        {
            animator.SetBool("DoOpen", true);
            Util.ExecuteAfter(0.5f, this, () => animator.SetBool("DoOpen", false));

            AudioManager.Instance?.OpeningDrawerPlay();
        }
    }

    public Item GetItem()
    {
        return item;
    }

    public void SetItem(Item item)
    {
        this.item = item;
        hammers?.SetActive(item == Item.Hammer);
        saws?.SetActive(item == Item.Saw);
        nails?.SetActive(item == Item.Nail);
        planks?.SetActive(item == Item.Plank);
        logs?.SetActive(item == Item.Log);
    }
}
