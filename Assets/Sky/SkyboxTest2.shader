Shader "WakameIsland/SkyboxSunset2"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
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

			sampler2D _MainTex;
			float _YRotate;
			float _Height;
			
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
				float2 uv;
				uv.x = atan2(cameraDir.z, cameraDir.x) / (2.*UNITY_PI)+_YRotate;
				uv.y = smoothstep(0,1,atan2(cameraDir.y, length(cameraDir.xz)) / (2.*UNITY_PI)*.5 + .5)+_Height;
				col = tex2D(_MainTex, uv);
				return col;
			}
			ENDCG
		}
	}
}
