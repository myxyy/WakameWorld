Shader "WakameIsland/Godray"
{
    Properties
    {
        _SL ("Sea level", Float) = 0.
        _Color ("Color", Color) = (1,1,1,1)
        _Pr1 ("Param1", Float) = 7
        _Pr2 ("Param2", Float) = 21
        _Pr3 ("Param3", Range(-10,10)) = .4
        _It ("Intensity", Range(0,1)) = .3
        _Sc ("Scale", Float) = 4
    }
    SubShader
    {
        Tags { "Queue"="AlphaTest+800" "LightMode"="ForwardBase" }
        LOD 100
        ZTest Always
        ZWrite Off

		GrabPass {
			"_GrabTex_myxy_Godray"
		}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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
                float4 grabPos : TEXCOORD2;
                float3 viewDir : TEXCOORD1;
            };

            sampler2D _GrabTex_myxy_Godray;
            sampler2D _CameraDepthTexture;
            float _SL;
            float4 _Color;
            float _Pr1;
            float _Pr2;
            float _Pr3;
            float _It;
            float _Sc;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = float4(1-2*v.uv.x,2*v.uv.y-1,0,1);
                float3 localViewDir = mul(unity_CameraInvProjection, float4(o.vertex.x, -o.vertex.y, 0, 1)).xyz;
                float4x4 vrotate = UNITY_MATRIX_V;
                vrotate._m03 = vrotate._m13 = vrotate._m23 = 0;
                o.viewDir = mul(transpose(vrotate), float4(localViewDir,0)).xyz;

				o.grabPos = ComputeGrabScreenPos(o.vertex);
                return o;
            }

            #define tau (2.*acos(-1))

            float h12(float2 p)
            {
                return frac(sin(dot(p,float2(32.52554,45.5634)))*12432.23553);
            }

            float h13(float3 p)
            {
                return frac(sin(dot(p, float3(23.42554,64.25235,45.24325)))*21345.54215);
            }

            float n12(float2 p)
            {
                float2 i = floor(p);
                float2 f = frac(p);
                f *= f * (3 - 2*f);
                return lerp(
                    lerp(h12(i+float2(0,0)),h12(i+float2(1,0)),f.x),
                    lerp(h12(i+float2(0,1)),h12(i+float2(1,1)),f.x),
                    f.y
                );
            }

            float n13(float3 p)
            {
                float3 i = floor(p);
                float3 f = frac(p);
                f *= f * (3 - 2*f);
                return lerp(
                    lerp(
                        lerp(h13(i+float3(0,0,0)),h13(i+float3(1,0,0)),f.x),
                        lerp(h13(i+float3(0,1,0)),h13(i+float3(1,1,0)),f.x),
                        f.y
                    ),
                    lerp(
                        lerp(h13(i+float3(0,0,1)),h13(i+float3(1,0,1)),f.x),
                        lerp(h13(i+float3(0,1,1)),h13(i+float3(1,1,1)),f.x),
                        f.y
                    ),
                    f.z 
                );
            }

            float caustics(float2 p, float t)
            {
                float3 k = float3(p,t);
                float l;
                float3x3 m = float3x3(-2,-1,2,3,-2,1,1,2,2);
                p *= _Sc;
                float n = n12(p);
                k = mul(m, k) * .5;
                l = length(.5 - frac(k+n));
                k = mul(m, k) * .4;
                l = min(l, length(.5 - frac(k+n)));
                k = mul(m, k) * .3;
                l = min(l, length(.5 - frac(k+n)));
                return pow(saturate(pow(l,_Pr1)*_Pr2),.1);
            }

            float map(float3 p)
            {
                float3 ld = normalize(_WorldSpaceLightPos0.xyz);
                p.x -= p.y*ld.x/ld.y;
                p.z -= p.y*ld.z/ld.y;
                //p *= 2;
                //return n13(float3(p.xz,_Time.y));
                //return n12(float2(p.x,5*n12(float2(p.z,_Time.y))))*1;
                return 1-caustics(p.xz*.1,_Time.y*.1);
                p = frac(p+.5)-.5;
                return length(p)-.1;
            }

            float field(float3 ro, float3 rd)
            {
                float3 rp = ro;
                float d;
                float a = 0;
                float4 scrPos;
                float depth;
                float3 ld = normalize(_WorldSpaceLightPos0.xyz);
                for (int j = 0; j<64; j++)
                {
                    d = map(rp);
                    a += exp(-d*50)*exp((rp.y-_SL)/ld.y*_Pr3);
                    //a += exp(-d*50)*(1+(_SL-rp.y)*_Pr3);
                    rp += d*rd;
                    if (rp.y > _SL) break;
                    scrPos = ComputeScreenPos(mul(UNITY_MATRIX_P,mul(UNITY_MATRIX_V,float4(rp,1))));
				    depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(scrPos)));
                    if (distance(_WorldSpaceCameraPos,rp)>depth)break;
                }
                //return 1/depth;
                return saturate(a)*_It;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float3 wscp = _WorldSpaceCameraPos;
                /*
				#if defined(USING_STEREO_MATRICES)
					wscp = (unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1]) * .5;
				#endif
                */
                if (wscp.y > _SL) clip(-1);
                //float3 viewDir = UNITY_MATRIX_V._m20_m21_m22;
				float3 cameraDir = normalize(mul(-transpose((float3x3)UNITY_MATRIX_V),float3(0,0,1)));
                float3 viewDir = normalize(i.viewDir);
                float seaDist = length((_SL-wscp.y)/viewDir.y);
                seaDist = viewDir.y > 0 ? seaDist : 100000;
                fixed4 col = fixed4(0,0,0,1);
                fixed4 grabCol = tex2D(_GrabTex_myxy_Godray, i.grabPos.xy/i.grabPos.w);

                
                col = grabCol;

                col.rgb += field(wscp, viewDir)*_Color.rgb;

                //return fixed4((fixed3)dot(cameraDir, viewDir),1);
                return col;
            }
            ENDCG
        }
    }
}
