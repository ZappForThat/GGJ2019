using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance = null;
    public float timeDelay = 0;
    public bool StartMenu = false;

    private bool bird;
    private float birdTimer;

    private float WoodTimer = 0;
    private float MetalTimer = 0;
    private float HammerTimer = 0;
    private float SawTimer = 0;
    private float StoneTimer = 0;
    private float EggTimer = 0;
    private float FishTimer = 0;

    private bool WoodReady = false;
    private bool MetalReady = false;
    private bool HammerReady = false;
    private bool SawReady = false;
    private bool StoneReady = false;
    private bool EggReady = false;
    private bool FishReady = false;

    private void Awake()
    {
        if (!Instance)
        {
            Instance = this;
        }
        DontDestroyOnLoad(this);
    }
    

    private void Update()
    {
        WoodTimer -= Time.deltaTime;
        MetalTimer -= Time.deltaTime;
        HammerTimer -= Time.deltaTime;
        SawTimer -= Time.deltaTime;
        StoneTimer -= Time.deltaTime;
        EggTimer -= Time.deltaTime;
        FishTimer -= Time.deltaTime;

        if (WoodTimer < 0 && WoodReady)
        {
            WoodReady = false;
            WoodPlay();
        }
        if (MetalTimer < 0 && MetalReady)
        {
            MetalReady = false;
            MetalPlay();
        }
        if (HammerTimer < 0 && HammerReady)
        {
            HammerReady = false;
            HammerPlay();
        }
        if (SawTimer < 0 && SawReady)
        {
            SawReady = false;
            SawPlay();
        }
        if (StoneTimer < 0 && StoneReady)
        {
            StoneReady = false;
            StonePlay();
        }
        if (EggTimer < 0 && EggReady)
        {
            EggReady = false;
            EggPlay();
        }
        if (FishTimer < 0 && FishReady)
        {
            FishReady = false;
            FishPlay();
        }

        if (bird)
        {
            birdTimer += Time.deltaTime;
            if (birdTimer >= 5)
            {
                AkSoundEngine.PostEvent("PlayChirp", gameObject);
                birdTimer -= 5;
            }
        }
        else
        {
            birdTimer = 5;
        }
    }

    private void Start()
    {
        if (StartMenu)
        {
            AudioManager.Instance?.MenuMusicPlay();
        }
    }

    public void HammerPlay(bool delay = false) // done
    {
        if (delay)
        {
            HammerReady = true;
            HammerTimer = timeDelay;
        }
        else
        {
            AkSoundEngine.PostEvent("PlayHammer", gameObject);
        }
    }
    public void BirdChirpPlay() // done
    {
        bird = true;
    }
    public void StopBirdChirpPlay() // done
    {
        bird = false;
    }
    public void EggPlay(bool delay = false)
    {
        if (delay)
        {
            EggReady = true;
            EggTimer = timeDelay;
        }
        else
        {
            AkSoundEngine.PostEvent("PlayEggs", gameObject);
        }
    }
    public void FishPlay(bool delay = false)
    {
        if (delay)
        {
            FishReady = true;
            FishTimer = timeDelay;
        }
        else
        {
            AkSoundEngine.PostEvent("PlayFish", gameObject);
        }
    }
    public void OpeningCabinetPlay() // NA
    {
        AkSoundEngine.PostEvent("PlayOpenCab", gameObject);
    }
    public void OpeningDrawerPlay() // done
    {
        AkSoundEngine.PostEvent("PlayOpenDrawer", gameObject);
    }
    public void SawPlay(bool delay = false) // done
    {
        if (delay)
        {
            SawReady = true;
            SawTimer = timeDelay;
        }
        else
        {
            AkSoundEngine.PostEvent("PlaySaw", gameObject);
        }
    }
    public void StonePlay(bool delay = false)
    {
        if (delay)
        {
            StoneReady = true;
            StoneTimer = timeDelay;
        }
        else
        {
            AkSoundEngine.PostEvent("PlayStone", gameObject);
        }
    }
    public void WoodPlay(bool delay = false)
    {
        if (delay)
        {
            WoodReady = true;
            WoodTimer = timeDelay;
        }
        else
        {
            AkSoundEngine.PostEvent("PlayWood", gameObject);
        }
    }
    public void MetalPlay(bool delay = false)
    {
        if (delay)
        {
            MetalReady = true;
            MetalTimer = timeDelay;
        }
        else
        {
            AkSoundEngine.PostEvent("PlayMetal", gameObject);
        }
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
    public void MenuMusicStop() // done
    {
        AkSoundEngine.PostEvent("MenuMusicStop", gameObject);
    }
    public void ShopMusicPlay() // done
    {
        MenuMusicStop();
        BuildingMusicStop();
        AkSoundEngine.PostEvent("ShopMusic", gameObject);
    }
    public void ShopMusicStop() // done
    {
        AkSoundEngine.PostEvent("ShopMusicStop", gameObject);
    }
    public void BuildingMusicPlay() // done
    {
        MenuMusicStop();
        ShopMusicStop();
        StopBirdChirpPlay();
        AkSoundEngine.PostEvent("BuildingMusic", gameObject);
    }
    public void BuildingMusicStop() // done
    {
        AkSoundEngine.PostEvent("BuildingMusicStop", gameObject);
    }
    public void VictoryMusicGoodPlay() // done
    {
        MenuMusicStop();
        ShopMusicStop();
        BuildingMusicStop();
        AkSoundEngine.PostEvent("VictoryMusic", gameObject);
    }
    public void VictoryMusicBadPlay() // done
    {
        MenuMusicStop();
        ShopMusicStop();
        BuildingMusicStop();
        AkSoundEngine.PostEvent("VictoryMusicBad", gameObject);
    }
}
