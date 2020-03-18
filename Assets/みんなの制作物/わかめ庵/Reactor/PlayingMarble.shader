// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// Created by S. Guillitte 2015
// See https://www.shadertoy.com/view/MtX3Ws
// Remixed by myxy 2020
Shader "PlayingMarble"
{
	Properties
	{
		_speed("speed", float) = .125
		_step ("step", int) = 5
		_hue ("hue", range(0,1)) = 0.
		_hspeed ("hue speed", float) = .125
		_smoke ("smoke", range(0,1)) = 1.
		_scale ("scale", float) = .49
		_rflx ("reflex", range(0,10)) = 4
	}
	SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent"}
		LOD 100
		GrabPass{}
		Pass
		{
			Cull Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "HLSLSupport.cginc"

			sampler2D _GrabTexture;
			float _speed;
			float _step;
			float _hue;
			float _hspeed;
			float _smoke;
			float _scale;
			float _rflx;
			sampler2D _CameraDepthTexture;


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 ro : TEXCOORD0;
				float3 oc : TEXCOORD1;
				float4 spos : TEXCOORD2;
			};

			struct frag_out
			{
				fixed4 color : SV_Target;
				float depth : SV_Depth;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.ro = _WorldSpaceCameraPos;
				o.ro = mul(unity_WorldToObject, float4(o.ro, 1.)).xyz;
				o.oc = v.vertex.xyz;
				o.spos = ComputeGrabScreenPos(o.vertex);
				return o;
			}

			float2 csqr(float2 a) { return float2(a.x*a.x - a.y*a.y, 2 * a.x*a.y); }

			float2x2 rot(float a) {
				float c = cos(a), s = sin(a);
				return float2x2(c, s, -s, c);
			}

			float2 iSphere(float3 ro, float3 rd, float4 sph) {
				float3 oc = ro - sph.xyz;
				float b = dot(oc, rd);
				float c = dot(oc, oc) - sph.w*sph.w;
				float h = b * b - c;
				if (h < 0)return (float2)(-1);
				h = sqrt(h);
				return float2(-b - h, -b + h);
			}

			float map(float3 p) {
				float res = 0.;
				float3 c = p;
				for (int i = 0; i < _step; i++) {
					p.xy = mul(p.xy, rot((_Time.y + i * .2546)*_speed));
					p.xz = mul(p.xz, rot((_Time.y + i * .4536)*_speed));
					p = .7 * abs(p) / dot(p, p) - .7;
					p.x += .2*sin(_Time.y*_speed + i);
					p.yz = csqr(p.yz);
					//p.yx = csqr(p.yx);
					p = p.zxy;
					res += exp(-19 * abs(dot(p, c)));
				}
				return res/2;
			}

			float3 raymarch(float3 ro, float3 rd, float2 tminmax) {
				float t = tminmax.x;
				float dt = .02;
				float c = 0;
				float3 col;
				for (int i = 0; i < 32; i++) {
					t += dt * exp(-2 * c);
					if (t > tminmax.y)break;
					c = map(ro + t * rd);
					col = .99*col + .08*lerp(float3(1, 0, 0), float3(c, c*c, c*c*c), _smoke);
				}
				return col;
			}

			float3 hsv2rgb(float3 c) {
				return c.z * lerp((float3)1, clamp(abs(frac((float3)c.x + float3(1, 2. / 3, 1. / 3)) * 6 - (float3)3) - (float3)1, 0, 1), c.y);
			}

			float3 rgb2hsv(float3 c) {
				float4 k = float4(0., -1. / 3, 2. / 3, -1);
				float4 p = lerp(float4(c.bg, k.wz), float4(c.gb, k.xy), step(c.b, c.g));
				float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));

				float d = q.x - min(q.w, q.y);
				float e = 1.e-10;
				return float3(abs(q.z + (q.w - q.y) / (6.*d + e)), d / (q.x + e), q.x);
			}
			
			frag_out frag (v2f i)
			{
				frag_out o;
				float3 col = float3(0,0,0);
				float3 ro = i.ro;
				float3 rd = normalize(i.oc - ro);
				float2 grabuv = i.spos.xy / i.spos.w;
				float4 back = tex2D(_GrabTexture, grabuv);

				float2 tmm = iSphere(ro, rd, float4(0, 0, 0, _scale));
				if (tmm.x < 0 && tmm.y < 0)discard;
				col = raymarch(ro, rd, tmm);
				float3 hsv = rgb2hsv(col);
				hsv.x = frac(hsv.x + _hue + _Time.y*_hspeed);
				col = hsv2rgb(hsv);

				//float a = clamp(.1*exp(-(tmm.y - tmm.x)),0,1);
				float a = clamp(1-16.*pow((tmm.y - tmm.x),3), 0, 1);
				a = 1 - a;

				col = lerp(back, col, a);

				/*
				float odepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.spos)));
				float sdepth = UNITY_Z_0_FAR_FROM_CLIPSPACE(ComputeScreenPos(UnityObjectToClipPos(float4(ro + rd * tmm.x, 1))).z);
				float bdepth = UNITY_Z_0_FAR_FROM_CLIPSPACE(ComputeScreenPos(UnityObjectToClipPos(float4(ro + rd * tmm.y, 1))).z);
				float dd = max(odepth - sdepth,0);
				if (sdepth < odepth && odepth < bdepth)
					col = lerp(back, col, min(dd,1));
				*/
				float3 nor = normalize(ro + tmm.x*rd);
				nor = reflect(rd, nor);
				float fre = pow(.5 + clamp(dot(nor, rd), 0, 1), 3)*_rflx;
				nor = UnityObjectToWorldDir(nor);
				col += UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, nor, 0).rgb*fre;


				col = .5*(log(1 + col));
				col = clamp(col, 0, 1);
				float4 vppos = UnityObjectToClipPos(float4(ro + rd * (tmm.x > 0 ? tmm.x : tmm.y), 1));

				o.depth = vppos.z / vppos.w;
				o.color = float4(col, 1);
				return o;
			}
			ENDCG
		}
	}
}
