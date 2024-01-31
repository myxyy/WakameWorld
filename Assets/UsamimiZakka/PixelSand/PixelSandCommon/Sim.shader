Shader "myxy/PixelSand/Sim"
{
    Properties
    {
        [HideInInspector] _IsWallByTex ("Is Wall By Texture", Int) = 0
        [HideInInspector] _WallTex ("Wall", 2D) = "black" {}
        [HideInInspector] _WallTh ("Wall Threashold", Range(-.01,1.01)) = 0.5
        [HideInInspector] _IsInitByProb ("Is Init By Probability", Int) = 0
        [HideInInspector] _MainTex("Previous State", 2D) = "black" {}
        [HideInInspector] _Init ("Init", Int) = 0
        [HideInInspector] _Amount ("Amount", Range(-1,1)) = 0.3
        [HideInInspector] _IsBoundWall ("Is Bound Wall", Int) = 1
        [HideInInspector] _SandInitTex ("Sand Mask", 2D) = "white" {}
        [HideInInspector] _InitProb ("Init Prob", Range(0,1)) = 1
        [HideInInspector] _Bottleneck ("Bottleneck width", Range(0,1)) = .0001
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

            int _IsWallByTex;
            sampler2D _WallTex;
            float4 _WallTex_ST;
            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            int _Init;
            float _Seed;
            float3 _Gravity;
            float _Amount;
            int _IsBoundWall;
            float _WallTh;
            sampler2D _SandInitTex;
            float _InitProb;
            float _Bottleneck;

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

            float lemniscate(float2 p, float a)
            {
                float x2 = p.x*p.x;
                float y2 = p.y*p.y;
                return (x2+y2)*(x2+y2) - 2*a*a*(x2-y2); 
            }

            bool wall_lem(int2 iuv)
            {
                float2 size = _MainTex_TexelSize.zw;
                float2 invsize = _MainTex_TexelSize.xy;
                return lemniscate(((iuv+.5)*invsize*2-1).yx, INVSQRT2) > _Bottleneck;
            }

            bool wall_tex(int2 iuv)
            {
                float2 size = _MainTex_TexelSize.zw;

                // float2 uv = (iuv+.5)*_MainTex_TexelSize.xy; // Does not work for _MainTex which is not square

                // float2 invsize = 1/size;
                // float2 uv = (iuv+.5)*invsize // Also does not work

                float2 uv = (iuv+.5)/size; // Works, why?


                if (_IsBoundWall && any((uv - saturate(uv))))
                {
                    return true;
                }
                return tex2Dlod(_WallTex, float4(frac(uv)*_WallTex_ST.xy+_WallTex_ST.zw,0,0)).r > _WallTh;
            }

            float4 init(int2 iuv)
            {
                float2 size = _MainTex_TexelSize.zw;
                float2 invsize = _MainTex_TexelSize.xy;
                bool iswall = false;
                [branch]
                if (_IsWallByTex)
                {
                    iswall = wall_tex(iuv);
                }
                else
                {
                    iswall = wall_lem(iuv);
                }
                if (iswall)
                {
                    return float4(WALL,0,0,0);
                }
                float sandAmount = iuv.y/size.y;
                if (_Amount < 0)
                {
                    sandAmount = 1 - sandAmount;
                }
                float sandMaskByInitTex = tex2Dlod(_SandInitTex, float4(frac((iuv + .5)*invsize)*_WallTex_ST.xy+_WallTex_ST.zw,0,0)).r;
                bool isSand = sandAmount < abs(_Amount) && h2s1(iuv.xy,SEED_AMOUNT) < _InitProb * sandMaskByInitTex;
                return float4(float2(isSand?SAND:EMPTY,0)+iuv*4,isSand?1:0,1);
            }

            float4 fetch(int2 iuv)
            {
                float2 size = _MainTex_TexelSize.zw;
                float2 invsize = _MainTex_TexelSize.xy;
                bool iswall = false;
                [branch]
                if (_IsWallByTex)
                {
                    iswall = wall_tex(iuv);
                }
                else
                {
                    iswall = wall_lem(iuv);
                }
                if (iswall)
                {
                    return float4(WALL,0,0,0);
                }
                return tex2Dlod(_MainTex, float4(frac((iuv+.5)*invsize),0,0));
            }

            int2 rn(int2 iuv)
            {
                return frac((iuv + .5)/_MainTex_TexelSize.zw) * _MainTex_TexelSize.zw;
            }

            bool IsFall(int2 iuv)
            {
                float gx = -_Gravity.x;
                float gy = -_Gravity.y;
                float seed = _Seed + .62542;
                return SQRT2 * h2s1(rn(iuv),seed) < abs(gx) + abs(gy);
            }

            bool IsMoveLeft(int2 iuv)
            {
                float seed = _Seed + .462542;
                return h2s1(rn(iuv),seed) < .5;
            }

            bool IsMoveRight(int2 iuv)
            {
                return !IsMoveLeft(iuv);
            }

            bool IsCollidingLeftFall(int2 iuv)
            {
                float seed = _Seed + .256326;
                return h2s1(rn(iuv),seed) >= .5;
            }

            bool IsCollidingRightFall(int2 iuv)
            {
                return !IsCollidingLeftFall(iuv);
            }
 
            float4 update(int2 iuv)
            {
                float gx = -_Gravity.x;
                float gy = -_Gravity.y;
                float4 emptyState = float4(EMPTY,0,0,1);
                int2 up;
                int2 right;
                if (frac(_Seed) * (abs(gx) + abs(gy)) < abs(gx))
                {
                    int s = gx < 0 ? -1 : 1;
                    up = int2(s, 0);
                    right = int2(0, -s);
                }
                else
                {
                    int s = gy < 0 ? -1 : 1;
                    up = int2(0, s);
                    right = int2(s, 0);
                }

                float4 self = fetch(iuv);

                bool isSand = self.x%4 == SAND;
                bool isEmpty = self.x%4 == EMPTY;
                if (!isSand && !isEmpty)
                {
                    return self;
                }

                float2 iuvUpU = (isSand?0:up) + iuv;
                float4 m3u = fetch(right*(-3) + iuvUpU);
                float4 m2u = fetch(right*(-2) + iuvUpU);
                float4 m1u = fetch(right*(-1) + iuvUpU);
                float4 p0u = fetch(right*( 0) + iuvUpU);
                float4 p1u = fetch(right*( 1) + iuvUpU);
                float4 p2u = fetch(right*( 2) + iuvUpU);
                float4 p3u = fetch(right*( 3) + iuvUpU);

                float2 iuvUpL = (isSand?-up:0) + iuv;
                float4 m3l = fetch(right*(-3) + iuvUpL);
                float4 m2l = fetch(right*(-2) + iuvUpL);
                float4 m1l = fetch(right*(-1) + iuvUpL);
                float4 p0l = fetch(right*( 0) + iuvUpL);
                float4 p1l = fetch(right*( 1) + iuvUpL);
                float4 p2l = fetch(right*( 2) + iuvUpL);
                float4 p3l = fetch(right*( 3) + iuvUpL);
                
                float4 isFallSelf = IsFall(iuv) ? emptyState : self;

                if (isSand)
                {
                    if (p0l.x%4 == EMPTY)
                    {
                        return isFallSelf;
                    }
                    bool isRightEmpty = p1u.x%4 == EMPTY && p1l.x%4 == EMPTY;
                    bool isLeftEmpty = m1u.x%4 == EMPTY && m1l.x%4 == EMPTY;
                    if (
                        (isRightEmpty && !isLeftEmpty) ||
                        (isRightEmpty && isLeftEmpty && IsMoveRight(iuv))
                    )
                    {
                        if (p2u.x%4 != SAND || p2l.x%4 == EMPTY)
                        {
                            return isFallSelf;
                        }
                        bool isRightRightEmpty = p3u.x%4 == EMPTY && p3l.x%4 == EMPTY;
                        if (isRightRightEmpty && IsMoveRight(iuv + right*( 2)))
                        {
                            return isFallSelf;
                        }
                        if (IsCollidingLeftFall(iuv + right*( 1)))
                        {
                            return isFallSelf;
                        }
                    }
                    if (
                        (!isRightEmpty && isLeftEmpty) ||
                        (isRightEmpty && isLeftEmpty && IsMoveLeft(iuv))
                    )
                    {
                        if (m2u.x%4 != SAND || m2l.x%4 == EMPTY)
                        {
                            return isFallSelf;
                        }
                        bool isLeftLeftEmpty = m3u.x%4 == EMPTY && m3l.x%4 == EMPTY;
                        if (isLeftLeftEmpty && IsMoveLeft(iuv + right*(-2)))
                        {
                            return isFallSelf;
                        }
                        if (IsCollidingRightFall(iuv + right*(-1)))
                        {
                            return isFallSelf;
                        }
                    }
                }

                if (isEmpty)
                {
                    if (p0u.x%4 == SAND)
                    {
                        return IsFall(iuv + up) ? p0u : emptyState;
                    }
                    bool isRightFallable = !(p2u.x%4 == EMPTY && p2l.x%4 == EMPTY) || (p2u.x%4 == EMPTY && p2l.x%4 == EMPTY && IsMoveLeft(iuv + up + right));
                    bool isLeftFallable = !(m2u.x%4 == EMPTY && m2l.x%4 == EMPTY) || (m2u.x%4 == EMPTY && m2l.x%4 == EMPTY && IsMoveRight(iuv + up - right));
                    float4 isRightFall = IsFall(iuv + up + right) ? p1u : emptyState;
                    float4 isLeftFall = IsFall(iuv + up - right) ? m1u : emptyState;
                    if (p0u.x%4 == EMPTY && p1u.x%4 == SAND && p1l.x%4 != EMPTY && (m1u.x%4 != SAND || m1l.x%4 == EMPTY))
                    {
                        if (isRightFallable)
                        {
                            return isRightFall;
                        }
                    }
                    if (p0u.x%4 == EMPTY && m1u.x%4 == SAND && m1l.x%4 != EMPTY && (p1u.x%4 != SAND || p1l.x%4 == EMPTY))
                    {
                        if (isLeftFallable)
                        {
                            return isLeftFall;
                        }
                    }
                    if (p0u.x%4 == EMPTY && m1u.x%4 == SAND && m1l.x%4 != EMPTY && p1u.x%4 == SAND && p1l.x%4 != EMPTY)
                    {
                        if (isRightFallable && !isLeftFallable)
                        {
                            return isRightFall;
                        }
                        if (!isRightFallable && isLeftFallable)
                        {
                            return isLeftFall;
                        }
                        if (isRightFallable && isLeftFallable)
                        {
                            if (IsCollidingRightFall(iuv + up))
                            {
                                return isRightFall;
                            }
                            else
                            {
                                return isLeftFall;
                            }
                        }
                    }
                }

                return self;
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
                int2 iuv = i.uv * _MainTex_TexelSize.zw;
                [branch]
                if (_Init)
                {
                    return init(iuv);
                }
                else
                {
                    return update(iuv);
                }
            }
            ENDCG
        }
    }
}