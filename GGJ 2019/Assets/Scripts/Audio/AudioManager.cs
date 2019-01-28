using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance = null;

    private bool bird;
    private float birdTimer;

    private void Awake()
    {
        Instance = this;
        DontDestroyOnLoad(this);
    }

    private void Update()
    {
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
        AudioManager.Instance?.MenuMusicPlay();
    }

    public void HammerPlay() // done
    {
        AkSoundEngine.PostEvent("PlayHammer", gameObject);
    }
    public void BirdChirpPlay() // done
    {
        bird = true;
    }
    public void StopBirdChirpPlay() // done
    {
        bird = false;
    }
    public void EggPlay()
    {
        AkSoundEngine.PostEvent("PlayEggs", gameObject);
    }
    public void FishPlay()
    {
        AkSoundEngine.PostEvent("PlayFish", gameObject);
    }
    public void OpeningCabinetPlay() // NA
    {
        AkSoundEngine.PostEvent("PlayOpenCab", gameObject);
    }
    public void OpeningDrawerPlay() // done
    {
        AkSoundEngine.PostEvent("PlayOpenDrawer", gameObject);
    }
    public void SawPlay() // done
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
