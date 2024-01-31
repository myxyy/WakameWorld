Shader "myxy/PixelSand/Hourglass"
{
    Properties
    {
        [HideInInspector] _SandTex ("Texture", 2D) = "black" {}
        [HideInInspector] _InitProb ("Init Prob", Range(0,1)) = 1
        [Header(SandSetings)]
        [Space]
        _Log2Res ("Log2(Resolution)", Int) = 8
        _DefaultFPS ("Default FPS", Float) = 120
        _MaxFPS ("Default FPS", Float) = 240
        _Bottleneck ("Bottleneck width", Range(0,0.001)) = .0001
        _Amount ("Amount", Range(-1,1)) = 0.231
        _Scale ("Sand Scale", Range(0,2)) = 1
        [Header(SandColor)]
        [Space]
        _Hue ("Hue", Range(0,1)) = 0
        _HuePeriod ("Hue Period (0 to mono color)", Range(0,1)) = 0
        _HueVar ("Hue Variance", Range(0,1)) = 0.01
        _Saturation ("Saturation", Range(0,1)) = 1
        _Value ("Value", Range(0,1)) = 0.5
        _Opacity ("Opacity", Range(0,1)) = 1
        _OpacityR ("Random Opacity Min Scale", Range(0,1)) = 1
        _OpacityRandomnessExp ("RandomOpacityExp", Range(0,1)) = 0.5
        _SandLightTrans ("Sand Light Transparency", Range(0,1)) = 0.5
        [Header(Lame)]
        [Space]
        _LameDense ("Lame Density", Range(0,1)) = 0.1
        _LameRefl ("Lame Reflection", Range(0,1)) = .5
        [Header(Emission)]
        [Space]
        _UnlitF ("Emission", Range(0,10)) = 0
        _UnlitR ("Random Emission Min Scale", Range(0,1)) = 1
        _UnlitRandomnessExp("RandomEmissionExp", Range(0,1)) = 0.5
        [Header(Glass)]
        [Space]
        _Thickness ("Internal Rim Thickness", Range(0,1)) = 0.05
        _Reflection ("Cube Reflection", Range(0,1)) = 0.1
    }




    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "LightMode"="ForwardBase" }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            //#include "UnityLightingCommon.cginc"
            #include "Assets/UsamimiZakka/PixelSand/PixelSandCommon/PixelSandCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                UNITY_FOG_COORDS(0)
                float4 vertex : SV_POSITION;
                float4 opos : TEXCOORD1;

                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _SandTex;
            float4 _SandTex_ST;
            float _Reflection;
            float _Scale;
            float _Thickness;
            float _Hue;
            float _HuePeriod;
            float _HueVar;
            float _Saturation;
            float _Value;
            int _Log2Res;
            static int _RefRes = exp2(_Log2Res);
            float _LameDense;
            float _LameRefl;
            float _Amount;
            float _UnlitF;
            float _UnlitR;
            float _InitProb;
            float _Opacity;
            float _OpacityR;
            float _Bottleneck;
            float _UnlitRandomnessExp;
            float _OpacityRandomnessExp;
            float _SandLightTrans;
            float _DefaultFPS;
            float _MaxFPS;







            float3 sampleTexCube(float3 wnormal, int level)
            {
                float4 refl = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, wnormal, level);
                return DecodeHDR(refl, unity_SpecCube0_HDR);
            }

            v2f vert (appdata v)
            {
                v2f o;

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.opos = v.vertex;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float lemniscate(float2 p, float a)
            {
                float x2 = p.x*p.x;
                float y2 = p.y*p.y;
                return (x2+y2)*(x2+y2) - 2*a*a*(x2-y2); 
            }

            float2 grad_lemniscate(float2 p, float a)
            {
                return 4*p*(p.x*p.x+p.y*p.y+float2(-1,1)*a*a);
            }


            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                fixed4 col;
                float4 opos = i.opos;
                float4 ocpos = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos,1));
                float3 ordir = normalize(opos - ocpos);
                float3 oinpos = boxInnerRayCast(opos, ordir);
                float3 absoinpos = abs(oinpos);
                float3 oinfacenormal = (1 + sign(absoinpos - max(absoinpos.x, max(absoinpos.y, absoinpos.z)))) * sign(oinpos);

                float3 wpos = mul(unity_ObjectToWorld, opos).xyz;
                float3 wrdir = normalize(wpos - _WorldSpaceCameraPos);
                float3 absopos = abs(opos);
                float3 ooutfacenormal = (1 + sign(absopos - max(absopos.x, max(absopos.y, absopos.z)))) * sign(opos);
                if (dot(ooutfacenormal, oinfacenormal) == 0)
                {
                    col = float4(sampleTexCube(reflect(wrdir, UnityObjectToWorldNormal(oinfacenormal)), 0),1);
                }
                else
                {
                    col = float4(0,0,0,0);
                }

