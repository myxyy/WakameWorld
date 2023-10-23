Shader "Unlit/level"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_r("r", Float) = 0
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				// make fog work
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float _r;
				#define tau (2.*UNITY_PI)

				v2f vert(appdata v)
				{
					v2f o;
					float4x4 M = UNITY_MATRIX_M;
					float a = -atan((M._m01*M._m22 - M._m02*M._m21) / (M._m02*M._m20 - M._m00*M._m22));
					v.vertex.xy = float2(v.vertex.x*cos(a) - v.vertex.y*sin(a), v.vertex.x*sin(a) + v.vertex.y*cos(a));
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = fixed4(1,0,0,1);
					float2 p = 2.*i.uv - 1.;
					float a = atan2(p.y, p.x);
					float x = frac(a / tau-1/4.);
					float f = abs(1. / 600./ (x - .5));
					clip(f>length(p)&&length(p)<1.?1:-1);
					return col;
				}
				ENDCG
			}
		}
}