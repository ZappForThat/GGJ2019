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

    public static Vector3 EaseInOut(Vector3 initial, Vector3 final, float time, float duration)
    {
        return new Vector3(Util.EaseInOut(initial.x, final.x, time, duration),
                           Util.EaseInOut(initial.y, final.y, time, duration),
                           Util.EaseInOut(initial.z, final.z, time, duration));
    }

    public static float EaseInOut(float initial, float final, float time, float duration)
    {
        float change = final - initial;
        time /= duration / 2;
        if (time < 1f) return change / 2 * time * time + initial;
        time--;
        return -change / 2 * (time * (time - 2) - 1) + initial;
    }

    public static float EaseIn(float initial, float final, float time, float duration)
    {
        time /= duration;
        float change = final - initial;
        return change * time * time + initial;
    }
}