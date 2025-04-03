#version 330

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

vec3 ray_march(in vec3 ro, in vec3 rd)
{
    float t = 0.0;
    const int NUMBER_OF_STEPS = 32;
    const float MINIMUM_HIT_DISTANCE = 0.001;
    const float MAXIMUM_TRACE_DISTANCE = 1000.0;

    for (int i = 0; i < NUMBER_OF_STEPS; ++i)
    {
        vec3 p = ro + t * rd;

        float distance_to_closest = sdSphere(p, vec3(0, 0, -3), 1.0);

        if (distance_to_closest < MINIMUM_HIT_DISTANCE)
            return vec3(1.0, 0.0, 0.0);
        if (t > MAXIMUM_TRACE_DISTANCE)
            break;
        t += distance_to_closest;
    }
    return vec3(0.0);
}



void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    uv -= vec2(0.5); // center
    uv.y *= u_resolution.y/u_resolution.x;

    vec4 col = background(uv);

    vec3 screen = vec3(uv, 2.0);
    vec3 ro = vec3(0, 0, 5);
    vec3 rd = normalize(screen - ro);

    col.rgb = ray_march(ro, rd);

    fragColor = col;
} 