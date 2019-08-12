Shader "WakameIsland/SkyboxFromImage"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

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
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.wPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.)).xyz;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				i.wPos = normalize(i.wPos);
				float axz = atan2(i.wPos.z, i.wPos.x);
				float ay = atan2(length(i.wPos.xz), i.wPos.y);
				fixed4 col = tex2D(_MainTex, ay/(2.*UNITY_PI/4.)*float2(cos(axz), sin(axz))*.5 + .5);
				return col;
			}
			ENDCG
		}
	}
}
