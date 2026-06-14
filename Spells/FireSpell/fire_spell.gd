extends Spell

var fireball: PackedScene = load("uid://cssirjrdiah6y")

func cast(player: Player, target_dir: Vector2) -> void:
  var proj: Projectile = fireball.instantiate()
  proj.dir = target_dir
  proj.global_position = player.global_position

  player.get_tree().get_root().add_child.call_deferred(proj)

var travel_speed: float = -1

func get_aim_assist_points(player: Player) -> Array[Vector2]:
  if travel_speed < 0.0:
    var proj: Projectile = fireball.instantiate()
    travel_speed = proj.speed
  
  var points: Array[Vector2] = []
  
  for i: Enemy in player.get_tree().get_nodes_in_group("enemies"):
    var diff: Vector2 = i.global_position - player.global_position
    var vel_diff: Vector2 = i.velocity * (diff.length() / travel_speed)
    
    points.append(i.global_position + vel_diff)
  
  return points
