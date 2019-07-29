Shader "WakameIsland/SkyboxSunset3"
{
	Properties
	{
		_MainTex("Texture", CUBE) = "white" {}
		_YRotate("YRotate", Range(0,1)) = 0
		_Height("Height", Range(0,1)) = 0
	}
	SubShader
	{
		Tags {
			"RenderType" = "Background"
			"Queue" = "Background"
			"PreviewType" = "SkyBox"
		}
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define TAU (UNITY_PI*2.)
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 wPos : TEXCOORD0;
			};

			samplerCUBE _MainTex;
			float _YRotate;
			float _Height;

			float2x2 rotate(float a) {
				return float2x2(cos(a), -sin(a), sin(a), cos(a));
			}
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.wPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)).xyz;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col;
				float3 cameraDir = normalize(i.wPos - _WorldSpaceCameraPos);
				cameraDir.xz = mul(cameraDir.xz, rotate(TAU*_YRotate));

				float a = atan2(cameraDir.z, cameraDir.x);
				cameraDir.xz = mul(rotate(-a), cameraDir.xz);
				cameraDir.xy = mul(rotate(atan2(cameraDir.x, cameraDir.y)*_Height), cameraDir.xy);
				cameraDir.xz = mul(rotate(a), cameraDir.xz);

				col = texCUBE(_MainTex, cameraDir);
				return col;
			}
			ENDCG
		}
	}
}
