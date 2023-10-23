Shader "WakameIsland/ReactorNoise" {
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
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		float H12(float2 p) {
			return frac(sin(dot(p, float2(13.6326, 12.2412)))*56272.5425);
		}

		float N12(float2 p) {
			float2 i = floor(p);
			float2 f = frac(p);
			f *= f * (3. - 2.*f);
			return lerp(
				lerp(H12(i + float2(0., 0.)), H12(i + float2(1., 0.)), f.x),
				lerp(H12(i + float2(0., 1.)), H12(i + float2(1., 1.)), f.x),
				f.y
			);
		}

		float2x2 rot(float a) {
			float c = cos(a), s = sin(a);
			return float2x2(c, -s, s, c);
		}

		float F12(float2 p) {
			float a = 1.;
			float o = 0.;
			for (int i = 0; i < 4; i++) {
				o += N12(p*a) / (2.*a);
				p = mul(rot(4.736), p);
				a *= 2.;
			}
			return o;
		}

		struct Input {
			float2 uv_MainTex;
			float3 oPos;
		};

		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.oPos = v.vertex.xyz;
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
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			float3 oP = IN.oPos;
			oP.xy = mul(rot(_Time.y*0.4), oP.xy);
			oP *= 4.;
			float kt = _Time.y*0.5;
			float noise = F12(float2(oP.z, kt + F12(float2(kt + oP.x, kt + oP.y))));
			noise = clamp(noise*1.1, 0., 1.);
			noise = pow(noise, 4.);
			o.Albedo = lerp(float3(0., 0., 0.), float3(0., 1., 0.), noise);
			o.Emission = lerp(float3(0., 0., 0.), float3(0., 1., 0.), noise);
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
