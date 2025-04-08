#version 330

uniform vec2 u_resolution;
uniform float u_time;
out vec4 fragColor;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float lightSource(vec2 st) {
    float r = 0.05;
    float gradient = 0.4;
    return smoothstep(r+gradient, r, length(st));
}

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;

    // x \in [-1, 1], y is scaled to the aspect ratio
    vec2 xy = (uv * 2.0 - vec2(1.0));
    xy.y *= u_resolution.y/u_resolution.x;

    vec3 col = vec3(lightSource(xy));
    fragColor = vec4(col,1);
} 