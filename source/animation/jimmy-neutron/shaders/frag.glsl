#version 330

const int NUMBER_OF_STEPS = 32;
const float MINIMUM_HIT_DISTANCE = 0.001;
const float MAXIMUM_TRACE_DISTANCE = 1000.0;

uniform vec2 u_resolution;
uniform float u_time;
out vec4 fragColor;

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

float intersect(in vec3 p) {
    // giant sdf

    float d = sdRoundedCylinder(p - vec3(0, 0, -4), 0.3, 0.1, 0.3);
    d = min(sdSphere(p, vec3(0, 0, -3), 0.3), d);

    return d;
}

vec4 ray_march(in vec3 ro, in vec3 rd, in vec2 uv)
{
    float t = 0.0;

    for (int i = 0; i < NUMBER_OF_STEPS; ++i)
    {
        vec3 p = ro + t * rd;

        float distance_to_closest = intersect(p);

        if (distance_to_closest < MINIMUM_HIT_DISTANCE)
            return vec4(0.95, 0.87, 0.29, 1.0);
        if (t > MAXIMUM_TRACE_DISTANCE)
            break;
        t += distance_to_closest;
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