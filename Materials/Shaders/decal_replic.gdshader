shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_always, cull_back;

// === Declaración del depth texture ===
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

// === Parámetros de control ===
uniform vec4 color : source_color = vec4(0.2, 0.8, 1.0, 0.4);
uniform float fade_height : hint_range(0.0, 5.0) = 1.0;
uniform float inner_radius : hint_range(0.0, 2.0) = 0.0;
uniform float edge_softness : hint_range(0.0, 1.0) = 0.1;

varying vec4 clip_pos;

void vertex() {
    clip_pos = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
}

void fragment() {
    // Convertimos posición a coordenadas de pantalla
    vec2 screen_uv = clip_pos.xy / clip_pos.w * 0.5 + 0.5;

    // Leemos la profundidad de la escena (0 = cerca, 1 = lejos)
    float scene_depth = texture(DEPTH_TEXTURE, screen_uv).r;
    float pixel_depth = clip_pos.z / clip_pos.w * 0.5 + 0.5; // Normalizamos a [0,1]

    // Descartamos si el píxel está detrás de la geometría visible
    if (pixel_depth > scene_depth + 0.002) {
        discard;
    }

    // --- Fade vertical ---
    float h = clamp(VERTEX.y / max(fade_height, 0.001), 0.0, 1.0);
    float height_fade = smoothstep(0.0, 1.0, h);

    // --- Borde circular ---
    float dist = length(VERTEX.xz);
    float outer = smoothstep(1.0, 1.0 - edge_softness, dist);
    float inner = 1.0;
    if (inner_radius > 0.0) {
        inner = smoothstep(inner_radius - edge_softness, inner_radius, dist);
    }

    // --- Combinamos ---
    float alpha = (1.0 - outer) * inner * (1.0 - height_fade);
    ALBEDO = color.rgb;
    ALPHA = clamp(alpha * color.a, 0.0, 1.0);
}
