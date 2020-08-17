Shader "WakameIsland/Ocean" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_Color2("Color2", Color) = (1,1,1,1)
		_Pa1("Color gradient parameter", Range(0.1,10)) = 5
		_SpecPower("Specular", Range(1,10)) = 10.0
		_Opacity("Opacity", Range(1,2)) = 1.1
		_Distortion("Distortion", Range(0,1)) = 0.1
		_WH("Wave height", Range(0,2)) = 1
		_Ref("Reflectance", Range(0,1)) = 0.5
		[MaterialToggle] _IsVD("Enable virtual depth", Float) = 0
		_VD ("Virtual depth", Float) = 0.5
		_Flow ("Flow vector, w=wave frequency scale", Vector) = (0,0,0,1)
		_DF ("Domain warping factor", Range(0,10)) = 1
	}
	SubShader {
		Tags { "Queue"="AlphaTest+500" "LightMode"="ForwardBase"}
		LOD 200
		Cull Off

		GrabPass {
			"_GrabTex_myxy_Ocean"
		}

		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

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
			fixed4 _Color2;
			float _Ref;
			float _Pa1;
			float _IsVD;
			float _VD;
			float4 _Flow;
			float _DF;


			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 wPos : WORLD_POS;
				float4 grabPos : TEXCOORD0;
				float4 scrPos : TEXCOORD1;
				float3 normal : TEXCOORD2;
				float3 tangent : TEXCOORD3;
			};

		   	//clipPos.w = 1, viewPos.z = -1
		    float2 ClipXYToViewXY(float2 clipXY)
		    {
		        //clipXY.xy = mad(1, UNITY_MATRIX_P._m02_m12, clipXY.xy);
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

			float h14(float4 p)
			{
				return frac(sin(dot(float4(32.5325,54.4235,73.5252,24.5245),p))*42545.25432);
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

			float fbm14(float4 p) {
				float f = 0;
				float a = 1.;
				float c = cos(1);
				float s = sin(1);
				float4x4 rxy = float4x4(c, s, 0, 0,-s, c, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
				float4x4 rxz = float4x4(c, 0, s, 0, 0, 1, 0, 0,-s, 0, c, 0, 0, 0, 0, 1);
				float4x4 rxw = float4x4(c, 0, 0, s, 0, 1, 0, 0, 0, 0, 1, 0,-s, 0, 0, c);
				float4x4 rxyzw = mul(rxw,mul(rxz,rxy));
				[unroll]
				for (int i = 0; i < 5; i++)
				{
					a *= 2.;
					f += n14(p*a/2)/a;
					p = mul(rxyzw,p);
				}
				return f;
			}

			float map(float4 p)
			{
				//return fbm14(p);
				float d = fbm14(p);
				return fbm14(mad(d,_DF,p));
			}

			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.wPos = mul(unity_ObjectToWorld, v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.scrPos = ComputeScreenPos(o.pos);
				o.tangent = mul(unity_ObjectToWorld, v.tangent.xyz);
				COMPUTE_EYEDEPTH(o.scrPos.z);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 c = _Color;
				float time = _Time.y;
				float3 normal = normalize(i.normal);
				float3 tangent = normalize(cross(cross(normal,i.tangent),normal));
				float3 binormal = normalize(cross(normal,tangent));
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 viewDir = normalize(i.wPos - _WorldSpaceCameraPos);
				//viewDir = normalize(UnityWorldSpaceViewDir(i.wPos));
				float3 cameraDir = normalize(mul(-transpose((float3x3)UNITY_MATRIX_V),float3(0,0,1)));
				float dotnv = dot(normal, -viewDir);
				viewDir = dotnv < 0 ? viewDir - 2.*dotnv*normal : viewDir;

				float noise = map(float4(mad(time,-_Flow.xyz,i.wPos),time*_Flow.w));
				float d = .00001*time;
				float3 vecx = mad(_WH*(map(float4(mad(tangent,d,mad(time,-_Flow.xyz,i.wPos)),time*_Flow.w))-noise),normal,tangent*d);
				float3 vecy = mad(_WH*(map(float4(mad(binormal,d,mad(time,-_Flow.xyz,i.wPos)),time*_Flow.w))-noise),normal,binormal*d);
				float3 wnormal = normalize(cross(vecx,vecy));

				float3 ref = reflect(-lightDir, wnormal);
				float refPower = dot(ref, -viewDir);
				float3 specPower = pow(max(0,refPower), _SpecPower);

				float4 depth4cd = UNITY_PROJ_COORD(i.scrPos);
				float truedepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd))/dot(cameraDir, viewDir);
				if(UNITY_MATRIX_P._m22 < .001) truedepth = LinearEyeDepthScreenUV(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd),depth4cd.xy/depth4cd.w);
				if (truedepth < 0) truedepth = _ProjectionParams.z;
				//if(UNITY_MATRIX_P._m22 < .001) truedepth = LinearEyeDepthScreenUV(0,depth4cd.xy/depth4cd.w);
				//truedepth = 1/(_ZBufferParams.z*SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd)+_ZBufferParams.w)/dot(cameraDir, viewDir);
				//truedepth = tex2D(_CameraDepthTexture, depth4cd.xy/depth4cd.w).r;
				float3 wnormalc = mul(unity_WorldToCamera, wnormal);
				float4 grabUV = i.grabPos;
				float2 aspect = _ScreenParams.xy / min(_ScreenParams.x, _ScreenParams.y);
				grabUV.xy += _Distortion * wnormalc.xy / aspect;
				depth4cd.xy += _Distortion * wnormalc.xz / aspect;

				float depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd))/dot(cameraDir, viewDir);
				if(UNITY_MATRIX_P._m22 < .001) depth = LinearEyeDepthScreenUV(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd),saturate(depth4cd.xy/depth4cd.w));
				if (depth < 0) depth = _ProjectionParams.z;
				//if(UNITY_MATRIX_P._m22 < .001) depth = LinearEyeDepthScreenUV(0,depth4cd.xy/depth4cd.w);
				//depth = 1/(_ZBufferParams.z*SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd)+_ZBufferParams.w)/dot(cameraDir, viewDir);
				//depth = tex2D(_CameraDepthTexture, depth4cd.xy/depth4cd.w).r;
				float surfDepth = distance(_WorldSpaceCameraPos, i.wPos);
				float depthDiff = depth - surfDepth;
				float truedepthDiff = truedepth - surfDepth;
				if (_IsVD)
				{
					depthDiff = min(_VD, depthDiff);
					truedepthDiff = min(_VD, truedepthDiff);
				}
				float transparency = 1 - saturate(1 / pow(_Opacity, depthDiff > 0 ? depthDiff : truedepthDiff));

				fixed4 grabCol = tex2D(_GrabTex_myxy_Ocean, saturate((depthDiff > 0 ? grabUV.xy : i.grabPos.xy)/grabUV.w));
				c.rgb = lerp(grabCol, lerp(_Color2,c.rgb,pow(transparency,_Pa1)), dotnv < 0 ? 0 : transparency);
				c.rgb += (float3)specPower*_LightColor0*(dotnv < 0 ? 1-_Ref:_Ref);
				//c.rgb = exp(-surfDepth*.1);
				//c.rgb = exp(-truedepth*.1);
				//c.rgb = truedepthDiff;
				//c.rgb = truedepth;
				//c.rgb = truedepth*.1;
				//c.rgb = exp(-abs(_ZBufferParams.xyzw)*2).xyz;
				//c.rgb = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos));
				//float cd = tex2D(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos).xy/UNITY_PROJ_COORD(i.scrPos).w).r;
				//float dist = LinearEyeDepth(cd) + (UNITY_MATRIX_P._m20 ? _ProjectionParams.z - _ProjectionParams.y : 0);
				//c.rgb = exp(-(dist));
				//c.rgb = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd);
				//c.rgb = noise;
				//c.rgb = (ddx(noise))/length(ddx(i.wPos));
				//c.rgb = .5*wnormal+.5;
				//c.rgb = .5*normalize(vecx)+.5;
				//float4 cddx = ddx(c);
				//float4 cddy = ddy(c);
				//c += cddx*.5 + cddy*.5;

				return c;
			}
			ENDCG
		}
	}
}