// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:34447,y:32349,varname:node_4795,prsc:2|emission-1178-OUT;n:type:ShaderForge.SFN_TexCoord,id:444,x:31389,y:33215,varname:node_444,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Vector2,id:9393,x:31399,y:33382,varname:node_9393,prsc:2,v1:0.5,v2:0.5;n:type:ShaderForge.SFN_Distance,id:4281,x:31672,y:33234,varname:node_4281,prsc:2|A-444-V,B-9393-OUT;n:type:ShaderForge.SFN_RemapRange,id:9699,x:31840,y:33234,varname:node_9699,prsc:2,frmn:0,frmx:0.5,tomn:0.5,tomx:1|IN-4281-OUT;n:type:ShaderForge.SFN_OneMinus,id:7155,x:32012,y:33234,varname:node_7155,prsc:2|IN-9699-OUT;n:type:ShaderForge.SFN_Clamp01,id:9414,x:32189,y:33234,varname:node_9414,prsc:2|IN-7155-OUT;n:type:ShaderForge.SFN_TexCoord,id:5992,x:31692,y:32324,varname:node_5992,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Vector2,id:7613,x:31702,y:32491,varname:node_7613,prsc:2,v1:0.5,v2:0.5;n:type:ShaderForge.SFN_Distance,id:9714,x:31975,y:32343,varname:node_9714,prsc:2|A-5992-V,B-7613-OUT;n:type:ShaderForge.SFN_RemapRange,id:429,x:32143,y:32343,varname:node_429,prsc:2,frmn:0.03,frmx:0.05,tomn:0,tomx:1|IN-9714-OUT;n:type:ShaderForge.SFN_OneMinus,id:1704,x:32303,y:32343,varname:node_1704,prsc:2|IN-429-OUT;n:type:ShaderForge.SFN_VertexColor,id:6428,x:33264,y:32631,varname:node_6428,prsc:2;n:type:ShaderForge.SFN_Clamp01,id:4931,x:32476,y:32343,varname:node_4931,prsc:2|IN-1704-OUT;n:type:ShaderForge.SFN_Blend,id:3598,x:32646,y:32262,varname:node_3598,prsc:2,blmd:1,clmp:False|SRC-7514-RGB,DST-4931-OUT;n:type:ShaderForge.SFN_Color,id:7514,x:32431,y:32109,ptovrint:False,ptlb:MainColor,ptin:_MainColor,varname:node_7514,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Blend,id:1870,x:32691,y:33036,varname:node_1870,prsc:2,blmd:1,clmp:False|SRC-1004-RGB,DST-855-OUT;n:type:ShaderForge.SFN_Color,id:1004,x:32349,y:33016,ptovrint:False,ptlb:BloomColor,ptin:_BloomColor,varname:node_1004,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5367647,c2:0.5367647,c3:0.5367647,c4:1;n:type:ShaderForge.SFN_Blend,id:7350,x:33506,y:32438,varname:node_7350,prsc:2,blmd:12,clmp:False|SRC-3657-OUT,DST-6428-RGB;n:type:ShaderForge.SFN_Blend,id:3657,x:33264,y:32438,varname:node_3657,prsc:2,blmd:8,clmp:False|SRC-406-OUT,DST-1870-OUT;n:type:ShaderForge.SFN_TexCoord,id:5289,x:31402,y:32718,varname:node_5289,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Vector2,id:1475,x:31412,y:32885,varname:node_1475,prsc:2,v1:0.5,v2:0.5;n:type:ShaderForge.SFN_Distance,id:4497,x:31685,y:32737,varname:node_4497,prsc:2|A-5289-V,B-1475-OUT;n:type:ShaderForge.SFN_RemapRange,id:6202,x:31853,y:32737,varname:node_6202,prsc:2,frmn:0,frmx:0.1,tomn:0,tomx:1|IN-4497-OUT;n:type:ShaderForge.SFN_OneMinus,id:442,x:32025,y:32737,varname:node_442,prsc:2|IN-6202-OUT;n:type:ShaderForge.SFN_Clamp01,id:99,x:32202,y:32737,varname:node_99,prsc:2|IN-442-OUT;n:type:ShaderForge.SFN_Color,id:3919,x:32440,y:32571,ptovrint:False,ptlb:SecondColor,ptin:_SecondColor,varname:_BloomColor_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.4926471,c2:0.4926471,c3:0.4926471,c4:1;n:type:ShaderForge.SFN_Blend,id:4828,x:32677,y:32701,varname:node_4828,prsc:2,blmd:1,clmp:False|SRC-3919-RGB,DST-99-OUT;n:type:ShaderForge.SFN_Blend,id:406,x:32980,y:32343,varname:node_406,prsc:2,blmd:8,clmp:False|SRC-3598-OUT,DST-4828-OUT;n:type:ShaderForge.SFN_Clamp01,id:6527,x:33710,y:32438,varname:node_6527,prsc:2|IN-7350-OUT;n:type:ShaderForge.SFN_Multiply,id:855,x:32429,y:33284,varname:node_855,prsc:2|A-9414-OUT,B-4450-OUT;n:type:ShaderForge.SFN_Time,id:7161,x:31410,y:33479,varname:node_7161,prsc:2;n:type:ShaderForge.SFN_Sin,id:9998,x:32042,y:33492,varname:node_9998,prsc:2|IN-2331-OUT;n:type:ShaderForge.SFN_Multiply,id:2331,x:31870,y:33492,varname:node_2331,prsc:2|A-7161-T,B-2647-OUT;n:type:ShaderForge.SFN_Slider,id:2647,x:31410,y:33693,ptovrint:False,ptlb:TimeScale,ptin:_TimeScale,varname:node_2647,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:100;n:type:ShaderForge.SFN_RemapRange,id:4450,x:32231,y:33492,varname:node_4450,prsc:2,frmn:0,frmx:1,tomn:0.8,tomx:1|IN-9998-OUT;n:type:ShaderForge.SFN_Add,id:6689,x:33931,y:32325,varname:node_6689,prsc:2|A-406-OUT,B-6527-OUT;n:type:ShaderForge.SFN_Multiply,id:1178,x:34192,y:32443,varname:node_1178,prsc:2|A-6689-OUT,B-6428-RGB;proporder:7514-3919-1004-2647;pass:END;sub:END;*/

