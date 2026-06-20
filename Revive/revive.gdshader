shader_type canvas_item;

uniform float progress = 0.0;

void fragment() {
  float angle = (atan(UV.y - .5, UV.x - .5) / PI + 1.0) / 2.0 - .25;
  if (angle >= 1.0) {
    angle -= 1.0;
  }
  if (angle < 0.0) {
    angle += 1.0;
  }
  float dist = sqrt((pow(UV.x - .5, 2) + pow(UV.y - .5, 2)) * 2.0);
  
  COLOR.a = 0.0;
  COLOR.rgb = vec3(0.0, 0.25, 0.75);
  
  if (dist >= .66 && dist <= .68){
    COLOR.a = 0.25;
    if (angle <= progress) {
      COLOR.a = 1.0;
    }
  }
}
