
using System.Diagnostics.PerformanceData;
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Rendering;
using VRC.SDKBase;
using VRC.Udon;
using VRC.Udon.Common.Interfaces;

namespace Myxy.PixelSand.Udon
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
    public class Hourgrass : UdonSharpBehaviour
    {
        private RenderTexture _previousRT;
        private RenderTexture _currentRT;
        private RenderTexture _countRT;

        private int _resolution;
        private int _log2Res;

        [SerializeField]
        private MeshRenderer _showMesh;

        private Vector3 _previousPosition = Vector3.zero;
        private Vector3 _previousVelocity = Vector3.zero;
        private Vector3 _acceleration;
        [SerializeField]
        private Vector3 _gravity = Physics.gravity;

        private float _defaultFps = 120f;
        private float _maxFps = 240f;
        private float _lastUpdateFixedTime = 0f;

        private const int MAX_UPDATE_PER_FRAME = 8;

        private int _spaceCount;
        public int SpaceCount => _spaceCount;
        private int _sandCountLower;
        private int _sandCountUpper;
        public int SandCountLower;
        public int SandCountUpper;
        public int SandCount;

        private float _previousCountTime;
        private int _previousSandCountLower;
        public float AverageSandSpeed;

        private const int SAND_COUNT_INTERVAL = 32;
        private int _sandCountIntervalCount = 0;

        private int _seedId;
        private int _gravityId;
        private int _sandTexId;
        private int _initId;
        private int _countTexId;
        private int _numId;
        private int _bottleneckId;

        [SerializeField]    
        private GameObject _materialWrapper;
        private Material _showMaterial;
        private Material _updateMaterial;
        private Material _countMaterial;
        private Material _transferMaterial;

        private const int COUNT_PIXEL = 32;
        private const int SYNC_PIXEL_THRESHOLD = 16;

        [UdonSynced, FieldChangeCallback(nameof(SyncSandCountLower))]
        private int _syncSandCountLower;
        public int SyncSandCountLower
        {
            get
            {
                return _syncSandCountLower;
            }
            set
            {
                _syncSandCountLower = value;
                if (Networking.IsOwner(this.gameObject))
                {
                    RequestSerialization();
                }
                else if (
                    Mathf.Abs(_sandCountLower - _syncSandCountLower) > SYNC_PIXEL_THRESHOLD &&
                    TransferCount == 0
                )
                {
                    TransferCount = _sandCountLower - _syncSandCountLower;
                }
            }
        }

        public int TransferCount = 0;
        public bool SyncSandAmount = true;

        private void Start()
        {
            _seedId = VRCShader.PropertyToID("_Seed");
            _gravityId = VRCShader.PropertyToID("_Gravity");
            _sandTexId = VRCShader.PropertyToID("_SandTex");
            _initId = VRCShader.PropertyToID("_Init");
            _countTexId = VRCShader.PropertyToID("_CountTex");
            _numId = VRCShader.PropertyToID("_Num");
            _bottleneckId = VRCShader.PropertyToID("_Bottleneck");
            _showMaterial = _showMesh.material;
            _log2Res = _showMaterial.GetInt("_Log2Res");
            _resolution = (int)(Mathf.Pow(2, _log2Res) + .5);

            _previousRT = new RenderTexture(_resolution, _resolution, 0, RenderTextureFormat.ARGBFloat);
            _previousRT.filterMode = FilterMode.Point;
            _previousRT.useMipMap = true;
            _previousRT.autoGenerateMips = true;
            _previousRT.Create();
            _currentRT = new RenderTexture(_resolution, _resolution, 0, RenderTextureFormat.ARGBFloat);
            _currentRT.filterMode = FilterMode.Point;
            _currentRT.useMipMap = true;
            _currentRT.autoGenerateMips = true;
            _currentRT.Create();
            _countRT = new RenderTexture(COUNT_PIXEL, 4, 0, RenderTextureFormat.ARGBFloat);
            _countRT.filterMode = FilterMode.Point;
            _countRT.Create();

            var materialWrapper = Instantiate(_materialWrapper);
            _updateMaterial = materialWrapper.GetComponent<MeshRenderer>().materials[0];
            _countMaterial = materialWrapper.GetComponent<MeshRenderer>().materials[1];
            _transferMaterial = materialWrapper.GetComponent<MeshRenderer>().materials[2];
            Destroy(materialWrapper);

            _defaultFps = _showMaterial.GetFloat("_DefaultFPS");
            _maxFps = _showMaterial.GetFloat("_MaxFPS");
            _updateMaterial.SetFloat("_Amount", _showMaterial.GetFloat("_Amount"));
            _updateMaterial.SetInt(_initId, 1);
            _updateMaterial.SetFloat("_InitProb", _showMaterial.GetFloat("_InitProb"));
            _updateMaterial.SetFloat(_bottleneckId, _showMaterial.GetFloat(_bottleneckId));
            _updateMaterial.SetInt("_IsWallByTex", 0);
            _countMaterial.SetInt("_Count", COUNT_PIXEL);
            _countMaterial.SetInt("_Log2Res", _showMaterial.GetInt("_Log2Res"));
            _transferMaterial.SetInt("_Count", COUNT_PIXEL);
        }

        public override void OnAsyncGpuReadbackComplete(VRCAsyncGPUReadbackRequest request)
        {
            if (request.hasError)
            {
                Debug.LogError("GPU readback error");
            }
            else
            {
                var px = new Color[4];
                request.TryGetData(px);
                int halfRes = _resolution / 2;
                _spaceCount = (int)((px[0].a + px[1].a + px[2].a + px[3].a) * halfRes * halfRes);
                _sandCountLower = (int)((px[0].b + px[1].b) * halfRes * halfRes);
                _sandCountUpper = (int)((px[2].b + px[3].b) * halfRes * halfRes);
                SandCountLower = _sandCountLower;
                SandCountUpper = _sandCountUpper;
                SandCount = _sandCountLower + _sandCountUpper;

                if (Mathf.Abs(_sandCountLower - _previousSandCountLower) > 1000f)
                {
                    _previousSandCountLower = _sandCountLower;
                }
                AverageSandSpeed = 0.99f * AverageSandSpeed + 0.01f * (_sandCountLower - _previousSandCountLower) / (Time.fixedTime - _previousCountTime);
                _previousSandCountLower = _sandCountLower;
                _previousCountTime = Time.fixedTime;
                if (Networking.IsOwner(this.gameObject))
                {
                    SyncSandCountLower = _sandCountLower;
                }
            }
        }

        private void FixedUpdate()
        {
            var position = transform.position;
            if (_previousPosition == Vector3.zero)
            {
                _previousPosition = position;
            }
            var velocity = (position - _previousPosition) / Time.unscaledDeltaTime;
            _previousPosition = position;
            _acceleration = (velocity - _previousVelocity) / Time.unscaledDeltaTime;
            _previousVelocity = velocity;

            var localAcceleration = _gravity - _acceleration;
            var normalizedLocalAcceleration = localAcceleration.normalized;
            var accelerationScale = localAcceleration.magnitude / _gravity.magnitude;
            var fps = Mathf.Min(_defaultFps * accelerationScale, _maxFps);

            var updateFrames = (int)((Time.fixedTime - _lastUpdateFixedTime) * fps);

            for (int j=0; j<Mathf.Min(updateFrames, MAX_UPDATE_PER_FRAME); j++)
            {
                UpdateSingle(normalizedLocalAcceleration);
            }
            _lastUpdateFixedTime += updateFrames / fps;

            _sandCountIntervalCount++;
            if (_sandCountIntervalCount >= SAND_COUNT_INTERVAL)
            {
                VRCAsyncGPUReadback.Request(_currentRT, _log2Res - 1, (IUdonEventReceiver)this);
                _sandCountIntervalCount = 0;
            }

            if (TransferCount != 0 && SyncSandAmount)
            {
                int tNum = Mathf.Min(Mathf.Abs(TransferCount), COUNT_PIXEL) * (int)Mathf.Sign(TransferCount);
                Transfer(tNum);
                TransferCount -= tNum;
            }
        }

        private void Transfer(int count)
        {
            VRCGraphics.Blit(_currentRT, _countRT, _countMaterial);
            var tempRT = _currentRT;
            _currentRT = _previousRT;
            _previousRT = tempRT;
            _transferMaterial.SetTexture(_sandTexId, _previousRT);
            _transferMaterial.SetTexture(_countTexId, _countRT);
            _transferMaterial.SetInt(_numId, count);
            VRCGraphics.Blit(null, _currentRT, _transferMaterial);
        }
 

        private void UpdateSingle(Vector3 normalizedLocalAcceleration)
        {
            var tempRT = _currentRT;
            _currentRT = _previousRT;
            _previousRT = tempRT;

            _updateMaterial.SetFloat(_seedId, Random.Range(0f,1f));
            _updateMaterial.SetVector(_gravityId, new Vector4(
                Vector3.Dot(transform.right, normalizedLocalAcceleration),
                Vector3.Dot(transform.up, normalizedLocalAcceleration),
                Vector3.Dot(transform.forward, normalizedLocalAcceleration),
                0f
            ));
            VRCGraphics.Blit(_previousRT, _currentRT, _updateMaterial);

            _showMesh.material.SetTexture(_sandTexId, _currentRT);

            _updateMaterial.SetFloat(_initId, 0);
        }
    }
}
