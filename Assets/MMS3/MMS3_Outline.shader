// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MMS3/Mnmrshader3_Outline"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Float) = 2
		_AmbientMinimum("Ambient Minimum", Range( 0 , 1)) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_DiffuseColor("Color", Color) = (1,1,1,1)
		[Normal]_NormalMap("Normal Map", 2D) = "bump" {}
		_EmissionMap1("Emission", 2D) = "black" {}
		_Emission_Color("Emission_Color", Color) = (1,1,1,1)
		_Shade_Matcap("Shade_Matcap", 2D) = "white" {}
		_Shade_Matcap_Color("Shade_Matcap_Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		[NoScaleOffset]_Shade_Matcap_Mask("Shade_Matcap_Mask", 2D) = "white" {}
		_BassColor_HardLight("BassColor_HardLight", Range( 0 , 1)) = 0.3
		_BassColor_Add("BassColor_Screen", Range( 0 , 1)) = 1
		_Shade_Matcap_Min("Shade_Matcap_Min", Range( 0 , 1)) = 0
		_Shade_Matcap_Max("Shade_Matcap_Max", Range( 0 , 1)) = 1
		_Add_Matcap("Add_Matcap", 2D) = "black" {}
		_Add_Matcap_Color("Add_Matcap_Color", Color) = (1,1,1,1)
		[NoScaleOffset]_Add_MatcapMask("Add_Matcap Mask", 2D) = "white" {}
		_RimLight_Color("RimLight_Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		_RimLight_Mask("RimLight_Mask", 2D) = "white" {}
		_RimLight_Power("RimLight_Power", Range( 0 , 1)) = 0
		_RimLight_Blur("RimLight_Blur", Range( 0 , 20)) = 5
		_Outline_Color("Outline_Color", Color) = (0.1960784,0.1960784,0.1960784,1)
		[Toggle]_BaseColor_Mix("BaseColor_Mix", Float) = 1
		_Outline_Width("Outline_Width", Range( 0 , 1)) = 0
		[NoScaleOffset]_Outline_Mask("Outline_Mask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_Outline_Mask102 = v.texcoord;
			float4 Outline_Width109 = ( (0.0 + (_Outline_Width - 0.0) * (0.003 - 0.0) / (1.0 - 0.0)) * tex2Dlod( _Outline_Mask, float4( uv_Outline_Mask102, 0, 0.0) ) );
			float outlineVar = Outline_Width109.r;
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 temp_output_16_0 = ( tex2D( _MainTex, uv_MainTex ) * _DiffuseColor );
			float4 BaseColor17 = temp_output_16_0;
			float3 localFunction_ShadeSH95 = Function_ShadeSH9();
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 ifLocalVar22 = 0;
			if( _WorldSpaceLightPos0.w <= 0.0 )
				ifLocalVar22 = ase_lightColor;
			else
				ifLocalVar22 = ( 1 * ase_lightColor );
			float4 temp_cast_2 = (_AmbientMinimum).xxxx;
			float4 clampResult3 = clamp( ( float4( localFunction_ShadeSH95 , 0.0 ) + ifLocalVar22 ) , temp_cast_2 , float4( 1,1,1,0 ) );
			float4 Lighting4 = saturate( clampResult3 );
			float2 uv_EmissionMap1 = i.uv_texcoord * _EmissionMap1_ST.xy + _EmissionMap1_ST.zw;
			float4 Emission107 = ( tex2D( _EmissionMap1, uv_EmissionMap1 ) * _Emission_Color );
			float4 Outline_Color108 = ( ( float4( ( lerp(float3( 1,1,1 ),(BaseColor17).rgb,_BaseColor_Mix) * (_Outline_Color).rgb ) , 0.0 ) * Lighting4 ) + Emission107 );
			o.Emission = Outline_Color108.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _CullMode;
		uniform sampler2D _EmissionMap1;
		uniform float4 _EmissionMap1_ST;
		uniform float4 _Emission_Color;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _RimLight_Power;
		uniform float _RimLight_Blur;
		uniform float4 _RimLight_Color;
		uniform sampler2D _RimLight_Mask;
		uniform float4 _RimLight_Mask_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _DiffuseColor;
		uniform sampler2D _Add_Matcap;
		uniform float4 _Add_Matcap_Color;
		uniform sampler2D _Add_MatcapMask;
		uniform sampler2D _Shade_Matcap;
		uniform float _Shade_Matcap_Min;
		uniform float _Shade_Matcap_Max;
		uniform float4 _Shade_Matcap_Color;
		uniform float _BassColor_HardLight;
		uniform float _BassColor_Add;
		uniform sampler2D _Shade_Matcap_Mask;
		uniform float _AmbientMinimum;
		uniform float _Outline_Width;
		uniform sampler2D _Outline_Mask;
		uniform float _BaseColor_Mix;
		uniform float4 _Outline_Color;


		float3 Function_ShadeSH9(  )
		{
			return ShadeSH9(half4(0,0,0,1));
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode66 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult47 = dot( (WorldNormalVector( i , tex2DNode66 )) , ase_worldViewDir );
			float2 uv_RimLight_Mask = i.uv_texcoord * _RimLight_Mask_ST.xy + _RimLight_Mask_ST.zw;
			float4 lerpResult73 = lerp( ( ( ( ( ( abs( ( 1.0 - dotResult47 ) ) * _RimLight_Power ) - 0.5 ) * _RimLight_Blur ) + 0.5 ) * _RimLight_Color ) , float4( 0,0,0,0 ) , ( 1.0 - tex2D( _RimLight_Mask, uv_RimLight_Mask ) ));
			float4 RimLight81 = saturate( lerpResult73 );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 temp_output_16_0 = ( tex2D( _MainTex, uv_MainTex ) * _DiffuseColor );
			float4 BaseColor17 = temp_output_16_0;
			float3 NormalMap42 = tex2DNode66;
			float3 temp_output_67_0 = ( 0.5 + ( 0.5 * (mul( UNITY_MATRIX_V, float4( (WorldNormalVector( i , NormalMap42 )) , 0.0 ) ).xyz).xyz ) );
			float4 tex2DNode54 = tex2D( _Add_Matcap, temp_output_67_0.xy );
			float4 blendOpSrc64 = tex2DNode54;
			float4 blendOpDest64 = _Add_Matcap_Color;
			float2 uv_Add_MatcapMask58 = i.uv_texcoord;
			float4 lerpResult84 = lerp( float4( 0,0,0,0 ) , ( saturate( ( blendOpSrc64 * blendOpDest64 ) )) , tex2D( _Add_MatcapMask, uv_Add_MatcapMask58 ));
			float4 Matcap83 = ( BaseColor17 + lerpResult84 );
			float4 tex2DNode52 = tex2D( _Shade_Matcap, temp_output_67_0.xy );
			float4 temp_cast_5 = (_Shade_Matcap_Min).xxxx;
			float4 temp_cast_6 = (_Shade_Matcap_Max).xxxx;
			float4 blendOpSrc79 = (float4( 0,0,0,0 ) + (tex2DNode52 - temp_cast_5) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (temp_cast_6 - temp_cast_5));
			float4 blendOpDest79 = _Shade_Matcap_Color;
			float4 blendOpSrc117 = BaseColor17;
			float4 blendOpDest117 = ( saturate( ( blendOpSrc79 + blendOpDest79 ) ));
			float4 lerpBlendMode117 = lerp(blendOpDest117, (( blendOpSrc117 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc117 - 0.5 ) ) * ( 1.0 - blendOpDest117 ) ) : ( 2.0 * blendOpSrc117 * blendOpDest117 ) ),_BassColor_HardLight);
			float4 blendOpSrc118 = BaseColor17;
			float4 blendOpDest118 = ( saturate( lerpBlendMode117 ));
			float4 lerpBlendMode118 = lerp(blendOpDest118,( 1.0 - ( 1.0 - blendOpSrc118 ) * ( 1.0 - blendOpDest118 ) ),_BassColor_Add);
			float2 uv_Shade_Matcap_Mask135 = i.uv_texcoord;
			float4 lerpResult136 = lerp( float4( 1,1,1,0 ) , ( saturate( lerpBlendMode118 )) , tex2D( _Shade_Matcap_Mask, uv_Shade_Matcap_Mask135 ));
			float4 MatcapShadow36 = lerpResult136;
			float3 localFunction_ShadeSH95 = Function_ShadeSH9();
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 ifLocalVar22 = 0;
			if( _WorldSpaceLightPos0.w <= 0.0 )
				ifLocalVar22 = ase_lightColor;
			else
				ifLocalVar22 = ( ase_lightAtten * ase_lightColor );
			float4 temp_cast_8 = (_AmbientMinimum).xxxx;
			float4 clampResult3 = clamp( ( float4( localFunction_ShadeSH95 , 0.0 ) + ifLocalVar22 ) , temp_cast_8 , float4( 1,1,1,0 ) );
			float4 Lighting4 = saturate( clampResult3 );
			c.rgb = saturate( ( ( RimLight81 + Matcap83 ) * MatcapShadow36 * Lighting4 ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_EmissionMap1 = i.uv_texcoord * _EmissionMap1_ST.xy + _EmissionMap1_ST.zw;
			float4 Emission107 = ( tex2D( _EmissionMap1, uv_EmissionMap1 ) * _Emission_Color );
			o.Emission = Emission107.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
311;252;1555;781;1499.252;1518.044;1.299367;True;True
Node;AmplifyShaderEditor.CommentaryNode;143;-3323.448,-2332.592;Inherit;False;3010.848;574.3976;;21;66;42;46;82;47;76;49;63;75;43;61;33;69;45;74;55;59;44;73;77;81;Rimlight;0.2938324,0.4416421,0.8773585,1;0;0
Node;AmplifyShaderEditor.SamplerNode;66;-3273.448,-2240.764;Inherit;True;Property;_NormalMap;Normal Map;4;1;[Normal];Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-2912.708,-2282.592;Float;False;NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;141;-3335.313,-1604.88;Inherit;False;3435.477;875.0003;;32;138;122;123;124;125;80;39;67;52;128;127;56;129;26;54;116;58;79;64;119;72;117;84;121;135;32;118;83;136;36;147;148;Matcap;1,0.5915164,0.4575472,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;46;-2900.287,-2200.519;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;138;-3285.313,-1236.871;Inherit;False;42;NormalMap;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;82;-2896.93,-2057.212;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;122;-3060.589,-1218.289;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;47;-2690.922,-2126.088;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewMatrixNode;123;-3036.269,-1342.541;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-2844.364,-1277.919;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;76;-2541.047,-2124.521;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1;-3342.618,-2984.137;Inherit;False;1869.626;445.3056;Copyright (c) 2018 Reflex  Released under the MIT license;12;13;10;9;7;6;5;4;3;21;22;23;157;Lighting;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2511.609,-2050.961;Float;False;Property;_RimLight_Power;RimLight_Power;21;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;125;-2673.747,-1285.907;Inherit;False;True;True;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;49;-2338.849,-2129.823;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-2666.179,-1430.732;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;21;-3280.196,-2858.953;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;156;-1853.477,-699.6858;Inherit;False;1791.567;919.4097;;16;151;152;150;154;155;153;149;146;107;106;105;104;17;16;14;15;Basecolor;0.3049396,0.9528302,0,1;0;0
Node;AmplifyShaderEditor.LightColorNode;9;-3251.908,-2719.732;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;43;-2220.907,-1897.385;Float;False;Constant;_Float9;Float 9;20;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2440.568,-1346.913;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2184.063,-2116.373;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;23;-3090.138,-2882.115;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;14;-1660.957,12.72389;Float;False;Property;_DiffuseColor;Color;3;0;Create;False;0;0;False;0;1,1,1,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-1753.477,-186.7982;Inherit;True;Property;_MainTex;MainTex;2;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2999.6,-2795.493;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-2025.376,-2112.689;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-2188.472,-1428.379;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2217.534,-1982.874;Float;False;Property;_RimLight_Blur;RimLight_Blur;22;0;Create;True;0;0;False;0;5;3;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;5;-2791.141,-2921.396;Float;False;return ShadeSH9(half4(0,0,0,1))@$;3;False;0;Function_ShadeSH9;False;False;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1410.37,-76.93811;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;22;-2818.62,-2800.684;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-1961.244,-1177.682;Float;False;Property;_Shade_Matcap_Min;Shade_Matcap_Min;12;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-1956.399,-1104.45;Float;False;Property;_Shade_Matcap_Max;Shade_Matcap_Max;13;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;52;-1983.355,-1389.961;Inherit;True;Property;_Shade_Matcap;Shade_Matcap;7;0;Create;True;0;0;False;0;ece969dbfb97d446ba8f8358a78789b5;ece969dbfb97d446ba8f8358a78789b5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1823.153,-2093.646;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-2528.542,-2895.195;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-1170.467,-81.3074;Float;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;140;-3361.197,-628.7159;Inherit;False;1453.857;860.6276;Outline;16;95;97;96;139;131;94;91;99;100;102;93;90;103;92;108;109;;1,0.2688679,0.2688679,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2579.601,-2750.249;Float;False;Property;_AmbientMinimum;Ambient Minimum;1;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-1876.07,-1979.493;Float;False;Property;_RimLight_Color;RimLight_Color;19;0;Create;True;0;0;False;0;0.3921569,0.3921569,0.3921569,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;26;-1650.21,-1040.139;Float;False;Property;_Shade_Matcap_Color;Shade_Matcap_Color;8;0;Create;True;0;0;False;0;0.3921569,0.3921569,0.3921569,1;0.7843137,0.7843137,0.7843137,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;56;-1328.534,-1382.925;Float;False;Property;_Add_Matcap_Color;Add_Matcap_Color;16;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;129;-1620.319,-1330.564;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;74;-1596.122,-1986.194;Inherit;True;Property;_RimLight_Mask;RimLight_Mask;20;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;54;-1635.703,-1546.084;Inherit;True;Property;_Add_Matcap;Add_Matcap;15;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;3;-2265.675,-2894.715;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-3311.197,-557.697;Inherit;False;17;BaseColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1581.524,-2098.484;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;64;-1038.683,-1497.062;Inherit;False;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1376.856,-2108.202;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;58;-1061.891,-1381.015;Inherit;True;Property;_Add_MatcapMask;Add_Matcap Mask;17;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;44;-1304.25,-1976.899;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-1322.806,-1214.5;Inherit;False;17;BaseColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-1411.008,-960.1365;Float;False;Property;_BassColor_HardLight;BassColor_HardLight;10;0;Create;True;0;0;False;0;0.3;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;105;-1691.056,-398.6626;Float;False;Property;_Emission_Color;Emission_Color;6;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;97;-3332.975,-466.1384;Float;False;Property;_Outline_Color;Outline_Color;23;0;Create;True;0;0;False;0;0.1960784,0.1960784,0.1960784,1;0.2941176,0.2941176,0.2941176,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;96;-3133.343,-561.2586;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;10;-2054.254,-2896.253;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;104;-1746.138,-599.6858;Inherit;True;Property;_EmissionMap1;Emission;5;0;Create;False;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;79;-1350.238,-1132.295;Inherit;False;LinearDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;117;-1031.892,-1085.242;Inherit;False;HardLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;73;-1087.156,-2085.308;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-1088.625,-945.6472;Float;False;Property;_BassColor_Add;BassColor_Screen;11;0;Create;False;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;84;-679.3104,-1453.109;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-552.4316,-1554.88;Inherit;False;17;BaseColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-1706.449,-2901.625;Float;False;Lighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1392.492,-481.893;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;131;-2911.692,-578.7159;Inherit;False;Property;_BaseColor_Mix;BaseColor_Mix;24;0;Create;True;0;0;False;0;1;2;0;FLOAT3;1,1,1;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;139;-3100.189,-459.3617;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;77;-903.1707,-2084.498;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;118;-730.3636,-1100.688;Inherit;False;Screen;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-322.6388,-1447.932;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;135;-771.4473,-959.8797;Inherit;True;Property;_Shade_Matcap_Mask;Shade_Matcap_Mask;9;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;91;-2714.708,-437.2303;Inherit;False;4;Lighting;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-2679.775,-536.4532;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-3173.041,-197.2671;Float;False;Property;_Outline_Width;Outline_Width;25;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-1186.285,-475.7793;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-707.5245,-2092.89;Float;False;RimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-133.8361,-1432.909;Float;False;Matcap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;136;-440.907,-1165.624;Inherit;False;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;100;-2844.225,-242.723;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.003;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;-2503.039,-414.539;Inherit;False;107;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-2493.754,-506.9491;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;102;-3144.338,-90.18736;Inherit;True;Property;_Outline_Mask;Outline_Mask;26;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;110;770.9203,-1449.138;Inherit;False;81;RimLight;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;770.0473,-1265.534;Inherit;False;83;Matcap;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-2289.039,-474.5392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-2624.428,-140.127;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-190.26,-1137.941;Float;False;MatcapShadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;814.6232,-1099.058;Inherit;False;36;MatcapShadow;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;991.3978,-1373.534;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-2141.34,-469.9782;Inherit;False;Outline_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-2425.908,-112.0373;Inherit;False;Outline_Width;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;885.7363,-990.1011;Inherit;False;4;Lighting;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;1169.931,-1003.469;Inherit;False;109;Outline_Width;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;1163.164,-1270.674;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;1165.751,-1084.803;Inherit;False;108;Outline_Color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;154;-697.5918,-389.5416;Inherit;False;Property;_Add_Matcap_Alpha;Add_Matcap_Alpha;18;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;1350.625,-1445.653;Inherit;False;107;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;153;-1125.783,-369.4604;Inherit;False;Property;_Shade_Matcap_Alpha;Shade_Matcap_Alpha;14;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;158;1563.263,-1238.908;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;-295.9102,-284.5654;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;146;-1227.844,-259.1736;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;148;-1316.593,-1475.188;Inherit;False;Add_Matcap_A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-1642.687,-2745.094;Float;False;Property;_CullMode;Cull Mode;0;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;-903.1801,-387.6817;Inherit;False;148;Add_Matcap_A;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;151;-893.7826,-278.4604;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-1373.051,-374.4102;Inherit;False;147;Shade_Matcap_A;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;-450.7826,-304.4604;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-1621.539,-1139.529;Inherit;False;Shade_Matcap_A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OutlineNode;134;1433.856,-1114.061;Inherit;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1756.146,-1452.237;Float;False;True;2;ASEMaterialInspector;0;0;CustomLighting;MMS3/Mnmrshader3_Outline;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;5;False;-1;7;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;157;-1;0;True;159;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;42;0;66;0
WireConnection;46;0;66;0
WireConnection;122;0;138;0
WireConnection;47;0;46;0
WireConnection;47;1;82;0
WireConnection;124;0;123;0
WireConnection;124;1;122;0
WireConnection;76;0;47;0
WireConnection;125;0;124;0
WireConnection;49;0;76;0
WireConnection;39;0;80;0
WireConnection;39;1;125;0
WireConnection;75;0;49;0
WireConnection;75;1;63;0
WireConnection;13;0;21;0
WireConnection;13;1;9;0
WireConnection;61;0;75;0
WireConnection;61;1;43;0
WireConnection;67;0;80;0
WireConnection;67;1;39;0
WireConnection;16;0;15;0
WireConnection;16;1;14;0
WireConnection;22;0;23;2
WireConnection;22;2;13;0
WireConnection;22;3;9;0
WireConnection;22;4;9;0
WireConnection;52;1;67;0
WireConnection;69;0;61;0
WireConnection;69;1;33;0
WireConnection;6;0;5;0
WireConnection;6;1;22;0
WireConnection;17;0;16;0
WireConnection;129;0;52;0
WireConnection;129;1;127;0
WireConnection;129;2;128;0
WireConnection;54;1;67;0
WireConnection;3;0;6;0
WireConnection;3;1;7;0
WireConnection;55;0;69;0
WireConnection;55;1;43;0
WireConnection;64;0;54;0
WireConnection;64;1;56;0
WireConnection;59;0;55;0
WireConnection;59;1;45;0
WireConnection;44;0;74;0
WireConnection;96;0;95;0
WireConnection;10;0;3;0
WireConnection;79;0;129;0
WireConnection;79;1;26;0
WireConnection;117;0;116;0
WireConnection;117;1;79;0
WireConnection;117;2;119;0
WireConnection;73;0;59;0
WireConnection;73;2;44;0
WireConnection;84;1;64;0
WireConnection;84;2;58;0
WireConnection;4;0;10;0
WireConnection;106;0;104;0
WireConnection;106;1;105;0
WireConnection;131;1;96;0
WireConnection;139;0;97;0
WireConnection;77;0;73;0
WireConnection;118;0;116;0
WireConnection;118;1;117;0
WireConnection;118;2;121;0
WireConnection;32;0;72;0
WireConnection;32;1;84;0
WireConnection;94;0;131;0
WireConnection;94;1;139;0
WireConnection;107;0;106;0
WireConnection;81;0;77;0
WireConnection;83;0;32;0
WireConnection;136;1;118;0
WireConnection;136;2;135;0
WireConnection;100;0;99;0
WireConnection;93;0;94;0
WireConnection;93;1;91;0
WireConnection;92;0;93;0
WireConnection;92;1;90;0
WireConnection;103;0;100;0
WireConnection;103;1;102;0
WireConnection;36;0;136;0
WireConnection;114;0;110;0
WireConnection;114;1;112;0
WireConnection;108;0;92;0
WireConnection;109;0;103;0
WireConnection;115;0;114;0
WireConnection;115;1;113;0
WireConnection;115;2;130;0
WireConnection;154;1;150;0
WireConnection;153;1;149;0
WireConnection;158;0;115;0
WireConnection;155;0;152;0
WireConnection;146;0;16;0
WireConnection;148;0;54;4
WireConnection;151;0;153;0
WireConnection;151;1;146;3
WireConnection;152;0;154;0
WireConnection;152;1;151;0
WireConnection;147;0;52;4
WireConnection;134;0;132;0
WireConnection;134;1;133;0
WireConnection;0;2;111;0
WireConnection;0;13;158;0
WireConnection;0;11;134;0
ASEEND*/
//CHKSM=75FDEA86F4B42A16087BCFFEF5EA344A0FA6408C