/*
                float xscale = length(unity_ObjectToWorld._m00_m10_m20);
                float yscale = length(unity_ObjectToWorld._m01_m11_m21);
                float2 scale = float2(xscale,yscale)/min(xscale,yscale) / _Scale;
*/
                static float xscaleSquare = dotself(unity_ObjectToWorld._m00_m10_m20);
                static float yscaleSquare = dotself(unity_ObjectToWorld._m01_m11_m21);
                static float2 scale = rsqrt(min(xscaleSquare,yscaleSquare)/float2(xscaleSquare,yscaleSquare)*_Scale*_Scale);

                float invodiffz = 1/(opos.z - oinpos.z);

                float2 uv = lerp(opos.xy, oinpos.xy, opos.z*invodiffz)*scale+.5;
                float2 uvf = lerp(opos.xy, oinpos.xy, (opos.z-sgn(opos.z)*_Thickness*.5)*invodiffz)*scale+.5;
                float2 uvb = lerp(opos.xy, oinpos.xy, (opos.z+sgn(opos.z)*_Thickness*.5)*invodiffz)*scale+.5;
                float rem = lemniscate(uv.yx*2-1, INVSQRT2) - _Bottleneck;
                float remf = lemniscate(uvf.yx*2-1, INVSQRT2) - _Bottleneck;
                float remb = lemniscate(uvb.yx*2-1, INVSQRT2) - _Bottleneck;
                if (remf * remb < 0)
                {
                    float3 oremnormal = normalize(float3(grad_lemniscate(uvf.yx*2-1, INVSQRT2).yx,0)) * sign(remf);
                    col = float4(sampleTexCube(reflect(wrdir, UnityObjectToWorldNormal(oremnormal)), 0),1);
                }

                static float2 size = _RefRes.xx;
                static float2 invsize = 1/size;
                float4 tex = tex2Dlod(_SandTex, float4(uv,0,0));
                uint state = tex.r%4;
                if (state == NONE)
                {
                    int2 iuv = floor(frac(uv) * size);
                    float sandAmount = iuv.y/size.y;
                    if (_Amount < 0)
                    {
                        sandAmount = 1 - sandAmount;
                    }
                    bool isSand = sandAmount < abs(_Amount) && h2s1(iuv, SEED_AMOUNT) < _InitProb;
                    tex = float4(float2(isSand?SAND:EMPTY,0)+iuv*4,isSand?1:0,1);
                    state = tex.r%4;
                }
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                if (
                    (remf * remb > 0 ^ remb > 0) &&
                    rem < 0 && (state == SAND || state == NONE)
                )
                {
                    float2 suv = state == NONE ? (floor(uv*size)+.5)*invsize : ((int2)(tex.xy*.25)+.5)*invsize;
                    float huePeriod = _HuePeriod == 0 ? 65536 : _HuePeriod;
                    float hueVar = (h2s1(suv,.72356) - .5) * _HueVar;
                    float4 sandcol = float4(hsv2rgb(_Hue + suv.y/huePeriod + hueVar, _Saturation, _Value),1);
                    col = sandcol;
                    col.a *= lerp(_Opacity * _OpacityR, _Opacity, pow(h2s1(suv,.7635), 1/_OpacityRandomnessExp-1));

                    float3 osfacenormal = float3(0,0,-sgn(ordir.z));
                    float3 wsfacenormal = UnityObjectToWorldNormal(osfacenormal);

                    float3 lightByDir = dotself(dot(lightDir, wsfacenormal)*.5+.5) * _LightColor0;
                    float3 lightByDirBack = dotself(dot(lightDir, -wsfacenormal)*.5+.5) * _LightColor0;

                    float3 lightByPrb = ShadeSH9(float4(wsfacenormal,1));
                    float3 lightByPrbBack = ShadeSH9(float4(-wsfacenormal,1));

                    float emitVal = lerp(_UnlitF * _UnlitR, _UnlitF, pow(h2s1(suv,.6245), 1/_UnlitRandomnessExp-1));
                    col.rgb *= lightByDir + lightByPrb + (lightByDirBack + lightByPrbBack)*_SandLightTrans + (exp2(emitVal)-1);

                    float3 lamenormal = normalize(float3(h2s1(suv,.46236)*2-1, h2s1(suv,.4236)*2-1, -sgn(ordir.z)*.01));
                    float3 lameref = sampleTexCube(reflect(-wrdir, UnityObjectToWorldNormal(lamenormal)), 0);
                    col.rgb += lameref * (h2s1(suv,.342) < _LameDense ? _LameRefl : 0);

                }
                float3 woutfacenormal = UnityObjectToWorldNormal(ooutfacenormal);
                float4 refrectColor = float4(sampleTexCube(reflect(wrdir, woutfacenormal), 0),1);

                float3 light = saturate(dot(reflect(-normalize(lightDir), woutfacenormal), -wrdir)) * _LightColor0;
                refrectColor.rgb += light;
                col = lerp(col, refrectColor, _Reflection);
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
