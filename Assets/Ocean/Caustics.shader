Shader "WakameIsland/Caustics"
{
    Properties
    {
        _p0 ("p0", Range(0,1)) = 1
        _p1 ("p1", Float) = 25
        _p2 ("p2", Float) = 7
        _ts ("time scale", Range(0,10)) = 1
        _ss ("space scale", Range(0,2)) = 1
    }
    SubShader
    {
        Pass
        {
            Name "ShadowCaster"
            Tags { "Queue"="Transparent" "LightMode"="ShadowCaster" }
            Offset 1,1
            LOD 100
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster

            #include "UnityCG.cginc"

            float _p0;
            float _p1;
            float _p2;
            float _ts;
            float _ss;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                //float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 wpos : TEXCOORD3;
                //V2F_SHADOW_CASTER;
            };

            float h12(float2 p)
            {
                return frac(sin(dot(p,float2(32.52554,45.5634)))*12432.23553);
            }

            float n12(float2 p)
            {
                float2 i = floor(p);
                float2 f = frac(p);
                f *= f * (3 - 2*f);
                return lerp(
                    lerp(h12(i+float2(0,0)),h12(i+float2(1,0)),f.x),
                    lerp(h12(i+float2(0,1)),h12(i+float2(1,1)),f.x),
                    f.y
                );
            }

            v2f vert (appdata_full v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.wpos = mul(unity_ObjectToWorld, v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                o.wpos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            // From https://www.shadertoy.com/view/MdKXDm
            float caustics(float2 p, float t)
            {
                float3 k = float3(p,t);
                float l;
                float3x3 m = float3x3(-2,-1,2,3,-2,1,1,2,2);
                float n = n12(p);
                k = mul(m, k) * .5;
                l = length(.5 - frac(k+n));
                k = mul(m, k) * .4;
                l = min(l, length(.5 - frac(k+n)));
                k = mul(m, k) * .3;
                l = min(l, length(.5 - frac(k+n)));
                return pow(l,_p2)*_p1;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);
                float3 fwpos = frac(i.wpos);
                //if(fwpos.x < .1 || fwpos.z < .1) clip(-1);
                if(h12(i.wpos.xz)*_p0 < caustics(i.wpos.xz*_ss, _Time.y*_ts)) clip(-1);
                return 0;
                //SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
