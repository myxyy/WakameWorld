Shader "Unlit/DigitalClock"
{
	Properties
	{
		_DataTex ("Texture", 2D) = "white" {}
		_DigitsTex("Digits", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_s ("Select:yyyyMMddhhmmss(0~13)", Int) = 0
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

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				nointerpolation uint d : TEXCOORD1;
			};

			struct date_t
			{
				uint year;
				uint month;
				uint day;
				uint hour;
				uint minute;
				uint second;
			};

			sampler2D _DataTex;
			sampler2D _DigitsTex;
			float4 _Color;
			uint _s;

			static const uint y1970 = 1970;

			uint getDaysInYears(uint y) {
				uint ly;
				y--;
				ly = 365 * y;
				ly += y / 4;
				ly -= y / 100;
				ly += y / 400;
				return ly;
			}

			bool isLeapYear(uint y) {
				bool c4 = y % 4 == 0;
				bool c100 = y % 100 == 0;
				bool c400 = y % 400 == 0;
				return c4 && (!c100 || c400);
			}

			static const uint monthDays[13] = { 0,31,59,90,120,151,181,212,243,273,304,334,365 };

			uint dateToSeconds(date_t d) {
				uint daysTo1970 = getDaysInYears(y1970);

				uint daysInYears = getDaysInYears(d.year) - daysTo1970;
				uint daysInMonths = monthDays[d.month - 1] + (d.month > 2 && isLeapYear(d.year) ? 1 : 0);
				uint daysInYMD = daysInYears + daysInMonths + (d.day - 1);
				uint hoursInYMDH = daysInYMD * 24 + d.hour;
				uint minutesInYMDHM = hoursInYMDH * 60 + d.minute;
				uint secondsInYMDHMS = minutesInYMDHM * 60 + d.second;

				return secondsInYMDHMS;
			}

			date_t secondsToDate(uint s) {
				uint daysTo1970 = getDaysInYears(y1970);

				date_t d;
				d.second = s % 60;
				s /= 60;
				d.minute = s % 60;
				s /= 60;
				d.hour = s % 24;
				s /= 24;
				
				s += daysTo1970;

				uint start = 0, end = (s / 365) + 1, mid;
				for (int i = 0; i < 16; i++) {
					if (start + 1 == end) break;
					mid = (start + end) / 2;
					if (getDaysInYears(mid) <= s) start = mid;
					else end = mid;
				}
				d.year = start;
				s -= getDaysInYears(d.year);
				uint dm;
				for (int i = 1; i <= 12; i++) {
					dm = monthDays[i] + (i >= 2 && isLeapYear(d.year) ? 1 : 0);
					if (s < dm) {
						d.month = i;
						break;
					}
				}
				s -= monthDays[d.month - 1] + (d.month > 2 && isLeapYear(d.year) ? 1 : 0);
				d.day = s + 1;
				return d;
			}
			
			v2f vert (appdata v)
			{
				v2f o;
				date_t d;
				uint ms,dw,moon,utime;
				float2 offset = float2(1. / 16., 1. / 16.);
				uint3 m11 = round(tex2Dlod(_DataTex, float4(float2(7, 0) / 8. + offset, 0, 0)));
				uint3 m21 = round(tex2Dlod(_DataTex, float4(float2(6, 0) / 8. + offset, 0, 0)));
				uint3 m31 = round(tex2Dlod(_DataTex, float4(float2(5, 0) / 8. + offset, 0, 0)));
				uint3 m41 = round(tex2Dlod(_DataTex, float4(float2(4, 0) / 8. + offset, 0, 0)));
				uint3 m51 = round(tex2Dlod(_DataTex, float4(float2(3, 0) / 8. + offset, 0, 0)));
				uint3 m61 = round(tex2Dlod(_DataTex, float4(float2(2, 0) / 8. + offset, 0, 0)));
				uint3 m71 = round(tex2Dlod(_DataTex, float4(float2(1, 0) / 8. + offset, 0, 0)));
				uint3 m81 = round(tex2Dlod(_DataTex, float4(float2(0, 0) / 8. + offset, 0, 0)));
				uint3 m12 = round(tex2Dlod(_DataTex, float4(float2(7, 1) / 8. + offset, 0, 0)));
				uint3 m22 = round(tex2Dlod(_DataTex, float4(float2(6, 1) / 8. + offset, 0, 0)));
				uint3 m32 = round(tex2Dlod(_DataTex, float4(float2(5, 1) / 8. + offset, 0, 0)));
				uint3 m42 = round(tex2Dlod(_DataTex, float4(float2(4, 1) / 8. + offset, 0, 0)));
				uint3 m52 = round(tex2Dlod(_DataTex, float4(float2(3, 1) / 8. + offset, 0, 0)));
				uint3 m62 = round(tex2Dlod(_DataTex, float4(float2(2, 1) / 8. + offset, 0, 0)));
				uint3 m72 = round(tex2Dlod(_DataTex, float4(float2(1, 1) / 8. + offset, 0, 0)));
				uint3 m82 = round(tex2Dlod(_DataTex, float4(float2(0, 1) / 8. + offset, 0, 0)));
				uint3 m13 = round(tex2Dlod(_DataTex, float4(float2(7, 2) / 8. + offset, 0, 0)));
				uint3 m23 = round(tex2Dlod(_DataTex, float4(float2(6, 2) / 8. + offset, 0, 0)));

				d.hour = m11.r + m11.g * 2 + m11.b * 4 + m21.r * 8 + m21.g * 16 + m21.b * 32;
				d.minute = m31.r + m31.g * 2 + m31.b * 4 + m41.r * 8 + m41.g * 16 + m41.b * 32;
				d.second = m51.r + m51.g * 2 + m51.b * 4 + m61.r * 8 + m61.g * 16 + m61.b * 32;
				ms = m71.r + m71.g * 2 + m71.b * 4 + m81.r * 8 + m81.g * 16 + m81.b * 32;
				d.year = m12.r + m12.g * 2 + m12.b * 4 + m22.r * 8 + m22.g * 16 + m22.b * 32 + m32.r * 64 + m32.g * 128 + m32.b * 256 + 1900;
				d.month = m42.r + m42.g * 2 + m42.b * 4 + m52.r * 8 + m52.g * 16 + m52.b * 32 + 1;
				d.day = m62.r + m62.g * 2 + m62.b * 4 + m72.r * 8 + m72.g * 16 + m72.b * 32;
				dw = m82.r + m82.g * 2 + m82.b * 4;
				//moon = m13.r + m13.g * 2 + m13.b * 4 + m23.r * 8 + m23.g * 16 + m23.b * 32;

				/*
				//test
				d.hour = 23;
				d.minute = 59;
				d.second = 59;
				d.year = 2004;
				d.month = 2;
				d.day = 28;
				*/
				
				utime = dateToSeconds(d);
				utime += (uint)_Time.y;
				d = secondsToDate(utime);

				switch (_s) {
				case 0:
					o.d = d.year / 1000;
					break;
				case 1:
					o.d = (d.year / 100) % 10;
					break;
				case 2:
					o.d = (d.year / 10) % 10;
					break;
				case 3:
					o.d = d.year % 10;
					break;
				case 4:
					o.d = d.month / 10;
					break;
				case 5:
					o.d = d.month % 10;
					break;
				case 6:
					o.d = d.day / 10;
					break;
				case 7:
					o.d = d.day % 10;
					break;
				case 8:
					o.d = d.hour / 10;
					break;
				case 9:
					o.d = d.hour % 10;
					break;
				case 10:
					o.d = d.minute / 10;
					break;
				case 11:
					o.d = d.minute % 10;
					break;
				case 12:
					o.d = d.second / 10;
					break;
				case 13:
					o.d = d.second % 10;
					break;
				default:
					o.d = 0;
					break;
				}

				o.uv = v.uv;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				i.uv.x *= .1;
				i.uv.x += i.d / 10.;
				// sample the texture
				fixed4 col = tex2D(_DigitsTex, i.uv) * _Color;
				if (col.a < .5) discard;
				return col;
			}
			ENDCG
		}
	}
}
