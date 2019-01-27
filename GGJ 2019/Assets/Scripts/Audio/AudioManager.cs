using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    
    void HammerPlay()
    {
        AkSoundEngine.PostEvent("PlayHammer", gameObject);
    }
    void BirdChirpPlay()
    {
        AkSoundEngine.PostEvent("PlayChirp", gameObject);
    }
    void EggPlay()
    {
        AkSoundEngine.PostEvent("PlayEggs", gameObject);
    }
    void FishPlay()
    {
        AkSoundEngine.PostEvent("PlayFish", gameObject);
    }
    void OpeningCabinetPlay()
    {
        AkSoundEngine.PostEvent("PlayOpenCab", gameObject);
    }
    void OpeningDrawerPlay()
    {
        AkSoundEngine.PostEvent("PlayOpenDrawer", gameObject);
    }
    void SawPlay()
    {
        AkSoundEngine.PostEvent("PlaySaw", gameObject);
    }
    void StonePlay()
    {
        AkSoundEngine.PostEvent("PlayStone", gameObject);
    }
    void WoodPlay()
    {
        AkSoundEngine.PostEvent("PlayWood", gameObject);
    }
    void MetalPlay()
    {
        AkSoundEngine.PostEvent("PlayMetal", gameObject);
    }
    void WrongPlay()
    {
        AkSoundEngine.PostEvent("PlayWrong", gameObject);
    }
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
