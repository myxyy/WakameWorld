Shader "myxy/YClock"
{
	Properties
	{
		_hour("hour",int) = 0
		_min("min",int) = 0
		_sec("sec",int) = 0
		_msec("msec",int) = 0
		_year("year",int) = 0
		_month("month",int) = 0
		_day("day",int) = 0
		_dow("day of week",int) = 0
		_moon("moon", int) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct colmap
			{
				uint3 cmap[8];
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				nointerpolation colmap cmap : TEXCOORD1;
			};

			uint _hour;
			uint _min;
			uint _sec;
			uint _msec;
			uint _year;
			uint _month;
			uint _day;
			uint _dow;
			uint _moon;

			colmap outcolmap(void) {
				colmap o;
				_year -= 1900;
				_day++;
				o.cmap[0] = uint3(
					(_hour&0x01?1:0) + (_hour&0x08?2:0) + (_min&0x01?4:0) + (_min&0x08?8:0) + (_sec&0x01?16:0) + (_sec&0x08?32:0) + (_msec&0x01?64:0) + (_msec&0x08?128:0),
					(_hour&0x02?1:0) + (_hour&0x10?2:0) + (_min&0x02?4:0) + (_min&0x10?8:0) + (_sec&0x02?16:0) + (_sec&0x10?32:0) + (_msec&0x02?64:0) + (_msec&0x10?128:0),
					(_hour&0x04?1:0) + (_hour&0x20?2:0) + (_min&0x04?4:0) + (_min&0x20?8:0) + (_sec&0x04?16:0) + (_sec&0x20?32:0) + (_msec&0x04?64:0) + (_msec&0x20?128:0)
				);
				o.cmap[1] = uint3(
					(_year&0x01?1:0) + (_year&0x08?2:0) + (_year&0x040?4:0) + (_month&0x01?8:0) + (_month&0x08?16:0) + (_day&0x01?32:0) + (_day&0x08?64:0) + (_dow&0x01?128:0),
					(_year&0x02?1:0) + (_year&0x10?2:0) + (_year&0x080?4:0) + (_month&0x02?8:0) + (_month&0x10?16:0) + (_day&0x02?32:0) + (_day&0x10?64:0) + (_dow&0x02?128:0),
					(_year&0x04?1:0) + (_year&0x20?2:0) + (_year&0x100?4:0) + (_month&0x04?8:0) + (_month&0x20?16:0) + (_day&0x04?32:0) + (_day&0x20?64:0) + (_dow&0x04?128:0)
				);
				o.cmap[2] = uint3(
					(_moon&0x01?1:0) + (_moon&0x08?2:0),
					(_moon&0x02?1:0) + (_moon&0x10?2:0),
					(_moon&0x04?1:0) + (_moon&0x20?2:0)
				);
				o.cmap[3] = 0;
				o.cmap[4] = 0;
				o.cmap[5] = 0;
				o.cmap[6] = 0;
				o.cmap[7] = 0;
				return o;
			}
			
			v2f vert (appdata v)
			{
				v2f o;
				o.uv = v.uv;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.cmap = outcolmap();
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 col = (fixed3)0.;

				i.uv.x = 1 - i.uv.x;

				uint2 xy = floor(i.uv * 8);

				col = clamp(i.cmap.cmap[xy.y] & (uint3)(0x01 << xy.x), 0, 1)*255.;
				//col = step(0, -(i.cmap.cmap[xy.y] & ((uint3)0x01 << xy.x)))*255.;

				return fixed4(col,1);
			}
			ENDCG
		}
	}
}
