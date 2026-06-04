extends Node

func get_action_strength(action_name: String, device: int) -> float:
  var val: float = 0.0
  
  if device < 0:
    for i in InputMap.action_get_events(action_name):
      if i is InputEventKey:
        if Input.is_physical_key_pressed(i.physical_keycode):
          val = max(val, 1.0)
      
      if i is InputEventMouseButton:
        if Input.is_mouse_button_pressed(i.button_index):
          val = max(val, 1.0)
  else:
    for i in InputMap.action_get_events(action_name):
      if i is InputEventJoypadMotion:
        var joy_val: float = clamp(Input.get_joy_axis(device, i.axis) / i.axis_value, 0.0, 1.0)
        if joy_val < 0.01:
          joy_val = 0.0
        
        val = max(val, joy_val)
      
      if i is InputEventJoypadButton:
        if Input.is_joy_button_pressed(device, i.button_index):
          val = max(val, 1.0)
  
  return val

func is_action_pressed(action_name: String, device: int) -> bool:
  return get_action_strength(action_name, device) >= .5

func get_action_axis(negative: String, positive: String, device: int) -> float:
  return (
    get_action_strength(positive, device) -
    get_action_strength(negative, device)
  )

func get_action_vector(negx: String, posx: String, negy: String, posy: String, device: int) -> Vector2:
  return Vector2(
    get_action_axis(negx, posx, device),
    get_action_axis(negy, posy, device),
  ).normalized()

func _ready() -> void:
  print("Connected joypads:")
  for i in Input.get_connected_joypads():
    print("  %s. %s" % [i, Input.get_joy_name(i)])
