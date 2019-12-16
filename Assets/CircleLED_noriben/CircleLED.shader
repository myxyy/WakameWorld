// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:36133,y:33958,varname:node_3138,prsc:2|emission-9657-OUT,alpha-1284-OUT;n:type:ShaderForge.SFN_TexCoord,id:550,x:31938,y:33031,varname:node_550,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:7304,x:32227,y:32835,varname:node_7304,prsc:2|A-550-UVOUT,B-9503-OUT;n:type:ShaderForge.SFN_Frac,id:6440,x:32455,y:32835,varname:node_6440,prsc:2|IN-7304-OUT;n:type:ShaderForge.SFN_Step,id:3024,x:33716,y:33101,varname:node_3024,prsc:2|A-6440-OUT,B-7265-OUT;n:type:ShaderForge.SFN_Step,id:3374,x:33716,y:32894,varname:node_3374,prsc:2|A-4457-OUT,B-7265-OUT;n:type:ShaderForge.SFN_Subtract,id:4457,x:33481,y:32818,varname:node_4457,prsc:2|A-3300-OUT,B-6440-OUT;n:type:ShaderForge.SFN_Vector1,id:3300,x:33288,y:32780,varname:node_3300,prsc:2,v1:1;n:type:ShaderForge.SFN_Add,id:8890,x:33901,y:33005,varname:node_8890,prsc:2|A-3374-OUT,B-3024-OUT;n:type:ShaderForge.SFN_ComponentMask,id:8989,x:34079,y:33005,varname:node_8989,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-8890-OUT;n:type:ShaderForge.SFN_Add,id:4495,x:34296,y:33005,varname:node_4495,prsc:2|A-8989-R,B-8989-G;n:type:ShaderForge.SFN_OneMinus,id:3703,x:34471,y:33005,varname:node_3703,prsc:2|IN-4495-OUT;n:type:ShaderForge.SFN_Color,id:7309,x:34954,y:33148,ptovrint:True,ptlb:MainColor,ptin:_MainColor,varname:_MainColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:2621,x:35174,y:33353,varname:node_2621,prsc:2|A-7309-RGB,B-1558-OUT;n:type:ShaderForge.SFN_Multiply,id:8753,x:35159,y:33045,varname:node_8753,prsc:2|A-3703-OUT,B-7309-RGB;n:type:ShaderForge.SFN_Slider,id:9503,x:31795,y:33205,ptovrint:False,ptlb:Divide,ptin:_Divide,varname:_Divide,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:50.45343,max:100;n:type:ShaderForge.SFN_TexCoord,id:235,x:33924,y:33284,varname:node_235,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Hue,id:1558,x:34432,y:33284,varname:node_1558,prsc:2|IN-2907-OUT;n:type:ShaderForge.SFN_Panner,id:9746,x:34102,y:33284,varname:node_9746,prsc:2,spu:-0.2,spv:-0.2|UVIN-235-UVOUT;n:type:ShaderForge.SFN_ComponentMask,id:2907,x:34265,y:33284,varname:node_2907,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-9746-UVOUT;n:type:ShaderForge.SFN_Slider,id:8984,x:33036,y:33190,ptovrint:False,ptlb:SizeX,ptin:_SizeX,varname:_SizeX,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.2606111,max:0.49;n:type:ShaderForge.SFN_Append,id:7265,x:33430,y:33189,varname:node_7265,prsc:2|A-8984-OUT,B-7598-OUT;n:type:ShaderForge.SFN_Slider,id:7598,x:33050,y:33319,ptovrint:False,ptlb:SizeY,ptin:_SizeY,varname:_SizeY,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.2432265,max:0.49;n:type:ShaderForge.SFN_TexCoord,id:66,x:32007,y:33581,varname:node_66,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Distance,id:8498,x:32418,y:33581,varname:node_8498,prsc:2|A-7006-OUT,B-8357-OUT;n:type:ShaderForge.SFN_Vector2,id:8357,x:32233,y:33735,varname:node_8357,prsc:2,v1:0.5,v2:0.5;n:type:ShaderForge.SFN_Time,id:4762,x:31588,y:34107,varname:node_4762,prsc:2;n:type:ShaderForge.SFN_Frac,id:208,x:32140,y:34122,varname:node_208,prsc:2|IN-9279-OUT;n:type:ShaderForge.SFN_Clamp01,id:5379,x:32323,y:34122,varname:node_5379,prsc:2|IN-208-OUT;n:type:ShaderForge.SFN_Add,id:6426,x:32673,y:34125,varname:node_6426,prsc:2|A-5379-OUT,B-2253-OUT;n:type:ShaderForge.SFN_Slider,id:2253,x:32263,y:34314,ptovrint:False,ptlb:Thickness,ptin:_Thickness,varname:node_2253,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.08404932,max:1;n:type:ShaderForge.SFN_Posterize,id:7006,x:32233,y:33581,varname:node_7006,prsc:2|IN-66-UVOUT,STPS-9503-OUT;n:type:ShaderForge.SFN_Multiply,id:9657,x:35787,y:33689,varname:node_9657,prsc:2|A-9628-OUT,B-5818-OUT;n:type:ShaderForge.SFN_Multiply,id:9279,x:31978,y:34122,varname:node_9279,prsc:2|A-4762-T,B-3443-OUT;n:type:ShaderForge.SFN_Slider,id:3443,x:31639,y:34300,ptovrint:False,ptlb:Speed,ptin:_Speed,varname:node_3443,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.3969111,max:1;n:type:ShaderForge.SFN_Smoothstep,id:7575,x:33292,y:33797,varname:node_7575,prsc:2|A-796-OUT,B-3381-OUT,V-8498-OUT;n:type:ShaderForge.SFN_Smoothstep,id:9871,x:33292,y:33939,varname:node_9871,prsc:2|A-1583-OUT,B-4218-OUT,V-8498-OUT;n:type:ShaderForge.SFN_Multiply,id:988,x:33841,y:33829,varname:node_988,prsc:2|A-5673-OUT,B-9871-OUT;n:type:ShaderForge.SFN_RemapRange,id:5818,x:34257,y:33829,varname:node_5818,prsc:2,frmn:0,frmx:1,tomn:0,tomx:1|IN-5318-OUT;n:type:ShaderForge.SFN_Clamp01,id:5318,x:34027,y:33829,varname:node_5318,prsc:2|IN-988-OUT;n:type:ShaderForge.SFN_OneMinus,id:5673,x:33475,y:33797,varname:node_5673,prsc:2|IN-7575-OUT;n:type:ShaderForge.SFN_Multiply,id:796,x:32999,y:33724,varname:node_796,prsc:2|A-4239-OUT,B-5379-OUT;n:type:ShaderForge.SFN_Multiply,id:3381,x:32999,y:33855,varname:node_3381,prsc:2|A-8797-OUT,B-5379-OUT;n:type:ShaderForge.SFN_Multiply,id:1583,x:32999,y:34004,varname:node_1583,prsc:2|A-4239-OUT,B-6426-OUT;n:type:ShaderForge.SFN_Multiply,id:4218,x:32999,y:34129,varname:node_4218,prsc:2|A-8797-OUT,B-6426-OUT;n:type:ShaderForge.SFN_RemapRange,id:6438,x:34506,y:33971,varname:node_6438,prsc:2,frmn:0.3,frmx:0.4,tomn:0,tomx:1|IN-5818-OUT;n:type:ShaderForge.SFN_TexCoord,id:4531,x:34150,y:34144,varname:node_4531,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Vector2,id:2811,x:34367,y:34406,varname:node_2811,prsc:2,v1:0.5,v2:0.5;n:type:ShaderForge.SFN_Distance,id:4396,x:34594,y:34324,varname:node_4396,prsc:2|A-4112-OUT,B-2811-OUT;n:type:ShaderForge.SFN_OneMinus,id:2112,x:34785,y:34334,varname:node_2112,prsc:2|IN-4396-OUT;n:type:ShaderForge.SFN_Clamp01,id:1284,x:35769,y:33891,varname:node_1284,prsc:2|IN-6435-OUT;n:type:ShaderForge.SFN_Clamp01,id:4007,x:35155,y:34334,varname:node_4007,prsc:2|IN-7016-OUT;n:type:ShaderForge.SFN_Clamp01,id:799,x:34693,y:33971,varname:node_799,prsc:2|IN-6438-OUT;n:type:ShaderForge.SFN_Multiply,id:6435,x:35524,y:33853,varname:node_6435,prsc:2|A-3703-OUT,B-799-OUT,C-4007-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:9628,x:35464,y:33120,ptovrint:False,ptlb:Rainbow,ptin:_Rainbow,varname:node_9628,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:True|A-8753-OUT,B-2621-OUT;n:type:ShaderForge.SFN_Vector1,id:4239,x:32470,y:33798,varname:node_4239,prsc:2,v1:0.99;n:type:ShaderForge.SFN_Vector1,id:8797,x:32470,y:33870,varname:node_8797,prsc:2,v1:0.878;n:type:ShaderForge.SFN_RemapRange,id:7016,x:34974,y:34334,varname:node_7016,prsc:2,frmn:0.52,frmx:0.6,tomn:0,tomx:1|IN-2112-OUT;n:type:ShaderForge.SFN_Posterize,id:4112,x:34367,y:34260,varname:node_4112,prsc:2|IN-4531-UVOUT,STPS-9503-OUT;proporder:9628-7309-9503-8984-7598-2253-3443;pass:END;sub:END;*/

