extends CharacterBody2D
class_name Player

@export var device: int = -1

var SPEED: float = 500

func handle_move(delta: float) -> void:
  var move_dir: Vector2 = MultiInput.get_action_vector(
    "left", "right",
    "up", "down",
    device
  )
  
  velocity = move_dir * SPEED * delta * 60

func _physics_process(delta: float) -> void:
  handle_move(delta)
  
  move_and_slide()
