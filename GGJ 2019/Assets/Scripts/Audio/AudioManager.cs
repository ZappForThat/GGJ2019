using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance = null;
    public float timeDelay = 0;

    private bool bird;
    private float birdTimer;

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            Destroy(this.gameObject);
        }
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
    public void HammerImpactPlay() // done
    {
        AkSoundEngine.PostEvent("PlayHammerImpact", gameObject);
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
    public void SawCutPlay() // done
    {
        AkSoundEngine.PostEvent("PlaySawCut", gameObject);
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
    public void LogPlay()
    {
        AkSoundEngine.PostEvent("PlayLog", gameObject);
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
    public void TimeUpPlay()
    {
        AkSoundEngine.PostEvent("PlayTimeUp", gameObject);
    }
    public void ItemSoundPlay(Item item)
    {
        switch (item)
        {
            case Item.Log:
                LogPlay();
                break;
            case Item.Plank:
                WoodPlay();
                break;
            case Item.Nail:
                MetalPlay();
                break;
            case Item.Hammer:
                HammerPlay();
                break;
            case Item.Saw:
                SawPlay();
                break;
            case Item.Brick:
                StonePlay();
                break;
            case Item.Egg:
                StonePlay();
                break;
            case Item.FidgetSpinner:
                StonePlay();
                break;
            case Item.Fish:
                StonePlay();
                break;
            default:
                break;
        }
    }
}
