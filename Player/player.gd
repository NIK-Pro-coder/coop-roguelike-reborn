extends CharacterBody2D
class_name Player

#region MulitInput warppers

func get_action_strength(action_name: String) -> float:
  return MultiInput.get_action_strength(action_name, device)

func is_action_pressed(action_name: String) -> bool:
  return MultiInput.is_action_pressed(action_name, device)

func get_action_axis(negative: String, positive: String) -> float:
  return MultiInput.get_action_axis(negative, positive, device)

func get_action_vector(negx: String, posx: String, negy: String, posy: String) -> Vector2:
  return MultiInput.get_action_vector(negx, posx, negy, posy, device)

#endregion

@export var device: int = -1

#region Player stats

var speed: float = 250
var roll_duration: float = .25
var roll_cooldown: float = .15

#endregion

var last_move_dir: Vector2

var rolling: bool = false

func handle_move(delta: float) -> void:
  if rolling:
    return
  
  last_move_dir = get_action_vector(
    "left", "right",
    "up", "down"
  )
  
  velocity = last_move_dir * speed * delta * 60

var roll_time: float = 0.0
var roll_dir: Vector2 = Vector2.ZERO

func handle_roll(delta: float) -> void:
  roll_time -= delta
  
  if !rolling:
    if roll_time > -roll_cooldown:
      return

    if !last_move_dir:
      return
    
    if is_action_pressed("roll"):
      rolling = true
      roll_dir = last_move_dir
      roll_time = roll_duration
    
    return
  
  if roll_time <= 0.0:
    rolling = false
    return

  velocity = last_move_dir * speed * 2.5 * delta * 60

func _physics_process(delta: float) -> void:
  handle_move(delta)
  handle_roll(delta)
  
  move_and_slide()
