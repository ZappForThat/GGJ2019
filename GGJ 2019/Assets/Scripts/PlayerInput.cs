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
    private float applyTime = 0.35f;
    
    [SerializeField]
    private float actionCooldown = 0.2f;

    private Cabinet hoveredCabinet;
    private int currentVcam = 0;
    private float lastActionTime = 0f;
    private CheatSequence cheatSequence = new CheatSequence(new List<KeyCode> { KeyCode.BackQuote, KeyCode.W });
    private CheatSequence timeoutSequence = new CheatSequence(new List<KeyCode> { KeyCode.BackQuote, KeyCode.T });

    public void DisableMainVcams()
    {
        SwitchToVcam(-1);
    }

    public void EnableMainVcams()
    {
        SwitchToVcam(0);
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
            Util.ExecuteAfter(applyTime, this, () =>
            {
                if (houseBuildManager.ApplyItem(savedCabinet.GetItem(), Reenable))
                {
                    this.enabled = false;
                }
            });
        }

        if (Input.GetKeyDown(KeyCode.D) || Input.GetKeyDown(KeyCode.RightArrow))
        {
            AdvanceVcam(1);
        }
        else if (Input.GetKeyDown(KeyCode.A) || Input.GetKeyDown(KeyCode.LeftArrow))
        {
            AdvanceVcam(-1);
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

    void Reenable()
    {
        this.enabled = true;
    }

    void AdvanceVcam(int direction)
    {
        currentVcam = (currentVcam + direction + vcams.Count) % vcams.Count;
        SwitchToVcam(currentVcam);
    }

    void SwitchToVcam(int vcam)
    {
        for (int i = 0; i < vcams.Count; i++)
        {
            vcams[i].enabled = (vcam == i);
        }
    }
}
