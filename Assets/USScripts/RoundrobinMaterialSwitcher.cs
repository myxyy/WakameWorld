
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;

public class RoundrobinMaterialSwitcher : UdonSharpBehaviour
{
    [UdonSynced, FieldChangeCallback(nameof(CurrentIndex))]
    private int _currentIndex = 0;
    public int CurrentIndex
    {
        get => _currentIndex;
        set
        {
            _currentIndex = value;
            if (_targetMeshRenderer != null && _materials != null && _materials.Length > 0)
            {
                _targetMeshRenderer.material = _materials[_currentIndex];
            }
        }
    }
    [SerializeField]
    private Material[] _materials;
    [SerializeField]
    private MeshRenderer _targetMeshRenderer;

    public override void OnPickupUseDown()
    {
        Networking.GetOwner(gameObject);
        if (Networking.IsOwner(Networking.LocalPlayer, gameObject) && _materials != null && _materials.Length > 0)
        {
            _currentIndex = (_currentIndex + 1) % _materials.Length;
            _targetMeshRenderer.material = _materials[_currentIndex];
            RequestSerialization();
        }
    }
}
