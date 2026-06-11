extends Spell

var particles: PackedScene = load("uid://cssirjrdiah6y")

func cast(player: Player, target_dir: Vector2) -> void:
  var proj: Projectile = particles.instantiate()
  proj.dir = target_dir
  proj.global_position = player.global_position
  proj.lifetime = 1.0
  
  player.get_tree().get_root().add_child.call_deferred(proj)
