using UnityEngine;
using System.Collections;

public class Nail : MonoBehaviour
{
    private Animator animator;
    public GameObject hammer;

    private void Awake()
    {
        animator = GetComponent<Animator>();
    }

    public void SetShown(bool shown)
    {
        hammer.gameObject.SetActive(shown);
    }

    public void Finish(bool good)
    {
        animator.SetBool("DoHammer", true);
        StartCoroutine(DoThing(good));
    }

    private IEnumerator DoThing(bool good)
    {
        yield return new WaitForSeconds(GetAnimationLength("HammerInNail"));

        hammer.gameObject.SetActive(false);
        if (good)
        {
            // Play particle effect, etc
            this.gameObject.SetActive(false);
        }
        else
        {
            // Bent nail?
        }
    }

    float GetAnimationLength(string name)
    {
        float time = 0;
        RuntimeAnimatorController ac = animator.runtimeAnimatorController;

        for (int i = 0; i < ac.animationClips.Length; i++)
        {
            if (ac.animationClips[i].name == name)
            {
                time = ac.animationClips[i].length;
                break;
            }
        }

        return time;
    }
}
