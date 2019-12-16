// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:35790,y:33194,varname:node_3138,prsc:2|emission-2621-OUT,clip-3703-OUT;n:type:ShaderForge.SFN_TexCoord,id:550,x:31938,y:33031,varname:node_550,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:7304,x:32227,y:32835,varname:node_7304,prsc:2|A-550-UVOUT,B-9503-OUT;n:type:ShaderForge.SFN_Frac,id:6440,x:32455,y:32835,varname:node_6440,prsc:2|IN-7304-OUT;n:type:ShaderForge.SFN_Step,id:3024,x:33716,y:33101,varname:node_3024,prsc:2|A-6440-OUT,B-7265-OUT;n:type:ShaderForge.SFN_Step,id:3374,x:33716,y:32894,varname:node_3374,prsc:2|A-4457-OUT,B-7265-OUT;n:type:ShaderForge.SFN_Subtract,id:4457,x:33481,y:32818,varname:node_4457,prsc:2|A-3300-OUT,B-6440-OUT;n:type:ShaderForge.SFN_Vector1,id:3300,x:33288,y:32780,varname:node_3300,prsc:2,v1:1;n:type:ShaderForge.SFN_Add,id:8890,x:33901,y:33005,varname:node_8890,prsc:2|A-3374-OUT,B-3024-OUT;n:type:ShaderForge.SFN_ComponentMask,id:8989,x:34079,y:33005,varname:node_8989,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-8890-OUT;n:type:ShaderForge.SFN_Add,id:4495,x:34296,y:33005,varname:node_4495,prsc:2|A-8989-R,B-8989-G;n:type:ShaderForge.SFN_OneMinus,id:3703,x:34471,y:33005,varname:node_3703,prsc:2|IN-4495-OUT;n:type:ShaderForge.SFN_Posterize,id:4099,x:33633,y:33633,varname:node_4099,prsc:2|IN-550-UVOUT,STPS-9503-OUT;n:type:ShaderForge.SFN_ComponentMask,id:1395,x:34137,y:33510,varname:node_1395,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-4099-OUT;n:type:ShaderForge.SFN_Subtract,id:8879,x:34388,y:33569,varname:node_8879,prsc:2|A-1395-OUT,B-2165-OUT;n:type:ShaderForge.SFN_Time,id:1764,x:33928,y:33670,varname:node_1764,prsc:2;n:type:ShaderForge.SFN_Frac,id:4838,x:34817,y:33690,varname:node_4838,prsc:2|IN-6240-OUT;n:type:ShaderForge.SFN_Color,id:7309,x:34499,y:34284,ptovrint:True,ptlb:MainColor,ptin:_MainColor,varname:_MainColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:2621,x:35416,y:33117,varname:node_2621,prsc:2|A-3703-OUT,B-1888-OUT;n:type:ShaderForge.SFN_Slider,id:9503,x:31825,y:33203,ptovrint:False,ptlb:Divide,ptin:_Divide,varname:_Divide,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:6.493421,max:128;n:type:ShaderForge.SFN_TexCoord,id:235,x:33991,y:34486,varname:node_235,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Hue,id:1558,x:34499,y:34486,varname:node_1558,prsc:2|IN-2907-OUT;n:type:ShaderForge.SFN_Panner,id:9746,x:34169,y:34486,varname:node_9746,prsc:2,spu:-0.2,spv:-0.2|UVIN-235-UVOUT;n:type:ShaderForge.SFN_ComponentMask,id:2907,x:34332,y:34486,varname:node_2907,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-9746-UVOUT;n:type:ShaderForge.SFN_Slider,id:8984,x:33036,y:33190,ptovrint:False,ptlb:SizeX,ptin:_SizeX,varname:_SizeX,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.2394897,max:0.5;n:type:ShaderForge.SFN_Append,id:7265,x:33430,y:33189,varname:node_7265,prsc:2|A-8984-OUT,B-7598-OUT;n:type:ShaderForge.SFN_Slider,id:7598,x:33050,y:33319,ptovrint:False,ptlb:SizeY,ptin:_SizeY,varname:_SizeY,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.2121264,max:0.5;n:type:ShaderForge.SFN_Multiply,id:1888,x:35184,y:33810,varname:node_1888,prsc:2|A-4838-OUT,B-784-OUT;n:type:ShaderForge.SFN_Noise,id:7609,x:34073,y:33977,varname:node_7609,prsc:2|XY-9501-OUT;n:type:ShaderForge.SFN_Add,id:6240,x:34647,y:33690,varname:node_6240,prsc:2|A-8879-OUT,B-7471-OUT;n:type:ShaderForge.SFN_ComponentMask,id:9501,x:33903,y:33977,varname:node_9501,prsc:2,cc1:1,cc2:1,cc3:-1,cc4:-1|IN-4099-OUT;n:type:ShaderForge.SFN_Multiply,id:7471,x:34253,y:33977,varname:node_7471,prsc:2|A-7609-OUT,B-6747-OUT;n:type:ShaderForge.SFN_Slider,id:6747,x:33903,y:34213,ptovrint:False,ptlb:Noise,ptin:_Noise,varname:_Noise,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_SwitchProperty,id:784,x:34986,y:34292,ptovrint:False,ptlb:Rainbow,ptin:_Rainbow,varname:node_784,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:True|A-7309-RGB,B-4776-OUT;n:type:ShaderForge.SFN_Multiply,id:4776,x:34757,y:34375,varname:node_4776,prsc:2|A-7309-RGB,B-1558-OUT;n:type:ShaderForge.SFN_Multiply,id:2165,x:34189,y:33687,varname:node_2165,prsc:2|A-1764-T,B-4987-OUT;n:type:ShaderForge.SFN_Slider,id:4987,x:33861,y:33822,ptovrint:False,ptlb:Speed,ptin:_Speed,varname:node_4987,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1.030514,max:3;proporder:784-7309-9503-8984-7598-6747-4987;pass:END;sub:END;*/

