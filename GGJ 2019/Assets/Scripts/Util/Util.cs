using UnityEngine;
using System.Collections;

public class Util
{
    public static void OnNextFrame(MonoBehaviour mb, System.Action action)
    {
        mb.StartCoroutine(OnNextFrameCoroutine(action));
    }

    public static void ExecuteAfter(float seconds, MonoBehaviour mb, System.Action action)
    {
        mb.StartCoroutine(AfterSecondsCoroutine(seconds, action));
    }

    private static IEnumerator OnNextFrameCoroutine(System.Action action)
    {
        yield return new WaitForEndOfFrame();
        action();
    }

    private static IEnumerator AfterSecondsCoroutine(float seconds, System.Action action)
    {
        yield return new WaitForSeconds(seconds);
        action();
    }
}