@tool

extends Projectile

var explosion_scene: PackedScene = load("uid://bxs8c64gm6v7")

func expire() -> void:
  super.expire()
  
  var exp_part: Hitbox = explosion_scene.instantiate()
  exp_part.global_position = global_position
  
  get_tree().get_root().add_child.call_deferred(exp_part)
