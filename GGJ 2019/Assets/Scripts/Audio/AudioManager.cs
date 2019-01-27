using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance = null;

    private void Awake()
    {
        Instance = this;
        DontDestroyOnLoad(this);
    }

    private void Start()
    {
        AudioManager.Instance?.MenuMusicPlay();
    }

    public void HammerPlay()
    {
        AkSoundEngine.PostEvent("PlayHammer", gameObject);
    }
    public void BirdChirpPlay()
    {
        AkSoundEngine.PostEvent("PlayChirp", gameObject);
    }
    public void EggPlay()
    {
        AkSoundEngine.PostEvent("PlayEggs", gameObject);
    }
    public void FishPlay()
    {
        AkSoundEngine.PostEvent("PlayFish", gameObject);
    }
    public void OpeningCabinetPlay() //NA
    {
        AkSoundEngine.PostEvent("PlayOpenCab", gameObject);
    }
    public void OpeningDrawerPlay() // done
    {
        AkSoundEngine.PostEvent("PlayOpenDrawer", gameObject);
    }
    public void SawPlay()
    {
        AkSoundEngine.PostEvent("PlaySaw", gameObject);
    }
    public void StonePlay()
    {
        AkSoundEngine.PostEvent("PlayStone", gameObject);
    }
    public void WoodPlay()
    {
        AkSoundEngine.PostEvent("PlayWood", gameObject);
    }
    public void MetalPlay()
    {
        AkSoundEngine.PostEvent("PlayMetal", gameObject);
    }
    public void WrongPlay()
    {
        AkSoundEngine.PostEvent("PlayWrong", gameObject);
    }

    public void MenuMusicPlay() // done
    {
        ShopMusicStop();
        BuildingMusicStop();
        AkSoundEngine.PostEvent("MenuMusic", gameObject);
    }
    public void MenuMusicStop()
    {
        AkSoundEngine.PostEvent("MenuMusicStop", gameObject);
    }
    public void ShopMusicPlay()
    {
        MenuMusicStop();
        BuildingMusicStop();
        AkSoundEngine.PostEvent("ShopMusic", gameObject);
    }
    public void ShopMusicStop()
    {
        AkSoundEngine.PostEvent("ShopMusicStop", gameObject);
    }
    public void BuildingMusicPlay()
    {
        MenuMusicStop();
        ShopMusicStop();
        AkSoundEngine.PostEvent("BuildingMusic", gameObject);
    }
    public void BuildingMusicStop()
    {
        AkSoundEngine.PostEvent("BuildingMusicStop", gameObject);
    }
    public void VictoryMusicPlay()
    {
        MenuMusicStop();
        ShopMusicStop();
        BuildingMusicStop();
        AkSoundEngine.PostEvent("VictoryMusic", gameObject);
    }
}
