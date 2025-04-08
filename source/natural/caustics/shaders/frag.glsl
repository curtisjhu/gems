#version 330

uniform vec2 u_resolution;
uniform float u_time;
out vec4 fragColor;

#define OCTAVES 8
#define AMPLITUDE 5.0
#define FREQUENCY 40.0
#define SPEED 0.0

#define N_WATER 1.33
#define N_AIR 1.0
#define PLANE -1.0

float lightSource(vec2 st) {
    float r = 0.05;
    float gradient = 0.4;
    return smoothstep(r+gradient, r, length(st));
}


float surface(vec2 st) {
    float z = 0.0;
    float factor = 0.5;
    for (int i = 0; i < OCTAVES; i++) {
        z -= cos(u_time*SPEED + FREQUENCY * st.x * st.y / factor ) * factor;
        factor = factor / 2;
    }
    return AMPLITUDE * length(st) * z;
}

vec3 nSurface(vec2 st) {
    float dfx = 0.0;
    float dfy = 0.0;

    float factor = 0.5;
    float d = length(st);

    for (int i = 0; i < OCTAVES; i++) {
        dfx -= d * sin(u_time*SPEED + FREQUENCY * st.x * st.y / factor ) * FREQUENCY * st.y
               - cos(u_time*SPEED + FREQUENCY * st.x * st.y / factor) * st.x * factor / d;
        dfy -= d * sin(u_time*SPEED + FREQUENCY * st.x * st.y / factor ) * FREQUENCY * st.x
               - cos(u_time*SPEED + FREQUENCY * st.x * st.y / factor) * st.y * factor / d;
        factor = factor / 2;
    }

    return vec3( - AMPLITUDE * dfx,
                 - AMPLITUDE * dfy,
                 1.0);

}

vec3 refracted(vec3 N, vec3 E) {
    N = normalize(N);
    E = normalize(E);
    float n = N_WATER / N_AIR;
    vec3 T = n * cross(N, -cross(N, E));
    T -= N * sqrt(1.0 - n*n*dot(cross(N, E), cross(N, E)) );
    return T;
}

vec2 plane(vec3 ro, vec3 rd) {
    if (rd.z == 0.0) {
        return vec2(0.0, 0.0);
    }
    float t = (PLANE - ro.z) / rd.z;
    return (ro + t*rd).xy;
}

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;

    vec2 xy = vec2(uv);
    xy.y *= u_resolution.y/u_resolution.x;

    // x \in [-1, 1], y is scaled to the aspect ratio
    vec2 st = (uv * 2.0 - vec2(1.0));
    st.y *= u_resolution.y/u_resolution.x;

    vec3 ro = vec3(0.0, 0.0, surface(xy));
    vec3 rd = refracted(nSurface(xy), vec3(0.0, 0.0, -1.0));

    vec3 col = vec3(lightSource(plane(ro, rd)));
    fragColor = vec4(col,1);
} 