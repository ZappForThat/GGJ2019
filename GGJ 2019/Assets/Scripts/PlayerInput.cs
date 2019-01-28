using UnityEngine;
using System.Collections.Generic;
using Cinemachine;

public class PlayerInput : MonoBehaviour
{
    [SerializeField]
    private List<CinemachineVirtualCamera> vcams = new List<CinemachineVirtualCamera>();

    [SerializeField]
    private LayerMask layerMask;

    [SerializeField]
    private HouseBuildManager houseBuildManager;
    
    [SerializeField]
    private float actionCooldown = 0.35f;

    private Cabinet hoveredCabinet;
    private int currentVcam = 0;
    private float lastActionTime = 0f;
    private CheatSequence cheatSequence = new CheatSequence(new List<KeyCode> { KeyCode.BackQuote, KeyCode.W });
    private CheatSequence timeoutSequence = new CheatSequence(new List<KeyCode> { KeyCode.BackQuote, KeyCode.T });

    void OnEnable()
    {
        SwitchVcam(0);
    }

    void Update()
    {
        RaycastHit hitInfo;
        Ray cameraRay = Camera.main.ScreenPointToRay(Input.mousePosition);
        bool hit = Physics.Raycast(cameraRay, out hitInfo, Mathf.Infinity, layerMask, QueryTriggerInteraction.Ignore);

        CabinetCollider collider = null;
        if (hit && (Time.time - lastActionTime) >= actionCooldown)
        {
            collider = hitInfo.collider.GetComponent<CabinetCollider>();
        }

        if (collider?.cabinet != hoveredCabinet)
        {
            if (collider?.cabinet != null)
            {
                collider.cabinet.SetHover(true);
            }

            if (hoveredCabinet != null)
            {
                hoveredCabinet.SetHover(false);
            }

            hoveredCabinet = collider?.cabinet;
        }

        if (Input.GetMouseButtonDown(0) && hoveredCabinet != null && (Time.time - lastActionTime) >= actionCooldown)
        {
            hoveredCabinet.DoOpen();
            lastActionTime = Time.time;
            var savedCabinet = hoveredCabinet;
            Util.ExecuteAfter(actionCooldown, this, () =>
            {
                houseBuildManager.ApplyItem(savedCabinet.GetItem());
            });
        }

        if (Input.GetKeyDown(KeyCode.D) || Input.GetKeyDown(KeyCode.RightArrow))
        {
            SwitchVcam(1);
        }
        else if (Input.GetKeyDown(KeyCode.A) || Input.GetKeyDown(KeyCode.LeftArrow))
        {
            SwitchVcam(-1);
        }

        if (cheatSequence.CheckCheat())
        {
            houseBuildManager.CheatHouseComplete(true);
        }
        else if (timeoutSequence.CheckCheat())
        {
            houseBuildManager.CheatHouseComplete(false);
        }
    }

    void SwitchVcam(int direction)
    {
        currentVcam = (currentVcam + direction + vcams.Count) % vcams.Count;
        for (int i = 0; i < vcams.Count; i++)
        {
            vcams[i].enabled = (currentVcam == i);
        }
    }
}
