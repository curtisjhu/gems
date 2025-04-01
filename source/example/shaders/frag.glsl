#version 330

uniform vec2 u_resolution;
uniform float u_time;
out vec4 fragColor;

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    vec3 col = 0.5 + 0.5*cos(u_time+uv.xyx+vec3(0,2,4));
    fragColor = vec4(col,1);
} 