shader_type canvas_item;

void fragment() {
  float angle = atan(UV.y - .5, UV.x - .5);
  float dist = sqrt((pow(UV.x - .5, 2) + pow(UV.y - .5, 2)) * 2.0);
  
  COLOR.a = 0.0;
  
  if (dist >= .66 && dist <= .68){
    COLOR.a = 1.0;
  }
}
