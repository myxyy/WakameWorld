Shader "Custom/Island" {
	Properties {
		_MainTex ("Texture1", 2D) = "white" {}
		_SecondTex ("Texture2", 2D) = "white" {}
		_MaskTex ("Mask", 2D) = "white" {}
		_Test ("Test", Range(0,1)) = 1
		_SB ("SandBrightness", Float) = 1
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
		sampler2D _SecondTex;
		sampler2D _MaskTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SecondTex;
			float2 uv_MaskTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed _Test;
		fixed _SB;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 s = tex2D(_SecondTex, IN.uv_SecondTex)*_SB;
			fixed4 m = tex2D(_MaskTex, IN.uv_MaskTex)*_Test;
			o.Albedo = c.rgb*m+s.rgb*(1-m);
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
