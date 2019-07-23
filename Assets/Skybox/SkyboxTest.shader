Shader "WakameIsland/SkyboxSunset"
{
	Properties
	{
		_Color3 ("Sun", Color) = (1,0,0,1)
		_Color0 ("Ambient", Color) = (1,1,1,1)
		_Color1 ("Sky", Color) = (0,0,0,1)
		_Th0("Sun size", Range(0,1)) = .1
		_Th1("Ambient size", Range(0,1)) = .2
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
				float3 cameraDir : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 wPos : TEXCOORD0;
			};

			fixed4 _Color0;
			fixed4 _Color1;
			fixed4 _Color3;
			float _Th0;
			float _Th1;
			
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
				col = lerp(_Color0, _Color1, smoothstep(0, _Th1, .5 - .5*dot(normalize(_WorldSpaceLightPos0.xyz), cameraDir)));
				col = lerp(_Color3, col, smoothstep(0, _Th0, .5 - .5*dot(normalize(_WorldSpaceLightPos0.xyz), cameraDir)));
				return col;
			}
			ENDCG
		}
	}
}
