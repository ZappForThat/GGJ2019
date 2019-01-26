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

    private int currentVcam = 0;

    void OnEnable()
    {
        SwitchVcam(0);
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            RaycastHit hitInfo;
            Ray cameraRay = Camera.main.ScreenPointToRay(Input.mousePosition);
            bool hit = Physics.Raycast(cameraRay, out hitInfo, Mathf.Infinity, layerMask, QueryTriggerInteraction.Ignore);

            if (hit)
            {
                CabinetCollider collider = hitInfo.collider.GetComponent<CabinetCollider>();
                if (collider != null)
                {
                    houseBuildManager.ApplyItem(collider.cabinet.item);
                }
            }
        }

        if (Input.GetKeyDown(KeyCode.D) || Input.GetKeyDown(KeyCode.RightArrow))
        {
            SwitchVcam(1);
        }
        else if (Input.GetKeyDown(KeyCode.A) || Input.GetKeyDown(KeyCode.LeftArrow))
        {
            SwitchVcam(-1);
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
