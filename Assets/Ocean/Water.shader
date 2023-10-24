Shader "myxy/WaterShader/Water" {
	Properties{
		[Header(Color)]
		_Color("Color deep", Color) = (0,0,1,1)
		_ColorShallow("Color shallow", Color) = (0.5,0.5,1,1)
		_Pa1("Color gradient parameter", Range(0.1,10)) = 5
		_Opacity("Opacity", Range(0,5)) = 0.1
		[Header(Wave and Noise)]
		[KeywordEnum(World, Object, UV, UVTorus)] _NoiseSpace ("Noise space", Float) = 0
		[MaterialToggle] _NormalByVector ("Normal by vector:ON/Normal by height:OFF", Float) = 0
		_WH("Wave height", Range(0,10)) = 1
		_Distortion("Distortion", Range(0,1)) = 0.1
		_Loop ("FBM loop count (max 8)", Int) = 5
		_FBMAmpFactor ("FBM amplitude factor", Range(1,4)) = 2
		_FBMSclFactor ("FBM scale factor", Range(1,4)) = 2
		[MaterialToggle] _ENABLE_DOMAIN_WARPING ("Enable domain warping", Float) = 0
		_DF ("Domain warping factor", Range(0,10)) = 1
		[Header(Lighting)]
		_SpecPower("Specular power", Range(1,128)) = 10.0
		_SpecInt("Specular intensity", Range(0,4)) = 1
		_FresnelPower("Diffuse power", Range(1,16)) = 5
		_FresnelInt("Diffuse intensity", Range(0,1)) = .2
		_ReflectFace("Reflectance (face)", Range(0,1)) = 0.5
		_ReflectBack("Reflectance (back)", Range(0,1)) = 0.5
		_Refract ("Refractive index", Range(1,8)) = 1.334
		_Blend_DLC_RP("Blend directional light color and reflection probe color", Range(0,1)) = 0.5
		[Header(Manual direcional light)]
		[MaterialToggle] _Manual_directional_light_direction ("Enable manual directional light direction", Float) = 0
		_LD ("Manual light direction", Vector) = (0,1,0,0)
		[MaterialToggle] _Manual_directional_light_color ("Enable manual directional light color", Float) = 0
		_LC ("Manual light color", Color) = (1,1,1,1)
		[Header(Scaling and Scroll)]
		_Scale ("Scale, (x,y,z,time) for World/Object, (u,v,_,time) for UV/UVTorus", Vector) = (1,1,1,1)
		_Flow ("Flow vector, (x,y,z,_) for World/Object, (u,v,_,_) for UV/UVTorus", Vector) = (0,0,0,0)
		[Header(Virtual depth)]
		[MaterialToggle] _IsVD("Enable virtual depth", Float) = 0
		_VD ("Virtual depth", Float) = 0.5
		[Header(Pseudo mipmap)]
		[MaterialToggle] _ENABLE_PSEUDO_MIPMAP ("Enable pseudo mipmap", Float) = 0
		_MUD ("Pseudo mipmap unit distance", Float) = .1
		[Header(Tessellation)]
		_MinDist ("Min distance", Float) = 5
		_MaxDist ("Max distance", Float) = 20
		_TessFactor ("Tessellation factor", Int) = 1
		[Header(Vertex)]
		[MaterialToggle] _ENABLE_VERTEX_NOISE ("Enable vertex noise, only for 'Normal by height' mode", Float) = 0
		_WHT ("Amplitude for noise (object space)", Float) = .01
		[MaterialToggle] _ENABLE_WAVE ("Enable sine wave", Float) = 0
		_WHT2 ("Amplitude for sine wave(object space)", Float) = .01
		_WavePower ("Wave power", Range(1,10)) = 1
		_ScaleT ("Wave vector, frequency, (x,y,z,time) for World/Object, (u,v,_,time) for UV/UVTorus", Vector) = (.1,.1,.1,1)
		_Offset ("Offset", Range(-1,1)) = 0
		[Header(NearShoreAdjusting)]
		_NearShorePower("Near shore distance estimation power", Range(0,10)) = 5
		[MaterialToggle] _EnableAttenuateReflection ("Enable attenuate reflection", Float) = 0
		[MaterialToggle] _EnableAttenuateDistortion ("Enable attenuate distortion", Float) = 0
		[MaterialToggle] _EnableCoastWhite ("Enable coast white", Float) = 0
		[Header(Other)]
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 0
		[MaterialToggle] _ZWrite ("ZWrite", Float) = 0
		[HideInInspector] _Test ("Test", Float) = 0
	}
	SubShader {
		Tags { "Queue"="AlphaTest+300" "LightMode"="ForwardBase" "IgnoreProjector"="True" }
		LOD 200
		Cull [_Cull]
		ZWrite [_ZWrite]

		GrabPass {
			"_GrabTex_myxy_Ocean"
		}

		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma hull hull
			#pragma domain domain
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma multi_compile _NOISESPACE_WORLD _NOISESPACE_OBJECT _NOISESPACE_UV _NOISESPACE_UVTORUS

			#include "Tessellation.cginc"
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			#define tau (UNITY_PI*2)
			#define MAX_LOOP_COUNT 8

			sampler2D _GrabTex_myxy_Ocean;
			float4 _GrabTex_myxy_Ocean_TexelSize;
			sampler2D _CameraDepthTexture;
			float4 _GrabTex_ST;
			float _WH;
			float _SpecPower;
			float _Opacity;
			float _Distortion;
			fixed4 _Color;
			fixed4 _ColorShallow;
			float _ReflectFace;
			float _ReflectBack;
			float _Pa1;
			float _IsVD;
			float _VD;
			float4 _Flow;
			float _DF;
			float _MUD;
			float4 _Scale;
			float4 _LD;
			float4 _LC;
			float _Test;
			float _Loop;
			float _FresnelPower;
			float _FresnelInt;
			float _SpecInt;
			float _Manual_directional_light_direction;
			float _Manual_directional_light_color;
			float _Blend_DLC_RP;
			float _Refract;
			float _ENABLE_DOMAIN_WARPING;
			float _ENABLE_PSEUDO_MIPMAP;
			float _MaxDist;
			float _MinDist;
			int _TessFactor;
			float _WHT;
			float _WHT2;
			float _Offset;
			float4 _ScaleT;
			float4 _FlowT;
			float _ENABLE_WAVE;
			float _ENABLE_VERTEX_NOISE;
			float _WavePower;
			float _NormalByVector;
			float _NearShorePower;
			float _EnableAttenuateReflection;
			float _EnableAttenuateDistortion;
			float _EnableCoastWhite;
			float _FBMAmpFactor;
			float _FBMSclFactor;

			// Code snipetts thankfully offered by RamType-0
			// For fetching CameraDepthTexture in the mirror
			// https://gist.github.com/RamType-0/3cbbf58b9e3808b607cf2419fd9a6334

		    float2 ClipXYToViewXY(float2 clipXY)
		    {
		        clipXY.xy += UNITY_MATRIX_P._m02_m12;
		        return float2(clipXY.x / UNITY_MATRIX_P._m00, clipXY.y / UNITY_MATRIX_P._m11);
		    }       

		    float2 InverseTransformStereoScreenSpaceTex(float2 uv, float w)
		    {
		        #if UNITY_SINGLE_PASS_STEREO

		            float4 scaleOffset = unity_StereoScaleOffset[unity_StereoEyeIndex];
		            uv.xy = mad(scaleOffset.zw, -w, uv.xy);
		            return uv.xy / scaleOffset.xy;
		        #else
		            return uv;
		        #endif
		    }
		    float2 InverseTransformStereoScreenSpaceTex(float2 uv)
		    {
		        #if UNITY_SINGLE_PASS_STEREO
		            return InverseTransformStereoScreenSpaceTex(saturate(uv), 1);
		        #else
		            return uv;
		        #endif
		    }

		   float PreComputeLinearEyeDepthFactor(in float3 viewPos){
		        return mad(
		        viewPos.x * UNITY_MATRIX_P._m20 + viewPos.y * UNITY_MATRIX_P._m21 ,
		        rcp(viewPos.z) , 
		        UNITY_MATRIX_P._m22
		        );
		    }

		    float2 ScreenUVToClipXY(float2 screenUV)
		    {
		        float2 o;
		        o.xy = InverseTransformStereoScreenSpaceTex(screenUV);


		        o.xy = mad(o.xy, 2, -1);
		        o.y *= _ProjectionParams.x;
		        return o;
		    }

		    float LinearEyeDepth(in float zBuffer,in float linearEyeDepthFactor){
		        return UNITY_MATRIX_P._m23 /(linearEyeDepthFactor + zBuffer);
		    }

		    float LinearEyeDepth(in float zBuffer,in float3 viewPos)
		    {
		        return LinearEyeDepth(zBuffer,PreComputeLinearEyeDepthFactor(viewPos));

		    }

		    float PreComputeLinearEyeDepthFactorViewXY(float2 viewXY){
		        return mad(viewXY.x , -UNITY_MATRIX_P._m20, mad(viewXY.y , -UNITY_MATRIX_P._m21 , UNITY_MATRIX_P._m22));
		    }

		    float LinearEyeDepthViewXY(float zBuffer, float2 viewXY)
		    {
		        return LinearEyeDepth(zBuffer,PreComputeLinearEyeDepthFactorViewXY(viewXY));
		    }

		    float LinearEyeDepthScreenUV(float zBuffer, float2 screenUV)
		    {
		        float2 viewXY = ClipXYToViewXY(ScreenUVToClipXY(screenUV));
		        return LinearEyeDepthViewXY(zBuffer, viewXY);
		    }

			// float5 utilities

			struct float5
			{
				float4 u;
				float l;
			};

			struct float5x5
			{
				float4x4 ul;
				float4x1 ur;
				float1x4 ll;
				float1x1 lr;
			};

			float5 float5c(float x1, float x2, float x3, float x4, float x5)
			{
				float5 x;
				x.u = float4(x1,x2,x3,x4);
				x.l = float(x5);
				return x;
			}

			float5 float5c(float4 x1234, float x5)
			{
				float5 x;
				x.u = x1234;
				x.l = x5;
				return x;
			}

			float5 float5c(float x)
			{
				float5 y;
				y.u = x.xxxx;
				y.l = x;
				return y;
			}

			float5x5 float5x5c(
				float a11, float a12, float a13, float a14, float a15,
				float a21, float a22, float a23, float a24, float a25,
				float a31, float a32, float a33, float a34, float a35,
				float a41, float a42, float a43, float a44, float a45,
				float a51, float a52, float a53, float a54, float a55
			)
			{
				float5x5 a;
				a.ul = float4x4(
					a11, a12, a13, a14,
					a21, a22, a23, a24,
					a31, a32, a33, a34,
					a41, a42, a43, a44
				);
				a.ur = float4x1(
					a15,
					a25,
					a35,
					a45
				);
				a.ll = float1x4(
					a51, a52, a53, a54
				);
				a.lr = float1x1(
					a55
				);
				return a;
			}

			float5 floor(float5 x)
			{
				return float5c(floor(x.u),floor(x.l));
			}
			float5 frac(float5 x)
			{
				return float5c(frac(x.u),frac(x.l));
			}
			float5 lerp(float5 a, float5 b, float x)
			{
				return float5c(lerp(a.u,b.u,x),lerp(a.l,b.l,x));
			}

			float5 mul(float5x5 a, float5 x)
			{
				return float5c(mul(a.ul,x.u)+mul(a.ur,x.l),mul(a.ll,x.u)+mul(a.lr,x.l));
			}

			float5 add(float5 x, float5 y)
			{
				return float5c(x.u+y.u,x.l+y.l);
			}

			float5 m(float5 x, float5 y)
			{
				return float5c(x.u*y.u,x.l*y.l);
			}

			float5 mad(float5 a, float5 b, float5 c)
			{
				return float5c(mad(a.u,b.u,c.u),mad(a.l,b.l,c.l));
			}

			float5 ddx(float5 x)
			{
				return float5c(ddx(x.u),ddx(x.l));
			}

			float5 ddy(float5 x)
			{
				return float5c(ddy(x.u),ddy(x.l));
			}
			
			// Random functions

			float h13(float3 p)
			{
				return frac(sin(dot(float3(45.24525,54.626,34.15314),p))*143214.1513);
			}

			float h14(float4 p)
			{
				return frac(sin(dot(float4(23.42151,45.24525,54.626,34.15314),p))*143214.1513);
			}

			float h15(float5 p)
			{
				return frac(sin(mad(32.51551,p.l,dot(float4(23.42151,45.24525,54.626,34.15314),p.u)))*143214.1513);
			}

			// Value noises

			float n13(float3 p)
			{
				float3 i = floor(p);
				float3 f = frac(p);
				//f *= f * mad(-2,f,3);
				f = mad(mad(6,f,-15),f,10)*f*f*f;
				return lerp(
					lerp(
						lerp(h13(i+float3(0,0,0)),h13(i+float3(1,0,0)),f.x),
						lerp(h13(i+float3(0,1,0)),h13(i+float3(1,1,0)),f.x),
						f.y
					),
					lerp(
						lerp(h13(i+float3(0,0,1)),h13(i+float3(1,0,1)),f.x),
						lerp(h13(i+float3(0,1,1)),h13(i+float3(1,1,1)),f.x),
						f.y
					),
					f.z	
				);
			}

			float n14(float4 p)
			{
				float4 i = floor(p);
				float4 f = frac(p);
				//f *= f * mad(-2,f,3);
				f = mad(mad(6,f,-15),f,10)*f*f*f;
				return lerp(
					lerp(
						lerp(
							lerp(h14(i+float4(0,0,0,0)),h14(i+float4(1,0,0,0)),f.x),
							lerp(h14(i+float4(0,1,0,0)),h14(i+float4(1,1,0,0)),f.x),
							f.y
						),
						lerp(
							lerp(h14(i+float4(0,0,1,0)),h14(i+float4(1,0,1,0)),f.x),
							lerp(h14(i+float4(0,1,1,0)),h14(i+float4(1,1,1,0)),f.x),
							f.y
						),
						f.z	
					),
					lerp(
						lerp(
							lerp(h14(i+float4(0,0,0,1)),h14(i+float4(1,0,0,1)),f.x),
							lerp(h14(i+float4(0,1,0,1)),h14(i+float4(1,1,0,1)),f.x),
							f.y
						),
						lerp(
							lerp(h14(i+float4(0,0,1,1)),h14(i+float4(1,0,1,1)),f.x),
							lerp(h14(i+float4(0,1,1,1)),h14(i+float4(1,1,1,1)),f.x),
							f.y
						),
						f.z	
					),
					f.w	
				);
			}

			float n15(float5 p)
			{
				float5 i = floor(p);
				float5 f = frac(p);
				//f = m(f,m(f,mad(float5c(-2),f,float5c(3))));
				f = m(m(m(mad(mad(float5c(6),f,float5c(-15)),f,float5c(10)),f),f),f);
				return lerp(
					lerp(
						lerp(
							lerp(
								lerp(h15(add(i,float5c(0,0,0,0,0))),h15(add(i,float5c(1,0,0,0,0))),f.u.x),
								lerp(h15(add(i,float5c(0,1,0,0,0))),h15(add(i,float5c(1,1,0,0,0))),f.u.x),
								f.u.y
							),
							lerp(
								lerp(h15(add(i,float5c(0,0,1,0,0))),h15(add(i,float5c(1,0,1,0,0))),f.u.x),
								lerp(h15(add(i,float5c(0,1,1,0,0))),h15(add(i,float5c(1,1,1,0,0))),f.u.x),
								f.u.y
							),
							f.u.z	
						),
						lerp(
							lerp(
								lerp(h15(add(i,float5c(0,0,0,1,0))),h15(add(i,float5c(1,0,0,1,0))),f.u.x),
								lerp(h15(add(i,float5c(0,1,0,1,0))),h15(add(i,float5c(1,1,0,1,0))),f.u.x),
								f.u.y
							),
							lerp(
								lerp(h15(add(i,float5c(0,0,1,1,0))),h15(add(i,float5c(1,0,1,1,0))),f.u.x),
								lerp(h15(add(i,float5c(0,1,1,1,0))),h15(add(i,float5c(1,1,1,1,0))),f.u.x),
								f.u.y
							),
							f.u.z	
						),
						f.u.w
					),
					lerp(
						lerp(
							lerp(
								lerp(h15(add(i,float5c(0,0,0,0,1))),h15(add(i,float5c(1,0,0,0,1))),f.u.x),
								lerp(h15(add(i,float5c(0,1,0,0,1))),h15(add(i,float5c(1,1,0,0,1))),f.u.x),
								f.u.y
							),
							lerp(
								lerp(h15(add(i,float5c(0,0,1,0,1))),h15(add(i,float5c(1,0,1,0,1))),f.u.x),
								lerp(h15(add(i,float5c(0,1,1,0,1))),h15(add(i,float5c(1,1,1,0,1))),f.u.x),
								f.u.y
							),
							f.u.z	
						),
						lerp(
							lerp(
								lerp(h15(add(i,float5c(0,0,0,1,1))),h15(add(i,float5c(1,0,0,1,1))),f.u.x),
								lerp(h15(add(i,float5c(0,1,0,1,1))),h15(add(i,float5c(1,1,0,1,1))),f.u.x),
								f.u.y
							),
							lerp(
								lerp(h15(add(i,float5c(0,0,1,1,1))),h15(add(i,float5c(1,0,1,1,1))),f.u.x),
								lerp(h15(add(i,float5c(0,1,1,1,1))),h15(add(i,float5c(1,1,1,1,1))),f.u.x),
								f.u.y
							),
							f.u.z	
						),
						f.u.w
					),
					f.l	
				);
			}

			// FBM noises

			float fbm13normal(float3 p, int loop) {
				float f = 0;
				float a = 1;
				float a1 = 1;
				float b = 0;
				//float c = 4/5;
				//float s = 3/5;
				//float3x3 rxy = float3x3(c, s, 0,-s, c, 0, 0, 0, 1);
				//float3x3 rxz = float3x3(c, 0, s, 0, 1, 0,-s, 0, c);
				//float3x3 rxyz = mul(mul(rxz,rxy),rxz);
				float3x3 rxyz = float3x3(19./125,108./125,12./25,-108./125,44./125,-9./25,-12./25,-9./25,4./5);

				[loop]
				for (int i = 0; i < loop; i++)
				{
					p = mul(rxyz,p);
					a *= 2;
					a1 *= 2;
					f += n13(a/2*p)/a1;
					b += rcp(a);
				}
				return f/(b==0?1:b);
			}

			float fbm13(float3 p, int loop) {
				float f = 0;
				float a = 1;
				float a1 = 1;
				float b = 0;
				//float c = 4/5;
				//float s = 3/5;
				//float3x3 rxy = float3x3(c, s, 0,-s, c, 0, 0, 0, 1);
				//float3x3 rxz = float3x3(c, 0, s, 0, 1, 0,-s, 0, c);
				//float3x3 rxyz = mul(mul(rxz,rxy),rxz);
				float3x3 rxyz = float3x3(19./125,108./125,12./25,-108./125,44./125,-9./25,-12./25,-9./25,4./5);

				[loop]
				for (int i = 0; i < loop; i++)
				{
					p = mul(rxyz,p);
					a *= _FBMSclFactor;
					a1 *= _FBMAmpFactor;
					f += n13(a/2*p)/a1;
					b += rcp(a1);
				}
				return f/(b==0?1:b);
			}

			float fbm14(float4 p, int loop) {
				float f = 0;
				float a = 1;
				float a1 = 1;
				float b = 0;
				//float c = 4/5;
				//float s = 3/5;
				//float4x4 rxy = float4x4(c, s, 0, 0,-s, c, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
				//float4x4 rxz = float4x4(c, 0, s, 0, 0, 1, 0, 0,-s, 0, c, 0, 0, 0, 0, 1);
				//float4x4 rxw = float4x4(c, 0, 0, s, 0, 1, 0, 0, 0, 0, 1, 0,-s, 0, 0, c);
				//float4x4 rxyzw = mul(mul(mul(mul(rxy,rxz),rxw),rxy),rxz);
				float4x4 rxyzw = float4x4(-776./3125,492./625,1293./3125,48./125,-1293./3125,256./625,-2376./3125,-36./125,-492./625,-36./125,256./625,-9./25,-48./125,-9./25,-36./125,4./5);

				[loop]
				for (int i = 0; i < loop; i++)
				{
					p = mul(rxyzw,p);
					a *= _FBMSclFactor;
					a1 *= _FBMAmpFactor;
					f += n14(a/2*p)/a1;
					b += rcp(a1);
				}
				return f/(b==0?1:b);
			}

			float fbm15(float5 p, int loop) {
				float f = 0;
				float a = 1;
				float a1 = 1;
				float b = 0;
				float5x5 rotate = float5x5c(-37616./78125,2268./3125,5697./15625,9288./78125,192./625,-9288./78125,1424./3125,-11304./15625,-35091./78125,-144./625,-5697./15625,-144./625,1424./3125,-11304./15625,-36./125,-2268./3125,-36./125,-144./625,1424./3125,-9./25,-192./625,-9./25,-36./125,-144./625,4./5);
				[loop]
				for (int i = 0; i < loop; i++)
				{
					p = mul(rotate,p);
					a *= _FBMSclFactor;
					a1 *= _FBMAmpFactor;
					f += n15(m(p,float5c(a/2)))/a1;
					b += rcp(a1);
				}
				return f/(b==0?1:b);
			}

			// Noise functions with pseudo mipmap level

			float map13(float3 p, float level, int loop)
			{
				float d = _ENABLE_DOMAIN_WARPING ? fbm13(p, loop) : 0;
				float3 pnear = p;
				pnear.xy /= exp2(floor(level));
				float3 pfar = p;
				pfar.xy /= exp2(ceil(level));
				[branch]
				if (_ENABLE_PSEUDO_MIPMAP)
				{
					return lerp(fbm13(mad(d,_DF,pnear),loop),fbm13(mad(d,_DF,pfar),loop),frac(level));
				}
				else
				{
					return fbm13(mad(d,_DF,p),loop);
				}
			}

			float map14(float4 p, float level, int loop)
			{
				float d = _ENABLE_DOMAIN_WARPING ? fbm14(p, loop) : 0;
				float4 pnear = p;
				pnear.xyz /= exp2(floor(level));
				float4 pfar = p;
				pfar.xyz /= exp2(ceil(level));
				[branch]
				if (_ENABLE_PSEUDO_MIPMAP)
				{
					return lerp(fbm14(mad(d,_DF,pnear),loop),fbm14(mad(d,_DF,pfar),loop),frac(level));
				}
				else
				{
					return fbm14(mad(d,_DF,pnear),loop);
				}
			}

			float map15(float5 p, float level, int loop)
			{
				float d = _ENABLE_DOMAIN_WARPING ? fbm15(p,loop) : 0;
				float5 pnear = p;
				pnear.u /= exp2(floor(level));
				float5 pfar = p;
				pfar.u /= exp2(ceil(level));
				d *= _DF;
				[branch]
				if (_ENABLE_PSEUDO_MIPMAP)
				{
					return lerp(fbm15(mad(float5c(d),float5c(_DF),pnear),loop),fbm15(mad(float5c(d),float5c(_DF),pfar),loop),frac(level));
				}
				else
				{
					return fbm15(mad(float5c(d),float5c(_DF),pnear),loop);
				}
			}

			// Rodrigues' rotation formula
			// https://mathworld.wolfram.com/RodriguesRotationFormula.html
			float3x3 rrf(float3 n, float cosa)
			{
				float3 nsina=n*sqrt(mad(-cosa,cosa,1));
				return mad(mul(float3x1(n.x,n.y,n.z),float1x3(n.x,n.y,n.z)),(1-cosa),float3x3(
					cosa,   -nsina.z,nsina.y,
					nsina.z, cosa,  -nsina.x,
					-nsina.y,nsina.x,cosa
				));
			}

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
			};

			struct v2h
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
			};

			struct h2d_main
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
			};

			struct h2d_const
			{
				float tess_factor[3] : SV_TessFactor;
				float InsideTessFactor : SV_InsideTessFactor;
			};

			struct d2f
			{
				float4 pos : SV_POSITION;
				float3 wPos : WORLD_POS;
				float3 tangent : TEXCOORD0;
				float4 scrPos : TEXCOORD1;
				float3 normal : TEXCOORD2;
				float4 grabPos : TEXCOORD3;
				float2 uv : TEXCOORD4;
				//float noise : TEXCOORD0;
			};

			v2h vert(appdata i)
			{
				v2h o;
				o.vertex = i.vertex;
				o.normal = i.normal;
				o.tangent = i.tangent;
				o.uv = i.uv;
				return o;
			}

			h2d_const hull_const(InputPatch<v2h, 3> i)
			{
				h2d_const o;
				float4 tessFactor = UnityDistanceBasedTess(i[0].vertex, i[1].vertex, i[2].vertex, _MinDist, _MaxDist, _TessFactor);
				o.tess_factor[0] = tessFactor.x;
				o.tess_factor[1] = tessFactor.y;
				o.tess_factor[2] = tessFactor.z;
				o.InsideTessFactor = tessFactor.w;
				return o;
			}

			[domain("tri")]
			[partitioning("integer")]
			[outputtopology("triangle_cw")]
			[outputcontrolpoints(3)]
			[patchconstantfunc("hull_const")]
			h2d_main hull(InputPatch<v2h, 3> i, uint id : SV_OutputControlPointID)
			{
				h2d_main o;
				o.vertex = i[id].vertex;
				o.normal = i[id].normal;
				o.tangent = i[id].tangent;
				o.uv = i[id].uv;
				return o;
			}

			[domain("tri")]
			d2f domain(h2d_const hull_const_data, const OutputPatch<h2d_main, 3> i, float3 bary : SV_DomainLocation)
			{
				d2f o;
				float time = _Time.y + _Test;
				float4 vertex = i[0].vertex * bary.x + mad(i[1].vertex,bary.y,i[2].vertex * bary.z);
				float2 uv = i[0].uv * bary.x + i[1].uv * bary.y + i[2].uv * bary.z;
				o.uv = uv;
				float3 normal = normalize(i[0].normal * bary.x + i[1].normal * bary.y + i[2].normal * bary.z);
				float3 tangent = normalize(i[0].tangent.xyz * bary.x + i[1].tangent.xyz * bary.y + i[2].tangent.xyz * bary.z);
				o.wPos = mul(unity_ObjectToWorld, vertex);

				int loop = _Loop;
				if (loop > MAX_LOOP_COUNT) loop = MAX_LOOP_COUNT;
				[branch]
				if (_ENABLE_VERTEX_NOISE && !_NormalByVector)
				{
					#ifdef _NOISESPACE_WORLD
					float4 p4n = float4(mad(time,-_Flow.xyz,o.wPos),time);
					p4n *= _Scale;
					vertex.xyz += _WHT*mad(2,map14(p4n,0,loop),-1+_Offset)*normal;
					#elif _NOISESPACE_OBJECT
					float4 p4n = float4(mad(time,-_Flow.xyz,vertex.xyz),time);
					p4n *= _Scale;
					vertex.xyz += _WHT*mad(2,map14(p4n,0,loop),-1+_Offset)*normal;
					#elif _NOISESPACE_UV
					float3 p4n = float3(mad(time,-_Flow.xy,uv),time);
					p4n *= _Scale.xyw;
					vertex.xyz += _WHT*mad(2,map13(p4n,0,loop),-1+_Offset)*normal;
					#elif _NOISESPACE_UVTORUS
					float2 temp = frac(mad(time,-_Flow.xy,uv))*tau;
					float5 p4n = float5c(_Scale.x*cos(temp.x)/tau,_Scale.x*sin(temp.x)/tau,_Scale.y*cos(temp.y)/tau,_Scale.y*sin(temp.y)/tau,time*_Scale.w);
					vertex.xyz += _WHT*mad(2,map15(p4n,0,loop),-1+_Offset)*normal;
					#endif
				}
				[branch]
				if (_ENABLE_WAVE)
				{
					#ifdef _NOISESPACE_WORLD
					vertex.xyz += _WHT2*(pow(mad(.5,sin(tau*dot(float4(o.wPos,-time),_ScaleT)),.5), _WavePower)*2-1+_Offset)*normal;
					#elif _NOISESPACE_OBJECT
					vertex.xyz += _WHT2*(pow(mad(.5,sin(tau*dot(float4(vertex.xyz,-time),_ScaleT)),.5), _WavePower)*2-1+_Offset)*normal;
					#elif _NOISESPACE_UV
					vertex.xyz += _WHT2*(pow(mad(.5,sin(tau*dot(float3(uv,-time),_ScaleT.xyw)),.5), _WavePower)*2-1+_Offset)*normal;
					#elif _NOISESPACE_UVTORUS
					vertex.xyz += _WHT2*(pow(mad(.5,sin(tau*dot(float3(uv,-time),float3(floor(_ScaleT.xy),_ScaleT.w))),.5), _WavePower)*2-1+_Offset)*normal;
					#endif
				}
				o.wPos = mul(unity_ObjectToWorld, vertex);

				o.pos = UnityObjectToClipPos(vertex);
				o.normal = UnityObjectToWorldNormal(normal);
				o.tangent = mul(unity_ObjectToWorld, tangent.xyz); 
				o.grabPos = ComputeGrabScreenPos(o.pos);
				o.scrPos = ComputeScreenPos(o.pos);
				return o;
			}

			fixed4 frag(d2f i, fixed face : VFACE) : SV_Target
			{
				fixed4 c = _Color;
				float3 wpos = i.wPos;
				float time = _Time.y + _Test;
				float level = max(0,log2(length(fwidth(wpos))/_MUD));
				float3 normal = normalize(i.normal);
				float3 tangent = normalize(cross(cross(normal, i.tangent),normal));
				float3 binormal = normalize(cross(normal, tangent));
				float3 viewDir = normalize(wpos - _WorldSpaceCameraPos);
				float3 cameraDir = unity_CameraToWorld._m02_m12_m22;
				float3 ddxwpos = ddx(wpos);
				float3 ddywpos = ddy(wpos);

				// Calculate normal

				#ifdef _NOISESPACE_WORLD
				float4 p4n = float4(mad(time,-_Flow.xyz,wpos),time);
				p4n *= _Scale;
				#elif _NOISESPACE_OBJECT
				float4 p4n = float4(mul(unity_WorldToObject, float4(mad(time,-_Flow.xyz,wpos), 1)).xyz,time);
				p4n *= _Scale;
				#elif _NOISESPACE_UV
				float3 p4n = float3(mad(time,-_Flow.xy,i.uv),time);
				p4n *= _Scale.xyw;
				#elif _NOISESPACE_UVTORUS
				float2 temp = frac(mad(time,-_Flow.xy,i.uv))*tau;
				float2 scaletau = _Scale.xy/tau;
				float5 p4n = float5c(scaletau.x*cos(temp.x),scaletau.x*sin(temp.x),scaletau.y*cos(temp.y),scaletau.y*sin(temp.y),time*_Scale.w);
				#endif

				float d = .001*log2(time);

				float3 fnormal = -normalize(cross(ddywpos,ddxwpos))*_ProjectionParams.x;
				float3 ftangent = normalize(cross(cross(fnormal,tangent),fnormal));
				float3 fbinormal = normalize(cross(cross(fnormal,binormal),fnormal));

				int loop = _Loop;
				[branch]
				if (loop > MAX_LOOP_COUNT) loop = MAX_LOOP_COUNT;

				float3 wnormal;
				float3 wh_fnormal = _WH*fnormal;
				#ifdef _NOISESPACE_UVTORUS
				[branch]
				if (_NormalByVector)
				{
					//wnormal = normalize(fnormal+_WH*((2*map15(p4n,level,loop)-1)*ftangent+(2*map15(add(p4n,float5c(1)),level,loop)-1)*fbinormal));
					wnormal = normalize(mad(_WH,mad(mad(2,map15(p4n,level,loop),-1),ftangent,mad(2,map15(add(p4n,float5c(1)),level,loop),-1)*fbinormal),fnormal));
				}
				else
				{
					/*
					float3 wavepos0 = map15(p4n,level,loop)*wh_fnormal+wpos;
					float3 waveposx = map15(add(p4n,m(ddx(p4n),float5c(d/length(ddx(wpos))))),level,loop)*wh_fnormal+normalize(ddx(wpos))*d+wpos;
					float3 waveposy = map15(add(p4n,m(ddy(p4n),float5c(d/length(ddy(wpos))))),level,loop)*wh_fnormal+normalize(ddy(wpos))*d+wpos;
					wnormal = normalize(cross(waveposy-wavepos0,waveposx-wavepos0));
					*/
					float3 wavepos0_ = map15(p4n,level,loop);
					float rcplengthddxwposd = rsqrt(dot(ddxwpos,ddxwpos))*d;
					float rcplengthddywposd = rsqrt(dot(ddywpos,ddywpos))*d;
					float3 waveposx_0 = mad(map15(mad(ddx(p4n),float5c(rcplengthddxwposd),p4n),level,loop)-wavepos0_,wh_fnormal,rcplengthddxwposd*ddxwpos); //+wpos
					float3 waveposy_0 = mad(map15(mad(ddy(p4n),float5c(rcplengthddywposd),p4n),level,loop)-wavepos0_,wh_fnormal,rcplengthddywposd*ddywpos); //+wpos
					wnormal = normalize(cross(waveposy_0,waveposx_0));
				}
				#elif _NOISESPACE_UV
				[branch]
				if (_NormalByVector)
				{
					//wnormal = normalize(fnormal+_WH*((2*map13(p4n,level,loop)-1)*ftangent+(2*map13(p4n+1,level,loop)-1)*fbinormal));
					wnormal = normalize(mad(_WH,mad(mad(2,map13(p4n,level,loop),-1),ftangent,mad(2,map13(p4n+1,level,loop),-1)*fbinormal),fnormal));
				}
				else
				{
					/*
					float3 wavepos0 = map13(p4n,level,loop)*wh_fnormal+wpos;
					float3 waveposx = map13(p4n+ddx(p4n)*d/length(ddx(wpos)),level,loop)*wh_fnormal+normalize(ddx(wpos))*d+wpos;
					float3 waveposy = map13(p4n+ddy(p4n)*d/length(ddy(wpos)),level,loop)*wh_fnormal+normalize(ddy(wpos))*d+wpos;
					wnormal = normalize(cross(waveposy-wavepos0,waveposx-wavepos0));
					*/
					float3 wavepos0_ = map13(p4n,level,loop);
					float rcplengthddxwposd = rsqrt(dot(ddxwpos,ddxwpos))*d;
					float rcplengthddywposd = rsqrt(dot(ddywpos,ddywpos))*d;
					float3 waveposx_0 = mad(map13(mad(ddx(p4n),rcplengthddxwposd,p4n),level,loop)-wavepos0_,wh_fnormal,rcplengthddxwposd*ddxwpos);
					float3 waveposy_0 = mad(map13(mad(ddy(p4n),rcplengthddywposd,p4n),level,loop)-wavepos0_,wh_fnormal,rcplengthddywposd*ddywpos); //+wpos
					wnormal = normalize(cross(waveposy_0,waveposx_0));
				}
				#else
				[branch]
				if (_NormalByVector)
				{
					//wnormal = normalize(fnormal+_WH*((2*map14(p4n,level,loop)-1)*ftangent+(2*map14(p4n+1,level,loop)-1)*fbinormal));
					wnormal = normalize(mad(_WH,mad(mad(2,map14(p4n,level,loop),-1),ftangent,mad(2,map14(p4n+1,level,loop),-1)*fbinormal),fnormal));
				}
				else
				{
					/*
					float3 wavepos0 = map14(p4n,level,loop)*wh_fnormal+wpos;
					float3 waveposx = map14(p4n+ddx(p4n)*d/length(ddx(wpos)),level,loop)*wh_fnormal+normalize(ddx(wpos))*d+wpos;
					float3 waveposy = map14(p4n+ddy(p4n)*d/length(ddy(wpos)),level,loop)*wh_fnormal+normalize(ddy(wpos))*d+wpos;
					wnormal = normalize(cross(waveposy-wavepos0,waveposx-wavepos0));
					*/
					float wavepos0_ = map14(p4n,level,loop);
					float rcplengthddxwposd = rsqrt(dot(ddxwpos,ddxwpos))*d;
					float rcplengthddywposd = rsqrt(dot(ddywpos,ddywpos))*d;
					float3 waveposx_0 = mad(map14(mad(ddx(p4n),rcplengthddxwposd,p4n),level,loop)-wavepos0_,wh_fnormal,rcplengthddxwposd*ddxwpos);
					float3 waveposy_0 = mad(map14(mad(ddy(p4n),rcplengthddywposd,p4n),level,loop)-wavepos0_,wh_fnormal,rcplengthddywposd*ddywpos);
					wnormal = normalize(cross(waveposy_0,waveposx_0));
				}
				#endif

				float3 fbnormal = face > 0 ? normal : -normal;
				wnormal = face > 0 ? wnormal : -wnormal;
				wnormal = abs(UNITY_MATRIX_P._m20) > .0001 ? -wnormal : wnormal;
				fnormal = abs(UNITY_MATRIX_P._m20) > .0001 ? -fnormal : fnormal;
				float dot_fnormal_fbnormal = dot(fnormal, fbnormal);
				wnormal = dot_fnormal_fbnormal < .99999 ? mul(rrf(normalize(cross(fnormal,fbnormal)),dot_fnormal_fbnormal),wnormal) : wnormal;

				// Calculate UV for grabtexture and cameradepthtexture

				float dot_cameradir_viewdir = dot(cameraDir, viewDir);
				float4 depth4cd = UNITY_PROJ_COORD(i.scrPos);
				float truedepth = LinearEyeDepthScreenUV(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd),depth4cd.xy/depth4cd.w)/dot_cameradir_viewdir;
				truedepth = truedepth > 0 ? truedepth : 1.#INF;
				float3 wnormalc = mul(unity_WorldToCamera, wnormal);
				float4 grabUV = i.grabPos;
				float2 aspect = _ScreenParams.xy / min(_ScreenParams.x, _ScreenParams.y);
				float2 distortion_wnormalc_aspect = _Distortion / aspect * wnormalc.xy;
				grabUV.xy += distortion_wnormalc_aspect;
				depth4cd.xy += distortion_wnormalc_aspect;

				// Calculate transparency

				float depth = LinearEyeDepthScreenUV(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd),saturate(depth4cd.xy/depth4cd.w))/dot_cameradir_viewdir;
				depth = depth > 0 ? depth : 1.#INF;
				float surfDepth = distance(_WorldSpaceCameraPos, i.wPos);
				float depthDiff = depth - surfDepth;
				float truedepthDiff = truedepth - surfDepth;
				[branch]
				if (_IsVD)
				{
					depthDiff = min(_VD, depthDiff);
					truedepthDiff = min(_VD, truedepthDiff);
				}
				float transparency = saturate(1-exp2(-_Opacity * (depthDiff > 0 ? depthDiff : truedepthDiff)));

				// Lighting

				float3 lightDir = _Manual_directional_light_direction ? normalize(_LD.xyz) : normalize(_WorldSpaceLightPos0.xyz);
				float3 lightColor = _Manual_directional_light_color ? _LC.rgb : _LightColor0.rgb;
				fixed4 reflectionProbeColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, face < 0 ? refract(viewDir, -wnormal, 1/_Refract) : reflect(viewDir, wnormal), 0);
				lightColor = lerp(lightColor, reflectionProbeColor, _Blend_DLC_RP);

				float3 specular = pow(max(0,dot(face < 0 ? refract(-lightDir, wnormal, _Refract) : reflect(-lightDir, wnormal),-viewDir)), _SpecPower);
				float fresnel = pow(max(0,dot(lightDir,wnormal)),_FresnelPower);

				float nearShore = pow(saturate(depthDiff*.1),_NearShorePower+1e-5);
				//float nearShore = pow(1-exp(-depthDiff),_NearShorePower+1e-5);
				fixed4 grabCol = tex2D(_GrabTex_myxy_Ocean, saturate((depthDiff > 0 ? grabUV.xy : i.grabPos.xy)/grabUV.w));

				float truedepthDiffDiff = fwidth(truedepthDiff)/length(fwidth(i.wPos));
				//float cdet = pow(truedepthDiff,3)/(truedepthDiffDiff < .1 ? truedepthDiffDiff : 1e-5);
				float cdet = pow(truedepthDiff,3)/(truedepthDiffDiff < .01 ? truedepthDiffDiff : 1e-5);
				cdet*=1e-5;
				cdet = pow(cdet,_NearShorePower);

				[branch]
				if (_EnableAttenuateDistortion)
				{
					fixed4 trueGrabCol = tex2D(_GrabTex_myxy_Ocean, saturate(i.grabPos.xy/grabUV.w));
					grabCol = lerp(trueGrabCol, grabCol, saturate(cdet));
				}
				c.rgb = lerp(grabCol * (face < 0 ? _ReflectBack : 1), lerp(_ColorShallow,c.rgb,pow(transparency,_Pa1)), face < 0 ? 0 : transparency);

				//float cde = truedepthDiff/length(ddx(truedepthDiff)/ddx(i.wPos));
				c.rgb += ((specular*_SpecInt+fresnel*_FresnelInt)*lightColor)*(face < 0 ? _ReflectBack:_ReflectFace)*(_EnableAttenuateReflection?saturate(cdet):1);
				//c.rgb += exp(-cdet*1e-5)*(pow(fbm14(float4(i.wPos*10,time*.1),4),1.5)>.3?1:0)*saturate(1-abs(truedepthDiff*5-1));

				if (_EnableCoastWhite)
				{
					float3 p4c = float3(i.wPos.xz*10,time*.1);
					c.rgb += exp(-cdet)*(pow(fbm13normal(p4c+fbm13normal(p4c,3)*4,4),1.5)>.4?1:0)*pow(saturate(1-abs(1-cdet*10)),.8)*length(lightColor)/1.7;
				}

				//return face>0?fixed4(1,0,0,1):fixed4(0,1,0,1);
				//return fixed4(frac(wpos.xz),0,1);
				//return fixed4(map14(p4n,0,_LoopT).xxx,1);
				//return fixed4(i.noise.xxx,1);
				//return fixed4(wnormal*.5+.5,1);
				return c;
			}
			ENDCG
		}
	}
}