Shader "Shader Forge/BloomTrail" {
    Properties {
        _MainColor ("MainColor", Color) = (1,1,1,1)
        _SecondColor ("SecondColor", Color) = (0.4926471,0.4926471,0.4926471,1)
        _BloomColor ("BloomColor", Color) = (0.5367647,0.5367647,0.5367647,1)
        _TimeScale ("TimeScale", Range(0, 100)) = 1
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
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _MainColor;
            uniform float4 _BloomColor;
            uniform float4 _SecondColor;
            uniform float _TimeScale;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float3 node_406 = ((_MainColor.rgb*saturate((1.0 - (distance(i.uv0.g,float2(0.5,0.5))*50.0+-1.5))))+(_SecondColor.rgb*saturate((1.0 - (distance(i.uv0.g,float2(0.5,0.5))*10.0+0.0)))));
                float4 node_7161 = _Time;
                float3 emissive = ((node_406+saturate(((node_406+(_BloomColor.rgb*(saturate((1.0 - (distance(i.uv0.g,float2(0.5,0.5))*1.0+0.5)))*(sin((node_7161.g*_TimeScale))*0.2+0.8)))) > 0.5 ?  (1.0-(1.0-2.0*((node_406+(_BloomColor.rgb*(saturate((1.0 - (distance(i.uv0.g,float2(0.5,0.5))*1.0+0.5)))*(sin((node_7161.g*_TimeScale))*0.2+0.8))))-0.5))*(1.0-i.vertexColor.rgb)) : (2.0*(node_406+(_BloomColor.rgb*(saturate((1.0 - (distance(i.uv0.g,float2(0.5,0.5))*1.0+0.5)))*(sin((node_7161.g*_TimeScale))*0.2+0.8))))*i.vertexColor.rgb)) ))*i.vertexColor.rgb);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,1));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
