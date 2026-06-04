extends CharacterBody2D
class_name Enemy

var speed: float = 200.0

func _physics_process(_delta: float) -> void:
  move_and_slide()
