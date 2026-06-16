shader_type canvas_item;

uniform vec3 chroma_color = vec3(0.0, 1.0, 0.0);
uniform float threshold = .5;

void fragment() {
  vec3 diff = COLOR.rgb - chroma_color;
  float len = (diff.x * diff.x + diff.y * diff.y + diff.z * diff.z) / 3.0;
  
  if (len <= threshold) {
    COLOR.a = 0.0;
  }
}
