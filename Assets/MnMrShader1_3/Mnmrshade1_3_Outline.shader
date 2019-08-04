// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:3,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:34359,y:32398,varname:node_4013,prsc:2|normal-3574-RGB,custl-3460-OUT,olwid-3712-OUT,olcol-537-RGB;n:type:ShaderForge.SFN_Color,id:1304,x:32165,y:33247,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:1925,x:32165,y:33061,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_1925,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:3574,x:33849,y:32264,ptovrint:False,ptlb:NormalTex,ptin:_NormalTex,varname:node_3574,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_ValueProperty,id:312,x:33720,y:33593,ptovrint:False,ptlb:Outline_width,ptin:_Outline_width,varname:node_312,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Color,id:537,x:33899,y:33053,ptovrint:False,ptlb:Outline_color,ptin:_Outline_color,varname:node_537,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_NormalVector,id:5138,x:31187,y:32563,prsc:2,pt:True;n:type:ShaderForge.SFN_Transform,id:6197,x:31513,y:32569,varname:node_6197,prsc:2,tffrom:0,tfto:3|IN-5138-OUT;n:type:ShaderForge.SFN_ComponentMask,id:3277,x:31675,y:32569,varname:node_3277,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-6197-XYZ;n:type:ShaderForge.SFN_RemapRange,id:3332,x:31830,y:32569,varname:node_3332,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-3277-OUT;n:type:ShaderForge.SFN_Tex2d,id:788,x:32165,y:32835,ptovrint:False,ptlb:ShadowMatcapTex,ptin:_ShadowMatcapTex,varname:node_788,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-3332-OUT;n:type:ShaderForge.SFN_LightColor,id:6424,x:32067,y:31080,varname:node_6424,prsc:2;n:type:ShaderForge.SFN_LightAttenuation,id:9581,x:32205,y:31107,varname:node_9581,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8994,x:32349,y:31073,varname:node_8994,prsc:2|A-6424-RGB,B-9581-OUT;n:type:ShaderForge.SFN_Multiply,id:868,x:32351,y:33101,varname:node_868,prsc:2|A-1925-RGB,B-1304-RGB;n:type:ShaderForge.SFN_Add,id:3315,x:32614,y:31345,varname:node_3315,prsc:2|A-8994-OUT,B-9923-OUT,C-8882-OUT;n:type:ShaderForge.SFN_ViewPosition,id:6214,x:31376,y:31374,varname:node_6214,prsc:2;n:type:ShaderForge.SFN_ObjectPosition,id:7444,x:31377,y:31493,varname:node_7444,prsc:2;n:type:ShaderForge.SFN_Subtract,id:1103,x:31561,y:31427,varname:node_1103,prsc:2|A-6214-XYZ,B-7444-XYZ;n:type:ShaderForge.SFN_Normalize,id:6237,x:31716,y:31427,varname:node_6237,prsc:2|IN-1103-OUT;n:type:ShaderForge.SFN_Vector3,id:9569,x:31716,y:31259,varname:node_9569,prsc:2,v1:0,v2:1,v3:0;n:type:ShaderForge.SFN_Code,id:8882,x:31875,y:31417,varname:node_8882,prsc:2,code:ZgBsAG8AYQB0ADQAIAB2AGEAbAAgAD0AIABVAE4ASQBUAFkAXwBTAEEATQBQAEwARQBfAFQARQBYAEMAVQBCAEUAXwBMAE8ARAAoAHUAbgBpAHQAeQBfAFMAcABlAGMAQwB1AGIAZQAwACwAIAByAGUAZgBsAFYAZQBjAHQALAAgADcAKQA7AAoAZgBsAG8AYQB0ADMAIAByAGUAZgBsAEMAbwBsACAAPQAgAEQAZQBjAG8AZABlAEgARABSACgAdgBhAGwALAAgAHUAbgBpAHQAeQBfAFMAcABlAGMAQwB1AGIAZQAwAF8ASABEAFIAKQA7AAoAcgBlAHQAdQByAG4AIAByAGUAZgBsAEMAbwBsACAAKgAgADAALgAwADIAOwA=,output:2,fname:Function_node_8882,width:684,height:256,input:2,input_1_label:reflVect|A-6237-OUT;n:type:ShaderForge.SFN_Code,id:9923,x:31875,y:31256,varname:node_9923,prsc:2,code:cgBlAHQAdQByAG4AIABTAGgAYQBkAGUAUwBIADkAKABoAGEAbABmADQAKABuAG8AcgBtAGEAbAAsACAAMQAuADAAKQApADsACgAKAA==,output:2,fname:Function_node_9923,width:429,height:132,input:2,input_1_label:normal|A-9569-OUT;n:type:ShaderForge.SFN_Clamp01,id:7533,x:32789,y:31345,varname:node_7533,prsc:2|IN-3315-OUT;n:type:ShaderForge.SFN_Tex2d,id:3295,x:32165,y:32439,ptovrint:False,ptlb:LightMatcapTex,ptin:_LightMatcapTex,varname:node_3295,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-3332-OUT;n:type:ShaderForge.SFN_Multiply,id:9823,x:32706,y:32896,varname:node_9823,prsc:2|A-3900-OUT,B-868-OUT;n:type:ShaderForge.SFN_Multiply,id:5046,x:33895,y:33520,varname:node_5046,prsc:2|A-8850-OUT,B-312-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8850,x:33720,y:33520,ptovrint:False,ptlb:線幅調整用,ptin:_,varname:node_8850,prsc:2,glob:False,taghide:True,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.0001;n:type:ShaderForge.SFN_Blend,id:2095,x:32952,y:32663,varname:node_2095,prsc:2,blmd:6,clmp:True|SRC-2479-OUT,DST-9823-OUT;n:type:ShaderForge.SFN_Blend,id:3618,x:32351,y:32870,varname:node_3618,prsc:2,blmd:10,clmp:True|SRC-2391-RGB,DST-788-RGB;n:type:ShaderForge.SFN_Color,id:2391,x:32165,y:32680,ptovrint:False,ptlb:ShadowMatcapColor,ptin:_ShadowMatcapColor,varname:node_2391,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:2479,x:32732,y:32414,varname:node_2479,prsc:2|A-9988-RGB,B-3295-RGB,C-41-OUT;n:type:ShaderForge.SFN_Color,id:9988,x:32165,y:32276,ptovrint:False,ptlb:LightMatcapColor,ptin:_LightMatcapColor,varname:node_9988,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Lerp,id:3460,x:33460,y:32736,varname:node_3460,prsc:2|A-7091-OUT,B-868-OUT,T-481-OUT;n:type:ShaderForge.SFN_Tex2d,id:5196,x:32984,y:32960,ptovrint:False,ptlb:EmissionMap,ptin:_EmissionMap,varname:node_5196,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Slider,id:5819,x:32919,y:33174,ptovrint:False,ptlb:EmissionPower,ptin:_EmissionPower,varname:node_5819,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Multiply,id:481,x:33240,y:33017,varname:node_481,prsc:2|A-5196-RGB,B-5819-OUT;n:type:ShaderForge.SFN_Tex2d,id:3896,x:33537,y:33269,ptovrint:False,ptlb:Outline_Mask,ptin:_Outline_Mask,varname:node_3896,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Multiply,id:3712,x:34016,y:33219,varname:node_3712,prsc:2|A-2247-OUT,B-5046-OUT;n:type:ShaderForge.SFN_OneMinus,id:2247,x:33720,y:33286,varname:node_2247,prsc:2|IN-3896-RGB;n:type:ShaderForge.SFN_Tex2d,id:3007,x:32351,y:32516,ptovrint:False,ptlb:LightMatcapMaskTex,ptin:_LightMatcapMaskTex,varname:node_3007,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_OneMinus,id:41,x:32526,y:32516,varname:node_41,prsc:2|IN-3007-RGB;n:type:ShaderForge.SFN_Blend,id:3900,x:32531,y:32786,varname:node_3900,prsc:2,blmd:6,clmp:True|SRC-5519-RGB,DST-3618-OUT;n:type:ShaderForge.SFN_Tex2d,id:5519,x:32351,y:32716,ptovrint:False,ptlb:ShadowMatcapMaskTex,ptin:_ShadowMatcapMaskTex,varname:node_5519,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Multiply,id:7091,x:33218,y:32500,varname:node_7091,prsc:2|A-7533-OUT,B-9234-OUT;n:type:ShaderForge.SFN_Color,id:5641,x:32167,y:31926,ptovrint:False,ptlb:LightMatcap2Color,ptin:_LightMatcap2Color,varname:_LightMatcapColor_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Tex2d,id:2142,x:32167,y:32089,ptovrint:False,ptlb:LightMatcap2Tex,ptin:_LightMatcap2Tex,varname:_LightMatcapTex_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-3332-OUT;n:type:ShaderForge.SFN_Multiply,id:4797,x:32734,y:32064,varname:node_4797,prsc:2|A-5641-RGB,B-2142-RGB;n:type:ShaderForge.SFN_Blend,id:9234,x:33094,y:32577,varname:node_9234,prsc:2,blmd:6,clmp:True|SRC-4797-OUT,DST-2095-OUT;proporder:1304-1925-3574-2391-788-5519-9988-3295-3007-5641-2142-537-312-3896-8850-5819-5196;pass:END;sub:END;*/

