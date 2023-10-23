Shader "WakameIsland/Star"
{
    Properties
    {
        _p0 ("param0", Range(0,0.1)) = 0.04
        _p1 ("param1", Float) = 0.1
        _p2 ("param0", Range(0,10)) = 3
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

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
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            float _p0;
            float _p1;
            float _p2;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = i.color;
                float2 p = i.uv * 2 - 1;
                p = abs(p);
                p += _p0;
                col.a *= pow(_p1/(p.x*p.y),_p2);
                return col;
            }
            ENDCG
        }
    }
}
