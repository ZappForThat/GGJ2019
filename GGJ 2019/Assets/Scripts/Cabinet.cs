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

    private void Awake()
    {
        hammers?.SetActive(item == Item.Hammer);
        saws?.SetActive(item == Item.Saw);
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
            Util.OnNextFrame(this, () => animator.SetBool("DoOpen", false));
        }
    }
}
