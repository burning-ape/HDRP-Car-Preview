using Cinemachine;
using UnityEngine;
using UnityEngine.EventSystems;
using System.Collections.Generic;

public class CursorVisibility : MonoBehaviour
{
    [SerializeField] private CinemachineFreeLook _cinemachineFreeLook;
    [SerializeField] private EventSystem _eventSystem;


    private void Update() => SwitchMouseVisibility();


    private void SwitchMouseVisibility()
    {
        if (Input.GetMouseButton(0) && !OnUI())
        {
            _cinemachineFreeLook.enabled = true;
            Cursor.visible = false;
        }
        else
        {
            _cinemachineFreeLook.enabled = false;
            Cursor.visible = true;
        }
    }


    private bool OnUI()
    {
        var pointerEventData = new PointerEventData(_eventSystem) { position = Input.mousePosition };
        var raycastResults = new List<RaycastResult>();
        _eventSystem.RaycastAll(pointerEventData, raycastResults);

        if (raycastResults.Count > 0) return true;
        else return false;
    }
}
