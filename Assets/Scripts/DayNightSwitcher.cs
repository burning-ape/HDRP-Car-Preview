using UnityEngine;

public class DayNightSwitcher : MonoBehaviour
{
    [SerializeField] private GameObject _dayVolume, _nightVolume;
    [SerializeField] private Light _dayLight, _nightLight;
    [Space(15)][SerializeField] private Light[] _carLights, _streetLights;
    [Space(15)][SerializeField] private GameObject _leaves;


    public void DayToggle(bool isDay)
    {
        _dayVolume.SetActive(isDay); _nightVolume.SetActive(!isDay);
        _dayLight.enabled = isDay; _nightLight.enabled = !isDay;

        foreach (var lights in _carLights) lights.enabled = !isDay;
        foreach (var lights in _streetLights) lights.enabled = !isDay;

        _leaves.SetActive(isDay);
    }
}
