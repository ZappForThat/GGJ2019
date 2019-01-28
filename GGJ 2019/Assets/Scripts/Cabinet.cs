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

    [SerializeField]
    private GameObject bricks;

    [SerializeField]
    private GameObject eggs;

    [SerializeField]
    private GameObject fidgetSpinners;

    [SerializeField]
    private GameObject fish;

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

            switch (item)
            {
                case Item.Log:
                    AudioManager.Instance?.WoodPlay(true);
                    break;
                case Item.Plank:
                    AudioManager.Instance?.WoodPlay(true);
                    break;
                case Item.Nail:
                    AudioManager.Instance?.MetalPlay(true);
                    break;
                case Item.Hammer:
                    AudioManager.Instance?.HammerPlay(true);
                    break;
                case Item.Saw:
                    AudioManager.Instance?.MetalPlay(true);
                    break;
                case Item.Brick:
                    AudioManager.Instance?.StonePlay(true);
                    break;
                case Item.Egg:
                    AudioManager.Instance?.EggPlay(true);
                    break;
                case Item.FidgetSpinner:
                    AudioManager.Instance?.MetalPlay(true);
                    break;
                case Item.Fish:
                    AudioManager.Instance?.FishPlay(true);
                    break;
                default:
                    break;
            }
            Debug.Log("sound!");
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

        bricks?.SetActive(item == Item.Brick);
        eggs?.SetActive(item == Item.Egg);
        fidgetSpinners?.SetActive(item == Item.FidgetSpinner);
        fish?.SetActive(item == Item.Fish);
    }
}
