Shader"Raymarching/Wakame3"{
	Properties{
		_Radius("Radius", float) = 0.5
	}
	SubShader{
		Tags{
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
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
	
			float _Radius;
	
			#define STEPS 64

			struct appdata {
				float4 vertex : POSITION;
			};

			struct ray {
				float3 org;
				float3 dir;
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

			float wakameshape(float3 pos, float3 center)
			{
				pos -= center;
				float plane = abs(pos.z) - .01;
				pos.y = 1.5*pos.y+.0;
				pos.y = min(pos.y, .76);
				float curve = 1.*pos.y*pos.y*(3. - 4.*pos.y)+.01;
				float side = abs(pos.x) - (.4 + .1*sin(60.*pos.y-5.*_Time.y))*curve;
				return max(-pos.y ,max(plane,side));
				//return max(plane, side);
			}

			float wakameshape2(float3 pos)
			{
				float plane = abs(pos.z) - .01;
				pos.y = 1.5*pos.y + .0;
				pos.y = min(pos.y, .76);
				float curve = 1.*pos.y*pos.y*(3. - 4.*pos.y) + .01;
				float side = abs(pos.x) - (.4 + .1*sin(60.*pos.y - 5.*_Time.y))*curve;
				return max(-pos.y, max(plane, side));
			}

			float wakame(float3 pos, float3 center)
			{
				//pos -= center;
				pos.z += .05*sin(10.*pos.y+_Time.y*2.);
				pos.x += .03*sin(10.*pos.y+_Time.y*3.);
				return wakameshape(pos, center);
			}

			float wakame2(float3 pos)
			{
				//pos -= center;
				pos.z += .05*sin(10.*pos.y + _Time.y*2.);
				pos.x += .03*sin(10.*pos.y + _Time.y*3.);
				return wakameshape2(pos);
			}

			float sphere(float3 pos, float3 center, float radius)
			{
				return distance(pos, center) - radius;
			}

			float2 rotate(float2 pos, float rad)
			{
				return float2(cos(rad)*pos.x - sin(rad)*pos.y, sin(rad)*pos.x + cos(rad)*pos.y);
			}

			float sdf(float3 pos, float3 center)
			{
				pos.xz = (random2(floor(pos.xz+.5))-.5)*.5+frac(pos.xz+.5)-.5;
				//pos.xz = frac(pos.xz+.5)-.5;
				//return sphere(pos, mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz, _Radius);
				return pos.y-center.y > 1. ? pos.y-center.y : wakame(pos, center);
				//return sphere(pos, center, _Radius);
			}

			float sdf2(float3 pos) {
				pos.xz = (random2(floor(pos.xz + .5)) - .5)*.5 + frac(pos.xz + .5) - .5;
				return pos.y > 1. ? pos.y : wakame2(pos);
			}

			float getDepth(float3 rPos) {
				float4 vpPos = UnityObjectToClipPos(float4(rPos,1.0));
				return (vpPos.z / vpPos.w);
			}

			frag_out frag(v2f i)
			{
				frag_out o;
				float3 worldPosition = i.wPos;
				float4 objPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
				//float3 cameraPos = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;
				float3 cameraPos = _WorldSpaceCameraPos;
				//float3 center = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
				float3 center = float3(0, mul(unity_ObjectToWorld, float4(0,0,0,1)).y-1., 0);
				ray r;
				r.dir = normalize(i.wPos - cameraPos);
				//r.org = worldPosition;
				r.org = cameraPos;
				float rLen = 0;
				float3 rPos = r.org;
				float dist = 0;

				for (int ind = 0; ind < STEPS; ind++)
				{
					dist = sdf(rPos, center);
					rLen += dist;
					rPos = r.org + rLen * r.dir;
				}

				o.depth = getDepth(mul(unity_WorldToObject, float4(rPos,1.)).xyz);
				//o.depth = 0;

				float d = .0001;
				float3 normal = normalize(float3(
						sdf(rPos + float3(d, 0, 0), center) - sdf(rPos + float3(-d, 0, 0), center),
						sdf(rPos + float3(0, d, 0), center) - sdf(rPos + float3(0, -d, 0), center),
						sdf(rPos + float3(0, 0, d), center) - sdf(rPos + float3(0, 0, -d), center)
				));

			
				if (abs(dist)<.0001) {
					//o.color = fixed4(float3(1,0,0)*dot(float3(0., 1., 0.), normal),1);
					o.color = fixed4(float3(0,.1,0)*max(0,dot(mul(unity_WorldToObject, _WorldSpaceLightPos0).xyz, normal)),1);
					o.color += fixed4(.0, .1, .0, 0.);
				}else {
					o.color = fixed4(0,0,0,0);
				}
				return o;
			}
			ENDCG
		 }
	 }
}