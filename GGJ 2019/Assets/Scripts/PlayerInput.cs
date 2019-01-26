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
    private GameManager gameManager;

    private int currentVcam = 0;

    void Start()
    {
    }

    void Update()
    {
        RaycastHit hitInfo;
        Ray cameraRay = Camera.main.ScreenPointToRay(Input.mousePosition);
        bool hit = Physics.Raycast(cameraRay, out hitInfo, Mathf.Infinity, layerMask, QueryTriggerInteraction.Ignore);
        Cabinet cabinet = null;

        if (hit)
        {
            cabinet = hitInfo.collider.GetComponent<Cabinet>();
        }

        if (cabinet && Input.GetMouseButtonDown(0))
        {
            gameManager.ApplyItem(cabinet.item);
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
