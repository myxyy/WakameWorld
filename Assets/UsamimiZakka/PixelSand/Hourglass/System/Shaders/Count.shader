Shader "myxy/PixelSand/Count"
{
    Properties
    {
        [HideInInspector] _MainTex ("SandTex", 2D) = "black" {}
        [HideInInspector] _Count ("Count", Int) = 32
        [HideInInspector] _Log2Res ("Log2Res", Int) = 8
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

            sampler2D _MainTex;
            int _Count;
            int _Log2Res;

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

            uint3 count(uint2 iuv)
            {
                uint res = exp2(_Log2Res);
                uint2 xlInit = tex2Dlod(_MainTex, float4((uint2(0,iuv.y<2?0:1)+.5)*.5,0,_Log2Res-1)).ba*res*res*.25+.5;
                uint2 xrInit = tex2Dlod(_MainTex, float4((uint2(1,iuv.y<2?0:1)+.5)*.5,0,_Log2Res-1)).ba*res*res*.25+.5;
                uint cxlInit = (iuv.y%2<1)?xlInit.x:(xlInit.y-xlInit.x);
                uint cxrInit = (iuv.y%2<1)?xrInit.x:(xrInit.y-xrInit.x);
                if (cxlInit + cxrInit <= iuv.x)
                {
                    return uint3(0,0,1);
                }
                uint2 crdi = uint2(cxlInit>iuv.x?0:1,iuv.y<2?0:1);
                uint cp = cxlInit>iuv.x?0:cxlInit;

                for (int i=_Log2Res-2; i>=0; i--)
                {
                    int resScale = exp2(_Log2Res-i);
                    int countScale = exp2(i)*exp2(i);
                    uint2 lli = tex2Dlod(_MainTex, float4((crdi*2+uint2(0,0)+.5)/resScale,0,i)).ba*countScale+.5;
                    uint2 lri = tex2Dlod(_MainTex, float4((crdi*2+uint2(1,0)+.5)/resScale,0,i)).ba*countScale+.5;
                    uint2 uli = tex2Dlod(_MainTex, float4((crdi*2+uint2(0,1)+.5)/resScale,0,i)).ba*countScale+.5;
                    uint clli = (iuv.y%2<1)?lli.x:(lli.y-lli.x);
                    uint clri = (iuv.y%2<1)?lri.x:(lri.y-lri.x);
                    uint culi = (iuv.y%2<1)?uli.x:(uli.y-uli.x);
                    crdi = crdi*2 + ((cp+clli)>iuv.x?uint2(0,0):(cp+clli+clri)>iuv.x?uint2(1,0):(cp+clli+clri+culi)>iuv.x?uint2(0,1):uint2(1,1));
                    cp += (cp+clli)>iuv.x?0:(cp+clli+clri)>iuv.x?clli:(cp+clli+clri+culi)>iuv.x?(clli+clri):(clli+clri+culi);
                }
               
                return uint3(crdi,0);
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
                uint2 iuv = i.uv * float2(_Count, 4);
                return float4(count(iuv),1);
            }
            ENDCG
        }
    }
}
