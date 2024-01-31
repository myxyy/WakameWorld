Shader "myxy/PixelSand/Transfer"
{
    Properties
    {
        [HideInInspector] _CountTex ("SandTex", 2D) = "black" {}
        [HideInInspector] _SandTex ("SandTex", 2D) = "black" {}
        [HideInInspector] _Count ("Count", Int) = 32
        [HideInInspector] _Num ("Num", Int) = 0
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
            #include "Assets/UsamimiZakka/PixelSand/PixelSandCommon/PixelSandCommon.cginc"

            sampler2D _CountTex;
            sampler2D _SandTex;
            float4 _SandTex_TexelSize;
            int _Count;
            int _Num;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 transfer(uint2 iuv)
            {
                for (int i=0; i<abs(_Num); i++)
                {
                    float sandY = ((1-(sign(_Num)*.5+.5))*2+.5)/4;
                    uint3 fetchSand = tex2Dlod(_CountTex, float4((i+.5)/_Count,sandY,0,0)).rgb + .5;
                    float emptyY = ((sign(_Num)*.5+.5)*2+1.5)/4;
                    uint3 fetchEmpty = tex2Dlod(_CountTex, float4((i+.5)/_Count,emptyY,0,0)).rgb + .5;
                    if (fetchSand.z + fetchEmpty.z > 0)
                    {
                        break;
                    }
                    if (iuv.x == fetchSand.x && iuv.y == fetchSand.y)
                    {
                        return float4(EMPTY,0,0,1);
                    }
                    if (iuv.x == fetchEmpty.x && iuv.y == fetchEmpty.y)
                    {
                        return tex2Dlod(_SandTex, float4((fetchSand.xy+.5)/_SandTex_TexelSize.zw,0,0));
                    }
                }
                return tex2Dlod(_SandTex, float4((iuv +.5)/_SandTex_TexelSize.zw,0,0));
            }

            v2f vert (appdata v)
            {
                v2f o;
#if UNITY_UV_STARTS_AT_TOP
                o.vertex = float4(v.uv.x*2-1,1-v.uv.y*2,1,1);
#else
                o.vertex = float4(v.uv.x*2-1,v.uv.y*2-1,1,1);
#endif
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                uint2 iuv = i.uv * _SandTex_TexelSize.zw;
                return transfer(iuv);
            }
            ENDCG
        }
    }
}
