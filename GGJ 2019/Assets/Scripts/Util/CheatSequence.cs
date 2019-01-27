using UnityEngine;
using System.Collections.Generic;

public class CheatSequence
{
    List<KeyCode> keySequence;
    int count = 0;

    public CheatSequence(List<KeyCode> sequence)
    {
        this.keySequence = sequence;
    }

    public bool CheckCheat()
    {
        if (count < keySequence.Count && Input.GetKeyDown(keySequence[count]))
        {
            count++;
            if (count >= keySequence.Count)
            {
                count = 0;
                return true;
            }
        }

        return false;
    }
}
