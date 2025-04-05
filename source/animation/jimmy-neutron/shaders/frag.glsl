#version 330

const int NUMBER_OF_STEPS = 32;
const float MINIMUM_HIT_DISTANCE = 0.001;
const float MAXIMUM_TRACE_DISTANCE = 1000.0;

uniform vec2 u_resolution;
uniform float u_time;

// DEBUGGING PURPOSES
uniform float k;
uniform float theta;
uniform float phi;

out vec4 fragColor;

#define LIGHT vec3(3, 4, 4)

vec4 background(vec2 uv) {
    return vec4(vec3(0.93), 1.0);
}

float plane(vec3 ro, vec3 rd) {
    float y = 0;
    return (y-ro.y)/rd.y;
}

float sdSphere( vec3 p, vec3 c, float s )
{
  return length(p-c)-s;
}

float sdRoundedCylinder( vec3 p, float ra, float rb, float h )
{
  vec2 d = vec2( length(p.xz)-2.0*ra+rb, abs(p.y) - h );
  return min(max(d.x,d.y),0.0) + length(max(d,0.0)) - rb;
}

vec3 nSphere(in vec3 p, in vec3 c) {
    return normalize(p - c);
}

float sdRoundCone( vec3 p, float r1, float r2, float h )
{
  // sampling independent computations (only depend on shape)
  float b = (r1-r2)/h;
  float a = sqrt(1.0-b*b);

  // sampling dependant computations
  vec2 q = vec2( length(p.xz), p.y );
  float k = dot(q,vec2(-b,a));
  if( k<0.0 ) return length(q) - r1;
  if( k>a*h ) return length(q-vec2(0.0,h)) - r2;
  return dot( q, vec2(a,b) ) - r1;
}


float sdEllipsoid( vec3 p, vec3 r )
{
  float k0 = length(p/r);
  float k1 = length(p/(r*r));
  return k0*(k0-1.0)/k1;
}

float intersect(in vec3 p) {

    // DEBUG
    p *= mat3(k, 0, 0,
              0, k, 0,
              0, 0, k);
    p *= mat3(cos(theta), 0, -sin(theta),
              0,          1, 0,
              sin(theta), 0, cos(theta));
    p *= mat3(1, 0, 0,
              0, cos(phi), -sin(phi),
              0, sin(phi), cos(phi));

    // centered at origin
    // upper face
    float d = sdRoundCone(p, 0.2, 0.3, 0.3);

    // bottom face
    d = min(d, sdEllipsoid(p - vec3(0, -0.2, 0.04), vec3(0.22, 0.18, 0.22)));

    return d;
}

vec3 normal(in vec3 p) {
    vec2 e = vec2(0.001, 0);
    return normalize(vec3(intersect( p + e.xyy ) - intersect( p - e.xyy),
                          intersect( p + e.yxy ) - intersect( p - e.yxy),
                          intersect( p + e.yyx ) - intersect( p - e.yyx)
                        ));
}

vec4 ray_march(in vec3 ro, in vec3 rd, in vec2 uv)
{
    float t = 0.0;

    for (int i = 0; i < NUMBER_OF_STEPS; ++i)
    {
        vec3 p = ro + t*rd;

        float d = intersect(p);

        if (d < MINIMUM_HIT_DISTANCE) {
            float eps = 0.001;
            vec4 res = vec4(0.95, 0.87, 0.29, 1.0);
            // res.rgb *= clamp((intersect(p+eps*LIGHT)-d)/eps,0.0,1.0);
            res.rgb *= clamp(dot(normal(p), LIGHT-p), 0, 1);
            return res;
        }
        if (t > MAXIMUM_TRACE_DISTANCE)
            break;
        t += d;
    }

    return background(uv);
}



void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    uv -= vec2(0.5); // center
    uv.y *= u_resolution.y/u_resolution.x;

    vec4 col = vec4(1, 0, 0, 1);

    vec3 screen = vec3(uv, 2.0);
    vec3 ro = vec3(0, 0, 5);
    vec3 rd = normalize(screen - ro);

    col = ray_march(ro, rd, uv);

    fragColor = col;
} 