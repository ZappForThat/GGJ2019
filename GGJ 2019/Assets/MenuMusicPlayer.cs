using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MenuMusicPlayer : MonoBehaviour
{
    private static bool transitionedFromCredits = false;
    public bool isMainMenu = false;

    private void Start()
    {
        if (!isMainMenu || !transitionedFromCredits)
        {
            AudioManager.Instance?.MenuMusicPlay();
        }

        if (!isMainMenu)
        {
            transitionedFromCredits = true;
        }
    }
}
