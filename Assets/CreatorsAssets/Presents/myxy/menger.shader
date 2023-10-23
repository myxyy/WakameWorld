Shader "Unlit/menger"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Opaque" }
		LOD 100

		Pass
		{
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "HLSLSupport.cginc"
			#define tau (2.*UNITY_PI)

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 oPos : TEXCOORD1;
				float3 wscp : TEXCOORD2;
			};

			struct frag_out
			{
				fixed4 color : SV_Target;
				float depth : SV_Depth;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.oPos = v.vertex.xyz;
				o.wscp = _WorldSpaceCameraPos;
				return o;
			}

			float sdCube(float3 p, float3 a)
			{
				float3 q = abs(p) - a;
				return length(max(q, (float3)0))+min(max(q.x, max(q.y, q.z)), 0);
			}

			float sdCross(float3 p)
			{
				float2 d = float2(2, 1. / 3.);
				return min(
					sdCube(p, d.xyy),
					min(
						sdCube(p, d.yxy),
						sdCube(p, d.yyx)
					)
				);
			}

			float sdMenger(float3 p)
			{
				float3 q = p;
				float a = 1.;
				q = (frac(a*q / 2. + .5) - .5) / a * 2.;
				float d = max(sdCross(a*q)/a, sdCube(p, (float3)1.1));
				//float d = sdCross(a*q) / a;
				//q = (frac(3.*q / 2. + .5) - .5) / 3.*2.;
				for (int i = 0; i < 4; i++)
				{
					a *= 3.;
					q = (frac(a*q / 2. + .5) - .5) / a * 2.;
					d = min(d, max(sdCross(a*q)/a, sdCube(p, (float3)1.1)));
					//d = min(d, sdCross(a*q) / a);
				}
				return max(sdCube(p, (float3)1), -d);
			}

			float sdSphere(float3 p, float r)
			{
				return length(p) - r;
			}

			float3 hsv2rgb(float h, float s, float v)
			{
				return lerp(1, clamp(abs(frac((float3)h + float3(1, 2. / 3., 1. / 3.)) * 6 - 3) - 1, 0, 1), s)*v;
			}

			float pulse(float t, float a, float n)
			{
				t = frac(t);
				float b = 1 + a / n + 2.*a;
				return clamp(abs(frac(a / b * t + a / b + .5)*b - .5*b) - a, 0, 1);
			}

			float sdf(float3 p)
			{
				float kt = _Time.y*.1;

				return (
					pulse(kt        , 5, 3)*sdMenger(p * 2) / 2 +
					pulse(kt + 1./3., 5, 3)*sdSphere(p, .5) +
					pulse(kt + 2./3., 5, 3)*sdCube(p, .5)
				);
			}

			float3 normal(float3 p)
			{
				float2 d = float2(0, 0.001);
				return normalize(
					float3(
						sdf(p + d.yxx) - sdf(p - d.yxx),
						sdf(p + d.xyx) - sdf(p - d.xyx),
						sdf(p + d.xxy) - sdf(p - d.xxy)
						)
				);
			}
			
			frag_out frag(v2f i)
			{
				frag_out o;
				float3 rPos = mul(unity_WorldToObject, float4(i.wscp, 1)).xyz;
				float3 vDir = normalize(i.oPos - rPos);

				for (int j = 0; j < 64; j++)
				{
					rPos += vDir * sdf(rPos);
				}

				if (abs(sdf(rPos)) > .001) clip(-1);

				float3 nml = UnityObjectToWorldNormal(normal(rPos));

				float3 rflt = reflect(UnityObjectToWorldDir(vDir), nml);
				
				fixed4 specularColorI = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, rflt, 0);

				specularColorI.rgb = DecodeHDR(specularColorI, unity_SpecCube0_HDR);

				o.color = specularColorI;
				//o.color.rgb = dot(nml, (float3)1);
				float4 vpPos = UnityObjectToClipPos(float4(rPos,1));
				o.depth = vpPos.z / vpPos.w;
				return o;
			}
			ENDCG
		}
	}
}
