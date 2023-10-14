using UnityEngine;

public class CarColorChanger : MonoBehaviour
{
    [SerializeField] private Material _carColor, _carStitches;

    public void ChangeCarColor(Color color)
    {
        _carColor.SetColor("_BaseColor", color);
        _carStitches.SetColor("_BaseColor", color);
    }


#if UNITY_EDITOR
    private void OnDestroy()
    {
        // Restore default color
        ChangeCarColor(new Color(142, 0, 0, 255));
    }
#endif
}
