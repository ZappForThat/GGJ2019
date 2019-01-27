using UnityEngine;
using UnityEngine.UI;

public class MinigameManager : MonoBehaviour
{
    [SerializeField]
    private MinigameSlider slider;

    private bool started = false;
    private float rangeSize = 0;
    private int iterations = 0;
    private int currentIteration = 0;

    public System.Action<int, bool> minigameResultCallback;
    public System.Action minigameEndCallback;

    private void Start()
    {
        slider.SetShown(false);
    }

    public void StartMinigame(float rangeSize, int iterations)
    {
        if (iterations == 0)
        {
            Debug.LogWarning("No iterations?");
            Util.OnNextFrame(this, () => { EndMinigame(); });
        }

        slider.SetShown(true);
        started = true;
        this.iterations = iterations;
        this.rangeSize = rangeSize;
        this.currentIteration = 0;

        NewGame();

        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    private void EndMinigame()
    {
        started = false;
        slider.SetShown(false);

        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;

        minigameEndCallback?.Invoke();
    }

    private void NewGame()
    {
        slider.ConfigureSweetSpot(Random.Range(0.4f, 1.0f - rangeSize), rangeSize);
    }

    private void Update()
    {
        if (!started)
        {
            return;
        }

        if (Input.GetMouseButtonDown(0))
        {
            minigameResultCallback?.Invoke(currentIteration, slider.IsInSweetSpot());
            currentIteration++;
            if (currentIteration >= iterations)
            {
                EndMinigame();
            }
            else
            {
                NewGame();
            }
        }
    }
}
