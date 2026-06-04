extends State
class_name FollowState

var target: Player

func enter(enemy: Enemy) -> void:
  var dist: float = -1.0
  
  for i in get_tree().get_nodes_in_group("player"):
    var d: float = (i as Player).global_position.distance_squared_to(enemy.global_position)
    
    if d < dist or dist < 0.0:
      dist = d
      target = i

func update(delta: float, enemy: Enemy) -> void:
  var move_dir: Vector2 = (target.global_position - enemy.global_position).normalized()
  
  enemy.velocity = move_dir * enemy.speed * delta * 60
