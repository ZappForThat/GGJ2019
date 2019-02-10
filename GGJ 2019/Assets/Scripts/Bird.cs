using UnityEngine;
using System.Collections;

public class Bird : MonoBehaviour
{
    [SerializeField]
    private Animator animator;

    private void Awake()
    {
        if (animator == null)
        {
            animator = GetComponent<Animator>();
        }
    }

    public void SetReaction(float reaction)
    {
        if (animator == null)
        {
            animator = GetComponent<Animator>();
        }
        animator.SetFloat("Blend", reaction);
    }
}
