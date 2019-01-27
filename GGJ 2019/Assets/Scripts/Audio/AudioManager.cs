using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    
    
    
    void MenuMusicPlay()
    {
        AkSoundEngine.PostEvent("MenuMusic", gameObject);
    }
    void ShopMusicPlay()
    {
        AkSoundEngine.PostEvent("ShopMusic", gameObject);
    }
    void BuildingMusicPlay()
    {
        AkSoundEngine.PostEvent("BuildingMusic", gameObject);
    }
    void VictoryMusicPlay()
    {
        AkSoundEngine.PostEvent("VictoryMusic", gameObject);
    }
}
