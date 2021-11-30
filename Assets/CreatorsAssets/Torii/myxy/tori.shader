Shader "WakameIsland/tori"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
		LOD 100

		Pass
		{
			Cull Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 oPos : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.oPos = v.vertex.xyz;
				return o;
			}

			struct frag_out
			{
				fixed4 color : SV_Target;
				float depth : SV_Depth;
			};

			float cylinder_y(float3 p, float r) {
				return length(p.xz) - r;
			}

			float box(float3 p, float3 r) {
				p = abs(p) - r;
				return length(max(p, 0)) + min(0, max(p.x, max(p.y, p.z)));
			}

			float sdf(float3 p) {
				p.x += .05*sin(p.y*10+2*_Time.y);
				p.z += .05*sin(p.y * 10 + _Time.y + UNITY_PI*.5);
				p.y = p.y * (1.1 + .1*_SinTime.w);
				float3 q = p;
				float d;
				q.x = abs(p.x);
				q.x -= .4;
				d = cylinder_y(q, .1);
				d = max(d, -p.y);
				d = max(d, p.y - 2);
				q = p;
				q.y -= 1.5;
				d = min(d, box(q, float3(.8, .05, .2)));
				q = p;
				q.y -= 1.95;
				d = min(d, box(q, float3(.8, .05, .2)));
				return d;
			}

			float3 normal(float3 p) {
				float2 d = float2(0, .001);
				return normalize(
					float3(sdf(p + d.yxx) - sdf(p - d.yxx), sdf(p + d.xyx) - sdf(p - d.xyx), sdf(p + d.xxy) - sdf(p - d.xxy))
				);
			}

			float hl(float3 n, float3 l) {
				return pow(.5*dot(n, l) + .5, 2);
				//return max(0, dot(n, l));
			}

			float3 ObjectToWorldNormal(float3 n) {
				return mul(unity_ObjectToWorld, float4(n, 0)).xyz;
			}
			
			frag_out frag (v2f i)
			{
				frag_out o;
				float3 rgb;
				float3 oscp = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;
				float3 rDir = normalize(i.oPos - oscp);
				float rLen = 0;
				for (int i = 0; i < 64; i++) {
					rLen += sdf(oscp + rDir * rLen);
				}
				float3 rPos = oscp + rDir * rLen;
				float3 wNormal = UnityObjectToWorldNormal(normal(rPos));
				if (sdf(rPos) < .001) {
					float l = hl(wNormal, _WorldSpaceLightPos0);
					rgb = float3(1, 0, 0)*(l*_LightColor0+ShadeSH9(float4(wNormal,1)));
				}
				else discard;

				o.color = float4(rgb, 1);
				float4 vpPos = UnityObjectToClipPos(float4(rPos, 1));
				o.depth = vpPos.z / vpPos.w;

				return o;
			}
			ENDCG
		}
	}
}
