shader_type spatial;
render_mode unshaded, shadows_disabled, cull_disabled, depth_test_disabled;

uniform vec4 color_inside : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Color dentro del círculo
uniform vec4 color_border : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Color del borde punteado
uniform float alpha_inside : hint_range(0.0, 1.0) = 1.0; // Transparencia dentro del círculo
uniform float alpha_outside : hint_range(0.0, 1.0) = 0.0; // Transparencia fuera del círculo

uniform float diameter = 1.0; // Diámetro del círculo
uniform float thickness = 0.05; // Grosor del borde
uniform float frequency = 10; // Cantidad de puntos en el borde
uniform float rotation_speed = 1.0; // Control de la rotación del patrón

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

    // Mezclar colores según la posición
    vec3 final_color = mix(vec3(0.0), color_inside.rgb, inside_circle);
    final_color = mix(final_color, color_border.rgb, ring);

    // Mezclar la transparencia (fuera del círculo será alpha_outside)
    float final_alpha = mix(alpha_outside, alpha_inside, inside_circle);
    final_alpha = mix(final_alpha, 1.0, ring); // Asegurar que el borde es totalmente visible

    // Aplicar color final con transparencia
    ALBEDO = final_color;
    ALPHA = final_alpha;
}
