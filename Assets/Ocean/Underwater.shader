Shader "myxy/WaterShader/Underwater"
{
    Properties
    {
        _SL ("Sea level", Float) = 0.
        _Color ("Near color", Color) = (0,0,0,1)
        _SC ("Far color", Color) = (0,0,1,1)
        _Tr ("Transparency", Range(0,1)) = .1
        _Tr2 ("Transparency2", Range(0,1)) = .1
        _Bl ("Blur max", Range(0,10)) = 0
        _Bld ("Blur max distance", Float) = 0
    }
    SubShader
    {
        Tags { "Queue"="AlphaTest+301" "LightMode"="ForwardBase" }
        LOD 100
        ZTest Always
        ZWrite Off

		GrabPass {
			"_GrabTex_myxy_UnderWater"
		}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                noperspective float4 grabPos : TEXCOORD2;
                noperspective float4 projCoord: TEXCOORD3;
                float3 viewDir : TEXCOORD1;
            };

            sampler2D _GrabTex_myxy_UnderWater;
            float _SL;
            float4 _Color;
            float4 _SC;
			sampler2D _CameraDepthTexture;
            float _Tr;
            float _Tr2;
            float _Bl;
            float _Bld;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = float4(1-2*v.uv.x,_ProjectionParams.x*(1-2*v.uv.y),0,1);
                float3 localViewDir = mul(unity_CameraInvProjection, float4(o.vertex.x, _ProjectionParams.x*o.vertex.y, 0, 1)).xyz;
                o.viewDir = mul(transpose(UNITY_MATRIX_V), localViewDir);

				o.grabPos = ComputeGrabScreenPos(o.vertex);
				o.projCoord = UNITY_PROJ_COORD(ComputeScreenPos(o.vertex));
                return o;
            }

            #define tau (2.*acos(-1))

            fixed4 frag (v2f i) : SV_Target
            {
				float3 wscp = _WorldSpaceCameraPos;
                if (wscp.y > _SL) clip(-1);
				float3 cameraDir = unity_CameraToWorld._m02_m12_m22;
                float3 viewDir = normalize(i.viewDir);
                float seaDist = length((_SL-wscp.y)/viewDir.y);
                seaDist = viewDir.y > 0 ? seaDist : _ProjectionParams.z;
                fixed4 col;
				float depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, i.projCoord))/dot(cameraDir, viewDir);

                float2 dxGrabPos = ddx(i.grabPos);
                float2 dyGrabPos = ddy(i.grabPos);
                fixed4 grabCol = (fixed4)0;

                float blur = saturate(depth/_Bld)*_Bl;
                grabCol += tex2D(_GrabTex_myxy_UnderWater, (i.grabPos.xy+dxGrabPos*blur)/i.grabPos.w);
                grabCol += tex2D(_GrabTex_myxy_UnderWater, (i.grabPos.xy-dxGrabPos*blur)/i.grabPos.w);
                grabCol += tex2D(_GrabTex_myxy_UnderWater, (i.grabPos.xy+dyGrabPos*blur)/i.grabPos.w);
                grabCol += tex2D(_GrabTex_myxy_UnderWater, (i.grabPos.xy-dyGrabPos*blur)/i.grabPos.w);
                grabCol /= 4;

                float test = depth > seaDist ? 1 : 0;
                depth = depth > seaDist ? seaDist : depth;
                col = grabCol;
                col.rgb += _Color.rgb * min(depth*_Tr2, 1);
                return lerp(col, _SC, 1-exp(-depth*_Tr));
            }
            ENDCG
        }
    }
}
