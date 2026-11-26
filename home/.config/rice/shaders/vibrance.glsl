#version 300 es
// Vibrance (LeyzS idea, gentler): boosts dull colours more than already-bright ones.
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float AMOUNT = 0.35;

void main() {
    vec4 c = texture(tex, v_texcoord);
    float luma = dot(c.rgb, vec3(0.299, 0.587, 0.114));
    float sat = max(c.r, max(c.g, c.b)) - min(c.r, min(c.g, c.b));
    float boost = 1.0 + AMOUNT * (1.0 - sat);
    fragColor = vec4(clamp(mix(vec3(luma), c.rgb, boost), 0.0, 1.0), c.a);
}
