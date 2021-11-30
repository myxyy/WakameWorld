Shader "Unlit/leveler_scale"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
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
			#define tau (2.*UNITY_PI)
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = (fixed4)1.;

				//col = fixed4(i.uv.x, i.uv.y, 0, 1);
				float2 p = 2.*i.uv - 1.;
				//col = fixed4(.5*p.x + .5, .5*p.y + .5, 0, 1);

				clip((p.y < 0 && length(p) < 1.)?1:-1);
				float a = atan2(p.y, p.x)+tau;
				col = .5-abs(fmod(a/tau,1./60)*60-.5)<.1 && length(p)>.9? fixed4(0, 0, 0, 1) : col;
				col = abs(a - tau * 3. / 4) < .01 && length(p)>.8? fixed4(0, 0, 0, 1) : col;

				return col;
			}
			ENDCG
		}
	}
}
