using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreditsAudioHandler : MonoBehaviour
{
    private void OnEnable()
    {
        AudioManager.Instance?.MenuMusicPlay();
    }
}
