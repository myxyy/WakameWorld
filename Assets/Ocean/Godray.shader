Shader "myxy/WaterShader/Godray"
{
    Properties
    {
        [MaterialToggle] _ESL ("Enable Sea level", Float) = 1
        _SL ("Sea level", Float) = 0.
        _Color ("Color", Color) = (1,1,1,1)
        _Pr1 ("Caustics parameter 1", Float) = 7
        _Pr2 ("Caustics parameter 2", Float) = 21
        _Pr3 ("Attenuation rate", Range(0,10)) = .4
        _Pr4 ("Raymarching parameter", Range(0,2)) = 1
        _It ("Intensity", Range(0,1)) = .3
        _Sc ("Scale", Float) = .1
        _TSc ("Time scale", Float) = .1
    }
    SubShader
    {
        Tags { "Queue"="AlphaTest+302" "LightMode"="ForwardBase" }
        LOD 100
        ZTest Always
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

		GrabPass {
			"_GrabTex_myxy_Godray"
		}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                noperspective float4 grabPos : TEXCOORD2;
                noperspective float4 scrPos : TEXCOORD3;
                float3 viewDir : TEXCOORD1;
            };

            sampler2D _GrabTex_myxy_Godray;
            sampler2D _CameraDepthTexture;
            float _ESL;
            float _SL;
            float4 _Color;
            float _Pr1;
            float _Pr2;
            float _Pr3;
            float _Pr4;
            float _It;
            float _Sc;
            float _TSc;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = float4(1-2*v.uv.x,2*v.uv.y-1,0,1);
                float3 localViewDir = mul(unity_CameraInvProjection, float4(o.vertex.x, -o.vertex.y, 0, 1)).xyz;
                float4x4 vrotate = UNITY_MATRIX_V;
                o.viewDir = mul(transpose(vrotate), localViewDir);

                o.scrPos = UNITY_PROJ_COORD(ComputeScreenPos(mul(UNITY_MATRIX_P,float4(localViewDir,1))));
				o.grabPos = ComputeGrabScreenPos(o.vertex);
                return o;
            }

            float caustics(float2 p, float t)
            {
                float3 k = float3(p,t);
                float l = 1;
                float3x3 m = float3x3(2,-2,1,-2,-1,2,1,2,2)*.4;

                [unroll]
                for(int i=0;i<3;i++)
                {
                    k = mul(m, k);
                    l = min(l, length(.5 - frac(k)));
                }
                return pow(saturate(pow(l,_Pr1)*_Pr2),.1);
            }

            float map(float3 p)
            {
                float3 ld = normalize(_WorldSpaceLightPos0.xyz);
                p.xz -= p.y*ld.xz/ld.y;
                return 1-caustics(p.xz*_Sc,_Time.y*_TSc);
            }

            float field(float3 ro, float3 rd, float4 scrPos)
            {
                float3 rp = ro;
                float d;
                float a = 0;
                float depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, scrPos));
                float3 ld = normalize(_WorldSpaceLightPos0.xyz);
                for (int j = 0; j<128; j++)
                {
                    d = map(rp);
                    a += exp(-d*50+(rp.y-_SL)/ld.y*_Pr3);
                    rp += d*rd*_Pr4;
                    if (rp.y > _SL && _ESL) break;
                    if (distance(_WorldSpaceCameraPos,rp)>depth)break;
                }
                return saturate(a)*_It;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float3 wscp = _WorldSpaceCameraPos;
                if (wscp.y > _SL) clip(-1);
				float3 cameraDir = unity_CameraToWorld._m02_m12_m22;
                float3 viewDir = normalize(i.viewDir);
                float seaDist = length((_SL-wscp.y)/viewDir.y);
                seaDist = viewDir.y > 0 ? seaDist : 100000;
                fixed4 col = fixed4(_Color.rgb,field(wscp, viewDir, i.scrPos));

                return col;
            }
            ENDCG
        }
    }
}