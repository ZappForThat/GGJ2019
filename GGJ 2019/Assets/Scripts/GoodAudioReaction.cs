using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoodAudioReaction : MonoBehaviour
{
    private void OnEnable()
    {
        AudioManager.Instance?.VictoryMusicPlay();
    }
}
