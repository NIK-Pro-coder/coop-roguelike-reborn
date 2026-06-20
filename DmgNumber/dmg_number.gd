extends RichTextLabel
class_name DmgNumber

var damage: float = 100

var time: Timer

var start_y: float = 0.0

func _ready() -> void:
  z_index = 100
  
  global_position += Vector2(
    randf_range(-1.0, 1.0),
    randf_range(-1.0, 1.0)
  ).normalized() * 10
  
  start_y = global_position.y
  
  text = str(abs(damage)) if abs(round(damage) - damage) > 0.01 else str(abs(int(round(damage))))
  fit_content = true
  custom_minimum_size.x = 10000
  position.x -= custom_minimum_size.x / 2.0
  horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
  vertical_alignment = VERTICAL_ALIGNMENT_CENTER
  
  theme = Qol.main_theme
  
  if damage > 0:
    add_theme_color_override("default_color", Color(1, 0, 0))
  else:
    add_theme_color_override("default_color", Color(0, 1, 0))
    
  add_theme_constant_override("outline_size", 3)
  
  var lifetime: float = clamp(abs(damage) / 100, .2, 2)
  
  time = Timer.new()
  time.autostart = true
  time.wait_time = lifetime
  time.timeout.connect(queue_free)
  
  add_child(time)

func _process(_delta: float) -> void:
  modulate.a = time.time_left / time.wait_time
  global_position.y = start_y - (time.wait_time - time.time_left) * 25
