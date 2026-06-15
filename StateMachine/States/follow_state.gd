extends State
class_name FollowState

@export var target_dist: float = 100.0

func enter(enemy: Enemy) -> void:
  enemy.grab_target()

func update(_delta: float, enemy: Enemy) -> void:
  var diff: Vector2 = (enemy.target.global_position - enemy.global_position)
  if diff.length_squared() <= target_dist * target_dist:
    transition("attack")
    enemy.move_position = enemy.global_position
    return
  
  enemy.move_position = enemy.target.global_position
