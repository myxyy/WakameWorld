Shader "Custom/Sea" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
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
			float3 v101 = 2.*random3(pi + float3(1, 0, 1)) - 1.;
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

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			float fBm_xzt = .5*fBm(float3(IN.worldPos.xz, _Time.y)) + .5;
			o.Albedo *= (float3)fBm_xzt;
			float2 dheight = float2(
				.5*fBm(float3(IN.worldPos.xz + float2(.001, 0), _Time.y)) + .5 - fBm_xzt,
				.5*fBm(float3(IN.worldPos.xz + float2(0, .001), _Time.y)) + .5 - fBm_xzt
			);
			o.Normal = normalize(float3(-dheight.x, .001, -dheight.y));
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
