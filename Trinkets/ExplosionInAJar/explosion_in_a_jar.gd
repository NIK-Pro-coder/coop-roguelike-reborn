extends Trinket

var explosion_scene: PackedScene = load("uid://bs3abt7bmsvbs")

func on_kill(player: Player, enemy: Enemy) -> void:
  var explode: VideoStreamPlayer = explosion_scene.instantiate()
  explode.global_position = enemy.global_position
  # trust, ts exists
  explode.attacker = player
  
  Qol.add_to_tree(explode)
