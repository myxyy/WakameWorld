Shader "myxy/WaterShader/Ocean" {
	Properties{
		[Header(Color)]
		_Color("Color deep", Color) = (0,0,1,1)
		_ColorShallow("Color shallow", Color) = (0.5,0.5,1,1)
		_Pa1("Color gradient parameter", Range(0.1,10)) = 5
		_Opacity("Opacity", Range(1,2)) = 1.1
		[Header(Wave and Noise)]
		[KeywordEnum(World, Object, UV, UVTorus)] _NoiseSpace ("Noise space", Float) = 0
		_WH("Wave height", Range(0,2)) = 1
		_Distortion("Distortion", Range(0,1)) = 0.1
		[Toggle(ENABLE_DOMAIN_WARPING)] _ENABLE_DOMAIN_WARPING ("Enable domain warping", Float) = 0
		_DF ("Domain warping factor", Range(0,10)) = 1
		[Header(Lighting)]
		_SpecPower("Specular power", Range(1,128)) = 10.0
		_SpecInt("Specular intensity", Range(0,4)) = 1
		_FresnelPower("Diffuse power", Range(1,16)) = 5
		_FresnelInt("Diffuse intensity", Range(0,1)) = .2
		_Ref("Reflectance", Range(0,1)) = 0.5
		_Blend_DLC_RP("Blend directional light color and reflection probe color", Range(0,1)) = 0.5
		[Header(Manual direcional light)]
		[MaterialToggle] _Manual_directional_light_direction ("Manual directional light direction", Float) = 0
		_LD ("Manual light direction", Vector) = (0,1,0,0)
		[MaterialToggle] _Manual_directional_light_color ("Manual directional light color", Float) = 0
		_LC ("Manual light color", Color) = (1,1,1,1)
		[Header(Scaling and Scroll)]
		_Scale ("Scale(x,y,z,time)", Vector) = (1,1,1,1)
		_Flow ("Flow vector, w=wave frequency scale", Vector) = (0,0,0,1)
		[Header(Virtual depth)]
		[MaterialToggle] _IsVD("Enable virtual depth", Float) = 0
		_VD ("Virtual depth", Float) = 0.5
		[Header(Other)]
		_MUD ("Pseudo mipmap unit distance", Float) = .1
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 0
		[MaterialToggle] _ZWrite ("ZWrite", Float) = 0
		_Test ("Test", Float) = 0
		_Loop ("FBM loop count (int value)", Range(0,8)) = 5
	}
	SubShader {
		Tags { "Queue"="AlphaTest+500" "LightMode"="ForwardBase"}
		LOD 200
		Cull [_Cull]
		ZWrite [_ZWrite]

		GrabPass {
			"_GrabTex_myxy_Ocean"
		}

		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma shader_feature ENABLE_DOMAIN_WARPING
			#pragma multi_compile _NOISESPACE_WORLD _NOISESPACE_OBJECT _NOISESPACE_UV _NOISESPACE_UVTORUS

			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

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
			float _Ref;
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

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 wPos : WORLD_POS;
				UNITY_FOG_COORDS(0)
				float4 scrPos : TEXCOORD1;
				float3 normal : TEXCOORD2;
				float4 grabPos : TEXCOORD3;
				float2 uv : TEXCOORD4;
			};

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

			uint uh11(uint p)
			{
				p += (p << 10);
				p ^= (p >> 6);
				p += (p << 3);
				p ^= (p >> 11);
				p += (p << 15);
				return p;
			}

			uint uh13(uint3 p)
			{
				return uh11(p.x ^ uh11(p.y ^ uh11(p.z)));
			}

			uint uh14(uint4 p)
			{
				return uh11(p.x ^ uh11(p.y ^ uh11(p.z ^ uh11(p.w))));
			}

			float as01float(uint p)
			{
				const uint ieeemantissa = 0x007fffff;
				const uint ieeeone = 0x3f800000;;
				p &= ieeemantissa;
				p |= ieeeone;
				float f = asfloat(p);
				return f-1;
			}
			float h13(float3 p)
			{
				return frac(as01float(uh13(asuint(p))));
			}

			float h14(float4 p)
			{
				return frac(as01float(uh14(asuint(p))));
			}

			float n13(float3 p)
			{
				float3 i = floor(p);
				float3 f = frac(p);
				f *= f * (3 - 2*f);
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
				f *= f * (3 - 2*f);
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

			#define FBMLOOP 5

			float fbm13(float3 p) {
				float f = 0;
				float a = 1.;
				//float c = 4/5;
				//float s = 3/5;
				//float3x3 rxy = float3x3(c, s, 0,-s, c, 0, 0, 0, 1);
				//float3x3 rxz = float3x3(c, 0, s, 0, 1, 0,-s, 0, c);
				//float3x3 rxyz = mul(mul(rxz,rxy),rxz);
				float3x3 rxyz = float3x3(19./125,108./125,12./25,-108./125,44./125,-9./25,-12./25,-9./25,4./5);

				[loop]
				for (int i = 0; i < _Loop; i++)
				{
					a *= 2.;
					f += n13(p*a/2)/a;
					p = mul(rxyz,p);
				}
				return f;
			}

			float fbm14(float4 p) {
				float f = 0;
				float a = 1.;
				//float c = 4/5;
				//float s = 3/5;
				//float4x4 rxy = float4x4(c, s, 0, 0,-s, c, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
				//float4x4 rxz = float4x4(c, 0, s, 0, 0, 1, 0, 0,-s, 0, c, 0, 0, 0, 0, 1);
				//float4x4 rxw = float4x4(c, 0, 0, s, 0, 1, 0, 0, 0, 0, 1, 0,-s, 0, 0, c);
				//float4x4 rxyzw = mul(mul(mul(mul(rxy,rxz),rxw),rxy),rxz);
				float4x4 rxyzw = float4x4(-776./3125,492./625,1293./3125,48./125,-1293./3125,256./625,-2376./3125,-36./125,-492./625,-36./125,256./625,-9./25,-48./125,-9./25,-36./125,4./5);

				[loop]
				for (int i = 0; i < _Loop; i++)
				{
					a *= 2.;
					f += n14(p*a/2)/a;
					p = mul(rxyzw,p);
				}
				return f;
			}

			float fbm_1_2t1_3s(float3 p, float3 s)
			{
				float3 f = float3(frac(p.xy),p.z);
				return lerp(
					lerp(fbm13((f+float3(0,0,0))*s),fbm13((f+float3(1,0,0))*s),1-f.x),
					lerp(fbm13((f+float3(0,1,0))*s),fbm13((f+float3(1,1,0))*s),1-f.x),
					1-f.y
				);
			}

			float map14(float4 p, float level)
			{
				#ifdef ENABLE_DOMAIN_WARPING
				float d = fbm14(p);
				#else
				float d = 0;
				#endif
				float4 pnear = p;
				pnear.xyz /= pow(2,floor(level));
				float4 pfar = p;
				pfar.xyz /= pow(2,ceil(level));
				return lerp(fbm14(mad(d,_DF,pnear)),fbm14(mad(d,_DF,pfar)),frac(level));
			}

			float map_1_2t1_3s(float3 p, float3 s, float level)
			{
				#ifdef ENABLE_DOMAIN_WARPING
				float d = fbm_1_2t1_3s(p,s);
				#else
				float d = 0;
				#endif
				float3 pnear = p;
				pnear.xy /= pow(2,floor(level));
				float3 pfar = p;
				pfar.xy /= pow(2,ceil(level));
				return lerp(fbm_1_2t1_3s(mad(d,_DF,pnear),s),fbm_1_2t1_3s(mad(d,_DF,pfar),s),frac(level));
			}

			float map13(float3 p, float level)
			{
				#ifdef ENABLE_DOMAIN_WARPING
				float d = fbm13(p);
				#else
				float d = 0;
				#endif
				float3 pnear = p;
				pnear.xy /= pow(2,floor(level));
				float3 pfar = p;
				pfar.xy /= pow(2,ceil(level));
				return lerp(fbm13(mad(d,_DF,pnear)),fbm13(mad(d,_DF,pfar)),frac(level));
			}


			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.wPos = mul(unity_ObjectToWorld, v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.scrPos = ComputeScreenPos(o.pos);
				o.uv = v.uv;
				COMPUTE_EYEDEPTH(o.scrPos.z);
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}

			#define tau 6.28318530717958647692528676655900576839433879875021

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 c = _Color;
				float3 wpos = i.wPos;
				float time = _Time.y + _Test;
				float level = max(0,log2(length(ddx(i.wPos)+ddy(i.wPos))/_MUD));
				float3 normal = normalize(i.normal);
				float3 viewDir = normalize(i.wPos - _WorldSpaceCameraPos);
				float3 cameraDir = cameraDir = unity_CameraToWorld._m02_m12_m22;
				float dotnv = dot(normal, -viewDir);
				//viewDir = dotnv < 0 ? -(-viewDir - 2.*dotnv*normal) : viewDir;

				// Calculate normal

				#ifdef _NOISESPACE_WORLD
				float4 p4n = float4(mad(time,-_Flow.xyz,i.wPos),time*_Flow.w);
				p4n *= _Scale;
				#elif _NOISESPACE_OBJECT
				float4 p4n = float4(mul(unity_WorldToObject, float4(mad(time,-_Flow.xyz,i.wPos), 1)).xyz,time*_Flow.w);
				p4n *= _Scale;
				#elif _NOISESPACE_UV
				float3 p4n = float3(mad(time,-_Flow.xy,i.uv),time);
				p4n *= _Scale.xyw;
				#elif _NOISESPACE_UVTORUS
				float3 p4n = float3(mad(time,-_Flow.xy,i.uv),time);
				#endif

				float d = .001*log2(time);

				float3 nddxwpos = normalize(ddx(wpos));
				float3 wtanx = normalize(cross(normal,cross(ddx(wpos),normal)));
				float dotwtanxnddxwpos = dot(wtanx,nddxwpos);
				float3 apprxwposdiffx = wtanx / dotwtanxnddxwpos * d;

				float3 nddywpos = normalize(ddy(wpos));
				float3 wtany = normalize(cross(normal,cross(ddy(wpos),normal)));
				float dotwtanynddywpos = dot(wtany,nddywpos);
				float3 apprxwposdiffy = wtany / dotwtanynddywpos * d;

				#ifdef _NOISESPACE_UVTORUS
				float3 wavepos0 = _WH*map_1_2t1_3s(p4n,_Scale.xyw,level)*normal; //+wpos
				float3 waveposx = _WH*map_1_2t1_3s(p4n+ddx(p4n)*d/length(ddx(wpos))/dotwtanxnddxwpos,_Scale.xyw,level)*normal+apprxwposdiffx; //+wpos
				float3 waveposy = _WH*map_1_2t1_3s(p4n+ddy(p4n)*d/length(ddy(wpos))/dotwtanynddywpos,_Scale.xyw,level)*normal+apprxwposdiffy; //+wpos
				#elif _NOISESPACE_UV
				float3 wavepos0 = _WH*map13(p4n,level)*normal; //+wpos
				float3 waveposx = _WH*map13(p4n+ddx(p4n)*d/length(ddx(wpos))/dotwtanxnddxwpos,level)*normal+apprxwposdiffx; //+wpos
				float3 waveposy = _WH*map13(p4n+ddy(p4n)*d/length(ddy(wpos))/dotwtanynddywpos,level)*normal+apprxwposdiffy; //+wpos
				#else
				float3 wavepos0 = _WH*map14(p4n,level)*normal; //+wpos
				float3 waveposx = _WH*map14(p4n+ddx(p4n)*d/length(ddx(wpos))/dotwtanxnddxwpos,level)*normal+apprxwposdiffx; //+wpos
				float3 waveposy = _WH*map14(p4n+ddy(p4n)*d/length(ddy(wpos))/dotwtanynddywpos,level)*normal+apprxwposdiffy; //+wpos
				#endif

				float3 wnormal = normalize(cross(waveposx-wavepos0,waveposy-wavepos0));
				wnormal = dotnv < 0 ? -wnormal : wnormal;

				// Calculate UV for grabtexture and cameradepthtexture

				float4 depth4cd = UNITY_PROJ_COORD(i.scrPos);
				float truedepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd))/dot(cameraDir, viewDir);
				if(UNITY_MATRIX_P._m22 < .001) truedepth = LinearEyeDepthScreenUV(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd),depth4cd.xy/depth4cd.w);
				if (truedepth < 0) truedepth = 1.#INF;
				float3 wnormalc = mul(unity_WorldToCamera, wnormal);
				float4 grabUV = i.grabPos;
				float2 aspect = _ScreenParams.xy / min(_ScreenParams.x, _ScreenParams.y);
				grabUV.xy += _Distortion * wnormalc.xy / aspect;
				depth4cd.xy += _Distortion * wnormalc.xz / aspect;

				// Calculate transparency

				float depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd))/dot(cameraDir, viewDir);
				if(UNITY_MATRIX_P._m22 < .001) depth = LinearEyeDepthScreenUV(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd),saturate(depth4cd.xy/depth4cd.w));
				if (depth < 0) depth = 1.#INF;
				float surfDepth = distance(_WorldSpaceCameraPos, i.wPos);
				float depthDiff = depth - surfDepth;
				float truedepthDiff = truedepth - surfDepth;
				if (_IsVD)
				{
					depthDiff = min(_VD, depthDiff);
					truedepthDiff = min(_VD, truedepthDiff);
				}
				float transparency = 1 - saturate(1 / pow(_Opacity, depthDiff > 0 ? depthDiff : truedepthDiff));

				// Lighting

				float3 lightDir;
				if (_Manual_directional_light_direction)
				{
					lightDir = normalize(_LD.xyz);
				}
				else
				{
					lightDir = normalize(_WorldSpaceLightPos0.xyz);
				}
				lightDir = dotnv < 0 ? lightDir - 2 * normal * dot(normal, lightDir) : lightDir;

				float3 lightColor;
				if (_Manual_directional_light_color)
				{
					lightColor = _LC.rgb;
				}
				else
				{
					lightColor = _LightColor0.rgb;
				}
				fixed4 reflectionProbeColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflect(viewDir,dotnv < 0 ? -wnormal : wnormal), 0);
				lightColor = lerp(lightColor, reflectionProbeColor, _Blend_DLC_RP);

				float3 specular = pow(max(0,dot(reflect(-lightDir, wnormal),-viewDir)), _SpecPower);
				float fresnel = pow(1-max(0,dot(lightDir,wnormal)),_FresnelPower);

				fixed4 grabCol = tex2D(_GrabTex_myxy_Ocean, saturate((depthDiff > 0 ? grabUV.xy : i.grabPos.xy)/grabUV.w));
				c.rgb = lerp(grabCol * (dotnv < 0 ? 1 - _Ref : 1), lerp(_ColorShallow,c.rgb,pow(transparency,_Pa1)), dotnv < 0 ? 0 : transparency);
				c.rgb += ((specular*_SpecInt+fresnel*_FresnelInt)*lightColor)*(dotnv < 0 ? 1-_Ref:_Ref);
				UNITY_APPLY_FOG(i.fogCoord, col);

				return c;
			}
			ENDCG
		}
	}
}