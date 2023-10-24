Shader"Raymarching/WakameSingle"{
	Properties{
		_Test("Test", float) = 1.0
		_Test2("Test2", range(0,.5)) = 1.0
	}
	SubShader{
		Tags{
			"RenderType" = "Transparent"
			"Queue" = "Geometry"
			"LightMode" = "ForwardBase"
		}
		Pass{
			Cull Off
			//ZWrite On
			//ZTest LEqual
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	
			#include "UnityCG.cginc"
	
			float _Test;
			float _Test2;
	
			#define STEPS 64

			struct appdata {
				float4 vertex : POSITION;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float3 pos : TEXCOORD0;
				float3 wPos : TEXCOORD1; // World Position
			};

			struct frag_out
			{
				fixed4 color : SV_Target;
				float depth : SV_Depth;
			};

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.pos = v.vertex.xyz;
				o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}

			float2 random2(float2 p) {
				return frac(sin(float2(dot(p, float2(12.9898, 78.233)), dot(p, float2(32.2352, 57.567))))*43758.5453);
			}

			float wakameshape(float3 pos)
			{
				float plane = abs(pos.z) - .01;
				pos.y = 1.5*pos.y + .0;
				pos.y = min(pos.y, .76);
				float curve = 1.*pos.y*pos.y*(3. - 4.*pos.y) + .01;
				float side = abs(pos.x) - (.4 + .1*sin(60.*pos.y - 5.*_Time.y))*curve;
				return max(-pos.y, max(plane, side));
			}

			float wakameshape2(float3 pos)
			{
				float3 p = pos;
				float plane = abs(pos.z) - .1;
				p.y = 1.5*p.y + .0;
				p.y = min(p.y, .76);
				float curve = 1.*p.y*p.y*(3. - 4.*p.y) + .01;
				float side = abs(p.x) - (.4 + .1*sin(60.*p.y - 5.*_Time.y))*curve;
				side = abs(p.x) - .1;
				return max(pos.y-.5, max(plane, side));// max(-pos.y, max(plane, side));
			}

			float testshape(float3 pos)
			{
				return max(abs(pos.z) - .02, pos.y - .5);
			}

			float wakame(float3 pos)
			{
				//pos -= center;

				pos.z += .05*sin(10.*pos.y + _Time.y*2.);
				pos.x += .03*sin(10.*pos.y + _Time.y*3.);
				return wakameshape(pos);
			}

			float sphere(float3 pos)
			{
				return length(pos) - 1.;
			}

			float cube(float3 pos)
			{
				pos = abs(pos) - 1.;
				return max(pos.x, max(pos.y, pos.z));
			}

			float2 rotate(float2 pos, float rad)
			{
				return float2(cos(rad)*pos.x - sin(rad)*pos.y, sin(rad)*pos.x + cos(rad)*pos.y);
			}

			float sdf(float3 pos) {
				float3 p = pos;
				p = pos - mul(unity_ObjectToWorld, float4(0, 0, 0, 1)) - float3(0, _Test, 0);
				return wakame(p);
			}

			float getDepth(float3 rPos) {
				float4 vpPos = UnityObjectToClipPos(float4(rPos,1.0));
				return (vpPos.z / vpPos.w);
			}

			float raymarch(float3 ro, float3 rd)
			{
				float dist, rLen = 0;
				float3 rPos = ro;
				for (int i = 0; i < STEPS; i++) {
					dist = sdf(rPos);
					rLen += dist*.9;
					rPos = ro + rLen * rd;
				}
				if (abs(dist) < .0001) return rLen;
				else return -1;
			}

			frag_out frag(v2f i)
			{
				frag_out o;
				float3 worldPosition = i.wPos;
				float3 cameraPos = _WorldSpaceCameraPos;

				float3 rdir = normalize(i.wPos - cameraPos);
				//r.org = worldPosition;

				float3 rorg = cameraPos;
				float rLen = raymarch(rorg, rdir);
				float3 rPos = rorg + rLen*rdir;

				o.depth = getDepth(mul(unity_WorldToObject, float4(rPos,1.)).xyz);
				//o.depth = 0;

				float d = .0001;
				//float3 rPos4sdf = rPos - objPos.xyz - float3(0, _Test, 0);
				float3 normal = normalize(float3(
						sdf(rPos + float3(d, 0, 0)) - sdf(rPos + float3(-d, 0, 0)),
						sdf(rPos + float3(0, d, 0)) - sdf(rPos + float3(0, -d, 0)),
						sdf(rPos + float3(0, 0, d)) - sdf(rPos + float3(0, 0, -d))
				));

			
				if (rLen != -1) {
					//o.color = fixed4(float3(1,0,0)*dot(float3(0., 1., 0.), normal),1);
					o.color = fixed4(float3(0,.1,0)*max(0,dot(mul(unity_WorldToObject, _WorldSpaceLightPos0).xyz, normal)),1);
					o.color += fixed4(.0, .1, .0, 0.);
				}else {
					discard;
					//o.color = fixed4(0,0,0,0);
				}
				return o;
			}
			ENDCG
		 }
	 }
}