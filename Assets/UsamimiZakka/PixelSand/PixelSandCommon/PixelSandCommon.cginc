float h31(float3 p)
{
    return frac(sin(dot(float3(23.54325,34.5626,54.6356),p))*43627.452387);
}

float h2s1(float2 p, float seed)
{
    return h31(float3(p.xy,seed));
}

float3 hsv2rgb(float h, float s, float v)
{
    return  lerp(1, saturate(abs(frac(h + float3(3,2,1)/3.) * 6 - 3) - 1), s) * v;
}

#define dotself(x) (dot(x,x))
#define sgn(x) ((x)<0?-1:1)

float3 boxInnerRayCast(float3 opos, float3 ordir)
{
    float3 axdist = sign(ordir) * .5 - opos;
    float3 xline = ordir * abs(axdist.x / ordir.x);
    float3 yline = ordir * abs(axdist.y / ordir.y);
    float3 zline = ordir * abs(axdist.z / ordir.z);
    float xdist = dotself(xline);
    float ydist = dotself(yline);
    float zdist = dotself(zline);
    float m = min(xdist, min(ydist, zdist));
    return mul(transpose(float3x3(xline, yline, zline)), (1 - sign(float3(xdist, ydist, zdist) - m))) + opos;
}

#define NONE 0
#define EMPTY 1
#define SAND 2
#define WALL 3

#define SEED_AMOUNT (.45325)

#define SQRT2 (1.41421356237)
#define INVSQRT2 (0.70710678118)