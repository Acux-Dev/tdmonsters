shader_type spatial;
render_mode unshaded, shadows_disabled, cull_disabled;

uniform vec4 color_inside : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Color dentro del círculo
uniform vec4 color_border : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Color del borde punteado

uniform float alpha_inside : hint_range(0.0, 1.0) = 1.0; // Transparencia dentro del círculo
uniform float alpha_outside : hint_range(0.0, 1.0) = 0.0; // Transparencia fuera del círculo

uniform float diameter = 1.0; // Diámetro del círculo
uniform float thickness = 0.05; // Grosor del borde
uniform float frequency = 10.0; // Cantidad de puntos en el borde
uniform float rotation_speed = 1.0; // Velocidad de rotación del borde punteado

uniform float line_angle = 20.0; // Ángulo de las líneas internas
uniform float line_count = 20.0; // Cantidad de líneas
uniform float line_speed = 5.0; // Velocidad de las líneas
uniform float blur : hint_range(0.0, 2.0, 0); // Desenfoque de las líneas
uniform float darken_factor : hint_range(0.0, 1.0) = 0.5; // Factor de oscurecimiento

uniform bool patron_inside; // Habilitar patrón dentro del círculo

// Función para rotar coordenadas UV
vec2 rotate(vec2 uv, float rotation_angle) {
    float radians_angle = radians(rotation_angle);
    float cos_angle = cos(radians_angle);
    float sin_angle = sin(radians_angle);
    mat2 rotation_matrix = mat2(vec2(cos_angle, -sin_angle), vec2(sin_angle, cos_angle));
    return uv * rotation_matrix;
}

// Función para generar líneas en el patrón
float stripe(vec2 uv) {
    return cos(uv.y * line_count + TIME * line_speed);
}

void fragment() {
    // Convertir UV en coordenadas centradas
    vec2 pos = UV - vec2(0.5, 0.5);

    // Convertir UV en coordenadas polares
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Normalizar ángulo (0 a 2PI)
    if (angle < 0.0) {
        angle += 2.0 * PI;
    }

    // Definir radio exterior e interior del borde
    float outer_radius = diameter / 2.0;
    float inner_radius = outer_radius - thickness;

    // Determinar si el píxel está dentro o fuera del círculo
    float inside_circle = step(radius, outer_radius - 0.005);
    float outside_circle = 1.0 - inside_circle;

    // Definir el borde del círculo
    float outer_circle = step(radius, outer_radius);
    float inner_circle = step(radius, inner_radius);

    // Generar patrón punteado con onda sinusoidal
    float wave = 0.5 * sin(frequency * angle + rotation_speed * TIME) + 0.5;
    float ring = outer_circle - inner_circle;
    ring *= step(0.5, wave);

    // Generar el patrón de líneas si está habilitado
    vec3 pattern_color = color_inside.rgb;
    if (patron_inside) {
        vec2 uv = UV - vec2(0.5, 0.5);
        uv = rotate(uv, line_angle);
        float g = stripe(uv);

        // Color más oscuro basado en `color_inside`
        vec3 darker_color = color_inside.rgb * darken_factor;

        // Mezclar entre color original y más oscuro según el patrón
        pattern_color = mix(darker_color, color_inside.rgb, smoothstep(0.0, blur, g));
    }

    // Mezclar colores según la posición
    vec3 final_color = mix(vec3(0.0), pattern_color, inside_circle);
    final_color = mix(final_color, color_border.rgb, ring);

    // Mezclar la transparencia (fuera del círculo será alpha_outside)
    float final_alpha = mix(alpha_outside, alpha_inside, inside_circle);
    final_alpha = mix(final_alpha, 1.0, ring); // Asegurar que el borde es totalmente visible

    // Aplicar color final con transparencia
    ALBEDO = final_color;
    ALPHA = final_alpha;
}
