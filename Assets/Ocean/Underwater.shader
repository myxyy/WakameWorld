Shader "WakameIsland/Underwater"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SL ("Sea level", Float) = 0.
        _Color ("Color", Color) = (0,0,0,1)
        _SC ("Sea color", Color) = (0,0,1,1)
        _Tr ("Transparency", Range(0,1)) = .1
        _Tr2 ("Transparency2", Range(0,1)) = .1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent+100" }
        LOD 100
        ZTEST Always

		GrabPass {
			"_GrabTex_UnderWater"
		}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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
                float4 grabPos : TEXCOORD2;
                float4 scrPos : TEXCOORD3;
                float3 viewDir : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _GrabTex_UnderWater;
            float _SL;
            float4 _Color;
            float4 _SC;
			sampler2D _CameraDepthTexture;
            float _Tr;
            float _Tr2;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = float4(1-2*v.uv.x,2*v.uv.y-1,0,1);
                float3 localViewDir = float3(-1/UNITY_MATRIX_P._m00_m11*o.vertex.xy, 1);
                float4x4 vrotate = UNITY_MATRIX_V;
                vrotate._m03 = vrotate._m13 = vrotate._m23 = 0;
                o.viewDir = -mul(transpose(vrotate), float4(localViewDir,0)).xyz;

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.grabPos = ComputeGrabScreenPos(o.vertex);
				o.scrPos = ComputeScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 wscp = _WorldSpaceCameraPos;
                if (wscp.y > _SL) clip(-1);
                //float3 viewDir = UNITY_MATRIX_V._m20_m21_m22;
                float3 viewDir = normalize(i.viewDir);
                float seaDist = length((_SL-wscp.y)/viewDir.y);
                seaDist = viewDir.y > 0 ? seaDist : 100000;
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 grabCol = tex2D(_GrabTex_UnderWater, i.grabPos.xy/i.grabPos.w);
				float4 depth4cd = UNITY_PROJ_COORD(i.scrPos);
				float depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, depth4cd));
                float test = depth > seaDist ? 1 : 0;
                depth = depth > seaDist ? seaDist : depth;
                col = grabCol;
                col.rgb += _Color.rgb * min(depth*_Tr2, 1);
                //return fixed4(viewDir, 1);
                //return fixed4(fixed3(exp(-depth),test,0),1);
                return lerp(col, _SC, 1-exp(-depth*_Tr));
            }
            ENDCG
        }
    }
}
