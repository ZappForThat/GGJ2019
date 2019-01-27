using UnityEngine;
using System.Collections;

public class Cabinet : MonoBehaviour
{
    [SerializeField]
    public Item item;

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
        hammers?.SetActive(item == Item.Hammer);
        saws?.SetActive(item == Item.Saw);
        nails?.SetActive(item == Item.Nail);
        planks?.SetActive(item == Item.Plank);
        logs?.SetActive(item == Item.Log);
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
        }
    }
}