Shader "MMS/Mnmrshader1_3_Outline" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _NormalTex ("NormalTex", 2D) = "bump" {}
        _ShadowMatcapColor ("ShadowMatcapColor", Color) = (1,1,1,1)
        _ShadowMatcapTex ("ShadowMatcapTex", 2D) = "white" {}
        _ShadowMatcapMaskTex ("ShadowMatcapMaskTex", 2D) = "black" {}
        _LightMatcapColor ("LightMatcapColor", Color) = (0,0,0,1)
        _LightMatcapTex ("LightMatcapTex", 2D) = "black" {}
        _LightMatcapMaskTex ("LightMatcapMaskTex", 2D) = "black" {}
        _LightMatcap2Color ("LightMatcap2Color", Color) = (0,0,0,1)
        _LightMatcap2Tex ("LightMatcap2Tex", 2D) = "black" {}
        _Outline_color ("Outline_color", Color) = (0,0,0,1)
		_Outline_Tex ("Outline_Tex", 2D) = "white" {}
        _Outline_width ("Outline_width", Float ) = 0
        _Outline_Mask ("Outline_Mask", 2D) = "black" {}
        [HideInInspector]_ ("線幅調整用", Float ) = 0.0001
        _EmissionPower ("EmissionPower", Range(0, 1)) = 0
        _EmissionMap ("EmissionMap", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "RenderType"="Opaque"
        }
 Pass {
            Name "Outline"
            Tags {
			"LightMode"="ForwardBase"
            }
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_fwdbase
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _Outline_width;
            uniform float4 _Outline_color;
            float3 Function_node_8882( float3 reflVect ){
            float4 val = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflVect, 7);
            float3 reflCol = DecodeHDR(val, unity_SpecCube0_HDR);
            return reflCol * 0.02;
            }
            
            float3 Function_node_9923( float3 normal ){
            return ShadeSH9(half4(normal, 1.0));
            
            
            }
            
            uniform float _;
            uniform sampler2D _Outline_Mask; uniform float4 _Outline_Mask_ST;
            uniform sampler2D _Outline_Tex; uniform float4 _Outline_Tex_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
				float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
				float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 lightColor = _LightColor0.rgb;
                float4 _Outline_Mask_var = tex2Dlod(_Outline_Mask,float4(TRANSFORM_TEX(o.uv0, _Outline_Mask),0.0,0));
                o.pos = UnityObjectToClipPos( float4(v.vertex.xyz + v.normal*((1.0 - _Outline_Mask_var.rgb)*(_*_Outline_width)),1) );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
				float4 _Outline_Tex_var = tex2D(_Outline_Tex,TRANSFORM_TEX(i.uv0, _Outline_Tex));
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 lightColor = _LightColor0.rgb;
				float attenuation = 1;
                float3 node_7533 = saturate(((_LightColor0.rgb*attenuation)+Function_node_9923( float3(0,1,0) )+Function_node_8882( normalize((_WorldSpaceCameraPos-objPos.rgb)) )));
                return fixed4((node_7533*_Outline_color.rgb*_Outline_Tex_var.rgb),0);
            }
            ENDCG
        }
		        Pass {
            Name "Outline_DELTA"
            Tags {
			"LightMode"="ForwardAdd"
            }
			Blend One One
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
			#include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_fwdadd
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _Outline_width;
            uniform float4 _Outline_color;
            float3 Function_node_8882( float3 reflVect ){
            float4 val = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflVect, 7);
            float3 reflCol = DecodeHDR(val, unity_SpecCube0_HDR);
            return reflCol * 0.02;
            }
            
            float3 Function_node_9923( float3 normal ){
            return ShadeSH9(half4(normal, 1.0));
            
            
            }
            
            uniform float _;
            uniform sampler2D _Outline_Mask; uniform float4 _Outline_Mask_ST;
            uniform sampler2D _Outline_Tex; uniform float4 _Outline_Tex_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
				float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
				 float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
				LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 lightColor = _LightColor0.rgb;
                float4 _Outline_Mask_var = tex2Dlod(_Outline_Mask,float4(TRANSFORM_TEX(o.uv0, _Outline_Mask),0.0,0));
                o.pos = UnityObjectToClipPos( float4(v.vertex.xyz + v.normal*((1.0 - _Outline_Mask_var.rgb)*(_*_Outline_width)),1) );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
				float4 _Outline_Tex_var = tex2D(_Outline_Tex,TRANSFORM_TEX(i.uv0, _Outline_Tex));
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 lightColor = _LightColor0.rgb;
				float attenuation = LIGHT_ATTENUATION(i);
                float3 node_7533 = saturate(((_LightColor0.rgb*attenuation)+Function_node_9923( float3(0,1,0) )+Function_node_8882( normalize((_WorldSpaceCameraPos-objPos.rgb)) )));
                return fixed4((node_7533*_Outline_color.rgb*_Outline_Tex_var.rgb),0);
            }
            ENDCG
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
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _NormalTex; uniform float4 _NormalTex_ST;
            uniform sampler2D _ShadowMatcapTex; uniform float4 _ShadowMatcapTex_ST;
            float3 Function_node_8882( float3 reflVect ){
            float4 val = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflVect, 7);
            float3 reflCol = DecodeHDR(val, unity_SpecCube0_HDR);
            return reflCol * 0.02;
            }
            
            float3 Function_node_9923( float3 normal ){
            return ShadeSH9(half4(normal, 1.0));
            
            
            }
            
            uniform sampler2D _LightMatcapTex; uniform float4 _LightMatcapTex_ST;
            uniform float4 _ShadowMatcapColor;
            uniform float4 _LightMatcapColor;
            uniform sampler2D _EmissionMap; uniform float4 _EmissionMap_ST;
            uniform float _EmissionPower;
            uniform sampler2D _LightMatcapMaskTex; uniform float4 _LightMatcapMaskTex_ST;
            uniform sampler2D _ShadowMatcapMaskTex; uniform float4 _ShadowMatcapMaskTex_ST;
            uniform float4 _LightMatcap2Color;
            uniform sampler2D _LightMatcap2Tex; uniform float4 _LightMatcap2Tex_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalTex_var = UnpackNormal(tex2D(_NormalTex,TRANSFORM_TEX(i.uv0, _NormalTex)));
                float3 normalLocal = _NormalTex_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = 1;
                float2 node_3332 = (mul( UNITY_MATRIX_V, float4(normalDirection,0) ).xyz.rgb.rg*0.5+0.5);
                float4 _LightMatcap2Tex_var = tex2D(_LightMatcap2Tex,TRANSFORM_TEX(node_3332, _LightMatcap2Tex));
                float4 _LightMatcapTex_var = tex2D(_LightMatcapTex,TRANSFORM_TEX(node_3332, _LightMatcapTex));
                float4 _LightMatcapMaskTex_var = tex2D(_LightMatcapMaskTex,TRANSFORM_TEX(i.uv0, _LightMatcapMaskTex));
                float4 _ShadowMatcapMaskTex_var = tex2D(_ShadowMatcapMaskTex,TRANSFORM_TEX(i.uv0, _ShadowMatcapMaskTex));
                float4 _ShadowMatcapTex_var = tex2D(_ShadowMatcapTex,TRANSFORM_TEX(node_3332, _ShadowMatcapTex));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 node_868 = (_MainTex_var.rgb*_Color.rgb);
                float4 _EmissionMap_var = tex2D(_EmissionMap,TRANSFORM_TEX(i.uv0, _EmissionMap));
                float3 finalColor = lerp((saturate(((_LightColor0.rgb*attenuation)+Function_node_9923( float3(0,1,0) )+Function_node_8882( normalize((_WorldSpaceCameraPos-objPos.rgb)) )))*saturate((1.0-(1.0-(_LightMatcap2Color.rgb*_LightMatcap2Tex_var.rgb))*(1.0-saturate((1.0-(1.0-(_LightMatcapColor.rgb*_LightMatcapTex_var.rgb*(1.0 - _LightMatcapMaskTex_var.rgb)))*(1.0-(saturate((1.0-(1.0-_ShadowMatcapMaskTex_var.rgb)*(1.0-saturate(( _ShadowMatcapTex_var.rgb > 0.5 ? (1.0-(1.0-2.0*(_ShadowMatcapTex_var.rgb-0.5))*(1.0-_ShadowMatcapColor.rgb)) : (2.0*_ShadowMatcapTex_var.rgb*_ShadowMatcapColor.rgb) )))))*node_868)))))))),node_868,(_EmissionMap_var.rgb*_EmissionPower));
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdadd
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _NormalTex; uniform float4 _NormalTex_ST;
            uniform sampler2D _ShadowMatcapTex; uniform float4 _ShadowMatcapTex_ST;
            float3 Function_node_8882( float3 reflVect ){
            float4 val = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflVect, 7);
            float3 reflCol = DecodeHDR(val, unity_SpecCube0_HDR);
            return reflCol * 0.02;
            }
            
            float3 Function_node_9923( float3 normal ){
            return ShadeSH9(half4(normal, 1.0));
            
            
            }
            
            uniform sampler2D _LightMatcapTex; uniform float4 _LightMatcapTex_ST;
            uniform float4 _ShadowMatcapColor;
            uniform float4 _LightMatcapColor;
            uniform sampler2D _EmissionMap; uniform float4 _EmissionMap_ST;
            uniform float _EmissionPower;
            uniform sampler2D _LightMatcapMaskTex; uniform float4 _LightMatcapMaskTex_ST;
            uniform sampler2D _ShadowMatcapMaskTex; uniform float4 _ShadowMatcapMaskTex_ST;
            uniform float4 _LightMatcap2Color;
            uniform sampler2D _LightMatcap2Tex; uniform float4 _LightMatcap2Tex_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalTex_var = UnpackNormal(tex2D(_NormalTex,TRANSFORM_TEX(i.uv0, _NormalTex)));
                float3 normalLocal = _NormalTex_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float2 node_3332 = (mul( UNITY_MATRIX_V, float4(normalDirection,0) ).xyz.rgb.rg*0.5+0.5);
                float4 _LightMatcap2Tex_var = tex2D(_LightMatcap2Tex,TRANSFORM_TEX(node_3332, _LightMatcap2Tex));
                float4 _LightMatcapTex_var = tex2D(_LightMatcapTex,TRANSFORM_TEX(node_3332, _LightMatcapTex));
                float4 _LightMatcapMaskTex_var = tex2D(_LightMatcapMaskTex,TRANSFORM_TEX(i.uv0, _LightMatcapMaskTex));
                float4 _ShadowMatcapMaskTex_var = tex2D(_ShadowMatcapMaskTex,TRANSFORM_TEX(i.uv0, _ShadowMatcapMaskTex));
                float4 _ShadowMatcapTex_var = tex2D(_ShadowMatcapTex,TRANSFORM_TEX(node_3332, _ShadowMatcapTex));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 node_868 = (_MainTex_var.rgb*_Color.rgb);
                float4 _EmissionMap_var = tex2D(_EmissionMap,TRANSFORM_TEX(i.uv0, _EmissionMap));
                float3 finalColor = lerp((saturate(((_LightColor0.rgb*attenuation)+Function_node_9923( float3(0,1,0) )+Function_node_8882( normalize((_WorldSpaceCameraPos-objPos.rgb)) )))*saturate((1.0-(1.0-(_LightMatcap2Color.rgb*_LightMatcap2Tex_var.rgb))*(1.0-saturate((1.0-(1.0-(_LightMatcapColor.rgb*_LightMatcapTex_var.rgb*(1.0 - _LightMatcapMaskTex_var.rgb)))*(1.0-(saturate((1.0-(1.0-_ShadowMatcapMaskTex_var.rgb)*(1.0-saturate(( _ShadowMatcapTex_var.rgb > 0.5 ? (1.0-(1.0-2.0*(_ShadowMatcapTex_var.rgb-0.5))*(1.0-_ShadowMatcapColor.rgb)) : (2.0*_ShadowMatcapTex_var.rgb*_ShadowMatcapColor.rgb) )))))*node_868)))))))),node_868,(_EmissionMap_var.rgb*_EmissionPower));
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
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
            #pragma multi_compile_fog
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
