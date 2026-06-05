extends State
class_name AttackState

@export var max_dist: float = 150.0

var attack_cooldown: float = 1.5

func update(_delta: float, enemy: Enemy) -> void:
  var diff: Vector2 = (enemy.global_position - enemy.target.global_position)
  
  if diff.length_squared() > max_dist * max_dist:
    transition("follow")
    return
  
  attack_cooldown -= _delta
  if attack_cooldown <= 0.0:
    print("hi")
    attack_cooldown = 1.5
