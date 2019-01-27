using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BackgroundMusic : MonoBehaviour
{
    bool Menu = false;
    bool Shop = false;
    bool Building = false;
    bool Victory = false;
    float timer = 0f;
    float randBuildingIncrement = -100f;

    // Start is called before the first frame update
    void Start()
    {
        ShopMusicPlay();
        //BuildingMusicPlay();
        Building = true;
    }

    // Update is called once per frame
    /*void Update()
    {
        if (Building)
        {
            timer += Time.deltaTime;
            Debug.Log(timer);
            if (timer > 2)
            {
                timer = 0.0f;
                randBuildingIncrement += .1f; 
                AkSoundEngine.SetRTPCValue("BuildingMusicIncrease", randBuildingIncrement);
                Debug.Log("Hi");
            }
        }
    }*/
    void MenuMusic()
    {

    }
    void ShopMusic()
    {

    }
    void BuildingMusic()
    {
        
    }
    void VictoryMusic()
    {

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