Shader "Noriben/CircleLED" {
    Properties {
        [MaterialToggle] _Rainbow ("Rainbow", Float ) = 1
        [HDR]_MainColor ("MainColor", Color) = (1,1,1,1)
        _Divide ("Divide", Range(0, 100)) = 50.45343
        _SizeX ("SizeX", Range(0, 0.49)) = 0.2606111
        _SizeY ("SizeY", Range(0, 0.49)) = 0.2432265
        _Thickness ("Thickness", Range(0, 1)) = 0.08404932
        _Speed ("Speed", Range(0, 1)) = 0.3969111
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _MainColor;
            uniform float _Divide;
            uniform float _SizeX;
            uniform float _SizeY;
            uniform float _Thickness;
            uniform float _Speed;
            uniform fixed _Rainbow;
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
////// Lighting:
////// Emissive:
                float2 node_6440 = frac((i.uv0*_Divide));
                float2 node_7265 = float2(_SizeX,_SizeY);
                float2 node_8989 = (step((1.0-node_6440),node_7265)+step(node_6440,node_7265)).rg;
                float node_3703 = (1.0 - (node_8989.r+node_8989.g));
                float4 node_1776 = _Time;
                float node_4239 = 0.99;
                float4 node_4762 = _Time;
                float node_5379 = saturate(frac((node_4762.g*_Speed)));
                float node_8797 = 0.878;
                float node_8498 = distance(floor(i.uv0 * _Divide) / (_Divide - 1),float2(0.5,0.5));
                float node_6426 = (node_5379+_Thickness);
                float node_5818 = (saturate(((1.0 - smoothstep( (node_4239*node_5379), (node_8797*node_5379), node_8498 ))*smoothstep( (node_4239*node_6426), (node_8797*node_6426), node_8498 )))*1.0+0.0);
                float3 emissive = (lerp( (node_3703*_MainColor.rgb), (_MainColor.rgb*saturate(3.0*abs(1.0-2.0*frac((i.uv0+node_1776.g*float2(-0.2,-0.2)).r+float3(0.0,-1.0/3.0,1.0/3.0)))-1)), _Rainbow )*node_5818);
                float3 finalColor = emissive;
                return fixed4(finalColor,saturate((node_3703*saturate((node_5818*10.0+-3.0))*saturate(((1.0 - distance(floor(i.uv0 * _Divide) / (_Divide - 1),float2(0.5,0.5)))*12.49999+-6.499996)))));
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
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
