shader_type canvas_item;

void fragment() {
  vec3 diff = COLOR.rgb - vec3(0.0, 1.0, 0.0);
  float len = diff.x * diff.x + diff.y * diff.y + diff.z * diff.z;
  
  if (len <= .7) {
    COLOR.a = 0.0;
  }
}
