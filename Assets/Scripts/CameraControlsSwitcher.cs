using Cinemachine;
using UnityEngine;

public class CameraControlsSwitcher : MonoBehaviour
{
    [SerializeField] private CinemachineFreeLook _cfl;


    private void Update()
    {
        if (Input.GetMouseButton(0))
        {
            _cfl.enabled = true;
            Cursor.visible = false;
        }
        else
        {
            _cfl.enabled = false;
            Cursor.visible = true;
        }
    }
}