Shader "Noriben/FlowLED" {
    Properties {
        [MaterialToggle] _Rainbow ("Rainbow", Float ) = 1
        [HDR]_MainColor ("MainColor", Color) = (1,1,1,1)
        _Divide ("Divide", Range(0, 128)) = 6.493421
        _SizeX ("SizeX", Range(0, 0.5)) = 0.2394897
        _SizeY ("SizeY", Range(0, 0.5)) = 0.2121264
        _Noise ("Noise", Range(0, 1)) = 0
        _Speed ("Speed", Range(0, 3)) = 1.030514
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _MainColor;
            uniform float _Divide;
            uniform float _SizeX;
            uniform float _SizeY;
            uniform float _Noise;
            uniform fixed _Rainbow;
            uniform float _Speed;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float2 node_6440 = frac((i.uv0*_Divide));
                float2 node_7265 = float2(_SizeX,_SizeY);
                float2 node_8989 = (step((1.0-node_6440),node_7265)+step(node_6440,node_7265)).rg;
                float node_3703 = (1.0 - (node_8989.r+node_8989.g));
                clip(node_3703 - 0.5);
////// Lighting:
////// Emissive:
                float2 node_4099 = floor(i.uv0 * _Divide) / (_Divide - 1);
                float4 node_1764 = _Time;
                float2 node_9501 = node_4099.gg;
                float2 node_7609_skew = node_9501 + 0.2127+node_9501.x*0.3713*node_9501.y;
                float2 node_7609_rnd = 4.789*sin(489.123*(node_7609_skew));
                float node_7609 = frac(node_7609_rnd.x*node_7609_rnd.y*(1+node_7609_skew.x));
                float4 node_9876 = _Time;
                float3 emissive = (node_3703*(frac(((node_4099.r-(node_1764.g*_Speed))+(node_7609*_Noise)))*lerp( _MainColor.rgb, (_MainColor.rgb*saturate(3.0*abs(1.0-2.0*frac((i.uv0+node_9876.g*float2(-0.2,-0.2)).r+float3(0.0,-1.0/3.0,1.0/3.0)))-1)), _Rainbow )));
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _Divide;
            uniform float _SizeX;
            uniform float _SizeY;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float2 node_6440 = frac((i.uv0*_Divide));
                float2 node_7265 = float2(_SizeX,_SizeY);
                float2 node_8989 = (step((1.0-node_6440),node_7265)+step(node_6440,node_7265)).rg;
                float node_3703 = (1.0 - (node_8989.r+node_8989.g));
                clip(node_3703 - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
