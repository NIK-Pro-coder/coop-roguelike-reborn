extends CharacterBody2D
class_name Player

var SPEED: float = 500

func handle_move(delta: float) -> void:
  var move_dir: Vector2 = Input.get_vector(
    "right", "left",
    "up", "down"
  ).normalized()
  
  velocity = move_dir * SPEED * delta * 60

func _physics_process(delta: float) -> void:
  handle_move(delta)
  
  move_and_slide()
