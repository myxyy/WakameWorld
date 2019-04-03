Shader "WakameIsland/Ocean" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_SpecPower("Specular", Float) = 10.0
		_Opacity("Opacity", Range(1,2)) = 1.1
		_Distortion("Distortion", Range(0,1)) = 0.2
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		LOD 200

		Blend SrcAlpha OneMinusSrcAlpha

		GrabPass {"_GrabTex"}

		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _GrabTex;
			sampler2D _CameraDepthTexture;
			float4 _GrabTex_ST;

			struct appdata {
				float4 vertex : POSITION;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 wPos : WORLD_POS;
				float4 grabPos : TEXCOORD0;
				float4 scrPos : TEXCOORD1;
			};

			float random3(float3 p) {
				return frac(sin(float3(dot(p, float3(12.9898, 78.233, 54.5436)), dot(p, float3(32.2352, 57.567, 76.4532)), dot(p, float3(43.2452, 65.366, 23.6543))))*43758.5453);
			}

			float perlinNoise(float3 p) {
				float3 pi = floor(p);
				float3 pf = frac(p);
				float3 pf0 = pf * pf*(3. - 2.*pf);

				float3 v000 = 2.*random3(pi + float3(0, 0, 0)) - 1.;
				float3 v001 = 2.*random3(pi + float3(0, 0, 1)) - 1.;
				float3 v010 = 2.*random3(pi + float3(0, 1, 0)) - 1.;
				float3 v011 = 2.*random3(pi + float3(0, 1, 1)) - 1.;
				float3 v100 = 2.*random3(pi + float3(1, 0, 0)) - 1.;
	;			float3 v101 = 2.*random3(pi + float3(1, 0, 1)) - 1.;
				float3 v110 = 2.*random3(pi + float3(1, 1, 0)) - 1.;
				float3 v111 = 2.*random3(pi + float3(1, 1, 1)) - 1.;

				float3 vx00 = lerp(dot(v000, pf - float3(0, 0, 0)), dot(v100, pf - float3(1, 0, 0)), pf0.x);
				float3 vx01 = lerp(dot(v001, pf - float3(0, 0, 1)), dot(v101, pf - float3(1, 0, 1)), pf0.x);
				float3 vx10 = lerp(dot(v010, pf - float3(0, 1, 0)), dot(v110, pf - float3(1, 1, 0)), pf0.x);
				float3 vx11 = lerp(dot(v011, pf - float3(0, 1, 1)), dot(v111, pf - float3(1, 1, 1)), pf0.x);

				float3 vxy0 = lerp(vx00, vx10, pf0.y);
				float3 vxy1 = lerp(vx01, vx11, pf0.y);

				float3 vxyz = lerp(vxy0, vxy1, pf0.z);

				return vxyz;
			}

			float fBm(float3 p) {
				float f = 0;
				float3 p0 = p;
				f += .5*perlinNoise(p0);
				p0 *= 2.0537;
				f += .25*perlinNoise(p0);
				p0 *= 2.0654;
				f += .125*perlinNoise(p0);
				p0 *= 2.0643;
				f += .0625*perlinNoise(p0);
				return f;
			}

			float _SpecPower;
			float _Opacity;
			float _Distortion;
			fixed4 _Color;

			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.wPos = mul(unity_ObjectToWorld, v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);
				o.scrPos = ComputeScreenPos(o.pos);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 c = _Color;
				float fBm_xzt = .5*fBm(float3(i.wPos.xz, _Time.y)) + .5;
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 viewDir = normalize(_WorldSpaceCameraPos - i.wPos);

				c.rbg *= (float3)fBm_xzt;
				float2 dheight = float2(
					.5*fBm(float3(i.wPos.xz + float2(.001, 0), _Time.y)) + .5 - fBm_xzt,
					.5*fBm(float3(i.wPos.xz + float2(0, .001), _Time.y)) + .5 - fBm_xzt
				);
				float3 normal = normalize(float3(-dheight.x, .001, -dheight.y));

				float3 ref = reflect(-lightDir, normal);
				float refPower = dot(ref, viewDir);
				float3 specPower = pow(max(0,refPower), _SpecPower);
				c.rgb += (float3)specPower;

				float4 grabUV = i.grabPos;
				grabUV.xy = (i.grabPos + _Distortion * normal.xz);

				float depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(grabUV)));
				float surfDepth = UNITY_Z_0_FAR_FROM_CLIPSPACE(i.scrPos.z);
				float depthDiff = depth - surfDepth;
				float transparency = 1 - saturate(1 / pow(_Opacity, depthDiff));
				//c.a = transparency;

				fixed4 grabCol = tex2D(_GrabTex, grabUV.xy/grabUV.w);
				c.rgb = c.rgb*transparency + grabCol * (1 - transparency);
				//c.rgb = grabCol;

				return c;
			}
			ENDCG
		}
	}
	//FallBack "Diffuse"
}
