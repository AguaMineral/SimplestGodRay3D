shader_type spatial;
render_mode unshaded, cull_back, depth_prepass_alpha, blend_add;

uniform float spread = 3.0;
uniform float intensity = 1.0;
uniform float transparency = 1.0;
uniform float fade_distance = 1.0;
uniform vec4 ray_color : source_color = vec4(1.0, 1.0, 0.8, 1.0);

void vertex() {
    float t = UV.y;
    VERTEX.x *= mix(1.0, spread, t);
}

void fragment() {
    float t = UV.y;
    float fade = pow(1.0 - t, fade_distance);
    vec3 final_color = ray_color.rgb * intensity;
    float alpha = ray_color.a * transparency * fade;

    ALBEDO = final_color;
    ALPHA = alpha;
}
