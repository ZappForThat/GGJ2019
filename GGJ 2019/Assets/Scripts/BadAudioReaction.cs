using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BadAudioReaction : MonoBehaviour
{
    private void OnEnable()
    {
        AudioManager.Instance?.VictoryMusicPlay();
    }
}
