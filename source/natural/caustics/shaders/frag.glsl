#version 330

uniform vec2 u_resolution;
uniform float u_time;
out vec4 fragColor;

#define OCTAVES 5
#define AMPLITUDE 5.0
#define FREQUENCY 10.0
#define SPEED 1.0

#define N_WATER 1.33
#define N_AIR 1.0
#define PLANE -1.0

float lightSource(vec2 st) {
    float r = 0.05;
    float gradient = 0.4;
    return smoothstep(r+gradient, r, length(st));
}


float naive(vec2 st) {
    float z = 0.0;
    float factor = 0.5;
    for (int i = 0; i < OCTAVES; i++) {
        z -= cos(u_time*SPEED + FREQUENCY * st.x * st.y / factor ) * factor;
        factor = factor / 2;
    }
    return AMPLITUDE * length(st) * z;
}

vec3 nNaive(vec2 st) {
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

    return normalize(vec3( - AMPLITUDE * dfx,
                           - AMPLITUDE * dfy,
                           1.0));

}


float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) *
            43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    // Four corners in 2D of a tile
    float a = random(uv_index);
    float b = random(uv_index + vec2(1.0, 0.0));
    float c = random(uv_index + vec2(0.0, 1.0));
    float d = random(uv_index + vec2(1.0, 1.0));

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix(a, b, blur.x) +
            (c - a) * blur.y * (1.0 - blur.x) +
            (d - b) * blur.x * blur.y;
}

float fbm(vec2 uv) {
    int octaves = 6;
    float amplitude = 0.5;
    float frequency = 3.0;
	float value = 0.0;
	
    for(int i = 0; i < octaves; i++) {
        value += amplitude * noise(frequency * uv);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}

vec3 calcNormal( in vec2 x, in float eps )
{
  vec2 e = vec2( eps, 0.0 );
  return normalize(vec3(fbm(x+e.xy)-fbm(x-e.xy),
                        fbm(x+e.yx)-fbm(x-e.yx));
}

vec3 refracted(vec3 N, vec3 E) {
    N = normalize(N);
    E = normalize(E);
    float n = N_WATER / N_AIR;
    vec3 T = n * cross(N, -cross(N, E));
    T -= N * sqrt(1.0 - n*n*dot(cross(N, E), cross(N, E)) );
    return normalize(T);
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

    // x \in [0, 1], y scaled to the aspect ratio
    vec2 xy = vec2(uv);
    xy.y *= u_resolution.y/u_resolution.x;

    // x \in [-1, 1], y is scaled to the aspect ratio
    // origin in the center
    vec2 st = (uv * 2.0 - vec2(1.0));
    st.y *= u_resolution.y/u_resolution.x;

    vec3 ro = vec3(0.0, 0.0, surface(xy));
    vec3 rd = refracted(nSurface(xy), vec3(0, 0, -1));

    vec2 ix = plane(ro, rd);

    vec3 col = vec3(lightSource(ix));
    fragColor = vec4(col,1);
} 