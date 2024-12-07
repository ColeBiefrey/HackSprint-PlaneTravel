// adding shader
shader_type canvas_item;
// variable controlling direction, to the left
uniform vec2 direction = vec2(1.0, 0.0);
// float to control speed of movement
uniform float speed_scale = .03;
// fragment shifts each pixel
void fragment(){
 vec2 move = direction * TIME * speed_scale;
 COLOR = texture(TEXTURE, UV + move);
}
