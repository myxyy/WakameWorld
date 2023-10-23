Shader "WakameIsland/SkyboxGrad"
{
	Properties
	{
		_Color3 ("Sun", Color) = (1,0,0,1)
		_Color0 ("Sky1", Color) = (1,1,1,1)
		_Color2 ("Sky2", Color) = (1,1,1,1)
		_Color1 ("Ambient", Color) = (0,0,0,1)
		_Ex ("Param1", Range(0,1)) = 0.2
		_Ex2 ("Param2", Range(0,10)) = 0.2
		_Ex3 ("Param3", Range(0,10)) = 0.2
		_Th0("Sun size", Range(0,.25)) = .1
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
			fixed4 _Color2;
			fixed4 _Color3;
			float _Th0;
			float _Th1;
			float _Ex;
			float _Ex2;
			float _Ex3;

			#define tau  (2*acos(-1));
			
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

				float a = atan2(cameraDir.y, length(cameraDir.xz))/tau;
				
				a *= (3-2*a)*a;

				col = lerp(_Color0,_Color2,pow(max(0,a*4),_Ex));
				float s = acos(dot(normalize(_WorldSpaceLightPos0.xyz), cameraDir))/tau;
				col = lerp(_Color3, col, pow(smoothstep(0, _Th0, s),_Ex2));
				float s2 = acos(dot(normalize(_WorldSpaceLightPos0.xyz), cameraDir))/tau;
				col = lerp(_Color1, col, pow(smoothstep(0, _Th1, s2),_Ex3));
				return fixed4(col.rgb, 1);
			}
			ENDCG
		}
	}
}
